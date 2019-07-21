SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spPOSInsertarCxcAnticipoAplicarTemp
@Estacion       int,
@IDPOS          varchar(50)

AS
BEGIN
DECLARE
@ID         int,
@Empresa    varchar(5)
SELECT @ID = PedidoReferenciaID, @Empresa = Empresa
FROM POSL WITH (NOLOCK)
WHERE ID = @IDPOS
DELETE CxcAnticipoPendienteTemp WHERE Estacion = @Estacion
INSERT CxcAnticipoPendienteTemp(
Estacion, ID, Empresa, Mov, MovID, FechaEmision, Referencia, Cliente, Concepto, AnticipoSaldo, Moneda, TipoCambio, Importe,
Impuestos, Retencion, AnticipoAplicar)
SELECT
@Estacion, ID, @Empresa, Mov, MovID, FechaEmision,  Referencia, Cliente, Concepto, AnticipoSaldo, Moneda, TipoCambio, Importe,
Impuestos, Retencion, NULL
FROM POSCxcAnticipoTemp WITH (NOLOCK)
WHERE Estacion = @Estacion
AND PedidoReferenciaID = @ID
DELETE CxcAnticipoPendienteTemp2 WHERE Estacion = @Estacion
INSERT CxcAnticipoPendienteTemp2(
Estacion,  ID, Empresa, Mov, MovID, FechaEmision, Referencia, Cliente, Concepto, AnticipoSaldo, Moneda, TipoCambio, Importe,
Impuestos, Retencion, AnticipoAplicar)
SELECT
@Estacion, ID, @Empresa, Mov, MovID, FechaEmision,  Referencia, Cliente, Concepto, AnticipoSaldo, Moneda, TipoCambio, Importe,
Impuestos, Retencion, NULL
FROM POSCxcAnticipoTemp WITH (NOLOCK)
WHERE Estacion = @Estacion
AND PedidoReferenciaID IS NULL
END

