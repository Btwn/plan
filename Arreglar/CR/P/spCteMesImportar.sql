SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCteMesImportar

AS
BEGIN
INSERT INTO CteMES(Cliente, RazonSocial, NombreComercial, Direccion1, Direccion2,
Poblacion, Provincia, CodigoPostal, Pais, CIFDNI, FormaPago,
TipoDocumento, CodigoMoneda, Idioma, CodigoPortes, DiaPago1,
DiaPago2, DiaPago3, Cuenta, SubCuenta, EstatusIntelIMES)
SELECT c.Cliente, c.Nombre, c.Nombre, RTRIM(ISNULL(Direccion, '')) + ' ' + RTRIM(ISNULL(DireccionNumero, '')) + ' ' + RTRIM(ISNULL(DireccionNumeroInt, '')), c.Colonia,
RTRIM(ISNULL(Delegacion, '')) + ' ' + RTRIM(ISNULL(Poblacion, '')), c.Estado, c.CodigoPostal, c.Pais, c.RFC, c.Condicion,
'', (SELECT m.Moneda FROM MonMes m WHERE m.Descripcion = c.DefMoneda), '', '', NULL,
NULL, NULL, c.Cuenta, '', 0
FROM Cte c
WHERE c.Cliente IN (SELECT c2.Cliente
FROM Cte c2
LEFT OUTER JOIN CteMES cm ON c2.Cliente = cm.Cliente
GROUP BY c2.Cliente, cm.Cliente
HAVING cm.Cliente IS NULL)
SELECT 'Proceso Concluido'
RETURN
END

