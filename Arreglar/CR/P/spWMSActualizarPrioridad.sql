SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSActualizarPrioridad
@Estacion		int,
@Prioridad		varchar(20)

AS BEGIN
UPDATE WMSMontacargaTarea SET Prioridad = @Prioridad WHERE Estacion = @Estacion AND IDLista IN(SELECT ID FROM ListaID WHERE Estacion = @Estacion)
END

