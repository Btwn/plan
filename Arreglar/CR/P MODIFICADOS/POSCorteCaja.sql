SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE POSCorteCaja
@Fecha		datetime,
@Cajero		varchar(20)

AS
BEGIN
CREATE TABLE #POSCorteCaja (
Num			int,
Concepto	varchar(25),
Cantidad    money)
INSERT INTO #POSCorteCaja
SELECT 'Num' = 0,
'Concepto' = '',
'Cantidad' = 0
INSERT INTO #POSCorteCaja
SELECT 'Num' = 1,
'Concepto' = 'Venta',
'Cantidad' = ISNULL(ROUND(SUM(CONVERT(Money, ISNULL((d.Cantidad * d.Precio) * (1 - ISNULL(ROUND(d.DescuentoLinea, 2), 0) / 100), 0))), 2), 0) - ISNULL(SUM(ISNULL(d.CantidadObsequio, 0) * d.Precio), 0)
FROM POSLVenta d WITH(NOLOCK)
JOIN POSL e WITH(NOLOCK) ON d.ID = e.ID
JOIN Art a WITH(NOLOCK) ON d.Articulo = a.Articulo
WHERE e.Mov IN ('Nota', 'Otros Ingresos') AND e.Modulo = 'VTAS' AND a.Tipo != 'SERVICIO'
AND e.Usuario = @Cajero AND CONVERT(Date, FechaEmision) = @Fecha AND e.Estatus IN ('CONCLUIDO','TRASPASADO')
INSERT INTO #POSCorteCaja
SELECT 'Num' = 1,
'Concepto' = 'Venta Credito',
'Cantidad' = ISNULL(ROUND(SUM(CONVERT(Money, ISNULL((d.Cantidad * d.Precio) * (1 - ISNULL(ROUND(d.DescuentoLinea, 2), 0) / 100), 0))), 2), 0)
FROM POSLVenta d WITH(NOLOCK)
JOIN POSL e WITH(NOLOCK) ON d.ID = e.ID
JOIN Art a WITH(NOLOCK) ON d.Articulo = a.Articulo
WHERE e.Mov = 'Venta Credito' AND e.Modulo = 'VTAS' AND a.Tipo != 'SERVICIO'
AND e.Usuario = @Cajero AND CONVERT(Date, FechaEmision) = @Fecha AND e.Estatus IN ('CONCLUIDO','TRASPASADO')
INSERT INTO #POSCorteCaja
SELECT 'Num' = 2,
'Concepto' = 'I.V.A.',
'Cantidad' = ISNULL(ROUND(SUM(CONVERT(Money, ISNULL((d.Cantidad * d.Precio) * (1 - ISNULL(ROUND(d.DescuentoLinea, 2), 0) / 100) * (ISNULL(d.Impuesto1, 0) / 100), 0))), 2), 0) - ISNULL(SUM(ISNULL(d.CantidadObsequio, 0) * d.Precio * (d.impuesto1/ 100)), 0)
FROM POSLVenta d WITH(NOLOCK)
JOIN POSL e WITH(NOLOCK) ON d.ID = e.ID
JOIN Art a WITH(NOLOCK) ON d.Articulo = a.Articulo
WHERE e.Mov IN ('Nota', 'Venta Credito', 'Otros Ingresos') AND e.Modulo = 'VTAS' AND a.Tipo != 'SERVICIO'
AND e.Usuario = @Cajero AND CONVERT(Date, FechaEmision) = @Fecha AND e.Estatus IN ('CONCLUIDO','TRASPASADO')
INSERT INTO #POSCorteCaja
SELECT 'Num' = 3,
'Concepto' = 'Donativos',
'Cantidad' = ISNULL(ROUND(SUM(CONVERT(Money, ISNULL((d.Cantidad * d.Precio) * (1 - ISNULL(ROUND(d.DescuentoLinea, 2), 0) / 100), 0))), 2), 0)
FROM POSLVenta d WITH(NOLOCK)
JOIN POSL e WITH(NOLOCK) ON d.ID = e.ID
JOIN Art a WITH(NOLOCK) ON d.Articulo = a.Articulo
WHERE e.Mov IN ('Nota', 'Otros Ingresos') AND e.Modulo = 'VTAS' AND d.Articulo = 'DONATIVOS'
AND e.Usuario = @Cajero AND CONVERT(Date, FechaEmision) = @Fecha AND e.Estatus IN ('CONCLUIDO','TRASPASADO')
INSERT INTO #POSCorteCaja
SELECT 'Num' = 4,
'Concepto' = 'Recargas a Celular',
'Cantidad' = ISNULL(ROUND(SUM(CONVERT(Money, ISNULL((d.Cantidad * d.Precio) * (1 - ISNULL(ROUND(d.DescuentoLinea, 2), 0) / 100), 0))), 2), 0)
FROM POSLVenta d WITH(NOLOCK)
JOIN POSL e WITH(NOLOCK) ON d.ID = e.ID
JOIN Art a WITH(NOLOCK) ON d.Articulo = a.Articulo
WHERE e.Mov IN ('Nota', 'Otros Ingresos') AND e.Modulo = 'VTAS' AND (a.Tipo = 'SERVICIO' AND d.Articulo != 'DONATIVOS')
AND e.Usuario = @Cajero AND CONVERT(Date, FechaEmision) = @Fecha AND e.Estatus IN ('CONCLUIDO','TRASPASADO')
INSERT INTO #POSCorteCaja
SELECT 'Num' = 4,
'Concepto' = 'Otros Ingresos',
'Cantidad' = ISNULL(ROUND(SUM(CONVERT(Money, ISNULL((d.Cantidad * d.Precio) * (1 - ISNULL(ROUND(d.DescuentoLinea, 2), 0) / 100), 0))), 2), 0)
FROM POSLVenta d WITH(NOLOCK)
JOIN POSL e WITH(NOLOCK) ON d.ID = e.ID
JOIN Art a WITH(NOLOCK) ON d.Articulo = a.Articulo
WHERE e.Mov IN ('Nota', 'Otros Ingresos') AND e.Modulo = 'VTAS'
AND (a.Tipo = 'SERVICIO' AND d.Articulo != 'DONATIVOS' AND d.Articulo IN ('AguaPotable','Predial')) AND
e.Usuario = @Cajero AND CONVERT(Date, FechaEmision) = @Fecha AND e.Estatus IN ('CONCLUIDO','TRASPASADO')
INSERT INTO #POSCorteCaja
SELECT 'Num' = 5,
'Concepto' = 'T O T A L',
'Cantidad' = ISNULL(ROUND(SUM(CONVERT(Money, ISNULL((d.Cantidad * d.Precio) * (1 - ISNULL(ROUND(d.DescuentoLinea, 2), 0) / 100) * (1 + ISNULL(d.Impuesto1, 0) / 100), 0))), 2), 0) - ISNULL(SUM(ISNULL(d.cantidadObsequio, 0) * d.Precio * (1 + (d.Impuesto1 / 100))), 0)
FROM POSLVenta d WITH(NOLOCK)
JOIN POSL e WITH(NOLOCK) ON d.ID       = e.ID
WHERE e.Mov IN ('Nota', 'Venta Credito', 'Otros Ingresos') AND e.Modulo = 'VTAS'
AND e.Usuario = @Cajero AND CONVERT(Date, FechaEmision) = @Fecha AND e.Estatus IN ('CONCLUIDO','TRASPASADO')
INSERT INTO #POSCorteCaja
SELECT 'Num' = 6,
'Concepto' = '',
'Cantidad' = 0
INSERT INTO #POSCorteCaja
SELECT 'Num' = 7,
'Concepto' = c.formaPago,
'Cantidad' = CASE WHEN ISNULL(SUM(ISNULL(c.importe,0)) ,0) IS NULL THEN 0 ELSE -(ISNULL(SUM(ISNULL(c.importe,0)) ,0)) END
FROM POSLCobro c WITH(NOLOCK)
INNER JOIN POSL p WITH(NOLOCK) ON p.ID=c.id
WHERE p.Cajero=@Cajero AND CAST(c.Fecha AS Date)=CAST(@Fecha AS Date) AND p.Modulo='VTAS' AND p.Estatus IN ('CONCLUIDO','TRASPASADO')
GROUP BY formaPago
INSERT INTO #POSCorteCaja
SELECT 'Num' = 8,
'Concepto' = 'T O T A L',
'Cantidad' = CASE WHEN ISNULL(SUM(ISNULL(c.Importe,0)) ,0) IS NULL THEN 0 ELSE -(ISNULL(SUM(ISNULL(c.Importe,0)) ,0)) END
FROM POSLCobro c WITH(NOLOCK)
INNER JOIN POSL p WITH(NOLOCK) ON p.ID=c.id
WHERE p.Cajero=@Cajero AND CAST(c.Fecha AS Date)=CAST(@Fecha AS Date) AND p.Modulo='VTAS' AND p.Estatus IN ('CONCLUIDO','TRASPASADO')
INSERT INTO #POSCorteCaja
SELECT 'Num' = 10,
'Concepto' = '',
'Cantidad' = 0
INSERT INTO #POSCorteCaja
SELECT 'Num' = 11,
'Concepto' = MovID,
'Cantidad' = 0
FROM POSL WITH(NOLOCK)
WHERE Mov = 'Corte Caja' AND Cajero = @Cajero AND CAST(FechaEmision AS Date) =CAST(@Fecha AS Date)
SELECT Num, Concepto, Cantidad
FROM #POSCorteCaja
ORDER BY Num
END

