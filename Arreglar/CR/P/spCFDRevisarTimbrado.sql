SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDRevisarTimbrado
@Empresa	varchar(5),
@Mov		varchar(20),
@ID		int,
@Modulo		char(5) = 'VTAS'

AS BEGIN
DECLARE @Timbrado bit
SELECT @Timbrado = 1
IF (((SELECT ISNULL(CFD, 0) FROM Empresa WHERE Empresa = @Empresa) = 1) AND
((SELECT ISNULL(CFD, 0) FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov) = 1)) OR
(((SELECT ISNULL(CFDFlex, 0) FROM EmpresaGral WHERE Empresa = @Empresa) = 1) AND
((SELECT ISNULL(CFDFlex, 0) FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov) = 1)) BEGIN
SELECT @Timbrado = 0
IF EXISTS (SELECT * FROM CFD WHERE Modulo = @Modulo AND ModuloID = @ID)
SELECT @Timbrado = Timbrado FROM CFD WHERE Modulo = @Modulo AND ModuloID = @ID
END
SELECT "Timbrado" = @Timbrado
RETURN
END

