SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spADD_INDEX
@Tabla 	varchar(100),
@Indice	varchar(100),
@Campos	varchar(255)

AS BEGIN
if not exists (SELECT * FROM sysindexes, sysobjects WHERE sysobjects.name = @Tabla AND sysindexes.name = @Indice AND sysobjects.id = sysindexes.id)
EXEC('CREATE INDEX '+@Indice+' ON '+@Tabla+' ('+@Campos+')')
END

