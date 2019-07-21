SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISeCommercePrecioD
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
@Resultado2		varchar(max) ,
@GUID                 varchar(50),
@CantidadI            float,
@CantidadD            float,
@Tipo					varchar(23),
@Articulo				varchar(20),
@NivelArticulo		bit,
@Usuario				varchar(10),
@Monto				money
SELECT @Usuario = WebUsuario
FROM WebVersion
SELECT @Empresa = Empresa,
@PrecioID= PrecioID ,
@CantidadI = CantidadI,
@CantidadD = CantidadD,
@GUID = GUID,
@Sucursal = Sucursal,
@eCommerceSucursal = eCommerceSucursal,
@Estatus = Estatus
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/PrecioD')
WITH (Empresa varchar(5),  Sucursal int, eCommerceSucursal  varchar(10), Estatus varchar(10),  PrecioID int, CantidadI float, CantidadD float, GUID varchar(50))
SELECT @Tipo = Tipo, @Articulo = Articulo FROM Precio WHERE ID = @PrecioID
SELECT @Monto = Monto FROM PrecioD WHERE GUID = @GUID
IF(@Tipo IN ('Precio', 'Precio=Costo+[$]', '$ Descuento', '$ Descuento (Variable)')
AND ISNULL(@Articulo, '') != ''
AND (SELECT VentaPreciosImpuestoIncluido FROM EmpresaCfg WHERE Empresa = @Empresa) = 0)
BEGIN
EXEC spDesglosarPrecioCImpuestos  @Articulo, @Usuario, @Empresa, @Sucursal, @Monto OUTPUT
END
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @Estatus IN ('ALTA','CAMBIO')
BEGIN
SELECT @Tabla =(SELECT '<PrecioD ID="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),PrecioD.ID)),'')+'" Cantidad="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),PrecioD.Cantidad)),'')+'"'+  ' Monto="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),@Monto)),'')+'"'+  ' Sucursal="'+ISNULL(dbo.fneWebConvertirDescripcionHTML(CONVERT(varchar(1000),PrecioD.Sucursal)),'')+'" />' FROM PrecioD PrecioD WHERE PrecioD.ID = @PrecioID AND PrecioD.Cantidad = @CantidadI AND GUID = @GUID)
END
ELSE   SELECT @Tabla = ''
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia="PrecioD" Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) +' Empresa=' + CHAR(34) + ISNULL(@Empresa,'') + CHAR(34)+ ' Sucursal=' + CHAR(34) + ISNULL(CONVERT(varchar,@Sucursal),'') + CHAR(34)+' eCommerceSucursal=' + CHAR(34) + ISNULL(@eCommerceSucursal,'') + CHAR(34)+ ' Estatus=' + CHAR(34) + ISNULL(@Estatus,'') + CHAR(34) +' IDPrecio=' + CHAR(34) + ISNULL(CONVERT(varchar,@PrecioID),'') + CHAR(34)+' CantidadAnterior=' + CHAR(34) + ISNULL(CONVERT(varchar,@CantidadD),'') + CHAR(34)+' GUID=' + CHAR(34) + ISNULL(@GUID,'') + CHAR(34) +' >'+ISNULL(@Tabla,'')+'</Resultado></Intelisis>'
END

