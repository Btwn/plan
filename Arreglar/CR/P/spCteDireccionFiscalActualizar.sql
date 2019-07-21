SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCteDireccionFiscalActualizar

AS BEGIN
INSERT INTO CteDireccionFiscal(Cliente, Icono, Mapeado)
SELECT c.Cliente, 435, 0
FROM Cte c LEFT JOIN CteDireccionFiscal cd ON c.Cliente = cd.Cliente
WHERE cd.Cliente IS NULL
INSERT INTO CteEnviarADireccionFiscal(Cliente, ID, Icono, Mapeado)
SELECT c.Cliente, c.ID, 435, 0
FROM CteEnviarA c LEFT JOIN CteEnviarADireccionFiscal cd ON c.Cliente = cd.Cliente AND c.ID = cd.ID
WHERE cd.Cliente IS NULL
RETURN
END

