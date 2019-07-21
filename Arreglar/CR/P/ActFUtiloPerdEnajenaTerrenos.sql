SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE ActFUtiloPerdEnajenaTerrenos
@Empresa varchar(5),
@Ejercicio as bigint,
@Periodo as int

AS BEGIN
DECLARE		@fecha_ope as varchar(10),
@SQL as nvarchar(max);
SET @fecha_ope=cast(@Ejercicio as nvarchar(4))+REPLACE(STR(@Periodo,2),SPACE(1),'0')+'01';
SET @SQL=N'';
SET @SQL='SELECT Vista2.*,
Vista2.MOI_actualizado as MOI_actualizado2,
CASE WHEN Precio_de_venta > MOI_actualizado THEN
CAST(Precio_de_venta - MOI_actualizado AS decimal(18,2)) ELSE 0 END AS GananciaEnajena,
CASE WHEN Precio_de_venta < MOI_actualizado THEN
CAST(Precio_de_venta - MOI_actualizado AS decimal(18,2)) *-1 ELSE 0 END AS PerdidaEnajena
FROM (
SELECT	Vista1.*,
CASE WHEN ROUND(INPC_numerador/NULLIF(INPC_denominador,0),4,1) < 1 THEN 1
ELSE ROUND(INPC_numerador/NULLIF(INPC_denominador,0),4,1) END as Factor_de_actualización,
MOI * CAST(INPC_numerador/NULLIF(INPC_denominador,0) as Decimal(18,4)) as MOI_actualizado,
Vista1.PrecioVenta as Precio_de_venta
FROM
(
SELECT	aTipos.Descripcion as Tipo,
Empresa,
sucursal,
TipoActivo,
Estatus,
Clave,
ActivosF.Descripcion as Concepto,
FechaAdqui as Fecha_de_adquisición,
Fechabaja as Fecha_de_enajenación,
CASE WHEN EsAuto=1 and MontoOrig >=MontoFisAuto THEN
MontoFisAuto
ELSE
MontoOrig
END AS MOI,
CAST(dbo.fgetINPC_Num_UP (Fechabaja)  AS Decimal(18,4)) as INPC_numerador,
CAST(dbo.fgetINPC_Denom(FechaAdqui)  AS Decimal(18,4)) as INPC_denominador,
PrecioVenta
FROM dbo.ActivosF INNER JOIN dbo.ActivosFTipos aTipos ON ActivosF.TipoActivo = aTipos.Tipo
WHERE Estatus = ''V'' AND aTipos.Tipo = 8 AND TipoActivo<>9 and Empresa = '''+@Empresa+''' and YEAR(FechaBaja)='+CAST(@Ejercicio AS VARCHAR(4))+'  
) AS Vista1
) AS Vista2 ORDER BY Estatus'
EXEC Sp_ExecuteSql @SQL;
END

