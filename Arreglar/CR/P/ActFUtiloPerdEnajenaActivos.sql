SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE ActFUtiloPerdEnajenaActivos
@Empresa varchar(5),
@Ejer smallint,
@Periodo smallint,
@EjAntMV as smallint, 
@EstatusAct varchar(1), 
@TipoAct smallint = NULL,
@ClaveAC VARCHAR(100)=''

AS BEGIN
DECLARE @SQL AS Nvarchar(max),
@SQL1 AS Nvarchar(max),
@fecha_ope as varchar(10),@TipoActiv as varchar(100),@FiltroClave as VARCHAR(100);
SET @SQL=N'';
SET @SQL1=N'';
SET @TipoActiv = N''
IF ISNULL(@TipoAct,'')<>''
SET @TipoActiv = ' AND ActivosF.TipoActivo = '+CAST(@TipoAct AS VARCHAR(2))
SET @FiltroClave = ''
IF ISNULL(@ClaveAC,'')<>''
SET @FiltroClave = ' AND ActivosF.Clave = '''+ltrim(rtrim(isnull(@ClaveAC,'')))+''''
SET @fecha_ope=cast(@Ejer as nvarchar(4))+REPLACE(STR(@Periodo,2),SPACE(1),'0')+'01';
SET @SQL='SELECT 	Vista3.*,
(Vista3.SaldoPenDedFis * Vista3.FactorActualizacion) AS SaldoPendDedFisActualizado,
CASE WHEN (Vista3.PrecioVenta > (Vista3.SaldoPenDedFis * Vista3.FactorActualizacion))
THEN Vista3.PrecioVenta - (Vista3.SaldoPenDedFis * Vista3.FactorActualizacion)
ELSE 0 END AS GananciaFiscalEnajena,
CASE WHEN (Vista3.PrecioVenta < (Vista3.SaldoPenDedFis * Vista3.FactorActualizacion))
THEN (Vista3.PrecioVenta - (Vista3.SaldoPenDedFis * Vista3.FactorActualizacion))*-1
ELSE 0 END AS PerdidaFiscalEnajena,
CASE WHEN (Vista3.PrecioVenta > Vista3.SaldoPenDepConta)
THEN (Vista3.PrecioVenta - Vista3.SaldoPenDepConta)
ELSE 0 END AS GananciaContableEnajena,
CASE WHEN (Vista3.PrecioVenta < Vista3.SaldoPenDepConta)
THEN (Vista3.PrecioVenta - Vista3.SaldoPenDepConta) * -1
ELSE 0 END AS PerdidaContableEnajena
FROM
(SELECT Vista2.*,
Vista2.MOI - Vista2.DedFisHistoricaInv as SaldoPenDedFis,
Vista2.MontoOrig -  Vista2.DedContHistoricaInv as SaldoPenDepConta,
CASE WHEN CAST(ROUND(INPC_numerador/NULLIF(INPC_denominador,0),4,1) AS DECIMAL(18,4)) < 1 THEN 1
ELSE CAST(ROUND(INPC_numerador/NULLIF(INPC_denominador,0),4,1) AS DECIMAL(18,4)) END as FactorActualizacion
FROM'
SET @SQL1 ='        	(SELECT Vista1.*,
CASE
WHEN ' + cast(@EjAntMV as varchar(2)) + '= 1 THEN Vista1.DepFiscalAct
WHEN ' + cast(@EjAntMV as varchar(2)) + '= 2 THEN
CASE WHEN (Vista1.DepFiscalAct + dbo.fgetdeduccion(Vista1.MOI,Vista1.DepFiscal,Vista1.MesesUso)) > Vista1.MOI THEN Vista1.MOI ELSE (Vista1.DepFiscalAct + CAST(dbo.fgetdeduccion(Vista1.MOI,Vista1.DepFiscal,Vista1.MesesUso) AS DECIMAL(18,2))) END
END AS DedFisHistoricaInv,
CASE
WHEN ' + cast(@EjAntMV as varchar(2)) + '= 1 THEN Vista1.DepFinanAct
WHEN ' + cast(@EjAntMV as varchar(2)) + '= 2 THEN
CASE WHEN (Vista1.DepFinanAct + dbo.fgetdeduccion(Vista1.MontoOrig,Vista1.DepFinanciera,Vista1.MesesUso)) > Vista1.MontoOrig THEN  Vista1.MontoOrig ELSE (Vista1.DepFinanAct + CAST(dbo.fgetdeduccion(Vista1.MontoOrig,Vista1.DepFinanciera,Vista1.MesesUso) AS DECIMAL(18,2))) END
END AS DedContHistoricaInv,
/*CAST(ROUND(dbo.fgetINPC_Num('+CAST(@Ejer as varchar(4))+',case when MONTH(FechaEnajenacion)>1 then MONTH(FechaEnajenacion)-1 else MONTH(FechaEnajenacion) end ,mesesUso),4,1) AS DECIMAL(18,4)) INPC_Numerador,*/
CAST(ROUND(dbo.fgetINPC_Num('+CAST(@Ejer as varchar(4))+','+CAST(@Periodo as varchar(2))+',mesesUso,FechaInicioUso),4,1) AS DECIMAL(18,4)) INPC_Numerador,
CAST(ROUND(dbo.fgetINPC_Denom(FechaAdquicision),4,1) AS DECIMAL(18,4)) INPC_Denominador
FROM (SELECT	aTipos.Descripcion as Tipo,
Empresa,Sucursal,TipoActivo,Estatus,Clave,DepFiscal,DepFinanciera,EsRecuperacion,EsAuto,
ActivosF.Descripcion as Concepto,
FechaAdqui as FechaAdquicision,
FechaIniUso as FechaInicioUso,
FechaBaja as FechaEnajenacion,
CASE WHEN EsAuto=1 AND MontoOrig >= MontoFisAuto THEN MontoFisAuto ELSE MontoOrig END AS MOI,
isnull(PrecioVenta,0) PrecioVenta,MontoFisAuto,
/*dbo.fnMFAMesesDeUso(FechaIniUso,FechaBaja,CAST('''+@fecha_ope+''' as DATETIME),Estatus) as mesesUso,*/
dbo.fnMFAMesesDeUso(Clave,'''+@Empresa+''',CAST('''+@fecha_ope+''' as DATETIME)) as mesesUso,
ISNULL(DepFiscalAct,0) DepFiscalAct,ISNULL(DepFinanAct,0)DepFinanAct,MontoOrig
FROM dbo.ActivosF INNER JOIN dbo.ActivosFTipos aTipos ON ActivosF.TipoActivo= aTipos.Tipo
WHERE TipoActivo<>8 AND TipoActivo<>9 AND ISNULL(ActivosF.AplicoDedInmed,0)=0 AND ActivosF.Empresa = '''+@Empresa+''' AND ActivosF.Estatus in('''+ @EstatusAct +''') ' + @TipoActiv +' AND YEAR(FechaBaja)='+CAST(@Ejer AS VARCHAR(4))+' AND MONTH(FechaBaja)<='+CAST(@Periodo AS VARCHAR(2))+ @FiltroClave +'
)AS Vista1
)AS Vista2
)AS Vista3 ORDER BY TipoActivo,Clave'
EXEC (@SQL+@SQL1)
END

