SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAgendaAgregar
@De				varchar(100),
@Fecha			datetime		= NULL,
@Asunto			varchar(255)	= NULL,
@Ubicacion		varchar(255) 	= NULL,
@Mensaje		text			= NULL,
@FechaD			datetime		= NULL,
@FechaA			datetime		= NULL,
@Vencimiento	datetime		= NULL,
@DiaCompleto	bit				= 0,
@Estado			varchar(100)	= NULL,
@ColorEtiqueta	int				= NULL,
@EnSilencio		bit 			= 0,
@ID				int				= NULL OUTPUT

AS
BEGIN
DECLARE @Referencia	varchar(50)
BEGIN TRANSACTION
SELECT @Referencia = replace(replace(substring(convert(varchar(30),getdate(),121), 12, 12),':',''),'.','')
INSERT OutlookProcesar (Tipo,   De,   Fecha,   Asunto, Ubicacion, Mensaje, FechaD, FechaA, Vencimiento, DiaCompleto, Recibido, Estado, Accion, Referencia)
VALUES         ('Cita', @De, @Fecha, @Asunto, @Ubicacion, @Mensaje, @FechaD, @FechaA, @Vencimiento, @DiaCompleto, 0, @Estado,  'Agregar', @Referencia)
INSERT Outlook (Tipo, De,  Fecha,  Asunto, Ubicacion,  Mensaje,  FechaD,    FechaA,  Vencimiento, DiaCompleto,   Recibido, Estado, ColorEtiqueta, Referencia)
VALUES         ('Cita', @De, @Fecha, @Asunto, @Ubicacion, @Mensaje, @FechaD, @FechaA, @Vencimiento , @DiaCompleto, 0, @Estado, @ColorEtiqueta, @Referencia)
IF @@ERROR = 0 and @@ROWCOUNT > 0
BEGIN
SELECT @ID = SCOPE_IDENTITY()
COMMIT TRANSACTION
IF @EnSilencio = 0
SELECT 'ID' = ISNULL(@ID, 0)
END
ELSE
BEGIN
ROLLBACK TRANSACTION
IF @EnSilencio = 0
SELECT 'ID' = -1
END
END

