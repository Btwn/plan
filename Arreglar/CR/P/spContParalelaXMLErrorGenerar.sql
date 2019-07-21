SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spContParalelaXMLErrorGenerar
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
@ISReferencia		varchar(100),
@XML				varchar(max)	OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS
BEGIN
DECLARE @Detalle		varchar(max),
@SubLlave		varchar(10)
DELETE ContParalelaXML WHERE ID = @ID
SELECT @BaseDatos = DB_NAME()
SELECT @SubLlave = 'Resultado'
SELECT @XML = '<Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="' + ISNULL(@ISReferencia, '') + '" SubReferencia="" Version="01" Ok="' + ISNULL(CONVERT(varchar(max), @Ok), '') + '" OkRef="' + ISNULL(@OkRef, '') +'" >
<' + @SubLlave + '>
<ContParalela Usuario ="' + ISNULL(@CPUsuario, '') + '" Mov ="' + ISNULL(@Mov, '') + '" MovID = "' + ISNULL(@MovID, '') + '" BaseDatos="' + ISNULL(@BaseDatos, '') + '" Empresa="' + ISNULL(@Empresa, '') + '" CuentaD="' + ISNULL(@CuentaD, '') + '" CuentaA="' + ISNULL(@CuentaA, '') + '" CPBaseLocal="' + ISNULL(CONVERT(varchar(max), @CPBaseLocal), '') + '" CPBaseDatos="' + ISNULL(@CPBaseDatos, '') + '" CPURL="' + ISNULL(@CPURL, '') + '" CPCentralizadora="' + ISNULL(CONVERT(varchar(max), @CPCentralizadora), '') + '" />'
SELECT @XML = @XML + '  </' + @SubLlave + '>
</Intelisis>'
INSERT ContParalelaXML(ID, XML) SELECT @ID, @XML
RETURN
END

