SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSInsertarPOSLCBAccionTemp
@Estacion           int

AS
BEGIN
DELETE POSLCBAccionTemp WHERE Estacion = @Estacion
INSERT POSLCBAccionTemp (
Estacion, Codigo, Accion, CodigoAnterior)
SELECT
@Estacion,Codigo, Accion, Codigo
FROM CB
WHERE  TipoCuenta = 'Accion'
INSERT POSLCBAccionTemp (
Estacion, Codigo, Accion, CodigoAnterior)
SELECT
@Estacion, NULL, Accion, NULL
FROM POSAccion
WHERE Accion NOT IN(SELECT Accion FROM  CB   WHERE  TipoCuenta = 'Accion')
END

