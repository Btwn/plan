SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgeDocAC ON eDoc

FOR UPDATE, INSERT
AS BEGIN
DECLARE
@eDocA					varchar(50),
@eDocN					varchar(50),
@ModuloA				varchar(5),
@ModuloN				varchar(5),
@UltimoCambioA			datetime,
@UltimaCompilacionA		datetime,
@UltimoCambioN			datetime,
@UltimaCompilacionN		datetime
SELECT @eDocA = NULLIF(RTRIM(eDoc), ''), @ModuloA = NULLIF(RTRIM(Modulo), ''), @UltimoCambioA = NULLIF(UltimoCambio, ''), @UltimaCompilacionA = NULLIF(UltimaCompilacion, '') FROM Deleted
SELECT @eDocN = NULLIF(RTRIM(eDoc), ''), @ModuloN = NULLIF(RTRIM(Modulo), ''), @UltimoCambioN = NULLIF(UltimoCambio, ''), @UltimaCompilacionN = NULLIF(UltimaCompilacion, '') FROM Inserted
IF @UltimoCambioA = @UltimoCambioN AND @UltimaCompilacionA = @UltimaCompilacionN
BEGIN
UPDATE eDoc SET UltimoCambio = GETDATE() WHERE eDoc = @eDocN AND Modulo = @ModuloN
END
END

