SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW gNotaCobro
 AS
SELECT
ID,
Importe1,
Importe2,
Importe3,
Importe4,
Importe5,
FormaCobro1,
FormaCobro2,
FormaCobro3,
FormaCobro4,
FormaCobro5,
Referencia1,
Referencia2,
Referencia3,
Referencia4,
Referencia5,
Observaciones1,
Observaciones2,
Observaciones3,
Observaciones4,
Observaciones5,
Cambio,
Redondeo,
DelEfectivo,
Sucursal,
CtaDinero,
Cajero,
Condicion,
Vencimiento,
Actualizado,
TotalCobrado,
SucursalOrigen
FROM NotaCobro
UNION ALL
SELECT
ID,
Importe1,
Importe2,
Importe3,
Importe4,
Importe5,
FormaCobro1,
FormaCobro2,
FormaCobro3,
FormaCobro4,
FormaCobro5,
Referencia1,
Referencia2,
Referencia3,
Referencia4,
Referencia5,
Observaciones1,
Observaciones2,
Observaciones3,
Observaciones4,
Observaciones5,
Cambio,
Redondeo,
DelEfectivo,
Sucursal,
CtaDinero,
Cajero,
Condicion,
Vencimiento,
Actualizado,
TotalCobrado,
SucursalOrigen
FROM hNotaCobro
;

