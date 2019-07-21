SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ArtExistenciaTarima

AS
SELECT
s.Empresa Empresa,
s.Cuenta Articulo,
s.Grupo Almacen,
s.SubGrupo Tarima,
Sum(s.SaldoU*r.Factor) Existencia
FROM SaldoUWMS s
JOIN Rama r ON s.Rama=r.Rama
WHERE r.Mayor IN ('WMS','PZA') and r.Rama <> 'RESV' 
GROUP BY
s.Empresa, s.Cuenta, s.Grupo, s.SubGrupo

