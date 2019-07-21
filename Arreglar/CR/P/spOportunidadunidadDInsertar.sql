SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spOportunidadunidadDInsertar
@ID			int,
@Plantilla	varchar(50),
@Usuario	varchar(10),
@Ok			int			 = NULL OUTPUT,
@OkRef		varchar(255) = NULL OUTPUT

AS
BEGIN
INSERT INTO OportunidadD(
ID,   Renglon,   RenglonSub,   RenglonID,   Tipo,   RenglonTipo,   Clave, Recurso,                                                      Estado)
SELECT @ID, d.Renglon, d.RenglonSub, d.RenglonID, d.Tipo, d.RenglonTipo, d.Clave, CASE Tipo WHEN 'Actividad' THEN d.RecursoOmision ELSE '' END, CASE Tipo WHEN 'Actividad' THEN 'No Comenzada' ELSE '' END
FROM OportunidadPlantillaD d
JOIN OportunidadPlantilla c ON c.ID = d.ID
WHERE Plantilla = @Plantilla
UPDATE OportunidadPlantilla SET TieneMovimientos = 1  WHERE Plantilla = @Plantilla
EXEC xpOportunidadunidadDInsertar @ID, @Plantilla, @Usuario, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
RETURN
END

