SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spInvGenerarRetencionesCompra
@Fiscal						bit,
@FiscalGenerarRetenciones	bit,
@CfgRetencionAlPago			bit,
@MovTipo     				char(20),
@SumaRetencion				money,
@SumaRetencion2				money,
@SumaRetencion3				money,
@CfgRetencionAcreedor		char(10),
@Sucursal					int,
@SucursalOrigen				int,
@SucursalDestino			int,
@Accion						char(20),
@Empresa	      			char(5),
@Modulo	      				char(5),
@ID                			int,
@Mov	  	      			char(20),
@MovID             			varchar(20),
@MovMoneda	      			char(10),
@MovTipoCambio	 			float,
@FechaEmision				datetime,
@CfgRetencionConcepto		varchar(50),
@Proyecto					varchar(50),
@Usuario					char(10),
@Autorizacion      			char(10),
@DocFuente	      			int,
@Observaciones     			varchar(255),
@FechaRegistro				datetime,
@Ejercicio					int,
@Periodo					int,
@CfgRetencionMov			char(20),
@CfgRetencion2Acreedor		char(10),
@CfgRetencion2Concepto		varchar(50),
@CfgRetencion3Acreedor		char(10),
@CfgRetencion3Concepto		varchar(50),
@CxModulo		 			char(5)		OUTPUT,
@CxMov		 				char(20)	OUTPUT,
@CxMovID		 			varchar(20)	OUTPUT,
@Ok							int			OUTPUT,
@OkRef						varchar(255)OUTPUT

AS
BEGIN
IF (@Fiscal = 0 OR @FiscalGenerarRetenciones = 1) AND @CfgRetencionAlPago = 0 AND @MovTipo IN ('COMS.F','COMS.FL','COMS.EG', 'COMS.EI', 'COMS.D') AND (@SumaRetencion <> 0.0 OR @SumaRetencion2 <> 0.0 OR @SumaRetencion3 <> 0.0)
BEGIN
IF @SumaRetencion <> 0.0
BEGIN
IF @CfgRetencionAcreedor IS NULL
SELECT @Ok = 70100
ELSE
EXEC spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, NULL, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaEmision, @CfgRetencionConcepto, @Proyecto, @Usuario, @Autorizacion, NULL, @DocFuente, @Observaciones,
@FechaRegistro, @Ejercicio, @Periodo,
NULL, NULL, @CfgRetencionAcreedor, NULL, NULL, NULL, NULL, NULL,
@SumaRetencion, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, @CfgRetencionMov,
@CxModulo OUTPUT, @CxMov OUTPUT, @CxMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
END
IF @SumaRetencion2 <> 0.0
BEGIN
IF @CfgRetencion2Acreedor IS NULL
SELECT @Ok = 70100
ELSE
EXEC spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, NULL, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaEmision, @CfgRetencion2Concepto, @Proyecto, @Usuario, @Autorizacion, NULL, @DocFuente, @Observaciones,
@FechaRegistro, @Ejercicio, @Periodo,
NULL, NULL, @CfgRetencion2Acreedor, NULL, NULL, NULL, NULL, NULL,
@SumaRetencion2, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, @CfgRetencionMov,
@CxModulo OUTPUT, @CxMov OUTPUT, @CxMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
END
IF @SumaRetencion3 <> 0.0
BEGIN
IF @CfgRetencion3Acreedor IS NULL
SELECT @Ok = 70100
ELSE
EXEC spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, NULL, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaEmision, @CfgRetencion3Concepto, @Proyecto, @Usuario, @Autorizacion, NULL, @DocFuente, @Observaciones,
@FechaRegistro, @Ejercicio, @Periodo,
NULL, NULL, @CfgRetencion3Acreedor, NULL, NULL, NULL, NULL, NULL,
@SumaRetencion3, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, @CfgRetencionMov,
@CxModulo OUTPUT, @CxMov OUTPUT, @CxMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
END
END
RETURN
END

