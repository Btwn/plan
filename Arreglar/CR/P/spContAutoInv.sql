SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContAutoInv
@Modulo		  char(5),
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
@CfgContArticulo	  bit,
@IncluirArticulos	  bit,
@IncluirDepartamento	  bit,
@RetencionPorcentaje	  float,
@ContAutoContactoEsp	  varchar(50),
@ContactoAplica	  varchar(10),
@ContAutoEmpresa	  varchar(10) = '(Todas)'

AS BEGIN
DECLARE
@Empresa			varchar(5),
@Renglon			float,
@RenglonSub			int,
@RenglonID			int,
@AlmacenOrigen		varchar(10),
@AlmacenDestino		varchar(10),
@Almacen			varchar(10),
@AlmacenTipo		varchar(20),
@Agente			varchar(10),
@ContUso			varchar(20),
@ContUso2			varchar(20),
@ContUso3			varchar(20),
@Articulo			varchar(20),
@TipoCambio			float,
@Importe			money,
@Cantidad			float,
@Costo			money,
@Precio			money,
@AjusteCosteo		money,
@CostoUEPS			money,
@CostoPEPS			money,
@UltimoCosto		money,
@CostoEstandar		money,
@CostoPromedio		money,
@CostoReposicion		money,
@PrecioLista		money,
@AjustePrecioLista		money,
@CostoActividad		money,
@Descuentos			money,
@Comisiones			money,
@Impuesto1			money,
@Impuesto1Excento		bit,
@Excento			bit,
@Impuesto2			money,
@Impuesto3			money,
@Impuesto5			money,
@Impuestos			money,
@ImporteTotal		money,
@Cta			varchar(20),
@Monto			money,
@Debe			money,
@Haber			money,
@DepartamentoDetallista	int,
@TipoImpuesto1		varchar(10),
@TipoImpuesto2		varchar(10),
@TipoImpuesto3		varchar(10),
@TipoImpuesto5		varchar(10),
@TipoRetencion1		varchar(10),
@TipoRetencion2		varchar(10),
@TipoRetencion3		varchar(10),
@ArtImpuesto1       float,
@ArtImpuesto1Excento bit,
@Condicion           varchar(50),
@TipoCondicion       varchar(20)
IF @Campo IS NULL RETURN
IF @Modulo = 'VTAS'
DECLARE crMovD CURSOR FAST_FORWARD READ_ONLY FOR
SELECT e.Empresa, e.Almacen, e.AlmacenDestino, e.Agente, d.Renglon, d.RenglonSub, d.RenglonID, d.Almacen, Alm.Tipo, d.ContUso, d.ContUso2, d.ContUso3, d.Articulo, d.CantidadNeta, d.AjusteCosteo, d.CostoUEPS, d.CostoPEPS, d.UltimoCosto, d.CostoEstandar, d.CostoPromedio, d.CostoReposicion, d.PrecioLista, d.TipoCambio, d.SubTotal, d.CostoTotal, d.DescuentosTotales, d.Impuesto1Total, d.Impuesto2Total, d.Impuesto3Total, CONVERT(money,NULL), d.Impuestos, d.ImporteTotal-(d.SubTotal*(ISNULL(@RetencionPorcentaje, 0.0)/100.0)), d.Comision, d.CostoActividadTotal, CONVERT(money, null), CONVERT(money, null), ISNULL(Art.Impuesto1Excento, 0),
d.TipoImpuesto1, d.TipoImpuesto2, d.TipoImpuesto3, CONVERT(varchar(10),NULL), art.TipoRetencion1, art.TipoRetencion2, art.TipoRetencion3, Art.Impuesto1, Art.Impuesto1Excento, e.Condicion
FROM Venta e
JOIN VentaTCalc d ON e.ID = d.ID
JOIN Alm ON d.Almacen = Alm.Almacen
JOIN Art ON d.Articulo = Art.Articulo
WHERE e.ID = @ID
IF @Modulo = 'COMS'
DECLARE crMovD CURSOR FAST_FORWARD READ_ONLY FOR
SELECT e.Empresa, e.Almacen, NULL, e.Agente, d.Renglon, d.RenglonSub, d.RenglonID, d.Almacen, Alm.Tipo, d.ContUso, d.ContUso2, d.ContUso3, d.Articulo, d.CantidadNeta, d.AjusteCosteo, d.CostoUEPS, d.CostoPEPS, d.UltimoCosto, d.CostoEstandar, d.CostoPromedio, d.CostoReposicion, d.PrecioLista, d.TipoCambio, d.SubTotal, d.SubTotalInv, d.DescuentosTotales, d.Impuesto1Total, d.Impuesto2Total, d.Impuesto3Total, d.Impuesto5Total, d.Impuestos, d.ImporteTotal, CONVERT(money, NULL), CONVERT(money, null), CONVERT(money, null), CONVERT(money, null), ISNULL(Art.Impuesto1Excento, 0),
d.TipoImpuesto1, d.TipoImpuesto2, d.TipoImpuesto3, d.TipoImpuesto5, d.TipoRetencion1, d.TipoRetencion2, d.TipoRetencion3, Art.Impuesto1, Art.Impuesto1Excento, e.Condicion
FROM Compra e
JOIN CompraTCalc d ON e.ID = d.ID
JOIN Alm ON d.Almacen = Alm.Almacen
JOIN Art ON d.Articulo = Art.Articulo
WHERE e.ID = @ID
IF @Modulo = 'INV'
DECLARE crMovD CURSOR FAST_FORWARD READ_ONLY FOR
SELECT e.Empresa, e.Almacen, e.AlmacenDestino, e.Agente, d.Renglon, d.RenglonSub, d.RenglonID, d.Almacen, Alm.Tipo, d.ContUso, CONVERT(varchar, NULL), CONVERT(varchar, NULL), d.Articulo, d.Cantidad-ISNULL(d.CantidadCancelada, 0), d.AjusteCosteo, d.CostoUEPS, d.CostoPEPS, d.UltimoCosto, d.CostoEstandar, d.CostoPromedio, d.CostoReposicion, d.PrecioLista, e.TipoCambio, d.Costo*(d.Cantidad-ISNULL(d.CantidadCancelada, 0)), ISNULL(d.CostoInv, d.Costo)*(d.Cantidad-ISNULL(d.CantidadCancelada, 0)), CONVERT(money, NULL), CONVERT(money, NULL), CONVERT(money, NULL), CONVERT(money, NULL), CONVERT(money, NULL), CONVERT(money, NULL), CONVERT(money, NULL), CONVERT(money, NULL), CONVERT(money, NULL), d.Precio*(d.Cantidad-ISNULL(d.CantidadCancelada, 0)), d.AjustePrecioLista, ISNULL(Art.Impuesto1Excento, 0),
art.TipoImpuesto1, art.TipoImpuesto2, art.TipoImpuesto3, CONVERT(varchar(10),NULL), art.TipoRetencion1, art.TipoRetencion2, art.TipoRetencion3, Art.Impuesto1, Art.Impuesto1Excento, e.Condicion
FROM Inv e
JOIN InvD d ON e.ID = d.ID
JOIN Alm ON d.Almacen = Alm.Almacen
JOIN Art ON d.Articulo = Art.Articulo
WHERE e.ID = @ID
IF @Modulo = 'PROD'
DECLARE crMovD CURSOR FAST_FORWARD READ_ONLY FOR
SELECT e.Empresa, e.Almacen, NULL, NULL, d.Renglon, d.RenglonSub, d.RenglonID, d.Almacen, Alm.Tipo, CONVERT(varchar, NULL), CONVERT(varchar, NULL), CONVERT(varchar, NULL), d.Articulo, d.Cantidad-ISNULL(d.CantidadCancelada, 0), d.AjusteCosteo, d.CostoUEPS, d.CostoPEPS, d.UltimoCosto, d.CostoEstandar, d.CostoPromedio, d.CostoReposicion, d.PrecioLista, e.TipoCambio, CONVERT(money, NULL), d.Costo*(d.Cantidad-ISNULL(d.CantidadCancelada, 0)), CONVERT(money, NULL), CONVERT(money, NULL), CONVERT(money, NULL), CONVERT(money, NULL), CONVERT(money, NULL), CONVERT(money, NULL), CONVERT(money, NULL), CONVERT(money, NULL), CONVERT(money, null), CONVERT(money, null), CONVERT(money, null), ISNULL(Art.Impuesto1Excento, 0),
art.TipoImpuesto1, art.TipoImpuesto2, art.TipoImpuesto3, CONVERT(varchar(10),NULL), art.TipoRetencion1, art.TipoRetencion2, art.TipoRetencion3, Art.Impuesto1, Art.Impuesto1Excento, CONVERT(varchar, NULL)
FROM Prod e
JOIN ProdD d ON e.ID = d.ID
JOIN Alm ON d.Almacen = Alm.Almacen
JOIN Art ON d.Articulo = Art.Articulo
WHERE e.ID = @ID
OPEN crMovD
FETCH NEXT FROM crMovD INTO @Empresa, @AlmacenOrigen, @AlmacenDestino, @Agente, @Renglon, @RenglonSub, @RenglonID, @Almacen, @AlmacenTipo, @ContUso, @ContUso2, @ContUso3, @Articulo, @Cantidad, @AjusteCosteo, @CostoUEPS, @CostoPEPS, @UltimoCosto, @CostoEstandar, @CostoPromedio, @CostoReposicion, @PrecioLista, @TipoCambio, @Importe, @Costo, @Descuentos, @Impuesto1, @Impuesto2, @Impuesto3, @Impuesto5, @Impuestos, @ImporteTotal, @Comisiones, @CostoActividad, @Precio, @AjustePrecioLista, @Impuesto1Excento,
@TipoImpuesto1, @TipoImpuesto2, @TipoImpuesto3, @TipoImpuesto5, @TipoRetencion1, @TipoRetencion2, @TipoRetencion3, @ArtImpuesto1, @ArtImpuesto1Excento, @Condicion
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF UPPER(@Cuenta) = 'ALMACEN/AF DESTINO' AND @Modulo = 'INV'
BEGIN
SELECT @Almacen = @AlmacenDestino
SELECT @AlmacenTipo = Tipo FROM Alm WHERE Almacen = @Almacen
END
SELECT @Monto = NULL, @Cta = NULL, @DepartamentoDetallista = NULL
IF UPPER(@Cuenta) IN ('CUENTA IMP 1','CUENTA IMP 1 COND') AND @Modulo = 'VTAS'
BEGIN
SELECT @TipoCondicion = UPPER(TipoCondicion) FROM Condicion WHERE Condicion = @Condicion
IF UPPER(@Cuenta) = 'CUENTA IMP 1' AND ISNULL(@ArtImpuesto1Excento,0) = 0
SELECT @Cta = Cuenta FROM CfgCuentasContablesImpuesto1 WHERE UPPER(Nombre) <> 'EXENTO' AND ISNULL(Tasa,0) = @ArtImpuesto1
ELSE IF UPPER(@Cuenta) = 'CUENTA IMP 1' AND ISNULL(@ArtImpuesto1Excento,0) = 1
SELECT @Cta = Cuenta FROM CfgCuentasContablesImpuesto1 WHERE UPPER(Nombre) = 'EXENTO'
ELSE IF UPPER(@Cuenta) = 'CUENTA IMP 1 COND' AND ISNULL(@ArtImpuesto1Excento,0) = 0
SELECT @Cta = Cuenta FROM CfgCuentasContablesCondImpuesto1 WHERE UPPER(Condicion) = UPPER(@TipoCondicion) AND UPPER(Nombre) <> 'EXENTO' AND ISNULL(Tasa,0) = @ArtImpuesto1
ELSE IF UPPER(@Cuenta) = 'CUENTA IMP 1 COND' AND ISNULL(@ArtImpuesto1Excento,0) = 1
SELECT @Cta = Cuenta FROM CfgCuentasContablesCondImpuesto1 WHERE UPPER(Condicion) = UPPER(@TipoCondicion) AND UPPER(Nombre) = 'EXENTO'
END
IF @Cta IS NULL
EXEC spContAutoGetCuenta @Modulo, @Cuenta, @CuentaOmision, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, @Articulo, @Almacen, @AlmacenTipo, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Cta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT,
@TipoImpuesto1, @TipoImpuesto2, @TipoImpuesto3, @TipoImpuesto5, @TipoRetencion1, @TipoRetencion2, @TipoRetencion3
IF @Cta IS NULL
EXEC xpContAutoCuentaExtra @Modulo, @ID, @Cuenta, @CuentaOmision, @CtaCtoTipo, @CtaCtoTipoAplica, @CtaClase, @Articulo, @Almacen, @AlmacenTipo, @Concepto, @Contacto, @ContactoTipo, @CtaDinero, @CtaDineroDestino, @FormaPago, @Cta OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Cta IS NOT NULL OR @Cuenta = 'TABLA %'
BEGIN
SELECT @Excento = 0
IF @Campo = 'IMPORTE BRUTO'        SELECT @Monto = @Importe+@Descuentos 	ELSE
IF @Campo = 'IMPORTE' 		   SELECT @Monto = @Importe 	     		ELSE
IF @Campo = 'COSTO'   		   SELECT @Monto = @Costo 			ELSE
IF @Campo = 'PRECIO'   		   SELECT @Monto = @Precio 			ELSE
IF @Campo = 'AJUSTE COSTEO'	   SELECT @Monto = @AjusteCosteo*@Cantidad   	ELSE
IF @Campo = 'COSTO UEPS' 	   SELECT @Monto = @CostoUEPS*@Cantidad   	ELSE
IF @Campo = 'COSTO PEPS' 	   SELECT @Monto = @CostoPEPS*@Cantidad   	ELSE
IF @Campo = 'ULTIMO COSTO' 	   SELECT @Monto = @UltimoCosto*@Cantidad 	ELSE
IF @Campo = 'COSTO ESTANDAR' 	   SELECT @Monto = @CostoEstandar*@Cantidad 	ELSE
IF @Campo = 'COSTO PROMEDIO' 	   SELECT @Monto = @CostoPromedio*@Cantidad	ELSE
IF @Campo = 'COSTO REPOSICION' 	   SELECT @Monto = @CostoReposicion*@Cantidad	ELSE
IF @Campo = 'PRECIO LISTA' 	   SELECT @Monto = @PrecioLista*@Cantidad 	ELSE
IF @Campo = 'AJUSTE PRECIO LISTA'  SELECT @Monto = @AjustePrecioLista*@Cantidad ELSE
IF @Campo = 'COSTO ACTIVIDAD' 	   SELECT @Monto = @CostoActividad   		ELSE
IF @Campo = 'COMISIONES' 	   SELECT @Monto = @Comisiones			ELSE
IF @Campo = 'DESCUENTOS'  	   SELECT @Monto = @Descuentos 			ELSE
IF @Campo = 'IMPUESTO 1'  	   SELECT @Monto = @Impuesto1, @Excento = @Impuesto1Excento ELSE
IF @Campo = 'IMPUESTO 2'  	   SELECT @Monto = @Impuesto2			ELSE
IF @Campo = 'IMPUESTO 3'    	   SELECT @Monto = @Impuesto3			ELSE
IF @Campo = 'IMPUESTO 5'    	   SELECT @Monto = @Impuesto5			ELSE
IF @Campo = 'IMPUESTOS'     	   SELECT @Monto = @Impuestos			ELSE
IF @Campo = 'IMPORTE TOTAL' 	   SELECT @Monto = @ImporteTotal		ELSE
IF @Campo = 'UTILIDAD' 		   SELECT @Monto = ISNULL(@Importe, 0)-ISNULL(@Costo, 0)-ISNULL(@CostoActividad, 0) ELSE
IF @Campo = 'MERMA DEPARTAMENTO'   SELECT @Monto = @Importe * (dd.Merma/100.0) FROM Art a, DepartamentoDetallista dd WHERE a.Articulo = @Articulo AND dd.Departamento = a.DepartamentoDetallista ELSE
IF @Campo = 'AF VALOR ADQUISICION' SELECT @Monto = SUM(af.AdquisicionValor*m.TipoCambio) FROM SerieLoteMov sl JOIN ActivoF af ON af.Empresa = sl.Empresa AND af.Articulo = sl.Articulo AND af.Serie = sl.SerieLote JOIN Mon m ON m.Moneda = af.Moneda WHERE sl.Empresa = @Empresa AND sl.Modulo = @Modulo AND sl.ID = @ID AND sl.RenglonID = @RenglonID AND sl.Articulo = @Articulo ELSE
IF @Campo = 'AF DEPRECIACION ACUM' SELECT @Monto = SUM(af.DepreciacionAcum*m.TipoCambio) FROM SerieLoteMov sl JOIN ActivoF af ON af.Empresa = sl.Empresa AND af.Articulo = sl.Articulo AND af.Serie = sl.SerieLote JOIN Mon m ON m.Moneda = af.Moneda WHERE sl.Empresa = @Empresa AND sl.Modulo = @Modulo AND sl.ID = @ID AND sl.RenglonID = @RenglonID AND sl.Articulo = @Articulo ELSE
IF @Campo = 'AF HISTORICO NETO'    SELECT @Monto = SUM((ISNULL(af.AdquisicionValor, 0)-ISNULL(af.DepreciacionAcum, 0))*m.TipoCambio) FROM SerieLoteMov sl JOIN ActivoF af ON af.Empresa = sl.Empresa AND af.Articulo = sl.Articulo AND af.Serie = sl.SerieLote JOIN Mon m ON m.Moneda = af.Moneda WHERE sl.Empresa = @Empresa AND sl.Modulo = @Modulo AND sl.ID = @ID AND sl.RenglonID = @RenglonID AND sl.Articulo = @Articulo
IF @Campo = 'AF UTILIDAD/PERDIDA'  SELECT @Monto = (SUM(af.AdquisicionValor*m.TipoCambio)) - @Importe FROM SerieLoteMov sl JOIN ActivoF af ON af.Empresa = sl.Empresa AND af.Articulo = sl.Articulo AND af.Serie = sl.SerieLote JOIN Mon m ON m.Moneda = af.Moneda WHERE sl.Empresa = @Empresa AND sl.Modulo = @Modulo AND sl.ID = @ID AND sl.RenglonID = @RenglonID AND sl.Articulo = @Articulo
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
IF @Campo <> 'AF UTILIDAD/PERDIDA'
BEGIN
IF @EsDebe = 1
SELECT @Debe = CASE WHEN @Campo IN ('AF VALOR ADQUISICION', 'AF DEPRECIACION ACUM', 'AF HISTORICO NETO') THEN @Monto ELSE @Monto*@TipoCambio END
ELSE
SELECT @Haber = CASE WHEN @Campo IN ('AF VALOR ADQUISICION', 'AF DEPRECIACION ACUM', 'AF HISTORICO NETO') THEN @Monto ELSE @Monto*@TipoCambio END
END
ELSE IF @Campo = 'AF UTILIDAD/PERDIDA'
BEGIN
SELECT @Debe = NULL, @Haber = NULL
IF @EsDebe = 1
SELECT @Debe = CASE WHEN ISNULL(@Monto,0) > 0 THEN @Monto ELSE NULL END
ELSE
SELECT @Haber = CASE WHEN ISNULL(@Monto,0) > 0 THEN NULL ELSE ABS(@Monto) END
END
IF @IncluirDepartamento = 1 SELECT @DepartamentoDetallista = DepartamentoDetallista FROM Art WHERE Articulo = @Articulo
IF @CfgContArticulo = 0 OR @IncluirArticulos = 0 SELECT @Articulo = NULL
INSERT #Poliza (
Renglon,  RenglonSub,  Orden,  Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto,  Articulo,  DepartamentoDetallista,  Debe,  Haber,  ContactoEspecifico,                                                                                                                                                        ContactoTipo) 
SELECT @Renglon, @RenglonSub, @Orden, @Cta,   @ContUso,  @ContUso2,  @ContUso3,  @Concepto, @Articulo, @DepartamentoDetallista, @Debe, @Haber, dbo.fnContactoEspecifico(@ContAutoContactoEsp, @Contacto, @ContactoAplica, NULL, @Agente, NULL, @CtaDinero, @CtaDineroDestino, @AlmacenOrigen, @AlmacenDestino, @Almacen), dbo.fnTipoContactoEspecifico(@ContAutoContactoEsp,@ContactoTipo) 
END
END
END
FETCH NEXT FROM crMovD INTO @Empresa, @AlmacenOrigen, @AlmacenDestino, @Agente, @Renglon, @RenglonSub, @RenglonID, @Almacen, @AlmacenTipo, @ContUso, @ContUso2, @ContUso3, @Articulo, @Cantidad, @AjusteCosteo, @CostoUEPS, @CostoPEPS, @UltimoCosto, @CostoEstandar, @CostoPromedio, @CostoReposicion, @PrecioLista, @TipoCambio, @Importe, @Costo, @Descuentos, @Impuesto1, @Impuesto2, @Impuesto3, @Impuesto5, @Impuestos, @ImporteTotal, @Comisiones, @CostoActividad, @Precio, @AjustePrecioLista, @Impuesto1Excento,
@TipoImpuesto1, @TipoImpuesto2, @TipoImpuesto3, @TipoImpuesto5, @TipoRetencion1, @TipoRetencion2, @TipoRetencion3, @ArtImpuesto1, @ArtImpuesto1Excento, @Condicion
IF @@ERROR <> 0 SELECT @Ok = 1
END  
CLOSE crMovD
DEALLOCATE crMovD
RETURN
END

