SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spContParalelaXMLGenerar
@ID					int,
@Empresa			varchar(5),
@Mov				varchar(20),
@MovID				varchar(20),
@MovTipo			varchar(20),
@BaseDatos			varchar(255),
@EmpresaOrigen		varchar(5),
@CuentaD			varchar(20),
@CuentaA			varchar(20),
@Nivel				varchar(20),
@CPBaseLocal		bit,
@CPBaseDatos		varchar(255),
@CPURL				varchar(255),
@CPCentralizadora	bit,
@CPUsuario			varchar(10),
@CPContrasena		varchar(32),
@ISReferencia		varchar(100),
@IDEmpresa			int,
@CONTEsCancelacion	bit,
@XML				varchar(max)	OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS
BEGIN
DECLARE @Detalle		varchar(max),
@SubLlave		varchar(10)
DELETE ContParalelaXML WHERE ID = @ID
SELECT @BaseDatos = DB_NAME()
SELECT @SubLlave = CASE @MovTipo
WHEN 'CONTP.ENVIARCUENTAS' THEN 'Solicitud'
WHEN 'CONTP.RECIBIRCUENTA' THEN 'Resultado'
WHEN 'CONTP.PAQUETE' THEN 'Solicitud'
WHEN 'CONTP.RECIBIRPAQUETE' THEN 'Resultado'
ELSE 'Solicitud'
END
IF @MovTipo IN('CONTP.ENVIARCUENTAS', 'CONTP.RECIBIRCUENTA')
SELECT @Detalle = (SELECT Cuenta, Rama, Descripcion, Tipo, Categoria, Grupo, Familia, EsAcreedora, EsAcumulativa, Estatus, TieneMovimientos, CtaEstatus
FROM ContParalelaD
WHERE ID = @ID
FOR XML AUTO)
IF @MovTipo IN('CONTP.RECIBIRPAQUETE')
SELECT @Detalle = (SELECT ContID, ContMov, ContMovID, ContFechaEmision, ContOrigenTipo, ContOrigen, ContOrigenID, PolizaEstatus
FROM ContParalelaD
WHERE ID = @ID
FOR XML AUTO)
IF @MovTipo IN('CONTP.PAQUETE')
EXEC spContParalelaPaqueteXMLGenerar @ID, @Empresa, @Mov, @MovID, @MovTipo, @BaseDatos, @EmpresaOrigen, @CuentaD, @CuentaA, @Nivel, @CPBaseLocal, @CPBaseDatos, @CPURL, @CPCentralizadora, @CPUsuario, @CPContrasena, @ISReferencia, @IDEmpresa, /*REQ25300*/ @CONTEsCancelacion, @Detalle OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
SELECT @XML = '<?xml version="1.0" encoding="windows-1252" ?>'
SELECT @XML = @XML + '<Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="' + ISNULL(@ISReferencia, '') + '" SubReferencia="" Version="01" Ok="' + ISNULL(CONVERT(varchar(max), @Ok), '') + '" OkRef="' + ISNULL(@OkRef, '') +'" Usuario ="' + ISNULL(@CPUsuario, '') + '" Contrasena ="' + ISNULL(@CPContrasena, '') + '">
<' + @SubLlave + '>
<ContParalela Usuario ="' + ISNULL(@CPUsuario, '') + '" Mov ="' + ISNULL(@Mov, '') + '" MovID = "' + ISNULL(@MovID, '') + '" BaseDatos="' + ISNULL(@BaseDatos, '') + '" Empresa="' + ISNULL(@Empresa, '') + '" CuentaD="' + ISNULL(@CuentaD, '') + '" CuentaA="' + ISNULL(@CuentaA, '') + '" CPBaseLocal="' + ISNULL(CONVERT(varchar(max), @CPBaseLocal), '') + '" CPBaseDatos="' + ISNULL(@CPBaseDatos, '') + '" CPURL="' + ISNULL(@CPURL, '') + '" CPCentralizadora="' + ISNULL(CONVERT(varchar(max), @CPCentralizadora), '') + '" Nivel="' + ISNULL(@Nivel, '')+'" CONTEsCancelacion="'	+CONVERT(varchar(max), @CONTEsCancelacion) + '" />'
SELECT @XML = @XML + ISNULL(@Detalle, '')
SELECT @XML = @XML + '  </' + @SubLlave + '>
</Intelisis>'
INSERT ContParalelaXML(ID, XML) SELECT @ID, @XML
RETURN
END

