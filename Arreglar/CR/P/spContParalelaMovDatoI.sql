SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spContParalelaMovDatoI
@Modulo			varchar(5),
@ModuloID		int

AS
BEGIN
IF NOT EXISTS(SELECT ID FROM ContParalelaMovDato WHERE Modulo = @Modulo AND ModuloID = @ModuloID)
BEGIN
IF @Modulo = 'COMS'
INSERT INTO ContParalelaMovDato(
Modulo,  ModuloID, Fecha,                              Moneda, TipoCambio)
SELECT @Modulo, @ModuloID, ISNULL(FechaEntrega, FechaEmision), Moneda, TipoCambio
FROM Compra
WHERE ID = @ModuloID
IF @Modulo = 'GAS'
INSERT INTO ContParalelaMovDato(
Modulo,  ModuloID, Fecha,        Moneda, TipoCambio)
SELECT @Modulo, @ModuloID, FechaEmision, Moneda, TipoCambio
FROM Gasto
WHERE ID = @ModuloID
IF @Modulo = 'VTAS'
INSERT INTO ContParalelaMovDato(
Modulo,  ModuloID, Fecha,                              Moneda, TipoCambio)
SELECT @Modulo, @ModuloID, ISNULL(FechaEntrega, FechaEmision), Moneda, TipoCambio
FROM Venta
WHERE ID = @ModuloID
END
RETURN
END

