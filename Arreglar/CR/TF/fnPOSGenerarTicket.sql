SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPOSGenerarTicket (
@Cadena		varchar(max),
@Caracter	nvarchar(20)
)
RETURNS @Tabla TABLE
(
ID		int IDENTITY(1,1),
Campo	varchar(max)
)

AS
BEGIN
DECLARE
@Contador int,
@Posicion int
SET @Contador = 1
SET @Posicion = CHARINDEX(@Caracter,@Cadena)
WHILE (@Posicion>0)
BEGIN
INSERT INTO @Tabla (Campo)
SELECT
Campo = RTRIM(SUBSTRING(@Cadena, 1, @Posicion - 1))
SET @Cadena = SUBSTRING(@Cadena, @Posicion + DATALENGTH(@Caracter) / 2, LEN(@Cadena))
SET @Contador = @Contador + 1
SET @Posicion = CHARINDEX(@Caracter, @Cadena)
END
INSERT intO @Tabla (Campo)
SELECT Campo = LTRIM(RTRIM(@Cadena))
RETURN
END

