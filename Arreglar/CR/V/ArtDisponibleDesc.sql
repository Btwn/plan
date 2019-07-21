SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ArtDisponibleDesc

AS
SELECT
s.Empresa Empresa,
s.Cuenta Articulo,
s.Grupo Almacen,
case
when UPPER(a.tipo) in ('JUEGO','SERVICIO') then NULL
else Sum(s.SaldoU*r.Factor)
end Disponible,
a.Descripcion1, a.Descripcion2, a.Unidad, a.Tipo, a.PrecioLista, a.Impuesto1, a.Impuesto2, a.Impuesto3, ac.UltimoCosto, ac.UltimoCostoSinGastos, ac.CostoPromedio, a.CostoEstandar, a.CostoReposicion
FROM Art a
JOIN ArtCosto ac ON a.Articulo = ac.Articulo
JOIN SaldoU s ON ac.Articulo = s.Cuenta AND ac.Empresa = s.Empresa
JOIN Rama r ON s.Rama = r.Rama AND r.Mayor = 'INV'
JOIN Alm ON s.Grupo = alm.Almacen
GROUP BY
s.Empresa, s.Cuenta, s.Grupo,
a.Descripcion1, a.Descripcion2, a.Unidad, a.Tipo, a.PrecioLista, a.Impuesto1, a.Impuesto2, a.Impuesto3, ac.UltimoCosto, ac.UltimoCostoSinGastos, ac.CostoPromedio, a.CostoEstandar, a.CostoReposicion

