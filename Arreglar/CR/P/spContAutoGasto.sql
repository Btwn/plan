SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContAutoGasto
@Modulo			char(5),
@Clave			varchar(20),
@Nombre			varchar(50),
@ID				int,
@Cuenta			varchar(20),
@CuentaOmision		char(20),
@OmitirConcepto		bit,
@OmitirCentroCostos		bit,
@CentroCostos		varchar(20),
@CentroCostosSucursal  	varchar(20),
@CentroCostosDestino	  	varchar(20),
@CentroCostosMatriz	  	varchar(20),
@CtaCtoTipo			varchar(20),
@CtaCtoTipoAplica		varchar(20),
@CtaClase			char(20),
@Concepto			varchar(50),
@Contacto			char(10),
@ContactoTipo		varchar(20),
@CtaDinero			char(10),
@CtaDineroDestino		char(10),
@FormaPago			varchar(50),
@Orden			int,
@Campo			varchar(20),
@EsDebe			bit,
@CfgClaseConceptoGastos 	bit,
@Ok				int		OUTPUT,
@OkRef			varchar(255)	OUTPUT,
@CfgPartidasSinImporte	bit,
@IncluirDepartamento		bit,
@ContAutoContactoEsp		varchar(50),
@ContAutoEmpresa		varchar(10) = '(Todas)'

