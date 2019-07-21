SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRHAfectar
@ID                		int,
@Accion			char(20),
@Empresa	      		char(5),
@Modulo	      		char(5),
@Mov	  	      		char(20),
@MovID             		varchar(20) OUTPUT,
@MovTipo     		char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaEmision      		datetime,
@FechaAfectacion      	datetime,
@FechaConclusion		datetime,
@Proyecto	      		varchar(50),
@Concepto			varchar(50),
@Usuario	      		char(10),
@Autorizacion      		char(10),
@DocFuente	      		int,
@Observaciones     		varchar(255),
@Estatus           		char(15),
@EstatusNuevo	      	char(15),
@FechaRegistro     		datetime,
@Ejercicio	      		int,
@Periodo	      		int,
@Conexion			bit,
@SincroFinal			bit,
@Sucursal			int,
@SucursalDestino		int,
@SucursalOrigen		int,
@CfgControlPlazas		varchar(20),
@CfgContX			bit,
@CfgContXGenerar		char(20),
@GenerarPoliza		bit,
@GenerarMov			char(20),
@IDGenerar			int	     OUTPUT,
@GenerarMovID	  	varchar(20)  OUTPUT,
@Ok                		int          OUTPUT,
@OkRef             		varchar(255) OUTPUT

AS BEGIN
DECLARE
@Personal			char(10),
@SueldoDiario		money,
@SueldoDiarioComplemento	money,
@SDI			money,
@TipoContrato		varchar(50),
@VencimientoContrato	datetime,
@PeriodoTipo		varchar(20),
@Jornada			varchar(50),
@TipoSueldo			varchar(10),
@Plaza			varchar(20),
@Puesto			varchar(50),
@Departamento		varchar(50),
@Categoria			varchar(50),
@Grupo			varchar(50),
@ReportaA			varchar(10),
@CentroCostos		varchar(20),
@SucursalTrabajo		int,
@FechaAlta			datetime,
@FechaAntiguedad		datetime,
@Generar			bit,
@GenerarAfectado		bit,
@GenerarModulo		char(5),
@GenerarMovTipo		char(20),
@GenerarEstatus		char(15),
@GenerarPeriodo 		int,
@GenerarEjercicio 		int,
@FechaCancelacion		datetime,
@GenerarAccion		char(20),
@RedondeoMonetarios		int,
@Incremento			float,
@IDOrigen			int,
@OrigenTipo			char(10),
@Origen			varchar(20),
@OrigenID			varchar(20),
@OrigenMovTipo		varchar(20),
@Fecha			DATETIME,
@SubClave		varchar(20)
SELECT @RedondeoMonetarios = dbo.fnRedondeoMonetarios()
SELECT @Generar 		= 0,
@GenerarAfectado	= 0,
@IDGenerar		= NULL,
@GenerarModulo		= NULL,
@GenerarMovID	        = NULL,
@GenerarMovTipo        = NULL,
@GenerarEstatus 	= 'SINAFECTAR'
SELECT @SubClave = SubClave FROM MovTipo WHERE Mov = @Mov AND Modulo = 'RH'
EXEC spMovConsecutivo @Sucursal, @SucursalOrigen, @SucursalDestino, @Empresa, @Usuario, @Modulo, @Ejercicio, @Periodo, @ID, @Mov, NULL, @Estatus, @Concepto, @Accion, @Conexion, @SincroFinal, @MovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR') AND @Accion <> 'CANCELAR' AND @Ok IS NULL
EXEC spMovChecarConsecutivo	@Empresa, @Modulo, @Mov, @MovID, NULL, @Ejercicio, @Periodo, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion IN ('CONSECUTIVO', 'SINCRO') AND @Ok IS NULL
BEGIN
IF @Accion = 'SINCRO' EXEC spAsignarSucursalEstatus @ID, @Modulo, @SucursalDestino, @Accion
SELECT @Ok = 80060, @OkRef = @MovID
RETURN
END
IF @OK IS NOT NULL RETURN
IF @Accion = 'GENERAR' AND @Ok IS NULL
BEGIN
EXEC spMovGenerar @Sucursal, @Empresa, @Modulo, @Ejercicio, @Periodo, @Usuario, @FechaRegistro, @GenerarEstatus,
NULL, NULL,
@Mov, @MovID, 0,
@GenerarMov, NULL, @GenerarMovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spMovTipo @Modulo, @GenerarMov, @FechaAfectacion, @Empresa, NULL, NULL, @GenerarMovTipo OUTPUT, @GenerarPeriodo OUTPUT, @GenerarEjercicio OUTPUT, @Ok OUTPUT
IF @@ERROR <> 0 SELECT @Ok = 1
IF @MovTipo = 'RH.INC'
BEGIN
INSERT RHD (
ID,         Renglon,   Sucursal,  SucursalOrigen, Personal,   Incremento,   SueldoDiario,   SueldoDiarioComplemento,   SDI,   TipoContrato,   PeriodoTipo,   Jornada,   TipoSueldo,   Categoria,   Departamento,   Puesto,   Grupo,   FechaAlta,   FechaAntiguedad,   SucursalTrabajo,   ReportaA,   CentroCostos,   VencimientoContrato, Plaza)
SELECT @IDGenerar, d.Renglon, @Sucursal, @Sucursal,      p.Personal, d.Incremento, p.SueldoDiario, p.SueldoDiarioComplemento, p.SDI, p.TipoContrato, p.PeriodoTipo, p.Jornada, p.TipoSueldo, p.Categoria, p.Departamento, p.Puesto, p.Grupo, p.FechaAlta, p.FechaAntiguedad, p.SucursalTrabajo, p.ReportaA, p.CentroCostos, p.VencimientoContrato, d.Plaza
FROM RHD d, Personal p
WHERE d.ID = @ID AND p.Personal = d.Personal
EXEC spRHModificarEnLote @Empresa, @IDGenerar, NULL, NULL, 'NO', @UsarIncremento = 1
END ELSE
INSERT RHD (
ID,         Renglon, Sucursal,  SucursalOrigen, Personal, Incremento, SueldoDiario, SueldoDiarioComplemento, SDI, TipoContrato, PeriodoTipo, Jornada, TipoSueldo, Categoria, Departamento, Puesto, Grupo, FechaAlta, FechaAntiguedad, SucursalTrabajo, ReportaA, CentroCostos, VencimientoContrato, Plaza)
SELECT @IDGenerar, Renglon, @Sucursal, @Sucursal,      Personal, Incremento, SueldoDiario, SueldoDiarioComplemento, SDI, TipoContrato, PeriodoTipo, Jornada, TipoSueldo, Categoria, Departamento, Puesto, Grupo, FechaAlta, FechaAntiguedad, SucursalTrabajo, ReportaA, CentroCostos, VencimientoContrato, Plaza
FROM RHD
WHERE ID = @ID
IF @Ok IS NULL SELECT @Ok = 80030
RETURN
END
IF @OK IS NOT NULL RETURN
IF @Conexion = 0
BEGIN TRANSACTION
EXEC spMovEstatus @Modulo, 'AFECTANDO', @ID, @Generar, @IDGenerar, @GenerarAfectado, @Ok OUTPUT
IF @Accion = 'AFECTAR' AND @Estatus IN ('SINAFECTAR', 'CONFIRMAR')
IF (SELECT Sincro FROM Version) = 1
EXEC sp_executesql N'UPDATE RHD SET Sucursal = @Sucursal, SincroC = 1 WHERE ID = @ID AND (Sucursal <> @Sucursal OR SincroC <> 1)', N'@Sucursal int, @ID int', @Sucursal, @ID
IF @Accion <> 'CANCELAR'
EXEC spRegistrarMovimiento @Sucursal, @Empresa, @Modulo, @Mov, @MovID, @ID, @Ejercicio, @Periodo, @FechaRegistro, @FechaEmision,
NULL, @Proyecto, @MovMoneda, @MovTipoCambio,
@Usuario, @Autorizacion, NULL, @DocFuente, @Observaciones,
@Generar, @GenerarMov, @GenerarMovID, @IDGenerar,
@Ok OUTPUT
DECLARE crRH CURSOR
FOR SELECT NULLIF(RTRIM(Personal), ''), SueldoDiario, SueldoDiarioComplemento, SDI,
NULLIF(RTRIM(TipoContrato), ''), VencimientoContrato, NULLIF(RTRIM(PeriodoTipo), ''), NULLIF(RTRIM(Jornada), ''), NULLIF(RTRIM(TipoSueldo), ''), NULLIF(RTRIM(Plaza), ''),
NULLIF(RTRIM(Puesto), ''), NULLIF(RTRIM(Departamento), ''), NULLIF(RTRIM(Categoria), ''), NULLIF(RTRIM(Grupo), ''), NULLIF(RTRIM(ReportaA), ''), NULLIF(RTRIM(CentroCostos), ''), SucursalTrabajo,
FechaAlta, FechaAntiguedad, Incremento
FROM RHD
WHERE ID = @ID
OPEN crRH
FETCH NEXT FROM crRH INTO @Personal, @SueldoDiario, @SueldoDiarioComplemento, @SDI, @TipoContrato, @VencimientoContrato, @PeriodoTipo, @Jornada, @TipoSueldo, @Plaza, @Puesto, @Departamento, @Categoria, @Grupo, @ReportaA, @CentroCostos, @SucursalTrabajo, @FechaAlta, @FechaAntiguedad, @Incremento
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF @MovTipo = 'RH.INC'
UPDATE Personal
SET Incremento = CASE WHEN @Accion <> 'CANCELAR' THEN @Incremento ELSE NULL END
WHERE Personal = @Personal
IF @MovTipo IN ('RH.C', 'RH.A', 'RH.M', 'RH.B')
BEGIN
IF @Accion <> 'CANCELAR'
BEGIN
IF @CfgControlPlazas <> 'NO' AND @MovTipo IN ('RH.A', 'RH.M', 'RH.B') AND @SubClave NOT IN ('RH.BRP', 'RH.ARP')
EXEC spRHControlPlazas @Accion, @CfgControlPlazas, @Empresa, @SucursalTrabajo, @MovTipo, @FechaAlta, @Personal, @Plaza, @Puesto, @Departamento, @SubClave, @Ok OUTPUT, @OkRef OUTPUT
IF @MovTipo = 'RH.C'
UPDATE Personal
SET SueldoDiario = ROUND(NULLIF(@SueldoDiario, 0.0), @RedondeoMonetarios),
SueldoDiarioComplemento = ROUND(NULLIF(@SueldoDiarioComplemento, 0.0), @RedondeoMonetarios),
SDI = ROUND(NULLIF(@SDI, 0.0), 4),
TipoContrato = @TipoContrato, VencimientoContrato = @VencimientoContrato, PeriodoTipo = @PeriodoTipo, Jornada = @Jornada, TipoSueldo = @TipoSueldo,
Plaza = @Plaza, Puesto = @Puesto, Departamento = @Departamento, Categoria = @Categoria, Grupo = @Grupo, ReportaA = @ReportaA, CentroCostos = @CentroCostos, SucursalTrabajo = @SucursalTrabajo,
Estatus = 'CANDIDATO', Moneda = @MovMoneda, FechaAlta = @FechaEmision, UltimaModificacion = NULL, FechaBaja = NULL, TieneMovimientos = 1
WHERE Personal = @Personal
ELSE
IF @MovTipo = 'RH.A'
UPDATE Personal
SET SueldoDiario = ROUND(NULLIF(@SueldoDiario, 0.0), @RedondeoMonetarios),
SueldoDiarioComplemento = ROUND(NULLIF(@SueldoDiarioComplemento, 0.0), @RedondeoMonetarios),
SDI = ROUND(NULLIF(@SDI, 0.0), @RedondeoMonetarios),
TipoContrato = @TipoContrato, VencimientoContrato = @VencimientoContrato, PeriodoTipo = @PeriodoTipo, Jornada = @Jornada, TipoSueldo = @TipoSueldo,
Plaza = @Plaza, Puesto = @Puesto, Departamento = @Departamento, Categoria = @Categoria, Grupo = @Grupo, ReportaA = @ReportaA, CentroCostos = @CentroCostos, SucursalTrabajo = @SucursalTrabajo,
Estatus = 'ALTA', Moneda = @MovMoneda, FechaAlta = @FechaAlta, FechaAntiguedad = @FechaAntiguedad, UltimaModificacion = NULL, FechaBaja = NULL, TieneMovimientos = 1, Empresa = @Empresa
WHERE Personal = @Personal
ELSE
IF @MovTipo = 'RH.M'
UPDATE Personal
SET /*SueldoDiario = ROUND(ISNULL(@SueldoDiario, SueldoDiario), @RedondeoMonetarios),
SueldoDiarioComplemento = ROUND(ISNULL(@SueldoDiarioComplemento, SueldoDiarioComplemento), @RedondeoMonetarios), */
SueldoDiario = ROUND(NULLIF(@SueldoDiario, 0.0), @RedondeoMonetarios),
SueldoDiarioComplemento = ROUND(NULLIF(@SueldoDiarioComplemento, 0.0), @RedondeoMonetarios),
SDI = ROUND(ISNULL(@SDI, SDI), @RedondeoMonetarios),
TipoContrato = @TipoContrato, VencimientoContrato = @VencimientoContrato, PeriodoTipo = @PeriodoTipo, Jornada = @Jornada, TipoSueldo = @TipoSueldo,
Plaza = @Plaza, Puesto = @Puesto, Departamento = @Departamento, Categoria = @Categoria, Grupo = @Grupo, ReportaA = @ReportaA, CentroCostos = @CentroCostos, SucursalTrabajo = @SucursalTrabajo,
UltimaModificacion = @FechaEmision, TieneMovimientos = 1
WHERE Personal = @Personal
ELSE
IF @MovTipo = 'RH.B'
BEGIN
IF @SubClave = 'RH.BRP'
UPDATE Personal
SET FechaBaja = @FechaEmision, ConceptoBaja = @Concepto, TieneMovimientos = 1
WHERE Personal = @Personal
ELSE
UPDATE Personal
SET Estatus = 'BAJA', FechaBaja = @FechaEmision, ConceptoBaja = @Concepto, TieneMovimientos = 1
WHERE Personal = @Personal
END
END ELSE
BEGIN
IF @MovTipo IN ('RH.C', 'RH.A', 'RH.M')
EXEC spRHValoresAnteriores @ID, @Personal, @SueldoDiario OUTPUT, @SueldoDiarioComplemento OUTPUT, @SDI OUTPUT, @TipoContrato OUTPUT, @VencimientoContrato OUTPUT, @PeriodoTipo OUTPUT, @Jornada OUTPUT, @TipoSueldo OUTPUT,
@Plaza OUTPUT, @Puesto OUTPUT, @Departamento OUTPUT, @Categoria OUTPUT, @Grupo OUTPUT, @ReportaA OUTPUT, @CentroCostos OUTPUT, @SucursalTrabajo OUTPUT, @FechaAlta OUTPUT, @FechaAntiguedad OUTPUT
IF @CfgControlPlazas <> 'NO' AND @MovTipo IN ('RH.A', 'RH.M', 'RH.B') AND @SubClave NOT IN ('RH.BRP', 'RH.ARP')
EXEC spRHControlPlazas @Accion, @CfgControlPlazas, @Empresa, @SucursalTrabajo, @MovTipo, @FechaAlta, @Personal, @Plaza, @Puesto, @Departamento, @SubClave, @Ok OUTPUT, @OkRef OUTPUT
IF @MovTipo = 'RH.C'
UPDATE Personal
SET SueldoDiario = ROUND(NULLIF(@SueldoDiario, 0.0), @RedondeoMonetarios),
SueldoDiarioComplemento = ROUND(NULLIF(@SueldoDiarioComplemento, 0.0), @RedondeoMonetarios),
SDI = ROUND(NULLIF(@SDI, 0.0), @RedondeoMonetarios),
TipoContrato = @TipoContrato, VencimientoContrato = @VencimientoContrato, PeriodoTipo = @PeriodoTipo, Jornada = @Jornada, TipoSueldo = @TipoSueldo,
/*Plaza = @Plaza, */Puesto = @Puesto, Departamento = @Departamento, Categoria = @Categoria, Grupo = @Grupo, ReportaA = @ReportaA, CentroCostos = @CentroCostos, SucursalTrabajo = @SucursalTrabajo,
Estatus = 'ASPIRANTE', FechaAlta = NULL
WHERE Personal = @Personal
ELSE
IF @MovTipo = 'RH.A'
BEGIN
/*IF EXISTS(SELECT * FROM Nomina n JOIN NominaD d ON d.ID = n.ID AND d.Personal = @Personal WHERE n.Empresa = @Empresa AND n.Estatus IN ('PENDIENTE', 'CONCLUIDO', 'VIGENTE'))
SELECT @Ok = 30151, @OkRef = @Personal*/
SELECT @Fecha = MAX(FechaEmision) FROM RH r, RHD d
WHERE d.ID = r.ID
AND d.Personal=@Personal
AND r.Estatus='CONCLUIDO'
AND r.ID <> @ID
UPDATE Personal
SET SueldoDiario = ROUND(NULLIF(@SueldoDiario, 0.0), @RedondeoMonetarios),
SueldoDiarioComplemento = ROUND(NULLIF(@SueldoDiarioComplemento, 0.0), @RedondeoMonetarios),
SDI = ROUND(NULLIF(@SDI, 0.0), @RedondeoMonetarios),
TipoContrato = @TipoContrato, VencimientoContrato = @VencimientoContrato, PeriodoTipo = @PeriodoTipo, Jornada = @Jornada, TipoSueldo = @TipoSueldo,
/*Plaza = @Plaza, */Puesto = @Puesto, Departamento = @Departamento, Categoria = @Categoria, Grupo = @Grupo, ReportaA = @ReportaA, CentroCostos = @CentroCostos, SucursalTrabajo = @SucursalTrabajo,
Estatus = CASE WHEN EXISTS( SELECT *
FROM RH r, RHD d, MovTipo m
WHERE d.ID           = r.ID
AND m.Clave        ='RH.B'
AND m.Mov          = r.Mov
AND d.Personal     = @Personal
AND r.FechaEmision = @Fecha
AND r.Estatus      = 'CONCLUIDO')
THEN 'BAJA'
ELSE 'ASPIRANTE'
END,
FechaAlta = NULL
WHERE Personal = @Personal
END ELSE
IF @MovTipo = 'RH.M'
UPDATE Personal
SET SueldoDiario = ROUND(NULLIF(@SueldoDiario, 0.0), @RedondeoMonetarios),
SueldoDiarioComplemento = ROUND(NULLIF(@SueldoDiarioComplemento, 0.0), @RedondeoMonetarios),
SDI = ROUND(NULLIF(@SDI, 0.0), @RedondeoMonetarios),
TipoContrato = @TipoContrato, VencimientoContrato = @VencimientoContrato, PeriodoTipo = @PeriodoTipo, Jornada = @Jornada, TipoSueldo = @TipoSueldo,
/*Plaza = @Plaza, */Puesto = @Puesto, Departamento = @Departamento, Categoria = @Categoria, Grupo = @Grupo, ReportaA = @ReportaA, CentroCostos = @CentroCostos, SucursalTrabajo = @SucursalTrabajo,
UltimaModificacion = NULL
WHERE Personal = @Personal
ELSE
IF @MovTipo = 'RH.B'
UPDATE Personal
SET FechaBaja = NULL, ConceptoBaja = NULL, Estatus = 'ALTA'
WHERE Personal = @Personal
END
END
END
FETCH NEXT FROM crRH INTO @Personal, @SueldoDiario, @SueldoDiarioComplemento, @SDI, @TipoContrato, @VencimientoContrato, @PeriodoTipo, @Jornada, @TipoSueldo, @Plaza, @Puesto, @Departamento, @Categoria, @Grupo, @ReportaA, @CentroCostos, @SucursalTrabajo, @FechaAlta, @FechaAntiguedad, @Incremento
IF @@ERROR <> 0 SELECT @Ok = 1
END  
CLOSE crRH
DEALLOCATE crRH
EXEC xpRHAfectar @ID, @Accion, @Empresa, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaEmision, @FechaAfectacion, @FechaConclusion,
@Proyecto, @Concepto, @Usuario, @Autorizacion, @DocFuente, @Observaciones,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen,
@CfgControlPlazas, @CfgContX, @CfgContXGenerar, @GenerarPoliza,
@GenerarMov, @IDGenerar, @GenerarMovID,
@Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
IF @EstatusNuevo = 'CANCELADO' SELECT @FechaCancelacion = @FechaRegistro ELSE SELECT @FechaCancelacion = NULL
IF @EstatusNuevo = 'CONCLUIDO' SELECT @FechaConclusion  = @FechaEmision  ELSE IF @EstatusNuevo <> 'CANCELADO' SELECT @FechaConclusion  = NULL
IF @CfgContX = 1 AND @CfgContXGenerar <> 'NO'
BEGIN
IF @Estatus IN ('SINAFECTAR', 'CONFIRMAR') AND @EstatusNuevo <> 'CANCELADO' SELECT @GenerarPoliza = 1 ELSE
IF @Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR') AND @EstatusNuevo =  'CANCELADO' IF @GenerarPoliza = 1 SELECT @GenerarPoliza = 0 ELSE SELECT @GenerarPoliza = 1
END
EXEC spValidarTareas @Empresa, @Modulo, @ID, @EstatusNuevo, @Ok OUTPUT, @OkRef OUTPUT
UPDATE RH
SET FechaConclusion  = @FechaConclusion,
FechaCancelacion = @FechaCancelacion,
UltimoCambio     = /*CASE WHEN UltimoCambio IS NULL THEN */@FechaRegistro /*ELSE UltimoCambio END*/,
Estatus          = @EstatusNuevo,
Situacion 	      = CASE WHEN @Estatus <> @EstatusNuevo THEN NULL ELSE Situacion END,
GenerarPoliza    = @GenerarPoliza
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
END
SELECT @OrigenTipo = OrigenTipo, @Origen = Origen, @OrigenID = OrigenID
FROM RH
WHERE ID = @ID
IF @OrigenTipo = @Modulo
BEGIN
SELECT @IDOrigen = NULL
SELECT @IDOrigen = ID FROM RH WHERE Mov = @Origen AND MovID = @OrigenID AND Empresa = @Empresa AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
SELECT @OrigenMovTipo = Clave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Origen
IF @OrigenMovTipo IN ('RH.SA', 'RH.SM', 'RH.SB', 'RH.SINC', 'RH.INC') AND @IDOrigen IS NOT NULL
UPDATE RH SET Estatus = CASE WHEN @Accion = 'CANCELAR' THEN 'PENDIENTE' ELSE 'CONCLUIDO' END WHERE ID = @IDOrigen
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @IDOrigen, @Origen, @OrigenID, @Modulo, @ID, @Mov, @MovID, @Ok OUTPUT
END
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spMovFinal @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion = 'CANCELAR' AND @EstatusNuevo = 'CANCELADO' AND @Ok IS NULL
EXEC spCancelarFlujo @Empresa, @Modulo, @ID, @Ok OUTPUT
IF @Conexion = 0
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
RETURN
END

