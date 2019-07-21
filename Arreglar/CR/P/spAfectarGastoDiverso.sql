SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAfectarGastoDiverso
@Sucursal			int,
@SucursalOrigen		int,
@SucursalDestino		int,
@Accion			char(20),
@Empresa	      		char(5),
@Modulo	      		char(5),
@ID                		int,
@Mov	  	      		char(20),
@MovID             		varchar(20),
@MovTipo     		char(20),
@FechaRegistro    		datetime,
@Proyecto	      		varchar(50),
@Usuario	      		char(10),
@Autorizacion      		char(10),
@Referencia	      		varchar(50),
@DocFuente	      		int,
@Observaciones     		varchar(255),
@Ejercicio			int,
@Periodo			int,
@VIN				varchar(20),
@Ok                		int          OUTPUT,
@OkRef             		varchar(255) OUTPUT

AS BEGIN
DECLARE
@Concepto		 	  varchar(50),
@Acreedor		 	  char(10),
@Moneda		 	  char(10),
@TipoCambio		 	  float,
@Importe		 	  money,
@Retencion		 	  float,
@Retencion2		 	  float,
@Retencion3		 	  float,
@Impuestos		 	  money,
@PorcentajeImpuestos 	  float,
@FechaEmision	 	  datetime,
@Condicion		 	  varchar(50),
@Vencimiento	 	  datetime,
@CxImporte			  money,
@CxImpuestos		  money,
@CxRetencion	  	  money,
@CxRetencion2		  money,
@CxRetencion3		  money,
@CxModulo		 	  char(5),
@CxpID			  int,
@CxcID			  int,
@CxMov		 	  char(20),
@CxMovID		 	  varchar(20),
@CxReferencia   		  varchar(50),
@GastoID                      int,
@GastoMov                     char(20),
@GastoMovID                   varchar(20),
@GastoDiversoMov		  char(20),
@RenglonID			  int,
@CfgRetencionAlPago		  bit,
@CfgRetencionConcepto	  varchar(50),
@CfgRetencion2Concepto	  varchar(50),
@CfgRetencion3Concepto	  varchar(50),
@RetencionConcepto		  varchar(50),
@Retencion2Concepto		  varchar(50),
@Retencion3Concepto		  varchar(50),
@CfgRetencionAcreedor	  char(10),
@CfgRetencion2Acreedor	  char(10),
@CfgRetencion3Acreedor	  char(10),
@CfgRetencionMov		  char(20),
@CfgReferenciaGasto		  bit,
@CfgCompraGastoDiversoCxc	  bit,
@ReferenciaGasto   		  varchar(50),
@CfgGastoDiversoSinProrratear varchar(20),
@Prorrateo                    varchar(20),
@Clase                        varchar(50),
@SubClase                     varchar(50),
@Cliente			  varchar(10),
@PorcentajeDeducible          float,
@CfgDefImpuesto		  float,
@ImportacionImpuesto1	  money,
@ImportacionImpuesto1IVA	  money,
@ImportacionImpuesto2	  money,
@ImportacionImpuesto2IVA	  money,
@CfgMoneda			  char(10),
@CfgImportacionImpuesto1Acreedor	  varchar(10),
@CfgImportacionImpuesto1Concepto	  varchar(50),
@CfgImportacionImpuesto2Acreedor	  varchar(10),
@CfgImportacionImpuesto2Concepto	  varchar(50),
@Fiscal				  bit,
@FiscalGenerarRetenciones		  bit,
@Impuesto1						float
SELECT @Fiscal = ISNULL(Fiscal, 0)
FROM EmpresaGral
WHERE Empresa = @Empresa
SELECT @CfgRetencionMov  = CxpRetencion,
@GastoMov         = Gasto,
@GastoDiversoMov  = CxpGastoDiverso
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
SELECT @CfgRetencionAlPago	       = ISNULL(RetencionAlPago, 0),
@CfgRetencionAcreedor         = NULLIF(RTRIM(GastoRetencionAcreedor), ''),
@CfgRetencionConcepto         = NULLIF(RTRIM(GastoRetencionConcepto), ''),
@CfgRetencion2Acreedor        = NULLIF(RTRIM(GastoRetencion2Acreedor), ''),
@CfgRetencion2Concepto        = NULLIF(RTRIM(GastoRetencion2Concepto), ''),
@CfgRetencion3Acreedor        = NULLIF(RTRIM(GastoRetencion3Acreedor), ''),
@CfgRetencion3Concepto        = NULLIF(RTRIM(GastoRetencion3Concepto), ''),
@CfgReferenciaGasto	       = GastoDiversoReferenciaCxp,
@CfgGastoDiversoSinProrratear = UPPER(GastoDiversoSinProrratear),
@CfgCompraGastoDiversoCxc     = ISNULL(CompraGastoDiversoCxc, 0),
@FiscalGenerarRetenciones     = ISNULL(FiscalGenerarRetenciones, 0)
FROM EmpresaCfg2
WHERE Empresa = @Empresa
IF @Modulo = 'COMS'
DECLARE crEGD CURSOR FOR
SELECT Concepto, Acreedor, RenglonID, ISNULL(Importe, 0), ISNULL(Retencion, 0), ISNULL(Retencion2, 0), ISNULL(Retencion3, 0), ISNULL(Impuestos, 0), PorcentajeImpuestos, Moneda, TipoCambio, FechaEmision, Condicion, Vencimiento, Referencia, UPPER(Prorrateo)
FROM CompraGastoDiverso
WHERE ID = @ID
IF @Modulo = 'INV'
DECLARE crEGD CURSOR FOR
SELECT Concepto, Acreedor, RenglonID, ISNULL(Importe, 0), ISNULL(Retencion, 0), ISNULL(Retencion2, 0), ISNULL(Retencion3, 0), ISNULL(Impuestos, 0), PorcentajeImpuestos, Moneda, TipoCambio, FechaEmision, Condicion, Vencimiento, Referencia, UPPER(Prorrateo)
FROM InvGastoDiverso
WHERE ID = @ID
OPEN crEGD
FETCH NEXT FROM crEGD INTO @Concepto, @Acreedor, @RenglonID, @Importe, @Retencion, @Retencion2, @Retencion3, @Impuestos, @PorcentajeImpuestos, @Moneda, @TipoCambio, @FechaEmision, @Condicion, @Vencimiento, @ReferenciaGasto, @Prorrateo
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @CxpID = NULL, @GastoID = NULL
IF @CfgReferenciaGasto = 1 SELECT @CxReferencia = @ReferenciaGasto ELSE SELECT @CxReferencia = @Referencia
/*IF @Impuestos IS NULL
SELECT @Impuestos = ROUND(@Importe * (@PorcentajeImpuestos/100), @RedondeoMonetarios)*/
IF @CfgGastoDiversoSinProrratear = 'GASTOS' AND @Prorrateo = 'NO'
BEGIN
IF @Accion <> 'CANCELAR'
BEGIN
SELECT @PorcentajeDeducible = 100
SELECT @Clase = Clase, @SubClase = SubClase, @PorcentajeDeducible = PorcentajeDeducible FROM Concepto WHERE Modulo = 'GAS' AND Concepto = @Concepto
INSERT Gasto (Sucursal,  Empresa,  Mov,       FechaEmision,  Moneda,  TipoCambio,  Usuario,  Estatus,      UltimoCambio, Acreedor,  Clase,  SubClase,  OrigenTipo, Origen, OrigenID, Prioridad)
VALUES (@Sucursal, @Empresa, @GastoMov, @FechaEmision, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', GETDATE(),    @Acreedor, @Clase, @SubClase, @Modulo,    @Mov,   @MovID,   'Normal')
SELECT @GastoID = SCOPE_IDENTITY()
IF @Importe >0  SELECT @Impuesto1 = (@Impuestos *100)/@Importe
INSERT GastoD (ID,       Renglon,  Concepto,  Fecha,         Referencia,    Cantidad,  Precio,   Importe,  Impuestos,  Retencion,  Retencion2,  Retencion3,  Sucursal,  PorcentajeDeducible,Impuesto1)
VALUES (@GastoID, 2048,     @Concepto, @FechaEmision, @CxReferencia, 1,         @Importe, @Importe, @Impuestos, @Retencion, @Retencion2, @Retencion3, @Sucursal, @PorcentajeDeducible,ROUND(@Impuesto1,2))
END ELSE
SELECT @GastoID = ID FROM Gasto WHERE Empresa = @Empresa AND OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
IF @GastoID IS NOT NULL
BEGIN
EXEC spGasto @GastoID, 'GAS', @Accion, 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, @GastoMov, @GastoMovID OUTPUT, NULL, @Ok OUTPUT, @OkRef OUTPUT
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'GAS', @GastoID, @GastoMov, @GastoMovID, @Ok OUTPUT
END ELSE
SELECT @Ok = 30120, @OkRef = @GastoMov
END ELSE
BEGIN
SELECT @CxImporte = @Importe, @CxImpuestos = @Impuestos, @CxRetencion = @Retencion, @CxRetencion2 = @Retencion2, @CxRetencion3 = @Retencion3
/** 04.08.2006 **/
/*IF @CfgRetencionAlPago = 0
SELECT @CxImporte = @CxImporte - @Retencion - @Retencion2 - @Retencion3, @CxRetencion = NULL, @CxRetencion2 = NULL, @CxRetencion3 = NULL*/
IF @CfgRetencionAlPago = 0
EXEC spExtraerFecha @FechaEmision OUTPUT
EXEC @CxpID = spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, NULL, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @Moneda, @TipoCambio,
@FechaEmision, @Concepto, @Proyecto, @Usuario, @Autorizacion, @CxReferencia, @DocFuente, @Observaciones,
@FechaRegistro, @Ejercicio, @Periodo,
@Condicion, @Vencimiento, @Acreedor, NULL, NULL, 'DESGLOSE', NULL, NULL,
@CxImporte, @CxImpuestos, @CxRetencion, NULL,
NULL, NULL, NULL, NULL, @VIN, @GastoDiversoMov,
@CxModulo, @CxMov OUTPUT, @CxMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT, @Retencion2 = @CxRetencion2, @Retencion3 = @CxRetencion3
IF @CfgCompraGastoDiversoCxc = 1 AND @Modulo = 'COMS' AND @Ok IS NULL
BEGIN
SELECT @Cliente = NULLIF(RTRIM(Cliente), '') FROM Compra WHERE ID = @ID
IF @Cliente IS NULL SELECT @Ok = 40010
IF @Ok IS NULL
EXEC @CxcID = spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, NULL, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @Moneda, @TipoCambio,
@FechaEmision, @Concepto, @Proyecto, @Usuario, @Autorizacion, @CxReferencia, @DocFuente, @Observaciones,
@FechaRegistro, @Ejercicio, @Periodo,
@Condicion, @Vencimiento, @Cliente, NULL, NULL, 'CXC', NULL, NULL,
@CxImporte, @CxImpuestos, @CxRetencion, NULL,
NULL, NULL, NULL, NULL, @VIN, @GastoDiversoMov,
@CxModulo, @CxMov, @CxMovID,
@Ok OUTPUT, @OkRef OUTPUT, @Retencion2 = @CxRetencion2, @Retencion3 = @CxRetencion3, @ModuloEspecifico = 'CXC', @MovIDEspecifico = @CxMovID
END
IF (@Fiscal = 0 OR @FiscalGenerarRetenciones = 1) AND @CfgRetencionAlPago = 0
BEGIN
EXEC spGastoConcepto @CfgRetencionConcepto,  @Concepto, @RetencionConcepto OUTPUT
EXEC spGastoConcepto @CfgRetencion2Concepto, @Concepto, @Retencion2Concepto OUTPUT
EXEC spGastoConcepto @CfgRetencion3Concepto, @Concepto, @Retencion3Concepto OUTPUT
IF @Retencion <> 0.0
BEGIN
IF @CfgRetencionAcreedor IS NULL
SELECT @Ok = 70100
ELSE
EXEC spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, NULL, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @Moneda, @TipoCambio,
@FechaEmision, @RetencionConcepto, @Proyecto, @Usuario, @Autorizacion, @CxReferencia, @DocFuente, @Observaciones,
@FechaRegistro, @Ejercicio, @Periodo,
NULL, NULL, @CfgRetencionAcreedor, NULL, NULL, NULL, NULL, NULL,
@Retencion, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, @CfgRetencionMov,
@CxModulo OUTPUT, @CxMov OUTPUT, @CxMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
END
IF @Retencion2 <> 0.0
BEGIN
IF @CfgRetencion2Acreedor IS NULL
SELECT @Ok = 70100
ELSE
EXEC spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, NULL, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @Moneda, @TipoCambio,
@FechaEmision, @Retencion2Concepto, @Proyecto, @Usuario, @Autorizacion, @CxReferencia, @DocFuente, @Observaciones,
@FechaRegistro, @Ejercicio, @Periodo,
NULL, NULL, @CfgRetencion2Acreedor, NULL, NULL, NULL, NULL, NULL,
@Retencion2, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, @CfgRetencionMov,
@CxModulo OUTPUT, @CxMov OUTPUT, @CxMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
END
IF @Retencion3 <> 0.0
BEGIN
IF @CfgRetencion3Acreedor IS NULL
SELECT @Ok = 70100
ELSE
EXEC spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, NULL, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @Moneda, @TipoCambio,
@FechaEmision, @Retencion3Concepto, @Proyecto, @Usuario, @Autorizacion, @CxReferencia, @DocFuente, @Observaciones,
@FechaRegistro, @Ejercicio, @Periodo,
NULL, NULL, @CfgRetencion3Acreedor, NULL, NULL, NULL, NULL, NULL,
@Retencion3, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, @CfgRetencionMov,
@CxModulo OUTPUT, @CxMov OUTPUT, @CxMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
END
END
END
EXEC xpAfectarGastoDiversoCursor @Accion, @Empresa, @Sucursal, @Usuario, @Modulo, @ID, @Concepto, @Acreedor, @RenglonID, @CxpID, @GastoID, @Ok OUTPUT, @OkRef OUTPUT
END
FETCH NEXT FROM crEGD INTO @Concepto, @Acreedor, @RenglonID, @Importe, @Retencion, @Retencion2, @Retencion3, @Impuestos, @PorcentajeImpuestos, @Moneda, @TipoCambio, @FechaEmision, @Condicion, @Vencimiento, @ReferenciaGasto, @Prorrateo
END
CLOSE crEGD
DEALLOCATE crEGD
IF @MovTipo = 'COMS.EI'
BEGIN
SELECT @TipoCambio = TipoCambio FROM Compra WHERE ID = @ID
SELECT @CfgDefImpuesto = DefImpuesto
FROM EmpresaGral
WHERE Empresa = @Empresa
SELECT @CfgMoneda = ContMoneda,
@CfgImportacionImpuesto1Acreedor = ImportacionImpuesto1Acreedor,
@CfgImportacionImpuesto1Concepto = ImportacionImpuesto1Concepto,
@CfgImportacionImpuesto2Acreedor = ImportacionImpuesto2Acreedor,
@CfgImportacionImpuesto2Concepto = ImportacionImpuesto2Concepto
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @FechaEmision = FechaEmision
FROM Compra
WHERE ID = @ID
SELECT @ImportacionImpuesto1 = SUM(Cantidad*ValorAduana*(ImportacionImpuesto1/100.0)*@TipoCambio),
@ImportacionImpuesto2 = SUM(Cantidad*ValorAduana*(ImportacionImpuesto2/100.0)*@TipoCambio)
FROM CompraD
WHERE ID = @ID
SELECT @ImportacionImpuesto1IVA = 0.0, 
@ImportacionImpuesto2IVA = 0.0 
IF ISNULL(@ImportacionImpuesto1, 0.0) <> 0.0
EXEC spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, NULL, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @CfgMoneda, 1.0,
@FechaEmision, @CfgImportacionImpuesto1Concepto, @Proyecto, @Usuario, @Autorizacion, @CxReferencia, @DocFuente, @Observaciones,
@FechaRegistro, @Ejercicio, @Periodo,
NULL, NULL, @CfgImportacionImpuesto1Acreedor, NULL, NULL, NULL, NULL, NULL,
@ImportacionImpuesto1, @ImportacionImpuesto1IVA, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, @GastoDiversoMov,
@CxModulo OUTPUT, @CxMov OUTPUT, @CxMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
IF ISNULL(@ImportacionImpuesto2, 0.0) <> 0.0
EXEC spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, NULL, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @CfgMoneda, 1.0,
@FechaEmision, @CfgImportacionImpuesto2Concepto, @Proyecto, @Usuario, @Autorizacion, @CxReferencia, @DocFuente, @Observaciones,
@FechaRegistro, @Ejercicio, @Periodo,
NULL, NULL, @CfgImportacionImpuesto2Acreedor, NULL, NULL, NULL, NULL, NULL,
@ImportacionImpuesto2, @ImportacionImpuesto2IVA, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, @GastoDiversoMov,
@CxModulo OUTPUT, @CxMov OUTPUT, @CxMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
END
RETURN
END

