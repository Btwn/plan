SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSInsertarReferenciaDevolucion
@Empresa           varchar(5),
@Sucursal          int,
@Usuario           varchar(10),
@Estacion          int,
@ID                int,
@IDPOS             varchar(36)

AS
BEGIN
DECLARE
@Aplica             varchar(20),
@AplicaID           varchar(20),
@Host               varchar(20),
@Caja               varchar(10),
@Orden              int,
@CXCSaldoTotal		float,
@CXCSaldo           float
SELECT @Aplica = Mov , @AplicaID  = MovID, @CXCSaldoTotal = ImporteTotal, @CXCSaldo = ImporteTotal
FROM POSCxcAnticipoTemp
WHERE Estacion = @Estacion AND ID = @ID
SELECT @Host = Host , @Caja = Caja
FROM POSL
WHERE ID = @IDPOS
IF EXISTS (SELECT * FROM POSLVenta WHERE ID = @IDPOS)
DELETE POSLVenta WHERE ID = @IDPOS
INSERT POSLVenta(
ID, Renglon, RenglonID, RenglonTipo, Articulo, Cantidad, Aplica, AplicaID, Precio, PrecioImpuestoInc)
SELECT
@IDPOS, 2048.0, 1, 'K', 'DEVOLUCION', 1, @Aplica, @AplicaID, -@CXCSaldo, -@CXCSaldo
UPDATE POSL SET CXCSaldoTotal = @CXCSaldoTotal WHERE ID = @IDPOS
END

