SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgMovBitacoraA ON MovBitacora

FOR INSERT
AS BEGIN
DECLARE
@Modulo		char(5),
@ID			int,
@RID			int,
@Estatus		varchar(15),
@Situacion		varchar(50),
@SituacionFecha	datetime,
@SituacionUsuario	varchar(10),
@SituacionNota	varchar(100)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @Modulo = Modulo, @ID = ID, @RID = RID FROM Inserted
EXEC spMovInfo @ID, @Modulo, @Estatus = @Estatus OUTPUT, @Situacion = @Situacion OUTPUT, @SituacionFecha = @SituacionFecha OUTPUT, @SituacionUsuario = @SituacionUsuario OUTPUT, @SituacionNota = @SituacionNota OUTPUT
UPDATE MovBitacora
SET MovEstatus = @Estatus,
MovSituacion = @Situacion,
MovSituacionFecha = @SituacionFecha,
MovSituacionUsuario = @SituacionUsuario,
MovSituacionNota = @SituacionNota
WHERE Modulo = @Modulo AND ID = @ID AND RID = @RID
END

