SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgMovSituacionLBC ON MovSituacionL

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@ModuloNuevo	varchar(5),
@ModuloAnterior 	varchar(5),
@MovNuevo		varchar(20),
@MovAnterior	varchar(20),
@EstatusNuevo	varchar(15),
@EstatusAnterior	varchar(15),
@Flujo				varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ModuloNuevo    = Modulo, @MovNuevo    = Mov, @EstatusNuevo    = Estatus, @Flujo = Flujo FROM Inserted
SELECT @ModuloAnterior = Modulo, @MovAnterior = Mov, @EstatusAnterior = Estatus FROM Deleted
IF @ModuloNuevo = @ModuloAnterior AND @MovNuevo = @MovAnterior AND @EstatusNuevo = @EstatusAnterior RETURN
IF @Flujo = 'CONDICIONAL' RETURN
IF @EstatusNuevo IS NULL
BEGIN
DELETE MovSituacionD WHERE ID IN (SELECT ID FROM MovSituacion WHERE Modulo = @ModuloAnterior AND Mov = @MovAnterior AND Estatus = @EstatusAnterior)
DELETE MovSituacion WHERE Modulo = @ModuloAnterior AND Mov = @MovAnterior AND Estatus = @EstatusAnterior
END ELSE
BEGIN
UPDATE MovSituacion
SET Modulo  = @ModuloNuevo,
Mov     = @MovNuevo,
Estatus = @EstatusNuevo
WHERE Modulo  = @ModuloAnterior
AND Mov     = @MovAnterior
AND Estatus = @EstatusAnterior
END
END

