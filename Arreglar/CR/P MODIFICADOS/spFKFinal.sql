SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spFKFinal

AS BEGIN
DECLARE
@TablaOrigen	varchar(100),
@CampoOrigen	varchar(100),
@CampoOrigen2	varchar(100),
@CampoOrigen3	varchar(100),
@CampoOrigen4	varchar(100),
@CampoOrigen5	varchar(100),
@TablaDestino	varchar(100),
@CampoDestino	varchar(100),
@CampoDestino2	varchar(100),
@CampoDestino3	varchar(100),
@CampoDestino4	varchar(100),
@CampoDestino5	varchar(100),
@Eliminar		bit,
@FK			varchar(100),
@CantidadCampos	int
IF (SELECT ISNULL(FK, 0) FROM Version) = 0 RETURN
DECLARE crFK CURSOR FOR
SELECT TablaOrigen, CampoOrigen, NULLIF(CampoOrigen2,''), NULLIF(CampoOrigen3,''), NULLIF(CampoOrigen4,''), NULLIF(CampoOrigen5,''), TablaDestino, NULLIF(CampoDestino,''), NULLIF(CampoDestino2,''), NULLIF(CampoDestino3,''), NULLIF(CampoDestino4,''), NULLIF(CampoDestino5,''), ISNULL(Eliminar,0)
FROM FK
OPEN crFK
FETCH NEXT FROM crFK  INTO @TablaOrigen, @CampoOrigen, @CampoOrigen2, @CampoOrigen3, @CampoOrigen4, @CampoOrigen5, @TablaDestino, @CampoDestino, @CampoDestino2, @CampoDestino3, @CampoDestino4, @CampoDestino5, @Eliminar
WHILE @@FETCH_STATUS = 0
BEGIN
IF EXISTS(SELECT * FROM sysobjects WHERE id = object_id('dbo.' + RTRIM(LTRIM(@TablaOrigen))) and TYPE = 'U') AND EXISTS(SELECT * FROM sysobjects WHERE id = object_id('dbo.' + RTRIM(LTRIM(@TablaDestino))) and TYPE = 'U') AND @Eliminar = 0
BEGIN
SET @CantidadCampos = CASE ISNULL(@CampoOrigen,'')  WHEN '' THEN 0 ELSE 1 END + CASE ISNULL(@CampoOrigen2,'') WHEN '' THEN 0 ELSE 1 END + CASE ISNULL(@CampoOrigen3,'') WHEN '' THEN 0 ELSE 1 END + CASE ISNULL(@CampoOrigen4,'') WHEN '' THEN 0 ELSE 1 END + CASE ISNULL(@CampoOrigen5,'') WHEN '' THEN 0 ELSE 1 END
IF @CantidadCampos = 1
BEGIN
SELECT @FK = 'FK_'+@TablaOrigen+'_'+@CampoOrigen
if not exists(select * from sysobjects where name = @FK and type = 'F')
BEGIN
EXEC('ALTER TABLE dbo.'+@TablaOrigen+' WITH NOCHECK ADD CONSTRAINT '+@FK+' FOREIGN KEY ('+@CampoOrigen+') REFERENCES dbo.'+@TablaDestino+' ('+@CampoDestino+') NOT FOR REPLICATION')
EXEC('ALTER TABLE dbo.'+@TablaOrigen+' NOCHECK CONSTRAINT '+@FK)
END
END ELSE
IF @CantidadCampos = 2
BEGIN
SELECT @FK = 'FK_'+@TablaOrigen+'_'+@CampoOrigen+'_'+@CampoOrigen2
if not exists(select * from sysobjects where name = @FK and type = 'F')
BEGIN
EXEC('ALTER TABLE dbo.'+@TablaOrigen+' WITH NOCHECK ADD CONSTRAINT '+@FK+' FOREIGN KEY ('+@CampoOrigen+', '+@CampoOrigen2+') REFERENCES dbo.'+@TablaDestino+' ('+@CampoDestino+', '+@CampoDestino2+') NOT FOR REPLICATION')
EXEC('ALTER TABLE dbo.'+@TablaOrigen+' NOCHECK CONSTRAINT '+@FK)
END
END ELSE
IF @CantidadCampos = 3
BEGIN
SELECT @FK = 'FK_'+@TablaOrigen+'_'+@CampoOrigen+'_'+@CampoOrigen2+'_'+@CampoOrigen3
if not exists(select * from sysobjects where name = @FK and type = 'F')
BEGIN
EXEC('ALTER TABLE dbo.'+@TablaOrigen+' WITH NOCHECK ADD CONSTRAINT '+@FK+' FOREIGN KEY ('+@CampoOrigen+', '+@CampoOrigen2+', '+@CampoOrigen3+') REFERENCES dbo.'+@TablaDestino+' ('+@CampoDestino+', '+@CampoDestino2+', '+@CampoDestino3+') NOT FOR REPLICATION')
EXEC('ALTER TABLE dbo.'+@TablaOrigen+' NOCHECK CONSTRAINT '+@FK)
END
END ELSE
IF @CantidadCampos = 4
BEGIN
SELECT @FK = 'FK_'+@TablaOrigen+'_'+@CampoOrigen+'_'+@CampoOrigen2+'_'+@CampoOrigen3+'_'+@CampoOrigen4
if not exists(select * from sysobjects where name = @FK and type = 'F')
BEGIN
EXEC('ALTER TABLE dbo.'+@TablaOrigen+' WITH NOCHECK ADD CONSTRAINT '+@FK+' FOREIGN KEY ('+@CampoOrigen+', '+@CampoOrigen2+', '+@CampoOrigen3+', '+@CampoOrigen4+') REFERENCES dbo.'+@TablaDestino+' ('+@CampoDestino+', '+@CampoDestino2+', '+@CampoDestino3+', '+@CampoDestino4+') NOT FOR REPLICATION')
EXEC('ALTER TABLE dbo.'+@TablaOrigen+' NOCHECK CONSTRAINT '+@FK)
END
END ELSE
IF @CantidadCampos = 5
BEGIN
SELECT @FK = 'FK_'+@TablaOrigen+'_'+@CampoOrigen+'_'+@CampoOrigen2+'_'+@CampoOrigen3+'_'+@CampoOrigen4+'_'+@CampoOrigen5
if not exists(select * from sysobjects where name = @FK and type = 'F')
BEGIN
EXEC('ALTER TABLE dbo.'+@TablaOrigen+' WITH NOCHECK ADD CONSTRAINT '+@FK+' FOREIGN KEY ('+@CampoOrigen+', '+@CampoOrigen2+', '+@CampoOrigen3+', '+@CampoOrigen4+', '+@CampoOrigen5+') REFERENCES dbo.'+@TablaDestino+' ('+@CampoDestino+', '+@CampoDestino2+', '+@CampoDestino3+', '+@CampoDestino4+', '+@CampoDestino5+') NOT FOR REPLICATION')
EXEC('ALTER TABLE dbo.'+@TablaOrigen+' NOCHECK CONSTRAINT '+@FK)
END
END
END ELSE
IF EXISTS(SELECT * FROM sysobjects WHERE id = object_id('dbo.' + RTRIM(LTRIM(@TablaOrigen))) and TYPE = 'U') AND EXISTS(SELECT * FROM sysobjects WHERE id = object_id('dbo.' + RTRIM(LTRIM(@TablaDestino))) and TYPE = 'U') AND @Eliminar = 1
BEGIN
SET @CantidadCampos = CASE ISNULL(@CampoOrigen,'')  WHEN '' THEN 0 ELSE 1 END + CASE ISNULL(@CampoOrigen2,'') WHEN '' THEN 0 ELSE 1 END + CASE ISNULL(@CampoOrigen3,'') WHEN '' THEN 0 ELSE 1 END + CASE ISNULL(@CampoOrigen4,'') WHEN '' THEN 0 ELSE 1 END + CASE ISNULL(@CampoOrigen5,'') WHEN '' THEN 0 ELSE 1 END
IF @CantidadCampos = 1
BEGIN
SELECT @FK = 'FK_'+@TablaOrigen+'_'+@CampoOrigen
if exists(select * from sysobjects where name = @FK and type = 'F')
BEGIN
EXEC('ALTER TABLE dbo.'+@TablaOrigen+' DROP CONSTRAINT '+@FK)
END
END ELSE
IF @CantidadCampos = 2
BEGIN
SELECT @FK = 'FK_'+@TablaOrigen+'_'+@CampoOrigen+'_'+@CampoOrigen2
if exists(select * from sysobjects where name = @FK and type = 'F')
BEGIN
EXEC('ALTER TABLE dbo.'+@TablaOrigen+' DROP CONSTRAINT '+@FK)
END
END ELSE
IF @CantidadCampos = 3
BEGIN
SELECT @FK = 'FK_'+@TablaOrigen+'_'+@CampoOrigen+'_'+@CampoOrigen2+'_'+@CampoOrigen3
if exists(select * from sysobjects where name = @FK and type = 'F')
BEGIN
EXEC('ALTER TABLE dbo.'+@TablaOrigen+' DROP CONSTRAINT '+@FK)
END
END ELSE
IF @CantidadCampos = 4
BEGIN
SELECT @FK = 'FK_'+@TablaOrigen+'_'+@CampoOrigen+'_'+@CampoOrigen2+'_'+@CampoOrigen3+'_'+@CampoOrigen4
if exists(select * from sysobjects where name = @FK and type = 'F')
BEGIN
EXEC('ALTER TABLE dbo.'+@TablaOrigen+' DROP CONSTRAINT '+@FK)
END
END ELSE
IF @CantidadCampos = 5
BEGIN
SELECT @FK = 'FK_'+@TablaOrigen+'_'+@CampoOrigen+'_'+@CampoOrigen2+'_'+@CampoOrigen3+'_'+@CampoOrigen4+'_'+@CampoOrigen5
if exists(select * from sysobjects where name = @FK and type = 'F')
BEGIN
EXEC('ALTER TABLE dbo.'+@TablaOrigen+' DROP CONSTRAINT '+@FK)
END
END
END
FETCH NEXT FROM crFK  INTO @TablaOrigen, @CampoOrigen, @CampoOrigen2, @CampoOrigen3, @CampoOrigen4, @CampoOrigen5, @TablaDestino, @CampoDestino, @CampoDestino2, @CampoDestino3, @CampoDestino4, @CampoDestino5, @Eliminar
END
CLOSE crFK
DEALLOCATE crFK
DELETE FROM FK
END

