SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDineroChequeDevueltoCxp
@Estacion			int,
@DineroID			int,
@Usuario			varchar(10)

AS BEGIN
DECLARE
@Sucursal				int,
@SucursalOrigen		int,
@SucursalDestino		int,
@Empresa				varchar(10),
@Modulo				varchar(5),
@Mov					varchar(20),
@MovID				varchar(20),
@MovTipo				varchar(20),
@MovMoneda			varchar(10),
@MovTipoCambio		float,
@FechaEmision			datetime,
@Proyecto				varchar(50),
@Referencia			varchar(50),
@Observaciones		varchar(100),
@FechaRegistro		datetime,
@Condicion			varchar(50),
@Contacto				varchar(10),
@CtaDinero			varchar(10),
@FormaPago			varchar(50),
@Importe				money,
@Impuestos			money,
@Retencion			money,
@ComisionTotal		money,
@Beneficiario			varchar(100),
@CxMov				varchar(20),
@UEN					int,
@IEPSFiscal			float,
@IVAFiscal			float,
@IDGenerar			int,
@Ok					int,
@OkRef				varchar(255),
@Transaccion			varchar(50),
@CxMovID				varchar(20),
@ChequeDevuelto		bit,
@ContactoTipo Varchar(50),
@CxModulo varchar(5),
@Ejercicio int,
@Periodo int,
@CfgMovChequeDevuelto varchar(20),
@Cajero varchar(20),
@DineroMovID varchar(20),
@FEchaAfectacion datetime,
@CxMovTipo varchar(20),
@DineroIDChequeDevuelto int,
@DineroChequeDevueltoMovID varchar(20),
@IDGenerarCD int
SET @Transaccion = 'spDineroGenerarChequeDevuelto' + RTRIM(LTRIM(CONVERT(varchar,ISNULL(@Estacion,0))))
SELECT @FechaAfectacion = getdate()
SELECT @ChequeDevuelto = ISNULL(ChequeDevuelto,0), @ContactoTipo = Contactotipo FROM Dinero WHERE ID = @DineroID
BEGIN TRANSACTION @Transaccion
IF @ChequeDevuelto = 0
BEGIN
SET @Modulo = 'DIN'
SET @FechaRegistro = GETDATE()
SET @FechaEmision = dbo.fnFechaSinHora(@FechaRegistro)
IF @Contactotipo = 'Proveedor'
BEGIN
SELECT
@Sucursal = d.Sucursal,
@SucursalOrigen = d.SucursalOrigen,
@SucursalDestino = d.SucursalDestino,
@Empresa = d.Empresa,
@Mov = d.Mov,
@MovID = d.MovID,
@MovTipo = mt.Clave,
@MovMoneda = d.Moneda,
@MovTipoCambio = d.TipoCambio,
@Proyecto = d.Proyecto,
@Referencia = d.Referencia,
@Observaciones = d.Observaciones,
@Condicion = p.Condicion,
@Contacto = d.Contacto,
@CtaDinero = d.CtaDinero,
@FormaPago = d.FormaPago,
@Importe = d.Importe,
@Impuestos = d.Impuestos,
@Retencion = d.Retencion,
@ComisionTotal = d.Comisiones,
@Beneficiario = d.Beneficiario,
@IVAFiscal = IVAFiscal,
@IEPSFiscal = IEPSFiscal,
@UEN = d.UEN
FROM Dinero d JOIN MovTipo mt
ON mt.Mov = d.Mov AND mt.Modulo = 'DIN' LEFT OUTER JOIN Prov p
ON p.Proveedor = d.Contacto AND d.ContactoTipo = 'Proveedor'
WHERE ID = @DineroID
SELECT @CxModulo = 'CXP'
SELECT @CxMov = CxpChequeDevuelto FROM EmpresaCfgMovCxp WHERE Empresa = @Empresa
UPDATE Dinero SET ChequeDevuelto = 1 WHERE ID = @DineroID IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
INSERT Cxp (Empresa,  Mov,    FechaEmision,  Proyecto,  UEN,  Moneda,     TipoCambio,     ProveedorMoneda, ProveedorTipoCambio, Usuario,  Referencia,  Observaciones,  Estatus,      Proveedor, CtaDinero,  FormaPago,  Importe,  Impuestos,  Retencion,  Beneficiario,  OrigenTipo, Origen, OrigenID, FechaRegistro,  Sucursal,  IVAFiscal,  IEPSFiscal)
VALUES (@Empresa, @CxMov, @FechaEmision, @Proyecto, @UEN, @MovMoneda, @MovTipoCambio, @MovMoneda,      @MovTipoCambio,      @Usuario, @Referencia, @Observaciones, 'SINAFECTAR', @Contacto, @CtaDinero, @FormaPago, @Importe, @Impuestos, @Retencion, @Beneficiario, 'DIN',      @Mov,   @MovID,   @FechaRegistro, @Sucursal, @IVAFiscal, @IEPSFiscal)
SET @IDGenerar = Scope_identity()
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL
BEGIN
INSERT MovImpuesto (
Modulo, ModuloID,   OrigenModulo, OrigenModuloID, OrigenConcepto, OrigenDeducible,	          OrigenFecha, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, Impuesto1, Impuesto2, Impuesto3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, Importe1, Importe2, Importe3, SubTotal, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal)
SELECT @CxModulo,  @IDGenerar, OrigenModulo, OrigenModuloID, OrigenConcepto, ISNULL(OrigenDeducible, 100), OrigenFecha, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, Impuesto1, Impuesto2, Impuesto3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, Importe1, Importe2, Importe3, SubTotal, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal
FROM MovImpuesto
WHERE Modulo = 'DIN' AND ModuloID = @DineroID
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL
EXEC spAfectar @CxModulo, @IDGenerar, 'AFECTAR', 'TODO', NULL, @Usuario, 0, 1, @Ok OUTPUT, @OkRef OUTPUT, @FechaRegistro, 1, @Estacion
IF @Ok IS NULL OR @Ok = 80030
BEGIN
SELECT @CxMovID = MovID FROM CXP WHERE ID = @IDGenerar
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, 'DIN', @DineroID, @Mov, @MovID, @CxModulo, @IDGenerar, @CxMov, @CxMovID, @Ok OUTPUT
END
END
ELSE IF @ContactoTipo = 'Cliente'
BEGIN
SELECT @Ok = 20380, @OkRef = 'El Origen De Este Cheque No es de Cuentas por Pagar'
/*
SELECT
@Sucursal = d.Sucursal,
@SucursalOrigen = d.SucursalOrigen,
@SucursalDestino = d.SucursalDestino,
@Empresa = d.Empresa,
@Mov = d.Mov,
@MovID = d.MovID,
@MovTipo = mt.Clave,
@MovMoneda = d.Moneda,
@MovTipoCambio = d.TipoCambio,
@Proyecto = d.Proyecto,
@Referencia = d.Referencia,
@Observaciones = d.Observaciones,
@Condicion = p.Condicion,
@Contacto = d.Contacto,
@CtaDinero = d.CtaDinero,
@FormaPago = d.FormaPago,
@Importe = d.Importe,
@Impuestos = d.Impuestos,
@Retencion = d.Retencion,
@ComisionTotal = d.Comisiones,
@Beneficiario = d.Beneficiario,
@IVAFiscal = IVAFiscal,
@IEPSFiscal = IEPSFiscal,
@UEN = d.UEN,
@Ejercicio = d.Ejercicio,
@Periodo = d.Periodo,
@Cajero = d.Cajero
FROM Dinero d JOIN MovTipo mt
ON mt.Mov = d.Mov AND mt.Modulo = 'DIN' LEFT OUTER JOIN Cte p
ON p.Cliente = d.Contacto AND d.ContactoTipo = 'Cliente'
WHERE ID = @DineroID
SELECT @CxModulo = 'CXC'
SELECT @CfgMovChequeDevuelto =  NULLIF(RTRIM(BancoChequeDevuelto), '') FROM EmpresaCfgMov WHERE Empresa = @Empresa
SELECT  @CxMov = CxcNCredito from EmpresaCfgMov WHERE Empresa = @Empresa
UPDATE Dinero SET ChequeDevuelto = 1 WHERE ID = @DineroID IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
INSERT Cxc (Empresa,  Mov,    FechaEmision,  Proyecto,  UEN,  Moneda,     TipoCambio,     ClienteMoneda, ClienteTipoCambio, Usuario,  Referencia,  Observaciones,  Estatus,      Cliente, CtaDinero,  FormaCobro,  Importe,  Impuestos,  Retencion,  OrigenTipo, Origen, OrigenID, FechaRegistro,  Sucursal,  IVAFiscal,  IEPSFiscal)
VALUES (@Empresa, @CxMov, @FechaEmision, @Proyecto, @UEN, @MovMoneda, @MovTipoCambio, @MovMoneda,      @MovTipoCambio,      @Usuario, @Referencia, @Observaciones, 'SINAFECTAR', @Contacto, @CtaDinero, @FormaPago, @Importe, @Impuestos, @Retencion, 'DIN',      @Mov,   @MovID,   @FechaRegistro, @Sucursal, @IVAFiscal, @IEPSFiscal)
SET @IDGenerar = Scope_identity()
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL
BEGIN
INSERT MovImpuesto (
Modulo, ModuloID,   OrigenModulo, OrigenModuloID, OrigenConcepto, OrigenDeducible,	          OrigenFecha, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, Impuesto1, Impuesto2, Impuesto3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, Importe1, Importe2, Importe3, SubTotal, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal)
SELECT @CxModulo,  @IDGenerar, OrigenModulo, OrigenModuloID, OrigenConcepto, ISNULL(OrigenDeducible, 100), OrigenFecha, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, Impuesto1, Impuesto2, Impuesto3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, Importe1, Importe2, Importe3, SubTotal, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal
FROM MovImpuesto
WHERE Modulo = 'DIN' AND ModuloID = @DineroID
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL
EXEC spAfectar @CxModulo, @IDGenerar, 'AFECTAR', 'TODO', NULL, @Usuario, 0, 1, @Ok OUTPUT, @OkRef OUTPUT, @FechaRegistro, 1, @Estacion
IF @Ok IS NULL OR @Ok = 80030
BEGIN
SELECT @CxMovID = movID FROM Cxc WHERE ID = @IdGenerar
SELECT @CxMovTipo = Clave FROM MovTipo WHERE Modulo = @CxModulo AND Mov = @CxMov
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, 'DIN', @DineroID, @Mov, @MovID, @CxModulo, @IDGenerar, @CxMov, @CxMovID, @Ok OUTPUT
INSERT Dinero (Sucursal,  SucursalOrigen,  SucursalDestino,  Empresa,  Mov,        MovID,        FechaEmision,     Concepto,  Proyecto,  Moneda,     TipoCambio,     Usuario,  Autorizacion,  Referencia,  DocFuente,  Observaciones,  Estatus,        CtaDinero,  Cajero,  Importe,  Impuestos,  ConDesglose,  FormaPago,  OrigenTipo, Origen, OrigenID, UEN,        FechaProgramada, IVAFiscal,  IEPSFiscal,  Contacto,  ContactoTipo)
VALUES (@Sucursal, @SucursalOrigen, @SucursalDestino, @Empresa, @CfgMovChequeDevuelto, NULL, @FechaAfectacion, NULL, @Proyecto, @MovMoneda, @MovTipoCambio, @Usuario, NULL, @Referencia, NULL, @Observaciones, 'SINAFECTAR', @CtaDinero, @Cajero, @Importe, @Impuestos,  0,            @FormaPago, @CxModulo,    @CxMov,   @CxMovID,   NULL, NULL,    @IVAFiscal, @IEPSFiscal, @Contacto, @ContactoTipo)
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @DineroIDChequeDevuelto = SCOPE_IDENTITY()
EXEC spMovCopiarAnexos @Sucursal, @CxModulo, @IDGenerar, 'DIN', @DineroIDChequeDevuelto
IF @Ok IS NULL AND @DineroIDChequeDevuelto IS NOT NULL
EXEC spDinero @DineroIDChequeDevuelto, 'DIN', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0,
@CfgMovChequeDevuelto OUTPUT, @DineroChequeDevueltoMovID OUTPUT, @IDGenerarCD OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok = 80060 SELECT @Ok = NULL, @OkRef = NULL
IF @Ok IS NULL OR @Ok = 80030
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, 'CXC', @IDGenerar, @CxMov, @CxMovID, 'DIN', @DineroIDChequeDevuelto, @CfgMovChequeDevuelto, @DineroChequeDevueltoMovID, @Ok OUTPUT
END*/
END
END
IF @Ok IS NULL OR @Ok = 80030
BEGIN
COMMIT TRANSACTION @Transaccion
SELECT 'Proceso exitoso.'
END
ELSE
BEGIN
ROLLBACK TRANSACTION @Transaccion
SELECT CONVERT(varchar,@Ok) + '. ' + ISNULL(@OkRef,'')
END
END

