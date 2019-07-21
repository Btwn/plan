SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spSincroISActualizaEstatusPaqueteDropBox
@Conversacion		uniqueidentifier,
@ID					int

AS
BEGIN
UPDATE SincroISDropBoxPaquete SET Estatus = 'RECIBIDO' WHERE IntelisisServiceID = @ID AND Conversacion = @Conversacion
IF NOT EXISTS(SELECT RID FROM SincroISDropBoxPaquete WHERE Conversacion = @Conversacion AND Estatus = 'PENDIENTE')
UPDATE IntelisisService SET Estatus = 'SINPROCESAR' WHERE Conversacion = @Conversacion AND Estatus = 'RECIBIDO'
END

