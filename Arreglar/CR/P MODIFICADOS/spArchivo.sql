SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spArchivo
@Nombre		varchar(255),
@Accion		varchar(20),
@ID		int		OUTPUT,
@Layout		varchar(50)  = NULL,
@Referencia	varchar(100) = NULL,
@EnSilencio	bit	= 1

AS BEGIN
INSERT Archivo (Nombre, Accion, Layout, Referencia) VALUES (@Nombre, @Accion, @Layout, @Referencia)
SELECT @ID = SCOPE_IDENTITY()
IF @EnSilencio = 0
SELECT 'ID' = @ID
RETURN
END

