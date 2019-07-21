SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNominaBajaVacaciones
@Accion				char(20),
@Sucursal			int,
@Empresa	      		char(5),
@FechaEmision      	datetime,
@Proyecto	      	varchar(50),
@Usuario	      		char(10),
@Modulo	      		char(5),
@ID					int,
@Mov	  	      		char(20),
@MovID             	varchar(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaRegistro		datetime,
@Ok                	int          OUTPUT,
@OkRef             	varchar(255) OUTPUT

AS BEGIN
DECLARE
@NomID						int,
@NomMov						char(20),
@NomMovID					varchar(20),
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
INSERT Nomina (Sucursal,  SucursalOrigen, Empresa,  Mov,     FechaEmision,  Proyecto,  Usuario,  Moneda,     TipoCambio,     OrigenTipo, Origen, OrigenID, Estatus)
VALUES (@Sucursal, @Sucursal,      @Empresa, @NomMov, @FechaEmision, @Proyecto, @Usuario, @MovMoneda, @MovTipoCambio, @Modulo,    @Mov,   @MovID,   'CONFIRMAR')
SELECT @NomID = SCOPE_IDENTITY()
INSERT NominaD (ID,  Renglon, Personal, Modulo, Cantidad, FechaD)
SELECT @NomID, MIN(d.Renglon), d.Personal, 'NOM', v.Vacaciones, @FechaEmision
FROM NominaD d, PersonalVacaciones v
WHERE v.Empresa = @Empresa AND d.Personal = v.Personal AND d.ID = @ID AND NULLIF(v.Vacaciones, 0) IS NOT NULL
GROUP BY d.Personal, v.Vacaciones
IF @@ROWCOUNT > 0
EXEC spNomina @NomID, 'NOM', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, @NomMov, @NomMovID OUTPUT, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT 
ELSE
DELETE Nomina WHERE ID = @NomID
END
RETURN
END

