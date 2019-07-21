SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGastoInventariable
@Estacion		int

AS BEGIN
DECLARE
@Empresa		varchar(5),
@Sucursal		int,
@Fecha			datetime,
@Concepto		varchar(20),
@Cantidad		float,
@Importe		money,
@Disponible		float,
@CostoPromedio		float
DECLARE @Tabla    table(
Empresa        varchar(5),
Sucursal       int,
Concepto       varchar(20),
Descripcion    varchar(50),
Disponible     float,
CostoPromedio  float,
InvSeguridad   float,
CantidadMinima float,
CantidadMaxima float
)
SELECT  @Empresa = InfoEmpresa,
@Sucursal = InfoSucursal,
@Fecha = InfoFechaA,
@Concepto = InfoConcepto
FROM  RepParam
WHERE Estacion = @Estacion
INSERT INTO @Tabla
SELECT g.Empresa , g.Sucursal, gd.Concepto, c.Descripcion, SUM(gd.Cantidad * mt.Factor) AS Disponible, (SUM(gd.Importe)/SUM(gd.Cantidad * mt.Factor)) AS CostoPromedio, c.InvSeguridad , c.CantidadMinima, c.CantidadMaxima
FROM GastoD gd JOIN Gasto G ON gd.ID = g.ID
JOIN Concepto c ON gd.Concepto = c.Concepto
JOIN dbo.MovTipo mt ON mt.Mov = g.Mov
WHERE g.Empresa = @Empresa
AND gd.Concepto = ISNULL(NULLIF(@Concepto,''),gd.Concepto)
AND gd.Fecha <= @Fecha
AND c.EsInventariable = 1
AND mt.Modulo = 'GAS'
AND g.Estatus = 'CONCLUIDO'
AND mt.Clave = 'GAS.CI'
GROUP BY g.Empresa, g.Sucursal, gd.Concepto, c.Descripcion, c.InvSeguridad , c.CantidadMinima, c.CantidadMaxima
SELECT * FROM @Tabla
END

