SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCampoExtraBC ON CampoExtra

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@CampoExtraN  varchar(50),
@CampoExtraA  varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @CampoExtraN = CampoExtra FROM Inserted
SELECT @CampoExtraA = CampoExtra FROM Deleted
IF @CampoExtraA = @CampoExtraN RETURN
IF EXISTS(SELECT * FROM MovCampoExtra WHERE CampoExtra = @CampoExtraA) OR EXISTS(SELECT * FROM CtoCampoExtra WHERE CampoExtra = @CampoExtraA)
BEGIN
RAISERROR ('Campo Extra en Uso',16,-1)
RETURN
END
IF @CampoExtraN IS NULL
BEGIN
DELETE MovTipoCampoExtra    WHERE CampoExtra = @CampoExtraA
DELETE CtoTipoCampoExtra    WHERE CampoExtra = @CampoExtraA
DELETE CampoExtraAyudaLista WHERE CampoExtra = @CampoExtraA
END ELSE
BEGIN
UPDATE MovTipoCampoExtra    SET CampoExtra = @CampoExtraN WHERE CampoExtra = @CampoExtraA
UPDATE CtoTipoCampoExtra    SET CampoExtra = @CampoExtraN WHERE CampoExtra = @CampoExtraA
UPDATE CampoExtraAyudaLista SET CampoExtra = @CampoExtraN WHERE CampoExtra = @CampoExtraA
END
END

