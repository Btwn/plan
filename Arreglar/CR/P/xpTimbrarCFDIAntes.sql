SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpTimbrarCFDIAntes
@Modulo				char(5),
@ID					int,
@Documento			varchar(max),
@CadenaOriginal		varchar(max)
AS BEGIN
DECLARE
@OkRef		varchar(255),
@versionCFD	varchar(10),
@Empresa		varchar(10),
@XML          xml,
@iDatos		int,
@Ruta			varchar(255),
@RutaXML		varchar(255),
@Prefijo		varchar(255),
@fecha		datetime,
@Mov			varchar(20),
@MovId		varchar(20),
@Ok			int
EXEC spMovInfo @ID, @Modulo, @Empresa = @Empresa OUTPUT, @Mov = @Mov OUTPUT, @MovID = @MovID OUTPUT
SELECT @VersionCFD = Version FROM EmpresaCFD WHERE Empresa = @Empresa
SELECT @OkRef = NULL
IF @VersionCFD >= '3.2'
BEGIN
IF EXISTS (SELECT * FROM CFD WHERE Modulo = @Modulo AND ModuloID = @ID AND Timbrado = 1 AND SelloSAT IS NOT NULL)
SELECT @OkRef = 'Este Movimiento Ya Fue Timbrado'
IF CHARINDEX(':cfdi',@Documento,1)=0
SELECT @OkRef = 'El XML del Movimiento no es un CFDI'
SELECT @XML = CONVERT(XML,REPLACE(REPLACE(@Documento,'encoding="UTF-8"','encoding="Windows-1252"'),'?<?xml','<?xml'))
SET @Prefijo = '<ns xmlns' + CHAR(58) + 'cfdi="http' + CHAR(58) + '//www.sat.gob.mx/cfd/3" xmlns' + CHAR(58) + 'tfd="http' + CHAR(58) + '//www.sat.gob.mx/TimbreFiscalDigital"/>'
EXEC sp_xml_preparedocument @iDatos OUTPUT, @XML, @Prefijo
SET @Ruta = '/cfdi' + CHAR(58)
SET @RutaXML = @Ruta + 'Comprobante'
SELECT @fecha = fecha
FROM OPENXML (@iDatos, @RutaXML, 1) WITH (fecha varchar(100))
IF DATEDIFF(hour,@Fecha, getdate()) > 72 SELECT @OkRef = 'Han Pasado Mas de 72 Horas Para Timbrar Este Comprobante'
EXEC sp_xml_removedocument @iDatos
END
EXEC xpCFDIRegistrarlog 'ANTES DE TIMBRAR', @Empresa, @Modulo, @ID, @Mov, @MovID, @Documento, 0, @Ok, @OkRef, NULL
IF @OkRef IS NOT NULL
SELECT ' - '+@OkRef
ELSE
SELECT ''
RETURN
END

