SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocParsearTexto
(
@Modulo			varchar(5),
@eDoc				varchar(50),
@IDSeccion		int,
@Vista			varchar(50),
@Texto			varchar(MAX) OUTPUT,
@Ok				int		     OUTPUT,
@OkRef			varchar(255) OUTPUT
)

AS
BEGIN
DECLARE
@Largo									int,
@Contador								int,
@TextoRetorno							varchar(MAX),
@Caracter								char(1),
@Campo									varchar(255),
@CampoTraducido							varchar(255),
@Modo									int,
@Traducir								bit,
@FormatoOpcional						varchar(50),
@RID									int,
@Decimales								int,
@DecimalesPorOmision					int,
@CaracterExtendidoAASCII				bit, 
@CaracterExtendidoAASCIIOmision			bit, 
@ConvertirPaginaCodigo437				bit, 
@ConvertirPaginaCodigo437Omision		bit, 
@ConvertirComillaDobleAASCII			bit, 
@ConvertirComillaDobleAASCIIOmision		bit, 
@NumericoNuloACero						bit, 
@NumericoNuloACeroTexto					varchar(50)  
SELECT @Largo = LEN(@Texto), @Contador = 1
SELECT @TextoRetorno = Char(39)
SELECT @Campo = '', @Modo = 0
SELECT
@DecimalesPorOmision                = DecimalesPorOmision,
@CaracterExtendidoAASCIIOmision     = CaracterExtendidoAASCII,
@ConvertirPaginaCodigo437Omision    = ConvertirPaginaCodigo437,
@ConvertirComillaDobleAASCIIOmision = ConvertirComillaDobleAASCII
FROM eDoc WITH(NOLOCK)
 WHERE eDoc = @eDoc
WHILE @Contador <= @Largo
BEGIN
SET @Caracter = SUBSTRING(@Texto,@Contador,1)
IF @Caracter = '[' SET @Modo = 1 ELSE
IF @Caracter = ']' SET @Modo = 2 ELSE
IF ASCII(@Caracter) <= 31 AND @Modo NOT IN (1) SET @Modo = 3 ELSE
IF ASCII(@Caracter) >= 32 AND @Caracter NOT IN ('[',']') AND @Modo NOT IN (1) SET @Modo = 4
IF @Modo = 1
BEGIN
SET @Campo = @Campo + @Caracter
END
ELSE IF @Modo = 2
BEGIN
SET @Campo = @Campo + @Caracter
SET @CampoTraducido = NULL
SELECT
@CampoTraducido              = RTRIM(CampoVista),
@FormatoOpcional             = ISNULL(FormatoOpcional,''),
@Traducir                    = ISNULL(Traducir,0),
@RID                         = RID,
@Decimales                   = Decimales,
@CaracterExtendidoAASCII     = CaracterExtendidoAASCII,
@ConvertirPaginaCodigo437    = ConvertirPaginaCodigo437,
@ConvertirComillaDobleAASCII = ConvertirComillaDobleAASCII,
@NumericoNuloACero           = ISNULL(NumericoNuloACero,0)
FROM eDocDMapeoCampo WITH(NOLOCK)
 WHERE RTRIM(Modulo) = RTRIM(@Modulo)
