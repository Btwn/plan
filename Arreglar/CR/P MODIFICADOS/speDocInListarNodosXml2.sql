SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocInListarNodosXml2
@Estacion	int,
@eDocIn         varchar(50)

AS BEGIN
DECLARE
@Xml varchar(max)
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON
SET QUOTED_IDENTIFIER ON
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_PADDING ON
DELETE FROM eDocInNodoTemp WHERE Estacion = @Estacion
SELECT @Xml = Documento FROM eDocIn WITH(NOLOCK) WHERE eDocIn = @eDocIn
EXEC spDocInXmlNSListarNodo @xml ,@Estacion
SET ANSI_NULLS OFF
SET ANSI_WARNINGS OFF
SET QUOTED_IDENTIFIER OFF
SET CONCAT_NULL_YIELDS_NULL OFF
SET ANSI_PADDING OFF
END

