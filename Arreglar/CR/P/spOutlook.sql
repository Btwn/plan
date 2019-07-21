SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOutlook
@De					varchar(100),
@Fecha				datetime,
@Asunto				varchar(255),
@Mensaje			text,
@Anexos				varchar(255),
@OutlookID			varchar(150) 	= NULL,
@Recibido			bit		= 0,
@Tipo				varchar(20)	= 'Correo',
@FechaD				datetime	= NULL,
@FechaA				datetime	= NULL,
@DiaCompleto		bit		= 0,
@Vencimiento		datetime	= NULL,
@Ubicacion			varchar(255) 	= NULL,
@Estado				varchar(100) 	= NULL,
@Completado			float 		= NULL,
@Prioridad			varchar(20)	= NULL,
@Eliminar			bit 		= 0,
@Referencia			varchar(20)	= NULL,
@Modulo				char(5)	= NULL,
@ModuloID			int	= NULL,
@UsuarioAsignado	char(10) = NULL,
@EnSilencio			bit = 0,
@ID					int	= NULL OUTPUT

AS BEGIN
DECLARE
@Estatus				varchar(15),
@OutlookEstatusNuevo	bit
SELECT @ID = NULL, @De = NULLIF(RTRIM(@De), '')
IF @Tipo <> 'Cita'
BEGIN
IF @OutlookID IS NOT NULL
SELECT @ID = MIN(ID) FROM Outlook WHERE OutlookID = @OutlookID
END
ELSE
BEGIN
IF @Referencia IS NOT NULL
SELECT @ID = MIN(ID) FROM Outlook WHERE Referencia = @Referencia
END
IF @Eliminar = 1
BEGIN
IF @ID IS NULL AND @Tipo <> 'Tarea'
SELECT @ID = MIN(ID)
FROM Outlook
WHERE De = @De AND Fecha = @Fecha AND Anexos = @Anexos AND Asunto = @Asunto AND Tipo = @Tipo AND FechaD = @FechaD AND FechaA = @FechaA
ELSE
IF @ID IS NULL AND @Tipo = 'Tarea'
SELECT @ID = MIN(ID)
FROM Outlook
WHERE Recibido = @Recibido and Modulo = @Modulo and ModuloID = @ModuloID
DELETE Outlook WHERE Modulo = @Modulo and ModuloID = @ModuloID	
END
ELSE
BEGIN
IF @ID IS NULL
BEGIN
SELECT @OutlookEstatusNuevo = OutlookEstatusNuevo FROM Version
EXEC spOutlookNombre @De, @Estatus OUTPUT
IF (@Estatus = 'NUEVO' AND @OutlookEstatusNuevo = 1) OR (@Estatus = 'ALTA')
BEGIN
SELECT @UsuarioAsignado = MIN(Usuario) FROM OutlookNombre WHERE Nombre = @De AND Estatus = 'ALTA'
IF @Tipo= 'Cita'
SELECT @Referencia = replace(replace(substring(convert(varchar(30),getdate(),121), 12, 12),':',''),'.','')
INSERT Outlook (De,  Fecha,  Asunto,  Mensaje,  Anexos,  OutlookID,  Recibido,  Tipo,  FechaD,  FechaA,  DiaCompleto,  Vencimiento,  Ubicacion,  Estado,  Completado,  Prioridad,  Referencia,  Modulo,  ModuloID, UsuarioAsignado)
VALUES (@De, @Fecha, @Asunto, @Mensaje, @Anexos, @OutlookID, @Recibido, @Tipo, @FechaD, @FechaA, @DiaCompleto, @Vencimiento, @Ubicacion, @Estado, @Completado, @Prioridad, @Referencia, @Modulo, @ModuloID, @UsuarioAsignado)
SELECT @ID = SCOPE_IDENTITY()
END
END
ELSE
IF UPPER(@Tipo) <> 'CORREO'
BEGIN
DELETE OutlookPara WHERE ID = @ID
UPDATE Outlook
SET De = @De, Fecha = @Fecha, Asunto = @Asunto, Mensaje = @Mensaje, Anexos = @Anexos, FechaD = @FechaD, FechaA = @FechaA, DiaCompleto = @DiaCompleto, Vencimiento = @Vencimiento, Ubicacion = @Ubicacion,
Estado = @Estado, Completado = @Completado, Prioridad = @Prioridad, Referencia = @Referencia, Modulo = @Modulo, ModuloID = @ModuloID, UsuarioAsignado = ISNULL(@UsuarioAsignado, UsuarioAsignado)
WHERE ID = @ID
END
END
IF @EnSilencio = 0
SELECT 'ID' = ISNULL(@ID, 0)
RETURN
END

