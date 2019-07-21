SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spExportacionXML
(
@Estacion		int,
@Modulo		varchar(5),
@Mov			varchar(20),
@ID			int,
@Ok			int OUTPUT,
@OkRef		varchar(255) OUTPUT
)

AS
BEGIN
DECLARE	@Documento				varchar(MAX),
@Exportacion			varchar(50),
@Orden					int,
@Seccion				varchar(50),
@SubSeccionDe			varchar(50),
@Vista					varchar(100),
@ExpresionFinal			varchar(100),
@DocumentoSeccion		varchar(MAX),
@LargoExpresionFinal	int,
@PosicionFinal			int,
@Select					varchar(MAX),
@NSelect				nvarchar(MAX),
@OrdenSeccion			int,
@Cierre					bit,
@DocumentoTexto			varchar(MAX),
@ApuntadorTexto			binary(16),
@ApuntadorPrologo		binary(16),
@IDSeccion				int,
@Prologo				varchar(200),
@Codificacion			varchar(20),
@ApuntadorValido		int
SET @OrdenSeccion = 0
DELETE MovExportacionDatos WHERE Estacion = @Estacion
SELECT @Exportacion = Exportacion, @Documento = Documento FROM MovExportacion WHERE Modulo = @Modulo AND Mov = @Mov
SELECT @Codificacion = Codificacion FROM MovExportacion WITH(NOLOCK) WHERE Exportacion = @Exportacion
SET @Prologo = '<?xml version = "1.0" encoding = "'+ RTRIM(@Codificacion) +'" ?>'
DECLARE crMovExportacionD CURSOR FAST_FORWARD FOR
SELECT Orden, Seccion, SubSeccionDe, Vista, ISNULL(ExpresionFinal,''), Cierre, RID
FROM MovExportacionD
WITH(NOLOCK) WHERE Exportacion = @Exportacion
ORDER BY Orden
OPEN crMovExportacionD
FETCH NEXT FROM crMovExportacionD  INTO @Orden, @Seccion, @SubSeccionDe, @Vista, @ExpresionFinal, @Cierre, @IDSeccion
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF NULLIF(RTRIM(@ExpresionFinal),'') IS NOT NULL
BEGIN
SET @LargoExpresionFinal = LEN(@ExpresionFinal)
SET @PosicionFinal = CHARINDEX(@ExpresionFinal,@Documento,1)
IF @PosicionFinal > 0 SET @PosicionFinal = (@PosicionFinal - 1) + @LargoExpresionFinal ELSE SET @PosicionFinal = LEN(@Documento)
SET @DocumentoSeccion = SUBSTRING(@Documento,1,@PosicionFinal)
SET @Documento = SUBSTRING(@Documento,@PosicionFinal + 1, LEN(@Documento))
END
ELSE
BEGIN
SET @DocumentoSeccion = @Documento
SET @Documento = ''
END
EXEC spMovParsearSeccion @Estacion, @Modulo, @Mov, @Exportacion, @IDSeccion, @Vista, @ID, @DocumentoSeccion, @SubSeccionDe, @Cierre, @Select OUTPUT, @OrdenSeccion OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SET @NSelect = @Select
EXECUTE sp_executesql @NSelect
END
FETCH NEXT FROM crMovExportacionD  INTO @Orden, @Seccion, @SubSeccionDe, @Vista, @ExpresionFinal, @Cierre, @IDSeccion
END
CLOSE crMovExportacionD
DEALLOCATE crMovExportacionD
DELETE FROM MovXML WHERE Modulo = @Modulo AND ModuloID = @ID
DECLARE crMovExportacionDatos CURSOR FAST_FORWARD FOR
SELECT Documento
FROM MovExportacionDatos WITH(NOLOCK)
WHERE  Estacion = @Estacion AND Modulo = @Modulo AND ModuloID = @ID
ORDER BY OrdenExportacion
OPEN crMovExportacionDatos
FETCH NEXT FROM crMovExportacionDatos  INTO @DocumentoTexto
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF NOT EXISTS(SELECT * FROM MovXML WHERE Modulo = @Modulo AND ModuloID = @ID)
INSERT MovXML (Modulo, ModuloID, DocumentoTexto) VALUES (@Modulo, @ID, @DocumentoTexto)
ELSE
BEGIN
SELECT @ApuntadorTexto = TEXTPTR(DocumentoTexto) FROM MovXML WHERE Modulo = @Modulo AND ModuloID = @ID
SET @ApuntadorValido = TEXTVALID('MovXML.DocumentoTexto',@ApuntadorPrologo)
IF @ApuntadorValido = 1
UPDATETEXT MovXML.DocumentoTexto @ApuntadorTexto NULL 0 @DocumentoTexto
END
FETCH NEXT FROM crMovExportacionDatos  INTO @DocumentoTexto
END
CLOSE crMovExportacionDatos
DEALLOCATE crMovExportacionDatos
SELECT @ApuntadorPrologo = TEXTPTR(DocumentoTexto) FROM MovXML WHERE Modulo = @Modulo AND ModuloID = @ID
SET @ApuntadorValido = TEXTVALID('MovXML.DocumentoTexto',@ApuntadorPrologo)
IF @ApuntadorValido = 1
UPDATETEXT MovXML.DocumentoTexto @ApuntadorPrologo 0 0 @Prologo
EXEC spLimpiarXML @Exportacion, @Modulo, @ID
UPDATE MovXML  WITH(ROWLOCK) SET DocumentoXML = DocumentoTexto WHERE Modulo = @Modulo AND ModuloID = @ID
END

