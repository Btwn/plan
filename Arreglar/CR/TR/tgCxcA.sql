SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCxcA ON Cxc

FOR INSERT
AS BEGIN
IF dbo.fnEstaSincronizando() = 1 RETURN
INSERT CxcPersonalCobradorLog (ID, Fecha, PersonalCobrador)
SELECT ID, GETDATE(), PersonalCobrador FROM Inserted WHERE NULLIF(RTRIM(PersonalCobrador), '') IS NOT NULL
END

