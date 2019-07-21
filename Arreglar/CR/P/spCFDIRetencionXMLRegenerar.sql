SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionXMLRegenerar
@Estacion		int,
@Empresa		varchar(5),
@Usuario		varchar(10)

AS
BEGIN
DECLARE @ID				int,
@IDAnt			int,
@UUID				varchar(50),
@Documento		varchar(max),
@Proveedor		varchar(10),
@Sucursal			int,
@ConceptoSAT		varchar(5),
@Version			varchar(5),
@Modulo			varchar(5),
@ModuloAnt		varchar(5),
@ModuloID			int,
@ModuloIDAnt		int,
@AlmacenarXML		bit,
@AlmacenarPDF		bit,
@Archivo			varchar(255),
@Reporte			varchar(100),
@Ruta				varchar(255),
@Para				varchar(255),
@Asunto			varchar(max),
@Mensaje			varchar(max),
@Enviar			bit,
@EnviarXML		bit,
@EnviarPDF		bit,
@ArchivoXML		varchar(255),
@NombreArchivo	varchar(255),
@Ok				int,
@OkRef			varchar(255),
@Ejerc			int,
@MesIni			int,
@MesFin			int
SELECT @Version = Version FROM CFDIRetencionCfg
SELECT @IDAnt = 0
WHILE(1=1)
BEGIN
SELECT @ID = MIN(ID)
FROM ListaID
WHERE Estacion = @Estacion
AND ID > @IDAnt
IF @ID IS NULL BREAK
SELECT @IDAnt = @ID
SELECT @UUID = NULL, @Documento = NULL, @Proveedor = NULL, @ConceptoSAT = NULL, @AlmacenarXML = NULL, @AlmacenarPDF = NULL, @Archivo = NULL, @Reporte = NULL, @Ruta = NULL, @Para = NULL, @Asunto = NULL, @Mensaje = NULL, @Enviar = NULL, @EnviarXML = NULL, @EnviarPDF = NULL, @ArchivoXML = NULL, @Sucursal = NULL, @NombreArchivo = NULL
SELECT @UUID = UUID, @Documento = Documento, @Proveedor = Proveedor, @ConceptoSAT = ConceptoSAT, @Ejerc = Ejercicio, @MesIni = Periodo, @MesFin = Periodo FROM CFDRetencion WHERE Modulo = 'CXP' AND ModuloID = @ID
SELECT @Sucursal = Sucursal FROM Cxp WHERE ID = @ID
EXEC spCFDIRetencionAlmacenar @Empresa, @Usuario, @Proveedor, @ConceptoSAT, @Version,
@Ejerc, @MesIni, @MesFin,
@AlmacenarXML OUTPUT, @AlmacenarPDF OUTPUT, @Archivo OUTPUT, @Reporte OUTPUT, @Ruta OUTPUT, @Para OUTPUT, @Asunto OUTPUT, @Mensaje OUTPUT, @Enviar OUTPUT, @EnviarXML OUTPUT, @EnviarPDF OUTPUT, 0
SELECT @ArchivoXML = @Ruta + '\' + @Archivo + '.xml'
EXEC spCrearRuta @Ruta, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spRegenerarArchivo @ArchivoXML, @Documento, @Ok OUTPUT, @OkRef OUTPUT
SELECT @NombreArchivo = REPLACE(REPLACE(@ArchivoXML, @Ruta, ''), '\', '')
IF @Ok IS NULL
BEGIN
SELECT @ModuloAnt = ''
WHILE(1=1)
BEGIN
SELECT @Modulo = MIN(Modulo)
FROM CFDRetencion
WHERE UUID = @UUID
AND Modulo > @ModuloAnt
IF @Modulo IS NULL BREAK
SELECT @ModuloAnt = @Modulo
SELECT @ModuloIDAnt = 0
WHILE(1=1)
BEGIN
SELECT @ModuloID = MIN(ModuloID)
FROM CFDRetencion
WHERE UUID = @UUID
AND Modulo = @Modulo
AND ModuloID > @ModuloIDAnt
IF @ModuloID IS NULL BREAK
SELECT @ModuloIDAnt = @ModuloID
IF NOT EXISTS(SELECT * FROM AnexoMov WHERE Rama = @Modulo AND ID = @ModuloID AND CFD = 1 AND Nombre = @NombreArchivo)
INSERT AnexoMov (Sucursal,  Rama,    ID,        Nombre,         Direccion,  Tipo,      Icono, CFD)
VALUES (@Sucursal, @Modulo, @ModuloID, @NombreArchivo, @ArchivoXML, 'Archivo', 17,    1)
END
END
END
END
SELECT 'Proceso Concluido'
RETURN
END

