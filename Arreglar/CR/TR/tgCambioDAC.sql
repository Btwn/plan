SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCambioDAC ON CambioD

FOR INSERT, UPDATE
AS BEGIN
DECLARE
@ID				int,
@Usuario			char(10),
@ValorAnterior		varchar(50),
@ValorNuevo			varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ValorAnterior = CONVERT(char, Cobertura) FROM DELETED
SELECT @ValorNuevo    = CONVERT(char, Cobertura) FROM INSERTED
SELECT @ID = ID, @Usuario = UsuarioCobertura FROM INSERTED
IF @ValorAnterior <> @ValorNuevo
INSERT CambioBitacora (CambioID, Usuario, Fecha, Accion, ValorAnterior, ValorNuevo) VALUES (@ID, @Usuario, GETDATE(), 'Cobertura', @ValorAnterior, @ValorNuevo)
END

