SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarCFDCoppel
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
@ClienteDireccion		varchar(100),
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
@formaDePago		varchar(100),
@metodoDePago		varchar(100),
@Importe			money,
@SubTotal			money,
@Descuento			varchar(50),
@DescuentosTotales		money,
@ImpuestosTotal		money,
@Total			money,
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
@Precio			money,
@PrecioLinea		money,
@PrecioSinDescuentos	money,
@SubTotalLinea		money,
@TotalLinea			money,
@SerieLote			varchar(50),
@Pedimento			varchar(20),
@PedimentoFecha		datetime,
@Aduana			varchar(50),
@AduanaGLN			varchar(50),
@AduanaCiudad		varchar(50),
@Impuesto1			float,
@Impuesto1Linea		money,
@Impuesto1SubTotal		money,
@Impuesto1Total		money,
@Impuesto1Promedio		float,
@Impuesto2			float,
@Impuesto2Linea		money,
@Impuesto2SubTotal		money,
@Impuesto2Total		money,
@Impuesto2Promedio		float,
@PctDescuentoLinea		float,
@DescuentoLinea		money,
@DescuentoGlobalLinea	money,
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
@ImporteDescuentoGlobal	money,
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
@MonedaClave		char(3),
@UnidadClave		char(3),
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
@ImporteLinea		money,
@SumaImporteLinea		money,
@SumaCantidad		money,
@SumaSubTotalLinea		money,
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
@CompSubTotal 		money,
@CompDescuentoLineal 	money,
@CompImporteDescuentoGlobal money,
@CompImpuesto1Total 	money,
@CompImpuesto2Total 	money,
@CompPrecio 		money,
@PersonalCobrador 		varchar(10),
@emailCobrador 		varchar(50),
@AnticiposFacturados	money,
@AnticiposImpuestos		money,
@AgruparDetalle 		int,
@ArtUnidad 			varchar(20),
@UtilizaPaquete 		int,
@SeFacturaPor		varchar(50),
@MovIDCFD			varchar(20),
@Agente				varchar(20),
@DescripcionExtra	varchar(100),
@Coppel bit, 
@CadenaOriginal varchar(max), 
@CodigoCoppel varchar(20), 
@TallaCoppel varchar(20), 
@TotalCajasRenglon int,
@TipoProveedor varchar(20),
@FleteCajaEsPropia bit
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
IF @Layout = 'COPPEL'         SELECT @Coppel = 1
IF @Modulo = 'VTAS'
SELECT @Estatus = Estatus, @Empresa = Empresa, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @FormaEnvio = FormaEnvio, @Condicion = Condicion, @Vencimiento = Vencimiento, @Cliente = Cliente, @EnviarA = EnviarA, @Descuento = Descuento, @DescuentoGlobal = DescuentoGlobal,
@OrdenCompra = OrdenCompra, @FechaOrdenCompra = FechaOrdenCompra, @Departamento = Departamento, @ZonaImpuesto = ZonaImpuesto, @Moneda = Moneda, @TipoCambio = TipoCambio, @FechaRequerida = FechaRequerida, @Observaciones = Observaciones,
@Referencia = Referencia, @FechaEmision = FechaEmision, @Origen = Origen, @OrigenID = OrigenID,
@AnticiposFacturados = AnticiposFacturados, @Anticiposimpuestos = AnticiposImpuestos, @Agente = Agente
FROM Venta
WITH(NOLOCK) WHERE ID = @ID
IF @Modulo = 'CXC'
BEGIN
SELECT @Estatus = Estatus, @Empresa = Empresa, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Cliente = Cliente, @EnviarA = ClienteEnviarA,
@Moneda = Moneda, @TipoCambio = TipoCambio, @Observaciones = Observaciones, @Concepto = Concepto,
@Referencia = Referencia, @FechaEmision = FechaEmision, @Impuesto1Total = ISNULL(Impuestos,0), @ImpuestosTotal = ISNULL(Impuestos,0), @Importe = Importe
FROM CXC
WITH(NOLOCK) WHERE ID = @ID
SELECT @ImporteDescuentoGlobal = 0
IF @Importe = 0.0 OR @ImpuestosTotal = 0.0
SELECT @Impuesto1 = 0.00
ELSE
SELECT @Impuesto1 = ROUND((@ImpuestosTotal*100)/@Importe,2)
END
IF @Layout = 'SAT'
SELECT @MN = SAT_MN
FROM EmpresaCFD
WITH(NOLOCK) WHERE Empresa = @Empresa
IF @MN = 1 AND @Modulo = 'CXC'
SELECT @Impuesto1Total = @Impuesto1Total*@TipoCambio, @ImpuestosTotal = @ImpuestosTotal*@TipoCambio , @Importe = @Importe*@TipoCambio
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
SELECT @SubTotal = Round(@Importe - @ImporteDescuentoGlobal - ISNULL(@AnticiposFacturados,0) + ISNULL(@AnticiposImpuestos,0),2)
SELECT @ImpuestosTotal = ROUND(@ImpuestosTotal - ISNULL(@AnticiposImpuestos,0),2)
SELECT @Total = @SubTotal + @ImpuestosTotal
SELECT @ImporteEnLetra = dbo.fnNumeroEnEspanol(@Total, @Moneda)
SELECT @Impuesto1Total = ROUND(@Impuesto1Total - ISNULL(@AnticiposImpuestos,0),2)
SELECT @ClienteRFC = dbo.fnLimpiarRFC(RFC), @ClienteNombre = Nombre, @ClienteDireccion = Direccion, @ClienteDireccionNumero = DireccionNumero, @ClienteDireccionNumeroInt = DireccionNumeroInt,
@ClienteColonia = Colonia, @ClientePoblacion = Poblacion, @ClienteObservaciones = EntreCalles/*Observaciones*/, @ClienteDelegacion = Delegacion, @ClienteEstado = Estado,
@ClientePais = Pais, @ClienteCodigoPostal = CodigoPostal, @ClienteGLN = GLN, @ClienteTelefonos = Telefonos, @ClienteIEPS = IEPS, @PersonalCobrador = PersonalCobrador
FROM Cte
WITH(NOLOCK) WHERE Cliente = @Cliente
SELECT @emailCobrador = email FROM Personal WITH(NOLOCK) WHERE Personal = @PersonalCobrador
SELECT @ReceptorID = ReceptorID, @TipoAddenda = TipoAddenda,
@AddendaVersion = CASE WHEN VersionFecha < @Fecha OR VersionFecha IS NULL THEN Version ELSE VersionAnterior END
FROM CteCFD
WITH(NOLOCK) WHERE Cliente = @Cliente
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
@EmpresaRepresentante = Representante, @EmpresaRegistroPatronal = RegistroPatronal, @EmpresaGLN = GLN, @EmpresaTelefonos = Telefonos
FROM Empresa
WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT @noCertificado = noCertificado,
@Version = CASE WHEN versionFecha<@Fecha OR versionFecha IS NULL THEN version ELSE versionAnterior END,
@EmpresaEAN13 = EAN13, @EmpresaDUN14 = DUN14, @EmpresaSKUCliente = SKU, @EmpresaSKUEmpresa = SKUEmpresa,
@EmpresaSKUCodigoInterno = ISNULL(SKUCodigoInterno, 0), @ModoPruebas = ModoPruebas, @PaqueteEsCantidad = PaqueteEsCantidad,
@AgruparDetalle = AgruparDetalle
FROM EmpresaCFD
WITH(NOLOCK) WHERE Empresa = @Empresa
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
SELECT @TipoCondicion = TipoCondicion, @formaDePago = CFD_formaDePago, @metodoDePago = CFD_metodoDePago, @DiasVencimiento = ISNULL(DiasVencimiento,1),
@ProntoPago = ProntoPago, @DescuentoProntoPago = DescuentoProntoPago
FROM Condicion
WITH(NOLOCK) WHERE Condicion = @Condicion
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
IF @MovTipo IN ('VTAS.D', 'VTAS.B')
BEGIN
SELECT @ReferenciaFecha = Fecha FROM CFD WITH(NOLOCK) WHERE Empresa = @Empresa AND MovID = @Referencia
IF @@ROWCOUNT = 0
SELECT @ReferenciaFecha = FechaRegistro FROM Venta WITH(NOLOCK) WHERE Empresa = @Empresa AND MovID = @Referencia AND Estatus IN ('CONCLUIDO', 'PENDIENTE')
END
SELECT @FleteCajaEsPropia = EsPropia FROM FormaEnvio WITH(NOLOCK) WHERE Formaenvio = @FormaEnvio
SELECT @Antecedente      = CASE WHEN @Estatus='CANCELADO' THEN @MovID WHEN @MovTipo IN ('VTAS.D', 'VTAS.B', 'CXC.NC', 'CXC.CA') THEN @Referencia      ELSE @OrdenCompra      END
SELECT @AntecedenteFecha = CASE WHEN @Estatus='CANCELADO' THEN @Fecha WHEN @MovTipo IN ('VTAS.D', 'VTAS.B', 'CXC.NC', 'CXC.CA') THEN @ReferenciaFecha ELSE @FechaOrdenCompra END
SELECT @ReferenciaEnvio = dbo.fnDateTimeFmt(GETDATE(), 'AAMMDDHHMMSSMM')
EXEC xpGenerarCFDEncabezado   @Estacion, @Modulo, @ID, @Layout, @Validar, @Empresa,  @Sucursal, @Cliente, @EnviarA, @EmpresaGLN, @Version,
@Mov, @MovID, @Estatus, @ConsecutivoModulo, @ConsecutivoMov, @Fecha,  @Serie, @Folio, @MovTipo, @tipoDeComprobante, @TipoAddenda, @AddendaVersion,
@Moneda, @TipoCambio, @Liverpool, @Gigante, @ComercialMexicana, @Elektra, @EHB, @Origen, @OrigenID, @SucursalGLN OUTPUT, @ClienteGLN OUTPUT,
@EnviarAGLN OUTPUT, @Referencia OUTPUT,  @ReferenciaFecha OUTPUT, @FormaEnvio OUTPUT, @Condicion OUTPUT, @Vencimiento OUTPUT, @formaDePago OUTPUT,
@metodoDePago OUTPUT,  @EmisorID OUTPUT, @ReceptorID OUTPUT,  @ProveedorID OUTPUT,  @OrdenCompra OUTPUT,  @FechaOrdenCompra OUTPUT, @DepartamentoClave OUTPUT,
@DepartamentoNombre OUTPUT, @DepartamentoContacto OUTPUT, @Observaciones OUTPUT, @EnviarAClave OUTPUT, @Embarque OUTPUT,  @EmbarqueFecha OUTPUT,
@Recibo OUTPUT,  @ReciboFecha OUTPUT, @MonedaClave OUTPUT, @FechaRequerida OUTPUT, @TipoCondicion OUTPUT, @DescuentoClave OUTPUT, @Antecedente OUTPUT,
@AntecedenteFecha OUTPUT, @ReferenciaEnvio OUTPUT, @Ok OUTPUT,  @OkRef OUTPUT, @AgruparDetalle OUTPUT
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
IF NULLIF(RTRIM(@EmpresaRFC), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Empresa RFC'
IF LEN(@EmpresaRFC) NOT IN (12,13) SELECT @Ok = 10010, @OkRef = 'CFD - Empresa RFC Requiere 12 o 13 Caracteres'
IF NULLIF(RTRIM(@EmpresaNombre), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Empresa Nombre'
IF NULLIF(RTRIM(@ClienteRFC), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Cliente RFC'
IF LEN(@ClienteRFC) NOT IN (12,13) SELECT @Ok = 10010, @OkRef = 'CFD - Cliente RFC Requiere 12 o 13 Caracteres'
IF NULLIF(RTRIM(@ClientePais), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Cliente Pais'
IF NULLIF(RTRIM(@EmpresaDireccion), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Empresa Calle'
IF NULLIF(RTRIM(@EmpresaDelegacion), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Empresa Municipio'
IF NULLIF(RTRIM(@EmpresaEstado), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Empresa Estado'
IF NULLIF(RTRIM(@EmpresaPais), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Empresa Pais'
IF NULLIF(RTRIM(@EmpresaCodigoPostal), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Empresa Codigo Postal'
END
IF @Modulo = 'VTAS' AND @Coppel =1
BEGIN
SELECT @TipoProveedor = @EmisorID
SELECT @TotalCajas = SUM(Paquete) FROM VentaD WHERE ID = @ID
END
IF @Layout LIKE 'COPPEL'
BEGIN
SELECT '<cfdi:Addenda>'+
'<requestForPayment'+
' xmlns:xsi='+char(34)+'http://www.w3.org/2001/XMLSchema-instance'+char(34)+' '+
dbo.fnXML('type', 'SimpleInvoiceType')+
dbo.fnXML('contentVersion', '1.0')+
dbo.fnXML('documentStructureVersion', 'CPLR1.0')+
dbo.fnXML('documentStatus', CASE WHEN @Estatus='CANCELADO' THEN 'DELETE' ELSE 'ORIGINAL' END)+
dbo.fnXMLDatetimeFmt('DeliveryDate', @Fecha, 'AAAA-MM-DD') +
'>'
SELECT '<requestForPaymentIdentification>'+
dbo.fnTag('entityType', CASE @MovTipo WHEN 'VTAS.D' THEN 'CREDIT_NOTE' WHEN 'VTAS.B' THEN 'DEBIT_NOTE' ELSE 'INVOICE' END)+
dbo.fnTag('uniqueCreatorIdentification', @MovID)+
'</requestForPaymentIdentification>'
SELECT '<orderIdentification>'+
'<referenceIdentification'+dbo.fnXML('type', 'ON')+'>'+ISNULL(@Antecedente, '')+'</referenceIdentification>'+
dbo.fnTagDateTimeFmt('ReferenceDate', @AntecedenteFecha, 'AAAA-MM-DD')+
CASE WHEN @TipoProveedor = '1' THEN dbo.fnTagDateTimeFmt('FechaPromesaEnt', @EmbarqueFecha, 'AAAA-MM-DD') ELSE '' END +
'</orderIdentification>'
SELECT '<seller>'+
dbo.fnTag('gln', @EmpresaGLN)+
'<alternatePartyIdentification'+dbo.fnXML('type', 'SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY')+'>'+ISNULL(@ProveedorIDDeptoEnviarA, @ProveedorID)+'</alternatePartyIdentification>'+
dbo.fnTag('IndentificaTipoProv', @TipoProveedor)+
'</seller>'
IF /*@Gigante = 0 AND*/ @Liverpool = 0
BEGIN
SELECT '<shipTo>'+
dbo.fnTag('gln', @EnviarAGLN)
IF @Gigante = 0
SELECT   '<nameAndAddress>'+
dbo.fnTag('name', LEFT(@EnviarANombre,35))+
dbo.fnTag('streetAddressOne', LEFT(@EnviarADireccion+' '+@EnviarADireccionNumero+' '+ISNULL(@EnviarADireccionNumeroInt,'')+' '+ISNULL(@EnviarAColonia,''), 35))+
dbo.fnTag('city', LEFT(@EnviarAEstado, 35))+
dbo.fnTag('postalCode', LEFT(@EnviarACodigoPostal, 9))+
CASE WHEN @TipoProveedor = '2' THEN dbo.fnTag('bodegaEnt', @EnviarAClave) ELSE '' END +
'</nameAndAddress>'
IF @TipoProveedor = '1'
SELECT dbo.fnTag('BodegaDestino', @EnviarAClave) +
dbo.fnTag('BodegaReceptora', @EntregaMercancia)
SELECT '</shipTo>'
END
IF @TipoProveedor = '1' AND EXISTS (SELECT s.Propiedades FROM SerieLoteMov s  WITH(NOLOCK) JOIN SerieLoteProp p  WITH(NOLOCK) ON p.Propiedades = s.Propiedades WHERE s.Empresa = @Empresa AND s.Modulo = @Modulo AND s.ID = @ID)
BEGIN
SELECT '<Customs>'
DECLARE crCustoms CURSOR LOCAL FOR
SELECT dbo.fnLimpiarRFC(s.Propiedades)
FROM SerieLoteMov s
 WITH(NOLOCK) JOIN SerieLoteProp p  WITH(NOLOCK) ON p.Propiedades = s.Propiedades
WHERE s.Empresa = @Empresa AND s.Modulo = @Modulo AND s.ID = @ID
GROUP BY s.Propiedades
ORDER BY s.Propiedades
OPEN crCustoms
FETCH NEXT FROM crCustoms  INTO @Pedimento
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT '<alternatePartyIdentification'+dbo.fnXML('type', 'TN')+'>'+@Pedimento+'</alternatePartyIdentification>'
END
FETCH NEXT FROM crCustoms  INTO @Pedimento
END
CLOSE crCustoms
DEALLOCATE crCustoms
SELECT '</Customs>'
END
SELECT '<currency'+dbo.fnXML('currencyISOCode', @MonedaClave)+'>'+
dbo.fnTag('currencyFunction', 'BILLING_CURRENCY')+
dbo.fnTagFloat('rateOfChange', @TipoCambio)+
'</currency>'
IF @TipoProveedor = '2'
SELECT '<TotalLotes>' + dbo.fnTag('cantidad', @TotalCajas) +'</TotalLotes>'
IF @TipoProveedor = '1'
BEGIN
SELECT '<FleteCaja'+dbo.fnXML('type', CASE WHEN @FleteCajaEsPropia = 1 THEN 'SELLER_PROVIDED' ELSE 'BUYER_PROVIDED' END)+'>'+@FormaEnvio+'</FleteCaja>'
END
IF @TipoProveedor <> '2'
SELECT '<allowanceCharge'+dbo.fnXML('settlementType', 'OFF_INVOICE')+dbo.fnXML('allowanceChargeType', 'ALLOWANCE_GLOBAL')+'>'+
dbo.fnTag('specialServicesType', ISNULL(NULLIF(RTRIM(@DescuentoClave), ''), 'AJ'))+
'<monetaryAmountOrPercentage>'+
'<rate'+dbo.fnXML('base', 'INVOICE_VALUE')+'>'+
dbo.fnTagFloat('percentage', ISNULL(@DescuentoGlobal, 0.0))+
'</rate>'+
'</monetaryAmountOrPercentage>'+
'</allowanceCharge>'
END
IF @Modulo = 'VTAS'
BEGIN
IF @AgruparDetalle = 1
DECLARE crDetalle CURSOR LOCAL FOR
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
DECLARE crDetalle CURSOR LOCAL FOR
SELECT d.Renglon, d.RenglonSub, d.RenglonID, d.RenglonTipo, d.Codigo, ISNULL(d.CantidadNeta,0.0), ISNULL(NULLIF(RTRIM(d.Unidad), ''), a.Unidad), ISNULL(NULLIF(d.Factor, 0.0), 1.0), d.Articulo, d.SubCuenta, d.SubTotal * (CASE WHEN @MN = 1 THEN d.TipoCambio ELSE 1.0 END),
dbo.fnQueCodigo(@EmpresaEAN13, d.Articulo, d.SubCuenta, d.Codigo, @Cliente), dbo.fnQueCodigo(@EmpresaDUN14, d.Articulo, d.SubCuenta, d.Codigo, @Cliente), dbo.fnQueCodigo(@EmpresaSKUCliente, d.Articulo, d.SubCuenta, d.Codigo, @Cliente), dbo.fnQueCodigo(@EmpresaSKUEmpresa, d.Articulo, d.SubCuenta, d.Codigo, @Cliente),
d.DescuentoLinea, ISNULL(d.DescuentoLineal, 0.0), ISNULL(d.ImporteDescuentoGlobal, 0.0), ISNULL(d.Impuesto1,0), ISNULL(d.Impuesto2,0), ISNULL(d.Impuesto1Total, 0.0), ISNULL(d.Impuesto2Total, 0.0),
a.Descripcion1, a.Descripcion2, a.TipoEmpaque, d.Precio
FROM VentaTCalc d
 WITH(NOLOCK) JOIN Art a  WITH(NOLOCK) ON a.Articulo = d.Articulo
WHERE d.ID = @ID AND d.RenglonTipo <> 'C'
OPEN crDetalle
FETCH NEXT FROM crDetalle  INTO @Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @Codigo, @Cantidad, @Unidad, @UnidadFactor, @Articulo, @SubCuenta, @SubTotalLinea,
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
IF @Layout = 'EDIFACT' AND @UnidadClave = 'PCE' SELECT @UnidadClave = 'EA'
IF @Layout = 'AMECE / GIGANTE' AND @UnidadClave = 'PCE' SELECT @UnidadClave = 'PZA'
EXEC xpGenerarCFDDetalle @Estacion, @Modulo, @ID, @Layout, @Version, @Renglon, @RenglonSub,
@Cantidad OUTPUT, @Codigo OUTPUT, @Unidad OUTPUT, @UnidadClave OUTPUT, @UnidadFactor OUTPUT, @Articulo OUTPUT, @SubCuenta OUTPUT,
@ArtDescripcion1 OUTPUT, @ArtDescripcion2 OUTPUT, @ArtTipoEmpaque OUTPUT, @TipoEmpaqueClave OUTPUT, @TipoEmpaqueTipo OUTPUT,
@Paquetes OUTPUT, @CantidadEmpaque OUTPUT, @EAN13 OUTPUT, @DUN14 OUTPUT, @SKUCliente OUTPUT, @SKUEmpresa OUTPUT, @noIdentificacion OUTPUT,
@AgruparDetalle, @Cliente, @OrdenCompra OUTPUT
IF @Cantidad = 0 SELECT @SubTotalLinea  =  0 ELSE SELECT @SubTotalLinea  = ROUND(@SubTotalLinea/@Cantidad,2) * @Cantidad
SELECT @TotalLinea = @SubTotalLinea + ISNULL(@Impuesto1Linea, 0.0) + ISNULL(@Impuesto2Linea, 0.0)
SELECT @ImporteLinea = @SubTotalLinea + @DescuentoGlobalLinea
SELECT @Conteo = @Conteo + 1,
@SumaCantidad = @SumaCantidad + ISNULL(@Cantidad, 0.0),
@SumaSubTotalLinea = @SumaSubTotalLinea + ISNULL(@SubTotalLinea, 0.0),
@SumaImporteLinea = @SumaImporteLinea + ISNULL(@ImporteLinea, 0.0)
IF @Cantidad = 0 SELECT @PrecioLinea = 0 ELSE SELECT @PrecioLinea = ROUND(convert(money, @SubTotalLinea / NULLIF(@Cantidad, 0.0)),2)
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
IF @Modulo = 'VTAS' AND @Coppel = 1
BEGIN
SELECT @CodigoCoppel = Codigo, @TallaCoppel = Descripcion FROM ArtIdioma WHERE Articulo = @Articulo AND Idioma = @Cliente
SELECT @TotalCajasRenglon  = @Paquetes
END
IF @Validar = 1
BEGIN
IF NULLIF(RTRIM(@Cantidad), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Cantidad'
IF NULLIF(RTRIM(@ArtDescripcion1), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Concepto'
IF @SubTotalLinea IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - SubTotal'
END
IF @Layout = 'COPPEL'
BEGIN
SELECT '<lineItem'+
dbo.fnXML('type', 'SimpleInvoiceLineItemType')+
dbo.fnXMLInt('number', @Conteo)
+'>'
SELECT '<tradeItemIdentification>'
SELECT '<gtin>'+ISNULL(@EAN13,'')+'</gtin>'
SELECT '</tradeItemIdentification>'
SELECT '<alternateTradeItemIdentification'+dbo.fnXML('type', CASE WHEN @EmpresaSKUCodigoInterno=1 THEN 'SUPPLIER_ASSIGNED' ELSE 'BUYER_ASSIGNED' END)+'>'+
CASE WHEN @EmpresaSKUCodigoInterno=1 THEN RTRIM(@SKUEmpresa) ELSE RTRIM(@SKUCliente) END+
'</alternateTradeItemIdentification>'
IF @TipoProveedor = '2'
SELECT '<codigoTallaInternoCop>' +
dbo.fnTag('codigo', @CodigoCoppel) +
dbo.fnTag('talla', @TallaCoppel) +
'</codigoTallaInternoCop>'
SELECT '<tradeItemDescriptionInformation'+dbo.fnXML('language', 'ES')+'>'+
dbo.fnTag('longText', LEFT(@ArtDescripcion1, 35))+
'</tradeItemDescriptionInformation>'
IF ABS(@SubTotalLinea) > 0.01
BEGIN
SELECT '<invoicedQuantity'+dbo.fnXML('unitOfMeasure', @UnidadClave)+'>'+
CONVERT(varchar(20), ISNULL(@Cantidad, 0.0))+
'</invoicedQuantity>'
IF @Gigante = 0 AND @TipoProveedor <> '1'
SELECT '<aditionalQuantity'+dbo.fnXML('QuantityType', 'NUM_CONSUMER_UNITS')+'>'+
CONVERT(varchar(20), @Paquetes)+
'</aditionalQuantity>'
END
ELSE
BEGIN
SELECT '<invoicedQuantity'+dbo.fnXML('unitOfMeasure', @UnidadClave)+'>0.00</invoicedQuantity>'
IF @TipoProveedor <> '1'
BEGIN
IF @UnidadFactor <> 1.0
SELECT '<aditionalQuantity'+dbo.fnXML('QuantityType', 'NUM_CONSUMER_UNITS')+'>'+
CONVERT(varchar(20), @Cantidad*@UnidadFactor)+
'</aditionalQuantity>'
ELSE
SELECT '<aditionalQuantity'+dbo.fnXML('QuantityType', 'FREE_GOODS')+'>'+
CONVERT(varchar(20), ISNULL(@Cantidad, 0.0))+
'</aditionalQuantity>'
END
END
SELECT '<grossPrice>'+dbo.fnTagMoney('Amount', @ImporteLinea/NULLIF(@Cantidad, 0.0))+'</grossPrice>'
SELECT '<netPrice>'  +dbo.fnTagMoney('Amount', @SubTotalLinea/NULLIF(@Cantidad, 0.0))+'</netPrice>'
IF @TipoProveedor = '1'
SELECT '<modeloInformation>' +
dbo.fnTag('longText', @CodigoCoppel) +
'</modeloInformation>'
IF @Gigante = 0
BEGIN
IF NULLIF(@PctDescuentoLinea, 0.0) IS NOT NULL
SELECT '<allowanceCharge'+dbo.fnXML('allowanceChargeType', 'ALLOWANCE_GLOBAL')+'>'+
dbo.fnTag('specialServicesType', 'PAD')+
'<monetaryAmountOrPercentage>'+
dbo.fnTagFloat('percentagePerUnit', @PctDescuentoLinea)+
'</monetaryAmountOrPercentage>'+
'</allowanceCharge>'
END
SELECT '<totalLineAmount>'+
'<grossAmount>'+
dbo.fnTagMoney('Amount', @ImporteLinea)+
'</grossAmount>'
SELECT '<netAmount>'+
dbo.fnTagMoney('Amount', @SubTotalLinea)+
'</netAmount>'
SELECT '</totalLineAmount>'
SELECT '</lineItem>'
END
END
FETCH NEXT FROM crDetalle  INTO @Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @Codigo, @Cantidad, @Unidad, @UnidadFactor, @Articulo, @SubCuenta, @SubTotalLinea,
@EAN13, @DUN14, @SKUCliente, @SKUEmpresa,
@PctDescuentoLinea, @DescuentoLinea, @DescuentoGlobalLinea, @Impuesto1, @Impuesto2, @Impuesto1Linea, @Impuesto2Linea,
@ArtDescripcion1, @ArtDescripcion2, @ArtTipoEmpaque, @Precio
END
CLOSE crDetalle
DEALLOCATE crDetalle
/** END de IF 'VTAS'   */
END
IF @Layout = 'COPPEL'
BEGIN
SELECT '<totalAmount>'+
dbo.fnTagMoney('Amount', @Importe)+
'</totalAmount>'
SELECT '<TotalAllowanceCharge'+dbo.fnXML('allowanceOrChargeType', 'ALLOWANCE')+'>'+
dbo.fnTag('specialServicesType', 'TD')+
dbo.fnTagMoney('Amount', ISNULL(@ImporteDescuentoGlobal, 0.0))+
'</TotalAllowanceCharge>'
SELECT '<baseAmount>'+
dbo.fnTagMoney('Amount', @SubTotal)+
'</baseAmount>'
END
IF @Version = '1.0' AND @Layout = 'SAT'
BEGIN
IF @Layout = 'SAT'
BEGIN
SELECT '<Impuestos><Traslados>'
SELECT '<Traslado'+
dbo.fnXML('impuesto', 'IVA')+
dbo.fnXMLMoney('importe', @Impuesto1Total)+
'/>'
IF @Impuesto2Total <> 0.0
SELECT '<Traslado'+
dbo.fnXML('impuesto', 'IEPS')+
dbo.fnXMLMoney('importe', @Impuesto2Total)+
'/>'
SELECT '</Traslados></Impuestos>'
END
END
IF (@Version = '2.0' AND @Layout = 'SAT') OR @Layout IN ('COPPEL')
BEGIN
IF @Modulo = 'VTAS'
BEGIN
DECLARE crImpuesto1 CURSOR LOCAL FOR
SELECT Impuesto1, SUM(Impuesto1Total * CASE WHEN @MN = 1 THEN TipoCambio ELSE 1.0 END)
FROM VentaTCalc
WITH(NOLOCK) WHERE ID = @ID
GROUP BY Impuesto1
ORDER BY Impuesto1
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
/*ARL 25.02.2010*/
EXEC xpCFDVentaImpuesto @Estacion, @Modulo, @ID, @Layout, @Validar, @Empresa,  @Sucursal, @Cliente, 'IVA', @Impuesto1 OUTPUT, @Impuesto1SubTotal OUTPUT
IF @Layout ='COPPEL'
BEGIN
SELECT '<tax'+dbo.fnXML('type', 'VAT')+'>'
SELECT dbo.fnTagFloat('taxPercentage', @Impuesto1)+
dbo.fnTagMoney('taxAmount', @Impuesto1SubTotal)+
dbo.fnTag('taxCategory', 'TRANSFERIDO')
SELECT '</tax>'
END
END
FETCH NEXT FROM crImpuesto1 INTO @Impuesto1, @Impuesto1SubTotal
END
CLOSE crImpuesto1
DEALLOCATE crImpuesto1
END
IF @Modulo = 'VTAS'
BEGIN
DECLARE crImpuesto2 CURSOR LOCAL FOR
SELECT Impuesto2, SUM(Impuesto2Total * CASE WHEN @MN = 1 THEN TipoCambio ELSE 1.0 END)
FROM VentaTCalc
WITH(NOLOCK) WHERE ID = @ID
GROUP BY Impuesto2
ORDER BY Impuesto2
OPEN crImpuesto2
FETCH NEXT FROM crImpuesto2 INTO @Impuesto2, @Impuesto2SubTotal
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2 AND NULLIF(@Impuesto2, 0.0) IS NOT NULL
BEGIN
IF @Layout = 'COPPEL'
BEGIN
SELECT '<tax'+dbo.fnXML('type', 'GST')+'>	'
SELECT dbo.fnTagFloat('taxPercentage', @Impuesto2)+
dbo.fnTagMoney('taxAmount', @Impuesto2SubTotal)+
dbo.fnTag('taxCategory', 'TRANSFERIDO')
SELECT '</tax>'
END
END
FETCH NEXT FROM crImpuesto2 INTO @Impuesto2, @Impuesto2SubTotal
END
CLOSE crImpuesto2
DEALLOCATE crImpuesto2
END
END
IF @Layout = 'COPPEL'
BEGIN
SELECT '<payableAmount>'+
dbo.fnTagMoney('Amount', @Total)+
'</payableAmount>'
IF @Coppel = 1
BEGIN
SELECT '<cadenaOriginal>'
SELECT '<Cadena>'
SELECT  '{@CadenaOriginal}'
SELECT '</Cadena>'
SELECT '</cadenaOriginal>'
END
END
IF @Layout = 'COPPEL'
SELECT '</requestForPayment>'+
'</cfdi:Addenda>'
SET CONCAT_NULL_YIELDS_NULL OFF
RETURN
END

