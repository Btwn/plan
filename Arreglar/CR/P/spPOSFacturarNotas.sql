SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spPOSFacturarNotas
@Estacion       int,
@IDPOS          varchar(50),
@Empresa        varchar(20),
@Sucursal       int,
@Usuario        varchar(10),
@MovFact        varchar(20),
@Cliente        varchar(10),
@Ok             int   = NULL         OUTPUT,
@OkRef          varchar(255)  = NULL OUTPUT

AS
BEGIN
DECLARE
@IDDev							varchar(50),
@IDFact							varchar(50),
@MovCFD							varchar(20),
@MovDev							varchar(20),
@IDNuevo						int,
@CodigoRedondeo					varchar(20),
@ArticuloRedondeo				varchar(20),
@UUID							varchar(50),
@FechaTimbrado					datetime,
@MovIDCFD						varchar(20),
@SelloSat						varchar(255),
@TFDVersion						varchar(10),
@NoCertificadoSAT				varchar(20),
@TFDCadenaOriginal				varchar(max),
@CadenaOriginal					varchar(max),
@Sello							varchar(255),
@Certificado					varchar(20),
@DocumentoXML					varchar(max),
@FechaSello						datetime,
@Fecha 							datetime,
@ArticuloTarjeta				varchar(20),
@AlmacenTarjeta					varchar(20),
@Prefijo						varchar(5),
@Consecutivo					int,
@noAprobacion					int,
@fechaAprobacion				datetime,
@MovIDFact						varchar(20),
@MovIDDev						varchar(20),
@VentaPreciosImpuestoIncluido	bit,
@Host							varchar(20),
@Cluster						varchar(20),
@ContMoneda						varchar(10),
@ContMonedaTC					float,
@Expresion						varchar(255),
@ArticuloTarjetaServico			varchar(20),
@RenglonIDMonederoDev			int,
@RenglonIDMonederoFac			int,
@Aplica							varchar(20),
@APlicaID						varchar(20),
@SugerirFechaCierre				bit,
@FechaCierre					datetime,
@Caja							varchar(10)
SELECT @Caja = Caja
FROM POSL
WHERE ID = @IDPOS
SELECT @MovCFD = MovFactura, @CodigoRedondeo = RedondeoVentaCodigo
FROM POSCfg
WHERE Empresa = @Empresa
SELECT @ArticuloRedondeo = Cuenta
FROM CB
WHERE Codigo = @CodigoRedondeo    AND TipoCuenta = 'Articulos'
SELECT
@VentaPreciosImpuestoIncluido = ISNULL(VentaPreciosImpuestoIncluido,0),
@ArticuloTarjeta = CxcArticuloTarjetasDef,
@AlmacenTarjeta = CxcAlmacenTarjetasDef,
@ArticuloTarjetaServico = ArtTarjetaServicio
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @SugerirFechaCierre = SugerirFechaCierre
FROM POSCfg
WHERE Empresa = @Empresa
SELECT @FechaCierre = Fecha
FROM POSFechaCierre
WHERE Sucursal = @Sucursal
SELECT @FechaCierre = dbo.fnPOSFechaCierre(@Empresa,@Sucursal,@FechaCierre,@Caja)
SELECT @Fecha = CASE WHEN @SugerirFechaCierre = 1
THEN @FechaCierre
ELSE dbo.fnFechaSinHora(GETDATE())
END
SELECT @IDDev = NEWID()
SELECT @IDFact = NEWID()
EXEC spPOSHost @Host OUTPUT, @Cluster OUTPUT
SELECT @ContMoneda = ec.ContMoneda
FROM EmpresaCfg ec
WHERE ec.Empresa = @Empresa
SELECT @ContMonedaTC = TipoCambio
FROM POSLTipoCambioRef
WHERE Sucursal = @Sucursal AND Moneda = @ContMoneda
BEGIN TRANSACTION
IF @Ok IS  NULL
BEGIN
INSERT POSL (
ID, Empresa, Mov, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda, TipoCambio, Importe, Impuestos, Usuario, Referencia,
Estatus, Observaciones, Cliente, EnviarA, Almacen, Agente, FormaEnvio, Condicion, Vencimiento, CtaDinero, Descuento, DescuentoGlobal, Causa, Atencion,
AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, Sucursal, OrigenTipo, Origen, OrigenID, Host, Cluster, Nombre, Direccion, DireccionNumero,
DireccionNumeroInt, EntreCalles, Delegacion, Colonia, Poblacion, Estado, Pais, Zona, CodigoPostal, RFC, CURP, Modulo, Cajero, CtaDineroDestino,
Directo, Caja, PedidoReferencia, PedidoReferenciaID, IDR, FechaNacimiento, EstadoCivil, Conyuge, Sexo, Fuma, Profesion, Puesto, NumeroHijos, Religion)
SELECT
@IDDev, Empresa, Mov, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda, TipoCambio, (Importe*-1), (Impuestos*-1), @Usuario, Referencia,
Estatus, Observaciones, Cliente, EnviarA, Almacen, Agente, FormaEnvio, Condicion, Vencimiento, CtaDinero, Descuento, DescuentoGlobal, Causa, Atencion,
AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, @Sucursal, OrigenTipo, NULL, NULL, @Host, @Cluster, Nombre, Direccion, DireccionNumero,
DireccionNumeroInt, EntreCalles, Delegacion, Colonia, Poblacion, Estado, Pais, Zona, CodigoPostal, RFC, CURP, Modulo, Cajero, CtaDineroDestino,
Directo, Caja, PedidoReferencia, PedidoReferenciaID, @IDPOS, FechaNacimiento, EstadoCivil, Conyuge, Sexo, Fuma, Profesion, Puesto, NumeroHijos, Religion
FROM POSL
WHERE ID = @IDPOS
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL
INSERT POSLVenta(
ID, Renglon, RenglonID, Aplica, AplicaID, RenglonTipo, Cantidad, CantidadObsequio, Articulo, SubCuenta, Precio, PrecioSugerido,
DescuentoLinea, Impuesto1, Impuesto2, Impuesto3, Unidad, Factor,  Puntos,PrecioImpuestoInc, Almacen, Codigo, EsMonedero)
SELECT
@IDDev, Renglon, RenglonID, NULL, NULL, RenglonTipo, (Cantidad*-1), (CantidadObsequio*-1), Articulo, SubCuenta, Precio, PrecioSugerido,
DescuentoLinea, Impuesto1, Impuesto2, Impuesto3, Unidad, Factor,  Puntos,PrecioImpuestoInc, Almacen, Codigo, EsMonedero
FROM POSLVenta
WHERE ID = @IDPOS
IF @@ERROR <> 0
SET @Ok = 1
IF EXISTS(SELECT * FROM POSLSerieLote WHERE ID = @IDPOS)
BEGIN
INSERT POSLSerieLote(
ID, RenglonID, Articulo, SubCuenta, SerieLote)
SELECT
@IDDev, RenglonID, Articulo, ISNULL(SubCuenta,''), SerieLote
FROM POSLSerieLote
WHERE ID = @IDPOS
ORDER BY Orden
END
IF EXISTS(SELECT * FROM POSLCobro WHERE ID = @IDPOS)
BEGIN
INSERT POSLCobro(
ID, FormaPago, Importe, Referencia, Monedero, CtaDinero, Fecha, Caja, Cajero, Host, ImporteRef, TipoCambio,
Voucher, Banco, MonedaRef, CtaDineroDestino)
SELECT
@IDDev, FormaPago, (Importe*-1), Referencia, Monedero, CtaDinero, Fecha,  Caja,  Cajero, Host, (ImporteRef*-1), TipoCambio,
Voucher, Banco, MonedaRef, CtaDineroDestino
FROM POSLCobro
WHERE ID = @IDPOS
END
IF EXISTS(SELECT * FROM POSLVenta WHERE ID = @IDDev AND ISNULL(EsMonedero,0) = 1)
BEGIN
SELECT @RenglonIDMonederoDev = RenglonID
FROM POSLVenta
WHERE  ID = @IDDev AND ISNULL(EsMonedero,0) = 1
UPDATE POSLVenta SET Articulo = @ArticuloTarjetaServico, RenglonTipo = 'N'
WHERE  ID = @IDDev AND ISNULL(EsMonedero,0) = 1
DELETE POSLSerieLote WHERE ID = @IDDev AND RenglonID = @RenglonIDMonederoDev
END
SELECT @MovDev = Mov FROM POSL WHERE ID = @IDDev
IF @Ok IS NULL
BEGIN
EXEC spPOSConsecutivoAuto @Empresa, @Sucursal, @MovDev, @MovIDDev OUTPUT, @Prefijo OUTPUT,
@Consecutivo OUTPUT, @noAprobacion OUTPUT, @FechaAprobacion OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
UPDATE
POSL SET MovID =  @MovIDDev,
Prefijo = ISNULL(Prefijo, @Prefijo),
Consecutivo = ISNULL(Consecutivo, @Consecutivo),
noAprobacion = ISNULL(noAprobacion, @NoAprobacion),
fechaAprobacion = ISNULL(fechaAprobacion, @fechaAprobacion),
Estatus = 'CONCLUIDO',
FechaEmision = dbo.fnFechaSinHora(@Fecha),
FechaRegistro = @Fecha
WHERE ID = @IDDev
END
END
IF @MovFact IS NOT NULL AND @Ok IS NULL
BEGIN
INSERT POSL (
ID, Empresa, Mov, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda, Importe, Impuestos, TipoCambio, Usuario, Referencia, Estatus,
Observaciones, Cliente, EnviarA, Almacen, Agente, FormaEnvio, Condicion, Vencimiento, CtaDinero, Descuento, DescuentoGlobal, Causa, Atencion,
AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, Sucursal, OrigenTipo, Origen, OrigenID, Host, Cluster, Nombre, Direccion, DireccionNumero,
DireccionNumeroInt, EntreCalles, Delegacion, Colonia, Poblacion, Estado, Pais, Zona, CodigoPostal, RFC, CURP,Modulo, Cajero, CtaDineroDestino,
Directo, Caja, PedidoReferencia, PedidoReferenciaID, IDR, FechaNacimiento, EstadoCivil, Conyuge, Sexo, Fuma, Profesion, Puesto, NumeroHijos, Religion)
SELECT
@IDFact, Empresa, @MovFact, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda, Importe, Impuestos, TipoCambio, @Usuario, Referencia, Estatus,
Observaciones, @Cliente, EnviarA, Almacen, Agente, FormaEnvio, Condicion, Vencimiento, CtaDinero, Descuento, DescuentoGlobal, Causa, Atencion,
AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, @Sucursal, OrigenTipo, NULL, NULL, @Host, @Cluster, Nombre, Direccion, DireccionNumero,
DireccionNumeroInt, EntreCalles, Delegacion, Colonia, Poblacion, Estado, Pais, Zona, CodigoPostal, RFC, CURP, Modulo, Cajero, CtaDineroDestino,
Directo, Caja, PedidoReferencia, PedidoReferenciaID, @IDPOS, FechaNacimiento, EstadoCivil, Conyuge, Sexo, Fuma, Profesion, Puesto, NumeroHijos, Religion
FROM POSL
WHERE ID = @IDPOS
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL
INSERT POSLVenta(
ID, Renglon, RenglonID, Aplica, AplicaID, RenglonTipo, Cantidad, CantidadObsequio, Articulo, SubCuenta, Precio, PrecioSugerido, DescuentoLinea,
Impuesto1, Impuesto2, Impuesto3, Unidad, Factor,  Puntos,PrecioImpuestoInc, Almacen, Codigo, EsMonedero)
SELECT
@IDFact, Renglon, RenglonID, NULL  , NULL,     RenglonTipo, Cantidad, CantidadObsequio, Articulo, SubCuenta, Precio, PrecioSugerido, DescuentoLinea,
Impuesto1, Impuesto2, Impuesto3, Unidad, Factor,  Puntos,PrecioImpuestoInc, Almacen, Codigo, EsMonedero
FROM POSLVenta
WHERE ID = @IDPOS
IF @@ERROR <> 0
SET @Ok = 1
IF EXISTS(SELECT * FROM POSLSerieLote WHERE ID = @IDPOS)
BEGIN
INSERT POSLSerieLote(
ID, RenglonID, Articulo, SubCuenta, SerieLote)
SELECT
@IDFact, RenglonID, Articulo, ISNULL(SubCuenta,''), SerieLote
FROM POSLSerieLote
WHERE ID = @IDPOS
ORDER BY Orden
END
IF EXISTS(SELECT * FROM POSLCobro WHERE ID = @IDPOS)
BEGIN
INSERT POSLCobro(
ID, FormaPago, Importe, Referencia, Monedero, CtaDinero, Fecha,  Caja,  Cajero, Host, ImporteRef,
TipoCambio, Voucher, Banco, MonedaRef, CtaDineroDestino)
SELECT
@IDFact, FormaPago, Importe, Referencia, Monedero, CtaDinero, Fecha,  Caja,  Cajero, Host, ImporteRef,
TipoCambio, Voucher, Banco, MonedaRef, CtaDineroDestino
FROM POSLCobro
WHERE ID = @IDPOS
END
IF EXISTS(SELECT * FROM POSLVenta WHERE ID = @IDFact AND ISNULL(EsMonedero,0) = 1)
BEGIN
SELECT @RenglonIDMonederoFac = RenglonID
FROM POSLVenta
WHERE  ID = @IDFact AND ISNULL(EsMonedero,0) = 1
UPDATE POSLVenta SET Articulo = @ArticuloTarjetaServico, RenglonTipo = 'N'
WHERE  ID = @IDFact AND ISNULL(EsMonedero,0) = 1
DELETE POSLSerieLote WHERE ID = @IDFact AND RenglonID = @RenglonIDMonederoFac
END
IF @Ok IS NULL
EXEC spPOS @Estacion, NULL, @Empresa, 'VTAS', @Sucursal, @Usuario,  NULL, @IDFact, NULL, NULL, NULL, 0, NULL, @Cliente, @EnSilencio = 1
IF @Ok IS NULL
BEGIN
EXEC spPOSConsecutivoAuto @Empresa, @Sucursal, @MovFact, @MovIDFact OUTPUT, @Prefijo OUTPUT, @Consecutivo OUTPUT,
@noAprobacion OUTPUT, @FechaAprobacion OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
UPDATE
POSL SET MovID =  @MovIDFact,
Prefijo = ISNULL(Prefijo, @Prefijo),
Consecutivo = ISNULL(Consecutivo, @Consecutivo),
noAprobacion = ISNULL(noAprobacion, @NoAprobacion),
fechaAprobacion = ISNULL(fechaAprobacion, @fechaAprobacion),
Estatus = 'CONCLUIDO',
FechaEmision = dbo.fnFechaSinHora(@Fecha),
FechaRegistro = @Fecha
WHERE ID = @IDFact
END
END
IF NULLIF(@MovCFD,'') IS NOT NULL AND @Ok IS NULL
BEGIN
INSERT Venta (
Empresa, Mov, MovID, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda,
TipoCambio, Usuario, Referencia, Estatus, Observaciones, Cliente, EnviarA, Almacen, Agente, FormaEnvio, Condicion, Vencimiento,
CtaDinero, Descuento, DescuentoGlobal, Causa, Atencion, AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, Sucursal, OrigenTipo, Origen, OrigenID,
ReferenciaOrdenCompra, GenerarDinero, SucursalOrigen)
SELECT
p.Empresa, @MovCFD, NULL, p.FechaEmision, p.FechaRegistro, p.Concepto, p.Proyecto, p.UEN, p.Moneda,
CASE WHEN p.Moneda <> @ContMoneda
THEN  (p.TipoCambio/@ContMonedaTC)
ELSE p.TipoCambio
END, p.Usuario, p.Referencia, 'SINAFECTAR', p.Observaciones, p.Cliente, p.EnviarA, p.Almacen, p.Agente, p.FormaEnvio, p.Condicion, p.Vencimiento,
p.CtaDinero, p.Descuento, 0.0, p.Causa, p.Atencion, p.AtencionTelefono, p.ListaPreciosEsp, p.ZonaImpuesto, p.Sucursal, 'POS', p.Mov, p.MovID,
@IDFact, 0, p.Sucursal
FROM POSL p
WHERE p.ID = @IDFact
IF @@ERROR <> 0
SET @Ok = 1
SELECT @IDNuevo = SCOPE_IDENTITY()
INSERT VentaD (
ID, Renglon, RenglonID, Aplica, AplicaID, RenglonTipo, Cantidad, CantidadObsequio,
Almacen, EnviarA, Articulo, SubCuenta, Precio, DescuentoLinea, Impuesto1,
Impuesto2, Impuesto3, Unidad, Factor, Sucursal, Puntos, POSDesGlobal, POSDesLinea, Codigo)
SELECT
@IDNuevo, pmv.Renglon, pmv.RenglonID, pmv.Aplica, pmv.AplicaID, pmv.RenglonTipo, pmv.Cantidad, pmv.CantidadObsequio,
CASE WHEN pmv.Articulo= @ArticuloTarjeta
THEN ISNULL(p.Almacen,@AlmacenTarjeta)
ELSE ISNULL(pmv.Almacen,p.Almacen)
END, p.EnviarA, pmv.Articulo, pmv.SubCuenta, CASE WHEN @VentaPreciosImpuestoIncluido = 1
THEN pmv.PrecioImpuestoInc
ELSE pmv.Precio
END, dbo.fnPOSCalcDescuentosVenta(CASE WHEN ISNULL(pmv.AplicaDescGlobal, 1) = 1
THEN ISNULL(p.DescuentoGlobal,0.0)
ELSE 0
END,pmv.DescuentoLinea), pmv.Impuesto1,
pmv.Impuesto2, pmv.Impuesto3, pmv.Unidad, 1, @Sucursal, pmv.Puntos, CASE WHEN ISNULL(pmv.AplicaDescGlobal, 1) = 1
THEN ISNULL(p.DescuentoGlobal,0.0)
ELSE 0
END, ISNULL(pmv.DescuentoLinea,0.0), pmv.Codigo
FROM POSLVenta pmv JOIN POSL p ON pmv.ID = p.ID
WHERE pmv.ID = @IDFact
IF @@ERROR <> 0
SET @Ok = 1
EXEC spPOSInsertarPOSVentaCobro @IDFact, @Empresa,@Sucursal, @Ok OUTPUT, @OkRef OUTPUT
IF EXISTS(SELECT 1 FROM POSLSerieLote pls WHERE pls.ID = @IDFact)
INSERT SerieLoteMov (Empresa,  Modulo, ID,       RenglonID,     Articulo,     SubCuenta,                 SerieLote,     Cantidad,  Sucursal)
SELECT               @Empresa, 'VTAS', @IDNuevo, pls.RenglonID, pls.Articulo, ISNULL(pls.SubCuenta, ''), pls.SerieLote, COUNT(*),  @Sucursal
FROM POSLSerieLote pls
WHERE pls.ID = @IDFact
GROUP BY Articulo, ISNULL(SubCuenta,''), SerieLote, RenglonID
IF @Ok IS NULL AND @IDNuevo IS NOT NULL
EXEC spAfectar 'VTAS', @IDNuevo, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL AND EXISTS(SELECT * FROM CFD WHERE Modulo = 'VTAS' AND ModuloID = @IDNuevo)
BEGIN
SELECT
@CadenaOriginal = cfd.CadenaOriginal,
@Certificado = cfd.noCertificado,
@Sello = cfd.Sello,
@DocumentoXML = cfd.Documento,
@MovIDCFD = cfd.MovID,
@UUID = cfd.UUID ,
@FechaTimbrado = cfd.FechaTimbrado,
@SelloSat =  cfd.SelloSat,
@TFDVersion = cfd.TFDVersion  ,
@NoCertificadoSAT = cfd.NoCertificadoSAT,
@TFDCadenaOriginal = cfd.TFDCadenaOriginal
FROM CFD cfd
WHERE cfd.Modulo = 'VTAS' AND cfd.ModuloID = @IDNuevo
IF @Ok IS NULL
UPDATE POSL
SET CadenaOriginal = @CadenaOriginal,
Sello = @Sello,
Certificado = @Certificado,
DocumentoXML = @DocumentoXML,
FechaSello = @FechaSello,
Origen = @MovCFD,
OrigenID = @MovIDCFD,
UUID = @UUID,
FechaTimbrado =  @FechaTimbrado,
SelloSat = @SelloSat,
TFDVersion = @TFDVersion,
NoCertificadoSAT = @NoCertificadoSAT,
TFDCadenaOriginal = @TFDCadenaOriginal
WHERE ID = @IDFact
END
END
IF @Ok IS NULL
UPDATE POSL SET Facturado = 1 WHERE ID = @IDPOS
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
SELECT @Expresion = 'FormaModal('+CHAR(39)+'POSFacturarNotas'+CHAR(39)+')'
SELECT @OkRef = ' Se Genero '+@MovFact+' '+@MovIDFact
END
ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT @OkRef = Descripcion+' '+RTRIM(ISNULL(@OkRef,''))
FROM MensajeLista
WHERE Mensaje = @Ok
SELECT @Expresion= 'ERROR('+CHAR(39)+@OkRef+CHAR(39)+')'
END
SELECT @OkRef,@Expresion, @IDFact, @IDNuevo,@MovCFD, @MovIDCFD
RETURN
END

