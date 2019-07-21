SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContAutoDinero
@Modulo					char(5),
@ID						int,
@Cuenta					varchar(20),
@CuentaOmision			char(20),
@OmitirConcepto			bit,
@OmitirCentroCostos		bit,
@CentroCostos			varchar(20),
@CentroCostosSucursal	varchar(20),
@CentroCostosDestino		varchar(20),
@CentroCostosMatriz		varchar(20),
@Concepto				varchar(50),
@Orden					int,
@Campo					varchar(20),
@EsDebe					bit,
@Ok						int		OUTPUT,
@OkRef					varchar(255)	OUTPUT,
@CfgPartidasSinImporte	bit,
@Cta						char(20),
@SucursalContable		varchar(20),
@ContAutoContactoEsp		varchar(50),
@Contacto				varchar(10),
@ContactoAplica			varchar(10),
@ContactoTipo			varchar(20) 

AS BEGIN
DECLARE
@Empresa		char(5),
@Renglon		float,
@RenglonSub		int,
@Importe		float, 
@Impuestos		float, 
@IVAFiscal		float, 
@IEPSFiscal		float, 
@ImporteTotal	float, 
@ImporteDetalle	float, 
@TipoCambio		float,
@FormaPago		varchar(50),
@ContUso		char(20),
@ContUso2		char(20), 
@ContUso3		char(20), 
@Monto			float, 
@Debe			float, 
@Haber			float, 
@Dias			int,
@TasaDiaria		float, 
@AplicaSucursal	int,
@PolizaSucursal	int,
@ContactoDetalle	varchar(10),
@CtaDinero		varchar(10),
@CtaDineroDestino	varchar(10),
@Agente		varchar(10)
IF @Campo IS NULL RETURN
SELECT @Empresa = Empresa,
@TipoCambio = TipoCambio,
@Importe = Importe,
@Impuestos = Impuestos,
@IVAFiscal = (ISNULL(Importe, 0)+ISNULL(Impuestos, 0))*IVAFiscal,
@IEPSFiscal = (ISNULL(Importe, 0)+ISNULL(Impuestos, 0))*IEPSFiscal,
@Dias = DATEDIFF(day, FechaOrigen, Vencimiento),
@TasaDiaria = Tasa / NULLIF(TasaDias, 0),
@ContUso = ContUso,
@ContUso2 = ContUso2, 
@ContUso3 = ContUso3, 
@CtaDinero = CtaDinero,
@CtaDineroDestino = CtaDineroDestino,
@Agente = Cajero
FROM Dinero
WHERE ID = @ID
SELECT @ImporteTotal = @Importe + @Impuestos
DECLARE crMovD CURSOR FOR
SELECT d.Renglon, d.RenglonSub, d.FormaPago, d.Importe, ISNULL(d.ContUso,@ContUso), ISNULL(d.ContUso2,@ContUso2), ISNULL(d.ContUso3,@ContUso3), a.Sucursal, a.Contacto 
FROM DineroD d
LEFT OUTER JOIN Dinero a ON a.Empresa = @Empresa AND a.Mov = d.Aplica AND a.MovID = d.AplicaID AND a.Estatus IN ('PENDIENTE', 'CONCLUIDO')
WHERE d.ID = @ID
OPEN crMovD
FETCH NEXT FROM crMovD INTO @Renglon, @RenglonSub, @FormaPago, @ImporteDetalle, @ContUso, @ContUso2, @ContUso3, @AplicaSucursal, @ContactoDetalle
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF UPPER(@SucursalContable) = 'DETALLE' SELECT @PolizaSucursal = @AplicaSucursal ELSE SELECT @PolizaSucursal = NULL
IF @Cta IS NULL
SELECT @Cta = Cuenta FROM FormaPago WHERE FormaPago = @FormaPago
IF @Cta IS NULL
EXEC xpContAutoCuentaExtra @Modulo, @ID, @Cuenta, @CuentaOmision, NULL, NULL, NULL, NULL, NULL, NULL, @Concepto, NULL, NULL, NULL, NULL, @FormaPago, @Cta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Cta IS NOT NULL
BEGIN
IF @Campo = 'IMPORTE' 		SELECT @Monto = @ImporteDetalle*@Importe/@ImporteTotal		ELSE
IF @Campo = 'IMPUESTOS'     	SELECT @Monto = @ImporteDetalle*@Impuestos/@ImporteTotal	ELSE
IF @Campo = 'IVA FISCAL'     	SELECT @Monto = @ImporteDetalle*@IVAFiscal/@ImporteTotal	ELSE
IF @Campo = 'IEPS FISCAL'     	SELECT @Monto = @ImporteDetalle*@IEPSFiscal/@ImporteTotal	ELSE
IF @Campo = 'IMPORTE TOTAL' 	SELECT @Monto = @ImporteDetalle					ELSE
IF @Campo = 'INTERESES' 	SELECT @Monto = @ImporteDetalle*@Dias*(@TasaDiaria/100.0)
ELSE EXEC xpContAutoCampoExtra @Modulo, @ID, @Renglon, @RenglonSub, @Campo, @Monto OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF (NULLIF(@Monto, 0) IS NOT NULL OR @CfgPartidasSinImporte = 1)
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
Renglon,  RenglonSub,  Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto,  Debe,  Haber,  SucursalContable, ContactoEspecifico,                                                                                                                                           ContactoTipo) 
SELECT @Renglon, @RenglonSub, @Orden, @Cta,   @ContUso,  @ContUso2,  @ContUso3,  @Concepto, @Debe, @Haber, @PolizaSucursal,  dbo.fnContactoEspecifico(@ContAutoContactoEsp, @Contacto, @ContactoAplica, @ContactoDetalle, @Agente, NULL, @CtaDinero, @CtaDineroDestino, NULL, NULL, NULL), dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo) 
IF @Cuenta = 'FORMA PAGO' SELECT @Cta = NULL
END
END
END
FETCH NEXT FROM crMovD INTO @Renglon, @RenglonSub, @FormaPago, @ImporteDetalle, @ContUso, @ContUso2, @ContUso3, @AplicaSucursal, @ContactoDetalle 
IF @@ERROR <> 0 SELECT @Ok = 1
END  
CLOSE crMovD
DEALLOCATE crMovD
RETURN
END

