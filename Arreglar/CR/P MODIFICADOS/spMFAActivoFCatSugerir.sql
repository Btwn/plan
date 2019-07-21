SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spMFAActivoFCatSugerir

AS BEGIN
DELETE MFAActivoFCat
INSERT INTO MFAActivoFCat(Categoria) SELECT Categoria FROM ActivoFCat WITH (NOLOCK)
RETURN
END

