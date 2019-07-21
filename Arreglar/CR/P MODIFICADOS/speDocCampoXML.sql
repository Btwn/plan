SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocCampoXML
(
@Modulo			varchar(5),
@eDoc			varchar(50),
@Seccion		varchar(50)
)

AS
BEGIN
DECLARE
@iDatos				int,
@XML				varchar(max),
@XMLSeccion			varchar(max)
SELECT @XML = Documento FROM eDoc WITH(NOLOCK) WHERE Modulo = @Modulo AND eDoc = @eDoc
SELECT @XMLSeccion = Datos FROM dbo.fneDocDocumentoASecciones(@Modulo, @eDoc) WHERE Nombre = @Seccion
SELECT * FROM dbo.fneDocCampoXMLTexto(@XMLSeccion)
END

