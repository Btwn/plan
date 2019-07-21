SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spOportunidadeMailEnviar
@ID					int,
@Usuario			varchar(10),
@EstacionTrabajo	int,
@PlantillaeMail		varchar(20),
@Ok					int			 = NULL OUTPUT,
@OkRef				varchar(255) = NULL OUTPUT

AS
BEGIN
DECLARE @RID			int,
@RIDAnt		int,
@OkDesc		varchar(255),
@OkTipo		varchar(50)
IF ISNULL(@PlantillaeMail, '') = ''
SELECT @Ok = 14084
IF @Ok IS NULL AND (SELECT COUNT(*) FROM OportunidadPlantillaeMail WHERE Plantilla = @PlantillaeMail) = 0
SELECT @Ok = 14085, @OkRef = @PlantillaeMail
IF @Ok IS NULL AND (SELECT ISNULL(Estatus, '') FROM OportunidadPlantillaeMail WHERE Plantilla = @PlantillaeMail) <> 'Activa'
SELECT @Ok = 14086, @OkRef = @PlantillaeMail
SELECT @RIDAnt = 0
WHILE(1=1) AND @Ok IS NULL
BEGIN
SELECT @RID = MIN(RID)
FROM OportunidadeMailEnviar
WHERE EstacionTrabajo = @EstacionTrabajo
AND RID > @RIDAnt
AND ISNULL(Enviar, 0) = 1
IF @RID IS NULL BREAK
SELECT @RIDAnt = @RID
EXEC spOportunidadeMailEnviarRegistro @ID, @Usuario, @EstacionTrabajo, @RID, @PlantillaeMail, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
IF @Ok IS NULL
BEGIN
SELECT @OkRef = NULL
END
ELSE
SELECT @OkDesc = Descripcion,
@OkTipo = Tipo
FROM MensajeLista
WHERE Mensaje = @Ok
SELECT @Ok, @OkDesc, @OkTipo, @OkRef, NULL
RETURN
END

