SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAccesoUsuarioOk
@Usuario	     	varchar(10)

AS BEGIN
DECLARE
@Bloquear		bit,
@Dias		int,
@UltimoAcceso	datetime,
@Hoy		datetime,
@Estatus		varchar(15)
SELECT @Hoy = dbo.fnFechaSinHora(GETDATE())
SELECT @Estatus = Estatus FROM Usuario WHERE Usuario = @Usuario
SELECT @Bloquear = BloquearUsuariosInactivos, @Dias = NULLIF(BloquearUsuariosInactivosDias, 0)
FROM Version
IF @Bloquear = 1 AND @Dias IS NOT NULL AND @Estatus = 'ALTA'
BEGIN
SELECT @UltimoAcceso = UltimoAcceso FROM Usuario WHERE Usuario = @Usuario
IF @UltimoAcceso IS NOT NULL
BEGIN
IF @Hoy > DATEADD(day, @Dias, @UltimoAcceso)
UPDATE Usuario SET Estatus = 'BLOQUEADO' WHERE Usuario = @Usuario
END
END
RETURN
END

