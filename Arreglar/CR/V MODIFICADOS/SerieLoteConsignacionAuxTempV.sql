SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW SerieLoteConsignacionAuxTempV
AS
SELECT
Estacion,
ModuloID CorteID,
Modulo,
dbo.fnModuloNombre(MModulo) ModuloNombre,
MModuloID ModuloID,
dbo.fnSerieLoteConsignacionMov(MModulo,MModuloID) Mov,
dbo.fnSerieLoteConsignacionMovID(MModulo,MModuloID) MovID,
Fecha,
Articulo,
SubCuenta,
SerieLote,
CargoU Cargo,
AbonoU Abono
FROM SerieLoteConsignacionAuxTemp WITH(NOLOCK)
WHERE NULLIF(CorteID,0) IS NULL

