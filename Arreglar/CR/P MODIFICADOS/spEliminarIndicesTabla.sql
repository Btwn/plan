SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spEliminarIndicesTabla @tablename varchar(30)

AS BEGIN
DECLARE
@a		  int,
@Indice 	  varchar(100),
@Eliminando  varchar(255),
@Nombre	  varchar(255)
SELECT @a = 0
DECLARE crIndices CURSOR FOR SELECT i.name FROM sysindexes i , sysobjects o WHERE o.name = @tablename AND o.id = i.id AND i.impid<>-1
OPEN crIndices
FETCH NEXT FROM crIndices  INTO @Indice
WHILE (@@fetch_status <> -1)
BEGIN
IF (@@fetch_status <> -2)
BEGIN
SELECT @a = @a +1
IF @a > 1 AND SUBSTRING(@Indice,1, 1) <> '_'
BEGIN
SELECT @Nombre = "dbo." + RTRIM(@tablename) + '.' + RTRIM(@Indice)
SELECT @Eliminando = "Eliminando Indice: " + @Nombre
PRINT @Eliminando
SELECT @Nombre = "DROP INDEX "+@Nombre
EXEC (@Nombre)
END
END
FETCH NEXT FROM crIndices  INTO @Indice
END
CLOSE crIndices
DEALLOCATE crIndices
END

