SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpInvAfectar
@ID                		int,
@Accion			char(20),
@Base			char(20),
@Empresa	      		char(5),
@Usuario			char(10),
@Modulo	      		char(5),
@Mov	  	      		char(20),
@MovID             		varchar(20),
@MovTipo     		char(20),
@MovMoneda	      		char(10),
@MovTipoCambio	 	float,
@Estatus	 	      	char(15),
@EstatusNuevo	      	char(15),
@FechaEmision		datetime,
@FechaRegistro		datetime,
@FechaAfectacion    		datetime,
@Conexion			bit,
@SincroFinal			bit,
@Sucursal			int,
@UtilizarID			int,
@UtilizarMovTipo    		char(20),
@Ok				int		OUTPUT,
@OkRef			varchar(255)	OUTPUT
AS BEGIN
DECLARE
@Error		int,
@ErrorRef	varchar(255),
@Origen                 char(5),
@OrigenID               varchar(20),
@OrigenMov              varchar(20),
@OrigenMovID            varchar(20),
@OrigenMovTipo          varchar(20),
@OID                    int,
@OrigenTipo             varchar(10),
@IDCancelar             int,
@ModuloCancelar         varchar(5),
@IDCancelarA            int,
@ModuloCancelarA        char(5),
@SubClave               char(20) 
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
BEGIN
EXEC spINFORInvAfectar  @ID, @Accion, @Base, @Empresa, @Usuario, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio, @Estatus, @EstatusNuevo, @FechaEmision, @FechaRegistro, @FechaAfectacion, @Conexion, @SincroFinal, @Sucursal, NULL, NULL,@Error OUTPUT, @ErrorRef OUTPUT
IF @Error IS NOT NULL OR @Error BETWEEN 80030 AND 81000
SELECT @Ok = @Error, @OkRef = @OkRef
END
SELECT @SubClave = ISNULL(SubClave,'') FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov AND Clave = @MovTipo
IF @Ok IS NULL AND @Modulo = 'INV' AND @MovTipo = 'INV.SOL' and @SubClave='INV.ENT' AND @Accion='CANCELAR' AND @Conexion = 0
BEGIN
SELECT @Origen = OrigenTipo, @OrigenMov = Origen, @OrigenMovID = OrigenID FROM Inv WHERE ID = @ID
SELECT @OrigenMovTipo = Clave, @SubClave=SubClave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @OrigenMov
IF @Conexion = 0
IF 
@Estatus IN('CONCLUIDO', 'PROCESAR', 'PENDIENTE')
AND @OrigenMovTipo = 'INV.A' AND @Origen = 'INV' AND @SubClave='INV.ATMAORENT'
SELECT @Ok = 60070
END
RETURN
END

