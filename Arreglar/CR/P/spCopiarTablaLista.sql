SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCopiarTablaLista
@TablaO			varchar(50),
@Destino	    varchar(50)

AS BEGIN
DECLARE
@EmpresaA	char(10)
BEGIN TRANSACTION
IF @TablaO = 'Empresa'
BEGIN
IF EXISTS(SELECT * FROM sys.dm_exec_cursors(@@SPID) WHERE name = 'crCopiarTablaLista')
DEALLOCATE crCopiarTablaLista
ELSE
DECLARE crCopiarTablaLista CURSOR FOR
SELECT Empresa FROM Empresa WHERE Configuracion = @Destino
END
ELSE
IF @TablaO = 'Usuario' AND EXISTS(SELECT * FROM Usuario WHERE Configuracion = @Destino)
BEGIN
IF EXISTS(SELECT * FROM sys.dm_exec_cursors(@@SPID) WHERE name = 'crCopiarTablaLista')
DEALLOCATE crCopiarTablaLista
ELSE
DECLARE crCopiarTablaLista CURSOR FOR
SELECT Usuario FROM Usuario WHERE Configuracion = @Destino
END
IF (@TablaO = 'Usuario' AND EXISTS(SELECT * FROM Usuario WHERE Configuracion = @Destino)) OR (@TablaO = 'Empresa' AND EXISTS(SELECT * FROM Empresa WHERE Configuracion = @Destino))
BEGIN
OPEN crCopiarTablaLista
FETCH NEXT FROM crCopiarTablaLista INTO @EmpresaA
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
EXEC spCopiarTabla @TablaO, @Destino, @EmpresaA
FETCH NEXT FROM crCopiarTablaLista INTO @EmpresaA
END
CLOSE crCopiarTablaLista
DEALLOCATE crCopiarTablaLista
END
COMMIT TRANSACTION
RETURN
END

