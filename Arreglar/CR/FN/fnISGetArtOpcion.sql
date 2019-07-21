SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnISGetArtOpcion
(
@Articulo    varchar(20),
@Agente      varchar(100) = NULL,
@GUID		 varchar(50)
)
RETURNS XML
AS
BEGIN
DECLARE
@Empresa char(5),
@sXListaPrecios varchar(max),
@XMLArt XML,
@XOpciones XML,
@XOpcion XML,
@XListaPrecios XML,
@XDetalle XML,
@XTasa XML,
@sXTasa varchar(max),
@Parcial  varchar(max)
DECLARE @Lista TABLE(ID int identity(1,1),Lista varchar(100))
SELECT @Empresa = Empresa
FROM MovilUsuarioCfg
WHERE Agente = @Agente
SELECT @XMLArt = (
SELECT Articulos.Articulo,REPLACE(Articulos.Descripcion1,':','')AS Descripcion1, REPLACE(Articulos.Descripcion2,':','')AS Descripcion2, REPLACE(Articulos.Categoria,':','')AS Categoria,
Articulos.Unidad, Articulos.ImpuestoExento, REPLACE(Articulos.Tipo,':','')AS Tipo, Articulos.MonedaPrecio, REPLACE(Articulos.Almacen,':','')AS Almacen, Articulos.Disponible,
REPLACE(Articulos.Grupo,':','')AS Grupo, REPLACE(Articulos.Linea,':','')AS Linea, REPLACE(Articulos.Familia,':','')AS Familia, Articulos.PrecioLista,
TasaIVA,Articulos.Estatus, Articulos.Existencia, ArtJuego.Clave, ArtJuego.Descripcion
FROM (
SELECT DISTINCT Articulo.Articulo Articulo,
ISNULL(Articulo.Descripcion1, ' ') Descripcion1,
ISNULL(Articulo.Descripcion2, ' ') Descripcion2,
ISNULL(Articulo.Categoria,	   ' ') Categoria,
ISNULL(Articulo.Unidad,	   ' ') Unidad,
ISNULL(Articulo.Tipo,		   ' ') Tipo,
ISNULL(Articulo.MonedaPrecio, ' ') MonedaPrecio,
ISNULL(Articulo.Impuesto1Excento,   '0') ImpuestoExento,
ISNULL(Oferta.Almacen,        ' ') Almacen,
CAST(CAST(ISNULL(ArtDisponible.Disponible,  ' ') AS DECIMAL(18, 2)) AS VARCHAR(15)) Disponible,
ISNULL(Articulo.Grupo,		   ' ') Grupo,
ISNULL(Articulo.Linea,		   ' ') Linea,
ISNULL(Articulo.Familia,	   ' ') Familia,
ISNULL(Articulo.PrecioLista,  ' ') PrecioLista,
CAST(CAST(ISNULL(Articulo.Impuesto1,    ' ') AS DECIMAL(18, 2)) AS VARCHAR(15)) TasaIVA,
ISNULL(Articulo.Estatus,	   ' ') Estatus,
CAST(CAST(ISNULL(ArtDisponible.Existencias,   ' ') AS DECIMAL(18, 2)) AS VARCHAR(15)) Existencia
FROM Art Articulo
JOIN OfertaMovilTemp Oferta      ON Articulo.Articulo = Oferta.Articulo AND Articulo.Articulo = @Articulo
LEFT JOIN ArtExistenciaReservado ArtDisponible ON Articulo.Articulo = ArtDisponible.Articulo AND ArtDisponible.Empresa = @Empresa AND ArtDisponible.Almacen = Oferta.Almacen
WHERE Oferta.GUID = @GUID
)AS Articulos
LEFT JOIN (
SELECT Aj.Articulo, AD.Opcion Clave, Aj.Descripcion
FROM ArtJuego Aj
JOIN ArtJuegoD  AD ON Aj.Articulo = AD.Articulo AND Aj.Juego = AD.Juego
) AS ArtJuego ON Articulos.Articulo = ArtJuego.Articulo
FOR XML AUTO, TYPE, ELEMENTS
)
SET @XOpciones = '<ArtOpciones/>'
DECLARE @Opcion char, @Descripcion varchar(100)
DECLARE @Numero int, @Nombre varchar(100)
DECLARE Opcion_cursor CURSOR FOR
SELECT Opcion,Descripcion
FROM
(SELECT Top 2 Op.Opcion, Op.Descripcion,ao.Orden
FROM ArtOpcion AO
JOIN Opcion Op ON AO.Opcion = Op.Opcion
WHERE AO.Articulo = @Articulo
ORDER BY ao.Orden, Op.Descripcion) Opciones
ORDER BY Orden DESC, Descripcion DESC
OPEN Opcion_cursor
FETCH NEXT FROM Opcion_cursor
INTO @Opcion, @Descripcion
WHILE @@FETCH_STATUS = 0
BEGIN
SET @Descripcion = REPLACE(@Descripcion,'/','')
SET @Descripcion = REPLACE(@Descripcion,':','')
SELECT @XOpcion = '<' + replace(@Descripcion, ' ', '_') + '/>'
IF NOT EXISTS(SELECT Articulo FROM ArtOpcionD WHERE Opcion = @Opcion and Articulo = @Articulo)
BEGIN
DECLARE Detalle_cursor CURSOR FOR
SELECT AD.Numero, AD.Nombre
FROM ArtOpcion AO
JOIN Opcion ArtOpciones ON AO.Opcion = ArtOpciones.Opcion
JOIN OpcionD AD ON AO.Opcion = AD.Opcion
WHERE AO.Opcion = @Opcion and AO.Articulo = @Articulo
GROUP BY AD.Numero, AD.Nombre
ORDER BY AD.Numero
END
ELSE
BEGIN
DECLARE Detalle_cursor CURSOR FOR
SELECT AD.Numero, AD.Nombre
FROM ArtOpcionD AO
JOIN Opcion ArtOpciones ON AO.Opcion = ArtOpciones.Opcion
JOIN OpcionD AD ON AO.Opcion = AD.Opcion AND AO.Numero = AD.Numero
WHERE AO.Opcion = @Opcion and AO.Articulo = @Articulo
GROUP BY AD.Numero, AD.Nombre
ORDER BY AD.Nombre
END
OPEN Detalle_cursor
FETCH NEXT FROM Detalle_cursor
INTO @Numero, @Nombre
WHILE @@FETCH_STATUS = 0
BEGIN
SET @Nombre = REPLACE(@Nombre,'&','')
SELECT @XDetalle = '<' + @Opcion + CAST(@Numero as varchar(10)) + '>' + dbo.Replace4XML(@Nombre) + '</' + @Opcion + CAST(@Numero as varchar(10)) + '>'
SET @XOpcion.modify('insert <XDetalleTemp/> as first into /*[1]')
SET @XOpcion = CAST( REPLACE( CAST(@XOpcion AS VARCHAR(MAX)), '<XDetalleTemp/>', CAST(@XDetalle AS VARCHAR(MAX))) AS XML)
FETCH NEXT FROM Detalle_cursor
INTO @Numero, @Nombre
END
CLOSE Detalle_cursor
DEALLOCATE Detalle_cursor
SET @XOpciones.modify('insert <XOpcionTemp/> as first into /*[1]')
SET @XOpciones = CAST( REPLACE( CAST(@XOpciones AS VARCHAR(MAX)), '<XOpcionTemp/>', CAST(@XOpcion AS VARCHAR(MAX))) AS XML)
FETCH NEXT FROM Opcion_cursor
INTO @Opcion, @Descripcion
END
CLOSE Opcion_cursor;
DEALLOCATE Opcion_cursor;
INSERT @Lista(Lista)
SELECT '<' + dbo.Replace4XML(Oferta.ListaPrecios) + '>'
+ CAST(ISNULL(CAST(Oferta.Precio as decimal(18,2)), '0.00') AS VARCHAR(100))
+ '</' + dbo.Replace4XML(Oferta.ListaPrecios) + '>'
FROM OfertaMovilTemp Oferta
LEFT JOIN Art Articulo ON Oferta.Articulo = Articulo.Articulo
WHERE Oferta.Articulo = @Articulo and Oferta.GUID = @GUID
GROUP BY '<' + dbo.Replace4XML(Oferta.ListaPrecios) + '>'
+ CAST(ISNULL(CAST(Oferta.Precio as decimal(18,2)), '0.00') AS VARCHAR(100))
+ '</' + dbo.Replace4XML(Oferta.ListaPrecios) + '>'
IF @@Version LIKE '%2005%' OR @@Version LIKE '%2008%' OR @@Version LIKE '%2012%' OR @@Version LIKE '%2014%' OR @@Version LIKE '%2016%'
BEGIN
SET @sXListaPrecios = ''
DECLARE Precios_cursor CURSOR FOR
SELECT Lista
FROM @Lista
OPEN Precios_cursor
FETCH NEXT FROM Precios_cursor
INTO @Parcial
WHILE @@FETCH_STATUS = 0
BEGIN
SET @sXListaPrecios = @sXListaPrecios + @Parcial
FETCH NEXT FROM Precios_cursor
INTO @Parcial
END
CLOSE Precios_cursor;
DEALLOCATE Precios_cursor;
END
ELSE
BEGIN
SELECT @sXListaPrecios = dbo.clrconcatenate(Lista) FROM @Lista
END
SET @sXListaPrecios = '<ListaPrecios>' + @sXListaPrecios + '</ListaPrecios>'
SET @XListaPrecios = CAST(REPLACE(REPLACE(REPLACE(@sXListaPrecios, '(', ''), ')', ''), '-', '') AS XML)
SELECT @sXTasa = '<TasaIVAZona>'
SELECT @sXTasa = @sXTasa + '<' + dbo.Replace4XML('Z'+ZI.Zona) + '>' + CAST(ZI.Porcentaje AS VARCHAR(10)) + '</' + dbo.Replace4XML('Z'+ZI.Zona) + '>'
FROM ZonaImp ZI
JOIN Art A ON ZI.Impuesto = A.Impuesto1
WHERE A.Articulo = @Articulo
SELECT @sXTasa = @sXTasa + '</TasaIVAZona>'
SET @XTasa = CAST(REPLACE(REPLACE(REPLACE(@sXTasa, '(', ''), ')', ''), '-', '') AS XML)
SET @XMLArt.modify('insert <XOpcionesATemp/> as first into /*[1]')
SET @XMLArt = CAST( REPLACE( CAST(@XMLArt AS VARCHAR(MAX)), '<XOpcionesATemp/>', CAST(@XOpciones AS VARCHAR(MAX))) AS XML)
SET @XMLArt.modify('insert <XListaPreciosTemp/> as first into /*[1]')
SET @XMLArt = CAST( REPLACE( CAST(@XMLArt AS VARCHAR(MAX)), '<XListaPreciosTemp/>', CAST(@XListaPrecios AS VARCHAR(MAX))) AS XML)
SET @XMLArt.modify('insert <XTasaTemp/> as first into /*[1]')
SET @XMLArt = CAST( REPLACE( CAST(@XMLArt AS VARCHAR(MAX)), '<XTasaTemp/>', CAST(@XTasa AS VARCHAR(MAX))) AS XML)
RETURN @XMLArt
END

