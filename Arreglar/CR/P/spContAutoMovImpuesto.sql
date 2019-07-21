SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContAutoMovImpuesto
@Modulo					char(5),
@Clave						varchar(20),
@Nombre					varchar(50),
@ID						int,
@Cuenta					varchar(20),
@CuentaOmision				char(20),
@OmitirConcepto			bit,
@OmitirCentroCostos		bit,
@CentroCostos				varchar(20),
@CentroCostosSucursal		varchar(20),
@CentroCostosDestino		varchar(20),
@CentroCostosMatriz		varchar(20),
@CtaCtoTipo				varchar(20),
@CtaCtoTipoAplica			varchar(20),
@CtaClase					char(20),
@Concepto					varchar(50),
@Contacto					char(10),
@ContactoTipo				varchar(20),
@CtaDinero					char(10),
@CtaDineroDestino			char(10),
@FormaPago					varchar(50),
@Orden						int,
@Campo						varchar(20),
@EsDebe					bit,
@Ok						int				OUTPUT,
@OkRef						varchar(255)	OUTPUT,
@CfgPartidasSinImporte		bit,
@TipoCambio				float,
@ContAutoContactoEsp		varchar(50),
@ContactoAplica			varchar(10),
@ContAutoEmpresa			varchar(10) = '(Todas)'

