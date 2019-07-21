SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.vwSucursalPNet
AS
SELECT	E.Empresa, S.Sucursal, ISNULL(PN.Nombre, S.Nombre) Nombre, ISNULL(PN.Telefonos, S.Telefonos) Telefonos,
ISNULL(PN.Direccion, ISNULL(S.Direccion, '')) Direccion, PN.ImagenPath, PN.Email, PN.MapaLatitud,
PN.MapaLongitud, PN.MapaPrecision, PN.Estatus, CASE WHEN E.Empresa = PN.Empresa THEN 1 ELSE 0 END Asignada
FROM (SELECT	S.Sucursal, S.Nombre, S.Telefonos,
ISNULL(S.Direccion, '') + ISNULL(' ' + S.DireccionNumero, '') + ISNULL(' ' + S.DireccionNumeroInt, '') + ISNULL(S.Colonia, '') + ISNULL(', ' + S.Delegacion, '') + ISNULL(', ' + S.Estado, '') + ISNULL(', CP. ' + S.CodigoPostal, '') Direccion
FROM	Sucursal S
WHERE	S.Estatus = 'ALTA') AS S
CROSS	JOIN vwEmpresaCfgPNet E
LEFT	JOIN pNetSucursal PN ON S.Sucursal = PN.Sucursal AND E.Empresa = PN.Empresa

