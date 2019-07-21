SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSAsignaPosicion @Posicion	varchar(20), @Estacion	int

AS BEGIN
UPDATE WMSSurtidoProcesarD SET PosicionDestino = @Posicion WHERE WMSSurtidoProcesarD.Procesado = 0 AND WMSSurtidoProcesarD.Estacion = @Estacion
RETURN
END

