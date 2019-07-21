SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocINInsertarRutaTablaDOmision
@eDocIn          varchar(50),
@Ruta            varchar(50),
@Tablas          varchar(50),
@Modulo          varchar(20),
@Ok              int OUTPUT,
@OkRef           varchar(255) OUTPUT

AS BEGIN
IF EXISTS(SELECT * FROM   eDocInRutaTablaDOmision WITH(NOLOCK) WHERE Modulo = @Modulo AND Tablas = @Tablas)
BEGIN
INSERT eDocInRutaTablaD (eDocIn,   Ruta,  Tablas,  CampoXML, ExpresionXML, CampoTabla, CampoXMLTipo, CampoXMLRuta, CampoXMLAtributo, CampoXMLTipoXML, EsIndependiente, EsConsecutivo, ConsecutivoNombre, ConsecutivoInicial, ConsecutivoIncremento, Traducir, TablaST)
SELECT                   @eDocIn,  @Ruta, @Tablas, Campo  , Expresion,    Campo,      TipoDatos,   NULL,         NULL,             NULL,            1,               0,             NULL,              NULL,               NULL,                  0,        NULL
FROM eDocInRutaTablaDOmision WITH(NOLOCK)
WHERE Modulo = @Modulo AND Tablas = @Tablas
EXCEPT
SELECT  eDocIn,   Ruta,  Tablas,  CampoXML, ExpresionXML, CampoTabla, CampoXMLTipo, CampoXMLRuta, CampoXMLAtributo, CampoXMLTipoXML, EsIndependiente, EsConsecutivo, ConsecutivoNombre, ConsecutivoInicial, ConsecutivoIncremento, Traducir, TablaST
FROM eDocInRutaTablaD WITH(NOLOCK)
WHERE eDocIn = @eDocIn AND Ruta = @Ruta AND Tablas = @Tablas
END
END

