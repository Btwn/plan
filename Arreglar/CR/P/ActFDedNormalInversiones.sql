SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE ActFDedNormalInversiones
@Empresa varchar(5),
@Ejercicio as smallint,
@Periodo as smallint,
@TipoAC smallint = 0,
@EstatusAc varchar(1)='',
@ClaveAc varchar(100)='',
@ConSaldo varchar(2)='no',
@IntCostoVta smallint = 0

AS BEGIN
DECLARE	@Porcentajededuccion as float,
@MesesUso as smallint,
@fecha_ope as varchar(10),
@SQL as varchar(max),
@SQL1 as varchar(max),
@lcFiltro varchar(300),
@lcFiltroSaldo varchar(100);
SET @lcFiltro = ''
SET @lcFiltroSaldo = ''
IF ISNULL(@TipoAc,0)<>0
SET @lcFiltro = @lcFiltro + ' AND ActivosF.TipoActivo ='+CAST(@TipoAc AS varchar(2))
IF ISNULL(@EstatusAC,'')<>''
SET @lcFiltro = @lcFiltro + ' AND ActivosF.Estatus = '''+@EstatusAc+''''
IF ISNULL(@ClaveAc,'')<>''
SET @lcFiltro = @lcFiltro + ' AND ActivosF.Clave ='''+@ClaveAc+''''
IF LOWER(ISNULL(@ConSaldo,'no'))='si'
SET @lcFiltroSaldo = ' WHERE DeduccionFis<>0'
SET @fecha_ope=cast(@Ejercicio as varchar(4))+REPLACE(STR(@Periodo,2),SPACE(1),'0')+'01';
SET @SQL=N'';
SET @SQL1=N'';
SET @SQL='SELECT aTipos.Descripcion as Tipo,Vista2.*,CASE WHEN Vista2.FactorActualizacionA < 1 THEN 1 ELSE Vista2.FactorActualizacionA END FactorActualizacion,
CAST(Vista2.DeduccionFis + Vista2.DeduccionAcumFis AS Decimal(18,2)) as DeduccionAcumEjercicio,
(DeduccionFis * CASE WHEN FactorActualizacionA < 1 THEN 1 ELSE FactorActualizacionA END ) DedFiscalActualizadaEjer
FROM (
SELECT	Vista1.*,
CASE
WHEN DeduccionAcumFis >= MOI THEN 0
WHEN DeduccionAcumFis + dbo.fgetDeduccion(MOI,DepFiscal,mesesUso) > MOI THEN (MOI - DeduccionacumFis)
ELSE CAST(dbo.fgetDeduccion(MOI,DepFiscal,mesesUso)  AS Decimal(18,2)) END AS DeduccionFis,
CASE
WHEN DeduccionAcumCont >= MontoOrig THEN 0
WHEN DeduccionAcumCont + dbo.fgetDeduccion(MontoOrig,DepFinanciera,mesesUso) > MontoOrig THEN (MontoOrig - DeduccionAcumCont)
ELSE CAST(dbo.fgetDeduccion(MontoOrig,DepFinanciera,mesesUso)  AS Decimal(18,2)) END AS DeduccionCont,
/*CAST(ROUND(dbo.fgetINPC_Num('+CAST(@Ejercicio as varchar(4))+', CASE WHEN Estatus in(''V'',''P'',''S'') THEN case when MONTH(FechaBaja)>1 then MONTH(FechaBaja)-1 else MONTH(FechaBaja) end ELSE case when Estatus=''A'' and ' + CAST(@Periodo AS nvarchar(2)) + ' <> mesesUso then mesesUso else ' + CAST(@Periodo AS nvarchar(2)) + ' end END,mesesUso),4,0) AS DECIMAL(18,4)) INPC_Numerador,*/
CAST(ROUND(dbo.fgetINPC_Num('+CAST(@Ejercicio as varchar(4))+', ' + CAST(@Periodo AS nvarchar(2)) + ',mesesUso,FechaIniUso),4,0) AS DECIMAL(18,4)) INPC_Numerador,
CAST(ROUND(dbo.fgetINPC_Denom(FechaAdqui),4,0) AS DECIMAL(18,4)) INPC_Denominador,
/*CAST(ROUND(dbo.fgetINPC_Num('+CAST(@Ejercicio as varchar(4))+', CASE WHEN Estatus in(''V'',''P'',''S'') THEN case when MONTH(FechaBaja)>1 then MONTH(FechaBaja)-1 else MONTH(FechaBaja) end ELSE case when Estatus=''A'' and ' + CAST(@Periodo AS nvarchar(2)) + ' <> mesesUso then mesesUso else ' + CAST(@Periodo AS nvarchar(2)) + ' end END,mesesUso) / NULLIF(dbo.fgetINPC_Denom(FechaAdqui),0),4,0) AS DECIMAL(18,4)) FactorActualizacionA*/
CAST(ROUND(dbo.fgetINPC_Num('+CAST(@Ejercicio as varchar(4))+', ' + CAST(@Periodo AS nvarchar(2)) + ' ,mesesUso,FechaIniUso) / NULLIF(dbo.fgetINPC_Denom(FechaAdqui),0),4,0) AS DECIMAL(18,4)) FactorActualizacionA
FROM'
SET @SQL1= '(SELECT	Empresa,
sucursal,
TipoActivo,
Clave,
Descripcion as Concepto,
NumFactura,
Estatus,
FechaAdqui,
FechaIniUso,
FechaBaja,
CuentaContable,
MontoOrig,
CASE WHEN EsAuto=1 AND  MontoOrig >=MontoFisAuto THEN
MontoFisAuto
ELSE
MontoOrig
END AS MOI,
DepFiscal,
isnull(DepFiscalAct,0) DeduccionAcumFis,
DepFinanciera,
isnull(DepFinanAct,0) DeduccionAcumCont,
/*dbo.fnMFAMesesDeUso(FechaIniUso,FechaBaja,CAST('''+@fecha_ope+''' as DATETIME),Estatus) as mesesUso*/
dbo.fnMFAMesesDeUso(Clave,'''+@Empresa+''',CAST('''+@fecha_ope+''' as DATETIME)) as mesesUso
FROM dbo.ActivosF WHERE TipoActivo<>8 AND TipoActivo<>9 AND ISNULL(ActivosF.AplicoDedInmed,0)=0 AND ISNULL(IntCosto,0)= '+rtrim(ltrim(str(@IntCostoVta)))+' AND Empresa = '''+@Empresa+''''+@lcFiltro + ' AND ' + CAST(@Ejercicio AS VARCHAR(4))+' = CASE WHEN Estatus IN(''V'',''P'',''S'') THEN YEAR(FechaBaja) ELSE '+CAST(@Ejercicio AS VARCHAR(4))+' END
) AS Vista1
) AS Vista2
INNER JOIN dbo.ActivosFTipos aTipos
ON Vista2.TipoActivo = aTipos.Tipo '+@lcFiltroSaldo+' ORDER BY aTipos.Tipo,Clave '
EXEC (@SQL + @SQL1);
END

