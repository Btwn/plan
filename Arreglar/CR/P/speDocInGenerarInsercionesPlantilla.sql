SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocInGenerarInsercionesPlantilla
@eDocIn		varchar(50)

AS BEGIN
DECLARE
@InsercioneDoc		varchar(max)
DECLARE @Insercion TABLE
(
RID			int identity(1,1),
Datos			varchar(max)
)
INSERT @Insercion (Datos)
SELECT '/********************************* ' + ISNULL(@eDocIn,'') + '-eDocIn' + ' *********************************/'
INSERT @Insercion (Datos)
SELECT ' EXEC sp_msforeachtable "ALTER TABLE ? DISABLE TRIGGER  all" '
SELECT @InsercioneDoc = 'IF NOT EXISTS(SELECT * FROM eDocIn WHERE eDocIn = ' + dbo.fneDocComillas(eDocIn) + ') ' +
'INSERT INTO eDocIn (eDocIn, Descripcion, Tipo, Documento) ' +
'SELECT ' + dbo.fneDocComillas(eDocIn) + ', ' + dbo.fneDocComillas(Descripcion)+ ', ' + dbo.fneDocComillas(Tipo) + ',' +  dbo.fneDocComillas(RTRIM(Documento))
FROM eDocIn
WHERE eDocIn = @eDocIn
INSERT @Insercion (Datos)
SELECT RTRIM(LTRIM(REPLACE(REPLACE(@InsercioneDoc,CHAR(10),''),CHAR(13),'')))
INSERT @Insercion (Datos)
SELECT CHAR(71) + CHAR(79)
INSERT @Insercion (Datos)
SELECT CHAR(32)
INSERT @Insercion (Datos)
SELECT '/* ' + ISNULL(@eDocIn,'') + '-eDocInRuta*/'
INSERT @Insercion (Datos)
SELECT 'IF NOT EXISTS(SELECT * FROM eDocInRuta WHERE  eDocIn = ' + dbo.fneDocComillas(@eDocIn)+' )  BEGIN Print 1 '
INSERT @Insercion (Datos)
SELECT 'INSERT INTO eDocInRuta (eDocIn, Ruta, Descripcion, XSD, Modulo, Mov, Afectar, VigenciaDe, VigenciaA, AntesAfectar)
SELECT ' + dbo.fneDocComillas(eDocIn) + ', ' + dbo.fneDocComillas(Ruta) + ', '+ dbo.fneDocComillas(Descripcion) + ','+ CONVERT(varchar(max),ISNULL(XSD,0)) + ','  + dbo.fneDocComillas(Modulo) + ',' + dbo.fneDocComillas(Mov) + ',' + CONVERT(varchar,ISNULL(Afectar,0)) + ',' + dbo.fneDocComillas(CONVERT(varchar,VigenciaDe)) + ',' + dbo.fneDocComillas(CONVERT(varchar,VigenciaA))+','+ dbo.fneDocComillas(CONVERT(varchar,AntesAfectar))
FROM eDocInRuta
WHERE eDocIn = @eDocIn
INSERT @Insercion (Datos)
SELECT 'END'
INSERT @Insercion (Datos)
SELECT CHAR(71) + CHAR(79)
INSERT @Insercion (Datos)
SELECT CHAR(32)
INSERT @Insercion (Datos)
SELECT '/* ' + ISNULL(@eDocIn,'') + '-eDocInRutaD*/'
INSERT @Insercion (Datos)
SELECT 'IF NOT EXISTS(SELECT * FROM eDocInRutaD WHERE  eDocIn = ' + dbo.fneDocComillas(@eDocIn)+') BEGIN  Print 1 '
INSERT @Insercion (Datos)
SELECT' INSERT eDocInRutaD (eDocIn, Ruta, OperadorLogico, Tipo)
SELECT ' + dbo.fneDocComillas(eDocIn) + ', ' + dbo.fneDocComillas(Ruta) + ','+ dbo.fneDocComillas(OperadorLogico) +','+ dbo.fneDocComillas(Tipo)
FROM eDocInRutaD
WHERE eDocIn = @eDocIn
INSERT @Insercion (Datos)
SELECT 'END'
INSERT @Insercion (Datos)
SELECT CHAR(71) + CHAR(79)
INSERT @Insercion (Datos)
SELECT CHAR(32)
INSERT @Insercion (Datos)
SELECT '/* ' + ISNULL(@eDocIn,'') + '-eDocInRutaDCondicion*/'
INSERT @Insercion (Datos)
SELECT 'IF NOT EXISTS(SELECT * FROM eDocInRutaDCondicion WHERE  eDocIn = ' + dbo.fneDocComillas(@eDocIn) + ')  BEGIN  Print 1 '
INSERT @Insercion (Datos)
SELECT 'INSERT eDocInRutaDCondicion (eDocIn, Ruta, GUID, Operando1, Operador, Operando2 )
SELECT ' + dbo.fneDocComillas(c.eDocIn) + ', ' + dbo.fneDocComillas(c.Ruta) + ','+'(SELECT GUID FROM eDocInRutaD WHERE eDocIn ='+ dbo.fneDocComillas(@eDocIn) +' AND Ruta = '+dbo.fneDocComillas(c.Ruta)+' AND OperadorLogico = '+CHAR(39)+'Y'+CHAR(39)+'),'+ dbo.fneDocComillas(Operando1)+ ','+ dbo.fneDocComillas(Operador) + ','+ dbo.fneDocComillas(Operando2)
FROM eDocInRutaDCondicion c JOIN eDocInRutaD d ON c.eDocIn = d.eDocIn AND c.Ruta = d.Ruta AND c.GUID = d.GUID
WHERE c.eDocIn = @eDocIn AND d.OperadorLogico = 'Y'
UNION ALL
SELECT 'INSERT eDocInRutaDCondicion (eDocIn, Ruta, GUID, Operando1, Operador, Operando2 )
SELECT ' + dbo.fneDocComillas(c.eDocIn) + ', ' + dbo.fneDocComillas(c.Ruta) + ','+'(SELECT GUID FROM eDocInRutaD WHERE eDocIn ='+dbo.fneDocComillas(@eDocIn)+' AND Ruta = '+dbo.fneDocComillas(c.Ruta)+' AND OperadorLogico = '+CHAR(39)+'O'+CHAR(39)+'),'+ dbo.fneDocComillas(Operando1)+ ','+ dbo.fneDocComillas(Operador) + ','+ dbo.fneDocComillas(Operando2)
FROM eDocInRutaDCondicion c JOIN eDocInRutaD d ON c.eDocIn = d.eDocIn AND c.Ruta = d.Ruta AND c.GUID = d.GUID
WHERE c.eDocIn = @eDocIn AND d.OperadorLogico = 'O'
INSERT @Insercion (Datos)
SELECT 'END'
INSERT @Insercion (Datos)
SELECT CHAR(71) + CHAR(79)
INSERT @Insercion (Datos)
SELECT CHAR(32)
INSERT @Insercion (Datos)
SELECT '/* ' + ISNULL(@eDocIn,'') + '-eDocInRutaTabla */'
INSERT @Insercion (Datos)
SELECT 'IF NOT EXISTS(SELECT * FROM eDocInRutaTabla WHERE  eDocIn = ' + dbo.fneDocComillas(@eDocIn)+') BEGIN  Print 1 '
INSERT @Insercion (Datos)
SELECT 'INSERT eDocInRutaTabla (eDocIn, Ruta, Tablas, DetalleDe, Nodo, NodoNombre)
SELECT ' + dbo.fneDocComillas(eDocIn) + ', ' + dbo.fneDocComillas(Ruta) + ','+ dbo.fneDocComillas(Tablas) + ','+ dbo.fneDocComillas(DetalleDe) + ','+ dbo.fneDocComillas(Nodo) + ','+ dbo.fneDocComillas(NodoNombre)
FROM eDocInRutaTabla
WHERE eDocIn = @eDocIn
INSERT @Insercion (Datos)
SELECT 'END'
INSERT @Insercion (Datos)
SELECT CHAR(71) + CHAR(79)
INSERT @Insercion (Datos)
SELECT CHAR(32)
INSERT @Insercion (Datos)
SELECT '/* ' + ISNULL(@eDocIn,'') + '-eDocInRutaTablaD */'
INSERT @Insercion (Datos)
SELECT DISTINCT 'IF NOT EXISTS(SELECT * FROM eDocInRutaTablaD WHERE  eDocIn = ' + dbo.fneDocComillas(@eDocIn) +')  BEGIN  Print 1 '
INSERT @Insercion (Datos)
SELECT 'INSERT eDocInRutaTablaD (eDocIn, Ruta, Tablas, CampoXML, ExpresionXML, CampoTabla, CampoXMLTipo, CampoXMLRuta,CampoXMLAtributo, CampoXMLTipoXML, EsIndependiente, EsConsecutivo, ConsecutivoNombre, ConsecutivoInicial, ConsecutivoIncremento, Traducir, TablaSt)
SELECT ' + dbo.fneDocComillas(eDocIn) + ', ' + dbo.fneDocComillas(Ruta) + ','+ dbo.fneDocComillas(Tablas) + ','+ dbo.fneDocComillas(CampoXML) + ','+ dbo.fneDocComillas(ExpresionXML) + ','+ dbo.fneDocComillas(CampoTabla) + ','+ dbo.fneDocComillas(CampoXMLTipo) + ','+ dbo.fneDocComillas(CampoXMLRuta)+', '+ dbo.fneDocComillas(CampoXMLAtributo) + ', ' + dbo.fneDocComillas(CampoXMLTipoXML)+', ' + dbo.fneDocComillas(EsIndependiente)+', ' + dbo.fneDocComillas(EsConsecutivo)+', ' + dbo.fneDocComillas(ConsecutivoNombre)+', ' + dbo.fneDocComillas(ConsecutivoInicial)+', ' + dbo.fneDocComillas(ConsecutivoIncremento)+', ' + dbo.fneDocComillas(Traducir)+', ' + dbo.fneDocComillas(TablaSt)
FROM eDocInRutaTablaD
WHERE eDocIn = @eDocIn
INSERT @Insercion (Datos)
SELECT 'END '
INSERT @Insercion (Datos)
SELECT 'GO'
INSERT @Insercion (Datos)
SELECT 'EXEC sp_msforeachtable "ALTER TABLE ? ENABLE TRIGGER all" '
INSERT @Insercion (Datos)
SELECT CHAR(71) + CHAR(79)
INSERT @Insercion (Datos)
SELECT CHAR(32)
SELECT * FROM @Insercion ORDER BY RID
END

