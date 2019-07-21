SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISeCommerceWebArt
@ID			int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok			int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
SET nocount ON
DECLARE
@IDArticulo		int,
@Estatus		varchar(10),
@Empresa              varchar(5),
@Sucursal             int,
@eCommerceSucursal    varchar(10),
@ReferenciaIS         varchar(100),
@Tabla                varchar(max) ,
@Resultado2		varchar(max) ,
@ListaPrecios         varchar(20),
@CfgImpuestoIncluido	float,
@Articulo             varchar(20),
@Precio               float,
@Usuario              varchar(10),
@SKU					varchar(255),
@EnvolturaIDS			varchar(max),
@Impuestos			float
SELECT @Usuario = WebUsuario
FROM WebVersion
SELECT @Empresa = Empresa,
@IDArticulo = IDArticulo,
@Sucursal = Sucursal,
@eCommerceSucursal = eCommerceSucursal,
@Estatus = Estatus
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/WebArt')
WITH (Empresa varchar(5), IDArticulo int, Sucursal int, eCommerceSucursal  varchar(10), Estatus varchar(10))
SELECT @ListaPrecios = ISNULL(eCommerceListaPrecios,'(Precio Lista)'), @CfgImpuestoIncluido = ISNULL(eCommerceImpuestoIncluido, 1)
FROM Sucursal WHERE Sucursal = @Sucursal
SELECT @Articulo  = Articulo
FROM  WebArt
WHERE ID  = @IDArticulo
SELECT @Precio  = CASE WHEN @ListaPrecios = '(Precio Lista)' THEN PrecioLista
WHEN @ListaPrecios = '(Precio 2)' THEN ISNULL(Precio2,PrecioLista)
WHEN @ListaPrecios = '(Precio 3)' THEN ISNULL(Precio3,PrecioLista)
WHEN @ListaPrecios = '(Precio 4)' THEN ISNULL(Precio4,PrecioLista)
WHEN @ListaPrecios = '(Precio 5)' THEN ISNULL(Precio5,PrecioLista)
WHEN @ListaPrecios = '(Precio 6)' THEN ISNULL(Precio6,PrecioLista)
WHEN @ListaPrecios = '(Precio 7)' THEN ISNULL(Precio7,PrecioLista)
WHEN @ListaPrecios = '(Precio 8)' THEN ISNULL(Precio8,PrecioLista)
WHEN @ListaPrecios = '(Precio 9)' THEN ISNULL(Precio9,PrecioLista)
WHEN @ListaPrecios = '(Precio 10)' THEN ISNULL(Precio10,PrecioLista) END
FROM Art
WHERE Articulo = @Articulo
SELECT @SKU = ISNULL(NULLIF(SKU,''),'ID#'+CONVERT(varchar(10),ID)) FROM WebArt WHERE ID = @IDArticulo
EXEC spDesglosarPrecioCImpuestos  @Articulo, @Usuario, @Empresa, @Sucursal, @Precio OUTPUT, NULL, NULL, NULL, NULL, NULL, NULL, @Impuestos OUTPUT
IF(@CfgImpuestoIncluido = 1)
SELECT @Impuestos = 0.00
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
EXEC spWebArtEnvolturas @IDArticulo, @Sucursal, @EnvolturaIDS OUTPUT
IF @Estatus IN ('ALTA','CAMBIO')
SELECT @Tabla = (SELECT  ISNULL(CONVERT(varchar,ID),'')ID,ISNULL(CONVERT(varchar,ISNULL(Orden,0)),'')Orden,ISNULL(Nombre,'')Nombre,ISNULL(CONVERT(varchar,ISNULL(EsDigital,0)),'')EsDigital,ISNULL(Archivo,'')Archivo,+@SKU SKU, ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(4000),DescripcionHTML)),'')DescripcionHTML,ISNULL(PalabrasBusqueda,'')PalabrasBusqueda,ISNULL(Disponibilidad,'')Disponibilidad,ISNULL(CONVERT(varchar,ISNULL(@Precio,0.0)),'')Precio,ISNULL(CONVERT(varchar,ISNULL(Costo,0.0)),'')Costo,ISNULL(CONVERT(varchar,ISNULL(PrecioMenudeo,0.0)),'')PrecioMenudeo,ISNULL(CONVERT(varchar,ISNULL(PrecioOferta,0.0)),'')PrecioOferta,ISNULL(CONVERT(varchar,PrecioCImpuesto),'')PrecioCImpuesto,ISNULL(CONVERT(varchar,Visible),'')Visible,ISNULL(CONVERT(varchar,Destacado),'')Destacado, ISNULL(CONVERT(varchar,DestacadoProv),'')DestacadoProv,ISNULL(ArtRelacionados,'')ArtRelacionados,ISNULL(CONVERT(varchar,OpcionesReq),'')OpcionesReq,ISNULL(Garantia,'')Garantia,ISNULL(CONVERT(varchar,Peso),'')Peso,ISNULL(CONVERT(varchar,Ancho),'')Ancho,ISNULL(CONVERT(varchar,Alto),'')Alto,ISNULL(CONVERT(varchar,Largo),'')Largo,ISNULL(CONVERT(varchar,CostoEnvioFijo),'')CostoEnvioFijo, ISNULL(CONVERT(varchar,EnvioGratis),'')EnvioGratis,ISNULL(CONVERT(varchar,FechaAlta),'')FechaAlta,ISNULL(CONVERT(varchar,MarcaID),'')MarcaID,ISNULL(TituloPagina,'')TituloPagina,ISNULL(MetaKeyWords,'')MetaKeyWords,ISNULL(Metadesc,'')Metadesc,ISNULL(Layout,'')Layout,ISNULL(CONVERT(varchar,VariacionID),'')VariacionID,ISNULL(CONVERT(varchar,PermiteCompra),'')PermiteCompra,ISNULL(CONVERT(varchar,OcultarPrecio),'')OcultarPrecio,ISNULL(TelefonoPrecios,'')TelefonoPrecios,ISNULL(CategoriaIDS,'')CategoriaIDS,ISNULL(CONVERT(varchar,UltimoCambio),'')UltimoCambio,ISNULL(CONVERT(varchar,FechaLanzamiento),'')FechaLanzamiento,ISNULL(UPC,'')UPC,ISNULL(CONVERT(varchar,DesHabilitarGoogle),'')DesHabilitarGoogle,ISNULL(Articulo,'')Articulo,ISNULL(SubCuenta,'')SubCuenta,ISNULL(CONVERT(varchar,Categoria1),'')Categoria1,ISNULL(Unidad,'')Unidad,ISNULL(SerieLote,'')SerieLote,ISNULL(CONVERT(varchar,Cantidad),'')Cantidad,ISNULL(dbo.fnWebArtEstausExistencia(@SKU,@Sucursal),'')Situacion,ISNULL(CONVERT(varchar,@EnvolturaIDS),'')EnvolturaIDS,ISNULL(CONVERT(varchar,@Impuestos),'')Impuestos FROM WebArt  WHERE ID = @IDArticulo FOR XML AUTO)
ELSE   SELECT @Tabla = ''
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia="WebArt" Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) +' Empresa=' + CHAR(34) + ISNULL(@Empresa,'') + CHAR(34)+ ' Sucursal=' + CHAR(34) + ISNULL(CONVERT(varchar,@Sucursal),'') + CHAR(34)+' eCommerceSucursal=' + CHAR(34) + ISNULL(@eCommerceSucursal,'') + CHAR(34)+ ' Estatus=' + CHAR(34) + ISNULL(@Estatus,'') + CHAR(34) +' IDArticulo=' + CHAR(34) + CONVERT(varchar,ISNULL(@IDArticulo,'')) + CHAR(34) +' >' +ISNULL(@Tabla,'')+'</Resultado></Intelisis>'
END

