SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDINominaReciboEliminar
@Estacion		int,
@ID				int,
@Personal		varchar(10),
@Timbrado		varchar(15),
@Ok				int			OUTPUT,
@OkRef			varchar(255)OUTPUT

AS
BEGIN
IF ISNULL(@Timbrado, 'No Timbrado') = 'No Timbrado'
BEGIN
DELETE CFDINominaRecibo WHERE ID = @ID AND Personal = @Personal
DELETE CFDINominaPercepcionDeduccion WHERE ID = @ID AND Personal = @Personal
DELETE CFDINominaHoraExtra WHERE ID = @ID AND Personal = @Personal
DELETE CFDINominaIncapacidad WHERE ID = @ID AND Personal = @Personal
DELETE CFDINominaRetencion WHERE ID = @ID AND Personal = @Personal
END
RETURN
END

