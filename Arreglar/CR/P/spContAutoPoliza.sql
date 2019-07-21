SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContAutoPoliza
@Empresa					char(5),
@Sucursal				int,
@Modulo					char(5),
@ID						int,
@Mov						varchar(20),
@MovID					varchar(20),
@MovTipo					char(20),
@Estatus					char(15),
@EstatusNuevo			char(15),
@Usuario					char(10),
@FechaEmision			datetime,
@FechaRegistro			datetime,
@CfgClaseConceptoGastos 	bit,
@Concepto				varchar(50)		OUTPUT,
@Proyecto				varchar(50)		OUTPUT,
@UEN						int				OUTPUT,
@Contacto				char(10)		OUTPUT,
@ContactoTipo			varchar(20)		OUTPUT,
@ContactoAplica			varchar(20)		OUTPUT,
@Intercompania			bit				OUTPUT,
@OrigenMoneda			varchar(10)		OUTPUT,
@OrigenTipoCambio		float			OUTPUT,
@Ok						int				OUTPUT,
@OkRef					varchar(255)	OUTPUT,
@CfgPartidasSinImporte	bit,
@CfgConsolidacion		bit,
@CfgTipoFilial			varchar(20),
@CfgContArticulo			bit,
@ContAutoEmpresa			varchar(10) = '(Todas)'

