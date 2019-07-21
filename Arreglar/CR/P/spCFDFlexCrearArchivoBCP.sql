SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexCrearArchivoBCP
@Estacion		int,
@Archivo		varchar(255),
@XML			varchar(max),
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@ManejadorObjeto			int,
@IDArchivo					int,
@Shell						varchar(8000)
DELETE FROM ArchivoTemp WHERE Estacion = @Estacion
INSERT ArchivoTemp (Estacion, Datos) VALUES (@Estacion, @XML)
SELECT @Shell = 'BCP "SELECT Datos FROM Desarrollo3500.dbo.ArchivoTemp WHERE Estacion = ' + CONVERT(varchar,@Estacion) + '"  queryout '+ @Archivo + ' -c -Cutf-16 -T'
EXEC xp_cmdshell @Shell
SET @shell = 'C' + CHAR(58) + '\charsc ' + @Archivo +  ' /scs=utf-16 /dcs=utf-8 /replace'
EXEC xp_cmdshell @Shell
END

