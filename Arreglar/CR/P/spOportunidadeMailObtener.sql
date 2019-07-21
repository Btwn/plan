SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spOportunidadeMailObtener
@EstacionTrabajo	int,
@ID					int

AS
BEGIN
DECLARE @Mov			varchar(20),
@MovTipo		varchar(20)
DELETE OportunidadeMailEnviar WHERE EstacionTrabajo = @EstacionTrabajo
SELECT @Mov = Oportunidad.Mov, @MovTipo = MovTipo.Clave FROM Oportunidad JOIN MovTipo ON Oportunidad.Mov = MovTipo.Mov AND MovTipo.Modulo = 'OPORT' WHERE ID = @ID
IF @MovTipo = 'OPORT.G'
BEGIN
INSERT INTO OportunidadeMailEnviar(
EstacionTrabajo, ContactoTipo, Cliente,  ID,		  Enviar)
SELECT @EstacionTrabajo, OportunidadD.Tipo,    Contacto, CteCto.ID, 0
FROM CteCto
JOIN OportunidadD ON CteCto.Cliente = OportunidadD.Contacto
WHERE OportunidadD.ID = @ID
AND ISNULL(OPORTEnviar, 0) = 1
END
ELSE IF @MovTipo = 'OPORT.O'
BEGIN
INSERT INTO OportunidadeMailEnviar(
EstacionTrabajo, ContactoTipo,     Cliente,  ID,		  Enviar)
SELECT @EstacionTrabajo, Oportunidad.ContactoTipo, Contacto, CteCto.ID, 0
FROM CteCto
JOIN Oportunidad ON CteCto.Cliente = Oportunidad.Contacto
WHERE Oportunidad.ID = @ID
AND ISNULL(OPORTEnviar, 0) = 1
END
RETURN
END

