SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fneDocDocumentoASecciones
(
@Modulo				varchar(5),
@eDoc				varchar(50)
)
RETURNS @Seccion TABLE
(
Nombre			varchar(50),
Datos			varchar(max)
)

AS BEGIN
DECLARE
@SeccionNombre			varchar(50),
@XML					varchar(max),
@PosicionInicial		bigint,
@PosicionFinal			bigint,
@SeccionLongitud		bigint
SELECT @XML = Documento FROM eDoc WHERE Modulo = @Modulo AND eDoc = @eDoc
DECLARE creDocD CURSOR FOR
SELECT RTRIM(ISNULL(Seccion,''))
FROM eDocD
WHERE Modulo = @Modulo
AND eDoc = @eDoc
ORDER BY Orden
OPEN creDocD
FETCH NEXT FROM creDocD INTO @SeccionNombre
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @PosicionInicial  = ISNULL(PATINDEX('%' + '{' + @SeccionNombre + '}%',@XML),0) + LEN(@SeccionNombre) + 2 
SELECT @PosicionFinal    = ISNULL(PATINDEX('%' + '{/' + @SeccionNombre + '}%',@XML),0)
SELECT @SeccionLongitud = @PosicionFinal - @PosicionInicial
IF @SeccionLongitud > 0
INSERT @Seccion (Nombre, Datos) VALUES (@SeccionNombre,SUBSTRING(@XML,@PosicionInicial,@SeccionLongitud))
FETCH NEXT FROM creDocD INTO @SeccionNombre
END
CLOSE creDocD
DEALLOCATE creDocD
RETURN
END

