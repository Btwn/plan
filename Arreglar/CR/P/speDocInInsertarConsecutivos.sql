SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocInInsertarConsecutivos
@eDocIn					varchar(50),
@Ruta					varchar(50),
@XML					xml = NULL OUTPUT,
@Ok						int = NULL OUTPUT,
@OkRef					varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Tabla						varchar(50),
@ConsecutivoNombre			varchar(100),
@ConsecutivoInicial			int,
@ConsecutivoIncremento		int,
@CampoXMLRuta					varchar(max),
@CampoXMLAtributo				varchar(255)
SELECT @XML = CONVERT(xml,ISNULL(NULLIF(CONVERT(varchar(max),@XML),''),Documento)) FROM eDocIn WHERE eDocIn = @eDocIn
IF NULLIF(CONVERT(varchar(max),@XML),'') IS NULL SELECT @Ok = 72230, @OkRef = '(' + @eDocIn + ')'
DECLARE creDocInRutaTablaD CURSOR FOR
SELECT RTRIM(ISNULL(ConsecutivoNombre,'')), ConsecutivoInicial, ConsecutivoIncremento, RTRIM(ISNULL(CampoXMLRuta,'')), RTRIM(ISNULL(CampoXMLAtributo,'')), RTRIM(ISNULL(Tablas,''))
FROM eDocInRutaTablaD
WHERE ISNULL(EsConsecutivo,0) = 1
AND Ruta = @Ruta
AND eDocIn = @eDocIn
OPEN creDocInRutaTablaD
FETCH NEXT FROM creDocInRutaTablaD INTO @ConsecutivoNombre, @ConsecutivoInicial, @ConsecutivoIncremento, @CampoXMLRuta, @CampoXMLAtributo, @Tabla
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF NULLIF(@Tabla,'') IS NULL OR NOT EXISTS(SELECT 1 FROM SysTabla WHERE RTRIM(SysTabla) = @Tabla) SELECT @Ok = 72300, @OkRef = '(' + @eDocIn + ', ' + @Ruta + ', ' + @Tabla + ')' ELSE
IF NULLIF(@ConsecutivoNombre,'') IS NULL SELECT @Ok = 72250, @OkRef = '(' + @eDocIn + ', ' + @Ruta + ', ' + @Tabla + ', ' + @ConsecutivoNombre + ')' ELSE
IF NULLIF(@ConsecutivoInicial,'') IS NULL SELECT @Ok = 72260, @OkRef = '(' + @eDocIn + ', ' + @Ruta + ', ' + @Tabla + ', ' + @ConsecutivoNombre + ')' ELSE
IF NULLIF(@ConsecutivoIncremento,'') IS NULL SELECT @Ok = 72270, @OkRef = '(' + @eDocIn + ', ' + @Ruta + ', ' + @Tabla + ', ' + @ConsecutivoNombre + ')' ELSE
IF NULLIF(@CampoXMLRuta,'') IS NULL SELECT @Ok = 72280, @OkRef = '(' + @eDocIn + ', ' + @Ruta + ', ' + @Tabla + ', ' + @ConsecutivoNombre + ')' ELSE
IF NULLIF(@CampoXMLAtributo,'') IS NULL SELECT @Ok = 72290, @OkRef = '(' + @eDocIn + ', ' + @Ruta + ', ' + @Tabla + ', ' + @ConsecutivoNombre + ')'
EXEC speDocInInsertarConsecutivo @XML OUTPUT, @CampoXMLRuta, @ConsecutivoNombre, @ConsecutivoInicial, @ConsecutivoIncremento, @Ok OUTPUT, @OkRef OUTPUT
FETCH NEXT FROM creDocInRutaTablaD INTO @ConsecutivoNombre, @ConsecutivoInicial, @ConsecutivoIncremento, @CampoXMLRuta, @CampoXMLAtributo, @Tabla
END
CLOSE creDocInRutaTablaD
DEALLOCATE creDocInRutaTablaD
END

