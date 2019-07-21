SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgPOSLTipoCambioRefABC ON POSLTipoCambioRef

FOR INSERT,UPDATE, DELETE
AS BEGIN
DECLARE
@SucursalA            int,
@SucursalB            int,
@Mensaje              varchar(255)
SELECT @SucursalA = Sucursal FROM INSERTED
SELECT @SucursalB = Sucursal FROM DELETED
IF @SucursalA IS NOT NULL
BEGIN
IF EXISTS(SELECT * FROM POSLTipoCambioRef WHERE Sucursal = @SucursalA AND EsPrincipal = 1 AND TipoCambio <> 1)
BEGIN
SELECT @Mensaje = 'La moneda principal debe de tener tipo de cambio = 1.0'
RAISERROR (@Mensaje,16,-1)
END
IF NOT EXISTS(SELECT * FROM POSLTipoCambioRef WHERE Sucursal = @SucursalA AND EsPrincipal = 1) AND NOT EXISTS(SELECT * FROM POSLTipoCambioRef WHERE Sucursal = @SucursalA AND EsPrincipal = 1)
BEGIN
SELECT @Mensaje = 'Es necesario asignar una moneda principal'
RAISERROR (@Mensaje,16,-1)
END
IF (SELECT COUNT(*) FROM POSLTipoCambioRef WHERE Sucursal = @SucursalA AND EsPrincipal = 1)>1
BEGIN
SELECT @Mensaje = 'Solo una moneda puede ser principal'
RAISERROR (@Mensaje,16,-1)
END
END
END

