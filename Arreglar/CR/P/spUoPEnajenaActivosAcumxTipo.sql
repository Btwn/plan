SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spUoPEnajenaActivosAcumxTipo
@Empresa varchar(5),
@Ejer smallint,
@Periodo smallint,
@EjAntMV as smallint, 
@EstatusAct varchar(1), 
@TipoAct smallint = NULL,
@ClaveAC VARCHAR(100)=''

AS BEGIN
CREATE TABLE #ActivosFEnajena(
Tipo		varchar(100),
Empresa		varchar(5),
sucursal	varchar(10),
TipoActivo	smallint,
Estatus		varchar(2),
Clave		varchar(100),
DepFiscal	float,
DepFinanciera float,
esRecuperacion bit,
EsAuto		bit,
Concepto	varchar(200),
FechaAdquicision	datetime,
FechaInicioUso	datetime,
FechaEnajenacion	datetime,
Moi	float,
PrecioVenta		float,
MontoFisAuto	float,
MesesUso	smallint,
DepFiscalAct	float,
DepFinanAct	float,
MontoOrig	float,
DedFisHistoricaInv	float,
DedContHistoricaInv	float,
Inpc_Numerador	float,
Inpc_Denominador	float,
SaldoPenDedFis	float,
SaldoPenDepConta	float,
FactorActualizacion	float,
SaldoPendDedFisActualizado	float,
GananciaFiscalEnajena float,
PerdidaFiscalEnajena float,
GananciaContableEnajena float,
PerdidaContableEnajena float
)
INSERT INTO #ActivosFEnajena
exec ActFUtiloPerdEnajenaActivos @Empresa,@Ejer,@Periodo,@EjAntMV,@EstatusAct,@TipoAct,@ClaveAC
SELECT TipoActivo,Tipo,ROUND(SUM(ISNULL(MontoOrig,0)),2) MontoOrig,ROUND(SUM(ISNULL(SaldoPendDedFisActualizado,0)),2) SaldoPFActualizado,
ROUND(SUM(ISNULL(GananciaFiscalEnajena,0)),2) GananciaFiscal,ROUND(SUM(ISNULL(PerdidaFiscalEnajena,0)),2) PerdidaFiscal,
ROUND(SUM(ISNULL(GananciaContableEnajena,0)),2) GananciaContable,ROUND(SUM(ISNULL(PerdidaContableEnajena,0)),2) PerdidaContable
FROM #ActivosFEnajena
GROUP BY TipoActivo,Tipo
ORDER BY TipoActivo
END

