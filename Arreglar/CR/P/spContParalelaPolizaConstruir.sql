SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spContParalelaPolizaConstruir
@ID					int,
@Sucursal			int,
@Usuario			varchar(10),
@Empresa			varchar(5),
@Mov				varchar(20),
@MovID				varchar(20),
@IDEmpresaAux		int,
@IDAux				int,
@GenerarMov			varchar(20),
@FechaTrabajo		datetime,
@BaseDatosRemota	varchar(255),
@EmpresaRemota		varchar(255),
@CONTEsCancelacion	bit,
@CPPolizaID			int				OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS
BEGIN
DECLARE @OrigenTipoCambio		float,
@RecepcionTipoCambio	float,
@OrigenMov			varchar(20),
@OrigenMovID			varchar(20),
@FechaEmision			datetime,
@GeneraEjercicio		int,
@GeneraPeriodo		int
SELECT @OrigenTipoCambio		= ISNULL(NULLIF(OrigenTipoCambio, 0), TipoCambio),
@RecepcionTipoCambio	= ISNULL(NULLIF(RecepcionTipoCambio, 0), ISNULL(NULLIF(OrigenTipoCambio, 0), TipoCambio)),
@OrigenMov = Mov,
@OrigenMovID = MovID,
@FechaEmision = FechaEmision,
@GeneraEjercicio = YEAR(FechaEmision),
@GeneraPeriodo = MONTH(FechaEmision)
FROM ContParalelaPoliza
WHERE ID = @IDAux
AND IDEmpresa = @IDEmpresaAux
CREATE TABLE #PolizaD(
RID						int			IDENTITY,
Cuenta					varchar(20),
CuentaAsignada			varchar(20) NULL,
TransformarNegativo		bit			NULL,
Debe					float		NULL,
Haber					float		NULL
)
INSERT INTO #PolizaD(
Cuenta,  Debe,                                          Haber)
SELECT Cuenta, (Debe/@OrigenTipoCambio)*@RecepcionTipoCambio, (Haber/@OrigenTipoCambio)*@RecepcionTipoCambio
FROM ContParalelaPolizaD
WHERE IDEmpresa = @IDEmpresaAux
AND ID = @IDAux
AND ISNULL(CONTEsCancelacion, 0) = ISNULL(@CONTEsCancelacion, 0)
UPDATE #PolizaD
SET CuentaAsignada			= Cta.CuentaAsignada,
TransformarNegativo	= ISNULL(Cta.TransformarNegativo, 0)
FROM #PolizaD
JOIN ContParalelaCta Cta ON #PolizaD.Cuenta = Cta.Cuenta
WHERE Cta.ID = @IDEmpresaAux
UPDATE #PolizaD
SET Debe = Haber * -1,
Haber = Debe * -1
WHERE TransformarNegativo = 1
DELETE #PolizaD WHERE CuentaAsignada IS NULL
EXEC @CPPolizaID = spMovCopiar @Sucursal, 'CONTP', @ID, @Usuario, @FechaTrabajo, 1, 1, NULL, NULL, @GenerarMov, NULL, NULL, NULL, 1, 1
UPDATE ContParalela
SET Estatus = 'CONFIRMAR',
OrigenTipo = 'CONTP',
Origen = @Mov,
OrigenID = @MovID,
BaseDatosOrigen = @BaseDatosRemota,
EmpresaOrigen = @EmpresaRemota,
Referencia = RTRIM(ISNULL(@OrigenMov, ''))+' '+RTRIM(ISNULL(@OrigenMovID, '')),
IDEmpresa = @IDEmpresaAux,
IDAux = @IDAux,
GeneraEjercicio = @GeneraEjercicio,
GeneraPeriodo = @GeneraPeriodo,
GeneraFechaD = @FechaEmision,
GeneraFechaA = @FechaEmision
WHERE ID = @CPPolizaID
INSERT INTO ContParalelaD(
ID,         Renglon,  Cuenta,         Debe, Haber)
SELECT @CPPolizaID, RID*2048, CuentaAsignada, Debe, Haber
FROM #PolizaD
RETURN
END

