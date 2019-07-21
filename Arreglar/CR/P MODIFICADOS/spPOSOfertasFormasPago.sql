SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSOfertasFormasPago(
@ID					varchar(36),
@Empresa			varchar(5),
@Sucursal			int,
@CodigoFormaPago	varchar(50),
@Mostrar			bit = 1
)

AS
BEGIN
DECLARE
@String							varchar(MAX),
@FormasPago						varchar(MAX),
@Codigo							varchar(50),
@Moneda							varchar(20),
@MonedaPrincipal				varchar(20),
@TipoCambio						float,
@LargoLinea						int,
@Fecha							datetime,
@RedondeoMonetarios				int,
@Importe						float,
@ArticuloRedondeo				varchar(20),
@CodigoRedondeo					varchar(50),
@ImporteProm					varchar(50),
@Descuento						float,
@FormaPago						varchar(50),
@Hora							int,
@Minutos						int,
@HoraMinutos					int,
@MontoMinimo					float,
@MovClave						varchar(20),
@CfgAnticipoArticuloServicio	varchar(20),
@POSMonedaAct					bit,
@Comision3						float
SELECT @POSMonedaAct = POSMonedaAct
FROM POSCfg WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @FormaPago = FormaPago
FROM CB WITH (NOLOCK)
WHERE Codigo = @CodigoFormaPago
AND TipoCuenta = 'Forma Pago'
SELECT @LargoLinea = 100
SELECT @Fecha = GETDATE()
SELECT @Hora = DATEPART(HOUR, @Fecha)
SELECT @Minutos= DATEPART(MINUTE, @Fecha)
SELECT @HoraMinutos = (@Hora*60) + @Minutos
SELECT @CfgAnticipoArticuloServicio = NULLIF(CxcAnticipoArticuloServicio,'')
FROM EmpresaCfg2 WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @CodigoRedondeo = pc.RedondeoVentaCodigo
FROM POSCfg pc WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @MovClave = mt.Clave
FROM MovTipo mt WITH (NOLOCK)
JOIN POSL p WITH (NOLOCK) ON mt.Mov = p.Mov AND mt.Modulo = 'POS'
WHERE p.ID = @ID
SELECT @ArticuloRedondeo = Cuenta
FROM CB WITH (NOLOCK)
WHERE Codigo = @CodigoRedondeo AND TipoCuenta = 'Articulos'
SELECT @Importe = SUM(dbo.fnPOSImporteMov(((plv.Cantidad - ISNULL(plv.CantidadObsequio,0.0)) *
((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) - ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) * (
CASE WHEN ISNULL(plv.AplicaDescGlobal, 1) = 1
THEN ISNULL(p.DescuentoGlobal,0.0)
ELSE 0
END)/100))),plv.Impuesto1,plv.Impuesto2,plv.Impuesto3,plv.Cantidad))
FROM POSLVenta plv WITH (NOLOCK)
JOIN POSL p WITH (NOLOCK) ON p.ID = plv.ID
WHERE plv.ID = @ID
AND plv.Articulo <> @ArticuloRedondeo
SELECT @Fecha = dbo.fnFechaSinHora(@Fecha)
IF @MovClave IN ('POS.N','POS.F') AND NOT EXISTS(SELECT * FROM POSLVenta WITH (NOLOCK) WHERE ID = @ID AND Articulo IN(SELECT Articulo FROM POSLDIArtRecargaTel WITH (NOLOCK)))
AND NOT EXISTS(SELECT * FROM POSLVenta WITH (NOLOCK) WHERE ID = @ID AND Articulo = @CfgAnticipoArticuloServicio)
BEGIN
SELECT @Descuento = Descuento, @MontoMinimo = MontoMinimo
FROM POSOfertaFormaPago WITH (NOLOCK)
WHERE Estatus = 'ACTIVA' AND FormaPago = @FormaPago AND @Fecha BETWEEN ISNULL(FechaD,@Fecha)
AND ISNULL(FechaA,@Fecha) AND @HoraMinutos BETWEEN ISNULL(dbo.fnHoraEnEntero(HoraD),0) AND ISNULL(dbo.fnHoraEnEntero(ISNULL(HoraA,'12:00')),1440)
GROUP BY  Descuento,MontoMinimo
HAVING @Importe >= MAX(MontoMinimo)
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa)
SELECT @Moneda = CASE WHEN @POSMonedaAct = 0 THEN NULLIF(fp.Moneda,'') ELSE NULLIF(fp.POSMoneda,'') END,
@Comision3 = Comision3
FROM FormaPago fp WITH (NOLOCK)
WHERE fp.FormaPago = @FormaPago
SELECT TOP 1 @MonedaPrincipal = Moneda
FROM POSLTipoCambioRef WITH (NOLOCK)
WHERE TipoCambio = 1
AND Sucursal = @Sucursal AND EsPrincipal = 1
IF ISNULL(@Moneda, @MonedaPrincipal) <> @MonedaPrincipal
SELECT @TipoCambio = ROUND(ptcr.TipoCambio,@RedondeoMonetarios)
FROM POSLTipoCambioRef ptcr WITH (NOLOCK)
WHERE ptcr.Sucursal = @Sucursal
AND ptcr.Moneda = @Moneda
ELSE
SELECT @TipoCambio = 1.0
SELECT @ImporteProm = ROUND(@Importe,@RedondeoMonetarios) / ISNULL(@TipoCambio,1)
IF @ImporteProm>= ISNULL(@MontoMinimo,0.0) AND @Descuento IS NOT NULL
BEGIN
SELECT @ImporteProm = (@ImporteProm -(@ImporteProm *ISNULL(@Descuento,0.0)/100))
DELETE POSLVenta WHERE ID = @ID AND Articulo = @ArticuloRedondeo
END
ELSE
SELECT @ImporteProm = NULL, @Descuento = NULL
IF @ImporteProm>= ISNULL(@MontoMinimo,0.0) AND @Comision3 IS NOT NULL
BEGIN
SELECT @ImporteProm = (@ImporteProm -(@ImporteProm *ISNULL(@Comision3,0.0)/100))
DELETE POSLVenta WHERE ID = @ID AND Articulo = @ArticuloRedondeo
END
ELSE
SELECT @ImporteProm = NULL,@Descuento = NULL
SELECT @FormasPago = dbo.fnFormatoMoneda(@Importe,@Empresa)+' '+@FormaPago
IF  EXISTS(SELECT * FROM POSLCobro WITH (NOLOCK) WHERE ID = @ID)
SELECT @ImporteProm = NULL, @Descuento = NULL
END
IF @MovClave IN ('POS.CXCC')
BEGIN
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa)
SELECT @Moneda = CASE WHEN @POSMonedaAct = 0 THEN NULLIF(fp.Moneda,'') ELSE NULLIF(fp.POSMoneda,'') END,
@Comision3 = Comision3 *-1
FROM FormaPago fp WITH (NOLOCK)
WHERE fp.FormaPago = @FormaPago
SELECT TOP 1 @MonedaPrincipal = Moneda
FROM POSLTipoCambioRef WITH (NOLOCK)
WHERE TipoCambio = 1 AND Sucursal = @Sucursal AND EsPrincipal = 1
IF ISNULL(@Moneda, @MonedaPrincipal) <> @MonedaPrincipal
SELECT @TipoCambio = ROUND(ptcr.TipoCambio,@RedondeoMonetarios)
FROM POSLTipoCambioRef ptcr WITH (NOLOCK)
WHERE ptcr.Sucursal = @Sucursal
AND ptcr.Moneda = @Moneda
ELSE
SELECT @TipoCambio = 1.0
SELECT @ImporteProm = ROUND(@Importe,@RedondeoMonetarios) / ISNULL(@TipoCambio,1)
IF @ImporteProm>= ISNULL(@MontoMinimo,0.0) AND @Comision3 IS NOT NULL
BEGIN
SELECT @ImporteProm = (@ImporteProm +(@ImporteProm *ISNULL(@Comision3,0.0)/100))*-1
DELETE POSLVenta WHERE ID = @ID AND Articulo = @ArticuloRedondeo
END
ELSE
SELECT @ImporteProm = NULL,@Descuento = NULL
SELECT @FormasPago = dbo.fnFormatoMoneda(@Importe,@Empresa)+' '+@FormaPago
IF  EXISTS(SELECT * FROM POSLCobro WITH (NOLOCK) WHERE ID = @ID)
SELECT @ImporteProm = NULL, @Descuento = NULL
END
IF @Mostrar = 1
IF @MovClave IN ('POS.CXCC')
BEGIN
SELECT ISNULL(ROUND(@ImporteProm,@RedondeoMonetarios),0.0), ISNULL(@Descuento,0.0), ISNULL(@Comision3, 0.0)
END
ELSE
SELECT ISNULL(ROUND(@ImporteProm,@RedondeoMonetarios),0.0), ISNULL(@Descuento,0.0), 0.0
END

