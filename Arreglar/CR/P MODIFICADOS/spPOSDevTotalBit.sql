SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSDevTotalBit
@ID				varchar (36),
@Ofertados		bit

AS
BEGIN
INSERT INTO POSDevolucionTotal (ID, Ofertados) VALUES (@ID, @Ofertados)
END

