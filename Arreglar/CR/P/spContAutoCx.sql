SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContAutoCx
@Modulo		  varchar(5),
@Clave		  varchar(20),
@Nombre		  varchar(50),
@ID			  int,
@Cuenta		  varchar(20),
@CuentaOmision	  varchar(20),
@OmitirConcepto	  bit,
@OmitirCentroCostos	  bit,
@CentroCostos	  varchar(20),
@CentroCostosSucursal  varchar(20),
@CentroCostosDestino	  varchar(20),
@CentroCostosMatriz	  varchar(20),
@CtaCtoTipo		  varchar(20),
@CtaCtoTipoAplica	  varchar(20),
@CtaClase		  varchar(20),
@Concepto		  varchar(50),
@Contacto		  varchar(10),
@ContactoTipo	  varchar(20),
@CtaDinero		  varchar(10),
@CtaDineroDestino	  varchar(10),
@FormaPago		  varchar(50),
@Orden		  int,
@Campo		  varchar(20),
@EsDebe		  bit,
@Ok			  int		OUTPUT,
@OkRef		  varchar(255)	OUTPUT,
@CfgPartidasSinImporte bit,
@ContAutoContactoEsp	  varchar(50),
@ContactoAplica	  varchar(10),
@ContAutoEmpresa	  varchar(10) = '(Todas)'

