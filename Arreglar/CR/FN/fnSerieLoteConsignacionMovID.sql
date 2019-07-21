SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnSerieLoteConsignacionMovID
(
@Modulo				varchar(5),
@ModuloID				int
)
RETURNS varchar(20)

AS BEGIN
DECLARE
@Resultado	varchar(20)
IF @Modulo = 'VTAS'  SELECT @Resultado = MovID FROM Venta WHERE ID = @ModuloID ELSE
IF @Modulo = 'COMS'  SELECT @Resultado = MovID FROM Compra WHERE ID = @ModuloID ELSE
IF @Modulo = 'AF'    SELECT @Resultado = MovID FROM ActivoFijo WHERE ID = @ModuloID ELSE
IF @Modulo = 'VALE'  SELECT @Resultado = MovID FROM Vale WHERE ID = @ModuloID ELSE
IF @Modulo = 'TMA'   SELECT @Resultado = MovID FROM TMA WHERE ID = @ModuloID ELSE
IF @Modulo = 'PROD'  SELECT @Resultado = MovID FROM Prod WHERE ID = @ModuloID ELSE
IF @Modulo = 'INV'   SELECT @Resultado = MovID FROM Inv WHERE ID = @ModuloID ELSE
IF @Modulo = 'OFER'  SELECT @Resultado = MovID FROM Oferta WHERE ID = @ModuloID ELSE
IF @Modulo = 'EMB'   SELECT @Resultado = MovID FROM Embarque WHERE ID = @ModuloID
RETURN (@Resultado)
END

