SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCxcRef ON Cxc

FOR INSERT, UPDATE
AS BEGIN
DECLARE
@Empresa		varchar(5),
@Contacto		varchar(10),
@Mov		varchar(20),
@MovID		varchar(20),
@Referencia		varchar(50),
@FechaEmision	datetime,
@Vencimiento	datetime,
@EnviarA		int
IF dbo.fnEstaSincronizando() = 1 RETURN
IF UPDATE(Empresa) OR UPDATE(Referencia) OR UPDATE(Vencimiento)
BEGIN
SELECT @Empresa = NULLIF(RTRIM(Empresa), ''), @Contacto = NULLIF(RTRIM(Cliente), ''), @Mov = NULLIF(RTRIM(Mov), ''), @MovID = NULLIF(RTRIM(MovID), ''), @Referencia = Referencia, @FechaEmision = FechaEmision, @Vencimiento = Vencimiento, @EnviarA = ClienteEnviarA FROM Inserted
IF @Empresa IS NOT NULL AND @Contacto IS NOT NULL AND @Mov IS NOT NULL AND @MovID IS NOT NULL
BEGIN
UPDATE MovRef SET Referencia = @Referencia, FechaEmision = @FechaEmision, Vencimiento = @Vencimiento, EnviarA = @EnviarA WHERE Empresa = @Empresa AND Modulo = 'CXC' AND Contacto = @Contacto AND Mov = @Mov AND MovID = @MovID
IF @@ROWCOUNT = 0
INSERT MovRef (Empresa, Modulo, Contacto, Mov, MovID, Referencia, FechaEmision, Vencimiento, EnviarA) VALUES (@Empresa, 'CXC', @Contacto, @Mov, @MovID, @Referencia, @FechaEmision, @Vencimiento, @EnviarA)
END
END
END

