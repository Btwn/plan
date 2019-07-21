SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spParsearTexto
(
@Modulo			varchar(5),
@Mov				varchar(20),
@Exportacion			varchar(50),
@IDSeccion			int,
@Vista			varchar(50),
@Texto			varchar(MAX) OUTPUT,
@Ok				int		     OUTPUT,
@OkRef			varchar(255) OUTPUT
)

AS
BEGIN
DECLARE
@Largo				int,
@Contador			int,
@TextoRetorno			varchar(MAX),
@Caracter			char(1),
@Campo				varchar(100),
@CampoTraducido			varchar(200),
@Modo				int,
@Traducir			bit,
@Formato			varchar(50)
SELECT @Largo = LEN(@Texto), @Contador = 1
SELECT @TextoRetorno = Char(39)
SELECT @Campo = '', @Modo = 0
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
SELECT @CampoTraducido = RTRIM(CampoIntelisis), @Formato = ISNULL(Formato,''), @Traducir = ISNULL(Traducir,0) FROM TablaParseoD WHERE RTRIM(Exportacion) = RTRIM(@Exportacion) AND IDSeccion = @IDSeccion AND RTRIM(CampoXML) = RTRIM(@Campo)
SET @CampoTraducido = ISNULL(@CampoTraducido,@Campo)
IF @CampoTraducido <> @Campo
BEGIN
IF dbo.fnObtenerTipoColumna(@CampoTraducido,@Vista) IN ('uniqueidentifier','tinyint','smallint','int','real','money','float','bit','decimal','numeric','smallmoney','bigint') AND @CampoTraducido <> @Campo SET @CampoTraducido = 'ISNULL(RTRIM(LTRIM(CONVERT(varchar,' + RTRIM(@CampoTraducido) + '))),' + CHAR(39) + CHAR(39) + ')' ELSE
IF dbo.fnObtenerTipoColumna(@CampoTraducido,@Vista) IN ('smalldatetime','datetime') AND @CampoTraducido <> @Campo SET @CampoTraducido = 'ISNULL(RTRIM(LTRIM(dbo.fnFormatoFecha(' + RTRIM(@CampoTraducido) + ',' + CHAR(39) + RTRIM(@Formato) + CHAR(39) + '))),' + CHAR(39) + CHAR(39) + ')' ELSE
IF dbo.fnObtenerTipoColumna(@CampoTraducido,@Vista) IN ('varbinary','binary') AND @CampoTraducido <> @Campo SET @CampoTraducido = 'ISNULL(RTRIM(LTRIM(CONVERT(varchar,' + RTRIM(@CampoTraducido) + '))),' + CHAR(39) + CHAR(39) + ')' ELSE
IF dbo.fnObtenerTipoColumna(@CampoTraducido,@Vista) IN ('varchar','char','nvarchar','nchar') AND @CampoTraducido <> @Campo SET @CampoTraducido = 'ISNULL(RTRIM(' + RTRIM(@CampoTraducido) + '),' + CHAR(39) + CHAR(39) + ')'
IF @Traducir = 1 SET @CampoTraducido = CHAR(39) + ' +  dbo.fnTraducirParseo(' + CHAR(39) + RTRIM(@Modulo) + CHAR(39) + ',' + CHAR(39) + RTRIM(@Mov) + CHAR(39) + ',' + CHAR(39) + RTRIM(@Exportacion) + CHAR(39) + ',' + RTRIM(CONVERT(varchar,@IDSeccion)) + ',' + @CampoTraducido +  ') + ' + CHAR(39) ELSE
IF @Traducir = 0 SET @CampoTraducido = CHAR(39) + ' + ' + @CampoTraducido +  ' + ' + CHAR(39)
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

