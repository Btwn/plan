SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spInsertarCxcAnticipoAplicarTemp
@Empresa		varchar(5),
@Cliente		varchar(10),
@PedidoID		int,
@Estacion		int

AS
BEGIN
DELETE CxcAnticipoPendienteTemp WHERE Estacion = @Estacion
INSERT CxcAnticipoPendienteTemp(
Estacion, ID, Empresa, Mov, MovID, FechaEmision, Referencia, Cliente, Concepto, AnticipoSaldo, Moneda, TipoCambio, Importe,
Impuestos, Retencion, AnticipoAplicar)
SELECT
@Estacion, ID, Empresa, Mov, MovID, FechaEmision,  Referencia, Cliente, Concepto, AnticipoSaldo, Moneda, TipoCambio, Importe,
Impuestos, Retencion, AnticipoAplicar
FROM Cxc
WITH(NOLOCK) WHERE Empresa = @Empresa
AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
AND AnticipoSaldo > 0.0
AND Cliente = @Cliente
AND PedidoReferenciaID = @PedidoID
DELETE CxcAnticipoPendienteTemp2 WHERE Estacion = @Estacion
INSERT CxcAnticipoPendienteTemp2(
Estacion, ID, Empresa, Mov, MovID, FechaEmision, Referencia, Cliente, Concepto, AnticipoSaldo, Moneda, TipoCambio, Importe,
Impuestos, Retencion, AnticipoAplicar)
SELECT
@Estacion, ID, Empresa, Mov, MovID, FechaEmision,  Referencia, Cliente, Concepto, AnticipoSaldo, Moneda, TipoCambio, Importe,
Impuestos, Retencion, AnticipoAplicar
FROM Cxc
WITH(NOLOCK) WHERE Empresa = @Empresa
AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
AND AnticipoSaldo > 0.0
AND Cliente = @Cliente
AND PedidoReferenciaID IS NULL
END

