SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW Movil_Cliente AS
SELECT
Cliente,
Nombre,
RFC,
AlmacenDef,
'' AS NombreSucursal,
Categoria,
Grupo,
Familia,
Tipo,
Direccion,
DireccionNumero,
DireccionNumeroInt,
EntreCalles,
Observaciones,
Delegacion,
Colonia,
CodigoPostal,
Poblacion,
Estado,
Telefonos,
Contacto1,
Contacto2,
Extencion1,
Extencion2,
eMail1,
eMail2,
Descuento,
ZonaImpuesto,
MapaLatitud,
MapaLongitud,
MapaPrecision,
0 AS Saldo,
CreditoLimite
FROM Cte WITH(NOLOCK)

