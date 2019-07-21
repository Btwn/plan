SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW TMAPendiente

AS
SELECT
td.Tarima,
t.Mov,
t.MovID,
adt.Articulo,
td.CantidadPicking,
td.Almacen,
td.Renglon,
0 RenglonID,
t.Agente,
t.ID,
td.Posicion Posicion,
td.PosicionDestino PosicionDestino,
ap.Zona Zona
FROM TMA t
JOIN TMAD td ON t.ID = td.ID
JOIN MovTipo mt ON t.Mov = mt.Mov AND 'TMA' = mt.Modulo AND 'TMA.TSUR' = mt.Clave
JOIN AlmPos ap ON td.Almacen = ap.Almacen AND td.Posicion = ap.Posicion AND ap.Tipo = 'DOMICILIO'
JOIN ArtDisponibleTarima adt ON td.Almacen = adt.Almacen AND td.Tarima = adt.Tarima
WHERE t.Estatus = 'PENDIENTE' AND ISNULL(td.Procesado,0) = 0

