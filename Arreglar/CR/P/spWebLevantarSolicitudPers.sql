SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebLevantarSolicitudPers
@Empresa		Varchar(5),
@SolicitudMov	Varchar(20),
@Usuario		Varchar(10),
@Recurso		Varchar(10),
@Personal		Varchar(10),
@Prioridad		Varchar(10),
@Comentarios	Varchar(500)
AS BEGIN
SET NOCOUNT ON
DECLARE @NuevoID INT
DECLARE @UsuarioResponsable VARCHAR(10)
SELECT @UsuarioResponsable = Usuario FROM Recurso WHERE Recurso = @Recurso
INSERT INTO Soporte (Empresa,	Mov,			FechaEmision,												Usuario,		Estatus,
Personal,	Estado,			UsuarioResponsable,											Vencimiento,
Prioridad,	Titulo,			Comentarios,		SubModulo)
VALUES(@Empresa, @SolicitudMov, CONVERT(Datetime, CONVERT(Varchar, GETDATE(), 102), 102),		@Usuario,		'SINAFECTAR',
@Personal, 'No comenzado',	@UsuarioResponsable,	   CONVERT(Datetime, CONVERT(Varchar, GETDATE(), 102), 102),
@Prioridad, @SolicitudMov,	@Comentarios,	'STPER')
IF @@IDENTITY > 0
SET @NuevoID = @@IDENTITY
ELSE
SET @NuevoID = 0
EXEC spAfectar @Modulo = 'ST', @ID = @NuevoID, @Accion = 'AFECTAR', @Base = 'TODO', @GenerarMov = NULL, @Usuario = @Usuario, @SincroFinal = false, @EnSilencio = false
SET NOCOUNT OFF
RETURN
END

