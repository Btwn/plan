SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spBorrarMonederoMov
@ID           int
AS
BEGIN
DELETE FROM SerieTarjetaMovM WHERE Modulo = 'VTAS' AND ID = @ID
SELECT 'Monedero Electr�nico Eliminado'
RETURN
END

