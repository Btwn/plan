SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCteABC_CRM ON Cte

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@ClienteI  			varchar(10),
@ClienteD			varchar(10),
@CRMII				varchar(36),
@CRMID				varchar(36),
@Datos				varchar(max),
@Usuario			varchar(10),
@Contrasena			varchar(32),
@Ok					int,
@OkRef				varchar(255),
@IDIS				int,
@Accion				varchar(20),
@SincronizarCRMI	bit,
@EstatusI			varchar(15),
@EstatusD			varchar(15),
@SincronizarCRMD	bit
IF dbo.fnEstaSincronizandoCRM() = 1
RETURN
SELECT
@Usuario    = Usuario,
@Contrasena = Contrasena
FROM CfgCRM
SELECT @ClienteI = Cliente, @CRMII = CRMID, @SincronizarCRMI = SincronizarCRM, @EstatusI = Estatus FROM Inserted
SELECT @ClienteD = Cliente, @CRMID = CRMID, @SincronizarCRMD = SincronizarCRM, @EstatusD = Estatus FROM Deleted
IF (@CRMII IS NULL AND @CRMID IS NULL) OR (@SincronizarCRMI = 0 AND @EstatusI = 'ALTA')
RETURN
IF @CRMII IS NOT NULL AND @CRMID IS NULL
SELECT @Accion = 'INSERT'
ELSE
IF @CRMII IS NOT NULL AND @CRMID IS NOT NULL
SELECT @Accion = 'UPDATE'
ELSE
IF @CRMII IS NULL AND @CRMID IS NOT NULL
SELECT @Accion = 'DELETE'
ELSE
RETURN
SELECT @Datos = '<Intelisis Sistema="IntelisisCRM" Contenido="Solicitud" Referencia="IntelisisCRM.CRM" SubReferencia="" Version="1.0">' + '<Solicitud>' + '<' + @Accion + '>'
IF @ClienteD IS NULL OR @ClienteD = @ClienteI
SELECT @Datos = @Datos + (SELECT ActividadEconomicaCNBV, Agente, Agente3, Agente4, AgenteServicio, Alergias, AlmacenDef, AlmacenVtasConsignacion, Alta, Aseguradora, BloquearMorosos, Bonificacion, BonificacionTipo, Categoria, CBDir, ChecarCredito, Clase, Cliente, Coaseguro, Cobrador, CodigoPostal, Colonia, Conciliar, Condicion, Contacto1, Contacto2, Contrasena, Contrasena2, Conyuge, Credito, CreditoConCondiciones, CreditoConDias, CreditoCondiciones, CreditoConLimite, CreditoConLimitePedidos, CreditoDias, CreditoEspecial, CreditoLimite, CreditoLimitePedidos, CreditoMoneda, CRMCantidad, CRMCierreFechaAprox, CRMCierreProbabilidad, CRMCompetencia, CRMEtapa, CRMFuente, CRMID, CRMImporte, CRMInfluencia, CRMovVenta, CRMPresupuestoAsignado, Cuenta, CuentaRetencion, CURP, Deducible, DeducibleMoneda, DefMoneda, Delegacion, Descripcion1, Descripcion10, Descripcion11, Descripcion12, Descripcion13, Descripcion14, Descripcion15, Descripcion16, Descripcion17, Descripcion18, Descripcion19, Descripcion2, Descripcion20, Descripcion3, Descripcion4, Descripcion5, Descripcion6, Descripcion7, Descripcion8, Descripcion9, Descuento, DescuentoRecargos, DiaPago1, DiaPago2, DiaRevision1, DiaRevision2, Direccion, DireccionNumero, DireccionNumeroInt, DirInternet, DocumentacionCompleta, EDICalificador, EDIIdentificador, eMail1, eMail2, eMailAuto, EntreCalles, EnviarA, EsAgente, EsAlmacen, EsCentroCostos, EsCentroTrabajo, EsEspacio, EsEstacionTrabajo, Espacio, EsPersonal, EsProveedor, EsProyecto, Estado, EstadoCivil, Estatura, Estatus, ExcentoISAN, ExpedienteFamiliar, Extencion1, Extencion2, Extranjero, FacturarCte, FacturarCteEnviarA, Familia, Fax, Fecha1, Fecha2, Fecha3, Fecha4, Fecha5, FechaMatrimonio, FechaNacimiento, FiscalRegimen, Flotilla, FordDistribuidor, FordZona, FormaEnvio, FormasPagoRestringidas, FueraLinea, Fuma, GLN, Grado, Grupo, GrupoSanguineo, GrupoSanguineoRH, HorarioPago, HorarioRevision, Idioma, IEPS, IFE, ImportadorRegimen, ImportadorRegistro, Intercompania, InterfacturaRI, Licencias, LicenciasLlave, LicenciasTipo, ListaPrecios, ListaPreciosEsp, LocalidadCNBV, MapaLatitud, MapaLongitud, MapaPrecision, Mensaje, ModificarVencimiento, NivelAcceso, Nombre, NombreAsegurado, NombreCorto, NoriticarATelefonos, NotificarA, Numero, NumeroHijos, Observaciones, OperacionLimite, OtrosCargos, Pais, Parentesco, Pasaporte, PedidoDef, PedidosParciales, PedirTono, PersonalApellidoMaterno, PersonalApellidoPaterno, PersonalCobrador, PersonalCodigoPostal, PersonalColonia, PersonalDelegacion, PersonalDireccion, PersonalEntreCalles, PersonalEstado, PersonalNombres, PersonalPais, PersonalPlano, PersonalPoblacion, PersonalSMS, PersonalTelefonoMovil, PersonalTelefonos, PersonalTelefonosLada, PersonalZona, Peso, PITEX, Plano, Poblacion, PolizaFechaEmision, PolizaImporte, PolizaNumero, PolizaReferencia, PolizaTipo, PolizaVencimiento, PreciosInferioresMinimo, PrimaryContactId, Profesion, ProveedorClave, ProveedorInfo, Proyecto, Publico, Puesto, Rama, RecorrerVencimiento, ReferenciaBancaria, Religion, Responsable, RFC, RPU, Ruta, RutaOrden, Sexo, SIC,
SincroC, SincroID, SIRAC, Situacion, SituacionFecha, SituacionNota, SituacionUsuario, SucursalEmpresa, Telefonos, TelefonosLada, TemaCRM, TieneMovimientos, Tipo, TipoRegistro, Titulo, UltimoCambio, Usuario, VigenciaDesde, VigenciaHasta, VtasConsignacion, wMovVentas, wVerArtListaPreciosEsp, wVerDisponible, Zona, ZonaImpuesto FROM Inserted Cuenta FOR XML AUTO)
ELSE
IF @SincronizarCRMD = 1
SELECT @Datos = @Datos + (SELECT ActividadEconomicaCNBV, Agente, Agente3, Agente4, AgenteServicio, Alergias, AlmacenDef, AlmacenVtasConsignacion, Alta, Aseguradora, BloquearMorosos, Bonificacion, BonificacionTipo, Categoria, CBDir, ChecarCredito, Clase, Cliente, Coaseguro, Cobrador, CodigoPostal, Colonia, Conciliar, Condicion, Contacto1, Contacto2, Contrasena, Contrasena2, Conyuge, Credito, CreditoConCondiciones, CreditoConDias, CreditoCondiciones, CreditoConLimite, CreditoConLimitePedidos, CreditoDias, CreditoEspecial, CreditoLimite, CreditoLimitePedidos, CreditoMoneda, CRMCantidad, CRMCierreFechaAprox, CRMCierreProbabilidad, CRMCompetencia, CRMEtapa, CRMFuente, CRMID, CRMImporte, CRMInfluencia, CRMovVenta, CRMPresupuestoAsignado, Cuenta, CuentaRetencion, CURP, Deducible, DeducibleMoneda, DefMoneda, Delegacion, Descripcion1, Descripcion10, Descripcion11, Descripcion12, Descripcion13, Descripcion14, Descripcion15, Descripcion16, Descripcion17, Descripcion18, Descripcion19, Descripcion2, Descripcion20, Descripcion3, Descripcion4, Descripcion5, Descripcion6, Descripcion7, Descripcion8, Descripcion9, Descuento, DescuentoRecargos, DiaPago1, DiaPago2, DiaRevision1, DiaRevision2, Direccion, DireccionNumero, DireccionNumeroInt, DirInternet, DocumentacionCompleta, EDICalificador, EDIIdentificador, eMail1, eMail2, eMailAuto, EntreCalles, EnviarA, EsAgente, EsAlmacen, EsCentroCostos, EsCentroTrabajo, EsEspacio, EsEstacionTrabajo, Espacio, EsPersonal, EsProveedor, EsProyecto, Estado, EstadoCivil, Estatura, Estatus, ExcentoISAN, ExpedienteFamiliar, Extencion1, Extencion2, Extranjero, FacturarCte, FacturarCteEnviarA, Familia, Fax, Fecha1, Fecha2, Fecha3, Fecha4, Fecha5, FechaMatrimonio, FechaNacimiento, FiscalRegimen, Flotilla, FordDistribuidor, FordZona, FormaEnvio, FormasPagoRestringidas, FueraLinea, Fuma, GLN, Grado, Grupo, GrupoSanguineo, GrupoSanguineoRH, HorarioPago, HorarioRevision, Idioma, IEPS, IFE, ImportadorRegimen, ImportadorRegistro, Intercompania, InterfacturaRI, Licencias, LicenciasLlave, LicenciasTipo, ListaPrecios, ListaPreciosEsp, LocalidadCNBV, MapaLatitud, MapaLongitud, MapaPrecision, Mensaje, ModificarVencimiento, NivelAcceso, Nombre, NombreAsegurado, NombreCorto, NoriticarATelefonos, NotificarA, Numero, NumeroHijos, Observaciones, OperacionLimite, OtrosCargos, Pais, Parentesco, Pasaporte, PedidoDef, PedidosParciales, PedirTono, PersonalApellidoMaterno, PersonalApellidoPaterno, PersonalCobrador, PersonalCodigoPostal, PersonalColonia, PersonalDelegacion, PersonalDireccion, PersonalEntreCalles, PersonalEstado, PersonalNombres, PersonalPais, PersonalPlano, PersonalPoblacion, PersonalSMS, PersonalTelefonoMovil, PersonalTelefonos, PersonalTelefonosLada, PersonalZona, Peso, PITEX, Plano, Poblacion, PolizaFechaEmision, PolizaImporte, PolizaNumero, PolizaReferencia, PolizaTipo, PolizaVencimiento, PreciosInferioresMinimo, PrimaryContactId, Profesion, ProveedorClave, ProveedorInfo, Proyecto, Publico, Puesto, Rama, RecorrerVencimiento, ReferenciaBancaria, Religion, Responsable, RFC, RPU, Ruta, RutaOrden, Sexo, SIC,
SincroC, SincroID, SIRAC, Situacion, SituacionFecha, SituacionNota, SituacionUsuario, SucursalEmpresa, Telefonos, TelefonosLada, TemaCRM, TieneMovimientos, Tipo, TipoRegistro, Titulo, UltimoCambio, Usuario, VigenciaDesde, VigenciaHasta, VtasConsignacion, wMovVentas, wVerArtListaPreciosEsp, wVerDisponible, Zona, ZonaImpuesto FROM Deleted Cuenta FOR XML AUTO)
SELECT @Datos = @Datos + '</' + @Accion + '></Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario, @Contrasena, @Datos, NULL, @Ok OUTPUT, @OkRef OUTPUT, 1, 0, @IDIS OUTPUT
RETURN
END

