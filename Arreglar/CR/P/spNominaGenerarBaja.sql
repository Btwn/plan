SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNominaGenerarBaja
@Accion			char(20),
@Sucursal			int,
@Empresa	      		char(5),
@FechaEmision      		datetime,
@Proyecto	      		varchar(50),
@Usuario	      		char(10),
@Modulo	      		char(5),
@ID				int,
@Mov	  	      		char(20),
@MovID             		varchar(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaRegistro		datetime,
@Ok                		int          OUTPUT,
@OkRef             		varchar(255) OUTPUT

AS BEGIN
DECLARE
@Personal		char(20),
@Renglon		float,
@RHID		int,
@RHMov		char(20),
@RHMovID		varchar(20),
@IDGenerar		int,
@ConsecutivoPorPeriodo	bit,
@ConsecutivoPorEjercicio	bit,
@ConsecutivoPorEmpresa	char(20),
@ConsecutivoSucursalEsp	bit,
@Ejercicio			int,
@Periodo			int
SELECT @ConsecutivoPorPeriodo   = ConsecutivoPorPeriodo,
@ConsecutivoPorEjercicio = ConsecutivoPorEjercicio,
@ConsecutivoPorEmpresa   = ISNULL(UPPER(ConsecutivoPorEmpresa), 'SI'),
@ConsecutivoSucursalEsp  = ISNULL(ConsecutivoSucursalEsp, 0)
FROM MovTipo
WHERE Modulo = 'NOM'
AND Mov    = @Mov
SELECT @Ejercicio = YEAR(@FechaRegistro), @Periodo = MONTH(@FechaRegistro)
SELECT @RHMov = RHBajas
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
IF @Accion = 'CANCELAR'
BEGIN
SELECT @RHID = NULL
SELECT @RHID = MIN(ID) FROM RH WHERE Mov = @RHMov AND OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND Periodo   = CASE WHEN @ConsecutivoPorPeriodo   = 1    THEN @Periodo   ELSE Periodo   END
AND Ejercicio = CASE WHEN @ConsecutivoPorEjercicio = 1    THEN @Ejercicio ELSE Ejercicio END
AND Empresa   = CASE WHEN @ConsecutivoPorEmpresa   = 'SI' THEN @Empresa   ELSE Empresa  END
AND Sucursal  = CASE WHEN @ConsecutivoSucursalEsp  = 1    THEN @Sucursal  ELSE Sucursal END
IF @RHID IS NOT NULL
BEGIN
SELECT @RHMov = Mov, @RHMovID = MovID FROM RH WHERE ID = @RHID
EXEC spRH @RHID, 'RH', @Accion, 'TODO', @FechaRegistro, NULL, @Usuario, 0, 0, @RHMov, @RHMovID OUTPUT, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
END
END ELSE
BEGIN
INSERT RH (Sucursal, SucursalOrigen, Empresa,  Mov,    FechaEmision,  Proyecto,  Usuario,  Moneda,     TipoCambio,     OrigenTipo, Origen, OrigenID, Estatus)
VALUES (@Sucursal, @Sucursal,     @Empresa, @RHMov, @FechaEmision, @Proyecto, @Usuario, @MovMoneda, @MovTipoCambio, @Modulo,    @Mov,   @MovID,   'CONFIRMAR')
SELECT @RHID = SCOPE_IDENTITY()
SELECT @Renglon = 0
DECLARE crGenerarBaja CURSOR FOR
SELECT DISTINCT d.Personal
FROM NominaD d
WHERE ID = @ID AND NULLIF(RTRIM(d.Personal), '') IS NOT NULL
OPEN crGenerarBaja
FETCH NEXT FROM crGenerarBaja INTO @Personal
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @Renglon = @Renglon + 2048.0
INSERT RHD (
ID,    Renglon,  Personal, SueldoDiario, SDI, TipoContrato, VencimientoContrato, PeriodoTipo, Jornada, TipoSueldo, Puesto, Departamento, Categoria, Grupo, SucursalTrabajo, CentroCostos, FechaAlta, FechaAntiguedad, Plaza)
SELECT @RHID, @Renglon, Personal, SueldoDiario, SDI, TipoContrato, VencimientoContrato, PeriodoTipo, Jornada, TipoSueldo, Puesto, Departamento, Categoria, Grupo, SucursalTrabajo, CentroCostos, FechaAlta, FechaAntiguedad, Plaza
FROM Personal
WHERE Personal = @Personal
END
FETCH NEXT FROM crGenerarBaja INTO @Personal
END  
CLOSE crGenerarBaja
DEALLOCATE crGenerarBaja
EXEC spRH @RHID, 'RH', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, @RHMov, @RHMovID OUTPUT, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
END
IF @RHID IS NOT NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'RH', @RHID, @RHMov, @RHMovID, @Ok OUTPUT
RETURN
END

