SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISeCommercePrecio
@ID			int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok			int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@PrecioID             int,
@Estatus		varchar(10),
@Empresa              varchar(5),
@Sucursal             int,
@eCommerceSucursal     varchar(10),
@ReferenciaIS         varchar(100),
@Tabla                varchar(max) ,
@Resultado2		varchar(max)
SELECT @Empresa = Empresa,
@PrecioID= PrecioID ,
@Sucursal = Sucursal,
@eCommerceSucursal = eCommerceSucursal,
@Estatus = Estatus
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/Precio')
WITH (Empresa varchar(5),  Sucursal int, eCommerceSucursal  varchar(10), Estatus varchar(10),  PrecioID int)
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @Estatus IN ('ALTA','CAMBIO')
SELECT @Tabla = '<Precio '+(SELECT   ' ID="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.ID)),'')+'"'+  ' Descripcion="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.Descripcion),'')+'"'+  ' Estatus="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.Estatus),'')+'"'+  ' UltimoCambio="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.UltimoCambio)),'')+'"'+  ' NivelArticulo="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.NivelArticulo)),'')+'"'+  ' Articulo="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.Articulo),'')+'"'+  ' NivelSubCuenta="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.NivelSubCuenta)),'')+'"'+  ' SubCuenta="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.SubCuenta),'')+'"'+  ' NivelArtGrupo="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.NivelArtGrupo)),'')+'"'+  ' ArtGrupo="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.ArtGrupo),'')+'"'+  ' NivelArtCat="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.NivelArtCat)),'')+'"'+  ' ArtCat="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.ArtCat),'')+'"'+  ' NivelArtFam="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.NivelArtFam)),'')+'"'+  ' ArtFam="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.ArtFam),'')+'"'+  ' NivelArtABC="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.NivelArtABC)),'')+'"'+  ' ArtABC="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.ArtABC),'')+'"'+  ' NivelFabricante="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.NivelFabricante)),'')+'"'+  ' Fabricante="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.Fabricante),'')+'"'+  ' NivelCliente="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.NivelCliente)),'')+'"'+  ' Cliente="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.Cliente),'')+'"'+  ' NivelCteGrupo="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.NivelCteGrupo)),'')+'"'+  ' CteGrupo="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.CteGrupo),'')+'"'+  ' NivelCteCat="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.NivelCteCat)),'')+'"'+  ' CteCat="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.CteCat),'')+'"'+  ' NivelCteFam="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.NivelCteFam)),'')+'"'+  ' CteFam="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.CteFam),'')+'"'+  ' NivelCteZona="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.NivelCteZona)),'')+'"'+  ' CteZona="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.CteZona),'')+'"'+  ' NivelMoneda="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.NivelMoneda)),'')+'"'+  ' Moneda="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.Moneda),'')+'"'+  ' NivelCondicion="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.NivelCondicion)),'')+'"'+  ' Condicion="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.Condicion),'')+'"'+  ' NivelAlmacen="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.NivelAlmacen)),'')+'"'+  ' Almacen="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.Almacen),'')+'"'+  ' NivelProyecto="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.NivelProyecto)),'')+'"'+  ' Proyecto="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.Proyecto),'')+'"'+  ' NivelAgente="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.NivelAgente)),'')+'"'+  ' Agente="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.Agente),'')+'"'+  ' NivelFormaEnvio="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.NivelFormaEnvio)),'')+'"'+  ' FormaEnvio="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.FormaEnvio),'')+'"'+  ' NivelMov="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.NivelMov)),'')+'"'+  ' Mov="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.Mov),'')+'"'+  ' NivelServicioTipo="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.NivelServicioTipo)),'')+'"'+  ' ServicioTipo="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.ServicioTipo),'')+'"'+  ' NivelContratoTipo="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.NivelContratoTipo)),'')+'"'+  ' ContratoTipo="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.ContratoTipo),'')+'"'+  ' NivelUnidadVenta="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.NivelUnidadVenta)),'')+'"'+  ' UnidadVenta="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.UnidadVenta),'')+'"'+  ' NivelEmpresa="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.NivelEmpresa)),'')+'"'+  ' Empresa="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.Empresa),'')+'"'+  ' NivelSucursal="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.NivelSucursal)),'')+'"'+  ' Sucursal="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.Sucursal)),'')+'"'+  ' Tipo="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.Tipo),'')+'"'+  ' Nivel="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.Nivel),'')+'"'+  ' ListaPrecios="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.ListaPrecios),'')+'"'+  ' ConVigencia="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.ConVigencia)),'')+'"'+  ' FechaD="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.FechaD)),'')+'"'+  ' FechaA="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.FechaA)),'')+'"'+  ' ArticuloObsequio="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(Precio.ArticuloObsequio),'')+'"'+  ' CantidadObsequio="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.CantidadObsequio)),'')+'"'+  ' Logico1="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.Logico1)),'')+'"'+  ' Logico2="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),Precio.Logico2)),'')+'" />' FROM Precio Precio WHERE Precio.ID = @PrecioID )
ELSE   SELECT @Tabla = ''
SELECT @Resultado2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia="Precio" Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) +' Empresa=' + CHAR(34) + ISNULL(@Empresa,'') + CHAR(34)+ ' Sucursal=' + CHAR(34) + ISNULL(CONVERT(varchar,@Sucursal),'') + CHAR(34)+' eCommerceSucursal=' + CHAR(34) + ISNULL(@eCommerceSucursal,'') + CHAR(34)+ ' Estatus=' + CHAR(34) + ISNULL(@Estatus,'') + CHAR(34) +' PrecioID=' + CHAR(34) + ISNULL(CONVERT(varchar,@PrecioID),'') + CHAR(34) +' >'
SELECT @Resultado = @Resultado2+ISNULL(@Tabla,'')+'</Resultado></Intelisis>'
END

