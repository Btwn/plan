SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvQuitarBasura
@Empresa      		char(5),
@Modulo	      		char(5),
@ID                  	int,
@Conexion			bit,
@SincroFinal			bit,
@Sucursal			int

AS BEGIN
DECLARE
@Borrar	bit,
@RenglonID	int,
@Articulo	char(20)
IF @Conexion = 0
BEGIN TRANSACTION
DECLARE crSerieLoteMov CURSOR FOR
SELECT DISTINCT RenglonID, Articulo FROM SerieLoteMov WITH(NOLOCK) WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID
OPEN crSerieLoteMov
FETCH NEXT FROM crSerieLoteMov INTO @RenglonID, @Articulo
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Borrar = 0
IF @Modulo = 'VTAS' IF NOT EXISTS(SELECT * FROM VentaD WITH(NOLOCK) WHERE ID = @ID AND RenglonID = @RenglonID AND Articulo = @Articulo) SELECT @Borrar = 1
IF @Modulo = 'COMS' IF NOT EXISTS(SELECT * FROM CompraD WITH(NOLOCK) WHERE ID = @ID AND RenglonID = @RenglonID AND (Articulo = @Articulo OR ArticuloMaquila = @Articulo)) SELECT @Borrar = 1
IF @Modulo = 'INV'  IF NOT EXISTS(SELECT * FROM InvD   WITH(NOLOCK) WHERE ID = @ID AND RenglonID = @RenglonID AND Articulo = @Articulo) SELECT @Borrar = 1
IF @Modulo = 'PROD' IF NOT EXISTS(SELECT * FROM ProdD  WITH(NOLOCK) WHERE ID = @ID AND RenglonID = @RenglonID AND Articulo = @Articulo) SELECT @Borrar = 1
IF @Borrar = 1
DELETE SerieLoteMov WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID AND RenglonID = @RenglonID AND Articulo = @Articulo
END
FETCH NEXT FROM crSerieLoteMov INTO @RenglonID, @Articulo
END
CLOSE crSerieLoteMov
DEALLOCATE crSerieLoteMov
IF @Conexion = 0
COMMIT TRANSACTION
END

