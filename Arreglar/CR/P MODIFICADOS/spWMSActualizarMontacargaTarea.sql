SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSActualizarMontacargaTarea
@Estacion		int

AS BEGIN
DECLARE
@IDLista		int,
@ID				int,
@Renglon		float,
@Montacarga		varchar(20),
@Prioridad		varchar(20),
@SubClave		varchar(20),
@PosicionDestino	varchar(10)
DECLARE crLista CURSOR FOR
SELECT ID
FROM ListaID WITH(NOLOCK)
WHERE Estacion = @Estacion
OPEN crLista
FETCH NEXT FROM crLista INTO @IDLista
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @ID			= ID,
@Renglon		= Renglon,
@Montacarga	= Montacarga,
@Prioridad	= Prioridad,
@PosicionDestino = PosicionDestino
FROM WMSMontacargaTarea WITH(NOLOCK)
WHERE IDLista = @IDLista
UPDATE TMAD WITH(ROWLOCK)
SET Montacarga	= @Montacarga,
Prioridad	= @Prioridad,
PosicionDestino = @PosicionDestino
WHERE ID = @ID
AND 1 = CASE WHEN (@Renglon = 0) OR (@Renglon <> 0 AND Renglon = @Renglon) THEN 1 ELSE 0 END
UPDATE TMA WITH(ROWLOCK)
SET Agente	= @Montacarga
WHERE ID = @ID
FETCH NEXT FROM crLista INTO @IDLista
END
CLOSE crLista
DEALLOCATE crLista
RETURN
END

