SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpPOSConcatenaTicket
@CajaActual				varchar(20),
@CajeroActual			varchar(20),
@ID						varchar(50) = NULL,
@RecalcularTodo			bit   = 1,
@Accion					varchar(50) = NULL,
@ArtDescripcionRef		varchar(50) = NULL,
@ArtConsulta			varchar(50) = NULL,
@SucursalTrabajo		int = NULL,
@Ticket					varchar(MAX) OUTPUT,
@Totales				varchar(MAX) OUTPUT,
@Saldos					varchar(MAX) OUTPUT,
@Total					float	     OUTPUT,
@Saldo					float	     OUTPUT,
@CodigoAccion			varchar(30) = NULL,
@Estacion				int,
@DesgloseCC				bit = 0,
@EsImpresion			bit = 0
AS
BEGIN
DECLARE
@Ok								int,
@OkRef							varchar(255),
@LargoLineaTicket				int,
@LargoLineaTotales				int,
@LargoLineaSaldos				int,
@String							varchar(MAX),
@String2						varchar(MAX),
@Empresa						varchar(5),
@Sucursal						int,
@EmpresaNombre					varchar(100),
@EmpresaDireccion				varchar(100),
@EmpresaDireccionNumero			varchar(20),
@EmpresaDireccionNumeroInt		varchar(20),
@EmpresaColonia					varchar(30),
@EmpresaPoblacion				varchar(30),
@EmpresaDelegacion				varchar(100),
@EmpresaEstado					varchar(30),
@EmpresaPais					varchar(30),
@EmpresaCodigoPostal			varchar(15),
@EmpresaTelefonos				varchar(100),
@EmpresaFax						varchar(50),
@EmpresaRFC						varchar(20),
@SucursalNombre					varchar(100),
@SucursalDireccion				varchar(100),
@SucursalDireccionNumero		varchar(20),
@SucursalDireccionNumeroInt		varchar(20),
@SucursalColonia				varchar(30),
@SucursalPoblacion				varchar(30),
@SucursalDelegacion				varchar(100),
@SucursalEstado					varchar(30),
@SucursalPais					varchar(30),
@SucursalCodigoPostal			varchar(15),
@SucursalTelefonos				varchar(100),
@SucursalFax					varchar(50),
@Mov							varchar(20),
@MovID							varchar(20),
@MovClave						varchar(20),
@FechaEmision					DateTime,
@FechaEntrega					DateTime,
@FechaRegistro					DateTime,
@Concepto						varchar(50),
@Proyecto						varchar(50),
@UEN							int,
@Moneda							varchar(10),
@TipoCambio						float,
@Usuario						varchar(10),
@Referencia						varchar(50),
@Observaciones					varchar(200),
@Estatus						varchar(15),
@Cliente						varchar(10),
@CteEnviarA						int,
@Almacen						varchar(10),
@Agente							varchar(10),
@Cajero							varchar(10),
@FormaEnvio						varchar(50),
@Condicion						varchar(50),
@Vencimiento					datetime,
@Descuento						varchar(30),
@DescuentoGlobal				float,
@ListaPreciosEsp				varchar(20),
@ZonaImpuesto					varchar(30),
@Origen							varchar(20),
@OrigenID						varchar(20),
@CteNombre						varchar(100),
@CteDireccion					varchar(100),
@CteDireccionNumero				varchar(20),
@CteDireccionNumeroInt			varchar(20),
@CteColonia						varchar(100),
@CtePoblacion					varchar(100),
@CteDelegacion					varchar(100),
@CteEstado						varchar(30),
@CtePais						varchar(30),
@CteCodigoPostal				varchar(15),
@CteTelefonos					varchar(100),
@CteRFC							varchar(15),
@CteEnviarANombre				varchar(100),
@CteEnviarADireccion			varchar(100),
@CteEnviarADireccionNumero		varchar(20),
@CteEnviarADireccionNumeroInt	varchar(20),
@CteEnviarAColonia				varchar(100),
@CteEnviarAPoblacion			varchar(100),
@CteEnviarADelegacion			varchar(100),
@CteEnviarAEstado				varchar(30),
@CteEnviarAPais					varchar(30),
@CteEnviarACodigoPostal			varchar(15),
@CteEnviarATelefonos			varchar(100),
@CodigoBarras					varchar(30),
@Articulo						varchar(20),
@Unidad							varchar(50),
@SubCuenta						varchar(50),
@ArtDescripcion					varchar(100),
@Cantidad						float,
@CantidadObsequio				float,
@Precio							float,
@DescuentoLinea					money,
@DescuentoLineaAcumulado		money,
@Impuesto1						float,
@Impuesto2						float,
@Impuesto3						float,
@SubTotal						float,
@TotalDescuento					float,
@TotalImpuesto1					float,
@CodigoFormaPago				varchar(50),
@FormaPago						varchar(50),
@Importe						float,
@ImporteCobrado					float,
@SumaCobrado					float,
@RedondeoVenta					bit,
@CodigoRedondeo					varchar(30),
@ArticuloRedondeo				varchar(20),
@Redondeo						float,
@Inventario						float,
@CtaDinero						varchar(10),
@CtaDineroDestino				varchar(10),
@FechaAmortizacion				datetime,
@ImporteAmortizacion			float,
@InteresAmortizacion			float,
@TotalAmortizacion				float,
@CajaAbierta					bit,
@MovOrden						int,
@ImporteRef						float,
@POSMoneda						varchar(20),
@SucursalInv					int,
@SucursalInvNombre				char(10),
@IDTemp                         int,
@Beneficiario                   varchar(100),
@Renglon                        float,
@OfertaPuntos                   float,
@OfertaPrecio                   float,
@LineaAhorro                    varchar(255),
@Ahorro                         float,
@PuntosUtilizados               float,
@Monedero                       varchar(20),
@MonedaMonedero                 varchar(50),
@Puntos                         float,
@PrecioSugerido                 float,
@Aplicado                       bit,
@POSImpuestoIncluido            bit,
@PrecioImpuestoInc              float,
@UsuarioPerfil                  varchar(10),
@Numero                         int,
@ConceptoCXC                    varchar(50),
@TotalCxc                       float,
@Descripcion                    varchar(20),
@Descripcion2                   varchar(20),
@Host                           varchar(20),
@Cluster                        varchar(20),
@OfertaID                       int,
@NoCertificadoSAT               varchar(20),
@UUID                           varchar(50),
@Sello							varchar(255),
@SelloSat                       varchar(255),
@CadenaOriginal					varchar(max),
@FechaTimbrado                  datetime,
@NoCertificado					varchar(20),
@AplicaDescGlobal               bit,
@SubClave                       varchar(20),
@EmidaResponseMessage           varchar(500),
@ArticuloOfertaFP               varchar(20),
@AlmacenDestino                 varchar(10),
@AlmacenDestinoNombre           varchar(100),
@AlmacenD                       varchar(10),
@AlmacenDNombre                 varchar(30),
@AlmacenNombre                  varchar(100),
@PedidoReferencia               varchar(50),
@MovSubClave                    varchar(20),
@Aplica                         varchar(20),
@AplicaID                       varchar(20),
@CXCSaldoTotal                  float,
@AlmacenV						varchar(10),
@AlmacenVNombre					varchar(10),
@FormaEnvioV					varchar(50),
@ConceptoDIN                    varchar(50),
@Orden							int,
@ControlAnticipos				varchar(20),
@Cadena                         varchar(max),
@ImporteMov						float,
@ImpuestosMov					float,
@ClaveCte                       varchar(10),
@ValidacionTEMP					int,
@OrdenCorteCaja					int,
@OrdenMovAnterior				int,
@FechaCorteCaja					datetime,
@CampoCorteTemp					varchar(max),
@DirectorioEstilo               varchar(256),
@CtaDineroMM					varchar(10),
@CtaDineroMMDescripcion			varchar(100)
EXEC spPOSHost @Host OUTPUT, @Cluster OUTPUT
IF @EsImpresion = 0
SELECT @LargoLineaTicket = 110, @LargoLineaTotales = 70, @LargoLineaSaldos = 70
ELSE
SELECT @LargoLineaTicket = 52, @LargoLineaTotales = 50, @LargoLineaSaldos = 50
IF @RecalcularTodo = 1
BEGIN
SELECT
@Empresa = e.Empresa,
@EmpresaNombre = e.Nombre,
@EmpresaDireccion = e.Direccion,
@EmpresaDireccionNumero = e.DireccionNumero,
@EmpresaDireccionNumeroInt = e.DireccionNumeroInt,
@EmpresaColonia = e.Colonia,
@EmpresaPoblacion = e.Poblacion,
@EmpresaDelegacion = e.Delegacion,
@EmpresaEstado = e.Estado,
@EmpresaPais = e.Pais,
@EmpresaCodigoPostal = e.CodigoPostal,
@EmpresaTelefonos = e.Telefonos,
@EmpresaFax = e.Fax,
@EmpresaRFC = e.RFC
FROM Empresa e
INNER JOIN POSL p ON e.Empresa = p.Empresa AND p.ID = @ID
SELECT
@SucursalNombre = s.Nombre,
@SucursalDireccion = s.Direccion,
@SucursalDireccionNumero = s.DireccionNumero,
@SucursalDireccionNumeroInt = s.DireccionNumeroInt,
@SucursalColonia = s.Colonia,
@SucursalPoblacion = s.Poblacion,
@SucursalDelegacion = s.Delegacion,
@SucursalEstado = s.Estado,
@SucursalPais = s.Pais,
@SucursalCodigoPostal = s.CodigoPostal,
@SucursalTelefonos = s.Telefonos,
@SucursalFax = s.Fax,
@Sucursal=s.Sucursal
FROM Sucursal s
INNER JOIN POSL p ON p.Sucursal = s.Sucursal AND p.ID = @ID
IF @EsImpresion = 1
BEGIN
SELECT @String = '<BR>' + dbo.fnAlinearCampoValor2(dbo.fnCentrar(UPPER(@EmpresaNombre), @LargoLineaTicket-4), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SELECT @String = dbo.fnAlinearCampoValor2(dbo.fnCentrar(ISNULL(UPPER(@EmpresaDireccion) , '')+ ' ' + ISNULL(UPPER(@EmpresaDireccionNumero), '')+ ' ' +
ISNULL(UPPER(@EmpresaDireccionNumeroInt), ''), @LargoLineaTicket-4), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SELECT @String = dbo.fnAlinearCampoValor2(dbo.fnCentrar(ISNULL(UPPER('COL.' + @EmpresaColonia), ''), @LargoLineaTicket-4), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
IF NULLIF(@EmpresaPoblacion,'') IS NOT NULL
BEGIN
SELECT @String = dbo.fnAlinearCampoValor2(dbo.fnCentrar(ISNULL(UPPER(@EmpresaPoblacion), ''), @LargoLineaTicket-4), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
SELECT @String = dbo.fnAlinearCampoValor2(dbo.fnCentrar(ISNULL(UPPER(@EmpresaDelegacion + ', ' +
ISNULL(@EmpresaEstado, '')), ''), @LargoLineaTicket-4), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SELECT @String = dbo.fnAlinearCampoValor2(dbo.fnCentrar(ISNULL(UPPER('RFC: ' + @EmpresaRFC), ''), @LargoLineaTicket-4), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SELECT @String = dbo.fnAlinearCampoValor2(dbo.fnCentrar(ISNULL(UPPER('Telefonos: ' + @EmpresaTelefonos), ''), @LargoLineaTicket-4), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SELECT @Ticket = ISNULL(@Ticket,'')  + dbo.fnAlinearCampoValor2(dbo.fnCentrar(UPPER('DATOS SUCURSAL:'), @LargoLineaTicket-4), '<BR>', @LargoLineaTicket)
SELECT @String = dbo.fnAlinearCampoValor2(dbo.fnCentrar(UPPER(ISNULL(@SucursalNombre,'')), @LargoLineaTicket-4), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SELECT @String = dbo.fnAlinearCampoValor2(dbo.fnCentrar(ISNULL(UPPER(@SucursalDireccion), '') + ' ' + ISNULL(UPPER(@SucursalDireccionNumero), '')+ ' ' +
ISNULL(UPPER(@SucursalDireccionNumeroInt), ''), @LargoLineaTicket-4), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SELECT @String = dbo.fnAlinearCampoValor2(dbo.fnCentrar(ISNULL(UPPER('COL. ' + @SucursalColonia), ''), @LargoLineaTicket-4), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SELECT @String = dbo.fnAlinearCampoValor2(dbo.fnCentrar(ISNULL(UPPER(@SucursalPoblacion), ''), @LargoLineaTicket-4), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SELECT @String = dbo.fnAlinearCampoValor2(dbo.fnCentrar(ISNULL(UPPER(@SucursalDelegacion + ', ' +
ISNULL(@SucursalEstado, '')), ''), @LargoLineaTicket-4), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SELECT @String = dbo.fnAlinearCampoValor2(dbo.fnCentrar(ISNULL(UPPER('Telefonos: ' + @SucursalTelefonos), ''), @LargoLineaTicket-4), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF @ID IS NOT NULL
BEGIN
SELECT
@Mov = p.Mov,
@MovID = p.MovID,
@MovClave = mt.Clave,
@FechaEmision = p.FechaEmision,
@FechaEntrega = p.FechaEntrega,
@FechaRegistro = p.FechaRegistro,
@Concepto = p.Concepto,
@Proyecto = p.Proyecto,
@UEN	= p.UEN,
@Moneda = p.Moneda,
@TipoCambio = p.TipoCambio,
@Usuario = p.Usuario,
@Referencia	= p.Referencia,
@Observaciones = p.Observaciones,
@Estatus = p.Estatus,
@Cliente = p.Cliente,
@CteEnviarA = p.EnviarA,
@Almacen = p.Almacen,
@Agente = p.Agente,
@Cajero = p.Cajero,
@CtaDinero = p.CtaDinero,
@CtaDineroDestino = p.CtaDineroDestino,
@FormaEnvio = p.FormaEnvio,
@Condicion = p.Condicion,
@Vencimiento	= p.Vencimiento,
@Descuento = p.Descuento,
@DescuentoGlobal = p.DescuentoGlobal,
@ListaPreciosEsp = p.ListaPreciosEsp,
@ZonaImpuesto = p.ZonaImpuesto,
@Origen = p.Origen,
@OrigenID = p.OrigenID,
@Importe = p.Importe,
@Monedero = p.Monedero,
@NoCertificadoSAT =   p.NoCertificadoSAT,
@UUID  =   p.UUID,
@Sello =  p.Sello,
@SelloSat =  p.SelloSat,
@CadenaOriginal = p.CadenaOriginal,
@FechaTimbrado  = p.FechaTimbrado,
@NoCertificado = p.Certificado,
@Beneficiario = p.BeneficiarioNombre,
@SubClave = mt.SubClave,
@EmidaResponseMessage = p.EmidaResponseMessage,
@AlmacenDestino = p.AlmacenDestino,
@PedidoReferencia = p.PedidoReferencia,
@MovSubClave = mt.SubClave,
@CXCSaldoTotal = p.CXCSaldoTotal
FROM POSL p
INNER JOIN MovTipo mt ON p.Mov = mt.Mov AND mt.Modulo = 'POS'
WHERE p.ID = @ID
SELECT
@ClaveCte = c.Cliente,
@CteNombre = c.Nombre,
@CteDireccion = c.Direccion,
@CteDireccionNumero = c.DireccionNumero,
@CteDireccionNumeroInt = c.DireccionNumeroInt,
@CteColonia = c.Colonia,
@CtePoblacion = c.Poblacion,
@CteDelegacion = c.Delegacion,
@CteEstado = c.Estado,
@CtePais = c.Pais,
@CteCodigoPostal = c.CodigoPostal,
@CteTelefonos = c.Telefonos,
@CteRFC = RFC
FROM Cte c
WHERE c.Cliente = @Cliente
SELECT @AlmacenDestinoNombre = Nombre FROM Alm WHERE Almacen = @AlmacenDestino
SELECT @AlmacenNombre = Nombre FROM Alm WHERE Almacen = @Almacen
SELECT @UsuarioPerfil = NULLIF(POSPerfil,'') FROM Usuario WHERE Usuario = @Usuario
IF @EsImpresion = 1
SELECT @Ticket = ISNULL(@Ticket,'') + REPLICATE('-', @LargoLineaTicket+CASE WHEN @EsImpresion=0 THEN 32 ELSE 0 END) + '<BR>'
IF @EsImpresion = 0
BEGIN
SELECT @DirectorioEstilo = Directorio
FROM POSUsuarioEstacion
WHERE Empresa = @Empresa
AND Sucursal = @Sucursal
AND Usuario = @Usuario
AND Estacion = @Estacion
SET @DirectorioEstilo = ISNULL(@DirectorioEstilo,'')
IF ISNULL(@DirectorioEstilo,'') <> '' AND RIGHT(@DirectorioEstilo,1) <> '\'
SET @DirectorioEstilo = @DirectorioEstilo + '\'
SET @String = ''
SET @String = @String + '<!DOCTYPE HTML>'
SET @String = @String + '<html>'
SET @String = @String + '<head>'
SET @String = @String + '<title>Ticket POS</title>'
SET @String = @String + '<meta name="viewport" content="width=device-width, initial-scale=1">'
SET @String = @String + '<meta http-equiv="Content-Type" content="text/html; charset=latin1" />'
SET @String = @String + '<meta name="keywords" content="POS, SDK"/>'
SET @String = @String + '<base href="'+@DirectorioEstilo+'">'
SET @String = @String + '<link href="web/css/bootstrap.min.css" rel="stylesheet" type="text/css" />'
SET @String = @String + '<link href="web/css/style.css" rel="stylesheet" type="text/css" />'
SET @String = @String + '<link rel="stylesheet" href="web/css/morris.css" type="text/css"/>'
SET @String = @String + '<link href="web/css/font-awesome.css" rel="stylesheet">'
SET @String = @String + '<link rel="stylesheet" type="text/css" href="web/css/table-style.css" />'
SET @String = @String + '<link rel="stylesheet" type="text/css" href="web/css/basictable.css" />'
SET @String = @String + '<link rel="stylesheet" href="web/css/icon-font.min.css" type="text/css" />'
SET @String = @String + '</head>'
SET @String = @String + '<body>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
END
IF @EsImpresion = 1
BEGIN
SELECT @String = dbo.fnAlinearCampoValor2(((ISNULL('MOVIMIENTO: ' + (RTRIM(LTRIM(@Mov)) + ' ' + ISNULL(@MovID,'')), '')) + '                    	         ' +
dbo.fnCentrar(ISNULL('FECHA: ' + CONVERT(varchar,@FechaEmision, 105), ''), @LargoLineaTicket)), '', @LargoLineaTicket) + '<BR>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF @EsImpresion = 0
BEGIN
SELECT @String = @String + '<table width="100%" style="margin:0;">'
SELECT @String = @String + '  <tr style="border-bottom:0px;">'
SELECT @String = @String + '    <th style="text-align:left; padding:3px 12px; border-bottom:0px; background:#337ab7;">MOVIMIENTO: ' + ISNULL(RTRIM(LTRIM(@Mov)),'') + ' ' + ISNULL(@MovID,'') + '</th>'
SELECT @String = @String + '    <th style="text-align:right; padding:3px 12px; border-bottom:0px; background:#337ab7;">FECHA: '+ ISNULL(CONVERT(varchar,@FechaEmision, 105), '') + '</th>'
SELECT @String = @String + '  </tr>'
SELECT @String = @String + '</table>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
EXEC spPOSGenereDoctos @ID,@Mov,@Cadena OUTPUT
IF @MovClave IN ('POS.N', 'POS.A', 'POS.F','POS.P','POS.P','POS.NPC','POS.NPC','POS.FA','POS.CXCC','POS.CXCD')
BEGIN
IF @EsImpresion = 1
BEGIN
SELECT @String = dbo.fnAlinearCampoValor2((ISNULL('CLIENTE:            '+UPPER(@CteNombre), '')), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SELECT @String = dbo.fnAlinearCampoValor2((ISNULL(UPPER('RFC:                    ' + @CteRFC), '')), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
IF NULLIF(@Condicion,'')IS NOT NULL
BEGIN
SELECT @String = dbo.fnAlinearCampoValor2((ISNULL(UPPER('Condiciones: ' + @Condicion), '')), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF NULLIF(@Origen,'') IS NOT NULL
BEGIN
SELECT @Ticket = @Ticket + '<BR>'
SELECT @String = dbo.fnAlinearCampoValor2(dbo.fnCentrar(ISNULL(UPPER('ORIGEN: ' + LTRIM(RTRIM(@Origen)) + ' ' +
@OrigenID), ''), @LargoLineaTicket-4), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
END
IF @EsImpresion = 0
BEGIN
SET @String = ''
SELECT @String = @String + '<table width="100%">'
SELECT @String = @String + '  <tr>'
SELECT @String = @String + '    <th style="text-align:left; padding:3px 12px; border-bottom:0px; background:#337ab7;">CLIENTE: ' + ISNULL(RTRIM(LTRIM(UPPER(@CteNombre))),'') + ' ' + ISNULL(@MovID,'') + '</th>'
SELECT @String = @String + '    <th style="text-align:right; padding:3px 12px; border-bottom:0px; background:#337ab7;">RFC: '+ ISNULL(UPPER(@CteRFC), '') + '</th>'
SELECT @String = @String + '  </tr>'
SELECT @String = @String + '</table>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
IF NULLIF(@Condicion,'')IS NOT NULL
BEGIN
SET @String = ''
SELECT @String = @String + '<table width="100%">'
SELECT @String = @String + '  <tr>'
SELECT @String = @String + '    <th style="text-align:left; padding:3px 12px; border-bottom:0px; background:#337ab7;">CONDICIONES: ' + ISNULL(RTRIM(LTRIM(UPPER(@Condicion))),'') + '</th>'
SELECT @String = @String + '  </tr>'
SELECT @String = @String + '</table>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF NULLIF(@Origen,'') IS NOT NULL
BEGIN
SET @String = ''
SELECT @String = @String + '<table width="100%">'
SELECT @String = @String + '  <tr>'
SELECT @String = @String + '    <th style="text-align:left; padding:3px 12px; border-bottom:0px; background:#337ab7;">ORIGEN: ' + ISNULL(RTRIM(LTRIM(UPPER(@Origen))),'') + ' ' + ISNULL(RTRIM(LTRIM(UPPER(@OrigenID))),'')+ '</th>'
SELECT @String = @String + '  </tr>'
SELECT @String = @String + '</table>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
END
END
IF @EsImpresion = 1
BEGIN
IF NULLIF(@Cajero,'') IS NOT NULL
BEGIN
SELECT @String = dbo.fnAlinearCampoValor2((ISNULL(UPPER('CAJERO:       ' + @Cajero), '	') + '                                ' +
ISNULL(UPPER('AGENTE: ' + @Agente), '')), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF NULLIF(@Monedero,'') IS NOT NULL
BEGIN
SELECT @String ='<BR>'+ dbo.fnAlinearCampoValor2(dbo.fnCentrar(ISNULL(UPPER('MONEDERO : ' +
ISNULL(@Monedero,'')), ''), @LargoLineaTicket-4), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF NULLIF(@PedidoReferencia,'') IS NOT NULL
BEGIN
SELECT @String ='<BR>'+ dbo.fnAlinearCampoValor2(dbo.fnCentrar(ISNULL(UPPER('Pedido Referencia : ' +
ISNULL(@PedidoReferencia,'')), ''), @LargoLineaTicket-4), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
END
IF @EsImpresion = 0
BEGIN
IF NULLIF(@Cajero,'') IS NOT NULL
BEGIN
SET @String = ''
SELECT @String = @String + '<table width="100%">'
SELECT @String = @String + '  <tr>'
SELECT @String = @String + '    <th style="text-align:left; padding:3px 12px; border-bottom:0px; background:#337ab7;">CAJERO: ' + ISNULL(UPPER(@Cajero),'') + '</th>'
SELECT @String = @String + '    <th style="text-align:right; padding:3px 12px; border-bottom:0px; background:#337ab7;">AGENTE: '+ ISNULL(UPPER(@Agente), '') + '</th>'
SELECT @String = @String + '  </tr>'
SELECT @String = @String + '</table>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF NULLIF(@Monedero,'') IS NOT NULL
BEGIN
SET @String = ''
SELECT @String = @String + '<table width="100%">'
SELECT @String = @String + '  <tr>'
SELECT @String = @String + '    <th style="text-align:left; padding:3px 12px; border-bottom:0px; background:#337ab7;">MONEDERO: ' + ISNULL(UPPER(@Monedero),'') + '</th>'
SELECT @String = @String + '  </tr>'
SELECT @String = @String + '</table>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF NULLIF(@PedidoReferencia,'') IS NOT NULL
BEGIN
SET @String = ''
SELECT @String = @String + '<table width="100%">'
SELECT @String = @String + '  <tr>'
SELECT @String = @String + '    <th style="text-align:left; padding:3px 12px; border-bottom:0px; background:#337ab7;">PEDIDO REFERENCIA: ' + ISNULL(UPPER(@PedidoReferencia),'') + '</th>'
SELECT @String = @String + '  </tr>'
SELECT @String = @String + '</table>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
END
IF @MovClave IN('POS.CXCD')
BEGIN
SELECT TOP 1 @Aplica = Aplica, @AplicaID = AplicaID FROM POSLVenta WHERE ID = @ID
IF @Aplica IS NOT NULL AND @AplicaID IS NOT NULL
BEGIN
IF @EsImpresion = 1
BEGIN
SELECT @String ='<BR>'+ dbo.fnAlinearCampoValor2(dbo.fnCentrar(ISNULL(UPPER('Aplica : ' +
ISNULL(@Aplica+' '+@AplicaID,'')), ''), @LargoLineaTicket-4), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
IF @CXCSaldoTotal IS NOT NULL
BEGIN
SELECT @String ='<BR>'+ dbo.fnAlinearCampoValor2(dbo.fnCentrar(ISNULL(UPPER('Saldo Total : ' +
dbo.fnFormatoMoneda(@CXCSaldoTotal,@Empresa)), ''), @LargoLineaTicket-4), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
END
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '<table width="100%">'
SET @String = @String + '  <tr>'
SET @String = @String + '    <th style="text-align:left; padding:3px 12px; border-bottom:0px; background:#337ab7;">APLICA: ' + ISNULL(UPPER(@Aplica),'') + ISNULL(UPPER(@AplicaID),'') + '</th>'
SET @String = @String + '  </tr>'
SET @String = @String + '</table>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
IF @CXCSaldoTotal IS NOT NULL
BEGIN
SET @String = ''
SET @String = @String + '<table width="100%">'
SET @String = @String + '  <tr>'
SET @String = @String + '    <th style="text-align:left; padding:3px 12px; border-bottom:0px; background:#337ab7;">SALDO TOTAL: ' + ISNULL(dbo.fnFormatoMoneda(@CXCSaldoTotal,@Empresa),'') + '</th>'
SET @String = @String + '  </tr>'
SET @String = @String + '</table>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
END
END
END
IF @MovClave IN('POS.FA') AND @MovSubClave = 'POS.ANTREF'
BEGIN
IF @EsImpresion = 1
BEGIN
SELECT @String ='<BR>'+ dbo.fnAlinearCampoValor2(dbo.fnCentrar(ISNULL(UPPER('Saldo PEDIDO : ' +
dbo.fnFormatoMoneda(@CXCSaldoTotal,@Empresa)), ''), @LargoLineaTicket-4), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '<table width="100%">'
SET @String = @String + '  <tr>'
SET @String = @String + '    <th style="text-align:left; padding:3px 12px; border-bottom:0px; background:#337ab7;">SALDO PEDIDO: ' + ISNULL(dbo.fnFormatoMoneda(@CXCSaldoTotal,@Empresa),'') + '</th>'
SET @String = @String + '  </tr>'
SET @String = @String + '</table>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
END
IF @MovClave = 'POS.EC'
BEGIN
IF @EsImpresion = 1
BEGIN
SELECT @String ='<BR>'+ dbo.fnAlinearCampoValor2(dbo.fnCentrar(ISNULL(UPPER('BENEFICIARIO : ' +
ISNULL(@Beneficiario,'')), ''), @LargoLineaTicket-4), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '<table width="100%">'
SET @String = @String + '  <tr>'
SET @String = @String + '    <th style="text-align:left; padding:3px 12px; border-bottom:0px; background:#337ab7;">BENEFICIARIO: ' + ISNULL(UPPER(@Beneficiario),'') + '</th>'
SET @String = @String + '  </tr>'
SET @String = @String + '</table>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
END
IF @MovClave IN('POS.INVD', 'POS.INVA')
BEGIN
IF @EsImpresion = 1
BEGIN
IF NULLIF(@Almacen,'')IS NOT NULL
BEGIN
SELECT @String = CASE WHEN @EsImpresion= 1 THEN '<BR>' ELSE '' END +
dbo.fnAlinearCampoValor2(dbo.fnCentrar(ISNULL(UPPER('Almacen Origen:   ' + @Almacen+ ' ' +
SUBSTRING(@AlmacenNombre,1,30)), ''), @LargoLineaTicket-4), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF NULLIF(@AlmacenDestino,'')IS NOT NULL
BEGIN
SELECT @String = dbo.fnAlinearCampoValor2(dbo.fnCentrar(ISNULL(UPPER('Almacen Destino: ' + @AlmacenDestino+ ' ' +
SUBSTRING(@AlmacenDestinoNombre,1,30)), ''), @LargoLineaTicket-4), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
END
IF @EsImpresion = 0
BEGIN
IF NULLIF(@Almacen,'')IS NOT NULL
BEGIN
SET @String = ''
SET @String = @String + '<table width="100%">'
SET @String = @String + '  <tr>'
SET @String = @String + '    <th style="text-align:left; padding:3px 12px; border-bottom:0px; background:#337ab7;">ALMACEN ORIGEN: ' + ISNULL(UPPER(@Almacen),'')+ ' ' + SUBSTRING(UPPER(ISNULL(@AlmacenNombre,'')),1,30) + '</th>'
SET @String = @String + '  </tr>'
SET @String = @String + '</table>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF NULLIF(@AlmacenDestino,'')IS NOT NULL
BEGIN
SET @String = ''
SET @String = @String + '<table width="100%">'
SET @String = @String + '  <tr>'
SET @String = @String + '    <th style="text-align:left; padding:3px 12px; border-bottom:0px; background:#337ab7;">ALMACEN DESTINO: ' + ISNULL(UPPER(@AlmacenDestino),'')+ ' ' + SUBSTRING(UPPER(ISNULL(@AlmacenDestinoNombre,'')),1,30) + '</th>'
SET @String = @String + '  </tr>'
SET @String = @String + '</table>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
END
END
IF @MovClave IN('POS.CC','POS.CCM') AND @DesgloseCC = 1
BEGIN
EXEC spPOSTicketDesgloseCorte    @ID, @Empresa, @Sucursal, @Host, @Usuario, @MovClave, @CtaDinero, @Estacion, @LargoLineaTicket, @String2 OUTPUT, @Ok  OUTPUT, @OkRef  OUTPUT
SELECT @Ticket = @Ticket +'<BR>'+ISNULL(@String2,'')
END
IF @MovClave IN ('POS.AC','POS.AP', 'POS.CC', 'POS.CPC','POS.CAC','POS.CCC')
BEGIN
IF @EsImpresion = 1
BEGIN
SELECT @Ticket = @Ticket + '<BR>' + REPLICATE('-', @LargoLineaTicket +CASE WHEN @EsImpresion=0 THEN 32 ELSE 0 END) + '<BR>' +
dbo.fnCentrar(UPPER('Cuenta'), @LargoLineaTicket /2) + dbo.fnCentrar(UPPER('Cuenta Destino'), @LargoLineaTicket /2)  + '<BR>' +
REPLICATE('-', @LargoLineaTicket+CASE WHEN @EsImpresion=0 THEN 32 ELSE 0 END) + '<BR>'
SELECT @String = dbo.fnCentrar(ISNULL(@CtaDinero,''), @LargoLineaTicket/2) + dbo.fnCentrar(ISNULL(@CtaDineroDestino,''), @LargoLineaTicket/2) + '<BR>'
SELECT @Ticket = @Ticket + @String
END
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '<table width="100%">'
SET @String = @String + '  <tr>'
SET @String = @String + '    <th style="text-align:left; padding:3px 12px; border-bottom:0px; background:#337ab7;">CUENTA: ' + ISNULL(UPPER(@CtaDinero),'') + '</th>'
SET @String = @String + '    <th style="text-align:right; padding:3px 12px; border-bottom:0px; background:#337ab7;">CUENTA DESTINO: ' + ISNULL(UPPER(@CtaDineroDestino),'') + '</th>'
SET @String = @String + '  </tr>'
SET @String = @String + '</table>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
END
IF @MovClave IN ('POS.IC', 'POS.EC')
BEGIN
IF @EsImpresion = 1
BEGIN
SELECT @Ticket = @Ticket + '<BR>' + REPLICATE('-', @LargoLineaTicket +CASE WHEN @EsImpresion=0 THEN 32 ELSE 0 END) + '<BR>' +
dbo.fnCentrar(UPPER('Cuenta :'), @LargoLineaTicket /2) + dbo.fnCentrar(ISNULL(@CtaDinero,''), @LargoLineaTicket /2)  + '<BR>' +
REPLICATE('-', @LargoLineaTicket+CASE WHEN @EsImpresion=0 THEN 32 ELSE 0 END) + '<BR>'
SELECT @Ticket = @Ticket + '<BR>'
END
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '<table width="100%">'
SET @String = @String + '  <tr>'
SET @String = @String + '    <th style="text-align:left; padding:3px 12px; border-bottom:0px; background:#337ab7;">CUENTA: ' + ISNULL(UPPER(@CtaDinero),'') + '</th>'
SET @String = @String + '  </tr>'
SET @String = @String + '</table>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
END
IF @CteEnviarA IS NOT NULL
BEGIN
SELECT @CteEnviarANombre = c.Nombre
FROM CteEnviarA c
WHERE c.Cliente = @Cliente
AND c.ID = @CteEnviarA
IF @EsImpresion = 1
BEGIN
SELECT @Ticket = @Ticket + '<BR>' +
CASE @Cliente WHEN NULL THEN ''
ELSE dbo.fnCentrar(ISNULL(UPPER('SUCURSAL: ' + @CteEnviarANombre), ''), @LargoLineaTicket)
END + '<BR>'
END
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '<table width="100%">'
SET @String = @String + '  <tr>'
SET @String = @String + '    <th style="text-align:center; padding:3px 12px; border-bottom:0px; background:#337ab7;">SUCURSAL: ' + ISNULL(UPPER(@CteEnviarANombre),'') + '</th>'
SET @String = @String + '  </tr>'
SET @String = @String + '</table>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
END
IF @MovClave IN ('POS.N', 'POS.A', 'POS.F','POS.P','POS.NPC')
BEGIN
SELECT @CodigoRedondeo = pc.RedondeoVentaCodigo,
@RedondeoVenta = pc.RedondeoVenta,
@POSImpuestoIncluido = ISNULL(ImpuestoIncluido,0),
@ArticuloOfertaFP = pc.ArtOfertaFP
FROM POSCfg pc
WHERE pc.Empresa = @Empresa
SELECT @ArticuloRedondeo = cb.Cuenta
FROM CB
WHERE CB.Cuenta = @CodigoRedondeo
AND CB.TipoCuenta = 'Articulos'
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '<table width="100%" style="border-spacing:0px; border-color:#A8A4A4;">'
SET @String = @String + '  <tr style="background-color:#333; border-spacing:0px; border-color:#333;">'
SET @String = @String + '    <th style="text-align:left; color:#f5f5f5; background:#777;">CANT</th>'
SET @String = @String + '    <th style="text-align:left; color:#f5f5f5; background:#777;">PRODUCTO</th>'
SET @String = @String + '    <th style="text-align:left; color:#f5f5f5; background:#777;">DESCRIPCION</th>'
SET @String = @String + '    <th style="text-align:right; color:#f5f5f5; background:#777;">PRECIO</th>'
SET @String = @String + '    <th style="text-align:right; color:#f5f5f5; background:#777;">DESCTO</th>'
SET @String = @String + '    <th style="text-align:right; color:#f5f5f5; background:#777;">IMPORTE</th>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF @EsImpresion = 1
BEGIN
SELECT @Ticket = @Ticket + '<BR>' + REPLICATE('-', @LargoLineaTicket) + '<BR>' + '   CANT '  + ' PRODUCTO ' + ' ' +
dbo.fnAlinearDerecha('PRECIO', 9)  + dbo.fnAlinearDerecha('DESCTO.', 8) +  dbo.fnAlinearDerecha('IMPORTE',8) +
'<BR>' + REPLICATE('-', @LargoLineaTicket) + '<BR>'
END
IF EXISTS(SELECT * FROM POSLVenta WHERE ID = @ID)
BEGIN
DECLARE crArticulos CURSOR LOCAL FOR
SELECT plv.Articulo,
plv.Renglon,
plv.SubCuenta,
plv.Cantidad,
plv.Precio,
plv.DescuentoLinea,
plv.Impuesto1,
plv.Impuesto2,
plv.Impuesto3,
plv.Unidad,
ISNULL(plv.CantidadObsequio,0.0),
plv.Puntos,
plv.PrecioSugerido ,
plv.Aplicado,
plv.PrecioImpuestoInc,
dbo.fnRellenarConCaracter(SUBSTRING(ISNULL(a.Descripcion1,''),1,20),20,'D',CHAR(32)) ,
dbo.fnRellenarConCaracter(SUBSTRING(ISNULL(a.Descripcion1,''),1,50),50,'D',CHAR(32)) ,
plv.OfertaID,
ISNULL(plv.AplicaDescGlobal,1)
FROM POSLVenta plv JOIN Art a ON plv.Articulo = a.Articulo
WHERE plv.ID = @ID
AND plv.Articulo <> ISNULL(@ArticuloRedondeo,'')
AND plv.RenglonTipo <> 'K'
OPEN crArticulos
FETCH NEXT FROM crArticulos INTO @Articulo, @Renglon, @SubCuenta, @Cantidad, @Precio, @DescuentoLinea, @Impuesto1, @Impuesto2, @Impuesto3,
@Unidad, @CantidadObsequio, @Puntos, @PrecioSugerido, @Aplicado, @PrecioImpuestoInc,@Descripcion, @Descripcion2,
@OfertaID, @AplicaDescGlobal
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @EsImpresion = 0
BEGIN
IF @Cantidad-@CantidadObsequio <> 0.0
BEGIN
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td>'+CONVERT(varchar,@Cantidad-@CantidadObsequio)+'</td>'
SET @String = @String + '    <td>'+RTRIM(@Articulo)+'</td>'
SET @String = @String + '    <td>'+RTRIM(@Descripcion)+'</td>'
SET @String = @String + '    <td style="text-align:right;">'+dbo.fnFormatoMoneda(ISNULL(CASE WHEN @POSImpuestoIncluido = 1 THEN @PrecioImpuestoInc ELSE @Precio END ,0.0),@Empresa)+'</td>'
SET @String = @String + '    <td style="text-align:right;">'+CONVERT(varchar, ISNULL(@DescuentoLinea, 0.0))+ ' %'+'</td>'
SET @String = @String + '    <td style="text-align:right;">'+dbo.fnFormatoMoneda((@Cantidad - ISNULL(@CantidadObsequio, 0.0)) * ISNULL((CASE WHEN @POSImpuestoIncluido = 1 THEN @PrecioImpuestoInc ELSE @Precio END - (CASE WHEN @POSImpuestoIncluido = 1 THEN @PrecioImpuestoInc ELSE @Precio END * (ISNULL(@DescuentoLinea,0.0)/100))),0.0),@Empresa)+'</td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
SELECT @DescuentoLineaAcumulado = ISNULL(@DescuentoLineaAcumulado,0) + ((@Cantidad - ISNULL(@CantidadObsequio, 0)) *
ISNULL((CASE WHEN @POSImpuestoIncluido = 1 THEN @PrecioImpuestoInc ELSE @Precio END *
(ISNULL(@DescuentoLinea,0)/100)),0))
IF ISNULL(@CantidadObsequio,0) >= 1.0
BEGIN
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td colspan="6" style="text-align:center;">'+'******    ' + CONVERT(varchar, @CantidadObsequio) + ' ' + @Unidad + ' ' + dbo.fnRellenarConCaracter(SUBSTRING(@Articulo,1,10),10,'D',' ') + '  ' + @Descripcion + ' Articulo' + CASE WHEN @CantidadObsequio > 1 THEN 's' ELSE '' END + ' Obsequiado' + CASE WHEN @CantidadObsequio > 1 THEN 's' ELSE '' END +'    ******'+'</td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF @EsImpresion = 1
BEGIN
SELECT @String = @String+'<BR>'+dbo.fnCentrar('******    ' + CONVERT(varchar, @CantidadObsequio) + ' ' + @Unidad + ' ' +
dbo.fnRellenarConCaracter(SUBSTRING(@Articulo,1,10),10,'D',' ') + '  ' + @Descripcion + ' Articulo' +
CASE WHEN @CantidadObsequio > 1 THEN 's' ELSE '' END +
' Obsequiados    ******',@LargoLineaTicket) + ' <BR><BR>'
SELECT @Ticket = @Ticket + @String
END
SELECT @DescuentoLineaAcumulado = ISNULL(@DescuentoLineaAcumulado,0) + ISNULL(@CantidadObsequio, 0) * ISNULL((CASE WHEN @POSImpuestoIncluido = 1 THEN @PrecioImpuestoInc ELSE @Precio END *
(ISNULL(NULLIF(@DescuentoLinea,0),1))),0) END
IF EXISTS(SELECT * FROM Oferta WHERE ID = @OfertaID AND Forma = 'Precio') AND (ISNULL(@PrecioSugerido,0.0)-ISNULL(@Precio,0.0))>0.0
BEGIN
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td colspan="6" style="text-align:center;">'+'******     USTED AHORRO ' +
dbo.fnFormatoMoneda((ISNULL(@PrecioSugerido,0.0)-ISNULL(CASE WHEN @POSImpuestoIncluido = 1 THEN @PrecioImpuestoInc ELSE @Precio END ,0.0)) *
@Cantidad,@Empresa) + ' ' + @Moneda + '  ******     '+'</td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF @EsImpresion = 1
BEGIN
SELECT @Ticket = @Ticket+dbo.fnCentrar('******     USTED AHORRO ' + dbo.fnFormatoMoneda((ISNULL(@PrecioSugerido,0.0)-ISNULL(CASE WHEN @POSImpuestoIncluido = 1 THEN @PrecioImpuestoInc ELSE @Precio END ,0.0)) *
@Cantidad,@Empresa) + ' ' + @Moneda + '  ******     ',@LargoLineaTicket-4)+' <BR>' END
END
IF @Cantidad < 0.0
BEGIN
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td colspan="6" style="text-align:center;">'+dbo.fnRellenarConCaracter(CONVERT(varchar,@Cantidad),6,'i',CHAR(32)) + '  ' +
dbo.fnRellenarConCaracter(SUBSTRING(@Articulo,1,10),10,'D',' ') + '  ' + @Descripcion + ' ' +
dbo.fnAlinearDerecha(dbo.fnFormatoMoneda(ISNULL(CASE WHEN @POSImpuestoIncluido = 1 THEN @PrecioImpuestoInc ELSE @Precio END ,0.0), @Empresa), 8) +
dbo.fnAlinearDerecha(CONVERT(varchar, ISNULL(@DescuentoLinea,0.0)), 6) + '% ' +  dbo.fnAlinearDerecha(dbo.fnFormatoMoneda((@Cantidad - ISNULL(@CantidadObsequio, 0.0)) *
ISNULL((@Precio - (@Precio * (ISNULL(@DescuentoLinea,0.0)/100))),0.0),@Empresa),10)+'</td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF @EsImpresion = 1
BEGIN
SELECT @String = ISNULL(@String,'') + dbo.fnRellenarConCaracter(CONVERT(varchar,@Cantidad),6,'i',CHAR(32)) + '  ' +
dbo.fnRellenarConCaracter(SUBSTRING(@Articulo,1,10),10,'D',' ') + '  ' + @Descripcion + ' ' +
dbo.fnAlinearDerecha(dbo.fnFormatoMoneda(ISNULL(CASE WHEN @POSImpuestoIncluido = 1 THEN @PrecioImpuestoInc ELSE @Precio END ,0.0), @Empresa), 8) +
dbo.fnAlinearDerecha(CONVERT(varchar, ISNULL(@DescuentoLinea,0.0)), 6) + '% ' +  dbo.fnAlinearDerecha(dbo.fnFormatoMoneda((@Cantidad -
ISNULL(@CantidadObsequio, 0.0)) * ISNULL((@Precio - (@Precio * (ISNULL(@DescuentoLinea,0.0)/100))),0.0),@Empresa),10) + '<BR>'
END
END
IF ISNULL(@CantidadObsequio,0) < 0.0
BEGIN
IF @EsImpresion =0
BEGIN
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td colspan="6" style="text-align:center;">'+CONVERT(varchar, @CantidadObsequio) + ' ' +
dbo.fnRellenarConCaracter(SUBSTRING(@Articulo,1,10),10,'D',' ') + ' Articulo' + CASE WHEN @CantidadObsequio > 1 THEN 's' ELSE '' END + ' Obsequiados    ******'+'</td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF @EsImpresion =1
BEGIN
SELECT @String = @String + '<BR>' + dbo.fnCentrar('******    ' + CONVERT(varchar, @CantidadObsequio) + ' ' +
dbo.fnRellenarConCaracter(SUBSTRING(@Articulo,1,10),10,'D',' ') + ' Articulo' + CASE WHEN @CantidadObsequio > 1 THEN 's' ELSE '' END +
' Obsequiados    ******',@LargoLineaTicket-4)+' <BR>'
SELECT @Ticket = @Ticket + @String
END
SELECT @DescuentoLineaAcumulado = ISNULL(@DescuentoLineaAcumulado,0) + ISNULL(@CantidadObsequio, 0) * ISNULL((CASE WHEN @POSImpuestoIncluido = 1 THEN @PrecioImpuestoInc ELSE @Precio END *
(ISNULL(NULLIF(@DescuentoLinea,0),1))),0)
END
END
ELSE
BEGIN
IF @Cantidad-@CantidadObsequio <>0.0
BEGIN
SELECT @String = dbo.fnRellenarConCaracter(CONVERT(varchar,@Cantidad-@CantidadObsequio),5,'i',CHAR(32)) +' '+
dbo.fnRellenarConCaracter(Rtrim(@Articulo),10,'D', SPACE(1))+' ' +
dbo.fnAlinearDerecha(dbo.fnFormatoMoneda(ISNULL(CASE WHEN @POSImpuestoIncluido = 1 THEN @PrecioImpuestoInc ELSE @Precio END ,0.0),@Empresa), 8)
+' '+ dbo.fnAlinearDerecha(CONVERT(varchar, ISNULL(@DescuentoLinea, 0.0))+ ' % ', 8) +' '+  dbo.fnAlinearDerecha(dbo.fnFormatoMoneda( (@Cantidad - ISNULL(@CantidadObsequio, 0.0)) *
ISNULL((CASE WHEN @POSImpuestoIncluido = 1 THEN @PrecioImpuestoInc ELSE @Precio END -
(CASE WHEN @POSImpuestoIncluido = 1 THEN @PrecioImpuestoInc ELSE @Precio END * (ISNULL(@DescuentoLinea,0.0)/100))),0.0),@Empresa),12) + '<BR>'
SELECT @String = @String + '       '+ dbo.fnRellenarConCaracter(@Descripcion,20,'I', SPACE(1))+ + '<BR>'
END
ELSE
SELECT @String =''
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SELECT @String =''
IF @Cantidad - @CantidadObsequio > 0.0
BEGIN
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td colspan="6" style="text-align:center;">'+CONVERT(varchar,@Cantidad-@CantidadObsequio) +'  '+
dbo.fnRellenarConCaracter(SUBSTRING(@Articulo,1,10),10,'D',' ')+' ' +
dbo.fnAlinearDerecha(dbo.fnFormatoMoneda(ISNULL(CASE WHEN @POSImpuestoIncluido =1 THEN @PrecioImpuestoInc ELSE @Precio END ,0.0),@Empresa), 8)  +
dbo.fnAlinearDerecha(CONVERT(varchar, ISNULL(@DescuentoLinea,0.0)), 6) + '% ' +  dbo.fnAlinearDerecha(dbo.fnFormatoMoneda((@Cantidad - ISNULL(@CantidadObsequio, 0.0)) *
ISNULL((@Precio - (@Precio * (ISNULL(@DescuentoLinea,0.0)/100))),0.0),@Empresa),10)+'</td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td colspan="6" style="text-align:center;">'+
CASE WHEN @Articulo = @ArticuloOfertaFP THEN @Descripcion2+ ' IMPUESTOS AL '+CONVERT(varchar,@Impuesto1)+'%' ELSE +@Descripcion2+ '' END+'</td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF @EsImpresion = 1
BEGIN
SELECT @String =dbo.fnRellenarConCaracter(CONVERT(varchar,@Cantidad-@CantidadObsequio),6,'i',CHAR(32)) +'  '+
dbo.fnRellenarConCaracter(SUBSTRING(@Articulo,1,10),10,'D',' ')+' ' +
dbo.fnAlinearDerecha(dbo.fnFormatoMoneda(ISNULL(CASE WHEN @POSImpuestoIncluido =1 THEN @PrecioImpuestoInc ELSE @Precio END ,0.0),@Empresa), 8)  +
dbo.fnAlinearDerecha(CONVERT(varchar, ISNULL(@DescuentoLinea,0.0)), 6) + '% ' +  dbo.fnAlinearDerecha(dbo.fnFormatoMoneda((@Cantidad - ISNULL(@CantidadObsequio, 0.0)) *
ISNULL((@Precio - (@Precio * (ISNULL(@DescuentoLinea,0.0)/100))),0.0),@Empresa),10) + '<BR>' +
dbo.fnRellenarConCaracter('',6,'i',CHAR(32))+'  '+
CASE WHEN @Articulo = @ArticuloOfertaFP THEN @Descripcion2+ ' IMPUESTOS AL '+CONVERT(varchar,@Impuesto1)+'%  <BR>' ELSE +@Descripcion2+ '<BR>'  END
END
END
IF @Cantidad < 0.0
BEGIN
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td>'+CONVERT(varchar,@Cantidad)+'</td>'
SET @String = @String + '    <td>'+RTRIM(@Articulo)+'</td>'
SET @String = @String + '    <td>'+RTRIM(@Descripcion2)+'</td>'
SET @String = @String + '    <td style="text-align:right;">'+dbo.fnFormatoMoneda(ISNULL(CASE WHEN @POSImpuestoIncluido = 1 THEN @PrecioImpuestoInc ELSE @Precio END ,0.0),@Empresa)+'</td>'
SET @String = @String + '    <td style="text-align:right;">'+CONVERT(varchar, ISNULL(@DescuentoLinea, 0.0))+ ' %'+'</td>'
SET @String = @String + '    <td style="text-align:right;">'+dbo.fnFormatoMoneda( (@Cantidad - ISNULL(@CantidadObsequio, 0.0)) * ISNULL((@Precio - (@Precio * (ISNULL(@DescuentoLinea,0.0)/100))),0.0),@Empresa)+'</td>'
SET @String = @String + '  </tr>'
SET @String = @String + '</table>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF @EsImpresion = 1
BEGIN
SELECT @String = ISNULL(@String,'')+dbo.fnRellenarConCaracter(CONVERT(varchar,@Cantidad),6,'i',CHAR(32))+'  '+ dbo.fnRellenarConCaracter(SUBSTRING(@Articulo,1,10),10,'D',' ')+' ' +
dbo.fnAlinearDerecha(dbo.fnFormatoMoneda(ISNULL(CASE WHEN @POSImpuestoIncluido =1 THEN @PrecioImpuestoInc ELSE @Precio END ,0.0),@Empresa), 8)  +
dbo.fnAlinearDerecha(CONVERT(varchar, ISNULL(@DescuentoLinea,0.0)), 6) + '%' +
dbo.fnAlinearDerecha(dbo.fnFormatoMoneda( (@Cantidad - ISNULL(@CantidadObsequio, 0.0)) * ISNULL((@Precio - (@Precio * (ISNULL(@DescuentoLinea,0.0)/100))),0.0),@Empresa),10) + '<BR>' +
dbo.fnRellenarConCaracter('',6,'i',CHAR(32))+'  '+@Descripcion2+ '<BR>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
END
SELECT @DescuentoLineaAcumulado = ISNULL(@DescuentoLineaAcumulado,0) + ((@Cantidad - ISNULL(@CantidadObsequio, 0)) *
ISNULL((CASE WHEN @POSImpuestoIncluido =1 THEN @PrecioImpuestoInc ELSE @Precio END *
(ISNULL(@DescuentoLinea,0)/100)),0))
IF ISNULL(@CantidadObsequio,0) >= 1.0
BEGIN
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td>'+CONVERT(varchar,@CantidadObsequio)+'</td>'
SET @String = @String + '    <td>'+RTRIM(@Articulo)+'</td>'
SET @String = @String + '    <td>'+RTRIM(@Descripcion2)+'</td>'
SET @String = @String + '    <td style="text-align:right;">'+dbo.fnFormatoMoneda(0.0,@Empresa)+'</td>'
SET @String = @String + '    <td style="text-align:right;">'+CONVERT(varchar,0.0)+ ' %'+'</td>'
SET @String = @String + '    <td style="text-align:right;">'+dbo.fnFormatoMoneda(0.0,@Empresa)+'</td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td colspan="6" style="text-align:center;">'+CONVERT(varchar, @CantidadObsequio) + ' ' +
dbo.fnRellenarConCaracter(SUBSTRING(@Articulo,1,10),10,'D',' ') + ' Articulo' +
CASE WHEN @CantidadObsequio > 1 THEN 's' ELSE '' END + ' Obsequiados    ******'+'</td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF @EsImpresion = 1
BEGIN
SELECT @String = '' + dbo.fnRellenarConCaracter(CONVERT(varchar,@CantidadObsequio),6,'i',CHAR(32)) + '  ' + dbo.fnRellenarConCaracter(SUBSTRING(@Articulo,1,10),10,'D',' ') + ' ' +
dbo.fnAlinearDerecha(dbo.fnFormatoMoneda(0.0,@Empresa), 8) + dbo.fnAlinearDerecha(CONVERT(varchar,0.0), 6) + '% ' +  dbo.fnAlinearDerecha(dbo.fnFormatoMoneda(0.0,@Empresa),10) + '<BR>' +
dbo.fnRellenarConCaracter('',6,'i',CHAR(32)) + '  ' + @Descripcion2 + '<BR>'
SELECT @String = @String + '<BR>' + dbo.fnCentrar('******    ' + CONVERT(varchar, @CantidadObsequio) + ' ' + dbo.fnRellenarConCaracter(SUBSTRING(@Articulo,1,10),10,'D',' ') + ' Articulo' +
CASE WHEN @CantidadObsequio > 1 THEN 's' ELSE '' END + ' Obsequiados    ******',@LargoLineaTicket-4)+' <BR><BR>'
SELECT @Ticket = @Ticket + @String
END
SELECT @DescuentoLineaAcumulado = ISNULL(@DescuentoLineaAcumulado,0) + ISNULL(@CantidadObsequio, 0) * ISNULL((CASE WHEN @POSImpuestoIncluido =1 THEN @PrecioImpuestoInc ELSE @Precio END * (ISNULL(NULLIF(@DescuentoLinea,0),1))),0)
END
END
IF EXISTS(SELECT * FROM POSOfertaTemp WHERE Estacion = @Estacion AND Articulo = @Articulo AND IDR = @ID AND Renglon = @Renglon) AND ISNULL(@Aplicado,0)=0
BEGIN
SELECT @OfertaPuntos = (Puntos), @OfertaPrecio = Precio
FROM POSOfertaTemp
WHERE Estacion = @Estacion AND Articulo = @Articulo
AND IDR = @ID AND Renglon = @Renglon
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td colspan="6" style="text-align:center;">'+'******    CON  ' + CONVERT(varchar, @OfertaPuntos) + '  PUNTOS PAGUE SOLO ' +
dbo.fnFormatoMoneda((@OfertaPrecio*@Cantidad),@Empresa) + '    ******'+'</td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF @EsImpresion = 1
BEGIN
SELECT @String = '<BR>' + dbo.fnCentrar('******    CON  ' + CONVERT(varchar, @OfertaPuntos) + '  PUNTOS PAGUE SOLO ' +
dbo.fnFormatoMoneda((@OfertaPrecio*@Cantidad),@Empresa) + '    ******',@LargoLineaTicket-4) + ' <BR><BR>'
SELECT @Ticket = @Ticket + @String
END
END
IF EXISTS(SELECT * FROM POSLVenta WHERE ID = @ID ) AND NULLIF(@Monedero,'') IS NOT NULL AND ISNULL(@Puntos,0.0) < 0.0 AND ISNULL(@Aplicado,0)=1
BEGIN
IF @EsImpresion = 0
BEGIN
SELECT @Ahorro = SUM((ISNULL(@PrecioSugerido,0.0) * @Cantidad) - (ISNULL(@Precio,0.0)*@Cantidad)),@PuntosUtilizados = ABS(SUM(@Puntos))
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td colspan="6" style="text-align:center;">'+'*****  USTED UTILIZO ' + CONVERT(varchar,@PuntosUtilizados) + ' PUNTOS  Y AHORRO :' +
dbo.fnFormatoMoneda(ISNULL(@Ahorro,0.0),@Empresa) + '    ******'+'</td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF @EsImpresion = 1
BEGIN
SELECT @String = '<BR>' + dbo.fnCentrar('*****  USTED UTILIZO ' + CONVERT(varchar,@PuntosUtilizados) + ' PUNTOS  Y AHORRO :' +
dbo.fnFormatoMoneda(ISNULL(@Ahorro,0.0),@Empresa) + '    ******',@LargoLineaTicket-4) + '<BR><BR>'
SELECT @Ticket = @Ticket + @String
END
END
IF EXISTS(SELECT * FROM POSLVenta WHERE ID = @ID ) AND NULLIF(@Monedero,'') IS NOT NULL AND ISNULL(@Puntos,0.0) > 0.0 AND @Estatus NOT IN ('CONCLUIDO','TRASPASADO')
BEGIN
SELECT @MonedaMonedero =  Moneda
FROM POSValeSerie
WHERE Serie = @Monedero
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td colspan="6" style="text-align:center;">'+'***** EN EL ARTICULO ' + dbo.fnRellenarConCaracter(SUBSTRING(@Articulo,1,10),10,'D',' ') + ' GANARA  ' +
CONVERT(varchar,@Puntos) + ' ' + @MonedaMonedero + '    *****'+'</td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF @EsImpresion = 1
BEGIN
SELECT @String = '<BR>' + dbo.fnCentrar('***** EN EL ARTICULO ' + dbo.fnRellenarConCaracter(SUBSTRING(@Articulo,1,10),10,'D',' ') + ' GANARA  ' +
CONVERT(varchar,@Puntos) + ' ' + @MonedaMonedero + '    *****',@LargoLineaTicket-4) + ' <BR><BR>'
SELECT @Ticket = @Ticket + @String
END
END
SET @Puntos = NULL
END
FETCH NEXT FROM crArticulos INTO @Articulo, @Renglon, @SubCuenta, @Cantidad, @Precio, @DescuentoLinea, @Impuesto1, @Impuesto2, @Impuesto3,
@Unidad, @CantidadObsequio, @Puntos, @PrecioSugerido, @Aplicado, @PrecioImpuestoInc,@Descripcion, @Descripcion2,
@OfertaID, @AplicaDescGlobal
END
CLOSE crArticulos
DEALLOCATE crArticulos
SELECT @SubTotal = SUM(ISNULL(((Cantidad - ISNULL(CantidadObsequio,0)) * Precio) ,0))
FROM POSLVenta
WHERE ID = @ID
AND Articulo <> ISNULL(@ArticuloRedondeo,'')
SELECT @ImporteMov = SUM((plv.Cantidad  - ISNULL(plv.CantidadObsequio,0)) * ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0)/100))) -
((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0)/100))) * (CASE WHEN ISNULL(plv.AplicaDescGlobal, 1) = 1 THEN ISNULL(p.DescuentoGlobal,0.0) ELSE 0 END)/100))),
@ImpuestosMov = (SUM(dbo.fnPOSImporteMov(((plv.Cantidad  - ISNULL(plv.CantidadObsequio,0.0)) * ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) - ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) *
(CASE WHEN ISNULL(plv.AplicaDescGlobal, 1) = 1 THEN ISNULL(p.DescuentoGlobal,0.0) ELSE 0 END)/100))),plv.Impuesto1,plv.Impuesto2,plv.Impuesto3,plv.Cantidad))-@ImporteMov)
FROM POSLVenta plv
INNER JOIN POSL p ON p.ID = plv.ID
WHERE plv.ID = @ID
SELECT @TotalImpuesto1 = @ImpuestosMov
SELECT @TotalDescuento = @SubTotal - @ImporteMov
SELECT @Total = @ImporteMov + @ImpuestosMov
SELECT @Totales = dbo.fnAlinearCampoValor2('SUBTOTAL', dbo.fnFormatoMoneda(@SubTotal,@Empresa), @LargoLineaTotales/2) + '<BR>' +
dbo.fnAlinearCampoValor2('DESCUENTO', dbo.fnFormatoMoneda(@TotalDescuento,@Empresa), @LargoLineaTotales/2) + '<BR>' +
dbo.fnAlinearCampoValor2('IMPUESTOS',dbo.fnFormatoMoneda(@TotalImpuesto1,@Empresa), @LargoLineaTotales/2) + '<BR>' +
dbo.fnAlinearCampoValor2('TOTAL', dbo.fnFormatoMoneda(@Total,@Empresa), @LargoLineaTotales/2) + '<BR>'
IF @EsImpresion = 1
BEGIN
SET @String = ''
SET @String = @String + '<BR><BR><BR>' + @Totales
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td colspan="5" style="text-align:right;">SUBTOTAL</td>'
SET @String = @String + '    <td style="text-align:right;">'+dbo.fnFormatoMoneda(@SubTotal,@Empresa)+'</td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td colspan="5" style="text-align:right;">DESCUENTO</td>'
SET @String = @String + '    <td style="text-align:right;">'+dbo.fnFormatoMoneda(@TotalDescuento,@Empresa)+'</td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td colspan="5" style="text-align:right;">IMPUESTOS</td>'
SET @String = @String + '    <td style="text-align:right;">'+dbo.fnFormatoMoneda(@TotalImpuesto1,@Empresa)+'</td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td colspan="5" style="text-align:right;">TOTAL</td>'
SET @String = @String + '    <td style="text-align:right;">'+dbo.fnFormatoMoneda(@Total,@Empresa)+'</td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
END
IF EXISTS(SELECT * FROM POSLVenta WHERE ID = @ID AND ISNULL(Puntos,0.0) < 0.0) AND NULLIF(@Monedero,'') IS NOT NULL
BEGIN
SELECT @Ahorro = SUM((ISNULL(PrecioSugerido,0.0)*Cantidad)-(ISNULL(Precio,0.0)*Cantidad)),@PuntosUtilizados = ABS(SUM(Puntos))
FROM POSLVenta
WHERE ID = @ID
AND ISNULL(Puntos,0.0) < 0.0
SELECT @LineaAhorro = dbo.fnAlinearCampoValor2(ISNULL(UPPER(REPLICATE(' ', 9) + ' TOTAL PUNTOS UTILIZADOS ' + CONVERT(varchar,@PuntosUtilizados) + '  Y AHORRO :'), '') +
dbo.fnAlinearDerecha(dbo.fnFormatoMoneda(ISNULL(@Ahorro,0.0),@Empresa), 13), '<BR>', @LargoLineaTicket)
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td colspan="5" style="text-align:right;">TOTAL PUNTOS UTILIZADOS</td>'
SET @String = @String + '    <td style="text-align:right;">'+CONVERT(varchar,@PuntosUtilizados)+'</td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td colspan="5" style="text-align:right;">AHORRO</td>'
SET @String = @String + '    <td style="text-align:right;">'+dbo.fnFormatoMoneda(ISNULL(@Ahorro,0.0),@Empresa)+'</td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
END
IF EXISTS(SELECT * FROM POSLVenta WHERE ID = @ID AND ISNULL(Puntos,0.0) >0.0)AND NULLIF(@Monedero,'') IS NOT NULL
BEGIN
SELECT @PuntosUtilizados = ABS(SUM(Puntos))
FROM POSLVenta
WHERE ID = @ID AND ISNULL(Puntos,0.0)> 0.0
SELECT @MonedaMonedero =  Moneda
FROM POSValeSerie
WHERE Serie = @Monedero
IF @Estatus IN ('CONCLUIDO','TRASPASADO')
BEGIN
SELECT @LineaAhorro = dbo.fnAlinearCampoValor2(ISNULL(UPPER(REPLICATE(' ', 9) + ' SE ABONARON  ' + CONVERT(varchar,@PuntosUtilizados) + ' ' +
@MonedaMonedero + ' AL MONEDERO : '), '') +  @Monedero, '<BR>', @LargoLineaTicket)
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td colspan="6" style="text-align:center;">SE ABONARON: '+CONVERT(varchar,@PuntosUtilizados) + ' ' + @MonedaMonedero + ' AL MONEDERO : '+ @Monedero +'</td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
END
END
SELECT @String = ISNULL(@LineaAhorro,'')+'<BR>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
IF @DescuentoLineaAcumulado > 0.0 OR EXISTS(SELECT * FROM POSLVenta WHERE ID = @ID  AND NULLIF(@Monedero,'') IS NOT NULL AND  ISNULL(Aplicado,0)=1 HAVING SUM(Puntos) < 0.0 )
BEGIN
SELECT @Ahorro = @TotalDescuento
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td colspan="6" style="text-align:center;">'+'********** USTED AHORRO   ' + dbo.fnFormatoMoneda(ISNULL(@Ahorro,0.0),@Empresa) + ' ' + @Moneda + ' **********' +'</td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF @EsImpresion = 1
BEGIN
SELECT @String = ' <BR> ' + dbo.fnCentrar('********** USTED AHORRO   ' +dbo.fnFormatoMoneda(ISNULL(@Ahorro,0.0),@Empresa) + ' ' + @Moneda + ' **********', @LargoLineaTicket) + ' <BR> '
SELECT @Ticket = @Ticket + ISNULL(@String, '')
END
END
IF (ISNULL(@Total,0.0) + ISNULL(@Redondeo, 0.0))<>0.0
BEGIN
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td colspan="6" style="text-align:center;">(SON ' + dbo.fnNumeroEnEspanol(ISNULL(@Total,0.0) + ISNULL(@Redondeo, 0.0),@Moneda) +') ' +'</td>'
SET @String = @String + '  </tr>'
SET @String = @String + '</table>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF @EsImpresion = 1
BEGIN
SELECT @String = ' <BR>' + dbo.fnCentrar('(SON ' + dbo.fnNumeroEnEspanol(ISNULL(@Total,0.0) + ISNULL(@Redondeo, 0.0),@Moneda) +') ', @LargoLineaTicket) + '<BR><BR>' + ISNULL(@Cadena,'')
SELECT @Ticket = @Ticket + ISNULL(@String, '')
END
END
IF (@MovClave = 'POS.F' OR (@MovClave  = 'POS.P' AND @MovSubClave = 'POS.FACCRED')) AND @OK IS NULL AND @EsImpresion=1
BEGIN
SELECT @String = dbo.fnCentrar('CERTIFICADO DIGITAL: ' + @noCertificadoSAT, @LargoLineaTicket-4) + '<BR>' +
dbo.fnCentrar('  FOLIO FISCAL: ' + @UUID, @LargoLineaTicket-4) + '<BR>' +
dbo.fnPOSTablaTicketCadena('SELLO DIGITAL DEL CFDI: ' + @Sello,@LargoLineaTicket) +
dbo.fnPOSTablaTicketCadena('SELLO DIGITAL DEL SAT: ' + @SelloSAT,@LargoLineaTicket) +
dbo.fnPOSTablaTicketCadena('CADENA ORIGINAL: ' + @CadenaOriginal,@LargoLineaTicket) +
dbo.fnCentrar('FECHA DE CERTIFICACI±N: ' + CONVERT(varchar,@FechaTimbrado), @LargoLineaTicket-4) + '<BR>' +
dbo.fnCentrar('  CERTIFICADO DIGITAL SAT: ' + @noCertificado, @LargoLineaTicket-4) +
'<BR>' + UPPER('Este documento es una representación impresa de un CFDI')
SELECT @Ticket = @Ticket + ISNULL(@String, '')
END
END
END
IF @MovClave IN('POS.INVD', 'POS.INVA') AND @Estatus NOT IN ('CONCLUIDO', 'TRASPASADO')
BEGIN
IF @EsImpresion = 0
BEGIN
SELECT @Ticket = @Ticket +
REPLICATE('-', @LargoLineaTicket+32) + '<BR>' + ' CANTIDAD    '  + '  PRODUCTO ' + '             DESCRIPCION       ' + '<BR>' +
REPLICATE('-', @LargoLineaTicket+32) + '<BR>'
END
ELSE
BEGIN
SELECT @Ticket = @Ticket + '<BR>' +
REPLICATE('-', @LargoLineaTicket) + '<BR>' +  ' CANTIDAD    '  + 'PRODUCTO ' + '       DESCRIPCION       ' + '<BR>' +
REPLICATE('-', @LargoLineaTicket) + '<BR>'
END
SET @String = ''
IF EXISTS(SELECT * FROM POSLVenta WHERE ID = @ID)
BEGIN
DECLARE crArticulos CURSOR LOCAL FOR
SELECT plv.Articulo,
plv.Renglon,
plv.SubCuenta,
plv.Cantidad,
plv.Precio,
plv.DescuentoLinea,
plv.Impuesto1,
plv.Impuesto2,
plv.Impuesto3,
plv.Unidad,
ISNULL(plv.CantidadObsequio,0.0),
plv.Puntos,
plv.PrecioSugerido ,
plv.Aplicado,
plv.PrecioImpuestoInc,
dbo.fnRellenarConCaracter(SUBSTRING(ISNULL(a.Descripcion1,''),1,20),20,'D',CHAR(32)) ,
dbo.fnRellenarConCaracter(SUBSTRING(ISNULL(a.Descripcion1,''),1,50),50,'D',CHAR(32)) ,
plv.OfertaID,
ISNULL(plv.AplicaDescGlobal,1)
FROM POSLVenta plv JOIN Art a ON plv.Articulo = a.Articulo
WHERE plv.ID = @ID
AND plv.Articulo <> ISNULL(@ArticuloRedondeo,'')
AND plv.RenglonTipo <> 'K'
OPEN crArticulos
FETCH NEXT FROM crArticulos INTO @Articulo, @Renglon, @SubCuenta, @Cantidad, @Precio, @DescuentoLinea, @Impuesto1, @Impuesto2,
@Impuesto3, @Unidad, @CantidadObsequio, @Puntos, @PrecioSugerido, @Aplicado, @PrecioImpuestoInc,
@Descripcion, @Descripcion2, @OfertaID, @AplicaDescGlobal
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @EsImpresion = 0
BEGIN
SELECT @String = ISNULL(@String,'') + dbo.fnRellenarConCaracter(CONVERT(varchar,@Cantidad),6,'i',CHAR(32)) + '         ' +
dbo.fnRellenarConCaracter(SUBSTRING(@Articulo,1,15),15,'D',' ') + '  ' + @Descripcion + '   ' + '<BR>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
ELSE
BEGIN
SELECT @String = dbo.fnRellenarConCaracter(CONVERT(varchar,@Cantidad),6,'i',CHAR(32)) + '       ' +
dbo.fnRellenarConCaracter(SUBSTRING(@Articulo,1,10),10,'D',' ') + ' ' +
dbo.fnRellenarConCaracter('',6,'i',CHAR(32)) + '  ' + @Descripcion2+ '<BR>'
END
END
FETCH NEXT FROM crArticulos INTO @Articulo, @Renglon, @SubCuenta, @Cantidad, @Precio, @DescuentoLinea, @Impuesto1, @Impuesto2,
@Impuesto3, @Unidad, @CantidadObsequio, @Puntos, @PrecioSugerido, @Aplicado, @PrecioImpuestoInc,
@Descripcion, @Descripcion2, @OfertaID, @AplicaDescGlobal
END
CLOSE crArticulos
DEALLOCATE crArticulos
END
END
IF @MovClave IN('POS.INVD', 'POS.INVA') AND @Estatus IN ('CONCLUIDO', 'TRASPASADO')
BEGIN
IF @EsImpresion = 0
BEGIN
SELECT @Ticket = @Ticket +
REPLICATE('-', @LargoLineaTicket+32) + '<BR>' + ' CANTIDAD    '  + '  PRODUCTO ' + '             DESCRIPCION       ' + '<BR>' +
REPLICATE('-', @LargoLineaTicket+32) + '<BR>'
END
ELSE
BEGIN
SELECT @Ticket = @Ticket + '<BR>' +
REPLICATE('-', @LargoLineaTicket) + '<BR>' +  ' CANTIDAD    '  + 'PRODUCTO ' + '       DESCRIPCION       ' + '<BR>' +
REPLICATE('-', @LargoLineaTicket) + '<BR>'
END
SET @String = ''
IF EXISTS(SELECT * FROM POSLInv WHERE ID = @ID)
BEGIN
DECLARE crArticulos CURSOR LOCAL FOR
SELECT plv.Articulo,
plv.Renglon,
plv.SubCuenta,
plv.Cantidad,
plv.Precio,
NULL,
NULL,
NULL,
NULL,
plv.Unidad,
0.0,
0,
0,
NULL,
NULL,
dbo.fnRellenarConCaracter(SUBSTRING(ISNULL(a.Descripcion1,''),1,20),20,'D',CHAR(32)) ,
dbo.fnRellenarConCaracter(SUBSTRING(ISNULL(a.Descripcion1,''),1,50),50,'D',CHAR(32)) ,
NULL,
NULL
FROM POSLInv plv JOIN Art a ON plv.Articulo = a.Articulo
WHERE plv.ID = @ID
AND plv.Articulo <> ISNULL(@ArticuloRedondeo,'')
AND plv.RenglonTipo <> 'K'
OPEN crArticulos
FETCH NEXT FROM crArticulos INTO @Articulo, @Renglon, @SubCuenta, @Cantidad, @Precio, @DescuentoLinea, @Impuesto1, @Impuesto2,
@Impuesto3, @Unidad, @CantidadObsequio, @Puntos, @PrecioSugerido, @Aplicado, @PrecioImpuestoInc,
@Descripcion, @Descripcion2, @OfertaID, @AplicaDescGlobal
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @EsImpresion = 0
BEGIN
SELECT @String = ISNULL(@String,'') + dbo.fnRellenarConCaracter(CONVERT(varchar,@Cantidad),6,'i',CHAR(32)) + '         ' +
dbo.fnRellenarConCaracter(SUBSTRING(@Articulo,1,15),15,'D',' ') + '  ' + @Descripcion + '   ' + '<BR>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
ELSE
BEGIN
SELECT @String = dbo.fnRellenarConCaracter(CONVERT(varchar,@Cantidad),6,'i',CHAR(32)) + '       ' +
dbo.fnRellenarConCaracter(SUBSTRING(@Articulo,1,10),10,'D',' ') + ' ' +
dbo.fnRellenarConCaracter('',6,'i',CHAR(32)) + '  ' + @Descripcion2+ '<BR>'
END
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
FETCH NEXT FROM crArticulos INTO @Articulo, @Renglon, @SubCuenta, @Cantidad, @Precio, @DescuentoLinea, @Impuesto1, @Impuesto2,
@Impuesto3, @Unidad, @CantidadObsequio, @Puntos, @PrecioSugerido, @Aplicado, @PrecioImpuestoInc,
@Descripcion, @Descripcion2, @OfertaID, @AplicaDescGlobal
END
CLOSE crArticulos
DEALLOCATE crArticulos
END
END
IF @MovClave IN ('POS.FA','POS.CXCD')
BEGIN
IF @EsImpresion = 1
BEGIN
IF NULLIF(@Concepto,'') IS NOT NULL
SELECT @Ticket =@Ticket+ '<BR>' + dbo.fnCentrar('CONCEPTO : '+@Concepto, @LargoLineaTicket-4) + '<BR>'
SELECT @Ticket = @Ticket + '<BR>' + REPLICATE('-', @LargoLineaTicket + CASE WHEN @EsImpresion = 0 THEN 32 ELSE 0 END) + '<BR>' +
dbo.fnCentrar(UPPER('FORMA PAGO'), @LargoLineaTicket /2) + dbo.fnCentrar(UPPER('IMPORTE'), @LargoLineaTicket /2) +
dbo.fnCentrar(UPPER('IMPORTE  M/N'), @LargoLineaTicket /2) + '<BR>' +
REPLICATE('-', @LargoLineaTicket + CASE WHEN @EsImpresion=0 THEN 32 ELSE 0 END) + '<BR>'
END
IF @EsImpresion = 0
BEGIN
IF NULLIF(@Concepto,'') IS NOT NULL
BEGIN
SET @String = ''
SET @String = @String + '<table width="100%" style="border-spacing:0px; border-color:#A8A4A4;">'
SET @String = @String + '  <tr style="background-color:#333; border-spacing:0px; border-color:#333;">'
SET @String = @String + '    <th colspan="5" style="text-align:left; color:#f5f5f5; background:#777;"> CONCEPTO :  </th>'
SET @String = @String + '    <th style="text-align:right; color:#f5f5f5; background:#777;">' + @Concepto + '</th>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF @SubClave = 'POS.ANTREF'
BEGIN
SET @String = ''
SET @String = @String + '<table width="100%" style="border-spacing:0px; border-color:#A8A4A4;">'
SET @String = @String + '  <tr style="background-color:#333; border-spacing:0px; border-color:#333;">'
SET @String = @String + '    <th style="text-align:left; color:#f5f5f5; background:#777;"> FORMA PAGO </th>'
SET @String = @String + '    <th style="text-align:left; color:#f5f5f5; background:#777;"> IMPORTE </th>'
SET @String = @String + '    <th style="text-align:right; color:#f5f5f5; background:#777;"> IMPORTE  M/N </th>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
END
IF @SubClave = 'POS.ANTREF'
BEGIN
DECLARE crSaldos CURSOR LOCAL FOR
SELECT dbo.fnRellenarConCaracter(p.FormaPago,30,'d',CHAR(32)), SUM(p.Importe), SUM(p.ImporteRef), fp.Moneda
FROM POSLCobro p
INNER JOIN FormaPago fp ON p.FormaPago = fp.FormaPago
WHERE p.ID = @ID AND p.CtadineroDestino =@CtaDineroDestino
GROUP BY p.FormaPago,fp.Moneda
OPEN crSaldos
FETCH NEXT FROM crSaldos INTO @FormaPago, @ImporteCobrado, @ImporteRef, @POSMoneda
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @EsImpresion = 1
SELECT @String = dbo.fnCentrar(REPLICATE(' ', 5) + UPPER(@FormaPago) + ': '+ '  $  ' + STUFF(dbo.fnFormatoMoneda( @ImporteRef,@Empresa),1,1,'') +
CASE WHEN @ImporteRef IS NOT NULL THEN '  $ '+ STUFF(dbo.fnFormatoMoneda( @ImporteCobrado,@Empresa),1,1,'') + ' ' + @Moneda ELSE '' END,
@LargoLineaTicket-4) + '<BR>'
END
EXEC spPOSTicketDenominacion @ID, @Empresa, @MovClave, @FormaPago, @Estacion, @LargoLineaTicket, @EsImpresion, @String2  OUTPUT
SELECT @Ticket = @Ticket + @String+'<BR>'+ISNULL(@String2,'')
FETCH NEXT FROM crSaldos INTO @FormaPago, @ImporteCobrado, @ImporteRef, @POSMoneda
END
CLOSE crSaldos
DEALLOCATE crSaldos
END
SELECT @Ticket = ISNULL(@Ticket,'') + '<BR><BR>'
SELECT @SubTotal = SUM(Importe) FROM POSL WHERE ID = @ID
SELECT @TotalImpuesto1 = ISNULL(Impuestos,0) FROM POSL WHERE ID = @ID
SELECT @TotalCxc = ISNULL(@SubTotal,0.0) + ISNULL(@TotalImpuesto1,0.0)
IF @EsImpresion = 1
BEGIN
SELECT @String = dbo.fnAlinearCampoValor2(ISNULL(UPPER(REPLICATE(' ', @LargoLineaTicket - 30)+' SUBTOTAL: '), '') +
dbo.fnAlinearDerecha(dbo.fnFormatoMoneda(ISNULL(@SubTotal,0.0),@Empresa), 13), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SELECT @String = dbo.fnAlinearCampoValor2(ISNULL(UPPER(REPLICATE(' ', @LargoLineaTicket - 30)+'IMPUESTOS: '), '') +
dbo.fnAlinearDerecha(dbo.fnFormatoMoneda(ISNULL(@TotalImpuesto1,0.0),@Empresa),13), '<BR>', @LargoLineaTicket)
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SELECT @String = dbo.fnAlinearCampoValor2(ISNULL(UPPER(REPLICATE(' ', @LargoLineaTicket - 30)+'    TOTAL: '), '') +
dbo.fnAlinearDerecha(dbo.fnFormatoMoneda(ISNULL(@TotalCxc,0.0) + ISNULL(@Redondeo, 0.0),@Empresa),13), '<BR>', @LargoLineaTicket) + '<BR><BR>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td colspan="5" style="text-align:right;">SUBTOTAL</td>'
SET @String = @String + '    <td style="text-align:right;">'+dbo.fnFormatoMoneda(@SubTotal,@Empresa)+'</td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td colspan="5" style="text-align:right;">IMPUESTOS</td>'
SET @String = @String + '    <td style="text-align:right;">'+dbo.fnFormatoMoneda(@TotalImpuesto1,@Empresa)+'</td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td colspan="5" style="text-align:right;">TOTAL</td>'
SET @String = @String + '    <td style="text-align:right;">'+dbo.fnFormatoMoneda(@TotalCxc,@Empresa)+'</td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
END
IF @MovClave IN ('POS.CXCC')
BEGIN
IF @EsImpresion = 1
BEGIN
IF NULLIF(@Concepto,'') IS NOT NULL
SELECT @Ticket =@Ticket+ '<BR>' + dbo.fnCentrar('CONCEPTO : ' + @Concepto, @LargoLineaTicket-4) + '<BR>'
SELECT @Ticket = @Ticket + '<BR>' + REPLICATE('-', @LargoLineaTicket + CASE WHEN @EsImpresion = 0 THEN 32 ELSE 0 END) + '<BR>' +
dbo.fnCentrar(UPPER('APLICA'), @LargoLineaTicket /3)+ dbo.fnCentrar(UPPER('MOVIMIENTO'), @LargoLineaTicket /2) +
dbo.fnCentrar(UPPER('IMPORTE'), @LargoLineaTicket/2)+ '<BR>' + REPLICATE('-', @LargoLineaTicket + CASE WHEN @EsImpresion = 0 THEN 32 ELSE 0 END) + '<BR>'
SELECT @Ticket = ISNULL(@Ticket,'') + '<BR><BR>'
END
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '<table width="100%" style="border-spacing:0px; border-color:#A8A4A4;">'
SET @String = @String + '  <tr style="background-color:#333; border-spacing:0px; border-color:#333;">'
SET @String = @String + '    <th style="text-align:left; color:#f5f5f5; background:#777;"> APLICA </th>'
SET @String = @String + '    <th style="text-align:left; color:#f5f5f5; background:#777;"> MOVIMIENTO </th>'
SET @String = @String + '    <th style="text-align:right; color:#f5f5f5; background:#777;">IMPORTE</th>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
SELECT @SubTotal = SUM(Importe) FROM POSL WHERE ID = @ID
SELECT @TotalImpuesto1 = Impuestos FROM POSL WHERE ID = @ID
SELECT @TotalCxc = ISNULL(@SubTotal,0.0) + ISNULL(@TotalImpuesto1,0.0)
DECLARE crDoc CURSOR LOCAL FOR
SELECT Aplica, AplicaID, Articulo, ROUND(Precio,4)
FROM POSLVenta p
WHERE p.ID = @ID
OPEN crDoc
FETCH NEXT FROM crDoc INTO @Aplica, @AplicaID, @Articulo, @Precio
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @EsImpresion = 1
SELECT @String = dbo.fnAlinearIzquierda(REPLICATE(' ', 2) + @Articulo , @LargoLineaTicket/3) + dbo.fnAlinearIzquierda(UPPER(@Aplica) + ' ' + @AplicaID, @LargoLineaTicket/3) +
dbo.fnAlinearDerecha(dbo.fnFormatoMoneda(ISNULL(@Precio,0.0) + ISNULL(@Redondeo, 0.0),@Empresa), @LargoLineaTicket / 4) + '<BR>'
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td> '+@Articulo+' </td>'
SET @String = @String + '    <td> '+UPPER(@Aplica) + ' ' + @AplicaID+' </td>'
SET @String = @String + '    <td style="text-align:right;"> '+dbo.fnFormatoMoneda(ISNULL(@Precio,0.0) + ISNULL(@Redondeo, 0.0),@Empresa)+' </td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
END
IF @EsImpresion = 1
SELECT @Ticket = @Ticket + @String+'<BR>'+ISNULL(@String2,'')
FETCH NEXT FROM crDoc INTO @Aplica, @AplicaID, @Articulo, @Precio
END
CLOSE crDoc
DEALLOCATE crDoc
SELECT @SubTotal = ISNULL(SUM(ISNULL(((Cantidad - ISNULL(CantidadObsequio,0)) * (Precio - (Precio * (ISNULL(DescuentoLinea,0)/100)))),0)),0.0)
FROM POSLVenta
WHERE ID = @ID
AND Articulo <> ISNULL(@ArticuloRedondeo,'')
SELECT @TotalDescuento = SUM(ISNULL(((Cantidad - ISNULL(CantidadObsequio,0)) * (Precio - (Precio * (ISNULL(DescuentoLinea,0)/100)))),0) *
(CASE WHEN ISNULL(plv.AplicaDescGlobal, 1) = 1 THEN ISNULL(p.DescuentoGlobal,0.0) ELSE 0 END) /100)
FROM POSLVenta plv JOIN POSL p ON p.ID = plv.ID
WHERE p.ID = @ID
SELECT @TotalImpuesto1 = SUM(dbo.fnPOSImporteMov(( ISNULL(((plv.Cantidad - ISNULL(plv.CantidadObsequio,0)) * ((plv.Precio - (plv.Precio * (ISNULL(plv.DescuentoLinea,0)/100))) - ((plv.Precio - (plv.Precio * (ISNULL(plv.DescuentoLinea,0)/100))) *
(CASE WHEN ISNULL(plv.AplicaDescGlobal, 1) = 1 THEN ISNULL(p.DescuentoGlobal,0.0) ELSE 0 END)/100))),0)),plv.Impuesto1,plv.Impuesto2, plv.Impuesto3 ,plv.Cantidad) - (ISNULL(((plv.Cantidad - ISNULL(plv.CantidadObsequio,0)) *
((plv.Precio - (plv.Precio * (ISNULL(plv.DescuentoLinea,0)/100))) - ((plv.Precio - (plv.Precio * (ISNULL(plv.DescuentoLinea,0)/100))) * (CASE WHEN ISNULL(plv.AplicaDescGlobal, 1) = 1 THEN ISNULL(p.DescuentoGlobal,0.0) ELSE 0 END)/100))),0)))
FROM POSLVenta plv JOIN POSL p ON p.ID = plv.ID
WHERE p.ID = @ID
SELECT @Total = ISNULL(@SubTotal,0) - ISNULL(@TotalDescuento,0) + ISNULL(@TotalImpuesto1,0)
SELECT @Totales = dbo.fnAlinearCampoValor2('SUBTOTAL', dbo.fnFormatoMoneda(@SubTotal,@Empresa), @LargoLineaTotales/2) + '<BR>' +
dbo.fnAlinearCampoValor2('DESCUENTO', dbo.fnFormatoMoneda(@TotalDescuento,@Empresa), @LargoLineaTotales/2) + '<BR>' +
dbo.fnAlinearCampoValor2('IMPUESTOS',dbo.fnFormatoMoneda(@TotalImpuesto1,@Empresa), @LargoLineaTotales/2) + '<BR>' +
dbo.fnAlinearCampoValor2('TOTAL', dbo.fnFormatoMoneda(@Total,@Empresa), @LargoLineaTotales/2) + '<BR>'
END
IF @MovClave IN ('POS.AC','POS.AP','POS.CC','POS.CPC','POS.CAC','POS.CCC', 'POS.IC','POS.EC')
BEGIN
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '<table width="100%" style="border-spacing:0px; border-color:#A8A4A4;">'
SET @String = @String + '  <tr style="background-color:#333; border-spacing:0px; border-color:#333;">'
SET @String = @String + '    <th style="text-align:left; color:#f5f5f5; background:#777;">FORMA PAGO </th>'
SET @String = @String + '    <th style="text-align:left; color:#f5f5f5; background:#777;">IMPORTE</th>'
SET @String = @String + '    <th style="text-align:left; color:#f5f5f5; background:#777;">IMPORTE</th>'
SET @String = @String + '    <th style="text-align:right; color:#f5f5f5; background:#777;">MONEDA</th>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF @EsImpresion = 1
SELECT @Ticket = @Ticket + '<BR>'
DECLARE crSaldos CURSOR LOCAL FOR
SELECT dbo.fnRellenarConCaracter(p.FormaPago,30,'d',CHAR(32)),
SUM(p.Importe),
SUM(p.ImporteRef),
fp.Moneda
FROM POSLCobro p
INNER JOIN FormaPago fp ON p.FormaPago = fp.FormaPago
WHERE ID = @ID
GROUP BY p.FormaPago,fp.Moneda
OPEN crSaldos
FETCH NEXT FROM crSaldos INTO @FormaPago, @ImporteCobrado, @ImporteRef, @POSMoneda
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @EsImpresion = 1
BEGIN
SELECT @String = dbo.fnCentrar(REPLICATE(' ', 5) + UPPER(@FormaPago) + ': '+ '  $  ' + STUFF(dbo.fnFormatoMoneda( @ImporteCobrado,@Empresa),1,1,'') +
CASE WHEN @ImporteRef IS NOT NULL THEN '  $ ' + STUFF(dbo.fnFormatoMoneda( @ImporteRef,@Empresa),1,1,'') + ' ' + @POSMoneda
ELSE '' END  , @LargoLineaTicket-4) + '<BR>'
SELECT @Saldos = ISNULL(@Saldos,'') + ISNULL(@String,'')
SELECT @ImporteRef = NULL
SELECT @Ticket = @Ticket + @String
END
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td>'+UPPER(@FormaPago)+'</td>'
SET @String = @String + '    <td> '+dbo.fnFormatoMoneda( @ImporteCobrado,@Empresa)+'</td>'
SET @String = @String + '    <td> '+dbo.fnFormatoMoneda( @ImporteRef,@Empresa)+'</td>'
SET @String = @String + '    <td style="text-align:right;"> '+@POSMoneda+'</td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
END
IF @EsImpresion = 1
EXEC spPOSTicketDenominacion @ID, @Empresa, @MovClave, @FormaPago, @Estacion, @LargoLineaTicket, @EsImpresion, @String2  OUTPUT
SELECT @Ticket = @Ticket + '<BR>' + ISNULL(@String2,'')
FETCH NEXT FROM crSaldos INTO @FormaPago, @ImporteCobrado, @ImporteRef, @POSMoneda
END
CLOSE crSaldos
DEALLOCATE crSaldos
SELECT @String = '<BR>' + dbo.fnAlinearCampoValor2(ISNULL(UPPER(REPLICATE(' ', @LargoLineaTicket - 30) + '    SALDO: '), '') +
dbo.fnAlinearDerecha(dbo.fnFormatoMoneda(ISNULL(@Saldo,0.0),@Empresa),13), '<BR>', @LargoLineaTicket)
END
IF @MovClave IN('POS.ACM','POS.CCCM','POS.TCM','POS.TRM')
BEGIN
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '<table width="100%" style="border-spacing:0px; border-color:#A8A4A4;">'
SET @String = @String + '  <tr style="background-color:#333; border-spacing:0px; border-color:#333;">'
SET @String = @String + '    <th style="text-align:left; color:#f5f5f5; background:#777;">FORMA PAGO </th>'
SET @String = @String + '    <th style="text-align:left; color:#f5f5f5; background:#777;">IMPORTE</th>'
SET @String = @String + '    <th style="text-align:left; color:#f5f5f5; background:#777;">IMPORTE</th>'
SET @String = @String + '    <th style="text-align:right; color:#f5f5f5; background:#777;">MONEDA</th>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF @EsImpresion = 1
SELECT @Ticket = @Ticket + '<BR>'
DECLARE crCta CURSOR LOCAL FOR
SELECT p.CtaDinero
FROM POSLCobro p
WHERE ID = @ID
GROUP BY p.CtaDinero
OPEN crCta
FETCH NEXT FROM crCta INTO @CtaDinero
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @EsImpresion = 1
BEGIN
SELECT @Ticket = @Ticket + '<BR>' + REPLICATE('-', @LargoLineaTicket+ CASE WHEN @EsImpresion=0 THEN 32 ELSE 0 END) +
'<BR>' + dbo.fnCentrar(UPPER('Cuenta'), @LargoLineaTicket /2) + dbo.fnCentrar(UPPER('Cuenta Destino'), @LargoLineaTicket /2) +
'<BR>' +REPLICATE('-', @LargoLineaTicket+32) + '<BR>'
SELECT @Ticket =@Ticket + dbo.fnCentrar(ISNULL(@CtaDinero,''), @LargoLineaTicket/2) + dbo.fnCentrar(ISNULL(@CtaDineroDestino,''), @LargoLineaTicket/2) + '<BR>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '<table width="100%" style="border-spacing:0px; border-color:#A8A4A4;">'
SET @String = @String + '  <tr style="background-color:#333; border-spacing:0px; border-color:#333;">'
SET @String = @String + '    <th style="text-align:left; color:#f5f5f5; background:#777;"> CUENTA </th>'
SET @String = @String + '    <th style="text-align:right; color:#f5f5f5; background:#777;"> CUENTA DESTINO </th>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
DECLARE crSaldos CURSOR LOCAL FOR
SELECT dbo.fnRellenarConCaracter(p.FormaPago,30,'d',CHAR(32)), p.Importe, p.ImporteRef, fp.Moneda
FROM POSLCobro p
INNER JOIN FormaPago fp ON p.FormaPago = fp.FormaPago
WHERE p.ID = @ID AND p.Ctadinero =@CtaDinero
OPEN crSaldos
FETCH NEXT FROM crSaldos INTO @FormaPago, @ImporteCobrado, @ImporteRef, @POSMoneda
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @EsImpresion = 1
BEGIN
SELECT @Saldos = ISNULL(@Saldos,'') + ISNULL(@String,'')
SELECT @String =dbo.fnCentrar(REPLICATE(' ', 5) + UPPER(@FormaPago) + ': '+ '  $  ' + STUFF(dbo.fnFormatoMoneda( @ImporteCobrado,@Empresa),1,1,'') +
CASE WHEN @ImporteRef IS NOT NULL THEN '  $ ' + STUFF(dbo.fnFormatoMoneda( @ImporteRef,@Empresa),1,1,'') + ' ' + @POSMoneda ELSE '' END, @LargoLineaTicket-4) + '<BR>'
END
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td> '+UPPER(@CtaDinero)+' </td>'
SET @String = @String + '    <td style="text-align:right;"> '+@CtaDineroDestino+' </td>'
SET @String = @String + '  </tr>'
SET @String = @String + '  <tr>'
SET @String = @String + '    <td>'+UPPER(@FormaPago)+'</td>'
SET @String = @String + '    <td> '+dbo.fnFormatoMoneda( @ImporteCobrado,@Empresa)+'</td>'
SET @String = @String + '    <td> '+dbo.fnFormatoMoneda( @ImporteRef,@Empresa)+'</td>'
SET @String = @String + '    <td style="text-align:right;"> '+@POSMoneda+'</td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
SELECT @ImporteRef = NULL
END
IF @EsImpresion = 1
BEGIN
EXEC spPOSTicketDenominacion @ID, @Empresa, @MovClave, @FormaPago, @Estacion, @LargoLineaTicket, @EsImpresion, @String2  OUTPUT
SELECT @Ticket = @Ticket + @String + '<BR>' + ISNULL(@String2,'')
END
FETCH NEXT FROM crSaldos INTO @FormaPago, @ImporteCobrado, @ImporteRef, @POSMoneda
END
CLOSE crSaldos
DEALLOCATE crSaldos
FETCH NEXT FROM crCta INTO @CtaDinero
END
CLOSE crCta
DEALLOCATE crCta
END
IF @MovClave IN('POS.CCM','POS.CPCM','POS.CACM','POS.CTCM','POS.CTRM')
BEGIN
DECLARE crCta CURSOR LOCAL FOR
SELECT p.CtaDineroDestino
FROM POSLCobro p
WHERE ID = @ID
GROUP BY p.CtaDineroDestino
OPEN crCta
FETCH NEXT FROM crCta INTO @CtaDineroDestino
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @EsImpresion = 1
BEGIN
SELECT @Ticket = @Ticket + '<BR>' + REPLICATE('-', @LargoLineaTicket + CASE WHEN @EsImpresion = 0 THEN 32 ELSE 0 END) + '<BR>' +
dbo.fnCentrar(UPPER('Cuenta'), @LargoLineaTicket /2) + dbo.fnCentrar(UPPER('Cuenta Destino'), @LargoLineaTicket /2) + '<BR>' +
REPLICATE('-', @LargoLineaTicket + CASE WHEN @EsImpresion = 0 THEN 32 ELSE 0 END) + '<BR>'
SELECT @Ticket =@Ticket + dbo.fnCentrar(ISNULL(@CtaDinero,''), @LargoLineaTicket/2) + dbo.fnCentrar(ISNULL(@CtaDineroDestino,''), @LargoLineaTicket/2) + '<BR>'
END
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '<table width="100%" style="border-spacing:0px; border-color:#A8A4A4;">'
SET @String = @String + '  <tr style="background-color:#333; border-spacing:0px; border-color:#333;">'
SET @String = @String + '    <th style="text-align:left; color:#f5f5f5; background:#777;"> CUENTA </th>'
SET @String = @String + '    <th style="text-align:right; color:#f5f5f5; background:#777;"> CUENTA DESTINO </th>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
DECLARE crSaldos CURSOR LOCAL FOR
SELECT dbo.fnRellenarConCaracter(p.FormaPago,30,'d',CHAR(32)), SUM(p.Importe), SUM(p.ImporteRef), fp.Moneda
FROM POSLCobro p
INNER JOIN FormaPago fp ON p.FormaPago = fp.FormaPago
WHERE p.ID = @ID AND p.CtadineroDestino =@CtaDineroDestino
GROUP BY p.FormaPago,fp.Moneda
OPEN crSaldos
FETCH NEXT FROM crSaldos INTO @FormaPago, @ImporteCobrado, @ImporteRef, @POSMoneda
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @EsImpresion = 1
BEGIN
SELECT @String = dbo.fnCentrar(REPLICATE(' ', 5) + UPPER(@FormaPago) + ': '+ '  $  ' + STUFF(dbo.fnFormatoMoneda( @ImporteRef,@Empresa),1,1,'') +
CASE WHEN @ImporteRef IS NOT NULL THEN '  $ '+ STUFF(dbo.fnFormatoMoneda( @ImporteCobrado,@Empresa),1,1,'') + ' ' + @Moneda ELSE '' END,
@LargoLineaTicket-4) + '<BR>'
END
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td> '+UPPER(@CtaDinero)+' </td>'
SET @String = @String + '    <td style="text-align:right;"> '+@CtaDineroDestino+' </td>'
SET @String = @String + '  </tr>'
SET @String = @String + '  <tr>'
SET @String = @String + '    <td>'+UPPER(@FormaPago)+'</td>'
SET @String = @String + '    <td> '+dbo.fnFormatoMoneda( @ImporteCobrado,@Empresa)+'</td>'
SET @String = @String + '    <td> '+dbo.fnFormatoMoneda( @ImporteRef,@Empresa)+'</td>'
SET @String = @String + '    <td style="text-align:right;"> '+@POSMoneda+'</td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
SELECT @ImporteRef = NULL
END
IF @EsImpresion = 1
BEGIN
EXEC spPOSTicketDenominacion @ID, @Empresa, @MovClave, @FormaPago, @Estacion, @LargoLineaTicket, @EsImpresion, @String2  OUTPUT
SELECT @Ticket = @Ticket + @String + '<BR>' + ISNULL(@String2,'')
END
FETCH NEXT FROM crSaldos INTO @FormaPago, @ImporteCobrado, @ImporteRef, @POSMoneda
END
CLOSE crSaldos
DEALLOCATE crSaldos
FETCH NEXT FROM crCta INTO @CtaDineroDestino
END
CLOSE crCta
DEALLOCATE crCta
END
IF @MovClave IN ('POS.N', 'POS.A', 'POS.F','POS.P','POS.NPC','POS.FA')
SELECT @Saldos = ISNULL(@Saldos,'') + ISNULL(@String,'')
END
IF EXISTS(SELECT * FROM POSLAmortizacionPagos pap WHERE pap.ID = @ID)
BEGIN
SELECT @String = '<BR>' + dbo.fnCentrar(UPPER('FECHA AMORT.') + REPLICATE(' ', 4) + 'MONTO' + REPLICATE(' ', 4) + 'INTERES' + REPLICATE(' ', 4) + 'MONTO TOTAL' , @LargoLineaTicket) +  '<BR>'
DECLARE crPOSLAmortizacionPagos CURSOR LOCAL FOR
SELECT pap.Fecha, pap.Importe, pap.Interes
FROM POSLAmortizacionPagos pap
WHERE pap.ID = @ID
OPEN crPOSLAmortizacionPagos
FETCH NEXT FROM crPOSLAmortizacionPagos INTO @FechaAmortizacion, @ImporteAmortizacion, @InteresAmortizacion
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @InteresAmortizacion = @ImporteAmortizacion * (ISNULL(@InteresAmortizacion,0)/100)
SELECT @TotalAmortizacion = @ImporteAmortizacion + ISNULL(@InteresAmortizacion,0)
SELECT @String = @String + dbo.fnCentrar(CONVERT(varchar, @FechaAmortizacion, 103) + '    ' + dbo.fnFormatoMoneda(@ImporteAmortizacion,@Empresa) + '    ' +
dbo.fnFormatoMoneda(@InteresAmortizacion,@Empresa) + '    ' + dbo.fnFormatoMoneda(@TotalAmortizacion,@Empresa) + '<BR>', @LargoLineaTicket)
END
FETCH NEXT FROM crPOSLAmortizacionPagos INTO @FechaAmortizacion, @ImporteAmortizacion, @InteresAmortizacion
END
CLOSE crPOSLAmortizacionPagos
DEALLOCATE crPOSLAmortizacionPagos
SELECT @Ticket = ISNULL(@Ticket,'') + '<BR>'+ ISNULL(@String,'')
END
IF @CodigoAccion = 'MODIFICAR CONDICION'
BEGIN
SELECT @Ticket = '<BR>' + dbo.fnCentrar('CONDICION', @LargoLineaTicket) + '<BR>'
SELECT @Ticket = @Ticket + REPLICATE('-', @LargoLineaTicket) + '<BR>'
DECLARE crCondicion CURSOR LOCAL FOR
SELECT DISTINCT Condicion, ControlAnticipos
FROM Condicion
OPEN crCondicion
FETCH NEXT FROM crCondicion INTO @Condicion, @ControlAnticipos
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Ticket = @Ticket + dbo.fnCentrar(@Condicion, @LargoLineaTicket) + CASE WHEN @ControlAnticipos = 'Cobrar Pedido' THEN ' ** <BR>' ELSE '<BR>' END
END
FETCH NEXT FROM crCondicion INTO @Condicion, @ControlAnticipos
END
CLOSE crCondicion
DEALLOCATE crCondicion
END
IF @CodigoAccion = 'MODIFICAR ALM SUC'
BEGIN
SELECT @Ticket = '<BR>' + dbo.fnCentrar('ALMACEN', @LargoLineaTicket) + '<BR>'
SELECT @Ticket = @Ticket + REPLICATE('-', @LargoLineaTicket) + '<BR>'
DECLARE crAlm CURSOR LOCAL FOR
SELECT dbo.fnRellenarConCaracter(CONVERT(varchar,Rtrim(Almacen)),10,'i',CHAR(32)) , SUBSTRING(Nombre,1,30)
FROM Alm
WHERE Sucursal = @Sucursal
OPEN crAlm
FETCH NEXT FROM crAlm INTO @AlmacenV, @AlmacenVNombre
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Ticket = @Ticket + @AlmacenV +'  '+@AlmacenVNombre+ '<BR>'
END
FETCH NEXT FROM crAlm INTO @AlmacenV, @AlmacenVNombre
END
CLOSE crAlm
DEALLOCATE crAlm
END
IF @CodigoAccion = 'MODIFICAR ALM FOR'
BEGIN
SELECT @Ticket = '<BR>' + dbo.fnCentrar('ALMACEN', @LargoLineaTicket) + '<BR>'
SELECT @Ticket = @Ticket + REPLICATE('-', @LargoLineaTicket) + '<BR>'
DECLARE crAlm CURSOR LOCAL FOR
SELECT dbo.fnRellenarConCaracter(CONVERT(varchar,Rtrim(Almacen)),10,'i',CHAR(32)) , SUBSTRING(Nombre,1,30)
FROM Alm
WHERE Sucursal <> @Sucursal
OPEN crAlm
FETCH NEXT FROM crAlm INTO @AlmacenV, @AlmacenVNombre
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Ticket = @Ticket + @AlmacenV +'  '+@AlmacenVNombre+ '<BR>'
END
FETCH NEXT FROM crAlm INTO @AlmacenV, @AlmacenVNombre
END
CLOSE crAlm
DEALLOCATE crAlm
END
IF @CodigoAccion IN('FORMA ENVIO')
BEGIN
IF @MovClave IN ('POS.P', 'POS.N')
BEGIN
DELETE POSFormaEnvioTemp WHERE Estacion = @Estacion
INSERT POSFormaEnvioTemp(Estacion, FormaEnvio)
SELECT					@Estacion, FormaEnvio
FROM FormaEnvio
SELECT @Orden = 0
UPDATE POSFormaEnvioTemp
SET @Orden = Orden = @Orden + 1
FROM POSFormaEnvioTemp
WHERE  Estacion = @Estacion
END
IF @EsImpresion = 0
BEGIN
SET @Ticket = ''
SET @String = ''
SET @String = @String + '<table width="100%" style="border-spacing:0px; border-color:#A8A4A4;">'
SET @String = @String + '  <tr style="background-color:#333; border-spacing:0px; border-color:#333;">'
SET @String = @String + '    <th style="text-align:left; color:#f5f5f5; background:#777;"> NUMERO </th>'
SET @String = @String + '    <th style="text-align:right; color:#f5f5f5; background:#777;"> FORMA ENVIO </th>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF @EsImpresion = 1
BEGIN
SELECT @Ticket = '<BR>' + 'NUMERO' + dbo.fnCentrar('FORMA ENVIO', @LargoLineaTicket) + '<BR>'
SELECT @Ticket = @Ticket + REPLICATE('-', @LargoLineaTicket) + REPLICATE('-', @LargoLineaTicket) + '<BR>'
END
DECLARE crCondicion CURSOR LOCAL FOR
SELECT Orden, FormaEnvio
FROM POSFormaEnvioTemp
WHERE Estacion = @Estacion
OPEN crCondicion
FETCH NEXT FROM crCondicion INTO @Numero , @FormaEnvio
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @EsImpresion = 1
SELECT @Ticket = @Ticket + CONVERT(varchar,@Numero) + '  ' + @FormaEnvio + '<BR>'
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td> '+CONVERT(varchar,@Numero)+'  </td>'
SET @String = @String + '    <td style="text-align:right;"> '+@FormaEnvio+'  </td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
END
FETCH NEXT FROM crCondicion INTO @Numero , @FormaEnvio
END
CLOSE crCondicion
DEALLOCATE crCondicion
END
IF @CodigoAccion = 'INTRODUCIR CONCEPTOCXC'
BEGIN
IF @EsImpresion = 0
BEGIN
SET @Ticket = ''
SET @String = ''
SET @String = @String + '<table width="100%" style="border-spacing:0px; border-color:#A8A4A4;">'
SET @String = @String + '  <tr style="background-color:#333; border-spacing:0px; border-color:#333;">'
SET @String = @String + '    <th style="text-align:left; color:#f5f5f5; background:#777;"> NUMERO </th>'
SET @String = @String + '    <th style="text-align:right; color:#f5f5f5; background:#777;"> CONCEPTO </th>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
IF @EsImpresion = 1
BEGIN
SELECT @Ticket = '<BR>' + 'NUMERO' + dbo.fnCentrar('CONCEPTO', @LargoLineaTicket) + '<BR>'
SELECT @Ticket = @Ticket + REPLICATE('-', @LargoLineaTicket) + REPLICATE('-', @LargoLineaTicket) + '<BR>'
END
DECLARE crCondicion CURSOR LOCAL FOR
SELECT Orden,Concepto
FROM POSConceptoCXCTemp
WHERE Estacion = @Estacion
OPEN crCondicion
FETCH NEXT FROM crCondicion INTO @Numero , @Conceptocxc
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @EsImpresion = 1
SELECT @Ticket = @Ticket + CONVERT(varchar,@Numero)+ dbo.fnCentrar(@Conceptocxc, @LargoLineaTicket-4) + '<BR>'
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td> '+CONVERT(varchar,@Numero)+'  </td>'
SET @String = @String + '    <td style="text-align:right;"> '+@Conceptocxc+'  </td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
END
FETCH NEXT FROM crCondicion INTO @Numero , @Conceptocxc
END
CLOSE crCondicion
DEALLOCATE crCondicion
END
IF @CodigoAccion = 'INTRODUCIR CONCEPTODIN'
BEGIN
DELETE POSConceptoDINTemp WHERE Estacion = @Estacion
INSERT INTO POSConceptoDINTemp (Estacion, Concepto)
SELECT							@Estacion, Concepto
FROM Concepto
WHERE Modulo = 'DIN'
SELECT @Orden = 0
UPDATE POSConceptoDINTemp SET @Orden = Orden = @Orden + 1
FROM POSConceptoDINTemp
WHERE Estacion = @Estacion
SELECT @Ticket = '<BR>' + 'NUMERO' + dbo.fnCentrar('CONCEPTO', @LargoLineaTicket) + '<BR>'
SELECT @Ticket = @Ticket + REPLICATE('-', @LargoLineaTicket)  +REPLICATE('-', @LargoLineaTicket) + '<BR>'
DECLARE crCondicion CURSOR LOCAL FOR
SELECT Orden, Concepto
FROM POSConceptoDINTemp
WHERE Estacion = @Estacion
OPEN crCondicion
FETCH NEXT FROM crCondicion INTO @Numero , @ConceptoDIN
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Ticket = @Ticket + CONVERT(varchar,@Numero) + ' ' + @ConceptoDIN + '<BR>'
END
FETCH NEXT FROM crCondicion INTO @Numero , @ConceptoDIN
END
CLOSE crCondicion
DEALLOCATE crCondicion
END
IF @CodigoAccion IN('ALMACEN DESTINO')
BEGIN
SELECT @Ticket = '<BR>' + 'NUMERO' + dbo.fnCentrar('ALMACEN', @LargoLineaTicket) + '<BR>'
SELECT @Ticket = @Ticket + REPLICATE('-', @LargoLineaTicket) + REPLICATE('-', @LargoLineaTicket) + '<BR>'
DECLARE crCondicion CURSOR LOCAL FOR
SELECT dbo.fnRellenarConCaracter(CONVERT(varchar,p.Orden),4,'i',CHAR(32)),
dbo.fnRellenarConCaracter(CONVERT(varchar,p.Almacen),10,'i',CHAR(32)) , SUBSTRING(a.Nombre,1,30)
FROM POSAlmTemp p JOIN Alm a ON p.Almacen = a.Almacen
WHERE p.Estacion = @Estacion
OPEN crCondicion
FETCH NEXT FROM crCondicion INTO @Numero , @AlmacenD, @AlmacenDNombre
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Ticket = @Ticket + CONVERT(varchar,@Numero) + '  ' + @AlmacenD + '  ' + @AlmacenDNombre + '<BR>'
END
FETCH NEXT FROM crCondicion INTO @Numero , @AlmacenD,  @AlmacenDNombre
END
CLOSE crCondicion
DEALLOCATE crCondicion
END
IF @Accion = 'VER CORTE CAJA'
BEGIN
SELECT TOP 1 @Moneda = Moneda
FROM POSLTipoCambioRef
WHERE TipoCambio = 1
AND Sucursal = @Sucursal
AND EsPrincipal = 1
SELECT @DirectorioEstilo = Directorio
FROM POSUsuarioEstacion
WHERE Empresa = @Empresa
AND Sucursal = @Sucursal
AND Usuario = @Usuario
AND Estacion = @Estacion
SET @DirectorioEstilo = ISNULL(@DirectorioEstilo,'')
IF ISNULL(@DirectorioEstilo,'') <> '' AND RIGHT(@DirectorioEstilo,1) <> '\'
SET @DirectorioEstilo = @DirectorioEstilo + '\'
SET @Ticket = ''
SET @String = ''
SET @String = @String + '<!DOCTYPE HTML>'
SET @String = @String + '<html>'
SET @String = @String + '<head>'
SET @String = @String + '<title>Ticket POS</title>'
SET @String = @String + '<meta name="viewport" content="width=device-width, initial-scale=1">'
SET @String = @String + '<meta http-equiv="Content-Type" content="text/html; charset=latin1" />'
SET @String = @String + '<meta name="keywords" content="POS, SDK"/>'
SET @String = @String + '<base href="'+@DirectorioEstilo+'">'
SET @String = @String + '<link href="web/css/bootstrap.min.css" rel="stylesheet" type="text/css" />'
SET @String = @String + '<link href="web/css/style.css" rel="stylesheet" type="text/css" />'
SET @String = @String + '<link rel="stylesheet" href="web/css/morris.css" type="text/css"/>'
SET @String = @String + '<link href="web/css/font-awesome.css" rel="stylesheet">'
SET @String = @String + '<link rel="stylesheet" type="text/css" href="web/css/table-style.css" />'
SET @String = @String + '<link rel="stylesheet" type="text/css" href="web/css/basictable.css" />'
SET @String = @String + '<link rel="stylesheet" href="web/css/icon-font.min.css" type="text/css" />'
SET @String = @String + '</head>'
SET @String = @String + '<body>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
SET @String = @String + '<table width="100%" style="border-spacing:0px; border-color:#A8A4A4;">'
SET @String = @String + '  <tr style="background-color:#333; border-spacing:0px; border-color:#333;">'
SET @String = @String + '    <th style="text-align:left; color:#f5f5f5; background:#777;">CODIGO</th>'
SET @String = @String + '    <th style="text-align:left; color:#f5f5f5; background:#777;">FORMA</th>'
SET @String = @String + '    <th style="text-align:left; color:#f5f5f5; background:#777;">IMPORTE</th>'
SET @String = @String + '    <th style="text-align:right; color:#f5f5f5; background:#777;">IMPORTE REF</th>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
DECLARE crFormaPago CURSOR LOCAL FOR
SELECT plc.FormaPago, SUM(plc.Importe * mt.Factor), SUM(plc.ImporteRef * mt.Factor)
FROM POSLCobro plc
LEFT JOIN POSL p ON plc.ID = p.ID
INNER JOIN MovTipo mt ON p.Mov = mt.Mov AND mt.Modulo = 'POS'
WHERE p.Caja = @CajaActual
AND p.Estatus NOT IN ('CANCELADO', 'SINAFECTAR','PENDIENTE', 'TRASPASADO', 'CONERROR', 'NOTFOUND35')
AND p.Empresa = @Empresa
GROUP BY plc.FormaPago
OPEN crFormaPago
FETCH NEXT FROM crFormaPago INTO @FormaPago, @Importe, @ImporteRef
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @CodigoFormaPago = codigo
FROM CB
WHERE cb.FormaPago = @FormaPago
AND cb.TipoCuenta = 'Forma Pago'
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td>'+UPPER(@CodigoFormaPago)+'</td>'
SET @String = @String + '    <td>'+UPPER(@FormaPago)+'</td>'
SET @String = @String + '    <td>'+dbo.fnFormatoMoneda(@Importe,@Empresa)+'</td>'
SET @String = @String + '    <td style="text-align:right;">'+dbo.fnFormatoMoneda(@ImporteRef,@Empresa)+'</td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
FETCH NEXT FROM crFormaPago INTO @FormaPago, @Importe, @ImporteRef
END
CLOSE crFormaPago
DEALLOCATE crFormaPago
SET @String = ''
SET @String = @String + '</body>'
SET @String = @String + '</html>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
END
IF @Accion = 'CONSULTAR INV'
BEGIN
SELECT @Articulo = NULL, @SubCuenta = NULL, @ArtDescripcion = NULL
SELECT @Articulo = cb.Cuenta,
@SubCuenta = cb.SubCuenta,
@ArtDescripcion = a.Descripcion1
FROM CB
INNER JOIN Art a ON CB.Cuenta = a.Articulo
WHERE cb.Codigo = @ArtConsulta
AND cb.TipoCuenta = 'Articulos'
SELECT @Ticket = REPLICATE('-', @LargoLineaTicket + 3) + '<BR>' + dbo.fnCentrar('SUCURSAL   ' + UPPER('Codigo'), @LargoLineaTicket /3.5) +
dbo.fnCentrar(UPPER('Articulo'), @LargoLineaTicket /5) + dbo.fnCentrar(UPPER('Opcion'), @LargoLineaTicket /5) +
dbo.fnCentrar(UPPER('Descripcion'), @LargoLineaTicket /3) +  dbo.fnCentrar(UPPER('Inventario'), @LargoLineaTicket /2.8) + '<BR>' +
REPLICATE('-', @LargoLineaTicket+32) + '<BR>'
IF @Articulo IS NOT NULL
BEGIN
DECLARE crSuc CURSOR LOCAL FOR
SELECT Sucursal
FROM Sucursal
OPEN crSuc
FETCH NEXT FROM crSUC INTO @SucursalInv
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @SucursalInvNombre = Nombre + ' ' +  CONVERT(varchar, Sucursal)
FROM Sucursal
WHERE Sucursal = @SucursalInv
EXEC spPOSInvSucursal @Empresa, @SucursalInv, @Articulo, @SubCuenta, @Inventario OUTPUT
IF ISNULL(@Inventario,0) <> 0
SELECT @Ticket = @Ticket + LEFT(UPPER(@SucursalInvNombre) + '   ',10)  + ' ' +
LEFT(UPPER(@ArtConsulta) + '                        ',8) + ' ' +
LEFT(UPPER(@Articulo) + '   ',10) + ' ' + LEFT(UPPER(@SubCuenta) + '                ',10) + ' ' +
LEFT(UPPER(@ArtDescripcion) + '                       ',16) + ' ' + RIGHT( + '                  ' +
UPPER(Convert(varchar,Convert(money, ISNULL(@Inventario,0)),102)),10) + '<BR>'
END
FETCH NEXT FROM crSUC INTO @SucursalInv
END
CLOSE crSuc
DEALLOCATE crSuc
END
END
IF @Accion = 'VERIFICAR PRECIOS'
BEGIN
EXEC spPOSVerificadorPrecios @ID, @ArtConsulta, @Usuario, @Estacion, @Ticket OUTPUT, @Ok OUTPUT, @okRef OUTPUT
END
IF @Accion = 'BUSCAR ARTICULOS'
BEGIN
SELECT @Ticket = REPLICATE('-', @LargoLineaTicket) + '<BR>' + dbo.fnCentrar(UPPER('Codigo'), @LargoLineaTicket /5) +
dbo.fnCentrar(UPPER('Articulo'), @LargoLineaTicket /4) + dbo.fnCentrar(UPPER('Descripcion'), @LargoLineaTicket /3) +
dbo.fnCentrar(UPPER(''), @LargoLineaTicket /1.5) + '<BR>' +REPLICATE('-', @LargoLineaTicket) + '<BR>'
DECLARE crCB CURSOR LOCAL FOR
SELECT c.Codigo, c.Cuenta, c.SubCuenta, a.Descripcion1, a.Unidad
FROM CB c
INNER JOIN Art a ON c.Cuenta = a.Articulo AND a.Descripcion1 LIKE '%'+ @ArtConsulta +'%'
WHERE c.TipoCuenta = 'Articulos'
ORDER BY Descripcion1
OPEN crCB
FETCH NEXT FROM crCB INTO @CodigoBarras, @Articulo, @SubCuenta, @ArtDescripcion, @Unidad
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Precio = NULL, @DescuentoLinea = NULL
EXEC spArtPrecio @Articulo, 1, @Unidad, @Precio OUTPUT, @DescuentoLinea OUTPUT, NULL,
@SubCuenta, @FechaEmision, @Agente, @Moneda, @TipoCambio, @Condicion,
@Almacen, @Proyecto, @FormaEnvio, @Mov, @Empresa, @Sucursal, @ListaPreciosEsp,
@Cliente
SELECT @Ticket = @Ticket + '  '+UPPER(@CodigoBarras) +'         '  + dbo.fnAlinearDerecha(@Articulo, 10) + '   ' +
LEFT(CONVERT(char(30),UPPER(@ArtDescripcion)) + REPLICATE(' ', 8),30) + '<BR>'
END
FETCH NEXT FROM crCB INTO @CodigoBarras, @Articulo, @SubCuenta, @ArtDescripcion, @Unidad
END
CLOSE crCB
DEALLOCATE crCB
END
IF @CodigoAccion = 'CAMBIAR MOVIMIENTO'
BEGIN
SELECT @Ticket = '<BR>' + dbo.fnCentrar('MOVIMIENTO', @LargoLineaTicket-2) + '<BR>'
SELECT @Ticket = @Ticket + REPLICATE('-', @LargoLineaTicket-2) + '<BR>'
DECLARE crMovTipo CURSOR LOCAL FOR
SELECT dbo.fnRellenarConCaracter(CONVERT(varchar, mt.Orden),5,'d',CHAR(32)) + '  ' + mt.Mov
FROM MovTipo mt JOIN POSUsuarioMov pu ON mt.Mov = pu.Mov
WHERE mt.Modulo = 'POS'
AND mt.Clave NOT IN('POS.CTCAC','POS.CTCRC','POS.STE','POS.FTE','POS.TCRC','POS.TCAC','POS.ET')
AND pu.Usuario = ISNULL(NULLIF(@UsuarioPerfil,''),@Usuario)
ORDER BY mt.Orden
OPEN crMovTipo
FETCH NEXT FROM crMovTipo INTO @String
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Ticket = @Ticket + @String + '<BR>'
END
FETCH NEXT FROM crMovTipo INTO @String
END
CLOSE crMovTipo
DEALLOCATE crMovTipo
END
IF @CodigoAccion IN( 'REVERSAR COBRO')
BEGIN
SELECT @Ticket = '<BR>' + 'FORMAS DE PAGO' + '<BR>'
SELECT @Ticket = @Ticket + REPLICATE('-', @LargoLineaTicket-2) + '<BR>'
DECLARE crMovTipo CURSOR LOCAL FOR
SELECT Codigo + SPACE(15) + FormaPago
FROM CB
WHERE TipoCuenta = 'Forma Pago'
OPEN crMovTipo
FETCH NEXT FROM crMovTipo INTO @String
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Ticket = @Ticket + @String + '<BR>'
END
FETCH NEXT FROM crMovTipo INTO @String
END
CLOSE crMovTipo
DEALLOCATE crMovTipo
END
IF @CodigoAccion = 'INTRODUCIR CUENTA DINERO'
BEGIN
SELECT @DirectorioEstilo = Directorio
FROM POSUsuarioEstacion
WHERE Empresa = @Empresa
AND Sucursal = @Sucursal
AND Usuario = @Usuario
AND Estacion = @Estacion
SET @DirectorioEstilo = ISNULL(@DirectorioEstilo,'')
IF ISNULL(@DirectorioEstilo,'') <> '' AND RIGHT(@DirectorioEstilo,1) <> '\'
SET @DirectorioEstilo = @DirectorioEstilo + '\'
SET @Ticket = ''
SET @String = ''
SET @String = @String + '<!DOCTYPE HTML>'
SET @String = @String + '<html>'
SET @String = @String + '<head>'
SET @String = @String + '<title>Ticket POS</title>'
SET @String = @String + '<meta name="viewport" content="width=device-width, initial-scale=1">'
SET @String = @String + '<meta http-equiv="Content-Type" content="text/html; charset=latin1" />'
SET @String = @String + '<meta name="keywords" content="POS, SDK"/>'
SET @String = @String + '<base href="'+@DirectorioEstilo+'">'
SET @String = @String + '<link href="web/css/bootstrap.min.css" rel="stylesheet" type="text/css" />'
SET @String = @String + '<link href="web/css/style.css" rel="stylesheet" type="text/css" />'
SET @String = @String + '<link rel="stylesheet" href="web/css/morris.css" type="text/css"/>'
SET @String = @String + '<link href="web/css/font-awesome.css" rel="stylesheet">'
SET @String = @String + '<link rel="stylesheet" type="text/css" href="web/css/table-style.css" />'
SET @String = @String + '<link rel="stylesheet" type="text/css" href="web/css/basictable.css" />'
SET @String = @String + '<link rel="stylesheet" href="web/css/icon-font.min.css" type="text/css" />'
SET @String = @String + '</head>'
SET @String = @String + '<body>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
SET @String = @String + '<table width="100%" style="border-spacing:0px; border-color:#A8A4A4;">'
SET @String = @String + '  <tr style="background-color:#333; border-spacing:0px; border-color:#333;">'
SET @String = @String + '    <th style="text-align:left; color:#f5f5f5; background:#777;"> CUENTA </th>'
SET @String = @String + '    <th style="text-align:right; color:#f5f5f5; background:#777;"> DESCRIPCI±N </th>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @CtaDineroMM = NULL
SET @CtaDineroMM = @CtaDineroMMDescripcion
DECLARE crCtaDinero CURSOR LOCAL FOR
SELECT c.CtaDinero , ISNULL(c.Descripcion, '')
FROM CtaDinero c JOIN POSL p ON c.Sucursal = p.Sucursal
WHERE Tipo = CASE WHEN @MovClave IN('POS.TCM','POS.TRM') THEN 'Caja' ELSE 'Banco' END
AND c.Empresa = @Empresa
AND p.ID = @ID
AND c.EsConcentradora = CASE WHEN @MovClave IN('POS.TCM','POS.TRM') THEN 1 ELSE 0 END
OPEN crCtaDinero
FETCH NEXT FROM crCtaDinero INTO @CtaDineroMM, @CtaDineroMMDescripcion
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SET @String = ''
SET @String = @String + '  <tr>'
SET @String = @String + '    <td> '+UPPER(@CtaDineroMM)+' </td>'
SET @String = @String + '    <td style="text-align:right;"> '+@CtaDineroMMDescripcion+' </td>'
SET @String = @String + '  </tr>'
SET @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
END
FETCH NEXT FROM crCtaDinero INTO @CtaDineroMM, @CtaDineroMMDescripcion
END
CLOSE crCtaDinero
DEALLOCATE crCtaDinero
END
IF @CodigoAccion = 'ASIGNAR CAJA'
BEGIN
SELECT @Ticket = '<BR>' + dbo.fnCentrar('CAJA', @LargoLineaTicket) + '<BR>'
SELECT @Ticket = @Ticket + REPLICATE('-', @LargoLineaTicket) + '<BR>'
DECLARE crCtaDinero CURSOR LOCAL FOR
SELECT c.CtaDinero + '  ' + ISNULL(c.Descripcion, '')
FROM CtaDinero c JOIN POSL p ON c.Sucursal = p.Sucursal
WHERE Tipo = 'Caja'
AND c.Empresa = @Empresa
AND p.ID = @ID
OPEN crCtaDinero
FETCH NEXT FROM crCtaDinero INTO @String
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Ticket = @Ticket + dbo.fnCentrar(@String, @LargoLineaTicket) + '<BR>'
END
FETCH NEXT FROM crCtaDinero INTO @String
END
CLOSE crCtaDinero
DEALLOCATE crCtaDinero
END
IF @CodigoAccion = 'MODIFICAR COMPONENTE'
BEGIN
DELETE POSTempArtJuego WHERE Estacion = @Estacion
INSERT POSTempArtJuego(Estacion, ID, RID, RenglonID, Articulo)
SELECT				   @Estacion,NULL,@ID,RenglonID, Articulo
FROM POSLVenta
WHERE ID = @ID
AND RenglonTipo = 'J'
SET @IDTemp = 0
UPDATE POSTempArtJuego SET @IDTemp = ID = @IDTemp + 1
FROM POSTempArtJuego
WHERE RID = @ID
AND Estacion = @Estacion
SELECT @Ticket = '<BR>' + REPLICATE('-', @LargoLineaTicket + CASE WHEN @EsImpresion = 0 THEN 32 ELSE 0 END) + '<BR>' +
dbo.fnCentrar(UPPER('Numero'), @LargoLineaTicket /2) + dbo.fnCentrar(UPPER('Articulo'), @LargoLineaTicket /2) + '<BR>'
DECLARE crArt CURSOR LOCAL FOR
SELECT CONVERT(varchar,v.ID)+ '            ' + ISNULL(a.Descripcion1, '')
FROM POSTempArtJuego v JOIN Art a ON v.Articulo = a.Articulo
WHERE v.RID = @ID AND Estacion = @Estacion
OPEN crArt
FETCH NEXT FROM crArt INTO @String
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Ticket = @Ticket + dbo.fnCentrar(@String, @LargoLineaTicket) + '<BR>'
END
FETCH NEXT FROM crArt INTO @String
END
CLOSE crArt
DEALLOCATE crArt
END
IF @EsImpresion = 0
BEGIN
SET @String = ''
SET @String = @String + '</body>'
SET @String = @String + '</html>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
END
END

