SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSacaLosPresentes
@Empresa char(20),
@Usuario char(10)

AS BEGIN
DECLARE
@Personal char(10),
@ID       int,
@Renglon  Float,
@Ok       int,
@OkRef    varchar(255)
IF DATEPART(hh, GETDATE()) > 21
BEGIN
DECLARE crPresenteSalida CURSOR FOR
SELECT Personal FROM Personal WHERE EstaPresente  =  1 AND ESTATUS  =  'ALTA'
OPEN crPresenteSalida
FETCH NEXT FROM crPresenteSalida INTO @Personal
IF @@FETCH_STATUS  =  0
INSERT Asiste(Empresa, Mov, FechaEmision, Usuario, Estatus, Observaciones)
VALUES(@Empresa, 'Registro', CONVERT(datetime, FLOOR(CONVERT(float, GETDATE()))), @Usuario, 'SINAFECTAR', 'No Marco Salida')
SELECT @ID = @@IDENTITY, @Renglon = 2048.0
WHILE @@FETCH_STATUS  =  0
BEGIN
INSERT AsisteD(ID, Renglon, Personal, Registro, HoraRegistro, FechaD, FechaA, Observaciones)
VALUES(@ID, @Renglon, @Personal, 'Salida', '23:59', CONVERT(datetime, FLOOR(CONVERT(float, GETDATE()))), CONVERT(datetime, GETDATE(), 103), 'No Marco Salida')
UPDATE Personal SET EstaPresente = 0 WHERE Personal = @Personal
SELECT @Renglon  =  @Renglon + 2048.0
FETCH NEXT FROM crPresenteSalida INTO @Personal
END
CLOSE crPresenteSalida
DEALLOCATE crPresenteSalida
UPDATE Personal SET EstaPresente = 0 WHERE EstaPresente = 1
END
END

