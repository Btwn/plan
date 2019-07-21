SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spRepGeneralProyecto
@EstacionTrabajo int

AS BEGIN
DECLARE
@rowcount     int,
@lvl          int,
@delcount     int,
@Proyecto     varchar(50),
@ProyectoD    varchar(50),
@ProyectoA    varchar(50),
@Empresa      varchar(5),
@Moneda       varchar(15),
@ProyectoRama varchar(50),
@Ventas       money,
@Compras      money,
@Gastos       money,
@Tipo         varchar(15),
@ID           int,
@HorasPlaneadas   float,
@ImportePlaneadas money,
@HorasReales      float,
@ImporteReales    money
SELECT @Empresa		=	InfoEmpresa,
@ProyectoD		=	InfoProyectoD,
@ProyectoA		=	InfoProyectoA,
@Moneda			=	InfoMoneda
FROM RepParam
WHERE Estacion = @EstacionTrabajo
DECLARE @Informacion TABLE
(
ProyectoRama       varchar(50),
Proyecto           varchar(50),
Descripcion        varchar(100) null,
Tipo               varchar(15),
Ventas             money null,
Compras            money null,
Gastos             money null,
HorasPlaneadas     float null,
ImportePlaneadas   money null,
HorasReales        float null,
ImporteReales      money null
)
DECLARE @Jerarquia TABLE
(
TreeId           int identity primary key,
Proyecto         varchar(50)   null,
lvl              int           null,
ParentTreeId     varchar(20)   null,
Path             varchar(max) null,
Proyecto_Id_Path varchar(max) null
)
SET @lvl=0
DECLARE CursorProyecto CURSOR FOR
SELECT Proyecto, Tipo
FROM Proy
WHERE Proyecto BETWEEN @ProyectoD AND @ProyectoA
OPEN CursorProyecto
FETCH NEXT FROM CursorProyecto INTO @Proyecto, @Tipo
WHILE @@FETCH_STATUS = 0
BEGIN
IF @Tipo = 'Proyecto'
BEGIN
INSERT INTO @Jerarquia(Proyecto, lvl)
VALUES          (@Proyecto, @lvl)
SET @rowcount=@@ROWCOUNT
UPDATE @Jerarquia set Path=str(TreeId,10,0) + '.', Proyecto_Id_Path=cast(Proyecto as varchar(50)) + '\'
WHILE @rowcount>0
BEGIN
SET @lvl=@lvl+1
INSERT INTO @Jerarquia(Proyecto, lvl, ParentTreeId)
SELECT e.Proyecto, @lvl, t.TreeId
FROM Proy e INNER JOIN @Jerarquia t ON e.ProyectoRama=t.Proyecto AND t.lvl=@lvl-1
SELECT @rowcount=@@ROWCOUNT, @delcount=@@ROWCOUNT
SELECT @rowcount=@rowcount-@delcount
END
END
ELSE
IF @Tipo = 'SubProyecto'
BEGIN
DELETE FROM @Jerarquia
INSERT INTO @Jerarquia(Proyecto, lvl) VALUES (@Proyecto, @lvl)
INSERT INTO @Informacion(ProyectoRama, Proyecto, Descripcion, Tipo)
SELECT p.ProyectoRama, p.Proyecto, p.Descripcion, p.Tipo
FROM Proy p JOIN @Jerarquia j
ON p.Proyecto = j.Proyecto
UPDATE @Informacion
SET ProyectoRama = Proyecto
WHERE ISNULL(ProyectoRama,'') = ''
AND Tipo = 'Proyecto'
SELECT @Proyecto = MIN(Proyecto) FROM @Informacion
WHILE @Proyecto IS NOT NULL
BEGIN
SELECT @Ventas = SUM(v.Importe /* + v.Impuestos */)
FROM Venta v JOIN MovTipo mt
ON 'VTAS' = mt.Modulo AND v.Mov = mt.Mov
WHERE mt.Clave IN ('VTAS.F')
AND v.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND v.Empresa = @Empresa
AND ISNULL(v.Proyecto,'') = @Proyecto
AND v.Moneda = @Moneda
SELECT @Compras = SUM(c.Importe /* + c.Impuestos */)
FROM Compra c JOIN MovTipo mt
ON 'COMS' = mt.Modulo AND c.Mov = mt.Mov
WHERE mt.Clave IN ('COMS.F')
AND c.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND c.Empresa = @Empresa
AND ISNULL(c.Proyecto,'') = @Proyecto
AND c.Moneda = @Moneda
SELECT @Gastos = SUM(g.Importe /* + g.Impuestos*/)
FROM Gasto g JOIN MovTipo mt
ON 'GAS' = mt.Modulo AND g.Mov = mt.Mov
WHERE mt.Clave IN ('GAS.G', 'GAS.P', 'GAS.GTC')
AND g.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND g.Empresa = @Empresa
AND ISNULL(g.Proyecto,'') = @Proyecto
AND g.Moneda = @Moneda
SELECT @HorasPlaneadas = SUM(ISNULL(DuracionDias,0) * ISNULL(p.HorasDia, 8))
FROM Proyecto p JOIN ProyectoD pd
ON p.ID = pd.ID
WHERE p.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND p.Empresa = @Empresa
AND ISNULL(p.Proyecto,'') = @Proyecto
AND pd.EsFase = 0
SELECT @ID = ID FROM Proyecto WHERE Empresa = @Empresa AND Estatus NOT IN ('SINAFECTAR', 'CANCELADO') AND Proyecto = @Proyecto
SELECT @ImportePlaneadas = SUM(ISNULL(pr.CostoHora,0) * ISNULL(pd.DuracionDias,0) * ISNULL(pr.HorasDia, 8))
FROM ProyectoRecurso pr JOIN ProyectoDRecurso pdr ON pr.ID = pdr.ID
AND pr.Recurso = pdr.Recurso JOIN ProyectoD pd ON pdr.ID = pd.ID
AND pdr.Actividad = pd.Actividad
WHERE pr.ID = @ID
SELECT @HorasReales = SUM(ISNULL(ad.Cantidad,0)) FROM Asiste a JOIN AsisteD ad
ON a.ID = ad.ID JOIN MovTipo mt
ON 'ASIS' = mt.Modulo AND a.Mov = mt.Mov
WHERE mt.Clave = 'ASIS.RA'
AND a.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND a.Empresa = @Empresa
AND ISNULL(ad.Proyecto,'') = @Proyecto
AND ISNULL(ad.Actividad,'') <> ''
SELECT @ImporteReales = SUM(ISNULL(ad.Cantidad,0) * ISNULL(ad.Costo,0))
FROM Asiste a JOIN AsisteD ad
ON a.ID = ad.ID JOIN MovTipo mt
ON 'ASIS' = mt.Modulo AND a.Mov = mt.Mov
WHERE mt.Clave = 'ASIS.RA'
AND a.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND a.Empresa = @Empresa
AND ISNULL(ad.Proyecto,'') = @Proyecto
AND ISNULL(ad.Actividad,'') <> ''
UPDATE @Informacion
SET Ventas = @Ventas, Compras = @Compras, Gastos = @Gastos, HorasPlaneadas = @HorasPlaneadas,
HorasReales = @HorasReales, ImportePlaneadas = @ImportePlaneadas, ImporteReales = @ImporteReales
WHERE Proyecto = @Proyecto
SELECT @Proyecto = MIN(Proyecto) FROM @Informacion WHERE Proyecto > @Proyecto
END
END
FETCH NEXT FROM CursorProyecto INTO @Proyecto, @Tipo
END
CLOSE CursorProyecto
DEALLOCATE CursorProyecto
IF @Tipo = 'Proyecto'
SELECT * FROM @Informacion WHERE Tipo = 'SubProyecto'
ELSE
SELECT * FROM @Informacion
END
RETURN

