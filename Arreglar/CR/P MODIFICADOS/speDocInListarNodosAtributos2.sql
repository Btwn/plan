SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocInListarNodosAtributos2
@Estacion		int,
@eDocIn			varchar(50)

AS BEGIN
DECLARE
@Xml        varchar(max),
@Xml2       xml
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON
SET QUOTED_IDENTIFIER ON
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_PADDING ON
SELECT @Xml = Documento FROM eDocIn WITH(NOLOCK) WHERE eDocIn = @eDocIn
SELECT @Xml2 = CONVERT(varchar(max),@Xml)
DELETE eDocInNodoAtributoTemp2 WHERE Estacion = @Estacion
EXEC spDocInXmlNSListarNodo @xml ,@Estacion
INSERT eDocInNodoAtributoTemp2(Estacion,  Nodo, NodoNombre, Ruta, CampoTipoxml, Atributo)
SELECT                        @Estacion, Nodo, NodoNombre, Nodo, 'NODO',       NULL
FROM eDocInNodoTemp WHERE Estacion = @Estacion
EXEC speDocInListaCompletaAtributos @Estacion, @XML2
INSERT eDocInNodoAtributoTemp2(Estacion,  Nodo,         NodoNombre, Ruta,         CampoTipoxml, Atributo)
SELECT                        @Estacion, AtributoRuta, Campo,      AtributoRuta+'@'+AtributoNombre, 'ATRIBUTO',   AtributoNombre
FROM eDocInAtributoTemp WHERE Estacion = @Estacion
SET ANSI_NULLS OFF
SET ANSI_WARNINGS OFF
SET QUOTED_IDENTIFIER OFF
SET CONCAT_NULL_YIELDS_NULL OFF
SET ANSI_PADDING OFF
END

