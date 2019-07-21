SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW VerPC

AS
SELECT e.ID, e.Empresa, e.Mov, e.MovID, e.FechaEmision, e.Moneda, e.Estatus, e.ListaModificar, e.FechaInicio, e.FechaTermino,  d.Renglon, d.Articulo, d.Anterior, d.Nuevo,
"Diferencia" = CONVERT(money, d.Nuevo-d.Anterior),
"Porcentaje" = CONVERT(float, ((d.Nuevo/d.Anterior)-1)*100),
"EstatusPrecio" = CONVERT(char(15), CASE WHEN d.Nuevo > d.Anterior THEN 'SUBIO' WHEN d.Nuevo < d.Anterior THEN 'BAJO' ELSE 'SINCAMBIO' END)
FROM PC e
JOIN PCD d ON e.ID = d.ID

