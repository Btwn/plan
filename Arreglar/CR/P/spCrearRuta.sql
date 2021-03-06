SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCrearRuta
(
@Ruta				varchar(255),
@Ok					int = NULL OUTPUT,
@OkRef				varchar(255) = NULL OUTPUT
)

AS
BEGIN
DECLARE
@Directorio				varchar(255)
DECLARE crDirectorios CURSOR FOR
SELECT Directorio
FROM dbo.fnFragmentarRuta(@Ruta)
OPEN crDirectorios
FETCH NEXT FROM crDirectorios INTO @Directorio
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
EXEC spCrearDirectorio @Directorio, @Ok OUTPUT, @OkRef OUTPUT
FETCH NEXT FROM crDirectorios INTO @Directorio
END
CLOSE crDirectorios
DEALLOCATE crDirectorios
END

