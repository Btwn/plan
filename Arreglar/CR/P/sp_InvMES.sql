SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sp_InvMES
@ID    INT,
@iSolicitud  INT,
@Version  FLOAT,
@Resultado  VARCHAR(MAX) = NULL OUTPUT,
@Ok    INT = NULL OUTPUT,
@OkRef   VARCHAR(255) = NULL OUTPUT

AS BEGIN
SET NOCOUNT ON;
DECLARE @query NVARCHAR(500)
DECLARE @SQL NVARCHAR(MAX), @ReferenciaIntelisisService VARCHAR(50)
DECLARE @inv VARCHAR(MAX), @xml VARCHAR(MAX), @ReferenciaIS VARCHAR(100), @SubReferencia VARCHAR(255)
DECLARE @Articulo VARCHAR(50), @Lote VARCHAR(250), @Almacen VARCHAR(50), @Existencia FLOAT, @Pos INT, @Art VARCHAR(50)
DECLARE @Coste FLOAT, @cont INTEGER, @SubCuenta VARCHAR(50)
DECLARE @temp TABLE(
Articulo VARCHAR(50),
Lote VARCHAR(250),
Almacen VARCHAR(50),
Existencia FLOAT,
Coste FLOAT
)
DECLARE @tabla TABLE(
Articulo VARCHAR(50),
SubCuenta VARCHAR(50),
Lote VARCHAR(250),
Almacen VARCHAR(50),
Existencia FLOAT,
Coste FLOAT
)
SELECT @ReferenciaIntelisisService = ReferenciaIntelisisService FROM OPENXML (@iSolicitud,'/Intelisis')
WITH (ReferenciaIntelisisService VARCHAR(255))
DECLARE @Cadena VARCHAR(500), @ResultadoBD VARCHAR(500), @Base VARCHAR(500)
SET @SQL = N'SET ANSI_NULLS ON ' +
N'SET ANSI_WARNINGS ON ' +
N'SET QUOTED_IDENTIFIER ON ' +
N'BEGIN TRY ' +
N'SELECT @Cadena = stringconexion
FROM QPFactoryQPL.dbo.relsucintelisis
WHERE nombrelogico = ' + CHAR(39) + @ReferenciaIntelisisService + CHAR(39) + N'END TRY ' +
N'BEGIN CATCH ' +
N'  SELECT @Ok = @@ERROR,  @OkRef = ERROR_MESSAGE() ' +
N'  IF XACT_STATE() = -1 ' +
N'  BEGIN ' +
N'    ROLLBACK TRAN ' +
N'    SET @OkRef = ' + CHAR(39) + N'Error  ' + CHAR(39) + N' + CONVERT(VARCHAR,@Ok) + ' + CHAR(39) + N', ' + CHAR(39) + N' + @OkRef ' +
N'    RAISERROR(@OkRef,20,1) WITH LOG ' +
N'  END ' +
N'END CATCH '
EXEC sp_executesql @SQL, N'@Cadena VARCHAR(500) OUTPUT, @Ok INT OUTPUT, @OkRef VARCHAR(255) OUTPUT', @Cadena = @Cadena OUTPUT, @OK = @OK OUTPUT, @OkRef = @OkRef OUTPUT
DECLARE @db_name VARCHAR(50)
SELECT @Base = SUBSTRING(@Cadena, CHARINDEX('Catalog=',@Cadena)+ 8, LEN(@Cadena))
SELECT @ResultadoBD = SUBSTRING(@Base, 1, CHARINDEX(';',@Base)-1)
SET @db_name = @ResultadoBD
/************* AGREGAR CONSULTA A VARIABLE @query PARA IMPORTAR ARTICULOS DESDE QP *************/
SET @query = 'SELECT s.item AS CodigoArticulo, s.identificacion AS NumeroLote, ia.intalmacen AS almacen,
s.fisico As Existencia, i.scosto AS PrecioCosteMedio
FROM ' + @db_name + '.dbo.stock s
INNER JOIN ' + @db_name + '.dbo.items i ON i.item = s.item AND i.version = s.version ' +
'INNER JOIN ' + @db_name + '.dbo.intelisisalmacen ia ON ia.qpfalmacen = s.almacen'
INSERT INTO @temp
EXEC sp_executesql @query
DECLARE INVEN CURSOR FOR
SELECT Articulo, Lote, Almacen, Existencia, Coste
FROM @temp
OPEN INVEN
FETCH NEXT FROM INVEN INTO @Articulo , @Lote, @Almacen, @Existencia, @Coste
WHILE @@FETCH_STATUS = 0
BEGIN
SET @Articulo = LTRIM(RTRIM(@Articulo))+ '\'
SET @Pos = CHARINDEX('\', @Articulo, 1)
IF REPLACE(@Articulo, '\', '') <> ''
BEGIN
SET @cont = 0
WHILE @Pos > 0
BEGIN
IF @cont = 0
BEGIN
SET @Art = LTRIM(RTRIM(LEFT(@Articulo, @Pos - 1)))
SET @cont = @cont + 1
SET @SubCuenta = ''
END
ELSE
BEGIN
SET @SubCuenta = LTRIM(RTRIM(LEFT(@Articulo, @Pos - 1)))
SET @cont = 0
INSERT INTO @tabla(Articulo, SubCuenta, Lote, Almacen, Existencia, Coste)
VALUES (@Art, @SubCuenta, @Lote, @Almacen, @Existencia, @Coste)
END
SET @Articulo = RIGHT(@Articulo, LEN(@Articulo) - @Pos)
SET @Pos = CHARINDEX('\', @Articulo, 1)
IF @cont = 1 AND @Pos = 0
BEGIN
INSERT INTO @tabla(Articulo, SubCuenta, Lote, Almacen, Existencia, Coste)
VALUES (@Art, @SubCuenta, @Lote, @Almacen, @Existencia, ISNULL(@Coste,0.0))
END
END
END
FETCH NEXT FROM INVEN INTO @Articulo , @Lote, @Almacen, @Existencia, @Coste
END
CLOSE INVEN
DEALLOCATE INVEN
SET @inv = convert(VARCHAR(MAX), (SELECT * FROM @tabla INV FOR XML AUTO))
IF @Ok IS NULL
BEGIN
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' +
CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') +
CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(VARCHAR ,@Version),'') + CHAR(34) +
'><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(VARCHAR,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) +
ISNULL(CONVERT(VARCHAR,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) +
' ReferenciaIntelisisService=' + CHAR(34) + ISNULL(@ReferenciaIntelisisService,'') + CHAR(34) + '>' +
CONVERT(VARCHAR(MAX),@inv) + '</Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
END
END

