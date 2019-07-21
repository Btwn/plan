SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarRetencionMovImpuesto
@Sucursal 			int,
@SucursalOrigen 		int,
@SucursalDestino 		int,
@Accion 			varchar(20),
@Empresa 			varchar(5),
@Modulo 			varchar(5),
@ID 			int,
@movTipo 			varchar(20),
@Mov 			varchar(20),
@MovID 			varchar(20),
@MovMoneda 			varchar(10),
@MovTipoCambio 		float,
@FechaEmision  		datetime,
@Proyecto 			varchar(50),
@Usuario 			varchar(10),
@FechaRegistro 		datetime,
@Ejercicio 			int,
@Periodo 			int,
@CfgRetencionMov		char(20),
@CfgRetencionAcreedor	char(10),
@CfgRetencionConcepto	varchar(50),
@CfgRetencion2Acreedor	char(10),
@CfgRetencion2Concepto	varchar(50),
@CfgRetencion3Acreedor	char(10),
@CfgRetencion3Concepto	varchar(50),
@Idaplica 			int,
@AplicaSaldoFactor 		float,
@RedondeoMonetarios 	float,
@Ok 			int 	     OUTPUT,
@okRef 			varchar(255) OUTPUT

AS BEGIN
DECLARE
@OrigenConcepto 		varchar(50),
@Retencion 			float,
@Retencion2 		float,
@Retencion3 		float,
@Subtotal 			money,
@RetencionConcepto 		varchar(50),
@Retencion2Concepto 	varchar(50),
@Retencion3Concepto 	varchar(50),
@CxModulo			char(5),
@CxMov			char(20),
@CxMovID			varchar(20),
@CfgDevRetencionMov                 varchar(20),
@Retencion2BaseImpuesto1		bit
SELECT @Retencion2BaseImpuesto1 = ISNULL(Retencion2BaseImpuesto1,0) FROM Version
SELECT @CfgDevRetencionMov = CxpDevRetencion FROM EmpresaCfgMov WITH(NOLOCK) WHERE Empresa = @Empresa
DECLARE crMovRetencion CURSOR FOR
SELECT OrigenConcepto, ISNULL(SubTotal*(Retencion1/100.0), 0.0), CASE WHEN @Retencion2BaseImpuesto1 = 0 THEN ISNULL(SubTotal*(Retencion2/100.0), 0.0) ELSE ISNULL(Importe1*(Retencion2/100.0), 0.0) END, ISNULL(SubTotal*(Retencion3/100.0),0.0)
FROM MovImpuesto
WITH(NOLOCK) WHERE Modulo = @Modulo AND ModuloId = @IDAplica AND OrigenConcepto IS NOT NULL
OPEN crMovRetencion
FETCH NEXT FROM crMovretencion  INTO @OrigenConcepto, @Retencion, @Retencion2, @Retencion3
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Retencion < 0
SELECT @Retencion  = @Retencion*-1, @CfgRetencionMov = @CfgDevRetencionMov
IF @Retencion2 < 0
SELECT @Retencion2 = @Retencion2*-1, @CfgRetencionMov = @CfgDevRetencionMov
IF @Retencion3 < 0
SELECT @Retencion3 = @Retencion3*-1, @CfgRetencionMov = @CfgDevRetencionMov
EXEC spGastoConcepto @CfgRetencionConcepto,  @OrigenConcepto, @RetencionConcepto OUTPUT
EXEC spGastoConcepto @CfgRetencion2Concepto, @OrigenConcepto, @Retencion2Concepto OUTPUT
EXEC spGastoConcepto @CfgRetencion3Concepto, @OrigenConcepto, @Retencion3Concepto OUTPUT
SELECT @Retencion  = ROUND(@Retencion  * @AplicaSaldoFactor, @RedondeoMonetarios),
@Retencion2 = ROUND(@Retencion2 * @AplicaSaldoFactor, @RedondeoMonetarios),
@Retencion3 = ROUND(@Retencion3 * @AplicaSaldoFactor, @RedondeoMonetarios)
IF @Retencion <> 0.0
BEGIN
IF @CfgRetencionAcreedor IS NULL
SELECT @Ok = 70100
ELSE
EXEC spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, NULL, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaEmision, @RetencionConcepto, @Proyecto, @Usuario, NULL, NULL, NULL, NULL,
@FechaRegistro, @Ejercicio, @Periodo,
NULL, NULL, @CfgRetencionAcreedor, NULL, NULL, NULL, NULL, NULL,
@Retencion, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, @CfgRetencionMov,
@CxModulo OUTPUT, @CxMov OUTPUT, @CxMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT, @INSTRUCCIONES_ESP = 'RETENCION'
END
IF @Retencion2 <> 0.0
BEGIN
IF @CfgRetencion2Acreedor IS NULL
SELECT @Ok = 70100
ELSE
EXEC spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, NULL, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaEmision, @Retencion2Concepto, @Proyecto, @Usuario, NULL, NULL, NULL, NULL,
@FechaRegistro, @Ejercicio, @Periodo,
NULL, NULL, @CfgRetencion2Acreedor, NULL, NULL, NULL, NULL, NULL,
@Retencion2, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, @CfgRetencionMov,
@CxModulo OUTPUT, @CxMov OUTPUT, @CxMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT, @INSTRUCCIONES_ESP = 'RETENCION'
END
IF @Retencion3 <> 0.0
BEGIN
IF @CfgRetencion3Acreedor IS NULL
SELECT @Ok = 70100
ELSE
EXEC spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, NULL, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaEmision, @Retencion3Concepto, @Proyecto, @Usuario, NULL, NULL, NULL, NULL,
@FechaRegistro, @Ejercicio, @Periodo,
NULL, NULL, @CfgRetencion3Acreedor, NULL, NULL, NULL, NULL, NULL,
@Retencion3, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, @CfgRetencionMov,
@CxModulo OUTPUT, @CxMov OUTPUT, @CxMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT, @INSTRUCCIONES_ESP = 'RETENCION'
END
END
FETCH NEXT FROM crMovRetencion  INTO @OrigenConcepto, @Retencion, @Retencion2, @Retencion3
END
CLOSE crMovRetencion
DEALLOCATE crMovRetencion
RETURN
END

