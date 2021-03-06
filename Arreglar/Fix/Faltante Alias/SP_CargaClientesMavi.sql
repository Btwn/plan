SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT - 1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
-- ========================================================================================================================================
-- NOMBRE  		: SP_CargaClientesMavi
-- AUTOR			: Intelisis 
-- FECHA CREACION	: 
-- DESARROLLO		: CLIENTE EXPRESS
-- MODULO			: 
-- DESCRIPCION		: PROCEDIMIENTO PARA LA CARGA DE CLIENTE EXPRESS
-- 1º MODIFICACION  : ARTURO GUIZER REYES 20100615  --AGR 20110211 SE CAMBIA PARA QUE GUARDE NOMBRE POR APELLIDO
-- 2º MODIFICACIÓN  : CARMEN QUINTANA 2011/12/10 SE CORRIGIÓ LA FORMA EN QUE INSERTABAN LOS CLIENTES EN LA TABLA CTE
-- 3º MODIFICACIÓN  : CARMEN QUINTANA 2012/07/18 Se inserta una dirección genérica para cuando no se capturen dichos datos a los 
--												 Clientes con Canal de Venta pertenecientes a las Categorías Contado y Crédito Extrerno
-- ULTIMA TEAM		: 19122011 E1722
-- ULTIMA OFICIAL	: 21122011 V1135 M21122011_1140	
-- ========================================================================================================================================
-- FECHA Y AUTOR MODIFICACION: 03/jul/2013 Por: ERIC F. MARTINEZ, SE ELIMINO LA CONDICION SI DIRECCION DEL EMPLEO CLIENTE ES NULA '@DireccionEmpleo' .
-- FECHA Y AUTOR MODIFICACION: 23/may/2015 Por: ERIC F. MARTINEZ, ifnull en @DireccionAnterior para no crear el contacto CTEDOMANT
-- FECHA Y AUTOR MODIFICACION: 16/DIC/2015 Por: ERIC F. MARTINEZ, se le pasa la informacion del nuevo campo TipoEmpleo de ClienteExpressMavi a MaviCteCtoEmpleo
-- FECHA Y AUTOR MODIFICACION: 30/MAY/2017 Por: ERIC F. MARTINEZ, se agrego la referencia para guardar los datos del telefono y extencion de la empresa
-- FECHA Y AUTOR MODIFICACION: 30/MAY/2017 Por: ERIC F. MARTINEZ, se agrego la referencia para guardar los datos del telefono y extencion de la empresa
-- ========================================================================================================================================
-- FECHA Y AUTOR MODIFICACION: 13-11-2017 Por: Daniel Guastavo Hernandez Ramirez, se genero la correccion para la seccion de cobranza, ya que estaba poniendo un dato incorrecto en el update
-- ========================================================================================================================================
-- FECHA Y AUTOR MODIFICACION: 05-03-2018 Por: Daniel Guastavo Hernandez Ramirez, se quito un <BR> que estaba al guardar el cliente
-- ========================================================================================================================================
ALTER PROCEDURE [dbo].[SP_CargaClientesMavi] @Clave varchar(20),
@Accion varchar(10),
@Estacion int,
@IDn int,
@Usuario varchar(12),
@Regimen varchar(30)

