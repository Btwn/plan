SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSMuestraOfertasFormasPago (
@ID          varchar(36),
@Empresa     varchar(5),
@Sucursal    int,
@Estacion    int
)

AS
BEGIN
DECLARE
@String							varchar(MAX),
@FormasPago						varchar(MAX),
@FormasPago2					varchar(MAX),
@Codigo							varchar(50),
@FormaPago						varchar(50),
@LargoLinea						int,
@Moneda							varchar(20),
@MonedaPrincipal				varchar(20),
@TipoCambio						float,
@Descuento						float,
@Fecha							datetime,
@RedondeoMonetarios				int,
@Importe						float,
@ImporteTotal					float,
@ArticuloRedondeo				varchar(20),
@CodigoRedondeo					varchar(50),
@Hora							int,
@Minutos						int,
@HoraMinutos					int,
@MontoMinimo					float 	,
@MovClave						varchar(20),
@Descripcion					varchar(100),
@CfgAnticipoArticuloServicio	varchar(20),
@POSMonedaAct					bit,
@Comision3						float
SELECT @POSMonedaAct = POSMonedaAct
FROM POSCfg
WHERE Empresa = @Empresa
SELECT @LargoLinea = 100
SELECT @Fecha = GETDATE()
SELECT @Hora = DATEPART(HOUR,@Fecha)
SELECT @Minutos= DATEPART(MINUTE,@Fecha)
SELECT @HoraMinutos = (@Hora*60)+@Minutos
SELECT @Fecha = dbo.fnFechaSinHora(@Fecha)
SELECT @CodigoRedondeo = pc.RedondeoVentaCodigo
FROM POSCfg pc
WHERE Empresa = @Empresa
SELECT @CfgAnticipoArticuloServicio = NULLIF(CxcAnticipoArticuloServicio,'')
FROM EmpresaCfg2
WHERE Empresa = @Empresa
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa)
SELECT @ArticuloRedondeo = Cuenta
FROM CB
WHERE Codigo = @CodigoRedondeo AND TipoCuenta = 'Articulos'
SELECT TOP 1 @MonedaPrincipal = Moneda
FROM POSLTipoCambioRef
WHERE TipoCambio = 1 AND Sucursal = @Sucursal AND EsPrincipal = 1
SELECT @MovClave = mt.Clave
FROM MovTipo mt JOIN POSL p ON mt.Mov = p.Mov AND mt.Modulo = 'POS'
WHERE p.ID = @ID
SELECT @ImporteTotal = SUM(dbo.fnPOSImporteMov(((plv.Cantidad  - ISNULL(plv.CantidadObsequio,0.0)) *
((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) - ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) * (
CASE WHEN ISNULL(plv.AplicaDescGlobal, 1) = 1
THEN ISNULL(p.DescuentoGlobal,0.0)
ELSE 0
END)/100))),plv.Impuesto1,plv.Impuesto2,plv.Impuesto3,plv.Cantidad))
FROM POSLVenta plv
JOIN POSL p ON p.ID = plv.ID
WHERE plv.ID = @ID
AND plv.Articulo <> @ArticuloRedondeo
IF @MovClave IN ('POS.N','POS.F') AND NOT EXISTS(SELECT * FROM POSLVenta WHERE ID = @ID AND Articulo IN(SELECT Articulo FROM POSLDIArtRecargaTel))
AND NOT EXISTS(SELECT * FROM POSLVenta WHERE ID = @ID AND Articulo =@CfgAnticipoArticuloServicio)
BEGIN
IF EXISTS(SELECT * FROM  POSOfertaFormaPago WHERE Estatus = 'ACTIVA' AND @Fecha BETWEEN ISNULL(FechaD,@Fecha)
AND ISNULL(FechaA,@Fecha)AND   @HoraMinutos BETWEEN ISNULL(dbo.fnHoraEnEntero(HoraD),0)
AND ISNULL(dbo.fnHoraEnEntero(ISNULL(HoraA,'12:00')),1440))
AND NOT EXISTS(SELECT * FROM POSLCobro WHERE ID = @ID)
BEGIN
SELECT @FormasPago = '************* DESCUENTOS POR FORMA DE PAGO  *************  <BR><BR>'
DECLARE crFormaPago CURSOR LOCAL FOR
SELECT FormaPago,Descuento, MontoMinimo, ISNULL(SUBSTRING(Descripcion,1,57),'')
FROM POSOfertaFormaPago
WHERE Estatus = 'ACTIVA' AND @Fecha BETWEEN ISNULL(FechaD,@Fecha)
AND ISNULL(FechaA,@Fecha) AND @HoraMinutos BETWEEN ISNULL(dbo.fnHoraEnEntero(HoraD),0)
AND ISNULL(dbo.fnHoraEnEntero(ISNULL(HoraA,'12:00')),1440)
GROUP BY FormaPago,Descuento, MontoMinimo ,Descripcion
HAVING @ImporteTotal >=MAX(MontoMinimo)
OPEN crFormaPago
FETCH NEXT FROM crFormaPago INTO @FormaPago, @Descuento, @MontoMinimo, @Descripcion
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Moneda = CASE WHEN @POSMonedaAct = 0 THEN NULLIF(fp.Moneda,'') ELSE NULLIF(fp.POSMoneda,'') END
FROM FormaPago fp
WHERE fp.FormaPago = @FormaPago
SELECT @Importe = @ImporteTotal
IF ISNULL(@Moneda, @MonedaPrincipal) <> @MonedaPrincipal
SELECT @TipoCambio = ROUND(ptcr.TipoCambio,@RedondeoMonetarios)
FROM POSLTipoCambioRef ptcr
WHERE ptcr.Sucursal = @Sucursal
AND ptcr.Moneda = @Moneda
ELSE
SELECT @TipoCambio = 1.0
SELECT @Importe = ROUND(@Importe,@RedondeoMonetarios) / ISNULL(@TipoCambio,1)
IF @Importe >= @MontoMinimo
BEGIN
SELECT @Importe = (@Importe -(@Importe *ISNULL(@Descuento,0.0)/100))
SELECT @String = UPPER(@Descripcion) + '<BR>' + 'PAGO EN ' + LEFT(UPPER(@FormaPago) + SPACE(40),40) +
CONVERT(varchar,@Descuento) + '% DESCUENTO' + '<BR>' +
'IMPORTE CON DESCUENTO:                    ' + dbo.fnFormatoMoneda(@Importe,@Empresa) + ' ' + @Moneda + '<BR>'
SELECT @FormasPago = ISNULL(@FormasPago,'') + ISNULL(@String,'')
END
END
FETCH NEXT FROM crFormaPago INTO @FormaPago, @Descuento, @MontoMinimo, @Descripcion
END
CLOSE crFormaPago
DEALLOCATE crFormaPago
END
END
IF @MovClave IN ('POS.CXCC') AND NOT EXISTS(SELECT * FROM POSLVenta WHERE ID = @ID AND Articulo IN(SELECT Articulo FROM POSLDIArtRecargaTel))
AND NOT EXISTS(SELECT * FROM POSLVenta WHERE ID = @ID AND Articulo =@CfgAnticipoArticuloServicio)
BEGIN
SELECT @FormasPago = '************* COMISIONES POR FORMA DE PAGO  *************  <BR><BR>'
DECLARE crFormaPago CURSOR LOCAL FOR
SELECT FormaPago, Comision3
FROM FormaPago
GROUP BY  FormaPago, Comision3
HAVING Comision3 >=0
OPEN crFormaPago
FETCH NEXT FROM crFormaPago INTO @FormaPago, @Comision3
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Moneda = CASE WHEN @POSMonedaAct = 0 THEN NULLIF(fp.Moneda,'') ELSE NULLIF(fp.POSMoneda,'') END
FROM FormaPago fp
WHERE fp.FormaPago = @FormaPago
SELECT @Importe = @ImporteTotal
IF ISNULL(@Moneda, @MonedaPrincipal) <> @MonedaPrincipal
SELECT @TipoCambio = ROUND(ptcr.TipoCambio,@RedondeoMonetarios)
FROM POSLTipoCambioRef ptcr
WHERE ptcr.Sucursal = @Sucursal
AND ptcr.Moneda = @Moneda
ELSE
SELECT @TipoCambio = 1.0
SELECT @Importe = ROUND(@Importe,@RedondeoMonetarios) / ISNULL(@TipoCambio,1)
SELECT @Importe = (@Importe +(@Importe *ISNULL(@Comision3,0.0)/100))
SELECT @String = UPPER(@Descripcion) + '<BR>' + 'PAGO EN ' + LEFT(UPPER(@FormaPago) + SPACE(40),40) +
CONVERT(varchar, @Descuento) + '% COMISION' + '<BR>' + 'IMPORTE CON COMISION:                    ' +
dbo.fnFormatoMoneda(@Importe,@Empresa) + ' ' + @Moneda + '<BR>'
SELECT @FormasPago = ISNULL(@FormasPago,'') + ISNULL(@String,'')
END
FETCH NEXT FROM crFormaPago INTO @FormaPago, @Comision3
END
CLOSE crFormaPago
DEALLOCATE crFormaPago
END
EXEC spPOSMuestraCondicionesCobro @ID, @Empresa, @Sucursal, @Estacion, @FormasPago2 OUTPUT
SELECT ISNULL(@FormasPago,'')+ISNULL(@FormasPago2,'')
END

