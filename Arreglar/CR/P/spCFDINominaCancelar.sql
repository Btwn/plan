SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDINominaCancelar
@ID			int,
@Personal	varchar(10)

AS
BEGIN
DECLARE @Estatus				varchar(20),
@Empresa				varchar(10),
@Sucursal				int,
@Timbrado				varchar(15),
@Ok					int,
@OkRef				varchar(255),
@FirmaCancelacionSAT	varchar(max),
@DatosXMl				varchar(max),
@AlmacenarRuta		varchar(200),
@Archivo				varchar(255),
@FechaCancelacion		datetime,
@Ruta					varchar(255),
@NombreArchivo		varchar(255),
@NoTimbrado			int,
@Mov					varchar(20),
@MovID				varchar(20),
@VersionCFD			varchar(5),
@RFCEmisor			varchar(20),
@Importe				float
SELECT @FechaCancelacion = GETDATE()
SELECT @Estatus = Estatus, @Empresa = Empresa, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID FROM Nomina WHERE ID = @ID
SELECT @Timbrado = ISNULL(Timbrado, 'No Timbrado') FROM CFDINominaRecibo WHERE ID = @ID AND Personal = @Personal
IF ISNULL(@Timbrado, 'No Timbrado') = 'Timbrado'
BEGIN
EXEC spCFDINominaCancelarTimbre 'NOM', @ID, @Personal, @Estatus, @Empresa, @Sucursal, @FirmaCancelacionSAT OUTPUT, @DatosXML OUTPUT, @AlmacenarRuta OUTPUT, @Archivo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
SELECT @Ruta = dbo.fnCFDINominaObtenerRuta(@AlmacenarRuta)+ '\'
SELECT @NombreArchivo = REPLACE(@AlmacenarRuta, @Ruta, '')
IF @Ok IS NOT NULL
UPDATE CFDINominaRecibo SET OkCancela = @Ok, OkRefCancela = @OkRef WHERE ID = @ID AND Personal = @Personal
ELSE IF @Ok IS NULL
BEGIN
IF /*@FirmaCancelacionSAT IS NOT NULL AND */@Ok IS NULL
BEGIN
UPDATE CFDNomina
SET Cancelado		= 1,
AcuseCancelado	= @DatosXml,
RutaAcuse		= @AlmacenarRuta,
SelloCancelacionSAT = @FirmaCancelacionSAT
WHERE Modulo = 'NOM'
AND ModuloID = @ID
AND Personal = @Personal
IF NOT EXISTS(SELECT * FROM AnexoMov WHERE Rama = 'NOM' AND ID = @ID AND CFD = 1 AND Direccion = @AlmacenarRuta)
INSERT AnexoMov ( Sucursal,  Rama,  ID,  Nombre,         Direccion,     Tipo,      Icono, CFD)
VALUES (@Sucursal, 'NOM', @ID, @NombreArchivo, @AlmacenarRuta, 'Archivo', 17,   1)
UPDATE CFDINominaRecibo SET Timbrado = 'No Timbrado', OkCancela = NULL, OkRefCancela = NULL WHERE ID = @ID AND Personal = @Personal
INSERT INTO CFDNominaCancelado(
Modulo, ModuloID, Personal, Fecha, Ejercicio, Periodo, Empresa, MovID, RFCEmisor, RFCReceptor, Importe, noCertificado, Sello, CadenaOriginal, Documento, Timbrado, UUID, FechaTimbrado, TipoCambio, SelloSAT, TFDVersion, noCertificadoSAT, TFDCadenaOriginal, VersionCFD, SelloCancelacionSAT, Moneda, Cancelado, AcuseCancelado, RutaAcuse,  FechaCancelacion, NoTimbrado)
SELECT Modulo, ModuloID, Personal, Fecha, Ejercicio, Periodo, Empresa, MovID, RFCEmisor, RFCReceptor, Importe, noCertificado, Sello, CadenaOriginal, Documento, Timbrado, UUID, FechaTimbrado, TipoCambio, SelloSAT, TFDVersion, noCertificadoSAT, TFDCadenaOriginal, VersionCFD, SelloCancelacionSAT, Moneda, Cancelado, AcuseCancelado, RutaAcuse, @FechaCancelacion, NoTimbrado
FROM CFDNomina
WHERE Modulo = 'NOM'
AND ModuloID = @ID
AND Personal = @Personal
SELECT @VersionCFD = VersionCFD,
@RFCEmisor = RFCEmisor,
@Importe = Importe
FROM CFDNomina
WHERE Modulo = 'NOM'
AND ModuloID = @ID
AND Personal = @Personal
EXEC spCrearRuta @Ruta, @Ok OUTPUT, @OkRef OUTPUT
EXEC spRegenerarArchivo @AlmacenarRuta, @DatosXML, @Ok OUTPUT, @OkRef OUTPUT
DELETE CFDNomina WHERE Modulo = 'NOM' AND ModuloID = @ID AND Personal = @Personal
EXEC spCFDINominaInsertar @ID, @Empresa, @Sucursal, @Mov, @MovID, @VersionCFD, '', '', @RFCEmisor, @Importe, @NoTimbrado, @Ok OUTPUT, @OkRef OUTPUT, @PersonalEsp = @Personal
UPDATE Nomina SET CFDTimbrado = 0 WHERE ID = @ID
END
END
END
SELECT NULL, NULL, NULL, NULL, NULL
END