AS BEGIN
DECLARE
@Renglon			float,
@RenglonSub			int,
@Almacen			char(10),
@AlmacenTipo		varchar(20),
@ContUso			char(20),
@ContUso2			char(20),
@ContUso3			char(20),
@Articulo			char(20),
@TipoCambio			float,
@Importe			money,
@Provision			money,
@Impuestos			money,
@Retencion1			money,
@Retencion2			money,
@Retencion3			money,
@Retenciones		money,
@ImporteTotal		money,
@Clase			varchar(50),
@SubClase			varchar(50),
@Cta			char(20),
@Monto			money,
@Debe			money,
@Haber			money,
@PorcentajeDeducible 	float,
@DepartamentoDetallista	int,
@Impuesto1Excento		bit,
@Excento			bit,
@Personal			varchar(10),
@EndosarA			varchar(10),
@ContactoDetalle		varchar(10),
@TipoImpuesto1		varchar(10),
@TipoImpuesto2		varchar(10),
@TipoImpuesto3		varchar(10),
@TipoImpuesto5		varchar(10),
@TipoRetencion1		varchar(10),
@TipoRetencion2		varchar(10),
@TipoRetencion3		varchar(10)
IF @Campo IS NULL RETURN
DECLARE crMovD CURSOR FOR
SELECT d.Renglon, d.RenglonSub, d.ContUso, d.ContUso2, d.ContUso3, d.Concepto, d.TipoCambio, d.ImporteLinea, d.ImpuestosLinea, d.Retencion1, d.Retencion2, d.Retencion3, d.RetencionLinea, d.TotalLinea, ISNULL(d.PorcentajeDeducible, 0.0), d.Provision, d.Impuesto1Excento, d.Personal, d.EndosarA,
d.TipoImpuesto1, d.TipoImpuesto2, d.TipoImpuesto3, d.TipoImpuesto5, d.TipoRetencion1, d.TipoRetencion2, d.TipoRetencion3
FROM GastoT d
WHERE d.ID = @ID
OPEN crMovD
FETCH NEXT FROM crMovD INTO @Renglon, @RenglonSub, @ContUso, @ContUso2, @ContUso3, @Concepto, @TipoCambio, @Importe, @Impuestos, @Retencion1, @Retencion2, @Retencion3, @Retenciones, @ImporteTotal, @PorcentajeDeducible, @Provision, @Impuesto1Excento, @Personal, @EndosarA,
@TipoImpuesto1, @TipoImpuesto2, @TipoImpuesto3, @TipoImpuesto5, @TipoRetencion1, @TipoRetencion2, @TipoRetencion3
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @Excento = 0
SELECT @Monto = NULL, @Cta = NULL, @DepartamentoDetallista = NULL
IF @CfgClaseConceptoGastos = 1 AND UPPER(@Cuenta) = 'CLASIFICACION'
BEGIN
SELECT @Clase = Clase, @SubClase = SubClase FROM Concepto WHERE Modulo = @Modulo AND Concepto = @Concepto
EXEC spCuentaClase @Modulo, @Clase, @SubClase, @CtaClase OUTPUT
END
IF UPPER(@Cuenta) = 'CONCEPTO CONTX'
BEGIN
SELECT @Cta = c.CuentaContable FROM Gastod g JOIN ContXCta c ON c.Cuenta=g.Concepto
JOIN CtaSub cc ON c.CuentaContable=cc.Cuenta AND cc.Subcuenta=g.ContUso
WHERE cc.Subcuenta=@ContUso AND g.Concepto=@Concepto AND g.ID=@ID
END
IF @Cta IS NULL
EXEC spContAutoGetCuenta @Modulo, @Cuenta, @CuentaOmision, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, NULL, NULL, NULL, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Cta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT,
@TipoImpuesto1, @TipoImpuesto2, @TipoImpuesto3, @TipoImpuesto5, @TipoRetencion1, @TipoRetencion2, @TipoRetencion3
IF @Cta IS NULL
EXEC xpContAutoCuentaExtra @Modulo, @ID, @Cuenta, @CuentaOmision, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, NULL, NULL, NULL, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Cta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Cta IS NOT NULL OR @Cuenta = 'TABLA %'
BEGIN
IF @Campo = 'IMPORTE' 		SELECT @Monto = @Importe
ELSE IF @Campo = 'RETENCION 1'  	SELECT @Monto = @Retencion1
ELSE IF @Campo = 'RETENCION 2'  	SELECT @Monto = @Retencion2
ELSE IF @Campo = 'RETENCION 3'  	SELECT @Monto = @Retencion3
ELSE IF @Campo = 'RETENCIONES'  	SELECT @Monto = @Retenciones
ELSE IF @Campo = 'IMPUESTOS'     	SELECT @Monto = @Impuestos, @Excento = @Impuesto1Excento
ELSE IF @Campo = 'IMPORTE TOTAL' 	SELECT @Monto = @ImporteTotal
ELSE IF @Campo = 'IMPORTE DEDUCIBLE'    SELECT @Monto = @Importe*(@PorcentajeDeducible/100.0)
ELSE IF @Campo = 'IMPUESTO DEDUCIBLE'   SELECT @Monto = @Impuestos*(@PorcentajeDeducible/100.0)
ELSE IF @Campo = 'TOTAL DEDUCIBLE'      SELECT @Monto = @ImporteTotal*(@PorcentajeDeducible/100.0)
ELSE IF @Campo = 'IMPORTE N/DEDUCIBLE'  SELECT @Monto = @Importe*(1-(@PorcentajeDeducible/100.0))
ELSE IF @Campo = 'IMPUESTO N/DEDUCIBLE' SELECT @Monto = @Impuestos*(1-(@PorcentajeDeducible/100.0))
ELSE IF @Campo = 'TOTAL N/DEDUCIBLE'    SELECT @Monto = @ImporteTotal*(1-(@PorcentajeDeducible/100.0))
ELSE IF @Campo = 'IMPORTE S/PROVISION'  SELECT @Monto = @Importe-@Provision
ELSE IF @Campo = 'PROVISION'            SELECT @Monto = @Provision
ELSE IF @Campo = 'IMPORTE NETO GT'		SELECT @Monto = @Importe - ISNULL(@Retencion1,0.0)
ELSE EXEC xpContAutoCampoExtra @Modulo, @ID, @Renglon, @RenglonSub, @Campo, @Monto OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Cuenta = 'TABLA %'
EXEC spContAutoGetCuentaTabla @Modulo, @Clave, @Nombre, @Monto, @Importe, @Cta OUTPUT, @Excento = @Excento, @ContAutoEmpresa = @ContAutoEmpresa
IF @Cta IS NOT NULL AND (NULLIF(@Monto, 0) IS NOT NULL OR @CfgPartidasSinImporte = 1)
BEGIN
SELECT @Debe = NULL, @Haber = NULL
IF @OmitirConcepto     = 1 SELECT @Concepto = NULL
IF @OmitirCentroCostos = 1
BEGIN
SELECT @ContUso  = NULL, @ContUso2 = NULL, @ContUso3 = NULL
END ELSE
SELECT @ContUso = CASE @CentroCostos WHEN 'Sucursal' THEN @CentroCostosSucursal WHEN 'Sucursal Destino' THEN @CentroCostosDestino WHEN 'Matriz' THEN @CentroCostosMatriz ELSE @ContUso END
IF @EsDebe = 1
SELECT @Debe = @Monto*@TipoCambio
ELSE
SELECT @Haber = @Monto*@TipoCambio
IF @IncluirDepartamento = 1 SELECT @DepartamentoDetallista = DepartamentoDetallista FROM Concepto WHERE Modulo = @Modulo AND Concepto = @Concepto
INSERT #Poliza (
Renglon,  RenglonSub,  Orden,  Cuenta, SubCuenta, SubCuenta2, SubCuenta3,  Concepto,  DepartamentoDetallista,  Debe,  Haber, ContactoEspecifico,                                                                                                                            ContactoTipo) 
SELECT @Renglon, @RenglonSub, @Orden, @Cta,   @ContUso,   @ContUso2, @ContUso3,   @Concepto, @DepartamentoDetallista, @Debe, @Haber, dbo.fnContactoEspecifico(@ContAutoContactoEsp, @Contacto, NULL, @EndosarA, NULL, @Personal, @CtaDinero, @CtaDineroDestino, NULL, NULL, NULL), dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo) 
END
END
END
FETCH NEXT FROM crMovD INTO @Renglon, @RenglonSub, @ContUso, @ContUso2, @ContUso3, @Concepto, @TipoCambio, @Importe, @Impuestos, @Retencion1, @Retencion2, @Retencion3, @Retenciones, @ImporteTotal, @PorcentajeDeducible, @Provision, @Impuesto1Excento, @Personal, @EndosarA,
@TipoImpuesto1, @TipoImpuesto2, @TipoImpuesto3, @TipoImpuesto5, @TipoRetencion1, @TipoRetencion2, @TipoRetencion3
IF @@ERROR <> 0 SELECT @Ok = 1
END  
CLOSE crMovD
DEALLOCATE crMovD
RETURN
END

