SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSAccionReferenciaPedido
@Empresa           varchar(5),
@Sucursal          int,
@Usuario           varchar(10),
@Estacion          int,
@IDPOS             varchar(36)

AS
BEGIN
DECLARE
@Host           varchar(20),
@Caja           varchar(10),
@MovClave		varchar(20)
SELECT @Host = p.Host , @Caja = p.Caja,  @MovClave = mt.Clave
FROM POSL p JOIN MovTipo mt ON p.Mov = mt.Mov AND mt.Modulo = 'POS'
WHERE p.ID = @IDPOS
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
IF @MovClave = 'POS.FA'
BEGIN
INSERT POSLAccion (
Host,  Caja, Accion)
VALUES (
@Host, @Caja,'REFERENCIAR PEDIDO')
END
IF @MovClave IN('POS.CXCC','POS.CXCD' )
BEGIN
INSERT POSLAccion (
Host,  Caja, Accion)
VALUES (
@Host, @Caja,'REFERENCIAR COBRO' )
END
END

