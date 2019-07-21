SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCorregirRedondeo
AS BEGIN
DECLARE
@RedondeoMonetarios		int,
@WMSAuxiliar	            bit 
SET NOCOUNT ON
SELECT @WMSAuxiliar = WMSAuxiliar FROM Version 
SELECT @RedondeoMonetarios = dbo.fnRedondeoMonetarios()
update Auxiliar set cargo = round(cargo, @RedondeoMonetarios), abono = round(abono, @RedondeoMonetarios)
update Acum set cargos = round(cargos, @RedondeoMonetarios), abonos = round(abonos, @RedondeoMonetarios)
update Saldo set saldo = round(saldo, @RedondeoMonetarios)
IF @WMSAuxiliar = 1 
BEGIN
update AuxiliarUWMS set cargo = round(cargo, @RedondeoMonetarios), abono = round(abono, @RedondeoMonetarios)
update AcumUWMS set cargos = round(cargos, @RedondeoMonetarios), abonos = round(abonos, @RedondeoMonetarios)
update SaldoUWMS set Saldo = round(Saldo, @RedondeoMonetarios)
update AuxiliarU set cargo = round(cargo, @RedondeoMonetarios), abono = round(abono, @RedondeoMonetarios)
update AcumU set cargos = round(cargos, @RedondeoMonetarios), abonos = round(abonos, @RedondeoMonetarios)
update SaldoU set Saldo = round(Saldo, @RedondeoMonetarios)
END ELSE BEGIN 
EXEC dbo.sp_executesql N'
update AuxiliarU set cargo = round(cargo, @RedondeoMonetarios), abono = round(abono, @RedondeoMonetarios)
update AcumU set cargos = round(cargos, @RedondeoMonetarios), abonos = round(abonos, @RedondeoMonetarios)
update SaldoU set Saldo = round(Saldo, @RedondeoMonetarios)',
N'@RedondeoMonetarios int', @RedondeoMonetarios
END 
update AuxiliarRU set cargo = round(cargo, @RedondeoMonetarios), abono = round(abono, @RedondeoMonetarios)
update AcumRU set cargos = round(cargos, @RedondeoMonetarios), abonos = round(abonos, @RedondeoMonetarios)
update SaldoRU set saldo = round(saldo, @RedondeoMonetarios)
update Cxc set importe = round(importe, @RedondeoMonetarios), impuestos = round(impuestos, @RedondeoMonetarios), saldo = round(saldo, @RedondeoMonetarios)
update Cxp set importe = round(importe, @RedondeoMonetarios), impuestos = round(impuestos, @RedondeoMonetarios), saldo = round(saldo, @RedondeoMonetarios)
update Gasto set importe = round(importe, @RedondeoMonetarios), impuestos = round(impuestos, @RedondeoMonetarios), saldo = round(saldo, @RedondeoMonetarios)
update Venta set importe = round(importe, @RedondeoMonetarios), impuestos = round(impuestos, @RedondeoMonetarios), saldo = round(saldo, @RedondeoMonetarios)
update Compra set importe = round(importe, @RedondeoMonetarios), impuestos = round(impuestos, @RedondeoMonetarios), saldo = round(saldo, @RedondeoMonetarios)
RETURN
END

