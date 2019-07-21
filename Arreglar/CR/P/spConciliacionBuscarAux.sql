SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spConciliacionBuscarAux
@Empresa		char(5),
@MovTipo		varchar(20),
@DineroID		int,
@CtaDinero		varchar(10),
@Cuenta			varchar(20),
@Cargo			money,
@Abono			money,
@Auxiliar 		int		OUTPUT,
@ContD 			int		OUTPUT,
@CfgTolerancia		int,
@Ok 			int		OUTPUT,
@OkRef 			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@DineroMov		varchar(20),
@DineroMovID	varchar(20),
@ContID		int
IF @Ok IS NOT NULL RETURN
SELECT @Auxiliar = NULL, @ContD = NULL, @Cargo = NULLIF(@Cargo, 0.0), @Abono = NULLIF(@Abono, 0.0)
SELECT @DineroMov = Mov, @DineroMovID = MovID, @ContID = ContID FROM Dinero WHERE ID = @DineroID
IF @Cargo IS NOT NULL
SELECT @Auxiliar = MIN(ID)
FROM Auxiliar
WHERE Empresa = @Empresa AND Rama = 'DIN' AND Mov = @DineroMov AND MovID = @DineroMovID AND Modulo = 'DIN' AND ModuloID = @DineroID AND Cuenta = @CtaDinero AND ROUND(Cargo, @CfgTolerancia) = ROUND(@Cargo, @CfgTolerancia)
ELSE
IF @Abono IS NOT NULL
SELECT @Auxiliar = MIN(ID)
FROM Auxiliar
WHERE Empresa = @Empresa AND Rama = 'DIN' AND Mov = @DineroMov AND MovID = @DineroMovID AND Modulo = 'DIN' AND ModuloID = @DineroID AND Cuenta = @CtaDinero AND ROUND(Abono, @CfgTolerancia) = ROUND(@Abono, @CfgTolerancia)
IF @MovTipo = 'CONC.BC'
IF (SELECT Estatus FROM Cont WHERE ID = @ContID) = 'CONCLUIDO'
BEGIN
IF @Cargo IS NOT NULL
SELECT @ContD = MIN(RID)
FROM ContD
WHERE ID = @ContID
AND Cuenta = @Cuenta
AND Conciliado = 0
AND ROUND(ISNULL(Debe, 0.0),  @CfgTolerancia) = ROUND(@Cargo, @CfgTolerancia)
ELSE
IF @Abono IS NOT NULL
SELECT @ContD = MIN(RID)
FROM ContD
WHERE ID = @ContID
AND Cuenta = @Cuenta
AND Conciliado = 0
AND ROUND(ISNULL(Haber, 0.0),  @CfgTolerancia) = ROUND(@Abono, @CfgTolerancia)
END
IF @Auxiliar IS NULL SELECT @Ok = 51140 ELSE
IF @MovTipo = 'CONC.BC' AND @ContD IS NULL SELECT @Ok = 51150
RETURN
END

