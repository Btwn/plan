SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAgregarCapas
@Sucursal		int,
@Sistema		char(1),
@Empresa		char(5),
@Articulo		char(20),
@SubCuenta		varchar(50),
@Fecha		datetime,
@Cantidad		float,
@Costo		float,
@Modulo		char(5),
@Mov			char(20),
@MovID 		varchar(20),
@Ok			int	OUTPUT,
@Almacen		varchar(10)	= NULL,
@ID			int		= NULL,
@Renglon		float		= NULL,
@RenglonSub		int		= NULL,
@OtraMoneda						varchar(10) = NULL, 
@OtraMonedaTipoCambio			float = NULL, 
@OtraMonedaTipoCambioVenta		float = NULL, 
@OtraMonedaTipoCambioCompra		float = NULL  

AS BEGIN
DECLARE
@InvCapaID	int
UPDATE InvCapa WITH(ROWLOCK)
SET @InvCapaID = ID,
Existencia = Existencia + ISNULL(@Cantidad, 0.0)
WHERE Sucursal = @Sucursal
AND Sistema  = @Sistema
AND Empresa  = @Empresa
AND Articulo = @Articulo
AND SubCuenta= @SubCuenta
AND Modulo   = @Modulo
AND Mov      = @Mov
AND MovID    = @MovID
AND Costo    = @Costo
AND Existencia IS NOT NULL
IF @@ROWCOUNT = 0
BEGIN
INSERT INTO InvCapa (Sucursal,  Sistema,  Empresa,  Articulo,  SubCuenta,  Fecha,  Existencia, Costo,  Modulo,  Mov,  MovID,  OtraMoneda,  OtraMonedaTipoCambio,  OtraMonedaTipoCambioVenta,  OtraMonedaTipoCambioCompra) 
VALUES  (@Sucursal, @Sistema, @Empresa, @Articulo, @SubCuenta, @Fecha, @Cantidad,  @Costo, @Modulo, @Mov, @MovID, @OtraMoneda, @OtraMonedaTipoCambio, @OtraMonedaTipoCambioVenta, @OtraMonedaTipoCambioCompra) 
SELECT @InvCapaID = SCOPE_IDENTITY()
END
INSERT InvCapaAux (
ID,         Fecha,  Modulo,  ModuloID, Renglon,  RenglonSub,  Almacen,  CargoU)
VALUES (@InvCapaID, @Fecha, @Modulo, @ID,      @Renglon, @RenglonSub, @Almacen, @Cantidad)
RETURN
END

