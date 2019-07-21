SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisServiceProcesarContParalela
@Sistema			varchar(100),
@ID					int,
@iSolicitud			int,
@Solicitud			varchar(max),
@Version			float,
@Referencia			varchar(100),
@SubReferencia		varchar(100),
@Resultado			varchar(max)	OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT,
@EsContParalela		bit				OUTPUT

AS BEGIN
DECLARE @BaseDatosRemota		varchar(255),
@IDEmpresa			int,
@Empresa				varchar(5),
@EmpresaRemota		varchar(5),
@CuentaD				varchar(20),
@CuentaA				varchar(20),
@CPBaseLocal			bit,
@CPBaseDatos			varchar(255),
@CPURL				varchar(255),
@CPCentralizadora		bit,
@Mov					varchar(20),
@MovID				varchar(20),
@Usuario				varchar(10),
@Nivel				varchar(10)
SELECT @BaseDatosRemota	= BaseDatos,
@EmpresaRemota		= Empresa,
@CuentaD			= CuentaD,
@CuentaA			= CuentaA,
@CPBaseLocal		= CPBaseLocal,
@CPBaseDatos		= CPBaseDatos,
@CPURL				= CPURL,
@CPCentralizadora	= CPCentralizadora,
@Mov				= Mov,
@MovID				= MovID,
@Usuario			= Usuario,
@Nivel				= Nivel
FROM OPENXML (@iSolicitud, '/Intelisis/Solicitud/ContParalela',1)
WITH (BaseDatos			varchar(255),
Empresa			varchar(5),
CuentaD			varchar(20),
CuentaA			varchar(20),
CPBaseLocal		bit,
CPBaseDatos		varchar(255),
CPURL				varchar(255),
CPCentralizadora	bit,
Mov				varchar(20),
MovID				varchar(20),
Usuario			varchar(10),
Nivel				varchar(10)
)
SELECT @IDEmpresa = ID, @Empresa = Empresa FROM ContParalelaEmpresa WHERE BaseDatosRemota = @BaseDatosRemota AND EmpresaRemota = @EmpresaRemota
IF @Referencia IN('ContParalela.CentralizarCuentas', 'ContParalela.PaqueteContable') AND @Empresa IS NULL
SELECT @Ok = 10704, @OkRef = @EmpresaRemota
IF @Ok IS NULL AND @Referencia = 'ContParalela.CentralizarCuentas' EXEC spISContParalelaCtaRecibir     @ID, @Mov, @MovID, @Usuario, @iSolicitud, @Version, @BaseDatosRemota, @EmpresaRemota, @Empresa, @CuentaD, @CuentaA, @Nivel, @CPBaseLocal, @CPBaseDatos, @CPURL, @CPCentralizadora, @IDEmpresa, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @Referencia = 'ContParalela.PaqueteContable'    EXEC spISContParalelaPaqueteRecibir @ID, @Mov, @MovID, @Usuario, @iSolicitud, @Version, @BaseDatosRemota, @EmpresaRemota, @Empresa, @CuentaD, @CuentaA, @Nivel, @CPBaseLocal, @CPBaseDatos, @CPURL, @CPCentralizadora, @IDEmpresa, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Referencia IN('ContParalela.CentralizarCuentas', 'ContParalela.PaqueteContable')
SELECT @EsContParalela = 1
RETURN
END

