SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSVerificarAnticiposTipoServicio
@Estacion		int,
@ID				varchar(36),
@Empresa		varchar(5)
AS BEGIN
DECLARE @SubTotal			float,
@ImporteMov			float,
@ImpuestosMov		float,
@TotalImpuesto1		float,
@TotalDescuento		float,
@Total				float,
@ArticuloRedondeo	varchar(20),
@ImportePagado		float,
@TotalAnticipos		float,
@Respuesta			bit
SET	@Respuesta = 1
SELECT @ArticuloRedondeo = c.Cuenta
FROM CB c WITH (NOLOCK)
JOIN POSCfg p WITH (NOLOCK) ON c.Codigo = p.RedondeoVentaCodigo AND c.TipoCuenta = 'Articulos'
WHERE p.Empresa = @Empresa
SELECT @ImportePagado = SUM(ISNULL(Importe,0))
FROM POSLCobro WITH (NOLOCK)
WHERE ID = @ID
SELECT @TotalAnticipos = SUM(ISNULL(AnticipoAplicar,0))
FROM POSCxcAnticipoTemp WITH (NOLOCK)
WHERE Estacion = @Estacion
SELECT @SubTotal = SUM(ISNULL(((Cantidad - ISNULL(CantidadObsequio,0)) * Precio) ,0))
FROM POSLVenta WITH (NOLOCK)
WHERE ID = @ID
AND Articulo <> ISNULL(@ArticuloRedondeo,'')
SELECT @ImporteMov = SUM((plv.Cantidad  - ISNULL(plv.CantidadObsequio,0)) * ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0)/100))) -
((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0)/100))) * (CASE WHEN ISNULL(plv.AplicaDescGlobal, 1) = 1 THEN ISNULL(p.DescuentoGlobal,0.0) ELSE 0 END)/100))),
@ImpuestosMov = (SUM(dbo.fnPOSImporteMov(((plv.Cantidad  - ISNULL(plv.CantidadObsequio,0.0)) * ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) - ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) *
(CASE WHEN ISNULL(plv.AplicaDescGlobal, 1) = 1 THEN ISNULL(p.DescuentoGlobal,0.0) ELSE 0 END)/100))),plv.Impuesto1,plv.Impuesto2,plv.Impuesto3,plv.Cantidad))-@ImporteMov)
FROM POSLVenta plv WITH (NOLOCK)
INNER JOIN POSL p WITH (NOLOCK) ON p.ID = plv.ID
WHERE plv.ID = @ID
SET @TotalImpuesto1 = ISNULL(@ImpuestosMov,0)
SET @TotalDescuento = ISNULL(@SubTotal,0) - ISNULL(@ImporteMov,0)
SET @Total = ISNULL(@ImporteMov,0) + ISNULL(@ImpuestosMov,0)
SET @Total = @Total - ISNULL(@ImportePagado,0)
SET @Total = @Total - ISNULL(@TotalAnticipos,0)
IF @Total < 0.00
SET @Respuesta = 0
SELECT @Respuesta
END

