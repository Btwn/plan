SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCteCtoAC ON CteCto

FOR INSERT, UPDATE
AS BEGIN
IF dbo.fnEstaSincronizando() = 1 RETURN
INSERT CteCtoHist (
Cliente, ID, Fecha,     Nombre, ApellidoPaterno, ApellidoMaterno, Atencion, Tratamiento, Cargo, Grupo, FechaNacimiento, Telefonos, Extencion, eMail, Fax, PedirTono, EnviarA, Tipo, Sexo, Usuario)
SELECT Cliente, ID, GETDATE(), Nombre, ApellidoPaterno, ApellidoMaterno, Atencion, Tratamiento, Cargo, Grupo, FechaNacimiento, Telefonos, Extencion, eMail, Fax, PedirTono, EnviarA, Tipo, Sexo, Usuario
FROM Inserted
END

