SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContCopiar
@ID			int,
@Empresa		char(5),
@Usuario		char(10),
@Mov			char(20),
@Referencia		varchar(50),
@Voltear		bit,
@CopiarID		int	OUTPUT,
@EmpresaControladora	bit 	= 0,
@OrigenTipo		varchar(10)	= NULL,
@Origen		varchar(20)	= NULL,
@OrigenID		varchar(20)	= NULL,
@OrigenEmpresa	varchar(5)	= NULL,
@FactorIntegracion	float		= NULL

AS BEGIN
INSERT Cont (
Empresa,  Usuario,  Mov,  Referencia,  Estatus,      UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, FechaEmision, FechaContable, Concepto, Proyecto, UEN, Intercompania, Moneda, TipoCambio, Observaciones, OrigenEmpresa,  OrigenTipo,  Origen,  OrigenID,  FactorIntegracion)
SELECT @Empresa, @Usuario, @Mov, @Referencia, 'SINAFECTAR', UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, FechaEmision, FechaContable, Concepto, Proyecto, UEN, Intercompania, Moneda, TipoCambio, Observaciones, @OrigenEmpresa, @OrigenTipo, @Origen, @OrigenID, @FactorIntegracion
FROM Cont
WHERE ID = @ID
SELECT @CopiarID = SCOPE_IDENTITY()
IF @Voltear = 0
BEGIN
INSERT ContD (
ID,        Empresa,  Renglon, RenglonSub, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Campo, Concepto, Articulo, DepartamentoDetallista, ContactoEspecifico, Debe,			   Debe2,		     Haber,		       Haber2,			  SucursalContable, Sucursal, Presupuesto, Ejercicio, Periodo, FechaContable)
SELECT @CopiarID, @Empresa, Renglon, RenglonSub, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Campo, Concepto, Articulo, DepartamentoDetallista, ContactoEspecifico, Debe*@FactorIntegracion, Debe2*@FactorIntegracion, Haber*@FactorIntegracion, Haber2*@FactorIntegracion, SucursalContable, Sucursal, Presupuesto, Ejercicio, Periodo, FechaContable
FROM ContD
WHERE ID = @ID
INSERT ContReg (
ID,        Empresa,  Sucursal, Modulo, ModuloID, ModuloRenglon, ModuloRenglonSub, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, Debe,			   Haber,		     ContactoEspecifico)
SELECT @CopiarID, @Empresa, Sucursal, Modulo, ModuloID, ModuloRenglon, ModuloRenglonSub, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, Debe*@FactorIntegracion, Haber*@FactorIntegracion, ContactoEspecifico
FROM ContReg
WHERE ID = @ID
END ELSE
BEGIN
INSERT ContD (
ID,        Empresa,  Renglon, RenglonSub, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Campo, Concepto, Articulo, DepartamentoDetallista, ContactoEspecifico, Debe,			    Debe2,		       Haber,			 Haber2,		   SucursalContable, Sucursal, Presupuesto, Ejercicio, Periodo, FechaContable)
SELECT @CopiarID, @Empresa, Renglon, RenglonSub, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Campo, Concepto, Articulo, DepartamentoDetallista, ContactoEspecifico, Haber*@FactorIntegracion, Haber2*@FactorIntegracion, Debe*@FactorIntegracion,  Debe2*@FactorIntegracion, SucursalContable, Sucursal, Presupuesto, Ejercicio, Periodo, FechaContable
FROM ContD
WHERE ID = @ID
INSERT ContReg (
ID,        Empresa,  Sucursal, Modulo, ModuloID, ModuloRenglon, ModuloRenglonSub, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, Debe,			    Haber,		     ContactoEspecifico)
SELECT @CopiarID, @Empresa, Sucursal, Modulo, ModuloID, ModuloRenglon, ModuloRenglonSub, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, Haber*@FactorIntegracion, Debe*@FactorIntegracion, ContactoEspecifico
FROM ContReg
WHERE ID = @ID
END
IF @EmpresaControladora = 1
INSERT ContSocio (ID, Socio, Participacion)
SELECT @CopiarID, Socio, Participacion
FROM ContSocio
WHERE ID = @ID
RETURN
END