AS BEGIN
DECLARE
@Impuesto1						float,
@Impuesto2						float,
@Impuesto3						float,
@Impuesto5						float,
@Retencion1						float,
@Retencion2						float,
@Retencion3						float,
@Importe1						money,
@Importe2						money,
@Importe3						money,
@Importe5						money,
@ImporteRetencion1				money,
@ImporteRetencion2				money,
@ImporteRetencion3 				money,
@Excento1						bit,
@Cta							char(20),
@ContUso						varchar(20),
@LoteFijo						varchar(50),
@OrigenModulo					varchar(5),
@OrigenModuloID					varchar(20),
@OrigenConcepto					varchar(50),
@OrigenFecha					datetime,
@Monto							money,
@Debe							money,
@Haber							money,
@ContUso2						varchar(20),
@ContUso3						varchar(20),
@SubTotal						money,
@Total							money,
@DescuentoGlobal				float,
@DescuentoImporte				money,
@TotalBruto						money,
@ContactoArrastre				varchar(10),
@ContactoEspecifico				varchar(10),
@CfgRetencion2BaseImpuesto1		bit,
@TipoImpuesto1					varchar(10),
@TipoImpuesto2					varchar(10),
@TipoImpuesto3					varchar(10),
@TipoImpuesto5					varchar(10),
@TipoRetencion1					varchar(10),
@TipoRetencion2					varchar(10),
@TipoRetencion3					varchar(10),
@RetencionIVA					varchar(10)
SELECT @CfgRetencion2BaseImpuesto1 = ISNULL(Retencion2BaseImpuesto1, 0) FROM Version
SELECT @ContUso  = NULL
IF @Campo IS NULL RETURN
DECLARE crMovImpuesto CURSOR FOR
SELECT OrigenModulo, OrigenModuloID, OrigenConcepto, OrigenFecha, Retencion1, Retencion2, Retencion3, LoteFijo, ContUso, ContUso2, ContUso3, Impuesto1, Impuesto2, Impuesto3, Impuesto5, SUM(Importe1), SUM(Importe2), SUM(Importe3), SUM(Importe5), SUM(SubTotal*(Retencion1/100.0)), SUM(CASE WHEN @CfgRetencion2BaseImpuesto1 = 1 THEN Importe1 ELSE SubTotal END*(Retencion2/100.0)), SUM(SubTotal*(Retencion3/100.0)), Excento1, ISNULL(DescuentoGlobal,0.0),
TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoImpuesto5, TipoRetencion1, TipoRetencion2, TipoRetencion3,
SUM(ISNULL(Subtotal,0.0)),
SUM(ISNULL(SubTotal,0.0) + ISNULL(Importe1,0.0) + ISNULL(Importe2,0.0) + ISNULL(Importe3,0.0) + ISNULL(Importe5,0.0) - (ISNULL(SubTotal,0.0)*(ISNULL(Retencion1,0.0)/100.0)) - (CASE WHEN @CfgRetencion2BaseImpuesto1 = 1 THEN ISNULL(Importe1,0.0) ELSE ISNULL(SubTotal,0.0) END*(ISNULL(Retencion2,0.0)/100.0)) - (ISNULL(SubTotal,0.0)*(ISNULL(Retencion3,0.0)/100.0))),
SUM(ImporteBruto * (ISNULL(DescuentoGlobal,0.0)/100)),
SUM(ImporteBruto),
(SUM(ISNULL(Subtotal,0.0))*(Retencion2/100))
FROM MovImpuesto
WHERE Modulo = @Modulo AND ModuloID = @ID
GROUP BY OrigenModulo, OrigenModuloID, OrigenConcepto, OrigenFecha, Retencion1, Retencion2, Retencion3, LoteFijo, ContUso, ContUso2, ContUso3, Impuesto1, Impuesto2, Impuesto3, Impuesto5, Excento1, DescuentoGlobal, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoImpuesto5, TipoRetencion1, TipoRetencion2, TipoRetencion3
ORDER BY OrigenModulo, OrigenModuloID, OrigenConcepto, OrigenFecha, Retencion1, Retencion2, Retencion3, LoteFijo, ContUso, ContUso2, ContUso3, Impuesto1, Impuesto2, Impuesto3, Impuesto5, Excento1, DescuentoGlobal, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoImpuesto5, TipoRetencion1, TipoRetencion2, TipoRetencion3
OPEN crMovImpuesto
FETCH NEXT FROM crMovImpuesto INTO @OrigenModulo, @OrigenModuloID, @OrigenConcepto, @OrigenFecha, @Retencion1, @Retencion2, @Retencion3, @LoteFijo, @ContUso, @ContUso2, @ContUso3, @Impuesto1, @Impuesto2, @Impuesto3, @Impuesto5, @Importe1, @Importe2, @Importe3, @Importe5, @ImporteRetencion1, @ImporteRetencion2, @ImporteRetencion3, @Excento1, @DescuentoGlobal,
@TipoImpuesto1, @TipoImpuesto2, @TipoImpuesto3, @TipoImpuesto5, @TipoRetencion1, @TipoRetencion2, @TipoRetencion3,
@SubTotal, @Total, @DescuentoImporte, @TotalBruto, @RetencionIVA
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @Monto = NULL, @Cta = NULL
EXEC spContAutoGetCuenta @Modulo, @Cuenta, @CuentaOmision, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, NULL, NULL, NULL, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Cta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT,
@TipoImpuesto1, @TipoImpuesto2, @TipoImpuesto3, @TipoImpuesto5, @TipoRetencion1, @TipoRetencion2, @TipoRetencion3
IF @Cta IS NOT NULL OR @Cuenta IN ('TABLA %', 'LOTE FIJO', 'LOTE FIJO ESPECIFICO', 'CONCEPTO ORIGEN')
BEGIN
IF @Campo = 'TOTAL IMPUESTO 1' 		SELECT @Monto = @Importe1 ELSE
IF @Campo = 'TOTAL IMPUESTO 2' 		SELECT @Monto = @Importe2 ELSE
IF @Campo = 'TOTAL IMPUESTO 3' 		SELECT @Monto = @Importe3 ELSE
IF @Campo = 'TOTAL IMPUESTO 5' 		SELECT @Monto = @Importe5 ELSE
IF @Campo = 'TOTAL RETENCION 1'		SELECT @Monto = @ImporteRetencion1 ELSE
IF @Campo = 'TOTAL RETENCION 2'		SELECT @Monto = @ImporteRetencion2 ELSE
IF @Campo = 'TOTAL RETENCION 3'		SELECT @Monto = @ImporteRetencion3
IF @Campo = 'SUBTOTAL ARRASTRE'		SELECT @Monto = @SubTotal
IF @Campo = 'TOTAL ARRASTRE'		SELECT @Monto = @Total
IF @Campo = 'TOTAL BRUTO ARRASTRE'	SELECT @Monto = @TotalBruto
IF @Campo = 'DESCUENTO ARRASTRE'	SELECT @Monto = @DescuentoImporte
IF @Campo = 'Retencion IVA'			SELECT @Monto = @RetencionIVA
IF @Cuenta = 'CONCEPTO ORIGEN'
SELECT @Cta = Cuenta FROM Concepto WHERE Modulo = @OrigenModulo AND Concepto = @OrigenConcepto
ELSE
IF @Cuenta = 'TABLA %'
BEGIN
IF @Campo = 'TOTAL IMPUESTO 1'  SELECT @Cta = ISNULL(Cuenta, @Cta) FROM MovTipoContAutoTabla WHERE Empresa = @ContAutoEmpresa AND Modulo = @Modulo AND Clave = @Clave AND Nombre = @Nombre AND Porcentaje = @Impuesto1  AND Excento = ISNULL(@Excento1, 0) ELSE
IF @Campo = 'TOTAL IMPUESTO 2'  SELECT @Cta = ISNULL(Cuenta, @Cta) FROM MovTipoContAutoTabla WHERE Empresa = @ContAutoEmpresa AND Modulo = @Modulo AND Clave = @Clave AND Nombre = @Nombre AND Porcentaje = @Impuesto2  AND Excento = 0 ELSE
IF @Campo = 'TOTAL IMPUESTO 3'  SELECT @Cta = ISNULL(Cuenta, @Cta) FROM MovTipoContAutoTabla WHERE Empresa = @ContAutoEmpresa AND Modulo = @Modulo AND Clave = @Clave AND Nombre = @Nombre AND Porcentaje = @Impuesto3  AND Excento = 0 ELSE
IF @Campo = 'TOTAL IMPUESTO 5'  SELECT @Cta = ISNULL(Cuenta, @Cta) FROM MovTipoContAutoTabla WHERE Empresa = @ContAutoEmpresa AND Modulo = @Modulo AND Clave = @Clave AND Nombre = @Nombre AND Porcentaje = @Impuesto5  AND Excento = 0 ELSE
IF @Campo = 'TOTAL RETENCION 1' SELECT @Cta = ISNULL(Cuenta, @Cta) FROM MovTipoContAutoTabla WHERE Empresa = @ContAutoEmpresa AND Modulo = @Modulo AND Clave = @Clave AND Nombre = @Nombre AND Porcentaje = @Retencion1 AND Excento = 0 ELSE
IF @Campo = 'TOTAL RETENCION 2' SELECT @Cta = ISNULL(Cuenta, @Cta) FROM MovTipoContAutoTabla WHERE Empresa = @ContAutoEmpresa AND Modulo = @Modulo AND Clave = @Clave AND Nombre = @Nombre AND Porcentaje = @Retencion2 AND Excento = 0 ELSE
IF @Campo = 'TOTAL RETENCION 3' SELECT @Cta = ISNULL(Cuenta, @Cta) FROM MovTipoContAutoTabla WHERE Empresa = @ContAutoEmpresa AND Modulo = @Modulo AND Clave = @Clave AND Nombre = @Nombre AND Porcentaje = @Retencion3 AND Excento = 0 ELSE
IF @Campo = 'Retencion IVA'	  SELECT @Cta = ISNULL(Cuenta, @Cta) FROM MovTipoContAutoTabla WHERE Empresa = @ContAutoEmpresa AND Modulo = @Modulo AND Clave = @Clave AND Nombre = @Nombre AND Porcentaje = @Retencion2 AND Excento = 0
END ELSE
IF @Cuenta = 'LOTE FIJO'
BEGIN
IF @Campo = 'TOTAL IMPUESTO 1'  SELECT @Cta = ISNULL(Cuenta1, @Cta) FROM LoteFijo WHERE Lote = @LoteFijo ELSE
IF @Campo = 'TOTAL IMPUESTO 2'  SELECT @Cta = ISNULL(Cuenta2, @Cta) FROM LoteFijo WHERE Lote = @LoteFijo ELSE
IF @Campo = 'TOTAL IMPUESTO 3'  SELECT @Cta = ISNULL(Cuenta3, @Cta) FROM LoteFijo WHERE Lote = @LoteFijo ELSE
IF @Campo = 'TOTAL IMPUESTO 5'  SELECT @Cta = ISNULL(Cuenta5, @Cta) FROM LoteFijo WHERE Lote = @LoteFijo
END ELSE
IF @Cuenta = 'LOTE FIJO ESPECIFICO'
BEGIN
IF @Campo = 'TOTAL IMPUESTO 1' SELECT @Cta = ISNULL(Cuenta1, @Cta) FROM MovTipoContAutoLoteFijo WHERE Empresa = @ContAutoEmpresa AND Modulo = @Modulo AND Clave = @Clave AND Nombre = @Nombre AND Lote = @LoteFijo ELSE
IF @Campo = 'TOTAL IMPUESTO 2' SELECT @Cta = ISNULL(Cuenta2, @Cta) FROM MovTipoContAutoLoteFijo WHERE Empresa = @ContAutoEmpresa AND Modulo = @Modulo AND Clave = @Clave AND Nombre = @Nombre AND Lote = @LoteFijo ELSE
IF @Campo = 'TOTAL IMPUESTO 3' SELECT @Cta = ISNULL(Cuenta3, @Cta) FROM MovTipoContAutoLoteFijo WHERE Empresa = @ContAutoEmpresa AND Modulo = @Modulo AND Clave = @Clave AND Nombre = @Nombre AND Lote = @LoteFijo ELSE
IF @Campo = 'TOTAL IMPUESTO 5' SELECT @Cta = ISNULL(Cuenta5, @Cta) FROM MovTipoContAutoLoteFijo WHERE Empresa = @ContAutoEmpresa AND Modulo = @Modulo AND Clave = @Clave AND Nombre = @Nombre AND Lote = @LoteFijo
END
IF @Cta IS NOT NULL AND (NULLIF(@Monto, 0) IS NOT NULL OR @CfgPartidasSinImporte = 1)
BEGIN
SELECT @Debe = NULL, @Haber = NULL
IF @OmitirConcepto     = 1 SELECT @Concepto = NULL
IF @OmitirCentroCostos = 1
BEGIN
SELECT @ContUso  = NULL, @ContUso2 = NULL, @ContUso3 = NULL
END ELSE
BEGIN
SELECT @ContUso = CASE @CentroCostos WHEN 'Sucursal' THEN @CentroCostosSucursal WHEN 'Sucursal Destino' THEN @CentroCostosDestino WHEN 'Matriz' THEN @CentroCostosMatriz ELSE @ContUso END
END
IF @EsDebe = 1
SELECT @Debe = @Monto*@TipoCambio
ELSE
SELECT @Haber = @Monto*@TipoCambio
IF UPPER(@ContAutoContactoEsp) = 'CONTACTO ARRASTRE'
EXEC spMovInfo @OrigenModuloID, @OrigenModulo, @Contacto = @ContactoArrastre OUTPUT
SELECT @ContactoEspecifico = dbo.fnContactoEspecifico(@ContAutoContactoEsp, @Contacto, @ContactoAplica, @ContactoArrastre, NULL, NULL, @CtaDinero, @CtaDineroDestino, NULL, NULL, NULL)
INSERT #Poliza (Orden,  Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico,  Debe,  Haber,  Campo,  ContactoTipo) 
VALUES (@Orden, @Cta,   @ContUso,  @ContUso2,  @ContUso3, @Concepto, @ContactoEspecifico, @Debe, @Haber, @Campo, dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo)) 
END
END
END
FETCH NEXT FROM crMovImpuesto INTO @OrigenModulo, @OrigenModuloID, @OrigenConcepto, @OrigenFecha, @Retencion1, @Retencion2, @Retencion3, @LoteFijo, @ContUso, @ContUso2, @ContUso3, @Impuesto1, @Impuesto2, @Impuesto3, @Impuesto5, @Importe1, @Importe2, @Importe3, @Importe5, @ImporteRetencion1, @ImporteRetencion2, @ImporteRetencion3, @Excento1, @DescuentoGlobal,
@TipoImpuesto1, @TipoImpuesto2, @TipoImpuesto3, @TipoImpuesto5, @TipoRetencion1, @TipoRetencion2, @TipoRetencion3,
@SubTotal, @Total, @DescuentoImporte, @TotalBruto, @RetencionIVA
IF @@ERROR <> 0 SELECT @Ok = 1
END  
CLOSE crMovImpuesto
DEALLOCATE crMovImpuesto
RETURN
END