AS
BEGIN
  DECLARE @Nombre varchar(100),
          @Sucursal varchar(50),
          @ID float, --DM0138
          @Tipo varchar(50),
          @Nomina varchar(50),
          @TipoTel varchar(50),
          @ClaveInst varchar(50),
          @Cargo varchar(50),
          @Municipio varchar(50),
          @MaxContacto float,
          @Sexo varchar(20),
          @Parentesco varchar(20),
          @Nombres varchar(100),
          @Apaterno varchar(20),
          @Amaterno varchar(20),
          @Puesto varchar(50),
          @RFCInst varchar(50),
          @EnviarA int,
          @BuroCredito tinyint,
          @CanalVenta tinyint,
          @DireccionAnterior varchar(110),
          @Emisor1C varchar(60),
          @Observaciones varchar(max),
          @Cadena varchar(30),
          @UEN tinyint,
          @DireccionEmpleo varchar(100),
          @Bonifica float,
          @EsCredExpress bit

  SELECT
    @Nombre = ISNULL(ApaternoCte + ' ' + AmaternoCte + ' ' + NombresCte, Nombre),
    @Nombres = NombresCte,
    @Apaterno = ApaternoCte,
    @Amaterno = AmaternoCte,
    @Sucursal = Categoria,
    @ClaveInst = ClaveInst,
    @Cargo = Cargo,
    @Municipio = Municipio,
    @Sexo = SexoCte,
    @EsCredExpress = EsCredExpress
  FROM ClienteExpressMavi WITH (NOLOCK)
  WHERE ID = @IDn
  AND Estacion = @Estacion

  --Inicio AGR 07112009 Para agregar el domicilio anterior al contacto en caso de tenerla, asi como Referencias
  SELECT
    @DireccionAnterior = ADireccionCte
  FROM ClienteExpressMavi WITH (NOLOCK)
  WHERE ID = @IDn
  AND Estacion = @Estacion

  SELECT
    @Emisor1C = Emisor1C
  FROM ClienteExpressMavi WITH (NOLOCK)
  WHERE ID = @IDn
  AND Estacion = @Estacion

  SELECT
    @Observaciones =
                    CASE
                      WHEN (Observaciones IS NULL) OR
                        (Observaciones = '') OR
                        (Observaciones = ' ') THEN 'NULO'
                      ELSE Observaciones
                    END
  FROM ClienteExpressMavi WITH (NOLOCK)
  WHERE ID = @IDn
  AND Estacion = @Estacion


  --AGR 21112009 SE AREGA VARIABLE PARA SABER SI TIENE DIRECCION DEL EMPLEO
  SELECT
    @DireccionEmpleo = EDireccion
  FROM ClienteExpressMavi WITH (NOLOCK)
  WHERE ID = @IDn
  AND Estacion = @Estacion

  --AGR 13012010 SE AREGA VARIABLE PARA SABER SI TIENE BONIFICACION
  SET @Bonifica = 0
  SELECT
    @Bonifica = Porcentaje
  FROM MaviBonifMayoreo WITH (NOLOCK)

  --Fin AGR 07112009 Para agregar el domicilio anterior al contacto en caso de tenerla
  SELECT
    @EnviarA = ID
  FROM CteEnviarA WITH (NOLOCK)
  WHERE Cliente = @Clave

  /*Agreado AGR para insertar el campo de SeEnviaBuroCredito en la tabla Cte */
  SELECT
    @CanalVenta = CanalventaCte
  FROM ClienteExpressMavi WITH (NOLOCK)
  WHERE Cliente = @Clave
  SELECT
    @BuroCredito = SeEnviaBuroCreditoMavi
  FROM dbo.VentasCanalMAVI WITH (NOLOCK)
  WHERE id = @CanalVenta
  SELECT
    @Cadena = Cadena
  FROM dbo.VentasCanalMAVI WITH (NOLOCK)
  WHERE id = @CanalVenta
  SELECT
    @uen = Uen
  FROM dbo.VentasCanalMAVI WITH (NOLOCK)
  WHERE id = @CanalVenta


  SELECT TOP 1
    @Nomina = Nomina,
    @Puesto = Puesto,
    @RFCInst = RFCInstitucion
  FROM CteExpressCVMavi WITH (NOLOCK)
  WHERE IDint = @IDn

  IF @Regimen <> 'Persona Moral'
    SET @Nombre = @Apaterno + ' ' + @Amaterno + ' ' + @Nombres

  UPDATE ClienteExpressMavi WITH (ROWLOCK)
  SET Cliente = @Clave,
      nombre = @Nombre
  WHERE ID = @IDn

  IF EXISTS (SELECT
      *
    FROM CteEnviarA WITH (ROWLOCK)
    WHERE cliente = @clave)
  BEGIN
    UPDATE CteEnviarA WITH (ROWLOCK)
    SET nombre = c.nombre,
        Alta = GETDATE(),
        UltimoCambio = GETDATE(),
        Direccion = c.Direccioncte,
        DireccionNumero = c.NumeroExteriorCte,
        DireccionNumeroInt = c.NumeroInteriorCte,
        EntreCalles = c.EntreCallesCte,
        colonia = c.coloniaCte,
        delegacion = c.delegacionCte,
        poblacion = c.poblacion,
        estado = c.estadoCte,
        pais = c.paisCte,
        codigopostal = c.codigopostalCte,
        Categoria = c.Categoria,
        SeccionCobranzaMAVI =
                             CASE
                               WHEN canalventacte = 76 THEN 'CREDITO MENUDEO'
                               ELSE c.Categoria
                             END,
        Cadena = @Cadena,
        UenMavi = @Uen,
        ZonaImpuesto = 'OCCIDENTE',
        SeEnviaBuroCreditoMavi = @BuroCredito
    FROM ClienteExpressMavi c WITH (NOLOCK)
    WHERE CteEnviarA.Cliente = @clave
    AND c.ID = @IDn
  END

  --************************************** Validación Domicilio Canales de Venta Contado y Crédito Externo **************************************
  DECLARE @DireccionD varchar(50),
          @DireccionNumeroD varchar(50),
          @CodigoPostalD varchar(50),
          @ColoniaD varchar(50),
          @DelegacionD varchar(50),
          @PoblacionD varchar(50),
          @EstadoD varchar(50),
          @PaisD varchar(50),
          @RFCD varchar(50)

  IF (SELECT
      CanalVentaCte
    FROM ClienteExpressMavi WITH (NOLOCK)
    WHERE Cliente = @Clave)
    IN (SELECT
      ID
    FROM VentasCanalMAVI WITH (NOLOCK)
    WHERE Categoria IN ('CONTADO', 'CREDITO EXTERNO'))
  BEGIN
    SELECT
      @DireccionD = ISNULL(DireccionCte, 'DOMICILIO CONOCIDO'),
      @DireccionNumeroD = ISNULL(NumeroExteriorCte, 'S/N'),
      @CodigoPostalD = ISNULL(CodigoPostalCte, 0),
      @ColoniaD = ISNULL(ColoniaCte, (SELECT
        Colonia
      FROM CodigoPostal WITH (NOLOCK)
      WHERE CodigoPostal = 0)
      ),
      @DelegacionD = ISNULL(DelegacionCte, (SELECT
        Delegacion
      FROM CodigoPostal WITH (NOLOCK)
      WHERE CodigoPostal = 0)
      ),
      @PoblacionD = ISNULL(Poblacion, (SELECT
        Delegacion
      FROM CodigoPostal WITH (NOLOCK)
      WHERE CodigoPostal = 0)
      ),
      @EstadoD = ISNULL(EstadoCte, (SELECT
        Estado
      FROM CodigoPostal WITH (NOLOCK)
      WHERE CodigoPostal = 0)
      ),
      @PaisD = ISNULL(PaisCte, 'Mexico'),
      @RFCD = ISNULL(RFCCte, 'XAXX010101000')
    FROM ClienteExpressMavi C WITH (NOLOCK)
    INNER JOIN VentasCanalMAVI V WITH (NOLOCK)
      ON V.ID = C.CanalVentaCte
    WHERE V.Categoria IN ('CONTADO', 'CREDITO EXTERNO')
    AND Cliente = @Clave

    UPDATE ClienteExpressMavi WITH (ROWLOCK)
    SET DireccionCte = @DireccionD,
        NumeroExteriorCte = @DireccionNumeroD,
        CodigoPostalCte = @CodigoPostalD,
        ColoniaCte = @ColoniaD,
        DelegacionCte = @DelegacionD,
        Poblacion = @PoblacionD,
        EstadoCte = @EstadoD,
        PaisCte = @PaisD,
        RFCCte = @RFCD
    WHERE Cliente = @Clave
  END
  ELSE
  BEGIN
    SELECT
      @DireccionD = DireccionCte,
      @DireccionNumeroD = NumeroExteriorCte,
      @CodigoPostalD = CodigoPostalCte,
      @ColoniaD = ColoniaCte,
      @DelegacionD = DelegacionCte,
      @PoblacionD = Poblacion,
      @EstadoD = EstadoCte,
      @PaisD = PaisCte,
      @RFCD = RFCCte
    FROM ClienteExpressMavi WITH (NOLOCK)
    WHERE Cliente = @Clave
  END

  --*************************************************************** INICIO C.Q.R ****************************************************************
  IF @Regimen = 'Persona Moral'
  BEGIN
    INSERT INTO Cte (Cliente, FiscalRegimen, Nombre, PersonalNombres, PersonalApellidoPaterno, PersonalApellidoMaterno, Direccion,
    DireccionNumero, DireccionNumeroInt, EntreCalles, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal,
    RFC, Tipo, Estatus, EstadoCivil, Sexo,
    FechaNacimiento, TipoCalle, eMail1, MaviRecomendadoPor, ImporteRentaMavi, ViveEnCalidad, AntiguedadNegocioMavi, MaviEstatus,
    ParentescoRecomiendaMavi, DireccionRecomiendaMavi, DEFMONEDA, CREDITOMONEDA, CreditoEspecial, ZonaImpuesto, PedidosParciales,
    ListaPrecios, VtasConsignacion, Alta, Conciliar, wVerDisponible, wVerArtListaPreciosEsp, ChecarCredito, BloquearMorosos,
    ModificarVencimiento, CreditoConLimite, CreditoConLimitePedidos, CreditoConDias, CreditoConCondiciones, RecorrerVencimiento,
    FormasPagoRestringidas, PersonalSMS, Fuma, Flotilla, EsProveedor, EsPersonal, EsAgente, EsAlmacen, EsEspacio, EsCentroCostos,
    EsProyecto, EsCentroTrabajo, EsEstacionTrabajo, PedidoDef, eMailAuto, Intercompania, Publico, CRMovVenta, Extranjero,
    DocumentacionCompleta, EnviarCobTelMavi, Usuario, SeEnviaBuroCreditoMavi, CalculoMoratorioMAVI, PublicidadMAVI, EsCredExpress, TipoCredito)
      SELECT
        @Clave,
        FiscalRegimenCte,
        @Nombres,
        '',
        '',
        '',
        @DireccionD,
        @DireccionNumeroD,
        NumeroInteriorCTE,
        EntreCallesCTE,
        @DelegacionD,
        @ColoniaD,
        @PoblacionD,
        @EstadoD,
        @PaisD,
        @CodigoPostalD,
        RFCCte,
        'Prospecto',
        'ALTA',
        EstadocivilCTE,
        SexoCte,
        FechaNacimiento,
        TipoCalleCte1,
        CorreoElectronico,
        Recomendado,
        ImporteRentaCte,
        ViveEnCalidadCte,
        AntiguaedadNegocioCte,
        'Nuevo',
        Parentesco,
        DireccionP,
        'Pesos',
        'Pesos',
        1,
        'OCCIDENTE',
        1,
        1,
        0,
        GETDATE(),
        0,
        0,
        0,
        '(Empresa)',
        '(Empresa)',
        '(Empresa)',
        0,
        0,
        0,
        0,
        '(Empresa)',
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        '(Empresa)',
        0,
        0,
        1,
        @Usuario,
        @BuroCredito,
        1,
        0,
        @EsCredExpress,
        TipoCredito
      FROM ClienteExpressMavi WITH (NOLOCK)
      WHERE Cliente = @Clave
  END
  ELSE
  BEGIN
    INSERT INTO Cte (Cliente, FiscalRegimen, Nombre, PersonalNombres, PersonalApellidoPaterno, PersonalApellidoMaterno, Direccion,
    DireccionNumero, DireccionNumeroInt, EntreCalles, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal,
    RFC, Tipo, Estatus, EstadoCivil, Sexo,
    FechaNacimiento, TipoCalle, eMail1, MaviRecomendadoPor, ImporteRentaMavi, ViveEnCalidad, AntiguedadNegocioMavi, MaviEstatus,
    ParentescoRecomiendaMavi, DireccionRecomiendaMavi, DEFMONEDA, CREDITOMONEDA, CreditoEspecial, ZonaImpuesto, PedidosParciales,
    ListaPrecios, VtasConsignacion, Alta, Conciliar, wVerDisponible, wVerArtListaPreciosEsp, ChecarCredito, BloquearMorosos,
    ModificarVencimiento, CreditoConLimite, CreditoConLimitePedidos, CreditoConDias, CreditoConCondiciones, RecorrerVencimiento,
    FormasPagoRestringidas, PersonalSMS, Fuma, Flotilla, EsProveedor, EsPersonal, EsAgente, EsAlmacen, EsEspacio, EsCentroCostos,
    EsProyecto, EsCentroTrabajo, EsEstacionTrabajo, PedidoDef, eMailAuto, Intercompania, Publico, CRMovVenta, Extranjero,
    DocumentacionCompleta, EnviarCobTelMavi, Usuario, SeEnviaBuroCreditoMavi, CalculoMoratorioMAVI, PublicidadMAVI, EsCredExpress, TipoCredito)
      SELECT
        @Clave,
        FiscalRegimenCte,
        @Apaterno + ' ' + @Amaterno + ' ' + @Nombres,
        @Nombres,
        @Apaterno,
        @Amaterno,
        @DireccionD,
        @DireccionNumeroD,
        NumeroInteriorCTE,
        EntreCallesCTE,
        @DelegacionD,
        @ColoniaD,
        @PoblacionD,
        @EstadoD,
        @PaisD,
        @CodigoPostalD,
        RFCCte,
        'Prospecto',
        'ALTA',
        EstadocivilCTE,
        SexoCte,
        FechaNacimiento,
        TipoCalleCte1,
        CorreoElectronico,
        Recomendado,
        ImporteRentaCte,
        ViveEnCalidadCte,
        AntiguaedadNegocioCte,
        'Nuevo',
        Parentesco,
        DireccionP,
        'Pesos',
        'Pesos',
        1,
        'OCCIDENTE',
        1,
        1,
        0,
        GETDATE(),
        0,
        0,
        0,
        '(Empresa)',
        '(Empresa)',
        '(Empresa)',
        0,
        0,
        0,
        0,
        '(Empresa)',
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        '(Empresa)',
        0,
        0,
        1,
        @Usuario,
        @BuroCredito,
        1,
        0,
        @EsCredExpress,
        TipoCredito
      FROM ClienteExpressMavi WITH (NOLOCK)
      WHERE Cliente = @Clave
  END
  --***************************************************************** FIN C.Q.R *****************************************************************

  IF @Nomina IS NOT NULL
  BEGIN
    UPDATE CteEnviarA WITH (ROWLOCK)
    SET ClaveInst = @ClaveInst,
        Cargo = @Cargo,
        Municipio = @Municipio,
        Nomina = @Nomina,
        Puesto = @Puesto,
        RFCInstitucion = @RFCInst
    WHERE Cliente = @Clave
  END

  --AGR 21112009 SE AGREGA CONDICION PARA AGREGAR EL CTE COMO CTO TIPO LABORAL
  IF @Regimen = 'Persona Fisica'
    AND @Sucursal IN ('INSTITUCIONES', 'CREDITO MENUDEO', 'ASOCIADOS') --AND @DireccionEmpleo is not null
  BEGIN
    IF @Sexo = 'Masculino'
      SET @Parentesco = 'EL'
    ELSE
    IF @Sexo = 'Femenino'
      SET @Parentesco = 'ELLA'
    INSERT INTO cteCto (Cliente, Nombre, ApellidoPaterno, ApellidoMaterno, FechaNacimiento, EnviarA, Tipo, Sexo, MaviEstatus,
    Atencion, Tratamiento, ViveConMavi, ViveEnCalidadDeMavi, Usuario, CteEnviarAExpress, EstadoCivilMavi)
      SELECT
        @Clave,
        NombresCte,
        ApaternoCte,
        AmaternoCte,
        FechaNacimiento,
        @EnviarA,
        'LABORAL',
        SexoCte,
        'Nuevo',
        @Parentesco,
        ViveEnCalidadCte,
        ViveConH,
        ViveEnCalidadH,
        @Usuario,
        @EnviarA,
        EstadoCivilCte--Se agregaron los ultimos 5 campos...AGR 021109 
      FROM ClienteExpressMavi WITH (NOLOCK)
      WHERE ID = @IDn
      AND Estacion = @Estacion
    SET @MaxContacto = SCOPE_IDENTITY()
    IF NOT EXISTS (SELECT
        *
      FROM CteCtoDireccion WITH (NOLOCK)
      WHERE Cliente = @Clave
      AND ID = @MaxContacto)
      AND @EsCredExpress = 0
    BEGIN
      INSERT INTO CteCtoDireccion (Cliente, ID, Tipo, Direccion, Delegacion, Colonia, Poblacion, Estado, CodigoPostal, MaviNumero,
      MaviNumeroInterno, TipoCalle, Pais, AntiguedadMesesMavi, AntiguedadAniosMavi)
        SELECT
          @Clave,
          @MaxContacto,
          'Particular',
          EDireccion,
          EDelegacion,
          EColonia,
          EDelegacion,
          EEstado,
          ECodigoPostal,
          ENumeroExterior,
          ENumeroInterior,
          ETipoCalle,
          EPais,
          EAntiguedadMesesMavi,
          EAntiguedadAniosMavi
        FROM ClienteExpressMavi WITH (NOLOCK)
        WHERE ID = @IDn
        AND Estacion = @Estacion

    END
  END

  --AGR 24112009 INSERTAR INFORMACION DEL EMPLEO EN TABLA MAVICTECTOEMPLEO
  IF (@DireccionEmpleo IS NOT NULL
    OR @DireccionEmpleo = NULL)
    AND @Sucursal IN ('INSTITUCIONES', 'CREDITO MENUDEO', 'ASOCIADOS')
  BEGIN
    INSERT INTO MaviCteCtoEmpleo (Cliente, ID, Empresa, Funciones, Departamento, AntiguedadMesesMavi, AntiguedadAniosMavi, JefeInmediato,
    PuestoJefeInmediato, Ingresos, PeriodoIngresos, Comprobables, TipoCalle, Direccion, Colonia, Delegacion,
    CodigoPostal, Estado, Cruces, Pais, NumeroExterior, NumeroInterior, TrabajoAnterior, TATipoCalle, TADireccion,
    TANumeroExterior, TANumeroInterior, TAEntreCalles, TAColonia, TADelegacion, TACodigoPostal, TAEstado, TAPais, TipoEmpleo, Telefono, Extension)
      SELECT
        @Clave,
        @MaxContacto,
        EEmpresa,
        EFunciones,
        EDepartamento,
        EAntiguedadMesesMavi,
        EAntiguedadAniosMavi,
        EJefeInmediato,
        EPuestoJefeInmediato,
        EIngresos,
        EPeriodoIngresos,
        EComprobables,
        ETipoCalle,
        EDireccion,
        EColonia,
        EDelegacion,
        ECodigoPostal,
        EEstado,
        ECruces,
        EPais,
        ENumeroExterior,
        ENumeroInterior,
        ETrabajoAnterior,
        ETATipoCalle,
        ETADireccion,
        ETANumeroExterior,
        ETANumeroInterior,
        ETAEntreCalles,
        ETAColonia,
        ETADelegacion,
        ETACodigoPostal,
        ETAEstado,
        ETAPais,
        TipoEmpleo,
        ETelefono,
        EExtencion
      FROM ClienteExpressMavi WITH (NOLOCK)
      WHERE ID = @IDn
      AND Estacion = @Estacion
  END

  --Inicio AGR 07112009 PARA CUANDO TIENE DIRECCION ANTERIOR
  IF @Regimen = 'Persona Fisica'
    AND @Sucursal IN ('INSTITUCIONES', 'CREDITO MENUDEO', 'ASOCIADOS')
    AND NULLIF(@DireccionAnterior, '') IS NOT NULL
  BEGIN
    IF @Sexo = 'Masculino'
      SET @Parentesco = 'EL'
    ELSE
    IF @Sexo = 'Femenino'
      SET @Parentesco = 'ELLA'
    INSERT INTO cteCto (Cliente, Nombre, ApellidoPaterno, ApellidoMaterno, FechaNacimiento, EnviarA, Tipo, Sexo, MaviEstatus, Atencion,
    Tratamiento, ViveConMavi, ViveEnCalidadDeMavi, Usuario, CteEnviarAExpress, EstadoCivilMavi)
      SELECT
        @Clave,
        NombresCte,
        ApaternoCte,
        AmaternoCte,
        FechaNacimiento,
        @EnviarA,
        'CTEDOMANT',
        SexoCte,
        'Nuevo',
        @Parentesco,
        ViveEnCalidadCte,
        ViveConH,
        ViveEnCalidadH,
        @Usuario,
        @EnviarA,
        EstadoCivilCte --Se agregaron los ultimos 2 campos...AGR 140809 
      FROM ClienteExpressMavi WITH (NOLOCK)
      WHERE ID = @IDn
      AND Estacion = @Estacion
    SET @MaxContacto = SCOPE_IDENTITY()

    IF NOT EXISTS (SELECT
        *
      FROM CteCtoDireccion WITH (NOLOCK)
      WHERE Cliente = @Clave
      AND ID = @MaxContacto)
      AND @EsCredExpress = 0
    BEGIN
      INSERT INTO CteCtoDireccion (Cliente, ID, Tipo, Direccion, Delegacion, Colonia, Poblacion, Estado, CodigoPostal, MaviNumero,
      MaviNumeroInterno, TipoCalle, Pais, AntiguedadMesesMavi, AntiguedadAniosMavi)
        SELECT
          @Clave,
          @MaxContacto,
          'Particular',
          ADireccionCTE,
          ADelegacionCTE,
          AColoniaCTE,
          APoblacion,
          AEstadoCTE,
          ACodigoPostalCTE,
          ANumeroExteriorCTE,
          ANumeroInteriorCTE,
          ATipoCalleCte1,
          APaisCTE,
          0,
          0
        FROM ClienteExpressMavi WITH (NOLOCK)
        WHERE ID = @IDn
        AND Estacion = @Estacion
    END
  END
  --FIN 07112009 AGR PARA CUANDO TIENE DIRECCION ANTERIOR
  --INICIO CAMBIO AGR 091120009 SE GRABAN DATOS EN TABLA CTEENVIARAOTROSDATOS

  IF @Sucursal IN ('CREDITO MENUDEO', 'ASOCIADOS')
    AND NULLIF(@Emisor1C, '') IS NOT NULL
  BEGIN
    INSERT INTO CteEnviarAOtrosDatos (Cliente, ID, Descripcion1, Descripcion2, Descripcion3, Descripcion4, Descripcion5, Descripcion6, Descripcion7,
    Descripcion8, Descripcion9, Descripcion10)
      SELECT
        @Clave,
        @EnviarA,
        Emisor1C,
        NTarjeta1C,
        Emisor2C,
        NTarjeta2C,
        Emisor1B,
        NTarjeta1B,
        Emisor2B,
        NTarjeta2B,
        Emisor3B,
        NTarjeta3B--Se agregaron los ultimos 2 campos...AGR 140809 
      FROM ClienteExpressMavi WITH (NOLOCK)
      WHERE ID = @IDn
      AND Estacion = @Estacion
  END
  --FIN CAMBIO AGR 091120009 SE GRABAN DATOS EN TABLA CTEENVIARAOTROSDATOS
  --INICIO CAMBIO AGR 141120009 SE GRABAN DATOS EN TABLA CTABITACORA
  IF (@Observaciones <> 'NULO')
  BEGIN
    INSERT INTO CtaBitacora (Modulo, Cuenta, Fecha, Evento, Usuario)
      SELECT
        'CXC',
        @Clave,
        GETDATE(),
        UPPER(@Observaciones),
        @Usuario--Se agregaron los ultimos 2 campos...AGR 140809 --DM0138
      FROM ClienteExpressMavi WITH (NOLOCK)
      WHERE ID = @IDn
      AND Estacion = @Estacion
  END
  --FIN CAMBIO AGR 141120009 SE GRABAN DATOS EN TABLA CTABITACORA
  --AGR PARA INSERTAR LA BONIFICACION DE PROSPECTOS CON CANAL DE VENTA DE MAYOREO
  IF @Sucursal IN ('MAYOREO')
    AND @Bonifica > 0
  BEGIN
    INSERT INTO CteBonificacion (Cliente, Concepto, Porcentaje, FechaD, FechaA)
      VALUES (@Clave, 'BONIFICACION MAYOREO 2', @Bonifica, CAST(FLOOR(CAST(GETDATE() AS real)) AS datetime), CONVERT(datetime, CONVERT(varchar(4), YEAR(GETDATE())) + '1231'))
    UPDATE Cte WITH (ROWLOCK)
    SET BonificacionTipo = 'Multiple'
    WHERE cliente = @Clave
  END

  IF @Accion = 'Agregar'
    SELECT
      'Enviado al Módulo de Clientes con el número  ' + @Clave
END