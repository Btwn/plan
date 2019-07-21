SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ArtSaldoUSinTarima

AS
SELECT
s.Empresa Empresa,
s.Cuenta Articulo,
s.Grupo Almacen,
s.SubGrupo Tarima,
SaldoU=s.SaldoU-ss.SaldoU
FROM SaldoU s
JOIN SaldoUWMSDisponible ss ON ss.Empresa=s.Empresa AND s.Sucursal=ss.Sucursal AND ss.Cuenta=s.Cuenta AND ss.Grupo=s.Grupo

