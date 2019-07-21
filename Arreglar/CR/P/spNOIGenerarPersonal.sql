SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNOIGenerarPersonal
@Empresa        varchar(5),
@TablaPeriodo	varchar(10),
@Usuario        varchar(10),
@Estacion       int,
@Generar        bit =NULL,
@Mensaje        bit =NULL OUTPUT,
@Ok             int =NULL  OUTPUT,
@OkRef          varchar(255)=NULL OUTPUT

AS BEGIN
DECLARE
@EmpresaNOI        varchar(2),
@Sucursal          int,
@Nomina            varchar(10),
@Personal          varchar(10),
@Nombre            varchar(30),
@ApellidoPaterno   varchar(30),
@ApellidoPaternoO  varchar(30),
@ApellidoMaterno   varchar(30),
@ApellidoMaternoO  varchar(30),
@Estatus           varchar(15),
@Registro2         varchar(30),
@Registro2O        varchar(30),
@Departamento      varchar(50),
@DepartamentoO     varchar(50),
@Puesto            varchar(50),
@Registro3         varchar(30),
@Registro3O        varchar(30),
@FechaAlta         datetime   ,
@FechaAltaO        datetime   ,
@FechaBaja         datetime   ,
@FormaPago         varchar(50),
@FormaPagoO        varchar(50),
@SueldoDiario      money   ,
@SueldoDiarioO     money   ,
@SDI               money   ,
@SDIO              money   ,
@TipoSueldo        varchar(10),
@TipoSueldoO       varchar(10),
@Direccion         varchar(100),
@DireccionO        varchar(100),
@Colonia           varchar(100),
@ColoniaO          varchar(100),
@Poblacion         varchar(100),
@PoblacionO        varchar(100),
@Estado            varchar(30),
@EstadoO           varchar(30),
@CodigoPostal      varchar(15),
@CtaDinero         varchar(10),
@PersonalCuenta    varchar(20),
@LugarNacimiento   varchar(50),
@Tipo              varchar(20),
@TipoContrato      varchar(50),
@EstadoCivil       varchar(20),
@UnidadMedica      int   ,
@Padre             varchar(50),
@Madre             varchar(50),
@Telefono          varchar(50),
@Sexo              varchar(10),
@FechaNacimiento   datetime   ,
@Registro          varchar(30),
@RegistroO         varchar(30),
@Email             varchar(50),
@Jornada           varchar(20),
@PeriodoTipo       varchar(20),
@ZonaEconomica     varchar(30),
@Moneda            varchar(10),
@Fecha             datetime   ,
@MovAlta           varchar(20),
@MovBaja           varchar(20),
@MovCambio         varchar(20),
@IDAlta            int,
@IDBaja            int,
@IDCambio          int,
@TipoCambio        float ,
@Renglon           float,
@FechaBaja2        datetime
DECLARE
@Alta table(
Renglon   float,
Personal  varchar(10))
DECLARE
@Baja table(
Renglon   float,
Personal  varchar(10),
FechaBaja datetime)
DECLARE
@Cambio table(
Renglon   float,
Personal  varchar(10))
SELECT @Fecha = dbo.fnFechaSinHora(GETDATE())
SELECT @EmpresaNOI = EmpresaAspel,@Sucursal = SucursalIntelisis
FROM InterfaseAspel WHERE SistemaAspel = 'NOI' AND Empresa = @Empresa
SELECT @Moneda = Moneda
FROM InterfaseAspelNOI WHERE  Empresa = @Empresa
SELECT @TipoCambio = TipoCambio
FROM Mon WHERE Moneda = @Moneda
SELECT @MovAlta = RHAltas ,@MovBaja = RHBajas, @MovCambio= RHModificaciones
FROM EmpresaCfgMov WHERE Empresa = @Empresa
IF NOT EXISTS(SELECT * FROM NOIPersonal WHERE Ok IS NOT NULL AND Estacion = @Estacion)
BEGIN
DECLARE crDetalle CURSOR FOR
SELECT LTRIM(RTRIM(Personal)), Nombre, ApellidoPaterno, ApellidoMaterno, RTRIM(LTRIM(Estatus)), Registro2, Departamento, Puesto, Registro3, FechaAlta, FechaBaja, FormaPago, SueldoDiario, SDI, TipoSueldo, Direccion, Colonia, Poblacion, Estado, CodigoPostal, CtaDinero, PersonalCuenta, LugarNacimiento, Tipo, TipoContrato, EstadoCivil, UnidadMedica, Padre, Madre, Telefono, Sexo, FechaNacimiento, Registro, Email, Jornada, PeriodoTipo, ZonaEconomica, Moneda
FROM NOIPersonal
WHERE EmpresaNOI = @EmpresaNOI
AND Nomina = @TablaPeriodo
AND Verificado = 1
AND Estacion = @Estacion
OPEN crDetalle
FETCH NEXT FROM crDetalle INTO  @Personal, @Nombre, @ApellidoPaterno, @ApellidoMaterno, @Estatus, @Registro2, @Departamento, @Puesto, @Registro3, @FechaAlta, @FechaBaja, @FormaPago, @SueldoDiario, @SDI, @TipoSueldo, @Direccion, @Colonia, @Poblacion, @Estado, @CodigoPostal, @CtaDinero, @PersonalCuenta, @LugarNacimiento, @Tipo, @TipoContrato, @EstadoCivil, @UnidadMedica, @Padre, @Madre, @Telefono, @Sexo, @FechaNacimiento, @Registro, @Email, @Jornada, @PeriodoTipo, @ZonaEconomica, @Moneda
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF NOT EXISTS (SELECT * FROM Personal WHERE Personal = @Personal)
BEGIN
INSERT Personal (Personal,  Nombre,  ApellidoPaterno,  ApellidoMaterno,  Estatus,     Registro2,  Departamento,  Puesto,  Registro3,  FechaAlta,  FechaBaja,  FormaPago,  SueldoDiario,  SDI,  TipoSueldo,  Direccion,  Colonia,  Poblacion,  Estado,  CodigoPostal,  CtaDinero,  PersonalCuenta,  LugarNacimiento,  Tipo,  TipoContrato,  EstadoCivil,  UnidadMedica,  Padre,  Madre,  Telefono,  Sexo,  FechaNacimiento,  Registro,  Email,  Jornada,  PeriodoTipo,  ZonaEconomica,  Moneda, SucursalTrabajo,FechaAntiguedad, DiasPeriodo  )
SELECT           @Personal, @Nombre, @ApellidoPaterno, @ApellidoMaterno, 'ASPIRANTE', @Registro2, @Departamento, @Puesto, @Registro3, @FechaAlta, @FechaBaja, @FormaPago, @SueldoDiario, @SDI, @TipoSueldo, @Direccion, @Colonia, @Poblacion, @Estado, @CodigoPostal, @CtaDinero, @PersonalCuenta, @LugarNacimiento, @Tipo, @TipoContrato, @EstadoCivil, @UnidadMedica, @Padre, @Madre, @Telefono, @Sexo, @FechaNacimiento, @Registro, @Email, @Jornada, @PeriodoTipo, @ZonaEconomica, @Moneda, @Sucursal,     @FechaAlta,      'Dias Periodo'
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
INSERT @Alta(Personal)
SELECT @Personal
IF @@ERROR <> 0 SET @Ok = 1
END
IF EXISTS (SELECT * FROM Personal WHERE Personal = @Personal)
BEGIN
IF @Estatus = 'ALTA'
BEGIN
SELECT @ApellidoPaternoO=ApellidoPaterno,
@ApellidoMaternoO=ApellidoMaterno,
@Registro2O=Registro2,
@DepartamentoO=Departamento,
@RegistroO=Registro,
@Registro3O=Registro3,
@FechaAltaO=FechaAlta,
@FormaPagoO=FormaPago,
@SueldoDiarioO=SueldoDiario,
@SDIO=SDI,
@TipoSueldoO=TipoSueldo,
@DireccionO=Direccion,
@ColoniaO=Colonia,
@PoblacionO=Poblacion,
@EstadoO=Estado
FROM Personal
WHERE Personal = @Personal
IF  @ApellidoPaternoO  <> @ApellidoPaterno   OR
@ApellidoMaternoO  <> @ApellidoMaterno   OR
@Registro2O  <> @Registro2   OR
@DepartamentoO  <> @Departamento   OR
@RegistroO  <> @Registro   OR
@Registro3O  <> @Registro3   OR
@FechaAltaO  <> @FechaAlta   OR
@FormaPagoO  <> @FormaPago   OR
@SueldoDiarioO  <> @SueldoDiario   OR
@SDIO  <> @SDI   OR
@TipoSueldoO  <> @TipoSueldo   OR
@DireccionO  <> @Direccion   OR
@ColoniaO  <> @Colonia   OR
@PoblacionO  <> @Poblacion   OR
@EstadoO  <> @Estado
BEGIN
UPDATE Personal SET ApellidoPaterno   =  @ApellidoPaterno, ApellidoMaterno   =  @ApellidoMaterno,  Registro2   =  @Registro2, Departamento   =  @Departamento, Registro   =  @Registro, FechaAlta   =  @FechaAlta, FechaAntiguedad = @FechaAlta,  FormaPago   =  @FormaPago, SueldoDiario   =  @SueldoDiario, SDI   =  @SDI, TipoSueldo   =  @TipoSueldo, Direccion   =  @Direccion, Colonia   =  @Colonia, Poblacion   =  @Poblacion, Estado   =  @Estado, SucursalTrabajo = @Sucursal
WHERE Personal = @Personal
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
INSERT @Cambio(Personal)
SELECT @Personal
IF @@ERROR <> 0 SET @Ok = 1
END
END
IF @Estatus = 'BAJA'
BEGIN
INSERT @Baja (Personal,FechaBaja)
SELECT @Personal,@FechaBaja
IF @@ERROR <> 0 SET @Ok = 1
END
END
FETCH NEXT FROM crDetalle INTO  @Personal, @Nombre, @ApellidoPaterno, @ApellidoMaterno, @Estatus, @Registro2, @Departamento, @Puesto, @Registro3, @FechaAlta, @FechaBaja, @FormaPago, @SueldoDiario, @SDI, @TipoSueldo, @Direccion, @Colonia, @Poblacion, @Estado, @CodigoPostal, @CtaDinero, @PersonalCuenta, @LugarNacimiento, @Tipo, @TipoContrato, @EstadoCivil, @UnidadMedica, @Padre, @Madre, @Telefono, @Sexo, @FechaNacimiento, @Registro, @Email, @Jornada, @PeriodoTipo, @ZonaEconomica, @Moneda
END
CLOSE crDetalle
DEALLOCATE crDetalle
END
IF EXISTS(SELECT * FROM NOIPersonal WHERE Ok IS NOT NULL AND Estacion = @Estacion)
SELECT TOP 1 @Ok = Ok FROM NOIPersonal WHERE Ok IS NOT NULL
BEGIN TRANSACTION
IF @Ok IS NULL AND EXISTS (SELECT * FROM @Alta)
BEGIN
SET @Renglon = 0.0
UPDATE @Alta
SET @Renglon = Renglon = @Renglon + 2048.0
FROM @Alta
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
INSERT RH (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, Empresa,  Usuario,  Estatus,      Mov,      FechaEmision,  Moneda,  TipoCambio)
SELECT     GETDATE(),   @Sucursal, @Sucursal,      @Sucursal,       @Empresa, @Usuario, 'SINAFECTAR',   @MovAlta, @Fecha, @Moneda, @TipoCambio
SELECT @IDAlta = SCOPE_IDENTITY()
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
INSERT RHD (ID,  Renglon, Sucursal, SucursalOrigen, Personal,   SueldoDiario,   SueldoDiarioComplemento,   SDI,   TipoContrato,   PeriodoTipo,   Jornada,   TipoSueldo,   Categoria,   Departamento,   Puesto,   Grupo,   FechaAlta,   FechaAntiguedad,   SucursalTrabajo,   ReportaA,   CentroCostos,   VencimientoContrato,   Plaza)
SELECT @IDAlta, a.Renglon,  @Sucursal,  @Sucursal,      a.Personal, p.SueldoDiario, p.SueldoDiarioComplemento, p.SDI, p.TipoContrato, p.PeriodoTipo, p.Jornada, p.TipoSueldo, p.Categoria, p.Departamento, p.Puesto, p.Grupo, p.FechaAlta, p.FechaAntiguedad, p.SucursalTrabajo, p.ReportaA, p.CentroCostos, p.VencimientoContrato, p.Plaza
FROM @Alta a JOIN Personal p ON a.Personal = p.Personal
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL  AND @IDAlta IS NOT NULL
EXEC spAfectar 'RH', @IDAlta, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL AND @Mensaje IS NULL AND @IDAlta IS NOT NULL
SELECT @Mensaje = 1
END
IF @Ok IS NULL AND EXISTS (SELECT * FROM @Cambio)
BEGIN
SET @Renglon = 0.0
UPDATE @Cambio
SET @Renglon = Renglon = @Renglon + 2048.0
FROM @Cambio
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
INSERT RH (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, Empresa,  Usuario,  Estatus,      Mov,      FechaEmision,  Moneda,  TipoCambio)
SELECT     GETDATE(),   @Sucursal, @Sucursal,      @Sucursal,       @Empresa, @Usuario, 'SINAFECTAR',   @MovCambio, @Fecha, @Moneda, @TipoCambio
SELECT @IDCambio = SCOPE_IDENTITY()
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
INSERT RHD (ID,  Renglon, Sucursal, SucursalOrigen, Personal,   SueldoDiario,   SueldoDiarioComplemento,   SDI,   TipoContrato,   PeriodoTipo,   Jornada,   TipoSueldo,   Categoria,   Departamento,   Puesto,   Grupo,   FechaAlta,   FechaAntiguedad,   SucursalTrabajo,   ReportaA,   CentroCostos,   VencimientoContrato,   Plaza)
SELECT @IDCambio, a.Renglon,  @Sucursal,  @Sucursal,      a.Personal, p.SueldoDiario, p.SueldoDiarioComplemento, p.SDI, p.TipoContrato, p.PeriodoTipo, p.Jornada, p.TipoSueldo, p.Categoria, p.Departamento, p.Puesto, p.Grupo, p.FechaAlta, p.FechaAntiguedad, p.SucursalTrabajo, p.ReportaA, p.CentroCostos, p.VencimientoContrato, p.Plaza
FROM @Cambio a JOIN Personal p ON a.Personal = p.Personal
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL  AND @IDCambio IS NOT NULL
EXEC spAfectar 'RH', @IDCambio, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL AND @Mensaje IS NULL AND @IDCambio IS NOT NULL
SELECT @Mensaje = 1
END
IF @Ok IS NULL AND EXISTS (SELECT * FROM @Baja)
BEGIN
SET @Renglon = 0.0
UPDATE @Baja
SET @Renglon = Renglon = @Renglon + 2048.0
FROM @Baja
IF @@ERROR <> 0 SET @Ok = 1
DECLARE crBaja CURSOR FOR
SELECT FechaBaja
FROM @Baja
GROUP BY  FechaBaja
OPEN crBaja
FETCH NEXT FROM crBaja INTO @FechaBaja2
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @FechaBaja2 = dbo.fnFechaSinHora(@FechaBaja2)
IF @Ok IS NULL
INSERT RH (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, Empresa,  Usuario,  Estatus,      Mov,        FechaEmision,  Moneda,  TipoCambio)
SELECT     GETDATE(),   @Sucursal, @Sucursal,      @Sucursal,       @Empresa, @Usuario, 'SINAFECTAR',   @MovBaja, @FechaBaja2,   @Moneda, @TipoCambio
SELECT @IDBaja = SCOPE_IDENTITY()
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
INSERT RHD (ID,  Renglon, Sucursal, SucursalOrigen, Personal)
SELECT @IDBaja, a.Renglon,  @Sucursal,  @Sucursal,      a.Personal
FROM @Baja a JOIN Personal p ON a.Personal = p.Personal
WHERE a.FechaBaja = @FechaBaja2
IF @@ERROR <> 0 SET @Ok = 1
SET @Renglon = 0.0
UPDATE RHD
SET @Renglon = Renglon = @Renglon + 2048.0
FROM RHD
WHERE ID = @IDBaja
IF @Ok IS NULL  AND @IDBaja IS NOT NULL
EXEC spAfectar 'RH', @IDBaja, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL AND @Mensaje IS NULL AND @IDBaja IS NOT NULL
SELECT @Mensaje = 1
FETCH NEXT FROM crBaja INTO @FechaBaja2
END
CLOSE crBaja
DEALLOCATE crBaja
END
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
DELETE NOIPersonal
WHERE EmpresaNOI = @EmpresaNOI AND Estacion = @Estacion AND Nomina = @TablaPeriodo
IF @Mensaje = 1 AND @Generar IS NULL
SELECT 'Se Generaron Los Movimientos En El Modulo RH'
ELSE
IF ISNULL(@Mensaje,0) = 0 AND @Generar IS NULL
SELECT 'Se Actualizo La Informacion Correctamente'
END ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT Descripcion+' '+ISNULL(RTRIM(@OkRef), '') FROM MensajeLista WHERE Mensaje = @Ok
END
RETURN
END

