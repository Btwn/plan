SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgProyectoDC ON ProyectoD

FOR UPDATE
AS BEGIN
DECLARE
@OutlookID			int,
@SincroOutlook		bit,
@IDN			int,
@IDA			int,
@EstaLiberadoN		bit,
@EstaLiberadoA		bit,
@DeN			varchar(100),
@DeA			varchar(100),
@ParaN			varchar(100),
@ParaA			varchar(100),
@ComienzoN			datetime,
@ComienzoA			datetime,
@FinN			datetime,
@FinA			datetime,
@AsuntoN			varchar(100),
@AsuntoA			varchar(100),
@EstadoN			varchar(30),
@EstadoA			varchar(30),
@AvanceN			float,
@AvanceA			float,
@PrioridadN			varchar(10),
@PrioridadA			varchar(10),
@ActividadN			varchar(50),
@ActividadA			varchar(50),
@EsFaseN                    bit,
@EsFaseA                    bit
IF dbo.fnEstaSincronizando() = 1 RETURN
IF UPDATE(Sincronizando) RETURN
SELECT @SincroOutlook = ISNULL(OutlookActividadesSincronizar, 0) FROM Version
SELECT @IDN = ID, @ActividadN = Actividad, @ComienzoN = Comienzo, @FinN = Fin, @AsuntoN = Asunto, @EstadoN = Estado, @AvanceN = Avance, @PrioridadN = Prioridad, @EstaLiberadoN = EstaLiberado, @EsFaseN = EsFase FROM Inserted
SELECT @IDA = ID, @ActividadA = Actividad, @ComienzoA = Comienzo, @FinA = Fin, @AsuntoA = Asunto, @EstadoA = Estado, @AvanceA = Avance, @PrioridadA = Prioridad, @EstaLiberadoA = EstaLiberado, @EsFaseA = EsFase FROM Deleted
IF @ActividadN <> @ActividadA
UPDATE ProyectoDRecurso SET Actividad = @ActividadN WHERE ID = @IDA AND Actividad = @ActividadA
IF @SincroOutlook = 1
BEGIN
IF @IDN IS NOT NULL SELECT @DeN = r.NombreExchange /*r.Nombre+' ['+r.eMail+']'*/ FROM Recurso r JOIN Proyecto p ON p.Supervisor = r.Recurso WHERE p.ID = @IDN
IF @IDA IS NOT NULL SELECT @DeA = r.NombreExchange /*r.Nombre+' ['+r.eMail+']'*/ FROM Recurso r JOIN Proyecto p ON p.Supervisor = r.Recurso WHERE p.ID = @IDA
END
IF @SincroOutlook = 1 AND @EstaLiberadoN = 1
BEGIN
IF @EstaLiberadoA = 0 AND @EstaLiberadoN = 1
BEGIN
INSERT OutlookProcesar (
Tipo,        De,   Fecha,           Asunto,                             Mensaje,     FechaD,   FechaA, Estado, Completado, Prioridad, Accion,    Modulo,  ModuloID)
SELECT 'Actividad', @DeN, FechaLiberacion, Actividad+' - '+ISNULL(Asunto, ''), Comentarios, Comienzo, Fin,    Estado, Avance,     Prioridad, 'Agregar', 'ACT',   ID
FROM ProyectoD
WHERE ID = @IDN AND Actividad = @ActividadN
SELECT @OutlookID = SCOPE_IDENTITY()
INSERT OutlookProcesarPara (ID, Para)
SELECT @OutlookID, r.NombreExchange
FROM ProyectoDRecurso dr
JOIN Recurso r ON r.Recurso = dr.Recurso
WHERE dr.ID = @IDN AND dr.Actividad = @ActividadN
END
IF @EstaLiberadoA = 1 AND @EstaLiberadoN = 1
BEGIN
IF UPDATE(Comentarios) OR @ParaN <> @ParaA OR @ComienzoN <> @ComienzoA OR @FinN <> @FinA OR @AsuntoN <> @AsuntoA OR @EstadoN <> @EstadoA OR @AvanceN <> @AvanceA OR @PrioridadN <> @PrioridadA
BEGIN
INSERT OutlookProcesar (
Tipo,        De,   Fecha,           Asunto,                             Mensaje,     FechaD,   FechaA, Estado, Completado, Prioridad, Accion,       Modulo, ModuloID)
SELECT 'Actividad', @DeN, FechaLiberacion, Actividad+' - '+ISNULL(Asunto, ''), Comentarios, Comienzo, Fin,    Estado, Avance,     Prioridad, 'Modificar', 'ACT',   ID
FROM ProyectoD
WHERE ID = @IDN AND Actividad = @ActividadN
SELECT @OutlookID = SCOPE_IDENTITY()
INSERT OutlookProcesarPara (ID, Para)
SELECT @OutlookID, r.NombreExchange
FROM ProyectoDRecurso dr
JOIN Recurso r ON r.Recurso = dr.Recurso
WHERE dr.ID = @IDN AND dr.Actividad = @ActividadN
END
END
END
EXEC spProyectoDLiberar @IDN, @ActividadN
END

