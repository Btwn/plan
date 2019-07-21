SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgTareaABC ON Tarea

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@ID				int,
@IDN			int,
@IDA			int,
@UsuarioN			char(10),
@UsuarioA			char(10),
@UsuarioResponsableN	char(10),
@UsuarioResponsableA	char(10),
@UsuarioAsignadoN		char(10),
@UsuarioAsignadoA		char(10),
@DeN			varchar(100),
@DeA			varchar(100),
@ParaN			varchar(100),
@ParaA			varchar(100),
@Tarea			varchar(20)
IF dbo.fnEstaSincronizando() = 1 RETURN
IF NOT EXISTS (SELECT * FROM Version WHERE OutlookTareas = 1 AND OutlookTareasSincronizar = 1) RETURN
SELECT @IDN = ID, @UsuarioN = Usuario, @UsuarioResponsableN = NULLIF(RTRIM(UsuarioResponsable), ''), @UsuarioAsignadoN = NULLIF(RTRIM(UsuarioAsignado), '') FROM Inserted
SELECT @IDA = ID, @UsuarioA = Usuario, @UsuarioResponsableA = NULLIF(RTRIM(UsuarioResponsable), ''), @UsuarioAsignadoA = NULLIF(RTRIM(UsuarioAsignado), '') FROM Deleted
SELECT @UsuarioResponsableN = ISNULL(@UsuarioResponsableN, @UsuarioN),
@UsuarioResponsableA = ISNULL(@UsuarioResponsableA, @UsuarioA)
SELECT @UsuarioAsignadoN = ISNULL(@UsuarioAsignadoN, @UsuarioResponsableN),
@UsuarioAsignadoA = ISNULL(@UsuarioAsignadoA, @UsuarioResponsableA)
IF @IDN IS NOT NULL
BEGIN
SELECT @DeN   = MIN(Nombre) FROM OutlookNombre WHERE Usuario = @UsuarioResponsableN AND Estatus = 'ALTA'
SELECT @ParaN = MIN(Nombre) FROM OutlookNombre WHERE Usuario = @UsuarioAsignadoN    AND Estatus = 'ALTA'
END
IF @IDA IS NOT NULL
BEGIN
SELECT @DeA   = MIN(Nombre) FROM OutlookNombre WHERE Usuario = @UsuarioResponsableA AND Estatus = 'ALTA'
SELECT @ParaA = MIN(Nombre) FROM OutlookNombre WHERE Usuario = @UsuarioAsignadoA    AND Estatus = 'ALTA'
END
IF @IDA IS NULL
BEGIN
IF @IDN IS NOT NULL
BEGIN
INSERT INTO TareaBitacora (ID, Fecha, Evento, Usuario)
VALUES (@IDN, getdate(), 'Alta', @UsuarioResponsableN)
END
INSERT OutlookProcesar (
Tipo,    De,   Fecha,        Asunto, Mensaje,     FechaD,      FechaA,          Vencimiento, Estado, Completado, Prioridad, Accion,    Modulo,  ModuloID)
SELECT 'Tarea', @DeN, FechaEmision, Asunto, Comentarios, FechaInicio, FechaConclusion, Vencimiento, Estado, Completada, Prioridad, 'Agregar', 'TAREA', ID
FROM Tarea
WHERE ID = @IDN
SELECT @ID = SCOPE_IDENTITY()
IF @UsuarioAsignadoN <> NULL
INSERT OutlookProcesarPara (ID, Para) VALUES (@ID, @ParaN)
END
ELSE
IF @IDN IS NULL
INSERT OutlookProcesar (Tipo, De, Accion, Modulo, ModuloID) VALUES ('Tarea', @DeA , 'Eliminar', 'TAREA', @IDA)
ELSE
BEGIN
IF NOT UPDATE(Sincronizando)
BEGIN
IF @UsuarioResponsableA = @UsuarioResponsableN  and @UsuarioResponsableA <> @UsuarioAsignadoA and @UsuarioAsignadoN = @UsuarioAsignadoA
SELECT @DeN = @ParaN
INSERT OutlookProcesar (
Tipo,    De,   Fecha,        Asunto, Mensaje,     FechaD,      FechaA,          Vencimiento, Estado, Completado, Prioridad, Accion,      Modulo,  ModuloID)
SELECT 'Tarea', @DeN, FechaEmision, Asunto, Comentarios, FechaInicio, FechaConclusion, Vencimiento, Estado, Completada, Prioridad, 'Modificar', 'TAREA', ID
FROM Tarea
WHERE ID = @IDN
SELECT @ID = SCOPE_IDENTITY()
IF @ParaN <> @ParaA
INSERT OutlookProcesarPara (ID, Para) VALUES (@ID, @ParaN)
INSERT INTO TareaBitacora (ID, Fecha, Evento, Usuario)
VALUES (@IDN, getdate(), 'Actualizada', @UsuarioAsignadoN)
END
END
END

