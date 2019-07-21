SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spDIOT
@Estacion		int,
@Empresa		varchar(5),
@FechaD			datetime,
@FechaA			datetime

AS
BEGIN
SET NOCOUNT ON
DECLARE @CxpAnticiposPagadosPeriodo	bit,
@GASIncluirComprobantes		bit,
@GASIncluirMovSinCxp			bit,
@CalcularBaseImportacion		bit,
@COMSIVAImportacionAnticipado	bit
SELECT @CxpAnticiposPagadosPeriodo = ISNULL(CxpAnticiposPagadosPeriodo, 0),
@GASIncluirComprobantes = ISNULL(GASIncluirComprobantes, 0),
@GASIncluirMovSinCxp    = ISNULL(GASIncluirMovSinCxp, 0),
@CalcularBaseImportacion = ISNULL(CalcularBaseImportacion, 0),
@COMSIVAImportacionAnticipado = ISNULL(COMSIVAImportacionAnticipado, 0)
FROM DIOTCfg
WHERE Empresa = @Empresa
DELETE DIOT       WHERE EstacionTrabajo = @Estacion
DELETE DIOTD      WHERE EstacionTrabajo = @Estacion
DELETE DIOTLayout WHERE EstacionTrabajo = @Estacion
CREATE TABLE #Movtos (Empresa		varchar(5)	NULL,
ModuloRaiz	varchar(5)	NULL,
IDRaiz		int			NULL,
MovRaiz		varchar(20)	NULL,
MovIDRaiz		varchar(20)	NULL,
OModulo		varchar(5)	NULL,
OID			int			NULL,
OMov			varchar(20)	NULL,
OMovID		varchar(20)	NULL,
DModulo		varchar(5)	NULL,
DID			int			NULL,
DMov			varchar(20)	NULL,
DMovID		varchar(20)	NULL
)
CREATE TABLE #Tesoreria(Empresa		varchar(5)	NULL,
ID			int			NULL,
Mov			varchar(20) NULL,
MovID			varchar(20) NULL,
RID			int			NULL,
FormaPago		varchar(50) NULL,
Importe		float		NULL,
FechaEmision	datetime	NULL,
OrigenTipo	varchar(20) NULL,
OrigenIID		int			NULL,
Origen		varchar(20) NULL,
OrigenMID		varchar(20) NULL,
ContID		int			NULL,
ContMov		varchar(20) NULL,
ContMovID		varchar(20) NULL
)
CREATE TABLE #Pagos(
RID					int			IDENTITY,
ID					int			NULL,
Empresa				varchar(5)	COLLATE Database_Default	NULL,
Mov					varchar(20)	COLLATE Database_Default	NULL,
MovID				varchar(20)	COLLATE Database_Default	NULL,
Ejercicio			int			NULL,
Periodo				int			NULL,
FechaEmision		datetime	NULL,
Aplica				varchar(20)	COLLATE Database_Default	NULL,
AplicaID			varchar(20)	COLLATE Database_Default	NULL,
Importe				float		NULL,
TipoCambio			float		NULL,
Dinero				varchar(20)	COLLATE Database_Default	NULL,
DineroID			varchar(20)	COLLATE Database_Default	NULL,
FechaConciliacion	datetime	NULL,
EsAnticipo			bit			NULL DEFAULT 0,
EsComprobante		bit			NULL DEFAULT 0,
DineroMov			varchar(20) NULL,
DineroMovID			varchar(20) NULL,
TipoInsert          int         NULL,
DineroMov2			varchar(20) NULL,
DineroMovID2		varchar(20) NULL,
DineroFormaPago		varchar(50) NULL,
DineroImporte		float		NULL,
ContID				int			NULL,
ContMov				varchar(20) NULL,
ContMovID			varchar(20) NULL
)
CREATE TABLE #Documentos(
RID					int			IDENTITY,
ID					int			NULL,
Empresa				varchar(5)	COLLATE Database_Default	NULL,
Pago				varchar(20)	COLLATE Database_Default	NULL,
PagoID				varchar(20)	COLLATE Database_Default	NULL,
ModuloID            int			NULL,
Mov					varchar(20)	COLLATE Database_Default	NULL,
MovID				varchar(20)	COLLATE Database_Default	NULL,
Ejercicio			int			NULL,
Periodo				int			NULL,
FechaEmision		datetime	NULL,
Proveedor			varchar(10)	COLLATE Database_Default	NULL,
Nombre				varchar(100)COLLATE Database_Default	NULL,
RFC					varchar(15) COLLATE Database_Default	NULL,
ImportadorRegistro	varchar(30) COLLATE Database_Default	NULL,
Pais				varchar(50) COLLATE Database_Default	NULL,
Nacionalidad		varchar(50) COLLATE Database_Default	NULL,
TipoDocumento		varchar(20) COLLATE Database_Default	NULL,
TipoTercero			varchar(20) COLLATE Database_Default	NULL,
TipoOperacion		int			NULL,
Importe				float		NULL,
IVA					float		NULL,
IEPS				float		NULL,
ISAN				float		NULL,
Retencion1			float		NULL,
Retencion2			float		NULL,
BaseIVA				float		NULL,
Tasa				float		NULL,
ConceptoClave		varchar(50) COLLATE Database_Default	NULL,
Concepto			varchar(100)COLLATE Database_Default	NULL,
EsImportacion		bit			NULL,
EsExcento			bit			NULL,
BaseIVAImportacion	float		NULL,
DineroMov			varchar(20) NULL,
DineroMovID			varchar(20) NULL,
PorcentajeDeducible	float		NOT NULL DEFAULT 100,
TipoInsert			int			NULL,
ImporteFactor       float       NULL,
DineroMov2			varchar(20) NULL,
DineroMovID2		varchar(20) NULL,
DineroFormaPago		varchar(50) NULL,
DineroImporte		float		NULL,
ContID				int			NULL,
ContMov				varchar(20) NULL,
ContMovID			varchar(20) NULL
)
CREATE INDEX Importe ON #Documentos(Mov, MovID, Pago, PagoID, Empresa) INCLUDE(Importe, IVA, IEPS, ISAN, Retencion1, Retencion2)
BEGIN
WITH Cte
AS (
SELECT 0 [Orden], D.Empresa, M.DModulo [ModuloRaiz], M.DID [IDRaiz], M.DMov [MovRaiz], M.DMovID [MovIDRaiz],
M.OModulo, M.OID, M.OMov, M.OMovID, M2.DModulo, M2.DID, M2.DMov, M2.DMovID
FROM MovFlujo M
LEFT JOIN MovFlujo M2
ON M.DModulo = M2.OModulo
AND M.DID = M2.OID
AND M2.DModulo = 'CONT'
JOIN Dinero D
ON M.DID = D.ID
AND M.DModulo = 'DIN'
AND D.Empresa = @Empresa
AND (D.FechaEmision >= @FechaD OR D.FechaConciliacion >= @FechaD)
AND (D.FechaEmision <= @FechaA OR D.FechaConciliacion <= @FechaA)
AND D.Estatus IN ('CONCLUIDO','CONCILIADO')
UNION ALL
SELECT C.Orden+1, C.Empresa, C.ModuloRaiz, C.IDRaiz, C.MovRaiz, C.MovIDRaiz,
M.OModulo, M.OID, M.OMov, M.OMovID, C.DModulo, C.DID, C.DMov, C.DMovID
FROM MovFlujo M
JOIN Cte C ON M.DModulo = C.OModulo AND M.DID = C.OID
)
INSERT INTO #Movtos(Empresa, ModuloRaiz, IDRaiz, MovRaiz, MovIDRaiz,
OModulo, OID, OMov, OMovID, DModulo, DID, DMov, DMovID)
SELECT Empresa, ModuloRaiz, IDRaiz, MovRaiz, MovIDRaiz,
OModulo, OID, OMov, OMovID, DModulo, DID, DMov, DMovID
FROM Cte ORDER BY 4,1
END
EXEC spDIOTObtenerPago @Estacion, @Empresa, @FechaD, @FechaA
IF @CxpAnticiposPagadosPeriodo = 1
EXEC spDIOTObtenerAnticipo @Estacion, @Empresa, @FechaD, @FechaA
IF @GASIncluirComprobantes = 1
EXEC spDIOTObtenerComprobante @Estacion, @Empresa, @FechaD, @FechaA
IF @GASIncluirMovSinCxp = 1
EXEC spDIOTObtenerGasto @Estacion, @Empresa, @FechaD, @FechaA
EXEC spDIOTObtenerDocumento @Estacion, @Empresa, @FechaD, @FechaA, @CalcularBaseImportacion, @COMSIVAImportacionAnticipado, @GASIncluirMovSinCxp
EXEC spDIOTClasificar @Estacion, @Empresa, @FechaD, @FechaA
EXEC spDIOTProcesar @Estacion, @Empresa, @FechaD, @FechaA
EXEC spDIOTLayout @Estacion, @Empresa, @FechaD, @FechaA
SELECT 'Proceso Concluido'
END

