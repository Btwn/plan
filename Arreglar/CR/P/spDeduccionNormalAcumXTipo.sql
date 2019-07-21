SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDeduccionNormalAcumXTipo
@Empresa varchar(5),
@Ejercicio as smallint,
@Periodo as smallint,
@TipoAC smallint = 0,
@EstatusAc varchar(1)='',
@ClaveAc varchar(100)='',
@ConSaldo varchar(2)='no'

AS BEGIN
CREATE TABLE #ActivosFDedNormal(
Tipo		varchar(100),
Empresa		varchar(5),
sucursal	varchar(10),
TipoActivo	smallint,
Clave		varchar(100),
Concepto	varchar(200),
NumFactura	varchar(50),
Estatus		varchar(2),
FechaAdqui	datetime,
FechaIniUso	datetime,
FechaBaja	datetime,
CuentaContable varchar(100),
MontoOrig	float,
MOI			float,
DepFiscal	float,
DeduccionAcumFis	float,
DepFinanciera	float,
DeduccionAcumCont	float,
MesesUso	smallint,
DeduccionFis	float,
DeduccionCont	float,
Inpc_Numerador	float,
Inpc_Denominador	float,
FactorActualizacionA	float,
FactorActualizacion	float,
DeduccionAcumEjercicio	float,
DedFiscalActualizadaEjer float
)
INSERT INTO #ActivosFDedNormal
exec ActFDedNormalInversiones @Empresa,@Ejercicio,@Periodo,@TipoAc,@EstatusAc,@ClaveAc,@ConSaldo
SELECT TipoActivo,Tipo,ROUND(SUM(ISNULL(DedFiscalActualizadaEjer,0)),2) DFiscalAct,0.00 DeduccionInmed,
ROUND(SUM(CASE WHEN YEAR(FechaAdqui)=@Ejercicio THEN ISNULL(MontoOrig,0) ELSE 0 END ),2) MontoOrig
FROM #ActivosFDedNormal
GROUP BY TipoActivo,Tipo
ORDER BY TipoActivo
END

