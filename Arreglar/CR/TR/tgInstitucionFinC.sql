SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgInstitucionFinC ON InstitucionFin

FOR UPDATE
AS BEGIN
DECLARE
@InstitucionN	varchar(20),
@InstitucionA	varchar(20)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @InstitucionN = Institucion FROM Inserted
SELECT @InstitucionA = Institucion FROM Deleted
IF @InstitucionN <> @InstitucionA
BEGIN
UPDATE MensajeInstitucion     SET Institucion = @InstitucionN WHERE Institucion = @InstitucionA
UPDATE InstitucionFinConcepto SET Institucion = @InstitucionN WHERE Institucion = @InstitucionA
END
END

