SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnPuedeAvanzarSituacion(
@Empresa		varchar(5),
@Modulo			varchar(5),
@Mov			varchar(20),
@Estatus		varchar(15),
@Situacion		varchar(50),
@Usuario		varchar(10)
)
RETURNS bit
AS
BEGIN
DECLARE @Resultado	bit
IF ISNULL(@Situacion, '') IN('.', '')
SELECT @Situacion = RTRIM(@Mov)+' '+RTRIM(Nombre) FROM Estatus WHERE Estatus = @Estatus
IF dbo.fnMovSituacionTipoFlujo(@Empresa, @Modulo, @Mov, @Estatus) = 'Condicional'
BEGIN
IF(SELECT TOP 1 ISNULL(ControlUsuarios, 0) FROM MovSituacion WHERE Modulo = @Modulo AND Mov = @Mov AND Estatus = @Estatus AND Situacion = @Situacion) = 0
SELECT @Resultado = 1
ELSE
BEGIN
IF EXISTS(SELECT u.Usuario FROM MovSituacionUsuario u JOIN MovSituacion s ON u.ID = s.ID WHERE s.Modulo = @Modulo AND s.Mov = @Mov AND s.Estatus = @Estatus AND s.Situacion = @Situacion AND u.Usuario = @Usuario)
SELECT @Resultado = 1
ELSE
SELECT @Resultado = 0
END
END
ELSE
SELECT @Resultado = 0
RETURN @Resultado
END

