SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAbrirAnexo
@Modulo		varchar(5),
@ID			int

AS BEGIN
DECLARE
@Direccion		varchar(255)
SET @Direccion = NULL
IF @Modulo = 'VTAS'
BEGIN
SELECT TOP 1 @Direccion = a.Direccion
FROM Venta v
JOIN AnexoMov a
ON a.Rama = @Modulo
AND a.ID = v.ID
JOIN EmpresaCFD e
ON e.Empresa = v.Empresa
WHERE v.ID = @ID
AND a.CFD = 1
AND RIGHT(a.Direccion,4) = '.PDF'
AND ISNULL(e.MostrarAnexoPDF,0) = 1
END
ELSE
IF @Modulo = 'CXC'
BEGIN
SELECT TOP 1 @Direccion = a.Direccion
FROM Cxc c
JOIN AnexoMov a
ON a.Rama = @Modulo
AND a.ID = c.ID
JOIN EmpresaCFD e
ON e.Empresa = c.Empresa
WHERE c.ID = @ID
AND a.CFD = 1
AND RIGHT(a.Direccion,4) = '.PDF'
AND ISNULL(e.MostrarAnexoPDF,0) = 1
END
SELECT @Direccion
RETURN
END

