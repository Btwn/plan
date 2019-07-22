SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spGenerarCFD]
 @Estacion INT
,@Modulo CHAR(5)
,@ID INT
,@Layout VARCHAR(50)
,@Validar BIT = 0
,@Ok INT = NULL OUTPUT
,@OkRef VARCHAR(255) = NULL OUTPUT
AS
BEGIN
	DECLARE
		@TipoServicio VARCHAR(15)
	   ,@retenido VARCHAR(20)
	   ,@Empresa CHAR(5)
	   ,@EmpresaRFC VARCHAR(20)
	   ,@EmpresaNombre VARCHAR(100)
	   ,@EmpresaDireccion VARCHAR(100)
	   ,@EmpresaDireccionNumero VARCHAR(20)
	   ,@EmpresaDireccionNumeroInt VARCHAR(20)
	   ,@EmpresaColonia VARCHAR(100)
	   ,@EmpresaPoblacion VARCHAR(100)
	   ,@EmpresaObservaciones VARCHAR(100)
	   ,@EmpresaDelegacion VARCHAR(100)
	   ,@EmpresaEstado VARCHAR(30)
	   ,@EmpresaPais VARCHAR(30)
	   ,@EmpresaCodigoPostal VARCHAR(15)
	   ,@EmpresaRegistroPatronal VARCHAR(20)
	   ,@EmpresaGLN VARCHAR(50)
	   ,@EmpresaTelefonos VARCHAR(100)
	   ,@EmpresaEAN13 VARCHAR(20)
	   ,@EmpresaDUN14 VARCHAR(20)
	   ,@EmpresaSKUCliente VARCHAR(20)
	   ,@EmpresaSKUEmpresa VARCHAR(20)
	   ,@EmpresaSKUCodigoInterno BIT
	   ,@SucursalNombre VARCHAR(100)
	   ,@SucursalGLN VARCHAR(50)
	   ,@SucursalDireccion VARCHAR(100)
	   ,@SucursalDireccionNumero VARCHAR(20)
	   ,@SucursalDireccionNumeroInt VARCHAR(20)
	   ,@SucursalColonia VARCHAR(100)
	   ,@SucursalPoblacion VARCHAR(100)
	   ,@SucursalObservaciones VARCHAR(100)
	   ,@SucursalDelegacion VARCHAR(100)
	   ,@SucursalEstado VARCHAR(30)
	   ,@SucursalPais VARCHAR(30)
	   ,@SucursalCodigoPostal VARCHAR(15)
	   ,@ClienteRFC VARCHAR(20)
	   ,@ClienteNombre VARCHAR(100)
	   ,@ClienteDireccion VARCHAR(100)
	   ,@ClienteDireccionNumero VARCHAR(20)
	   ,@ClienteDireccionNumeroInt VARCHAR(20)
	   ,@ClienteColonia VARCHAR(100)
	   ,@ClientePoblacion VARCHAR(100)
	   ,@ClienteObservaciones VARCHAR(100)
	   ,@ClienteDelegacion VARCHAR(100)
	   ,@ClienteEstado VARCHAR(30)
	   ,@ClientePais VARCHAR(30)
	   ,@ClienteCodigoPostal VARCHAR(15)
	   ,@ClienteGLN VARCHAR(50)
	   ,@ClienteTelefonos VARCHAR(100)
	   ,@ClienteIEPS VARCHAR(20)
	   ,@EnviarARFC VARCHAR(20)
	   ,@EnviarANombre VARCHAR(100)
	   ,@EnviarADireccion VARCHAR(100)
	   ,@EnviarADireccionNumero VARCHAR(20)
	   ,@EnviarADireccionNumeroInt VARCHAR(20)
	   ,@EnviarAColonia VARCHAR(100)
	   ,@EnviarAPoblacion VARCHAR(100)
	   ,@EnviarAObservaciones VARCHAR(100)
	   ,@EnviarADelegacion VARCHAR(100)
	   ,@EnviarAEstado VARCHAR(30)
	   ,@EnviarAPais VARCHAR(30)
	   ,@EnviarACodigoPostal VARCHAR(15)
	   ,@EnviarAGLN VARCHAR(50)
	   ,@EnviarATelefonos VARCHAR(100)
	   ,@Sucursal INT
	   ,@Version VARCHAR(10)
	   ,@noCertificado VARCHAR(20)
	   ,@Mov VARCHAR(20)
	   ,@MovID VARCHAR(20)
	   ,@Referencia VARCHAR(50)
	   ,@ReferenciaFecha DATETIME
	   ,@ConsecutivoModulo CHAR(5)
	   ,@ConsecutivoMov VARCHAR(20)
	   ,@Fecha DATETIME
	   ,@Serie VARCHAR(20)
	   ,@Folio BIGINT
	   ,@FechaEmision DATETIME
	   ,@noAprobacion INT
	   ,@fechaAprobacion DATETIME
	   ,@MovTipo VARCHAR(20)
	   ,@tipoDeComprobante VARCHAR(20)
	   ,@FormaEnvio VARCHAR(50)
	   ,@Condicion VARCHAR(50)
	   ,@Vencimiento DATETIME
	   ,@formaDePago VARCHAR(100)
	   ,@metodoDePago VARCHAR(100)
	   ,@Importe FLOAT
	   ,@SubTotal FLOAT
	   ,@Descuento VARCHAR(50)
	   ,@DescuentosTotales FLOAT
	   ,@ImpuestosTotal FLOAT
	   ,@Total FLOAT
	   ,@Cliente VARCHAR(10)
	   ,@EnviarA INT
	   ,@Renglon FLOAT
	   ,@RenglonSub INT
	   ,@RenglonID INT
	   ,@RenglonTipo CHAR(1)
	   ,@Cantidad FLOAT
	   ,@CantidadTotal FLOAT
	   ,@Codigo VARCHAR(50)
	   ,@Unidad VARCHAR(50)
	   ,@Articulo VARCHAR(20)
	   ,@SubCuenta VARCHAR(50)
	   ,@noIdentificacion VARCHAR(100)
	   ,@ArtDescripcion1 VARCHAR(255)
	   ,@ArtDescripcion2 VARCHAR(255)
	   ,@ArtTipoEmpaque VARCHAR(50)
	   ,@TipoEmpaqueClave VARCHAR(20)
	   ,@TipoEmpaqueTipo VARCHAR(20)
	   ,@Precio FLOAT
	   ,@PrecioLinea FLOAT
	   ,@PrecioSinDescuentos FLOAT
	   ,@SubTotalLinea FLOAT
	   ,@TotalLinea FLOAT
	   ,@SerieLote VARCHAR(50)
	   ,@Pedimento VARCHAR(20)
	   ,@PedimentoFecha DATETIME
	   ,@Aduana VARCHAR(50)
	   ,@AduanaGLN VARCHAR(50)
	   ,@AduanaCiudad VARCHAR(50)
		 ,@Retencion1 FLOAT
	   ,@Impuesto1 FLOAT
	   ,@Impuesto1Linea FLOAT
	   ,@Impuesto1SubTotal FLOAT
	   ,@Impuesto1Total FLOAT
	   ,@Impuesto1Promedio FLOAT
	   ,@Impuesto2 FLOAT
	   ,@Impuesto2Linea FLOAT
	   ,@Impuesto2SubTotal FLOAT
	   ,@Impuesto2Total FLOAT
	   ,@Impuesto2Promedio FLOAT
	   ,@PctDescuentoLinea FLOAT
	   ,@DescuentoLinea FLOAT
	   ,@DescuentoGlobalLinea FLOAT
	   ,@EmisorID VARCHAR(20)
	   ,@ReceptorID VARCHAR(20)
	   ,@ProveedorID VARCHAR(20)
	   ,@ProveedorIDDeptoEnviarA VARCHAR(20)
	   ,@TipoAddenda VARCHAR(50)
	   ,@AddendaVersion VARCHAR(10)
	   ,@OrdenCompra VARCHAR(50)
	   ,@FechaOrdenCompra DATETIME
	   ,@DiasVencimiento INT
	   ,@Estatus VARCHAR(15)
	   ,@DescuentoGlobal FLOAT
	   ,@ImporteDescuentoGlobal FLOAT
	   ,@Departamento INT
	   ,@DepartamentoClave VARCHAR(20)
	   ,@DepartamentoNombre VARCHAR(100)
	   ,@DepartamentoContacto VARCHAR(100)
	   ,@EmpresaRepresentante VARCHAR(100)
	   ,@Observaciones VARCHAR(100)
	   ,@DefImpuesto FLOAT
	   ,@DefImpuestoZona FLOAT
	   ,@ZonaImpuesto VARCHAR(30)
	   ,@EnviarAClave VARCHAR(20)
	   ,@Embarque VARCHAR(50)
	   ,@EmbarqueFecha DATETIME
	   ,@Recibo VARCHAR(50)
	   ,@ReciboFecha DATETIME
	   ,@Moneda CHAR(10)
	   ,@MonedaClave CHAR(3)
	   ,@UnidadClave CHAR(3)
	   ,@TipoCambio FLOAT
	   ,@FechaRequerida DATETIME
	   ,@MN BIT
	   ,@Paquetes INT
	   ,@CantidadEmpaque FLOAT
	   ,@EAN13 VARCHAR(20)
	   ,@DUN14 VARCHAR(20)
	   ,@SKUCliente VARCHAR(20)
	   ,@SKUEmpresa VARCHAR(20)
	   ,@SKUDelCliente BIT
	   ,@PrimerSerieLote VARCHAR(50)
	   ,@ImporteLinea FLOAT
	   ,@SumaImporteLinea FLOAT
	   ,@SumaCantidad FLOAT
	   ,@SumaSubTotalLinea FLOAT
	   ,@Conteo INT
	   ,@ImporteEnLetra VARCHAR(255)
	   ,@TipoCondicion VARCHAR(50)
	   ,@ProntoPago BIT
	   ,@DescuentoProntoPago FLOAT
	   ,@DescuentoClave VARCHAR(20)
	   ,@UnidadFactor FLOAT
	   ,@Liverpool BIT
	   ,@Gigante BIT
	   ,@ComercialMexicana BIT
	   ,@Elektra BIT
	   ,@EHB BIT
	   ,@Antecedente VARCHAR(50)
	   ,@AntecedenteFecha DATETIME
	   ,@ModoPruebas BIT
	   ,@ReferenciaEnvio VARCHAR(14)
	   ,@Origen VARCHAR(20)
	   ,@OrigenID VARCHAR(20)
	   ,@NumeroArticulos INT
	   ,@EntregaMercancia VARCHAR(20)
	   ,@agenteAduanal VARCHAR(10)
	   ,@AgenteAduanalNombre VARCHAR(100)
	   ,@TotalCajas INT
	   ,@Concepto VARCHAR(50)
	   ,@AduanaClave VARCHAR(10)
	   ,@PedimentoFecha2 DATETIME
	   ,@PedimentoFecha3 DATETIME
	   ,@PaqueteEsCantidad BIT
	   ,@InformacionCompra VARCHAR(20)
	   ,@CompSubTotal FLOAT
	   ,@CompDescuentoLineal FLOAT
	   ,@CompImporteDescuentoGlobal FLOAT
	   ,@CompImpuesto1Total FLOAT
	   ,@CompImpuesto2Total FLOAT
	   ,@CompPrecio FLOAT
	   ,@PersonalCobrador VARCHAR(10)
	   ,@emailCobrador VARCHAR(50)
	   ,@AnticiposFacturados FLOAT
	   ,@AnticiposImpuestos FLOAT
	   ,@AgruparDetalle INT
	   ,@ArtUnidad VARCHAR(20)
	   ,@UtilizaPaquete INT
	   ,@SeFacturaPor VARCHAR(50)
	   ,@MovIDCFD VARCHAR(20)
	   ,@Agente VARCHAR(20)
	   ,@DescripcionExtra VARCHAR(100)
	   ,@cfgDecimales INT
	   ,@p CHAR(1)
	   ,@RetencionTotal FLOAT
	   ,@RetencionFlete FLOAT
	   ,@RetencionPitex FLOAT
	   ,@ImporteSobrePrecio FLOAT
	   ,@TasaAnticipoImpuesto FLOAT
	   ,@FechaRegistro DATETIME
	   ,@ExtraCondicion VARCHAR(50)
	   ,@MovE VARCHAR(20)
	   ,@MovIDE VARCHAR(20)
	   ,@OrigenE VARCHAR(20)
	   ,@OrigenIDE VARCHAR(20)
	   ,@OrigenDoc VARCHAR(20)
	   ,@OrigenIDDoc VARCHAR(20)
	   ,@MovOrigen VARCHAR(20)
	   ,@MovOrigenID VARCHAR(20)
	   ,@FechaCancelacion DATETIME
	   ,@IDNota INT
	   ,@MovNota VARCHAR(20)
	   ,@MovNotaID VARCHAR(20)
	   ,@CampoExtra VARCHAR(50)
	   ,@CampoExtraE VARCHAR(50)

	IF @Modulo NOT IN ('VTAS', 'CXC')
		RETURN

	SET CONCAT_NULL_YIELDS_NULL ON
	SELECT @MN = 0
		  ,@SumaCantidad = 0.0
		  ,@SumaSubTotalLinea = 0.0
		  ,@SumaImporteLinea = 0.0
		  ,@Conteo = 0
		  ,@Layout = UPPER(@Layout)
		  ,@ModoPruebas = 0
		  ,@Liverpool = 0
		  ,@Gigante = 0
		  ,@ComercialMexicana = 0
		  ,@Elektra = 0
		  ,@EHB = 0
		  ,@PaqueteEsCantidad = 0

	IF @Layout = 'AMECE / LIVERPOOL'
		SELECT @Liverpool = 1
	ELSE

	IF @Layout = 'AMECE / GIGANTE'
		SELECT @Gigante = 1
	ELSE

	IF @Layout = 'AMECE / CM'
		SELECT @ComercialMexicana = 1
	ELSE

	IF @Layout = 'INTERFACTURA / ELEKTRA'
		SELECT @Elektra = 1
	ELSE

	IF @Layout IN ('INTERFACTURA / EHB', 'INTERFACTURA / HEB')
		SELECT @EHB = 1

	IF @Layout = 'SORIANA'
		SELECT @Layout = 'SORIANA CEDIS'

	IF @Layout IN ('CHEDRAUI', 'EDIFACT')
		CREATE TABLE #CFD (
			ID INT NOT NULL IDENTITY (1, 1) PRIMARY KEY
		   ,Requerido BIT NULL
		   ,Campo VARCHAR(100) NULL
		   ,Dato VARCHAR(255) NULL
		)

	IF @Layout = 'EDIFACT'
		CREATE TABLE #EDI (
			ID INT NOT NULL IDENTITY (1, 1) PRIMARY KEY
		   ,Requerido BIT NULL
		   ,Campo VARCHAR(100) NULL
		   ,Dato VARCHAR(255) NULL
		)

	IF @Modulo = 'VTAS'
		SELECT @Estatus = Estatus
			  ,@Empresa = Empresa
			  ,@Sucursal = Sucursal
			  ,@Mov = Mov
			  ,@MovID = MovID
			  ,@FormaEnvio = FormaEnvio
			  ,@Condicion = Condicion
			  ,@Vencimiento = Vencimiento
			  ,@Cliente = Cliente
			  ,@EnviarA = EnviarA
			  ,@Descuento = Descuento
			  ,@DescuentoGlobal = DescuentoGlobal
			  ,@OrdenCompra = OrdenCompra
			  ,@FechaOrdenCompra = FechaOrdenCompra
			  ,@Departamento = Departamento
			  ,@ZonaImpuesto = ZonaImpuesto
			  ,@Moneda = Moneda
			  ,@TipoCambio = TipoCambio
			  ,@FechaRequerida = FechaRequerida
			  ,@Observaciones = Observaciones
			  ,@Referencia = Referencia
			  ,@FechaEmision = FechaEmision
			  ,@Origen = Origen
			  ,@OrigenID = OrigenID
			  ,@AnticiposFacturados = AnticiposFacturados
			  ,@Anticiposimpuestos = AnticiposImpuestos
			  ,@Agente = Agente
				,@RetencionTotal = ISNULL(Retencion, dbo.fnRetencionCFD(@ID))
			  ,@FechaRegistro = ISNULL(FechaRegistro, GETDATE())
			  ,@FechaCancelacion = ISNULL(FechaCancelacion, GETDATE())
		FROM Venta WITH(NOLOCK)
		WHERE ID = @ID

	IF @Modulo = 'CXC'
	BEGIN
		SELECT @Estatus = Estatus
			  ,@Empresa = Empresa
			  ,@Sucursal = Sucursal
			  ,@Mov = Mov
			  ,@MovID = MovID
			  ,@Cliente = Cliente
			  ,@EnviarA = ClienteEnviarA
			  ,@Condicion = Condicion
			  ,@Moneda = Moneda
			  ,@TipoCambio = TipoCambio
			  ,@Observaciones = Observaciones
			  ,@Concepto = ISNULL(Concepto, 'SIN CONCEPTO')
			  ,@Referencia = Referencia
			  ,@FechaEmision = FechaEmision
			  ,@Impuesto1Total = ISNULL(Impuestos, 0)
			  ,@ImpuestosTotal = ISNULL(Impuestos, 0)
			  ,@RetencionTotal = Retencion
			  ,@Importe = Importe
			  ,@Origen = Origen
			  ,@OrigenID = OrigenID
			  ,@FechaRegistro = ISNULL(FechaRegistro, GETDATE())
			  ,@FechaCancelacion = ISNULL(FechaCancelacion, GETDATE())
			  ,@FechaRegistro = FechaRegistro
		FROM CXC WITH(NOLOCK)
		WHERE ID = @ID
		SELECT @ImporteDescuentoGlobal = 0

		IF @Importe = 0.0
			OR @ImpuestosTotal = 0.0
			SELECT @Impuesto1 = 0.00
		ELSE
			SELECT @Impuesto1 = ROUND((@ImpuestosTotal * 100) / @Importe, 0)

	END

	IF @Layout = 'SAT'
		SELECT @MN = SAT_MN
		FROM EmpresaCFD WITH(NOLOCK)
		WHERE Empresa = @Empresa

	IF @MN = 1
		AND @Modulo = 'CXC'
		SELECT @Impuesto1Total = @Impuesto1Total * @TipoCambio
			  ,@ImpuestosTotal = @ImpuestosTotal * @TipoCambio
			  ,@Importe = @Importe * @TipoCambio
				,@RetencionTotal = @RetencionTotal * @TipoCambio

	IF @Validar = 1
		AND @Modulo IN ('VTAS', 'CXC', 'CXP')
		AND @ID IS NOT NULL
	BEGIN
		SELECT @MovIDCFD = MovID
		FROM CFD WITH(NOLOCK)
		WHERE Modulo = @Modulo
		AND ModuloID = @ID

		IF NULLIF(RTRIM(@MovID), '') <> NULLIF(RTRIM(@MovIDCFD), '')
			SELECT @OK = 30013
				  ,@OkRef = RTRIM(@Mov) + ' ' + RTRIM(@MovIDCFD)

	END

	SELECT @Fecha = Fecha
	FROM CFD WITH(NOLOCK)
	WHERE Modulo = @Modulo
	AND ModuloID = @ID

	IF @@ROWCOUNT = 0
	BEGIN
		SELECT @Fecha = @FechaRegistro

		IF @FEcha IS NULL
			SELECT @Fecha = GETDATE()

		IF @Validar = 0

			IF NOT EXISTS (SELECT ModuloID FROM CFD WITH(NOLOCK) WHERE Modulo = @Modulo AND ModuloID = @ID)
				INSERT CFD (Modulo, ModuloID, Fecha)
					VALUES (@Modulo, @ID, @Fecha)

	END

	IF @Modulo = 'VTAS'
	BEGIN

		IF @MN = 1
		BEGIN
			SELECT @CantidadTotal = SUM(Cantidad)
				  ,@Importe = SUM(Importe * TipoCambio)
				  ,@DescuentosTotales = SUM(DescuentosTotales * TipoCambio)
				  ,@Impuesto1Total = SUM(Impuesto1Total * TipoCambio)
				  ,@Impuesto2Total = SUM(Impuesto2Total * TipoCambio)
				  ,@ImpuestosTotal = SUM(Impuestos * TipoCambio)
				  ,@ImporteDescuentoGlobal = SUM(ImporteDescuentoGlobal * TipoCambio)
				  ,@ImporteSobrePrecio = SUM(ImporteSobrePrecio * TipoCambio)
			FROM VentaTCalc WITH(NOLOCK)
			WHERE ID = @ID
			SELECT @AnticiposFacturados = ISNULL(@AnticiposFacturados, 0) * @TipoCambio
				  ,@AnticiposImpuestos = ISNULL(@AnticiposImpuestos, 0) * @TipoCambio
		END
		ELSE
			SELECT @CantidadTotal = SUM(Cantidad)
				  ,@Importe = SUM(Importe)
				  ,@DescuentosTotales = SUM(DescuentosTotales)
				  ,@Impuesto1Total = SUM(Impuesto1Total)
				  ,@Impuesto2Total = SUM(Impuesto2Total)
				  ,@ImpuestosTotal = SUM(Impuestos)
				  ,@ImporteDescuentoGlobal = SUM(ImporteDescuentoGlobal)
				  ,@ImporteSobrePrecio = SUM(ImporteSobrePrecio)
			FROM VentaTCalc WITH(NOLOCK)
			WHERE ID = @ID

		SELECT @Embarque = Embarque
			  ,@EmbarqueFecha = EmbarqueFecha
			  ,@Recibo = Recibo
			  ,@ReciboFecha = ReciboFecha
			  ,@EntregaMercancia = EntregaMercancia
		FROM VentaEntrega WITH(NOLOCK)
		WHERE ID = @ID
		SELECT @NumeroArticulos = COUNT(DISTINCT (Articulo))
		FROM VentaD WITH(NOLOCK)
		WHERE ID = @ID
		AND RenglonTipo <> 'C'
	END

	SELECT @SubTotal = @Importe - ISNULL(@ImporteDescuentoGlobal, 0.0) - ISNULL(@AnticiposFacturados, 0) + ISNULL(@AnticiposImpuestos, 0) + ISNULL(@ImporteSobrePrecio, 0.0)
	SELECT @ImpuestosTotal = @ImpuestosTotal - ISNULL(@AnticiposImpuestos, 0)
	IF @RetencionTotal <> 0.0
		AND @RetencionTotal IS NOT NULL
		SELECT @Total = ((@SubTotal + @ImpuestosTotal) - @RetencionTotal)
	ELSE
		SELECT @Total = @SubTotal + @ImpuestosTotal
	SELECT @ImporteEnLetra = dbo.fnNumeroEnEspanol(@Total, @Moneda)
	SELECT @Impuesto1Total = @Impuesto1Total - ISNULL(@AnticiposImpuestos, 0)
	SELECT @ClienteRFC = dbo.fnBuscarRFC(@Cliente, @ID, @Modulo)
		  ,@ClienteNombre = Nombre
		  ,@ClienteDireccion = Direccion
		  ,@ClienteDireccionNumero = DireccionNumero
		  ,@ClienteDireccionNumeroInt = DireccionNumeroInt
		  ,@ClienteColonia = Colonia
		  ,@ClientePoblacion = Poblacion
		  ,@ClienteObservaciones = EntreCalles
		  ,@ClienteDelegacion = Delegacion
		  ,@ClienteEstado = Estado
		  ,@ClientePais = Pais
		  ,@ClienteCodigoPostal = CodigoPostal
		  ,@ClienteGLN = GLN
		  ,@ClienteTelefonos = Telefonos
		  ,@ClienteIEPS = IEPS
		  ,@PersonalCobrador = PersonalCobrador
	FROM Cte WITH(NOLOCK)
	WHERE Cliente = @Cliente
	SELECT @emailCobrador = email
	FROM Personal WITH(NOLOCK)
	WHERE Personal = @PersonalCobrador
	SELECT @ReceptorID = ReceptorID
		  ,@TipoAddenda = TipoAddenda
		  ,@AddendaVersion =
		   CASE
			   WHEN VersionFecha < @Fecha
				   OR VersionFecha IS NULL THEN Version
			   ELSE VersionAnterior
		   END
	FROM CteCFD WITH(NOLOCK)
	WHERE Cliente = @Cliente

	IF @TipoAddenda IN ('CHEDRAUI', 'EDIFACT')
		AND LEN(@ClienteRFC) NOT IN (12, 13)
		SELECT @ClienteRFC = NULL

	SELECT @EmisorID = EmisorID
		  ,@ProveedorID = ProveedorID
		  ,@InformacionCompra = InformacionCompra
	FROM CteEmpresaCFD WITH(NOLOCK)
	WHERE Cliente = @Cliente
	AND Empresa = @Empresa
	SELECT @ProveedorIDDeptoEnviarA = ProveedorID
	FROM CteDeptoEnviarA WITH(NOLOCK)
	WHERE Cliente = @Cliente
	AND Departamento = @Departamento
	AND Empresa = @Empresa
	AND EnviarA = @EnviarA
	SELECT @EnviarAClave = ISNULL(NULLIF(RTRIM(Clave), ''), CONVERT(VARCHAR(20), ID))
		  ,@EnviarANombre = Nombre
		  ,@EnviarADireccion = Direccion
		  ,@EnviarADireccionNumero = DireccionNumero
		  ,@EnviarADireccionNumeroInt = DireccionNumeroInt
		  ,@EnviarAColonia = Colonia
		  ,@EnviarAPoblacion = Poblacion
		  ,@EnviarAObservaciones = NULLIF(RTRIM(EntreCalles), '')
		  ,@EnviarADelegacion = Delegacion
		  ,@EnviarAEstado = Estado
		  ,@EnviarAPais = Pais
		  ,@EnviarACodigoPostal = CodigoPostal
		  ,@EnviarAGLN = GLN
		  ,@EnviarATelefonos = Telefonos
	FROM CteEnviarA WITH(NOLOCK)
	WHERE Cliente = @Cliente
	AND ID = @EnviarA
	SELECT @DepartamentoClave = Clave
		  ,@DepartamentoNombre = Departamento
		  ,@DepartamentoContacto = Contacto
	FROM CteDepto WITH(NOLOCK)
	WHERE Cliente = @Cliente
	AND Departamento = @Departamento

	IF @Subtotal = 0.0
		SELECT @Impuesto1Promedio = 0.0
			  ,@Impuesto2Promedio = 0.0
	ELSE
		SELECT @Impuesto1Promedio = (@Impuesto1Total * 100) / @SubTotal
			  ,@Impuesto2Promedio = (@Impuesto2Total * 100) / @SubTotal

	SELECT @EmpresaRFC = dbo.fnLimpiarRFC(RFC)
		  ,@EmpresaNombre = Nombre
		  ,@EmpresaDireccion = Direccion
		  ,@EmpresaDireccionNumero = DireccionNumero
		  ,@EmpresaDireccionNumeroInt = DireccionNumeroInt
		  ,@EmpresaColonia = Colonia
		  ,@EmpresaPoblacion = Poblacion
		  ,@EmpresaObservaciones = NULL
		  ,@EmpresaDelegacion = Delegacion
		  ,@EmpresaEstado = Estado
		  ,@EmpresaPais = Pais
		  ,@EmpresaCodigoPostal = CodigoPostal
		  ,@EmpresaRepresentante = Representante
		  ,@EmpresaRegistroPatronal = RegistroPatronal
		  ,@EmpresaGLN = GLN
		  ,@EmpresaTelefonos = Telefonos
	FROM Empresa WITH(NOLOCK)
	WHERE Empresa = @Empresa

	IF @TipoAddenda IN ('CHEDRAUI', 'EDIFACT')
		AND LEN(@EmpresaRFC) NOT IN (12, 13)
		SELECT @EmpresaRFC = NULL

	SELECT @noCertificado = noCertificado
		  ,@Version =
		   CASE
			   WHEN versionFecha < @Fecha
				   OR versionFecha IS NULL THEN version
			   ELSE versionAnterior
		   END
		  ,@EmpresaEAN13 = EAN13
		  ,@EmpresaDUN14 = DUN14
		  ,@EmpresaSKUCliente = SKU
		  ,@EmpresaSKUEmpresa = SKUEmpresa
		  ,@EmpresaSKUCodigoInterno = ISNULL(SKUCodigoInterno, 0)
		  ,@ModoPruebas = ModoPruebas
		  ,@PaqueteEsCantidad = PaqueteEsCantidad
		  ,@AgruparDetalle = AgruparDetalle
		  ,@CfgDecimales = ISNULL(Decimales, 2)
	FROM EmpresaCFD WITH(NOLOCK)
	WHERE Empresa = @Empresa

	IF ISNULL(@LayOut, '') IN ('SAT', '')
		AND @Version = '2.2'
	BEGIN

		IF ISNULL(@LayOut, '') IN ('')
			AND @Validar = 1
			EXEC spGenerarCFDSAT22 @Estacion
								  ,@Modulo
								  ,@ID
								  ,''
								  ,1
								  ,@Ok OUTPUT
								  ,@OkRef OUTPUT

		IF @LayOut = 'SAT'
		BEGIN
			SELECT @LayOut = 'SAT_2.2'
				  ,@TipoAddenda = NULL
			EXEC spGenerarCFDSAT22 @Estacion
								  ,@Modulo
								  ,@ID
								  ,'SAT_2.2'
		END

		RETURN
	END
	ELSE

	IF ISNULL(@LayOut, '') IN ('SAT', '')
		AND @Version = '3.2'
	BEGIN

		IF ISNULL(@LayOut, '') IN ('')
			AND @Validar = 1
			EXEC spGenerarCFDSAT32 @Estacion
								  ,@Modulo
								  ,@ID
								  ,''
								  ,1
								  ,@Ok OUTPUT
								  ,@OkRef OUTPUT

		IF @LayOut = 'SAT'
		BEGIN
			SELECT @LayOut = 'SAT_3.2'
				  ,@TipoAddenda = NULL
			EXEC spGenerarCFDSAT32 @Estacion
								  ,@Modulo
								  ,@ID
								  ,'SAT_3.2'
		END

		RETURN
	END

	SELECT @DefImpuesto = DefImpuesto
	FROM EmpresaGral WITH(NOLOCK)
	SELECT @DefImpuestoZona = @DefImpuesto
	EXEC spZonaImp @ZonaImpuesto
				  ,@DefImpuestoZona OUTPUT
	SELECT @MonedaClave = Clave
	FROM Mon WITH(NOLOCK)
	WHERE Moneda = @Moneda
	SELECT @DescuentoClave = Clave
	FROM Descuento WITH(NOLOCK)
	WHERE Descuento = @Descuento
	SELECT @SucursalNombre = Nombre
		  ,@SucursalGLN = GLN
		  ,@SucursalDireccion = Direccion
		  ,@SucursalDireccionNumero = DireccionNumero
		  ,@SucursalDireccionNumeroInt = DireccionNumeroInt
		  ,@SucursalColonia = Colonia
		  ,@SucursalPoblacion = Poblacion
		  ,@SucursalObservaciones = NULL
		  ,@SucursalDelegacion = Delegacion
		  ,@SucursalEstado = Estado
		  ,@SucursalPais = Pais
		  ,@SucursalCodigoPostal = CodigoPostal
	FROM Sucursal WITH(NOLOCK)
	WHERE Sucursal = @Sucursal
	SELECT @TipoCondicion = TipoCondicion
		  ,@formaDePago = CFD_formaDePago
		  ,@metodoDePago = CFD_metodoDePago
		  ,@DiasVencimiento = ISNULL(DiasVencimiento, 1)
		  ,@ProntoPago = ProntoPago
		  ,@DescuentoProntoPago = DescuentoProntoPago
	FROM Condicion WITH(NOLOCK)
	WHERE Condicion = @Condicion

	IF @Modulo = 'CXC'
	BEGIN
		SELECT @MovTipo = Clave
		FROM MovTipo WITH(NOLOCK)
		WHERE Modulo = @Modulo
		AND Mov = @Mov

		IF @MovTipo = 'CXC.CA'
		BEGIN

			IF @Mov = 'Nota Cargo'
				SET @CampoExtra = 'NC_FACTURA'
			ELSE

			IF @Mov = 'Nota Cargo VIU'
				SET @CampoExtra = 'NCV_FACTURA'
			ELSE

			IF @Mov = 'Nota Cargo Mayoreo'
				SET @CampoExtra = 'NCM_FACTURA'

			SET @ExtraCondicion = (
				SELECT Valor
				FROM MovCampoExtra WITH(NOLOCK)
				WHERE ID = @ID
				AND CampoExtra = @CampoExtra
			)

			IF @ExtraCondicion <> ''
			BEGIN
				SELECT @MovE = (
						   SELECT CASE
								WHEN Valor LIKE ('Factura Mayoreo_%') THEN 'Factura Mayoreo'
								WHEN Valor LIKE ('Factura VIU_%') THEN 'Factura VIU'
								WHEN Valor LIKE ('Factura_%') THEN 'Factura'
								WHEN Valor LIKE ('Nota Cargo_%') THEN 'Nota Cargo'
								WHEN Valor LIKE ('Nota Cargo Mayoreo_%') THEN 'Nota Cargo Mayoreo'
								WHEN Valor LIKE ('Nota Cargo VIU_%') THEN 'Nota Cargo VIU'
								WHEN Valor LIKE ('Endoso_%') THEN 'Endoso'
								WHEN Valor LIKE ('Credilana_%') THEN 'Credilana'
								WHEN Valor LIKE ('Prestamo Personal_%') THEN 'Prestamo Personal'
								WHEN Valor LIKE ('Refinanciamiento_%') THEN 'Refinanciamiento'
								WHEN Valor LIKE ('Seguro Vida_%') THEN 'Seguro Vida'
								WHEN Valor LIKE ('Seguro Auto_%') THEN 'Seguro Auto'
							END
					   )
					  ,@MovIDE = (
						   SELECT CASE
								WHEN Valor LIKE ('Factura Mayoreo_%') THEN SUBSTRING(Valor, LEN('Factura Mayoreo_') + 1, (LEN(Valor) - LEN('Factura Mayoreo_')))
								WHEN Valor LIKE ('Factura VIU_%') THEN SUBSTRING(Valor, LEN('Factura VIU_') + 1, (LEN(Valor) - LEN('Factura VIU_')))
								WHEN Valor LIKE ('Factura_%') THEN SUBSTRING(Valor, LEN('Factura_') + 1, (LEN(Valor) - LEN('Factura_')))
								WHEN Valor LIKE ('Nota Cargo_%') THEN SUBSTRING(Valor, LEN('Nota Cargo_') + 1, (LEN(Valor) - LEN('Nota Cargo_')))
								WHEN Valor LIKE ('Nota Cargo Mayoreo_%') THEN SUBSTRING(Valor, LEN('Nota Cargo Mayoreo_') + 1, (LEN(Valor) - LEN('Nota Cargo Mayoreo_')))
								WHEN Valor LIKE ('Nota Cargo VIU_%') THEN SUBSTRING(Valor, LEN('Nota Cargo VIU_') + 1, (LEN(Valor) - LEN('Nota Cargo VIU_')))
								WHEN Valor LIKE ('Endoso_%') THEN SUBSTRING(Valor, LEN('Endoso_') + 1, (LEN(Valor) - LEN('Endoso_')))
								WHEN Valor LIKE ('Credilana_%') THEN SUBSTRING(Valor, LEN('Credilana_') + 1, (LEN(Valor) - LEN('Credilana_')))
								WHEN Valor LIKE ('Prestamo Personal_%') THEN SUBSTRING(Valor, LEN('Prestamo Personal_') + 1, (LEN(Valor) - LEN('Prestamo Personal_')))
								WHEN Valor LIKE ('Refinanciamiento_%') THEN SUBSTRING(Valor, LEN('Refinanciamiento_') + 1, (LEN(Valor) - LEN('Refinanciamiento_')))
								WHEN Valor LIKE ('Seguro Vida_%') THEN SUBSTRING(Valor, LEN('Seguro Vida_') + 1, (LEN(Valor) - LEN('Seguro Vida_')))
								WHEN Valor LIKE ('Seguro Auto_%') THEN SUBSTRING(Valor, LEN('Seguro Auto_') + 1, (LEN(Valor) - LEN('Seguro Auto_')))
							END
					   )
				FROM MovCampoExtra WITH(NOLOCK)
				WHERE ID = @ID
				AND CampoExtra = @CampoExtra

				IF @MovE IN ('Endoso', 'Documento')
				BEGIN
					SELECT TOP 1 @OrigenDoc = Aplica
								,@OrigenIDDoc = AplicaID
					FROM CXCD d WITH(NOLOCK)
						,CXC c
					WHERE c.Mov = @MovE
					AND c.MovID = @MovIDE
					AND d.ID = c.ID
					SELECT @MovOrigen = Origen
						  ,@MovOrigenID = OrigenID
					FROM CXC WITH(NOLOCK)
					WHERE Mov = @OrigenDoc
					AND MovID = @OrigenIDDoc
					SELECT @formadePago = c.CFD_formaDePago
						  ,@TipoCondicion = c.TipoCondicion
					FROM cxc x WITH(NOLOCK)
						,condicion c WITH(NOLOCK)
					WHERE x.condicion = c.condicion
					AND x.MovID = @MovOrigenID
					AND x.Mov = @MovOrigen
				END

				IF @MovE LIKE 'Nota Cargo%'
					OR @MovE LIKE 'Factura%'
					OR @MovE IN ('Cheque Devuelto', 'Credilana', 'Prestamo Personal', 'Refinanciamiento', 'Seguro Auto', 'Seguro Vida')
				BEGIN
					SELECT @formadePago = c.CFD_formaDePago
						  ,@TipoCondicion = c.TipoCondicion
					FROM cxc v WITH(NOLOCK)
						,condicion c WITH(NOLOCK)
					WHERE v.mov = @MovE
					AND v.movid = @MovIDE
					AND v.condicion = c.condicion
				END

			END
			ELSE
				SELECT @formadePago = c.CFD_formaDePago
					  ,@TipoCondicion = c.TipoCondicion
				FROM condicion c WITH(NOLOCK)
					,cxc x WITH(NOLOCK)
				WHERE x.ID = @ID
				AND x.condicion = c.condicion

		END

		IF @MovTipo = 'CXC.NC'
		BEGIN

			IF @Origen LIKE 'Devolucion%'
			BEGIN
				SELECT @MovE = (
						   SELECT CASE
								WHEN Referencia LIKE ('Factura Mayoreo_%') THEN 'Factura Mayoreo'
								WHEN Referencia LIKE ('Factura VIU_%') THEN 'Factura VIU'
								WHEN Referencia LIKE ('Factura_%') THEN 'Factura'
							END
					   )
					  ,@MovIDE = (
						   SELECT CASE
								WHEN Referencia LIKE ('Factura Mayoreo_%') THEN SUBSTRING(Referencia, LEN('Factura Mayoreo_') + 1, (LEN(Referencia) - LEN('Factura Mayoreo_')))
								WHEN Referencia LIKE ('Factura VIU_%') THEN SUBSTRING(Referencia, LEN('Factura VIU_') + 1, (LEN(Referencia) - LEN('Factura VIU_')))
								WHEN Referencia LIKE ('Factura_%') THEN SUBSTRING(Referencia, LEN('Factura_') + 1, (LEN(Referencia) - LEN('Factura_')))
							END
					   )
				FROM Venta WITH(NOLOCK)
				WHERE Mov = @Origen
				AND MovID = @OrigenID
				SELECT @formadePago = c.CFD_formaDePago
					  ,@TipoCondicion = c.TipoCondicion
				FROM condicion c WITH(NOLOCK)
					,venta v WITH(NOLOCK)
				WHERE c.condicion = v.condicion
				AND v.mov = @MovE
				AND v.movid = @MovIDE
			END
			ELSE
			BEGIN
				SELECT TOP 1 @MovE = Aplica
							,@MovIDE = AplicaID
				FROM CxcD WITH(NOLOCK)
				WHERE ID = @ID

				IF @MovE = 'Documento'
				BEGIN
					SELECT @OrigenE = Origen
						  ,@OrigenIDE = OrigenID
					FROM Cxc WITH(NOLOCK)
					WHERE Mov = @MovE
					AND MovID = @MovIDE
					SELECT @formadePago = c.CFD_formaDePago
						  ,@TipoCondicion = c.TipoCondicion
					FROM Cxc x WITH(NOLOCK)
						,condicion c WITH(NOLOCK)
					WHERE x.condicion = c.condicion
					AND x.MovID = @OrigenIDE
					AND x.Mov = @OrigenE
				END

				IF @MovE IN ('Cta Incobrable F', 'Endoso')
				BEGIN
					SELECT TOP 1 @OrigenDoc = Aplica
								,@OrigenIDDoc = AplicaID
					FROM CXCD d WITH(NOLOCK)
						,CXC c WITH(NOLOCK)
					WHERE c.Mov = @MovE
					AND c.MovID = @MovIDE
					AND d.ID = c.ID
					SELECT @MovOrigen = Origen
						  ,@MovOrigenID = OrigenID
					FROM CXC WITH(NOLOCK)
					WHERE Mov = @OrigenDoc
					AND MovID = @OrigenIDDoc
					SELECT @formadePago = c.CFD_formaDePago
						  ,@TipoCondicion = c.TipoCondicion
					FROM cxc x WITH(NOLOCK)
						,condicion c WITH(NOLOCK)
					WHERE x.condicion = c.condicion
					AND x.MovID = @MovOrigenID
					AND x.Mov = @MovOrigen
				END

				IF @MovE = 'Cheque Devuelto'
					OR @MovE LIKE 'Factura%'
				BEGIN
					SELECT @formadePago = c.CFD_formaDePago
						  ,@TipoCondicion = c.TipoCondicion
					FROM cxc v WITH(NOLOCK)
						,condicion c WITH(NOLOCK)
					WHERE v.mov = @MovE
					AND v.movid = @MovIDE
					AND v.condicion = c.condicion
				END

				IF @MovE LIKE 'Nota Cargo%'
				BEGIN

					IF @MovE = 'Nota Cargo'
						SET @CampoExtraE = 'NC_FACTURA'
					ELSE

					IF @MovE = 'Nota Cargo VIU'
						SET @CampoExtraE = 'NCV_FACTURA'
					ELSE

					IF @MovE = 'Nota Cargo Mayoreo'
						SET @CampoExtraE = 'NCM_FACTURA'

					SELECT @IDNota = ID
					FROM Cxc WITH(NOLOCK)
					WHERE Mov = @MovE
					AND MovID = @MovIDE
					SET @ExtraCondicion = (
						SELECT Valor
						FROM MovCampoExtra WITH(NOLOCK)
						WHERE ID = @IDNota
						AND CampoExtra = @CampoExtraE
					)

					IF @ExtraCondicion <> ''
						SELECT @MovNota = (
								   SELECT CASE
										WHEN Valor LIKE ('Factura Mayoreo_%') THEN 'Factura Mayoreo'
										WHEN Valor LIKE ('Factura VIU_%') THEN 'Factura VIU'
										WHEN Valor LIKE ('Factura_%') THEN 'Factura'
										WHEN Valor LIKE ('Nota Cargo_%') THEN 'Nota Cargo'
										WHEN Valor LIKE ('Nota Cargo Mayoreo_%') THEN 'Nota Cargo Mayoreo'
										WHEN Valor LIKE ('Nota Cargo VIU_%') THEN 'Nota Cargo VIU'
										WHEN Valor LIKE ('Endoso_%') THEN 'Endoso'
										WHEN Valor LIKE ('Credilana_%') THEN 'Credilana'
										WHEN Valor LIKE ('Prestamo Personal_%') THEN 'Prestamo Personal'
										WHEN Valor LIKE ('Refinanciamiento_%') THEN 'Refinanciamiento'
										WHEN Valor LIKE ('Seguro Vida_%') THEN 'Seguro Vida'
										WHEN Valor LIKE ('Seguro Auto_%') THEN 'Seguro Auto'
									END
							   )
							  ,@MovNotaID = (
								   SELECT CASE
										WHEN Valor LIKE ('Factura Mayoreo_%') THEN SUBSTRING(Valor, LEN('Factura Mayoreo_') + 1, (LEN(Valor) - LEN('Factura Mayoreo_')))
										WHEN Valor LIKE ('Factura VIU_%') THEN SUBSTRING(Valor, LEN('Factura VIU_') + 1, (LEN(Valor) - LEN('Factura VIU_')))
										WHEN Valor LIKE ('Factura_%') THEN SUBSTRING(Valor, LEN('Factura_') + 1, (LEN(Valor) - LEN('Factura_')))
										WHEN Valor LIKE ('Nota Cargo_%') THEN SUBSTRING(Valor, LEN('Nota Cargo_') + 1, (LEN(Valor) - LEN('Nota Cargo_')))
										WHEN Valor LIKE ('Nota Cargo Mayoreo_%') THEN SUBSTRING(Valor, LEN('Nota Cargo Mayoreo_') + 1, (LEN(Valor) - LEN('Nota Cargo Mayoreo_')))
										WHEN Valor LIKE ('Nota Cargo VIU_%') THEN SUBSTRING(Valor, LEN('Nota Cargo VIU_') + 1, (LEN(Valor) - LEN('Nota Cargo VIU_')))
										WHEN Valor LIKE ('Endoso_%') THEN SUBSTRING(Valor, LEN('Endoso_') + 1, (LEN(Valor) - LEN('Endoso_')))
										WHEN Valor LIKE ('Credilana_%') THEN SUBSTRING(Valor, LEN('Credilana_') + 1, (LEN(Valor) - LEN('Credilana_')))
										WHEN Valor LIKE ('Prestamo Personal_%') THEN SUBSTRING(Valor, LEN('Prestamo Personal_') + 1, (LEN(Valor) - LEN('Prestamo Personal_')))
										WHEN Valor LIKE ('Refinanciamiento_%') THEN SUBSTRING(Valor, LEN('Refinanciamiento_') + 1, (LEN(Valor) - LEN('Refinanciamiento_')))
										WHEN Valor LIKE ('Seguro Vida_%') THEN SUBSTRING(Valor, LEN('Seguro Vida_') + 1, (LEN(Valor) - LEN('Seguro Vida_')))
										WHEN Valor LIKE ('Seguro Auto_%') THEN SUBSTRING(Valor, LEN('Seguro Auto_') + 1, (LEN(Valor) - LEN('Seguro Auto_')))
									END
							   )
						FROM MovCampoExtra WITH(NOLOCK)
						WHERE ID = @IDNota
						AND CampoExtra = @CampoExtraE

					IF @MovNota = 'Documento'
					BEGIN
						SELECT @OrigenE = Origen
							  ,@OrigenIDE = OrigenID
						FROM Cxc WITH(NOLOCK)
						WHERE Mov = @MovNota
						AND MovID = @MovNotaID
						SELECT @formadePago = c.CFD_formaDePago
							  ,@TipoCondicion = c.TipoCondicion
						FROM Cxc x WITH(NOLOCK)
							,condicion c WITH(NOLOCK)
						WHERE x.condicion = c.condicion
						AND x.MovID = @OrigenIDE
						AND x.Mov = @OrigenE
					END

					IF @MovNota IN ('Endoso')
					BEGIN
						SELECT TOP 1 @OrigenDoc = Aplica
									,@OrigenIDDoc = AplicaID
						FROM CXCD d WITH(NOLOCK)
							,CXC c WITH(NOLOCK)
						WHERE c.Mov = @MovNota
						AND c.MovID = @MovNotaID
						AND d.ID = c.ID
						SELECT @MovOrigen = Origen
							  ,@MovOrigenID = OrigenID
						FROM CXC WITH(NOLOCK)
						WHERE Mov = @OrigenDoc
						AND MovID = @OrigenIDDoc
						SELECT @formadePago = c.CFD_formaDePago
							  ,@TipoCondicion = c.TipoCondicion
						FROM cxc x WITH(NOLOCK)
							,condicion c WITH(NOLOCK)
						WHERE x.condicion = c.condicion
						AND x.MovID = @MovOrigenID
						AND x.Mov = @MovOrigen
					END

					IF @MovNota LIKE 'Nota Cargo%'
						OR @MovNota = 'Cheque Devuelto'
						OR @MovNota LIKE 'Factura%'
					BEGIN
						SELECT @formadePago = c.CFD_formaDePago
							  ,@TipoCondicion = c.TipoCondicion
						FROM cxc v WITH(NOLOCK)
							,condicion c WITH(NOLOCK)
						WHERE v.mov = @MovNota
						AND v.movid = @MovNotaID
						AND v.condicion = c.condicion
					END

				END

			END

		END

	END

	SELECT @MovTipo = Clave
		  ,@tipoDeComprobante = CFD_tipoDeComprobante
		  ,@ConsecutivoModulo = ConsecutivoModulo
		  ,@ConsecutivoMov = ConsecutivoMov
	FROM MovTipo WITH(NOLOCK)
	WHERE Modulo = @Modulo
	AND Mov = @Mov
	EXEC spMovIDEnSerieConsecutivo @MovID
								  ,@Serie OUTPUT
								  ,@Folio OUTPUT
	SELECT @noAprobacion = noAprobacion
		  ,@fechaAprobacion = fechaAprobacion
	FROM CFDFolio WITH(NOLOCK)
	WHERE Empresa = @Empresa
	AND Modulo = @ConsecutivoModulo
	AND Mov = @ConsecutivoMov
	AND Serie = @Serie
	AND @Folio BETWEEN FolioD AND FolioA
	AND Estatus = 'ALTA'

	IF @@ROWCOUNT = 0
		SELECT @noAprobacion = noAprobacion
			  ,@fechaAprobacion = fechaAprobacion
		FROM CFDFolio WITH(NOLOCK)
		WHERE Empresa = @Empresa
		AND Modulo = @ConsecutivoModulo
		AND Mov = @ConsecutivoMov
		AND ISNULL(Serie, '') = ISNULL(@Serie, '')
		AND @Folio BETWEEN FolioD AND FolioA
		AND Estatus = 'ALTA'

	IF @Layout <> 'SAT'
	BEGIN

		IF @MovTipo IN ('VTAS.D', 'VTAS.B')
		BEGIN
			SELECT @ReferenciaFecha = Fecha
			FROM CFD WITH(NOLOCK)
			WHERE Empresa = @Empresa
			AND MovID = @Referencia

			IF @@ROWCOUNT = 0
				SELECT @ReferenciaFecha = FechaRegistro
				FROM Venta WITH(NOLOCK)
				WHERE Empresa = @Empresa
				AND MovID = @Referencia
				AND Estatus IN ('CONCLUIDO', 'PENDIENTE')

		END

		SELECT @Antecedente =
		 CASE
			 WHEN @Estatus = 'CANCELADO' THEN @MovID
			 WHEN @MovTipo IN ('VTAS.D', 'VTAS.B', 'CXC.NC', 'CXC.CA') THEN @Referencia
			 ELSE @OrdenCompra
		 END
		SELECT @AntecedenteFecha =
		 CASE
			 WHEN @Estatus = 'CANCELADO' THEN @Fecha
			 WHEN @MovTipo IN ('VTAS.D', 'VTAS.B', 'CXC.NC', 'CXC.CA') THEN @ReferenciaFecha
			 ELSE @FechaOrdenCompra
		 END
		SELECT @ReferenciaEnvio = dbo.fnDateTimeFmt(GETDATE(), 'AAMMDDHHMMSSMM')
	END

	EXEC xpGenerarCFDEncabezado @Estacion
							   ,@Modulo
							   ,@ID
							   ,@Layout
							   ,@Validar
							   ,@Empresa
							   ,@Sucursal
							   ,@Cliente
							   ,@EnviarA
							   ,@EmpresaGLN
							   ,@Version
							   ,@Mov
							   ,@MovID
							   ,@Estatus
							   ,@ConsecutivoModulo
							   ,@ConsecutivoMov
							   ,@Fecha
							   ,@Serie
							   ,@Folio
							   ,@MovTipo
							   ,@tipoDeComprobante
							   ,@TipoAddenda
							   ,@AddendaVersion
							   ,@Moneda
							   ,@TipoCambio
							   ,@Liverpool
							   ,@Gigante
							   ,@ComercialMexicana
							   ,@Elektra
							   ,@EHB
							   ,@Origen
							   ,@OrigenID
							   ,@SucursalGLN OUTPUT
							   ,@ClienteGLN OUTPUT
							   ,@EnviarAGLN OUTPUT
							   ,@Referencia OUTPUT
							   ,@ReferenciaFecha OUTPUT
							   ,@FormaEnvio OUTPUT
							   ,@Condicion OUTPUT
							   ,@Vencimiento OUTPUT
							   ,@formaDePago OUTPUT
							   ,@metodoDePago OUTPUT
							   ,@EmisorID OUTPUT
							   ,@ReceptorID OUTPUT
							   ,@ProveedorID OUTPUT
							   ,@OrdenCompra OUTPUT
							   ,@FechaOrdenCompra OUTPUT
							   ,@DepartamentoClave OUTPUT
							   ,@DepartamentoNombre OUTPUT
							   ,@DepartamentoContacto OUTPUT
							   ,@Observaciones OUTPUT
							   ,@EnviarAClave OUTPUT
							   ,@Embarque OUTPUT
							   ,@EmbarqueFecha OUTPUT
							   ,@Recibo OUTPUT
							   ,@ReciboFecha OUTPUT
							   ,@MonedaClave OUTPUT
							   ,@FechaRequerida OUTPUT
							   ,@TipoCondicion OUTPUT
							   ,@DescuentoClave OUTPUT
							   ,@Antecedente OUTPUT
							   ,@AntecedenteFecha OUTPUT
							   ,@ReferenciaEnvio OUTPUT
							   ,@Ok OUTPUT
							   ,@OkRef OUTPUT
							   ,@AgruparDetalle OUTPUT
							   ,@ClienteDireccion OUTPUT
							   ,@EnviarADireccion OUTPUT

	IF @Validar = 1
	BEGIN

		IF @MovID IS NOT NULL
		BEGIN

			IF @noAprobacion IS NULL
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - No Aprobacion'

			IF @FechaAprobacion IS NULL
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - Año Aprobacion'

			IF @Folio IS NULL
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - Folio'

		END

		IF @Fecha IS NULL
			SELECT @Ok = 10010
				  ,@OkRef = 'CFD - Fecha'

		IF NULLIF(RTRIM(@FormaDePago), '') IS NULL
			SELECT @Ok = 10010
				  ,@OkRef = 'CFD - Forma De Pago'

		IF NULLIF(RTRIM(@noCertificado), '') IS NULL
			SELECT @Ok = 10010
				  ,@OkRef = 'CFD - Empresa Nombre'

		IF @SubTotal IS NULL
			SELECT @Ok = 10010
				  ,@OkRef = 'CFD - SubTotal'

		IF @Total IS NULL
			SELECT @Ok = 10010
				  ,@OkRef = 'CFD - Total'

		IF NULLIF(RTRIM(@tipoDeComprobante), '') IS NULL
			SELECT @Ok = 10010
				  ,@OkRef = 'CFD - Tipo de Comprobante'

		IF NULLIF(RTRIM(@EmpresaRFC), '') IS NULL
			SELECT @Ok = 10010
				  ,@OkRef = 'CFD - Empresa RFC'

		IF LEN(@EmpresaRFC) NOT IN (12, 13)
			SELECT @Ok = 10010
				  ,@OkRef = 'CFD - Empresa RFC Requiere 12 o 13 Caracteres'

		IF NULLIF(RTRIM(@ClienteRFC), '') IS NULL
			SELECT @Ok = 10010
				  ,@OkRef = 'CFD - Cliente RFC'

		IF LEN(@ClienteRFC) NOT IN (12, 13)
			SELECT @Ok = 10010
				  ,@OkRef = 'CFD - Cliente RFC Requiere 12 o 13 Caracteres'

		IF NULLIF(RTRIM(@ClientePais), '') IS NULL
			SELECT @Ok = 10010
				  ,@OkRef = 'CFD - Cliente Pais'

		IF @Modulo = 'VTAS'
			AND @LayOut = 'DETALLISTA'
		BEGIN

			IF NULLIF(RTRIM(@Antecedente), '') IS NULL
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - Orden Compra'

			IF NULLIF(RTRIM(@FechaOrdenCompra), '') IS NULL
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - Fecha Orden Compra'

			IF NULLIF(RTRIM(@ClienteGLN), '') IS NULL
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - Cliente GLN'

			IF LEN(@ClienteGLN) <> 13
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - Cliente GLN Requiere 13 Caracteres'

			IF ISNULL(NULLIF(RTRIM(@ProveedorIDDeptoEnviarA), ''), NULLIF(RTRIM(@ProveedorID), '')) IS NULL
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - ProveedorID'

			IF NULLIF(RTRIM(@Recibo), '') IS NULL
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - Recibo'

			IF LEN(@Recibo) > 35
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - Recibo Excede Tamaño Maximo 35'

			IF NULLIF(RTRIM(@ReciboFecha), '') IS NULL
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - Fecha Recibo'

			IF NULLIF(RTRIM(@DepartamentoClave), '') IS NULL
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - Clave Departamento Cliente'

			IF LEN(@DepartamentoClave) > 35
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - Clave Departamento Cliente Excede Tamaño Maximo 35'

			IF NULLIF(RTRIM(@EmpresaGLN), '') IS NULL
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - Empresa GLN'

			IF LEN(@EmpresaGLN) <> 13
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - Empresa GLN Requiere 13 Caracteres'

			IF LEN(@MonedaClave) <> 3
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - Moneda Clave Requiere 3 Caracteres'

			IF @MonedaClave NOT IN ('', NULL, 'MXN', 'XEU', 'USD')
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - Moneda Clave Debe ser MXN, XEUó USD)'

		END

		IF @Layout LIKE '%INTERFACTURA%'
			OR @TipoAddenda LIKE '%INTERFACTURA%'
		BEGIN

			IF NULLIF(RTRIM(@EmisorID), '') IS NULL
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - EmisorID'

			IF NULLIF(RTRIM(@ReceptorID), '') IS NULL
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - ReceptorID'

			IF NULLIF(RTRIM(@ProveedorID), '') IS NULL
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - ProveedorID'

			IF NULLIF(RTRIM(@monedaClave), '') IS NULL
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - Moneda Clave'

			IF @Modulo = 'CXC'
				AND @MovTipo IN ('CXC.NC', 'CXC.CA')
			BEGIN

				IF NULLIF(RTRIM(@Antecedente), '') IS NULL
					SELECT @Ok = 10010
						  ,@OkRef = 'CFD - Referencia'

				-- IF NULLIF(RTRIM(@Concepto), '') IS NULL
				-- 	SELECT @Ok = 10010
				-- 		  ,@OkRef = 'CFD - Concepto'

			END

		END

		IF @Layout IN ('INTERFACTURA / EHB', 'INTERFACTURA / HEB')
			OR @TipoAddenda IN ('INTERFACTURA / EHB', 'INTERFACTURA / HEB')
		BEGIN

			IF NULLIF(RTRIM(@monedaClave), '') NOT IN ('MXN', 'USD')
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - Moneda Clave No Existe'

			IF NULLIF(RTRIM(@EnviarAClave), '') IS NULL
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - EnviarAClave'

			IF NULLIF(RTRIM(CONVERT(VARCHAR(10), @Total)), '') IS NULL
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - Total'

			IF NULLIF(RTRIM(CONVERT(VARCHAR(10), @SubTotal)), '') IS NULL
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - SubTotal'

			IF NULLIF(RTRIM(@ProveedorID), '') IS NULL
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - ProveedorID'

			IF NULLIF(RTRIM(@EnviarADelegacion), '') IS NULL
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - Enviar a Delegacion'

			IF NULLIF(RTRIM(@Moneda), '') IS NULL
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - Moneda'

			IF NULLIF(RTRIM(CONVERT(VARCHAR(10), @Impuesto1Total)), '') IS NULL
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - Impuesto1Total'

			IF NULLIF(RTRIM(@EnviarADireccion), '') IS NULL
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - Enviar a Direccion'

			IF NULLIF(RTRIM(@DepartamentoClave), '') IS NULL
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - Clave Departamento HEB'

			IF dbo.fnEsNumerico(@OrdenCompra) = 0
				SELECT @Ok = 10010
					  ,@OkRef = 'CFD - Orden Compra Debe Ser Numero'

		END

	END

	IF @MovTipo IN ('VTAS.F', 'VTAS.D', 'VTAS.DF', 'VTAS.B')
	BEGIN

		IF @ClienteRFC IS NOT NULL
			AND LEN(@ClienteRFC) >= 9
		BEGIN
			SELECT @p = SUBSTRING(@ClienteRFC, 4, 1)

			IF UPPER(@p) NOT IN ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z')
			BEGIN
				SELECT @RetencionFlete = SUM(Subtotal * 0.04)
				FROM VentaTCalc WITH(NOLOCK)
				WHERE ID = @ID
				AND Articulo = 'FLETE'
			END

		END

		IF EXISTS (SELECT * FROM Cte WITH(NOLOCK) WHERE Cliente = @Cliente AND NULLIF(RTRIM(PITEX), '') IS NOT NULL)
		BEGIN
			SELECT @RetencionPitex = @Impuesto1Total + ISNULL(@AnticiposImpuestos, 0)
		END

		SELECT @RetencionTotal = ISNULL(@RetencionFlete, 0.0) + ISNULL(@RetencionPitex, 0.0)
	END

	IF @Layout = 'SAT'
	BEGIN
		SELECT '<?xml version="1.0" encoding="UTF-8"?>'

		IF @Version = '1.0'
			SELECT '<Comprobante' +
			 dbo.fnXML('version', @Version) +
			 dbo.fnXML('serie', @Serie) +
			 dbo.fnXMLBigint('folio', @Folio) +
			 dbo.fnXMLDatetime('fecha', @Fecha) +
			 dbo.fnXML('sello', '{@Sello}') +
			 dbo.fnXMLInt('noAprobacion', @noAprobacion) +
			 dbo.fnXML('formaDePago', @formaDePago) +
			 dbo.fnXML('noCertificado', @noCertificado) +
			 dbo.fnXML8000('certificado', '{@Certificado}') +
			 '>'
		ELSE
			SELECT '<Comprobante' +
			 CASE
				 WHEN @TipoAddenda = 'Detallista' THEN ' xmlns:xsi=' + CHAR(34) + 'http://www.w3.org/2001/XMLSchema-instance' + CHAR(34) + ' xmlns=' + CHAR(34) + 'http://www.sat.gob.mx/cfd/2' + CHAR(34) + ' xmlns:detallista=' + CHAR(34) + 'http://www.sat.gob.mx/detallista' + CHAR(34) + ' xsi:schemaLocation=' + CHAR(34) + 'http://www.sat.gob.mx/cfd/2 http://www.sat.gob.mx/sitio_internet/cfd/2/cfdv2.xsd http://www.sat.gob.mx/detallista http://www.sat.gob.mx/sitio_internet/cfd/detallista/detallista.xsd' + CHAR(34) + ' '
				 ELSE ' xmlns=' + CHAR(34) + 'http://www.sat.gob.mx/cfd/2' + CHAR(34) + ' xmlns:xsi=' + CHAR(34) + 'http://www.w3.org/2001/XMLSchema-instance' + CHAR(34) + ' xsi:schemaLocation=' + CHAR(34) + 'http://www.sat.gob.mx/cfd/2 http://www.sat.gob.mx/sitio_internet/cfd/2/cfdv2.xsd' + CHAR(34) + ' '
			 END +
			 dbo.fnXML('version', @Version) +
			 dbo.fnXML('serie', @Serie) +
			 dbo.fnXMLBigint('folio', @Folio) +
			 dbo.fnXMLDatetime('fecha', @Fecha) +
			 dbo.fnXML('sello', '{@Sello}') +
			 dbo.fnXMLInt('noAprobacion', @noAprobacion) +
			 dbo.fnXMLInt('anoAprobacion', YEAR(@fechaAprobacion)) +
			 dbo.fnXML('formaDePago', @formaDePago) +
			 dbo.fnXML('noCertificado', @noCertificado) +
			 dbo.fnXML8000('certificado', '{@Certificado}') +
			 dbo.fnXML('condicionesDePago', @TipoCondicion) +
			 dbo.fnXMLDecimal('subTotal', @SubTotal + ISNULL(@DescuentosTotales, 0.0), @CfgDecimales) +
			 dbo.fnXMLDecimal('descuento', @DescuentosTotales, @CfgDecimales) +
			 dbo.fnXML('motivoDescuento', NULLIF(RTRIM(@Descuento), '')) +
			 dbo.fnXMLDecimal('total', @Total - ISNULL(@RetencionTotal, 0.0), @CfgDecimales) +
			 dbo.fnXML('metodoDePago', @metodoDePago) +
			 dbo.fnXML('tipoDeComprobante', LOWER(@tipoDeComprobante)) +
			 '>'

		SELECT '<Emisor' +
		 dbo.fnXML('rfc', @EmpresaRFC) +
		 dbo.fnXML('nombre', @EmpresaNombre) +
		 '>'
		SELECT '<DomicilioFiscal' +
		 dbo.fnXML('calle', @EmpresaDireccion) +
		 dbo.fnXML('noExterior', @EmpresaDireccionNumero) +
		 dbo.fnXML('noInterior', @EmpresaDireccionNumeroInt) +
		 dbo.fnXML('colonia', @EmpresaColonia) +
		 dbo.fnXML('localidad', @EmpresaPoblacion) +
		 dbo.fnXML('referencia', @EmpresaObservaciones) +
		 dbo.fnXML('municipio', @EmpresaDelegacion) +
		 dbo.fnXML('estado', @EmpresaEstado) +
		 dbo.fnXML('pais', @EmpresaPais) +
		 dbo.fnXML('codigoPostal', @EmpresaCodigoPostal) +
		 '/>'

		IF @Sucursal <> 0
			SELECT '<ExpedidoEn' +
			 dbo.fnXML('calle', @SucursalDireccion) +
			 dbo.fnXML('noExterior', @SucursalDireccionNumero) +
			 dbo.fnXML('noInterior', @SucursalDireccionNumeroInt) +
			 dbo.fnXML('colonia', @SucursalColonia) +
			 dbo.fnXML('localidad', @SucursalPoblacion) +
			 dbo.fnXML('referencia', @SucursalObservaciones) +
			 dbo.fnXML('municipio', @SucursalDelegacion) +
			 dbo.fnXML('estado', @SucursalEstado) +
			 dbo.fnXML('pais', @SucursalPais) +
			 dbo.fnXML('codigoPostal', @SucursalCodigoPostal) +
			 '/>'

		SELECT '</Emisor>'
		SELECT '<Receptor' +
		 dbo.fnXML('rfc', @ClienteRFC) +
		 dbo.fnXML('nombre', @ClienteNombre) +
		 '>'
		SELECT '<Domicilio' +
		 dbo.fnXML('calle', @ClienteDireccion) +
		 dbo.fnXML('noExterior', @ClienteDireccionNumero) +
		 dbo.fnXML('noInterior', @ClienteDireccionNumeroInt) +
		 dbo.fnXML('colonia', @ClienteColonia) +
		 dbo.fnXML('localidad', @ClientePoblacion) +
		 dbo.fnXML('referencia', @ClienteObservaciones) +
		 dbo.fnXML('municipio', @ClienteDelegacion) +
		 dbo.fnXML('estado', @ClienteEstado) +
		 dbo.fnXML('pais', @ClientePais) +
		 dbo.fnXML('codigoPostal', @ClienteCodigoPostal) +
		 '/>'
		SELECT '</Receptor>'
	END
	ELSE

	IF @Layout LIKE 'AMECE%'
	BEGIN
		SELECT '<cfdi:Addenda>' +
		 '<requestForPayment' +
		 ' xmlns:xsi=' + CHAR(34) + 'http://www.w3.org/2001/XMLSchema-instance' + CHAR(34) + ' ' +
		 dbo.fnXML('type', 'SimpleInvoiceType') +
		 dbo.fnXML('contentVersion', '1.3.1') +
		 dbo.fnXML('documentStructureVersion', 'AMC7.1') +
		 dbo.fnXML('documentStatus', CASE
			 WHEN @Estatus = 'CANCELADO' THEN 'DELETE'
			 ELSE 'ORIGINAL'
		 END) +
		 CASE
			 WHEN @Gigante = 1
				 OR @ComercialMexicana = 1 THEN dbo.fnXMLDatetime('DeliveryDate', @Fecha)
			 ELSE dbo.fnXMLDatetimeFmt('DeliveryDate', @Fecha, 'AAAA-MM-DD')
		 END +
		 '>'
		SELECT '<requestForPaymentIdentification>' +
		 dbo.fnTag('entityType', CASE @MovTipo
			 WHEN 'VTAS.D' THEN 'CREDIT_NOTE'
			 WHEN 'VTAS.B' THEN 'DEBIT_NOTE'
			 ELSE 'INVOICE'
		 END) +
		 dbo.fnTag('uniqueCreatorIdentification', @MovID) +
		 '</requestForPaymentIdentification>'
		SELECT '<specialInstruction' + dbo.fnXML('code', CASE
			 WHEN @Gigante = 1 THEN 'PUR'
			 ELSE 'ZZZ'
		 END) + '>' +
		 dbo.fnTag('text', CASE
			 WHEN @Gigante = 1 THEN @InformacionCompra
			 ELSE RTRIM(@ImporteEnLetra) + ' M.N.'
		 END) +
		 '</specialInstruction>'
		SELECT '<orderIdentification>' +
		 '<referenceIdentification' + dbo.fnXML('type', 'ON') + '>' + ISNULL(@Antecedente, '') + '</referenceIdentification>' +
		 CASE
			 WHEN @Gigante = 0 THEN dbo.fnTagDateTimeFmt('ReferenceDate', @AntecedenteFecha, 'AAAA-MM-DD')
			 ELSE ''
		 END +
		 '</orderIdentification>'
		SELECT '<AdditionalInformation>' +
		 '<referenceIdentification' + dbo.fnXML('type', 'ATZ') + '>' + CONVERT(VARCHAR(20), ISNULL(@noAprobacion, 0)) + '</referenceIdentification>' +
		 '</AdditionalInformation>'

		IF NULLIF(RTRIM(@Recibo), '') IS NOT NULL
			AND @ReciboFecha IS NOT NULL
			SELECT '<DeliveryNote>' +
			 dbo.fnTag('referenceIdentification', @Recibo) +
			 CASE
				 WHEN @ComercialMexicana = 1 THEN dbo.fnTagDatetime('ReferenceDate', @Fecha)
				 ELSE dbo.fnTagDatetimeFmt('ReferenceDate', @Fecha, 'AAAA-MM-DD')
			 END +
			 '</DeliveryNote>'

		SELECT '<buyer>'
		SELECT '<gln>' + ISNULL(@ClienteGLN, '') + '</gln>'

		IF @Gigante = 0
			AND @DepartamentoClave IS NOT NULL
			SELECT '<contactInformation>' +
			 '<personOrDepartmentName>' +
			 dbo.fnTag('text', LEFT(@DepartamentoClave, 35)) +
			 '</personOrDepartmentName>' +
			 '</contactInformation>'

		SELECT '</buyer>'
		SELECT '<seller>' +
		 dbo.fnTag('gln', @EmpresaGLN) +
		 '<alternatePartyIdentification' + dbo.fnXML('type', 'SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY') + '>' + ISNULL(@ProveedorIDDeptoEnviarA, @ProveedorID) + '</alternatePartyIdentification>' +
		 '</seller>'

		IF @Liverpool = 0
			SELECT '<shipTo>' +
			 dbo.fnTag('gln', @EnviarAGLN) +
			 CASE
				 WHEN @Gigante = 0 THEN '<nameAndAddress>' +
					 dbo.fnTag('name', LEFT(@EnviarANombre, 35)) +
					 dbo.fnTag('streetAddressOne', LEFT(@EnviarADireccion + ' ' + @EnviarADireccionNumero + ' ' + ISNULL(@EnviarADireccionNumeroInt, '') + ' ' + ISNULL(@EnviarAColonia, ''), 35)) +
					 dbo.fnTag('city', LEFT(@EnviarAEstado, 35)) +
					 dbo.fnTag('postalCode', LEFT(@EnviarACodigoPostal, 9)) +
					 '</nameAndAddress>'
				 ELSE ''
			 END +
			 '</shipTo>'

		SELECT '<currency' + dbo.fnXML('currencyISOCode', @MonedaClave) + '>' +
		 dbo.fnTag('currencyFunction', 'BILLING_CURRENCY') +
		 dbo.fnTagFloat('rateOfChange', @TipoCambio) +
		 '</currency>'

		IF @Gigante = 0
			AND @Liverpool = 0
		BEGIN
			SELECT '<paymentTerms' +
			 dbo.fnXML('paymentTermsEvent', CASE @TipoCondicion
				 WHEN 'Contado' THEN 'DATE_OF_INVOICE'
				 ELSE 'EFFECTIVE_DATE'
			 END) +
			 dbo.fnXML('PaymentTermsRelationTime', 'REFERENCE_AFTER') + '>' +
			 '<netPayment' + dbo.fnXML('netPaymentTermsType', 'BASIC_NET') + '>' +
			 '<paymentTimePeriod>' +
			 '<timePeriodDue' + dbo.fnXML('timePeriod', 'DAYS') + '>' +
			 dbo.fnTagInt('value', @DiasVencimiento) +
			 '</timePeriodDue>' +
			 '</paymentTimePeriod>' +
			 '</netPayment>'

			IF @ProntoPago = 1
				SELECT '<discountPayment' + dbo.fnXML('discountType', 'ALLOWANCE_BY_PAYMENT_ON_TIME') + '>' +
				 dbo.fnTagFloat('percentage', @DescuentoProntoPago) +
				 '</discountPayment>'

			SELECT '</paymentTerms>'
		END

		SELECT '<allowanceCharge' + dbo.fnXML('settlementType', CASE
			 WHEN @Liverpool = 1 THEN 'BILL_BACK'
			 ELSE 'OFF_INVOICE'
		 END) + dbo.fnXML('allowanceChargeType', 'ALLOWANCE_GLOBAL') + '>' +
		 dbo.fnTag('specialServicesType', ISNULL(NULLIF(RTRIM(@DescuentoClave), ''), 'AJ')) +
		 '<monetaryAmountOrPercentage>' +
		 '<rate' + dbo.fnXML('base', 'INVOICE_VALUE') + '>' +
		 dbo.fnTag('percentage', ISNULL(@DescuentoGlobal, 0.00)) +
		 '</rate>' +
		 '</monetaryAmountOrPercentage>' +
		 '</allowanceCharge>'
	END
	ELSE

	IF @Layout LIKE '%INTERFACTURA%'
	BEGIN
		SELECT '<cfdi:Addenda>' +
		 CASE
			 WHEN @MovTipo IN ('VTAS.D', 'CXC.NC') THEN '<if:NotaCreditoInterfactura'
			 WHEN @MovTipo IN ('VTAS.B', 'CXC.CA') THEN '<if:NotaDebitoInterfactura'
			 ELSE '<if:FacturaInterfactura'
		 END +
		 dbo.fnXML('xmlns:if', 'https://www.interfactura.com/Schemas/Documentos') +
		 dbo.fnXML('TipoDocumento', CASE
			 WHEN @MovTipo IN ('VTAS.D', 'CXC.NC') THEN 'NotaCredito'
			 WHEN @MovTipo IN ('VTAS.B', 'CXC.CA') THEN 'NotaDebito'
			 ELSE 'Factura'
		 END) +
		 '>'
		SELECT '<if:Emisor' + dbo.fnXML('RI', @EmisorID) + dbo.fnXML('NumProveedor', @ProveedorID) + '/>'
		SELECT '<if:Receptor' + dbo.fnXML('RI', @ReceptorID) + '/>'
		SELECT '<if:Encabezado'

		IF @Elektra = 1
		BEGIN
			SELECT dbo.fnXMLDateTime('Fecha', @Fecha) +
			 dbo.fnXML('NumProveedor', @ProveedorID) +
			 dbo.fnXML('MonedaDoc', @monedaClave) +
			 dbo.fnXMLFloat('IVAPCT', ROUND(@Impuesto1Promedio, 2)) +
			 dbo.fnXMLmoney('Iva', @Impuesto1Total) +
			 dbo.fnXMLMoney('SubTotal', @SubTotal) +
			 dbo.fnXMLMoney('Total', @Total) +
			 dbo.fnXML(CASE @MovTipo
				 WHEN 'VTAS.D' THEN 'FolioFactura'
				 WHEN 'CXC.NC' THEN 'FolioFactura'
				 WHEN 'VTAS.B' THEN 'FolioFactura'
				 WHEN 'CXC.CA' THEN 'FolioFactura'
				 ELSE 'FolioOrdenCompra'
			 END, @Antecedente) +
			 dbo.fnXMLFloat('PorcentajeDescuento', @DescuentoGlobal) +
			 dbo.fnXMLMoney('TotalDescuento', @ImporteDescuentoGlobal)
		END

		IF @EHB = 1
		BEGIN
			SELECT dbo.fnXMLBigint('Folio', @Folio) +
			 dbo.fnXML('MonedaDoc', @MonedaClave) +
			 dbo.fnXML('MonedaDesc', CASE @MonedaClave
				 WHEN 'MXN' THEN 'Pesos'
				 WHEN 'USD' THEN 'Dolares'
			 END) +
			 dbo.fnXMLint('FolioAvisoPrefactura', CASE
				 WHEN dbo.fnEsNumerico(@OrdenCompra) = 1 THEN @OrdenCompra
				 ELSE NULL
			 END) +
			 dbo.fnXMLDateTime('Fecha', @Fecha) +
			 dbo.fnXML('CondicionPago', @Condicion) +
			 dbo.fnXMLMoney('SubTotal', @SubTotal) +
			 dbo.fnXMLmoney('Iva', @Impuesto1Total) +
			 dbo.fnXMLMoney('Total', @Total) +
			 dbo.fnXMLFloat('IVAPCT', ROUND(@Impuesto1Promedio, 2)) +
			 dbo.fnXML('NumProveedor', @ProveedorID) +
			 dbo.fnXML('NumSucursal', @EnviarAClave) +
			 dbo.fnXMLDateTime('FechaPago', @Vencimiento) +
			 dbo.fnXML('DomicilioSucursalCliente', LEFT(@EnviarADireccion + ' ' + @EnviarADireccionNumero + ' ' + ISNULL(@EnviarADireccionNumeroInt, ''), 50)) +
			 dbo.fnXML('ColoniaSucursalCliente', LEFT(@EnviarAColonia, 30)) +
			 dbo.fnXML('MunicipioSucursalCliente', LEFT(@EnviarADelegacion, 20)) +
			 dbo.fnXML('CPSucursalCliente', LEFT(@EnviarACodigoPostal, 10)) +
			 dbo.fnXML('Moneda', @MonedaClave) +
			 dbo.fnXML('DepartamentoCliente', @DepartamentoClave) +
			 dbo.fnXML('NoAprobacion', @Noaprobacion)
		END

		SELECT '>'
	END
	ELSE

	IF @Layout = 'HOME DEPOT'
	BEGIN
		SELECT '<cfdi:Addenda>' +
		 '<Encabezado' +
		 dbo.fnXML('oc', @OrdenCompra) +
		 dbo.fnXMLBigint('folio', @Folio) +
		 dbo.fnXML('serie', @Serie) +
		 dbo.fnXMLDatetimeFmt('fecha', @Fecha, 'DD/MM/AAAA') +
		 dbo.fnXML('proveedor', @ProveedorID) +
		 dbo.fnXMLMoney('subtotal', @SubTotal) +
		 dbo.fnXMLmoney('iva', @Impuesto1Total) +
		 dbo.fnXMLMoney('total', @Total) +
		 dbo.fnXML('divisa', 'PESO') +
		 dbo.fnXMLFloat('tipoCambio', @TipoCambio) +
		 dbo.fnXMLMoney('descuento1', @DescuentosTotales) +
		 dbo.fnXMLMoney('descuento2', NULL) +
		 '>'
	END
	ELSE

	IF @Layout LIKE 'SORIANA%'
	BEGIN
		SELECT '<cfdi:Addenda>'
		SELECT '<DSCargaRemisionProv>'
		SELECT '<Remision'

		IF @Layout = 'SORIANA CEDIS'
			SELECT dbo.fnXML('Id', 'Remision1') +
			 dbo.fnXMLInt('RowOrder', 1)

		SELECT '>' +
		 dbo.fnTag('Proveedor', LEFT(@ProveedorID, 35)) +
		 dbo.fnTag('Remision', LEFT(ISNULL(@Serie, '') + CONVERT(VARCHAR, @Folio), 35)) +
		 dbo.fnTagInt('Consecutivo', 0) +
		 dbo.fnTagDatetime('FechaRemision', @Fecha) +
		 dbo.fnTag('Tienda', @EnviarAClave) +
		 dbo.fnTagInt('TipoMoneda', 1) +
		 dbo.fnTagInt('TipoBulto', 1) +
		 dbo.fnTagInt('EntregaMercancia', @EntregaMercancia) +
		 dbo.fnTag('CumpleReqFiscales', 'true') +
		 dbo.fnTagFloat('CantidadBultos', @CantidadTotal) +
		 dbo.fnTagMoney('Subtotal', @SubTotal) +
		 dbo.fnTagMoney('Descuentos', ISNULL(@DescuentosTotales, 0.00)) +
		 dbo.fnTagMoney('IEPS', ISNULL(@Impuesto2total, 0.00)) +
		 dbo.fnTagMoney('IVA', @Impuesto1Total) +
		 dbo.fnTagMoney('OtrosImpuestos', 0.00) +
		 dbo.fnTagMoney('Total', @Total) +
		 dbo.fnTagFloat('CantidadPedidos', 1) +
		 dbo.fnTagDateTime('FechaEntregaMercancia', @ReciboFecha)

		IF @Layout = 'SORIANA TIENDA'
			SELECT dbo.fnTag('EmpaqueEnCajas', '') +
			 dbo.fnTag('EmpaqueEnTarimas', '') +
			 dbo.fnTagFloat('CantidadCajasTarimas', NULL)

		SELECT '</Remision>'
		SELECT '<Pedidos'

		IF @Layout = 'SORIANA CEDIS'
			SELECT dbo.fnXML('Id', 'Pedido1') +
			 dbo.fnXMLInt('RowOrder', 1)

		SELECT '>' +
		 dbo.fnTag('Proveedor', LEFT(@ProveedorID, 35)) +
		 dbo.fnTag('Remision', LEFT(LEFT(ISNULL(@Serie, '') + CONVERT(VARCHAR, @Folio), 35), 35)) +
		 dbo.fnTag('FolioPedido', @OrdenCompra) +
		 dbo.fnTag('Tienda', @EnviarAClave) +
		 dbo.fnTag('CantidadArticulos', @NumeroArticulos)
		SELECT '</Pedidos>'
	END
	ELSE

	IF @Layout = 'FEMSA'
	BEGIN
		SELECT '<cfdi:Addenda>'
		SELECT '<Documento>'
		SELECT '<FacturaFemsa>'
		SELECT dbo.fnTag('noVersAdd', @AddendaVersion) +
		 dbo.fnTag('claseDoc', CASE @MovTipo
			 WHEN 'VTAS.F' THEN 1
			 ELSE NULL
		 END) +
		 dbo.fnTag('noSociedad', @receptorID) +
		 dbo.fnTag('noProveedor', @ProveedorID) +
		 dbo.fnTag('noPedido', @OrdenCompra) +
		 dbo.fnTag('moneda', @MonedaClave) +
		 dbo.fnTag('noEntrada', @Recibo) +
		 dbo.fnTag('noRemision', @Embarque) +
		 '<noSocio>' + ISNULL(@DepartamentoClave, '') + '</noSocio>' +
		 '<centroCostos>' + '</centroCostos>' +
		 '<iniPerLiq>' + '</iniPerLiq>' +
		 '<finPerLiq>' + '</finPerLiq>' +
		 '<retencion1>' + '</retencion1>' +
		 '<retencion2>' + '</retencion2>' +
		 '<retencion3>' + '</retencion3>' +
		 '<email>' + ISNULL(@emailCobrador, '') + '</email>'
		SELECT '</FacturaFemsa>'
		SELECT '</Documento>'
		SELECT '</cfdi:Addenda>'
	END
	ELSE

	IF @LayOut = 'ASPEL'
	BEGIN
		SELECT '<cfdi:Addenda>'
		SELECT dbo.fnTag('Numero', @MovID) +
		 dbo.fnTag('clave', @Cliente) +
		 dbo.fnTag('NoVendedor', @Agente)
		SELECT '<Obspartidas>'
	END
	ELSE

	IF @Layout = 'EDIFACT'
	BEGIN
		INSERT #EDI
			SELECT 1
				  ,'<Datos Identificacion Mensaje>'
				  ,'UNB'
		INSERT #EDI
			SELECT 1
				  ,'Tipo Mensaje'
				  ,'UNOA:2'
		INSERT #EDI
			SELECT 1
				  ,'Emisor ID'
				  ,@EmisorID
		INSERT #EDI
			SELECT 1
				  ,'Receptor ID'
				  ,@ReceptorID
		INSERT #EDI
			SELECT 1
				  ,'Fecha Envio'
				  ,dbo.fnEDIDatetime(GETDATE())
		INSERT #EDI
			SELECT 1
				  ,'Referencia Envio'
				  ,dbo.fnEDI(@ReferenciaEnvio)
		INSERT #EDI
			SELECT 1
				  ,'<Fin>'
				  ,''
		INSERT #EDI
			SELECT 1
				  ,'<Cabecera Mensaje>'
				  ,'UNH'
		INSERT #EDI
			SELECT 1
				  ,'Referencia Mensaje'
				  ,dbo.fnEDI(RTRIM(@Modulo) + CONVERT(VARCHAR, @ID))
		INSERT #EDI
			SELECT 1
				  ,'Tipo Mensaje'
				  ,'INVOIC:D:01B:UN:AMC002'
		INSERT #EDI
			SELECT 1
				  ,'<Fin>'
				  ,''
		INSERT #EDI
			SELECT 1
				  ,'<Principio Mensaje>'
				  ,'BGM'
		INSERT #EDI
			SELECT 1
				  ,'Nombre Documento'
				  ,CASE @MovTipo
					   WHEN 'VTAS.D' THEN '381'
					   WHEN 'VTAS.B' THEN '383'
					   ELSE '380'
				   END
		INSERT #EDI
			SELECT 1
				  ,'Numero Documento'
				  ,CONVERT(VARCHAR(20), @Folio)
		INSERT #EDI
			SELECT 1
				  ,'Funcion Mensaje'
				  ,CASE
					   WHEN @Estatus = 'CANCELADO' THEN '1'
					   ELSE '9'
				   END
		INSERT #EDI
			SELECT 1
				  ,'<Fin>'
				  ,''
		INSERT #EDI
			SELECT 1
				  ,'<Fecha Hora>'
				  ,'DTM'
		INSERT #EDI
			SELECT 1
				  ,'Fecha Hora Documento'
				  ,'137:' + CONVERT(VARCHAR, @Fecha, 112) + ':102'
		INSERT #EDI
			SELECT 1
				  ,'<Fin>'
				  ,''
		INSERT #EDI
			SELECT 1
				  ,'<Texto Libre>'
				  ,'FTX'
		INSERT #EDI
			SELECT 1
				  ,'Clave Importe con Letra'
				  ,'ZZZ'
		INSERT #EDI
			SELECT 0
				  ,'???'
				  ,''
		INSERT #EDI
			SELECT 0
				  ,'???'
				  ,''
		INSERT #EDI
			SELECT 1
				  ,'Importe con Letra'
				  ,dbo.fnEDIMax(dbo.fnEDI(@ImporteEnLetra), 512)
		INSERT #EDI
			SELECT 1
				  ,'Idioma'
				  ,'ES'
		INSERT #EDI
			SELECT 1
				  ,'<Fin>'
				  ,''
		INSERT #EDI
			SELECT CASE
					   WHEN NULLIF(LTRIM(@Recibo), '') IS NOT NULL THEN 0
					   ELSE 1
				   END
				  ,'<Referencia>'
				  ,'RFF'
		INSERT #EDI
			SELECT CASE
					   WHEN NULLIF(LTRIM(@Recibo), '') IS NOT NULL THEN 0
					   ELSE 1
				   END
				  ,'Antecedente'
				  ,'ON:' + dbo.fnEDI(NULLIF(@Antecedente, ''))
		INSERT #EDI
			SELECT CASE
					   WHEN NULLIF(LTRIM(@Recibo), '') IS NOT NULL THEN 0
					   ELSE 1
				   END
				  ,'<Fin>'
				  ,''
		INSERT #EDI
			SELECT CASE
					   WHEN NULLIF(LTRIM(@Recibo), '') IS NOT NULL THEN 0
					   ELSE 1
				   END
				  ,'<Fecha Hora>'
				  ,'DTM'
		INSERT #EDI
			SELECT CASE
					   WHEN NULLIF(LTRIM(@Recibo), '') IS NOT NULL THEN 0
					   ELSE 1
				   END
				  ,'Antecedente Fecha'
				  ,'171:' + CONVERT(VARCHAR, @AntecedenteFecha, 112) + ':102'
		INSERT #EDI
			SELECT CASE
					   WHEN NULLIF(LTRIM(@Recibo), '') IS NOT NULL THEN 0
					   ELSE 1
				   END
				  ,'<Fin>'
				  ,''
		INSERT #EDI
			SELECT 1
				  ,'<Referencia>'
				  ,'RFF'
		INSERT #EDI
			SELECT 0
				  ,'Serie'
				  ,'BT:' + dbo.fnEDI(ISNULL(@Serie, ''))
		INSERT #EDI
			SELECT 1
				  ,'<Fin>'
				  ,''
		INSERT #EDI
			SELECT 1
				  ,'<Referencia>'
				  ,'RFF'
		INSERT #EDI
			SELECT 1
				  ,'Clave No Aprobacion'
				  ,'ATZ:' + CONVERT(VARCHAR(20), NULLIF(@noAprobacion, 0))
		INSERT #EDI
			SELECT 1
				  ,'<Fin>'
				  ,''

		IF NULLIF(@Recibo, '') IS NOT NULL
		BEGIN
			INSERT #EDI
				SELECT 1
					  ,'<Referencia>'
					  ,'RFF'
			INSERT #EDI
				SELECT 1
					  ,'Recibo'
					  ,'DQ:' + dbo.fnEDI(NULLIF(@Recibo, ''))
			INSERT #EDI
				SELECT 1
					  ,'<Fin>'
					  ,''
			INSERT #EDI
				SELECT 1
					  ,'<Fecha Hora>'
					  ,'DTM'
			INSERT #EDI
				SELECT 1
					  ,'Fecha Recibo'
					  ,'171:' + CONVERT(VARCHAR, @ReciboFecha, 112) + ':102'
			INSERT #EDI
				SELECT 1
					  ,'<Fin>'
					  ,''
		END

		INSERT #EDI
			SELECT 1
				  ,'<Nombre y Direccion>'
				  ,'NAD'
		INSERT #EDI
			SELECT 1
				  ,'Receptor'
				  ,'BY'
		INSERT #EDI
			SELECT 1
				  ,'Receptor - GLN'
				  ,NULLIF(RTRIM(dbo.fnEDI(@ClienteGLN)), '') + '::9'
		INSERT #EDI
			SELECT 0
				  ,'???'
				  ,''
		INSERT #EDI
			SELECT 1
				  ,'Receptor - Nombre'
				  ,dbo.fnEDIMax(dbo.fnEDI(@ClienteNombre), 35)
		INSERT #EDI
			SELECT 1
				  ,'Receptor - Direccion'
				  ,dbo.fnEDI(LEFT(NULLIF(RTRIM(@ClienteDireccion), '') + ' ' + NULLIF(RTRIM(@ClienteDireccionNumero), '') + ' ' + ISNULL(@ClienteDireccionNumeroInt, ''), 35)) + ':' + NULLIF(dbo.fnEDI(LEFT(@ClienteColonia, 35)), '')
		INSERT #EDI
			SELECT 0
				  ,'Receptor - Delegacion'
				  ,dbo.fnEDI(LEFT(@ClienteDelegacion, 35))
		INSERT #EDI
			SELECT 0
				  ,'Receptor - Estado'
				  ,dbo.fnEDI(LEFT(@ClienteEstado, 9))
		INSERT #EDI
			SELECT 0
				  ,'Receptor - Codigo Postal'
				  ,dbo.fnEDI(LEFT(@ClienteCodigoPostal, 17))
		INSERT #EDI
			SELECT 1
				  ,'<Fin>'
				  ,''
		INSERT #EDI
			SELECT 1
				  ,'<Referencia>'
				  ,'RFF'
		INSERT #EDI
			SELECT 1
				  ,'Receptor - RFC'
				  ,'GN:' + dbo.fnEDI(NULLIF(@ClienteRFC, ''))
		INSERT #EDI
			SELECT 1
				  ,'<Fin>'
				  ,''

		IF NULLIF(RTRIM(@ClienteIEPS), '') IS NOT NULL
		BEGIN
			INSERT #EDI
				SELECT 1
					  ,'<Referencia>'
					  ,'RFF'
			INSERT #EDI
				SELECT 1
					  ,'Receptor - IEPS'
					  ,'ZZZ:' + dbo.fnEDI(NULLIF(@ClienteIEPS, ''))
			INSERT #EDI
				SELECT 1
					  ,'<Fin>'
					  ,''
		END

		INSERT #EDI
			SELECT 1
				  ,'<Nombre y Direccion>'
				  ,'NAD'
		INSERT #EDI
			SELECT 1
				  ,'Emisor'
				  ,'SU'
		INSERT #EDI
			SELECT 0
				  ,'Emisor - GLN'
				  ,ISNULL(RTRIM(dbo.fnEDI(@EmpresaGLN)), '') +
				   CASE
					   WHEN NULLIF(RTRIM(dbo.fnEDI(@EmpresaGLN)), '') IS NULL THEN ''
					   ELSE '::9'
				   END
		INSERT #EDI
			SELECT 0
				  ,'???'
				  ,''
		INSERT #EDI
			SELECT 1
				  ,'Emisor - Nombre'
				  ,dbo.fnEDIMax(dbo.fnEDI(@EmpresaNombre), 35)
		INSERT #EDI
			SELECT 1
				  ,'Emisor - Direccion'
				  ,dbo.fnEDI(LEFT(NULLIF(RTRIM(@EmpresaDireccion), '') + ' ' + NULLIF(RTRIM(@EmpresaDireccionNumero), '') + ' ' + ISNULL(@EmpresaDireccionNumeroInt, ''), 35)) + ':' + NULLIF(dbo.fnEDI(LEFT(@EmpresaColonia, 35)), '')
		INSERT #EDI
			SELECT 0
				  ,'Emisor - Delegacion'
				  ,dbo.fnEDI(LEFT(@EmpresaDelegacion, 35))
		INSERT #EDI
			SELECT 0
				  ,'Emisor - Estado'
				  ,dbo.fnEDI(LEFT(@EmpresaEstado, 9))
		INSERT #EDI
			SELECT 0
				  ,'Emisor - Codigo Postal'
				  ,dbo.fnEDI(LEFT(@EmpresaCodigoPostal, 17))
		INSERT #EDI
			SELECT 1
				  ,'<Fin>'
				  ,''
		INSERT #EDI
			SELECT 1
				  ,'<Referencia>'
				  ,'RFF'
		INSERT #EDI
			SELECT 1
				  ,'Emisor - RFC'
				  ,'GN:' + dbo.fnEDI(NULLIF(@EmpresaRFC, ''))
		INSERT #EDI
			SELECT 1
				  ,'<Fin>'
				  ,''
		INSERT #EDI
			SELECT 1
				  ,'<Referencia>'
				  ,'RFF'
		INSERT #EDI
			SELECT 1
				  ,'Proveedor ID'
				  ,'IA:' + dbo.fnEDI(NULLIF(RTRIM(ISNULL(@ProveedorIDDeptoEnviarA, @ProveedorID)), ''))
		INSERT #EDI
			SELECT 1
				  ,'<Fin>'
				  ,''

		IF @Sucursal > 0
		BEGIN
			INSERT #EDI
				SELECT 1
					  ,'<Nombre y Direccion>'
					  ,'NAD'
			INSERT #EDI
				SELECT 1
					  ,'Sucursal'
					  ,'II'
			INSERT #EDI
				SELECT 0
					  ,'Sucursal - GLN'
					  ,ISNULL(RTRIM(dbo.fnEDI(@SucursalGLN)), '') +
					   CASE
						   WHEN NULLIF(RTRIM(dbo.fnEDI(@SucursalGLN)), '') IS NULL THEN ''
						   ELSE '::9'
					   END
			INSERT #EDI
				SELECT 0
					  ,'???'
					  ,''
			INSERT #EDI
				SELECT 1
					  ,'Sucursal - Nombre'
					  ,dbo.fnEDIMax(dbo.fnEDI(CASE
						   WHEN @Sucursal = 0 THEN @EmpresaNombre
						   ELSE @SucursalNombre
					   END), 35)
			INSERT #EDI
				SELECT 1
					  ,'Sucursal - Direccion'
					  ,dbo.fnEDI(LEFT(NULLIF(RTRIM(@SucursalDireccion), '') + ' ' + NULLIF(RTRIM(@SucursalDireccionNumero), '') + ' ' + ISNULL(@SucursalDireccionNumeroInt, ''), 35)) + ':' + NULLIF(dbo.fnEDI(LEFT(@SucursalColonia, 35)), '')
			INSERT #EDI
				SELECT 0
					  ,'Sucursal - Delegacion'
					  ,dbo.fnEDI(LEFT(@SucursalDelegacion, 35))
			INSERT #EDI
				SELECT 0
					  ,'Sucursal - Estado'
					  ,dbo.fnEDI(LEFT(@SucursalEstado, 9))
			INSERT #EDI
				SELECT 0
					  ,'Sucursal - Codigo Postal'
					  ,dbo.fnEDI(LEFT(@SucursalCodigoPostal, 17))
			INSERT #EDI
				SELECT 1
					  ,'<Fin>'
					  ,''
		END

		INSERT #EDI
			SELECT 1
				  ,'<Nombre y Direccion>'
				  ,'NAD'
		INSERT #EDI
			SELECT 1
				  ,'EnviarA'
				  ,'ST'
		INSERT #EDI
			SELECT 1
				  ,'EnviarA - GLN'
				  ,NULLIF(RTRIM(dbo.fnEDI(@EnviarAGLN)), '') + '::9'
		INSERT #EDI
			SELECT 0
				  ,'???'
				  ,''
		INSERT #EDI
			SELECT 1
				  ,'EnviarA - Nombre'
				  ,dbo.fnEDIMax(dbo.fnEDI(@EnviarANombre), 35)
		INSERT #EDI
			SELECT 1
				  ,'EnviarA - Direccion'
				  ,dbo.fnEDI(LEFT(NULLIF(RTRIM(@EnviarADireccion), '') + ' ' + NULLIF(RTRIM(@EnviarADireccionNumero), '') + ' ' + ISNULL(@EnviarADireccionNumeroInt, ''), 35)) + ':' + NULLIF(dbo.fnEDI(LEFT(@EnviarAColonia, 35)), '')
		INSERT #EDI
			SELECT 1
				  ,'EnviarA - Delegacion'
				  ,dbo.fnEDI(LEFT(@EnviarADelegacion, 35))
		INSERT #EDI
			SELECT 0
				  ,'EnviarA - Estado'
				  ,dbo.fnEDI(LEFT(@EnviarAEstado, 9))
		INSERT #EDI
			SELECT 0
				  ,'EnviarA - Codigo Postal'
				  ,dbo.fnEDI(LEFT(@EnviarACodigoPostal, 17))
		INSERT #EDI
			SELECT 1
				  ,'<Fin>'
				  ,''
		INSERT #EDI
			SELECT 1
				  ,'<Divisas>'
				  ,'CUX'
		INSERT #EDI
			SELECT 1
				  ,'Moneda'
				  ,'2:' + NULLIF(dbo.fnEDI(@MonedaClave), '') + ':4'
		INSERT #EDI
			SELECT 1
				  ,'<Fin>'
				  ,''
		INSERT #EDI
			SELECT 1
				  ,'<Condiciones Pago>'
				  ,'PAT'
		INSERT #EDI
			SELECT 1
				  ,'Condicion Basico'
				  ,'1'
		INSERT #EDI
			SELECT 0
				  ,'????'
				  ,''
		INSERT #EDI
			SELECT 1
				  ,'Tiempo Pago'
				  ,'5:3:D:' + CONVERT(VARCHAR, @DiasVencimiento)
		INSERT #EDI
			SELECT 1
				  ,'<Fin>'
				  ,''

		IF @ProntoPago = 1
		BEGIN
			INSERT #EDI
				SELECT 1
					  ,'<Porcentaje>'
					  ,'PCD'
			INSERT #EDI
				SELECT 1
					  ,'Porcentaje'
					  ,'12:' + CONVERT(VARCHAR(20), ROUND(@DescuentoProntoPago, 2)) + ':13'
			INSERT #EDI
				SELECT 1
					  ,'<Fin>'
					  ,''
		END

		IF NULLIF(@DescuentoGlobal, 0.0) IS NOT NULL
		BEGIN
			INSERT #EDI
				SELECT 1
					  ,'<Descuento Global>'
					  ,'ALC'
			INSERT #EDI
				SELECT 1
					  ,'Tipo Descuento'
					  ,'A'
			INSERT #EDI
				SELECT 0
					  ,'Imputacion Descuento'
					  ,''
			INSERT #EDI
				SELECT 0
					  ,'????'
					  ,''
			INSERT #EDI
				SELECT 0
					  ,'????'
					  ,''
			INSERT #EDI
				SELECT 1
					  ,'Clave Descuento'
					  ,dbo.fnEDI(NULLIF(@DescuentoClave, ''))
			INSERT #EDI
				SELECT 1
					  ,'<Fin>'
					  ,''
			INSERT #EDI
				SELECT 1
					  ,'<Porcentaje>'
					  ,'PCD'
			INSERT #EDI
				SELECT 1
					  ,'Porcentaje'
					  ,'1:' + CONVERT(VARCHAR(20), ROUND(@DescuentoGlobal, 2)) + ':13'
			INSERT #EDI
				SELECT 1
					  ,'<Fin>'
					  ,''
		END

	END
	ELSE

	IF @Layout = 'CHEDRAUI'
	BEGIN
		INSERT #CFD
			SELECT 0
				  ,'Enter'
				  ,'{@Enter}'
		INSERT #CFD
			SELECT 1
				  ,'Encabezado 0'
				  ,'[H0]'
		INSERT #CFD
			SELECT 1
				  ,'Receptor - RFC'
				  ,@ClienteRFC
		INSERT #CFD
			SELECT 1
				  ,'Clave Emisor'
				  ,@EmisorID
		INSERT #CFD
			SELECT 1
				  ,'Version Addenda'
				  ,@AddendaVersion
		INSERT #CFD
			SELECT 1
				  ,'Ano Aprobacion'
				  ,CONVERT(VARCHAR(20), YEAR(@fechaAprobacion))
		INSERT #CFD
			SELECT 1
				  ,'Numero Certificado'
				  ,@noCertificado
		INSERT #CFD
			SELECT 0
				  ,'Tipo Impresion'
				  ,'0'
		INSERT #CFD
			SELECT 1
				  ,'Tipo Envio'
				  ,CASE
					   WHEN @ModoPruebas = 1 THEN 'T'
					   ELSE 'P'
				   END
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 1'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 2'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Enter'
				  ,'{@Enter}'
		INSERT #CFD
			SELECT 1
				  ,'Encabezado 1'
				  ,'[H1]'
		INSERT #CFD
			SELECT 1
				  ,'Serie'
				  ,@Serie
		INSERT #CFD
			SELECT 1
				  ,'Folio'
				  ,CONVERT(VARCHAR(20), @Folio)
		INSERT #CFD
			SELECT 1
				  ,'Numero Aprobacion'
				  ,CONVERT(VARCHAR(20), @noAprobacion)
		INSERT #CFD
			SELECT 1
				  ,'Fecha Poliza'
				  ,SUBSTRING(CONVERT(VARCHAR, @Fecha, 126), 1, 19)
		INSERT #CFD
			SELECT 1
				  ,'Antecedente'
				  ,@Antecedente
		INSERT #CFD
			SELECT 1
				  ,'Fecha Antecedente'
				  ,SUBSTRING(CONVERT(VARCHAR, @AntecedenteFecha, 126), 1, 19)
		INSERT #CFD
			SELECT 1
				  ,'Forma Pago'
				  ,@formaDePago
		INSERT #CFD
			SELECT 1
				  ,'Dias Vencimiento'
				  ,CONVERT(VARCHAR(20), @DiasVencimiento)
		INSERT #CFD
			SELECT 1
				  ,'Funcion'
				  ,CASE
					   WHEN @Estatus = 'CANCELADO' THEN 'C'
					   ELSE 'O'
				   END
		INSERT #CFD
			SELECT 1
				  ,'Tipo Documento'
				  ,CASE @MovTipo
					   WHEN 'VTAS.D' THEN 'NOTA DE CREDITO'
					   WHEN 'VTAS.D' THEN 'NOTA DE DEBITO'
					   ELSE 'FACTURA COMERCIAL'
				   END
		INSERT #CFD
			SELECT 0
				  ,'% Descuento Global 1'
				  ,CONVERT(VARCHAR(20), ROUND(@DescuentoGlobal, 2))
		INSERT #CFD
			SELECT 0
				  ,'Descuento Global 1'
				  ,@Descuento
		INSERT #CFD
			SELECT 0
				  ,'$ Descuento Global 1'
				  ,CONVERT(VARCHAR(20), ROUND(@ImporteDescuentoGlobal, 2))
		INSERT #CFD
			SELECT 0
				  ,'% Descuento Global 2'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Descuento Global 2'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'$ Descuento Global 2'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'% Descuento Global 3'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Descuento Global 3'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'$ Descuento Global 3'
				  ,NULL
		INSERT #CFD
			SELECT 1
				  ,'Ano Aprobacion'
				  ,CONVERT(VARCHAR(20), YEAR(@fechaAprobacion))
		INSERT #CFD
			SELECT 1
				  ,'Numero Interno'
				  ,@Mov + ' ' + @MovID
		INSERT #CFD
			SELECT 1
				  ,'Departamento - Nombre'
				  ,@DepartamentoNombre
		INSERT #CFD
			SELECT 0
				  ,'Emisor - Representante Legal'
				  ,@EmpresaRepresentante
		INSERT #CFD
			SELECT 1
				  ,'Clave Proveedor'
				  ,ISNULL(@ProveedorIDDeptoEnviarA, @ProveedorID)
		INSERT #CFD
			SELECT 1
				  ,'Tasa Global IVA'
				  ,CONVERT(VARCHAR(20), ROUND(@DefImpuestoZona, 2))
		INSERT #CFD
			SELECT 1
				  ,'Numero Tienda (Enviar a)'
				  ,@EnviarAClave
		INSERT #CFD
			SELECT 0
				  ,'Recibo'
				  ,@Recibo
		INSERT #CFD
			SELECT 0
				  ,'Fecha Recibo'
				  ,SUBSTRING(CONVERT(VARCHAR, @ReciboFecha, 126), 1, 19)
		INSERT #CFD
			SELECT 0
				  ,'Cuenta Predial'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Numero Cheque'
				  ,NULL
		INSERT #CFD
			SELECT 1
				  ,'Clave Moneda'
				  ,@MonedaClave
		INSERT #CFD
			SELECT 1
				  ,'Tipo Cambio'
				  ,CONVERT(VARCHAR(20), ROUND(@TipoCambio, 4))
		INSERT #CFD
			SELECT 0
				  ,'Fecha Requerida'
				  ,SUBSTRING(CONVERT(VARCHAR, @FechaRequerida, 126), 1, 19)
		INSERT #CFD
			SELECT 0
				  ,'Departamento - Contacto'
				  ,@DepartamentoContacto
		INSERT #CFD
			SELECT 0
				  ,'Departamento - Clave'
				  ,@DepartamentoClave
		INSERT #CFD
			SELECT 0
				  ,'Observaciones 1'
				  ,@Observaciones
		INSERT #CFD
			SELECT 0
				  ,'Observaciones 2'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Observaciones 3'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Observaciones 4'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Observaciones 5'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Embarque'
				  ,@Embarque
		INSERT #CFD
			SELECT 0
				  ,'Fecha Embarque'
				  ,SUBSTRING(CONVERT(VARCHAR, @EmbarqueFecha, 126), 1, 19)
		INSERT #CFD
			SELECT 0
				  ,'Importe con Letra'
				  ,@ImporteEnLetra
		INSERT #CFD
			SELECT 0
				  ,'Tipo Impresion'
				  ,'0'
		INSERT #CFD
			SELECT 1
				  ,'Tipo Envio'
				  ,CASE
					   WHEN @ModoPruebas = 1 THEN 'T'
					   ELSE 'P'
				   END
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 1'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 2'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 3'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 4'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 5'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 6'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Enter'
				  ,'{@Enter}'
		INSERT #CFD
			SELECT 1
				  ,'Encabezado 2'
				  ,'[H2]'
		INSERT #CFD
			SELECT 1
				  ,'Emisor - Nombre'
				  ,@EmpresaNombre
		INSERT #CFD
			SELECT 1
				  ,'Emisor - RFC'
				  ,@EmpresaRFC
		INSERT #CFD
			SELECT 0
				  ,'Emisor - GLN'
				  ,@EmpresaGLN
		INSERT #CFD
			SELECT 1
				  ,'Emisor - Direccion'
				  ,@EmpresaDireccion
		INSERT #CFD
			SELECT 1
				  ,'Emisor - Numero Exterior'
				  ,@EmpresaDireccionNumero
		INSERT #CFD
			SELECT 0
				  ,'Emisor - Numero Interior'
				  ,ISNULL(NULLIF(RTRIM(@EmpresaDireccionNumeroInt), ''), 'S/N')
		INSERT #CFD
			SELECT 1
				  ,'Emisor - Colonia'
				  ,@EmpresaColonia
		INSERT #CFD
			SELECT 1
				  ,'Emisor - Poblacion'
				  ,@EmpresaPoblacion
		INSERT #CFD
			SELECT 0
				  ,'Emisor - Observaciones'
				  ,@EmpresaObservaciones
		INSERT #CFD
			SELECT 1
				  ,'Emisor - Delegacion'
				  ,@EmpresaDelegacion
		INSERT #CFD
			SELECT 1
				  ,'Emisor - Estado'
				  ,@EmpresaEstado
		INSERT #CFD
			SELECT 1
				  ,'Emisor - Pais'
				  ,@EmpresaPais
		INSERT #CFD
			SELECT 1
				  ,'Emisor - Codigo Postal'
				  ,@EmpresaCodigoPostal
		INSERT #CFD
			SELECT 0
				  ,'Emisor - Registro Patronal'
				  ,@EmpresaRegistroPatronal
		INSERT #CFD
			SELECT 0
				  ,'Emisor - Telefonos'
				  ,@EmpresaTelefonos
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 1'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 2'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 3'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 4'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 5'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 6'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 7'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 8'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 9'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Enter'
				  ,'{@Enter}'
		INSERT #CFD
			SELECT 1
				  ,'Encabezado 3'
				  ,'[H3]'
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 1'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 2'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 3'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Expedido En - Direccion'
				  ,CASE
					   WHEN @Sucursal = 0 THEN NULL
					   ELSE @SucursalDireccion
				   END
		INSERT #CFD
			SELECT 0
				  ,'Expedido En - Numero Exterior'
				  ,CASE
					   WHEN @Sucursal = 0 THEN NULL
					   ELSE @SucursalDireccionNumero
				   END
		INSERT #CFD
			SELECT 0
				  ,'Expedido En - Numero Interior'
				  ,CASE
					   WHEN @Sucursal = 0 THEN NULL
					   ELSE ISNULL(NULLIF(RTRIM(@SucursalDireccionNumeroInt), ''), 'S/N')
				   END
		INSERT #CFD
			SELECT 0
				  ,'Expedido En - Colonia'
				  ,CASE
					   WHEN @Sucursal = 0 THEN NULL
					   ELSE @SucursalColonia
				   END
		INSERT #CFD
			SELECT 0
				  ,'Expedido En - Poblacion'
				  ,CASE
					   WHEN @Sucursal = 0 THEN NULL
					   ELSE @SucursalPoblacion
				   END
		INSERT #CFD
			SELECT 0
				  ,'Expedido En - Observaciones'
				  ,CASE
					   WHEN @Sucursal = 0 THEN NULL
					   ELSE @SucursalObservaciones
				   END
		INSERT #CFD
			SELECT 0
				  ,'Expedido En - Delegacion'
				  ,CASE
					   WHEN @Sucursal = 0 THEN NULL
					   ELSE @SucursalDelegacion
				   END
		INSERT #CFD
			SELECT 0
				  ,'Expedido En - Estado'
				  ,CASE
					   WHEN @Sucursal = 0 THEN NULL
					   ELSE @SucursalEstado
				   END
		INSERT #CFD
			SELECT 0
				  ,'Expedido En - Pais'
				  ,CASE
					   WHEN @Sucursal = 0 THEN NULL
					   ELSE @SucursalPais
				   END
		INSERT #CFD
			SELECT 0
				  ,'Expedido En - Codigo Postal'
				  ,CASE
					   WHEN @Sucursal = 0 THEN NULL
					   ELSE @SucursalCodigoPostal
				   END
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 4'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 5'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 6'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 7'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 8'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 9'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 10'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 11'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 12'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 13'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 14'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Enter'
				  ,'{@Enter}'
		INSERT #CFD
			SELECT 1
				  ,'Encabezado 4'
				  ,'[H4]'
		INSERT #CFD
			SELECT 1
				  ,'Receptor - Nombre'
				  ,@ClienteNombre
		INSERT #CFD
			SELECT 1
				  ,'Receptor - RFC'
				  ,@ClienteRFC
		INSERT #CFD
			SELECT 1
				  ,'Receptor - GLN'
				  ,@ClienteGLN
		INSERT #CFD
			SELECT 1
				  ,'Receptor - Direccion'
				  ,@ClienteDireccion
		INSERT #CFD
			SELECT 1
				  ,'Receptor - Numero Exterior'
				  ,@ClienteDireccionNumero
		INSERT #CFD
			SELECT 0
				  ,'Receptor - Numero Interior'
				  ,ISNULL(NULLIF(RTRIM(@ClienteDireccionNumeroInt), ''), 'S/N')
		INSERT #CFD
			SELECT 1
				  ,'Receptor - Colonia'
				  ,@ClienteColonia
		INSERT #CFD
			SELECT 1
				  ,'Receptor - Poblacion'
				  ,@ClientePoblacion
		INSERT #CFD
			SELECT 0
				  ,'Receptor - Observaciones'
				  ,@ClienteObservaciones
		INSERT #CFD
			SELECT 1
				  ,'Receptor - Delegacion'
				  ,@ClienteDelegacion
		INSERT #CFD
			SELECT 1
				  ,'Receptor - Estado'
				  ,@ClienteEstado
		INSERT #CFD
			SELECT 1
				  ,'Receptor - Pais'
				  ,@ClientePais
		INSERT #CFD
			SELECT 1
				  ,'Receptor - Codigo Postal'
				  ,@ClienteCodigoPostal
		INSERT #CFD
			SELECT 0
				  ,'Receptor - Registro Patronal'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Receptor - Telefonos'
				  ,@ClienteTelefonos
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 1'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 2'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 3'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 4'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 5'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 6'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 7'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 8'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 9'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Enter'
				  ,'{@Enter}'
		INSERT #CFD
			SELECT 1
				  ,'Encabezado 5'
				  ,'[H5]'
		INSERT #CFD
			SELECT 1
				  ,'Enviar a - Nombre'
				  ,@EnviarANombre
		INSERT #CFD
			SELECT 1
				  ,'Enviar a - RFC'
				  ,@ClienteRFC
		INSERT #CFD
			SELECT 1
				  ,'Enviar a - GLN'
				  ,@EnviarAGLN
		INSERT #CFD
			SELECT 1
				  ,'Enviar a - Direccion'
				  ,@EnviarADireccion
		INSERT #CFD
			SELECT 1
				  ,'Enviar a - Numero Exterior'
				  ,@EnviarADireccionNumero
		INSERT #CFD
			SELECT 0
				  ,'Enviar a - Numero Interior'
				  ,ISNULL(NULLIF(RTRIM(@EnviarADireccionNumeroInt), ''), 'S/N')
		INSERT #CFD
			SELECT 1
				  ,'Enviar a - Colonia'
				  ,@EnviarAColonia
		INSERT #CFD
			SELECT 1
				  ,'Enviar a - Poblacion'
				  ,@EnviarAPoblacion
		INSERT #CFD
			SELECT 0
				  ,'Enviar a - Observaciones'
				  ,@EnviarAObservaciones
		INSERT #CFD
			SELECT 1
				  ,'Enviar a - Delegacion'
				  ,@EnviarADelegacion
		INSERT #CFD
			SELECT 1
				  ,'Enviar a - Estado'
				  ,@EnviarAEstado
		INSERT #CFD
			SELECT 1
				  ,'Enviar a - Pais'
				  ,@EnviarAPais
		INSERT #CFD
			SELECT 1
				  ,'Enviar a - Codigo Postal'
				  ,@EnviarACodigoPostal
		INSERT #CFD
			SELECT 0
				  ,'Enviar a - Registro Patronal'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Enviar a - Telefonos'
				  ,@EnviarATelefonos
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 1'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 2'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 3'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 4'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 5'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 6'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 7'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 8'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 9'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Enter'
				  ,'{@Enter}'
	END

	IF @Layout = 'SAT'
	BEGIN
		SELECT '<Conceptos>'

		IF @Modulo = 'CXC'
			AND @Origen IS NULL
		BEGIN

			IF @Version = '1.0'
				SELECT '<Concepto' +
				 dbo.fnXMLFloat('cantidad', 1.00) +
				 --dbo.fnXML('unidad', 'PCE') +
				 dbo.fnXML('descripcion', @Concepto) +
				 dbo.fnXMLDecimal('valorUnitario', @Importe, @CfgDecimales) +
				 dbo.fnXMLDecimal('importe', @Importe, @CfgDecimales) +
				 '>'
			ELSE
				SELECT '<Concepto' +
				 dbo.fnXMLFloat('cantidad', 1.00) +
				 --dbo.fnXML('unidad', 'PCE') +
				 dbo.fnXML('noIdentificacion', @Concepto) +
				 dbo.fnXML('descripcion', @Concepto) +
				 dbo.fnXMLDecimal('valorUnitario', @Importe, @CfgDecimales) +
				 dbo.fnXMLDecimal('importe', @Importe, @CfgDecimales) +
				 '>'

			SELECT '</Concepto>'
		END

	END

	IF @Layout LIKE '%INTERFACTURA%'
		AND @Modulo = 'CXC'
	BEGIN
		SELECT '<if:Cuerpo' +
		 dbo.fnXML('Renglon', 1) +
		 dbo.fnXMLFloat('Cantidad', 1) +
		 dbo.fnXML('Concepto', @Concepto) +
		 dbo.fnXMLMoney('PUnitario', @Total) +
		 dbo.fnXMLMoney('Importe', @Total) +
		 '>'
		SELECT '</if:Cuerpo>'
	END

	IF (@Modulo = 'VTAS')
		OR (@Modulo = 'CXC' AND @Origen LIKE 'Devolucion%')
	BEGIN

		IF @Modulo = 'CXC'
			AND @MovTipo = 'CXC.NC'
			AND @Origen LIKE 'Devolucion%'
		BEGIN
			SELECT @Mov = @Origen
				  ,@MovID = @OrigenID
		END

		IF @AgruparDetalle = 1
			DECLARE
				crDetalle
				CURSOR LOCAL FOR
				SELECT MAX(d.Renglon)
					  ,MAX(d.RenglonSub)
					  ,MAX(d.RenglonID)
					  ,MAX(d.RenglonTipo)
					  ,MAX(d.Codigo)
					  ,SUM(d.CantidadNeta)
					  ,MAX(ISNULL(NULLIF(RTRIM(d.Unidad), ''), a.Unidad))
					  ,MAX(ISNULL(NULLIF(d.Factor, 0.0), 1.0))
					  ,d.Articulo
					  ,d.SubCuenta
					  ,ROUND(d.SubTotal * (CASE
							WHEN @MN = 1 THEN d.TipoCambio
							ELSE 1.0
						END), 2)
					  ,dbo.fnQueCodigo(@EmpresaEAN13, d.Articulo, d.SubCuenta, MAX(d.Codigo), @Cliente)
					  ,dbo.fnQueCodigo(@EmpresaDUN14, d.Articulo, d.SubCuenta, MAX(d.Codigo), @Cliente)
					  ,dbo.fnQueCodigo(@EmpresaSKUCliente, d.Articulo, d.SubCuenta, MAX(d.Codigo), @Cliente)
					  ,dbo.fnQueCodigo(@EmpresaSKUEmpresa, d.Articulo, d.SubCuenta, MAX(d.Codigo), @Cliente)
					  ,MAX(d.DescuentoLinea)
					  ,SUM(ISNULL(d.DescuentoLineal, 0.0))
					  ,SUM(ISNULL(d.ImporteDescuentoGlobal, 0.0))
					  ,MAX(d.Impuesto1)
					  ,MAX(d.Impuesto2)
					  ,SUM(ISNULL(d.Impuesto1Total, 0.0))
					  ,SUM(ISNULL(d.Impuesto2Total, 0.0))
					  ,MAX(a.Descripcion1)
					  ,MAX(a.Descripcion2)
					  ,MAX(a.TipoEmpaque)
					  ,d.Precio
				FROM VentaTCalc d WITH(NOLOCK)
				JOIN Art a WITH(NOLOCK)
					ON a.Articulo = d.Articulo
				WHERE d.ID = @ID
				AND d.RenglonTipo <> 'C'
				GROUP BY d.Articulo
						,d.Subcuenta
						,d.Precio
						,d.SubTotal
						,d.TipoCambio
		ELSE

		IF @AgruparDetalle = 0
			DECLARE
				crDetalle
				CURSOR LOCAL FOR
				SELECT d.Renglon
					  ,d.RenglonSub
					  ,d.RenglonID
					  ,d.RenglonTipo
					  ,d.Codigo
					  ,ISNULL(d.CantidadNeta, 0.0)
					  ,ISNULL(NULLIF(RTRIM(d.Unidad), ''), a.Unidad)
					  ,ISNULL(NULLIF(d.Factor, 0.0), 1.0)
					  ,d.Articulo
					  ,d.SubCuenta
					  ,d.SubTotal * (CASE
						   WHEN @MN = 1 THEN d.TipoCambio
						   ELSE 1.0
					   END)
					  ,dbo.fnQueCodigo(@EmpresaEAN13, d.Articulo, d.SubCuenta, d.Codigo, @Cliente)
					  ,dbo.fnQueCodigo(@EmpresaDUN14, d.Articulo, d.SubCuenta, d.Codigo, @Cliente)
					  ,dbo.fnQueCodigo(@EmpresaSKUCliente, d.Articulo, d.SubCuenta, d.Codigo, @Cliente)
					  ,dbo.fnQueCodigo(@EmpresaSKUEmpresa, d.Articulo, d.SubCuenta, d.Codigo, @Cliente)
					  ,d.DescuentoLinea
					  ,ISNULL(d.DescuentoLineal, 0.0)
					  ,ISNULL(d.ImporteDescuentoGlobal, 0.0)
					  ,ISNULL(d.Impuesto1, 0)
					  ,ISNULL(d.Impuesto2, 0)
					  ,ISNULL(d.Impuesto1Total, 0.0)
					  ,ISNULL(d.Impuesto2Total, 0.0)
					  ,a.Descripcion1
					  ,a.Descripcion2
					  ,a.TipoEmpaque
					  ,d.Precio
				FROM VentaTCalc d WITH(NOLOCK)
				JOIN Art a WITH(NOLOCK)
					ON a.Articulo = d.Articulo
				WHERE d.ID = @ID
				AND d.RenglonTipo NOT IN ('C', 'E')

		OPEN crDetalle
		FETCH NEXT FROM crDetalle INTO @Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @Codigo, @Cantidad, @Unidad, @UnidadFactor, @Articulo, @SubCuenta, @SubTotalLinea,
		@EAN13, @DUN14, @SKUCliente, @SKUEmpresa,
		@PctDescuentoLinea, @DescuentoLinea, @DescuentoGlobalLinea, @Impuesto1, @Impuesto2, @Impuesto1Linea, @Impuesto2Linea,
		@ArtDescripcion1, @ArtDescripcion2, @ArtTipoEmpaque, @Precio, @TipoServicio
		WHILE @@FETCH_STATUS <> -1
		AND @@Error = 0
		BEGIN

		IF @@FETCH_STATUS <> -2
		BEGIN

			IF @RenglonTipo = 'J'
			BEGIN
				SELECT @CompSubTotal = ISNULL(SUM(SubTotal), 0.0)
					  ,@CompDescuentoLineal = ISNULL(SUM(DescuentoLineal), 0.0)
					  ,@CompImporteDescuentoGlobal = ISNULL(SUM(ImporteDescuentoGlobal), 0.0)
					  ,@CompImpuesto1Total = ISNULL(SUM(Impuesto1Total), 0.0)
					  ,@compImpuesto2Total = ISNULL(SUM(Impuesto2Total), 0.0)
					  ,@CompPrecio = ISNULL(SUM(ISNULL(Precio, 0.0) * Cantidad), 0.0)
				FROM VentaTCalc WITH(NOLOCK)
				WHERE ID = @ID
				AND RenglonID = @RenglonID
				AND RenglonTipo = 'C'
				SELECT @SubTotalLinea = @SubTotalLinea + @CompSubTotal
				SELECT @DescuentoLinea = @DescuentoLinea + @CompDescuentoLineal
				SELECT @DescuentoGlobalLinea = @DescuentoGlobalLinea + @CompImporteDescuentoGlobal
				SELECT @Impuesto1Linea = @Impuesto1Total + @CompImpuesto1Total
				SELECT @Impuesto2Linea = @Impuesto2Total + @CompImpuesto2Total
				SELECT @Precio = @Precio + @CompPrecio / @Cantidad
			END

			SELECT @UnidadClave = Clave
			FROM Unidad WITH(NOLOCK)
			WHERE Unidad = @Unidad

			IF @AgruparDetalle = 1
			BEGIN
				SELECT @Paquetes = @Cantidad / ISNULL(NULLIF(@UnidadFactor, 0.0), 1.0)
			END
			ELSE
				SELECT @Paquetes = Paquete
					  ,@DescripcionExtra = DescripcionExtra
				FROM VentaD WITH(NOLOCK)
				WHERE ID = @ID
				AND Renglon = @Renglon
				AND RenglonSub = @RenglonSub

			IF NULLIF(@Paquetes, 0.0) IS NULL
				SELECT @Paquetes = @Cantidad
					  ,@CantidadEmpaque = @UnidadFactor
			ELSE
				SELECT @CantidadEmpaque = @Cantidad / ISNULL(NULLIF(@Paquetes, 0.0), 1.0)

			IF @PaqueteEsCantidad = 1
				AND @Tipoaddenda IN ('CHEDRAUI', 'AMECE / CM')
				SELECT @Cantidad = @Paquetes

			SELECT @noIdentificacion = RTRIM(@Articulo) + ' ' + ISNULL(RTRIM(@SubCuenta), '')
			SELECT @TipoEmpaqueClave = Clave
				  ,@TipoEmpaqueTipo = Tipo
			FROM TipoEmpaque WITH(NOLOCK)
			WHERE TipoEmpaque = @ArtTipoEmpaque

			IF @Layout = 'EDIFACT'
				AND @UnidadClave = 'PCE'
				SELECT @UnidadClave = 'EA'

			IF @Layout = 'AMECE / GIGANTE'
				AND @UnidadClave = 'PCE'
				SELECT @UnidadClave = 'PZA'

			EXEC xpGenerarCFDDetalle @Estacion
									,@Modulo
									,@ID
									,@Layout
									,@Version
									,@Renglon
									,@RenglonSub
									,@Cantidad OUTPUT
									,@Codigo OUTPUT
									,@Unidad OUTPUT
									,@UnidadClave OUTPUT
									,@UnidadFactor OUTPUT
									,@Articulo OUTPUT
									,@SubCuenta OUTPUT
									,@ArtDescripcion1 OUTPUT
									,@ArtDescripcion2 OUTPUT
									,@ArtTipoEmpaque OUTPUT
									,@TipoEmpaqueClave OUTPUT
									,@TipoEmpaqueTipo OUTPUT
									,@Paquetes OUTPUT
									,@CantidadEmpaque OUTPUT
									,@EAN13 OUTPUT
									,@DUN14 OUTPUT
									,@SKUCliente OUTPUT
									,@SKUEmpresa OUTPUT
									,@noIdentificacion OUTPUT
									,@AgruparDetalle
									,@Cliente
									,@OrdenCompra OUTPUT

			SELECT @SubTotalLinea = ROUND(((@SubTotalLinea / @Cantidad) * @Cantidad), 2)
			SELECT @TotalLinea = @SubTotalLinea + ISNULL(@Impuesto1Linea, 0.0) + ISNULL(@Impuesto2Linea, 0.0)
			SELECT @ImporteLinea = @SubTotalLinea + @DescuentoGlobalLinea
			SELECT @Conteo = @Conteo + 1
				  ,@SumaCantidad = @SumaCantidad + ISNULL(@Cantidad, 0.0)
				  ,@SumaSubTotalLinea = @SumaSubTotalLinea + ISNULL(@SubTotalLinea, 0.0)
				  ,@SumaImporteLinea = @SumaImporteLinea + ISNULL(@ImporteLinea, 0.0)

			IF @Cantidad = 0
				SELECT @PrecioLinea = 0
			ELSE
				SELECT @PrecioLinea = ROUND(CONVERT(FLOAT, @SubTotalLinea / NULLIF(@Cantidad, 0.0)), 2)

			SELECT @PrimerSerieLote = NULL
				  ,@Pedimento = NULL
				  ,@PedimentoFecha = NULL
				  ,@Aduana = NULL
				  ,@AduanaGLN = NULL
				  ,@AduanaCiudad = NULL

			IF @RenglonTipo IN ('J', 'S')
				SELECT @PrimerSerieLote = NULL
			ELSE
				SELECT @PrimerSerieLote = NULL

			IF @PrimerSerieLote IS NOT NULL
				SELECT @Pedimento = dbo.fnLimpiarRFC(p.Extra1)
					  ,@PedimentoFecha = p.Fecha2
					  ,@PedimentoFecha2 = p.Fecha2
					  ,@PedimentoFecha3 = p.Fecha3
					  ,@Aduana = p.Aduana
					  ,@AgenteAduanal = p.AgenteAduanal
				FROM SerieLote s WITH(NOLOCK)
				JOIN SerieLoteProp p WITH(NOLOCK)
					ON p.Propiedades = s.Propiedades
				WHERE s.SerieLote = @PrimerSerieLote

			IF @Validar = 1
			BEGIN

				IF @Layout IN ('INTERFACTURA / EHB', 'INTERFACTURA / HEB')
					OR @TipoAddenda IN ('INTERFACTURA / EHB', 'INTERFACTURA / HEB')
				BEGIN

					IF NULLIF(RTRIM(@UnidadClave), '') IS NULL
						SELECT @Ok = 10010
							  ,@OkRef = 'CFD - Clave Unidad'

					IF NULLIF(RTRIM(CONVERT(VARCHAR(10), @Precio)), '') IS NULL
						SELECT @Ok = 10010
							  ,@OkRef = 'CFD - Precio Unitario'

					IF NULLIF(RTRIM(CONVERT(VARCHAR(10), @SubTotalLinea)), '') IS NULL
						SELECT @Ok = 10010
							  ,@OkRef = 'CFD - SubTotal Linea'

					IF NULLIF(RTRIM(@CantidadEmpaque), '') IS NULL
						SELECT @Ok = 10010
							  ,@OkRef = 'CFD - Factor Empaque'

					IF NULLIF(RTRIM(@EAN13), '') IS NULL
						SELECT @Ok = 10010
							  ,@OkRef = 'CFD -Codigo Articulo EAN13'

					IF NULLIF(RTRIM(@ArtDescripcion1), '') IS NULL
						SELECT @Ok = 10010
							  ,@OkRef = 'CFD - Concepto'

					IF NULLIF(RTRIM(@SKUCliente), '') IS NULL
						SELECT @Ok = 10010
							  ,@OkRef = 'CFD - Codigo Articulo SKU'

					IF NULLIF(RTRIM(@Cantidad), '') IS NULL
						SELECT @Ok = 10010
							  ,@OkRef = 'CFD - Cantidad'

					IF NULLIF(RTRIM(@Moneda), '') IS NULL
						SELECT @Ok = 10010
							  ,@OkRef = 'CFD - Moneda'

				END

				IF NULLIF(RTRIM(@Cantidad), '') IS NULL
					SELECT @Ok = 10010
						  ,@OkRef = 'CFD - Cantidad'

				IF NULLIF(RTRIM(@ArtDescripcion1), '') IS NULL
					SELECT @Ok = 10010
						  ,@OkRef = 'CFD - Concepto'

				IF @SubTotalLinea IS NULL
					SELECT @Ok = 10010
						  ,@OkRef = 'CFD - SubTotal'

				IF @Layout = 'DETALLISTA'
				BEGIN

					IF NULLIF(RTRIM(@EAN13), '') IS NULL
						SELECT @Ok = 10010
							  ,@OkRef = 'CFD - Codigo de Barras'

					IF LEN(@EAN13) > 14
						SELECT @Ok = 10010
							  ,@OkRef = 'CFD - Excede Tamaño Caracteres 14'

					IF NULLIF(RTRIM(@UnidadClave), '') IS NULL
						SELECT @Ok = 10010
							  ,@OkRef = 'CFD - Articulo Clave Unidad'

				END

			END

			IF @Layout = 'SAT'
			BEGIN

				IF @Version = '1.0'
				BEGIN

					IF @TipoServicio <> 'Servicio'
						SELECT '<Concepto' +
						 dbo.fnXMLFloat('cantidad', @Cantidad) +
						 dbo.fnXML('unidad', CASE
							 WHEN @Liverpool = 1 THEN @UnidadClave
							 ELSE @Unidad
						 END) +
						 dbo.fnXML('descripcion', @ArtDescripcion1) +
						 dbo.fnXMLMoney('valorUnitario', @SubTotalLinea / NULLIF(@Cantidad, 0.0)) +
						 dbo.fnXMLmoney('importe', @SubTotalLinea) +
						 '>'
					ELSE
						SELECT '<Concepto' +
						 dbo.fnXMLFloat('cantidad', @Cantidad) +
						 dbo.fnXML('descripcion', @ArtDescripcion1) +
						 dbo.fnXMLMoney('valorUnitario', @SubTotalLinea / NULLIF(@Cantidad, 0.0)) +
						 dbo.fnXMLmoney('importe', @SubTotalLinea) +
						 '>'

					IF @Layout = 'SAT'
						AND NULLIF(@Pedimento, '') IS NOT NULL
						AND @TipoAddenda NOT IN ('AMECE / LIVERPOOL', 'AMECE / CM')
						SELECT '<InformacionAduanera' +
						 dbo.fnXML('numero', @Pedimento) +
						 dbo.fnXMLDatetimeFmt('fecha', @PedimentoFecha, 'AAAA-MM-DD') +
						 dbo.fnXML('aduana', @Aduana) +
						 '/>'

				END
				ELSE

				IF @TipoServicio <> 'Servicio'
					SELECT '<Concepto' +
					 dbo.fnXMLFloat('cantidad', @Cantidad) +
					 dbo.fnXML('unidad', CASE
						 WHEN @Liverpool = 1 THEN @UnidadClave
						 ELSE @Unidad
					 END) +
					 dbo.fnXML('descripcion', @ArtDescripcion1) +
					 dbo.fnXMLDecimal('valorUnitario', @SubTotalLinea / NULLIF(@Cantidad, 0.0), @CfgDecimales) +
					 dbo.fnXMLDecimal('importe', @SubTotalLinea, @CfgDecimales) +
					 '>'
				ELSE
					SELECT '<Concepto' +
					 dbo.fnXMLFloat('cantidad', @Cantidad) +
					--  dbo.fnXML('unidad', CASE
					-- 	 WHEN @Liverpool = 1 THEN @UnidadClave
					-- 	 ELSE @Unidad
					--  END) +
					 dbo.fnXML('noIdentificacion', @noIdentificacion) +
					 dbo.fnXML('descripcion', @ArtDescripcion1) +
					 dbo.fnXMLDecimal('valorUnitario', (@SubTotalLinea / NULLIF(@Cantidad, 0.0)) + (ISNULL(@DescuentoLinea, 0) + ISNULL(@DescuentoGlobalLinea, 0)) / @Cantidad, @CfgDecimales) +
					 dbo.fnXMLDecimal('importe', @SubTotalLinea + ISNULL(@DescuentoLinea, 0) + ISNULL(@DescuentoGlobalLinea, 0), @CfgDecimales) +
					 '>'

				IF NULLIF(@Pedimento, '') IS NOT NULL
					AND @TipoAddenda NOT IN ('AMECE / LIVERPOOL', 'AMECE / CM')
					SELECT '<InformacionAduanera' +
					 dbo.fnXML('numero', @Pedimento) +
					 dbo.fnXMLDatetimeFmt('fecha', @PedimentoFecha, 'AAAA-MM-DD') +
					 dbo.fnXML('aduana', @Aduana) +
					 '/>'

			END
			ELSE

			IF @Layout LIKE 'AMECE%'
			BEGIN
				SELECT '<lineItem' +
				 dbo.fnXML('type', 'SimpleInvoiceLineItemType') +
				 dbo.fnXMLInt('number', @Conteo)
				 + '>'
				SELECT '<tradeItemIdentification>'
				SELECT '<gtin>' + ISNULL(@EAN13, '') + '</gtin>'
				SELECT '</tradeItemIdentification>'

				IF @Gigante = 0
					SELECT '<alternateTradeItemIdentification' + dbo.fnXML('type', CASE
						 WHEN @EmpresaSKUCodigoInterno = 1 THEN 'SUPPLIER_ASSIGNED'
						 ELSE 'BUYER_ASSIGNED'
					 END) + '>' +
					 CASE
						 WHEN @EmpresaSKUCodigoInterno = 1 THEN RTRIM(@SKUEmpresa)
						 ELSE RTRIM(@SKUCliente)
					 END +
					 '</alternateTradeItemIdentification>'

				SELECT '<tradeItemDescriptionInformation' + dbo.fnXML('language', 'ES') + '>' +
				 dbo.fnTag('longText', LEFT(@ArtDescripcion1, 35)) +
				 '</tradeItemDescriptionInformation>'

				IF ABS(@SubTotalLinea) > 0.01
				BEGIN
					SELECT '<invoicedQuantity' + dbo.fnXML('unitOfMeasure', @UnidadClave) + '>' +
					 CONVERT(VARCHAR(20), ISNULL(@Cantidad, 0.0)) +
					 '</invoicedQuantity>'

					IF @Gigante = 0
						SELECT '<aditionalQuantity' + dbo.fnXML('QuantityType', 'NUM_CONSUMER_UNITS') + '>' +
						 CONVERT(VARCHAR(20), @Paquetes) +
						 '</aditionalQuantity>'

				END
				ELSE
				BEGIN
					SELECT '<invoicedQuantity' + dbo.fnXML('unitOfMeasure', @UnidadClave) + '>0.00</invoicedQuantity>'

					IF @Gigante = 0
					BEGIN

						IF @UnidadFactor <> 1.0
							SELECT '<aditionalQuantity' + dbo.fnXML('QuantityType', 'NUM_CONSUMER_UNITS') + '>' +
							 CONVERT(VARCHAR(20), @Cantidad * @UnidadFactor) +
							 '</aditionalQuantity>'
						ELSE
							SELECT '<aditionalQuantity' + dbo.fnXML('QuantityType', 'FREE_GOODS') + '>' +
							 CONVERT(VARCHAR(20), ISNULL(@Cantidad, 0.0)) +
							 '</aditionalQuantity>'

					END

				END

				IF @Gigante = 0
					SELECT '<grossPrice>' + dbo.fnTagMoney('Amount', @ImporteLinea / NULLIF(@Cantidad, 0.0)) + '</grossPrice>'

				IF @Gigante = 0
					SELECT '<netPrice>' + dbo.fnTagMoney('Amount', @SubTotalLinea / NULLIF(@Cantidad, 0.0)) + '</netPrice>'

				IF NULLIF(RTRIM(@OrdenCompra), '') IS NOT NULL
					AND @Liverpool = 0
					SELECT '<AdditionalInformation>' +
					 '<referenceIdentification' + dbo.fnXML('type', 'ON') + '>' + @OrdenCompra +
					 '</referenceIdentification>' +
					 '</AdditionalInformation>'

				IF @Gigante = 0
				BEGIN

					IF @Layout IN ('AMECE')
						AND NULLIF(@Pedimento, '') IS NOT NULL
						SELECT '<Customs>' +
						 dbo.fnTag('gln', @AduanaGLN) +
						 '<alternatePartyIdentification' + dbo.fnXML('type', 'TN') + '>' + @Pedimento + '</alternatePartyIdentification>' +
						 dbo.fnTagDatetimeFmt('ReferenceDate', @PedimentoFecha, 'AAAA-MM-DD') +
						 '<nameAndAddress>' +
						 dbo.fnTag('name', @Aduana) +
						 '</nameAndAddress>' +
						 '</Customs>'

					IF @Layout IN ('AMECE', 'AMECE / GIGANTE')
						AND NULLIF(@Paquetes, 0) IS NOT NULL
						SELECT '<palletInformation>' +
						 dbo.fnTagInt('palletQuantity', @Paquetes) +
						 '<description' + dbo.fnXML('type', @TipoEmpaqueTipo) + '>' + 'default' + '</description>' +
						 '<transport>' +
						 dbo.fnTag('methodOfPayment', 'PREPAID_BY_SELLER') +
						 '</transport>' +
						 '</palletInformation>'

					IF NULLIF(@PctDescuentoLinea, 0.0) IS NOT NULL
						SELECT '<allowanceCharge' + dbo.fnXML('allowanceChargeType', 'ALLOWANCE_GLOBAL') + '>' +
						 '<monetaryAmountOrPercentage>' +
						 dbo.fnTagFloat('percentagePerUnit', @PctDescuentoLinea) +
						 '</monetaryAmountOrPercentage>' +
						 '</allowanceCharge>'

					IF @Layout IN ('AMECE')
					BEGIN
						SELECT '<tradeItemTaxInformation>' +
						 dbo.fnTag('taxTypeDescription', 'VAT') +
						 '<tradeItemTaxAmount>' +
						 dbo.fnTagFloat('taxPercentage', @Impuesto1) +
						 dbo.fnTagMoney('taxAmount', @Impuesto1Linea) +
						 '</tradeItemTaxAmount>' +
						 dbo.fnTag('taxCategory', 'TRANSFERIDO') +
						 '</tradeItemTaxInformation>'

						IF @Impuesto2Linea <> 0.0
							SELECT '<tradeItemTaxInformation>' +
							 dbo.fnTag('taxTypeDescription', 'GST') +
							 '<tradeItemTaxAmount>' +
							 dbo.fnTagFloat('taxPercentage', @Impuesto2) +
							 dbo.fnTagMoney('taxAmount', @Impuesto2Linea) +
							 '</tradeItemTaxAmount>' +
							 dbo.fnTag('taxCategory', 'TRANSFERIDO') +
							 '</tradeItemTaxInformation>'

					END

				END

				SELECT '<totalLineAmount>' +
				 '<grossAmount>' +
				 dbo.fnTagMoney('Amount', CASE
					 WHEN @Gigante = 1 THEN @SubTotalLinea
					 ELSE @ImporteLinea
				 END) +
				 '</grossAmount>'
				SELECT '<netAmount>' +
				 dbo.fnTagMoney('Amount', CASE
					 WHEN @Gigante = 1 THEN @ImporteLinea
					 ELSE @SubTotalLinea
				 END) +
				 '</netAmount>'
				SELECT '</totalLineAmount>'
				SELECT '</lineItem>'
			END
			ELSE

			IF @Layout LIKE '%INTERFACTURA%'
			BEGIN
				SELECT '<if:Cuerpo'

				IF @Elektra = 1
				BEGIN
					SELECT dbo.fnXML('Renglon', @Conteo) +
					 dbo.fnXMLFloat('Cantidad', @Cantidad) +
					 dbo.fnXML('Concepto', @ArtDescripcion1) +
					 dbo.fnXMLMoney('PUnitario', @Precio) +
					 dbo.fnXMLMoney('Importe', @Cantidad * @Precio)
				END

				IF @EHB = 1
					SELECT dbo.fnXML('U_x0020_de_x0020_M', @UnidadClave) +
					 dbo.fnXMLMoney('SubTotal', @SubTotalLinea) +
					 dbo.fnXML('SKU', @SKUEmpresa) +
					 dbo.fnXMLMoney('PUnitario', @Precio) +
					 dbo.fnXMLFloat('FactorEmpaque', @CantidadEmpaque) +
					 dbo.fnXML('EAN13', @EAN13) +
					 dbo.fnXML('Concepto', @ArtDescripcion1) +
					 dbo.fnXML('Codigo', @SKUCliente) +
					 dbo.fnXMLFloat('Cantidad', @Cantidad) +
					 dbo.fnXMLMoney('TotalDescuentos', @DescuentoGlobalLinea + @DescuentoLinea) +
					 dbo.fnXMLMoney('CUnitarioLista', @Precio)

				SELECT '>'
				SELECT '</if:Cuerpo>'
			END
			ELSE

			IF @Layout = 'HOME DEPOT'
			BEGIN
				SELECT '<Detalle' +
				 dbo.fnXML('SKU', @SKUCliente) +
				 dbo.fnXMLFloat('cantidad', @Cantidad) +
				 dbo.fnXML('descripcion', @ArtDescripcion1) +
				 dbo.fnXMLMoney('valor', @PrecioLinea) +
				 dbo.fnXML('unidad', @Unidad) +
				 dbo.fnXMLMoney('IVA', @Impuesto1Linea) +
				 dbo.fnXML('vendorPack', @CantidadEmpaque) + '/>'
			END
			ELSE

			IF @Layout LIKE 'SORIANA%'
			BEGIN

				IF @Layout = 'SORIANA TIENDA'
					AND @Pedimento IS NOT NULL
				BEGIN
					SELECT '<Pedimento' +
					 '>' +
					 dbo.fnTag('Proveedor', LEFT(@ProveedorID, 35)) +
					 dbo.fnTag('Remision', LEFT(@Embarque, 35)) +
					 dbo.fnTag('Pedimento', @Pedimento) +
					 dbo.fnTag('Aduana', @AduanaClave) +
					 dbo.fnTag('AgenteAduanal', @AgenteAduanal) +
					 dbo.fnTagInt('TipoPedimento', 1) +
					 dbo.fnTagDateTime('FechaPedimento', @PedimentoFecha) +
					 dbo.fnTagDateTime('FechaReciboLaredo', @PedimentoFecha2) +
					 dbo.fnTagDateTime('FechaBillOfLading', @PedimentoFecha3)
					SELECT '</Pedimento>'
				END

				SELECT '<Articulos' +
				 dbo.fnXML('Id', 'Articulo' + CONVERT(VARCHAR, @Conteo)) +
				 dbo.fnXMLInt('RowOrder', @Conteo) +
				 '>' +
				 dbo.fnTag('Proveedor', LEFT(@ProveedorID, 35)) +
				 dbo.fnTag('Remision', LEFT(ISNULL(@Serie, '') + CONVERT(VARCHAR, @Folio), 35)) +
				 dbo.fnTag('FolioPedido', @OrdenCompra) +
				 dbo.fnTag('Tienda', @EnviarAClave) +
				 dbo.fnTag('Codigo', @EAN13) +
				 dbo.fnTagFloat('CantidadUnidadCompra', @Cantidad) +
				 dbo.fnTagFloat('CostoNetoUnidadCompra', @PrecioLinea) +
				 dbo.fnTagFloat('PorcentajeIEPS', ISNULL(@Impuesto2, 0)) +
				 dbo.fnTagFloat('PorcentajeIVA', ISNULL(@Impuesto1, 0))
				SELECT '</Articulos>'

				IF @Layout = 'SORIANA TIENDA'
				BEGIN
					SELECT '<CajasTarimas' +
					 dbo.fnXMLInt('Id', 1) +
					 dbo.fnXMLInt('RowOrder', @Conteo) +
					 '>' +
					 dbo.fnTag('Proveedor', LEFT(@ProveedorID, 35)) +
					 dbo.fnTag('Remision', LEFT(@Embarque, 35)) +
					 dbo.fnTag('NumeroCajaTarima', @OrdenCompra) +
					 dbo.fnTag('CodigoBarraCajaTarima', @EAN13) +
					 dbo.fnTag('SucursalDistribuir', @EnviarAClave) +
					 dbo.fnTag('CantidadArticulos', @Paquetes)
					SELECT '</CajasTarimas>'
					SELECT '<ArticulosPorCajaTarima' +
					 dbo.fnXMLInt('Id', 1) +
					 dbo.fnXMLInt('RowOrder', @Conteo) +
					 '>' +
					 dbo.fnTag('Proveedor', LEFT(@ProveedorID, 35)) +
					 dbo.fnTag('Remision', LEFT(@Embarque, 35)) +
					 dbo.fnTag('FolioPedido', @OrdenCompra) +
					 dbo.fnTag('NumeroCajaTarima', @OrdenCompra) +
					 dbo.fnTag('SucursalDistribuir', @EAN13) +
					 dbo.fnTag('Codigo', @EAN13) +
					 dbo.fnTag('CantidadUnidadCompra', @CantidadEmpaque)
					SELECT '</ArticulosPorCajaTarima>'
				END

			END
			ELSE

			IF @LayOut = 'ASPEL'
			BEGIN
				SELECT dbo.fnTag('ObsPartida', @DescripcionExtra)
			END
			ELSE

			IF @Layout = 'EDIFACT'
			BEGIN
				INSERT #EDI
					SELECT 1
						  ,'<Linea>'
						  ,'LIN'
				INSERT #EDI
					SELECT 1
						  ,'Numero'
						  ,CONVERT(VARCHAR(20), @Conteo)
				INSERT #EDI
					SELECT 0
						  ,'ID Articulo'
						  ,''
				INSERT #EDI
					SELECT 1
						  ,'EAN'
						  ,NULLIF(RTRIM(dbo.fnEDI(@EAN13)), '') + ':SRV::9'
				INSERT #EDI
					SELECT 1
						  ,'<Fin>'
						  ,''

				IF NULLIF(RTRIM(@SKUCliente), '') IS NOT NULL
					AND @EmpresaSKUCodigoInterno = 0
				BEGIN
					INSERT #EDI
						SELECT 1
							  ,'<ID Adicional Producto>'
							  ,'PIA'
					INSERT #EDI
						SELECT 1
							  ,'ID Adicional'
							  ,'1'
					INSERT #EDI
						SELECT 1
							  ,'SKU'
							  ,dbo.fnEDI(@SKUCliente) + ':' +
							   CASE
								   WHEN @EmpresaSKUCodigoInterno = 1 THEN 'SA'
								   ELSE 'IN'
							   END
					INSERT #EDI
						SELECT 1
							  ,'<Fin>'
							  ,''
				END

				INSERT #EDI
					SELECT 1
						  ,'<Descripcion Articulo>'
						  ,'IMD'
				INSERT #EDI
					SELECT 1
						  ,'Tipo'
						  ,'F'
				INSERT #EDI
					SELECT 0
						  ,'Titulo Descripcion'
						  ,''
				INSERT #EDI
					SELECT 1
						  ,'Articulo - Descripcion 1'
						  ,':::' + NULLIF(dbo.fnEDI(@ArtDescripcion1), '') + ':' + ISNULL(dbo.fnEDI(@ArtDescripcion2), '') + ':ES'
				INSERT #EDI
					SELECT 1
						  ,'<Fin>'
						  ,''
				INSERT #EDI
					SELECT 1
						  ,'<Cantidad>'
						  ,'QTY'

				IF ABS(@SubTotalLinea) > 0.01
					INSERT #EDI
						SELECT 1
							  ,'Cantidad y Unidad Facturada'
							  ,'47:' + CONVERT(VARCHAR(20), ROUND(@Cantidad, 2)) + ':' + NULLIF(dbo.fnEDI(@UnidadClave), '')
				ELSE
				BEGIN
					INSERT #EDI
						SELECT 1
							  ,'Cantidad y Unidad Facturada'
							  ,'47:0.00:' + NULLIF(dbo.fnEDI(@UnidadClave), '')
					INSERT #EDI
						SELECT 1
							  ,'Cantidad y Unidad Gratis'
							  ,'192:' + CONVERT(VARCHAR(20), ROUND(@Cantidad, 2)) + ':' + NULLIF(dbo.fnEDI(@UnidadClave), '')
				END

				INSERT #EDI
					SELECT 1
						  ,'<Fin>'
						  ,''
				INSERT #EDI
					SELECT 1
						  ,'<Importe Monetario>'
						  ,'MOA'
				INSERT #EDI
					SELECT 1
						  ,'Importe Linea Neto'
						  ,'203:' + CONVERT(VARCHAR(20), ROUND(@ImporteLinea, 2))
				INSERT #EDI
					SELECT 1
						  ,'<Fin>'
						  ,''
				INSERT #EDI
					SELECT 1
						  ,'<Precio Unitario>'
						  ,'PRI'
				INSERT #EDI
					SELECT 1
						  ,'Precio Neto'
						  ,'AAA:' + CONVERT(VARCHAR(20), CONVERT(MONEY, ROUND(@ImporteLinea / NULLIF(@Cantidad, 0.0), 2))) + '::::' + ISNULL(dbo.fnEDI(@UnidadClave), '')
				INSERT #EDI
					SELECT 1
						  ,'<Fin>'
						  ,''
				INSERT #EDI
					SELECT 1
						  ,'<Impuestos>'
						  ,'TAX'
				INSERT #EDI
					SELECT 1
						  ,'Clave Impuestos'
						  ,'7'
				INSERT #EDI
					SELECT 1
						  ,'IVA'
						  ,'VAT'
				INSERT #EDI
					SELECT 0
						  ,'Titulo'
						  ,''
				INSERT #EDI
					SELECT 0
						  ,'????'
						  ,''
				INSERT #EDI
					SELECT 1
						  ,'Tasa'
						  ,':::' + CONVERT(VARCHAR(20), ROUND(@Impuesto1, 2))
				INSERT #EDI
					SELECT 1
						  ,'IVA Transferido'
						  ,'B'
				INSERT #EDI
					SELECT 1
						  ,'<Fin>'
						  ,''
				INSERT #EDI
					SELECT 1
						  ,'<Importe Monetario>'
						  ,'MOA'
				INSERT #EDI
					SELECT 1
						  ,'Importe IVA'
						  ,'124:' + CONVERT(VARCHAR(20), ROUND(@Impuesto1Linea, 2))
				INSERT #EDI
					SELECT 1
						  ,'<Fin>'
						  ,''

				IF NULLIF(@Impuesto2Linea, 0.0) IS NOT NULL
				BEGIN
					INSERT #EDI
						SELECT 1
							  ,'<Impuestos>'
							  ,'TAX'
					INSERT #EDI
						SELECT 1
							  ,'Clave Impuestos'
							  ,'7'
					INSERT #EDI
						SELECT 1
							  ,'IEPS'
							  ,'GST'
					INSERT #EDI
						SELECT 0
							  ,'Titulo'
							  ,''
					INSERT #EDI
						SELECT 0
							  ,'????'
							  ,''
					INSERT #EDI
						SELECT 1
							  ,'Tasa'
							  ,':::' + CONVERT(VARCHAR(20), ROUND(@Impuesto2, 2))
					INSERT #EDI
						SELECT 1
							  ,'IVA Transferido'
							  ,'B'
					INSERT #EDI
						SELECT 1
							  ,'<Fin>'
							  ,''
					INSERT #EDI
						SELECT 1
							  ,'<Importe Monetario>'
							  ,'MOA'
					INSERT #EDI
						SELECT 1
							  ,'Importe IEPS'
							  ,'124:' + CONVERT(VARCHAR(20), ROUND(@Impuesto2Linea, 2))
					INSERT #EDI
						SELECT 1
							  ,'<Fin>'
							  ,''
				END

				IF NULLIF(RTRIM(@Pedimento), '') IS NOT NULL
				BEGIN
					INSERT #EDI
						SELECT 1
							  ,'<Nombre y Direccion>'
							  ,'NAD'
					INSERT #EDI
						SELECT 1
							  ,'Aduana'
							  ,'CM'
					INSERT #EDI
						SELECT 0
							  ,'Aduana - GLN'
							  ,ISNULL(NULLIF(RTRIM(dbo.fnEDI(@AduanaGLN)), '') + '::9', '')
					INSERT #EDI
						SELECT 0
							  ,'Nombre de la Parte'
							  ,''
					INSERT #EDI
						SELECT 1
							  ,'Aduana - Nombre'
							  ,dbo.fnEDIMax(dbo.fnEDI(@Aduana), 35)
					INSERT #EDI
						SELECT 1
							  ,'<Fin>'
							  ,''
					INSERT #EDI
						SELECT 1
							  ,'<Referencia>'
							  ,'RFF'
					INSERT #EDI
						SELECT 1
							  ,'Recibo'
							  ,'TN:' + dbo.fnEDI(NULLIF(@Pedimento, ''))
					INSERT #EDI
						SELECT 1
							  ,'<Fin>'
							  ,''
					INSERT #EDI
						SELECT 1
							  ,'<Fecha Hora>'
							  ,'DTM'
					INSERT #EDI
						SELECT 1
							  ,'Fecha Pedimiento'
							  ,'171:' + CONVERT(VARCHAR, @PedimentoFecha, 112) + ':102'
					INSERT #EDI
						SELECT 1
							  ,'<Fin>'
							  ,''
				END

				IF @DescuentoLinea <> 0.0
				BEGIN
					INSERT #EDI
						SELECT 1
							  ,'<Descuento Linea>'
							  ,'ALC'
					INSERT #EDI
						SELECT 1
							  ,'Tipo Descuento'
							  ,'A'
					INSERT #EDI
						SELECT 1
							  ,'Secuencia Calculo'
							  ,'1'
					INSERT #EDI
						SELECT 0
							  ,'Titulo'
							  ,''
					INSERT #EDI
						SELECT 0
							  ,'Clave Descuento'
							  ,''
					INSERT #EDI
						SELECT 1
							  ,'<Fin>'
							  ,''
					INSERT #EDI
						SELECT 1
							  ,'<Porcentaje>'
							  ,'PCD'
					INSERT #EDI
						SELECT 1
							  ,'Porcentaje'
							  ,'1:' + CONVERT(VARCHAR(20), ROUND(@PctDescuentoLinea, 2))
					INSERT #EDI
						SELECT 1
							  ,'<Fin>'
							  ,''
					INSERT #EDI
						SELECT 1
							  ,'<Importe Monetario>'
							  ,'MOA'
					INSERT #EDI
						SELECT 1
							  ,'Importe Descuento Linea'
							  ,'204:' + CONVERT(VARCHAR(20), ROUND(@DescuentoLinea, 2))
					INSERT #EDI
						SELECT 1
							  ,'<Fin>'
							  ,''
				END

			END
			ELSE

			IF @Layout = 'CHEDRAUI'
			BEGIN
				INSERT #CFD
					SELECT 1
						  ,'Detalle'
						  ,'[D]'
				INSERT #CFD
					SELECT 1
						  ,'EAN'
						  ,@EAN13
				INSERT #CFD
					SELECT 1
						  ,'DUN14'
						  ,@DUN14
				INSERT #CFD
					SELECT 1
						  ,'Articulo - Descripcion 1'
						  ,@ArtDescripcion1
				INSERT #CFD
					SELECT 0
						  ,'Articulo - Descripcion 2'
						  ,@ArtDescripcion2

				IF ABS(@SubTotalLinea) > 0.01
					INSERT #CFD
						SELECT 1
							  ,'Cantidad'
							  ,CONVERT(VARCHAR(20), ROUND(@Cantidad, 2))
				ELSE
					INSERT #CFD
						SELECT 1
							  ,'Cantidad'
							  ,'0.00'

				INSERT #CFD
					SELECT 1
						  ,'Unidad - Clave'
						  ,@UnidadClave
				INSERT #CFD
					SELECT 1
						  ,'Cantidad Empaque'
						  ,CONVERT(VARCHAR(20), ROUND(@CantidadEmpaque, 4))
				INSERT #CFD
					SELECT 1
						  ,'Precio Linea'
						  ,CONVERT(VARCHAR(20), ROUND(@PrecioLinea, 2))
				INSERT #CFD
					SELECT 0
						  ,'% Desc 1'
						  ,CONVERT(VARCHAR(20), ROUND(@PctDescuentoLinea, 10))
				INSERT #CFD
					SELECT 0
						  ,'Tipo Desc 1'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Importe Desc 1'
						  ,CONVERT(VARCHAR(20), ROUND(@DescuentoLinea, 2))
				INSERT #CFD
					SELECT 0
						  ,'% Desc 2'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Tipo Desc 2'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Importe Desc 2'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'% Desc 3'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Tipo Desc 3'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Importe Desc 3'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'% Desc 4'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Tipo Desc 4'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Importe Desc 4'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'% Desc 5'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Tipo Desc 5'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Importe Desc 5'
						  ,NULL
				INSERT #CFD
					SELECT 1
						  ,'Precio Neto'
						  ,CONVERT(VARCHAR(20), ROUND(@SubTotalLinea, 2))
				INSERT #CFD
					SELECT 1
						  ,'% IVA'
						  ,CONVERT(VARCHAR(20), ROUND(@Impuesto1, 2))
				INSERT #CFD
					SELECT 1
						  ,'% IEPS'
						  ,CONVERT(VARCHAR(20), ROUND(ISNULL(@Impuesto2, 0.0), 2))
				INSERT #CFD
					SELECT 1
						  ,'Cantidad Embarcada'
						  ,CONVERT(VARCHAR(20), ROUND(@Cantidad, 2))
				INSERT #CFD
					SELECT 0
						  ,'Aduana'
						  ,@Aduana
				INSERT #CFD
					SELECT 0
						  ,'Fecha Pedimento'
						  ,CONVERT(VARCHAR, @PedimentoFecha, 126)
				INSERT #CFD
					SELECT 0
						  ,'Pedimento'
						  ,@Pedimento
				INSERT #CFD
					SELECT 0
						  ,'Articulo - Clave'
						  ,@Articulo
				INSERT #CFD
					SELECT 0
						  ,'SKU'
						  ,@SKUCliente

				IF ABS(@SubTotalLinea) > 0.01
					INSERT #CFD
						SELECT 1
							  ,'Cantidad Gratuita'
							  ,'0.00'
				ELSE
					INSERT #CFD
						SELECT 1
							  ,'Cantidad Gratuita'
							  ,CONVERT(VARCHAR(20), ROUND(@Cantidad, 2))

				INSERT #CFD
					SELECT 0
						  ,'Tipo Empaque'
						  ,@ArtTipoEmpaque
				INSERT #CFD
					SELECT 0
						  ,'Pago Empaque'
						  ,NULL
				INSERT #CFD
					SELECT 1
						  ,'Precio Bruto'
						  ,CONVERT(VARCHAR(20), CONVERT(MONEY, ROUND(@PrecioLinea * @Cantidad, 2)))
				INSERT #CFD
					SELECT 1
						  ,'Importe sin DescuentoGlobal'
						  ,CONVERT(VARCHAR(20), ROUND(@ImporteLinea, 2))
				INSERT #CFD
					SELECT 1
						  ,'Monto IVA'
						  ,CONVERT(VARCHAR(20), ROUND(@Impuesto1Linea, 2))
				INSERT #CFD
					SELECT 1
						  ,'Monto IEPS'
						  ,CONVERT(VARCHAR(20), ROUND(ISNULL(@Impuesto2Linea, 0.0), 2))
				INSERT #CFD
					SELECT 0
						  ,'% ISR'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Monto ISR'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'% Impuesto Petroleo'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Monto Impuesto Petroleo'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'% Excento'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Monto Excento'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'% Estatal'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Monto Estatal'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'% Cedular'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Monto Cedular'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'% Municipal'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Monto Municipal'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'% Hospedaje'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Monto Hospedaje'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'% Otros'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Monto Otros'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Etiqueta 1'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Numero Cuenta Predial'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Cantidad Real Kilos, Metros o Litros'
						  ,'0.00'
				INSERT #CFD
					SELECT 0
						  ,'Etiqueta 2'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Etiqueta 3'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Etiqueta 4'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Etiqueta 5'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Etiqueta 6'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Etiqueta 7'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Etiqueta 8'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Etiqueta 9'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Etiqueta 10'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Etiqueta 11'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Etiqueta 12'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Etiqueta 13'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Etiqueta 14'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Etiqueta 15'
						  ,NULL
				INSERT #CFD
					SELECT 0
						  ,'Enter'
						  ,'{@Enter}'
			END

			IF @Layout = 'SAT'
				AND @PrimerSerieLote IS NOT NULL
				AND @TipoAddenda NOT IN ('AMECE / LIVERPOOL', 'AMECE / CM')
			BEGIN

				IF @RenglonTipo = 'J'
					DECLARE
						crSerieLoteMov
						CURSOR LOCAL FOR
						SELECT s.SerieLote
							  ,dbo.fnLimpiarRFC(s.Propiedades)
							  ,p.Fecha2
							  ,p.Aduana
						FROM SerieLoteMov s WITH(NOLOCK)
						JOIN SerieLoteProp p WITH(NOLOCK)
							ON p.Propiedades = s.Propiedades
						WHERE s.Empresa = @Empresa
						AND s.Modulo = @Modulo
						AND s.ID = @ID
						AND s.RenglonID = @RenglonID
						GROUP BY s.SerieLote
								,s.Propiedades
								,p.Fecha2
								,p.Aduana
						ORDER BY s.SerieLote, s.Propiedades, p.Fecha2, p.Aduana
				ELSE
					DECLARE
						crSerieLoteMov
						CURSOR LOCAL FOR
						SELECT s.SerieLote
							  ,dbo.fnLimpiarRFC(s.Propiedades)
							  ,p.Fecha2
							  ,p.Aduana
						FROM SerieLoteMov s WITH(NOLOCK)
						JOIN SerieLoteProp p WITH(NOLOCK)
							ON p.Propiedades = s.Propiedades
						WHERE s.Empresa = @Empresa
						AND s.Modulo = @Modulo
						AND s.ID = @ID
						AND s.RenglonID = @RenglonID
						AND s.Articulo = @Articulo
						AND ISNULL(s.SubCuenta, '') = ISNULL(@SubCuenta, '')
						GROUP BY s.SerieLote
								,s.Propiedades
								,p.Fecha2
								,p.Aduana
						ORDER BY s.SerieLote, s.Propiedades, p.Fecha2, p.Aduana

				OPEN crSerieLoteMov
				FETCH NEXT FROM crSerieLoteMov INTO @SerieLote, @Pedimento, @PedimentoFecha, @Aduana
				WHILE @@FETCH_STATUS <> -1
				AND @@Error = 0
				BEGIN

				IF @@FETCH_STATUS <> -2
				BEGIN
					EXEC xpCFDSerieLote @Empresa
									   ,@Modulo
									   ,@Id
									   ,@Renglon
									   ,@RenglonSub
									   ,@RenglonID
									   ,@RenglonTipo
									   ,@Articulo
									   ,@Subcuenta
									   ,@TipoAddenda
									   ,@LayOut
									   ,@SerieLote
									   ,@Pedimento OUTPUT
									   ,@PedimentoFecha OUTPUT
									   ,@Aduana OUTPUT

					IF @Pedimento IS NOT NULL
						AND @Validar = 1
					BEGIN

						IF NULLIF(RTRIM(@Pedimento), '') IS NULL
							SELECT @Ok = 10010
								  ,@OkRef = 'CFD - Pedimento'

						IF @PedimentoFecha IS NULL
							SELECT @Ok = 10010
								  ,@OkRef = 'CFD - Pedimento Fecha'

						IF NULLIF(RTRIM(@Aduana), '') IS NULL
							SELECT @Ok = 10010
								  ,@OkRef = 'CFD - Aduana'

					END

					IF @Layout = 'SAT'
						AND @Pedimento IS NOT NULL
						SELECT '<InformacionAduanera' +
						 dbo.fnXML('numero', @Pedimento) +
						 dbo.fnXMLDatetimeFmt('fecha', @PedimentoFecha, 'AAAA-MM-DD') +
						 dbo.fnXML('aduana', @Aduana) +
						 '/>'

				END

				FETCH NEXT FROM crSerieLoteMov INTO @SerieLote, @Pedimento, @PedimentoFecha, @Aduana
				END
				CLOSE crSerieLoteMov
				DEALLOCATE crSerieLoteMov
			END

			IF @Layout = 'SAT'
				SELECT '</Concepto>'

		END

		FETCH NEXT FROM crDetalle INTO @Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @Codigo, @Cantidad, @Unidad, @UnidadFactor, @Articulo, @SubCuenta, @SubTotalLinea,
		@EAN13, @DUN14, @SKUCliente, @SKUEmpresa,
		@PctDescuentoLinea, @DescuentoLinea, @DescuentoGlobalLinea, @Impuesto1, @Impuesto2, @Impuesto1Linea, @Impuesto2Linea,
		@ArtDescripcion1, @ArtDescripcion2, @ArtTipoEmpaque, @Precio, @Tiposervicio
		END
		CLOSE crDetalle
		DEALLOCATE crDetalle

		IF @Layout = 'SAT'
			AND NULLIF(@AnticiposFacturados, 0) IS NOT NULL
			SELECT '<Concepto' +
			 dbo.fnXMLFloat('cantidad', 1) +
			 dbo.fnXML('unidad', 'No Aplica') +
			 dbo.fnXML('noIdentificacion', 'Anticipo') +
			 dbo.fnXML('descripcion', 'Anticipos Facturados') +
			 dbo.fnXMLDecimal('valorUnitario', (@AnticiposFacturados - ISNULL(@AnticiposImpuestos, 0.0)) * -1, @CfgDecimales) +
			 dbo.fnXMLDecimal('importe', (@AnticiposFacturados - ISNULL(@AnticiposImpuestos, 0.0)) * -1, @CfgDecimales) +
			 '>'

	END

	IF @Layout = 'SAT'
		SELECT '</Conceptos>'

	IF @Layout LIKE 'AMECE%'
	BEGIN

		IF @Gigante = 0
			SELECT '<totalAmount>' +
			 dbo.fnTagMoney('Amount', @Importe) +
			 '</totalAmount>'

		IF @Gigante = 0
			SELECT '<TotalAllowanceCharge' + dbo.fnXML('allowanceOrChargeType', 'ALLOWANCE') + '>' +
			 dbo.fnTagMoney('Amount', ISNULL(@ImporteDescuentoGlobal, 0.0)) +
			 '</TotalAllowanceCharge>'

		SELECT '<baseAmount>' +
		 dbo.fnTagMoney('Amount', @SubTotal) +
		 '</baseAmount>'
	END

	IF @Version = '1.0'
		AND @Layout = 'SAT'
	BEGIN

		IF @Layout = 'SAT'
		BEGIN
			SELECT '<Impuestos><Traslados>'
			SELECT '<Traslado' +
			 dbo.fnXML('impuesto', 'IVA') +
			 dbo.fnXMLDecimal('importe', @Impuesto1Total, @CfgDecimales) +
			 '/>'

			IF @Impuesto2Total <> 0.0
				SELECT '<Traslado' +
				 dbo.fnXML('impuesto', 'IEPS') +
				 dbo.fnXMLDecimal('importe', @Impuesto2Total, @CfgDecimales) +
				 '/>'

			SELECT '</Traslados></Impuestos>'
		END

	END

	IF (@Version = '2.0' AND @Layout = 'SAT')
		OR @Layout IN ('AMECE', 'AMECE / LIVERPOOL', 'AMECE / CM')
	BEGIN

		IF @Layout = 'SAT'
		BEGIN
			IF @RetencionTotal <> 0.0
				AND @RetencionTotal IS NOT NULL
				SELECT '<Impuestos' +
				 dbo.fnXMLMoney('totalImpuestosRetenidos', @RetencionTotal) +
				 dbo.fnXMLMoney('totalImpuestosTrasladados', @ImpuestosTotal) + '>'
			ELSE
			BEGIN
				SELECT '<Impuestos' +
				 dbo.fnXMLMoney('totalImpuestosTrasladados', @ImpuestosTotal) + '>'
				SELECT '<Traslados>'
			END

		END

		IF @RetencionTotal <> 0.0
			AND @RetencionTotal IS NOT NULL
		BEGIN

			IF @Modulo = 'CXC'
				AND @MovTipo = 'CXC.NC'
				AND @Origen LIKE 'Devolucion%'
			BEGIN
				SELECT @Mov = @Origen
					  ,@MovID = @OrigenID
			END

			SELECT '<Retenciones>'
			DECLARE
				crRetencion1
				CURSOR LOCAL FOR
				SELECT v.importe * (a.retencion2 / 100)
				FROM ventatcalc v WITH(NOLOCK)
					,art a WITH(NOLOCK)
				WHERE v.mov = @Mov
				AND v.MovID = @MovID
				AND v.articulo = a.articulo
				AND a.categoria = 'RETENCION'
			OPEN crRetencion1
			FETCH NEXT FROM crRetencion1 INTO @Retencion1
			WHILE @@FETCH_STATUS <> -1
			AND @@Error = 0
			BEGIN

			IF @@FETCH_STATUS <> -2
			BEGIN
				SELECT '<Retencion' +
				 dbo.fnXML('impuesto', 'IVA') +
				 dbo.fnXMLMoney('importe', @Retencion1) +
				 '/>'
			END

			FETCH NEXT FROM crRetencion1 INTO @Retencion1
			END
			CLOSE crRetencion1
			DEALLOCATE crRetencion1
			SELECT '</Retenciones>'

			SELECT '<Traslados>'
		END

		IF @Modulo = 'CXC'
		BEGIN

			IF @Layout = 'SAT'
				SELECT '<Traslado' +
				 dbo.fnXML('impuesto', 'IVA') +
				 dbo.fnXMLFloat2('tasa', @Impuesto1) +
				 dbo.fnXMLDecimal('importe', @Impuesto1Total, @CfgDecimales) +
				 '/>'

		END

		IF @Modulo = 'VTAS'
		BEGIN
			DECLARE
				crImpuesto1
				CURSOR LOCAL FOR
				SELECT Impuesto1
					  ,SUM(Impuesto1Total *
					   CASE
						   WHEN @MN = 1 THEN TipoCambio
						   ELSE 1.0
					   END)
				FROM VentaTCalc WITH(NOLOCK)
				WHERE ID = @ID
				GROUP BY Impuesto1
				ORDER BY Impuesto1
			OPEN crImpuesto1
			FETCH NEXT FROM crImpuesto1 INTO @Impuesto1, @Impuesto1SubTotal
			WHILE @@FETCH_STATUS <> -1
			AND @@Error = 0
			BEGIN

			IF @@FETCH_STATUS <> -2
			BEGIN

				IF @Validar = 1
				BEGIN

					IF @Impuesto1 IS NULL
						SELECT @Ok = 10010
							  ,@OkRef = 'CFD - Tasa Impuesto IVA'

					IF @Impuesto1SubTotal IS NULL
						SELECT @Ok = 10010
							  ,@OkRef = 'CFD - Importe Impuesto IVA'

				END

				IF NULLIF(@AnticiposImpuestos, 0.0) IS NOT NULL
					SELECT @TasaAnticipoImpuesto = @AnticiposImpuestos / (@AnticiposFacturados - @AnticiposImpuestos)

				IF @TasaAnticipoImpuesto IS NOT NULL
					AND @TasaAnticipoImpuesto < (@Impuesto1 / 100 + .01)
					AND @TasaAnticipoImpuesto > (@Impuesto1 / 100 - .01)
					SELECT @Impuesto1SubTotal = @Impuesto1SubTotal - @AnticiposImpuestos

				EXEC xpCFDVentaImpuesto @Estacion
									   ,@Modulo
									   ,@ID
									   ,@Layout
									   ,@Validar
									   ,@Empresa
									   ,@Sucursal
									   ,@Cliente
									   ,'IVA'
									   ,@Impuesto1 OUTPUT
									   ,@Impuesto1SubTotal OUTPUT

				IF @Layout = 'SAT'
					SELECT '<Traslado' +
					 dbo.fnXML('impuesto', 'IVA') +
					 dbo.fnXMLFloat2('tasa', @Impuesto1) +
					 dbo.fnXMLDecimal('importe', @Impuesto1SubTotal, @CfgDecimales) +
					 '/>'
				ELSE

				IF @Layout IN ('AMECE', 'AMECE / LIVERPOOL', 'AMECE / CM')
				BEGIN
					SELECT '<tax' + dbo.fnXML('type', 'VAT') + '>'
					SELECT dbo.fnTagFloat('taxPercentage', @Impuesto1) +
					 dbo.fnTagMoney('taxAmount', @Impuesto1SubTotal) +
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
			DECLARE
				crImpuesto2
				CURSOR LOCAL FOR
				SELECT Impuesto2
					  ,SUM(Impuesto2Total *
					   CASE
						   WHEN @MN = 1 THEN TipoCambio
						   ELSE 1.0
					   END)
				FROM VentaTCalc WITH(NOLOCK)
				WHERE ID = @ID
				GROUP BY Impuesto2
				ORDER BY Impuesto2
			OPEN crImpuesto2
			FETCH NEXT FROM crImpuesto2 INTO @Impuesto2, @Impuesto2SubTotal
			WHILE @@FETCH_STATUS <> -1
			AND @@Error = 0
			BEGIN

			IF @@FETCH_STATUS <> -2
				AND NULLIF(@Impuesto2, 0.0) IS NOT NULL
			BEGIN

				IF @Layout = 'SAT'
					SELECT '<Traslado' +
					 dbo.fnXML('impuesto', 'IEPS') +
					 dbo.fnXMLFloat2('tasa', @Impuesto2) +
					 dbo.fnXMLDecimal('importe', @Impuesto2SubTotal, @CfgDecimales) +
					 '/>'
				ELSE

				IF @Layout IN ('AMECE', 'AMECE / LIVERPOOL', 'AMECE / CM')
				BEGIN
					SELECT '<tax' + dbo.fnXML('type', 'GST') + '> '
					SELECT dbo.fnTagFloat('taxPercentage', @Impuesto2) +
					 dbo.fnTagMoney('taxAmount', @Impuesto2SubTotal) +
					 dbo.fnTag('taxCategory', 'TRANSFERIDO')
					SELECT '</tax>'
				END

			END

			FETCH NEXT FROM crImpuesto2 INTO @Impuesto2, @Impuesto2SubTotal
			END
			CLOSE crImpuesto2
			DEALLOCATE crImpuesto2
		END

		IF @Layout = 'SAT'
		BEGIN
			SELECT '</Traslados>'
			SELECT '</Impuestos>'
		END

	END

	IF @Layout LIKE 'AMECE%'
	BEGIN
		SELECT '<payableAmount>' +
		 dbo.fnTagMoney('Amount', @Total) +
		 '</payableAmount>'
	END
	ELSE

	IF @Layout = 'EDIFACT'
	BEGIN
		INSERT #EDI
			SELECT 1
				  ,'<Fin Detalle>'
				  ,'UNS'
		INSERT #EDI
			SELECT 1
				  ,'Separacion'
				  ,'S'
		INSERT #EDI
			SELECT 1
				  ,'<Fin>'
				  ,''
		INSERT #EDI
			SELECT 1
				  ,'<Total Control>'
				  ,'CNT'
		INSERT #EDI
			SELECT 1
				  ,'Conteo'
				  ,'2:' + CONVERT(VARCHAR(20), @Conteo)
		INSERT #EDI
			SELECT 1
				  ,'<Fin>'
				  ,''
		INSERT #EDI
			SELECT 1
				  ,'<Importe Monetario>'
				  ,'MOA'
		INSERT #EDI
			SELECT 1
				  ,'Gran Total'
				  ,'9:' + CONVERT(VARCHAR(20), ROUND(@Total, 2))
		INSERT #EDI
			SELECT 1
				  ,'<Fin>'
				  ,''
		INSERT #EDI
			SELECT 1
				  ,'<Importe Monetario>'
				  ,'MOA'
		INSERT #EDI
			SELECT 1
				  ,'SubTotal sin Descuentos'
				  ,'79:' + CONVERT(VARCHAR(20), ROUND(@SubTotal - @ImporteDescuentoGlobal, 2))
		INSERT #EDI
			SELECT 1
				  ,'<Fin>'
				  ,''

		IF NULLIF(@DescuentoGlobal, 0.0) IS NOT NULL
		BEGIN
			INSERT #EDI
				SELECT 1
					  ,'<Descuento Global>'
					  ,'ALC'
			INSERT #EDI
				SELECT 1
					  ,'Tipo Descuento'
					  ,'A'
			INSERT #EDI
				SELECT 0
					  ,'Titulo'
					  ,''
			INSERT #EDI
				SELECT 0
					  ,'Numero Descuento'
					  ,''
			INSERT #EDI
				SELECT 0
					  ,'Imputacion Descuento'
					  ,''
			INSERT #EDI
				SELECT 1
					  ,'Secuencia Calculo'
					  ,'1'
			INSERT #EDI
				SELECT 0
					  ,'Titulo'
					  ,''
			INSERT #EDI
				SELECT 1
					  ,'Clave Descuento'
					  ,dbo.fnEDI(@DescuentoClave)
			INSERT #EDI
				SELECT 1
					  ,'<Fin>'
					  ,''
			INSERT #EDI
				SELECT 1
					  ,'<Importe Monetario>'
					  ,'MOA'
			INSERT #EDI
				SELECT 1
					  ,'Importe Descuento Global'
					  ,'131:' + CONVERT(VARCHAR(20), ROUND(@DescuentoGlobal, 2))
			INSERT #EDI
				SELECT 1
					  ,'<Fin>'
					  ,''
		END

		INSERT #EDI
			SELECT 1
				  ,'<Importe Monetario>'
				  ,'MOA'
		INSERT #EDI
			SELECT 1
				  ,'SubTotal'
				  ,'125:' + CONVERT(VARCHAR(20), ROUND(@SubTotal, 2))
		INSERT #EDI
			SELECT 1
				  ,'<Fin>'
				  ,''
		INSERT #EDI
			SELECT 1
				  ,'<Impuestos>'
				  ,'TAX'
		INSERT #EDI
			SELECT 1
				  ,'Clave Impuestos'
				  ,'7'
		INSERT #EDI
			SELECT 1
				  ,'IVA'
				  ,'VAT'
		INSERT #EDI
			SELECT 0
				  ,'Titulo'
				  ,''
		INSERT #EDI
			SELECT 0
				  ,'????'
				  ,''
		INSERT #EDI
			SELECT 1
				  ,'Tasa'
				  ,':::' + CONVERT(VARCHAR(20), ROUND(@Impuesto1Promedio, 2))
		INSERT #EDI
			SELECT 1
				  ,'IVA Transferido'
				  ,'B'
		INSERT #EDI
			SELECT 1
				  ,'<Fin>'
				  ,''
		INSERT #EDI
			SELECT 1
				  ,'<Importe Monetario>'
				  ,'MOA'
		INSERT #EDI
			SELECT 1
				  ,'Importe IVA'
				  ,'124:' + CONVERT(VARCHAR(20), ROUND(@Impuesto1Total, 2))
		INSERT #EDI
			SELECT 1
				  ,'<Fin>'
				  ,''

		IF NULLIF(@Impuesto2Total, 0.0) IS NOT NULL
		BEGIN
			INSERT #EDI
				SELECT 1
					  ,'<Impuestos>'
					  ,'TAX'
			INSERT #EDI
				SELECT 1
					  ,'Clave Impuestos'
					  ,'7'
			INSERT #EDI
				SELECT 1
					  ,'IEPS'
					  ,'GST'
			INSERT #EDI
				SELECT 0
					  ,'Titulo'
					  ,''
			INSERT #EDI
				SELECT 0
					  ,'????'
					  ,''
			INSERT #EDI
				SELECT 1
					  ,'Tasa'
					  ,':::' + CONVERT(VARCHAR(20), ROUND(@Impuesto2Promedio, 2))
			INSERT #EDI
				SELECT 1
					  ,'IVA Transferido'
					  ,'B'
			INSERT #EDI
				SELECT 1
					  ,'<Fin>'
					  ,''
			INSERT #EDI
				SELECT 1
					  ,'<Importe Monetario>'
					  ,'MOA'
			INSERT #EDI
				SELECT 1
					  ,'Importe IEPS'
					  ,'124:' + CONVERT(VARCHAR(20), ROUND(@Impuesto2Total, 2))
			INSERT #EDI
				SELECT 1
					  ,'<Fin>'
					  ,''
		END

		INSERT #EDI
			SELECT 1
				  ,'<Fin Mensaje>'
				  ,'UNT'
		INSERT #EDI
			SELECT 1
				  ,'Total Segmentos'
				  ,CONVERT(VARCHAR, COUNT(*) + 1)
			FROM #EDI
			WHERE Campo = '<Fin>'
		INSERT #EDI
			SELECT 1
				  ,'Referencia Mensaje'
				  ,RTRIM(@Modulo) + CONVERT(VARCHAR, @ID)
		INSERT #EDI
			SELECT 1
				  ,'<Fin>'
				  ,''
		INSERT #EDI
			SELECT 1
				  ,'<Fin Mensaje>'
				  ,'UNZ'
		INSERT #EDI
			SELECT 1
				  ,'Numero Mensajes'
				  ,'1'
		INSERT #EDI
			SELECT 1
				  ,'Referencia Envio'
				  ,dbo.fnEDI(@ReferenciaEnvio)
		INSERT #EDI
			SELECT 1
				  ,'<Fin>'
				  ,''
	END
	ELSE

	IF @Layout = 'CHEDRAUI'
	BEGIN
		INSERT #CFD
			SELECT 1
				  ,'SubTotales'
				  ,'[S]'
		INSERT #CFD
			SELECT 1
				  ,'SubTotal'
				  ,CONVERT(VARCHAR(20), ROUND(@SubTotal + @ImporteDescuentoGlobal, 2))
		INSERT #CFD
			SELECT 0
				  ,'Monto Descuento 1'
				  ,CONVERT(VARCHAR(20), ROUND(@ImporteDescuentoGlobal, 2))
		INSERT #CFD
			SELECT 0
				  ,'Monto Descuento 2'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Monto Descuento 3'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Monto Descuento 4'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Monto Descuento 5'
				  ,NULL
		INSERT #CFD
			SELECT 1
				  ,'IVA'
				  ,CONVERT(VARCHAR(20), ROUND(@Impuesto1Total, 2))
		INSERT #CFD
			SELECT 1
				  ,'IEPS'
				  ,CONVERT(VARCHAR(20), ROUND(ISNULL(@Impuesto2Total, 0.0), 2))
		INSERT #CFD
			SELECT 1
				  ,'Total'
				  ,CONVERT(VARCHAR(20), ROUND(@Total, 2))
		INSERT #CFD
			SELECT 1
				  ,'SubTotal 2'
				  ,CONVERT(VARCHAR(20), ROUND(@SubTotal, 2))
		INSERT #CFD
			SELECT 0
				  ,'Total Articulos Facturados'
				  ,CONVERT(VARCHAR(20), ROUND(@SumaCantidad, 4))
		INSERT #CFD
			SELECT 1
				  ,'% IVA'
				  ,CONVERT(VARCHAR(20), ROUND(@Impuesto1Promedio, 2))
		INSERT #CFD
			SELECT 1
				  ,'% IEPS'
				  ,CONVERT(VARCHAR(20), ROUND(@Impuesto2Promedio, 2))
		INSERT #CFD
			SELECT 0
				  ,'% ISR'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Monto ISR'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'% Impuesto Petroleo'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Monto Impuesto Petroleo'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'% Excento'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Monto Excento'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'% Estatal'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Monto Estatal'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'% Cedular'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Monto Cedular'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'% Municipal'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Monto Municipal'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'% Hospedaje'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Monto Hospedaje'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'% Otros'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Monto Otros'
				  ,NULL
		INSERT #CFD
			SELECT 1
				  ,'Numero Partidas'
				  ,CONVERT(VARCHAR(20), @Conteo)
		INSERT #CFD
			SELECT 0
				  ,'% IVA Retenido'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Monto IVA Retenido'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'% ISR Retenido'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Monto ISR Retenido'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Monto Total Descuentos'
				  ,CONVERT(VARCHAR(20), ROUND(@DescuentosTotales, 2))
		INSERT #CFD
			SELECT 1
				  ,'SubTotal 3'
				  ,CONVERT(VARCHAR(20), ROUND(@SumaSubTotalLinea, 2))
		INSERT #CFD
			SELECT 1
				  ,'SubTotal 4'
				  ,CONVERT(VARCHAR(20), ROUND(ISNULL(@SumaImporteLinea, 0.0) + ISNULL(@Impuesto1Total, 0.0) + ISNULL(@Impuesto2Total, 0.0), 2))
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 1'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Etiqueta 2'
				  ,NULL
		INSERT #CFD
			SELECT 0
				  ,'Enter'
				  ,'{@Enter}'
	END

	IF @TipoAddenda = 'DETALLISTA'
		AND @LayOut = 'SAT'
		AND @Version = '2.0'
		EXEC spCFDDetallista @Estacion
							,@Modulo
							,@ID
							,''
							,1
							,@ok OUTPUT
							,@OkRef OUTPUT

	IF @LayOut = 'SAT'
		AND @TipoAddenda = 'DETALLISTA'
		AND @Version = '2.0'
		EXEC spCFDDetallista @Estacion
							,@Modulo
							,@ID
							,'Detallista'

	IF @Layout = 'SAT'
		SELECT '<Addenda>{@Addenda}</Addenda>'

	IF @Layout = 'EDIFACT'
		EXEC spConvertirEDIFACT

	IF @Layout = 'SAT'
	BEGIN
		SELECT '</Comprobante>'

		IF @Validar = 0
		BEGIN

			IF @Estatus = 'CANCELADO'
				AND (
					SELECT NULLIF(FechaCancelacion, '')
					FROM CFD WITH(NOLOCK)
					WHERE Modulo = @Modulo
					AND ModuloID = @ID
				)
				IS NULL
				UPDATE CFD WITH(ROWLOCK)
				SET FechaCancelacion = GETDATE()
			   ,Fecha = @FechaRegistro
			   ,Ejercicio = YEAR(@Fecha)
			   ,Periodo = MONTH(@Fecha)
			   ,Empresa = @Empresa
			   ,MovID = @MovID
			   ,Serie = @Serie
			   ,Folio = @Folio
			   ,RFC = @ClienteRFC
			   ,Aprobacion = CONVERT(VARCHAR, YEAR(@fechaAprobacion)) + CONVERT(VARCHAR, @noAprobacion)
			   ,Importe = @SubTotal
			   ,Impuesto1 = @Impuesto1Total
			   ,Impuesto2 = @Impuesto2Total
				WHERE Modulo = @Modulo
				AND ModuloID = @ID
			ELSE
				UPDATE CFD WITH(ROWLOCK)
				SET Fecha = @Fecha
				   ,Ejercicio = YEAR(@Fecha)
				   ,Periodo = MONTH(@Fecha)
				   ,Empresa = @Empresa
				   ,MovID = @MovID
				   ,Serie = @Serie
				   ,Folio = @Folio
				   ,RFC = @ClienteRFC
				   ,Aprobacion = CONVERT(VARCHAR, YEAR(@fechaAprobacion)) + CONVERT(VARCHAR, @noAprobacion)
				   ,Importe = @SubTotal
				   ,Impuesto1 = @Impuesto1Total
				   ,Impuesto2 = @Impuesto2Total
				   ,TipoCambio =
					CASE
						WHEN @MN = 1 THEN 1
						ELSE @TipoCambio
					END
				WHERE Modulo = @Modulo
				AND ModuloID = @ID

		END

	END
	ELSE

	IF @Layout IN ('CHEDRAUI', 'EDIFACT')
	BEGIN

		IF EXISTS (SELECT * FROM #CFD WHERE Requerido = 1 AND NULLIF(RTRIM(Dato), '') IS NULL)
		BEGIN
			INSERT #CFD
				SELECT 1
					  ,'{@CamposRequeridos}'
					  ,NULL
			SELECT Campo
			FROM #CFD
			WHERE Requerido = 1
			AND NULLIF(RTRIM(Dato), '') IS NULL
			ORDER BY ID
		END
		ELSE
		BEGIN
			SELECT ISNULL(RTRIM(Dato), '')
			FROM #CFD
			ORDER BY ID
		END

	END
	ELSE

	IF @Layout LIKE 'AMECE%'
		SELECT '</requestForPayment>' +
		 '</cfdi:Addenda>'
	ELSE

	IF @Layout LIKE '%INTERFACTURA%'
		SELECT '</if:Encabezado>' +
		 CASE @MovTipo
			 WHEN 'VTAS.D' THEN '</if:NotaCreditoInterfactura>'
			 WHEN 'CXC.NC' THEN '</if:NotaCreditoInterfactura>'
			 WHEN 'VTAS.B' THEN '</if:NotaDebitoInterfactura>'
			 WHEN 'CXC.CA' THEN '</if:NotaDebitoInterfactura>'
			 ELSE '</if:FacturaInterfactura>'
		 END +
		 '</cfdi:Addenda>'
	ELSE

	IF @Layout = 'HOME DEPOT'
		SELECT '</Encabezado>' +
		 '</cfdi:Addenda>'
	ELSE

	IF @Layout = 'SORIANA'
		SELECT '</DSCargaRemisionProv>' +
		 '</cfdi:Addenda>'
	ELSE

	IF @LayOut = 'ASPEL'
	BEGIN
		SELECT '</Obspartidas>'
		SELECT dbo.fnTagInt('totalpartidas', @NumeroArticulos)
		SELECT '<Cadena>'
		SELECT '{@CadenaOriginal}'
		SELECT '</Cadena>'
		SELECT dbo.fnTag('Observaciones', @Observaciones) +
		 dbo.fnTag('NoEmpresa', 2)
		SELECT '</cfdi:Addenda>'
	END

	IF @LayOut = 'ASSENSA'
		EXEC SpAddendaSorianaASSENSA @Id
									,@Referencia

	IF @LayOut = 'CONSOLIDADO SORIANA'
		AND @Modulo = 'VTAS'
		EXEC spCFDSorianaConsolidado @Estacion
									,'VTAS'
									,@ID
									,'CONSOLIDADO SORIANA'

	IF @LayOut = 'COPPEL'
		AND @Modulo = 'VTAS'
		EXEC spGenerarCFDCoppel @Estacion
							   ,'VTAS'
							   ,@ID
							   ,'COPPEL'

	SET CONCAT_NULL_YIELDS_NULL OFF
	RETURN
END
GO