AS BEGIN
DECLARE
@Nombre					varchar(50),
@Clave					varchar(20),
@CtaCtoTipo				varchar(20),
@CtaCtoTipoAplica		varchar(20),
@CtaClase				varchar(20),
@CtaDinero				varchar(10),
@CtaDineroDestino		varchar(10),
@FormaPago				varchar(50),
@ConDesglose			bit,
@Directo				bit,
@Orden					int,
@Debe					varchar(20),
@Haber					varchar(20),
@DebeHaber				varchar(20),
@Cuenta					varchar(20),
@CuentaOmision			varchar(20),
@Cta					varchar(20),
@OmitirConcepto			bit,
@QueConcepto			varchar(20),
@OmitirCentroCostos		bit,
@CentroCostos			varchar(20),
@SucursalContable		varchar(20),
@IncluirArticulos		bit,
@IncluirDepartamento	bit,
@ContAutoContactoEsp	varchar(50),
@Condicion				varchar(50),
@OrigenTipo				varchar(10),
@Continuar				bit,
@GenerarPoliza			bit,
@ContID					int,
@Poliza					varchar(20),
@PolizaID				varchar(20),
@Diferencia				money,
@DiferenciaIVA			money,
@DiferenciaIEPS			money,
@CxTipoCambio			float,
@ContactoTipoCambio		float,
@CxImporteTotalMN		money,
@CxImporteAplicaMN		money,
@CxIVAMN				money,
@CxIVAAplicaMN			money,
@CxIEPSMN				money,
@CxIEPSAplicaMN			money,
@CxPicosMN				money,
@ContactoSubTipo		varchar(20),
@Clase					varchar(50),
@SubClase				varchar(50),
@EsFilial				bit,
@Monto					money,
@Importe				money,
@CentroCostosSucursal	varchar(20),
@CentroCostosDestino	varchar(20),
@CentroCostosMatriz		varchar(20),
@ContUso				varchar(20), 
@ContUso2				varchar(20), 
@ContUso3				varchar(20), 
@RetencionPorcentaje	float,
@ObligacionFiscal		varchar(50),
@ContactoEspecifico		varchar(10),
@ContactoDetalle		varchar(10),
@Agente					varchar(10),
@Personal				varchar(10),
@Almacen				varchar(10),
@AlmacenDestino			varchar(10),
@AlmacenDetalle			varchar(10),
@OrigenModulo			char(5),
@OrigenModuloID			int
SELECT @EsFilial = 0
EXEC spContAutoGetDatos @Modulo, @ID,
@ContID OUTPUT, @Poliza OUTPUT, @PolizaID OUTPUT,
@Concepto OUTPUT, @Proyecto OUTPUT, @UEN OUTPUT, @OrigenTipo OUTPUT, @CtaClase OUTPUT, @CtaCtoTipo OUTPUT, @CtaCtoTipoAplica OUTPUT,
@Contacto OUTPUT, @CtaDinero OUTPUT, @CtaDineroDestino OUTPUT, @FormaPago OUTPUT, @ConDesglose OUTPUT, @GenerarPoliza OUTPUT,
@ContactoTipo OUTPUT, @ContactoSubTipo OUTPUT, @Clase OUTPUT, @SubClase OUTPUT, @Intercompania OUTPUT, @OrigenMoneda OUTPUT, @OrigenTipoCambio OUTPUT,
@CentroCostosSucursal OUTPUT, @CentroCostosDestino OUTPUT, @CentroCostosMatriz OUTPUT, @RetencionPorcentaje OUTPUT, @Directo OUTPUT, @ContactoAplica OUTPUT
IF @EstatusNuevo = 'CANCELADO'
BEGIN
IF NULLIF(RTRIM(@PolizaID), '') IS NULL RETURN
END ELSE
BEGIN
IF NULLIF(RTRIM(@PolizaID), '') IS NOT NULL RETURN
END
IF @CfgConsolidacion = 1 AND @Modulo = 'VTAS' AND @ContactoSubTipo = @CfgTipoFilial SELECT @EsFilial = 1
IF EXISTS(SELECT * FROM MovTipoContAuto WHERE Empresa = @ContAutoEmpresa AND Modulo = @Modulo AND Clave = @Mov)
SELECT @Clave = @Mov
ELSE
SELECT @Clave = '('+RTRIM(@MovTipo)+')'
EXEC xpContAutoPolizaClave @Empresa, @Sucursal, @Modulo,  @ID, @Mov, @MovID, @MovTipo, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Clave OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
DECLARE crContAuto CURSOR FOR
SELECT Nombre, Orden, NULLIF(RTRIM(UPPER(Condicion)), ''), NULLIF(RTRIM(UPPER(Debe)), ''), NULLIF(RTRIM(UPPER(Haber)), ''), Cuenta, CuentaOmision, ISNULL(OmitirConcepto, 0), Concepto, ISNULL(OmitirCentroCostos, 0), CentroCostos, Sucursal, ISNULL(IncluirArticulos, 0), ISNULL(IncluirDepartamento, 0), ISNULL(RTRIM(ContactoEspecifico), ''), NULLIF(RTRIM(ObligacionFiscal), ''), @Contacto 
FROM MovTipoContAuto
WHERE Empresa = @ContAutoEmpresa AND Modulo = @Modulo AND Clave = @Clave
OPEN crContAuto
FETCH NEXT FROM crContAuto INTO @Nombre, @Orden, @Condicion, @Debe, @Haber, @Cuenta, @CuentaOmision, @OmitirConcepto, @QueConcepto, @OmitirCentroCostos, @CentroCostos, @SucursalContable, @IncluirArticulos, @IncluirDepartamento, @ContAutoContactoEsp, @ObligacionFiscal, @Contacto 
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF (select estatus from Cta WHERE Cuenta = @CuentaOmision ) in ('BLOQUEADO','BAJA')
SELECT @Ok = 50070
IF UPPER(@Cuenta) IN ('CONTACTO ORIGEN', 'RETENCION CTO ORIGEN') AND @Modulo IN ('CXC', 'CXP') SELECT @Contacto = @ContactoAplica
IF @Debe = 'IMPORTE S/FISCAL'
SELECT @Debe = 'SUBTOTAL ARRASTRE'
IF @Haber = 'IMPORTE S/FISCAL'
SELECT @Haber = 'SUBTOTAL ARRASTRE'
IF @Debe = 'IVA FISCAL'
SELECT @Debe = 'TOTAL IMPUESTO 1'
IF @Haber = 'IVA FISCAL'
SELECT @Haber = 'TOTAL IMPUESTO 1'
IF @Debe = 'IEPS FISCAL'
SELECT @Debe = 'TOTAL IMPUESTO 2'
IF @Haber = 'IEPS FISCAL'
SELECT @Haber = 'TOTAL IMPUESTO 2'
IF @Debe IS NOT NULL SELECT @DebeHaber = @Debe ELSE SELECT @DebeHaber = @Haber
SELECT @Continuar = 1
IF @Condicion IS NOT NULL
BEGIN
IF @MovTipo = 'VTAS.F'
BEGIN
IF @Condicion = 'VENTA NORMAL'    AND @OrigenTipo =  'VMOS' SELECT @Continuar = 0
IF @Condicion = 'VENTA MOSTRADOR' AND @OrigenTipo <> 'VMOS' SELECT @Continuar = 0
END
END
IF @Continuar = 1
BEGIN
IF @Modulo IN ('VTAS', 'COMS', 'CXC', 'CXP', 'GAS', 'DIN', 'CONC') AND (@Debe IN ('TOTAL IMPUESTO 1', 'TOTAL IMPUESTO 2', 'TOTAL IMPUESTO 3', 'TOTAL IMPUESTO 5', 'TOTAL RETENCION 1', 'TOTAL RETENCION 2', 'TOTAL RETENCION 3', 'SUBTOTAL ARRASTRE', 'TOTAL ARRASTRE', 'TOTAL BRUTO ARRASTRE', 'DESCUENTO ARRASTRE') OR @Haber IN ('TOTAL IMPUESTO 1', 'TOTAL IMPUESTO 2', 'TOTAL IMPUESTO 3', 'TOTAL IMPUESTO 5', 'TOTAL RETENCION 1', 'TOTAL RETENCION 2', 'TOTAL RETENCION 3', 'SUBTOTAL ARRASTRE', 'TOTAL ARRASTRE', 'TOTAL BRUTO ARRASTRE', 'DESCUENTO ARRASTRE', 'Retencion IVA'))
BEGIN
IF @Debe  IS NOT NULL EXEC spContAutoMovImpuesto @Modulo, @Clave, @Nombre, @ID, @Cuenta, @CuentaOmision, @OmitirConcepto, @OmitirCentroCostos, @CentroCostos, @CentroCostosSucursal, @CentroCostosDestino, @CentroCostosMatriz, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Orden, @Debe,  1, @Ok OUTPUT, @OkRef OUTPUT, @CfgPartidasSinImporte, @OrigenTipoCambio, @ContAutoContactoEsp, @ContactoAplica, @ContAutoEmpresa = @ContAutoEmpresa
IF @Haber IS NOT NULL EXEC spContAutoMovImpuesto @Modulo, @Clave, @Nombre, @ID, @Cuenta, @CuentaOmision, @OmitirConcepto, @OmitirCentroCostos, @CentroCostos, @CentroCostosSucursal, @CentroCostosDestino, @CentroCostosMatriz, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Orden, @Haber, 0, @Ok OUTPUT, @OkRef OUTPUT, @CfgPartidasSinImporte, @OrigenTipoCambio, @ContAutoContactoEsp, @ContactoAplica, @ContAutoEmpresa = @ContAutoEmpresa
SELECT @Continuar = 0
END
END
IF @Continuar = 1
BEGIN
IF @OmitirConcepto = 1 SELECT @Concepto = NULL
IF @Modulo IN ('COMS', 'VTAS', 'INV', 'PROD')
BEGIN
IF @Debe  IN ('ANT FACT. DIFEREN C', 'ANT FACT. UTILIDAD C', 'ANT FACT. PERDIDA C') OR
@Haber IN ('ANT FACT. DIFEREN C', 'ANT FACT. UTILIDAD C', 'ANT FACT. PERDIDA C')
BEGIN
EXEC spContAutoGetCuenta @Modulo, @Cuenta, @CuentaOmision, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, NULL, NULL, NULL, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Cta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Debe  IS NOT NULL EXEC spContAutoVTASCambiario @Empresa, @Sucursal, @Modulo, @ID, @Mov, @MovID, @MovTipo, @Orden, @Debe, @Haber, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoSubTipo, @ContAutoContactoEsp, @Contacto, @ContactoAplica, @CtaDinero, @CtaDineroDestino, @Ok OUTPUT, @OkRef OUTPUT, @ContactoTipo
IF @Haber IS NOT NULL EXEC spContAutoVTASCambiario @Empresa, @Sucursal, @Modulo, @ID, @Mov, @MovID, @MovTipo, @Orden, @Debe, @Haber, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoSubTipo, @ContAutoContactoEsp, @Contacto, @ContactoAplica, @CtaDinero, @CtaDineroDestino, @Ok OUTPUT, @OkRef OUTPUT, @ContactoTipo
END ELSE
IF @Debe  IN ('GASTOS/RETENCION IVA', 'GASTOS/RETENCION ISR', 'GASTOS/IMPORTE', 'GASTOS/IMPUESTOS', 'GASTOS/IMPORTE TOTAL', 'GASTOS/RETENCION 3') OR
@Haber IN ('GASTOS/RETENCION IVA', 'GASTOS/RETENCION ISR', 'GASTOS/IMPORTE', 'GASTOS/IMPUESTOS', 'GASTOS/IMPORTE TOTAL', 'GASTOS/RETENCION 3')
BEGIN
EXEC spContAutoGetCuenta @Modulo, @Cuenta, @CuentaOmision, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, NULL, NULL, NULL, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Cta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Debe  = 'GASTOS/RETENCION ISR' INSERT #Poliza (Orden, Cuenta, Concepto, Debe)  SELECT @Orden, @Cta, @Concepto, Retencion*TipoCambio  FROM CompraGastoDiverso WHERE ID = @ID ELSE
IF @Haber = 'GASTOS/RETENCION ISR' INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, Retencion*TipoCambio  FROM CompraGastoDiverso WHERE ID = @ID ELSE
IF @Debe  = 'GASTOS/RETENCION IVA' INSERT #Poliza (Orden, Cuenta, Concepto, Debe)  SELECT @Orden, @Cta, @Concepto, Retencion2*TipoCambio FROM CompraGastoDiverso WHERE ID = @ID ELSE
IF @Haber = 'GASTOS/RETENCION IVA' INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, Retencion2*TipoCambio FROM CompraGastoDiverso WHERE ID = @ID ELSE
IF @Debe  = 'GASTOS/RETENCION 3'   INSERT #Poliza (Orden, Cuenta, Concepto, Debe)  SELECT @Orden, @Cta, @Concepto, Retencion3*TipoCambio FROM CompraGastoDiverso WHERE ID = @ID ELSE
IF @Haber = 'GASTOS/RETENCION 3'   INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, Retencion3*TipoCambio FROM CompraGastoDiverso WHERE ID = @ID ELSE
IF @Debe  = 'GASTOS/IMPORTE'       INSERT #Poliza (Orden, Cuenta, Concepto, Debe)  SELECT @Orden, @Cta, @Concepto, Importe*TipoCambio    FROM CompraGastoDiverso WHERE ID = @ID ELSE
IF @Haber = 'GASTOS/IMPORTE'       INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, Importe*TipoCambio    FROM CompraGastoDiverso WHERE ID = @ID ELSE
IF @Debe  = 'GASTOS/IMPUESTOS'     INSERT #Poliza (Orden, Cuenta, Concepto, Debe)  SELECT @Orden, @Cta, @Concepto, Impuestos*TipoCambio  FROM CompraGastoDiverso WHERE ID = @ID ELSE
IF @Haber = 'GASTOS/IMPUESTOS'     INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, Impuestos*TipoCambio  FROM CompraGastoDiverso WHERE ID = @ID ELSE
IF @Debe  = 'GASTOS/IMPORTE TOTAL' INSERT #Poliza (Orden, Cuenta, Concepto, Debe)  SELECT @Orden, @Cta, @Concepto, (Importe+ISNULL(Impuestos, 0.0)-ISNULL(Retencion, 0.0)-ISNULL(Retencion2, 0.0)-ISNULL(Retencion3, 0.0))*TipoCambio FROM CompraGastoDiverso WHERE ID = @ID ELSE
IF @Haber = 'GASTOS/IMPORTE TOTAL' INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, (Importe+ISNULL(Impuestos, 0.0)-ISNULL(Retencion, 0.0)-ISNULL(Retencion2, 0.0)-ISNULL(Retencion3, 0.0))*TipoCambio FROM CompraGastoDiverso WHERE ID = @ID
END ELSE
BEGIN
IF @Modulo = 'VTAS' AND (@Debe IN ('RETENCIONES', 'COMISIONES', 'COMISIONES IVA', 'TOTAL COMISIONES', 'ANTICIPOS FACTURADOS') OR @Haber IN ('RETENCIONES', 'COMISIONES', 'COMISIONES IVA', 'TOTAL COMISIONES', 'ANTICIPOS FACTURADOS'))
BEGIN
EXEC spContAutoGetCuenta @Modulo, @Cuenta, @CuentaOmision, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, NULL, NULL, NULL, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Cta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Debe  = 'RETENCIONES'      INSERT #Poliza (Orden, Cuenta, Concepto, Debe)  SELECT @Orden, @Cta, @Concepto, Retencion*TipoCambio     FROM Venta WHERE ID = @ID ELSE
IF @Haber = 'RETENCIONES'      INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, Retencion*TipoCambio     FROM Venta WHERE ID = @ID ELSE
IF @Debe  = 'COMISIONES'       INSERT #Poliza (Orden, Cuenta, Concepto, Debe)  SELECT @Orden, @Cta, @Concepto, Comisiones*TipoCambio    FROM Venta WHERE ID = @ID ELSE
IF @Haber = 'COMISIONES'       INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, Comisiones*TipoCambio    FROM Venta WHERE ID = @ID ELSE
IF @Debe  = 'COMISIONES IVA'   INSERT #Poliza (Orden, Cuenta, Concepto, Debe)  SELECT @Orden, @Cta, @Concepto, ComisionesIVA*TipoCambio FROM Venta WHERE ID = @ID ELSE
IF @Haber = 'COMISIONES IVA'   INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, ComisionesIVA*TipoCambio FROM Venta WHERE ID = @ID ELSE
IF @Debe  = 'TOTAL COMISIONES' INSERT #Poliza (Orden, Cuenta, Concepto, Debe)  SELECT @Orden, @Cta, @Concepto, (ISNULL(Comisiones, 0.0) + ISNULL(ComisionesIVA, 0.0))*TipoCambio FROM Venta WHERE ID = @ID ELSE
IF @Haber = 'TOTAL COMISIONES' INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, (ISNULL(Comisiones, 0.0) + ISNULL(ComisionesIVA, 0.0))*TipoCambio FROM Venta WHERE ID = @ID ELSE
IF @Debe  = 'ANTICIPOS FACTURADOS' IF EXISTS(SELECT 1 FROM VentaD WHERE AnticipoFacturado = 1 AND ID = @ID) INSERT #Poliza (Orden, Cuenta, Concepto, Debe) SELECT @Orden, @Cta, @Concepto, ISNULL(Importe, 0.0) FROM VentaFacturaAnticipo WHERE ID = @ID ELSE INSERT #Poliza (Orden, Cuenta, Concepto, Debe) SELECT @Orden, @Cta, @Concepto, AnticiposFacturados*TipoCambio FROM Venta WHERE ID = @ID ELSE
IF @Haber = 'ANTICIPOS FACTURADOS' IF EXISTS(SELECT 1 FROM VentaD WHERE AnticipoFacturado = 1 AND ID = @ID) INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, ISNULL(Importe, 0.0) FROM VentaFacturaAnticipo WHERE ID = @ID ELSE INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, AnticiposFacturados*TipoCambio FROM Venta WHERE ID = @ID
END ELSE
IF @Modulo = 'COMS' AND (@Debe IN ('COMISIONES', 'COMISIONES IVA', 'TOTAL COMISIONES') OR @Haber IN ('COMISIONES', 'COMISIONES IVA', 'TOTAL COMISIONES'))
BEGIN
EXEC spContAutoGetCuenta @Modulo, @Cuenta, @CuentaOmision, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, NULL, NULL, NULL, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Cta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Debe  = 'COMISIONES'       INSERT #Poliza (Orden, Cuenta, Concepto, Debe)  SELECT @Orden, @Cta, @Concepto, Comisiones*TipoCambio    FROM Compra WHERE ID = @ID ELSE
IF @Haber = 'COMISIONES'       INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, Comisiones*TipoCambio    FROM Compra WHERE ID = @ID ELSE
IF @Debe  = 'COMISIONES IVA'   INSERT #Poliza (Orden, Cuenta, Concepto, Debe)  SELECT @Orden, @Cta, @Concepto, ComisionesIVA*TipoCambio FROM Compra WHERE ID = @ID ELSE
IF @Haber = 'COMISIONES IVA'   INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, ComisionesIVA*TipoCambio FROM Compra WHERE ID = @ID ELSE
IF @Debe  = 'TOTAL COMISIONES' INSERT #Poliza (Orden, Cuenta, Concepto, Debe)  SELECT @Orden, @Cta, @Concepto, (ISNULL(Comisiones, 0.0) + ISNULL(ComisionesIVA, 0.0))*TipoCambio FROM Compra WHERE ID = @ID ELSE
IF @Haber = 'TOTAL COMISIONES' INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, (ISNULL(Comisiones, 0.0) + ISNULL(ComisionesIVA, 0.0))*TipoCambio FROM Compra WHERE ID = @ID
END ELSE
BEGIN
IF @Debe  IS NOT NULL EXEC spContAutoInv @Modulo, @Clave, @Nombre, @ID, @Cuenta, @CuentaOmision, @OmitirConcepto, @OmitirCentroCostos, @CentroCostos, @CentroCostosSucursal, @CentroCostosDestino, @CentroCostosMatriz, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Orden, @Debe,  1, @Ok OUTPUT, @OkRef OUTPUT, @CfgPartidasSinImporte, @CfgContArticulo, @IncluirArticulos, @IncluirDepartamento, @RetencionPorcentaje, @ContAutoContactoEsp, @ContactoAplica, @ContAutoEmpresa = @ContAutoEmpresa
IF @Haber IS NOT NULL EXEC spContAutoInv @Modulo, @Clave, @Nombre, @ID, @Cuenta, @CuentaOmision, @OmitirConcepto, @OmitirCentroCostos, @CentroCostos, @CentroCostosSucursal, @CentroCostosDestino, @CentroCostosMatriz, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Orden, @Haber, 0, @Ok OUTPUT, @OkRef OUTPUT, @CfgPartidasSinImporte, @CfgContArticulo, @IncluirArticulos, @IncluirDepartamento, @RetencionPorcentaje, @ContAutoContactoEsp, @ContactoAplica, @ContAutoEmpresa = @ContAutoEmpresa
END
END
END ELSE
IF @Modulo = 'GAS'
BEGIN
IF @MovTipo IN ('GAS.DA', 'GAS.ASC', 'GAS.SR')
BEGIN
EXEC spContAutoGetCuenta @Modulo, @Cuenta, @CuentaOmision, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, NULL, NULL, NULL, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Cta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Debe  IN ('IMPORTE', 'IMPORTE TOTAL') INSERT #Poliza (Orden, Cuenta, Concepto, Debe)  SELECT @Orden, @Cta, @Concepto, Importe*TipoCambio FROM Gasto WHERE ID = @ID ELSE
IF @Haber IN ('IMPORTE', 'IMPORTE TOTAL') INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, Importe*TipoCambio FROM Gasto WHERE ID = @ID
END ELSE
BEGIN
IF @Debe  IS NOT NULL EXEC spContAutoGasto @Modulo, @Clave, @Nombre, @ID, @Cuenta, @CuentaOmision, @OmitirConcepto, @OmitirCentroCostos, @CentroCostos, @CentroCostosSucursal, @CentroCostosDestino, @CentroCostosMatriz, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Orden, @Debe,  1, @CfgClaseConceptoGastos, @Ok OUTPUT, @OkRef OUTPUT, @CfgPartidasSinImporte, @IncluirDepartamento, @ContAutoContactoEsp, @ContAutoEmpresa = @ContAutoEmpresa ELSE
IF @Haber IS NOT NULL EXEC spContAutoGasto @Modulo, @Clave, @Nombre, @ID, @Cuenta, @CuentaOmision, @OmitirConcepto, @OmitirCentroCostos, @CentroCostos, @CentroCostosSucursal, @CentroCostosDestino, @CentroCostosMatriz, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Orden, @Haber, 0, @CfgClaseConceptoGastos, @Ok OUTPUT, @OkRef OUTPUT, @CfgPartidasSinImporte, @IncluirDepartamento, @ContAutoContactoEsp, @ContAutoEmpresa = @ContAutoEmpresa
END
END ELSE
IF @Modulo = 'AF'
BEGIN
IF @Debe  IS NOT NULL EXEC spContAutoAF @Modulo, @ID, @Cuenta, @CuentaOmision, @OmitirConcepto, @OmitirCentroCostos, @CentroCostos, @CentroCostosSucursal, @CentroCostosDestino, @CentroCostosMatriz, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Orden, @Debe,  1, @Ok OUTPUT, @OkRef OUTPUT, @CfgPartidasSinImporte
IF @Haber IS NOT NULL EXEC spContAutoAF @Modulo, @ID, @Cuenta, @CuentaOmision, @OmitirConcepto, @OmitirCentroCostos, @CentroCostos, @CentroCostosSucursal, @CentroCostosDestino, @CentroCostosMatriz, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Orden, @Haber, 0, @Ok OUTPUT, @OkRef OUTPUT, @CfgPartidasSinImporte
END ELSE
IF @Modulo = 'CP'
BEGIN
IF @Debe  IS NOT NULL EXEC spContAutoCP @Modulo, @ID, @Cuenta, @CuentaOmision, @OmitirConcepto, @OmitirCentroCostos, @CentroCostos, @CentroCostosSucursal, @CentroCostosDestino, @CentroCostosMatriz, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Orden, @Debe,  1, @Ok OUTPUT, @OkRef OUTPUT, @CfgPartidasSinImporte
IF @Haber IS NOT NULL EXEC spContAutoCP @Modulo, @ID, @Cuenta, @CuentaOmision, @OmitirConcepto, @OmitirCentroCostos, @CentroCostos, @CentroCostosSucursal, @CentroCostosDestino, @CentroCostosMatriz, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Orden, @Haber, 0, @Ok OUTPUT, @OkRef OUTPUT, @CfgPartidasSinImporte
END ELSE
IF @Modulo = 'FIS'
BEGIN
IF @Debe  IS NOT NULL EXEC spContAutoFiscal @Modulo, @Clave, @Nombre, @ID, @Cuenta, @CuentaOmision, @OmitirConcepto, @OmitirCentroCostos, @CentroCostos, @CentroCostosSucursal, @CentroCostosDestino, @CentroCostosMatriz, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, @Concepto, @Orden, @Debe,  1, @Ok OUTPUT, @OkRef OUTPUT, @CfgPartidasSinImporte, @ObligacionFiscal, @ContAutoEmpresa = @ContAutoEmpresa
IF @Haber IS NOT NULL EXEC spContAutoFiscal @Modulo, @Clave, @Nombre, @ID, @Cuenta, @CuentaOmision, @OmitirConcepto, @OmitirCentroCostos, @CentroCostos, @CentroCostosSucursal, @CentroCostosDestino, @CentroCostosMatriz, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, @Concepto, @Orden, @Haber, 0, @Ok OUTPUT, @OkRef OUTPUT, @CfgPartidasSinImporte, @ObligacionFiscal, @ContAutoEmpresa = @ContAutoEmpresa
END ELSE
IF @Modulo = 'PC'
BEGIN
IF @Debe  IS NOT NULL EXEC spContAutoPC @Modulo, @ID, @Cuenta, @CuentaOmision, @OmitirConcepto, @OmitirCentroCostos, @CentroCostos, @CentroCostosSucursal, @CentroCostosDestino, @CentroCostosMatriz, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Orden, @Debe,  1, @Ok OUTPUT, @OkRef OUTPUT, @CfgPartidasSinImporte, @CfgContArticulo, @IncluirArticulos, @IncluirDepartamento
IF @Haber IS NOT NULL EXEC spContAutoPC @Modulo, @ID, @Cuenta, @CuentaOmision, @OmitirConcepto, @OmitirCentroCostos, @CentroCostos, @CentroCostosSucursal, @CentroCostosDestino, @CentroCostosMatriz, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Orden, @Haber, 0, @Ok OUTPUT, @OkRef OUTPUT, @CfgPartidasSinImporte, @CfgContArticulo, @IncluirArticulos, @IncluirDepartamento
END ELSE
IF @Modulo = 'NOM'
BEGIN
IF @Debe  IS NOT NULL  EXEC spContAutoNomina @Empresa, @Modulo, @ID, @Cuenta, @CuentaOmision, @OmitirConcepto, @QueConcepto, @OmitirCentroCostos, @CentroCostos, @CentroCostosSucursal, @CentroCostosDestino, @CentroCostosMatriz, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Orden, @Condicion, @Debe,  1, @Ok OUTPUT, @OkRef OUTPUT, @CfgPartidasSinImporte, @ContAutoContactoEsp
IF @Haber IS NOT NULL  EXEC spContAutoNomina @Empresa, @Modulo, @ID, @Cuenta, @CuentaOmision, @OmitirConcepto, @QueConcepto, @OmitirCentroCostos, @CentroCostos, @CentroCostosSucursal, @CentroCostosDestino, @CentroCostosMatriz, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Orden, @Condicion, @Haber, 0, @Ok OUTPUT, @OkRef OUTPUT, @CfgPartidasSinImporte, @ContAutoContactoEsp
END ELSE
BEGIN
IF @Cuenta = 'CONTACTO' AND NULLIF(RTRIM(@ContAutoContactoEsp),'') IS NOT NULL
BEGIN
SELECT @Contacto = dbo.fnContactoEspecifico(@ContAutoContactoEsp, @Contacto, @ContactoAplica, @ContactoDetalle, @Agente, @Personal, @CtaDinero, @CtaDineroDestino, @Almacen, @AlmacenDestino, @AlmacenDetalle)
IF UPPER(@ContAutoContactoEsp) = 'CONTACTO ARRASTRE'
BEGIN
SELECT @OrigenModulo = OrigenModulo, @OrigenModuloID = OrigenModuloID FROM MovImpuesto WHERE Modulo = @Modulo AND ModuloID = @ID
EXEC spMovInfo @OrigenModuloID, @OrigenModulo, @Contacto = @Contacto OUTPUT
END
END
EXEC spContAutoGetCuenta @Modulo, @Cuenta, @CuentaOmision, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, NULL, NULL, NULL, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Cta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @ContAutoContactoEsp = 'Agente' AND @Contacto IS NULL AND @Cta IS NULL
EXEC spContAutoPolizaCtaAgente @Modulo, @ID, @Cta OUTPUT
IF @Modulo = 'CXC'
BEGIN
IF @OmitirCentroCostos = 1
BEGIN 
SELECT @ContUso   = NULL 
SELECT @ContUso2  = NULL 
SELECT @ContUso3  = NULL 
END 
ELSE 
BEGIN 
SELECT @ContUso = CASE @CentroCostos WHEN 'Sucursal' THEN @CentroCostosSucursal WHEN 'Sucursal Destino' THEN @CentroCostosDestino WHEN 'Matriz' THEN @CentroCostosMatriz ELSE (SELECT ContUso FROM Cxc WHERE ID = @ID) END 
SELECT @ContUso2 = ContUso2, @ContUso3 = ContUso3  FROM Cxc WHERE ID = @ID 
END 
IF @Cuenta = 'TABLA %'
BEGIN
IF EXISTS(SELECT * FROM CxcD WHERE ID = @ID)
BEGIN
IF @Debe  IS NOT NULL EXEC spContAutoCx @Modulo, @Clave, @Nombre, @ID, @Cuenta, @CuentaOmision, @OmitirConcepto, @OmitirCentroCostos, @CentroCostos, @CentroCostosSucursal, @CentroCostosDestino, @CentroCostosMatriz, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Orden, @Debe,  1, @Ok OUTPUT, @OkRef OUTPUT, @CfgPartidasSinImporte, @ContAutoContactoEsp, @ContactoAplica, @ContAutoEmpresa = @ContAutoEmpresa
IF @Haber IS NOT NULL EXEC spContAutoCx @Modulo, @Clave, @Nombre, @ID, @Cuenta, @CuentaOmision, @OmitirConcepto, @OmitirCentroCostos, @CentroCostos, @CentroCostosSucursal, @CentroCostosDestino, @CentroCostosMatriz, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Orden, @Haber, 0, @Ok OUTPUT, @OkRef OUTPUT, @CfgPartidasSinImporte, @ContAutoContactoEsp, @ContactoAplica, @ContAutoEmpresa = @ContAutoEmpresa
END ELSE
BEGIN
IF @Debe IN ('IMPUESTOS', 'IVA FISCAL') OR @Haber IN ('IMPUESTOS', 'IVA FISCAL')
BEGIN
SELECT @Agente = Agente, @Personal = PersonalCobrador, @Monto = Impuestos*TipoCambio, @Importe = Importe*TipoCambio FROM Cxc WHERE ID = @ID
SELECT @ContactoEspecifico = dbo.fnContactoEspecifico(@ContAutoContactoEsp, @Contacto, @ContactoAplica, @ContactoDetalle, @Agente, @Personal, @CtaDinero, @CtaDineroDestino, @Almacen, @AlmacenDestino, @AlmacenDetalle)
EXEC spContAutoGetCuentaTabla @Modulo, @Clave, @Nombre, @Monto, @Importe, @Cta OUTPUT, @ContAutoEmpresa = @ContAutoEmpresa
IF @Cta IS NOT NULL
BEGIN
IF @Debe  IN ('IMPUESTOS', 'IVA FISCAL') INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, Debe,  ContactoEspecifico, ContactoTipo) VALUES (@Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @Monto, @ContactoEspecifico, dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo)) 
IF @Haber IN ('IMPUESTOS', 'IVA FISCAL') INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, Haber, ContactoEspecifico, ContactoTipo) VALUES (@Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @Monto, @ContactoEspecifico, dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo)) 
END
END
END
END ELSE
BEGIN
IF @Cta IS NULL
EXEC xpContAutoCuentaExtra @Modulo, @ID, @Cuenta, @CuentaOmision, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, NULL, NULL, NULL, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Cta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spContAutoCxEncabezado @Empresa, @Sucursal, @Modulo, @ID, @MovTipo, @Orden, @Debe, @Haber, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @Diferencia, @DiferenciaIVA,@DiferenciaIEPS, @CxTipoCambio, @ContactoTipoCambio, @CxImporteTotalMN, @CxImporteAplicaMN, @CxIVAMN, @CxIVAAplicaMN, @CxIEPSMN, @CxIEPSAplicaMN, @CxPicosMN, @ContactoSubTipo, @ContAutoContactoEsp, @Contacto, @ContactoAplica, @CtaDinero, @CtaDineroDestino, @Ok OUTPUT, @OkRef OUTPUT, @ContactoTipo 
END
END ELSE
IF @Modulo = 'CXP'
BEGIN
IF @OmitirCentroCostos = 1
BEGIN 
SELECT @ContUso  = NULL, @ContUso2 = NULL, @ContUso3 = NULL 
END 
ELSE 
BEGIN 
SELECT @ContUso = CASE @CentroCostos WHEN 'Sucursal' THEN @CentroCostosSucursal WHEN 'Sucursal Destino' THEN @CentroCostosDestino WHEN 'Matriz' THEN @CentroCostosMatriz ELSE (SELECT ContUso FROM Cxp WHERE ID = @ID) END
SELECT @ContUso2 = ContUso2, @ContUso3 = ContUso3  FROM Cxp WHERE ID = @ID 
END 
IF @Cuenta = 'TABLA %'
BEGIN
IF EXISTS(SELECT * FROM CxpD WHERE ID = @ID)
BEGIN
IF @Debe  IS NOT NULL EXEC spContAutoCx @Modulo, @Clave, @Nombre, @ID, @Cuenta, @CuentaOmision, @OmitirConcepto, @OmitirCentroCostos, @CentroCostos, @CentroCostosSucursal, @CentroCostosDestino, @CentroCostosMatriz, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Orden, @Debe,  1, @Ok OUTPUT, @OkRef OUTPUT, @CfgPartidasSinImporte, @ContAutoContactoEsp, @ContactoAplica, @ContAutoEmpresa = @ContAutoEmpresa
IF @Haber IS NOT NULL EXEC spContAutoCx @Modulo, @Clave, @Nombre, @ID, @Cuenta, @CuentaOmision, @OmitirConcepto, @OmitirCentroCostos, @CentroCostos, @CentroCostosSucursal, @CentroCostosDestino, @CentroCostosMatriz, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Orden, @Haber, 0, @Ok OUTPUT, @OkRef OUTPUT, @CfgPartidasSinImporte, @ContAutoContactoEsp, @ContactoAplica, @ContAutoEmpresa = @ContAutoEmpresa
END ELSE
BEGIN
IF @Debe = 'IMPUESTOS' OR @Haber = 'IMPUESTOS'
BEGIN
SELECT @Monto = Impuestos*TipoCambio, @Importe = Importe*TipoCambio FROM Cxp WHERE ID = @ID
SELECT @ContactoEspecifico = dbo.fnContactoEspecifico(@ContAutoContactoEsp, @Contacto, @ContactoAplica, @ContactoDetalle, @Agente, @Personal, @CtaDinero, @CtaDineroDestino, @Almacen, @AlmacenDestino, @AlmacenDetalle)
EXEC spContAutoGetCuentaTabla @Modulo, @Clave, @Nombre, @Monto, @Importe, @Cta OUTPUT, @ContAutoEmpresa = @ContAutoEmpresa
IF @Cta IS NOT NULL
BEGIN
IF @Debe   = 'IMPUESTOS' INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, Debe,  ContactoEspecifico, ContactoTipo) VALUES (@Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @Monto, @ContactoEspecifico, dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo)) 
IF @Haber  = 'IMPUESTOS' INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, Haber, ContactoEspecifico, ContactoTipo) VALUES (@Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @Monto, @ContactoEspecifico, dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo)) 
END
END
END
END ELSE
EXEC spContAutoCxEncabezado @Empresa, @Sucursal, @Modulo, @ID, @MovTipo, @Orden, @Debe, @Haber, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @Diferencia, @DiferenciaIVA,@DiferenciaIEPS, @CxTipoCambio, @ContactoTipoCambio, @CxImporteTotalMN, @CxImporteAplicaMN, @CxIVAMN, @CxIVAAplicaMN, @CxIEPSMN, @CxIEPSAplicaMN, @CxPicosMN, @ContactoSubTipo, @ContAutoContactoEsp, @Contacto, @ContactoAplica, @CtaDinero, @CtaDineroDestino, @Ok OUTPUT, @OkRef OUTPUT, @ContactoTipo 
END ELSE
IF @Modulo = 'AGENT'
BEGIN
SELECT @Agente = Agente FROM Agent WHERE ID = @ID
SELECT @ContactoEspecifico = dbo.fnContactoEspecifico(@ContAutoContactoEsp, @Contacto, @ContactoAplica, @ContactoDetalle, @Agente, @Personal, @CtaDinero, @CtaDineroDestino, @Almacen, @AlmacenDestino, @AlmacenDetalle)
IF @Debe   = 'IMPORTE'   	  INSERT #Poliza (Orden, Cuenta, Concepto, ContactoEspecifico, Debe,  ContactoTipo)  SELECT @Orden, @Cta, @Concepto, @ContactoEspecifico, SUM(Importe*TipoCambio), dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo)			FROM Agent WHERE ID = @ID ELSE 
IF @Haber  = 'IMPORTE'   	  INSERT #Poliza (Orden, Cuenta, Concepto, ContactoEspecifico, Haber, ContactoTipo)  SELECT @Orden, @Cta, @Concepto, @ContactoEspecifico, SUM(Importe*TipoCambio), dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo) 		FROM Agent WHERE ID = @ID ELSE 
IF @Debe   = 'IMPUESTOS' 	  INSERT #Poliza (Orden, Cuenta, Concepto, ContactoEspecifico, Debe,  ContactoTipo)  SELECT @Orden, @Cta, @Concepto, @ContactoEspecifico, SUM(Impuestos*TipoCambio), dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo)    	FROM Agent WHERE ID = @ID ELSE 
IF @Haber  = 'IMPUESTOS' 	  INSERT #Poliza (Orden, Cuenta, Concepto, ContactoEspecifico, Haber, ContactoTipo)  SELECT @Orden, @Cta, @Concepto, @ContactoEspecifico, SUM(Impuestos*TipoCambio), dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo)    	FROM Agent WHERE ID = @ID ELSE 
IF @Debe   = 'RETENCIONES' 	  INSERT #Poliza (Orden, Cuenta, Concepto, ContactoEspecifico, Debe,  ContactoTipo)  SELECT @Orden, @Cta, @Concepto, @ContactoEspecifico, SUM(Retencion*TipoCambio), dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo)    	FROM Agent WHERE ID = @ID ELSE 
IF @Haber  = 'RETENCIONES'    INSERT #Poliza (Orden, Cuenta, Concepto, ContactoEspecifico, Haber, ContactoTipo)  SELECT @Orden, @Cta, @Concepto, @ContactoEspecifico, SUM(Retencion*TipoCambio), dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo)    	FROM Agent WHERE ID = @ID ELSE 
IF @Debe   = 'IMPORTE TOTAL'  INSERT #Poliza (Orden, Cuenta, Concepto, ContactoEspecifico, Debe,  ContactoTipo)  SELECT @Orden, @Cta, @Concepto, @ContactoEspecifico, SUM((ISNULL(Importe, 0)+ISNULL(Impuestos, 0)-ISNULL(Retencion, 0))*TipoCambio), dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo) FROM Agent WHERE ID = @ID ELSE 
IF @Haber  = 'IMPORTE TOTAL'  INSERT #Poliza (Orden, Cuenta, Concepto, ContactoEspecifico, Haber, ContactoTipo)  SELECT @Orden, @Cta, @Concepto, @ContactoEspecifico, SUM((ISNULL(Importe, 0)+ISNULL(Impuestos, 0)-ISNULL(Retencion, 0))*TipoCambio), dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo) FROM Agent WHERE ID = @ID 
END ELSE
IF @Modulo = 'DIN'
BEGIN
IF @ConDesglose = 1 AND @Cuenta = 'FORMA PAGO'
BEGIN
IF @Debe  IS NOT NULL EXEC spContAutoDinero @Modulo, @ID, @Cuenta, @CuentaOmision, @OmitirConcepto, @OmitirCentroCostos, @CentroCostos, @CentroCostosSucursal, @CentroCostosDestino, @CentroCostosMatriz, @Concepto, @Orden, @Debe,  1, @Ok OUTPUT, @OkRef OUTPUT, @CfgPartidasSinImporte, NULL, @SucursalContable, @ContAutoContactoEsp, @Contacto, @ContactoAplica, @ContactoTipo 
IF @Haber IS NOT NULL EXEC spContAutoDinero @Modulo, @ID, @Cuenta, @CuentaOmision, @OmitirConcepto, @OmitirCentroCostos, @CentroCostos, @CentroCostosSucursal, @CentroCostosDestino, @CentroCostosMatriz, @Concepto, @Orden, @Haber, 0, @Ok OUTPUT, @OkRef OUTPUT, @CfgPartidasSinImporte, NULL, @SucursalContable, @ContAutoContactoEsp, @Contacto, @ContactoAplica, @ContactoTipo 
END ELSE
IF @Directo = 0 AND @DebeHaber IN ('IMPORTE', 'IMPUESTOS', 'IMPORTE TOTAL', 'IVA FISCAL', 'IEPS FISCAL', 'INTERESES')
BEGIN
IF @Debe  IS NOT NULL EXEC spContAutoDinero @Modulo, @ID, @Cuenta, @CuentaOmision, @OmitirConcepto, @OmitirCentroCostos, @CentroCostos, @CentroCostosSucursal, @CentroCostosDestino, @CentroCostosMatriz, @Concepto, @Orden, @Debe,  1, @Ok OUTPUT, @OkRef OUTPUT, @CfgPartidasSinImporte, @Cta, @SucursalContable, @ContAutoContactoEsp, @Contacto, @ContactoAplica, @ContactoTipo 
IF @Haber IS NOT NULL EXEC spContAutoDinero @Modulo, @ID, @Cuenta, @CuentaOmision, @OmitirConcepto, @OmitirCentroCostos, @CentroCostos, @CentroCostosSucursal, @CentroCostosDestino, @CentroCostosMatriz, @Concepto, @Orden, @Haber, 0, @Ok OUTPUT, @OkRef OUTPUT, @CfgPartidasSinImporte, @Cta, @SucursalContable, @ContAutoContactoEsp, @Contacto, @ContactoAplica, @ContactoTipo 
END ELSE
BEGIN
SELECT @ContactoEspecifico = dbo.fnContactoEspecifico(@ContAutoContactoEsp, @Contacto, @ContactoAplica, @ContactoDetalle, @Agente, @Personal, @CtaDinero, @CtaDineroDestino, @Almacen, @AlmacenDestino, @AlmacenDetalle)
IF @OmitirCentroCostos = 1
BEGIN 
SELECT @ContUso   = NULL 
SELECT @ContUso2  = NULL 
SELECT @ContUso3  = NULL 
END 
ELSE 
BEGIN 
SELECT @ContUso = CASE @CentroCostos WHEN 'Sucursal' THEN @CentroCostosSucursal WHEN 'Sucursal Destino' THEN @CentroCostosDestino WHEN 'Matriz' THEN @CentroCostosMatriz ELSE (SELECT ContUso FROM Dinero WHERE ID = @ID) END 
SELECT @ContUso2 = ContUso2, @ContUso3 = ContUso3 FROM Dinero WHERE ID = @ID 
END 
IF @Debe   = 'IMPORTE'   	       INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Debe,  ContactoTipo)  SELECT @Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, Importe*TipoCambio, dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo) 	 FROM Dinero WHERE ID = @ID ELSE 
IF @Haber  = 'IMPORTE'   	       INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Haber, ContactoTipo) SELECT @Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, Importe*TipoCambio, dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo) 	 FROM Dinero WHERE ID = @ID ELSE 
IF @Debe   = 'IMPUESTOS' 	       INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Debe,  ContactoTipo)  SELECT @Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, Impuestos*TipoCambio, dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo) FROM Dinero WHERE ID = @ID ELSE 
IF @Haber  = 'IMPUESTOS' 	       INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Haber, ContactoTipo) SELECT @Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, Impuestos*TipoCambio, dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo) FROM Dinero WHERE ID = @ID ELSE 
IF @Debe   = 'IMPORTE TOTAL'     INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Debe,  ContactoTipo)  SELECT @Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, (ISNULL(Importe, 0)+ISNULL(Impuestos, 0))*TipoCambio, dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo) FROM Dinero WHERE ID = @ID ELSE 
IF @Haber  = 'IMPORTE TOTAL'     INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Haber, ContactoTipo) SELECT @Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, (ISNULL(Importe, 0)+ISNULL(Impuestos, 0))*TipoCambio, dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo) FROM Dinero WHERE ID = @ID ELSE 
IF @Debe   = 'IVA FISCAL'        INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Debe,  ContactoTipo)  SELECT @Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, (ISNULL(Importe, 0)+ISNULL(Impuestos, 0))*TipoCambio*IVAFiscal, dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo)  FROM Dinero WHERE ID = @ID ELSE 
IF @Haber  = 'IVA FISCAL'        INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Haber, ContactoTipo) SELECT @Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, (ISNULL(Importe, 0)+ISNULL(Impuestos, 0))*TipoCambio*IVAFiscal, dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo)  FROM Dinero WHERE ID = @ID ELSE 
IF @Debe   = 'IEPS FISCAL'       INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Debe,  ContactoTipo)  SELECT @Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, (ISNULL(Importe, 0)+ISNULL(Impuestos, 0))*TipoCambio*IEPSFiscal, dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo) FROM Dinero WHERE ID = @ID ELSE 
IF @Haber  = 'IEPS FISCAL'       INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Haber, ContactoTipo) SELECT @Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, (ISNULL(Importe, 0)+ISNULL(Impuestos, 0))*TipoCambio*IEPSFiscal, dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo) FROM Dinero WHERE ID = @ID ELSE 
IF @Debe   = 'INTERES BRUTO'     INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Debe,  ContactoTipo)  SELECT @Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, (ISNULL(Importe, 0)+ISNULL(Impuestos, 0))*TipoCambio*Tasa/NULLIF(TasaDias, 0)/100.0*DATEDIFF(day, FechaOrigen, Vencimiento), dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo) FROM Dinero WHERE ID = @ID ELSE 
IF @Haber  = 'INTERES BRUTO'     INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Haber, ContactoTipo) SELECT @Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, (ISNULL(Importe, 0)+ISNULL(Impuestos, 0))*TipoCambio*Tasa/NULLIF(TasaDias, 0)/100.0*DATEDIFF(day, FechaOrigen, Vencimiento), dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo) FROM Dinero WHERE ID = @ID ELSE 
IF @Debe   = 'INTERES NETO'      INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Debe,  ContactoTipo)  SELECT @Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, ((ISNULL(Importe, 0)+ISNULL(Impuestos, 0))*TipoCambio*Tasa/NULLIF(TasaDias, 0)/100.0*DATEDIFF(day, FechaOrigen, Vencimiento))-ISNULL(Retencion, 0.0)*TipoCambio, dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo) FROM Dinero WHERE ID = @ID ELSE 
IF @Haber  = 'INTERES NETO'      INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Haber, ContactoTipo) SELECT @Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, ((ISNULL(Importe, 0)+ISNULL(Impuestos, 0))*TipoCambio*Tasa/NULLIF(TasaDias, 0)/100.0*DATEDIFF(day, FechaOrigen, Vencimiento))-ISNULL(Retencion, 0.0)*TipoCambio, dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo) FROM Dinero WHERE ID = @ID ELSE 
IF @Debe   = 'INTERES RETENCION' INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Debe,  ContactoTipo)  SELECT @Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, Retencion*TipoCambio, dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo) FROM Dinero WHERE ID = @ID ELSE 
IF @Haber  = 'INTERES RETENCION' INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Haber, ContactoTipo) SELECT @Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, Retencion*TipoCambio, dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo) FROM Dinero WHERE ID = @ID ELSE 
IF @Debe   = 'UTILIDAD'          INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Debe,  ContactoTipo)  SELECT @Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, Importe*TipoCambio, dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo) FROM Dinero WHERE ID = @ID AND Importe>0 ELSE 
IF @Haber  = 'UTILIDAD'          INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Haber, ContactoTipo) SELECT @Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, Importe*TipoCambio, dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo) FROM Dinero WHERE ID = @ID AND Importe>0 ELSE 
IF @Debe   = 'PERDIDA'   	       INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Debe,  ContactoTipo)  SELECT @Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, -Importe*TipoCambio, dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo) FROM Dinero WHERE ID = @ID AND Importe<0 ELSE 
IF @Haber  = 'PERDIDA'   	       INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Haber, ContactoTipo) SELECT @Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, -Importe*TipoCambio, dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo) FROM Dinero WHERE ID = @ID AND Importe<0 
END
END ELSE
IF @Modulo = 'VALE'
BEGIN
IF @Debe   = 'IMPORTE'   	INSERT #Poliza (Orden, Cuenta, Concepto, Debe)  SELECT @Orden, @Cta, @Concepto, SUM(Importe*TipoCambio) 	FROM Vale WHERE ID = @ID ELSE
IF @Haber  = 'IMPORTE'   	INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, SUM(Importe*TipoCambio) 	FROM Vale WHERE ID = @ID
END ELSE
IF @Modulo = 'CR'
BEGIN
IF @Debe   = 'IMPORTE'   	INSERT #Poliza (Orden, Cuenta, Concepto, Debe)  SELECT @Orden, @Cta, @Concepto, SUM(d.Importe*e.TipoCambio) 	FROM CRVenta d, CR e WHERE d.ID = e.ID AND e.ID = @ID ELSE
IF @Haber  = 'IMPORTE'   	INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, SUM(d.Importe*e.TipoCambio) 	FROM CRVenta d, CR e WHERE d.ID = e.ID AND e.ID = @ID
END ELSE
IF @Modulo = 'CAM'
BEGIN
IF @Debe   = 'IMPORTE'   	INSERT #Poliza (Orden, Cuenta, Concepto, Debe)  SELECT @Orden, @Cta, @Concepto, SUM(Monto*TipoCambio) 	FROM CambioD WHERE ID = @ID ELSE
IF @Haber  = 'IMPORTE'   	INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, SUM(Monto*TipoCambio) 	FROM CambioD WHERE ID = @ID
END ELSE
IF @Modulo = 'CAP'
BEGIN
IF @Debe   = 'PRECIO' INSERT #Poliza (Orden, Cuenta, Concepto, Debe)  SELECT @Orden, @Cta, @Concepto, SUM(d.Precio*d.Cantidad*e.TipoCambio) FROM CapitalD d, Capital e WHERE d.ID = e.ID AND e.ID = @ID ELSE
IF @Haber  = 'PRECIO' INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, SUM(d.Precio*d.Cantidad*e.TipoCambio) FROM CapitalD d, Capital e WHERE d.ID = e.ID AND e.ID = @ID ELSE
IF @Debe   = 'COSTO'  INSERT #Poliza (Orden, Cuenta, Concepto, Debe)  SELECT @Orden, @Cta, @Concepto, SUM(d.Costo*d.Cantidad*e.TipoCambio)  FROM CapitalD d, Capital e WHERE d.ID = e.ID AND e.ID = @ID ELSE
IF @Haber  = 'COSTO'  INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, SUM(d.Costo*d.Cantidad*e.TipoCambio)  FROM CapitalD d, Capital e WHERE d.ID = e.ID AND e.ID = @ID
END ELSE
IF @Modulo = 'INC'
BEGIN
IF @Debe   = 'IMPORTE' INSERT #Poliza (Orden, Cuenta, Concepto, Debe)  SELECT @Orden, @Cta, @Concepto, SUM(d.Importe*e.TipoCambio) FROM IncidenciaD d, Incidencia e WHERE d.ID = e.ID AND e.ID = @ID ELSE
IF @Haber  = 'IMPORTE' INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, SUM(d.Importe*e.TipoCambio) FROM IncidenciaD d, Incidencia e WHERE d.ID = e.ID AND e.ID = @ID
END ELSE
IF @Modulo = 'CONC'
BEGIN
IF @Debe   = 'CARGO' INSERT #Poliza (Orden, Cuenta, Concepto, Debe)  SELECT @Orden, @Cta, @Concepto, SUM(d.Cargo*e.TipoCambio) FROM ConciliacionD d, Conciliacion e WHERE d.ID = e.ID AND e.ID = @ID ELSE
IF @Haber  = 'ABONO' INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, SUM(d.Abono*e.TipoCambio) FROM ConciliacionD d, Conciliacion e WHERE d.ID = e.ID AND e.ID = @ID
END ELSE
IF @Modulo = 'PPTO'
BEGIN
IF @Debe   = 'IMPORTE' INSERT #Poliza (Orden, Cuenta, Concepto, Debe)  SELECT @Orden, @Cta, @Concepto, SUM(d.Importe*e.TipoCambio) FROM PresupD d, Presup e WHERE d.ID = e.ID AND e.ID = @ID ELSE
IF @Haber  = 'IMPORTE' INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, SUM(d.Importe*e.TipoCambio) FROM PresupD d, Presup e WHERE d.ID = e.ID AND e.ID = @ID
END ELSE
IF @Modulo = 'CREDI'
BEGIN
IF @Debe   = 'IMPORTE'          INSERT #Poliza (Orden, Cuenta, Concepto, Debe)  SELECT @Orden, @Cta, @Concepto, SUM(e.Importe*e.TipoCambio)       FROM Credito e WHERE e.ID = @ID ELSE
IF @Haber  = 'IMPORTE'          INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, SUM(e.Importe*e.TipoCambio)       FROM Credito e WHERE e.ID = @ID ELSE
IF @Debe   = 'COMISIONES'       INSERT #Poliza (Orden, Cuenta, Concepto, Debe)  SELECT @Orden, @Cta, @Concepto, SUM(e.Comisiones*e.TipoCambio)    FROM Credito e WHERE e.ID = @ID ELSE
IF @Haber  = 'COMISIONES'       INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, SUM(e.Comisiones*e.TipoCambio)    FROM Credito e WHERE e.ID = @ID ELSE
IF @Debe   = 'COMISIONES IVA'   INSERT #Poliza (Orden, Cuenta, Concepto, Debe)  SELECT @Orden, @Cta, @Concepto, SUM(e.ComisionesIVA*e.TipoCambio) FROM Credito e WHERE e.ID = @ID ELSE
IF @Haber  = 'COMISIONES IVA'   INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, SUM(e.ComisionesIVA*e.TipoCambio) FROM Credito e WHERE e.ID = @ID ELSE
IF @Debe   = 'TOTAL COMISIONES' INSERT #Poliza (Orden, Cuenta, Concepto, Debe)  SELECT @Orden, @Cta, @Concepto, SUM(ISNULL(e.Comisiones, 0.0)+ISNULL(e.ComisionesIVA, 0.0)*e.TipoCambio) FROM Credito e WHERE e.ID = @ID ELSE
IF @Haber  = 'TOTAL COMISIONES' INSERT #Poliza (Orden, Cuenta, Concepto, Haber) SELECT @Orden, @Cta, @Concepto, SUM(ISNULL(e.Comisiones, 0.0)+ISNULL(e.ComisionesIVA, 0.0)*e.TipoCambio) FROM Credito e WHERE e.ID = @ID
END
END
END
END
FETCH NEXT FROM crContAuto INTO @Nombre, @Orden, @Condicion, @Debe, @Haber, @Cuenta, @CuentaOmision, @OmitirConcepto, @QueConcepto, @OmitirCentroCostos, @CentroCostos, @SucursalContable, @IncluirArticulos, @IncluirDepartamento, @ContAutoContactoEsp, @ObligacionFiscal, @Contacto 
IF @@ERROR <> 0 SELECT @Ok = 1
END  
CLOSE crContAuto
DEALLOCATE crContAuto
DELETE #Poliza WHERE ISNULL(Debe,0) = 0 AND ISNULL(Haber,0) = 0 
RETURN
END

