SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocGenerarInsercionesPlantilla
@Modulo		varchar(5),
@eDoc		varchar(50)

AS BEGIN
DECLARE
@InsercioneDoc		varchar(max)
DECLARE @Insercion TABLE
(
RID			int identity(1,1),
Datos			varchar(max)
)
INSERT @Insercion (Datos)
SELECT '/********************************* ' + ISNULL(@Modulo,'') + '-' + ISNULL(@eDoc,'') + '-eDoc' + ' *********************************/'
SELECT @InsercioneDoc = 'IF NOT EXISTS(SELECT * FROM eDoc WHERE Modulo = ' + dbo.fneDocComillas(Modulo) + ' AND eDoc = ' + dbo.fneDocComillas(eDoc) + ') ' +
'INSERT INTO eDoc (Modulo, eDoc, TipoXML, Documento, XSD, TipoCFD, DecimalesPorOmision, TipoCFDI, TimbrarEnTransaccion, CaracterExtendidoAASCII, ConvertirPaginaCodigo437, ConvertirComillaDobleAASCII) ' +
'SELECT ' + dbo.fneDocComillas(Modulo) + ', ' + dbo.fneDocComillas(eDoc) + ',' + CONVERT(varchar,ISNULL(TipoXML,0))+ ', ' + dbo.fneDocComillas(RTRIM(Documento)) + ',' + dbo.fneDocComillas(XSD) + ', ' + CONVERT(varchar,ISNULL(TipoCFD,0)) + ', ' +  CONVERT(varchar,ISNULL(DecimalesPorOmision,2)) + ', ' + CONVERT(varchar,ISNULL(TipoCFDI,0)) + ', ' + CONVERT(varchar,ISNULL(TimbrarEnTransaccion,0)) + ',' + CONVERT(varchar,ISNULL(CaracterExtendidoAASCII,0)) + ',' + CONVERT(varchar,ISNULL(ConvertirPaginaCodigo437,0)) + ', ' + CONVERT(varchar,ISNULL(ConvertirComillaDobleAASCII,0)) + ' '
FROM eDoc
WHERE Modulo = @Modulo
AND eDoc = @eDoc
INSERT @Insercion (Datos)
SELECT RTRIM(LTRIM(REPLACE(REPLACE(@InsercioneDoc,CHAR(10),''),CHAR(13),'')))
INSERT @Insercion (Datos)
SELECT CHAR(71) + CHAR(79)
INSERT @Insercion (Datos)
SELECT CHAR(32)
INSERT @Insercion (Datos)
SELECT '/* ' + ISNULL(@Modulo,'') + '-' + ISNULL(@eDoc,'') + '-eDocD*/'
INSERT @Insercion (Datos)
SELECT 'IF NOT EXISTS(SELECT * FROM eDocD WHERE Modulo = ' + dbo.fneDocComillas(Modulo)+ ' AND eDoc = ' + dbo.fneDocComillas(eDoc) + ' AND Seccion = ' + dbo.fneDocComillas(Seccion) + ')      INSERT INTO eDocD (Modulo, eDoc, Orden, Seccion, SubSeccionDe, Vista , Cierre, TablaSt) SELECT ' + dbo.fneDocComillas(Modulo) + ', ' + dbo.fneDocComillas(eDoc) + ', '+ CONVERT(varchar,Orden) + ',  ' + dbo.fneDocComillas(Seccion) + ',' + dbo.fneDocComillas(SubSeccionDe) + ',' + dbo.fneDocComillas(Vista) + ',' + CONVERT(varchar,ISNULL(Cierre,0)) + ',' + dbo.fneDocComillas(TablaSt) + ' '
FROM eDocD
WHERE Modulo = @Modulo
AND eDoc = @eDoc
INSERT @Insercion (Datos)
SELECT CHAR(71) + CHAR(79)
INSERT @Insercion (Datos)
SELECT CHAR(32)
INSERT @Insercion (Datos)
SELECT '/* ' + ISNULL(@Modulo,'') + '-' + ISNULL(@eDoc,'') + '-eDocDMapeoCampo*/'
INSERT @Insercion (Datos)
SELECT 'IF NOT EXISTS(SELECT * FROM eDocDMapeoCampo eddmc JOIN eDocD edd ON edd.RID = eddmc.IDSeccion WHERE eddmc.Modulo = ' + dbo.fneDocComillas(edd.Modulo) + ' AND eddmc.eDoc = ' + dbo.fneDocComillas(edd.eDoc) + ' AND edd.Seccion = ' + dbo.fneDocComillas(edd.Seccion) + ' AND eddmc.CampoXML = ' + dbo.fneDocComillas(eddmc.CampoXML) + ')  INSERT eDocDMapeoCampo (Modulo, eDoc, IDSeccion, CampoXML, CampoVista, FormatoOpcional, Traducir, Opcional, BorrarSiOpcional, TablaSt, Decimales, CaracterExtendidoAASCII, ConvertirPaginaCodigo437, ConvertirComillaDobleAASCII, NumericoNuloACero) SELECT ' + dbo.fneDocComillas(edd.Modulo) + ', ' + dbo.fneDocComillas(edd.eDoc) + ', (SELECT RID FROM eDocD WHERE Modulo = ' + dbo.fneDocComillas(edd.Modulo) + ' AND eDoc = ' + dbo.fneDocComillas(edd.eDoc) + ' AND Seccion = ' + dbo.fneDocComillas(edd.Seccion) + '), ' + dbo.fneDocComillas(eddmc.CampoXML) + ',  ' + dbo.fneDocComillas(eddmc.CampoVista) + ',' + dbo.fneDocComillas(eddmc.FormatoOpcional) + ',' + CONVERT(varchar,ISNULL(eddmc.Traducir,0)) + ',' + CONVERT(varchar,ISNULL(eddmc.Opcional,0)) + ',' + dbo.fneDocComillas(eddmc.BorrarSiOpcional) + ', ' + dbo.fneDocComillas(eddmc.TablaSt) + ', ' + CONVERT(varchar,ISNULL(Decimales,2)) + ',' + CONVERT(varchar,ISNULL(eddmc.CaracterExtendidoAASCII,0)) + ',' + CONVERT(varchar,ISNULL(eddmc.ConvertirPaginaCodigo437,0)) + ',' + CONVERT(varchar,ISNULL(eddmc.ConvertirComillaDobleAASCII,0)) + ',' + CONVERT(varchar,ISNULL(eddmc.NumericoNuloACero,0)) + ' ' 
FROM eDocDMapeoCampo eddmc JOIN eDocD edd
ON edd.eDoc = eddmc.eDoc AND edd.Modulo = eddmc.Modulo AND eddmc.IDSeccion = edd.RID
WHERE eddmc.eDoc = @eDoc
AND eddmc.Modulo = @Modulo
INSERT @Insercion (Datos)
SELECT CHAR(71) + CHAR(79)
INSERT @Insercion (Datos)
SELECT CHAR(32)
SELECT * FROM @Insercion ORDER BY RID
END

