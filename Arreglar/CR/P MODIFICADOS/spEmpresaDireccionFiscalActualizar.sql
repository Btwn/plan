SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spEmpresaDireccionFiscalActualizar

AS BEGIN
INSERT INTO EmpresaDireccionFiscal(Empresa, Icono, Mapeado)
SELECT e.Empresa, 435, 0
FROM Empresa e WITH (NOLOCK) LEFT JOIN EmpresaDireccionFiscal ed WITH (NOLOCK) ON e.Empresa = ed.Empresa
WHERE ed.Empresa IS NULL
RETURN
END

