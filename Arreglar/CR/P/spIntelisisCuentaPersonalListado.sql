SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisCuentaPersonalListado
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Personal			varchar(10),
@ApellidoPaterno	varchar(30),
@ApellidoMaterno	varchar(30),
@Nombre				varchar(30),
@Tipo				varchar(20),
@Direccion			varchar(100),
@DireccionNumero	varchar(20),
@DireccionNumeroInt varchar(20),
@Colonia			varchar(100),
@Delegacion			varchar(100),
@Poblacion			varchar(100),
@Estado				varchar(30),
@Pais				varchar(30),
@CodigoPostal		varchar(15),
@Telefono			varchar(50),
@eMail				varchar(50),
@eMailAuto			bit   ,
@ZonaEconomica		varchar(30),
@Registro			varchar(30),
@Registro2			varchar(30),
@Registro3			varchar(30),
@Registro4			varchar(30),
@FormaPago			varchar(50),
@CtaDinero			varchar(10),
@Afore				varchar(10),
@PersonalSucursal   varchar(50),
@PersonalCuenta		varchar(20),
@FechaNacimiento	datetime   ,
@LugarNacimiento	varchar(50),
@Nacionalidad		varchar(30),
@Pasaporte			varchar(30),
@Cartilla			varchar(30),
@Permiso			varchar(30),
@NivelAcademico		varchar(50),
@Sexo				varchar(10),
@EstadoCivil		varchar(20),
@Hijos				int   ,
@Dependientes		int   ,
@Beneficiario		varchar(50),
@BeneficiarioNacimiento   datetime   ,
@Parentesco			varchar(20),
@Porcentaje			float   ,
@Beneficiario2		varchar(50),
@Beneficiario2Nacimiento   datetime   ,
@Parentesco2		varchar(20),
@Porcentaje2		float   ,
@Beneficiario3		varchar(50),
@Beneficiario3Nacimiento   datetime   ,
@Parentesco3		varchar(20),
@Porcentaje3		float   ,
@Beneficiario4		varchar(50),
@Beneficiario4Nacimiento   datetime   ,
@Parentesco4		varchar(20),
@Porcentaje4		float   ,
@Beneficiario5		varchar(50),
@Beneficiario5Nacimiento   datetime   ,
@Parentesco5		varchar(20),
@Porcentaje5		float   ,
@Beneficiario6		varchar(50),
@Beneficiario6Nacimiento   datetime   ,
@Parentesco6		varchar(20),
@Porcentaje6		float   ,
@Beneficiario7		varchar(50),
@Beneficiario7Nacimiento   datetime   ,
@Parentesco7		varchar(20),
@Porcentaje7		float   ,
@Beneficiario8		varchar(50),
@Beneficiario8Nacimiento   datetime   ,
@Parentesco8		varchar(20),
@Porcentaje8		float   ,
@Valuacion			varchar(50),
@Padre				varchar(50),
@Madre				varchar(50),
@UnidadMedica		int   ,
@CentroCostos		varchar(20),
@ReportaA			varchar(10),
@AspiraSueldo		varchar(50),
@AspiraCategoria	varchar(50),
@AspiraDepartamento varchar(50),
@AspiraGrupo		varchar(50),
@AspiraPuesto		varchar(50),
@AspiraFecha		datetime   ,
@Categoria			varchar(50),
@Departamento		varchar(50),
@Grupo				varchar(50),
@Puesto				varchar(50),
@TipoContrato		varchar(50),
@PeriodoTipo		varchar(20),
@Jornada			varchar(20),
@TipoSueldo			varchar(10),
@Moneda				varchar(10),
@DiasPeriodo		varchar(20),
@SueldoDiario		money   ,
@SDI				money   ,
@SDIBimestral		money   ,
@SDIAnterior		money   ,
@SueldoDiarioComplemento   money   ,
@FechaAlta			datetime   ,
@FechaBaja			datetime   ,
@ConceptoBaja		varchar(50),
@FechaAntiguedad	datetime   ,
@UltimaModificacion datetime   ,
@UltimoPago			datetime   ,
@VencimientoContrato datetime   ,
@Estatus			varchar(15),
@UltimoCambio		datetime   ,
@Situacion			varchar(50),
@SituacionFecha		datetime   ,
@SituacionUsuario   varchar(10),
@SituacionNota		varchar(100),
@Logico1			bit   ,
@Logico2			bit   ,
@Logico3			bit   ,
@Logico4			bit   ,
@Logico5			bit   ,
@Logico6			bit   ,
@Logico7			bit   ,
@Logico8			bit   ,
@EstaPresente		bit   ,
@TieneMovimientos   bit   ,
@SucursalTrabajo	int   ,
@NivelAcceso		varchar(50),
@MinimoProfesional  int   ,
@Sindicato			varchar(50),
@Vehiculo			varchar(10),
@TablaCobranza		varchar(50),
@TablaCobranzaBono  varchar(50),
@TablaCobranzaCascada   varchar(50),
@TablaCobranzaBonoCascada   varchar(50),
@TablaVentaCascada  varchar(50),
@UEN				int   ,
@Actividad			varchar(100),
@Area				varchar(50),
@Fuente				varchar(50),
@Reclutador			varchar(10),
@RecomendadoPor		varchar(10),
@Cuenta				varchar(20),
@CuentaRetencion	varchar(20),
@MovNomina			varchar(20),
@Contrasena			varchar(100),
@Configuracion		varchar(50),
@Referencia			varchar(50),
@ReferenciaDireccion varchar(50),
@ReferenciaTelefono varchar(20),
@Referencia2		varchar(50),
@Referencia2Direccion   varchar(50),
@Referencia2Telefono   varchar(20),
@Referencia3		varchar(50),
@Referencia3Direccion   varchar(50),
@Referencia3Telefono varchar(20),
@Licencia			varchar(20),
@LicenciaVencimiento   datetime   ,
@Cliente			varchar(10),
@Incremento			float   ,
@EsSocio			bit   ,
@IndemnizacionPct   float   ,
@Proyecto			varchar(50),
@Plaza				varchar(20),
@Empresa			varchar(5),
@SueldoMensual		money   ,
@ISRFijoPeriodo		money   ,
@RataHora			money   ,
@DeclaraRenta		bit   ,
@EsRecurso			bit   ,
@EsAgente			bit   ,
@EsUsuarioWeb		bit   ,
@FechaInicioContrato   datetime   ,
@DuracionContrato   int   ,
@Confidencial		bit   ,
@EntreCalles		varchar(100),
@Plano				varchar(15),
@Observaciones		varchar(100),
@MapaLatitud		float   ,
@MapaLongitud		float   ,
@MapaPrecision		int   ,
@ActividadMedicion  varchar(50),
@SueldoDiarioAsimilable   money,
@Texto				xml,
@ReferenciaIS		varchar(100),
@SubReferencia		varchar(100)
SELECT  @Personal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Personal'
SELECT  @ApellidoPaterno = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ApellidoPaterno'
SELECT  @ApellidoMaterno = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ApellidoMaterno'
SELECT  @Nombre = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Nombre'
SELECT  @Tipo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tipo'
SELECT  @Direccion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Direccion'
SELECT  @DireccionNumero = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DireccionNumero'
SELECT  @DireccionNumeroInt = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DireccionNumeroInt'
SELECT  @Colonia = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Colonia'
SELECT  @Delegacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Delegacion'
SELECT  @Poblacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Poblacion'
SELECT  @Estado = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Estado'
SELECT  @Pais = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Pais'
SELECT  @CodigoPostal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CodigoPostal'
SELECT  @Telefono = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Telefono'
SELECT  @eMail = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'eMail'
SELECT  @eMailAuto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'eMailAuto'
SELECT  @ZonaEconomica = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ZonaEconomica'
SELECT  @Registro = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Registro'
SELECT  @Registro2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Registro2'
SELECT  @Registro3 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Registro3'
SELECT  @Registro4 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Registro4'
SELECT  @FormaPago = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'FormaPago'
SELECT  @CtaDinero = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CtaDinero'
SELECT  @Afore = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Afore'
SELECT  @PersonalSucursal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PersonalSucursal'
SELECT  @PersonalCuenta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PersonalCuenta'
SELECT  @FechaNacimiento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'FechaNacimiento'
SELECT  @LugarNacimiento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'LugarNacimiento'
SELECT  @Nacionalidad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Nacionalidad'
SELECT  @Pasaporte = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Pasaporte'
SELECT  @Cartilla = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Cartilla'
SELECT  @Permiso = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Permiso'
SELECT  @NivelAcademico = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'NivelAcademico'
SELECT  @Sexo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sexo'
SELECT  @EstadoCivil = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EstadoCivil'
SELECT  @Hijos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Hijos'
SELECT  @Dependientes = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Dependientes'
SELECT  @Beneficiario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Beneficiario'
SELECT  @BeneficiarioNacimiento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'BeneficiarioNacimiento'
SELECT  @Parentesco = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Parentesco'
SELECT  @Porcentaje = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Porcentaje'
SELECT  @Beneficiario2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Beneficiario2'
SELECT  @Beneficiario2Nacimiento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Beneficiario2Nacimiento'
SELECT  @Parentesco2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Parentesco2'
SELECT  @Porcentaje2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Porcentaje2'
SELECT  @Beneficiario3 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Beneficiario3'
SELECT  @Beneficiario3Nacimiento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Beneficiario3Nacimiento'
SELECT  @Parentesco3 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Parentesco3'
SELECT  @Porcentaje3 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Porcentaje3'
SELECT  @Beneficiario4 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Beneficiario4'
SELECT  @Beneficiario4Nacimiento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Beneficiario4Nacimiento'
SELECT  @Parentesco4 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Parentesco4'
SELECT  @Porcentaje4 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Porcentaje4'
SELECT  @Beneficiario5 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Beneficiario5'
SELECT  @Beneficiario5Nacimiento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Beneficiario5Nacimiento'
SELECT  @Parentesco5 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Parentesco5'
SELECT  @Porcentaje5 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Porcentaje5'
SELECT  @Beneficiario6 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Beneficiario6'
SELECT  @Beneficiario6Nacimiento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Beneficiario6Nacimiento'
SELECT  @Parentesco6 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Parentesco6'
SELECT  @Porcentaje6 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Porcentaje6'
SELECT  @Beneficiario7 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Beneficiario7'
SELECT  @Beneficiario7Nacimiento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Beneficiario7Nacimiento'
SELECT  @Parentesco7 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Parentesco7'
SELECT  @Porcentaje7 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Porcentaje7'
SELECT  @Beneficiario8 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Beneficiario8'
SELECT  @Beneficiario8Nacimiento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Beneficiario8Nacimiento'
SELECT  @Parentesco8 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Parentesco8'
SELECT  @Porcentaje8 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Porcentaje8'
SELECT  @Valuacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Valuacion'
SELECT  @Padre = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Padre'
SELECT  @Madre = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Madre'
SELECT  @UnidadMedica = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'UnidadMedica'
SELECT  @CentroCostos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CentroCostos'
SELECT  @ReportaA = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ReportaA'
SELECT  @AspiraSueldo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AspiraSueldo'
SELECT  @AspiraCategoria = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AspiraCategoria'
SELECT  @AspiraDepartamento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AspiraDepartamento'
SELECT  @AspiraGrupo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AspiraGrupo'
SELECT  @AspiraPuesto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AspiraPuesto'
SELECT  @AspiraFecha = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AspiraFecha'
SELECT  @Categoria = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Categoria'
SELECT  @Departamento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Departamento'
SELECT  @Grupo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Grupo'
SELECT  @Puesto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Puesto'
SELECT  @TipoContrato = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TipoContrato'
SELECT  @PeriodoTipo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PeriodoTipo'
SELECT  @Jornada = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Jornada'
SELECT  @TipoSueldo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TipoSueldo'
SELECT  @Moneda = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Moneda'
SELECT  @DiasPeriodo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DiasPeriodo'
SELECT  @SueldoDiario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SueldoDiario'
SELECT  @SDI = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SDI'
SELECT  @SDIBimestral = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SDIBimestral'
SELECT  @SDIAnterior = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SDIAnterior'
SELECT  @SueldoDiarioComplemento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SueldoDiarioComplemento'
SELECT  @FechaAlta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'FechaAlta'
SELECT  @FechaBaja = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'FechaBaja'
SELECT  @ConceptoBaja = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ConceptoBaja'
SELECT  @FechaAntiguedad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'FechaAntiguedad'
SELECT  @UltimaModificacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'UltimaModificacion'
SELECT  @UltimoPago = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'UltimoPago'
SELECT  @VencimientoContrato = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'VencimientoContrato'
SELECT  @Estatus = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Estatus'
SELECT  @UltimoCambio = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'UltimoCambio'
SELECT  @Situacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Situacion'
SELECT  @SituacionFecha = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SituacionFecha'
SELECT  @SituacionUsuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SituacionUsuario'
SELECT  @SituacionNota = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SituacionNota'
SELECT  @Logico1 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Logico1'
SELECT  @Logico2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Logico2'
SELECT  @Logico3 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Logico3'
SELECT  @Logico4 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Logico4'
SELECT  @Logico5 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Logico5'
SELECT  @Logico6 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Logico6'
SELECT  @Logico7 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Logico7'
SELECT  @Logico8 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Logico8'
SELECT  @EstaPresente = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EstaPresente'
SELECT  @TieneMovimientos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TieneMovimientos'
SELECT  @SucursalTrabajo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SucursalTrabajo'
SELECT  @NivelAcceso = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'NivelAcceso'
SELECT  @MinimoProfesional = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MinimoProfesional'
SELECT  @Sindicato = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sindicato'
SELECT  @Vehiculo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Vehiculo'
SELECT  @TablaCobranza = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TablaCobranza'
SELECT  @TablaCobranzaBono = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TablaCobranzaBono'
SELECT  @TablaCobranzaCascada = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TablaCobranzaCascada'
SELECT  @TablaCobranzaBonoCascada = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TablaCobranzaBonoCascada'
SELECT  @TablaVentaCascada = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TablaVentaCascada'
SELECT  @UEN = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'UEN'
SELECT  @Actividad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Actividad'
SELECT  @Area = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Area'
SELECT  @Fuente = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Fuente'
SELECT  @Reclutador = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Reclutador'
SELECT  @RecomendadoPor = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'RecomendadoPor'
SELECT  @Cuenta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Cuenta'
SELECT  @CuentaRetencion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CuentaRetencion'
SELECT  @MovNomina = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MovNomina'
SELECT  @Contrasena = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Contrasena'
SELECT  @Configuracion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Configuracion'
SELECT  @Referencia = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Referencia'
SELECT  @ReferenciaDireccion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ReferenciaDireccion'
SELECT  @ReferenciaTelefono = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ReferenciaTelefono'
SELECT  @Referencia2 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Referencia2'
SELECT  @Referencia2Direccion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Referencia2Direccion'
SELECT  @Referencia2Telefono = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Referencia2Telefono'
SELECT  @Referencia3 = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Referencia3'
SELECT  @Referencia3Direccion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Referencia3Direccion'
SELECT  @Referencia3Telefono = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Referencia3Telefono'
SELECT  @Licencia = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Licencia'
SELECT  @LicenciaVencimiento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'LicenciaVencimiento'
SELECT  @Cliente = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Cliente'
SELECT  @Incremento = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Incremento'
SELECT  @EsSocio = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EsSocio'
SELECT  @IndemnizacionPct = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'IndemnizacionPct'
SELECT  @Proyecto = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Proyecto'
SELECT  @Plaza = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Plaza'
SELECT  @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT  @SueldoMensual = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SueldoMensual'
SELECT  @ISRFijoPeriodo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ISRFijoPeriodo'
SELECT  @RataHora = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'RataHora'
SELECT  @DeclaraRenta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DeclaraRenta'
SELECT  @EsRecurso = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EsRecurso'
SELECT  @EsAgente = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EsAgente'
SELECT  @EsUsuarioWeb = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EsUsuarioWeb'
SELECT  @FechaInicioContrato = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'FechaInicioContrato'
SELECT  @DuracionContrato = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'DuracionContrato'
SELECT  @Confidencial = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Confidencial'
SELECT  @EntreCalles = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EntreCalles'
SELECT  @Plano = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Plano'
SELECT  @Observaciones = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Observaciones'
SELECT  @MapaLatitud = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MapaLatitud'
SELECT  @MapaLongitud = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MapaLongitud'
SELECT  @MapaPrecision = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MapaPrecision'
SELECT  @ActividadMedicion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ActividadMedicion'
SELECT  @SueldoDiarioAsimilable = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SueldoDiarioAsimilablable'
SELECT @Texto =(SELECT * FROM Personal
WHERE ISNULL(Personal,'') = ISNULL(ISNULL(@Personal,Personal),'')
AND ISNULL(ApellidoPaterno,'') = ISNULL(ISNULL(@ApellidoPaterno,ApellidoPaterno),'')
AND ISNULL(ApellidoMaterno,'') = ISNULL(ISNULL(@ApellidoMaterno,ApellidoMaterno),'')
AND ISNULL(Nombre,'') = ISNULL(ISNULL(@Nombre,Nombre),'')
AND ISNULL(Tipo,'') = ISNULL(ISNULL(@Tipo,Tipo),'')
AND ISNULL(Direccion,'') = ISNULL(ISNULL(@Direccion,Direccion),'')
AND ISNULL(DireccionNumero,'') = ISNULL(ISNULL(@DireccionNumero,DireccionNumero),'')
AND ISNULL(DireccionNumeroInt,'') = ISNULL(ISNULL(@DireccionNumeroInt,DireccionNumeroInt),'')
AND ISNULL(Colonia,'') = ISNULL(ISNULL(@Colonia,Colonia),'')
AND ISNULL(Delegacion,'') = ISNULL(ISNULL(@Delegacion,Delegacion),'')
AND ISNULL(Poblacion,'') = ISNULL(ISNULL(@Poblacion,Poblacion),'')
AND ISNULL(Estado,'') = ISNULL(ISNULL(@Estado,Estado),'')
AND ISNULL(Pais,'') = ISNULL(ISNULL(@Pais,Pais),'')
AND ISNULL(CodigoPostal,'') = ISNULL(ISNULL(@CodigoPostal,CodigoPostal),'')
AND ISNULL(Telefono,'') = ISNULL(ISNULL(@Telefono,Telefono),'')
AND ISNULL(eMail,'') = ISNULL(ISNULL(@eMail,eMail),'')
AND ISNULL(eMailAuto,'') = ISNULL(ISNULL(@eMailAuto,eMailAuto),'')
AND ISNULL(ZonaEconomica,'') = ISNULL(ISNULL(@ZonaEconomica,ZonaEconomica),'')
AND ISNULL(Registro,'') = ISNULL(ISNULL(@Registro,Registro),'')
AND ISNULL(Registro2,'') = ISNULL(ISNULL(@Registro2,Registro2),'')
AND ISNULL(Registro3,'') = ISNULL(ISNULL(@Registro3,Registro3),'')
AND ISNULL(Registro4,'') = ISNULL(ISNULL(@Registro4,Registro4),'')
AND ISNULL(FormaPago,'') = ISNULL(ISNULL(@FormaPago,FormaPago),'')
AND ISNULL(CtaDinero,'') = ISNULL(ISNULL(@CtaDinero,CtaDinero),'')
AND ISNULL(Afore,'') = ISNULL(ISNULL(@Afore,Afore),'')
AND ISNULL(PersonalSucursal,'') = ISNULL(ISNULL(@PersonalSucursal,PersonalSucursal),'')
AND ISNULL(PersonalCuenta,'') = ISNULL(ISNULL(@PersonalCuenta,PersonalCuenta),'')
AND ISNULL(FechaNacimiento,'') = ISNULL(ISNULL(@FechaNacimiento,FechaNacimiento),'')
AND ISNULL(LugarNacimiento,'') = ISNULL(ISNULL(@LugarNacimiento,LugarNacimiento),'')
AND ISNULL(Nacionalidad,'') = ISNULL(ISNULL(@Nacionalidad,Nacionalidad),'')
AND ISNULL(Pasaporte,'') = ISNULL(ISNULL(@Pasaporte,Pasaporte),'')
AND ISNULL(Cartilla,'') = ISNULL(ISNULL(@Cartilla,Cartilla),'')
AND ISNULL(Permiso,'') = ISNULL(ISNULL(@Permiso,Permiso),'')
AND ISNULL(NivelAcademico,'') = ISNULL(ISNULL(@NivelAcademico,NivelAcademico),'')
AND ISNULL(Sexo,'') = ISNULL(ISNULL(@Sexo,Sexo),'')
AND ISNULL(EstadoCivil,'') = ISNULL(ISNULL(@EstadoCivil,EstadoCivil),'')
AND ISNULL(Hijos,'') = ISNULL(ISNULL(@Hijos,Hijos),'')
AND ISNULL(Dependientes,'') = ISNULL(ISNULL(@Dependientes,Dependientes),'')
AND ISNULL(Beneficiario,'') = ISNULL(ISNULL(@Beneficiario,Beneficiario),'')
AND ISNULL(BeneficiarioNacimiento,'') = ISNULL(ISNULL(@BeneficiarioNacimiento,BeneficiarioNacimiento),'')
AND ISNULL(Parentesco,'') = ISNULL(ISNULL(@Parentesco,Parentesco),'')
AND ISNULL(Porcentaje,'') = ISNULL(ISNULL(@Porcentaje,Porcentaje),'')
AND ISNULL(Beneficiario2,'') = ISNULL(ISNULL(@Beneficiario2,Beneficiario2),'')
AND ISNULL(Beneficiario2Nacimiento,'') = ISNULL(ISNULL(@Beneficiario2Nacimiento,Beneficiario2Nacimiento),'')
AND ISNULL(Parentesco2,'') = ISNULL(ISNULL(@Parentesco2,Parentesco2),'')
AND ISNULL(Porcentaje2,'') = ISNULL(ISNULL(@Porcentaje2,Porcentaje2),'')
AND ISNULL(Beneficiario3,'') = ISNULL(ISNULL(@Beneficiario3,Beneficiario3),'')
AND ISNULL(Beneficiario3Nacimiento,'') = ISNULL(ISNULL(@Beneficiario3Nacimiento,Beneficiario3Nacimiento),'')
AND ISNULL(Parentesco3,'') = ISNULL(ISNULL(@Parentesco3,Parentesco3),'')
AND ISNULL(Porcentaje3,'') = ISNULL(ISNULL(@Porcentaje3,Porcentaje3),'')
AND ISNULL(Beneficiario4,'') = ISNULL(ISNULL(@Beneficiario4,Beneficiario4),'')
AND ISNULL(Beneficiario4Nacimiento,'') = ISNULL(ISNULL(@Beneficiario4Nacimiento,Beneficiario4Nacimiento),'')
AND ISNULL(Parentesco4,'') = ISNULL(ISNULL(@Parentesco4,Parentesco4),'')
AND ISNULL(Porcentaje4,'') = ISNULL(ISNULL(@Porcentaje4,Porcentaje4),'')
AND ISNULL(Beneficiario5,'') = ISNULL(ISNULL(@Beneficiario5,Beneficiario5),'')
AND ISNULL(Beneficiario5Nacimiento,'') = ISNULL(ISNULL(@Beneficiario5Nacimiento,Beneficiario5Nacimiento),'')
AND ISNULL(Parentesco5,'') = ISNULL(ISNULL(@Parentesco5,Parentesco5),'')
AND ISNULL(Porcentaje5,'') = ISNULL(ISNULL(@Porcentaje5,Porcentaje5),'')
AND ISNULL(Beneficiario6,'') = ISNULL(ISNULL(@Beneficiario6,Beneficiario6),'')
AND ISNULL(Beneficiario6Nacimiento,'') = ISNULL(ISNULL(@Beneficiario6Nacimiento,Beneficiario6Nacimiento),'')
AND ISNULL(Parentesco6,'') = ISNULL(ISNULL(@Parentesco6,Parentesco6),'')
AND ISNULL(Porcentaje6,'') = ISNULL(ISNULL(@Porcentaje6,Porcentaje6),'')
AND ISNULL(Beneficiario7,'') = ISNULL(ISNULL(@Beneficiario7,Beneficiario7),'')
AND ISNULL(Beneficiario7Nacimiento,'') = ISNULL(ISNULL(@Beneficiario7Nacimiento,Beneficiario7Nacimiento),'')
AND ISNULL(Parentesco7,'') = ISNULL(ISNULL(@Parentesco7,Parentesco7),'')
AND ISNULL(Porcentaje7,'') = ISNULL(ISNULL(@Porcentaje7,Porcentaje7),'')
AND ISNULL(Beneficiario8,'') = ISNULL(ISNULL(@Beneficiario8,Beneficiario8),'')
AND ISNULL(Beneficiario8Nacimiento,'') = ISNULL(ISNULL(@Beneficiario8Nacimiento,Beneficiario8Nacimiento),'')
AND ISNULL(Parentesco8,'') = ISNULL(ISNULL(@Parentesco8,Parentesco8),'')
AND ISNULL(Porcentaje8,'') = ISNULL(ISNULL(@Porcentaje8,Porcentaje8),'')
AND ISNULL(Valuacion,'') = ISNULL(ISNULL(@Valuacion,Valuacion),'')
AND ISNULL(Padre,'') = ISNULL(ISNULL(@Padre,Padre),'')
AND ISNULL(Madre,'') = ISNULL(ISNULL(@Madre,Madre),'')
AND ISNULL(UnidadMedica,'') = ISNULL(ISNULL(@UnidadMedica,UnidadMedica),'')
AND ISNULL(CentroCostos,'') = ISNULL(ISNULL(@CentroCostos,CentroCostos),'')
AND ISNULL(ReportaA,'') = ISNULL(ISNULL(@ReportaA,ReportaA),'')
AND ISNULL(AspiraSueldo,'') = ISNULL(ISNULL(@AspiraSueldo,AspiraSueldo),'')
AND ISNULL(AspiraCategoria,'') = ISNULL(ISNULL(@AspiraCategoria,AspiraCategoria),'')
AND ISNULL(AspiraDepartamento,'') = ISNULL(ISNULL(@AspiraDepartamento,AspiraDepartamento),'')
AND ISNULL(AspiraGrupo,'') = ISNULL(ISNULL(@AspiraGrupo,AspiraGrupo),'')
AND ISNULL(AspiraPuesto,'') = ISNULL(ISNULL(@AspiraPuesto,AspiraPuesto),'')
AND ISNULL(AspiraFecha,'') = ISNULL(ISNULL(@AspiraFecha,AspiraFecha),'')
AND ISNULL(Categoria,'') = ISNULL(ISNULL(@Categoria,Categoria),'')
AND ISNULL(Departamento,'') = ISNULL(ISNULL(@Departamento,Departamento),'')
AND ISNULL(Grupo,'') = ISNULL(ISNULL(@Grupo,Grupo),'')
AND ISNULL(Puesto,'') = ISNULL(ISNULL(@Puesto,Puesto),'')
AND ISNULL(TipoContrato,'') = ISNULL(ISNULL(@TipoContrato,TipoContrato),'')
AND ISNULL(PeriodoTipo,'') = ISNULL(ISNULL(@PeriodoTipo,PeriodoTipo),'')
AND ISNULL(Jornada,'') = ISNULL(ISNULL(@Jornada,Jornada),'')
AND ISNULL(TipoSueldo,'') = ISNULL(ISNULL(@TipoSueldo,TipoSueldo),'')
AND ISNULL(Moneda,'') = ISNULL(ISNULL(@Moneda,Moneda),'')
AND ISNULL(DiasPeriodo,'') = ISNULL(ISNULL(@DiasPeriodo,DiasPeriodo),'')
AND ISNULL(SueldoDiario,'') = ISNULL(ISNULL(@SueldoDiario,SueldoDiario),'')
AND ISNULL(SDI,'') = ISNULL(ISNULL(@SDI,SDI),'')
AND ISNULL(SDIBimestral,'') = ISNULL(ISNULL(@SDIBimestral,SDIBimestral),'')
AND ISNULL(SDIAnterior,'') = ISNULL(ISNULL(@SDIAnterior,SDIAnterior),'')
AND ISNULL(SueldoDiarioComplemento,'') = ISNULL(ISNULL(@SueldoDiarioComplemento,SueldoDiarioComplemento),'')
AND ISNULL(FechaAlta,'') = ISNULL(ISNULL(@FechaAlta,FechaAlta),'')
AND ISNULL(FechaBaja,'') = ISNULL(ISNULL(@FechaBaja,FechaBaja),'')
AND ISNULL(ConceptoBaja,'') = ISNULL(ISNULL(@ConceptoBaja,ConceptoBaja),'')
AND ISNULL(FechaAntiguedad,'') = ISNULL(ISNULL(@FechaAntiguedad,FechaAntiguedad),'')
AND ISNULL(UltimaModificacion,'') = ISNULL(ISNULL(@UltimaModificacion,UltimaModificacion),'')
AND ISNULL(UltimoPago,'') = ISNULL(ISNULL(@UltimoPago,UltimoPago),'')
AND ISNULL(VencimientoContrato,'') = ISNULL(ISNULL(@VencimientoContrato,VencimientoContrato),'')
AND ISNULL(Estatus,'') = ISNULL(ISNULL(@Estatus,Estatus),'')
AND ISNULL(UltimoCambio,'') = ISNULL(ISNULL(@UltimoCambio,UltimoCambio),'')
AND ISNULL(Situacion,'') = ISNULL(ISNULL(@Situacion,Situacion),'')
AND ISNULL(SituacionFecha,'') = ISNULL(ISNULL(@SituacionFecha,SituacionFecha),'')
AND ISNULL(SituacionUsuario,'') = ISNULL(ISNULL(@SituacionUsuario,SituacionUsuario),'')
AND ISNULL(SituacionNota,'') = ISNULL(ISNULL(@SituacionNota,SituacionNota),'')
AND ISNULL(Logico1,'') = ISNULL(ISNULL(@Logico1,Logico1),'')
AND ISNULL(Logico2,'') = ISNULL(ISNULL(@Logico2,Logico2),'')
AND ISNULL(Logico3,'') = ISNULL(ISNULL(@Logico3,Logico3),'')
AND ISNULL(Logico4,'') = ISNULL(ISNULL(@Logico4,Logico4),'')
AND ISNULL(Logico5,'') = ISNULL(ISNULL(@Logico5,Logico5),'')
AND ISNULL(Logico6,'') = ISNULL(ISNULL(@Logico6,Logico6),'')
AND ISNULL(Logico7,'') = ISNULL(ISNULL(@Logico7,Logico7),'')
AND ISNULL(Logico8,'') = ISNULL(ISNULL(@Logico8,Logico8),'')
AND ISNULL(EstaPresente,'') = ISNULL(ISNULL(@EstaPresente,EstaPresente),'')
AND ISNULL(TieneMovimientos,'') = ISNULL(ISNULL(@TieneMovimientos,TieneMovimientos),'')
AND ISNULL(SucursalTrabajo,'') = ISNULL(ISNULL(@SucursalTrabajo,SucursalTrabajo),'')
AND ISNULL(NivelAcceso,'') = ISNULL(ISNULL(@NivelAcceso,NivelAcceso),'')
AND ISNULL(MinimoProfesional,'') = ISNULL(ISNULL(@MinimoProfesional,MinimoProfesional),'')
AND ISNULL(Sindicato,'') = ISNULL(ISNULL(@Sindicato,Sindicato),'')
AND ISNULL(Vehiculo,'') = ISNULL(ISNULL(@Vehiculo,Vehiculo),'')
AND ISNULL(TablaCobranza,'') = ISNULL(ISNULL(@TablaCobranza,TablaCobranza),'')
AND ISNULL(TablaCobranzaBono,'') = ISNULL(ISNULL(@TablaCobranzaBono,TablaCobranzaBono),'')
AND ISNULL(TablaCobranzaCascada,'') = ISNULL(ISNULL(@TablaCobranzaCascada,TablaCobranzaCascada),'')
AND ISNULL(TablaCobranzaBonoCascada,'') = ISNULL(ISNULL(@TablaCobranzaBonoCascada,TablaCobranzaBonoCascada),'')
AND ISNULL(TablaVentaCascada,'') = ISNULL(ISNULL(@TablaVentaCascada,TablaVentaCascada),'')
AND ISNULL(UEN,'') = ISNULL(ISNULL(@UEN,UEN),'')
AND ISNULL(Actividad,'') = ISNULL(ISNULL(@Actividad,Actividad),'')
AND ISNULL(Area,'') = ISNULL(ISNULL(@Area,Area),'')
AND ISNULL(Fuente,'') = ISNULL(ISNULL(@Fuente,Fuente),'')
AND ISNULL(Reclutador,'') = ISNULL(ISNULL(@Reclutador,Reclutador),'')
AND ISNULL(RecomendadoPor,'') = ISNULL(ISNULL(@RecomendadoPor,RecomendadoPor),'')
AND ISNULL(Cuenta,'') = ISNULL(ISNULL(@Cuenta,Cuenta),'')
AND ISNULL(CuentaRetencion,'') = ISNULL(ISNULL(@CuentaRetencion,CuentaRetencion),'')
AND ISNULL(MovNomina,'') = ISNULL(ISNULL(@MovNomina,MovNomina),'')
AND ISNULL(Contrasena,'') = ISNULL(ISNULL(@Contrasena,Contrasena),'')
AND ISNULL(Configuracion,'') = ISNULL(ISNULL(@Configuracion,Configuracion),'')
AND ISNULL(Referencia,'') = ISNULL(ISNULL(@Referencia,Referencia),'')
AND ISNULL(ReferenciaDireccion,'') = ISNULL(ISNULL(@ReferenciaDireccion,ReferenciaDireccion),'')
AND ISNULL(ReferenciaTelefono,'') = ISNULL(ISNULL(@ReferenciaTelefono,ReferenciaTelefono),'')
AND ISNULL(Referencia2,'') = ISNULL(ISNULL(@Referencia2,Referencia2),'')
AND ISNULL(Referencia2Direccion,'') = ISNULL(ISNULL(@Referencia2Direccion,Referencia2Direccion),'')
AND ISNULL(Referencia2Telefono,'') = ISNULL(ISNULL(@Referencia2Telefono,Referencia2Telefono),'')
AND ISNULL(Referencia3,'') = ISNULL(ISNULL(@Referencia3,Referencia3),'')
AND ISNULL(Referencia3Direccion,'') = ISNULL(ISNULL(@Referencia3Direccion,Referencia3Direccion),'')
AND ISNULL(Referencia3Telefono,'') = ISNULL(ISNULL(@Referencia3Telefono,Referencia3Telefono),'')
AND ISNULL(Licencia,'') = ISNULL(ISNULL(@Licencia,Licencia),'')
AND ISNULL(LicenciaVencimiento,'') = ISNULL(ISNULL(@LicenciaVencimiento,LicenciaVencimiento),'')
AND ISNULL(Cliente,'') = ISNULL(ISNULL(@Cliente,Cliente),'')
AND ISNULL(Incremento,'') = ISNULL(ISNULL(@Incremento,Incremento),'')
AND ISNULL(EsSocio,'') = ISNULL(ISNULL(@EsSocio,EsSocio),'')
AND ISNULL(IndemnizacionPct,'') = ISNULL(ISNULL(@IndemnizacionPct,IndemnizacionPct),'')
AND ISNULL(Proyecto,'') = ISNULL(ISNULL(@Proyecto,Proyecto),'')
AND ISNULL(Plaza,'') = ISNULL(ISNULL(@Plaza,Plaza),'')
AND ISNULL(Empresa,'') = ISNULL(ISNULL(@Empresa,Empresa),'')
AND ISNULL(SueldoMensual,'') = ISNULL(ISNULL(@SueldoMensual,SueldoMensual),'')
AND ISNULL(ISRFijoPeriodo,'') = ISNULL(ISNULL(@ISRFijoPeriodo,ISRFijoPeriodo),'')
AND ISNULL(RataHora,'') = ISNULL(ISNULL(@RataHora,RataHora),'')
AND ISNULL(DeclaraRenta,'') = ISNULL(ISNULL(@DeclaraRenta,DeclaraRenta),'')
AND ISNULL(EsRecurso,'') = ISNULL(ISNULL(@EsRecurso,EsRecurso),'')
AND ISNULL(EsAgente,'') = ISNULL(ISNULL(@EsAgente,EsAgente),'')
AND ISNULL(EsUsuarioWeb,'') = ISNULL(ISNULL(@EsUsuarioWeb,EsUsuarioWeb),'')
AND ISNULL(FechaInicioContrato,'') = ISNULL(ISNULL(@FechaInicioContrato,FechaInicioContrato),'')
AND ISNULL(DuracionContrato,'') = ISNULL(ISNULL(@DuracionContrato,DuracionContrato),'')
AND ISNULL(Confidencial,'') = ISNULL(ISNULL(@Confidencial,Confidencial),'')
AND ISNULL(EntreCalles,'') = ISNULL(ISNULL(@EntreCalles,EntreCalles),'')
AND ISNULL(Plano,'') = ISNULL(ISNULL(@Plano,Plano),'')
AND ISNULL(Observaciones,'') = ISNULL(ISNULL(@Observaciones,Observaciones),'')
AND ISNULL(MapaLatitud,'') = ISNULL(ISNULL(@MapaLatitud,MapaLatitud),'')
AND ISNULL(MapaLongitud,'') = ISNULL(ISNULL(@MapaLongitud,MapaLongitud),'')
AND ISNULL(MapaPrecision,'') = ISNULL(ISNULL(@MapaPrecision,MapaPrecision),'')
AND ISNULL(ActividadMedicion,'') = ISNULL(ISNULL(@ActividadMedicion,ActividadMedicion),'')
AND ISNULL(SueldoDiarioAsimilable,'') = ISNULL(ISNULL(@SueldoDiarioAsimilable,SueldoDiarioAsimilable),'')
FOR XML AUTO)
IF @@ERROR <> 0 SET @Ok = 1
BEGIN
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max),@Texto) + '</Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
END
END
END

