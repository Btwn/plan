SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spProvMesImportar

AS
BEGIN
INSERT INTO ProvMes(Proveedor, RazonSocial, NombreComercial, Direccion1,
Direccion2, Poblacion, Provincia, CodigoPostal, CodigoPais, CIFDNI,
FormaPago, TipoDocumento, DefMoneda, Idioma, CodigoPortes, DiaPago1,
DiaPago2, DiaPago3, Cuenta, SubCuenta, EstatusIntelIMES)
SELECT p.Proveedor, p.Nombre, p.Nombre, RTRIM(ISNULL(Direccion, '')) + ' ' + RTRIM(ISNULL(DireccionNumero, '')) + ' ' + RTRIM(ISNULL(DireccionNumeroInt, '')),
p.Colonia, RTRIM(ISNULL(Delegacion, '')) + ' ' + RTRIM(ISNULL(Poblacion, '')), p.Estado, p.CodigoPostal, p.Pais, p.RFC,
'(NONE)', '', (SELECT m.Moneda FROM MonMes m WHERE m.Descripcion = p.DefMoneda), '', '', NULL,
NULL, NULL, p.Cuenta, '', 0
FROM Prov p
WHERE p.Proveedor IN (SELECT pr.Proveedor
FROM Prov pr
LEFT OUTER JOIN ProvMES pm ON pr.Proveedor = pm.Proveedor
GROUP BY pr.Proveedor, pm.Proveedor
HAVING pm.Proveedor IS NULL)
SELECT 'Proceso Concluido'
RETURN
END

