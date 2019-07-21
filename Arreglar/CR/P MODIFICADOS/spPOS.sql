SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOS
@Estacion 			int,
@Codigo				varchar(50),
@Empresa			varchar(5),
@Modulo				varchar(5),
@Sucursal			int,
@Usuario			varchar(10),
@Referencia			varchar(50),
@ID					varchar(50) = NULL,
@Importe			float = NULL,
@CodigoCambio		varchar(30) = NULL,
@ImporteCambio		float = NULL,
@Cobro				bit = 0,
@LecturaTarjeta		varchar(200) = NULL,
@Cliente			varchar(10) = NULL,
@Monedero			varchar(20) = NULL,
@ImporteRef			float = NULL,
@Ticket				varchar(MAX) =NULL	OUTPUT,
@DesgloseC			bit = 0,
@EsImpresion		bit = 0,
@EnSilencio			bit = 0,
@Ok					int = NULL			OUTPUT,
@OkRef				varchar(255)= NULL  OUTPUT

AS
BEGIN
BEGIN TRAN
DECLARE
@RecalcularTodo						bit,
@Accion								varchar(50),
@CodigoAccion						varchar(50),
@CodigoAccionSecundario				varchar(50),
@TipoCuenta							varchar(20),
@Totales							varchar(MAX),
@Saldos								varchar(MAX),
@Total								decimal(32,10),
@Saldo								decimal(32,10),
@ImporteMov							float,
@ImporteCobrado						float,
@SumaCobrado						float,
@Imagen								varchar(255),
@ImagenNombreAnexo					varchar(255),
@CantidadNotasEnProceso				int,
@IDM								varchar(50),
@Mov								varchar(20),
@MovClave							varchar(20),
@FechaEmision						datetime,
@FechaRegistro						datetime,
@Concepto							varchar(50),
@Proyecto							varchar(50),
@UEN								int,
@Moneda								varchar(10),
@MonedaSuc							varchar(10),
@TipoCambio							float,
@Almacen							varchar(10),
@Agente								varchar(10),
@Cajero								varchar(10),
@FormaEnvio							varchar(50),
@Condicion							varchar(50),
@Vencimiento						varchar(50),
@CtaDinero							varchar(10),
@CtaDineroDestino					varchar(10),
@Descuento							varchar(50),
@DescuentoGlobal					varchar(50),
@ListaPreciosEsp					varchar(20),
@ZonaImpuesto						varchar(50),
@FormaPago							varchar(50),
@ArtDescripcion						varchar(100),
@Articulo							varchar(20),
@SubCuenta							varchar(50),
@Cantidad							float,
@CantidadContador					float,
@ToleranciaRedondeo					float,
@ImporteSaldoaFavor					float,
@ValidarDevolucion					bit,
@ArtConsulta						varchar(50),
@SerieLote							varchar(50),
@RenglonUbicado						float,
@Expresion							varchar(255),
@AfectarOtrasSucursalesenLinea		bit,
@UsuarioSucursal					int,
@CantidadOriginal					float,
@AgruparArticulos					bit,
@CodigoExtendido					bit,
@CodigoExtendidoCodigo				varchar(50),
@CodigoExtendidoLetraCodigo			varchar(1),
@CodigoExtendidoLetraPeso			varchar(1),
@CodigoExtendidoDecimalesPeso		int,
@CodigoExtendidoMascara				varchar(50),
@CodigoExtendidoPeso				varchar(50),
@Peso								float,
@BasculaPesar						bit,
@RequiereReferencia					bit,
@TarjetaBandaMagnetica				bit,
@CajaActual							varchar(20),
@CajeroActual						varchar(20),
@Mensaje							varchar(255),
@Caja								varchar(10),
@Host								varchar(20),
@Cluster							varchar(20),
@Servicio							varchar(20),
@FormaServicio						varchar(50),
@CodigoRedondeo						varchar(50),
@ArticuloRedondeo					varchar(20),
@Redondeo							float,
@DefMonedaNacional					varchar(20),
@DefMonedaMov						varchar(20),
@DefCliente							varchar(10),
@RedondeoMonetarios					int,
@SevicioLDI							varchar(20),
@ArtTarjeta							varchar(20),
@CfgVentaMonedero					bit,
@Renglon							float,
@RenglonID							int,
@RenglonTipo						char(1),
@MonederoLDI						varchar(20),
@TipoMonedero						varchar(50),
@ReporteImpresora					varchar(100),
@IDImpresion						varchar(36),
@CajaOmision						bit,
@TorretaMensaje1					varchar(20),
@TorretaMensaje2					varchar(20),
@TorretaPosicion1					varchar(20),
@TorretaPosicion2					varchar(20),
@LDI								bit,
@MonedaFormaPago					varchar(10),
@Abierto							bit,
@RIDCobro							int,
@TarjetaMoneda						varchar(10),
@ImporteTarjeta						float,
@DesgloseCC							bit,
@IDImprimir							varchar(36),
@Expresion2							varchar(255),
@Unidad								varchar(50),
@MovSubClave						varchar(20),
@Orden								int,
@ContMoneda							varchar(10),
@GenerarCFD							bit,
@AfectadoEnLinea					bit,
@CierreiSyncNivel					varchar(20),
@POSMonedaAct						bit,
@TotalPuntos						money,
@CfgVentaMonederoA					bit,
@FormaPagoRegistros					int,
@FormaPagoRegRestante				int
SELECT @POSMonedaAct = POSMonedaAct FROM POSCfg WITH (NOLOCK) WHERE Empresa = @Empresa
DECLARE @LDILog table(
IDModulo                varchar(36),
Modulo                  varchar(5),
Servicio                varchar(50),
Fecha                   varchar(20),
TipoTransaccion         varchar(50),
TipoSubservicio         varchar(50),
CodigoRespuesta         varchar(50),
DescripcionRespuesta    varchar(255),
OrigenRespuesta         varchar(50),
InfoAdicional           varchar(50),
IDTransaccion           varchar(50),
CodigoAutorizacion      varchar(50),
Importe                 float,
Comprobante             varchar(Max),
Cadena                  varchar(Max),
CadenaRespuesta         varchar(Max),
RIDCobro                int
)
DELETE POSLDIIDTemp WHERE Estacion = @@SPID
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa)
SELECT TOP 1 @MonedaSuc = Moneda FROM POSLTipoCambioRef WITH (NOLOCK) WHERE Sucursal = @Sucursal AND TipoCambio = 1
EXEC spPOSHost @Host	OUTPUT, @Cluster OUTPUT
SELECT @RecalcularTodo = 1
SELECT
@AgruparArticulos				= ISNULL(pc.AgruparArticulos,0),
@CantidadNotasEnProceso			= ISNULL(pc.CantidadNotasEnProceso,0),
@CodigoExtendido				= ISNULL(pc.CodigoExtendido,0),
@CodigoExtendidoLetraCodigo		= pc.CodigoExtendidoLetraCodigo,
@CodigoExtendidoLetraPeso		= pc.CodigoExtendidoLetraPeso,
@CodigoExtendidoDecimalesPeso	= pc.CodigoExtendidoDecimalesPeso,
@CodigoExtendidoMascara			= pc.CodigoExtendidoMascara,
@CodigoRedondeo					= pc.RedondeoVentaCodigo,
@TipoMonedero					= pc.TipoMonedero,
@CajaOmision					= ISNULL(pc.CajaOmision,1),
@LDI							= ISNULL(MonederoLDI,0),
@DesgloseCC						= ISNULL(DesgloseCC,0),
@CierreiSyncNivel				= ISNULL(CierreiSyncNivel,'Sucursal'),
@ToleranciaRedondeo				= ISNULL(POSToleranciaVta,0.99)
FROM POSCfg pc WITH (NOLOCK)
WHERE pc.Empresa = @Empresa
SELECT @ArticuloRedondeo = cb.Cuenta
FROM CB WITH (NOLOCK)
WHERE CB.Cuenta = @CodigoRedondeo
AND CB.TipoCuenta = 'Articulos'
SELECT @Importe= CONVERT(decimal(20,6),@Importe), @ImporteRef= CONVERT(decimal(20,6),@ImporteRef)
SELECT @Importe = ROUND(@Importe,@RedondeoMonetarios)
SELECT @ImporteRef = ROUND(@ImporteRef,@RedondeoMonetarios)
SELECT
@UsuarioSucursal = u.Sucursal,
@AfectarOtrasSucursalesenLinea = u.AfectarOtrasSucursalesenLinea,
@Caja = u.DefCtaDinero,
@DefCliente= u.DefCliente
FROM Usuario u WITH (NOLOCK)
WHERE u.Usuario = @Usuario
IF NULLIF(@Caja,'') IS NULL AND @Ok IS NULL AND @CajaOmision = 1
SELECT @ok = 10510, @OkRef = 'Es necesario indicar la caja en la configuración del usuario'
IF NULLIF(@Caja,'') IS NULL AND @Ok IS NULL AND @CajaOmision = 0
SELECT @CodigoAccion = 'ASIGNAR CAJA'
IF NULLIF(@DefCliente,'') IS NULL AND @Ok IS NULL
SELECT @ok = 10575, @OkRef = 'Es necesario indicar el Cliente  en la configuración del usuario'
IF (SELECT Sucursal FROM CtaDinero WITH (NOLOCK) WHERE CtaDinero = @Caja)<> @Sucursal
SELECT @Ok = 30468  ,@OkRef = ' ('+CONVERT(varchar,@Sucursal)+')'
IF @CierreiSyncNivel = 'Sucursal'
BEGIN
IF (SELECT ISNULL(NULLIF(HOST,''),@HOST) FROM Sucursal  WITH (NOLOCK) WHERE Sucursal = @Sucursal)<> @HOST
SELECT @Ok = 30466  ,@OkRef = ' ('+@HOST+')'
END
IF @CierreiSyncNivel = 'Caja' AND @CodigoAccion NOT IN('ASIGNAR CAJA', NULL)
BEGIN
IF (SELECT ISNULL(NULLIF(HOST,''),@HOST) FROM Ctadinero WITH (NOLOCK) WHERE CtaDinero = @Caja)<> @HOST
SELECT @Ok = 304667  ,@OkRef = ' ('+@HOST+')'
END
SELECT /*@ToleranciaRedondeo = ec.CxcAutoAjusteMov,*/ @ArtTarjeta = ec.CxcArticuloTarjetasDef , @ContMoneda = ContMoneda
FROM EmpresaCfg ec WITH (NOLOCK)
WHERE ec.Empresa = @Empresa
SELECT @CfgVentaMonedero = ISNULL(VentaMonedero, 0),
@CfgVentaMonederoA =  ISNULL(VentaMonederoA,0)
FROM EmpresaCfg2 WITH (NOLOCK)
WHERE Empresa = @Empresa
IF EXISTS(SELECT * FROM POSL p WITH (NOLOCK) JOIN MovTipo m WITH (NOLOCK) ON m.Mov = p.Mov AND m.Modulo = 'POS'
WHERE m.Clave = 'POS.NPC' AND p.Estatus = 'PORCOBRAR' AND p.ID IN (SELECT ID FROM POSLPorCobrar WITH (NOLOCK) WHERE Estatus = 'TRASPASADO'))
UPDATE POSL SET Estatus = 'TRASPASADO'
FROM POSL p WITH (ROWLOCK) JOIN MovTipo m WITH (NOLOCK) ON m.Mov = p.Mov AND m.Modulo = 'POS'
WHERE m.Clave = 'POS.NPC' AND p.Estatus = 'PORCOBRAR' AND p.ID IN (SELECT ID FROM POSLPorCobrar WITH (NOLOCK) WHERE Estatus = 'TRASPASADO')
SELECT @MovClave = Clave, @MovSubClave = SubClave
FROM MovTipo mt WITH (NOLOCK)
INNER JOIN POSL pl WITH (NOLOCK) ON mt.Mov = pl.Mov AND pl.ID = @ID
WHERE mt.Modulo = 'POS'
IF @CodigoCambio IS NOT NULL
AND @MovClave IN ('POS.F', 'POS.N', 'POS.A','POS.NPC')
AND (SELECT ISNULL(fp.PermiteCambio,1) FROM CB WITH (NOLOCK) INNER JOIN FormaPago fp WITH (NOLOCK) ON CB.FormaPago = fp.FormaPago WHERE Codigo = @CodigoCambio)= 0
SELECT @Ok = 30590
IF @Cliente IS NOT NULL AND @Ok IS NULL
BEGIN
EXEC spPOSInsertaCliente2 @Empresa, @ID, @Codigo, @CtaDinero, @Cliente, @Estacion, @Imagen OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
SELECT @Codigo = NULL
END
IF @MovClave IN ('POS.F','POS.N','POS.P','POS.NPC','POS.INVD', 'POS.INVA')AND EXISTS(SELECT * FROM CB WITH (NOLOCK) WHERE Codigo = @Codigo AND TipoCuenta = 'Articulos')
BEGIN
IF NOT EXISTS(SELECT * FROM POSEstatusCaja WITH (NOLOCK) WHERE Caja = @Caja)
SELECT @Ok = 30440, @OkRef = @Caja
IF (SELECT Abierto FROM POSEstatusCaja WITH (NOLOCK) WHERE Caja = @Caja) = 0
SELECT @Ok =30440, @OkRef = @Caja
END
SELECT @Accion = MAX(pa.Accion)
FROM POSLAccion pa WITH (NOLOCK)
WHERE pa.Host = @Host
AND Caja = @Caja
IF @Accion IS NOT NULL
BEGIN
IF @Accion = 'ASIGNAR CAJA'
SELECT @CajaActual = @Codigo
EXEC spPOSAccionEjecutar @Estacion, @Empresa, @Sucursal, @Modulo, @Usuario, @Caja, @ID OUTPUT, @Codigo OUTPUT, @Accion OUTPUT,
@CodigoAccion OUTPUT, @Referencia OUTPUT, @Importe OUTPUT, @MovClave OUTPUT, @CtaDinero OUTPUT, @Mensaje OUTPUT,
@Cajero OUTPUT, @SerieLote OUTPUT, @Articulo OUTPUT, @SubCuenta OUTPUT, @Cantidad OUTPUT, @CantidadOriginal OUTPUT,
@RenglonUbicado OUTPUT, @ArtConsulta OUTPUT, @AgruparArticulos,
@Mov OUTPUT, @FechaEmision OUTPUT, @Concepto OUTPUT, @Agente OUTPUT, @UEN OUTPUT, @Moneda OUTPUT, @TipoCambio OUTPUT,
@Proyecto OUTPUT, @Cliente OUTPUT, @Condicion OUTPUT, @Almacen OUTPUT, @FormaEnvio OUTPUT, @Vencimiento OUTPUT,
@ListaPreciosEsp OUTPUT, @Descuento OUTPUT, @ArtDescripcion OUTPUT, @DescuentoGlobal OUTPUT, @Imagen OUTPUT, @ZonaImpuesto OUTPUT,
@ImporteSaldoaFavor OUTPUT, @Ok = @OK OUTPUT, @OkRef = @OkRef OUTPUT, @Expresion = @Expresion OUTPUT,
@TorretaMensaje1= @TorretaMensaje1 OUTPUT, @TorretaMensaje2 =@TorretaMensaje2  OUTPUT, @TorretaPosicion1= @TorretaPosicion1   OUTPUT,
@TorretaPosicion2 = @TorretaPosicion2  OUTPUT, @MovSubClave = @MovSubClave OUTPUT
END
IF @CodigoExtendido = 1 AND NOT EXISTS(SELECT * FROM CB WITH (NOLOCK) WHERE Codigo = @Codigo) AND @Accion IS NULL AND @Codigo IS NOT NULL
AND NOT EXISTS(SELECT 1 FROM Art WITH (NOLOCK) WHERE Articulo = @Codigo)
AND @MovClave NOT IN ('POS.FA','POS.INVD', 'POS.INVA','POS.CXCC','POS.CXCD' ) AND @Ok IS NULL
BEGIN
SELECT @CodigoExtendidoCodigo = @Codigo
EXEC spPOSSeparadorCodigoExtendido @CodigoExtendidoLetraCodigo, @CodigoExtendidoMascara, @CodigoExtendidoCodigo, 0, @Codigo OUTPUT
IF NOT EXISTS(SELECT * FROM CB WITH (NOLOCK) WHERE Codigo = @Codigo AND TipoCuenta = 'Articulos')
BEGIN
SELECT @Ok = 72040, @OkRef = @Codigo
END
ELSE
SELECT
@Articulo = cb.Cuenta,
@Subcuenta = cb.SubCuenta,
@BasculaPesar = a.BasculaPesar
FROM CB WITH (NOLOCK)
INNER JOIN Art a WITH (NOLOCK) ON cb.Cuenta = a.Articulo
WHERE cb.Codigo = @Codigo
EXEC spPOSSeparadorCodigoExtendido @CodigoExtendidoLetraPeso, @CodigoExtendidoMascara, @CodigoExtendidoCodigo,
@CodigoExtendidoDecimalesPeso, @CodigoExtendidoPeso OUTPUT
IF @Ok IS NULL
IF (SELECT dbo.fnEsNumerico(@CodigoExtendidoPeso)) = 0
BEGIN
SELECT @Ok = 20010, @OkRef = @CodigoExtendidoCodigo
END
ELSE
SELECT @Peso = CONVERT(float,@CodigoExtendidoPeso)
IF ISNULL(@BasculaPesar,0) = 0 AND @Ok IS NULL
SELECT @Ok = 73040, @OkRef = 'El Articulo no esta configurado para pesarse'
SELECT
@Mov = p.Mov,
@FechaEmision = p.FechaEmision,
@Concepto = p.Concepto,
@UEN  = p.UEN,
@Proyecto = p.Proyecto,
@Moneda = ISNULL(p.Moneda,@MonedaSuc),
@TipoCambio = p.TipoCambio,
@Cliente = p.Cliente,
@Almacen = p.Almacen,
@Agente = p.Agente,
@Cajero = p.Cajero,
@FormaEnvio = p.FormaEnvio,
@Condicion = p.Condicion,
@Vencimiento = p.Vencimiento,
@CtaDinero = p.CtaDinero,
@CtaDineroDestino = p.CtaDineroDestino,
@Descuento = p.Descuento,
@DescuentoGlobal = p.DescuentoGlobal,
@ListaPreciosEsp = p.ListaPreciosEsp,
@ZonaImpuesto = p.ZonaImpuesto,
@Sucursal = p.Sucursal,
@MonederoLDI = p.Monedero
FROM POSL p WITH (NOLOCK)
WHERE ID = @ID
IF @Ok IS NULL
BEGIN
EXEC spPOSVentaInsertaArticulo @Modulo, @Usuario, @Codigo, @CodigoAccion, @ID, @FechaEmision, @Agente, @Moneda, @TipoCambio, @Condicion,
@Almacen, @Proyecto, @FormaEnvio, @Mov, @Empresa, @Sucursal, @ListaPreciosEsp, @Cliente, @CtaDinero, @Accion, @Estacion,
@Mensaje OUTPUT, @ArtDescripcion OUTPUT, @Imagen OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @Expresion OUTPUT, @Cantidad = @Peso,
@Juego = 0,@TorretaMensaje1= @TorretaMensaje1 OUTPUT, @TorretaMensaje2 =@TorretaMensaje2  OUTPUT,
@TorretaPosicion1= @TorretaPosicion1   OUTPUT,  @TorretaPosicion2 = @TorretaPosicion2  OUTPUT
END
SELECT @Codigo = NULL
END
IF @CodigoAccion = 'REVERSAR MOV' AND @Ok IS NULL AND @ID IS NOT NULL AND @Codigo IS NOT NULL
BEGIN
EXEC spPOSReversarMovDinero @Empresa, @Sucursal, @Usuario, @ID, @MovClave, @Codigo, @Ok OUTPUT, @OkRef  OUTPUT
DELETE POSLAccion
WHERE Host = @Host
AND Accion = @CodigoAccion
AND Caja = @Caja
END
SELECT @TipoCuenta = c.TipoCuenta
FROM CB c WITH (NOLOCK)
WHERE c.Codigo = @Codigo
IF ISNULL(@TipoCuenta,'') = 'Forma Pago' AND @Ok IS NULL
BEGIN
IF (SELECT ISNULL(ISNULL(NULLIF(CASE WHEN @POSMonedaAct = 0 THEN fp.Moneda ELSE fp.POSMoneda END,''), @Moneda),@MonedaSuc)
FROM CB cb WITH (NOLOCK) INNER JOIN FormaPago fp WITH (NOLOCK) ON cb.FormaPago = fp.FormaPago
WHERE cb.Codigo = @Codigo AND cb.TipoCuenta = 'Forma Pago') NOT IN (SELECT Moneda FROM POSLTipoCambioRef WITH (NOLOCK) WHERE  Sucursal = @Sucursal)
SELECT @ok = 30600, @okRef = (SELECT cb.FormaPago FROM CB cb WITH (NOLOCK) WHERE cb.Codigo = @Codigo AND cb.TipoCuenta = 'Forma Pago')
END
IF @Cobro = 1 AND ISNULL(@TipoCuenta,'') <> 'Forma Pago'
SELECT @Ok = 30530, @OkRef = @Codigo
EXEC spPOSEstatusCajaVerificar @ID, @Caja, @Cajero,'Bloqueado' , @Abierto OUTPUT
IF @Abierto = 1
SELECT @Ok = 30441, @okRef = @Caja
IF @Accion IS NULL
BEGIN
IF @TipoCuenta = 'Expresion'
SELECT @Expresion = Expresion
FROM CB WITH (NOLOCK)
WHERE Codigo = @Codigo
IF @TipoCuenta = 'Accion' AND @Ok IN(NULL,30441)
BEGIN
SELECT @CodigoAccion = Accion
FROM CB WITH (NOLOCK)
WHERE Codigo = @Codigo
IF @CodigoAccion = 'DESBLOQUEAR CAJA' SET @Ok = NULL
INSERT POSLAccion (
Host, Caja,  Accion)
VALUES (
@Host, @Caja, @CodigoAccion)
END
IF @CodigoAccion IS NOT NULL AND @Ok IS NULL
BEGIN
EXEC spPOSAccionDisparar @Empresa, @Sucursal, @Modulo, @Usuario, @Caja, @Estacion, @ID OUTPUT, @Codigo OUTPUT, @CodigoAccion OUTPUT,
@Accion OUTPUT, @FormaPago OUTPUT, @Importe OUTPUT, @CantidadNotasEnProceso, @Imagen OUTPUT, @Mensaje  OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT,@Expresion = @Expresion OUTPUT
END
END
IF ISNULL(@CodigoAccion,'') <> 'MOVIMIENTO NUEVO' AND (@ID IS NULL OR NOT EXISTS(SELECT * FROM POSL p WITH (NOLOCK) WHERE ID = @ID))
BEGIN
SELECT TOP 1 @DefMonedaNacional = Moneda
FROM POSLTipoCambioRef m WITH (NOLOCK)
WHERE TipoCambio = 1 AND Sucursal = @Sucursal  AND EsPrincipal = 1
SELECT @DefMonedaMov = DefMoneda
FROM Usuario WITH (NOLOCK)
WHERE Usuario = @Usuario
IF @DefMonedaMov <> @DefMonedaNacional
SELECT @ok = 30040, @OkRef = 'Falta configurar la moneda Correcta en el usuario'
IF NOT EXISTS(SELECT * FROM   POSLTipoCambioRef WITH (NOLOCK) WHERE Sucursal = @Sucursal  AND Moneda = @ContMoneda) OR NULLIF(@ContMoneda,'') IS NULL
SELECT @ok = 30040, @OkRef = 'Falta configurar el tipo de cambio de la moneda contable de la empresa '
IF @Ok IS NULL
EXEC spPOSMovNuevo @Empresa, @Modulo, @Sucursal, @Usuario, @Estacion, @ID OUTPUT, @Imagen OUTPUT
END
SELECT
@Mov = p.Mov,
@FechaEmision = p.FechaEmision,
@Concepto = p.Concepto,
@UEN  = p.UEN,
@Proyecto = p.Proyecto,
@Moneda = p.Moneda,
@TipoCambio = p.TipoCambio,
@Cliente = p.Cliente,
@Almacen = p.Almacen,
@Agente = p.Agente,
@Cajero = p.Cajero,
@FormaEnvio = p.FormaEnvio,
@Condicion = p.Condicion,
@Vencimiento = p.Vencimiento,
@CtaDinero = p.CtaDinero,
@CtaDineroDestino = p.CtaDineroDestino,
@Descuento = p.Descuento,
@DescuentoGlobal = p.DescuentoGlobal,
@ListaPreciosEsp = p.ListaPreciosEsp,
@ZonaImpuesto = p.ZonaImpuesto,
@Sucursal = p.Sucursal,
@MonederoLDI = p.Monedero
FROM POSL p WITH (NOLOCK)
WHERE ID = @ID
IF EXISTS(SELECT 1 FROM Art WITH (NOLOCK) WHERE Articulo = @Codigo) AND @TipoCuenta IS NULL
BEGIN
SELECT @Articulo = @Codigo
SELECT
@Codigo = cb.Codigo,
@TipoCuenta = cb.TipoCuenta
FROM CB cb WITH (NOLOCK)
WHERE cb.Cuenta = @Articulo
AND cb.TipoCuenta = 'Articulos'
END
IF @TipoCuenta IS NULL AND @Codigo IS NOT NULL AND @CodigoAccion NOT IN('REVERSAR MOV')
AND @MovClave NOT IN ('POS.FA','POS.INVD', 'POS.INVA','POS.CXCC','POS.CXCD' )
AND @Accion NOT IN ('MODIFICAR COMPONENTE', 'INTRODUCIR CONCEPTOCXC', 'ALMACEN DESTINO')
BEGIN
IF @TipoCuenta IS NULL AND @Codigo IS NOT NULL 
SELECT @RecalcularTodo = 1, @Ok = 72040, @OkRef = @Codigo
END
ELSE
BEGIN
IF @TipoCuenta = 'Clientes' AND @Ok IS NULL
BEGIN
EXEC spPOSInsertaCliente @Empresa, @ID, @Codigo, @CtaDinero, NULL, @Estacion, @Imagen OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @TipoCuenta = 'Articulos' AND @Accion NOT IN ('MATRIZ OPCIONES')
BEGIN
EXEC spPOSVentaInsertaArticulo @Modulo, @Usuario, @Codigo, @CodigoAccion, @ID, @FechaEmision, @Agente, @Moneda, @TipoCambio, @Condicion,
@Almacen, @Proyecto, @FormaEnvio, @Mov, @Empresa, @Sucursal, @ListaPreciosEsp, @Cliente, @CtaDinero, @Accion, @Estacion,
@Mensaje OUTPUT, @ArtDescripcion OUTPUT, @Imagen OUTPUT, @Ok OUTPUT, @OkRef OUTPUT,@Expresion OUTPUT,
@TorretaMensaje1= @TorretaMensaje1 OUTPUT, @TorretaMensaje2 =@TorretaMensaje2  OUTPUT, @TorretaPosicion1= @TorretaPosicion1   OUTPUT,
@TorretaPosicion2 = @TorretaPosicion2  OUTPUT
END
END
SELECT @ImporteMov = SUM(dbo.fnPOSImporteMov(((plv.Cantidad  - ISNULL(plv.CantidadObsequio,0.0)) * ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) - ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) * (CASE WHEN ISNULL(plv.AplicaDescGlobal, 1) = 1 THEN ISNULL(p.DescuentoGlobal,0.0) ELSE 0 END)/100))),plv.Impuesto1,plv.Impuesto2,plv.Impuesto3,plv.Cantidad))
FROM POSLVenta plv WITH (NOLOCK)
INNER JOIN POSL p WITH (NOLOCK) ON p.ID = plv.ID
WHERE plv.ID = @ID
AND plv.Articulo <> @ArticuloRedondeo
SELECT @ImporteMov = ROUND(@ImporteMov,@RedondeoMonetarios)
SELECT @Redondeo = plv.Precio
FROM POSLVenta plv WITH (NOLOCK)
WHERE plv.ID = @ID
AND plv.Articulo = @ArticuloRedondeo
SELECT @ImporteCobrado = ROUND(SUM(Importe),@RedondeoMonetarios)
FROM POSLCobro WITH (NOLOCK)
WHERE ID = @ID
AND ISNULL(NULLIF(Referencia,''),'') <> 'COMISION CREDITO'
SELECT @Saldo = (ISNULL(@ImporteMov,0) + ISNULL(@Redondeo,0)) - ISNULL(@ImporteCobrado,0)
IF @Saldo < 0 AND @MovClave NOT IN ('POS.N','POS.NPC','POS.CXCD')
SELECT @Saldo = 0
IF @TipoCuenta = 'Forma Pago' AND @ID IS NOT NULL
AND ((@MovClave IN ('POS.A', 'POS.F', 'POS.N','POS.P','POS.NPC','POS.INVD', 'POS.INVA')
AND @Importe IS NOT NULL) OR (@MovClave NOT IN ('POS.A', 'POS.F', 'POS.N','POS.P','POS.INVD', 'POS.INVA')))
BEGIN
IF @MovClave IN ('POS.A', 'POS.F', 'POS.N','POS.NPC') AND ISNULL(@Cobro,0) = 0
SELECT @ok = 35050, @Ok = 'Debe realizar el movimiento desde la acción Concluir Movimiento'
IF @Importe IS NOT NULL AND @Ok IS NULL
EXEC spPOSMovCobrar @Empresa, @Sucursal, @Usuario, @ID, @Codigo, @Referencia, @CtaDinero, @ToleranciaRedondeo, @MovClave,
@Monedero, @ImporteRef, @CodigoAccion OUTPUT, @Importe OUTPUT, @Saldo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT,NULL,@RIDCobro OUTPUT
SELECT
@RequiereReferencia = RequiereReferencia,
@TarjetaBandaMagnetica = TarjetaBandaMagnetica
FROM CB cb WITH (NOLOCK)
INNER JOIN FormaPago fp WITH (NOLOCK) ON cb.FormaPago = fp.FormaPago
WHERE cb.Codigo = @Codigo
IF @MovClave IN ('POS.AC','POS.AP','POS.ACM','POS.IC','POS.EC') AND @TarjetaBandaMagnetica = 1
SELECT @Ok = 30600, @OkRef = @Codigo
IF @MovClave IN ('POS.AC','POS.AP', 'POS.CC', 'POS.CPC','POS.ACM','POS.CCM','POS.CPCM','POS.TCM','POS.TCAC','POS.IC','POS.EC','POS.TRM')
SELECT @RequiereReferencia = 0
IF @RequiereReferencia = 1 AND NULLIF(RTRIM(LTRIM(@Referencia)),'') IS NULL AND @Ok IS NULL
BEGIN
INSERT POSLAccion (Host, Caja, Accion, FormaPago) VALUES (@Host, @Caja, 'REFERENCIA FORMA PAGO', @Codigo)
SELECT @Mensaje = 'POR FAVOR INTRODUZCA LA REFERENCIA'
END
IF @Importe IS NULL AND ((@RequiereReferencia = 1 AND NULLIF(RTRIM(LTRIM(@Referencia)),'') IS NOT NULL)
OR (ISNULL(@RequiereReferencia, 0) = 0)) AND @Ok IS NULL AND @TipoCuenta = 'Forma Pago'
BEGIN
INSERT POSLAccion (Host, Caja, Accion, FormaPago, Referencia) VALUES (@Host, @Caja, 'MONTO FORMA PAGO', @Codigo, @Referencia)
SELECT @Mensaje = 'POR FAVOR INTRODUZCA EL MONTO EN '+UPPER(@Codigo)
SELECT @FormaPago = FormaPago
FROM CB WITH (NOLOCK)
WHERE Codigo = @Codigo
IF @Ok IS NULL AND @MovClave IN('POS.CC','POS.CPCM', 'POS.CPC','POS.CCM')
AND EXISTS(SELECT * FROM FormaPago WITH (NOLOCK) WHERE  FormaPago = @FormaPago AND POSDenominacion = 1)
BEGIN
IF NOT EXISTS(SELECT * FROM FormaPagoD WITH (NOLOCK) WHERE  FormaPago = @FormaPago)
SELECT @Ok = 30085, @OkRef = @OkRef +ISNULL(@FormaPago,'')
IF @Ok IS NULL
BEGIN
DELETE POSLDenominacionTemp WHERE Estacion = @Estacion
INSERT POSLDenominacionTemp(
ID, Estacion,   FormaPago, Denominacion,Nombre, Cantidad)
SELECT
@ID, @Estacion,  @FormaPago,Denominacion,Nombre,0
FROM FormaPagoD WITH (NOLOCK)
WHERE FormaPago = @FormaPago
IF @Ok IS NULL
SELECT @Expresion = 'Asigna(Info.FormaPago,'+CHAR(39)+@MonedaFormaPago+CHAR(39)+') FormaModal('+
CHAR(39)+'POSLDenominacionTemp'+CHAR(39)+')'
END
END
END
IF ISNULL(@ImporteCambio,0) > 0
BEGIN
SELECT @ImporteCambio = ROUND(@ImporteCambio * (-1),@RedondeoMonetarios)
EXEC spPOSMovCobrar @Empresa, @Sucursal, @Usuario, @ID, @CodigoCambio, @Referencia, @CtaDinero, @ToleranciaRedondeo, @MovClave,
@Monedero, @ImporteCambio, @CodigoAccion OUTPUT, @ImporteCambio OUTPUT, @Saldo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT,
@Cambio = 1, @RIDCobro = @RIDCobro  OUTPUT
END
SELECT @ImporteMov = SUM(dbo.fnPOSImporteMov(((plv.Cantidad  - ISNULL(plv.CantidadObsequio,0.0)) * ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) - ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) * (CASE WHEN ISNULL(plv.AplicaDescGlobal, 1) = 1 THEN ISNULL(p.DescuentoGlobal,0.0) ELSE 0 END)/100))),plv.Impuesto1,plv.Impuesto2,plv.Impuesto3,plv.Cantidad))
FROM POSLVenta plv WITH (NOLOCK)
INNER JOIN POSL p WITH (NOLOCK) ON p.ID = plv.ID
WHERE plv.ID = @ID
AND plv.Articulo <> @ArticuloRedondeo
SELECT @ImporteMov = ROUND(@ImporteMov,@RedondeoMonetarios)
SELECT @Redondeo = plv.Precio
FROM POSLVenta plv WITH (NOLOCK)
WHERE plv.ID = @ID
AND plv.Articulo = @ArticuloRedondeo
SELECT @ImporteCobrado = ROUND(SUM(Importe),@RedondeoMonetarios)
FROM POSLCobro WITH (NOLOCK)
WHERE ID = @ID
AND ISNULL(NULLIF(Referencia,''),'') <> 'COMISION CREDITO'
SELECT @Saldo = (ISNULL(@ImporteMov,0.0) +ISNULL(@Redondeo,0.0)) - ISNULL(@ImporteCobrado,0.0)
SELECT @Saldo = ROUND(@Saldo,@RedondeoMonetarios)
IF @Saldo < 0 AND @MovClave NOT IN ('POS.N','POS.NPC')
SELECT @Saldo = 0
IF @MovClave IN ('POS.N', 'POS.F', 'POS.A','POS.P','POS.NPC','POS.FA','POS.INVD', 'POS.INVA','POS.CXCC','POS.CXCD' ) AND @Ok IS NULL
BEGIN
IF ISNULL(@Saldo,0.0) BETWEEN (@ToleranciaRedondeo * (-1)) AND (@ToleranciaRedondeo)
SELECT @Saldo = 0.0, @CodigoAccion = 'CONCLUIR MOVIMIENTO'
END
IF ISNULL(@Saldo,0.0) > 0.0 AND @CodigoAccion <> 'CONCLUIR MOVIMIENTO' AND @MovClave IN ('POS.N', 'POS.F')
AND @Mov <> (SELECT POSDefMovDev FROM POSCfg WITH (NOLOCK) WHERE Empresa = @Empresa) AND @Ok IS NULL
BEGIN
SET @FormaPagoRegRestante = 5
SELECT @FormaPagoRegistros = COUNT(DISTINCT FormaPago) FROM POSLCobro WITH (NOLOCK) WHERE ID = @ID
SET @FormaPagoRegRestante = @FormaPagoRegRestante -  ISNULL(@FormaPagoRegistros,0)
SELECT @Mensaje = ISNULL(@Mensaje,'') + '   ' + 'PUEDES INGRESAR HASTA ' + CONVERT(varchar,@FormaPagoRegRestante) + ' DIFERENTES FORMAS DE PAGO MAS'
END
END
IF @Sucursal <> @UsuarioSucursal AND ISNULL(@AfectarOtrasSucursalesenLinea,0) = 0
SELECT @Ok = 3, @OkRef = 'El Usuario no pertenece a esta Sucursal'
IF @Ok IS NULL AND @MovClave IN ('POS.N','POS.F','POS.NPC') AND (@CfgVentaMonedero = 1  OR @CfgVentaMonederoA = 1)
AND @CodigoAccion = 'CONCLUIR MOVIMIENTO' AND NOT EXISTS ( SELECT * FROM  POSValeSerie WITH (NOLOCK) WHERE Serie = @MonederoLDI  )
AND NULLIF(@MonederoLDI,'') IS NOT NULL
INSERT POSValeSerie (Serie, Sucursal, Estatus, Moneda, Tipo, Cliente)
SELECT               @MonederoLDI, @Sucursal, 'DISPONIBLE', @MonedaSuc, @TipoMonedero, @Cliente
IF @Ok IS NULL AND  EXISTS (SELECT * FROM POSValeSerie WITH (NOLOCK) WHERE Serie = @MonederoLDI AND Cliente IS NULL)
UPDATE POSValeSerie WITH (ROWLOCK) SET Cliente = @Cliente WHERE Serie = @MonederoLDI
IF @Ok IS NULL AND @MovClave IN ('POS.N','POS.F','POS.NPC') AND @CfgVentaMonedero = 1  AND @CodigoAccion = 'CONCLUIR MOVIMIENTO'
AND EXISTS (SELECT * FROM  POSValeSerie WITH (NOLOCK) WHERE Serie = @MonederoLDI AND Estatus  IN ('DISPONIBLE','CIRCULACION')) AND @CfgVentaMonederoA = 0
BEGIN
IF (SELECT Estatus FROM POSValeSerie WITH (NOLOCK) WHERE Serie = @MonederoLDI)='DISPONIBLE'
BEGIN
SELECT @Unidad = Unidad FROM Art WITH (NOLOCK) WHERE Articulo =  @ArtTarjeta
SELECT @Renglon = MAX(Renglon)+ 2048.0, @RenglonID = MAX(RenglonID)+1
FROM POSLVenta WITH (NOLOCK) WHERE ID = @ID
SELECT  @RenglonTipo = dbo.fnRenglonTipo('SERIE')
INSERT POSLVenta(
ID, Renglon, RenglonID, RenglonTipo, Cantidad, Articulo, Precio, CantidadInventario, Unidad, EsMonedero)
SELECT
@ID, @Renglon, @RenglonID, @RenglonTipo, 1, @ArtTarjeta, 0.0, 1, @Unidad, 1
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL
INSERT POSLSerieLote (
ID,  RenglonID, Articulo, SubCuenta, SerieLote)
VALUES (
@ID, @RenglonID, @ArtTarjeta, '', @MonederoLDI)
UPDATE POSValeSerie WITH (ROWLOCK) SET  Estatus = 'CIRCULACION' WHERE Serie = @MonederoLDI
SELECT @RecalcularTodo = 1
END
EXEC spPOSVentaMonedero @Empresa, @ID, 'AFECTAR', @FechaEmision, @Usuario, @Sucursal, @MonedaSuc, @TipoCambio, @MonederoLDI, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL AND @MovClave IN ('POS.N','POS.F','POS.NPC') AND @CodigoAccion = 'CONCLUIR MOVIMIENTO'
AND EXISTS (SELECT * FROM  POSValeSerie WITH (NOLOCK) WHERE Serie = @MonederoLDI AND Estatus  IN ('DISPONIBLE','CIRCULACION')) AND @CfgVentaMonederoA = 0
DELETE FROM  POSValeSerie WHERE Serie = @MonederoLDI
IF @CodigoAccion = 'CONCLUIR MOVIMIENTO' AND @Ok IS NULL AND @ID IS NOT NULL AND @MovClave = 'POS.P' AND @MovSubClave NOT IN ('POS.FACCRED')
BEGIN
IF (SELECT ValidaFormaEnvio FROM POSCfg WITH (NOLOCK) WHERE Empresa = @Empresa) = 1
BEGIN
IF (SELECT NULLIF(FormaEnvio,'') FROM POSL WITH (NOLOCK) WHERE ID = @ID) IS NULL
SELECT @ok = 20703, @OkRef = 'Ejecute Accion '+ (SELECT Codigo FROM CB WITH (NOLOCK) WHERE TipoCuenta = 'Accion' AND Accion = 'FORMA ENVIO')
END
END
IF @MovClave = 'POS.N' AND @MovSubClave = 'POS.PEDCONT'
BEGIN
IF (SELECT Condicion FROM POSL WITH (NOLOCK) WHERE ID = @ID) NOT IN (SELECT Condicion FROM Condicion WITH (NOLOCK) WHERE ControlAnticipos = 'Cobrar Pedido')
SELECT @ok = 20705, @OkRef = 'Ejecute Accion '+ (SELECT Codigo FROM CB WITH (NOLOCK) WHERE TipoCuenta = 'Accion' AND Accion = 'MODIFICAR CONDICION')
END
IF @CodigoAccion = 'CONCLUIR MOVIMIENTO' AND @Ok IS NULL AND @ID IS NOT NULL AND @MovClave = 'POS.N' AND @MovSubClave = 'POS.PEDCONT'
BEGIN
IF (SELECT ValidaFormaEnvio FROM POSCfg WITH (NOLOCK) WHERE Empresa = @Empresa) = 1
BEGIN
IF (SELECT NULLIF(FormaEnvio,'') FROM POSL WITH (NOLOCK) WHERE ID = @ID) IS NULL
SELECT @ok = 20703, @OkRef = 'Ejecute Accion '+ (SELECT Codigo FROM CB WITH (NOLOCK) WHERE TipoCuenta = 'Accion' AND Accion = 'FORMA ENVIO')
END
END
IF @CodigoAccion = 'CONCLUIR MOVIMIENTO' AND @Ok IS NULL AND @ID IS NOT NULL
AND @MovClave IN ('POS.CC', 'POS.CPC', 'POS.AC','POS.AP','POS.ACM','POS.CCM','POS.CPCM','POS.CAC','POS.CACM','POS.CCC','POS.CCCM')
BEGIN
IF (SELECT RequiereConceptoDIN FROM POSCfg WITH (NOLOCK) WHERE Empresa = @Empresa) = 1
BEGIN
IF (SELECT NULLIF(Concepto,'') FROM POSL WITH (NOLOCK) WHERE ID = @ID) IS NULL
SELECT @ok = 20704, @OkRef = 'Ejecute Accion '+ (SELECT Codigo FROM CB WITH (NOLOCK) WHERE TipoCuenta = 'Accion' AND Accion = 'INTRODUCIR CONCEPTODIN')
END
END
IF @CodigoAccion = 'CONCLUIR MOVIMIENTO' AND @Ok IS NULL AND @ID IS NOT NULL AND @MovClave NOT IN ('POS.NPC')
BEGIN
EXEC spPOSConcluir @Empresa, @Modulo, @Sucursal, @Usuario, @Saldo, @Estacion,
@ID OUTPUT, @Mensaje OUTPUT, @Imagen OUTPUT, @Expresion OUTPUT, @Expresion2 OUTPUT, @Ok OUTPUT, @OkRef  OUTPUT,
@IDImpresion OUTPUT, @GenerarCFD  OUTPUT, @AfectadoEnLinea OUTPUT
DELETE FROM POSLAccion WHERE Host = @Host AND Accion = @CodigoAccion AND Caja = @Caja
IF @Ok IS NULL AND @Expresion IS NULL
BEGIN
IF EXISTS(SELECT * FROM POSReporteTicket WITH (NOLOCK) WHERE Estacion = @Estacion)
DELETE POSReporteTicket WHERE Estacion = @Estacion
IF @MovClave = 'POS.P' AND @MovSubClave = 'POS.PEDANT' AND @OK IS NULL
BEGIN
IF EXISTS(SELECT * FROM POSLAccion WITH (NOLOCK) WHERE Host = @Host AND Caja = @Caja AND Accion = @CodigoAccion)
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
DELETE POSConceptoCXCTemp WHERE Estacion = @Estacion
INSERT POSConceptoCXCTemp(
Estacion, Concepto)
SELECT
@Estacion, Concepto
FROM Concepto WITH (NOLOCK)
WHERE Modulo = 'CXC'
SELECT @Orden = 0
UPDATE POSConceptoCXCTemp WITH (ROWLOCK)
SET @Orden = Orden = @Orden + 1
FROM POSConceptoCXCTempS WITH (NOLOCK)
WHERE  Estacion = @Estacion
SELECT @CodigoAccion = 'INTRODUCIR CONCEPTOCXC'
SELECT @Mensaje = @Mensaje +'<BR>POR FAVOR INTRODUZCA EL NUMERO DEL CONCEPTO'
INSERT POSLAccion (
Host,  Caja, Accion)
VALUES (
@Host, @Caja,@CodigoAccion)
END
EXEC xpPOSConcatenaTicket @CajaActual, @CajeroActual, @IDImpresion, @RecalcularTodo, @Accion, @Codigo, @ArtConsulta, @Sucursal,
@Ticket OUTPUT, @Totales, @Saldos, @Total, @Saldo, @CodigoAccion, @Estacion, @DesgloseCC, @EsImpresion = 1
IF @Ok IS NULL
INSERT POSReporteTicket(
Estacion, RID, Campo, AbreCajon)
SELECT
@Estacion, @IDImpresion, Campo ,1
FROM dbo.fnPOSGenerarTicket(@Ticket,'<BR>')
ORDER BY ID
SELECT @ReporteImpresora = 'POSTicket'
SELECT @Expresion = 'ReporteImpresora(''' +@ReporteImpresora +''', ''' + @IDImpresion + ''')'
IF EXISTS(SELECT * FROM POSLCobro c WITH (NOLOCK) JOIN FormaPago f WITH (NOLOCK) ON f.FormaPago = c.FormaPago WHERE   f.AbreCajon = 1 AND c.ID = @IDImpresion)
SELECT @Expresion = @Expresion+' ReporteImpresora('+CHAR(39)+'POSCajonDinero'+CHAR(39)+')'
IF EXISTS(SELECT * FROM POSLCobro c WITH (NOLOCK) JOIN FormaPago f WITH (NOLOCK) ON f.FormaPago = c.FormaPago WHERE   f.AbreCajon = 1 AND c.ID = @IDImpresion)
SELECT @Expresion2 = 'ReporteImpresora('+CHAR(39)+'POSCajonDinero'+CHAR(39)+')'
END
SELECT @Ticket = NULL
END
IF @MovClave IN ('POS.NPC') AND @Ok IS NULL AND @ID IS NOT NULL AND @CodigoAccion = 'CONCLUIR MOVIMIENTO'
BEGIN
EXEC spPOSTraspasarPorCobrar @Empresa, @Modulo, @Sucursal, @Usuario, @Saldo, @Estacion,
@ID OUTPUT, @Mensaje OUTPUT, @Imagen OUTPUT, @Expresion OUTPUT, @IDImprimir OUTPUT, @Ok OUTPUT, @OkRef  OUTPUT
IF @Ok IS NULL
BEGIN
SELECT TOP 1 @ReporteImpresora = ecmi.ReporteImpresora
FROM EmpresaCfgMovImp ecmi WITH (NOLOCK)
WHERE Modulo = 'POS'
AND Mov = @Mov
AND Empresa = @Empresa
IF NULLIF(@ReporteImpresora,'') IS NOT NULL
BEGIN
SELECT @Expresion = 'ReporteImpresora(''' +@ReporteImpresora +''', ''' + @ID + ''')'
IF EXISTS(SELECT * FROM POSLCobro c WITH (NOLOCK) JOIN FormaPago f WITH (NOLOCK) ON f.FormaPago = c.FormaPago WHERE   f.AbreCajon = 1 AND c.ID = @IDImpresion)
SELECT @Expresion2 = 'ReporteImpresora('+CHAR(39)+'POSCajonDinero'+CHAR(39)+')'
END
END
IF @Ok IS NULL AND @Expresion IS NULL
BEGIN
IF EXISTS(SELECT * FROM POSReporteTicket WITH (NOLOCK) WHERE Estacion = @Estacion)
DELETE POSReporteTicket WHERE Estacion = @Estacion
EXEC xpPOSConcatenaTicket @CajaActual, @CajeroActual, @IDImprimir, @RecalcularTodo, @Accion, @Codigo, @ArtConsulta, @Sucursal,
@Ticket OUTPUT , @Totales , @Saldos , @Total , @Saldo, @CodigoAccion, @Estacion,@DesgloseCC, @EsImpresion =1
IF @Ok IS NULL
INSERT POSReporteTicket(
Estacion, RID, Campo, AbreCajon)
SELECT
@Estacion, @IDImprimir, Campo , 1
FROM dbo.fnPOSGenerarTicket(@Ticket,'<BR>')
ORDER BY ID
SELECT @ReporteImpresora = 'POSTicket'
SELECT @Expresion = 'ReporteImpresora(''' +@ReporteImpresora +''', ''' + @IDImprimir + ''')'
IF EXISTS(SELECT * FROM POSLCobro c WITH (NOLOCK) JOIN FormaPago f WITH (NOLOCK) ON f.FormaPago = c.FormaPago WHERE   f.AbreCajon = 1 AND c.ID = @IDImpresion)
SELECT @Expresion2 = 'ReporteImpresora('+CHAR(39)+'POSCajonDinero'+CHAR(39)+')'
END
SELECT @Ticket = NULL
IF @Ok IS NULL
SELECT @Saldo = 0
END
IF @MovClave IN ('POS.N', 'POS.F', 'POS.A','POS.P','POS.NPC','POS.INVD', 'POS.INVA')
BEGIN
SELECT
@CajaActual = Caja,
@CajeroActual = Cajero
FROM POSL pl WITH (NOLOCK)
WHERE pl.ID = @ID
EXEC spPOSHostDatosCaja @Host, @CajaActual, @CajeroActual
END
IF @Ok IS NOT NULL AND EXISTS(SELECT * FROM POSLDIIDTemp WITH (NOLOCK) WHERE Estacion = @@SPID)
BEGIN
INSERT @LDILog(
IDModulo, Modulo, Servicio, Fecha, TipoTransaccion, TipoSubservicio, CodigoRespuesta, DescripcionRespuesta, OrigenRespuesta,
InfoAdicional, IDTransaccion, CodigoAutorizacion, Comprobante, Cadena, CadenaRespuesta, Importe, RIDCobro)
SELECT
IDModulo, Modulo, Servicio, Fecha, TipoTransaccion, TipoSubservicio, CodigoRespuesta, DescripcionRespuesta, OrigenRespuesta,
InfoAdicional, IDTransaccion, CodigoAutorizacion, Comprobante, Cadena, CadenaRespuesta, Importe, RIDCobro
FROM POSLDILog WITH (NOLOCK)
WHERE IDModulo = @ID AND ID IN(SELECT ID FROM POSLDIIDTemp WITH (NOLOCK) WHERE Estacion = @@SPID)
END
DELETE POSLDIIDTemp WHERE Estacion = @@SPID
IF @Ok IS NULL
COMMIT TRAN
ELSE
BEGIN
ROLLBACK TRAN
IF CONVERT(varchar(50),CONTEXT_INFO()) LIKE '%Sucursal%'
UPDATE POSCfgUbicacionRed WITH (ROWLOCK)
SET ConexionActiva = 0
WHERE Tipo = 'Sucursal'
IF CONVERT(varchar(50),CONTEXT_INFO()) LIKE '%Matriz%'
UPDATE POSCfgUbicacionRed WITH (ROWLOCK)
SET ConexionActiva = 0
WHERE Tipo = 'Matriz'
SET CONTEXT_INFO 0
END
IF @Ok IS NULL AND @GenerarCFD = 1
BEGIN
EXEC spPOSAfectarCFD  @IDImpresion, @Empresa, @Sucursal, @Usuario, @AfectadoEnLinea,@Mensaje OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF EXISTS(SELECT * FROM POSReporteTicket WITH (NOLOCK) WHERE Estacion = @Estacion)
DELETE POSReporteTicket WHERE Estacion = @Estacion
EXEC xpPOSConcatenaTicket @CajaActual, @CajeroActual, @IDImpresion, @RecalcularTodo, @Accion, @Codigo, @ArtConsulta, @Sucursal,
@Ticket OUTPUT , @Totales , @Saldos , @Total , @Saldo	, @CodigoAccion, @Estacion, @DesgloseCC, @EsImpresion = 1
IF @Ok IS NULL
INSERT POSReporteTicket(
Estacion, RID, Campo, AbreCajon)
SELECT
@Estacion, @IDImpresion, Campo ,1
FROM dbo.fnPOSGenerarTicket(@Ticket,'<BR>')
ORDER BY ID
SELECT  @Ticket = NULL
END
IF EXISTS(SELECT * FROM @LDILog)
BEGIN
INSERT POSLDILog(
IDModulo, Modulo, Servicio, Fecha, TipoTransaccion, TipoSubservicio, CodigoRespuesta, DescripcionRespuesta, OrigenRespuesta, InfoAdicional,
IDTransaccion, CodigoAutorizacion, Comprobante, Cadena, CadenaRespuesta, Importe, RIDCobro)
SELECT
IDModulo, Modulo, Servicio, Fecha, TipoTransaccion, TipoSubservicio, CodigoRespuesta, DescripcionRespuesta, OrigenRespuesta, InfoAdicional,
IDTransaccion, CodigoAutorizacion, Comprobante, Cadena, CadenaRespuesta, Importe, RIDCobro
FROM @LDILog
END
IF (@Accion IN( 'PESAR') AND NULLIF(CONVERT(float,@Codigo),0) IS NULL AND @Ok = 20010)
SET @Accion = NULL
IF @Accion IS NOT NULL
DELETE POSLAccion WHERE Host = @Host AND Accion = ISNULL(@CodigoAccion, @Accion) AND Caja = @Caja
SELECT @Servicio = MAX(LDIServicio)
FROM POSLVenta plv WITH (NOLOCK)
WHERE plv.ID = @ID
IF NULLIF(@Servicio, '') IS NOT NULL AND @Servicio IN('IUSACELL','MOVISTAR','NEXTEL','TELCEL','UNEFON')
SELECT @FormaServicio = plart.Forma
FROM POSLDIArtRecargaTel plart WITH (NOLOCK)
WHERE plart.Servicio = @Servicio
EXEC xpPOSConcatenaTicket @CajaActual, @CajeroActual, @ID, @RecalcularTodo, @Accion, @Codigo, @ArtConsulta, @Sucursal,
@Ticket OUTPUT, @Totales OUTPUT, @Saldos OUTPUT, @Total OUTPUT, @Saldo	OUTPUT, @CodigoAccion, @Estacion,@DesgloseC,@EsImpresion
IF @Imagen IS NULL
BEGIN
SELECT
@ImagenNombreAnexo = pc.ImagenNombreAnexo,
@CantidadNotasEnProceso = pc.CantidadNotasEnProceso
FROM POSCfg pc WITH (NOLOCK)
WHERE pc.Empresa = @Empresa
SELECT @Imagen = MAX(ac.Direccion)
FROM AnexoCta ac WITH (NOLOCK)
WHERE ac.Nombre = @ImagenNombreAnexo
AND Rama = 'EMP'
AND ac.Cuenta = @Empresa
AND ac.Tipo = 'Imagen'
END
IF @Ok IS NOT NULL
BEGIN
SELECT @Mensaje = Descripcion + ', ' +ISNULL(RTRIM(@OkRef), '')
FROM MensajeLista WITH (NOLOCK)
WHERE Mensaje = @Ok
SELECT @ImporteMov = SUM(dbo.fnPOSImporteMov(((plv.Cantidad  - ISNULL(plv.CantidadObsequio,0.0)) * ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) - ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) * (CASE WHEN ISNULL(plv.AplicaDescGlobal, 1) = 1 THEN ISNULL(p.DescuentoGlobal,0.0) ELSE 0 END)/100))),plv.Impuesto1,plv.Impuesto2,plv.Impuesto3,plv.Cantidad))
FROM POSLVenta plv WITH (NOLOCK)
INNER JOIN POSL p WITH (NOLOCK) ON p.ID = plv.ID
WHERE plv.ID = @ID
AND plv.Articulo <> @ArticuloRedondeo AND plv.RenglonTipo <>'C'
SELECT @ImporteMov = ROUND(@ImporteMov,@RedondeoMonetarios)
SELECT @Redondeo = plv.Precio
FROM POSLVenta plv WITH (NOLOCK)
WHERE plv.ID = @ID
AND plv.Articulo = @ArticuloRedondeo
SELECT @ImporteCobrado = ROUND(SUM(Importe),@RedondeoMonetarios)
FROM POSLCobro WITH (NOLOCK)
WHERE ID = @ID
AND ISNULL(NULLIF(Referencia,''),'') <> 'COMISION CREDITO'
SELECT @Saldo = (ISNULL(@ImporteMov,0) + ISNULL(@Redondeo,0)) - ISNULL(@ImporteCobrado,0)
IF @Saldo < 0 AND @MovClave NOT IN ('POS.N','POS.NPC','POS.CXCD')
SELECT @Saldo = 0
IF @MovClave IN ('POS.N', 'POS.F', 'POS.A','POS.P','POS.NPC','POS.INVD', 'POS.INVA')
BEGIN
IF ISNULL(@Saldo,0.0) BETWEEN (@ToleranciaRedondeo * (-1)) AND (@ToleranciaRedondeo)
SELECT @Saldo = 0.0
END
END
IF @MovClave IN ('POS.INVD', 'POS.INVA')
SELECT @Total = 0.0, @Saldo = 0.0
IF @MovClave IN ('POS.P','POS.INVD', 'POS.INVA') AND @CodigoAccion = 'CONCLUIR MOVIMIENTO'
SELECT @Total = 0.0, @Saldo = 0.0
IF @EnSilencio = 0
SELECT ID = @ID, Ticket = @Ticket, Totales = @Totales, RecalcularTodo = @RecalcularTodo, Mensaje = @Mensaje, ArtDescripcion = @ArtDescripcion,
Expresion = @Expresion, Total =dbo.fnFormatoMoneda(@Total,@Empresa), Saldo =dbo.fnFormatoMoneda(@Saldo,@Empresa), Saldos = @Saldos,
Imagen = @Imagen, Servicio = @Servicio, FormaServicio = @FormaServicio,TorretaMensaje1 = @TorretaMensaje1 ,TorretaMensaje2 = @TorretaMensaje2,
TorretaPosicion1 = @TorretaPosicion1, TorretaPosicion2 = @TorretaPosicion2 , Caja = @Caja, HOST = @Host, Exprecion2 = @Expresion2
END

