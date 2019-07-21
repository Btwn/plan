SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW cPrevencionLDD
AS
SELECT ID, Renglon, OrigenModulo, OrigenModuloID, Aplica, AplicaId, Importe, ActEconimica, SaldoActual, SaldoAnterior, Variacion, Contacto, ContactoTipo, Sucursal,
SucursalOrigen, Referencia
FROM PrevencionLDD WITH (NOLOCK)

