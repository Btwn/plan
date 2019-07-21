SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgAgenteBC ON Agente

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@ClaveNueva  	varchar(10),
@ClaveAnterior	varchar(10),
@NombreNuevo	varchar(100),
@NombreAnterior	varchar(100),
@RFCNuevo		varchar(20),
@RFCAnterior	varchar(20),
@CURPNuevo		varchar(30),
@CURPAnterior	varchar(30),
@Mensaje 		varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ClaveNueva    = Agente, @NombreNuevo    = Nombre, @RFCNuevo    = RFC, @CURPNuevo    = CURP FROM Inserted
SELECT @ClaveAnterior = Agente, @NombreAnterior = Nombre, @RFCAnterior = RFC, @CURPAnterior = CURP FROM Deleted
/*IF @NombreNuevo <> @NombreAnterior OR @RFCNuevo <> @RFCAnterior OR @CURPNuevo <> @CURPAnterior*/
IF @ClaveNueva=@ClaveAnterior RETURN
IF @ClaveNueva IS NULL
BEGIN
DELETE AgenteActividad WHERE Agente = @ClaveAnterior
DELETE AgenteCte       WHERE Agente = @ClaveAnterior
DELETE AgentePersonal  WHERE Agente = @ClaveAnterior
DELETE AgenteAgenda    WHERE Agente = @ClaveAnterior
DELETE EquipoAgente    WHERE Equipo = @ClaveAnterior OR Agente = @ClaveAnterior
DELETE AgenteComisionTipoFactura WHERE Agente = @ClaveAnterior
DELETE Prop            WHERE Cuenta = @ClaveAnterior AND Rama='AGENT'
DELETE ListaD	   WHERE Cuenta = @ClaveAnterior AND Rama='AGENT'
DELETE AnexoCta        WHERE Cuenta = @ClaveAnterior AND Rama='AGENT'
DELETE CuentaTarea     WHERE Cuenta = @ClaveAnterior AND Rama='AGENT'
DELETE CtoCampoExtra WHERE Tipo = 'Agente' AND Clave = @ClaveAnterior
DELETE FormaExtraValor WHERE Aplica = 'Agente' AND AplicaClave = @ClaveAnterior
DELETE FormaExtraD WHERE Aplica = 'Agente' AND AplicaClave = @ClaveAnterior
END ELSE
IF @ClaveNueva <> @ClaveAnterior
BEGIN
UPDATE AgenteActividad SET Agente = @ClaveNueva WHERE Agente = @ClaveAnterior
UPDATE AgenteCte       SET Agente = @ClaveNueva WHERE Agente = @ClaveAnterior
UPDATE AgentePersonal  SET Agente = @ClaveNueva WHERE Agente = @ClaveAnterior
UPDATE AgenteAgenda    SET Agente = @ClaveNueva WHERE Agente = @ClaveAnterior
UPDATE EquipoAgente    SET Agente = @ClaveNueva WHERE Agente = @ClaveAnterior
UPDATE EquipoAgente    SET Equipo = @ClaveNueva WHERE Equipo = @ClaveAnterior
UPDATE AgenteComisionTipoFactura SET Agente = @ClaveNueva WHERE Agente = @ClaveAnterior
UPDATE Prop            SET Cuenta = @ClaveNueva WHERE Cuenta = @ClaveAnterior AND Rama='AGENT'
UPDATE ListaD          SET Cuenta = @ClaveNueva WHERE Cuenta = @ClaveAnterior AND Rama='AGENT'
UPDATE AnexoCta        SET Cuenta = @ClaveNueva WHERE Cuenta = @ClaveAnterior AND Rama='AGENT'
UPDATE CuentaTarea     SET Cuenta = @ClaveNueva WHERE Cuenta = @ClaveAnterior AND Rama='AGENT'
UPDATE CtoCampoExtra   SET Clave		= @ClaveNueva WHERE Clave   = @ClaveAnterior AND Tipo='Agente'
UPDATE FormaExtraValor SET AplicaClave  = @ClaveNueva WHERE AplicaClave   = @ClaveAnterior AND Aplica='Agente'
UPDATE FormaExtraD	   SET AplicaClave  = @ClaveNueva WHERE AplicaClave   = @ClaveAnterior AND Aplica='Agente'
END
END

