SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spImpTotalBonifMAVI
@ID			int

AS BEGIN
DECLARE
@MoratorioAPagar		money,
@Origen				varchar(20),
@OrigenID			varchar(20),
@Aplica				varchar(20),
@AplicaID           varchar(20),
@ImporteReal		money,
@ImporteAPagar		money,
@ImporteACondonar	money,
@Bonificacion		money,
@IDT				int
DECLARE crSdoTotalBon CURSOR FOR
SELECT ID, Mov, MovID, ImporteAPagar, MoratorioAPagar, ImporteACondonar, Bonificacion, Origen, OrigenId
FROM NegociaMoratoriosMAVI WHERE IDCobro = @ID
OPEN crSdoTotalBon
FETCH NEXT FROM crSdoTotalBon INTO @IDT, @Aplica, @AplicaID, @ImporteAPagar, @MoratorioAPagar, @ImporteACondonar, @Bonificacion, @Origen, @OrigenID
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
UPDATE NegociaMoratoriosMAVI
SET TotalAPagar = ROUND((ISNULL(@ImporteAPagar,0) + ISNULL(@MoratorioAPagar,0) - ISNULL(@ImporteACondonar,0)) - ISNULL(@Bonificacion,0),2)
WHERE Origen = @Origen AND OrigenID = @OrigenID AND IDCobro = @ID AND ID = @IDT
END
FETCH NEXT FROM crSdoTotalBon INTO @IDT, @Aplica, @AplicaID, @ImporteAPagar, @MoratorioAPagar, @ImporteACondonar, @Bonificacion, @Origen, @OrigenID
END
CLOSE crSdoTotalBon
DEALLOCATE crSdoTotalBon
RETURN
END

