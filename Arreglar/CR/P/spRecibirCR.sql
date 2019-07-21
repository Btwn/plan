SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRecibirCR
@xml		text,
@NoAfectar 	bit = 0,
@Sesion	varchar(50) = NULL

AS BEGIN
DECLARE
@ixml		 int,
@Empresa		 char(5),
@Sucursal		 int,
@Prefijo		 varchar(5),
@CajaCentral	 int,
@Usuario		 char(10),
@Almacen		 char(10),
@Moneda		 char(10),
@TipoCambio		 float,
@FechaTrabajo	 datetime,
@FechaRegistro	 datetime,
@Ok			 int,
@OkRef		 varchar(255),
@CorteCajaMov	 char(20),
@CorteCajaCentralMov char(20),
@CRMov		 char(20),
@CRMovID		 varchar(20),
@CRID		 int,
@Articulo		 char(20),
@SubCuenta		 varchar(20),
@Departamento	 int,
@Cantidad		 float,
@Importe		 money,
@Renglon		 float,
@RenglonID		 int,
@ID			 int,
@Caja		 int,
@CajaRef		 int,
@Cajero		 int,
@FechaD		 datetime,
@FechaA		 datetime,
@DocFuente		 int,
@CajaFolio		 int,
@Banco		 int,
@CtaRef		 char(10),
@CtaDinero		 char(10),
@CtaCaja		 char(10),
@CtaCajero		 char(10),
@CtaCajaCentral	 char(10),
@DepositoMov 	 char(20),
@ChequeMov   	 char(20),
@IngresoMov  	 char(20),
@EgresoMov   	 char(20),
@DineroMov		 char(20),
@DineroMovID	 varchar(20),
@DineroID		 int,
@Referencia		 varchar(50),
@Mensaje		 varchar(255),
@SQL			nvarchar(4000),
@Params			nvarchar(4000),
@CRProcesoDistribuido	bit,
@CRServidorOperaciones	varchar(50),
@CRBaseDatosOperaciones	varchar(50),
@CRAfectarAuto		bit,
@CREstatusSinAfectar	varchar(15),
@CRCerrarDiaAuto		bit/*,
@CRTipoCredito	varchar(20),
@CRTipoCreditoCxc	bit,
@ArtRedondeo	varchar(20)*/
SELECT @Ok = NULL, @OkRef = NULL, @SubCuenta = NULL, @Renglon = 0.0, @RenglonID = 0, /*@CRTipoCreditoCxc = 0, */@FechaRegistro = GETDATE()
BEGIN TRANSACTION
EXEC sp_xml_preparedocument @ixml OUTPUT, @xml
SELECT @Empresa = Empresa, @Sucursal = Sucursal, @CajaCentral = CajaCentral, @FechaTrabajo = FechaTrabajo
FROM OPENXML (@ixml, 'CR')
WITH (Empresa char(5), Sucursal int, CajaCentral int, FechaTrabajo datetime)
SELECT @Usuario = Usuario,
@Prefijo = Prefijo,
@Almacen = AlmacenPrincipal/*,
@CRTipoCredito = UPPER(CRTipoCredito)*/
FROM Sucursal
WHERE Sucursal = @Sucursal
SELECT @CRProcesoDistribuido = ISNULL(CRProcesoDistribuido, 0),
@CRServidorOperaciones = CRServidorOperaciones,
@CRBaseDatosOperaciones = CRBaseDatosOperaciones,
@CRAfectarAuto = ISNULL(CRAfectarAuto, 0),
@CREstatusSinAfectar = CREstatusSinAfectar,
@CRCerrarDiaAuto = CRCerrarDiaAuto/*,
@ArtRedondeo	= ArtRedondeo*/
FROM EmpresaCfg
WHERE Empresa = @Empresa
IF @NoAfectar = 1 SELECT @CRAfectarAuto = 0
IF @Usuario IS NULL
SELECT @Ok = 10560, @OkRef = CONVERT(varchar, @Sucursal)
IF @Almacen IS NULL
SELECT @Ok = 10570, @OkRef = CONVERT(varchar, @Sucursal)
IF EXISTS(SELECT * FROM crMov WHERE Sucursal = @Sucursal AND FechaEmision = @FechaTrabajo)
SELECT @Ok = 10550
/*IF NOT EXISTS(SELECT * FROM Art WHERE Articulo = @ArtRedondeo)
SELECT @Ok = 10600*/
IF @Ok IS NULL
BEGIN
DELETE crCta WHERE Sucursal = @Sucursal
INSERT crCta (Sucursal, Tipo, Numero, Nombre, Estatus, ClaveIntelisis, CajeroContrasena, CajeroEditarNota, CajeroPermiteDesc, CajeroCancelarNotas, CajeroReasignarCliente, CajeroCteExpress, CajeroCteExpressDesc, CajeroVerSaldo, CajeroRealizarCorte, CajeroAnticipo, CajeroDevAnticipo, CajeroGasto, CajeroDevolucionGasto, CajeroPrestamo, CajeroDevPrestamo, CajeroVentaCredito, CajeroDevolucionCredito, CajeroCobroCredito, CajeroMovsOtrosCajeros, CajeroMovsOtrasCajas, VendedorDeptoOmision, CajaLimiteInferior, CajaLimiteSuperior, CajaFondoFijo, CajaPausaValidar, VendedorPresupuesto, MonedaTipoCambio, BancoNumeroCuenta, FormaPagoReferenciaOmision, VendedorPrimerFolio, VendedorUltimoFolio, CajaSaltosRenglon, CajaPausaImprimir, CajaAbrirCajon, CajaCortarTicket, CajaValidarNota, CajaImpresionNegritas, CajaImpresionComprimido, CajaImpresionNormal, CajaCortarPapel, CajaSiguienteDia, MonedaTipoCambioCompra, MonedaTipoCambioVenta, CajaVentasPorHora, CajaPuertoLocal, CajeroBorrarCapturaAlm, CajeroBotonArticulos, CajeroBotonBancos, CajeroBotonCajas, CajeroBotonCajeros, CajeroBotonCerrarSucursal, CajeroBotonClientes, CajeroBotonConceptos, CajeroBotonConfigurar, CajeroBotonDepartamentos, CajeroBotonEliminar, CajeroBotonesPermitidos, CajeroBotonFormasPago, CajeroBotonMonedas, CajeroBotonSaldoCajas, CajeroBotonVendedores, CajeroCancelarMovsCaja, CajeroCancelarVentaActual, CajeroCapacidades, CajeroCapacidadesEspeciales, CajeroConfigurarAdmin, CajeroEditarTipoCambio, CajeroModificarRango, CajeroMovCorteCaja, CajeroMovFondoInicial, CajeroMovRecoleccion, CajeroMovsAlmacen, CajeroMovsPermitidos, CajeroPassword, CajeroReimprimirNota, CajeroUsarAdmin, FormaPagoAceptarCambio, FormaPagoDesglosar, FormaPagoMonedaEspecifica, FormaPagoRecolectar, CajeroMovAjusteSaldo, CajeroVencimContrasena)
SELECT        Sucursal, Tipo, Numero, Nombre, Estatus, ClaveIntelisis, CajeroContrasena, CajeroEditarNota, CajeroPermiteDesc, CajeroCancelarNotas, CajeroReasignarCliente, CajeroCteExpress, CajeroCteExpressDesc, CajeroVerSaldo, CajeroRealizarCorte, CajeroAnticipo, CajeroDevAnticipo, CajeroGasto, CajeroDevolucionGasto, CajeroPrestamo, CajeroDevPrestamo, CajeroVentaCredito, CajeroDevolucionCredito, CajeroCobroCredito, CajeroMovsOtrosCajeros, CajeroMovsOtrasCajas, VendedorDeptoOmision, CajaLimiteInferior, CajaLimiteSuperior, CajaFondoFijo, CajaPausaValidar, VendedorPresupuesto, MonedaTipoCambio, BancoNumeroCuenta, FormaPagoReferenciaOmision, VendedorPrimerFolio, VendedorUltimoFolio, CajaSaltosRenglon, CajaPausaImprimir, CajaAbrirCajon, CajaCortarTicket, CajaValidarNota, CajaImpresionNegritas, CajaImpresionComprimido, CajaImpresionNormal, CajaCortarPapel, CajaSiguienteDia, MonedaTipoCambioCompra, MonedaTipoCambioVenta, CajaVentasPorHora, CajaPuertoLocal, CajeroBorrarCapturaAlm, CajeroBotonArticulos, CajeroBotonBancos, CajeroBotonCajas, CajeroBotonCajeros, CajeroBotonCerrarSucursal, CajeroBotonClientes, CajeroBotonConceptos, CajeroBotonConfigurar, CajeroBotonDepartamentos, CajeroBotonEliminar, CajeroBotonesPermitidos, CajeroBotonFormasPago, CajeroBotonMonedas, CajeroBotonSaldoCajas, CajeroBotonVendedores, CajeroCancelarMovsCaja, CajeroCancelarVentaActual, CajeroCapacidades, CajeroCapacidadesEspeciales, CajeroConfigurarAdmin, CajeroEditarTipoCambio, CajeroModificarRango, CajeroMovCorteCaja, CajeroMovFondoInicial, CajeroMovRecoleccion, CajeroMovsAlmacen, CajeroMovsPermitidos, CajeroPassword, CajeroReimprimirNota, CajeroUsarAdmin, FormaPagoAceptarCambio, FormaPagoDesglosar, FormaPagoMonedaEspecifica, FormaPagoRecolectar, CajeroMovAjusteSaldo, CajeroVencimContrasena
FROM OPENXML (@ixml, 'CR/crCta/row')
WITH (Sucursal int, ID int, Tipo varchar(20), Numero int, Nombre varchar(100), Estatus char(15), ClaveIntelisis varchar(50), CajeroContrasena varchar(20), CajeroEditarNota bit, CajeroPermiteDesc bit, CajeroCancelarNotas bit, CajeroReasignarCliente bit, CajeroCteExpress bit, CajeroCteExpressDesc bit, CajeroVerSaldo bit, VendedorDeptoOmision int, CajaLimiteInferior money, CajaLimiteSuperior money, CajaFondoFijo money, CajaPausaValidar bit, VendedorPresupuesto float, MonedaTipoCambio float, BancoNumeroCuenta varchar(100), CajeroRealizarCorte bit, CajeroAnticipo bit, CajeroDevAnticipo bit, CajeroGasto bit, CajeroDevolucionGasto bit, CajeroPrestamo bit, CajeroDevPrestamo bit, CajeroVentaCredito bit, CajeroDevolucionCredito bit, CajeroCobroCredito bit, CajeroMovsOtrosCajeros bit, CajeroMovsOtrasCajas bit, FormaPagoReferenciaOmision varchar(50), VendedorPrimerFolio varchar(10), VendedorUltimoFolio varchar(10), CajaSaltosRenglon int, CajaPausaImprimir int, CajaAbrirCajon varchar(100), CajaCortarTicket varchar(100), CajaValidarNota varchar(100), CajaImpresionNegritas varchar(100), CajaImpresionComprimido varchar(100), CajaImpresionNormal varchar(100), CajaCortarPapel bit, CajaSiguienteDia bit, MonedaTipoCambioCompra float, MonedaTipoCambioVenta float, CajaVentasPorHora float,
CajaPuertoLocal char(10), CajeroBorrarCapturaAlm bit, CajeroBotonArticulos bit, CajeroBotonBancos bit, CajeroBotonCajas bit, CajeroBotonCajeros bit, CajeroBotonCerrarSucursal bit, CajeroBotonClientes bit, CajeroBotonConceptos bit, CajeroBotonConfigurar bit, CajeroBotonDepartamentos bit, CajeroBotonEliminar bit, CajeroBotonesPermitidos bit, CajeroBotonFormasPago bit, CajeroBotonMonedas bit, CajeroBotonSaldoCajas bit, CajeroBotonVendedores bit, CajeroCancelarMovsCaja bit, CajeroCancelarVentaActual bit, CajeroCapacidades bit, CajeroCapacidadesEspeciales bit, CajeroConfigurarAdmin bit, CajeroEditarTipoCambio bit, CajeroModificarRango bit, CajeroMovCorteCaja bit, CajeroMovFondoInicial bit, CajeroMovRecoleccion bit, CajeroMovsAlmacen bit, CajeroMovsPermitidos bit, CajeroPassword bit, CajeroReimprimirNota bit, CajeroUsarAdmin bit, FormaPagoAceptarCambio bit, FormaPagoDesglosar bit, FormaPagoMonedaEspecifica varchar(100), FormaPagoRecolectar bit, CajeroMovAjusteSaldo bit, CajeroVencimContrasena datetime)
WHERE Sucursal = @Sucursal
IF @@ERROR <> 0 SELECT @Ok = 1
/*Procesar*/ 
SET IDENTITY_INSERT crMov ON
IF @Sesion IS NULL
BEGIN
INSERT crMov (Sucursal, ID, FechaRegistro, Tipo, Cxc, Folio, FechaEmision, Estatus, Caja, CajaRef, Banco, Cajero, ClienteSucursal, Cliente, ClienteIntelisis, Referencia, Corte, FechaD, FechaA, Vencimiento, Concepto, FechaBanco, Enviado, CajeroCancelacion, OrigenID, OrigenTipo, OrigenFolio, Proveedor, ListaPrecios, CFDGenerado, CFDID, CFDSerie, CFDFolio) 
SELECT        Sucursal, ID, FechaRegistro, Tipo, Cxc, Folio, FechaEmision, Estatus, Caja, CajaRef, Banco, Cajero, ClienteSucursal, Cliente, ClienteIntelisis, Referencia, Corte, FechaD, FechaA, Vencimiento, Concepto, FechaBanco, Enviado, CajeroCancelacion, OrigenID, OrigenTipo, OrigenFolio, Proveedor, ListaPrecios, CFDGenerado, CFDID, CFDSerie, CFDFolio  
FROM OPENXML (@ixml, 'CR/crMov/row')
WITH (Sucursal int, ID int, FechaRegistro datetime, Tipo varchar(20), Cxc bit, Folio int, FechaEmision datetime, Estatus char(15), Caja int, CajaRef int, Banco int, Cajero int, ClienteSucursal int, Cliente int, ClienteIntelisis varchar(10), Referencia varchar(50), Corte int, FechaD datetime, FechaA datetime, Vencimiento datetime, Concepto varchar(50), FechaBanco datetime, Enviado bit, CajeroCancelacion int, OrigenID int, OrigenTipo varchar(20), OrigenFolio int, Proveedor int, ListaPrecios varchar(20), CFDGenerado bit, CFDID int, CFDSerie varchar(20), CFDFolio varchar(20))
WHERE Sucursal = @Sucursal
IF @@ERROR <> 0 SELECT @Ok = 1
END ELSE
BEGIN
INSERT crMov (Sucursal, ID, FechaRegistro, Tipo, Cxc, Folio, FechaEmision, Estatus, Caja, CajaRef, Banco, Cajero, ClienteSucursal, Cliente, ClienteIntelisis, Referencia, Corte, FechaD, FechaA, Vencimiento, Concepto, FechaBanco, Enviado, CajeroCancelacion, OrigenID, OrigenTipo, OrigenFolio, Proveedor, ListaPrecios, CFDGenerado, CFDID, CFDSerie, CFDFolio) 
SELECT        Sucursal, ID, FechaRegistro, Tipo, Cxc, Folio, FechaEmision, Estatus, Caja, CajaRef, Banco, Cajero, ClienteSucursal, Cliente, ClienteIntelisis, Referencia, Corte, FechaD, FechaA, Vencimiento, Concepto, FechaBanco, Enviado, CajeroCancelacion, OrigenID, OrigenTipo, OrigenFolio, Proveedor, ListaPrecios, CFDGenerado, CFDID, CFDSerie, CFDFolio  
FROM crMovTemp
WHERE Sesion = @Sesion
IF @@ERROR <> 0 SELECT @Ok = 1
END
SET IDENTITY_INSERT crMov OFF
/*Procesar*/ 
SET IDENTITY_INSERT crMovD ON
IF @Sesion IS NULL
BEGIN
INSERT crMovD (Sucursal, ID, RID, Tipo, Vendedor, FormaPago, Referencia, Articulo, SubCuenta, Departamento, Cantidad, Descuento1, Descuento2, Importe, Moneda, TipoCambio, Concepto, Unidad, Codigo, Ubicacion, Posicion, RenglonTipo, UsuarioAutorizacion, EsJuego, PrecioEspecial, PrecioNormal, Cancelado, Costo, TarjetaBanco, TarjetaTipo)
SELECT         Sucursal, ID, RID, Tipo, Vendedor, FormaPago, Referencia, Articulo, SubCuenta, Departamento, Cantidad, Descuento1, Descuento2, Importe, Moneda, TipoCambio, Concepto, Unidad, Codigo, Ubicacion, Posicion, RenglonTipo, UsuarioAutorizacion, EsJuego, PrecioEspecial, PrecioNormal, Cancelado, Costo, TarjetaBanco, TarjetaTipo
FROM OPENXML (@ixml, 'CR/crMovD/row')
WITH (Sucursal int, ID int, RID int, Tipo varchar(20), Vendedor int, FormaPago int, Referencia varchar(50), Articulo varchar(20), SubCuenta varchar(50), Departamento int, Cantidad float, Descuento1 float, Descuento2 float, Importe money, Moneda int, TipoCambio float, Concepto varchar(50), Unidad varchar(50), Codigo varchar(30), Ubicacion varchar(10), Posicion varchar(10), RenglonTipo char(1), UsuarioAutorizacion varchar(10), EsJuego bit, PrecioEspecial bit, PrecioNormal float, Cancelado bit, Costo money, TarjetaBanco varchar(20), TarjetaTipo varchar(20))
WHERE Sucursal = @Sucursal
IF @@ERROR <> 0 SELECT @Ok = 1
END ELSE
BEGIN
INSERT crMovD (Sucursal, ID, RID, Tipo, Vendedor, FormaPago, Referencia, Articulo, SubCuenta, Departamento, Cantidad, Descuento1, Descuento2, Importe, Moneda, TipoCambio, Concepto, Unidad, Codigo, Ubicacion, Posicion, RenglonTipo, UsuarioAutorizacion, EsJuego, PrecioEspecial, PrecioNormal, Cancelado, Costo)
SELECT         Sucursal, ID, RID, Tipo, Vendedor, FormaPago, Referencia, Articulo, SubCuenta, Departamento, Cantidad, Descuento1, Descuento2, Importe, Moneda, TipoCambio, Concepto, Unidad, Codigo, Ubicacion, Posicion, RenglonTipo, UsuarioAutorizacion, EsJuego, PrecioEspecial, PrecioNormal, Cancelado, Costo
FROM crMovDTemp
WHERE Sesion = @Sesion
IF @@ERROR <> 0 SELECT @Ok = 1
END
SET IDENTITY_INSERT crMovD OFF
/*IF @CRTipoCreditoCxc = 0
BEGIN*/
DELETE crCte WHERE Sucursal = @Sucursal AND ID IN (SELECT ID FROM OPENXML (@ixml, 'CR/crCte/row') WITH (Sucursal int, ID int) WHERE Sucursal = @Sucursal)
SET IDENTITY_INSERT crCte ON
INSERT crCte (Sucursal, ID, Nombre, Estatus, Direccion, EntreCalles, Delegacion, Colonia, Poblacion, Estado, Pais, Zona, CodigoPostal, RFC, CURP, Telefonos, Observaciones, Publico, Descuento, Tipo)
SELECT        Sucursal, ID, Nombre, Estatus, Direccion, EntreCalles, Delegacion, Colonia, Poblacion, Estado, Pais, Zona, CodigoPostal, RFC, CURP, Telefonos, Observaciones, Publico, Descuento, Tipo
FROM OPENXML (@ixml, 'CR/crCte/row')
WITH (Sucursal int, ID int, Nombre varchar(100), Estatus char(15), Direccion varchar(100), EntreCalles varchar(100), Delegacion varchar(30), Colonia varchar(30), Poblacion varchar(30), Estado varchar(30), Pais varchar(30), Zona varchar(30), CodigoPostal varchar(15), RFC varchar(15), CURP varchar(30), Telefonos varchar(100), Observaciones varchar(100), Publico bit, Descuento float, Tipo varchar(15))
WHERE Sucursal = @Sucursal
IF @@ERROR <> 0 SELECT @Ok = 1
SET IDENTITY_INSERT crCte OFF
/*END ELSE
BEGIN*/
/*Procesar*/ 
SET IDENTITY_INSERT crMovSoporte ON
INSERT crMovSoporte (Sucursal, ID, FechaRegistro, Corte, Mov, FechaEmision, Estatus, Caja, Cajero, ClienteIntelisis, Contacto, Telefono, Titulo, Problema, Enviado)
SELECT               Sucursal, ID, FechaRegistro, Corte, Mov, FechaEmision, Estatus, Caja, Cajero, ClienteIntelisis, Contacto, Telefono, Titulo, Problema, Enviado
FROM OPENXML (@ixml, 'CR/crMovSoporte/row')
WITH (Sucursal int, ID int, FechaRegistro datetime, Corte int, Mov varchar(20), FechaEmision datetime, Estatus char(15), Caja int, Cajero int, ClienteIntelisis varchar(10), Contacto varchar(50), Telefono varchar(30), Titulo varchar(100), Problema text, Enviado bit)
WHERE Sucursal = @Sucursal
IF @@ERROR <> 0 SELECT @Ok = 1
SET IDENTITY_INSERT crMovSoporte OFF
/*END*/
/*Procesar*/ 
SET IDENTITY_INSERT crBitacora ON
INSERT crBitacora (Sucursal, ID, FechaRegistro, FechaEmision, Mensaje)
SELECT             Sucursal, ID, FechaRegistro, FechaEmision, Mensaje
FROM OPENXML (@ixml, 'CR/crBitacora/row')
WITH (Sucursal int, ID int, FechaRegistro datetime, FechaEmision datetime, Mensaje varchar(255))
WHERE Sucursal = @Sucursal
IF @@ERROR <> 0 SELECT @Ok = 1
SET IDENTITY_INSERT crBitacora OFF
END
EXEC sp_xml_removedocument @ixml
IF /*@Procesar = 1 AND */@Ok IS NULL
BEGIN
SELECT @Moneda 	 = m.Moneda,
@TipoCambio = m.TipoCambio
FROM EmpresaCfg cfg, Mon m
WHERE Empresa = @Empresa AND Moneda = cfg.ContMoneda
SELECT @CorteCajaMov        = CRCorteCaja,
@CorteCajaCentralMov = CRCorteCajaCentral
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
CREATE TABLE #CRVenta (
Articulo	char(20)	COLLATE Database_Default NULL,
SubCuenta	varchar(50)	COLLATE Database_Default NULL,
Operaciones	int		NULL,
Cantidad	float		NULL,
DescuentoLinea	float		NULL,
Importe		money		NULL,
Almacen		varchar(10)	COLLATE Database_Default NULL,
Posicion	varchar(10)	COLLATE Database_Default NULL,
Cliente		varchar(10)	COLLATE Database_Default NULL,
Cxc		bit		NULL,
Mov		varchar(20)	COLLATE Database_Default NULL,
MovID		varchar(20)	COLLATE Database_Default NULL,
CFDSerie	varchar(20)	COLLATE Database_Default NULL, 
CFDFolio	varchar(20) COLLATE Database_Default NULL) 
CREATE TABLE #CRVenta2 (
Renglon		float		NULL,
Articulo	char(20)	COLLATE Database_Default NULL,
SubCuenta	varchar(50)	COLLATE Database_Default NULL,
Operaciones	int		NULL,
Cantidad	float		NULL,
DescuentoLinea	float		NULL,
Importe		money		NULL,
Almacen		varchar(10)	COLLATE Database_Default NULL,
Posicion	varchar(10)	COLLATE Database_Default NULL,
Cliente		varchar(10)	COLLATE Database_Default NULL,
Cxc		bit		NULL,
Mov		varchar(20)	COLLATE Database_Default NULL,
MovID		varchar(20)	COLLATE Database_Default NULL,
CFDSerie	varchar(20)	COLLATE Database_Default NULL, 
CFDFolio	varchar(20) COLLATE Database_Default NULL) 
CREATE TABLE #CRAgente (
Renglon		float		NULL,
Agente		char(10)	COLLATE Database_Default NULL,
Operaciones	int		NULL,
Cantidad	float		NULL,
Importe		money		NULL)
CREATE TABLE #CRCobro (
Renglon		float		NULL,
FormaPago	varchar(50)	COLLATE Database_Default NULL,
Referencia	varchar(50)	COLLATE Database_Default NULL,
Importe		money		NULL,
Moneda		char(10)	COLLATE Database_Default NULL,
TipoCambio	float		NULL,
Cliente		varchar(10)	COLLATE Database_Default NULL,
Cxc		bit		NULL,
Vencimiento	datetime	NULL,
CFDSerie	varchar(20)	COLLATE Database_Default NULL, 
CFDFolio	varchar(20) COLLATE Database_Default NULL) 
CREATE TABLE #CRCaja (
Renglon		float		NULL,
CtaDinero	char(10)	COLLATE Database_Default NULL,
Movimiento	varchar(20)	COLLATE Database_Default NULL,
Concepto	varchar(50)	COLLATE Database_Default NULL,
FormaPago	varchar(50)	COLLATE Database_Default NULL,
Referencia	varchar(50)	COLLATE Database_Default NULL,
Importe		money		NULL,
Moneda		char(10)	COLLATE Database_Default NULL,
TipoCambio	float		NULL,
FechaBanco	datetime	NULL)
CREATE TABLE #CRInvFisico (
Renglon		float		NULL,
Articulo	char(20)	COLLATE Database_Default NULL,
SubCuenta	varchar(50)	COLLATE Database_Default NULL,
Cantidad	float		NULL,
Unidad		varchar(50)	COLLATE Database_Default NULL,
Posicion	varchar(10)	COLLATE Database_Default NULL)
CREATE TABLE #CRSoporte (
Renglon		float		NULL,
Mov		varchar(20)	COLLATE Database_Default NULL,
Cliente		varchar(10)	COLLATE Database_Default NULL,
Contacto	varchar(50)	COLLATE Database_Default NULL,
Telefono	varchar(30)	COLLATE Database_Default NULL,
Titulo		varchar(100)	COLLATE Database_Default NULL,
Problema	text		NULL)
SELECT @CtaCajaCentral = NULLIF(RTRIM(ClaveIntelisis), '') FROM crCta WHERE Sucursal = @Sucursal AND Tipo = 'Caja' AND Numero = @CajaCentral
IF @CtaCajaCentral IS NULL SELECT @Ok = 10510, @OkRef = CONVERT(varchar, @CajaCentral)
DECLARE crCRMov CURSOR LOCAL FOR
SELECT ID, Caja, CajaRef, Folio, Banco, Cajero, Referencia, FechaD, FechaA
FROM crMov
WHERE Sucursal = @Sucursal AND FechaEmision = @FechaTrabajo AND Estatus = 'CONCLUIDO' AND ((Tipo = 'Corte' AND Caja <> @CajaCentral) OR (Tipo = 'Cierre' AND Caja = @CajaCentral))
OPEN crCRMov
FETCH NEXT FROM crCRMov INTO @ID, @Caja, @CajaRef, @CajaFolio, @Banco, @Cajero, @Referencia, @FechaD, @FechaA
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Caja = @CajaCentral SELECT @CRMov = @CorteCajaCentralMov ELSE SELECT @CRMov = @CorteCajaMov
SELECT @CtaCaja = NULLIF(RTRIM(ClaveIntelisis), '') FROM crCta WHERE Sucursal = @Sucursal AND Tipo = 'Caja' AND Numero = @Caja
IF @CtaCaja IS NULL SELECT @Ok = 10510, @OkRef = CONVERT(varchar, @Caja)
SELECT @CtaCajero = NULLIF(RTRIM(ClaveIntelisis), '') FROM crCta WHERE Sucursal = @Sucursal AND Tipo = 'Cajero' AND Numero = @Cajero
IF @CtaCajero IS NULL SELECT @Ok = 10515, @OkRef = CONVERT(varchar, @Cajero)
IF @Ok IS NULL
BEGIN
SELECT @DocFuente = NULLIF(COUNT(DISTINCT d.Referencia + '-' + Convert(varchar, d.Vendedor)), 0)
FROM crMov m, crMovD d
WHERE d.Sucursal = @Sucursal AND d.ID = m.ID
AND m.Sucursal = @Sucursal AND m.Corte = @ID
AND m.Tipo <> 'Redondeo'
AND m.Caja = @Caja
AND d.Tipo = 'Venta'
AND m.Estatus <> 'CANCELADO'
SELECT @SQL = N'EXEC '
IF @CRProcesoDistribuido = 1 SELECT @SQL = @SQL + @CRServidorOperaciones+'.'+@CRBaseDatosOperaciones+'.dbo.'
SELECT @SQL = @SQL + N'spInsertarCR @CRID OUTPUT, @Sucursal, @Empresa, @CRMov, @Moneda, @TipoCambio, @FechaTrabajo, @CtaCaja, @CajaFolio, @CtaCajero, @FechaD, @FechaA, @Referencia, @CREstatusSinAfectar, @DocFuente, @Usuario, @Ok OUTPUT, @OkRef OUTPUT'
SELECT @Params = N'@CRID int OUTPUT, @Sucursal int, @Empresa varchar(5), @CRMov varchar(20), @Moneda varchar(10),@TipoCambio float,  @FechaTrabajo datetime,  @CtaCaja varchar(10),  @CajaFolio int,  @CtaCajero varchar(10), @FechaD datetime,  @FechaA datetime,  @Referencia varchar(50),  @CREstatusSinAfectar varchar(15),  @DocFuente int,  @Usuario varchar(10), @Ok int OUTPUT, @OkRef varchar(255) OUTPUT'
EXEC sp_executesql @SQL, @Params, @CRID OUTPUT, @Sucursal, @Empresa, @CRMov, @Moneda, @TipoCambio, @FechaTrabajo, @CtaCaja, @CajaFolio, @CtaCajero, @FechaD, @FechaA, @Referencia, @CREstatusSinAfectar, @DocFuente, @Usuario, @Ok OUTPUT, @OkRef OUTPUT
/*,
INSERT CR (Sucursal,  SucursalOrigen, Empresa,  Mov,    Moneda,  TipoCambio,  FechaEmision,  Caja,     CajaFolio,  Cajero,     FechaD,  FechaA,  Referencia,  Estatus,              DocFuente,  Usuario)
VALUES (@Sucursal, @Sucursal,      @Empresa, @CRMov, @Moneda, @TipoCambio, @FechaTrabajo, @CtaCaja, @CajaFolio, @CtaCajero, @FechaD, @FechaA, @Referencia, @CREstatusSinAfectar, @DocFuente, @Usuario)
SELECT @CRID = SCOPE_IDENTITY()
*/
TRUNCATE TABLE #CRVenta
TRUNCATE TABLE #CRVenta2
/* VENTAS Y DEVOLUCIONES POR DEPARTAMENTO */
INSERT #CRVenta (
Articulo,         SubCuenta,   Almacen,    Posicion, Cliente,             Cxc,
Operaciones,
Cantidad,
DescuentoLinea,
Importe,
CFDSerie, 
CFDFolio) 
SELECT c.ClaveIntelisis, d.SubCuenta, d.Ubicacion, d.Posicion, m.ClienteIntelisis, m.Cxc,
Count(d.ID),
SUM(d.Cantidad),
100.0-((SUM(CONVERT(float, d.Importe)*(1-(ISNULL(d.Descuento1, 0.0)/100.0))*(1-(ISNULL(d.Descuento2, 0.0)/100.0)))/NULLIF(SUM(CONVERT(float, d.Importe)), 0.0))*100.0),
SUM(d.Importe*(1-(ISNULL(d.Descuento1, 0.0)/100.0))*(1-(ISNULL(d.Descuento2, 0.0)/100.0))),
ISNULL(m.CFDSerie,''), 
ISNULL(m.CFDFolio,'')  
FROM crMovD d, crMov m, crCta c
WHERE d.Sucursal = @Sucursal AND d.ID = m.ID
AND m.Sucursal = @Sucursal AND m.Corte = @ID
AND d.Tipo = 'Venta'
AND c.Sucursal = @Sucursal AND c.Numero = d.Departamento AND c.Tipo = 'Departamento'
GROUP BY m.ClienteIntelisis, m.Cxc, c.Nombre, c.ClaveIntelisis, d.Ubicacion, d.Posicion, d.SubCuenta, d.Descuento1, d.Descuento2, ISNULL(m.CFDSerie,''), ISNULL(m.CFDFolio,'') 
ORDER BY m.ClienteIntelisis, m.Cxc, c.Nombre, c.ClaveIntelisis, d.Ubicacion, d.Posicion, d.SubCuenta, d.Descuento1, d.Descuento2, ISNULL(m.CFDSerie,''), ISNULL(m.CFDFolio,'') 
INSERT #CRVenta (
Articulo,         SubCuenta,   Almacen,    Posicion, Cliente,             Cxc,
Operaciones,
Cantidad,
DescuentoLinea,
Importe,
CFDSerie, 
CFDFolio) 
SELECT c.ClaveIntelisis, d.SubCuenta, d.Ubicacion, d.Posicion, m.ClienteIntelisis, m.Cxc,
Count(d.ID),
-SUM(d.Cantidad),
100.0-((SUM(CONVERT(float, d.Importe)*(1-(ISNULL(d.Descuento1, 0.0)/100.0))*(1-(ISNULL(d.Descuento2, 0.0)/100.0)))/NULLIF(SUM(CONVERT(float, d.Importe)), 0.0))*100.0),
-SUM(d.Importe*(1-(ISNULL(d.Descuento1, 0.0)/100.0))*(1-(ISNULL(d.Descuento2, 0.0)/100.0))),
ISNULL(m.CFDSerie,''), 
ISNULL(m.CFDFolio,'')  
FROM crMovD d, crMov m, crCta c
WHERE d.Sucursal = @Sucursal AND d.ID = m.ID
AND m.Sucursal = @Sucursal AND m.Corte = @ID
AND d.Tipo = 'Devolucion'
AND c.Sucursal = @Sucursal AND c.Numero = d.Departamento AND c.Tipo = 'Departamento'
GROUP BY m.ClienteIntelisis, m.Cxc, c.Nombre, c.ClaveIntelisis, d.Ubicacion, d.Posicion, d.SubCuenta, d.Descuento1, d.Descuento2, ISNULL(m.CFDSerie,''), ISNULL(m.CFDFolio,'') 
ORDER BY m.ClienteIntelisis, m.Cxc, c.Nombre, c.ClaveIntelisis, d.Ubicacion, d.Posicion, d.SubCuenta, d.Descuento1, d.Descuento2, ISNULL(m.CFDSerie,''), ISNULL(m.CFDFolio,'') 
/* VENTAS POR ARTICULO */
INSERT #CRVenta (
Articulo,   SubCuenta,   Almacen,     Posicion, Cliente,            Cxc,
Mov, MovID,
Operaciones,
Cantidad,
DescuentoLinea,
Importe,
CFDSerie, 
CFDFolio) 
SELECT d.Articulo, d.SubCuenta, d.Ubicacion, d.Posicion, m.ClienteIntelisis, m.Cxc,
d.Tipo, @Prefijo+CONVERT(varchar(20), m.Folio),
Count(d.ID),
SUM(d.Cantidad),
100.0-((SUM(CONVERT(float, d.Importe)*(1-(ISNULL(d.Descuento1, 0.0)/100.0))*(1-(ISNULL(d.Descuento2, 0.0)/100.0)))/NULLIF(SUM(CONVERT(float, d.Importe)), 0.0))*100.0),
SUM(d.Importe*(1-(ISNULL(d.Descuento1, 0.0)/100.0))*(1-(ISNULL(d.Descuento2, 0.0)/100.0))),
ISNULL(m.CFDSerie,''), 
ISNULL(m.CFDFolio,'')  
FROM crMovD d, crMov m
WHERE d.Sucursal = @Sucursal AND d.ID = m.ID
AND m.Sucursal = @Sucursal AND m.Corte = @ID
AND d.Tipo IN ('Venta', 'Servicio', 'Factura')
AND NULLIF(RTRIM(d.Articulo), '') IS NOT NULL
GROUP BY d.Tipo, m.Folio, m.ClienteIntelisis, m.Cxc, d.Articulo, d.Ubicacion, d.Posicion, d.SubCuenta, d.Descuento1, d.Descuento2, ISNULL(m.CFDSerie,''), ISNULL(m.CFDFolio,'') 
ORDER BY d.Tipo, m.Folio, m.ClienteIntelisis, m.Cxc, d.Articulo, d.Ubicacion, d.Posicion, d.SubCuenta, d.Descuento1, d.Descuento2, ISNULL(m.CFDSerie,''), ISNULL(m.CFDFolio,'') 
INSERT #CRVenta (
Articulo,   SubCuenta,   Almacen,     Posicion, Cliente,            Cxc,
Mov, MovID,
Operaciones,
Cantidad,
DescuentoLinea,
Importe,
CFDSerie, 
CFDFolio) 
SELECT d.Articulo, d.SubCuenta, d.Ubicacion, d.Posicion, m.ClienteIntelisis, m.Cxc,
d.Tipo, @Prefijo+CONVERT(varchar(20), m.Folio),
Count(d.ID),
-SUM(d.Cantidad),
100.0-((SUM(CONVERT(float, d.Importe)*(1-(ISNULL(d.Descuento1, 0.0)/100.0))*(1-(ISNULL(d.Descuento2, 0.0)/100.0)))/SUM(CONVERT(float, d.Importe)))*100.0),
-SUM(d.Importe*(1-(ISNULL(d.Descuento1, 0.0)/100.0))*(1-(ISNULL(d.Descuento2, 0.0)/100.0))),
ISNULL(m.CFDSerie,''), 
ISNULL(m.CFDFolio,'')  
FROM crMovD d, crMov m
WHERE d.Sucursal = @Sucursal AND d.ID = m.ID
AND m.Sucursal = @Sucursal AND m.Corte = @ID
AND d.Tipo IN ('Devolucion', 'Bonificacion')
AND NULLIF(RTRIM(d.Articulo), '') IS NOT NULL
GROUP BY d.Tipo, m.Folio, m.ClienteIntelisis, m.Cxc, d.Articulo, d.Ubicacion, d.Posicion, d.SubCuenta, d.Descuento1, d.Descuento2, ISNULL(m.CFDSerie,''), ISNULL(m.CFDFolio,'') 
ORDER BY d.Tipo, m.Folio, m.ClienteIntelisis, m.Cxc, d.Articulo, d.Ubicacion, d.Posicion, d.SubCuenta, d.Descuento1, d.Descuento2, ISNULL(m.CFDSerie,''), ISNULL(m.CFDFolio,'') 
/*INSERT #CRVenta (Articulo, Operaciones, Cantidad, Importe)
SELECT @ArtRedondeo, Count(d.ID), 1, SUM(-d.Importe)
FROM crMovD d, crMov m
WHERE d.Sucursal = @Sucursal AND d.ID = m.ID
AND m.Sucursal = @Sucursal AND m.Corte = @ID
AND m.Tipo = 'Redondeo'*/
UPDATE #CRVenta SET Mov = 'Nota Importe',  MovID = NULL WHERE Mov = 'Bonificacion' AND NULLIF(CFDFolio,'') IS NULL AND NULLIF(CFDSerie,'') IS NULL 
UPDATE #CRVenta SET Mov = 'Nota',          MovID = NULL WHERE Mov IN ('Venta', 'Devolucion') AND NULLIF(CFDFolio,'') IS NULL AND NULLIF(CFDSerie,'') IS NULL 
UPDATE #CRVenta SET Mov = 'Nota Servicio', MovID = NULL WHERE Mov = 'Servicio' AND NULLIF(CFDFolio,'') IS NULL AND NULLIF(CFDSerie,'') IS NULL 
UPDATE #CRVenta SET Mov = 'Factura Mostrador' WHERE Mov = 'Factura' AND Cxc = 0 AND NULLIF(CFDFolio,'') IS NULL AND NULLIF(CFDSerie,'') IS NULL 
UPDATE #CRVenta SET Mov = 'Factura Mostrador' WHERE Mov IN ('Venta','Devolucion') AND Cxc = 0 AND NULLIF(CFDFolio,'') IS NOT NULL AND NULLIF(CFDSerie,'') IS NOT NULL 
INSERT #CRVenta2 (Articulo, SubCuenta, Almacen, Posicion, Cliente, Cxc, Mov, MovID, Operaciones, Cantidad, DescuentoLinea, Importe,     CFDSerie, CFDFolio) 
SELECT Articulo, SubCuenta, Almacen, Posicion, Cliente, Cxc, Mov, MovID, SUM(Operaciones), SUM(Cantidad), DescuentoLinea, SUM(Importe), CFDSerie, CFDFolio  
FROM #CRVenta
GROUP BY Articulo, SubCuenta, DescuentoLinea, Almacen, Posicion, Cliente, Cxc, Mov, MovID, CFDSerie, CFDFolio 
ORDER BY Articulo, SubCuenta, DescuentoLinea, Almacen, Posicion, Cliente, Cxc, Mov, MovID, CFDSerie, CFDFolio 
EXEC spCRVenta @CRID, @Sucursal, @Almacen, @CRProcesoDistribuido, @CRServidorOperaciones, @CRBaseDatosOperaciones, @Ok OUTPUT, @OkRef OUTPUT
TRUNCATE TABLE #CRAgente
INSERT #CRAgente (Agente, Operaciones, Cantidad, Importe)
SELECT c.ClaveIntelisis,
Count(d.ID),
SUM(d.Cantidad),
SUM(d.Importe*(1-(ISNULL(d.Descuento1, 0.0)/100.0))*(1-(ISNULL(d.Descuento2, 0.0)/100.0)))
FROM crMovD d, crMov m, crCta c
WHERE d.Sucursal = @Sucursal AND d.ID = m.ID
AND m.Sucursal = @Sucursal AND m.Corte = @ID
AND d.Tipo = 'Venta'
AND c.Sucursal = @Sucursal AND c.Numero = d.Vendedor AND c.Tipo = 'Vendedor'
GROUP BY c.Nombre, c.ClaveIntelisis
ORDER BY c.Nombre
INSERT #CRAgente (Agente, Operaciones, Cantidad, Importe)
SELECT c.ClaveIntelisis,
Count(d.ID),
-SUM(d.Cantidad),
-SUM(d.Importe*(1-(ISNULL(d.Descuento1, 0.0)/100.0))*(1-(ISNULL(d.Descuento2, 0.0)/100.0)))
FROM crMovD d, crMov m, crCta c
WHERE d.Sucursal = @Sucursal AND d.ID = m.ID
AND m.Sucursal = @Sucursal AND m.Corte = @ID
AND d.Tipo = 'Devolucion'
AND c.Sucursal = @Sucursal AND c.Numero = d.Vendedor AND c.Tipo = 'Vendedor'
GROUP BY c.Nombre, c.ClaveIntelisis
ORDER BY c.Nombre
EXEC spCRAgente @CRID, @Sucursal, @CRProcesoDistribuido, @CRServidorOperaciones, @CRBaseDatosOperaciones, @Ok OUTPUT, @OkRef OUTPUT
TRUNCATE TABLE #CRCobro
INSERT #CRCobro (FormaPago,        Referencia,   Moneda,             TipoCambio,   Cliente,            Cxc,   Vencimiento,   Importe,                                                        CFDSerie,            CFDFolio) 
SELECT           c.ClaveIntelisis, d.Referencia, mon.ClaveIntelisis, d.TipoCambio, m.ClienteIntelisis, m.Cxc, m.Vencimiento, SUM(CASE WHEN d.Tipo = 'Cobro' THEN Importe ELSE -Importe END), ISNULL(CFDSerie,''), ISNULL(CFDFolio,'') 
FROM crMovD d, crMov m, crCta c, crCta mon
WHERE d.Sucursal = @Sucursal AND d.ID = m.ID
AND m.Sucursal = @Sucursal AND m.Corte = @ID
AND m.Tipo IN ('Venta', 'Servicio', 'Factura', 'Devolucion', 'Bonificacion')
AND d.Tipo IN ('Cobro', 'Pago')
AND c.Sucursal = @Sucursal AND c.Numero = d.FormaPago AND c.Tipo = 'Forma Pago'
AND mon.Sucursal = @Sucursal AND mon.Numero = d.Moneda AND mon.Tipo = 'Moneda'
GROUP BY m.ClienteIntelisis, m.Cxc, m.Vencimiento, c.ClaveIntelisis, d.Referencia, mon.ClaveIntelisis, d.TipoCambio, ISNULL(m.CFDSerie,''), ISNULL(m.CFDFolio,'') 
ORDER BY m.ClienteIntelisis, m.Cxc, m.Vencimiento, c.ClaveIntelisis, d.Referencia, mon.ClaveIntelisis, d.TipoCambio, ISNULL(m.CFDSerie,''), ISNULL(m.CFDFolio,'') 
EXEC spCRCobro @CRID, @Sucursal, @CRProcesoDistribuido, @CRServidorOperaciones, @CRBaseDatosOperaciones, @Ok OUTPUT, @OkRef OUTPUT
TRUNCATE TABLE #CRCaja
IF @Caja = @CajaCentral
BEGIN
INSERT #CRCaja (Movimiento, CtaDinero,        Concepto,   FormaPago,         Referencia,   Moneda,             FechaBanco,  TipoCambio,   Importe)
SELECT           m.Tipo,    c.ClaveIntelisis, d.Concepto, fp.ClaveIntelisis, d.Referencia, mon.ClaveIntelisis, m.FechaBanco, d.TipoCambio, /*SUM(*/d.Importe/*)*/
FROM crMov m, crMovD d, crCta fp, crCta c, crCta mon
WHERE d.Sucursal = @Sucursal AND d.ID = m.ID
AND m.Sucursal = @Sucursal AND m.Corte = @ID
AND m.Tipo IN ('Deposito', 'Retiro')
AND c.Sucursal = @Sucursal AND c.Numero = m.Banco AND c.Tipo = 'Banco'
AND fp.Sucursal = @Sucursal AND fp.Numero = d.FormaPago AND fp.Tipo = 'Forma Pago'
AND mon.Sucursal = @Sucursal AND mon.Numero = d.Moneda AND mon.Tipo = 'Moneda'
AND NULLIF(d.Importe, 0) IS NOT NULL
INSERT #CRCaja (Movimiento, Concepto,   FormaPago,         Referencia,   Moneda,             TipoCambio,   Importe)
SELECT           m.Tipo,    d.Concepto, fp.ClaveIntelisis, d.Referencia, mon.ClaveIntelisis, d.TipoCambio, SUM(d.Importe)
FROM crMov m, crMovD d, crCta fp, crCta mon
WHERE d.Sucursal = @Sucursal AND d.ID = m.ID
AND m.Sucursal = @Sucursal AND m.Corte = @ID
AND m.Tipo IN ('Sobrante', 'Faltante')
AND fp.Sucursal = @Sucursal AND fp.Numero = d.FormaPago AND fp.Tipo = 'Forma Pago'
AND mon.Sucursal = @Sucursal AND mon.Numero = d.Moneda AND mon.Tipo = 'Moneda'
GROUP BY m.Tipo, fp.ClaveIntelisis, d.Concepto, d.Referencia, mon.ClaveIntelisis, d.TipoCambio
ORDER BY m.Tipo, fp.ClaveIntelisis, d.Concepto, d.Referencia, mon.ClaveIntelisis, d.TipoCambio
END ELSE
BEGIN
INSERT #CRCaja (Movimiento, Concepto, CtaDinero, FormaPago, Referencia, Moneda, TipoCambio, Importe)
SELECT m.Tipo, d.Concepto, c.ClaveIntelisis, fp.ClaveIntelisis,  m.Referencia, mon.ClaveIntelisis, d.TipoCambio, SUM(CASE d.Tipo WHEN 'Pago' THEN -d.Importe ELSE d.Importe END)
FROM crMov m, crMovD d, crCta fp, crCta c, crCta mon
WHERE d.Sucursal = @Sucursal AND d.ID = m.ID
AND m.Sucursal = @Sucursal AND m.Corte = @ID
AND m.Tipo IN ('Cobro Credito', 'Dev. Anticipo Gasto', 'Devolucion Prestamo')
AND c.Sucursal = @Sucursal AND c.Numero = m.CajaRef AND c.Tipo = 'Caja'
AND fp.Sucursal = @Sucursal AND fp.Numero = d.FormaPago AND fp.Tipo = 'Forma Pago'
AND mon.Sucursal = @Sucursal AND mon.Numero = d.Moneda AND mon.Tipo = 'Moneda'
GROUP BY m.Tipo, d.Concepto, c.ClaveIntelisis, fp.ClaveIntelisis, m.Referencia, mon.ClaveIntelisis, d.TipoCambio
ORDER BY m.Tipo, d.Concepto, c.ClaveIntelisis, fp.ClaveIntelisis, m.Referencia, mon.ClaveIntelisis, d.TipoCambio
INSERT #CRCaja (Movimiento, Concepto, CtaDinero, FormaPago, Referencia, Moneda, TipoCambio, Importe)
SELECT CASE WHEN m.Tipo = 'Corte' THEN 'Recoleccion' ELSE m.Tipo END, d.Concepto, c.ClaveIntelisis, fp.ClaveIntelisis,  m.Referencia, mon.ClaveIntelisis, d.TipoCambio, SUM(d.Importe)
FROM crMov m, crMovD d, crCta fp, crCta c, crCta mon
WHERE d.Sucursal = @Sucursal AND d.ID = m.ID
AND m.Sucursal = @Sucursal AND m.Corte = @ID
AND m.Tipo IN ('Fondo Inicial', 'Recoleccion', 'Corte', 'Sobrante', 'Faltante', 'Venta Credito', 'Anticipo Gasto', 'Prestamo', 'Aplicacion Credito')
AND c.Sucursal = @Sucursal AND c.Numero = m.CajaRef AND c.Tipo = 'Caja'
AND fp.Sucursal = @Sucursal AND fp.Numero = d.FormaPago AND fp.Tipo = 'Forma Pago'
AND mon.Sucursal = @Sucursal AND mon.Numero = d.Moneda AND mon.Tipo = 'Moneda'
GROUP BY m.Tipo, d.Concepto, c.ClaveIntelisis, fp.ClaveIntelisis, m.Referencia, mon.ClaveIntelisis, d.TipoCambio
ORDER BY m.Tipo, d.Concepto, c.ClaveIntelisis, fp.ClaveIntelisis, m.Referencia, mon.ClaveIntelisis, d.TipoCambio
INSERT #CRCaja (Movimiento, Concepto,   FormaPago,         Referencia,   Moneda,             TipoCambio,   Importe)
SELECT          m.Tipo,     m.Concepto, fp.ClaveIntelisis, m.Referencia, mon.ClaveIntelisis, d.TipoCambio, SUM(d.Importe)
FROM crMov m, crMovD d, crCta fp, crCta mon
WHERE d.Sucursal = @Sucursal AND d.ID = m.ID
AND m.Sucursal = @Sucursal AND m.Corte = @ID
AND m.Tipo IN ('Gasto', 'Devolucion Gasto')
AND fp.Sucursal = @Sucursal AND fp.Numero = d.FormaPago AND fp.Tipo = 'Forma Pago'
AND mon.Sucursal = @Sucursal AND mon.Numero = d.Moneda AND mon.Tipo = 'Moneda'
GROUP BY m.Tipo, m.Concepto, fp.ClaveIntelisis, m.Referencia, mon.ClaveIntelisis, d.TipoCambio
ORDER BY m.Tipo, m.Concepto, fp.ClaveIntelisis, m.Referencia, mon.ClaveIntelisis, d.TipoCambio
INSERT #CRCaja (Movimiento, Concepto,   Moneda,             TipoCambio,   Importe)
SELECT          m.Tipo,     m.Concepto, mon.ClaveIntelisis, d.TipoCambio, SUM(d.Importe)
FROM crMov m, crMovD d, crCta mon
WHERE d.Sucursal = @Sucursal AND d.ID = m.ID
AND m.Sucursal = @Sucursal AND m.Corte = @ID
AND m.Tipo = 'Redondeo'
AND mon.Sucursal = @Sucursal AND mon.Numero = d.Moneda AND mon.Tipo = 'Moneda'
GROUP BY m.Tipo, m.Concepto, mon.ClaveIntelisis, d.TipoCambio
ORDER BY m.Tipo, m.Concepto, mon.ClaveIntelisis, d.TipoCambio
END
EXEC spCRCaja @CRID, @Sucursal, @CRProcesoDistribuido, @CRServidorOperaciones, @CRBaseDatosOperaciones, @Ok OUTPUT, @OkRef OUTPUT
TRUNCATE TABLE #CRInvFisico
INSERT #CRInvFisico (Articulo, SubCuenta, Cantidad, Unidad, Posicion)
SELECT d.Articulo, d.SubCuenta, SUM(d.Cantidad), d.Unidad, d.Posicion
FROM crMovD d, crMov m
WHERE d.Sucursal = @Sucursal AND d.ID = m.ID
AND m.Sucursal = @Sucursal AND m.Corte = @ID
AND d.Tipo = 'Inventario Fisico'
AND NULLIF(RTRIM(d.Articulo), '') IS NOT NULL
GROUP BY d.Articulo, d.SubCuenta, d.Unidad, d.Posicion
ORDER BY d.Articulo, d.SubCuenta, d.Unidad, d.Posicion
EXEC spCRInvFisico @CRID, @Sucursal, @CRProcesoDistribuido, @CRServidorOperaciones, @CRBaseDatosOperaciones, @Ok OUTPUT, @OkRef OUTPUT
TRUNCATE TABLE #CRSoporte
INSERT #CRSoporte (Mov, Cliente, Contacto, Telefono, Titulo, Problema)
SELECT m.Mov, m.ClienteIntelisis, m.Contacto, m.Telefono, m.Titulo, m.Problema
FROM crMovSoporte m
WHERE m.Sucursal = @Sucursal AND m.Corte = @ID
EXEC spCRSoporte @CRID, @Sucursal, @CRProcesoDistribuido, @CRServidorOperaciones, @CRBaseDatosOperaciones, @Ok OUTPUT, @OkRef OUTPUT
/*IF NOT EXISTS(SELECT * FROM CRD WHERE ID = @CRID)
DELETE CR WHERE ID = @CRID
ELSE BEGIN*/
IF @CRAfectarAuto = 1 AND @Ok IS NULL
EXEC spCR @CRID, 'CR', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0,
@CRMov, @CRMovID OUTPUT, NULL, @Ok OUTPUT, @OkRef OUTPUT
/*END*/
END
END
FETCH NEXT FROM crCRMov INTO @ID, @Caja, @CajaRef, @CajaFolio, @Banco, @Cajero, @Referencia, @FechaD, @FechaA
END 
CLOSE crCRMov
DEALLOCATE crCRMov
END
IF /*@Procesar = 1 AND */@CRAfectarAuto = 1 AND @CRCerrarDiaAuto = 1 AND @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spCerrarDia @Empresa, @Sucursal, @FechaTrabajo, @Usuario, 0, 1, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
BEGIN
COMMIT TRANSACTION
SELECT @Mensaje = NULL
END ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT @Mensaje = RTRIM(Descripcion)+' '+ISNULL(@OkRef, '') FROM MensajeLista WHERE Mensaje = @Ok
END
IF @Sesion IS NOT NULL
BEGIN
DELETE crMovTemp WHERE Sesion = @Sesion
DELETE crMovDTemp WHERE Sesion = @Sesion
END
SELECT @Mensaje
RETURN
END

