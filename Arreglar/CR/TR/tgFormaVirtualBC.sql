SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgFormaVirtualBC ON FormaVirtual

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@FormaVirtualN	varchar(100),
@FormaVirtualA	varchar(100)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @FormaVirtualN = FormaVirtual FROM Inserted
SELECT @FormaVirtualA = FormaVirtual FROM Deleted
IF @FormaVirtualA = @FormaVirtualN RETURN
IF @FormaVirtualN IS NULL
BEGIN
DELETE FormaVirtualCarpeta WHERE FormaVirtual = @FormaVirtualA
DELETE FormaVirtualCampo   WHERE FormaVirtual = @FormaVirtualA
DELETE FormaVirtualAccion  WHERE FormaVirtual = @FormaVirtualA
END ELSE
BEGIN
UPDATE FormaVirtualCarpeta SET FormaVirtual = @FormaVirtualN WHERE FormaVirtual = @FormaVirtualA
UPDATE FormaVirtualCampo   SET FormaVirtual = @FormaVirtualN WHERE FormaVirtual = @FormaVirtualA
UPDATE FormaVirtualAccion  SET FormaVirtual = @FormaVirtualN WHERE FormaVirtual = @FormaVirtualA
END
END

