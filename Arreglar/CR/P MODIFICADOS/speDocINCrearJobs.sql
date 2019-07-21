SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocINCrearJobs
@Nombre   varchar(100),
@BaseDatos        varchar(30),
@UsuarioI         varchar(30)

AS
DECLARE
@TrabajoID        binary (16),
@ReturnCode       int,
@Usuario          varchar(30),
@Contrasena       varchar(30),
@Activo           bit,
@Trabajo          char(20),
@Cadena           varchar(100),
@Servidor         varchar(30),
@HoraInicial      int,
@HoraFinal        int,
@Frecuencia       tinyint,
@Valor            tinyint,
@Recurrencia      tinyint,
@FrecuenciaD      tinyint,
@ValorD           tinyint,
@Domingo          bit,
@Lunes            bit,
@Martes           bit,
@Miercoles        bit,
@Jueves           bit,
@Viernes          bit,
@Sabado           bit,
@Valor2           tinyint,
@Tipo             tinyint,
@Dia              tinyint,
@Fecha2           int,
@Estatus          bit,
@spSucursal       int,
@spEmpresa        varchar(5),
@spUsuario        varchar(30),
@spOrigen         varchar(255),
@spDestino        varchar(255),
@spExtencion      varchar(255),
@spFecha          datetime,
@NombreOriginal   varchar(100)
BEGIN TRANSACTION
DECLARE @SQLServerAgent TABLE
(
Estatus                       varchar(50)
)
SELECT @NombreOriginal = ISNULL(@Nombre,'')
SELECT @Nombre = ISNULL(@Nombre,'') + '.' + @@SERVERNAME + '.' + @BaseDatos
SELECT @ReturnCode = 0
IF (SELECT COUNT(*) FROM msdb.dbo.syscategories WHERE name = '[Uncategorized (Local)]') < 1
EXECUTE msdb.dbo.sp_add_category @name = '[Uncategorized (Local)]'
SELECT @TrabajoID = job_id FROM   msdb.dbo.sysjobs WHERE (name = @Nombre)
IF (@TrabajoID IS NOT NULL)
BEGIN
IF (EXISTS (SELECT  * FROM    msdb.dbo.sysjobservers WHERE   (job_id = @TrabajoID) AND (server_id <> 0)))
BEGIN
RAISERROR ('Unable to import job ''Notificacion '' since there is already a multi-server job with this name.', 16, 1)
SELECT @ReturnCode = 1
END
ELSE
EXECUTE msdb.dbo.sp_delete_job @job_name = @Nombre
SELECT @TrabajoID = NULL
END
IF (@@ERROR = 0 AND @ReturnCode = 0) AND EXISTS(SELECT * FROM eDocInTrabajo WITH(NOLOCK) WHERE  Trabajo = @NombreOriginal)
BEGIN
IF @ReturnCode = 0
EXECUTE @ReturnCode = msdb.dbo.sp_add_job @job_id = @TrabajoID OUTPUT , @job_name = @Nombre, @owner_login_name = @Usuario, @description =  @Nombre, @category_name = '[Uncategorized (Local)]', @enabled = 1, @notify_level_email = 0, @notify_level_page = 0, @notify_level_netsend = 0, @notify_level_eventlog = 2, @delete_level= 0
DECLARE crTrabajo SCROLL CURSOR FOR
SELECT Trabajo, Usuario, Contrasena, CONVERT(int, SUBSTRING(HoraInicial,1,2) + SUBSTRING(HoraInicial,4,2) + '00'), CONVERT(int, SUBSTRING(HoraFinal,1,2) + SUBSTRING(HoraFinal,4,2) + '00'), CASE Frecuencia WHEN 'Diaria' THEN 4 WHEN 'Semanal' THEN 8 WHEN 'Mensual' THEN 16 WHEN 'Mensual 2' THEN 32 END, Valor, Recurrencia, CASE FrecuenciaD WHEN 'Minutos' THEN 4 WHEN 'Horas' THEN 8 END , ValorD, Activo, Domingo, Lunes, Martes, Miercoles, Jueves, Viernes, Sabado, CASE Tipo WHEN 'Primer' THEN 1 WHEN 'Segundo' THEN 2 WHEN 'Tercer' THEN 4 WHEN 'Cuarto' THEN 8 WHEN 'Ultimo' THEN 16 END, CASE Dia WHEN 'Domingo' THEN 1 WHEN 'Lunes' THEN 2 WHEN 'Martes' THEN 3 WHEN 'Miercoles' THEN 4 WHEN 'Jueves' THEN 5 WHEN 'Viernes' THEN 6 WHEN 'Sabado' THEN 7 WHEN 'Dia' THEN 8 WHEN 'Dia de la semana' THEN 9 WHEN 'Dia del fin de semana' THEN 10 END, CONVERT(int, CONVERT(varchar,DATEPART(YEAR,FechaInicial)) + dbo.fnRellenarCerosIzquierda(CONVERT(varchar,DATEPART(MONTH,FechaInicial)),2) + dbo.fnRellenarCerosIzquierda(CONVERT(varchar,DATEPART(DAY,FechaInicial)),2)), spSucursal, spEmpresa, spUsuario, GETDATE(), spOrigen, spDestino
FROM eDocInTrabajo WITH(NOLOCK)
WHERE Trabajo = @NombreOriginal
IF ISNULL(@Contrasena,'') = ''
SELECT @Contrasena = 'NULL'
OPEN crTrabajo
FETCH NEXT FROM crTrabajo  INTO @Trabajo, @Usuario, @Contrasena, @HoraInicial, @HoraFinal, @Frecuencia, @Valor, @Recurrencia, @FrecuenciaD, @ValorD, @Activo, @Domingo, @Lunes, @Martes, @Miercoles, @Jueves, @Viernes, @Sabado, @Tipo, @Dia, @Fecha2, @spSucursal, @spEmpresa, @spUsuario, @spFecha, @spOrigen, @spDestino
WHILE @@FETCH_STATUS = 0 AND @ReturnCode = 0
BEGIN
SELECT @Valor2 = 0
IF @Frecuencia = 8
BEGIN
IF @Domingo = 1
SELECT @Valor2 = @Valor2 + 1
IF @Lunes = 1
SELECT @Valor2 = @Valor2 + 2
IF @Martes = 1
SELECT @Valor2 = @Valor2 + 4
IF @Miercoles = 1
SELECT @Valor2 = @Valor2 + 8
IF @Jueves = 1
SELECT @Valor2 = @Valor2 + 16
IF @Viernes = 1
SELECT @Valor2 = @Valor2 + 32
IF @Sabado = 1
SELECT @Valor2 = @Valor2 + 64
SELECT @Valor = @Valor2
END
ELSE
IF @Frecuencia = 32
SELECT @Valor = @Dia
SET @spExtencion = '.xml'
SET @cadena     = 'EXEC speDocInInsertarIS ' + '''' + RTRIM(@spOrigen) + '''' + ', ' + '''' + RTRIM(@spDestino) + '''' + ', ' + '''' + RTRIM(@spExtencion) + '''' + ', ' +    '''' + RTRIM(@spEmpresa) + '''' + ', ' + '''' + RTRIM(@spUsuario) + '''' + ', ' + '''' + RTRIM(@spSucursal) + ''''
EXECUTE @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @TrabajoID, @step_id = 1, @step_name = @Trabajo, @command = @cadena, @database_name = @BaseDatos, @server = '', @database_user_name = '', @subsystem = 'TSQL', @cmdexec_success_code = 0, @flags = 0, @retry_attempts = 0, @retry_interval = 1, @OUTPUT_file_name = '', @on_success_step_id = 0, @on_success_action = 1, @on_fail_step_id = 0, @on_fail_action = 2
UPDATE eDocInTrabajo  WITH(ROWLOCK) SET UltimaActualizacion = GETDATE() WHERE Trabajo = @Trabajo
FETCH NEXT FROM crTrabajo  INTO  @Trabajo, @Usuario, @Contrasena, @HoraInicial, @HoraFinal, @Frecuencia, @Valor, @Recurrencia, @FrecuenciaD, @ValorD, @Activo, @Domingo, @Lunes, @Martes, @Miercoles, @Jueves, @Viernes, @Sabado, @Tipo, @Dia, @Fecha2, @spSucursal, @spEmpresa, @spUsuario, @spFecha, @spOrigen, @spDestino
END
IF @ReturnCode = 0
EXECUTE @ReturnCode = msdb.dbo.sp_update_job @job_id = @TrabajoID, @start_step_id = 1, @enabled  = @Activo
IF @ReturnCode = 0
EXECUTE @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @TrabajoID, @name = @Nombre, @enabled = @Activo, @freq_type = @Frecuencia, @active_start_date = @Fecha2, @active_start_time = @HoraInicial, @freq_interval = @Valor, @freq_subday_type = @FrecuenciaD , @freq_subday_interval = @ValorD, @freq_relative_interval = @Tipo, @freq_recurrence_factor = @Recurrencia, @active_end_date = 99991231, @active_end_time = @HoraFinal
IF @ReturnCode = 0
EXECUTE @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @TrabajoID, @server_name = @@SERVERNAME
CLOSE crTrabajo
DEALLOCATE crTrabajo
END
INSERT @SQLServerAgent (Estatus)
EXEC master.dbo.xp_ServiceControl 'QUERYSTATE', 'SQLServerAgent'
IF (SELECT TOP 1 Estatus FROM @SQLServerAgent) = 'Running.' SELECT @Estatus = 1 ELSE SELECT @Estatus = 0
IF @ReturnCode = 0
BEGIN
IF @Estatus = 1 SELECT 'Proceso terminado.' ELSE SELECT 'Favor de verificar el servicio del Agente SQL Server para la ejecuci�n del trabajo.'
COMMIT TRANSACTION
END
ELSE
BEGIN
IF @Estatus = 1 SELECT 'Proceso terminado.' ELSE SELECT 'Favor de verificar el servicio del Agente SQL Server para la ejecuci�n del trabajo.'
ROLLBACK TRANSACTION
END

