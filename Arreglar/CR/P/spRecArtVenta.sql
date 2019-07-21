SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRecArtVenta
@Empresa                   varchar(5),
@Articulo                  varchar(20),
@FechaDe                   datetime,
@FechaA                    datetime,
@PeriodoDesc               varchar(20)

AS BEGIN
SET NOCOUNT ON
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
DECLARE @MaxID               int
DECLARE @idx                 int
DECLARE @b                   bit
DECLARE @Venta               table (Clave varchar(20) NULL)
DECLARE @VentaDev            table (Clave varchar(20) NULL)
DECLARE @TablaVenta table (
VentaID                    int NULL,
ID                         int IDENTITY (1, 1) NOT NULL,
Fecha                      datetime NULL,
Cantidad                   float NULL,
Importe                    float NULL,
Periodo                    varchar(10) NULL,
Consecutivo                int NULL,
DiaSemana                  int NULL,
Semana                     int NULL,
Mes                        int NULL,
Bimestre                   int NULL,
Trimestre                  int NULL,
Cuatrimestre               int NULL,
Semestre                   int NULL,
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
Mes                        int NULL,
Bimestre                   int NULL,
Trimestre                  int NULL,
Cuatrimestre               int NULL,
Semestre                   int NULL
)
DECLARE @TablaResultado table (
Consecutivo                int IDENTITY (1, 1) NOT NULL,
Cantidad                   float NULL,
Importe                    float NULL,
Anio                       int NULL,
Semana                     int NULL
)
IF EXISTS (SELECT TOP 1 Empresa FROM Empresa WHERE Empresa = @Empresa)
BEGIN
IF @FechaDe > @FechaA
BEGIN
SET @FechaT  = @FechaDe
SET @FechaDe = @FechaA
SET @FechaA  = @FechaT
END
SET @FechaDe = DATEADD(second,-1,@FechaDe)
SET @FechaA  = DATEADD(second,-1,@FechaA)
SET @FechaA  = DATEADD(day,1,@FechaA)
INSERT INTO @Venta(Clave)       VALUES ('VTAS.F')   
INSERT INTO @Venta(Clave)       VALUES ('VTAS.FM')  
INSERT INTO @Venta(Clave)       VALUES ('VTAS.FR')  
INSERT INTO @VentaDev(Clave)    VALUES ('VTAS.D')   
SET @Estatus = 'CONCLUIDO'
SET @b = 0
SET @PeriodoDesc = UPPER(LTRIM(RTRIM(@PeriodoDesc)))
INSERT INTO @TablaVenta (VentaID,Fecha,Cantidad,Importe,DiaSemana,Semana,Mes,Anio,DiaAnio)
SELECT v.ID,v.FechaEmision,ISNULL(d.Cantidad,0),ISNULL(d.Cantidad,0) * ISNULL(d.Precio,0.001),
datepart(weekday,v.FechaEmision),
datepart(week,v.FechaEmision),
datepart(month,v.FechaEmision),
datepart(year,v.FechaEmision),
datepart(dayofyear,v.FechaEmision)
FROM Venta v
JOIN VentaD d ON(v.ID = d.ID)
JOIN MovTipo m ON(v.Mov = m.Mov)
WHERE v.Empresa      = @Empresa
AND d.Articulo     = @Articulo
AND v.Estatus      = @Estatus
AND m.Clave IN (SELECT Clave FROM @Venta)
AND v.FechaEmision BETWEEN @FechaDe AND @FechaA
ORDER BY v.FechaEmision
UPDATE @TablaVenta
SET
Bimestre     = CAST(((Mes + 1) / 2) AS INT),
Trimestre    = CAST(((Mes + 2) / 3) AS INT),
Cuatrimestre = CAST(((Mes + 3) / 4) AS INT),
Semestre     = CAST(((Mes + 5) / 6) AS INT)
SELECT @PrimerID = Min(ID) FROM @TablaVenta
SET @PrimerID = ISNULL(@PrimerID,0)
SELECT TOP 1 @PrimerAnio = Anio FROM @TablaVenta WHERE ID = @PrimerID
SELECT TOP 1 @PrimerFecha = Fecha FROM @TablaVenta WHERE ID = @PrimerID
SELECT TOP 1 @PrimerSemana = Semana FROM @TablaVenta WHERE ID = @PrimerID
SET @Periodos = (ABS(DATEDIFF(DAY,@PrimerFecha,@FechaA)) / 7) + 2
UPDATE @TablaVenta SET Consecutivo = (Semana - @PrimerSemana + 1) + ((Anio - @PrimerAnio) * 52)
INSERT INTO @TablaResumen (Consecutivo,Anio,Semana,Cantidad,Importe)
SELECT Consecutivo,Anio,Semana,SUM(Cantidad),SUM(Importe)
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
INNER JOIN
@TablaResumen b
ON a.Consecutivo = b.Consecutivo
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
ISNULL(d.Cantidad,0) * ISNULL(d.Precio,0.001),
datepart(week,v.FechaEmision),
datepart(month,v.FechaEmision),
datepart(year,v.FechaEmision)
FROM Venta v
JOIN VentaD d ON(v.ID = d.ID)
JOIN MovTipo m ON(v.Mov = m.Mov)
WHERE v.Empresa      = @Empresa
AND d.Articulo     = @Articulo
AND v.Estatus      = @Estatus
AND m.Clave IN (SELECT Clave FROM @VentaDev)
AND v.FechaEmision BETWEEN @FechaDe AND @FechaA
ORDER BY v.FechaEmision
DECLARE spRecArtVenta_01_cursor CURSOR FOR
SELECT Anio,Semana,SUM(Cantidad)
FROM @TablaDevolucion
GROUP BY Anio,Semana
OPEN spRecArtVenta_01_cursor
FETCH NEXT FROM spRecArtVenta_01_cursor INTO @Anio,@Semana,@Cantidad
WHILE @@FETCH_STATUS = 0
BEGIN
UPDATE @TablaResultado
SET Cantidad = ISNULL(Cantidad,0) - ISNULL(@Cantidad,0)
WHERE Anio = @Anio AND Semana = @Semana
FETCH NEXT FROM spRecArtVenta_01_cursor INTO @Anio,@Semana,@Cantidad
END
CLOSE spRecArtVenta_01_cursor
DEALLOCATE spRecArtVenta_01_cursor
SELECT Consecutivo,Anio,Semana,Cantidad FROM @TablaResultado ORDER BY Consecutivo
END
END

