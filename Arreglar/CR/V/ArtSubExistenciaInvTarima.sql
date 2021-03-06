SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ArtSubExistenciaInvTarima

AS
SELECT
Sucursal,
Empresa,
Cuenta Articulo,
SubCuenta,
Grupo Almacen,
SubGrupo Tarima,
"Llave" = RTRIM(Cuenta)+CHAR(9)+ISNULL(RTRIM(SubCuenta), ''),
Sum(SaldoU) Inventario
FROM
SaldoUWMS
WHERE
Rama = 'WMS'
GROUP BY
Sucursal, Empresa, Cuenta, SubCuenta, Grupo, SubGrupo

