SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgEntidadBC ON Entidad

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@EntidadN  varchar(20),
@EntidadA	varchar(20)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @EntidadN = Entidad FROM Inserted
SELECT @EntidadA = Entidad FROM Deleted
IF @EntidadN = @EntidadA RETURN
IF @EntidadN IS NULL
BEGIN
DELETE EntidadCuenta	WHERE Entidad = @EntidadA
DELETE EntidadRelacion	WHERE Entidad = @EntidadA
DELETE EntidadPosicion	WHERE Entidad = @EntidadA
END ELSE
IF @EntidadA IS NOT NULL
BEGIN
UPDATE EntidadCuenta	SET Entidad = @EntidadN WHERE Entidad = @EntidadA
UPDATE EntidadRelacion	SET Entidad = @EntidadN WHERE Entidad = @EntidadA
UPDATE EntidadPosicion	SET Entidad = @EntidadN WHERE Entidad = @EntidadA
END
END

