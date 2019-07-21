SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSerieLoteFlujo
@Sucursal			int,
@SucursalAlmacen		int,
@SucursalAlmacenDestino	int,
@Accion			char(20),
@Empresa     		char(5),
@Modulo			char(5),
@ID				int,
@Articulo            	char(20),
@SubCuenta			varchar(50),
@SerieLote           	varchar(50),
@Almacen			char(10),
@RenglonID			int,
@Tarima			varchar(20) = NULL

AS BEGIN
SELECT @Tarima = Tarima
FROM INVd
WHERE Id = @ID
AND seccion = 1
SELECT @SubCuenta = ISNULL(@SubCuenta, ''), @Tarima = ISNULL(@Tarima, '')
IF @Accion = 'CANCELAR'
DELETE SerieLoteD WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND SerieLote = @SerieLote
ELSE
BEGIN
IF @Almacen IS NOT NULL
IF NOT EXISTS(SELECT * FROM SerieLote WHERE Sucursal = @SucursalAlmacen AND Empresa = @Empresa AND Articulo = @Articulo AND SerieLote = @SerieLote AND Tarima = @Tarima) AND @Tarima IS NULL
INSERT SerieLote (Sucursal,         Empresa,  Articulo,  SubCuenta,  SerieLote,  Almacen,  Tarima)
VALUES (@SucursalAlmacen, @Empresa, @Articulo, @SubCuenta, @SerieLote, @Almacen, @Tarima)
IF NOT EXISTS(SELECT * FROM SerieLoteD WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID AND Articulo = @Articulo AND SerieLote = @SerieLote)
INSERT SerieLoteD (Sucursal,         Empresa,  Modulo,  ID,  RenglonID,  Articulo,  SubCuenta,  SerieLote)
VALUES (@SucursalAlmacen, @Empresa, @Modulo, @ID, @RenglonID, @Articulo, @SubCuenta, @SerieLote)
END
RETURN
END

