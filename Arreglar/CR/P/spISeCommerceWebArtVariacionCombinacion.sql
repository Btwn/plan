SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISeCommerceWebArtVariacionCombinacion
@ID			int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max)  = NULL OUTPUT,
@Ok			int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
SET nocount ON
DECLARE
@IDCombinacion		int,
@IDArt		int,
@Estatus		varchar(255),
@IDOpciones		varchar(10),
@Empresa              varchar(5),
@Sucursal             int,
@eCommerceSucursal    varchar(10),
@ReferenciaIS         varchar(100),
@Tabla                varchar(max),
@Resultado2		varchar(max),
@ListaPrecios         varchar(20),
@Articulo             varchar(20),
@Usuario              varchar(10),
@Precio               float,
@SKU					varchar(255),
@EnvolturaIDS			varchar(max),
@Impuestos			float,
@CfgImpuestoIncluido	float,
@ImpuestosString		varchar(20),
@Impuesto1Excento		varchar(20),
@SubCuenta			varchar(50),
@PrecioVariacion		float
SELECT @Usuario = WebUsuario
FROM WebVersion
SELECT @Empresa = Empresa,
@IDCombinacion = IDCombinacion,
@IDArt = IDArticulo,
@IDOpciones = IDOpciones,
@Sucursal = Sucursal,
@eCommerceSucursal = eCommerceSucursal,
@Estatus = Estatus
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/WebArtVariacionCombinacion')
WITH (Empresa varchar(5), IDArticulo int, Sucursal int, eCommerceSucursal  varchar(10), Estatus varchar(10), IDCombinacion int, IDOpciones varchar(255))
/*SELECT @ListaPrecios = ISNULL(eCommerceListaPrecios,'(Precio Lista)')
FROM Sucursal WHERE Sucursal = @Sucursal*/
SELECT @ListaPrecios = ISNULL(eCommerceListaPrecios,'(Precio Lista)'), @CfgImpuestoIncluido = ISNULL(eCommerceImpuestoIncluido, 1)
FROM Sucursal WHERE Sucursal = @Sucursal
SELECT @Articulo  = Articulo
FROM  WebArtVariacionCombinacion
WHERE ID  = @IDCombinacion
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
WHERE Articulo =  @Articulo
SET @PrecioVariacion = ''
SELECT @SubCuenta = SubCuenta FROM WebArtVariacionCombinacion WHERE ID = @IDCombinacion
SELECT @PrecioVariacion = Precio FROM ListaPreciosSub WHERE Articulo = @Articulo AND SubCuenta = @SubCuenta
if @PrecioVariacion <> ''
SET @Precio = @PrecioVariacion
SELECT @SKU = ISNULL(NULLIF(SKU,''),'IDCO#'+CONVERT(varchar(10),ID)) FROM WebArtVariacionCombinacion WHERE ID = @IDCombinacion
EXEC spDesglosarPrecioCImpuestos  @Articulo, @Usuario, @Empresa, @Sucursal, @Precio OUTPUT, NULL, NULL, NULL, NULL, NULL, NULL, @Impuestos OUTPUT
SELECT @ImpuestosString = Impuesto1 FROM Art WHERE Articulo = @Articulo
IF(@CfgImpuestoIncluido = 1)
SELECT @Impuestos = 0.00
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @Estatus IN ('ALTA','CAMBIO')
SELECT @Tabla = (SELECT   ISNULL(CONVERT(varchar,ID),'')ID,ISNULL(CONVERT(varchar,Orden),'')Orden, ISNULL(CONVERT(varchar,IDArt),'')IDArt, ISNULL(CONVERT(varchar,IDVariacion),'')IDVariacion, ISNULL(CONVERT(varchar,Activa),'')Activa, ISNULL(CONVERT(varchar,IDOpciones),'')IDOpciones, ISNULL(CONVERT(varchar,Opciones),'')Opciones, @SKU SKU, ISNULL(CONVERT(varchar,Imagen),'')Imagen, ISNULL(CONVERT(varchar,UltimoCambio),'')UltimoCambio, ISNULL(CONVERT(varchar,OperacionPrecio),'')OperacionPrecio, ISNULL(CONVERT(varchar,OperacionPeso),'')OperacionPeso, ISNULL(CONVERT(varchar,@Precio),'')Precio, ISNULL(CONVERT(varchar,ISNULL(Peso,0.0)),'')Peso, ISNULL(CONVERT(varchar,SubCuenta),'')SubCuenta, ISNULL(CONVERT(varchar,Unidad),'')Unidad, ISNULL(CONVERT(varchar,Articulo),'')Articulo, ISNULL(CONVERT(varchar,Cantidad),'')Cantidad, ISNULL(CONVERT(varchar,TipoArchivo),'')TipoArchivo, ISNULL(CONVERT(varchar,NombreImagen),'')NombreImagen,ISNULL(dbo.fnWebArtEstausExistencia(@SKU,@Sucursal),'')Situacion FROM WebArtVariacionCombinacion WHERE ID = @IDCombinacion FOR XML AUTO )
ELSE   SELECT @Tabla = ''
SELECT @Impuestos = Impuesto1, @Impuesto1Excento = Impuesto1Excento FROM Art WHERE Articulo = @Articulo
SET @ImpuestosString =   CONVERT (VARCHAR(20), @Impuestos ,128)
SELECT @Resultado2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia="WebArtVariacionCombinacion" Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) +' Empresa=' + CHAR(34) + ISNULL(@Empresa,'') + CHAR(34)+ ' Sucursal=' + CHAR(34) + ISNULL(CONVERT(varchar,@Sucursal),'') + CHAR(34)+' eCommerceSucursal=' + CHAR(34) + ISNULL(@eCommerceSucursal,'') + CHAR(34)+ ' Estatus=' + CHAR(34) + ISNULL(@Estatus,'') + CHAR(34) +' IDCombinacion=' + CHAR(34) + CONVERT(varchar,ISNULL(@IDCombinacion,'')) + CHAR(34) +' IDArticulo=' + CHAR(34) + CONVERT(varchar,ISNULL(@IDArt,'')) + CHAR(34) ++' IDOpciones=' + CHAR(34) + ISNULL(@IDOpciones,'') + CHAR(34) + ' Impuestos=' + CHAR(34) + ISNULL(@ImpuestosString,'') + CHAR(34) + ' Impuesto1Excento=' + CHAR(34) + ISNULL(@Impuesto1Excento,'') + CHAR(34) +' >'
SELECT @Resultado = @Resultado2+ISNULL(@Tabla,'')+'</Resultado></Intelisis>'
END

