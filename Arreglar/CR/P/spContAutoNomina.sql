SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContAutoNomina
@Empresa		  char(5),
@Modulo		  char(5),
@ID			  int,
@Cuenta		  varchar(20),
@CuentaOmision	  char(20),
@OmitirConcepto	  bit,
@QueConcepto		  varchar(20),
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
@Condicion 		  varchar(50),
@Campo		  varchar(20),
@EsDebe		  bit,
@Ok			  int		OUTPUT,
@OkRef		  varchar(255)	OUTPUT,
@CfgPartidasSinImporte bit,
@ContAutoContactoEsp	  varchar(50)

AS BEGIN
DECLARE
@Renglon			float,
@RenglonModulo		char(5),
@Almacen			char(10),
@AlmacenTipo		varchar(20),
@ContUso			char(20),
@Articulo			char(20),
@TipoCambio			float,
@Importe			money,
@Cta			char(20),
@CtaConcepto		char(20),
@CtaConcepto2		char(20),
@Monto			money,
@Debe			money,
@Haber			money,
@Movimiento			varchar(20),
@ContPersonalSucursal	bit,
@SucursalContable		int,
@Personal			varchar(10)
SELECT @ContPersonalSucursal = ISNULL(ContPersonalSucursal, 0) FROM EmpresaGral WHERE Empresa = @Empresa
IF @Campo IS NULL RETURN
IF @Campo = 'IMPORTE'
DECLARE crMovD CURSOR FOR
SELECT d.Personal, d.Renglon, d.Modulo, p.SucursalTrabajo, p.CentroCostos, CASE WHEN @QueConcepto = 'Detalle' THEN d.Concepto ELSE e.Concepto END, e.TipoCambio, d.Importe, d.Movimiento, NULLIF(RTRIM(d.CuentaContable), ''), NULLIF(RTRIM(nc.Cuenta2), '')
FROM Nomina e
JOIN NominaD d ON d.ID = e.ID /*AND d.Modulo = 'NOM' */
JOIN Personal p ON p.Personal = d.Personal
LEFT OUTER JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto
WHERE e.ID = @ID
ELSE
IF @Campo IN ('IMPORTE TESORERIA', 'IMPORTE CXP')
DECLARE crMovD CURSOR FOR
SELECT d.Personal, d.Renglon, d.Modulo, p.SucursalTrabajo, p.CentroCostos, CASE WHEN @QueConcepto = 'Detalle' THEN d.Concepto ELSE e.Concepto END, e.TipoCambio, d.Importe, d.Movimiento, NULLIF(RTRIM(d.CuentaContable), ''), NULLIF(RTRIM(nc.Cuenta2), '')
FROM Nomina e
JOIN NominaD d ON d.ID = e.ID /*AND d.Modulo = 'NOM' */
LEFT OUTER JOIN Personal p ON p.Personal = d.Personal
LEFT OUTER JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto
WHERE e.ID = @ID
ELSE
IF @Campo = 'IMPORTE ESTADISTICA'
DECLARE crMovD CURSOR FOR
SELECT d.Personal, d.Renglon, d.Modulo, p.SucursalTrabajo, p.CentroCostos, CASE WHEN @QueConcepto = 'Detalle' THEN d.Concepto ELSE e.Concepto END, e.TipoCambio, d.Importe, d.Movimiento, NULLIF(RTRIM(d.CuentaContable), ''), NULLIF(RTRIM(nc.Cuenta2), '')
FROM Nomina e
JOIN NominaD d ON d.ID = e.ID /*AND d.Modulo = 'NOM' */AND UPPER(d.Movimiento) = 'ESTADISTICA'
JOIN Personal p ON p.Personal = d.Personal
LEFT OUTER JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto
WHERE e.ID = @ID
ELSE
DECLARE crMovD CURSOR FOR
SELECT d.Personal, d.Renglon, d.Modulo, p.SucursalTrabajo, p.CentroCostos, CASE WHEN @QueConcepto = 'Detalle' THEN d.Concepto ELSE e.Concepto END, e.TipoCambio, d.Importe, d.Movimiento, NULLIF(RTRIM(d.CuentaContable), ''), NULLIF(RTRIM(nc.Cuenta2), '')
FROM Nomina e
JOIN NominaD d ON d.ID = e.ID /*AND d.Modulo = 'NOM' */AND UPPER(d.Movimiento) IN ('PERCEPCION', 'DEDUCCION')
JOIN Personal p ON p.Personal = d.Personal
LEFT OUTER JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto
WHERE e.ID = @ID
OPEN crMovD
FETCH NEXT FROM crMovD INTO @Personal, @Renglon, @RenglonModulo, @SucursalContable, @ContUso, @Concepto, @TipoCambio, @Importe, @Movimiento, @CtaConcepto, @CtaConcepto2
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF @ContPersonalSucursal = 0 SELECT @SucursalContable = NULL
SELECT @Monto = NULL, @Cta = NULL
IF UPPER(@Cuenta) = 'CONCEPTO RECIBO' AND @CtaConcepto IS NOT NULL
SELECT @Cta = @CtaConcepto
ELSE
IF UPPER(@Cuenta) = 'CONCEPTO RECIBO 2' AND @CtaConcepto2 IS NOT NULL
SELECT @Cta = @CtaConcepto2
ELSE
EXEC spContAutoGetCuenta @Modulo, @Cuenta, @CuentaOmision, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, NULL, NULL, NULL, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Cta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Cta IS NULL
EXEC xpContAutoCuentaExtra @Modulo, @ID, @Cuenta, @CuentaOmision, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, NULL, NULL, NULL, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Cta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @CtaConcepto IS NULL AND @Condicion = 'CONCEPTO RECIBO C/CUENTA'
SELECT @Cta = NULL
IF @Cta IS NOT NULL
BEGIN
IF @Campo IN ('IMPORTE', 'IMPORTE ESTADISTICA')
SELECT @Monto = @Importe
ELSE
IF @Campo = 'IMPORTE NETO'
BEGIN
IF UPPER(@Movimiento) = 'PERCEPCION' SELECT @Monto = @Importe ELSE
IF UPPER(@Movimiento) = 'DEDUCCION'  SELECT @Monto = -@Importe
END ELSE
IF @Campo = 'IMPORTE PERCEPCIONES' AND UPPER(@Movimiento) = 'PERCEPCION' SELECT @Monto = @Importe ELSE
IF @Campo = 'IMPORTE DEDUCCIONES'  AND UPPER(@Movimiento) = 'DEDUCCION'  SELECT @Monto = @Importe ELSE
IF @Campo = 'IMPORTE TESORERIA'    AND @RenglonModulo     = 'DIN'        SELECT @Monto = @Importe ELSE
IF @Campo = 'IMPORTE CXP' 	   AND @RenglonModulo     = 'CXP'        SELECT @Monto = @Importe
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
INSERT #Poliza (
Renglon,  Orden,  Cuenta, SubCuenta, Concepto,  Debe,  Haber,  SucursalContable,  ContactoEspecifico,                                                                                              ContactoTipo) 
SELECT @Renglon, @Orden, @Cta,   @ContUso,  @Concepto, @Debe, @Haber, @SucursalContable, dbo.fnContactoEspecifico(@ContAutoContactoEsp, NULL, NULL, NULL, NULL, @Personal, NULL, NULL, NULL, NULL, NULL), dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo) 
END
END
END
FETCH NEXT FROM crMovD INTO @Personal, @Renglon, @RenglonModulo, @SucursalContable, @ContUso, @Concepto, @TipoCambio, @Importe, @Movimiento, @CtaConcepto, @CtaConcepto2
IF @@ERROR <> 0 SELECT @Ok = 1
END  
CLOSE crMovD
DEALLOCATE crMovD
RETURN
END

