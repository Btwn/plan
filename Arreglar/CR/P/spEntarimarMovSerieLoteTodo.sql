SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spEntarimarMovSerieLoteTodo
@Estacion	int,
@RenglonID	int,
@Articulo	varchar(20),
@SubCuenta	varchar(50)

AS BEGIN
UPDATE EntarimarMovSerieLote
SET CantidadA = Cantidad
WHERE Estacion = @Estacion AND RenglonID = @RenglonID AND Articulo = @Articulo AND SubCuenta = ISNULL(NULLIF(@SubCuenta, '0'), '')
RETURN
END

