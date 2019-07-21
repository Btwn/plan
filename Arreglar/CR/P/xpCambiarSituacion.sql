SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpCambiarSituacion
@Modulo              char(5),
@ID                  int,
@Situacion           char(50),
@SituacionFecha      datetime,
@Usuario             char(10),
@SituacionUsuario    varchar(10) = NULL,
@SituacionNota       varchar(100) = NULL
AS BEGIN
EXEC xpeCommerceCambiarSituacion @Modulo, @ID, @Situacion, @SituacionFecha, @Usuario, @SituacionUsuario, @SituacionNota
RETURN
END

