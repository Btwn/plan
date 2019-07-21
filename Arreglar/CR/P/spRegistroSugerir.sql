SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRegistroSugerir
@Cual             varchar(20),
@Registro         varchar(20),
@Nombre           varchar(50),
@Paterno          varchar(50),
@Materno          varchar(50),
@Nacimiento       datetime,
@Sexo             varchar(50) = NULL,
@Estado varchar(50) = NULL

AS BEGIN
DECLARE @A  int,
@UnNombre varchar(50),
@Palabra varchar(50),
@NombreCompleto  varchar(255),
@CPaterno        char(1),
@CMaterno        char(1),
@CNombre         char(1)
SELECT @CPaterno = '',  @CMaterno ='',   @CNombre = ''
SELECT @Registro         = UPPER(NULLIF(NULLIF(RTRIM(@Registro),  '0'),  ''))
SELECT @Paterno          = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(NULLIF(NULLIF(RTRIM(@Paterno),   '0'),  '')), 'a', 'A'), 'É','E'), 'S', 'I'), '±', 'O'), '˜','U'), 'Ñ','X')
SELECT @Materno          = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(NULLIF(NULLIF(RTRIM(@Materno),   '0'),  '')), 'a', 'A'), 'É','E'), 'S', 'I'), '±', 'O'), '˜','U'), 'Ñ','X')
SELECT @Nombre           = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(NULLIF(NULLIF(RTRIM(@Nombre),    '0'),  '')), 'a', 'A'), 'É','E'), 'S', 'I'), '±', 'O'), '˜','U')
SELECT @Sexo             = UPPER(NULLIF(NULLIF(RTRIM(@Sexo),    '0'),  ''))
SELECT @Estado           = UPPER(NULLIF(NULLIF(RTRIM(@Estado),    '0'),  ''))
SELECT @NombreCompleto = LTRIM(RTRIM(@Nombre + ' ' + @Paterno + ' ' + @Materno))
EXEC spQuitaPreposicionesArticulos @Paterno OUTPUT
EXEC spQuitaPreposicionesArticulos @Materno OUTPUT
EXEC spQuitaPreposicionesArticulos @Nombre  OUTPUT
IF (@Cual='RFC' OR @Cual = 'CURP')  AND  @Nacimiento > '01-01-1910'
BEGIN
IF CHARINDEX(' ', @Nombre) > 0 
BEGIN
SELECT  @UnNombre = @Nombre
EXEC SPExtraerDato @UnNombre OUTPUT,  @Palabra OUTPUT,  ' '
IF @Palabra NOT IN('JOSE',  'MARIA')
SELECT @Nombre = @Palabra
ELSE  BEGIN
EXEC SPExtraerDato @UnNombre OUTPUT,  @Palabra OUTPUT,  ' '
SELECT @Nombre = @Palabra
END
END
IF LEN(@Paterno) = 0 OR LEN(@Materno) = 0 
SELECT @Registro = SUBSTRING(@Paterno,  1,  2) +  SUBSTRING(@Materno,  1,  2) +  SUBSTRING(@Nombre,   1,  2)
+ RIGHT(LTRIM(RTRIM( YEAR(@Nacimiento))) , 2) +  RIGHT('0' + LTRIM(MONTH(@Nacimiento))  , 2)
+ RIGHT('0' + LTRIM(  DAY(@Nacimiento))  , 2)
ELSE BEGIN
IF LEN(@Paterno) < 3 
SELECT @Registro = SUBSTRING(@Paterno,  1,  1) + SUBSTRING(@Materno,  1,  1) + SUBSTRING(@Nombre,   1,  2)
+ RIGHT(LTRIM(RTRIM(YEAR(@Nacimiento))) , 2) + RIGHT('0' + LTRIM(MONTH(@Nacimiento)) , 2)
+ RIGHT('0' + LTRIM(DAY(@Nacimiento)) , 2)
ELSE
IF  LEN(ISNULL(@Nombre, '')) > 0  AND LEN(ISNULL(@Registro, '')) < 10
BEGIN
SELECT @A=2
WHILE (SUBSTRING(@Paterno, @A, 1) not in('A', 'E', 'I', 'O', 'U')  AND @A < LEN(ISNULL(@Paterno, ''))+1)
SELECT @A=@A+1
SELECT @REGISTRO =    SUBSTRING(LTRIM(@Paterno), 1, 1)
+  SUBSTRING(LTRIM(@Paterno), @A, 1)
+  SUBSTRING(LTRIM(@Materno), 1, 1)
+  SUBSTRING(LTRIM(@Nombre), 1, 1)
+  RIGHT(LTRIM(RTRIM(YEAR(@Nacimiento))), 2)
+  RIGHT('0' + LTRIM(MONTH(@Nacimiento)), 2)
+  RIGHT('0' + LTRIM(DAY(@Nacimiento)), 2)
END
END
END
IF EXISTS( SELECT * FROM RFCAnexoIV WHERE Palabra = SUBSTRING(@Registro,  1,  4))
SELECT @Registro = SUBSTRING(@Registro,  1,  3) + 'X' + SUBSTRING(@Registro, 5,  99)
IF @Cual = 'RFC' AND LEN(@registro) <=10 
BEGIN
SELECT @Palabra = ''
SELECT @Registro = LEFT(@Registro, 10)
EXEC spRFCClaveHomonima @NombreCompleto,  @Palabra OUTPUT
SELECT @Registro = @Registro + @Palabra
EXEC spRFCDigitoVerificador @Registro,  @Palabra OUTPUT
SELECT @Registro = @Registro + @Palabra
END
IF @Cual = 'CURP' AND LEN(@Registro) <= 10 
BEGIN
IF @Sexo = 'Masculino' SELECT @Registro = @Registro + 'H' ELSE SELECT @Registro = @Registro + 'M'
SELECT @Registro = @Registro + (SELECT MIN(ISNULL(ClaveCURP,'')) FROM PaisEstado WHERE Estado LIKE ('%' + @Estado + '%'))
SELECT @A = 2
WHILE @A <= LEN(@Paterno) AND @CPaterno =''
BEGIN
IF SUBSTRING(@Paterno, @A, 1) not in('A',  'E',  'I',  'O',  'U')  SELECT @CPaterno = REPLACE(SUBSTRING(@Paterno, @A, 1), 'Ñ','X')
SELECT @A = @A + 1
END
SELECT @A = 2
WHILE @A <= LEN(@Materno)AND @CMaterno =''
BEGIN
IF SUBSTRING(@Materno, @A, 1) not in('A', 'E', 'I', 'O', 'U') SELECT @CMaterno = REPLACE(SUBSTRING(@Materno,  @A,  1), 'Ñ','X')
SELECT @A = @A + 1
END
SELECT @A = 2
WHILE @A <= LEN(@Nombre) AND @CNombre=''
BEGIN
IF SUBSTRING(@Nombre, @A, 1) not in('A', 'E', 'I', 'O', 'U')  SELECT @CNombre = REPLACE(SUBSTRING(@Nombre,  @A,  1), 'Ñ','X')
SELECT @A = @A + 1
END
IF @CPaterno = '' SELECT @CPaterno = 'X'
IF @CMaterno = '' SELECT @CMaterno = 'X'
IF @CNombre  = '' SELECT @CNombre  = 'X'
SELECT @Registro = @Registro + @CPaterno + @CMaterno + @CNombre + '0'
SELECT @Palabra  = ''
EXEC spCURPDigitoVerificador @Registro,  @Palabra OUTPUT
SELECT @Registro = @Registro + @Palabra
END
SELECT "Registro" = @Registro
RETURN
END

