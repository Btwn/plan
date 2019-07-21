SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnOportunidadMovimientoGestion(
@ID			int)
RETURNS varchar(50)
AS
BEGIN
DECLARE @Valor	varchar(50)
SELECT @Valor = RTRIM(Mov) + ' ' + RTRIM(MovID) FROM Gestion WITH(NOLOCK) WHERE ID = @ID
RETURN @Valor
END

