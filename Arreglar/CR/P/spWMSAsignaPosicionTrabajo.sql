SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spWMSAsignaPosicionTrabajo
@Posicion		varchar(20),
@Estacion		int

AS
BEGIN
DELETE WMSSurtidoPosicionTrabajo
FROM WMSSurtidoPosicionTrabajo
JOIN ListaModuloID ON WMSSurtidoPosicionTrabajo.Modulo = ListaModuloID.Modulo AND WMSSurtidoPosicionTrabajo.ModuloID = ListaModuloID.ID
WHERE Estacion = @Estacion
INSERT INTO WMSSurtidoPosicionTrabajo SELECT Modulo, ID, @Posicion FROM ListaModuloID WHERE Estacion = @Estacion
END

