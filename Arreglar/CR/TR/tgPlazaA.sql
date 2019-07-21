SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgPlazaA ON Plaza
FOR UPDATE, INSERT
AS BEGIN
DECLARE
@PlazaN			varchar(20),
@PlazaA			varchar(20),
@Estatus		varchar(15),
@Rama			varchar(20),
@Personal		varchar(10),
@Mensaje		varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @PlazaN = RTRIM(Plaza), @Estatus = RTRIM(Estatus), @Rama = RTRIM(Rama), @Personal = NULLIF(RTRIM(Personal), '')
FROM Inserted
SELECT @PlazaA = RTRIM(Plaza)
FROM Deleted
IF @PlazaN is not NULL AND @PlazaA is null
BEGIN
IF @Rama = ''
UPDATE Plaza SET Rama = NULL WHERE Plaza = @PlazaN
END
IF @PlazaN is not NULL AND @PlazaA is not null AND @Estatus = 'BAJA' AND @Personal is not null
BEGIN
SELECT @Mensaje = 'No se puede dar de Baja la Plaza ' + RTRIM(@PlazaN) + '. Tiene Asignada una Persona'
RAISERROR (@Mensaje, 16, -1)
END
RETURN
END

