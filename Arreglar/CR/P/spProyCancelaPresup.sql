SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spProyCancelaPresup
@IDProyecto int,
@Empresa	varchar(20),
@Sucursal	int,
@Mov        varchar(100),
@MovID      varchar(20),
@Usuario	varchar(50),
@EstacionSp	int

AS BEGIN
DECLARE @DModuloCancela		varchar(20),
@DIDCancela			int
IF EXISTS(SELECT * FROM MovFlujo WHERE Empresa = @Empresa AND Sucursal = @Sucursal AND OModulo = 'PROY' AND OID = @IDProyecto
AND OMov = @Mov AND OMovID = @MovID AND DMov Like 'Presupuesto%' AND Cancelado = 0)
BEGIN
DECLARE crCancelaPresupuestos CURSOR LOCAL FOR
SELECT DModulo, DID FROM MovFlujo WHERE Empresa = @Empresa AND Sucursal = @Sucursal AND OModulo = 'PROY' AND OID = @IDProyecto
AND OMov = @Mov AND OMovID = @MovID AND DMov Like 'Presupuesto%' AND Cancelado = 0
OPEN crCancelaPresupuestos
FETCH NEXT FROM crCancelaPresupuestos INTO @DModuloCancela, @DIDCancela
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
EXEC spAfectar @DModuloCancela, @DIDCancela, 'CANCELAR', 'Todo', NULL, @Usuario, @Estacion=@EstacionSp
FETCH NEXT FROM crCancelaPresupuestos INTO @DModuloCancela, @DIDCancela
END
CLOSE crCancelaPresupuestos
DEALLOCATE crCancelaPresupuestos
END
END

