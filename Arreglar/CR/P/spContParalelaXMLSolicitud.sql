SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spContParalelaXMLSolicitud
@ID					int,
@Empresa			varchar(5),
@Mov				varchar(20),
@MovID				varchar(20),
@MovTipo			varchar(20),
@BaseDatos			varchar(255),
@EmpresaOrigen		varchar(5),
@CuentaD			varchar(20),
@CuentaA			varchar(20),
@CPBaseLocal		bit,
@CPBaseDatos		varchar(255),
@CPURL				varchar(255),
@CPCentralizadora	bit,
@CPUsuario			varchar(10),
@CPContrasena		varchar(32),
@XML				varchar(max),
@ISReferencia		varchar(100),
@IDEmpresa			int,
@Resultado			varchar(max)	OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS
BEGIN
IF @CPBaseLocal = 1
EXEC spContParalelaXMLSolicitudLocal @ID, @Empresa, @Mov, @MovID, @MovTipo, @BaseDatos, @EmpresaOrigen, @CuentaD, @CuentaA, @CPBaseLocal, @CPBaseDatos, @CPURL, @CPCentralizadora, @CPUsuario, @CPContrasena, @XML, @ISReferencia, @IDEmpresa, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
ELSE IF @CPBaseLocal = 0
EXEC spContParalelaXMLSolicitudRemota @ID, @Empresa, @Mov, @MovID, @MovTipo, @BaseDatos, @EmpresaOrigen, @CuentaD, @CuentaA, @CPBaseLocal, @CPBaseDatos, @CPURL, @CPCentralizadora, @CPUsuario, @CPContrasena, @XML, @ISReferencia, @IDEmpresa, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF CHARINDEX('<?xml version="1.0" encoding="windows-1252" ?>', @Resultado) = 0
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252" ?>' + @Resultado
RETURN
END

