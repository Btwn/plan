SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgRHB ON RH

FOR DELETE
AS BEGIN
DECLARE
@ID		int,
@Estatus 	char(15),
@Mensaje	char(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ID = ID, @Estatus = Estatus FROM Deleted
IF @Estatus IS NOT NULL AND @Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR')
BEGIN
SELECT @Mensaje = Descripcion FROM MensajeLista WHERE Mensaje = 60090
RAISERROR (@Mensaje,16,-1)
END ELSE
EXEC spMovAlEliminar 'RH', @ID
END

