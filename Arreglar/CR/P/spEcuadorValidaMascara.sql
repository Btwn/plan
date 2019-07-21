SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spEcuadorValidaMascara
@TipoRegistro	varchar(20),
@Registro       varchar(50),
@EnSilencio	bit	= 0,
@Valido		bit 	= 1	OUTPUT  

AS BEGIN
DECLARE
@Mascara	varchar(50),
@LargoReg	int,
@LargoMasc	int,
@Contador	int,
@TipoMasc	char(1),
@Codigo	int,
@TipoID	varchar(20),
@Digito	varchar(2)
SET @Registro = NULLIF(RTRIM(@Registro),'')
SELECT @Mascara = UPPER(Mascara), @TipoID = TipoID FROM TipoRegistro WHERE RTRIM(TipoRegistro) = RTRIM(@TipoRegistro)
SELECT @Contador = 1
SELECT @Valido = 1
SELECT @LargoReg=LEN(ISNULL(RTRIM(@Registro), ''))
SELECT @LargoMasc=LEN(ISNULL(RTRIM(@Mascara), ''))
IF @LargoReg > @LargoMasc
SELECT @Valido = 0
IF @Valido = 1
BEGIN
WHILE @Contador <= @LargoReg AND @Valido = 1
BEGIN
SELECT @TipoMasc = SUBSTRING(@Mascara, @Contador, 1)
SELECT @Codigo = ASCII(SUBSTRING(UPPER(@Registro), @Contador, 1))
IF @TipoMasc = 'A'
BEGIN
IF (NOT (@Codigo BETWEEN 65 AND 90)) AND (NOT (@Codigo BETWEEN 48 AND 57)) AND (@Codigo <> 209) SET @Valido = 0
END ELSE
IF @TipoMasc = '9'
BEGIN
IF (NOT (@Codigo BETWEEN 48 AND 57)) SET @Valido = 0
END ELSE
IF @TipoMasc NOT IN ('A','9')
BEGIN
IF @Codigo <> ASCII(@TipoMasc) SET @Valido = 0
END
SET @Contador = @Contador + 1
END
END
EXEC xpEcuadorValidaMascara @TipoRegistro, @Registro, @EnSilencio, @Valido OUTPUT
IF (@LargoReg <> @LargoMasc) AND (@Valido = 1) SELECT @Valido = 0
IF @Valido = 1 AND @TipoID = 'RUC'
BEGIN
EXEC spEcuadorRUCDigitoVerificador @Registro, @Digito OUTPUT
IF @Digito IS NULL SET @Valido = 0
END
IF @Valido = 1 AND @TipoID = 'Cedula'
BEGIN
EXEC spEcuadorCedulaDigitoVerificador @Registro, @Digito OUTPUT
IF @Digito IS NULL SET @Valido = 0
END
IF @EnSilencio = 0
SELECT @Valido
END

