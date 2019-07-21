SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISeCommerceArtSubCosto
@ID			int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok			int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Articulo			varchar(20),
@SubCuenta			varchar(50),
@EmpresaDestino		varchar(5),
@SucursalDestino		int,
@Estatus				varchar(10),
@Empresa              varchar(5),
@Sucursal             int,
@eCommerceSucursal    varchar(10),
@ReferenciaIS         varchar(100),
@Tabla                varchar(max) ,
@Resultado2			varchar(max),
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
@Articulo = Articulo,
@SubCuenta = SubCuenta,
@EmpresaDestino = EmpresaDestino,
@SucursalDestino = SucursalDestino,
@Sucursal = Sucursal,
@eCommerceSucursal = eCommerceSucursal,
@Estatus = Estatus
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/ArtSubCosto')
WITH (Empresa varchar(5),  Sucursal int, eCommerceSucursal  varchar(10), Estatus varchar(10), Articulo varchar(20), SubCuenta varchar(50), EmpresaDestino varchar(5), SucursalDestino int)
SELECT
@UltimoCosto = UltimoCosto,
@CostoPromedio = CostoPromedio,
@CostoEstandar = CostoEstandar,
@CostoReposicion = CostoReposicion,
@UltimoCostoSinGastos = UltimoCostoSinGastos
FROM ArtSubCosto WHERE Articulo = @Articulo AND SubCuenta = @SubCuenta AND Empresa = @EmpresaDestino AND Sucursal = @SucursalDestino
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
SELECT @Tabla = '<ArtSubCosto '+(SELECT
' Sucursal="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ArtSubCosto.Sucursal)),'')+'"'+
' Empresa="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ArtSubCosto.Empresa)),'')+'"'+
' Articulo="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ArtSubCosto.Articulo)),'')+'"'+
' SubCuenta="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),ArtSubCosto.SubCuenta)),'')+'"'+
' UltimoCosto="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),@UltimoCosto)),'')+'"'+
' CostoPromedio="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),@CostoPromedio)),'')+'"'+
' CostoEstandar="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),@CostoEstandar)),'')+'"'+
' CostoReposicion="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),@CostoReposicion)),'')+'"'+
' UltimoCostoSinGastos="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),@UltimoCostoSinGastos)),'')+'"'+
' />' FROM ArtSubCosto ArtSubCosto WHERE  Articulo = @Articulo AND SubCuenta = @SubCuenta AND Empresa = @EmpresaDestino AND Sucursal = @SucursalDestino)
ELSE   SELECT @Tabla = ''
SELECT @Resultado2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia="ArtSubCosto" Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) +' Empresa=' + CHAR(34) + ISNULL(@Empresa,'') + CHAR(34)+ ' Sucursal=' + CHAR(34) + ISNULL(CONVERT(varchar,@Sucursal),'') + CHAR(34)+' eCommerceSucursal=' + CHAR(34) + ISNULL(@eCommerceSucursal,'') + CHAR(34)+ ' Estatus=' + CHAR(34) + ISNULL(@Estatus,'') + CHAR(34) +' Articulo=' + CHAR(34) + ISNULL(CONVERT(varchar,@Articulo),'') + CHAR(34) +' SubCuenta=' + CHAR(34) + ISNULL(CONVERT(varchar,@SubCuenta),'') + CHAR(34) +' EmpresaDestino=' + CHAR(34) + ISNULL(CONVERT(varchar,@EmpresaDestino),'') + CHAR(34) +' SucursalDestino=' + CHAR(34) + ISNULL(CONVERT(varchar,@SucursalDestino),'') + CHAR(34) +' >'
SELECT @Resultado = @Resultado2+ISNULL(@Tabla,'')+'</Resultado></Intelisis>'
END

