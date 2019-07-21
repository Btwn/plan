SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTableLlavePrimariaOD
@Tabla		varchar(100),
@Origen		varchar(100),
@Destino	varchar(100),
@Llave		varchar(8000) OUTPUT

AS BEGIN
DECLARE
@Campo	varchar(255)
SELECT @Llave = ''
DECLARE crLlave CURSOR LOCAL FOR
SELECT syscolumns.name
FROM sysobjects
JOIN syscolumns
JOIN sysindexes ON syscolumns.id=sysindexes.id
JOIN sysindexkeys ON sysindexes.id = sysindexkeys.id
AND sysindexes.indid=sysindexkeys.indid
ON sysobjects.id = syscolumns.id
WHERE sysindexes.status & 0x800 = 0x800
AND syscolumns.colid=sysindexkeys.colid
AND sysobjects.name=@Tabla
OPEN crLlave
FETCH NEXT FROM crLlave INTO @Campo
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2 AND NULLIF(RTRIM(@Campo), '') IS NOT NULL
BEGIN
IF @Llave <> '' SELECT @Llave = @Llave +' AND '
SELECT @Llave = @Llave + @Origen+'.'+@Campo+' = '+@Destino+'.'+@Campo
END
FETCH NEXT FROM crLlave INTO @Campo
END
CLOSE crLlave
DEALLOCATE crLlave
RETURN
END

