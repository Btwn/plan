SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContRegCancelar
@ID		int,
@Ok		int          OUTPUT,
@OkRef	varchar(255) OUTPUT

AS BEGIN
INSERT ContReg (
ID, Empresa, Sucursal, Modulo, ModuloID, ModuloRenglon, ModuloRenglonSub, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Debe,  Haber)
SELECT ID, Empresa, Sucursal, Modulo, ModuloID, ModuloRenglon, ModuloRenglonSub, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, -Debe, -Haber
FROM ContReg
WHERE ID = @ID
RETURN
END

