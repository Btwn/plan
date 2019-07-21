SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgMovSituacionLFlujo ON MovSituacionL

FOR INSERT, UPDATE
AS
BEGIN
DECLARE @Modulo		varchar(5),
@Mov			varchar(20),
@Estatus		varchar(15),
@Situacion	varchar(50),
@Flujo		varchar(50)
IF UPDATE(Flujo)
BEGIN
SELECT @Modulo = Modulo, @Mov = Mov, @Estatus = Inserted.Estatus, @Situacion = RTRIM(@Mov) + ' ' + RTRIM(Nombre), @Flujo = Inserted.Flujo FROM Inserted JOIN Estatus ON Inserted.Estatus = Estatus.Estatus
IF NOT EXISTS(SELECT ID FROM MovSituacion WHERE Modulo = @Modulo AND Mov = @Mov AND Estatus = @Estatus AND ISNULL(EsPadre, 0) = 1) AND @Flujo = 'CONDICIONAL'
BEGIN
DELETE MovSituacion WHERE Modulo = @Modulo AND Mov = @Mov AND Estatus = @Estatus
INSERT INTO MovSituacion(
Modulo,  Mov,  Estatus,  Situacion,  PermiteAfectacion, PermiteRetroceder, PermiteBrincar, ControlUsuarios, Icono, Rama, Condicional, CondicionUsuario, SituacionVerdadero, Operador, EsPadre)
SELECT @Modulo, @Mov, @Estatus, @Situacion, 1,                 1,                 1,              0,               0,     NULL, 0,           NULL,             NULL,               'Todas',  1
END
END
RETURN
END

