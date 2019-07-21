SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSActualizarCBAccion
@Estacion           int

AS
BEGIN
IF EXISTS(SELECT * FROM POSLCBAccionTemp WITH (NOLOCK) WHERE CodigoAnterior IS NOT NULL AND Codigo <> CodigoAnterior AND NULLIF(Codigo,'') IS NOT NULL AND Estacion = @Estacion)
BEGIN
UPDATE CB WITH (ROWLOCK) SET Codigo = a.Codigo
FROM POSLCBAccionTemp a WITH (NOLOCK) JOIN CB c  ON  a.Accion = c.Accion AND c.Codigo = a.CodigoAnterior AND c.TipoCuenta = 'Accion'
WHERE a.CodigoAnterior IS NOT NULL AND a.Codigo <> a.CodigoAnterior AND NULLIF(a.Codigo,'') IS NOT NULL AND  a.Estacion = @Estacion
END
IF EXISTS(SELECT * FROM POSLCBAccionTemp WITH (NOLOCK) WHERE CodigoAnterior IS NOT NULL AND Codigo <> CodigoAnterior AND NULLIF(Codigo,'') IS  NULL AND Estacion = @Estacion)
BEGIN
DELETE CB  WHERE Codigo IN(SELECT CodigoAnterior FROM POSLCBAccionTemp WITH (NOLOCK)
WHERE CodigoAnterior IS NOT NULL AND Codigo <> CodigoAnterior AND NULLIF(Codigo,'') IS  NULL AND Estacion = @Estacion)
END
IF EXISTS (SELECT * FROM POSLCBAccionTemp WITH (NOLOCK) WHERE CodigoAnterior IS NULL AND NULLIF(Codigo,'') IS NOT NULL AND Estacion = @Estacion)
BEGIN
INSERT CB(
Codigo, TipoCuenta, Accion)
SELECT
Codigo, 'Accion', Accion
FROM POSLCBAccionTemp WITH (NOLOCK)
WHERE CodigoAnterior IS NULL AND Codigo IS NOT NULL AND Estacion = @Estacion
END
END

