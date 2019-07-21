SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpRecalcularSaldoMovVigentes
@Modulo		char(5),
@ID          int,
@DRenglon    float, 
@Mov			varchar(20),
@MovID		varchar(20),
@Personal	char(10),
@Monto		money,
@Saldo		money OUTPUT,
@DID         int = NULL
AS
BEGIN
DECLARE
@MovTipo	char(20),
@Clave		char(20),
@Referencia varchar(50)
SELECT @MovTipo = Clave FROM MovTipo WHERE Mov = @Mov AND Modulo = @Modulo
IF @Modulo = 'NOM' AND @MovTipo IN ('NOM.PD','NOM.PI')
BEGIN
SELECT @Monto = Monto FROM NominaCorrespondeLote WHERE IDNomina = @ID AND ID = @DID AND Comando = 'SALDO' AND Personal = @Personal AND DRenglon=@DRenglon 
SELECT @Saldo = ISNULL(@Saldo,0) - ISNULL(@Monto,0)
END
RETURN
END

