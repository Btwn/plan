SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spFK3
@TablaOrigen		varchar(100),
@CampoOrigen		varchar(100),
@CampoOrigen2	varchar(100),
@CampoOrigen3	varchar(100),
@TablaDestino	varchar(100),
@CampoDestino	varchar(100),
@CampoDestino2	varchar(100),
@CampoDestino3	varchar(100)

AS BEGIN
DECLARE
@FK	varchar(100)
IF (SELECT ISNULL(FK, 0) FROM Version) = 0 RETURN
IF NOT EXISTS(SELECT * FROM sysobjects WHERE id = object_id('dbo.' + RTRIM(LTRIM(@TablaOrigen))) and TYPE = 'U') OR NOT EXISTS(SELECT * FROM sysobjects WHERE id = object_id('dbo.' + RTRIM(LTRIM(@TablaDestino))) and TYPE = 'U')
EXEC spFKInsertarRegistro @TablaOrigen, @CampoOrigen, @CampoOrigen2, @CampoOrigen3, NULL, NULL, @TablaDestino, @CampoDestino, @CampoDestino2, @CampoDestino3, NULL, NULL, 0
ELSE
BEGIN
SELECT @FK = 'FK_'+@TablaOrigen+'_'+@CampoOrigen+'_'+@CampoOrigen2+'_'+@CampoOrigen3
if not exists(select * from sysobjects where name = @FK and type = 'F')
BEGIN
EXEC('ALTER TABLE dbo.'+@TablaOrigen+' WITH NOCHECK ADD CONSTRAINT '+@FK+' FOREIGN KEY ('+@CampoOrigen+', '+@CampoOrigen2+', '+@CampoOrigen3+') REFERENCES dbo.'+@TablaDestino+' ('+@CampoDestino+', '+@CampoDestino2+', '+@CampoDestino3+') NOT FOR REPLICATION')
EXEC('ALTER TABLE dbo.'+@TablaOrigen+' NOCHECK CONSTRAINT '+@FK)
END
END
END

