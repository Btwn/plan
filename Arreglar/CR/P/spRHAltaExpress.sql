SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRHAltaExpress
@Empresa	char(5),
@Sucursal	int,
@Usuario	char(10),
@Personal	char(10)

AS BEGIN
DECLARE
@ID			int,
@Mov		char(20),
@MovID		varchar(20),
@FechaRegistro	datetime,
@FechaEmision	datetime,
@Moneda		char(10),
@TipoCambio		float,
@PlazaPersonal varchar(10),
@Plaza      varchar(20),
@Ok			int,
@OkRef		varchar(255)
SELECT @FechaRegistro = GETDATE()
SELECT @FechaEmision = @FechaRegistro
EXEC spExtraerFecha @FechaEmision OUTPUT
SELECT @Moneda = m.Moneda, @TipoCambio = m.TipoCambio
FROM Personal p, Mon m
WHERE p.Personal = @Personal AND m.Moneda = p.Moneda
SELECT @Mov = RHAltas FROM EmpresaCfgMov WHERE Empresa = @Empresa
SELECT @Plaza = ISNULL(Plaza,'') FROM Personal WHERE Personal = @Personal
IF EXISTS(SELECT 1 FROM Personal WHERE Plaza = @Plaza AND Personal <> @Personal) AND ISNULL(@Plaza,'') <> ''
BEGIN
SELECT @PlazaPersonal = Personal FROM Personal WHERE Plaza = @Plaza AND Personal <> @Personal
SELECT @Ok = 55410, @OkRef = @PlazaPersonal
END
BEGIN TRANSACTION
INSERT RH (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, Empresa,  Usuario,  Estatus,      Mov,  FechaEmision,  Moneda,  TipoCambio)
SELECT GETDATE(),  @Sucursal,  @Sucursal,      @Sucursal,       @Empresa, @Usuario, 'SINAFECTAR', @Mov, @FechaEmision, @Moneda, @TipoCambio
SELECT @ID = SCOPE_IDENTITY()
INSERT RHD (ID,  Renglon, Sucursal,  SucursalOrigen, Personal, SueldoDiario, SueldoDiarioComplemento, SDI, TipoContrato, PeriodoTipo, Jornada, TipoSueldo, Categoria, Departamento, Puesto, Grupo, FechaAlta, FechaAntiguedad, SucursalTrabajo, ReportaA, CentroCostos, VencimientoContrato, Plaza)
SELECT @ID, 2048.0,  @Sucursal, @Sucursal,      Personal, SueldoDiario, SueldoDiarioComplemento, SDI, TipoContrato, PeriodoTipo, Jornada, TipoSueldo, Categoria, Departamento, Puesto, Grupo, FechaAlta, FechaAntiguedad, SucursalTrabajo, ReportaA, CentroCostos, VencimientoContrato, Plaza
FROM Personal
WHERE Personal = @Personal
EXEC spRH @ID, 'RH', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, @Mov OUTPUT, @MovID OUTPUT, NULL, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
SELECT 'Se Genero '+RTRIM(@Mov)+' '+RTRIM(@MovID)
END ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT Descripcion+' '+ISNULL(RTRIM(@OkRef), '') FROM MensajeLista WHERE Mensaje = @Ok
END
RETURN
END

