SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNetUpdComunicado
@IDComunicado INT,
@Titulo VARCHAR(60),
@Registro VARCHAR(10),
@DirigidoA VARCHAR(15),
@FechaPublicado DATETIME,
@FechaVigencia DATETIME,
@Descripcion VARCHAR(255),
@Prioridad VARCHAR(15),
@Tipo INT,
@Estatus bit
AS
BEGIN
IF (EXISTS(SELECT * FROM pNetUsuario WHERE Usuario = @Registro) AND EXISTS(SELECT * FROM pNetComunicado WHERE IDComunicado = @IDComunicado))
BEGIN
UPDATE pNetComunicado SET Titulo = @Titulo, Registro = @Registro, DirigidoA = @DirigidoA, FechaRegistro = GETDATE(),FechaPublicado = @FechaPublicado, FechaVigencia = @FechaVigencia, Descripcion = @Descripcion, Prioridad = @Prioridad, Tipo = @Tipo, Estatus = @Estatus WHERE IDComunicado = @IDComunicado
SELECT @IDComunicado as ID
END
ELSE
SELECT -1 as ID
END

