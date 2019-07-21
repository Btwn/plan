SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNOIImportarPersonal
@Empresa        varchar(5),
@TablaPeriodo	varchar(10),
@Estacion       int,
@FechaA         datetime

AS BEGIN
DECLARE
@Sucursal             int,
@SQL			varchar(MAX),
@SQL2			varchar(MAX),
@SQL3			varchar(MAX),
@BaseNOI	        varchar(255),
@EmpresaNOI           varchar(2),
@Personal             varchar(10),
@Nombre               varchar(30),
@ApellidoPaterno      varchar(30),
@ApellidoMaterno      varchar(30),
@Estatus              varchar(15),
@Registro2            varchar(30),
@Departamento         varchar(50),
@Puesto               varchar(50),
@Registro3            varchar(30),
@FechaAlta            datetime   ,
@FechaBaja            datetime   ,
@FormaPago            varchar(50),
@SueldoDiario         money   ,
@SDI                  money   ,
@TipoSueldo           varchar(10),
@Direccion            varchar(100),
@Colonia              varchar(100),
@Poblacion            varchar(100),
@Estado               varchar(30),
@CodigoPostal         varchar(15),
@CtaDinero            varchar(10),
@PersonalCuenta       varchar(20),
@LugarNacimiento      varchar(50),
@Tipo                 varchar(20),
@TipoContrato         varchar(50),
@EstadoCivil          varchar(20),
@UnidadMedica         int   ,
@Padre                varchar(50),
@Madre                varchar(50),
@Telefono             varchar(50),
@Sexo                 varchar(10),
@FechaNacimiento      datetime   ,
@Registro             varchar(30),
@Email                varchar(50),
@Jornada              varchar(20),
@ZonaEconomica        varchar(20),
@PeriodoTipo          varchar(20),
@Moneda               varchar(10),
@Ok           	int,
@OkRef              	varchar(255),
@Verificado           bit,
@FechaUltimoPago      datetime,
@FechaD               datetime
SELECT @BaseNOI = '['+Servidor +'].'+BaseDatosNombre,@EmpresaNOI = EmpresaAspel ,@Sucursal = SucursalIntelisis
FROM InterfaseAspel WHERE SistemaAspel = 'NOI' AND Empresa = @Empresa
SELECT @PeriodoTipo = TipoPeriodo,@Moneda = Moneda,@CtaDinero = CtaDinero
FROM InterfaseAspelNOI WHERE Empresa = @Empresa
SELECT @ZonaEconomica = ZonaEconomica FROM Sucursal WHERE Sucursal = @Sucursal
DECLARE
@Tabla table(
Personal  varchar(10), Nombre  varchar(30), ApellidoPaterno  varchar(30), ApellidoMaterno  varchar(30), Estatus  varchar(15), Registro2  varchar(30), Departamento  varchar(50), Puesto  varchar(50), Registro3  varchar(30), FechaAlta  datetime, FechaBaja  datetime, FormaPago  varchar(50), SueldoDiario  money, SDI  money, TipoSueldo  varchar(10), Direccion  varchar(100), Colonia  varchar(100), Poblacion  varchar(100), Estado  varchar(30), CodigoPostal  varchar(15), CtaDinero  varchar(10), PersonalCuenta  varchar(20), LugarNacimiento  varchar(50), Tipo  varchar(20), TipoContrato  varchar(50), EstadoCivil  varchar(20), UnidadMedica  int, Padre  varchar(50), Madre  varchar(50), Telefono  varchar(50), Sexo  varchar(10), FechaNacimiento  datetime, Registro  varchar(30), Email  varchar(50), Jornada  varchar(20))
DECLARE
@Deptos table(
Departamento  varchar(50),
Clave         int
)
DECLARE
@Puestos table(
Puesto        varchar(50),
Clave         int
)
IF EXISTS (SELECT * FROM NOIPersonal WHERE EmpresaNOI = @EmpresaNOI AND Nomina = @TablaPeriodo AND Estacion = @Estacion)
DELETE NOIPersonal WHERE EmpresaNOI = @EmpresaNOI AND Nomina = @TablaPeriodo AND Estacion = @Estacion
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON
SELECT @SQL = '  SELECT RTRIM(LTRIM(CLAVE)),NOMBRE,AP_PAT_,AP_MAT_,STATUS,R_F_C_,DEPTO,PUESTO,IMSS,FECH_ALTA,FECH_BAJA,FORM_PAGO,SAL_DIARIO,SDI,TIP_SAL,CALLE,COLONIA,CD_POBLAC,ENT_FED,COD_POST,BANC_NOM,CTACHEQNOM,LUG_NACIM,TIP_EMPL,CONTRATO,EDO_CIVIL,UN_MED_FAM,NOM_PADRE,NOM_MADRE,TELEFONO,SEXO,FECH_NACIM,CURP,EMAIL,TIPOJORNADA
FROM ' + @BaseNOI + '.dbo.TB' + @TablaPeriodo+@EmpresaNOI
INSERT @Tabla(Personal, Nombre, ApellidoPaterno, ApellidoMaterno, Estatus, Registro2, Departamento, Puesto, Registro3, FechaAlta, FechaBaja, FormaPago, SueldoDiario, SDI, TipoSueldo, Direccion, Colonia, Poblacion, Estado, CodigoPostal, CtaDinero, PersonalCuenta, LugarNacimiento, Tipo, TipoContrato, EstadoCivil, UnidadMedica, Padre, Madre, Telefono, Sexo, FechaNacimiento, Registro, Email, Jornada)
EXEC (@SQL)
SELECT @SQL2 = 'SELECT RTRIM(LTRIM(CLAVE)),NULLIF(NOMBRE,'+CHAR(39)+''+CHAR(39)+')
FROM ' + @BaseNOI + '.dbo.DEPTOS' + @EmpresaNOI
INSERT @Deptos (Clave,Departamento)
EXEC (@SQL2)
SELECT @SQL3 = 'SELECT RTRIM(LTRIM(CLAVE)),NULLIF(NOMBRE,'+CHAR(39)+''+CHAR(39)+')
FROM ' + @BaseNOI + '.dbo.PUESTOS' + @EmpresaNOI
INSERT @Puestos(Clave,Puesto)
EXEC (@SQL3)
DECLARE crDetalle CURSOR FOR
SELECT   RTRIM(LTRIM(a.Personal)), a.Nombre, a.ApellidoPaterno, a.ApellidoMaterno, CASE WHEN a.Estatus = 'A' THEN 'ALTA' WHEN a.Estatus ='B' THEN 'BAJA' ELSE NULL END, a.Registro2, d.Departamento, p.Puesto, a.Registro3, a.FechaAlta, a.FechaBaja, f.FormaPago, a.SueldoDiario, a.SDI,
CASE WHEN a.TipoSueldo = 'F' THEN 'Fijo' WHEN a.TipoSueldo = 'V' THEN 'Variable' WHEN a.TipoSueldo = 'M' THEN 'Mixto' ELSE NULL END
, a.Direccion, a.Colonia, a.Poblacion, cp.Estado, a.CodigoPostal, a.PersonalCuenta, pp.Estado, te.Tipo,
CASE WHEN a.TipoContrato = 'P' THEN 'Permanente' WHEN a.TipoContrato = 'E' THEN 'Eventual' WHEN a.TipoContrato = 'C' THEN 'Construcción' WHEN a.TipoContrato = 'A' THEN 'Eventual' ELSE NULL END
,  CASE WHEN a.EstadoCivil = 'S' THEN 'Soltero' WHEN a.EstadoCivil = 'C' THEN 'Casado'  ELSE NULL END
, a.UnidadMedica, a.Padre, a.Madre, a.Telefono,
CASE WHEN a.Sexo = 'F' THEN 'Femenino' WHEN a.Sexo = 'M' THEN 'Masculino'  ELSE NULL END
, a.FechaNacimiento, a.Registro, a.Email, 'Horario Completo'
FROM @Tabla a JOIN @Deptos d ON a.Departamento = d.Clave
JOIN @Puestos p ON a.Puesto = p.Clave
LEFT JOIN NOIFormaPago f ON f.ClaveNOI = a.FormaPago
LEFT JOIN NOITipoEmpleado te ON te.ClaveNOI = a.Tipo
JOIN PaisEstado cp ON RTRIM(LTRIM(a.Estado)) = RTRIM(LTRIM(cp.Clave)) AND cp.Pais = 'Mexico'
JOIN PaisEstado pp ON RTRIM(LTRIM(a.LugarNacimiento)) = RTRIM(LTRIM(pp.Clave)) AND pp.Pais = 'Mexico'
OPEN crDetalle
FETCH NEXT FROM crDetalle INTO   @Personal, @Nombre, @ApellidoPaterno, @ApellidoMaterno, @Estatus, @Registro2, @Departamento, @Puesto, @Registro3, @FechaAlta, @FechaBaja, @FormaPago, @SueldoDiario, @SDI, @TipoSueldo, @Direccion, @Colonia, @Poblacion, @Estado, @CodigoPostal, @PersonalCuenta, @LugarNacimiento, @Tipo, @TipoContrato, @EstadoCivil, @UnidadMedica, @Padre, @Madre, @Telefono, @Sexo, @FechaNacimiento, @Registro, @Email, @Jornada
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Verificado = 0 ,@Ok = NULL,@OkRef= NULL
IF NULLIF(@ApellidoPaterno,'') IS NULL
SELECT @Ok = 74100
IF NULLIF(@Nombre,'') IS NULL
SELECT @Ok = 74105
IF NULLIF(@FormaPago,'') IS NULL
SELECT @Ok = 74110
IF NULLIF(@Tipo,'') IS NULL
SELECT @Ok = 74113
IF @SueldoDiario IS NULL
SELECT @Ok = 74115
IF @FechaAlta IS NULL
SELECT @Ok = 74120
IF NULLIF(@Departamento,'') IS NULL OR NOT EXISTS (SELECT * FROM Departamento WHERE Departamento = @Departamento)
SELECT @Ok = 74125
IF NULLIF(@Puesto,'') IS NULL OR NOT EXISTS (SELECT * FROM Puesto WHERE Puesto = @Puesto)
SELECT @Ok = 74130
SELECT @FechaUltimoPago = UltimoPago FROM PersonalUltimoPago WHERE Personal = @Personal
IF ISNULL(@FechaUltimoPago,@FechaA-1)>=@FechaA
SELECT @Ok = 74135
IF @Ok IS NOT NULL
SELECT @OkRef = Descripcion
FROM MensajeLista
WHERE  Mensaje = @Ok
IF @Ok IS NULL SET @Verificado = 1
INSERT NOIPersonal(Estacion,  EmpresaNOI,Nomina,Personal, Nombre, ApellidoPaterno, ApellidoMaterno, Estatus, Registro2, Departamento, Puesto, Registro3, FechaAlta, FechaBaja, FormaPago, SueldoDiario, SDI, TipoSueldo, Direccion, Colonia, Poblacion, Estado, CodigoPostal, CtaDinero, PersonalCuenta, LugarNacimiento, Tipo, TipoContrato, EstadoCivil, UnidadMedica, Padre, Madre, Telefono, Sexo, FechaNacimiento, Registro, Email, Jornada,Ok,OkRef,Verificado,ZonaEconomica,PeriodoTipo,Moneda)
SELECT            @Estacion,  @EmpresaNOI,@TablaPeriodo,@Personal, @Nombre, @ApellidoPaterno, @ApellidoMaterno, @Estatus, @Registro2, @Departamento, @Puesto, @Registro3, @FechaAlta, @FechaBaja, @FormaPago, @SueldoDiario, @SDI, @TipoSueldo, @Direccion, @Colonia, @Poblacion, @Estado, @CodigoPostal, @CtaDinero, @PersonalCuenta, @LugarNacimiento, @Tipo, @TipoContrato, @EstadoCivil, @UnidadMedica, @Padre, @Madre, @Telefono, @Sexo, @FechaNacimiento, @Registro, @Email, @Jornada,@Ok,@OkRef,@Verificado,@ZonaEconomica,@PeriodoTipo,@Moneda
FETCH NEXT FROM crDetalle INTO  @Personal, @Nombre, @ApellidoPaterno, @ApellidoMaterno, @Estatus, @Registro2, @Departamento, @Puesto, @Registro3, @FechaAlta, @FechaBaja, @FormaPago, @SueldoDiario, @SDI, @TipoSueldo, @Direccion, @Colonia, @Poblacion, @Estado, @CodigoPostal, @PersonalCuenta, @LugarNacimiento, @Tipo, @TipoContrato, @EstadoCivil, @UnidadMedica, @Padre, @Madre, @Telefono, @Sexo, @FechaNacimiento, @Registro, @Email, @Jornada
END
CLOSE crDetalle
DEALLOCATE crDetalle
RETURN
END

