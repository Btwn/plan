SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisLic
@Licenciamiento	varchar(50)

AS BEGIN
CREATE TABLE #Resultado (ID int IDENTITY(1,1) NOT NULL PRIMARY KEY, Valor varchar(255) COLLATE Database_Default NULL)
INSERT #Resultado (Valor) SELECT '<?xml version="1.0" encoding="windows-1252"?>'
INSERT #Resultado (Valor) SELECT '<Intelisis Contenido="Licenciamiento">'
INSERT #Resultado (Valor) SELECT '<Licenciamiento>'
INSERT #Resultado (Valor) SELECT '<Licenciamiento>'+@Licenciamiento+'</Licenciamiento>'
INSERT #Resultado (Valor) SELECT '<Formas>'
INSERT #Resultado (Valor) SELECT '<Forma Clave="'+RTRIM(Forma)+'"/>' FROM IntelisisLicForma WHERE Licenciamiento = @Licenciamiento
INSERT #Resultado (Valor) SELECT '</Formas>'
INSERT #Resultado (Valor) SELECT '</Licenciamiento>'
INSERT #Resultado (Valor) SELECT '<LicenciamientoLlave></LicenciamientoLlave>'
INSERT #Resultado (Valor) SELECT '</Intelisis>'
SELECT Valor FROM #Resultado ORDER BY ID
DROP TABLE #Resultado
RETURN
END

