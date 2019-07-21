SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarCFDSAT22
@Estacion	int,
@Modulo		char(5),
@ID		int,
@Layout		varchar(50),
@Validar	bit		= 0,
@Ok		int		= NULL OUTPUT,
@OkRef		varchar(255)	= NULL OUTPUT

AS BEGIN
DECLARE
@Empresa			char(5),
@EmpresaRFC			varchar(20),
@EmpresaNombre		varchar(100),
@EmpresaDireccion		varchar(100),
@EmpresaDireccionNumero	varchar(20),
@EmpresaDireccionNumeroInt	varchar(20),
@EmpresaColonia		varchar(100),
@EmpresaPoblacion		varchar(100),
@EmpresaObservaciones	varchar(100),
@EmpresaDelegacion		varchar(100),
@EmpresaEstado		varchar(30),
@EmpresaPais		varchar(30),
@EmpresaCodigoPostal	varchar(15),
@EmpresaRegistroPatronal	varchar(20),
@EmpresaGLN			varchar(50),
@EmpresaTelefonos		varchar(100),
@EmpresaEAN13		varchar(20),
@EmpresaDUN14		varchar(20),
@EmpresaSKUCliente		varchar(20),
@EmpresaSKUEmpresa		varchar(20),
@EmpresaSKUCodigoInterno	bit,
@SucursalNombre		varchar(100),
@SucursalGLN		varchar(50),
@SucursalDireccion		varchar(100),
@SucursalDireccionNumero	varchar(20),
@SucursalDireccionNumeroInt	varchar(20),
@SucursalColonia		varchar(100),
@SucursalPoblacion		varchar(100),
@SucursalObservaciones	varchar(100),
@SucursalDelegacion		varchar(100),
@SucursalEstado		varchar(30),
@SucursalPais		varchar(30),
@SucursalCodigoPostal	varchar(15),
@ClienteRFC			varchar(20),
@ClienteNombre		varchar(100),
@ClienteDireccion		varchar(255),
@ClienteDireccionNumero	varchar(20),
@ClienteDireccionNumeroInt	varchar(20),
@ClienteColonia		varchar(100),
@ClientePoblacion		varchar(100),
@ClienteObservaciones	varchar(100),
@ClienteDelegacion		varchar(100),
@ClienteEstado		varchar(30),
@ClientePais		varchar(30),
@ClienteCodigoPostal	varchar(15),
@ClienteGLN			varchar(50),
@ClienteTelefonos		varchar(100),
@ClienteIEPS		varchar(20),
@EnviarARFC			varchar(20),
@EnviarANombre		varchar(100),
@EnviarADireccion		varchar(100),
@EnviarADireccionNumero	varchar(20),
@EnviarADireccionNumeroInt	varchar(20),
@EnviarAColonia		varchar(100),
@EnviarAPoblacion		varchar(100),
@EnviarAObservaciones	varchar(100),
@EnviarADelegacion		varchar(100),
@EnviarAEstado		varchar(30),
@EnviarAPais		varchar(30),
@EnviarACodigoPostal	varchar(15),
@EnviarAGLN			varchar(50),
@EnviarATelefonos		varchar(100),
@Sucursal			int,
@Version			varchar(10),
@noCertificado		varchar(20),
@Mov			varchar(20),
@MovID			varchar(20),
@Referencia			varchar(50),
@ReferenciaFecha		datetime,
@ConsecutivoModulo		char(5),
@ConsecutivoMov		varchar(20),
@Fecha			datetime,
@Serie 			varchar(20),
@Folio			bigint,
@FechaEmision		datetime,
@noAprobacion		int,
@fechaAprobacion		datetime,
@MovTipo			varchar(20),
@tipoDeComprobante		varchar(20),
@FormaEnvio			varchar(50),
@Condicion			varchar(50),
@Vencimiento		datetime,
@formaDePago		varchar(255),
@metodoDePago		varchar(255),
@Importe			Float,
@SubTotal			Float,
@Descuento			varchar(50),
@DescuentosTotales		Float,
@ImpuestosTotal		Float,
@Total			Float,
@Cliente			varchar(10),
@EnviarA			int,
@Renglon			float,
@RenglonSub			int,
@RenglonID			int,
@RenglonTipo		char(1),
@Cantidad			float,
@CantidadTotal		float,
@Codigo			varchar(50),
@Unidad			varchar(50),
@Articulo			varchar(20),
@SubCuenta			varchar(50),
@noIdentificacion		varchar(100),
@ArtDescripcion1		varchar(255),
@ArtDescripcion2		varchar(255),
@ArtTipoEmpaque		varchar(50),
@TipoEmpaqueClave		varchar(20),
@TipoEmpaqueTipo		varchar(20),
@Precio			Float,
@PrecioLinea		Float,
@PrecioSinDescuentos	Float,
@SubTotalLinea		Float,
@TotalLinea			Float,
@SerieLote			varchar(50),
@Pedimento			varchar(20),
@PedimentoFecha		datetime,
@Aduana			varchar(50),
@AduanaGLN			varchar(50),
@AduanaCiudad		varchar(50),
@Impuesto1			float,
@Impuesto1Linea		Float,
@Impuesto1SubTotal		Float,
@Impuesto1Total		Float,
@Impuesto1Promedio		float,
@Impuesto2			float,
@Impuesto2Linea		Float,
@Impuesto2SubTotal		Float,
@Impuesto2Total		Float,
@Impuesto2Promedio		float,
@PctDescuentoLinea		float,
@DescuentoLinea		Float,
@DescuentoGlobalLinea	Float,
@EmisorID 			varchar(20),
@ReceptorID 		varchar(20),
@ProveedorID 		varchar(20),
@ProveedorIDDeptoEnviarA	varchar(20),
@TipoAddenda 		varchar(50),
@AddendaVersion 		varchar(10),
@OrdenCompra 		varchar(50),
@FechaOrdenCompra		datetime,
@DiasVencimiento		int,
@Estatus			varchar(15),
@DescuentoGlobal		float,
@ImporteDescuentoGlobal	Float,
@Departamento		int,
@DepartamentoClave		varchar(20),
@DepartamentoNombre		varchar(100),
@DepartamentoContacto       varchar(100),
@EmpresaRepresentante	varchar(100),
@Observaciones		varchar(100),
@DefImpuesto		float,
@DefImpuestoZona		float,
@ZonaImpuesto		varchar(30),
@EnviarAClave		varchar(20),
@Embarque 			varchar(50),
@EmbarqueFecha 		datetime,
@Recibo 			varchar(50),
@ReciboFecha 		datetime,
@Moneda			char(10),
@MonedaClave		varchar(3),
@UnidadClave		varchar(50),
@TipoCambio			float,
@FechaRequerida		datetime,
@MN				bit,
@Paquetes			int,
@CantidadEmpaque		float,
@EAN13			varchar(20),
@DUN14			varchar(20),
@SKUCliente			varchar(20),
@SKUEmpresa			varchar(20),
@SKUDelCliente		bit,
@PrimerSerieLote		varchar(50),
@ImporteLinea		Float,
@SumaImporteLinea		Float,
@SumaCantidad		Float,
@SumaSubTotalLinea		Float,
@Conteo			int,
@ImporteEnLetra		varchar(255),
@TipoCondicion		varchar(20),
@ProntoPago 		bit,
@DescuentoProntoPago	float,
@DescuentoClave		varchar(20),
@UnidadFactor		float,
@Liverpool			bit,
@Gigante			bit,
@ComercialMexicana		bit,
@Elektra			bit,
@EHB			bit,
@Antecedente		varchar(50),
@AntecedenteFecha		datetime,
@ModoPruebas		bit,
@ReferenciaEnvio		varchar(14),
@Origen			varchar(20),
@OrigenID			varchar(20),
@NumeroArticulos 		int,
@EntregaMercancia 		varchar(20),
@agenteAduanal 		varchar(10),
@AgenteAduanalNombre 	varchar(100),
@TotalCajas 		int,
@Concepto 			varchar(50),
@AduanaClave		varchar(10),
@PedimentoFecha2		datetime,
@PedimentoFecha3		datetime,
@PaqueteEsCantidad		bit,
@InformacionCompra 		varchar(20),
@CompSubTotal 		Float,
@CompDescuentoLineal 	Float,
@CompImporteDescuentoGlobal Float,
@CompImpuesto1Total 	Float,
@CompImpuesto2Total 	Float,
@CompPrecio 		Float,
@PersonalCobrador 		varchar(10),
@emailCobrador 		varchar(50),
@AnticiposFacturados	Float,
@AnticiposImpuestos		Float,
@AgruparDetalle 		int,
@ArtUnidad 			varchar(20),
@UtilizaPaquete 		int,
@SeFacturaPor		varchar(50),
@MovIDCFD			varchar(20),
@Agente				varchar(20),
@DescripcionExtra	varchar(100),
@cfgDecimales		int,
@p					char(1),
@RetencionTotal		float,
@RetencionFlete		float,
@RetencionPitex		float,
@ImporteSobrePrecio float,
@TasaAnticipoImpuesto float,
/*    @OrigenDAMov			varchar(20),
@OrigenDAMovID			varchar(20),
@IDOrigenDA				varchar(20),
@EsDocAuto				bit,
@OrigenDAserie			varchar(20),
@OrigenDAFolio			varchar(20),
@OrigenDAFecha			datetime,
@OrigenDATotal			float,
@Resultado				varchar(50),
@Len					int,
@Desde					int,
@Hasta					int, */
@EmpresaRegimenFiscal	varchar(100),
@NumeroCuentaPago		varchar(255),
@IDOrigen				int,
@FormaPagoTipo			varchar(50),
@FormaCobro1 varchar(50),
@FormaCobro2 varchar(50),
@FormaCobro3 varchar(50),
@FormaCobro4 varchar(50),
@FormaCobro5 varchar(50),
@Referencia1 varchar(50),
@Referencia2 varchar(50),
@Referencia3 varchar(50),
@Referencia4 varchar(50),
@Referencia5 varchar(50),
@metodoDePagoCobro		varchar(255),
@NumeroCuentaPagoCobro  varchar(255),
@RegimenFiscal			varchar(255),
@CteCFDCta				varchar(20),
@FolioFiscalOrig		varchar(50),
@SerieFolioFiscalOrig	varchar(20),
@FechaFolioFiscalOrig	datetime,
@MontoFolioFiscalOrig	float,
@NameSpace				varchar(8000),
@UnidadSAT				varchar(100),
@CuentaPredial			varchar(100),
@InfoPago				varchar(100),
@InfoFormaPago			varchar(50),
@CteCFDFormaCobro		varchar(50),
@CteCFDCuentaPago		varchar(20),
@CteEmpresaFormaPago 	varchar(50),
@CteEmpresaCuentaPago 	varchar(50),
@LugarExpedicion		VARCHAR(255)
IF @Modulo NOT IN ('VTAS', 'CXC') RETURN
SET CONCAT_NULL_YIELDS_NULL ON
SELECT @MN = 0,
@SumaCantidad = 0.0,
@SumaSubTotalLinea = 0.0,
@SumaImporteLinea = 0.0,
@Conteo = 0,
@Layout = UPPER(@Layout),
@ModoPruebas = 0,
@Liverpool = 0,
@Gigante = 0,
@ComercialMexicana = 0,
@Elektra = 0,
@EHB = 0,
@PaqueteEsCantidad = 0
IF @Modulo = 'VTAS'
BEGIN
SELECT @Estatus = Estatus, @Empresa = Empresa, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @FormaEnvio = FormaEnvio, @Condicion = Condicion, @Vencimiento = Vencimiento, @Cliente = Cliente, @EnviarA = EnviarA, @Descuento = Descuento, @DescuentoGlobal = DescuentoGlobal,
@OrdenCompra = OrdenCompra, @FechaOrdenCompra = FechaOrdenCompra, @Departamento = Departamento, @ZonaImpuesto = ZonaImpuesto, @Moneda = Moneda, @TipoCambio = TipoCambio, @FechaRequerida = FechaRequerida, @Observaciones = Observaciones,
@Referencia = Referencia, @FechaEmision = FechaEmision, @Origen = Origen, @OrigenID = OrigenID,
@AnticiposFacturados = AnticiposFacturados, @Anticiposimpuestos = AnticiposImpuestos, @Agente = Agente,
@FormaPagoTipo = FormaPagoTipo, @Concepto = Concepto
FROM Venta
WITH(NOLOCK) WHERE ID = @ID
SELECT @FormaCobro1 = NULLIF(FormaCobro1,''), @FormaCobro2 = NULLIF(FormaCobro2,''), @FormaCobro3 = NULLIF(FormaCobro3,''), @FormaCobro4 = NULLIF(FormaCobro4,''), @FormaCobro5 = NULLIF(FormaCobro5,''),
@Referencia1 = NULLIF(Referencia1,''), @Referencia2 = NULLIF(Referencia2,''), @Referencia3 = NULLIF(Referencia3,''), @Referencia4 = NULLIF(Referencia4,''), @Referencia5 = NULLIF(Referencia5,'')
FROM VentaCobro WHERE ID = @ID
END
IF @Modulo = 'CXC'
BEGIN
SELECT @Estatus = Estatus, @Empresa = Empresa, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Cliente = Cliente, @EnviarA = ClienteEnviarA,
@Moneda = Moneda, @TipoCambio = TipoCambio, @Observaciones = Observaciones, @Concepto = Concepto,
@Referencia = Referencia, @FechaEmision = FechaEmision, @Impuesto1Total = ISNULL(Impuestos,0), @ImpuestosTotal = ISNULL(Impuestos,0), @Importe = Importe, @Condicion = Condicion,
@Origen = Origen, @OrigenId = OrigenID, @FormaPagoTipo = FormaCobro,
@FormaCobro1 = NULLIF(FormaCobro1,''), @FormaCobro2 = NULLIF(FormaCobro2,''), @FormaCobro3 = NULLIF(FormaCobro3,''), @FormaCobro4 = NULLIF(FormaCobro4,''), @FormaCobro5 = NULLIF(FormaCobro5,''),
@Referencia1 = NULLIF(Referencia1,''), @Referencia2 = NULLIF(Referencia2,''), @Referencia3 = NULLIF(Referencia3,''), @Referencia4 = NULLIF(Referencia4,''), @Referencia5 = NULLIF(Referencia5,'')
FROM CXC
WITH(NOLOCK) WHERE ID = @ID
SELECT @ImporteDescuentoGlobal = 0
IF @Importe = 0.0 OR @ImpuestosTotal = 0.0
SELECT @Impuesto1 = 0.00
ELSE
SELECT @Impuesto1 = ROUND((@ImpuestosTotal*100)/@Importe,2)
END
IF @Validar = 1 AND @Modulo IN ('VTAS', 'CXC', 'CXP') AND @ID IS NOT NULL
BEGIN
SELECT @MovIDCFD = MovID FROM CFD WITH(NOLOCK) WHERE Modulo = @Modulo AND ModuloID = @ID
IF NULLIF(RTRIM(@MovID), '') <> NULLIF(RTRIM(@MovIDCFD), '')
SELECT @OK = 30013, @OkRef = RTRIM(@Mov)+' '+RTRIM(@MovIDCFD)
END
SELECT @Fecha = Fecha FROM CFD WITH(NOLOCK) WHERE Modulo = @Modulo AND ModuloID = @ID
IF @@ROWCOUNT = 0
BEGIN
SELECT @Fecha = GETDATE()
IF @Validar = 0
IF NOT EXISTS (SELECT ModuloID FROM CFD WITH(NOLOCK) WHERE Modulo = @Modulo AND ModuloID = @ID )
INSERT CFD (Modulo, ModuloID, Fecha) VALUES (@Modulo, @ID, @Fecha)
END
SELECT @noCertificado = noCertificado,
@Version = CASE WHEN versionFecha<@Fecha OR versionFecha IS NULL THEN version ELSE versionAnterior END,
@EmpresaEAN13 = EAN13, @EmpresaDUN14 = DUN14, @EmpresaSKUCliente = SKU, @EmpresaSKUEmpresa = SKUEmpresa,
@EmpresaSKUCodigoInterno = ISNULL(SKUCodigoInterno, 0), @ModoPruebas = ModoPruebas, @PaqueteEsCantidad = PaqueteEsCantidad,
@AgruparDetalle = AgruparDetalle, @CfgDecimales = ISNULL(Decimales,2)
FROM EmpresaCFD
WITH(NOLOCK) WHERE Empresa = @Empresa
IF @Layout = 'SAT_2.2'
SELECT @MN = 0
IF @MN = 1 AND @Modulo = 'CXC'
SELECT @Impuesto1Total = @Impuesto1Total*@TipoCambio, @ImpuestosTotal = @ImpuestosTotal*@TipoCambio , @Importe = @Importe*@TipoCambio
IF @Modulo = 'VTAS'
BEGIN
IF @MN = 1
BEGIN
SELECT @CantidadTotal = SUM(Cantidad), @Importe = SUM(Importe*TipoCambio), @DescuentosTotales = SUM(DescuentosTotales*TipoCambio), 
@Impuesto1Total = SUM(Impuesto1Total*TipoCambio), @Impuesto2Total = SUM(Impuesto2Total*TipoCambio), @ImpuestosTotal = SUM(Impuestos*TipoCambio),
@ImporteDescuentoGlobal = SUM(ImporteDescuentoGlobal*TipoCambio)
FROM VentaTCalc
WITH(NOLOCK) WHERE ID = @ID
SELECT @AnticiposFacturados = ISNULL(@AnticiposFacturados,0) * @TipoCambio,
@AnticiposImpuestos  = ISNULL(@AnticiposImpuestos,0) * @TipoCambio
END
ELSE
SELECT @CantidadTotal = SUM(Cantidad), @Importe = SUM(Importe), @DescuentosTotales = SUM(DescuentosTotales), 
@Impuesto1Total = SUM(Impuesto1Total), @Impuesto2Total = SUM(Impuesto2Total), @ImpuestosTotal = SUM(Impuestos),
@ImporteDescuentoGlobal = SUM(ImporteDescuentoGlobal)
FROM VentaTCalc
WITH(NOLOCK) WHERE ID = @ID
/** AR se agrego la lectura de @Entregamercancia*/
SELECT @Embarque = Embarque, @EmbarqueFecha = EmbarqueFecha, @Recibo = Recibo, @ReciboFecha = ReciboFecha, @EntregaMercancia = EntregaMercancia
FROM VentaEntrega
WITH(NOLOCK) WHERE ID = @ID
SELECT @NumeroArticulos = COUNT(DISTINCT(Articulo)) FROM VentaD WHERE ID = @ID AND RenglonTipo <> 'C'
END
SELECT @SubTotal = @Importe - ISNULL(@ImporteDescuentoGlobal,0.0) - ISNULL(@AnticiposFacturados,0) + ISNULL(@AnticiposImpuestos,0)+ISNULL(@ImporteSobrePrecio,0.0)
SELECT @ImpuestosTotal = @ImpuestosTotal - ISNULL(@AnticiposImpuestos,0)
SELECT @Total = @SubTotal + @ImpuestosTotal
SELECT @ImporteEnLetra = dbo.fnNumeroEnEspanol(@Total, @Moneda)
SELECT @Impuesto1Total = @Impuesto1Total - ISNULL(@AnticiposImpuestos,0)
SELECT @ClienteRFC = dbo.fnLimpiarRFC(RFC), @ClienteNombre = Nombre, @ClienteDireccion = Direccion, @ClienteDireccionNumero = DireccionNumero, @ClienteDireccionNumeroInt = DireccionNumeroInt,
@ClienteColonia = Colonia, @ClientePoblacion = Poblacion, @ClienteObservaciones = EntreCalles/*Observaciones*/, @ClienteDelegacion = Delegacion, @ClienteEstado = Estado,
@ClientePais = Pais, @ClienteCodigoPostal = CodigoPostal, @ClienteGLN = GLN, @ClienteTelefonos = Telefonos, @ClienteIEPS = IEPS, @PersonalCobrador = PersonalCobrador
FROM Cte
WITH(NOLOCK) WHERE Cliente = @Cliente
SELECT @emailCobrador = email FROM Personal WITH(NOLOCK) WHERE Personal = @PersonalCobrador
SELECT @ReceptorID = ReceptorID, @TipoAddenda = TipoAddenda,
@AddendaVersion = CASE WHEN VersionFecha < @Fecha OR VersionFecha IS NULL THEN Version ELSE VersionAnterior END,
@CteCFDCta = Cta
FROM CteCFD
WITH(NOLOCK) WHERE Cliente = @Cliente
IF @TipoAddenda IN ('CHEDRAUI', 'EDIFACT') AND LEN(@ClienteRFC) NOT IN (12, 13)
SELECT @ClienteRFC = NULL
SELECT @EmisorID = EmisorID, @ProveedorID = ProveedorID, @InformacionCompra = InformacionCompra
FROM CteEmpresaCFD
WITH(NOLOCK) WHERE Cliente = @Cliente AND Empresa = @Empresa
SELECT @ProveedorIDDeptoEnviarA = ProveedorID
FROM CteDeptoEnviarA
WITH(NOLOCK) WHERE Cliente = @Cliente AND Departamento = @Departamento AND Empresa = @Empresa AND EnviarA = @EnviarA
SELECT @EnviarAClave = ISNULL(NULLIF(RTRIM(Clave), ''), CONVERT(varchar(20), ID)),
@EnviarANombre = Nombre, @EnviarADireccion = Direccion, @EnviarADireccionNumero = DireccionNumero, @EnviarADireccionNumeroInt = DireccionNumeroInt,
@EnviarAColonia = Colonia, @EnviarAPoblacion = Poblacion, @EnviarAObservaciones = NULLIF(RTRIM(EntreCalles/*Observaciones*/),''), @EnviarADelegacion = Delegacion, @EnviarAEstado = Estado,
@EnviarAPais = Pais, @EnviarACodigoPostal = CodigoPostal, @EnviarAGLN = GLN, @EnviarATelefonos = Telefonos
FROM CteEnviarA
WITH(NOLOCK) WHERE Cliente = @Cliente AND ID = @EnviarA
SELECT @DepartamentoClave = Clave,
@DepartamentoNombre = Departamento,
@DepartamentoContacto = Contacto
FROM CteDepto
WITH(NOLOCK) WHERE Cliente = @Cliente AND Departamento = @Departamento
IF @Subtotal = 0.0
SELECT @Impuesto1Promedio = 0.0,
@Impuesto2Promedio = 0.0
ELSE
SELECT @Impuesto1Promedio = (@Impuesto1Total*100)/@SubTotal,
@Impuesto2Promedio = (@Impuesto2Total*100)/@SubTotal
SELECT @EmpresaRFC = dbo.fnLimpiarRFC(RFC), @EmpresaNombre = Nombre,
@EmpresaDireccion = Direccion, @EmpresaDireccionNumero = DireccionNumero, @EmpresaDireccionNumeroInt = DireccionNumeroInt,
@EmpresaColonia = Colonia, @EmpresaPoblacion = Poblacion, @EmpresaObservaciones = NULL, @EmpresaDelegacion = Delegacion, @EmpresaEstado = Estado,
@EmpresaPais = Pais, @EmpresaCodigoPostal = CodigoPostal,
@EmpresaRepresentante = Representante, @EmpresaRegistroPatronal = RegistroPatronal, @EmpresaGLN = GLN, @EmpresaTelefonos = Telefonos, @EmpresaRegimenFiscal = FiscalRegimen
FROM Empresa
WITH(NOLOCK) WHERE Empresa = @Empresa
IF @TipoAddenda IN ('CHEDRAUI', 'EDIFACT') AND LEN(@EmpresaRFC) NOT IN (12, 13)
SELECT @EmpresaRFC = NULL
SELECT @DefImpuesto = DefImpuesto
FROM EmpresaGral
SELECT @DefImpuestoZona = @DefImpuesto
EXEC spZonaImp @ZonaImpuesto, @DefImpuestoZona OUTPUT
SELECT @MonedaClave = Clave FROM Mon WITH(NOLOCK) WHERE Moneda = @Moneda
SELECT @DescuentoClave = Clave FROM Descuento WITH(NOLOCK) WHERE Descuento = @Descuento
SELECT @SucursalNombre = Nombre, @SucursalGLN = GLN,
@SucursalDireccion = Direccion, @SucursalDireccionNumero = DireccionNumero, @SucursalDireccionNumeroInt = DireccionNumeroInt,
@SucursalColonia = Colonia, @SucursalPoblacion = Poblacion, @SucursalObservaciones = NULL, @SucursalDelegacion = Delegacion, @SucursalEstado = Estado,
@SucursalPais = Pais, @SucursalCodigoPostal = CodigoPostal
FROM Sucursal
WITH(NOLOCK) WHERE Sucursal = @Sucursal
SELECT @LugarExpedicion = NULLIF(@SucursalDelegacion,'')+', '+NULLIF(@SucursalEstado,'')
IF @Condicion IS NOT NULL
SELECT @TipoCondicion = TipoCondicion, @formaDePago = CFD_formaDePago, @metodoDePago = CFD_metodoDePago, @DiasVencimiento = ISNULL(DiasVencimiento,1),
@ProntoPago = ProntoPago, @DescuentoProntoPago = DescuentoProntoPago
FROM Condicion
WITH(NOLOCK) WHERE Condicion = @Condicion
ELSE
SELECT @formaDePago = 'PAGO EN UNA SOLA EXHIBICION'
IF NULLIF(@FormaPagoTipo,'') IS NOT NULL
SELECT @metodoDePago = @FormaPagoTipo
IF @Modulo = 'CXC'
SELECT @formaDePago = 'PAGO EN UNA SOLA EXHIBICION'
SELECT @MovTipo = Clave, @tipoDeComprobante = CFD_tipoDeComprobante,
@ConsecutivoModulo = ConsecutivoModulo, @ConsecutivoMov = ConsecutivoMov
FROM MovTipo
WITH(NOLOCK) WHERE Modulo = @Modulo AND Mov = @Mov
EXEC spMovIDEnSerieConsecutivo @MovID, @Serie OUTPUT, @Folio OUTPUT
SELECT @noAprobacion = noAprobacion, @fechaAprobacion = fechaAprobacion
FROM CFDFolio
WITH(NOLOCK) WHERE Empresa = @Empresa AND Modulo = @ConsecutivoModulo AND Mov = @ConsecutivoMov AND Serie = @Serie AND @Folio BETWEEN FolioD AND FolioA AND Estatus = 'ALTA'
IF @@ROWCOUNT = 0
SELECT @noAprobacion = noAprobacion, @fechaAprobacion = fechaAprobacion
FROM CFDFolio
WITH(NOLOCK) WHERE Empresa = @Empresa AND Modulo = @ConsecutivoModulo AND Mov = @ConsecutivoMov AND ISNULL(Serie,'') = ISNULL(@Serie,'') AND @Folio BETWEEN FolioD AND FolioA AND Estatus = 'ALTA'
IF @MovTipo IN ('VTAS.F', 'VTAS.D', 'VTAS.DF', 'VTAS.B')
BEGIN
IF @ClienteRFC IS NOT NULL AND LEN(@ClienteRFC) >= 9
BEGIN
SELECT @p = SUBSTRING(@ClienteRFC, 4, 1)
IF UPPER(@p) NOT IN ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z')
BEGIN
SELECT @RetencionFlete = SUM(Subtotal * 0.04) FROM VentaTCalc WHERE ID = @ID AND Articulo = 'FLETE'
END
END
IF EXISTS(SELECT * FROM Cte WITH(NOLOCK) WHERE Cliente = @Cliente AND NULLIF(RTRIM(PITEX), '') IS NOT NULL)
BEGIN
SELECT @RetencionPitex = @Impuesto1Total + ISNULL(@AnticiposImpuestos,0)
END
SELECT @RetencionTotal = ISNULL(@RetencionFlete,0.0) + ISNULL(@RetencionPitex,0.0)
END
IF NULLIF(@CteCFDCta,'') IS NOT NULL AND ISNUMERIC(@CteCFDCta) = 1
SELECT @NumeroCuentaPago =  RIGHT(RTRIM(@CteCFDCta),4)
SELECT @CteEmpresaFormaPago = NULLIF(InfoFormaPago,'') FROM CteEmpresaCFD WHERE Cliente = @Cliente AND Empresa = @Empresa
SELECT @CteEmpresaCuentaPago = CuentaPago FROM CteCFDFormaPago WITH(NOLOCK) WHERE Empresa = @Empresa AND Cliente = @Cliente AND FormaPago = @CteEmpresaFormaPago
SELECT @InfoPago = NULLIF(InfoPago,''), @InfoFormaPago = NULLIF(InfoFormaPago,'') FROM CteCFD WHERE Cliente = @Cliente
SELECT @CteCFDFormaCobro = NULLIF(FormaPago,''), @CteCFDCuentaPago = NULLIF(RIGHT(CuentaPago,4),'')
FROM CteCFDInfoPagoD
WITH(NOLOCK) WHERE Cliente = @Cliente AND InfoPago = @InfoPago AND FormaPago = @InfoFormaPago
IF @CteEmpresaFormaPago IS NOT NULL
SELECT @metodoDePago = @CteEmpresaFormaPago, @NumeroCuentaPago = ISNULL(@CteEmpresaCuentaPago,'NA')
ELSE
IF @CteCFDFormaCobro IS NOT NULL
BEGIN
SELECT @metodoDePago = @CteCFDFormaCobro
IF ISNUMERIC(@CteCFDCuentaPago) = 1 SELECT @NumeroCuentaPago = ISNULL(@CteCFDCuentaPago,'NA')
END
SELECT @MetodoDePagoCobro = '', @NumeroCuentaPagoCobro = ''
IF @FormaCobro1 IS NOT NULL
BEGIN
SELECT @MetodoDePagoCobro = @FormaCobro1
IF ISNUMERIC(@Referencia1) = 0 OR @Referencia1 IS NULL
SELECT @NumeroCuentaPagoCobro = 'NA'
ELSE
SELECT @NumeroCuentaPagoCobro = RIGHT(RTRIM(@Referencia1),4)
END
IF @MetodoDePagoCobro IS NOT NULL AND @FormaCobro2 IS NOT NULL
BEGIN
SELECT @MetodoDePagoCobro = @MetodoDePagoCobro +', ' + @FormaCobro2
IF ISNUMERIC(@Referencia2) = 0 OR @Referencia2 IS NULL
SELECT @NumeroCuentaPagoCobro = @NumeroCuentaPagoCobro+', '+'NA'
ELSE
SELECT @NumeroCuentaPagoCobro = @NumeroCuentaPagoCobro +', ' + RIGHT(RTRIM(@Referencia2),4)
END
IF @MetodoDePagoCobro IS NOT NULL AND @FormaCobro3 IS NOT NULL
BEGIN
SELECT @MetodoDePagoCobro = @MetodoDePagoCobro +', ' + @FormaCobro3
IF ISNUMERIC(@Referencia3) = 0 OR @Referencia3 IS NULL
SELECT @NumeroCuentaPagoCobro = @NumeroCuentaPagoCobro+', '+'NA'
ELSE
SELECT @NumeroCuentaPagoCobro = @NumeroCuentaPagoCobro +', ' + RIGHT(RTRIM(@Referencia3),4)
END
IF @MetodoDePagoCobro IS NOT NULL AND @FormaCobro4 IS NOT NULL
BEGIN
SELECT @MetodoDePagoCobro = @MetodoDePagoCobro +', ' + @FormaCobro4
IF ISNUMERIC(@Referencia4) = 0 OR @Referencia4 IS NULL
SELECT @NumeroCuentaPagoCobro = @NumeroCuentaPagoCobro+', '+'NA'
ELSE
SELECT @NumeroCuentaPagoCobro = @NumeroCuentaPagoCobro +', ' + RIGHT(RTRIM(@Referencia4),4)
END
IF @MetodoDePagoCobro IS NOT NULL AND @FormaCobro5 IS NOT NULL
BEGIN
SELECT @MetodoDePagoCobro = @MetodoDePagoCobro +', ' + @FormaCobro5
IF ISNUMERIC(@Referencia5) = 0 OR @Referencia5 IS NULL
SELECT @NumeroCuentaPagoCobro = @NumeroCuentaPagoCobro+', '+'NA'
ELSE
SELECT @NumeroCuentaPagoCobro = @NumeroCuentaPagoCobro +', ' + RIGHT(RTRIM(@Referencia5),4)
END
IF CHARINDEX(',',@metodoDePagoCobro,1) = 1 SELECT @metodoDePagoCobro = STUFF(@metodoDePagoCobro,1,1,'')
IF CHARINDEX(',',@NumeroCuentaPagoCobro,1)  = 1  SELECT @NumeroCuentaPagoCobro  = STUFF(@NumeroCuentaPagoCobro,1,1,'')
IF NULLIF(@metodoDePagoCobro,'') IS NOT NULL SELECT @metodoDePago = @metodoDePagoCobro, @NumeroCuentaPago = @NumeroCuentaPagoCobro
IF NULLIF(@metodoDePago,'') IS NULL SELECT @metodoDePago = 'NA'
IF NULLIF(@NumeroCuentaPago,'') IS NULL SELECT @NumeroCuentaPago = 'NA'
SELECT @RegimenFiscal = dbo.fnCFDFlexRegimenFiscal(@Empresa, @Modulo, @Concepto)
IF  (SELECT CFDEsPArcialidad FROM MovTipo WITH(NOLOCK) WHERE Modulo = @Modulo AND Mov = @Mov )  = 1
BEGIN
EXEC spCFDParcialidad @ID, @Modulo, @Empresa, @Mov, @MovTipo, @Concepto OUTPUT, @FormadePago OUTPUT, @FolioFiscalOrig OUTPUT, @SerieFolioFiscalOrig OUTPUT, @FechaFolioFiscalOrig OUTPUT, @MontoFolioFiscalOrig OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
EXEC xpGenerarCFDEncabezado   @Estacion, @Modulo, @ID, @Layout, @Validar, @Empresa,  @Sucursal, @Cliente, @EnviarA, @EmpresaGLN, @Version,
@Mov, @MovID, @Estatus, @ConsecutivoModulo, @ConsecutivoMov, @Fecha,  @Serie, @Folio, @MovTipo, @tipoDeComprobante, @TipoAddenda, @AddendaVersion,
@Moneda, @TipoCambio, @Liverpool, @Gigante, @ComercialMexicana, @Elektra, @EHB, @Origen, @OrigenID, @SucursalGLN OUTPUT, @ClienteGLN OUTPUT,
@EnviarAGLN OUTPUT, @Referencia OUTPUT,  @ReferenciaFecha OUTPUT, @FormaEnvio OUTPUT, @Condicion OUTPUT, @Vencimiento OUTPUT, @formaDePago OUTPUT,
@metodoDePago OUTPUT,  @EmisorID OUTPUT, @ReceptorID OUTPUT,  @ProveedorID OUTPUT,  @OrdenCompra OUTPUT,  @FechaOrdenCompra OUTPUT, @DepartamentoClave OUTPUT,
@DepartamentoNombre OUTPUT, @DepartamentoContacto OUTPUT, @Observaciones OUTPUT, @EnviarAClave OUTPUT, @Embarque OUTPUT,  @EmbarqueFecha OUTPUT,
@Recibo OUTPUT,  @ReciboFecha OUTPUT, @MonedaClave OUTPUT, @FechaRequerida OUTPUT, @TipoCondicion OUTPUT, @DescuentoClave OUTPUT, @Antecedente OUTPUT,
@AntecedenteFecha OUTPUT, @ReferenciaEnvio OUTPUT, @Ok OUTPUT,  @OkRef OUTPUT, @AgruparDetalle OUTPUT, @ClienteDireccion OUTPUT, @EnviarADireccion OUTPUT,
@Descuento OUTPUT, @RegimenFiscal OUTPUT, @NumeroCuentaPago OUTPUT, @CuentaPredial OUTPUT, @LugarExpedicion OUTPUT
IF @Validar = 1
BEGIN
IF @MovID IS NOT NULL
BEGIN
IF @noAprobacion IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - No Aprobacion'
IF @FechaAprobacion IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - A�o Aprobacion'
IF @Folio IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Folio'
END
IF @Fecha IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Fecha'
IF NULLIF(RTRIM(@FormaDePago), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Forma De Pago'
IF NULLIF(RTRIM(@noCertificado), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Empresa Nombre'
IF @SubTotal IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - SubTotal'
IF @Total IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Total'
IF NULLIF(RTRIM(@tipoDeComprobante), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Tipo de Comprobante'
IF NULLIF(RTRIM(@MetododePago), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Metodo de Pago'
IF NULLIF(RTRIM(@LugarExpedicion), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Lugar Expedicion'
IF NULLIF(RTRIM(@EmpresaRFC), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Empresa RFC'
IF LEN(@EmpresaRFC) NOT IN (12,13) SELECT @Ok = 10010, @OkRef = 'CFD - Empresa RFC Requiere 12 o 13 Caracteres'
IF NULLIF(RTRIM(@ClienteRFC), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Cliente RFC'
IF LEN(@ClienteRFC) NOT IN (12,13) SELECT @Ok = 10010, @OkRef = 'CFD - Cliente RFC Requiere 12 o 13 Caracteres'
IF NULLIF(RTRIM(@ClientePais), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Cliente Pais'
IF NULLIF(RTRIM(@RegimenFiscal), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Regimen Fiscal'
END
SELECT @NameSpace = NULL
EXEC xpNameSpace @Estacion, @Modulo, @ID, @Layout, @Version, @TipoAddenda, @NameSpace OUTPUT
IF @Layout = 'SAT_2.2'
BEGIN
SELECT '<?xml version="1.0" encoding="UTF-8" ?>'
SELECT '<Comprobante'+
ISNULL(@NameSpace,
CASE WHEN @TipoAddenda = 'Detallista'
THEN ' xmlns:xsi='+char(34)+'http://www.w3.org/2001/XMLSchema-instance'+char(34)+' xmlns='+char(34)+'http://www.sat.gob.mx/cfd/2'+char(34)+' xmlns:detallista='+char(34)+'http://www.sat.gob.mx/detallista'+char(34)+' xsi:schemaLocation='+char(34)+'http://www.sat.gob.mx/cfd/2 http://www.sat.gob.mx/sitio_internet/cfd/2/cfdv22.xsd http://www.sat.gob.mx/detallista http://www.sat.gob.mx/sitio_internet/cfd/detallista/detallista.xsd'+char(34)+' '
ELSE ' xmlns='+char(34)+'http://www.sat.gob.mx/cfd/2'+char(34)+' xmlns:xsi='+char(34)+'http://www.w3.org/2001/XMLSchema-instance'+char(34)+' xsi:schemaLocation='+char(34)+'http://www.sat.gob.mx/cfd/2 http://www.sat.gob.mx/sitio_internet/cfd/2/cfdv22.xsd'+char(34)+' '
END)+
dbo.fnXML('version', @Version)+
dbo.fnXML('serie', @Serie)+
dbo.fnXMLBigint('folio', @Folio)+
dbo.fnXMLDatetime('fecha', @Fecha)+
dbo.fnXML('sello', '{@Sello}')+
dbo.fnXMLInt('noAprobacion', @noAprobacion)+
dbo.fnXMLInt('anoAprobacion', YEAR(@fechaAprobacion))+
dbo.fnXML('formaDePago', @formaDePago)+
dbo.fnXML('noCertificado', @noCertificado)+
dbo.fnXML8000('certificado', '{@Certificado}')+
dbo.fnXML('condicionesDePago', @Condicion)+
dbo.fnXMLDecimal('subTotal', @SubTotal+ISNULL(@DescuentosTotales,0.0), @CfgDecimales)+
dbo.fnXMLDecimal('descuento', @DescuentosTotales, @CfgDecimales)+
dbo.fnXML('motivoDescuento', NULLIF(RTRIM(@Descuento),''))+
dbo.fnXMLDecimal('total', @Total-ISNULL(@RetencionTotal,0.0), @CfgDecimales)+
dbo.fnXML('metodoDePago', @metodoDePago)+
dbo.fnXML('tipoDeComprobante', LOWER(@tipoDeComprobante))+
dbo.fnXML('Moneda', @Moneda)+
dbo.fnXMLDecimal('TipoCambio', @TipoCambio, @CfgDecimales)+
dbo.fnXML('LugarExpedicion', @LugarExpedicion)+
dbo.fnXML('NumCtaPago',@NumeroCuentaPago )+
dbo.fnXml('FolioFiscalOrig', @FolioFiscalOrig)+
dbo.fnXml('SerieFolioFiscalOrig',@SerieFolioFiscalOrig)+
dbo.fnXmldatetime('FechaFolioFiscalOrig', @FechaFolioFiscalOrig)+
dbo.fnXmlMoney('MontoFolioFiscalOrig',@MontoFolioFiscalOrig)+
'>'
SELECT '<Emisor'+
dbo.fnXML('rfc', @EmpresaRFC)+
dbo.fnXML('nombre', @EmpresaNombre)+
'>'
SELECT '<DomicilioFiscal'+
dbo.fnXML('calle', @EmpresaDireccion)+
dbo.fnXML('noExterior', @EmpresaDireccionNumero)+
dbo.fnXML('noInterior', @EmpresaDireccionNumeroInt)+
dbo.fnXML('colonia', @EmpresaColonia)+
dbo.fnXML('localidad', @EmpresaPoblacion)+
dbo.fnXML('referencia', @EmpresaObservaciones)+
dbo.fnXML('municipio', @EmpresaDelegacion)+
dbo.fnXML('estado', @EmpresaEstado)+
dbo.fnXML('pais', @EmpresaPais)+
dbo.fnXML('codigoPostal', @EmpresaCodigoPostal)+
'/>'
IF @Sucursal <> 0
SELECT '<ExpedidoEn'+
dbo.fnXML('calle', @SucursalDireccion)+
dbo.fnXML('noExterior', @SucursalDireccionNumero)+
dbo.fnXML('noInterior', @SucursalDireccionNumeroInt)+
dbo.fnXML('colonia', @SucursalColonia)+
dbo.fnXML('localidad', @SucursalPoblacion)+
dbo.fnXML('referencia', @SucursalObservaciones)+
dbo.fnXML('municipio', @SucursalDelegacion)+
dbo.fnXML('estado', @SucursalEstado)+
dbo.fnXML('pais', @SucursalPais)+
dbo.fnXML('codigoPostal', @SucursalCodigoPostal)+
'/>'
IF @Version = '2.2'
SELECT '<RegimenFiscal'+dbo.fnXML('Regimen', @RegimenFiscal)+'/>'
SELECT '</Emisor>'
SELECT '<Receptor'+
dbo.fnXML('rfc', @ClienteRFC)+
dbo.fnXML('nombre', @ClienteNombre)+
'>'
SELECT '<Domicilio'+
dbo.fnXML('calle', @ClienteDireccion)+
dbo.fnXML('noExterior', @ClienteDireccionNumero)+
dbo.fnXML('noInterior', @ClienteDireccionNumeroInt)+
dbo.fnXML('colonia', @ClienteColonia)+
dbo.fnXML('localidad', @ClientePoblacion)+
dbo.fnXML('referencia', @ClienteObservaciones)+
dbo.fnXML('municipio', @ClienteDelegacion)+
dbo.fnXML('estado', @ClienteEstado)+
dbo.fnXML('pais', @ClientePais)+
dbo.fnXML('codigoPostal', @ClienteCodigoPostal)+
'/>'
SELECT '</Receptor>'
END
IF @Layout = 'SAT_2.2'
BEGIN
SELECT '<Conceptos>'
/** Detalle de CXC*/
IF @Modulo = 'CXC'
BEGIN
SELECT '<Concepto'+
dbo.fnXMLFloat('cantidad', 1.00)+
dbo.fnXML('unidad', 'No Aplica')+
dbo.fnXML('noIdentificacion', @Concepto)+
dbo.fnXML('descripcion', @Concepto)+
dbo.fnXMLDecimal('valorUnitario', @Importe, @CfgDecimales)+
dbo.fnXMLDecimal('importe', @Importe, @CfgDecimales)+
'>'
IF @Layout = 'SAT_2.2' AND NULLIF(@CuentaPredial,'') IS NOT NULL
SELECT '<CuentaPredial'+dbo.fnXML('numero', @CuentaPredial)+ '/>'
SELECT '</Concepto>'
END
END
IF @Modulo = 'VTAS'
BEGIN
IF @AgruparDetalle = 1
DECLARE crDetalle2 CURSOR LOCAL FOR
SELECT MAX(d.Renglon), MAX(d.RenglonSub), MAX(d.RenglonID), MAX(d.RenglonTipo), MAX(d.Codigo), SUM(d.CantidadNeta), MAX(ISNULL(NULLIF(RTRIM(d.Unidad), ''), a.Unidad)), MAX(ISNULL(NULLIF(d.Factor, 0.0), 1.0)), d.Articulo, d.SubCuenta, SUM(d.SubTotal * (CASE WHEN @MN = 1 THEN d.TipoCambio ELSE 1.0 END)),
dbo.fnQueCodigo(@EmpresaEAN13, d.Articulo, d.SubCuenta, MAX(d.Codigo), @Cliente), dbo.fnQueCodigo(@EmpresaDUN14, d.Articulo, d.SubCuenta, MAX(d.Codigo), @Cliente), dbo.fnQueCodigo(@EmpresaSKUCliente, d.Articulo, d.SubCuenta, MAX(d.Codigo), @Cliente), dbo.fnQueCodigo(@EmpresaSKUEmpresa, d.Articulo, d.SubCuenta, MAX(d.Codigo), @Cliente),
MAX(d.DescuentoLinea), SUM(ISNULL(d.DescuentoLineal, 0.0)), SUM(ISNULL(d.ImporteDescuentoGlobal, 0.0)), MAX(d.Impuesto1), MAX(d.Impuesto2), SUM(ISNULL(d.Impuesto1Total, 0.0)), SUM(ISNULL(d.Impuesto2Total, 0.0)),
MAX(a.Descripcion1), MAX(a.Descripcion2), MAX(a.TipoEmpaque), d.Precio
FROM VentaTCalc d
 WITH(NOLOCK) JOIN Art a  WITH(NOLOCK) ON a.Articulo = d.Articulo
WHERE d.ID = @ID AND d.RenglonTipo <> 'C'
GROUP BY d.Articulo, d.Subcuenta, d.Precio
ELSE
IF @AgruparDetalle = 0
DECLARE crDetalle2 CURSOR LOCAL FOR
SELECT d.Renglon, d.RenglonSub, d.RenglonID, d.RenglonTipo, d.Codigo, ISNULL(d.CantidadNeta,0.0), ISNULL(NULLIF(RTRIM(d.Unidad), ''), a.Unidad), ISNULL(NULLIF(d.Factor, 0.0), 1.0), d.Articulo, d.SubCuenta, d.SubTotal * (CASE WHEN @MN = 1 THEN d.TipoCambio ELSE 1.0 END),
dbo.fnQueCodigo(@EmpresaEAN13, d.Articulo, d.SubCuenta, d.Codigo, @Cliente), dbo.fnQueCodigo(@EmpresaDUN14, d.Articulo, d.SubCuenta, d.Codigo, @Cliente), dbo.fnQueCodigo(@EmpresaSKUCliente, d.Articulo, d.SubCuenta, d.Codigo, @Cliente), dbo.fnQueCodigo(@EmpresaSKUEmpresa, d.Articulo, d.SubCuenta, d.Codigo, @Cliente),
d.DescuentoLinea, ISNULL(d.DescuentoLineal, 0.0), ISNULL(d.ImporteDescuentoGlobal, 0.0), ISNULL(d.Impuesto1,0), ISNULL(d.Impuesto2,0), ISNULL(d.Impuesto1Total, 0.0), ISNULL(d.Impuesto2Total, 0.0),
a.Descripcion1, a.Descripcion2, a.TipoEmpaque, d.Precio
FROM VentaTCalc d
 WITH(NOLOCK) JOIN Art a  WITH(NOLOCK) ON a.Articulo = d.Articulo
WHERE d.ID = @ID AND d.RenglonTipo NOT IN ('C','E')
OPEN crDetalle2
FETCH NEXT FROM crDetalle2 INTO @Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @Codigo, @Cantidad, @Unidad, @UnidadFactor, @Articulo, @SubCuenta, @SubTotalLinea,
@EAN13, @DUN14, @SKUCliente, @SKUEmpresa,
@PctDescuentoLinea, @DescuentoLinea, @DescuentoGlobalLinea, @Impuesto1, @Impuesto2, @Impuesto1Linea, @Impuesto2Linea,
@ArtDescripcion1, @ArtDescripcion2, @ArtTipoEmpaque, @Precio
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @RenglonTipo = 'J'  
BEGIN
SELECT @CompSubTotal 			= ISNULL(SUM(SubTotal), 0.0),
@CompDescuentoLineal 		= ISNULL(SUM(DescuentoLineal), 0.0),
@CompImporteDescuentoGlobal 	= ISNULL(SUM(ImporteDescuentoGlobal), 0.0),
@CompImpuesto1Total 		= ISNULL(SUM(Impuesto1Total), 0.0),
@compImpuesto2Total 		= ISNULL(SUM(Impuesto2Total), 0.0),
@CompPrecio 			= ISNULL(SUM(ISNULL(Precio,0.0)*Cantidad),0.0)
FROM VentaTCalc WHERE ID = @ID AND RenglonID = @RenglonID AND RenglonTipo = 'C'
SELECT @SubTotalLinea 	= @SubTotalLinea + @CompSubTotal
SELECT @DescuentoLinea 	= @DescuentoLinea 		+ @CompDescuentoLineal
SELECT @DescuentoGlobalLinea 	= @DescuentoGlobalLinea 	+ @CompImporteDescuentoGlobal
SELECT @Impuesto1Linea 	= @Impuesto1Total 		+ @CompImpuesto1Total
SELECT @Impuesto2Linea 	= @Impuesto2Total 		+ @CompImpuesto2Total
SELECT @Precio 		= @Precio 			+ @CompPrecio / @Cantidad
END
SELECT @UnidadClave = Clave FROM Unidad WITH(NOLOCK) WHERE Unidad = @Unidad
IF @version = '2.2'
BEGIN
SELECT @UnidadClave = NULL
SELECT @UnidadClave = Valor FROM TablaSTD WITH(NOLOCK) WHERE TablaST = 'CFDFLEX_UNIDADES' AND Nombre = @Unidad
END
IF  @AgruparDetalle = 1
BEGIN
SELECT @Paquetes = @Cantidad / ISNULL(NULLIF(@UnidadFactor, 0.0), 1.0)
END ELSE
SELECT @Paquetes = Paquete, @DescripcionExtra = DescripcionExtra
FROM VentaD
WITH(NOLOCK) WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
IF NULLIF(@Paquetes, 0.0) IS NULL
SELECT @Paquetes = @Cantidad, @CantidadEmpaque = @UnidadFactor
ELSE
SELECT @CantidadEmpaque = @Cantidad / ISNULL(NULLIF(@Paquetes, 0.0), 1.0)
IF @PaqueteEsCantidad = 1 AND @Tipoaddenda IN ('CHEDRAUI', 'AMECE / CM')
SELECT @Cantidad = @Paquetes
SELECT @noIdentificacion = RTRIM(@Articulo)+' '+ISNULL(RTRIM(@SubCuenta), '')
SELECT @TipoEmpaqueClave = Clave, @TipoEmpaqueTipo = Tipo FROM TipoEmpaque WHERE TipoEmpaque = @ArtTipoEmpaque
EXEC xpGenerarCFDDetalle @Estacion, @Modulo, @ID, @Layout, @Version, @Renglon, @RenglonSub,
@Cantidad OUTPUT, @Codigo OUTPUT, @Unidad OUTPUT, @UnidadClave OUTPUT, @UnidadFactor OUTPUT, @Articulo OUTPUT, @SubCuenta OUTPUT,
@ArtDescripcion1 OUTPUT, @ArtDescripcion2 OUTPUT, @ArtTipoEmpaque OUTPUT, @TipoEmpaqueClave OUTPUT, @TipoEmpaqueTipo OUTPUT,
@Paquetes OUTPUT, @CantidadEmpaque OUTPUT, @EAN13 OUTPUT, @DUN14 OUTPUT, @SKUCliente OUTPUT, @SKUEmpresa OUTPUT, @noIdentificacion OUTPUT,
@AgruparDetalle, @Cliente, @OrdenCompra OUTPUT, @CuentaPredial OUTPUT
IF @Cantidad = 0 SELECT @SubTotalLinea  =  0 
SELECT @TotalLinea = @SubTotalLinea + ISNULL(@Impuesto1Linea, 0.0) + ISNULL(@Impuesto2Linea, 0.0)
SELECT @ImporteLinea = @SubTotalLinea + @DescuentoGlobalLinea
SELECT @Conteo = @Conteo + 1,
@SumaCantidad = @SumaCantidad + ISNULL(@Cantidad, 0.0),
@SumaSubTotalLinea = @SumaSubTotalLinea + ISNULL(@SubTotalLinea, 0.0),
@SumaImporteLinea = @SumaImporteLinea + ISNULL(@ImporteLinea, 0.0)
IF @Cantidad = 0 SELECT @PrecioLinea = 0 ELSE SELECT @PrecioLinea = ROUND(convert(Float, @SubTotalLinea / NULLIF(@Cantidad, 0.0)),2)
SELECT @PrimerSerieLote = NULL, @Pedimento = NULL, @PedimentoFecha = NULL, @Aduana = NULL, @AduanaGLN = NULL, @AduanaCiudad = NULL
IF @AgruparDetalle = 0
BEGIN
IF @RenglonTipo = 'J'
SELECT @PrimerSerieLote = NULLIF(RTRIM(MIN(SerieLote)), '')
FROM VentaD d
 WITH(NOLOCK) JOIN Art a  WITH(NOLOCK) ON d.Articulo = a.Articulo
JOIN SerieLoteMov s  WITH(NOLOCK) ON s.Modulo = 'VTAS' AND d.Id = s.ID AND d.RenglonID = s.RenglonID AND d.Articulo = s.Articulo AND ISNULL(d.Subcuenta,'') = ISNULL(s.Subcuenta,'')
WHERE a.Tipo IN ('Serie', 'Lote') AND d.ID = @ID AND d.RenglonID = @RenglonID AND s.Empresa = @Empresa
ELSE
SELECT @PrimerSerieLote = NULLIF(RTRIM(MIN(SerieLote)), '')
FROM SerieLoteMov
WITH(NOLOCK) WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID AND RenglonID = @RenglonID AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
END
IF @AgruparDetalle = 1
BEGIN
IF @RenglonTipo = 'J'
SELECT @PrimerSerieLote = NULLIF(RTRIM(MIN(SerieLote)), '')
FROM VentaD d
 WITH(NOLOCK) JOIN Art a  WITH(NOLOCK) ON d.Articulo = a.Articulo
JOIN SerieLoteMov s  WITH(NOLOCK) ON s.Modulo = 'VTAS' AND d.Id = s.ID /*AND d.RenglonID = s.RenglonID*/ AND d.Articulo = s.Articulo AND ISNULL(d.Subcuenta,'') = ISNULL(s.Subcuenta,'')
WHERE a.Tipo IN ('Serie', 'Lote') AND d.ID = @ID /*AND d.RenglonID = @RenglonID*/ AND s.Empresa = @Empresa
ELSE
SELECT @PrimerSerieLote = NULLIF(RTRIM(MIN(SerieLote)), '')
FROM SerieLoteMov
WITH(NOLOCK) WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID /*AND RenglonID = @RenglonID*/ AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
END
IF @PrimerSerieLote IS NOT NULL
SELECT @Pedimento = dbo.fnLimpiarRFC(p.Propiedades), @PedimentoFecha = p.Fecha1, @PedimentoFecha2 = p.Fecha2, @PedimentoFecha3 = p.Fecha3, @Aduana = p.Aduana, @AgenteAduanal = p.AgenteAduanal
FROM SerieLote s
 WITH(NOLOCK) JOIN SerieLoteProp p  WITH(NOLOCK) ON p.Propiedades = s.Propiedades
WHERE s.SerieLote = @PrimerSerieLote
IF @Aduana IS NOT NULL
SELECT @AduanaGLN = GLN, @AduanaCiudad = Ciudad FROM Aduana WHERE Aduana = @Aduana
IF @AgenteAduanal IS NOT NULL
SELECT @AgenteAduanalNombre = Nombre FROM Prov WITH(NOLOCK) WHERE Proveedor = @AgenteAduanal
IF @Validar = 1
BEGIN
IF NULLIF(RTRIM(@Cantidad), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Cantidad'
IF NULLIF(RTRIM(@UnidadClave), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Unidad'
IF NULLIF(RTRIM(@ArtDescripcion1), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Concepto'
IF @SubTotalLinea IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - SubTotal'
END
IF @Layout = 'SAT_2.2'
BEGIN
SELECT '<Concepto'+
dbo.fnXMLFloat('cantidad', @Cantidad)+
dbo.fnXML('unidad', CASE WHEN @Liverpool = 1 OR @Version = '2.2' THEN @UnidadClave ELSE @Unidad END)+
dbo.fnXML('noIdentificacion', @noIdentificacion)+
dbo.fnXML('descripcion', @ArtDescripcion1)+
dbo.fnXMLDecimal('valorUnitario', (@SubTotalLinea/NULLIF(@Cantidad, 0.0))+(ISNULL(@DescuentoLinea,0)+ISNULL(@DescuentoGlobalLinea,0))/@Cantidad, @CfgDecimales)+
dbo.fnXMLDecimal('importe', @SubTotalLinea+ISNULL(@DescuentoLinea,0)+ISNULL(@DescuentoGlobalLinea,0), @CfgDecimales)+
'>'
END
IF @Layout = 'SAT_2.2' AND @PrimerSerieLote IS NOT NULL AND @TipoAddenda NOT IN ('AMECE / LIVERPOOL', 'AMECE / CM')
BEGIN
IF @RenglonTipo = 'J'
DECLARE crSerieLoteMov CURSOR LOCAL FOR
SELECT s.SerieLote, dbo.fnLimpiarRFC(s.Propiedades), p.Fecha1, p.Aduana
FROM SerieLoteMov s
 WITH(NOLOCK) JOIN SerieLoteProp p  WITH(NOLOCK) ON p.Propiedades = s.Propiedades
WHERE s.Empresa = @Empresa AND s.Modulo = @Modulo AND s.ID = @ID AND s.RenglonID = @RenglonID
GROUP BY s.SerieLote, s.Propiedades, p.Fecha1, p.Aduana
ORDER BY s.SerieLote, s.Propiedades, p.Fecha1, p.Aduana
ELSE
DECLARE crSerieLoteMov CURSOR LOCAL FOR
SELECT s.SerieLote, dbo.fnLimpiarRFC(s.Propiedades), p.Fecha1, p.Aduana
FROM SerieLoteMov s
 WITH(NOLOCK) JOIN SerieLoteProp p  WITH(NOLOCK) ON p.Propiedades = s.Propiedades
WHERE s.Empresa = @Empresa AND s.Modulo = @Modulo AND s.ID = @ID AND s.RenglonID = @RenglonID AND s.Articulo = @Articulo AND ISNULL(s.SubCuenta, '') = ISNULL(@SubCuenta, '')
GROUP BY s.SerieLote, s.Propiedades, p.Fecha1, p.Aduana
ORDER BY s.SerieLote, s.Propiedades, p.Fecha1, p.Aduana
OPEN crSerieLoteMov
FETCH NEXT FROM crSerieLoteMov  INTO @SerieLote, @Pedimento, @PedimentoFecha, @Aduana
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC xpCFDSerieLote @Empresa, @Modulo, @Id, @Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @Articulo, @Subcuenta, @TipoAddenda, @LayOut, @SerieLote, @Pedimento OUTPUT, @PedimentoFecha OUTPUT, @Aduana OUTPUT
IF @Pedimento IS NOT NULL AND @Validar = 1
BEGIN
IF NULLIF(RTRIM(@Pedimento), '') IS NULL	SELECT @Ok = 10010, @OkRef = 'CFD - Pedimento'
IF @PedimentoFecha IS NULL					SELECT @Ok = 10010, @OkRef = 'CFD - Pedimento Fecha'
IF NULLIF(RTRIM(@Aduana), '') IS NULL		SELECT @Ok = 10010, @OkRef = 'CFD - Aduana'
END
IF @Layout = 'SAT_2.2' AND @Pedimento IS NOT NULL
SELECT '<InformacionAduanera'+
dbo.fnXML('numero', @Pedimento)+
dbo.fnXMLDatetimeFmt('fecha', @PedimentoFecha, 'AAAA-MM-DD')+
dbo.fnXML('aduana', @Aduana)+
'/>'
END
FETCH NEXT FROM crSerieLoteMov  INTO @SerieLote, @Pedimento, @PedimentoFecha, @Aduana
END
CLOSE crSerieLoteMov
DEALLOCATE crSerieLoteMov
END
IF @Layout = 'SAT_2.2' AND NULLIF(@CuentaPredial,'') IS NOT NULL
SELECT '<CuentaPredial'+dbo.fnXML('numero', @CuentaPredial)+ '/>'
EXEC xpConceptoComplemento @Estacion, @Modulo, @ID, @Layout, @Validar, @Version, @Renglon, @RenglonSub,
@Codigo, @Unidad, @UnidadClave, @UnidadFactor, @Articulo, @SubCuenta,
@ArtDescripcion1, @ArtDescripcion2, @ArtTipoEmpaque, @TipoEmpaqueClave, @TipoEmpaqueTipo,
@Paquetes, @CantidadEmpaque, @EAN13, @DUN14, @SKUCliente, @SKUEmpresa, @noIdentificacion,
@AgruparDetalle, @Cliente, @OrdenCompra, @TipoAddenda, @Cantidad, @Precio, @DescuentoLinea,
@DescuentoGlobalLinea, @Impuesto1Linea, @Impuesto2Linea, @SubTotalLinea,
@TotalLinea, @ImporteLinea, @Ok OUTPUT, @OkRef OUTPUT
IF @Layout = 'SAT_2.2'
SELECT '</Concepto>'
END
FETCH NEXT FROM crDetalle2 INTO @Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @Codigo, @Cantidad, @Unidad, @UnidadFactor, @Articulo, @SubCuenta, @SubTotalLinea,
@EAN13, @DUN14, @SKUCliente, @SKUEmpresa,
@PctDescuentoLinea, @DescuentoLinea, @DescuentoGlobalLinea, @Impuesto1, @Impuesto2, @Impuesto1Linea, @Impuesto2Linea,
@ArtDescripcion1, @ArtDescripcion2, @ArtTipoEmpaque, @Precio
END
CLOSE crDetalle2
DEALLOCATE crDetalle2
/** END de IF 'VTAS'   */
IF @Layout = 'SAT_2.2' AND NULLIF(@AnticiposFacturados,0) IS NOT NULL
BEGIN
SELECT '<Concepto'+
dbo.fnXMLFloat('cantidad', 1)+
dbo.fnXML('unidad', 'No Aplica')+
dbo.fnXML('noIdentificacion', 'Anticipo')+
dbo.fnXML('descripcion', 'Anticipos Facturados')+
dbo.fnXMLDecimal('valorUnitario', (@AnticiposFacturados-ISNULL(@AnticiposImpuestos,0.0))*-1, @CfgDecimales)+
dbo.fnXMLDecimal('importe', (@AnticiposFacturados-ISNULL(@AnticiposImpuestos,0.0))*-1, @CfgDecimales)+
'>'
SELECT '</Concepto>'
END
END
IF @Layout = 'SAT_2.2'
SELECT '</Conceptos>'
IF (@Version IN ('2.0','2.2') AND @Layout = 'SAT_2.2') OR @Layout IN ('AMECE', 'AMECE / LIVERPOOL', 'AMECE / CM')
BEGIN
IF @Layout = 'SAT_2.2'
BEGIN
SELECT '<Impuestos'+
dbo.fnXMLDecimal('totalImpuestosRetenidos', NULLIF(@RetencionTotal,0.0), @CfgDecimales)+
dbo.fnXMLDecimal('totalImpuestosTrasladados', @ImpuestosTotal, @CfgDecimales)+'>'
IF @RetencionFlete IS NOT NULL OR @RetencionPitex IS NOT NULL
BEGIN
SELECT '<Retenciones>'
SELECT '<Retencion'+
dbo.fnXML('impuesto', 'IVA')+
dbo.fnXMLDecimal('importe', ISNULL(@RetencionFlete,0.0)+ISNULL(@RetencionPitex,0.0), @CfgDecimales)+
'/>'
SELECT '</Retenciones>'
UPDATE CFD  WITH(ROWLOCK) SET Retencion1 = ISNULL(@RetencionFlete,0.0) + ISNULL(@RetencionPitex,0.0) WHERE Modulo = @Modulo AND ModuloID = @ID
END
IF @Modulo = 'VTAS'
AND (Exists (SELECT * FROM VentaTCalc V  WITH(NOLOCK) JOIN Art a  WITH(NOLOCK) ON v.articulo = a.Articulo WHERE v.ID = @ID AND a.Impuesto1Excento = 0 AND Impuesto1Total IS NOT NULL)
OR Exists (SELECT * FROM VentaTCalc V  WITH(NOLOCK) JOIN Art a  WITH(NOLOCK) ON v.articulo = a.Articulo WHERE v.ID = @ID AND a.Excento2 = 0 AND NULLIF(Impuesto2Total,0.0) IS NOT NULL))
SELECT '<Traslados>'
END
IF @Modulo = 'CXC'
BEGIN
SELECT '<Traslados>'
IF @Layout = 'SAT_2.2'
SELECT '<Traslado'+
dbo.fnXML('impuesto', 'IVA')+
dbo.fnXMLFloat2('tasa', @Impuesto1)+
dbo.fnXMLDecimal('importe', @Impuesto1Total, @CfgDecimales)+
'/>'
END
IF @Modulo = 'VTAS'
BEGIN
DECLARE crImpuesto1 CURSOR LOCAL FOR
SELECT v.Impuesto1, SUM(v.Impuesto1Total * CASE WHEN @MN = 1 THEN v.TipoCambio ELSE 1.0 END)
FROM VentaTCalc V
 WITH(NOLOCK) JOIN Art a  WITH(NOLOCK) ON v.articulo = a.Articulo
WHERE v.ID = @ID AND a.Impuesto1Excento = 0
GROUP BY v.Impuesto1
ORDER BY v.Impuesto1
OPEN crImpuesto1
FETCH NEXT FROM crImpuesto1 INTO @Impuesto1, @Impuesto1SubTotal
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Validar = 1
BEGIN
IF @Impuesto1 IS NULL	SELECT @Ok = 10010, @OkRef = 'CFD - Tasa Impuesto IVA'
IF @Impuesto1SubTotal IS NULL	SELECT @Ok = 10010, @OkRef = 'CFD - Importe Impuesto IVA'
END
IF NULLIF(@AnticiposImpuestos,0.0) IS NOT NULL
SELECT @TasaAnticipoImpuesto = @AnticiposImpuestos / (@AnticiposFacturados -@AnticiposImpuestos)
IF @TasaAnticipoImpuesto IS NOT NULL AND @TasaAnticipoImpuesto < (@Impuesto1/100+.01) AND @TasaAnticipoImpuesto > (@Impuesto1/100-.01)
SELECT @Impuesto1SubTotal = @Impuesto1SubTotal - @AnticiposImpuestos
/*ARL 25.02.2010*/
EXEC xpCFDVentaImpuesto @Estacion, @Modulo, @ID, @Layout, @Validar, @Empresa,  @Sucursal, @Cliente, 'IVA', @Impuesto1 OUTPUT, @Impuesto1SubTotal OUTPUT
IF @Layout = 'SAT_2.2'
SELECT '<Traslado'+
dbo.fnXML('impuesto', 'IVA')+
dbo.fnXMLFloat2('tasa', @Impuesto1)+
dbo.fnXMLDecimal('importe', @Impuesto1SubTotal, @CfgDecimales)+
'/>'
END
FETCH NEXT FROM crImpuesto1 INTO @Impuesto1, @Impuesto1SubTotal
END
CLOSE crImpuesto1
DEALLOCATE crImpuesto1
END
IF @Modulo = 'VTAS'
BEGIN
DECLARE crImpuesto2 CURSOR LOCAL FOR
SELECT v.Impuesto2, SUM(v.Impuesto2Total * CASE WHEN @MN = 1 THEN v.TipoCambio ELSE 1.0 END)
FROM VentaTCalc v
 WITH(NOLOCK) JOIN Art a  WITH(NOLOCK) ON v.Articulo = a.Articulo
WHERE v.ID = @ID AND a.Excento2 = 0
GROUP BY v.Impuesto2
ORDER BY v.Impuesto2
OPEN crImpuesto2
FETCH NEXT FROM crImpuesto2 INTO @Impuesto2, @Impuesto2SubTotal
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2 AND NULLIF(@Impuesto2, 0.0) IS NOT NULL
BEGIN
IF @Layout = 'SAT_2.2'
SELECT '<Traslado'+
dbo.fnXML('impuesto', 'IEPS')+
dbo.fnXMLFloat2('tasa', @Impuesto2)+
dbo.fnXMLDecimal('importe', @Impuesto2SubTotal, @CfgDecimales)+
'/>'
END
FETCH NEXT FROM crImpuesto2 INTO @Impuesto2, @Impuesto2SubTotal
END
CLOSE crImpuesto2
DEALLOCATE crImpuesto2
END
IF @Layout = 'SAT_2.2'
BEGIN
IF @Modulo = 'VTAS'
AND (Exists (SELECT * FROM VentaTCalc V  WITH(NOLOCK) JOIN Art a  WITH(NOLOCK) ON v.articulo = a.Articulo WHERE v.ID = @ID AND a.Impuesto1Excento = 0 AND Impuesto1Total IS NOT NULL)
OR Exists (SELECT * FROM VentaTCalc V  WITH(NOLOCK) JOIN Art a  WITH(NOLOCK) ON v.articulo = a.Articulo WHERE v.ID = @ID AND a.Excento2 = 0 AND NULLIF(Impuesto2Total,0.0) IS NOT NULL))
SELECT '</Traslados>'
IF @Modulo = 'CXC'
SELECT '</Traslados>'
SELECT '</Impuestos>'
END
END
IF @Validar = 1 AND @TipoAddenda = 'DETALLISTA'
EXEC spCFDDetallista @Estacion, @Modulo, @ID, '', 1, @ok OUTPUT, @OkRef OUTPUT
IF @LayOut = 'SAT_2.2' AND @TipoAddenda = 'DETALLISTA'
EXEC spCFDDetallista @Estacion, @Modulo, @ID, 'Detallista'
IF @Layout = 'SAT_2.2'
SELECT '<Addenda>{@Addenda}</Addenda>'
IF @Layout = 'EDIFACT'
EXEC spConvertirEDIFACT
IF @Layout = 'SAT_2.2'
BEGIN
SELECT '</Comprobante>'
IF @Validar = 0
BEGIN
IF @Estatus = 'CANCELADO' AND (SELECT NULLIF(FechaCancelacion,'') FROM CFD WHERE Modulo = @Modulo AND ModuloID = @ID) IS NULL
UPDATE CFD
 WITH(ROWLOCK) SET FechaCancelacion = GETDATE()
WHERE Modulo = @Modulo AND ModuloID = @ID
ELSE
UPDATE CFD
 WITH(ROWLOCK) SET Fecha = @Fecha, Ejercicio = YEAR(@Fecha), Periodo = MONTH(@Fecha), Empresa = @Empresa, MovID = @MovID, Serie = @Serie, Folio = @Folio, RFC = @ClienteRFC,
Aprobacion = CONVERT(varchar, YEAR(@fechaAprobacion))+CONVERT(varchar, @noAprobacion), Importe = @SubTotal, Impuesto1 = @Impuesto1Total, Impuesto2 = @Impuesto2Total,
TipoCambio = CASE WHEN @MN=1 THEN 1 ELSE @TipoCambio END
WHERE Modulo = @Modulo AND ModuloID = @ID
END
END
SET CONCAT_NULL_YIELDS_NULL OFF
RETURN
END