AND RTRIM(eDoc) = RTRIM(@eDoc)
AND IDSeccion = @IDSeccion
AND RTRIM(CampoXML) = RTRIM(@Campo)
SET @Decimales = ISNULL(ISNULL(@Decimales,@DecimalesPorOmision),2)
SET @CaracterExtendidoAASCII = ISNULL(ISNULL(@CaracterExtendidoAASCII,@CaracterExtendidoAASCIIOmision),0) 
SET @ConvertirPaginaCodigo437 = ISNULL(ISNULL(@ConvertirPaginaCodigo437,@ConvertirPaginaCodigo437Omision),0) 
SET @ConvertirComillaDobleAASCII = ISNULL(ISNULL(@ConvertirComillaDobleAASCII,@ConvertirComillaDobleAASCIIOmision),0) 
SET @CampoTraducido = ISNULL(@CampoTraducido,@Campo)
IF @NumericoNuloACero = 1
SET @NumericoNuloACeroTexto = '0.0'
ELSE
SET @NumericoNuloACeroTexto = 'NULL'
IF @CampoTraducido <> @Campo
BEGIN
IF dbo.fneDocObtenerTipoColumna(@CampoTraducido,@Vista) IN ('real','money','float','decimal','smallmoney') AND @CampoTraducido <> @Campo SET @CampoTraducido = 'ISNULL(RTRIM(LTRIM(CONVERT(varchar,CONVERT(DECIMAL(20,' + LTRIM(RTRIM(CONVERT(varchar,@Decimales))) + '),ISNULL(' + RTRIM(@CampoTraducido) + ',' + @NumericoNuloACeroTexto + '))))),' + CHAR(39) + CHAR(39) + ')' ELSE 
IF dbo.fneDocObtenerTipoColumna(@CampoTraducido,@Vista) IN ('numeric','smallint','int','uniqueidentifier','tinyint','bit','bigint') AND @CampoTraducido <> @Campo SET @CampoTraducido = 'ISNULL(RTRIM(LTRIM(CONVERT(varchar,' + RTRIM(@CampoTraducido) + '))),' + CHAR(39) + CHAR(39) + ')' ELSE
IF dbo.fneDocObtenerTipoColumna(@CampoTraducido,@Vista) IN ('smalldatetime','datetime') AND @CampoTraducido <> @Campo SET @CampoTraducido = 'ISNULL(RTRIM(LTRIM(dbo.fneDocFormatoFecha(' + RTRIM(@CampoTraducido) + ',' + CHAR(39) + RTRIM(@FormatoOpcional) + CHAR(39) + '))),' + CHAR(39) + CHAR(39) + ')' ELSE
IF dbo.fneDocObtenerTipoColumna(@CampoTraducido,@Vista) IN ('varbinary','binary') AND @CampoTraducido <> @Campo SET @CampoTraducido = 'ISNULL(RTRIM(LTRIM(CONVERT(varchar,' + RTRIM(@CampoTraducido) + '))),' + CHAR(39) + CHAR(39) + ')' ELSE
IF dbo.fneDocObtenerTipoColumna(@CampoTraducido,@Vista) IN ('varchar','char','nvarchar','nchar') AND @CampoTraducido <> @Campo SET @CampoTraducido = 'ISNULL(RTRIM(' + RTRIM(@CampoTraducido) + '),' + CHAR(39) + CHAR(39) + ')' ELSE
IF dbo.fneDocObtenerTipoColumna(@CampoTraducido,@Vista) IS NULL AND @CampoTraducido <> @Campo SET @CampoTraducido = 'ISNULL(RTRIM(' + RTRIM(@CampoTraducido) + '),' + CHAR(39) + CHAR(39) + ')'
IF @Traducir = 1 SET @CampoTraducido = 'dbo.fneDocTraducirParseo(' + CHAR(39) + RTRIM(@Modulo) + CHAR(39) + ',' + CHAR(39) + RTRIM(@eDoc) + CHAR(39) + ',' + RTRIM(CONVERT(varchar,@IDSeccion)) + ',' + RTRIM(CONVERT(varchar,@RID)) + ',' + @CampoTraducido +  ')' ELSE 
IF @Traducir = 0 SET @CampoTraducido = @CampoTraducido 
IF @CaracterExtendidoAASCII = 1 SET @CampoTraducido = CHAR(39) + ' +  dbo.fneDocXMLAUTF8Min(' + @CampoTraducido +  ',' + CONVERT(varchar,@ConvertirPaginaCodigo437) + ',' + CONVERT(varchar,@ConvertirComillaDobleAASCII) + ') + ' + CHAR(39) ELSE 
IF @CaracterExtendidoAASCII = 0 SET @CampoTraducido = CHAR(39) + ' + ' + @CampoTraducido +  ' + ' + CHAR(39) 
END
SET @Campo = ''
SET @TextoRetorno = @TextoRetorno + @CampoTraducido
END
ELSE IF @Modo = 3
BEGIN
SET @CampoTraducido = CHAR(39) + ' + CHAR(' + CONVERT(varchar,ASCII(@Caracter)) + ') + ' + CHAR(39)
SET @TextoRetorno = @TextoRetorno + @CampoTraducido
END
ELSE IF @Modo = 4
BEGIN
SET @TextoRetorno = @TextoRetorno + @Caracter
END
SET @Contador = @Contador + 1
END
SET @TextoRetorno = @TextoRetorno + CHAR(39)
SET @Texto = @TextoRetorno
END

