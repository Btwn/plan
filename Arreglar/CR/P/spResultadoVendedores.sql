SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spResultadoVendedores
@Empresa varchar(5),
@Agente  varchar(10),
@Moneda  varchar(10),
@ArtCat  varchar(50),
@FechaD  datetime,
@FechaA  datetime

AS BEGIN
IF @Agente IN ('Todos', '(Todos)', 'Todas', '(Todas)', '') SELECT @Agente = NULL
IF @ArtCat IN ('Todos', '(Todos)', 'Todas', '(Todas)', '') SELECT @ArtCat = NULL
SELECT v.Agente, a.Categoria, ISNULL(ao.Importe,0) Objetivo, SUM(v.Importe) Venta,
Porcentaje = CASE WHEN ISNULL(ao.Importe,0) = 0 THEN 0
ELSE SUM(v.Importe)/ISNULL(ao.Importe,0) END
FROM Venta v
JOIN MovTipo mt ON 'VTAS' = mt.Modulo AND v.Mov = mt.Mov
JOIN VentaD vd ON v.ID = vd.ID
JOIN Art a ON vd.Articulo = a.Articulo
LEFT JOIN AgenteObjetivos ao ON v.Agente = ao.Agente AND a.Categoria = ao.ArtCat AND v.Moneda = ao.Moneda
WHERE mt.Clave ='VTAS.F'
AND v.Estatus = 'CONCLUIDO'
AND v.Moneda = @Moneda
AND v.Agente = ISNULL(@Agente, v.Agente)
AND a.Categoria = ISNULL(@ArtCat, a.Categoria)
AND v.FechaEmision BETWEEN @FechaD AND @FechaA
GROUP BY v.Agente, a.Categoria, ao.Importe
RETURN
END

