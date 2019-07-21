SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW SerieLoteConsignacionAuxV
AS
SELECT
CorteID,
Modulo,
dbo.fnModuloNombre(Modulo) ModuloNombre,
ModuloID,
dbo.fnSerieLoteConsignacionMov(Modulo,ModuloID) Mov,
dbo.fnSerieLoteConsignacionMovID(Modulo,ModuloID) MovID,
Fecha,
Articulo,
SubCuenta,
SerieLote,
CargoU Cargo,
AbonoU Abono
FROM
SerieLoteConsignacionAux

