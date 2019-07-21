SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSCancelarComponente
@RID			varchar(36),
@RenglonID		int,
@Articulo       varchar(20),
@Estacion       int

AS
BEGIN
DECLARE
@Cantidad   float
SELECT @Cantidad = Cantidad
FROM POSArtJuegoComponente
WHERE Estacion = @Estacion AND RID = @RID AND RenglonID = @RenglonID AND Articulo = @Articulo
DELETE POSArtJuegoComponente WHERE Estacion = @Estacion
UPDATE POSLVenta SET Cantidad = Cantidad -ISNULL(@Cantidad,0.0)
WHERE ID = @RID AND Articulo = @Articulo AND RenglonID = @RenglonID AND RenglonTipo = 'J'
DELETE POSLVenta WHERE ID = @RID AND Articulo = @Articulo AND RenglonID = @RenglonID AND RenglonTipo = 'J' AND ISNULL(Cantidad,0.0) = 0.0
END

