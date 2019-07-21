SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speCommercePedido
@ID                     int,
@iSolicitud             int,
@Solicitud              varchar(max),
@Version                float,
@Resultado              varchar(max) = NULL OUTPUT,
@Ok                     int = NULL OUTPUT,
@OkRef                  varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Empresa              varchar(5),
@Sucursal             int,
@Mov                  varchar(20),
@MovID                varchar(20),
@Mon                  varchar(10),
@Cliente              varchar(10),
@Almacen              varchar(10),
@Estatus              varchar(15),
@FechaEmision         datetime,
@TipoCambio           float,
@Renglon              float,
@Articulo             varchar(20),
@ArticuloFlete        varchar(20),
@Precio               float,
@IDGenerar            int,
@RenglonID            int,
@ReferenciaIS         varchar(100),
@SubReferencia        varchar(100),
@EstatusGenerado      varchar(15),
@ListaPreciosCliente  varchar(20),
@ListaPrecios         varchar(20),
@ClienteCommerce      int,
@SubCuenta            varchar(50),
@Referencia           varchar(50),
@Observaciones        varchar(100),
@Cantidad             float,
@Unidad               varchar(20),
@Impuesto1            float,
@Impuesto2            float,
@Impuesto3            float,
@DescuentoGlobal      float,
@EnviarA              int,
@Usuario              varchar(10) ,
@CostoFlete           float,
@DescuentoFlete       float,
@Tipo                 varchar(50),
@RFC                  varchar(15),
@eMail                varchar(255),
@IDUsuario            int,
@IDEnviar             int,
@IDFormaPago          varchar(50),
@FormaPago            varchar(50),
@ReferenciaFormaPago  varchar(50),
@Condicion            varchar(50),
@Prepagado            bit,
@CtaDinero            varchar(10),
@Importe              float,
@Cajero               varchar(10),
@Agente               varchar(10),
@GUIDUsuario          varchar(50),
@GUIDEnviarA          varchar(50),
@Categoria            varchar(50),
@RequiereFactura2     varchar(5),
@RequiereFactura3     varchar(5),
@RequiereFactura      bit,
@Error                int,
@DescuentoLinea       float,
@IDPedidoD			int,
@FechaEntrega datetime,
@PedidoID	int,
@RenglonIDSerieLote	int,
@CodigoCR			varchar(50),
@SKUVentaD			varchar(50),
@IDGenerarVale            int,
@MovVale                  varchar(20),
@TipoVale				varchar(50),
@ConceptoVale				varchar(50)
DECLARE
@Tabla               table
(Empresa      varchar(5),
Sucursal     int,
Mov          varchar(20),
Mon          varchar(10),
Cliente      varchar(10),
Almacen      varchar(10),
Estatus      varchar(15),
Usuario      varchar(10),
FechaEmision datetime,
TipoCambio   float  ,
ListaPreciosEsp varchar(20) ,
EnviarA      int
)
DECLARE
@Tabla2 table
(Renglon       float,
RenglonID     int,
SKU           varchar(50),
SubCuenta     varchar(50),
Articulo      varchar(20),
Unidad        varchar(20),
Almacen       varchar(10),
Precio        float,
Cantidad      float,
DescuentoLinea float,
ID				int,
CodigoCR		varchar(50)
)
DECLARE @TablaVentaDWeb table (
ID		int,
Campo	varchar(255),
Valor	text
)
DECLARE @Tabla3 table(ID  int, Nombre varchar(100), Apellidos varchar(100),eMail varchar(250),Contrasena varchar(50),Telefono varchar(50),RFC varchar(20), Compania varchar(250) )
DECLARE @Direccion table(Direccion1 varchar(255), Direccion2 varchar(255),Ciudad varchar(100),Pais varchar(100),Estado varchar(100),CP varchar(30), Delegacion varchar(50), Colonia    varchar(50),NoExterior varchar(50))
DECLARE @Direccion2 table(Direccion1 varchar(255), Direccion2 varchar(255),Ciudad varchar(100),Pais varchar(100),Estado varchar(100),CP varchar(30), GUID varchar(50),Delegacion varchar(50), Colonia    varchar(50),NoExterior varchar(50),Nombre varchar(100), Apellido varchar(100),eMail varchar(250),Telefono varchar(50))
BEGIN TRANSACTION
IF @Ok IS NULL
BEGIN
SELECT @Usuario = WebUsuario
FROM WebVersion
SELECT @Empresa = Empresa, @Sucursal = Sucursal, @ClienteCommerce = Cliente, @EnviarA = EnviarA,  @Observaciones =  Observaciones, @Referencia = Referencia, @DescuentoGlobal = DescuentoGlobal, @CostoFlete = CostoFlete, @DescuentoFlete = DescuentoFlete, @IDFormaPago = FormaPago, @ReferenciaFormaPago = ReferenciaFormaPago, @Importe = Importe, @RequiereFactura2 = RequiereFactura, @FechaEntrega = FechaEntrega, @PedidoID = PedidoID
FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Pedido')
WITH (Empresa varchar(5), Sucursal int, Cliente int, EnviarA int, Observaciones varchar(100), Referencia varchar(50),  DescuentoGlobal float, CostoFlete   float, DescuentoFlete float, FormaPago  varchar(50), ReferenciaFormaPago  varchar(50), Importe float, RequiereFactura varchar(5), FechaEntrega datetime, PedidoID int)
SELECT  @ClienteCommerce = NULLIF(@ClienteCommerce,0)
IF @@ERROR<>0 SET @Ok = 1
SELECT @IDGenerar = IDPedido
FROM eCommercePedido
WHERE Sucursal = @Sucursal
AND IDPedido = @PedidoID
IF(ISNULL(@IDGenerar, '') != '')
BEGIN
SELECT @ReferenciaIS = Referencia, @SubReferencia = SubReferencia
FROM IntelisisService
WHERE ID = @ID
SELECT @EstatusGenerado = Estatus, @Mov = Mov, @MovID = MovID
FROM Venta
WHERE ID = @IDGenerar
COMMIT TRANSACTION
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + ' Modulo="Venta" ModuloID =' + CHAR(34) + ISNULL(CONVERT(varchar,@IDGenerar),'') + CHAR(34) + ' Consecutivo='+ CHAR(34) +ISNULL(@Mov,'')+' '+ISNULL(@MovID,'')+ CHAR(34) +' EstatusMov='+ CHAR(34) +ISNULL(@EstatusGenerado,'')+ CHAR(34) + ' IDUsuario=' + CHAR(34) + ISNULL(CONVERT(varchar,@IDUsuario),'') + CHAR(34)+ ' IDEnviarA=' + CHAR(34) + ISNULL(CONVERT(varchar,@IDEnviar),'') + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '/></Intelisis>'
RETURN
END
SELECT @RequiereFactura = CASE WHEN @RequiereFactura2 = 'ON' THEN 1 ELSE 0 END
SELECT  @FormaPago = w.FormaPago , @Prepagado = ISNULL(Prepagado,0), @CtaDinero = w.CtaDinero
FROM WebFormaPago w JOIN WebFormaPagoOmision o ON o.Nombre = w.FormaPagoWeb
WHERE o.IDForma = @IDFormaPago  AND w.Sucursal = @Sucursal
SELECT @Agente = eCommerceAgente
FROM Sucursal
WHERE Sucursal = @Sucursal
IF @Prepagado = 1
SELECT @Condicion = NULLIF(eCommerceCondicion,''), @Cajero = NULLIF(eCommerceCajero,'') FROM Sucursal WHERE Sucursal = @Sucursal
IF @Ok IS NULL
SELECT @GUIDEnviarA = GUID FROM OPENXML (@iSolicitud, '/Intelisis/Solicitud/Pedido/DireccionEnvio',1)
WITH (GUID varchar(50))
IF @@ERROR<>0 SET @Ok = 1
IF @Ok IS NULL
SELECT @RFC = RFC , @eMail = eMail, @GUIDUsuario = GUID, @RequiereFactura3 = RequiereFactura FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Pedido/Usuario')
WITH (RFC varchar(15),eMail varchar(250), GUID varchar(50), RequiereFactura char(5))
IF @@ERROR<>0 SET @Ok = 1
IF NULLIF(@GUIDUsuario,'') IS NULL
SELECT @Ok = 71020
SELECT @RequiereFactura = CASE WHEN @RequiereFactura2 IN ('ON', 'Si') THEN 1 ELSE 0 END
SELECT @RequiereFactura = CASE WHEN @RequiereFactura3 IN ('ON', 'Si') THEN 1 ELSE 0 END
IF NULLIF(@RFC,'') IS NULL  AND @RequiereFactura = 1
SELECT @Ok = 71020
IF @ClienteCommerce IS NULL
SELECT @ClienteCommerce = ID FROM WebUsuarios WHERE GUID = @GUIDUsuario
IF @Ok IS NULL
BEGIN
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
INSERT @Tabla3(ID,              Nombre , Apellidos,   eMail, Contrasena , Telefono, RFC ,Compania )
SELECT        @ClienteCommerce, Nombre , Apellidos,   eMail, Contrasena , Telefono, RFC ,Compania
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/Pedido/Usuario')
WITH (Nombre varchar(100), Apellidos varchar(100),eMail varchar(250),Contrasena varchar(50),Telefono varchar(50),RFC varchar(20), Compania varchar(250) )
EXEC sp_xml_removedocument @iSolicitud
IF @@ERROR<>0 SET @Ok = 1
END
IF @Ok IS NULL
BEGIN
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
INSERT @Direccion(Direccion1 , Direccion2, Ciudad, Pais , Estado, CP, Colonia, Delegacion, NoExterior  )
SELECT            Direccion1 , Direccion2, Ciudad, Pais , Estado, CP, Colonia, Delegacion, NumeroExterior
FROM OPENXML (@iSolicitud, '/Intelisis/Solicitud/Pedido/DireccionFactura',1)
WITH (Direccion1 varchar(255), Direccion2 varchar(255),Ciudad varchar(100),Pais varchar(100),Estado varchar(100),CP varchar(30), Colonia varchar(50), Delegacion  varchar(50), NumeroExterior  varchar(50))
EXEC sp_xml_removedocument @iSolicitud
IF @@ERROR<>0 SET @Ok = 1
END
IF @Ok IS NULL
BEGIN
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
INSERT @Direccion2(Direccion1 , Direccion2, Ciudad, Pais , Estado, CP, Colonia, Delegacion, NoExterior, Nombre, Apellido, eMail,Telefono )
SELECT             Direccion1 , Direccion2, Ciudad, Pais , Estado, CP, Colonia, Delegacion, NumeroExterior,Nombre, Apellido, eMail,Telefono
FROM OPENXML (@iSolicitud, '/Intelisis/Solicitud/Pedido/DireccionEnvio',1)
WITH (Direccion1 varchar(255), Direccion2 varchar(255),Ciudad varchar(100),Pais varchar(100),Estado varchar(100),CP varchar(30), Colonia varchar(50), Delegacion  varchar(50), NumeroExterior  varchar(50), Nombre  varchar(100), Apellido varchar(100), eMail varchar(250),Telefono varchar(50) )
EXEC sp_xml_removedocument @iSolicitud
IF @@ERROR<>0 SET @Ok = 1
END
IF @ClienteCommerce IS NULL
BEGIN
SELECT @Tipo = eCommerceTipoConsecutivo FROM Sucursal WHERE Sucursal = @Sucursal
IF NULLIF(@Tipo,'') IS NULL SET @Ok = 53040
IF(ISNULL(@Ok, '') = '' AND ISNULL(@RequiereFactura, 0) = 1)
BEGIN
SELECT @Tipo = eCommerceTipoConsecutivoFact FROM Sucursal WHERE Sucursal = @Sucursal
IF NULLIF(@Tipo,'') IS NULL SET @Ok = 53040
END
EXEC spConsecutivo @Tipo, @Sucursal, @Cliente OUTPUT
IF @Cliente IS NULL SET @Ok = 26060
IF ISNULL(@RFC, '') != '' AND EXISTS(SELECT RFC FROM Cte WHERE RFC = @RFC AND Cliente <> @Cliente)
UPDATE @Tabla3 SET RFC =  'XAXX010101000'
IF @Cliente IS NOT NULL AND @OK IS NULL
BEGIN
INSERT Cte(Cliente,  Nombre,                             eMail1,   Telefonos,  Contacto1,                       RFC,   Direccion,             DireccionNumeroInt,         Pais,     Estado,   Poblacion, CodigoPostal, Estatus, Delegacion,  DireccionNumero, Colonia)
SELECT     @Cliente,a.Nombre+' '+ISNULL(a.Apellidos,''), a.eMail,  a.Telefono, a.Nombre+' '+ISNULL(a.Apellidos,''), a.RFC, ISNULL(d.Direccion1,''),ISNULL(d.Direccion2,''),  d.Pais, d.Estado, d.Ciudad,  d.CP,         'ALTA',  d.Delegacion, d.NoExterior,   d.Colonia
FROM @Tabla3 a JOIN @Direccion d ON 1=1
IF @@ERROR<>0 SET @Ok = 1
END
IF EXISTS(SELECT * FROM WebUsuario WHERE eMail = @eMail)
SELECT @Ok = 3, @OkRef= 'Ya Existe Un Usuario Con EL Mismo Correo'
IF @Ok IS NULL AND NOT EXISTS(SELECT * FROM WebUsuario WHERE eMail = @eMail) AND @Ok IS NULL
BEGIN
INSERT WebUsuarios(eMail, eMail2,  Telefono,  FechaAlta, UltimoCambio,  Empresa,  Sucursal,  Cliente, Contrasena, ContrasenaConfirmacion, Nombre, Apellido, GUID  )
SELECT            eMail1, eMail2, Telefonos, GETDATE(), GETDATE(),    @Empresa, @Sucursal, Cliente, Contrasena, Contrasena ,dbo.fnWebSepararContacto(Contacto1,1),  dbo.fnWebSepararContacto(Contacto1,2) , @GUIDUsuario
FROM  Cte
WHERE Cliente = @Cliente
IF @@ERROR<>0 SET @Ok = 1
SELECT @IDUsuario = SCOPE_IDENTITY()
UPDATE @Tabla3 SET ID = @IDUsuario
END
END
ELSE
BEGIN
IF @ClienteCommerce IS NOT NULL AND EXISTS(SELECT * FROM WebUsuarios WHERE GUID = @GUIDUsuario)AND @Ok IS NULL
BEGIN
UPDATE WebUsuarios SET eMail = ISNULL(NULLIF(t.eMail,''),w.eMail), Telefono = ISNULL(NULLIF(t.Telefono,''),w.Telefono),  UltimoCambio = GETDATE(),   Contrasena = ISNULL(NULLIF(t.Contrasena,''),w.Contrasena), ContrasenaConfirmacion = ISNULL(NULLIF(t.Contrasena,''),w.Contrasena), Nombre = ISNULL(NULLIF(t.Nombre,''),w.Nombre) , Apellido = ISNULL(NULLIF(t.Apellidos,''),w.Apellido)
FROM @Tabla3 t JOIN WebUsuarios w ON t.ID = w.ID
WHERE w.ID = @ClienteCommerce
IF @@ERROR<>0 SET @Ok = 1
SELECT @IDUsuario = @ClienteCommerce
END
SELECT @Cliente = Cliente FROM WebUsuarios WHERE  GUID = @GUIDUsuario
IF ISNULL(@RFC, '') != '' AND EXISTS(SELECT RFC FROM Cte WHERE RFC = @RFC AND Cliente <> @Cliente)
UPDATE @Tabla3 SET RFC =  'XAXX010101000'
IF @Cliente IS NOT NULL AND EXISTS(SELECT * FROM Cte WHERE Cliente = @Cliente )
BEGIN
UPDATE Cte SET Telefonos =a.Telefono, RFC = a.RFC,   Direccion = ISNULL(d.Direccion1,''), DireccionNumeroInt = ISNULL(d.Direccion2,''), Pais =  d.Pais,     Estado = d.Estado,   Poblacion = d.Ciudad, CodigoPostal = d.CP, Delegacion = d.Delegacion, DireccionNumero = d.NoExterior, Colonia = d.Colonia,
Contacto1 = CASE
WHEN ISNULL(Contacto1, '') = '' THEN a.Nombre+' '+ISNULL(a.Apellidos,'')
ELSE Contacto1 END,
eMail1 = CASE
WHEN ISNULL(eMail1, '') = '' THEN a.eMail
ELSE eMail1 END
FROM Cte c JOIN @Tabla3 a ON c.Cliente = @Cliente
JOIN @Direccion d ON 1=1
IF @@ERROR<>0 SET @Ok = 1
IF @Ok IS NULL UPDATE WebUsuarios SET eMail = eMail    WHERE ID = @ClienteCommerce
END
END
IF @Ok IS NULL AND EXISTS(SELECT * FROM @Direccion2) AND @Ok IS NULL
BEGIN
IF EXISTS(SELECT * FROM CteEnviarA  WHERE Cliente = @Cliente AND GUID= @GUIDEnviarA)
BEGIN
SELECT @EnviarA = ID FROM CteEnviarA WHERE Cliente = @Cliente AND GUID = @GUIDEnviarA
UPDATE CteEnviarA SET Nombre = ISNULL(d.Nombre,'')+' '+ISNULL(d.Apellido,''), Direccion = ISNULL(d.Direccion1,''), DireccionNumeroInt = ISNULL(d.Direccion2,''), Pais = d.Pais, Estado = d.Estado, Poblacion= d.Ciudad, CodigoPostal=  d.CP, Delegacion = d.Delegacion, DireccionNumero = d.NoExterior, Colonia = d.Colonia, eMail1 = d.eMail, Telefonos = d.Telefono
FROM @Direccion2 d
LEFT JOIN WebUsuarios c ON 1=1 AND  c.ID = @IDUsuario
JOIN CteEnviarA a ON a.Cliente = @Cliente
WHERE a.Cliente = @Cliente  AND a.ID = @EnviarA AND a.GUID = @GUIDEnviarA
IF @@ERROR <> 0 SET @Ok = 1
SELECT @IDEnviar = @EnviarA
END
ELSE
BEGIN
SELECT @EnviarA =  MAX(ID) FROM CteEnviarA WHERE Cliente = @Cliente
SELECT @IDEnviar = ISNULL(@EnviarA,0)+1
IF @IDEnviar IS NOT NULL AND @Ok IS NULL
INSERT CteEnviarA(ID,        Cliente,  Nombre,                                        Direccion,          DireccionNumeroInt,                                          Pais,     Estado,   Poblacion, CodigoPostal, Estatus, GUID,        Delegacion,  DireccionNumero, Colonia,   eMail1, Telefonos)
SELECT            @IDEnviar, @Cliente,ISNULL(d.Nombre,'')+' '+ISNULL(d.Apellido,''), ISNULL(d.Direccion1,''),ISNULL(d.Direccion2,''), d.Pais, d.Estado, d.Ciudad,  d.CP,         'ALTA', @GUIDEnviarA, d.Delegacion, d.NoExterior,   d.Colonia, d.eMail, d.Telefono
FROM @Direccion2 d /*JOIN WebPais p ON d.Pais = p.ID
JOIN WebPaisEstado e ON  e.IDPais = p.ID AND e.ID = d.Estado */
JOIN WebUsuarios c ON c.GUID= @GUIDUsuario
IF @@ERROR<>0 SET @Ok = 1
END
END
SELECT @Cliente = Cliente FROM WebUsuarios WHERE  GUID = @GUIDUsuario
SELECT @ListaPreciosCliente = ListaPreciosEsp FROM Cte WHERE Cliente = @Cliente
SELECT @FechaEmision = dbo.fnFechaSinHora(GETDATE())
SELECT @Mon = DefMoneda  FROM Usuario
WHERE Usuario = @Usuario
SELECT @Almacen = eCommerceAlmacen , @Mov = eCommercePedido, @ListaPrecios = eCommerceListaPrecios, @TipoVale = eCommerceCRTipo, @ConceptoVale = eCommerceCRConcepto
FROM Sucursal WHERE Sucursal = @Sucursal
SELECT TOP 1 @MovVale = Mov FROM MovTipo WHERE Modulo = 'VALE' AND Clave = 'VALE.ET' ORDER BY Orden ASC
SELECT @TipoCambio = TipoCambio FROM Mon WHERE Moneda = @Mon
INSERT @Tabla(Empresa,  Mov,  Estatus,      FechaEmision,  Mon,  TipoCambio,  Cliente,  Usuario, Almacen, ListaPreciosEsp, Sucursal, EnviarA)
SELECT        @Empresa, @Mov, 'SINAFECTAR', @FechaEmision, @Mon, @TipoCambio, @Cliente, @Usuario, @Almacen, ISNULL(@ListaPreciosCliente,@ListaPrecios), @Sucursal, @IDEnviar
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
INSERT @Tabla2(Renglon, RenglonID, SKU, Almacen , Precio, Cantidad,DescuentoLinea, ID, CodigoCR)
SELECT         NULL , NULL,        SKU, @Almacen , Precio, Cantidad ,DescuentoLinea, ID, CodigoCR
FROM OPENXML (@iSolicitud, '/Intelisis/Solicitud/Pedido/PedidoD',1)
WITH (SKU varchar(50), Precio  float, Cantidad float, DescuentoLinea float, ID int, CodigoCR varchar(50))
EXEC sp_xml_removedocument @iSolicitud
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
INSERT INTO @TablaVentaDWeb (ID, Campo, Valor)
SELECT        ID, Campo, Valor
FROM OPENXML (@iSolicitud, '/Intelisis/Solicitud/Pedido/PedidoD/CamposConfigurables/CampoConfigurable',1)
WITH (ID int '../../@ID', Campo varchar(50), Valor varchar(max))
EXEC sp_xml_removedocument @iSolicitud
SET @Renglon = 0.0
SET @RenglonID = 0
SET @RenglonIDSerieLote = 0
UPDATE @Tabla2
SET @Renglon = Renglon = @Renglon + 2048.0, @RenglonID = RenglonID = @RenglonID +1, Articulo = dbo.fnWebSKUArticulo(SKU), SubCuenta = dbo.fnWebSKUArticuloSubCuenta(SKU), Unidad = (SELECT  Unidad FROM Art WHERE Articulo = dbo.fnWebSKUArticulo(SKU))
FROM @Tabla2
UPDATE @Tabla2
SET Articulo = dbo.fnWebArticuloCR(@Sucursal, Precio), SubCuenta = dbo.fnWebSubCuentaCR(@SubCuenta, Precio)
FROM @Tabla2
WHERE SKU = 'CR'
IF @Ok IS NULL
BEGIN
INSERT Venta (Empresa, Mov, Estatus,  FechaEmision, Moneda, TipoCambio, Cliente, Usuario, Almacen, ListaPreciosEsp, Sucursal, SucursalOrigen, SucursalDestino, EnviarA, DescuentoGlobal,  Observaciones,  Referencia,  Condicion,      Agente,  OrigenTipo, FechaRequerida )
SELECT        Empresa, Mov, Estatus,  FechaEmision, Mon,    TipoCambio, Cliente, Usuario, Almacen, ListaPreciosEsp, Sucursal, Sucursal,       Sucursal,        EnviarA, 0,				@Observaciones, @Referencia, @Condicion,@Agente, 'eCommerce',		@FechaEntrega
FROM @Tabla
IF @@ERROR <> 0 SET @Ok = 1
SELECT @IDGenerar = SCOPE_IDENTITY()
IF @Ok IS NULL AND @IDGenerar IS NOT NULL
BEGIN
DECLARE crDetalle CURSOR FOR
SELECT Renglon, RenglonID, Articulo, SubCuenta ,Almacen, Precio, Cantidad, Unidad, DescuentoLinea, ID, CodigoCR, SKU
FROM @Tabla2
OPEN crDetalle
FETCH NEXT FROM crDetalle INTO @Renglon, @RenglonID, @Articulo, @SubCuenta , @Almacen, @Precio, @Cantidad, @Unidad, @DescuentoLinea, @IDPedidoD, @CodigoCR, @SKUVentaD
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF NULLIF(@Articulo,'') IS NULL SELECT @Ok = 20400
IF @Cantidad IS NULL SELECT @Ok = 20015
EXEC spDesglosarPrecioCImpuestos2  @Articulo, @Usuario, @Empresa, @Sucursal, @Precio OUTPUT, @Cliente, 'VTAS', @Mov, @Impuesto1 OUTPUT, @Impuesto2 OUTPUT, @Impuesto3  OUTPUT
SELECT @DescuentoLinea = dbo.fneCommerceCalcDescuentosVenta(@DescuentoGlobal, @DescuentoLinea)
IF(ISNULL(@SubCuenta, '') = '')
EXEC speCommercePedidoCamposConfigurablesSubCuenta @iSolicitud, @Solicitud, @IDPedidoD, @Articulo, @SubCuenta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
INSERT VentaD(ID ,        Renglon,   RenglonID,  Articulo,  SubCuenta,  Almacen,  Precio, PrecioSugerido, Cantidad, CantidadInventario,  Unidad, Impuesto1,  Impuesto2,  Impuesto3, DescuentoLinea)
SELECT        @IDGenerar, @Renglon, @RenglonID, @Articulo, @SubCuenta ,@Almacen, @Precio, @Precio,		  @Cantidad, @Cantidad,          @Unidad, @Impuesto1, @Impuesto2, @Impuesto3, @DescuentoLinea
IF @@ERROR <> 0 SET @Ok = 1
IF @OK IS NULL AND @SKUVentaD = 'CR'
BEGIN
INSERT INTO Vale (Empresa, Mov,		 FechaEmision, Moneda, TipoCambio, Usuario, Estatus,	Sucursal, SucursalOrigen,	Concepto,		Tipo,	   Precio, Articulo, Almacen, FechaInicio, Vencimiento)
SELECT			  Empresa, @MovVale, GETDATE(),	   Mon,	 TipoCambio, Usuario, 'SINAFECTAR', @Sucursal, @Sucursal, @ConceptoVale, @TipoVale, @Precio, @Articulo, @Almacen, GETDATE(), GETDATE()
FROM @Tabla
SELECT @IDGenerarVale = SCOPE_IDENTITY()
IF @@ERROR <> 0 SELECT @Ok = 1, @OkRef = 'Al insertar Vale'
INSERT INTO ValeD (ID, Serie, Sucursal, SucursalOrigen, Importe)
SELECT				@IDGenerarVale, @CodigoCR, @Sucursal, @Sucursal, NULL
IF @@ERROR <> 0 SELECT @Ok = 1, @OkRef = 'Al insertar Detalle de Vale'
IF @Ok IS NULL AND @IDGenerar IS NOT NULL
EXEC spAfectar 'VALE', @IDGenerarVale, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1,  @Ok = @Error OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SET @RenglonIDSerieLote = @RenglonIDSerieLote + 1
INSERT INTO SerieLoteMov (
Empresa,
Modulo,
ID,
RenglonID,
Articulo,
SubCuenta,
SerieLote,
Cantidad,
CantidadAlterna,
Propiedades,
Ubicacion,
Cliente,
Localizacion,
Sucursal,
ArtCostoInv
)
SELECT
Empresa,
'VTAS',
@IDGenerar,
@RenglonIDSerieLote,
@Articulo,
@SubCuenta,
@CodigoCR,
@Cantidad,
NULL,
NULL,
NULL,
NULL,
NULL,
@Sucursal,
NULL
FROM @Tabla
END
END
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
DELETE FROM VentaDWeb WHERE ID = @IDGenerar AND Renglon = @Renglon AND RenglonSub = 0
INSERT VentaDWeb (ID,		  Renglon,  RenglonSub, Campo, Valor)
SELECT			  @IDGenerar, @Renglon, 0,			Campo, Valor
FROM @TablaVentaDWeb
WHERE ID = @IDPedidoD
END
FETCH NEXT FROM crDetalle INTO @Renglon, @RenglonID, @Articulo, @SubCuenta , @Almacen, @Precio, @Cantidad, @Unidad, @DescuentoLinea, @IDPedidoD, @CodigoCR, @SKUVentaD
END
CLOSE crDetalle
DEALLOCATE crDetalle
END
IF @Ok IS NULL AND NULLIF(@CostoFlete,'') IS NOT NULL AND ISNULL(NULLIF(@CostoFlete,''),0.0)>0.0
BEGIN
SELECT @ArticuloFlete = eCommerceArticuloFlete FROM Sucursal WHERE Sucursal = @Sucursal
SELECT  @Unidad = Unidad FROM Art WHERE Articulo = @ArticuloFlete
IF NULLIF(@ArticuloFlete,'') IS NOT NULL
BEGIN
SELECT @Renglon = MAX(Renglon)+2048.0, @RenglonID = MAX(RenglonID) +1 FROM VentaD WHERE ID = @IDGenerar
EXEC spDesglosarPrecioCImpuestos2  @ArticuloFlete , @Usuario, @Empresa, @Sucursal, @CostoFlete OUTPUT, @Cliente, 'VTAS', @Mov, @Impuesto1 OUTPUT, @Impuesto2 OUTPUT, @Impuesto3  OUTPUT
INSERT VentaD(ID ,        Renglon,   RenglonID,  Articulo,      Almacen,  Precio, PrecioSugerido, Cantidad, CantidadInventario,   Unidad, Impuesto1,  Impuesto2,  Impuesto3)
SELECT        @IDGenerar, @Renglon, @RenglonID, @ArticuloFlete, @Almacen, @CostoFlete, @CostoFlete,  1,     1,                   @Unidad, @Impuesto1, @Impuesto2, @Impuesto3
IF(@DescuentoFlete > 0) UPDATE VentaD SET DescuentoTipo = '%', DescuentoLinea = @DescuentoFlete WHERE ID = @IDGenerar AND Renglon = @Renglon AND RenglonID = @RenglonID
END
END
END
IF @Ok IS NULL AND @IDGenerar IS NOT NULL
EXEC spInvReCalcEncabezadoSimple  @Empresa, @IDGenerar, 'VTAS'
IF @Ok IS NULL AND @IDGenerar IS NOT NULL
EXEC speCommercePedidoEnvolturasRegalo @iSolicitud, @Solicitud, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @IDGenerar IS NOT NULL
EXEC speCommercePedidoCertificadosRegalo @iSolicitud, @Solicitud, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
SELECT @Importe = (Importe+Impuestos)-(Importe*ISNULL(DescuentoGlobal,0.0)/100) FROM Venta WHERE ID = @IDGenerar
IF @Prepagado = 1 AND NULLIF(@CtaDinero,'') IS NOT NULL AND @Ok IS NULL AND ISNULL(@Importe,0.0) >0.0 AND NULLIF(@Condicion,'') IS NOT NULL
BEGIN
INSERT VentaCobro(ID,         Importe1, FormaCobro1, Referencia1,          CtaDinero, Cajero)
SELECT            @IDGenerar, @Importe, @FormaPago,  @ReferenciaFormaPago, @CtaDinero, @Cajero
END
IF @Ok IS NULL AND @IDGenerar IS NOT NULL
EXEC spAfectar 'VTAS', @IDGenerar, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1,  @Ok = @Error OUTPUT, @OkRef = @OkRef OUTPUT
IF @Error IS NOT NULL AND @IDGenerar IS NOT NULL
UPDATE Venta SET Estatus = 'CONFIRMAR' WHERE ID = @IDGenerar
IF @Error IS NULL
SELECT @MovID = MovID FROM Venta WHERE ID = @IDGenerar
IF @Ok IS NULL
SELECT @ReferenciaIS = Referencia, @SubReferencia = SubReferencia
FROM IntelisisService
WHERE ID = @ID
IF @Ok IS NULL
SELECT @EstatusGenerado = Estatus
FROM Venta
WHERE ID = @IDGenerar
IF @Ok IS NULL
BEGIN
INSERT INTO eCommercePedido (IDVenta, Sucursal, IDPedido) VALUES (@IDGenerar, @Sucursal, @PedidoID)
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT @OkRef = 'ERROR: ' + CONVERT(varchar,@Ok) + ' '+ dbo.fneWebConvertirDescripcionHTML(ISNULL(@OkRef,'')) +'. '  +ISNULL((SELECT Descripcion FROM MensajeLista WHERE Mensaje = @Ok),'')
END
IF @Error IS NOT NULL
SET @Ok = @Error
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + ' Modulo="Venta" ModuloID =' + CHAR(34) + ISNULL(CONVERT(varchar,@IDGenerar),'') + CHAR(34) + ' Consecutivo='+ CHAR(34) +ISNULL(@Mov,'')+' '+ISNULL(@MovID,'')+ CHAR(34) +' EstatusMov='+ CHAR(34) +ISNULL(@EstatusGenerado,'')+ CHAR(34) + ' IDUsuario=' + CHAR(34) + ISNULL(CONVERT(varchar,@IDUsuario),'') + CHAR(34)+ ' IDEnviarA=' + CHAR(34) + ISNULL(CONVERT(varchar,@IDEnviar),'') + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '/></Intelisis>'
END
END

