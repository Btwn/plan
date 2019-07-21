SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSBObtenerFiltro
@Proceso	varchar(20)

AS
DECLARE
@Filtro		varchar(20),
@Tabla		varchar(20),
@Llave		varchar(20),
@Nombre		varchar(20),
@Tipo		varchar(10),
@ValorDefault	varchar(20),
@Campo		varchar(20),
@Activo		bit,
@Parentesis	bit,
@Variable	varchar(20),
@Orden		smallint,
@Cadena		varchar(500),
@Instruccion	varchar(8000),
@i		smallint
DECLARE SB_Cursor CURSOR FOR
SELECT  DISTINCT a.Filtro, a.Tabla, a.Llave, a.Nombre, a.Tipo, a.Activo, a.Orden, ISNULL(a.ValorDefault,''),Variable,Campo,Parentesis
FROM    SBFiltro a
WHERE   Activo = 1
AND Proceso = @Proceso
SET @i = 1
OPEN SB_Cursor
FETCH NEXT FROM SB_Cursor
INTO @Filtro, @Tabla, @Llave, @Nombre, @Tipo, @Activo, @Orden, @ValorDefault, @Variable, @Campo, @Parentesis
WHILE @@FETCH_STATUS = 0
BEGIN
SET @Cadena = "SELECT 'Campo'= '" + @Campo + "','Valor'="
IF @Tipo = 'CHAR'
IF @Parentesis = 1
SET @Cadena = @Cadena + "'('+" + "RTRIM(" + @Llave + ")"     + "+')',"
ELSE IF @Nombre IS NULL
SET @Cadena = @Cadena + "RTRIM(" + @Llave + ") ,"
ELSE
SET @Cadena = @Cadena + "RTRIM(" + @Llave + ") + ' - ' + ISNULL(" + @Nombre + ",''),"
ELSE
SET @Cadena = @Cadena + "REPLICATE(' ',6 - LEN(RTRIM(CONVERT(varchar(5)," + @Llave + ")))) + RTRIM(CONVERT(varchar(5)," + @Llave + ")) + ' - ' + ISNULL(" + @Nombre + ",''),"
SET @Cadena = @Cadena + "'Orden' = " + CONVERT(VARCHAR(3),@Orden) + ","
SET @Cadena = @Cadena + "'Etiqueta' = '" + @Filtro + "',"
SET @Cadena = @Cadena + "'Grupo' = '" + CONVERT(VARCHAR(2),@Parentesis) + "',"
SET @Cadena = @Cadena + "'ValorDefault' = '" + @ValorDefault + "' FROM " + @Tabla
IF @Variable IS NOT NULL
SET @Cadena = @Cadena + " WHERE " + @Variable
IF @i = 1
SET @Instruccion = @Cadena
ELSE
SET @Instruccion = @Instruccion + ' UNION ' + @Cadena
SET @i = @i + 1
FETCH NEXT FROM SB_Cursor
INTO @Filtro,@Tabla,@Llave,@Nombre,@Tipo,@Activo,@Orden, @ValorDefault, @Variable, @Campo, @Parentesis
END
CLOSE SB_Cursor
DEALLOCATE SB_Cursor
SET @Instruccion = @Instruccion + ' ORDER BY Orden'
EXEC (@Instruccion)

