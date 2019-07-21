SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNominaSugerirDisminucionVacaciones
@Accion				char(20),
@Sucursal			int,
@Empresa	      		char(5),
@FechaEmision      	datetime,
@Proyecto	      	varchar(50),
@Usuario	      		char(10),
@Modulo	      		char(5),
@Mov	  	      		char(20),
@MovID             	varchar(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaRegistro		datetime,
@CfgAfectarDisminucionVacaciones bit,
@Ok                	int          OUTPUT,
@OkRef             	varchar(255) OUTPUT

AS BEGIN
DECLARE
@NomID						int,
@NomMov						char(20),
@NomMovID					varchar(20),
@ConDismVac					varchar(50),
@IDGenerar					int,
@ConsecutivoPorPeriodo		bit,
@ConsecutivoPorEjercicio	bit,
@ConsecutivoPorEmpresa		char(20),
@ConsecutivoSucursalEsp		bit,
@Ejercicio					int,
@Periodo					int
SELECT @ConsecutivoPorPeriodo   = ConsecutivoPorPeriodo,
@ConsecutivoPorEjercicio = ConsecutivoPorEjercicio,
@ConsecutivoPorEmpresa   = ISNULL(UPPER(ConsecutivoPorEmpresa), 'SI'),
@ConsecutivoSucursalEsp  = ISNULL(ConsecutivoSucursalEsp, 0)
FROM MovTipo
WHERE Modulo = 'NOM'
AND Mov    = @Mov
SELECT @Ejercicio = YEAR(@FechaRegistro), @Periodo = MONTH(@FechaRegistro)
SELECT @NomMov = NomVacacionesTomadas
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
SELECT @ConDismVac = NomConceptoDisminuirVacaciones
FROM EmpresaCfg
WHERE Empresa = @Empresa
IF @Accion = 'CANCELAR'
BEGIN
SELECT @NomID = NULL
SELECT @NomID = MIN(ID) FROM Nomina WHERE Mov = @NomMov AND OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND Periodo   = CASE WHEN @ConsecutivoPorPeriodo   = 1    THEN @Periodo   ELSE Periodo   END
AND Ejercicio = CASE WHEN @ConsecutivoPorEjercicio = 1    THEN @Ejercicio ELSE Ejercicio END
AND Empresa   = CASE WHEN @ConsecutivoPorEmpresa   = 'SI' THEN @Empresa   ELSE Empresa  END
AND Sucursal  = CASE WHEN @ConsecutivoSucursalEsp  = 1    THEN @Sucursal  ELSE Sucursal END
IF @NomID IS NOT NULL
EXEC spNomina @NomID, 'NOM', @Accion, 'TODO', @FechaRegistro, NULL, @Usuario, 0, 0, @NomMov, @NomMovID OUTPUT, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
END ELSE
BEGIN
IF NOT EXISTS(SELECT * FROM #DisminucionVacaciones) RETURN
INSERT Nomina (Sucursal,  SucursalOrigen, Empresa,  Mov,     FechaEmision,  Proyecto,  Usuario,  Moneda,     TipoCambio,     OrigenTipo, Origen, OrigenID, Estatus)
VALUES (@Sucursal, @Sucursal,      @Empresa, @NomMov, @FechaEmision, @Proyecto, @Usuario, @MovMoneda, @MovTipoCambio, @Modulo,    @Mov,   @MovID,   'CONFIRMAR')
SELECT @NomID = SCOPE_IDENTITY()
INSERT NominaD (ID,  Renglon, Personal, Modulo,  Cantidad, Concepto, FechaD)
SELECT       @NomID, Renglon, Personal, 'NOM',  Cantidad, @NomMov, FechaD
FROM #DisminucionVacaciones
IF @CfgAfectarDisminucionVacaciones = 1
BEGIN
EXEC spNomina @NomID, 'NOM', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, @NomMov, @NomMovID OUTPUT, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000 SELECT @Ok = 80030, @OkRef = ISNULL(@OkRef, '') + '<BR>- '+RTRIM(@NomMov)+' '+RTRIM(@NomMovID)+'(Concluido)'
END
ELSE
SELECT @Ok = 80030, @OkRef = ISNULL(@OkRef, '') + '<BR>- Disminución Vacaciones (por Confirmar)'
END
RETURN
END

