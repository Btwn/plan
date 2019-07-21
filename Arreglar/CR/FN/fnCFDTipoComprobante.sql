SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCFDTipoComprobante
(@Modulo			varchar(20),
@Id        		Int)
RETURNS varchar(100)
AS BEGIN
DECLARE
@Mov  varchar(20),
@Resultado varchar(100)
IF @Modulo = 'VTAS'  SELECT @Mov = Mov FROM Venta		WHERE ID = @ID ELSE
IF @Modulo = 'INV'   SELECT @Mov = Mov FROM Inv		WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  SELECT @Mov = Mov FROM Compra	WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   SELECT @Mov = Mov FROM Cxc       WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   SELECT @Mov = Mov FROM Cxp       WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   SELECT @Mov = Mov FROM Gasto     WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   SELECT @Mov = Mov FROM Dinero    WHERE ID = @ID
SELECT @Resultado = CASE CFD_tipoDeComprobante WHEN  'INGRESO' THEN 'I' WHEN 'EGRESO' THEN 'E' WHEN 'TRASLADO' THEN 'T' END
FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov
RETURN (@Resultado)
END

