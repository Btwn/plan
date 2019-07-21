SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDDetallista
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
@MovIDCFD			varchar(20)
IF @Modulo NOT IN ('VTAS') RETURN
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
IF @Layout = 'AMECE / LIVERPOOL' 	SELECT @Liverpool 	     = 1 ELSE
IF @Layout = 'AMECE / GIGANTE'   	SELECT @Gigante   	     = 1 ELSE
IF @Layout = 'AMECE / CM' 	   	SELECT @ComercialMexicana    = 1 ELSE
IF @Layout = 'INTERFACTURA / ELEKTRA' SELECT @Elektra 	     = 1 ELSE
IF @Layout IN ('INTERFACTURA / EHB', 'INTERFACTURA / HEB')	SELECT @EHB 		     = 1
IF @Layout = 'SORIANA' SELECT @Layout = 'SORIANA CEDIS'
IF @Layout IN ('CHEDRAUI', 'EDIFACT')
CREATE TABLE #CFD (
ID 		int 		NOT NULL IDENTITY(1,1) PRIMARY KEY,
Requerido	bit		NULL,
Campo		varchar(100)	NULL,
Dato 		varchar(255) 	NULL)
IF @Layout = 'EDIFACT'
CREATE TABLE #EDI (
ID 		int 		NOT NULL IDENTITY(1,1) PRIMARY KEY,
Requerido	bit		NULL,
Campo		varchar(100)	NULL,
Dato 		varchar(255) 	NULL)
IF @Modulo = 'VTAS'
SELECT @Estatus = Estatus, @Empresa = Empresa, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @FormaEnvio = FormaEnvio, @Condicion = Condicion, @Vencimiento = Vencimiento, @Cliente = Cliente, @EnviarA = EnviarA, @Descuento = Descuento, @DescuentoGlobal = DescuentoGlobal,
@OrdenCompra = OrdenCompra, @FechaOrdenCompra = FechaOrdenCompra, @Departamento = Departamento, @ZonaImpuesto = ZonaImpuesto, @Moneda = Moneda, @TipoCambio = TipoCambio, @FechaRequerida = FechaRequerida, @Observaciones = Observaciones,
@Referencia = Referencia, @FechaEmision = FechaEmision, @Origen = Origen, @OrigenID = OrigenID,
@AnticiposFacturados = AnticiposFacturados, @Anticiposimpuestos = AnticiposImpuestos
FROM Venta
WHERE ID = @ID
IF @Modulo = 'CXC'
BEGIN
SELECT @Estatus = Estatus, @Empresa = Empresa, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Cliente = Cliente, @EnviarA = ClienteEnviarA,
@Moneda = Moneda, @TipoCambio = TipoCambio, @Observaciones = Observaciones, @Concepto = Concepto,
@Referencia = Referencia, @FechaEmision = FechaEmision, @Impuesto1Total = ISNULL(Impuestos,0), @ImpuestosTotal = ISNULL(Impuestos,0), @Importe = Importe
FROM CXC
WHERE ID = @ID
SELECT @ImporteDescuentoGlobal = 0
IF @Importe = 0.0 OR @ImpuestosTotal = 0.0
SELECT @Impuesto1 = 0.00
ELSE
SELECT @Impuesto1 = ROUND((@ImpuestosTotal*100)/@Importe,2)
END
IF @MN = 1 AND @Modulo = 'CXC'
SELECT @Impuesto1Total = @Impuesto1Total*@TipoCambio, @ImpuestosTotal = @ImpuestosTotal*@TipoCambio , @Importe = @Importe*@TipoCambio
IF @Validar = 1 AND @Modulo IN ('VTAS', 'CXC', 'CXP') AND @ID IS NOT NULL
BEGIN
SELECT @MovIDCFD = MovID FROM CFD WHERE Modulo = @Modulo AND ModuloID = @ID
IF NULLIF(RTRIM(@MovID), '') <> NULLIF(RTRIM(@MovIDCFD), '')
SELECT @OK = 30013, @OkRef = RTRIM(@Mov)+' '+RTRIM(@MovIDCFD)
END
SELECT @Fecha = Fecha FROM CFD WHERE Modulo = @Modulo AND ModuloID = @ID
IF @@ROWCOUNT = 0
BEGIN
SELECT @Fecha = GETDATE()
END
IF @Modulo = 'VTAS'
BEGIN
IF @MN = 1
BEGIN
SELECT @CantidadTotal = SUM(Cantidad), @Importe = SUM(Importe*TipoCambio), @DescuentosTotales = SUM(DescuentosTotales*TipoCambio), 
@Impuesto1Total = SUM(Impuesto1Total*TipoCambio), @Impuesto2Total = SUM(Impuesto2Total*TipoCambio), @ImpuestosTotal = SUM(Impuestos*TipoCambio),
@ImporteDescuentoGlobal = SUM(ImporteDescuentoGlobal*TipoCambio)
FROM VentaTCalc
WHERE ID = @ID
SELECT @AnticiposFacturados = ISNULL(@AnticiposFacturados,0) * @TipoCambio,
@AnticiposImpuestos  = ISNULL(@AnticiposImpuestos,0) * @TipoCambio
END
ELSE
SELECT @CantidadTotal = SUM(Cantidad), @Importe = SUM(Importe), @DescuentosTotales = SUM(DescuentosTotales), 
@Impuesto1Total = SUM(Impuesto1Total), @Impuesto2Total = SUM(Impuesto2Total), @ImpuestosTotal = SUM(Impuestos),
@ImporteDescuentoGlobal = SUM(ImporteDescuentoGlobal)
FROM VentaTCalc
WHERE ID = @ID
/** AR se agrego la lectura de @Entregamercancia*/
SELECT @Embarque = Embarque, @EmbarqueFecha = EmbarqueFecha, @Recibo = Recibo, @ReciboFecha = ReciboFecha, @EntregaMercancia = EntregaMercancia
FROM VentaEntrega
WHERE ID = @ID
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
WHERE Cliente = @Cliente
SELECT @emailCobrador = email FROM Personal WHERE Personal = @PersonalCobrador
SELECT @ReceptorID = ReceptorID, @TipoAddenda = TipoAddenda,
@AddendaVersion = CASE WHEN VersionFecha < @Fecha OR VersionFecha IS NULL THEN Version ELSE VersionAnterior END
FROM CteCFD
WHERE Cliente = @Cliente
IF @TipoAddenda IN ('CHEDRAUI', 'EDIFACT') AND LEN(@ClienteRFC) NOT IN (12, 13)
SELECT @ClienteRFC = NULL
SELECT @EmisorID = EmisorID, @ProveedorID = ProveedorID, @InformacionCompra = InformacionCompra
FROM CteEmpresaCFD
WHERE Cliente = @Cliente AND Empresa = @Empresa
SELECT @ProveedorIDDeptoEnviarA = ProveedorID
FROM CteDeptoEnviarA
WHERE Cliente = @Cliente AND Departamento = @Departamento AND Empresa = @Empresa AND EnviarA = @EnviarA
SELECT @EnviarAClave = ISNULL(NULLIF(RTRIM(Clave), ''), CONVERT(varchar(20), ID)),
@EnviarANombre = Nombre, @EnviarADireccion = Direccion, @EnviarADireccionNumero = DireccionNumero, @EnviarADireccionNumeroInt = DireccionNumeroInt,
@EnviarAColonia = Colonia, @EnviarAPoblacion = Poblacion, @EnviarAObservaciones = NULLIF(RTRIM(EntreCalles/*Observaciones*/),''), @EnviarADelegacion = Delegacion, @EnviarAEstado = Estado,
@EnviarAPais = Pais, @EnviarACodigoPostal = CodigoPostal, @EnviarAGLN = GLN, @EnviarATelefonos = Telefonos
FROM CteEnviarA
WHERE Cliente = @Cliente AND ID = @EnviarA
SELECT @DepartamentoClave = Clave,
@DepartamentoNombre = Departamento,
@DepartamentoContacto = Contacto
FROM CteDepto
WHERE Cliente = @Cliente AND Departamento = @Departamento
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
WHERE Empresa = @Empresa
IF @TipoAddenda IN ('CHEDRAUI', 'EDIFACT') AND LEN(@EmpresaRFC) NOT IN (12, 13)
SELECT @EmpresaRFC = NULL
SELECT @noCertificado = noCertificado,
@Version = CASE WHEN versionFecha<@Fecha OR versionFecha IS NULL THEN version ELSE versionAnterior END,
@EmpresaEAN13 = EAN13, @EmpresaDUN14 = DUN14, @EmpresaSKUCliente = SKU, @EmpresaSKUEmpresa = SKUEmpresa,
@EmpresaSKUCodigoInterno = ISNULL(SKUCodigoInterno, 0), @ModoPruebas = ModoPruebas, @PaqueteEsCantidad = PaqueteEsCantidad,
@AgruparDetalle = AgruparDetalle
FROM EmpresaCFD
WHERE Empresa = @Empresa
SELECT @DefImpuesto = DefImpuesto
FROM EmpresaGral
SELECT @DefImpuestoZona = @DefImpuesto
EXEC spZonaImp @ZonaImpuesto, @DefImpuestoZona OUTPUT
SELECT @MonedaClave = Clave FROM Mon WHERE Moneda = @Moneda
SELECT @DescuentoClave = Clave FROM Descuento WHERE Descuento = @Descuento
SELECT @SucursalNombre = Nombre, @SucursalGLN = GLN,
@SucursalDireccion = Direccion, @SucursalDireccionNumero = DireccionNumero, @SucursalDireccionNumeroInt = DireccionNumeroInt,
@SucursalColonia = Colonia, @SucursalPoblacion = Poblacion, @SucursalObservaciones = NULL, @SucursalDelegacion = Delegacion, @SucursalEstado = Estado,
@SucursalPais = Pais, @SucursalCodigoPostal = CodigoPostal
FROM Sucursal
WHERE Sucursal = @Sucursal
SELECT @TipoCondicion = TipoCondicion, @formaDePago = CFD_formaDePago, @metodoDePago = CFD_metodoDePago, @DiasVencimiento = ISNULL(DiasVencimiento,1),
@ProntoPago = ProntoPago, @DescuentoProntoPago = DescuentoProntoPago
FROM Condicion
WHERE Condicion = @Condicion
IF @Modulo = 'CXC'
SELECT @formaDePago = 'PAGO EN UNA SOLA EXHIBICION'
SELECT @MovTipo = Clave, @tipoDeComprobante = CFD_tipoDeComprobante,
@ConsecutivoModulo = ConsecutivoModulo, @ConsecutivoMov = ConsecutivoMov
FROM MovTipo
WHERE Modulo = @Modulo AND Mov = @Mov
EXEC spMovIDEnSerieConsecutivo @MovID, @Serie OUTPUT, @Folio OUTPUT
SELECT @noAprobacion = noAprobacion, @fechaAprobacion = fechaAprobacion
FROM CFDFolio
WHERE Empresa = @Empresa AND Modulo = @ConsecutivoModulo AND Mov = @ConsecutivoMov AND Serie = @Serie AND @Folio BETWEEN FolioD AND FolioA AND Estatus = 'ALTA'
IF @@ROWCOUNT = 0
SELECT @noAprobacion = noAprobacion, @fechaAprobacion = fechaAprobacion
FROM CFDFolio
WHERE Empresa = @Empresa AND Modulo = @ConsecutivoModulo AND Mov = @ConsecutivoMov AND ISNULL(Serie,'') = ISNULL(@Serie,'') AND @Folio BETWEEN FolioD AND FolioA AND Estatus = 'ALTA'
IF @MovTipo IN ('VTAS.D', 'VTAS.B')
BEGIN
SELECT @ReferenciaFecha = c.Fecha FROM CFD c
JOIN Venta v ON c.Modulo = 'VTAS' AND c.ModuloID = v.ID
WHERE v.Empresa = @Empresa AND @Referencia = RTRIM(v.Mov)+' '+RTRIM(v.MovID)
IF @@ROWCOUNT = 0
SELECT @ReferenciaFecha = FechaRegistro FROM Venta WHERE Empresa = @Empresa AND @Referencia = RTRIM(Mov)+' '+RTRIM(MovID) AND Estatus IN ('CONCLUIDO', 'PENDIENTE')
END
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
IF @FechaAprobacion IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Año Aprobacion'
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
IF NULLIF(RTRIM(@Antecedente), '') IS NULL
BEGIN
SELECT @Ok = 10010
IF @MovTipo IN ('VTAS.D', 'VTAS.B') SELECT @OkRef = 'CFD - Referencia Factura' ELSE SELECT @OkRef = 'CFD - Orden Compra'
END
IF NULLIF(RTRIM(@AntecedenteFecha), '') IS NULL
BEGIN
SELECT @Ok = 10010
IF @MovTipo IN ('VTAS.D', 'VTAS.B') SELECT @OkRef = 'CFD - Referencia Fecha Factura' ELSE SELECT @OkRef = 'CFD - Fecha Orden Compra'
END
IF NULLIF(RTRIM(@ClienteGLN), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Cliente GLN'
IF LEN(@ClienteGLN) <> 13 SELECT @Ok = 10010, @OkRef = 'CFD - Cliente GLN Requiere 13 Caracteres'
IF ISNULL(NULLIF(RTRIM(@ProveedorIDDeptoEnviarA),''), NULLIF(RTRIM(@ProveedorID),'')) IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - ProveedorID'
IF NULLIF(RTRIM(@Recibo), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Recibo'
IF LEN(@Recibo) > 35 SELECT @Ok = 10010, @OkRef = 'CFD - Recibo Excede Tamaño Maximo 35'
IF NULLIF(RTRIM(@ReciboFecha),'') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Fecha Recibo'
IF NULLIF(RTRIM(@DepartamentoClave), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Clave Departamento Cliente'
IF LEN(@DepartamentoClave) > 35 SELECT @Ok = 10010, @OkRef = 'CFD - Clave Departamento Cliente Excede Tamaño Maximo 35'
IF NULLIF(RTRIM(@EmpresaGLN), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Empresa GLN'
IF LEN(@EmpresaGLN) <> 13 SELECT @Ok = 10010, @OkRef = 'CFD - Empresa GLN Requiere 13 Caracteres'
IF LEN(@MonedaClave) <> 3 SELECT @Ok = 10010, @OkRef = 'CFD - Moneda Clave Requiere 3 Caracteres'
IF @MonedaClave NOT IN ('', NULL, 'MXN', 'XEU', 'USD') SELECT @Ok = 10010, @OkRef = 'CFD - Moneda Clave Debe ser MXN, XEU ó USD)'
END
IF @Layout = 'Detallista'
BEGIN
SELECT '<cfdi:Complemento>'
SELECT '<detallista:detallista'
SELECT dbo.fnXML('type', 'SimpleInvoiceType')+
dbo.fnXML('documentStructureVersion', 'AMC8.1')+
dbo.fnXML('documentStatus', CASE WHEN @Estatus='CANCELADO' THEN 'DELETE' ELSE 'ORIGINAL' END)+
dbo.fnXML('contentVersion', '1.3.1')+
'>'
SELECT '<detallista:requestForPaymentIdentification>'+
dbo.fnTagXSD('detallista','entityType', CASE @MovTipo WHEN 'VTAS.D' THEN 'CREDIT_NOTE' WHEN 'VTAS.B' THEN 'DEBIT_NOTE' ELSE 'INVOICE' END)+
'</detallista:requestForPaymentIdentification>'
SELECT '<detallista:specialInstruction'+dbo.fnXML('code','ZZZ')+'>'+
dbo.fnTagXSD('detallista','text', RTRIM(@ImporteEnLetra)+' M.N.')+
'</detallista:specialInstruction>'
SELECT '<detallista:orderIdentification>'+
'<detallista:referenceIdentification'+dbo.fnXML('type', 'ON')+'>'+ISNULL(@Antecedente, '')+'</detallista:referenceIdentification>'+
dbo.fnTagDatetimeFmtXSD('detallista','ReferenceDate', @AntecedenteFecha, 'AAAA-MM-DD')+
'</detallista:orderIdentification>'
SELECT '<detallista:AdditionalInformation>'+
'<detallista:referenceIdentification'+dbo.fnXML('type', 'ATZ')+'>'+CONVERT(varchar(20), ISNULL(@noAprobacion, 0))+'</detallista:referenceIdentification>'+
'</detallista:AdditionalInformation>'
IF NULLIF(RTRIM(@Recibo), '') IS NOT NULL AND @ReciboFecha IS NOT NULL
SELECT '<detallista:DeliveryNote>'+
dbo.fnTagXSD('detallista','referenceIdentification', @Recibo)+
dbo.fnTagDatetimeFmtXSD('detallista','ReferenceDate', @ReciboFecha, 'AAAA-MM-DD')+
'</detallista:DeliveryNote>'
SELECT '<detallista:buyer>'
SELECT '<detallista:gln>'+ISNULL(@ClienteGLN,'')+'</detallista:gln>'
IF @DepartamentoClave IS NOT NULL
SELECT '<detallista:contactInformation>'+
'<detallista:personOrDepartmentName>'+
dbo.fnTagXSD('detallista','text', LEFT(@DepartamentoClave, 35))+
'</detallista:personOrDepartmentName>'+
'</detallista:contactInformation>'
SELECT '</detallista:buyer>'
SELECT '<detallista:seller>'+
dbo.fnTagXSD('detallista','gln', @EmpresaGLN)+
'<detallista:alternatePartyIdentification'+dbo.fnXML('type', 'SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY')+'>'+ISNULL(@ProveedorIDDeptoEnviarA, @ProveedorID)+'</detallista:alternatePartyIdentification>'+
'</detallista:seller>'
IF @Liverpool = 0
SELECT '<detallista:shipTo>'+
dbo.fnTagXSD('detallista','gln', @EnviarAGLN)+
'<detallista:nameAndAddress>'+
dbo.fnTagXSD('detallista','name', LEFT(@EnviarANombre,35))+
dbo.fnTagXSD('detallista','streetAddressOne', LEFT(@EnviarADireccion+' '+@EnviarADireccionNumero+' '+ISNULL(@EnviarADireccionNumeroInt,'')+' '+ISNULL(@EnviarAColonia,''), 35))+
dbo.fnTagXSD('detallista','city', LEFT(@EnviarAEstado, 35))+
dbo.fnTagXSD('detallista','postalCode', LEFT(@EnviarACodigoPostal, 9))+
'</detallista:nameAndAddress>'+
'</detallista:shipTo>'
SELECT '<detallista:currency'+dbo.fnXML('currencyISOCode', @MonedaClave)+'>'+
dbo.fnTagXSD('detallista','currencyFunction', 'BILLING_CURRENCY')+
dbo.fnTagFloatXSD('detallista','rateOfChange', @TipoCambio)+
'</detallista:currency>'
/*
SELECT '<detallista:paymentTerms'+
dbo.fnXML('paymentTermsEvent', CASE @TipoCondicion WHEN 'Contado' THEN 'DATE_OF_INVOICE' ELSE 'EFFECTIVE_DATE' END)+
dbo.fnXML('PaymentTermsRelationTime', 'REFERENCE_AFTER')+'>'+
'<detallista:netPayment'+dbo.fnXML('netPaymentTermsType', 'BASIC_NET')+'>'+
'<detallista:paymentTimePeriod>'+
'<detallista:timePeriodDue'+dbo.fnXML('timePeriod', 'DAYS')+'>'+
dbo.fnTagIntXSD('detallista','value', @DiasVencimiento)+
'</detallista:timePeriodDue>'+
'</detallista:paymentTimePeriod>'+
'</detallista:netPayment>'
IF @ProntoPago = 1
SELECT '<detallista:discountPayment'+dbo.fnXML('discountType', 'ALLOWANCE_BY_PAYMENT_ON_TIME')+'>'+
dbo.fnTagFloatXSD('detallista','percentage', @DescuentoProntoPago)+
'</detallista:discountPayment>'
SELECT '</detallista:paymentTerms>'
*/
SELECT '<detallista:allowanceCharge'+dbo.fnXML('settlementType', CASE WHEN @Liverpool = 1 THEN 'BILL_BACK' ELSE 'OFF_INVOICE' END)+dbo.fnXML('allowanceChargeType', 'ALLOWANCE_GLOBAL')+'>'+
dbo.fnTagXSD('detallista','specialServicesType', ISNULL(NULLIF(RTRIM(@DescuentoClave), ''), 'AJ'))+
'<detallista:monetaryAmountOrPercentage>'+
'<detallista:rate'+dbo.fnXML('base', 'INVOICE_VALUE')+'>'+
dbo.fnTagFloatXSD('detallista','percentage', ISNULL(@DescuentoGlobal, 0.0))+
'</detallista:rate>'+
'</detallista:monetaryAmountOrPercentage>'+
'</detallista:allowanceCharge>'
END
IF @Modulo = 'VTAS'
BEGIN
IF @AgruparDetalle = 1
DECLARE crDetalleDetallista CURSOR LOCAL FOR
SELECT MAX(d.Renglon), MAX(d.RenglonSub), MAX(d.RenglonID), MAX(d.RenglonTipo), MAX(d.Codigo), SUM(d.CantidadNeta), MAX(ISNULL(NULLIF(RTRIM(d.Unidad), ''), a.Unidad)), MAX(ISNULL(NULLIF(d.Factor, 0.0), 1.0)), d.Articulo, d.SubCuenta, SUM(d.SubTotal * (CASE WHEN @MN = 1 THEN d.TipoCambio ELSE 1.0 END)),
dbo.fnQueCodigo(@EmpresaEAN13, d.Articulo, d.SubCuenta, MAX(d.Codigo), @Cliente), dbo.fnQueCodigo(@EmpresaDUN14, d.Articulo, d.SubCuenta, MAX(d.Codigo), @Cliente), dbo.fnQueCodigo(@EmpresaSKUCliente, d.Articulo, d.SubCuenta, MAX(d.Codigo), @Cliente), dbo.fnQueCodigo(@EmpresaSKUEmpresa, d.Articulo, d.SubCuenta, MAX(d.Codigo), @Cliente),
MAX(d.DescuentoLinea), SUM(ISNULL(d.DescuentoLineal, 0.0)), SUM(ISNULL(d.ImporteDescuentoGlobal, 0.0)), MAX(d.Impuesto1), MAX(d.Impuesto2), SUM(ISNULL(d.Impuesto1Total, 0.0)), SUM(ISNULL(d.Impuesto2Total, 0.0)),
MAX(a.Descripcion1), MAX(a.Descripcion2), MAX(a.TipoEmpaque), d.Precio
FROM VentaTCalc d
JOIN Art a ON a.Articulo = d.Articulo
WHERE d.ID = @ID AND d.RenglonTipo <> 'C'
GROUP BY d.Articulo, d.Subcuenta, d.Precio
ELSE
IF @AgruparDetalle = 0
DECLARE crDetalleDetallista CURSOR LOCAL FOR
SELECT d.Renglon, d.RenglonSub, d.RenglonID, d.RenglonTipo, d.Codigo, ISNULL(d.CantidadNeta,0.0), ISNULL(NULLIF(RTRIM(d.Unidad), ''), a.Unidad), ISNULL(NULLIF(d.Factor, 0.0), 1.0), d.Articulo, d.SubCuenta, d.SubTotal * (CASE WHEN @MN = 1 THEN d.TipoCambio ELSE 1.0 END),
dbo.fnQueCodigo(@EmpresaEAN13, d.Articulo, d.SubCuenta, d.Codigo, @Cliente), dbo.fnQueCodigo(@EmpresaDUN14, d.Articulo, d.SubCuenta, d.Codigo, @Cliente), dbo.fnQueCodigo(@EmpresaSKUCliente, d.Articulo, d.SubCuenta, d.Codigo, @Cliente), dbo.fnQueCodigo(@EmpresaSKUEmpresa, d.Articulo, d.SubCuenta, d.Codigo, @Cliente),
d.DescuentoLinea, ISNULL(d.DescuentoLineal, 0.0), ISNULL(d.ImporteDescuentoGlobal, 0.0), ISNULL(d.Impuesto1,0), ISNULL(d.Impuesto2,0), ISNULL(d.Impuesto1Total, 0.0), ISNULL(d.Impuesto2Total, 0.0),
a.Descripcion1, a.Descripcion2, a.TipoEmpaque, d.Precio
FROM VentaTCalc d
JOIN Art a ON a.Articulo = d.Articulo
WHERE d.ID = @ID AND d.RenglonTipo <> 'C'
OPEN crDetalleDetallista
FETCH NEXT FROM crDetalleDetallista INTO @Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @Codigo, @Cantidad, @Unidad, @UnidadFactor, @Articulo, @SubCuenta, @SubTotalLinea,
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
SELECT @UnidadClave = Clave FROM Unidad WHERE Unidad = @Unidad
IF  @AgruparDetalle = 1
BEGIN
SELECT @Paquetes = @Cantidad / ISNULL(NULLIF(@UnidadFactor, 0.0), 1.0)
END ELSE
SELECT @Paquetes = Paquete
FROM VentaD
WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
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
@AgruparDetalle, @Cliente
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
JOIN Art a ON d.Articulo = a.Articulo
JOIN SerieLoteMov s ON s.Modulo = 'VTAS' AND d.Id = s.ID AND d.RenglonID = s.RenglonID AND d.Articulo = s.Articulo AND ISNULL(d.Subcuenta,'') = ISNULL(s.Subcuenta,'')
WHERE a.Tipo IN ('Serie', 'Lote') AND d.ID = @ID AND d.RenglonID = @RenglonID AND s.Empresa = @Empresa
ELSE
SELECT @PrimerSerieLote = NULLIF(RTRIM(MIN(SerieLote)), '')
FROM SerieLoteMov
WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID AND RenglonID = @RenglonID AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
END
IF @AgruparDetalle = 1
BEGIN
IF @RenglonTipo = 'J'
SELECT @PrimerSerieLote = NULLIF(RTRIM(MIN(SerieLote)), '')
FROM VentaD d
JOIN Art a ON d.Articulo = a.Articulo
JOIN SerieLoteMov s ON s.Modulo = 'VTAS' AND d.Id = s.ID /*AND d.RenglonID = s.RenglonID*/ AND d.Articulo = s.Articulo AND ISNULL(d.Subcuenta,'') = ISNULL(s.Subcuenta,'')
WHERE a.Tipo IN ('Serie', 'Lote') AND d.ID = @ID /*AND d.RenglonID = @RenglonID*/ AND s.Empresa = @Empresa
ELSE
SELECT @PrimerSerieLote = NULLIF(RTRIM(MIN(SerieLote)), '')
FROM SerieLoteMov
WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID /*AND RenglonID = @RenglonID*/ AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
END
IF @PrimerSerieLote IS NOT NULL
SELECT @Pedimento = dbo.fnLimpiarRFC(p.Propiedades), @PedimentoFecha = p.Fecha1, @PedimentoFecha2 = p.Fecha2, @PedimentoFecha3 = p.Fecha3, @Aduana = p.Aduana, @AgenteAduanal = p.AgenteAduanal
FROM SerieLote s
JOIN SerieLoteProp p ON p.Propiedades = s.Propiedades
WHERE s.SerieLote = @PrimerSerieLote
IF @Aduana IS NOT NULL
SELECT @AduanaGLN = GLN, @AduanaCiudad = Ciudad FROM Aduana WHERE Aduana = @Aduana
IF @AgenteAduanal IS NOT NULL
SELECT @AgenteAduanalNombre = Nombre FROM Prov WHERE Proveedor = @AgenteAduanal
IF @Validar = 1
BEGIN
IF NULLIF(RTRIM(@Cantidad), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Cantidad'
IF NULLIF(RTRIM(@ArtDescripcion1), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Concepto'
IF @SubTotalLinea IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - SubTotal'
IF NULLIF(RTRIM(@EAN13), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Codigo de Barras'
IF LEN(@EAN13) > 14  SELECT @Ok = 10010, @OkRef = 'CFD - Excede Tamaño Caracteres 14'
IF NULLIF(RTRIM(@UnidadClave), '') IS NULL SELECT @Ok = 10010, @OkRef = 'CFD - Articulo Clave Unidad'
END
/******/
IF @Layout = 'Detallista'
BEGIN
SELECT '<detallista:lineItem'+
dbo.fnXML('type', 'SimpleInvoiceLineItemType')+
dbo.fnXMLInt('number', @Conteo)
+'>'
SELECT '<detallista:tradeItemIdentification>'
SELECT '<detallista:gtin>'+ISNULL(@EAN13,'')+'</detallista:gtin>'
SELECT '</detallista:tradeItemIdentification>'
SELECT '<detallista:alternateTradeItemIdentification'+dbo.fnXML('type', CASE WHEN @EmpresaSKUCodigoInterno=1 THEN 'SUPPLIER_ASSIGNED' ELSE 'BUYER_ASSIGNED' END)+'>'+
CASE WHEN @EmpresaSKUCodigoInterno=1 THEN RTRIM(@SKUEmpresa) ELSE RTRIM(@SKUCliente) END+
'</detallista:alternateTradeItemIdentification>'
SELECT '<detallista:tradeItemDescriptionInformation'+dbo.fnXML('language', 'ES')+'>'+
dbo.fnTagXSD('detallista','longText', LEFT(@ArtDescripcion1, 35))+
'</detallista:tradeItemDescriptionInformation>'
IF ABS(@SubTotalLinea) > 0.01
BEGIN
SELECT '<detallista:invoicedQuantity'+dbo.fnXML('unitOfMeasure', @UnidadClave)+'>'+
CONVERT(varchar(20), ISNULL(@Cantidad, 0.0))+
'</detallista:invoicedQuantity>'
IF @Gigante = 0
SELECT '<detallista:aditionalQuantity'+dbo.fnXML('QuantityType', 'NUM_CONSUMER_UNITS')+'>'+
CONVERT(varchar(20), @Paquetes)+
'</detallista:aditionalQuantity>'
END
ELSE
BEGIN
SELECT '<detallista:invoicedQuantity'+dbo.fnXML('unitOfMeasure', @UnidadClave)+'>0.00</detallista:invoicedQuantity>'
IF @UnidadFactor <> 1.0
SELECT '<detallista:aditionalQuantity'+dbo.fnXML('QuantityType', 'NUM_CONSUMER_UNITS')+'>'+
CONVERT(varchar(20), @Cantidad*@UnidadFactor)+
'</detallista:aditionalQuantity>'
END
SELECT '<detallista:grossPrice>'+dbo.fnTagMoneyXSD('detallista','Amount', @ImporteLinea/NULLIF(@Cantidad, 0.0))+'</detallista:grossPrice>'
SELECT '<detallista:netPrice>'  +dbo.fnTagMoneyXSD('detallista','Amount', @SubTotalLinea/NULLIF(@Cantidad, 0.0))+'</detallista:netPrice>'
IF NULLIF(RTRIM(@OrdenCompra),'') IS NOT NULL AND @Liverpool = 0 AND @ComercialMexicana = 0
SELECT '<detallista:AdditionalInformation>'+
'<detallista:referenceIdentification'+dbo.fnXML('type', 'ON')+'>'+@OrdenCompra+
'</detallista:referenceIdentification>'+
'</detallista:AdditionalInformation>'
IF @Gigante = 0
BEGIN
/*
IF @Layout IN ('AMECE', 'AMECE / CM') AND NULLIF(@Pedimento, '') IS NOT NULL
SELECT '<detallista:Customs>'+
dbo.fnTagXSD('detallista','gln', @AduanaGLN)+
'<detallista:alternatePartyIdentification'+dbo.fnXML('type', 'TN')+'/>'+
dbo.fnTagDatetimeFmtXSD('detallista','ReferenceDate', @PedimentoFecha, 'AAAA-MM-DD')+
'<detallista:nameAndAddress>'+
dbo.fnTagXSD('detallista','name', @Aduana)+
'</detallista:nameAndAddress>'+
'</detallista:Customs>'
*/
/*
IF /*@Layout IN ('AMECE', 'AMECE / GIGANTE') AND */NULLIF(@Paquetes, 0) IS NOT NULL AND @TipoEmpaqueTipo IS NOT NULL
SELECT '<detallista:palletInformation>'+
dbo.fnTagIntXSD('detallista','palletQuantity', @Paquetes)+
'<detallista:description'+dbo.fnXML('type', @TipoEmpaqueTipo)+'>'+'default'+'</detallista:description>'+
'<detallista:transport>'+
dbo.fnTagXSD('detallista','methodOfPayment', 'PREPAID_BY_SELLER')+
'</detallista:transport>'+
'</detallista:palletInformation>'
*/
/*IF @PrimerSerieLote IS NOT NULL AND @PedimentoFecha IS NOT NULL
SELECT '<detallista:extendedAttributes>'+
'<detallista:lotNumber'+dbo.fnXMLDatetimeFmt('productionDate', @PedimentoFecha, 'AAAA-MM-DD')+'>'+
@PrimerSerieLote+
'</detallista:lotNumber>'+
'</detallista:extendedAttributes>'*/
IF NULLIF(@PctDescuentoLinea, 0.0) IS NOT NULL
SELECT '<detallista:allowanceCharge'+dbo.fnXML('allowanceChargeType', 'ALLOWANCE_GLOBAL')+'>'+
'<detallista:monetaryAmountOrPercentage>'+
dbo.fnTagFloatXSD('detallista','percentagePerUnit', @PctDescuentoLinea)+
'</detallista:monetaryAmountOrPercentage>'+
'</detallista:allowanceCharge>'
SELECT '<detallista:tradeItemTaxInformation>'+
dbo.fnTagXSD('detallista','taxTypeDescription', 'VAT')+
'<detallista:tradeItemTaxAmount>'+
dbo.fnTagFloatXSD('detallista','taxPercentage', @Impuesto1)+
dbo.fnTagMoneyXSD('detallista','taxAmount', @Impuesto1Linea)+
'</detallista:tradeItemTaxAmount>'+
dbo.fnTagXSD('detallista','taxCategory', 'TRANSFERIDO')+
'</detallista:tradeItemTaxInformation>'
IF @Impuesto2Linea <> 0.0
SELECT '<detallista:tradeItemTaxInformation>'+
dbo.fnTagXSD('detallista','taxTypeDescription', 'GST')+
'<detallista:tradeItemTaxAmount>'+
dbo.fnTagFloatXSD('detallista','taxPercentage', @Impuesto2)+
dbo.fnTagMoneyXSD('detallista','taxAmount', @Impuesto2Linea)+
'</detallista:tradeItemTaxAmount>'+
dbo.fnTagXSD('detallista','taxCategory', 'TRANSFERIDO')+
'</detallista:tradeItemTaxInformation>'
END
SELECT '<detallista:totalLineAmount>'+
'<detallista:grossAmount>'+
dbo.fnTagMoneyXSD('detallista','Amount', CASE WHEN @Gigante=1 THEN @SubTotalLinea ELSE @ImporteLinea END)+
'</detallista:grossAmount>'
IF @ComercialMexicana = 0
SELECT '<detallista:netAmount>'+
dbo.fnTagMoneyXSD('detallista','Amount', CASE WHEN @Gigante=1 THEN @ImporteLinea ELSE @SubTotalLinea END)+
'</detallista:netAmount>'
SELECT '</detallista:totalLineAmount>'
SELECT '</detallista:lineItem>'
END
END
FETCH NEXT FROM crDetalleDetallista INTO @Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @Codigo, @Cantidad, @Unidad, @UnidadFactor, @Articulo, @SubCuenta, @SubTotalLinea,
@EAN13, @DUN14, @SKUCliente, @SKUEmpresa,
@PctDescuentoLinea, @DescuentoLinea, @DescuentoGlobalLinea, @Impuesto1, @Impuesto2, @Impuesto1Linea, @Impuesto2Linea,
@ArtDescripcion1, @ArtDescripcion2, @ArtTipoEmpaque, @Precio
END
CLOSE crDetalleDetallista
DEALLOCATE crDetalleDetallista
/** END de IF 'VTAS'   */
END
IF @Layout = 'Detallista'
BEGIN
SELECT '<detallista:totalAmount>'+
dbo.fnTagMoneyXSD('detallista','Amount', @Importe)+
'</detallista:totalAmount>'
SELECT '<detallista:TotalAllowanceCharge'+dbo.fnXML('allowanceOrChargeType', 'ALLOWANCE')+'>'+
dbo.fnTagXSD('detallista','specialServicesType', ISNULL(NULLIF(RTRIM(@DescuentoClave), ''), 'AJ'))+
dbo.fnTagMoneyXSD('detallista','Amount', ISNULL(@ImporteDescuentoGlobal, 0.0))+
'</detallista:TotalAllowanceCharge>'
SELECT '</detallista:detallista>'
SELECT '</cfdi:Complemento>'
END
RETURN
END