AS BEGIN
DECLARE
@Renglon		float,
@RenglonSub		int,
@Importe		money,
@ImporteTotal	money,
@IVAFiscal		float,
@IEPSFiscal		float,
@pRetencion		float,
@pRetencion2	float,
@pRetencion3	float,
@Retencion		money,
@Retencion2		money,
@Retencion3		money,
@TipoCambio		float,
@Cta		char(20),
@ContUso		varchar(20),
@ContUso2		varchar(20), 
@ContUso3		varchar(20), 
@Monto		money,
@Debe		money,
@Haber		money,
@ContactoDetalle	varchar(10),
@Agente		varchar(10),
@Personal		varchar(10),
@CfgRetencion2BaseImpuesto1	bit
SELECT @CfgRetencion2BaseImpuesto1 = ISNULL(Retencion2BaseImpuesto1, 0) FROM Version
SELECT @ContUso  = NULL, @ContUso2 = NULL, @ContUso3 = NULL  
IF @Modulo = 'CXC' SELECT @ContUso = ContUso, @ContUso2 = ContUso2, @ContUso3 = ContUso3 FROM Cxc WHERE ID = @ID ELSE 
IF @Modulo = 'CXP' SELECT @ContUso = ContUso, @ContUso2 = ContUso2, @ContUso3 = ContUso3 FROM Cxp WHERE ID = @ID 
IF @Campo IS NULL RETURN
IF @Modulo = 'CXC'
DECLARE crMovD CURSOR FOR
SELECT c.Agente, c.PersonalCobrador, d.Renglon, d.RenglonSub, d.Importe, ISNULL(a.IVAFiscal, 0), ISNULL(a.IEPSFiscal, 0), c.TipoCambio,
ISNULL(ISNULL(a.Retencion, 0)/NULLIF(a.Importe, 0)*100, 0),
ISNULL(ISNULL(a.Retencion2, 0)/NULLIF(a.Importe, 0)*100, 0),
ISNULL(ISNULL(a.Retencion3, 0)/NULLIF(a.Importe, 0)*100, 0),
a.Cliente
FROM Cxc c, CxcD d, Cxc a
WHERE c.ID = @ID AND d.ID = c.ID AND a.Empresa = c.Empresa AND a.Mov = d.Aplica AND a.MovID = d.AplicaID AND a.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
IF @Modulo = 'CXP'
DECLARE crMovD CURSOR FOR
SELECT NULL, NULL, d.Renglon, d.RenglonSub, d.Importe, ISNULL(a.IVAFiscal, 0), ISNULL(a.IEPSFiscal, 0), c.TipoCambio,
ISNULL(ISNULL(a.Retencion, 0)/NULLIF(a.Importe, 0)*100, 0),
ISNULL(ISNULL(a.Retencion2, 0)/NULLIF(CASE WHEN @CfgRetencion2BaseImpuesto1 = 1 THEN d.Importe*ISNULL(a.IVAFiscal, 0) ELSE a.Importe END, 0)*100, 0),
ISNULL(ISNULL(a.Retencion3, 0)/NULLIF(a.Importe, 0)*100, 0),
a.Proveedor
FROM Cxp c, CxpD d, Cxp a
WHERE c.ID = @ID AND d.ID = c.ID AND a.Empresa = c.Empresa AND a.Mov = d.Aplica AND a.MovID = d.AplicaID AND a.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
OPEN crMovD
FETCH NEXT FROM crMovD INTO @Agente, @Personal, @Renglon, @RenglonSub, @ImporteTotal, @IVAFiscal, @IEPSFiscal, @TipoCambio, @pRetencion, @pRetencion2, @pRetencion3, @ContactoDetalle
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @Importe = @ImporteTotal - (@ImporteTotal*@IVAFiscal) - (@ImporteTotal*@IEPSFiscal)
SELECT @Importe = (100*@Importe)/(100-@pRetencion-CASE WHEN @CfgRetencion2BaseImpuesto1 = 1 THEN 0.0 ELSE @pRetencion2 END-@pRetencion3)	
SELECT @Retencion  = @Importe * (@pRetencion/100.0),
@Retencion2 = CASE WHEN @CfgRetencion2BaseImpuesto1 = 1 THEN (@ImporteTotal*@IVAFiscal) * (@pRetencion2/100.0) ELSE @Importe * (@pRetencion2/100.0) END,
@Retencion3 = @Importe * (@pRetencion3/100.0)
SELECT @Monto = NULL, @Cta = NULL
EXEC spContAutoGetCuenta @Modulo, @Cuenta, @CuentaOmision, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, NULL, NULL, NULL, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Cta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Cta IS NULL
EXEC xpContAutoCuentaExtra @Modulo, @ID, @Cuenta, @CuentaOmision, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, NULL, NULL, NULL, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Cta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Cta IS NOT NULL OR @Cuenta = 'TABLA %'
BEGIN
IF @Campo = 'IMPORTE TOTAL' 	SELECT @Monto = @ImporteTotal  				ELSE
IF @Campo = 'IVA FISCAL'	SELECT @Monto = @ImporteTotal*@IVAFiscal        	ELSE
IF @Campo = 'IEPS FISCAL'	SELECT @Monto = @ImporteTotal*@IEPSFiscal       	ELSE
IF @Campo = 'IMPORTE S/FISCAL' 	SELECT @Monto = @ImporteTotal-ISNULL(@ImporteTotal*@IVAFiscal, 0.0)-ISNULL(@ImporteTotal*@IEPSFiscal, 0.0) ELSE
IF @Campo = 'IMPUESTOS'		SELECT @Monto = (@ImporteTotal*@IVAFiscal)+(@ImporteTotal*@IEPSFiscal) ELSE
IF @Campo = 'RETENCIONES'       SELECT @Monto = @Retencion+@Retencion2+@Retencion3 	ELSE
IF @Campo = 'RETENCION ISR'     SELECT @Monto = @Retencion				ELSE
IF @Campo = 'RETENCION IVA'     SELECT @Monto = @Retencion2				ELSE
IF @Campo = 'RETENCION 3'     	SELECT @Monto = @Retencion3
ELSE EXEC xpContAutoCampoExtra @Modulo, @ID, @Renglon, @RenglonSub, @Campo, @Monto OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Cuenta = 'TABLA %'
EXEC spContAutoGetCuentaTabla @Modulo, @Clave, @Nombre, @Monto, @Importe, @Cta OUTPUT, @ContAutoEmpresa = @ContAutoEmpresa
IF @Cta IS NOT NULL AND (NULLIF(@Monto, 0) IS NOT NULL OR @CfgPartidasSinImporte = 1)
BEGIN 
SELECT @Debe = NULL, @Haber = NULL 
IF @OmitirConcepto     = 1 SELECT @Concepto = NULL 
IF @OmitirCentroCostos = 1 
BEGIN 
SELECT @ContUso   = NULL 
SELECT @ContUso2  = NULL 
SELECT @ContUso3  = NULL 
END 
ELSE 
BEGIN 
SELECT @ContUso = CASE @CentroCostos WHEN 'Sucursal' THEN @CentroCostosSucursal WHEN 'Sucursal Destino' THEN @CentroCostosDestino WHEN 'Matriz' THEN @CentroCostosMatriz ELSE @ContUso END 
END 
IF @EsDebe = 1
SELECT @Debe = @Monto*@TipoCambio
ELSE
SELECT @Haber = @Monto*@TipoCambio
INSERT #Poliza (
Renglon,  RenglonSub,  Orden,  Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto,  Debe,  Haber,  ContactoEspecifico,                                                                                                                                                ContactoTipo) 
SELECT @Renglon, @RenglonSub, @Orden, @Cta,   @ContUso,  @ContUso2,  @ContUso3,  @Concepto, @Debe, @Haber, dbo.fnContactoEspecifico(@ContAutoContactoEsp, @Contacto, @ContactoAplica, @ContactoDetalle, @Agente, @Personal, @CtaDinero, @CtaDineroDestino, NULL, NULL, NULL), dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo) 
END
END
END
FETCH NEXT FROM crMovD INTO @Agente, @Personal, @Renglon, @RenglonSub, @ImporteTotal, @IVAFiscal, @IEPSFiscal, @TipoCambio, @pRetencion, @pRetencion2, @pRetencion3, @ContactoDetalle
IF @@ERROR <> 0 SELECT @Ok = 1
END  
CLOSE crMovD
DEALLOCATE crMovD
RETURN
END

