SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spOportunidadAgenteLista

AS
BEGIN
DECLARE @ListaAgente TABLE(Agente varchar(10), Nombre varchar(100))
INSERT INTO @ListaAgente(Agente, Nombre) VALUES('(Todos)', '(Todos)')
INSERT INTO @ListaAgente SELECT Agente, Nombre FROM Agente WHERE Estatus='ALTA'
SELECT Agente, Nombre FROM @ListaAgente
RETURN
END

