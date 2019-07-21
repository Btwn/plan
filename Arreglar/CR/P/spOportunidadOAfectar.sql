SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spOportunidadOAfectar
@ID                	int,
@Accion				char(20),
@Empresa	      	char(5),
@Modulo	      		char(5),
@Mov	  	      	char(20),
@MovID             	varchar(20)	OUTPUT,
@MovTipo     		char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaEmision      	datetime,
@FechaAfectacion    datetime,
@FechaConclusion	datetime,
@Proyecto	      	varchar(50),
@Usuario	      	char(10),
@Autorizacion      	char(10),
@DocFuente	      	int,
@Observaciones     	varchar(255),
@Concepto     		varchar(50),
@Referencia			varchar(50),
@Estatus           	char(15),
@EstatusNuevo	    char(15),
@FechaRegistro     	datetime,
@Ejercicio	      	int,
@Periodo	      	int,
@MovUsuario			char(10),
@NivelInteres		varchar(50),
@Plantilla			varchar(20),
@ContactoTipo		varchar(20),
@Contacto			varchar(10),
@ImporteOportunidad	float,
@PorcentajeCierre	float,
@ImportePonderado	float,
@ProbCierre			float,
@Competidor			varchar(50),
@Motivo				varchar(100),
@Propuesta			varchar(50),
@Intermediario		varchar(10),
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@SucursalDestino	int,
@SucursalOrigen		int,
@CfgContX			bit,
@CfgContXGenerar	char(20),
@GenerarPoliza		bit,
@Generar			bit,
@GenerarMov			char(20),
@GenerarAfectado	bit,
@OrigenTipo			varchar(5),
@Origen				varchar(20),
@OrigenID			varchar(20),
@IDGenerar			int	     	OUTPUT,
@GenerarMovID	  	varchar(20)	OUTPUT,
@Mensaje			int          OUTPUT,
@Ok                	int          OUTPUT,
@OkRef             	varchar(255) OUTPUT

AS BEGIN
DECLARE @IDPropuesta		int
SELECT @IDPropuesta = ID
FROM Venta
WHERE IDOPORT = @ID
AND RTRIM(Mov)+' '+RTRIM(MovID) = @Propuesta
AND Empresa = @Empresa
IF @Accion IN ('AFECTAR') AND NOT EXISTS(SELECT ID FROM OportunidadD WHERE ID = @ID)
BEGIN
EXEC spOportunidadunidadDInsertar @ID, @Plantilla, @Usuario, @Ok OUTPUT, @OkRef OUTPUT
END
IF ISNULL(@OrigenTipo, '') = 'OPORT' AND @Ok IS NULL AND ((@Estatus = 'SINAFECTAR' AND @EstatusNuevo = 'REVISION') OR(@Accion = 'CANCELAR'))
EXEC spOportunidadMatar @Empresa, @Usuario, @FechaEmision, @FechaRegistro, @Sucursal, @ID, @Accion, @OrigenTipo, @Origen, @OrigenID, @ContactoTipo, @Contacto, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND (@EstatusNuevo = 'PENDIENTE')
BEGIN
EXEC spOportunidadImporteOportunidad @Empresa, @Usuario, @FechaEmision, @FechaRegistro, @Sucursal, @ID, @Accion, @OrigenTipo, @Origen, @OrigenID, @ContactoTipo, @Contacto, @Propuesta, @Plantilla, @IDPropuesta, @Mensaje OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL AND ((@EstatusNuevo = 'CONCLUIDO') OR(@Accion = 'CANCELAR'))
BEGIN
EXEC spOportunidadOportunidadGanar @Empresa, @Usuario, @FechaEmision, @FechaRegistro, @Sucursal, @ID, @Accion, @OrigenTipo, @Origen, @OrigenID, @ContactoTipo, @Contacto, @Propuesta, @Plantilla, @IDPropuesta, @Mensaje OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @EstatusNuevo = 'CONCLUIDO'
EXEC spOportunidadPropuestaConcluir @Empresa, @Usuario, @FechaEmision, @FechaRegistro, @Sucursal, @ID, @Accion, @OrigenTipo, @Origen, @OrigenID, @ContactoTipo, @Contacto, @Propuesta, @Plantilla, @IDPropuesta, @Ok OUTPUT, @OkRef OUTPUT
END
EXEC xpOportunidadOAfectar @ID, @Accion, @Empresa, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio, @FechaEmision, @FechaAfectacion, @FechaConclusion, @Proyecto,
@Usuario, @Autorizacion, @DocFuente, @Observaciones, @Concepto, @Referencia, @Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo,
@MovUsuario, @NivelInteres, @Plantilla, @ContactoTipo, @Contacto, @ImporteOportunidad, @PorcentajeCierre, @ImportePonderado, @ProbCierre, @Competidor,
@Motivo, @Propuesta, @Intermediario, @Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen, @CfgContX, @CfgContXGenerar, @GenerarPoliza,
@Generar, @GenerarMov, @GenerarAfectado, @OrigenTipo, @Origen, @OrigenID, @IDGenerar OUTPUT, @GenerarMovID OUTPUT, @Mensaje OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

