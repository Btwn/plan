SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnRenglonID(
@Modulo		varchar(10),
@ID int,
@Renglon float,
@RenglonSub int
)
RETURNS int
AS
BEGIN
DECLARE
@RenglonID	int
IF @Modulo = 'VTAS'  SELECT @RenglonID = RenglonID FROM VentaD WITH(NOLOCK) WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub ELSE
IF @Modulo = 'COMS'  SELECT @RenglonID = RenglonID FROM CompraD WITH(NOLOCK) WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub ELSE
IF @Modulo = 'PROD'  SELECT @RenglonID = RenglonID FROM ProdD WITH(NOLOCK) WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub ELSE
IF @Modulo = 'INV'   SELECT @RenglonID = RenglonID FROM InvD WITH(NOLOCK) WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
RETURN @RenglonID
END

