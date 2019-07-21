SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speCommerceRegenerarTablas

AS BEGIN
IF EXISTS(SELECT * FROM Sucursal WHERE eCommerce = 1 AND NULLIF(eCommerceSucursal,'') IS NOT NULL)
BEGIN
DELETE eCommerceRegenerar
INSERT eCommerceRegenerar(Regenerando) VALUES(1)
EXEC spSetInformacionContexto 'ECOMMERCE', 1
IF EXISTS (SELECT * FROM WebArt)
UPDATE WebArt SET Orden = Orden
IF EXISTS (SELECT * FROM WebArtAtributos)
UPDATE WebArtAtributos SET Nombre = Nombre
IF EXISTS (SELECT * FROM WebArtAtributosCat)
UPDATE WebArtAtributosCat SET Tipo = Tipo
IF EXISTS (SELECT * FROM WebArtAtributosCatD)
UPDATE  WebArtAtributosCatD SET  Tipo = Tipo
IF EXISTS (SELECT * FROM WebArtAtributosCatDTemp)
UPDATE WebArtAtributosCatDTemp SET  Tipo = Tipo
IF EXISTS (SELECT * FROM WebArtAtributosCatTemp)
UPDATE WebArtAtributosCatTemp SET  Tipo = Tipo
IF EXISTS (SELECT * FROM WebArtCamposConfigurables)
UPDATE WebArtCamposConfigurables SET  Nombre = Nombre
IF EXISTS (SELECT * FROM WebArtCamposConfigurablesCat)
UPDATE WebArtCamposConfigurablesCat SET  Tipo = Tipo
IF EXISTS (SELECT * FROM WebArtCamposConfigurablesCatD)
UPDATE WebArtCamposConfigurablesCatD SET    Tipo = Tipo
IF EXISTS (SELECT * FROM WebArtCamposConfigurablesCatDD)
UPDATE WebArtCamposConfigurablesCatDD SET  Tipo = Tipo
IF EXISTS (SELECT * FROM WebArtCamposConfigurablesD)
UPDATE WebArtCamposConfigurablesD SET  Orden =  Orden
IF EXISTS (SELECT * FROM WebArtDescripcion)
UPDATE WebArtDescripcion SET  DescripcionHTML = DescripcionHTML
IF EXISTS (SELECT * FROM WebArtMarca)
UPDATE WebArtMarca SET  Orden =  Orden
IF EXISTS (SELECT * FROM WebArtOpcion)
UPDATE WebArtOpcion SET  Orden =  Orden
IF EXISTS (SELECT * FROM WebArtOpcionValor)
UPDATE WebArtOpcionValor SET  Orden =  Orden
IF EXISTS (SELECT * FROM WebArtVariacion)
UPDATE WebArtVariacion SET   Orden =  Orden
IF EXISTS (SELECT * FROM WebArtVariacionCombinacion)
UPDATE WebArtVariacionCombinacion SET  Orden =  Orden
IF EXISTS (SELECT * FROM WebArtVariacionCombinacionD)
UPDATE WebArtVariacionCombinacionD SET IDValor = IDValor
IF EXISTS (SELECT * FROM WebArtVideo)
UPDATE WebArtVideo SET  Orden =  Orden
IF EXISTS (SELECT * FROM WebCatArt)
UPDATE WebCatArt  SET  Orden = Orden
IF EXISTS (SELECT * FROM WebCatArt_Art)
UPDATE WebCatArt_Art SET   Orden = Orden
IF EXISTS (SELECT * FROM WebPais)
UPDATE WebPais SET Nombre = Nombre
IF EXISTS (SELECT * FROM WebPaisEstado)
UPDATE WebPaisEstado SET  Nombre = Nombre
IF EXISTS (SELECT * FROM WebSituacion)
UPDATE WebSituacion SET  Nombre = Nombre
IF EXISTS (SELECT * FROM WebSituacionEstatus)
UPDATE WebSituacionEstatus SET  Modulo =  Modulo
IF EXISTS (SELECT * FROM WebUsuarios)
UPDATE WebUsuarios SET  Cliente =  Cliente
IF EXISTS (SELECT * FROM WebSucursalImagen)
UPDATE WebSucursalImagen SET  Orden = Orden
IF EXISTS (SELECT * FROM WebArtImagen)
UPDATE WebArtImagen SET  Orden =  Orden
IF EXISTS(SELECT * FROM Sucursal)
UPDATE Sucursal SET  Nombre = Nombre
IF EXISTS(SELECT * FROM eCommerceMetodoEnvioCfg)
UPDATE eCommerceMetodoEnvioCfg SET  Nombre = Nombre
EXEC spSetInformacionContexto 'ECOMMERCE', 0
DELETE eCommerceRegenerar
SELECT 'Se Regeneraron Las Tablas de eCommerce'
END
ELSE
SELECT  'No Esta Configurada Ninguna Sucursal eCommerce'
RETURN
END

