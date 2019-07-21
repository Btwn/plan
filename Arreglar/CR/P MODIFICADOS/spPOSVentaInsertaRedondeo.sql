SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSVentaInsertaRedondeo
@ID			varchar(50),
@Tipo		varchar(20),
@Importe	float = NULL

AS
BEGIN
DECLARE
@Empresa					varchar(5),
@Codigo						varchar(50),
@RedondeoVenta				bit,
@RedondeoVentaModificar		bit,
@Articulo					varchar(20),
@Unidad						varchar(50),
@Renglon					float,
@RenglonID					int,
@ImporteMov					float,
@Saldo						float,
@RedondeoSugerido			float,
@RedondeoActual				float,
@RedondeoMonetarios         int
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa)
SELECT @Empresa = Empresa
FROM POSL pl WITH (NOLOCK)
WHERE pl.ID = @ID
SELECT @RedondeoSugerido = 0
SELECT
@Codigo = pc.RedondeoVentaCodigo,
@RedondeoVenta = pc.RedondeoVenta,
@RedondeoVentaModificar = pc.RedondeoVentaModificar
FROM POSCfg pc WITH (NOLOCK)
WHERE pc.Empresa = @Empresa
SELECT @Articulo = Cuenta
FROM CB WITH (NOLOCK)
WHERE Codigo = @Codigo
AND TipoCuenta = 'Articulos'
SELECT @Unidad = a.Unidad
FROM Art a WITH (NOLOCK)
WHERE a.Articulo = @Articulo
IF @Tipo = 'SUGERIR'
BEGIN
IF EXISTS(SELECT * FROM POSLVenta plv WITH (NOLOCK) WHERE plv.ID = @ID AND plv.Articulo = @Articulo AND ISNULL(Precio,0) > 0)
DELETE FROM POSLVenta WHERE ID = @ID AND Articulo = @Articulo AND ISNULL(Precio,0) > 0
SELECT @ImporteMov = SUM(dbo.fnPOSImporteMov(((plv.Cantidad  - ISNULL(plv.CantidadObsequio,0.0)) * ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) - ((plv.Precio - (plv.precio * (ISNULL(plv.DescuentoLinea,0.0)/100.0))) * (CASE WHEN ISNULL(plv.AplicaDescGlobal, 1) = 1 THEN ISNULL(p.DescuentoGlobal,0.0) ELSE 0 END)/100))),plv.Impuesto1,plv.Impuesto2,plv.Impuesto3,plv.Cantidad))
FROM POSLVenta plv WITH (NOLOCK)
INNER JOIN POSL p WITH (NOLOCK) ON p.ID = plv.ID
WHERE plv.ID = @ID
AND plv.Articulo <> @Articulo
SELECT @Saldo = SUM(ISNULL(Importe,0) * TipoCambio)
FROM POSLCobro WITH (NOLOCK)
WHERE ID = @ID
SET @ImporteMov = @ImporteMov - ISNULL(@Saldo, 0)
SELECT @ImporteMov = ROUND(@ImporteMov,@RedondeoMonetarios)
SELECT @RedondeoActual = ROUND(Precio, @RedondeoMonetarios)
FROM POSLVenta pl WITH (NOLOCK)
WHERE pl.ID = @ID
AND pl.Articulo = @Articulo
SELECT @RedondeoSugerido = ROUND(CEILING(ROUND(@ImporteMov,@RedondeoMonetarios)) - @ImporteMov, @RedondeoMonetarios)
IF ISNULL(@RedondeoActual,0) > 0
SELECT @RedondeoSugerido = 0
IF ISNULL(@RedondeoVenta,0) = 0
SELECT @RedondeoSugerido = 0
SELECT @RedondeoSugerido
END
IF @RedondeoVenta = 1 AND @Tipo = 'INSERTAR'
BEGIN
IF EXISTS(SELECT * FROM POSLVenta plv WITH (NOLOCK) WHERE plv.ID = @ID AND plv.Articulo = @Articulo)
UPDATE POSLVenta WITH (ROWLOCK) SET Precio = @Importe, PrecioImpuestoInc = @Importe, AplicaDescGlobal = 0 WHERE ID = @ID AND Articulo = @Articulo
ELSE
BEGIN
IF EXISTS (SELECT * FROM POSLVenta WITH (NOLOCK) WHERE ID = @ID AND Articulo = @Articulo)
DELETE POSLVenta WHERE ID = @ID AND Articulo = @Articulo
SELECT
@Renglon = MAX(Renglon),
@RenglonID = MAX(RenglonID)
FROM POSLVenta plv WITH (NOLOCK)
WHERE plv.ID = @ID
SELECT
@Renglon = ISNULL(@Renglon, 0) + 2048,
@RenglonID = ISNULL(@RenglonID, 0) + 1
INSERT POSLVenta (
ID, Renglon, RenglonID, RenglonTipo, Cantidad, Articulo, Precio, Unidad, Factor, CantidadInventario,
PrecioImpuestoInc, AplicaDescGlobal, Codigo)
VALUES (
@ID, @Renglon, @RenglonID, 'N', 1, @Articulo, @Importe, @Unidad, 1, 1,
@Importe,0, @Codigo)
END
END
IF @Tipo = 'ELIMINAR'
DELETE POSLVenta WHERE ID = @ID AND Articulo = @Articulo
IF @Tipo = 'ELIMINAR COBRO'
DELETE POSRedondeoTemp WHERE ID = @ID
IF @Tipo = 'CONSULTAR'
BEGIN
SELECT @RedondeoSugerido = ISNULL(SUM(Precio),0.0) FROM POSLVenta WITH (NOLOCK) WHERE ID = @ID AND Articulo = @Articulo
SELECT @RedondeoSugerido
END
IF @Tipo = 'CONSULTAR COBRO'
BEGIN
SELECT @RedondeoSugerido = ISNULL(SUM(Importe),0.0) FROM POSRedondeoTemp WITH (NOLOCK) WHERE ID = @ID
SELECT @RedondeoSugerido
END
IF @Tipo = 'INSERTAR COBRO' AND ISNULL(@Importe,0.0)>0.0
BEGIN
INSERT POSRedondeoTemp(
ID,Importe)
SELECT
@ID,@Importe
END
IF @Tipo = 'SUGERIR COBRO'
BEGIN
SELECT @ImporteMov = @Importe
SELECT @ImporteMov = ROUND(@ImporteMov,@RedondeoMonetarios)
SELECT @RedondeoActual = ROUND(Precio, @RedondeoMonetarios)
FROM POSLVenta pl WITH (NOLOCK)
WHERE pl.ID = @ID
AND pl.Articulo = @Articulo
SELECT @RedondeoSugerido = ROUND(CEILING(ROUND(@ImporteMov,@RedondeoMonetarios)) - @ImporteMov, @RedondeoMonetarios)
IF ISNULL(@RedondeoActual,0) > 0
SELECT @RedondeoSugerido = 0
IF EXISTS(SELECT * FROM POSLVenta plv WITH (NOLOCK) WHERE plv.ID = @ID AND plv.Articulo = @Articulo AND ISNULL(Precio,0) > 0)
SELECT @RedondeoSugerido = 0
IF ISNULL(@RedondeoVenta,0) = 0
SELECT @RedondeoSugerido = 0
SELECT @RedondeoSugerido
END
END

