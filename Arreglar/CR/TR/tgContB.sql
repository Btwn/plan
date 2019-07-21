SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgContB ON Cont

FOR DELETE
AS BEGIN
DECLARE
@ID		int,
@Empresa	varchar(5),
@Mov	varchar(20),
@MovID	varchar(20),
@Estatus 	varchar(15),
@OrigenTipo	varchar(10),
@Origen	varchar(20),
@OrigenID	varchar(20),
@Mensaje	varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ID = ID, @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @OrigenTipo = NULLIF(RTRIM(OrigenTipo), ''), @Origen = NULLIF(RTRIM(Origen), ''), @OrigenID = OrigenID FROM Deleted
IF @Estatus IS NOT NULL AND @Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR')
BEGIN
SELECT @Mensaje = Descripcion FROM MensajeLista WHERE Mensaje = 60090
RAISERROR (@Mensaje,16,-1)
END ELSE
BEGIN
IF @OrigenTipo IS NOT NULL AND @Origen IS NOT NULL
EXEC spLigarMovCont 'CANCELAR', @Empresa, @OrigenTipo, @Origen, @OrigenID, @ID, @Mov, @MovID
EXEC spMovAlEliminar 'CONT', @ID
END
END

