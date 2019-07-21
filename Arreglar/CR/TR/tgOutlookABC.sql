SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgOutlookABC ON Outlook
FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@ID			int,
@IDN		int,
@IDA		int,
@TipoN		varchar(20),
@TipoA		varchar(20),
@ModuloN		char(5),
@ModuloA		char(5),
@ModuloIDN		int,
@ModuloIDA		int,
@De			varchar(100),
@Para		varchar(100),
@UsuarioAsignado	char(10),
@UsuarioModificador	char(10),
@Estado		varchar(30)
IF dbo.fnEstaSincronizando() = 1 RETURN
IF NOT EXISTS (SELECT * FROM Version WHERE OutlookTareas = 1 AND OutlookTareasSincronizar = 1) RETURN
SELECT @IDN = ID, @TipoN = UPPER(Tipo), @ModuloN = Modulo, @ModuloIDN = ModuloID FROM Inserted
SELECT @IDA = ID, @TipoA = UPPER(Tipo), @ModuloA = Modulo, @ModuloIDA = ModuloID FROM Deleted
SELECT @Para = MIN(Para) FROM OutlookPara WHERE ID = @IDN
SELECT @De = MIN(De) FROM Outlook WHERE ID = @IDN
SELECT @UsuarioAsignado = MIN(Usuario) FROM OutlookNombre WHERE Nombre = @Para AND Estatus = 'ALTA'
IF not @UsuarioAsignado IS NULL
SELECT @UsuarioModificador = @UsuarioAsignado
ELSE
SELECT @UsuarioModificador = MIN(Usuario) FROM OutlookNombre WHERE Nombre = @De AND Estatus = 'ALTA'
IF @IDN IS NULL AND @TipoA = 'TAREA' AND @ModuloA = 'TAREA' AND @ModuloIDA IS NOT NULL
UPDATE Tarea set Estado = 'Eliminada', UsuarioAsignado = @UsuarioModificador WHERE ID = @ModuloIDA
ELSE
IF @IDA IS NOT NULL AND @IDN IS NOT NULL AND @TipoN = 'TAREA'
BEGIN
SELECT @Estado = Estado FROM Tarea WHERE Id = @ModuloIDA
UPDATE Tarea
SET FechaEmision = o.Fecha,
Asunto = o.Asunto,
Comentarios = o.Mensaje,
FechaInicio = o.FechaD,
FechaConclusion = o.FechaA,
Vencimiento = o.Vencimiento,
Estado = CASE WHEN @Estado = 'Eliminada' THEN 'Eliminada' ELSE o.Estado END,
Completada = o.Completado,
Prioridad = o.Prioridad,
UsuarioAsignado = ISNULL(NULLIF(RTRIM(@UsuarioModificador), ''), t.UsuarioAsignado),
Sincronizando = 1
FROM Outlook o, Tarea t
WHERE t.ID = @ModuloIDN AND o.ID = @IDN
UPDATE Tarea
SET Sincronizando = 0
WHERE ID = @IDN
END
IF @IDN IS NULL AND @TipoA = 'ACTIVIDAD' AND @ModuloA = 'ACT' AND @ModuloIDA IS NOT NULL
UPDATE Act SET Estado = 'Eliminada' WHERE ID = @ModuloIDA
ELSE
IF @IDA IS NOT NULL AND @IDN IS NOT NULL AND @TipoN = 'ACTIVIDAD'
BEGIN
SELECT @Estado = Estado FROM Act WHERE ID = @ModuloIDA
UPDATE Act
SET Asunto = o.Asunto,
Comentarios = o.Mensaje,
Comienzo = o.FechaD,
Fin = o.FechaA,
Estado = CASE WHEN @Estado = 'Eliminada' THEN 'Eliminada' ELSE o.Estado END,
Avance = o.Completado,
Prioridad = o.Prioridad,
Sincronizando = 1
FROM Outlook o, Act a
WHERE a.ID = @ModuloIDN AND o.ID = @IDN
UPDATE Act
SET Sincronizando = 0
WHERE ID = @IDN
END
END

