SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSAfectar
@Empresa		varchar(5),
@Modulo			varchar(5),
@Sucursal		int,
@Usuario		varchar(10),
@ID				varchar(36),
@Host 			varchar(20)	    = NULL,
@Ok				int		OUTPUT,
@OkRef			varchar(255)    OUTPUT

AS
BEGIN
DECLARE
@IDAnterior						varchar(36),
@Mov							varchar(20),
@MovID							varchar(20),
@FechaEmision					datetime,
@FechaRegistro					datetime,
@Concepto						varchar(50),
@Proyecto						varchar(50),
@UEN							int,
@Moneda							varchar(10),
@TipoCambio						float,
@UsuarioMov						varchar(10),
@Referencia						varchar(50),
@Observaciones					varchar(255),
@Cliente						varchar(10),
@Nombre							varchar(100),
@Direccion						varchar(100),
@DireccionNumero				varchar(20),
@DireccionNumeroInt				varchar(20),
@EntreCalles					varchar(100),
@Delegacion						varchar(100),
@Colonia						varchar(100),
@Poblacion						varchar(100),
@Estado							varchar(50),
@Pais							varchar(50),
@Zona							varchar(50),
@CodigoPostal					varchar(15),
@RFC							varchar(15),
@CURP							varchar(50),
@CteEnviarA						int,
@Almacen						varchar(10),
@Agente							varchar(10),
@Cajero							varchar(10),
@FormaEnvio						varchar(50),
@Condicion						varchar(50),
@Vencimiento					datetime,
@CtaDinero						varchar(10),
@CtaDineroDestino				varchar(10),
@Descuento						varchar(50),
@DescuentoGlobal				float,
@Causa							varchar(50),
@Atencion						varchar(50),
@AtencionTelefono				varchar(50),
@ListaPreciosEsp				varchar(20),
@ZonaImpuesto					varchar(50),
@SucursalMov					int,
@OrigenTipo						varchar(10),
@Origen							varchar(20),
@OrigenID						varchar(20),
@Importe						float,
@MovClave						varchar(20),
@IDNuevo						varchar(36),
@Serie							varchar(5),
@Consecutivo					int,
@noAprobacion					int,
@FechaAprobacion				datetime,
@CadenaOriginal					varchar(max),
@Sello							varchar(255),
@FechaCancelacion				dateTime,
@Certificado					varchar(20),
@DocumentoXML					varchar(max),
@FechaSello						dateTime,
@CFDImporte						float,
@CFDImpuesto1					float,
@CFDImpuesto2					float,
@Estatus						varchar(20),
@EstatusInsertar				varchar(20),
@CodigoRedondeo					varchar(50),
@ArticuloRedondeo				varchar(20),
@VentaPreciosImpuestoIncluido	bit,
@MovFactura   					varchar(20),
@MovFactura2   					varchar(20),
@IDGenerarPedido				int,
@GenerarDinero					bit,
@ArticuloTarjeta				varchar(20),
@AlmacenTarjeta					varchar(10),
@Monedero						varchar(20),
@TipoMonedero					varchar(50),
@Beneficiario					varchar(100),
@Impuestos						float,
@Directo						bit,
@MovCFD							varchar(20),
@NomArchivo						varchar(255),
@XML							varchar(max),
@UUID							varchar(50),
@FechaTimbrado					datetime,
@SelloSat						varchar(255),
@TFDVersion						varchar(10),
@NoCertificadoSAT				varchar(20),
@TFDCadenaOriginal				varchar(max),
@AfectadoEnLinea				bit,
@PedidoReferencia				varchar(50),
@PedidoReferenciaID				int,
@MovSubClave					varchar(20),
@MonederoTipoCambio				float,
@MonederoMoneda					varchar(10),
@ContMoneda						varchar(10),
@ContMonedaTC					float,
@OkReporte						int,
@OkRefReporte					varchar(255),
@FechaNacimiento				datetime,
@EstadoCivil					varchar(20),
@Conyuge						varchar(100),
@Sexo							varchar(20),
@Fuma							bit,
@Profesion						varchar(100),
@Puesto							varchar(100),
@NumeroHijos					int,
@Religion						varchar(50),
@Facturado						bit,
@CFDGenerado					bit,
@TipoCosteo						varchar(20),
@Articulo						varchar(20),
@SubCuenta						varchar(50),
@Unidad							varchar(50),
@Renglon						float,
@MovCosto						float,
@Costo							money,
@MultiUnidades					bit,
@VenderSinExistencia			bit,
@BloquearCantidadInventario		bit,
@NombreDF						varchar(30),
@ApellidosDF					varchar(60),
@PasaporteDF					varchar(30),
@NacionalidadDF					varchar(30),
@NoVueloDF						varchar(20),
@AerolineaDF					varchar(50),
@OrigenDF						varchar(100),
@DestinoDF						varchar(100),
@Comision2						float,
@Estacion						int,
@AutoAjuste						bit,
@CfgSeriesLotesAutoOrden		varchar(20),
@FormaPagoOI					varchar(50),
@POSSeriesLotesAutoOrden		bit,
@MovDevolucion					varchar(20),
@EsDevolucion					bit,
@CfgVentaPrecioMoneda			bit
SET @Estacion = @@SPID
SELECT @MultiUnidades = MultiUnidades, @BloquearCantidadInventario = BloquearCantidadInventario
FROM EmpresaCfg2
WHERE Empresa = @Empresa
SELECT @TipoCosteo = TipoCosteo, @CfgSeriesLotesAutoOrden = SeriesLotesAutoOrden, @CfgVentaPrecioMoneda = ISNULL(VentaPrecioMoneda,0)
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @CodigoRedondeo = pc.RedondeoVentaCodigo,
@MovFactura = pc.MovFactura,
@TipoMonedero = pc.TipoMonedero,
@AutoAjuste = pc.AutoAjuste,
@VenderSinExistencia = pc.VenderSinExistencia,
@POSSeriesLotesAutoOrden = ISNULL(POSSeriesLotesAutoOrden,0),
@MovDevolucion				= ISNULL(NULLIF(POSDefMovDev,''),'Nota Devolucion')
FROM POSCfg pc
WHERE pc.Empresa = @Empresa
SELECT @MovFactura2 = VentaFactura
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
SELECT @VentaPreciosImpuestoIncluido = VentaPreciosImpuestoIncluido, @ArticuloTarjeta= CxcArticuloTarjetasDef,
@AlmacenTarjeta= CxcAlmacenTarjetasDef , @ContMoneda = ContMoneda
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @ContMonedaTC = TipoCambio
FROM POSLTipoCambioRef
WHERE Sucursal = @Sucursal AND Moneda = @ContMoneda
SELECT @ArticuloRedondeo = Cuenta
FROM CB
WHERE Codigo = @CodigoRedondeo
AND TipoCuenta = 'Articulos'
DECLARE crPOSL CURSOR LOCAL FOR
SELECT
pm.ID,
pm.Mov,
pm.MovID,
pm.FechaEmision,
pm.FechaRegistro,
pm.Concepto,
pm.Proyecto,
pm.UEN,
pm.Moneda,
pm.TipoCambio,
pm.Usuario,
pm.Referencia,
pm.Observaciones,
pm.Cliente,
pm.Nombre,
pm.Direccion,
pm.DireccionNumero,
pm.DireccionNumeroInt,
pm.EntreCalles,
pm.Delegacion,
pm.Colonia,
pm.Poblacion,
pm.Estado,
pm.Pais,
pm.Zona,
pm.CodigoPostal,
pm.RFC,
pm.CURP,
pm.EnviarA,
pm.Almacen,
pm.Agente,
pm.Cajero,
pm.FormaEnvio,
pm.Condicion,
pm.Vencimiento,
pm.CtaDinero,
pm.CtaDineroDestino,
pm.Descuento,
pm.DescuentoGlobal,
pm.Causa,
pm.Atencion,
pm.AtencionTelefono,
pm.ListaPreciosEsp,
pm.ZonaImpuesto,
pm.Sucursal,
ISNULL(NULLIF(pm.OrigenTipo,''),'POS'),
pm.Origen,
pm.OrigenID,
pm.Importe,
mt.Clave,
pm.Prefijo,
pm.Consecutivo,
pm.noAprobacion,
pm.fechaAprobacion,
CadenaOriginal = CONVERT(varchar(MAX), pm.CadenaOriginal),
pm.Sello,
pm.FechaCancelacion,
pm.Certificado,
DocumentoXML = CONVERT(varchar(MAX), pm.DocumentoXML),
pm.FechaSello,
pm.Estatus,
pm.Monedero,
pm.BeneficiarioNombre,
pm.Impuestos,
ISNULL(pm.Directo,1),
pm.NombreArchivo,
pm.XmlJasper,
pm.UUID,
pm.FechaTimbrado ,
pm.SelloSat,
pm.TFDVersion,
pm.NoCertificadoSAT,
pm.TFDCadenaOriginal,
ISNULL(pm.AfectadoEnLinea,0),
pm.PedidoReferencia,
pm.PedidoReferenciaID,
mt.SubClave,
pm.FechaNacimiento,
pm.EstadoCivil ,
pm.Conyuge ,
pm.Sexo,
pm.Fuma,
pm.Profesion,
pm.Puesto,
pm.NumeroHijos,
pm.Religion ,
pm.Facturado,
ISNULL(pm.CFDGenerado,0),
pm.NombreDF,
pm.ApellidosDF,
pm.PasaporteDF,
pm.NacionalidadDF,
pm.NoVueloDF,
pm.AerolineaDF,
pm.OrigenDF,
pm.DestinoDF
FROM POSL pm
INNER JOIN MovTipo mt ON pm.Mov = mt.Mov
AND mt.Modulo = 'POS'
WHERE pm.Modulo = @Modulo
AND pm.Empresa = @Empresa
AND pm.ID = @ID
OPEN crPOSL
FETCH NEXT FROM crPOSL INTO @IDAnterior, @Mov, @MovID, @FechaEmision, @FechaRegistro, @Concepto, @Proyecto, @UEN, @Moneda, @TipoCambio, @UsuarioMov,
@Referencia, @Observaciones, @Cliente, @Nombre, @Direccion, @DireccionNumero, @DireccionNumeroInt, @EntreCalles, @Delegacion, @Colonia, @Poblacion,
@Estado, @Pais, @Zona, @CodigoPostal, @RFC, @CURP, @CteEnviarA, @Almacen, @Agente, @Cajero, @FormaEnvio, @Condicion, @Vencimiento, @CtaDinero,
@CtaDineroDestino, @Descuento, @DescuentoGlobal, @Causa, @Atencion, @AtencionTelefono, @ListaPreciosEsp, @ZonaImpuesto, @SucursalMov, @OrigenTipo,
@Origen, @OrigenID, @Importe, @MovClave, @Serie, @Consecutivo, @noAprobacion, @fechaAprobacion, @CadenaOriginal, @Sello, @FechaCancelacion,
@Certificado, @DocumentoXML, @FechaSello, @Estatus, @Monedero,@Beneficiario, @Impuestos, @Directo, @NomArchivo, @XML, @UUID, @FechaTimbrado,
@SelloSat, @TFDVersion, @NoCertificadoSAT, @TFDCadenaOriginal, @AfectadoEnLinea, @PedidoReferencia, @PedidoReferenciaID, @MovSubClave,
@FechaNacimiento, @EstadoCivil, @Conyuge, @Sexo, @Fuma, @Profesion, @Puesto, @NumeroHijos, @Religion, @Facturado, @CFDGenerado,
@NombreDF, @ApellidosDF, @PasaporteDF, @NacionalidadDF, @NoVueloDF, @AerolineaDF, @OrigenDF, @DestinoDF
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Modulo = 'VTAS' AND @MovClave NOT IN ('POS.NPC')
BEGIN
SET @EsDevolucion = 0
IF @MovDevolucion = @Mov
SET @EsDevolucion = 1
IF @MovClave IN( 'POS.P','POS.N') AND ISNULL(@MovSubClave,'') NOT IN( 'POS.PEDCONT')
SELECT @Condicion = NULL
IF EXISTS(SELECT 1 FROM Cte WHERE Cliente = @Cliente)
UPDATE Cte Set  Nombre = @Nombre,
Direccion = @Direccion,
DireccionNumeroInt = @DireccionNumeroInt,
EntreCalles = @EntreCalles,
Delegacion = @Delegacion,
Colonia = @Colonia,
Poblacion = @Poblacion,
Estado = @Estado,
Pais = @Pais,
Zona = @Zona,
CodigoPostal = @CodigoPostal,
RFC = @RFC,
CURP = CURP,
FechaNacimiento = @FechaNacimiento,
EstadoCivil	= @EstadoCivil,
Conyuge	= @Conyuge,
Sexo = @Sexo	,
Fuma	= @Fuma	,
Profesion = @Profesion ,
Puesto = @Puesto,
NumeroHijos	= @NumeroHijos,
Religion = @Religion
WHERE  Cliente = @Cliente
ELSE
INSERT Cte (Cliente, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia,
Poblacion, Estado, Pais, Zona, CodigoPostal, RFC, CURP, Tipo, Estatus, FechaNacimiento, EstadoCivil, Conyuge, Sexo,
Fuma, Profesion, Puesto, NumeroHijos, Religion)
VALUES (@Cliente, @Nombre, @Direccion, @DireccionNumero, @DireccionNumeroInt, @EntreCalles, @Observaciones, @Delegacion, @Colonia,
@Poblacion, @Estado, @Pais, @Zona, @CodigoPostal, @RFC, @CURP, 'Cliente', 'ALTA', @FechaNacimiento, @EstadoCivil, @Conyuge, @Sexo,
@Fuma, @Profesion, @Puesto, @NumeroHijos, @Religion)
IF @Estatus = 'CONCLUIDO'
SELECT @EstatusInsertar = 'SINAFECTAR'
ELSE
IF @Estatus = 'CANCELADO'
SELECT @EstatusInsertar = 'CANCELADO'
SELECT @MovCFD = MovFactura
FROM POSCfg
WHERE Empresa = @Empresa
IF @MovClave IN('POS.N')
SET @GenerarDinero = 1
IF NULLIF(@Origen,'') IS NOT NULL AND NULLIF(@OrigenID,'') IS NOT NULL AND @Origen NOT IN (@MovCFD)
SELECT @Directo = 0
IF EXISTS(SELECT * FROM POSLVenta WHERE NULLIF(Aplica,'') IS NOT NULL AND NULLIF(AplicaID,'') IS NOT NULL AND ID = @ID)
SELECT @Directo = 0
IF @AfectadoEnLinea = 0
BEGIN
INSERT Venta (Empresa, Mov, MovID, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda, TipoCambio,
Usuario, Referencia, Estatus, Observaciones, Cliente, EnviarA, Almacen, Agente, FormaEnvio, Condicion, Vencimiento,
CtaDinero, POSDescuento, DescuentoGlobal, Causa, Atencion, AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, Sucursal, OrigenTipo,
Origen, OrigenID, ReferenciaOrdenCompra, GenerarDinero, SucursalOrigen, Directo, PedidoReferencia, PedidoReferenciaID,
Monedero, Refacturado, SucursalVenta, NombreDF, ApellidosDF, PasaporteDF, NacionalidadDF, NoVueloDF,
AerolineaDF, OrigenDF, DestinoDF)
VALUES		 (@Empresa, @Mov, @MovID, @FechaEmision, @FechaRegistro, @Concepto, @Proyecto, @UEN, @Moneda, CASE WHEN @Moneda <> @ContMoneda THEN (@TipoCambio/@ContMonedaTC) ELSE @TipoCambio END,
@Usuario, @Referencia, @EstatusInsertar, dbo.fnPOSCBGenerar (@ID), @Cliente, @CteEnviarA, @Almacen, @Agente, @FormaEnvio, @Condicion, @Vencimiento,
@CtaDinero, @Descuento, 0.0, @Causa, @Atencion, @AtencionTelefono, @ListaPreciosEsp, @ZonaImpuesto, @SucursalMov, @OrigenTipo,
@Origen, @OrigenID, @ID, @GenerarDinero, @SucursalMov, @Directo, @PedidoReferencia, @PedidoReferenciaID,
@Monedero, @Facturado, @Sucursal, @NombreDF, @ApellidosDF, @PasaporteDF, @NacionalidadDF, @NoVueloDF,
@AerolineaDF, @OrigenDF, @DestinoDF)
SELECT @IDNuevo = SCOPE_IDENTITY()
INSERT VentaD (ID, Renglon, RenglonID, Aplica, AplicaID, RenglonTipo,
Cantidad,
CantidadObsequio,
EnviarA, Articulo, SubCuenta,
Precio,
DescuentoLinea,
DescuentoImporte,
Impuesto1, Impuesto2, Impuesto3, Unidad, Factor, Sucursal, Puntos,
POSDesGlobal,
POSDesLinea, Codigo, Almacen,
CantidadPendiente,
OfertaID, OfertaIDG1, OfertaIDG2, OfertaIDG3,OfertaIDP1, OfertaIDP2, OfertaIDP3,
DescuentoG1, DescuentoG2, DescuentoG3, DescuentoP1, DescuentoP2, DescuentoP3,
CantidadInventario,
Agente,
PrecioMoneda,
PrecioTipoCambio)
SELECT		   @IDNuevo, pmv.Renglon, pmv.RenglonID, pmv.Aplica, pmv.AplicaID, pmv.RenglonTipo,
CASE WHEN @MovClave = 'POS.N' AND ISNULL(@MovSubClave,'') = 'POS.DREF' THEN pmv.Cantidad *-1 ELSE pmv.Cantidad END,
CASE WHEN @MovClave ='POS.N' AND ISNULL(@MovSubClave,'') = 'POS.DREF' THEN pmv.CantidadObsequio *-1 ELSE pmv.CantidadObsequio END,
@CteEnviarA, pmv.Articulo, pmv.SubCuenta,
CASE WHEN @VentaPreciosImpuestoIncluido = 1 THEN pmv.PrecioImpuestoInc ELSE pmv.Precio END,
dbo.fnPOSCalcDescuentosVenta(CASE WHEN ISNULL(pmv.AplicaDescGlobal, 1) = 1 THEN ISNULL(@DescuentoGlobal,0.0) ELSE 0 END, pmv.DescuentoLinea),
(pmv.Cantidad*pmv.Precio)*(dbo.fnPOSCalcDescuentosVenta(CASE WHEN ISNULL(pmv.AplicaDescGlobal, 1) = 1 THEN ISNULL(@DescuentoGlobal,0.0) ELSE 0 END,pmv.DescuentoLinea)/100.0),
pmv.Impuesto1, pmv.Impuesto2, pmv.Impuesto3, pmv.Unidad, 1, @SucursalMov, pmv.Puntos,
CASE WHEN ISNULL(pmv.AplicaDescGlobal, 1) = 1 THEN ISNULL(@DescuentoGlobal,0.0) ELSE 0 END,
ISNULL(pmv.DescuentoLinea,0.0), pmv.Codigo, ISNULL(pmv.Almacen,@Almacen),
CASE WHEN @MovClave IN('POS.P') THEN pmv.Cantidad ELSE NULL END,
pmv.OfertaID, pmv.OfertaIDG1, pmv.OfertaIDG2, pmv.OfertaIDG3, pmv.OfertaIDP1, pmv.OfertaIDP2, pmv.OfertaIDP3,
pmv.DescuentoG1, pmv.DescuentoG2, pmv.DescuentoG3, pmv.DescuentoP1, pmv.DescuentoP2, pmv.DescuentoP3,
CASE WHEN @MultiUnidades = 1 THEN pmv.CantidadInventario ELSE NULL END, Agente,
CASE WHEN @CfgVentaPrecioMoneda = 1 THEN @Moneda ELSE NULL END,
CASE WHEN @CfgVentaPrecioMoneda = 1 THEN @TipoCambio ELSE NULL END
FROM		   POSLVenta pmv
WHERE		   pmv.ID = @IDAnterior
DECLARE crST1 CURSOR LOCAL FOR
SELECT vd.Renglon, vd.Articulo, vd.SubCuenta, vd.Unidad
FROM VentaD vd
WHERE vd.ID = @IDNuevo
OPEN crST1
FETCH NEXT FROM crST1 INTO @Renglon, @Articulo, @SubCuenta, @Unidad
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spVerCosto @Sucursal, @Empresa, NULL, @Articulo, @SubCuenta, @Unidad,  @TipoCosteo, @Moneda, @TipoCambio, @MovCosto OUTPUT, @ConReturn = 0
UPDATE VentaD SET Costo = @MovCosto WHERE ID=@IDNuevo AND Renglon = @Renglon
END
FETCH NEXT FROM crST1 INTO @Renglon, @Articulo, @SubCuenta, @Unidad
END
CLOSE crST1
DEALLOCATE crST1
IF @AutoAjuste = 1 AND @VenderSinExistencia = 1 AND @MovClave IN ('POS.F', 'POS.FA')
BEGIN
EXEC spPOSGeneraAjuste @Empresa, @Sucursal, @IDNuevo, @Moneda, @FechaEmision, @TipoCambio, @Almacen, @Usuario, @Ok OUTPUT, @OkRef OUTPUT
END
IF  @AutoAjuste = 1 AND @VenderSinExistencia = 0 AND @MovClave IN ('POS.F', 'POS.FA', 'POS.N')
BEGIN
EXEC spPOSGeneraAjuste @Empresa, @Sucursal, @IDNuevo, @Moneda, @FechaEmision, @TipoCambio, @Almacen, @Usuario, @Ok OUTPUT, @OkRef OUTPUT
END
IF EXISTS(SELECT 1 FROM POSLSerieLote pls WHERE pls.ID = @IDAnterior)
BEGIN
IF @POSSeriesLotesAutoOrden = 0
SET @CfgSeriesLotesAutoOrden = 'NO'
IF @CfgSeriesLotesAutoOrden <> 'NO'
EXEC spPOSSeriesLotesAutoOrden @IDAnterior, @SucursalMov, @Empresa, @IDNuevo, @CfgSeriesLotesAutoOrden
ELSE
BEGIN
IF @EsDevolucion = 0
INSERT SerieLoteMov (Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Sucursal)
SELECT				 @Empresa, 'VTAS', @IDNuevo, pls.RenglonID, pls.Articulo, ISNULL(pls.SubCuenta,''), pls.SerieLote, COUNT(*), @SucursalMov
FROM POSLSerieLote pls
WHERE pls.ID = @IDAnterior
GROUP BY Articulo, ISNULL(SubCuenta,''), SerieLote, RenglonID
ELSE
INSERT SerieLoteMov (Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, Sucursal)
SELECT				 @Empresa, 'VTAS', @IDNuevo, pls.RenglonID, pls.Articulo, ISNULL(pls.SubCuenta,''), pls.SerieLote, (COUNT(*) * (-1)), @SucursalMov
FROM POSLSerieLote pls
WHERE pls.ID = @IDAnterior
GROUP BY Articulo, ISNULL(SubCuenta,''), SerieLote, RenglonID
END
END
SELECT @MonederoMoneda = Moneda FROM POSValeSerie WHERE Serie = @Monedero
SELECT @MonederoTipoCambio = ISNULL(TipoCambio,1.0)
FROM POSLTipoCambioRef
WHERE Moneda = @MonederoMoneda AND Sucursal = @Sucursal
IF EXISTS(SELECT * FROM POSValeSerie WHERE Serie = @Monedero)
INSERT TarjetaSerieMov(Empresa, ID, Modulo, Serie, Sucursal, TipoCambioTarjeta)
SELECT				   @Empresa, @IDNuevo, @Modulo, @Monedero, @Sucursal, ISNULL(@MonederoTipoCambio,1.0)
EXEC spPOSAfectarVentaCobro @IDAnterior, @IDNuevo, @Empresa,@SucursalMov, @Ok OUTPUT, @OkRef OUTPUT
IF EXISTS(SELECT * FROM POSCxcAnticipo WHERE ID = @IDAnterior)AND @IDNuevo IS NOT NULL
BEGIN
UPDATE Cxc SET AnticipoAplicaID = @IDNuevo ,AnticipoAplicaModulo = 'VTAS',AnticipoAplicar =a.AnticipoAplicar
FROM POSCxcAnticipo a JOIN Cxc c ON a.GUIDOrigen = c.POSGUID
END
IF @Ok IS NULL
BEGIN
DELETE FROM VentaD WHERE Id = @IDNuevo AND ISNULL(Cantidad,0) = 0
IF @Estatus = 'CONCLUIDO'
BEGIN
EXEC spAfectar @Modulo, @IDNuevo, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 0, @Ok = @ok OUTPUT, @OkRef = @OkRef OUTPUT
EXEC xpPOSAfectarVenta @IDAnterior, @IDNuevo, @Ok OUTPUT, @okRef OUTPUT
IF NULLIF(@CadenaOriginal,'') IS NOT NULL
BEGIN
SELECT @FechaSello = ISNULL(@FechaSello,GETDATE())
IF NOT EXISTS(SELECT * FROM CFD WHERE Modulo = @Modulo AND ModuloID = @IDNuevo)
BEGIN
INSERT CFD(Modulo, ModuloID, Fecha, Ejercicio, Periodo, Empresa, MovID, Serie,
Folio, RFC, Aprobacion, Importe, Impuesto1, Impuesto2, FechaCancelacion,
noCertificado, Sello, CadenaOriginal, Documento, UUID, FechaTimbrado, SelloSat,
TFDVersion, NoCertificadoSAT, TFDCadenaOriginal, Timbrado)
VALUES    (@Modulo, @IDNuevo, @FechaSello, YEAR(@FechaSello), MONTH(@FechaSello), @Empresa, @MovID, @Serie,
@Consecutivo, @RFC, @noAprobacion, @CFDImporte, @CFDImpuesto1,@CFDImpuesto2, @FechaCancelacion,
@Certificado, @Sello, @CadenaOriginal, @DocumentoXML, @UUID, @FechaTimbrado, @SelloSat,
@TFDVersion, @NoCertificadoSAT, @TFDCadenaOriginal, 1)
END
ELSE
UPDATE CFD SET Fecha = @FechaSello,
Ejercicio = YEAR(@FechaSello),
Periodo = MONTH(@FechaSello),
Empresa = @Empresa,
MovID = @MovID,
Serie =@Serie,
Folio = @Consecutivo,
RFC = @RFC,
Aprobacion = @noAprobacion,
Importe = @CFDImporte,
Impuesto1 = @CFDImpuesto1,
Impuesto2 = @CFDImpuesto2,
FechaCancelacion = @FechaCancelacion,
noCertificado = @Certificado,
Sello = @Sello,
CadenaOriginal = @CadenaOriginal,
Documento = @DocumentoXML,
UUID = @UUID,
FechaTimbrado = @FechaTimbrado,
SelloSat = @SelloSat,
TFDVersion = @TFDVersion,
NoCertificadoSAT = @NoCertificadoSAT,
TFDCadenaOriginal = @TFDCadenaOriginal,
Timbrado = 1
WHERE Modulo = @Modulo
AND ModuloID = @IDNuevo
IF NULLIF(@NomArchivo,'') IS NOT NULL AND  NULLIF(@XML,'') IS NOT NULL
EXEC spPOSRegenerarReporteJasper @Empresa, @Sucursal,@Cliente, 'VTAS', @IDNuevo, @MovCFD, @XML, @NomArchivo, @OkReporte  OUTPUT, @OkRefReporte  OUTPUT
IF NULLIF(@NomArchivo,'') IS NOT NULL AND  NULLIF(@XML,'') IS NULL
EXEC spPOSRegenerarCFDFlex @Estacion, @Empresa, 'VTAS', @IDNuevo, @ID,  @Estatus, @OkReporte OUTPUT, @OkRefReporte OUTPUT
IF @OkReporte IS NULL
UPDATE POSL SET CFDGenerado = 1 WHERE ID = @ID
END
END
END
END
ELSE
BEGIN
IF NULLIF(@CadenaOriginal,'') IS NOT NULL AND @Estatus = 'TRASPASADO' AND @CFDGenerado = 0
BEGIN
SELECT @IDNuevo = ID FROM Venta WHERE ReferenciaOrdenCompra = @ID AND Mov = @Mov AND MovID = @MovID AND Empresa = @Empresa
SELECT @FechaSello = ISNULL(@FechaSello,GETDATE())
IF @IDNuevo IS NOT NULL AND @Ok IS NULL
BEGIN
IF NOT EXISTS(SELECT * FROM CFD WHERE Modulo = @Modulo AND ModuloID = @IDNuevo)
BEGIN
INSERT CFD (Modulo, ModuloID, Fecha, Ejercicio, Periodo, Empresa, MovID, Serie,
Folio, RFC, Aprobacion, Importe, Impuesto1, Impuesto2, FechaCancelacion,
noCertificado, Sello, CadenaOriginal, Documento, UUID, FechaTimbrado, SelloSat, TFDVersion,
NoCertificadoSAT, TFDCadenaOriginal, Timbrado)
VALUES (	@Modulo, @IDNuevo, @FechaSello, YEAR(@FechaSello), MONTH(@FechaSello), @Empresa, @MovID, @Serie,
@Consecutivo, @RFC, @noAprobacion, @CFDImporte, @CFDImpuesto1,@CFDImpuesto2, @FechaCancelacion,
@Certificado, @Sello, @CadenaOriginal, @DocumentoXML, @UUID, @FechaTimbrado, @SelloSat, @TFDVersion,
@NoCertificadoSAT, @TFDCadenaOriginal, 1)
SELECT @MovCFD = MovFactura FROM POSCfg WHERE Empresa = @Empresa
IF NULLIF(@NomArchivo,'') IS NOT NULL AND  NULLIF(@XML,'') IS NOT NULL
EXEC spPOSRegenerarReporteJasper @Empresa, @Sucursal,@Cliente, 'VTAS', @IDNuevo, @MovCFD, @XML, @NomArchivo, @OkReporte  OUTPUT, @OkRefReporte  OUTPUT
IF NULLIF(@NomArchivo,'') IS NOT NULL AND  NULLIF(@XML,'') IS NULL
EXEC spPOSRegenerarCFDFlex @Estacion, @Empresa, 'VTAS', @IDNuevo, @ID,  @Estatus, @OkReporte OUTPUT, @OkRefReporte OUTPUT
IF @OkReporte IS NULL
UPDATE POSL SET CFDGenerado = 1 WHERE ID = @ID
END
END
END
END
IF @Estatus = 'CANCELAR'
BEGIN
SELECT @IDNuevo = ID FROM Venta WHERE ReferenciaOrdenCompra = @ID
IF @IDNuevo IS NOT NULL
EXEC spAfectar @Modulo, @IDNuevo, 'CANCELAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @ok OUTPUT, @OkRef = @OkRef OUTPUT
END
END
IF @Modulo = 'DIN' AND @MovClave NOT IN('POS.TCAC','POS.CTCAC')
BEGIN
IF @MovClave IN('POS.IC','POS.EC')
SELECT @CtaDineroDestino = NULL
INSERT Dinero (Empresa, Mov, MovID, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda, TipoCambio,
Usuario, Estatus, Importe, Observaciones, CtaDinero, CtaDineroDestino, ConDesglose, Cajero,
Sucursal, SucursalOrigen, BeneficiarioNombre, OrigenTipo)
VALUES		  (@Empresa, @Mov, @MovID, @FechaEmision, @FechaRegistro, @Concepto, @Proyecto, @UEN, @Moneda,
CASE WHEN @Moneda <> @ContMoneda THEN  (@TipoCambio/@ContMonedaTC) ELSE @TipoCambio END,
@Usuario, 'SINAFECTAR', @Importe, @Observaciones, @CtaDinero, @CtaDineroDestino, 1, @Cajero,
@SucursalMov, @SucursalMov, @Beneficiario, 'POS')
SELECT @IDNuevo = SCOPE_IDENTITY()
EXEC spPOSAfectarDineroD @IDAnterior, @IDNuevo, @SucursalMov,@MovClave ,@Ok OUTPUT, @OkRef OUTPUT
EXEC xpPOSAfectarDineroD @IDAnterior, @IDNuevo, @SucursalMov,@MovClave ,@Ok OUTPUT, @OkRef OUTPUT
IF EXISTS(SELECT * FROM POSLDenominacion WHERE ID = @IDAnterior)
BEGIN
INSERT DineroDenominacion(ID, FormaPago, Denominacion,Nombre, Cantidad)
SELECT					  @IDNuevo, FormaPago, Denominacion,Nombre, Cantidad
FROM POSLDenominacion
WHERE ID = @IDAnterior
END
IF @OK IS NULL
EXEC spAfectar @Modulo, @IDNuevo, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
IF @Modulo = 'VALE'
BEGIN
INSERT Vale(Empresa, Mov, MovID, FechaEmision, Moneda,  TipoCambio,
Usuario,  Estatus,	  Sucursal, Tipo,          Precio,					Importe,
Cantidad,  CtaDinero, Articulo,            Almacen,                          FechaInicio,    OrigenTipo)
SELECT      @Empresa,@Mov,@MovID,@FechaEmision,@Moneda, CASE WHEN @Moneda <> @ContMoneda THEN  (@TipoCambio/@ContMonedaTC) ELSE @TipoCambio END,
@Usuario,'SINAFECTAR',@Sucursal,@TipoMonedero, ISNULL(@Importe,0.0),    ISNULL(@Importe,0.0),
1,         @CtaDinero, @ArticuloTarjeta,  ISNULL(@AlmacenTarjeta, @Almacen), @FechaEmision , 'POS'
SELECT @IDNuevo = SCOPE_IDENTITY()
INSERT ValeD(ID, Serie, Sucursal, SucursalOrigen,Importe)
SELECT @IDNuevo, @Monedero, @SucursalMov, @SucursalMov, 0.0
IF @OK IS NULL
EXEC spAfectar @Modulo, @IDNuevo, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
IF @Modulo = 'CXC'
BEGIN
IF @PedidoReferencia IS NOT NULL
BEGIN
IF EXISTS(SELECT * FROM VentaPedidoAnticipoPendiente WHERE MovConsecutivo = @PedidoReferencia)
SELECT @PedidoReferencia = MovConsecutivo, @PedidoReferenciaID = ID
FROM VentaPedidoAnticipoPendiente
WHERE MovConsecutivo = @PedidoReferencia
ELSE
IF  EXISTS(SELECT * FROM POSL WHERE ID = @PedidoReferencia AND Mov IN(SELECT Mov FROM MovTipo WHERE Modulo = 'POS' AND Clave = 'POS.P'))
SELECT @PedidoReferencia = p.Mov+' '+p.MovID,
@PedidoReferenciaID = (SELECT ID FROM VentaPedidoAnticipoPendiente WHERE MovConsecutivo = p.Mov+' '+p.MovID)
FROM POSL p
WHERE p.ID = @PedidoReferencia
ELSE
IF EXISTS(SELECT * FROM POSLCB cb JOIN POSL pl ON cb.ID = pl.ID WHERE cb.IDCB  = @PedidoReferencia AND pl.Mov IN(SELECT Mov FROM MovTipo WHERE Modulo = 'POS' AND Clave = 'POS.P'))
SELECT @PedidoReferencia = p.Mov+' '+p.MovID,
@PedidoReferenciaID = (SELECT ID FROM VentaPedidoAnticipoPendiente WHERE MovConsecutivo = p.Mov+' '+p.MovID)
FROM POSLCB cb JOIN POSL p ON cb.ID = p.ID
WHERE cb.IDCB  = @PedidoReferencia
ELSE
SELECT @PedidoReferencia = NULL, @PedidoReferenciaID = NULL
END
IF @MovClave IN('POS.CXCC'/*,'POS.CXCD'*/)
BEGIN
INSERT Cxc(Empresa, Mov, MovID, FechaEmision, Moneda, TipoCambio,
Usuario, Estatus, Cliente, ClienteEnviarA, CtaDinero, Condicion, Importe, Impuestos, Agente, Sucursal, Cajero, Concepto, ClienteMoneda,
ClienteTipoCambio,
OrigenTipo, POSGUID, PedidoReferencia, PedidoReferenciaID, Referencia, SucursalOrigen)
SELECT     @Empresa, @Mov, @MovID, @FechaEmision, @Moneda, CASE WHEN @Moneda <> @ContMoneda THEN (@TipoCambio/@ContMonedaTC) ELSE @TipoCambio END,
@Usuario, 'SINAFECTAR', @Cliente, @CteEnviarA, @CtaDinero,
@Condicion, @Importe, @Impuestos, @Agente, @Sucursal, @Cajero, @Concepto, @Moneda,
CASE WHEN @Moneda <> @ContMoneda THEN (@TipoCambio/@ContMonedaTC) ELSE @TipoCambio END,
'POS', @IDAnterior, @PedidoReferencia, @PedidoReferenciaID, @PedidoReferencia, @Sucursal
SELECT @IDNuevo = SCOPE_IDENTITY()
END
IF @MovClave IN('POS.CXCC'/*,'POS.CXCD'*/)
BEGIN
EXEC spPOSInsertarCxcCobroDetalle @IDAnterior, @IDNuevo, @Empresa, @Sucursal, @Usuario, @Moneda, @MovClave, @Ok OUTPUT, @OkRef OUTPUT
IF @MovClave='POS.CXCC'
BEGIN
INSERT NegociaMoratoriosMAVI(IDCobro, Estacion, Usuario, Mov, MovID, ImporteReal, ImporteAPagar, ImporteMoratorio, ImporteACondonar,
MoratorioAPagar, Origen, OrigenID)
SELECT DISTINCT				 @IDNuevo, @@SPID, @Usuario, Aplica, AplicaID, ImporteReal, ImporteAPagar, ImporteMoratorio, 0,
MoratorioAPagar, Origen, OrigenID
FROM POSLVenta
WHERE ID = @ID
EXEC spGeneraCobroSugeridoPOS 'CXC', @IDNuevo,  @Usuario, @@SPID, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok = 80030
SELECT @Ok = NULL
END
END
IF @OK IS NULL AND @MovClave = 'POS.CXCD'
BEGIN
SELECT @IDNuevo = ID
FROM Cxc
WHERE Mov = (SELECT TOP 1  Aplica FROM POSLVenta WHERE ID = @ID) AND MovID = (SELECT TOP 1 AplicaID FROM POSLVenta WHERE ID = @ID)
EXEC spAfectar @Modulo, @IDNuevo, 'CANCELAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL AND @MovClave = 'POS.FA'
EXEC spPOSAfectarCxcGenerarCobro @IDAnterior, @IDNuevo, @Empresa, @Sucursal, @Usuario, @Moneda, @Ok OUTPUT, @OkRef OUTPUT
END
IF @OK IS NULL AND @MovClave = 'POS.CXCC' AND (SELECT TOP 1 1 FROM POSLCobro WHERE ID = @ID AND Referencia = 'COMISION CREDITO') = 1
BEGIN
DECLARE crAA CURSOR FOR
SELECT FormaPago
FROM POSLCobro
WHERE ID = @ID
AND Referencia = 'COMISION CREDITO'
OPEN crAA
FETCH NEXT FROM crAA INTO @FormaPagoOI
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @CtaDinero = DefCtaDinero FROM Usuario WHERE Usuario = @Usuario
INSERT Dinero (Empresa, Mov, MovID, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda,
TipoCambio,
Usuario, Estatus, Importe, Observaciones, CtaDinero, CtaDineroDestino,
ConDesglose, Cajero, Sucursal, SucursalOrigen, BeneficiarioNombre, OrigenTipo, FormaPago,
Referencia)
SELECT			@Empresa, 'Otros Ingresos', null, @FechaEmision, @FechaRegistro, p.Referencia, @Proyecto, @UEN, @Moneda,
CASE WHEN @Moneda <> @ContMoneda THEN (@TipoCambio/@ContMonedaTC) ELSE @TipoCambio END,
@Usuario, 'SINAFECTAR', (p.ImporteRef), @Observaciones, @CtaDinero, @CtaDineroDestino,
0, @Cajero, @Sucursal, @Sucursal, @Beneficiario, 'POS', p.FormaPago,
(SELECT Mov+'  '+MovID FROM POSL WHERE ID = @ID)  FROM POSLCobro p WHERE ID = @ID AND p.Referencia IN('COMISION CREDITO')  AND FormaPago = @FormaPagoOI
IF @@ERROR <> 0  SET @Ok = 1
SELECT @IDNuevo = SCOPE_IDENTITY()
IF @OK IS NULL
EXEC spAfectar 'DIN', @IDNuevo, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
FETCH NEXT FROM crAA INTO @FormaPagoOI
END
CLOSE crAA
DEALLOCATE crAA
END
IF @MovClave IN('POS.FA')
BEGIN
INSERT Cxc(Empresa,  Mov,  MovID,  FechaEmision,  Moneda,  TipoCambio,                                                                              Usuario,  Estatus,      Cliente,  ClienteEnviarA,  CtaDinero,  Condicion,  Importe,  Impuestos,  Agente,  Sucursal,  Cajero, Concepto, ClienteMoneda,ClienteTipoCambio,                                                                         OrigenTipo, POSGUID,      PedidoReferencia, PedidoReferenciaID,  Referencia)
SELECT     @Empresa, @Mov, @MovID, @FechaEmision, @Moneda, CASE WHEN @Moneda <> @ContMoneda THEN  (@TipoCambio/@ContMonedaTC) ELSE @TipoCambio END, @Usuario, 'SINAFECTAR', @Cliente, @CteEnviarA,     @CtaDinero, @Condicion, @Importe, @Impuestos, @Agente, @Sucursal, @Cajero, @Concepto, @Moneda,    CASE WHEN @Moneda <> @ContMoneda THEN  (@TipoCambio/@ContMonedaTC) ELSE @TipoCambio END,       'POS',      @IDAnterior, @PedidoReferencia, @PedidoReferenciaID, @PedidoReferencia
SELECT @IDNuevo = SCOPE_IDENTITY()
IF @OK IS NULL
EXEC spAfectar @Modulo, @IDNuevo, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
EXEC spPOSAfectarCxcGenerarCobro @IDAnterior, @IDNuevo, @Empresa, @Sucursal, @Usuario, @Moneda, @Ok OUTPUT, @OkRef OUTPUT
END
END
EXEC xpPOSAfectar @Empresa, @Modulo, @Sucursal, @Usuario, @ID, @Host, @Ok OUTPUT, @OkRef OUTPUT
END
FETCH NEXT FROM crPOSL INTO @IDAnterior, @Mov, @MovID, @FechaEmision, @FechaRegistro, @Concepto, @Proyecto, @UEN, @Moneda, @TipoCambio, @UsuarioMov,
@Referencia, @Observaciones, @Cliente, @Nombre, @Direccion, @DireccionNumero, @DireccionNumeroInt, @EntreCalles, @Delegacion, @Colonia, @Poblacion,
@Estado, @Pais, @Zona, @CodigoPostal, @RFC, @CURP, @CteEnviarA, @Almacen, @Agente, @Cajero, @FormaEnvio, @Condicion, @Vencimiento, @CtaDinero,
@CtaDineroDestino, @Descuento, @DescuentoGlobal, @Causa, @Atencion, @AtencionTelefono, @ListaPreciosEsp, @ZonaImpuesto, @SucursalMov, @OrigenTipo,
@Origen, @OrigenID, @Importe, @MovClave, @Serie, @Consecutivo, @noAprobacion, @fechaAprobacion, @CadenaOriginal, @Sello, @FechaCancelacion,
@Certificado, @DocumentoXML, @FechaSello, @Estatus, @Monedero,@Beneficiario, @Impuestos, @Directo, @NomArchivo, @XML, @UUID, @FechaTimbrado,
@SelloSat, @TFDVersion, @NoCertificadoSAT, @TFDCadenaOriginal, @AfectadoEnLinea, @PedidoReferencia, @PedidoReferenciaID, @MovSubClave,
@FechaNacimiento, @EstadoCivil, @Conyuge, @Sexo, @Fuma, @Profesion, @Puesto, @NumeroHijos, @Religion, @Facturado, @CFDGenerado,
@NombreDF, @ApellidosDF, @PasaporteDF, @NacionalidadDF, @NoVueloDF, @AerolineaDF, @OrigenDF, @DestinoDF
END
CLOSE crPOSL
DEALLOCATE crPOSL
END

