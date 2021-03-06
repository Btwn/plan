SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPlanArtVenta
@Empresa                   varchar(5),
@Almacen                   varchar(10),
@Articulo                  varchar(20),
@FechaDe                   datetime

AS
BEGIN
SET NOCOUNT ON
DECLARE @FechaA              datetime
DECLARE @Estatus             varchar(15)
DECLARE @Periodos            int
DECLARE @PrimerID            int
DECLARE @PrimerFecha         datetime
DECLARE @FechaT              datetime
DECLARE @Anio                int
DECLARE @Semana              int
DECLARE @AnioTmp             int
DECLARE @SemanaTmp           int
DECLARE @PrimerAnio          int
DECLARE @PrimerSemana        int
DECLARE @Cantidad            float
DECLARE @Importe             float
DECLARE @MaxID               int
DECLARE @idx                 int
DECLARE @b                   bit
DECLARE @Venta               table (Clave varchar(20) NULL)
DECLARE @VentaDev            table (Clave varchar(20) NULL)
DECLARE @TablaVenta table (
ID                         int IDENTITY (1, 1) NOT NULL,
VentaID                    int NULL,
Fecha                      datetime NULL,
Cantidad                   float NULL,
Importe                    float NULL,
Periodo                    varchar(10) NULL,
Consecutivo                int NULL,
DiaSemana                  int NULL,
Semana                     int NULL,
Mes                        int NULL,
Anio                       int NULL,
DiaAnio                    int NULL
)
DECLARE @TablaDevolucion table (
ID                         int IDENTITY (1, 1) NOT NULL,
VentaID                    int NULL,
Fecha                      datetime NULL,
Cantidad                   float NULL,
Importe                    float NULL,
Semana                     int NULL,
Mes                        int NULL,
Anio                       int NULL
)
DECLARE @TablaResumen table (
ID                         int IDENTITY (1, 1) NOT NULL,
Consecutivo                int NULL,
Cantidad                   float NULL,
Importe                    float NULL,
Anio                       int NULL,
Semana                     int NULL,
Mes                        int NULL
)
DECLARE @TablaResultado table (
Consecutivo                int IDENTITY (1, 1) NOT NULL,
Cantidad                   float NULL,
Importe                    float NULL,
Anio                       int NULL,
Semana                     int NULL
)
SET @FechaA = dbo.fnFechaSinHora(GETDATE())
IF @FechaDe > @FechaA
BEGIN
SET @FechaT  = @FechaDe
SET @FechaDe = @FechaA
SET @FechaA  = @FechaT
END
SET @FechaDe = DATEADD(second,-1,@FechaDe)
SET @FechaA  = DATEADD(second,-1,@FechaA)
SET @FechaA  = DATEADD(day,1,@FechaA)
SET @Estatus = 'CONCLUIDO'
SET @b = 0
INSERT INTO @Venta(Clave)       VALUES ('VTAS.F')          
INSERT INTO @Venta(Clave)       VALUES ('VTAS.FM')         
INSERT INTO @Venta(Clave)       VALUES ('VTAS.FR')         
INSERT INTO @Venta(Clave)       VALUES ('VTAS.VCR')        
INSERT INTO @Venta(Clave)       VALUES ('VTAS.VC')         
INSERT INTO @VentaDev(Clave)    VALUES ('VTAS.D')          
INSERT INTO @VentaDev(Clave)    VALUES ('VTAS.DC')         
INSERT INTO @VentaDev(Clave)    VALUES ('VTAS.DCR')        
INSERT INTO @TablaVenta (VentaID,Fecha,Cantidad,Importe,DiaSemana,Semana,Mes,Anio,DiaAnio)
SELECT v.ID,v.FechaEmision,ISNULL(d.Cantidad,0),ISNULL(d.Cantidad,0) * ISNULL(d.Precio,0),
datepart(weekday,v.FechaEmision),
datepart(week,v.FechaEmision),
datepart(month,v.FechaEmision),
datepart(year,v.FechaEmision),
datepart(dayofyear,v.FechaEmision)
FROM Venta v
JOIN VentaD d ON(v.ID = d.ID)
JOIN MovTipo m ON(v.Mov = m.Mov)
JOIN @Venta mv ON(m.Clave = mv.Clave)
WHERE v.Empresa      = @Empresa
AND d.Almacen      = @Almacen
AND d.Articulo     = @Articulo
AND v.Estatus      = @Estatus
AND v.FechaEmision BETWEEN @FechaDe AND @FechaA
ORDER BY v.FechaEmision
DELETE @TablaVenta WHERE Importe = 0
SELECT @PrimerID = Min(ID) FROM @TablaVenta
SET @PrimerID = ISNULL(@PrimerID,0)
SELECT TOP 1 @PrimerAnio = Anio FROM @TablaVenta WHERE ID = @PrimerID
SELECT TOP 1 @PrimerFecha = Fecha FROM @TablaVenta WHERE ID = @PrimerID
SELECT TOP 1 @PrimerSemana = Semana FROM @TablaVenta WHERE ID = @PrimerID
SET @Periodos = (ABS(DATEDIFF(DAY,@PrimerFecha,@FechaA)) / 7) + 2
UPDATE @TablaVenta SET Consecutivo = (Semana - @PrimerSemana + 1) + ((Anio - @PrimerAnio) * 52)
INSERT INTO @TablaResumen (Consecutivo,Anio,Semana,Cantidad,Importe)
SELECT Consecutivo,Anio,Semana,SUM(Cantidad) ,SUM(Importe)
FROM @TablaVenta
GROUP BY Consecutivo,Semana,Anio
SET @idx = 1
WHILE @idx < @Periodos
BEGIN
INSERT INTO @TablaResultado (Cantidad,Importe) VALUES (0,0)
SET @idx = @idx + 1
END
UPDATE @TablaResultado
SET Anio = b.Anio, Semana = b.Semana , Cantidad = b.cAntidad, Importe = b.Importe
FROM @TablaResultado a
INNER JOIN @TablaResumen b ON a.Consecutivo = b.Consecutivo
SELECT @idx = (MAX(Consecutivo) + 1) FROM @TablaResultado
SET @b = 0
WHILE @b = 0
BEGIN
SET @idx = @idx - 1
IF EXISTS(SELECT TOP 1 Importe FROM @TablaResultado WHERE Importe = 0 AND Consecutivo = @idx)
BEGIN
DELETE @TablaResultado WHERE Consecutivo = @idx
END
ELSE
BEGIN
SET @b = 1
END
END
SELECT @Anio = Anio FROM @TablaResultado WHERE Consecutivo = 1
SELECT @Semana = Semana FROM @TablaResultado WHERE Consecutivo = 1
SELECT @MaxID = MAX(Consecutivo) FROM @TablaResultado
SET @idx = 2
WHILE @idx < @MaxID
BEGIN
SELECT @AnioTmp = Anio FROM @TablaResultado WHERE Consecutivo = @idx
SELECT @SemanaTmp = Semana FROM @TablaResultado WHERE Consecutivo = @idx
SET @AnioTmp = ISNULL(@AnioTmp,0)
SET @SemanaTmp = ISNULL(@SemanaTmp,0)
IF @SemanaTmp = 0
BEGIN
SET @Semana = @Semana + 1
IF @Semana > 52
BEGIN
SET @Semana = 1
SET @Anio = @Anio + 1
END
UPDATE @TablaResultado SET Anio = @Anio, Semana = @Semana WHERE Consecutivo = @idx
END
ELSE
BEGIN
SELECT @Anio = Anio FROM @TablaResultado WHERE Consecutivo = @idx
SELECT @Semana = Semana FROM @TablaResultado WHERE Consecutivo = @idx
END
SET @idx  = @idx + 1
END
INSERT INTO @TablaDevolucion (VentaID,Fecha,Cantidad,Importe,Semana,Mes,Anio)
SELECT v.ID,v.FechaEmision,
ISNULL(d.Cantidad,0),
ISNULL(d.Cantidad,0) * ISNULL(d.Precio,0),
datepart(week,v.FechaEmision),
datepart(month,v.FechaEmision),
datepart(year,v.FechaEmision)
FROM Venta v
JOIN VentaD d ON(v.ID = d.ID)
JOIN MovTipo m ON(v.Mov = m.Mov)
JOIN @VentaDev mv ON(m.Clave = mv.Clave)
WHERE v.Empresa      = @Empresa
AND d.Articulo     = @Articulo
AND v.Estatus      = @Estatus
AND v.FechaEmision BETWEEN @FechaDe AND @FechaA
ORDER BY v.FechaEmision
DECLARE spPlanArtVenta_cursor CURSOR FOR
SELECT Anio,Semana,SUM(Cantidad),SUM(Importe)
FROM @TablaDevolucion
GROUP BY Anio,Semana
OPEN spPlanArtVenta_cursor
FETCH NEXT FROM spPlanArtVenta_cursor INTO @Anio,@Semana,@Cantidad,@Importe
WHILE @@FETCH_STATUS = 0
BEGIN
UPDATE @TablaResultado
SET Cantidad = ISNULL(Cantidad,0) - ISNULL(@Cantidad,0),
Importe = ISNULL(Importe,0) - ISNULL(@Importe,0)
WHERE Anio = @Anio AND Semana = @Semana
FETCH NEXT FROM spPlanArtVenta_cursor INTO @Anio,@Semana,@Cantidad,@Importe
END
CLOSE spPlanArtVenta_cursor
DEALLOCATE spPlanArtVenta_cursor
SELECT Consecutivo,Anio,Semana,Cantidad,Importe FROM @TablaResultado ORDER BY Consecutivo
END

