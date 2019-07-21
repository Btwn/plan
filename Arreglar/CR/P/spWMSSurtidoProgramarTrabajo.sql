SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spWMSSurtidoProgramarTrabajo
@Estacion		int

AS
BEGIN
DELETE WMSSurtidoProcesarTrabajo
INSERT INTO WMSSurtidoProcesarTrabajo(
Modulo,   ModuloID)
SELECT l.Modulo, l.ID
FROM ListaModuloID l
JOIN WMSSurtidoPosicionTrabajo ON l.Modulo = WMSSurtidoPosicionTrabajo.Modulo AND l.ID = WMSSurtidoPosicionTrabajo.ModuloID
WHERE l.Estacion = @Estacion
SELECT 'Proceso Concluido.'
END

