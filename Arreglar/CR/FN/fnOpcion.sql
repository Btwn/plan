SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnOpcion (@SubCuenta VARCHAR(200))
RETURNS VARCHAR(200) AS
BEGIN
DECLARE @iPuntero	int,
@iLongitud	int,
@strToken	VARCHAR(200),
@strNombre	VARCHAR(200),
@strTitulo 	VARCHAR(20),
@strNumero 	VARCHAR(10),
@strLetra 	VARCHAR(1)
SET @iLongitud = LEN(RTRIM(@SubCuenta))
SET @iPuntero = 1
SET @strToken = CHAR(32)
SET @strTitulo = CHAR(32)
SET @strLetra = CHAR(32)
SET @strNumero = CHAR(32)
WHILE @iPuntero <= @iLongitud
BEGIN
IF dbo.fnEsNumerico(SUBSTRING(@SubCuenta,@iPuntero,1))=0
BEGIN
IF @iPuntero > 1
BEGIN
SELECT @strTitulo=RTRIM(Descripcion)
FROM Opcion
WHERE Opcion = @strLetra
SELECT @strNombre=Nombre
FROM OpcionD
WHERE Opcion=@strLetra
AND Numero = CONVERT(INT,@strNumero)
SET @strToken=@strToken+@strTitulo+CHAR(32) +@strNombre+CHAR(32)
SET @strNumero = CHAR(32)
END
SET @strLetra=SUBSTRING(@SubCuenta,@iPuntero,1)
END
ELSE
SET @strNumero=@strNumero+SUBSTRING(@SubCuenta,@iPuntero,1)
SET @iPuntero=@iPuntero+1
END
SELECT @strTitulo=RTRIM(Descripcion)
FROM Opcion
WHERE Opcion=@strLetra
SELECT @strNombre=Nombre
FROM OpcionD
WHERE Opcion=@strLetra
AND Numero = CONVERT(INT,@strNumero)
SET @strToken =	@strToken+@strTitulo+CHAR(32)+@strNombre+CHAR(32)
RETURN(LTRIM(@strToken))
END

