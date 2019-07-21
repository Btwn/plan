SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spWMSInventarioFisicoCambioArticulo
@Sucursal				int,
@ID						int,
@Empresa				char(5),
@Almacen				char(10),
@IDGenerar				int,
@Base					char(20),
@CfgSeriesLotesMayoreo	bit,
@Estatus				char(15),
@Ok						int				OUTPUT,
@OkRef					varchar(255)	OUTPUT

AS BEGIN
DECLARE @Renglon			float,
@RenglonAnt		float,
@Tarima			varchar(20),
@Articulo			varchar(20),
@RenglonSub		int,
@RenglonSubAnt	int,
@RenglonAux		int,
@RenglonSubAux	int,
@RenglonSubNuevo	int,
@Cantidad			float
SELECT @RenglonAnt = 0
WHILE(1=1)
BEGIN
SELECT @Renglon = MIN(Renglon)
FROM InvD
WHERE ID = @IDGenerar
AND Renglon > @RenglonAnt
IF @Renglon IS NULL BREAK
SELECT @RenglonAnt = @Renglon
SELECT @RenglonSubAnt = -1
WHILE(1=1)
BEGIN
SELECT @RenglonSub = MIN(RenglonSub)
FROM InvD
WHERE ID = @IDGenerar
AND Renglon = @Renglon
AND RenglonSub > @RenglonSubAnt
IF @RenglonSub IS NULL BREAK
SELECT @RenglonSubAnt = @RenglonSub
SELECT @Articulo = NULL, @Tarima = NULL, @Cantidad = NULL, @RenglonAux = NULL, @RenglonSubNuevo = NULL, @RenglonSubAux = NULL
SELECT @Articulo = Articulo, @Tarima = Tarima, @Cantidad = Cantidad FROM InvD WHERE ID = @IDGenerar AND Renglon = @Renglon AND RenglonSub = @RenglonSub
IF @Cantidad > 0
BEGIN
SELECT @RenglonAux = Renglon, @RenglonSubAux = RenglonSub FROM InvD WHERE ID = @IDGenerar AND Renglon > @Renglon AND Articulo <> @Articulo AND Tarima = @Tarima
IF @RenglonAux IS NOT NULL
BEGIN
SELECT @RenglonSubNuevo = MAX(RenglonSub) + 1 FROM InvD WHERE ID = @IDGenerar AND Renglon = @Renglon
UPDATE InvD SET RenglonSub = @RenglonSubNuevo WHERE ID = @IDGenerar AND Renglon = @Renglon AND RenglonSub = @RenglonSub
UPDATE InvD SET Renglon = @Renglon, RenglonSub = @RenglonSub WHERE ID = @IDGenerar AND Renglon = @RenglonAux AND RenglonSub = @RenglonSubAux
END
END
END
END
RETURN
END

