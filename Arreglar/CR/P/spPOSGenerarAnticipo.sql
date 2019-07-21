SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSGenerarAnticipo
@Estacion           int,
@ID                 varchar(36),
@Codigo             varchar(50),
@Ok                 int  OUTPUT,
@OkRef              varchar(255) OUTPUT

AS
BEGIN
DECLARE
@ConceptoCxc       varchar(50),
@ImpuestosPorc     float,
@Impuestos         float,
@ImporteSImp       float,
@Importe           float
SELECT @ConceptoCxc = Concepto
FROM POSL
WHERE ID = @ID
SELECT @ImpuestosPorc = Impuestos
FROM Concepto
WHERE Concepto = @ConceptoCxc AND Modulo = 'CXC'
SELECT @Importe = CONVERT(float,@Codigo)
SELECT @ImporteSImp = ISNULL(@Importe,0.0)/(1+(ISNULL(@ImpuestosPorc,0.0)/100))
SELECT @Impuestos = ISNULL(@Importe,0.0) - ISNULL(@ImporteSImp,0.0)
IF EXISTS(SELECT * FROM POSLVenta WHERE ID = @ID)
DELETE POSLVenta WHERE ID = @ID
INSERT POSLVenta(
ID, Renglon, RenglonID, RenglonTipo, Cantidad, Articulo, Precio, Impuesto1)
SELECT
@ID, 2048.0, 1, 'K', 1, 'ANTICIPO', ISNULL(@ImporteSImp,0.0), @ImpuestosPorc
UPDATE POSLVenta SET PrecioImpuestoInc = @Importe
WHERE ID = @ID
UPDATE POSL SET Importe = @ImporteSImp, Impuestos = @Impuestos
WHERE ID = @ID
END

