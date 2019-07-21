SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISeCommerceArtCosto
@ID			int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok			int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Articulo		varchar(20),
@Estatus		varchar(10),
@Empresa              varchar(5),
@Sucursal             int,
@eCommerceSucursal     varchar(10),
@ReferenciaIS         varchar(100),
@Tabla                varchar(max) ,
@Resultado2		varchar(max),
@UltimoCosto float,
@CostoPromedio float,
@CostoEstandar float,
@CostoReposicion float,
@UltimoCostoSinGastos float,
@Usuario				varchar(10),
@Impuesto1    float,
@Impuesto2    float,
@Impuesto3    float
SELECT @Usuario = WebUsuario
FROM WebVersion
SELECT @Empresa = Empresa,
@Articulo = Articulo ,
@Sucursal = Sucursal,
@eCommerceSucursal = eCommerceSucursal,
@Estatus = Estatus
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/ArtCosto')
WITH (Empresa varchar(5), Articulo varchar(10), Sucursal int, eCommerceSucursal  varchar(10), Estatus varchar(10))
SELECT
@UltimoCosto = UltimoCosto,
@CostoPromedio = CostoPromedio,
@CostoEstandar = CostoEstandar,
@CostoReposicion = CostoReposicion,
@UltimoCostoSinGastos = UltimoCostoSinGastos
FROM ArtCosto WHERE Articulo = @Articulo AND Empresa = @Empresa AND Sucursal = @Sucursal
IF(SELECT eCommerceImpuestoIncluido FROM Sucursal WHERE Sucursal = @Sucursal) = 1
BEGIN
EXEC spDesglosarPrecioCImpuestos  @Articulo, @Usuario, @Empresa, @Sucursal, 0, NULL, NULL, NULL, @Impuesto1 OUTPUT, @Impuesto2 OUTPUT, @Impuesto3 OUTPUT
SELECT @UltimoCosto = dbo.fnWebPrecioConImpuestos(@UltimoCosto,@Impuesto1,@Impuesto2,@Impuesto3)
SELECT @CostoPromedio = dbo.fnWebPrecioConImpuestos(@CostoPromedio,@Impuesto1,@Impuesto2,@Impuesto3)
SELECT @CostoEstandar = dbo.fnWebPrecioConImpuestos(@CostoEstandar,@Impuesto1,@Impuesto2,@Impuesto3)
SELECT @CostoReposicion = dbo.fnWebPrecioConImpuestos(@CostoReposicion,@Impuesto1,@Impuesto2,@Impuesto3)
SELECT @UltimoCostoSinGastos = dbo.fnWebPrecioConImpuestos(@UltimoCostoSinGastos,@Impuesto1,@Impuesto2,@Impuesto3)
END
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @Estatus IN ('ALTA','CAMBIO')
SELECT @Tabla = (SELECT '<ArtCosto '+
'Sucursal="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000), Sucursal)),'')+'" '+
'Empresa="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000), Empresa)),'')+'" '+
'Articulo="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000), Articulo)),'')+'" '+
'UltimoCosto="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000), @UltimoCosto)),'')+'" '+
'CostoPromedio="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000), @CostoPromedio)),'')+'" '+
'CostoEstandar="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000), @CostoEstandar)),'')+'" '+
'CostoReposicion="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000), @CostoReposicion)),'')+'" '+
'UltimoCostoSinGastos="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000), @UltimoCostoSinGastos)),'')+'" '+
'/>'
FROM ArtCosto WHERE Articulo = @Articulo AND Empresa = @Empresa AND Sucursal = @Sucursal)
ELSE   SELECT @Tabla = ''
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia="ArtCosto" Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) +' Empresa=' + CHAR(34) + ISNULL(@Empresa,'') + CHAR(34)+ ' Sucursal=' + CHAR(34) + ISNULL(CONVERT(varchar,@Sucursal),'') + CHAR(34)+' eCommerceSucursal=' + CHAR(34) + ISNULL(@eCommerceSucursal,'') + CHAR(34)+ ' Estatus=' + CHAR(34) + ISNULL(@Estatus,'') + CHAR(34) +' Articulo=' + CHAR(34) + ISNULL(@Articulo,'') + CHAR(34) +' >' +ISNULL(@Tabla,'')+'</Resultado></Intelisis>'
END

