SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovOpcionVerificar
@Modulo			char(5),
@ID				int,
@Renglon		float,
@RenglonSub		int,
@Subcuenta		varchar(50),
@Ok             int          OUTPUT,
@OkRef          varchar(255) OUTPUT

AS BEGIN
DECLARE
@SQL			nvarchar(max),
@Select			varchar(max),
@Opciones		varchar(max),
@OpcionOriginal varchar(2),
@Opcion			varchar(2)
IF NULLIF(@Subcuenta,'') IS NULL RETURN
SELECT @Select = dbo.fnMovOpcionListaSeleccion(@Subcuenta, 1)
SELECT @Opciones = REPLACE(REPLACE(REPLACE(@Select, CHAR(39), ''), ',', ''), ' ', '')
SELECT @SQL = 'IF NOT EXISTS(SELECT * FROM tempdb.information_schema.tables WHERE TABLE_NAME LIKE '+ CHAR(39)+ '##TempMovOpcion%'+ CHAR(39) + ')
CREATE TABLE ##TempMovOpcion (Estacion int, Opcion varchar(255) COLLATE DATABASE_DEFAULT NULL)
ELSE
DELETE ##TempMovOpcion WHERE Estacion = @@SPID
INSERT ##TempMovOpcion SELECT @@SPID, Opcion FROM OpcionD WHERE Opcion IN (' + @Select + ') GROUP BY Opcion'
BEGIN TRY
EXEC sp_executesql @SQL
END TRY
BEGIN CATCH
SELECT @Ok = 1
END CATCH
DECLARE crOpcionOriginal CURSOR FAST_FORWARD FOR
SELECT CadenaOriginal
FROM dbo.fnTextoaTabla(@Opciones, 2)
OPEN crOpcionOriginal
FETCH NEXT FROM crOpcionOriginal INTO @OpcionOriginal
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @Opcion = NULL
DECLARE crOpcion CURSOR FAST_FORWARD FOR
SELECT Opcion
FROM ##TempMovOpcion
WHERE Estacion = @@SPID
AND Opcion = @OpcionOriginal
OPEN crOpcion
FETCH NEXT FROM crOpcion INTO @Opcion
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
FETCH NEXT FROM crOpcion INTO @Opcion
END
CLOSE crOpcion
DEALLOCATE crOpcion
IF @OpcionOriginal <> @Opcion
SELECT @Ok = 20041, @OkRef = @OpcionOriginal
FETCH NEXT FROM crOpcionOriginal INTO @OpcionOriginal
END
CLOSE crOpcionOriginal
DEALLOCATE crOpcionOriginal
IF EXISTS(SELECT * FROM tempdb.information_schema.tables WHERE TABLE_NAME LIKE '##TempMovOpcion%')
BEGIN
DELETE ##TempMovOpcion WHERE Estacion = @@SPID
IF NOT EXISTS(SELECT * FROM ##TempMovOpcion)
DROP TABLE ##TempMovOpcion
END
END

