SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSLDIMonederoSaldoFavor
@ID				varchar(36),
@Monedero		varchar(20)

AS
BEGIN
DECLARE
@Mensaje	varchar(255)
IF EXISTS(SELECT * FROM POSLDIMonederoSaldoFavor plmsf WHERE plmsf.ID = @ID)
UPDATE POSLDIMonederoSaldoFavor SET Monedero = @Monedero WHERE ID = @ID
ELSE
INSERT POSLDIMonederoSaldoFavor (ID, Monedero) VALUES (@ID, @Monedero)
SELECT @Mensaje = 'Este monedero se utilizará para abonar el Saldo a Favor de este movimiento'
SELECT @Mensaje
END

