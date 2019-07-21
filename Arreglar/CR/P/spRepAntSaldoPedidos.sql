SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRepAntSaldoPedidos
@Estacion		int

AS BEGIN
DECLARE @ClienteD		varchar(10),
@ClienteA		varchar(10),
@Desglosado		char(2),
@Empresa			char(5)
SELECT @ClienteD = rp.InfoClienteD,
@ClienteA = rp.InfoClienteA,
@Desglosado = rp.InfoDesglosar,
@Empresa = rp.InfoEmpresa
FROM RepParam rp
WHERE Estacion = @Estacion
IF ISNULL(@ClienteD, '') IN ('Todos','(Todos)','') SELECT @ClienteD = MIN(Cliente) FROM Cte
IF ISNULL(@ClienteA, '') IN ('Todos','(Todos)','') SELECT @ClienteA = MAX(Cliente) FROM Cte
IF ISNULL(@Desglosado, '') IN ('') SELECT @Desglosado = 'No'
SELECT v.ID,
v.Empresa,
v.Mov,
v.MovID,
v.FechaEmision,
v.Cliente,
c.Nombre,
v.Total,
v.Moneda,
Saldo = ISNULL(v.Saldo, 0) - ISNULL(v.SaldoImpuestos,0),
vd.Articulo,
vd.ArtDescripcion,
Pendiente = CASE ISNULL(vd.CantidadPendiente, 0)
WHEN 0 THEN vd.CantidadReservada
ELSE ISNULL(vd.CantidadPendiente, 0)
END,
vd.Precio,
ImportePendienteDetalle = CASE ISNULL(vd.CantidadPendiente, 0)
WHEN 0 THEN (vd.CantidadReservada * vd.Precio) - (vd.CantidadReservada * vd.Precio * (ISNULL(vd.DescuentoLinea,0) / 100))
ELSE (vd.CantidadPendiente * vd.Precio) - (vd.CantidadPendiente * vd.Precio * (ISNULL(vd.DescuentoLinea,0) / 100))
END,
vd.DescuentoLinea,
Dias = DATEDIFF(DAY, v.FechaEmision, GETDATE())
FROM VentaPendiente v
INNER JOIN Cte c ON v.Cliente = c.Cliente
INNER JOIN VentaPendienteD vd On v.ID = vd.ID
INNER JOIN MovTipo mt ON mt.Modulo = 'VTAS' AND mt.Mov = v.Mov AND mt.Clave IN ('VTAS.P')
WHERE v.Empresa = @Empresa
AND v.Cliente BETWEEN @ClienteD AND @ClienteA
ORDER BY v.Moneda, v.Cliente, v.Mov
END

