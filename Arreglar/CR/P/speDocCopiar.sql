SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocCopiar
@Estacion		int,
@OModulo		varchar(5),
@OeDoc			varchar(50),
@DModulo		varchar(5),
@DeDoc			varchar(50)

AS BEGIN
DECLARE
@Transaccion		varchar(50),
@Ok					int,
@OkRef				varchar(255),
@Orden				int,
@IDSeccion			int,
@Seccion			varchar(50),
@SubSeccionDe		varchar(50),
@Vista				varchar(100),
@Cierre				bit,
@TablaSt			varchar(50),
@IDSeccionGenerar	int
SET @Transaccion = 'speDocCopiar' + RTRIM(LTRIM(CONVERT(varchar,@Estacion)))
BEGIN TRANSACTION @Transaccion
INSERT eDoc (Modulo,   eDoc,   TipoXML, Documento, XSD, TipoCFD, DecimalesPorOmision, TipoCFDI, CaracterExtendidoAASCII, ConvertirPaginaCodigo437, ConvertirComillaDobleAASCII)
SELECT  @DModulo, @DeDoc, TipoXML, Documento, XSD, TipoCFD, DecimalesPorOmision, TipoCFDI, CaracterExtendidoAASCII, ConvertirPaginaCodigo437, ConvertirComillaDobleAASCII
FROM  eDoc
WHERE  Modulo = @OModulo
AND  eDoc = @OeDoc
IF @@ERROR <> 0 SET @Ok = 1
DECLARE creDocD CURSOR FOR
SELECT Orden, Seccion, SubSeccionDe, Vista, Cierre, TablaSt, RID
FROM eDocD
WHERE Modulo = @OModulo
AND eDoc = @OeDoc
OPEN creDocD
FETCH NEXT FROM creDocD INTO @Orden, @Seccion, @SubSeccionDe, @Vista, @Cierre, @TablaSt, @IDSeccion
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
INSERT eDocD (Modulo,   eDoc,   Orden,  Seccion,  SubSeccionDe,  Vista,  Cierre,  TablaSt)
VALUES (@DModulo, @DeDoc, @Orden, @Seccion, @SubSeccionDe, @Vista, @Cierre, @TablaSt)
IF @@ERROR <> 0 SET @Ok = 1
SET @IDSeccionGenerar = SCOPE_IDENTITY()
IF @Ok IS NULL
INSERT eDocDMapeoCampo (Modulo,   eDoc,   IDSeccion,         CampoXML, CampoVista, FormatoOpcional, Traducir, Opcional, BorrarSiOpcional, TablaSt, Decimales, CaracterExtendidoAASCII, ConvertirPaginaCodigo437, ConvertirComillaDobleAASCII, NumericoNuloACero) 
SELECT  @DModulo, @DeDoc, @IDSeccionGenerar, CampoXML, CampoVista, FormatoOpcional, Traducir, Opcional, BorrarSiOpcional, TablaSt, Decimales, CaracterExtendidoAASCII, ConvertirPaginaCodigo437, ConvertirComillaDobleAASCII, NumericoNuloACero  
FROM  eDocDMapeoCampo
WHERE  IDSeccion = @IDSeccion
IF @@ERROR <> 0 SET @Ok = 1
FETCH NEXT FROM creDocD INTO @Orden, @Seccion, @SubSeccionDe, @Vista, @Cierre, @TablaSt, @IDSeccion
END
CLOSE creDocD
DEALLOCATE creDocD
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION @Transaccion
SELECT 'Proceso Exitoso'
END ELSE
BEGIN
ROLLBACK TRANSACTION @Transaccion
SELECT 'ERROR: ' + CONVERT(varchar,@Ok) + (SELECT Descripcion FROM MensajeLista WHERE Mensaje = @Ok) +'. ' + ISNULL(@OkRef,'')
END
END

