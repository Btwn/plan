SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgUnidadBC ON Unidad

FOR UPDATE, DELETE, INSERT
AS BEGIN
DECLARE
@UnidadN  	varchar(50),
@UnidadA	varchar(50),
@Mensaje	varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @UnidadN = Unidad FROM Inserted
SELECT @UnidadA = Unidad FROM Deleted
IF @UnidadN = @UnidadA RETURN
IF @UnidadN IS NULL AND
EXISTS(SELECT * FROM UnidadConversion WHERE Unidad = @UnidadA OR Conversion = @UnidadA)
BEGIN
SELECT @Mensaje = '"'+LTRIM(RTRIM(@UnidadA))+ '" ' + Descripcion FROM MensajeLista WHERE Mensaje = 30155
RAISERROR (@Mensaje,16,-1)
END ELSE
IF @UnidadA IS NOT NULL
BEGIN
UPDATE UnidadConversion SET Unidad = @UnidadN WHERE Unidad = @UnidadA
UPDATE UnidadConversion SET Conversion = @UnidadN WHERE Conversion = @UnidadA
END
END

