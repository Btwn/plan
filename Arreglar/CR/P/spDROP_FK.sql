SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDROP_FK
@TablaOrigen		varchar(100),
@CampoOrigen		varchar(100),
@TablaDestino	varchar(100),
@CampoDestino	varchar(100)

AS BEGIN
DECLARE
@FK	varchar(100)
IF (SELECT ISNULL(FK, 0) FROM Version) = 0 RETURN
IF NOT EXISTS(SELECT * FROM sysobjects WHERE id = object_id('dbo.' + RTRIM(LTRIM(@TablaOrigen))) and TYPE = 'U') OR NOT EXISTS(SELECT * FROM sysobjects WHERE id = object_id('dbo.' + RTRIM(LTRIM(@TablaDestino))) and TYPE = 'U')
EXEC spFKInsertarRegistro @TablaOrigen, @CampoOrigen, NULL, NULL, NULL, NULL, @TablaDestino, @CampoDestino, NULL, NULL, NULL, NULL, 1
ELSE
BEGIN
SELECT @FK = 'FK_'+@TablaOrigen+'_'+@CampoOrigen
if exists(select * from sysobjects where name = @FK and type = 'F')
BEGIN
EXEC('ALTER TABLE dbo.'+@TablaOrigen+' DROP CONSTRAINT '+@FK)
END
END
END

