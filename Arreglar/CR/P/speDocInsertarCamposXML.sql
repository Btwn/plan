SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocInsertarCamposXML
(
@Modulo			varchar(5),
@eDoc			varchar(50),
@IDSeccion		int
)

AS
BEGIN
DECLARE
@iDatos				int,
@XML				varchar(max),
@XMLSeccion			varchar(max),
@Seccion			varchar(50)
SELECT @XML = Documento FROM eDoc WHERE Modulo = @Modulo AND eDoc = @eDoc
SELECT @Seccion = Seccion FROM eDocD WHERE Modulo = @Modulo AND eDoc = @eDoc AND RID = @IDSeccion
SELECT @XMLSeccion = Datos FROM dbo.fneDocDocumentoASecciones(@Modulo, @eDoc) WHERE Nombre = @Seccion
DELETE FROM eDocDMapeoCampo WHERE Modulo = @Modulo AND eDoc = @eDoc AND IDSeccion = @IDSeccion
INSERT eDocDMapeoCampo (Modulo,  eDoc,  IDSeccion,  CampoXML)
SELECT  @Modulo, @eDoc, @IDSeccion, Campo
FROM dbo.fneDocCampoXMLTexto(@XMLSeccion)
END

