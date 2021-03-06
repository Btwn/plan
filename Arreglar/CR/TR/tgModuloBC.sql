SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgModuloBC ON Modulo

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@ModuloN  	char(5),
@ModuloA	char(5)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ModuloN = Modulo FROM Inserted
SELECT @ModuloA = Modulo FROM Deleted
IF @ModuloN = @ModuloA RETURN
IF @ModuloN IS NULL
DELETE SubModulo WHERE Modulo = @ModuloA
ELSE BEGIN
UPDATE SubModulo SET Modulo = @ModuloN WHERE Modulo = @ModuloA
END
END

