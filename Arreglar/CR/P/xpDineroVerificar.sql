SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpDineroVerificar
@ID               		int,
@Accion			char(20),
@Empresa          		char(5),
@Usuario			char(10),
@Modulo	      		char(5),
@Mov              		char(20),
@MovID			varchar(20),
@MovTipo	      		char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@Estatus			char(15),
@EstatusNuevo	      	char(15),
@BeneficiarioNombre		varchar(100),
@CtaDinero			char(10),
@CtaDineroTipo		char(20),
@CtaDineroDestino		char(10),
@CtaDineroFactor		float,
@CtaDineroTipoCambio	float,
@CtaDineroMoneda		char(10),
@CtaDineroDestinoMoneda	char(10),
@CtaDineroDestinoTipo	char(20),
@CtaEmpresa			char(5),
@Cajero			char(10),
@Importe			money,
@Impuestos			money,
@Saldo			money,
@Corte			int,
@CorteDestino		int,
@Directo	                bit,
@CfgContX			bit,
@CfgContXGenerar		char(20),
@OrigenMovTipo		char(20),
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@Ok               		int          OUTPUT,
@OkRef            		varchar(255) OUTPUT
AS BEGIN
RETURN
IF EXISTS(SELECT * FROM MovFlujo WHERE Cancelado = 0 AND Empresa = @Empresa AND DModulo = @Modulo AND DID = @ID AND OModulo <> DModulo AND @OrigenMovTipo='CONC.B' AND @Estatus='CONCLUIDO') AND @Accion='CANCELAR'
SELECT @Ok = 60070, @OkRef = @Mov + ' ' + @MovID
END

