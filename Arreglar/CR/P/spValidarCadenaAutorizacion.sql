SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spValidarCadenaAutorizacion
(
@CadenaAutorizacion			varchar(max),
@Tipo							varchar(50) = NULL OUTPUT,
@Empresa						varchar(5) = NULL OUTPUT,
@Sucursal						int = NULL OUTPUT,
@Modulo						varchar(5) = NULL OUTPUT,
@ID							int = NULL OUTPUT,
@Estatus						varchar(15) = NULL OUTPUT,
@Situacion					varchar(50) = NULL OUTPUT,
@Usuario						varchar(10) = NULL OUTPUT,
@CheckSum						int = NULL OUTPUT,
@CadenaAutorizacionValida		bit = 0 OUTPUT
)

AS BEGIN
DECLARE
@Largo									int,
@Contador								int,
@Caracter								char(1),
@Modo									int,
@Campo									varchar(255),
@CheckSumNuevo							int
SELECT @Largo = LEN(@CadenaAutorizacion), @Contador = 1, @Modo = -1, @Campo = '', @CheckSumNuevo = NULL
WHILE @Contador <= @Largo
BEGIN
SET @Caracter = SUBSTRING(@CadenaAutorizacion,@Contador,1)
IF @Caracter = CHAR(124)  AND @Modo = -1  SET @Modo = 0   ELSE
IF @Caracter <> CHAR(124) AND @Modo = 0   SET @Modo = -1  ELSE
IF @Caracter = CHAR(124)  AND @Modo = 0   SET @Modo = 1   ELSE
IF @Caracter = CHAR(124)  AND @Modo = 1   SET @Modo = 2   ELSE
IF @Caracter = CHAR(124)  AND @Modo = 2   SET @Modo = 3   ELSE
IF @Caracter = CHAR(124)  AND @Modo = 3   SET @Modo = 4   ELSE
IF @Caracter = CHAR(124)  AND @Modo = 4   SET @Modo = 5   ELSE
IF @Caracter = CHAR(124)  AND @Modo = 5   SET @Modo = 6   ELSE
IF @Caracter = CHAR(124)  AND @Modo = 6   SET @Modo = 7   ELSE
IF @Caracter = CHAR(124)  AND @Modo = 7   SET @Modo = 8   ELSE
IF @Caracter = CHAR(124)  AND @Modo = 8   SET @Modo = 9   ELSE
IF @Caracter = CHAR(124)  AND @Modo = 9   SET @Modo = 10  ELSE
IF @Caracter = CHAR(124)  AND @Modo = 10   SET @Modo = 11
IF @Modo = 1
BEGIN
IF @Caracter = CHAR(124)
SET @Campo = ''
ELSE IF @Caracter <> CHAR(124)
SET @Campo = @Campo + @Caracter
END ELSE
IF @Modo = 2
BEGIN
IF @Caracter = CHAR(124)
BEGIN
SET @Tipo = @Campo
SET @Campo = ''
END
ELSE IF @Caracter <> CHAR(124)
SET @Campo = @Campo + @Caracter
END ELSE
IF @Modo = 3
BEGIN
IF @Caracter = CHAR(124)
BEGIN
SET @Empresa = @Campo
SET @Campo = ''
END
ELSE IF @Caracter <> CHAR(124)
SET @Campo = @Campo + @Caracter
END ELSE
IF @Modo = 4
BEGIN
IF @Caracter = CHAR(124)
BEGIN
SET @Sucursal = CONVERT(int,@Campo)
SET @Campo = ''
END
ELSE IF @Caracter <> CHAR(124)
SET @Campo = @Campo + @Caracter
END ELSE
IF @Modo = 5
BEGIN
IF @Caracter = CHAR(124)
BEGIN
SET @Modulo = @Campo
SET @Campo = ''
END
ELSE IF @Caracter <> CHAR(124)
SET @Campo = @Campo + @Caracter
END ELSE
IF @Modo = 6
BEGIN
IF @Caracter = CHAR(124)
BEGIN
SET @ID = CONVERT(int,@Campo)
SET @Campo = ''
END
ELSE IF @Caracter <> CHAR(124)
SET @Campo = @Campo + @Caracter
END ELSE
IF @Modo = 7
BEGIN
IF @Caracter = CHAR(124)
BEGIN
SET @Estatus = @Campo
SET @Campo = ''
END
ELSE IF @Caracter <> CHAR(124)
SET @Campo = @Campo + @Caracter
END ELSE
IF @Modo = 8
BEGIN
IF @Caracter = CHAR(124)
BEGIN
SET @Situacion = @Campo
SET @Campo = ''
END
ELSE IF @Caracter <> CHAR(124)
SET @Campo = @Campo + @Caracter
END ELSE
IF @Modo = 9
BEGIN
IF @Caracter = CHAR(124)
BEGIN
SET @Usuario = @Campo
SET @Campo = ''
END
ELSE IF @Caracter <> CHAR(124)
SET @Campo = @Campo + @Caracter
END ELSE
IF @Modo = 10
BEGIN
IF @Caracter = CHAR(124)
BEGIN
SET @Checksum = CONVERT(int,@Campo)
SET @Campo = ''
END
ELSE IF @Caracter <> CHAR(124)
SET @Campo = @Campo + @Caracter
END
SET @Contador = @Contador + 1
END
SET @ChecksumNuevo = CHECKSUM(SUBSTRING(@Tipo,1,3) + LTRIM(RTRIM(@@SERVERNAME)) + LTRIM(RTRIM(DB_NAME())) + @Empresa + LTRIM(RTRIM(CONVERT(varchar,@Sucursal))) + @Modulo + LTRIM(RTRIM(CONVERT(varchar,@ID))) + @Estatus + @Situacion + @Usuario)
IF @CheckSum <> @CheckSumNuevo
SELECT @CadenaAutorizacionValida = 0
ELSE
SELECT @CadenaAutorizacionValida = 1
END

