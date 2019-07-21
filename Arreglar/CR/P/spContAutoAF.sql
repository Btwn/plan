SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContAutoAF
@Modulo		  char(5),
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
@Contacto		  char(10),
@ContactoTipo	  varchar(20),
@CtaDinero		  char(10),
@CtaDineroDestino	  char(10),
@FormaPago		  varchar(50),
@Orden		  int,
@Campo		  varchar(20),
@EsDebe		  bit,
@Ok			  int		OUTPUT,
@OkRef		  varchar(255)	OUTPUT,
@CfgPartidasSinImporte bit

AS BEGIN
DECLARE
@Renglon			float,
@RenglonSub			int,
@Almacen			char(10),
@Articulo			char(20),
@Importe			money,
@Impuestos			money,
@Depreciacion		money,
@ActualizacionCapital	money,
@ActualizacionGastos	money,
@ActualizacionDepreciacion	money,
@TipoCambio			float,
@Cta			char(20),
@Monto			money,
@Debe			money,
@Haber			money,
@ContUso		char(20),
@ContUso2		char(20),
@ContUso3		char(20)
IF @Campo IS NULL RETURN
DECLARE crMovD CURSOR FOR
SELECT d.Renglon, d.RenglonSub, d.Articulo, d.Importe, d.Impuestos, d.Depreciacion, d.ActualizacionCapital, d.ActualizacionGastos, d.ActualizacionDepreciacion, e.TipoCambio, af.CentroCostos, af.Almacen,
af.ContUso2, af.ContUso3
FROM ActivoFijoD d, ActivoFijo e, ActivoF af
WHERE e.ID = d.ID AND e.ID = @ID
AND af.Empresa = e.Empresa AND af.Articulo = d.Articulo AND af.Serie = d.Serie
OPEN crMovD
FETCH NEXT FROM crMovD INTO @Renglon, @RenglonSub, @Articulo, @Importe, @Impuestos, @Depreciacion, @ActualizacionCapital, @ActualizacionGastos, @ActualizacionDepreciacion, @TipoCambio, @ContUso, @Almacen, @ContUso2, @ContUso3
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @Monto = NULL, @Cta = NULL
EXEC spContAutoGetCuenta @Modulo, @Cuenta, @CuentaOmision, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, @Articulo, @Almacen, 'ACTIVOS FIJOS', @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Cta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Cta IS NULL
EXEC xpContAutoCuentaExtra @Modulo, @ID, @Cuenta, @CuentaOmision, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, @Articulo, @Almacen, 'ACTIVOS FIJOS', @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Cta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Cta IS NOT NULL
BEGIN
IF @Campo = 'IMPORTE'   	SELECT @Monto = @Importe 		ELSE
IF @Campo = 'IMPUESTOS'   	SELECT @Monto = @Impuestos		ELSE
IF @Campo = 'DEPRECIACION'   	SELECT @Monto = @Depreciacion		ELSE
IF @Campo = 'ACT. CAPITAL'   	SELECT @Monto = @ActualizacionCapital	ELSE
IF @Campo = 'ACT. GASTOS'   	SELECT @Monto = @ActualizacionGastos	ELSE
IF @Campo = 'ACT. DEPRECIACION' SELECT @Monto = @ActualizacionDepreciacion
ELSE EXEC xpContAutoCampoExtra @Modulo, @ID, @Renglon, @RenglonSub, @Campo, @Monto OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF (NULLIF(@Monto, 0) IS NOT NULL OR @CfgPartidasSinImporte = 1)
BEGIN
SELECT @Debe = NULL, @Haber = NULL
IF @OmitirConcepto     = 1 SELECT @Concepto = NULL
IF @OmitirCentroCostos = 1
SELECT @ContUso  = NULL, @ContUso2 = NULL, @ContUso3 = NULL
ELSE SELECT @ContUso = CASE @CentroCostos WHEN 'Sucursal' THEN @CentroCostosSucursal WHEN 'Sucursal Destino' THEN @CentroCostosDestino WHEN 'Matriz' THEN @CentroCostosMatriz ELSE @ContUso END
IF @EsDebe = 1
SELECT @Debe = @Monto*@TipoCambio
ELSE
SELECT @Haber = @Monto*@TipoCambio
INSERT #Poliza (Renglon,  RenglonSub,  Orden,  Cuenta, SubCuenta, Concepto,  Debe,  Haber, SubCuenta2, SubCuenta3)
VALUES (@Renglon, @RenglonSub, @Orden, @Cta,   @ContUso,  @Concepto, @Debe, @Haber, @ContUso2, @ContUso3)
END
END
END
FETCH NEXT FROM crMovD INTO @Renglon, @RenglonSub, @Articulo, @Importe, @Impuestos, @Depreciacion, @ActualizacionCapital, @ActualizacionGastos, @ActualizacionDepreciacion, @TipoCambio, @ContUso, @Almacen, @ContUso2, @ContUso3
IF @@ERROR <> 0 SELECT @Ok = 1
END  
CLOSE crMovD
DEALLOCATE crMovD
RETURN
END

