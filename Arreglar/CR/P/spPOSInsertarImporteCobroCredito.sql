SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSInsertarImporteCobroCredito
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
SELECT @Importe = CONVERT(float,@Codigo)
UPDATE POSLVenta SET Precio = ISNULL(@Importe,0.0), PrecioImpuestoInc = ISNULL(@Importe,0.0)
WHERE ID = @ID  AND Renglon = 2048.0
UPDATE POSL SET Importe = ISNULL(@Importe,0.0)
WHERE ID = @ID
END

