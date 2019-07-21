SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spRepProyectosRecursos
@EstacionTrabajo int

AS BEGIN
DECLARE
@Proyecto   varchar(50),
@Empresa    varchar(5),
@ProyectoD  varchar(50),
@ProyectoA  varchar(50),
@Moneda     varchar(15),
@rowcount   int,
@lvl        int,
@delcount   int,
@Tipo       varchar(15)
SELECT @Empresa		=	InfoEmpresa,
@ProyectoD		=	InfoProyectoD,
@ProyectoA		=	InfoProyectoA,
@Moneda			=	InfoMoneda
FROM RepParam
WHERE Estacion = @EstacionTrabajo
DECLARE @Jerarquia TABLE
(
TreeId           int identity primary key,
Proyecto         varchar(50)   null,
lvl              int           null,
ParentTreeId     varchar(20)   null,
Path             varchar(max) null,
Proyecto_Id_Path varchar(max) null
)
SET NOCOUNT ON
SET @lvl=0
DECLARE CursorProyecto CURSOR FOR
SELECT Proyecto, Tipo
FROM Proy
WHERE Proyecto BETWEEN @ProyectoD AND @ProyectoA
OPEN CursorProyecto
FETCH NEXT FROM CursorProyecto INTO @Proyecto, @Tipo
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Tipo = Tipo FROM Proy WHERE Proyecto = @Proyecto
IF @Tipo = 'Proyecto'
BEGIN
INSERT INTO @Jerarquia(Proyecto, lvl) VALUES (@Proyecto, @lvl)
SET @rowcount=@@ROWCOUNT
UPDATE @Jerarquia set Path=str(TreeId,10,0) + '.', Proyecto_Id_Path=cast(Proyecto as varchar(50)) + '\'
WHILE @rowcount>0
BEGIN
SET @lvl=@lvl+1
INSERT INTO @Jerarquia(Proyecto, lvl, ParentTreeId)
SELECT e.Proyecto, @lvl, t.TreeId
FROM Proy e INNER JOIN @Jerarquia t
ON e.ProyectoRama=t.Proyecto AND t.lvl=@lvl-1
SELECT @rowcount=@@ROWCOUNT, @delcount=@@ROWCOUNT
SELECT @rowcount=@rowcount-@delcount
END
END
ELSE
IF @Tipo = 'SubProyecto'
BEGIN
INSERT INTO @Jerarquia(Proyecto, lvl) VALUES (@Proyecto, @lvl)
END
FETCH NEXT FROM CursorProyecto INTO @Proyecto, @Tipo
END
CLOSE CursorProyecto
DEALLOCATE CursorProyecto
SELECT
ProyectoD.ID,
ProyectoD.Actividad,
ProyectoD.Asunto,
ProyectoD.Tipo,
ProyectoD.Categoria,
ProyectoD.Grupo,
ProyectoD.Familia,
ProyectoD.Duracion,
ProyectoD.DuracionUnidad,
ProyectoD.DuracionDias,
ProyectoD.Comienzo,
ProyectoD.Fin,
ProyectoD.Estado,
ISNULL(ProyectoD.Avance,0)/100 Avance,
ProyectoD.Prioridad,
Proyecto.Empresa,
Proyecto.Mov,
Proyecto.MovID,
Proyecto.FechaEmision,
Proyecto.UltimoCambio,
Proyecto.Concepto,
Proyecto.Usuario,
Proyecto.Autorizacion,
Proyecto.Estatus,
Proyecto.Referencia,
Proyecto.Moneda,
Proyecto.TipoCambio,
ProyectoD.RecursosAsignados,
CASE ProyectoD.EsFase
WHEN 0 THEN ISNULL(ProyectoD.DuracionDias,0) * ISNULL(Proyecto.HorasDia, 8)
ELSE 0 END HorasPlaneadas,
CASE ProyectoD.EsFase
WHEN 0 THEN (SELECT SUM(ISNULL(pr.CostoHora,0) * ISNULL(pd.DuracionDias,0) * ISNULL(pr.HorasDia, 8))
FROM ProyectoRecurso pr JOIN ProyectoDRecurso pdr ON pr.ID = pdr.ID
AND pr.Recurso = pdr.Recurso JOIN ProyectoD pd ON pdr.ID = pd.ID
AND pdr.Actividad = pd.Actividad
WHERE pr.ID = Proyecto.ID
AND pdr.Actividad = ProyectoD.Actividad)
ELSE 0 END CostoHorasPlaneadas,
HorasReales = (SELECT SUM(ISNULL(ad.Cantidad,0))
FROM Asiste a JOIN AsisteD ad ON a.ID = ad.ID
JOIN MovTipo mt ON 'ASIS' = mt.Modulo AND a.Mov = mt.Mov
WHERE mt.Clave = 'ASIS.RA'
AND a.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND a.Empresa = Proyecto.Empresa
AND ISNULL(ad.Proyecto,'') = Proyecto.Proyecto
AND ISNULL(ad.Actividad,'') = ProyectoD. Actividad),
ImporteReal = (SELECT SUM(ISNULL(ad.Cantidad,0) * ISNULL(ad.Costo,0))
FROM Asiste a JOIN AsisteD ad ON a.ID = ad.ID
JOIN MovTipo mt ON 'ASIS' = mt.Modulo AND a.Mov = mt.Mov
WHERE mt.Clave = 'ASIS.RA'
AND a.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND a.Empresa = Proyecto.Empresa
AND ISNULL(ad.Proyecto,'') = Proyecto.Proyecto
AND ISNULL(ad.Actividad,'') = ProyectoD. Actividad),
(SELECT ProyectoRama FROM Proy WHERE Proy.Proyecto = Proyecto.Proyecto) ProyectoRama,
Proyecto.Proyecto,
ISNULL(Proyecto.Avance,0) / 100 AvanceProyecto,
ProyectoD.EsFase
FROM ProyectoD JOIN Proyecto ON ProyectoD.ID=Proyecto.ID
WHERE Proyecto.Empresa = @Empresa
AND Proyecto.Estatus IN ('PENDIENTE', 'CONCLUIDO')
AND EXISTS (SELECT 1 FROM @Jerarquia WHERE Proyecto = Proyecto.Proyecto)
AND EXISTS (SELECT Proyecto FROM @Jerarquia)
ORDER BY Proyecto.ProyectoRama, Proyecto.Proyecto
RETURN
END

