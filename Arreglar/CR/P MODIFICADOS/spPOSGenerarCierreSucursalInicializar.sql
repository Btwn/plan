SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSGenerarCierreSucursalInicializar
@Empresa        varchar(5),
@Sucursal       int,
@Estacion		int,
@Usuario        varchar(10)

AS
BEGIN
DECLARE
@CajaActual  varchar(10)
SELECT @CajaActual = DefCtaDinero
FROM Usuario WITH (NOLOCK)
WHERE Usuario = @Usuario
DELETE POSCierreSucursalD WHERE Estacion = @Estacion
INSERT POSCierreSucursalD(
Estacion, Sucursal, FormaPago)
SELECT
@Estacion, @Sucursal , plc.FormaPago
FROM POSLCobro plc WITH (NOLOCK) JOIN POSL p WITH (NOLOCK) ON plc.ID = p.ID
JOIN MovTipo mt WITH (NOLOCK) ON p.Mov = mt.Mov AND mt.Modulo = 'POS'
WHERE p.caja  = @CajaActual
AND p.Estatus IN('CONCLUIDO','TRASPASADO')
GROUP BY plc.FormaPago
RETURN
END

