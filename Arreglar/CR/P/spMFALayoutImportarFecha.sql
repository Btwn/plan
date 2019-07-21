SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMFALayoutImportarFecha
@Usuario						varchar(20),
@Empresa						varchar(5),
@FechaD						datetime	= NULL,
@FechaA						datetime	= NULL

AS BEGIN
DECLARE @log_id		int
EXEC @log_id = spMFALayoutImportar @Usuario, @Empresa, @Ejercicio = NULL, @Periodo = NULL, @FechaD = @FechaD, @FechaA = @FechaA, @EnSilencio = 1
IF EXISTS(SELECT * FROM layout_logd where log_id  = @log_id )
SELECT 'Referencias Inválidas.'
ELSE
SELECT 'Proceso Concluido.'
END

