SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContAutoFiscal
@Modulo		  char(5),
@Clave		  varchar(20),
@Nombre		  varchar(50),
@ID			  int,
@Cuenta		  varchar(20),
@CuentaOmision	  char(20),
@OmitirConcepto	  bit,
@OmitirCentroCostos	  bit,
@CentroCostos	  varchar(20),
@CentroCostosSucursal  varchar(20),
@CentroCostosDestino	  varchar(20),
@CentroCostosMatriz	  varchar(20),
@CtaCtoTipo		  varchar(20),
@CtaCtoTipoAplica	  varchar(20),
@CtaClase		  char(20),
@Concepto		  varchar(50),
@Orden		  int,
@Campo		  varchar(20),
@EsDebe		  bit,
@Ok			  int		OUTPUT,
@OkRef		  varchar(255)	OUTPUT,
@CfgPartidasSinImporte bit,
@ObligacionFiscal	  varchar(50),
@ContAutoEmpresa	  varchar(10) = '(Todas)'

AS BEGIN
DECLARE
@Renglon			float,
@Cta			char(20),
@Monto			money,
@Debe			money,
@Haber			money,
@ContUso			char(20),
@Importe			money,
@OtrosImpuestos		money,
@Base			money,
@BaseDeducible		money,
@BaseNoDeducible		money,
@Tasa			float,
@Deducible			float,
@Excento			bit,
@Neto			money,
@NetoNoDeducible		money,
@Contacto			varchar(10),
@ContactoTipo		varchar(20),
@TipoCambio			float,
@Articulo			varchar(20)
IF @Campo IS NULL RETURN
DECLARE crMovD CURSOR FOR
SELECT e.TipoCambio, d.Renglon, d.ObligacionFiscal, d.Importe, d.OtrosImpuestos, d.Base, d.Tasa, d.Deducible, ISNULL(d.Excento, 0), d.Neto, d.Contacto, d.ContactoTipo, d.AFArticulo
FROM FiscalD d
JOIN Fiscal e ON e.ID = d.ID
WHERE d.ID = @ID AND d.ObligacionFiscal = ISNULL(@ObligacionFiscal, d.ObligacionFiscal)
OPEN crMovD
FETCH NEXT FROM crMovD INTO @TipoCambio, @Renglon, @ObligacionFiscal, @Importe, @OtrosImpuestos, @Base, @Tasa, @Deducible, @Excento, @Neto, @Contacto, @ContactoTipo, @Articulo
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @Monto = NULL, @Cta = NULL
EXEC spContAutoGetCuenta @Modulo, @Cuenta, @CuentaOmision, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, @Articulo, NULL, @ContactoTipo, @Concepto, @Contacto, @ContactoTipo, NULL, NULL, NULL, @Cta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Cta IS NULL
EXEC xpContAutoCuentaExtra @Modulo, @ID, @Cuenta, @CuentaOmision, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, @Articulo, NULL, @ContactoTipo, @Concepto, @Contacto, @ContactoTipo, NULL, NULL, NULL, @Cta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Cuenta = 'TABLA %'
SELECT @Cta = ISNULL(Cuenta, @Cta) FROM MovTipoContAutoTabla WHERE Empresa = @ContAutoEmpresa AND Modulo = @Modulo AND Clave = @Clave AND Nombre = @Nombre AND ROUND(ISNULL(Porcentaje, 0.0), 10) = ROUND(ISNULL(@Tasa, 0.0), 10) AND Excento = @Excento
IF @Cta IS NOT NULL
BEGIN
IF @Campo IN ('Ingreso Acumulable', 'Deduccion Fiscal') SELECT @Monto = @Base	ELSE
IF @Campo = 'No Deducibles'		SELECT @Monto = @Base*((100.0-@Deducible)/100.0)	ELSE
IF @Campo = 'Impuesto Generado'         SELECT @Monto = @Neto					ELSE
IF @Campo = 'Impuesto Acreditable'	SELECT @Monto = @Neto					ELSE
IF @Campo = 'Retencion Pagar'	SELECT @Monto = @Neto				ELSE
IF @Campo = 'Retencion Acreditar'	SELECT @Monto = @Neto		ELSE
IF @Campo = 'Impuesto No Acredita'	SELECT @Monto = @Base*((100.0-@Deducible)/100.0)*(@Tasa/100.0)
/*
IF @Campo = 'BASE G DED/ACUM'		SELECT @Monto = @Base*(@Deducible/100.0)
IF @Campo = 'IMPUESTO TOTAL'		SELECT @Monto = @Neto+(@Base*((100.0-@Deducible)/100.0)*(@Tasa/100.0))*/
ELSE EXEC xpContAutoCampoExtra @Modulo, @ID, @Renglon, NULL, @Campo, @Monto OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF (NULLIF(@Monto, 0) IS NOT NULL OR @CfgPartidasSinImporte = 1)
BEGIN
SELECT @Debe = NULL, @Haber = NULL
IF @OmitirConcepto     = 1 SELECT @Concepto = NULL
IF @OmitirCentroCostos = 1 SELECT @ContUso  = NULL ELSE SELECT @ContUso = CASE @CentroCostos WHEN 'Sucursal' THEN @CentroCostosSucursal WHEN 'Sucursal Destino' THEN @CentroCostosDestino WHEN 'Matriz' THEN @CentroCostosMatriz ELSE @ContUso END
IF @EsDebe = 1
SELECT @Debe = @Monto*@TipoCambio
ELSE
SELECT @Haber = @Monto*@TipoCambio
INSERT #Poliza (Renglon,  Orden,  Cuenta, SubCuenta, Concepto,  Debe,  Haber)
VALUES (@Renglon, @Orden, @Cta,   @ContUso,  @Concepto, @Debe, @Haber)
END
END
END
FETCH NEXT FROM crMovD INTO @TipoCambio, @Renglon, @ObligacionFiscal, @Importe, @OtrosImpuestos, @Base, @Tasa, @Deducible, @Excento, @Neto, @Contacto, @ContactoTipo, @Articulo
IF @@ERROR <> 0 SELECT @Ok = 1
END  
CLOSE crMovD
DEALLOCATE crMovD
RETURN
END

