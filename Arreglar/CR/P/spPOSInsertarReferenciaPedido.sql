SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSInsertarReferenciaPedido
@Empresa           varchar(5),
@Sucursal          int,
@Usuario           varchar(10),
@Estacion          int,
@ID                int,
@IDPOS             varchar(36),
@SaldoTotal        float = NULL

AS
BEGIN
DECLARE
@PedidoReferencia		varchar(50),
@Host                   varchar(20),
@Caja                   varchar(10),
@Orden                  int
SELECT @PedidoReferencia = Mov + ' '+ MovID
FROM POSVentaPedidoTemp
WHERE Estacion = @Estacion AND ID = @ID
SELECT @Host = Host , @Caja = Caja
FROM POSL
WHERE ID = @IDPOS
UPDATE POSL SET PedidoReferencia = @PedidoReferencia, PedidoReferenciaID = @ID, CXCSaldoTotal = @SaldoTotal
WHERE ID = @IDPOS
DELETE POSConceptoCXCTemp WHERE Estacion = @Estacion
INSERT POSConceptoCXCTemp(
Estacion, Concepto)
SELECT
@Estacion, Concepto
FROM Concepto
WHERE Modulo = 'CXC'
SELECT @Orden = 0
UPDATE POSConceptoCXCTemp
SET @Orden = Orden = @Orden + 1
FROM POSConceptoCXCTemp
WHERE Estacion = @Estacion
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
INSERT POSLAccion (
Host,  Caja, Accion)
VALUES (
@Host, @Caja,'INTRODUCIR CONCEPTOCXC' )
END

