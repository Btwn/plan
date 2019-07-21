SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCfgRegistroABC ON CfgRegistro

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@CfgRegistroN	int,
@CfgRegistroA	int
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @CfgRegistroN = CfgRegistro FROM Inserted
SELECT @CfgRegistroA = CfgRegistro FROM Deleted
IF @CfgRegistroN = @CfgRegistroA RETURN
IF @CfgRegistroA IS NULL
BEGIN
INSERT CfgRegistroCuenta (CfgRegistro, Referencia) VALUES (@CfgRegistroN, 'Cuentas por Cobrar')
INSERT CfgRegistroCuenta (CfgRegistro, Referencia) VALUES (@CfgRegistroN, 'Cuentas por Pagar')
INSERT CfgRegistroCuenta (CfgRegistro, Referencia) VALUES (@CfgRegistroN, 'Impuestos por Cobrar')
INSERT CfgRegistroCuenta (CfgRegistro, Referencia) VALUES (@CfgRegistroN, 'Impuestos por Pagar')
INSERT CfgRegistroCuenta (CfgRegistro, Referencia) VALUES (@CfgRegistroN, 'Ventas')
INSERT CfgRegistroCuenta (CfgRegistro, Referencia) VALUES (@CfgRegistroN, 'Costo Ventas')
INSERT CfgRegistroCuenta (CfgRegistro, Referencia) VALUES (@CfgRegistroN, 'Inventarios')
INSERT CfgRegistroCuenta (CfgRegistro, Referencia) VALUES (@CfgRegistroN, 'Tersoreria')
INSERT CfgRegistroCuenta (CfgRegistro, Referencia) VALUES (@CfgRegistroN, 'Gastos')
INSERT CfgRegistroCuenta (CfgRegistro, Referencia) VALUES (@CfgRegistroN, 'Activos Fijos')
END ELSE
IF @CfgRegistroN IS NULL
BEGIN
DELETE CfgRegistroCuenta WHERE CfgRegistro = @CfgRegistroA
END ELSE
BEGIN
UPDATE CfgRegistroCuenta SET CfgRegistro = @CfgRegistroN WHERE CfgRegistro = @CfgRegistroA
END
END

