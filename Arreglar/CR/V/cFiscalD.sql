SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW cFiscalD

AS
SELECT
ID,
Renglon,
ObligacionFiscal,
TipoImpuesto,
Importe,
OtrosImpuestos,
Tasa,
Excento,
Deducible,
OrigenModulo,
OrigenModuloID,
AFArticulo,
AFSerie,
Contacto,
ContactoTipo,
/*  DebeFiscal,
HaberFiscal,
*/
Sucursal,
SucursalOrigen
FROM
FiscalD

