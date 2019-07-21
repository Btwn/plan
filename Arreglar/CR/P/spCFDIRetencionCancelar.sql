SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionCancelar
@ID					int,
@EstacionTrabajo	int

AS
BEGIN
DECLARE @Estatus				varchar(20),
@Empresa				varchar(10),
@Sucursal				int,
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
@Proveedor			varchar(10),
@ConceptoSAT			varchar(5),
@UUID					varchar(50),
@Modulo				varchar(5),
@ModuloAnt			varchar(5),
@ModuloID				int,
@ModuloIDAnt			int,
@OkDesc           	varchar(255),
@OkTipo           	varchar(50)
DELETE FROM ListaID WHERE ID = @ID AND Estacion = @EstacionTrabajo
BEGIN TRAN
SELECT @FechaCancelacion = GETDATE()
SELECT @Estatus = Estatus, @Empresa = Empresa, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Proveedor = Proveedor FROM Cxp WHERE ID = @ID
SELECT @ConceptoSAT = ConceptoSAT, @UUID = UUID FROM CFDRetencion WHERE Modulo = 'CXP' AND ModuloID = @ID
EXEC spCFDIRetencionCancelarTimbre 'CXP', @ID, @Proveedor, @ConceptoSAT, @Estatus, @Empresa, @Sucursal, @FirmaCancelacionSAT OUTPUT, @DatosXML OUTPUT, @AlmacenarRuta OUTPUT, @Archivo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
SELECT @Ruta = dbo.fnCFDINominaObtenerRuta(@AlmacenarRuta)+ '\'
SELECT @NombreArchivo = REPLACE(@AlmacenarRuta, @Ruta, '')
IF @Ok IS NULL
BEGIN
EXEC spCrearRuta @Ruta, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spRegenerarArchivo @AlmacenarRuta, @DatosXML, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
DELETE CFDIRetencionProvPeriodo WHERE ID = @ID
UPDATE CFDRetencion
SET Cancelado		= 1,
AcuseCancelado	= @DatosXml,
RutaAcuse		= @AlmacenarRuta,
SelloCancelacionSAT = @FirmaCancelacionSAT
WHERE Modulo = 'CXP'
AND ModuloID = @ID
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
INSERT INTO CFDRetencionCancelado(
Modulo, ModuloID, Proveedor, ConceptoSAT, Fecha, Ejercicio, Periodo, Empresa, Mov, MovID, Serie, Folio, RFCEmisor, RFCReceptor, Aprobacion, Importe, Impuesto1, Impuesto2, Retencion1, Retencion2, noCertificado, Sello, CadenaOriginal, Documento, GenerarPDF, Timbrado, UUID, FechaTimbrado, Moneda, TipoCambio, EsPago, SelloSAT, TFDVersion, noCertificadoSAT, TFDCadenaOriginal, VersionCFD, SelloCancelacionSAT, Cancelado, AcuseCancelado, RutaAcuse, montoTotExent, montoTotGrav, montoTotOperacion, montoTotRet,  FechaCancelacion)
SELECT Modulo, ModuloID, Proveedor, ConceptoSAT, Fecha, Ejercicio, Periodo, Empresa, Mov, MovID, Serie, Folio, RFCEmisor, RFCReceptor, Aprobacion, Importe, Impuesto1, Impuesto2, Retencion1, Retencion2, noCertificado, Sello, CadenaOriginal, Documento, GenerarPDF, Timbrado, UUID, FechaTimbrado, Moneda, TipoCambio, EsPago, SelloSAT, TFDVersion, noCertificadoSAT, TFDCadenaOriginal, VersionCFD, SelloCancelacionSAT, Cancelado, AcuseCancelado, RutaAcuse, montoTotExent, montoTotGrav, montoTotOperacion, montoTotRet, @FechaCancelacion
FROM CFDRetencion
WHERE Modulo = 'CXP'
AND ModuloID = @ID
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
DELETE CFDRetencion
WHERE Modulo = 'CXP'
AND ModuloID = @ID
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
UPDATE Cxp SET CFDRetencionTimbrado = 0 WHERE ID = @ID
IF NOT EXISTS(SELECT * FROM AnexoMov WHERE Rama = 'CXP' AND ID = @ID AND CFD = 1 AND Direccion = @AlmacenarRuta)
INSERT AnexoMov ( Sucursal, Rama,   ID,  Nombre,         Direccion,     Tipo,      Icono, CFD)
VALUES (@Sucursal, 'CXP', @ID, @NombreArchivo, @AlmacenarRuta, 'Archivo', 17,   1)
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
UPDATE CFDRetencion
SET Cancelado		= 1,
AcuseCancelado	= @DatosXml,
RutaAcuse		= @AlmacenarRuta,
SelloCancelacionSAT = @FirmaCancelacionSAT
WHERE Modulo = @Modulo
AND ModuloID = @ModuloID
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
INSERT INTO CFDRetencionCancelado(
Modulo, ModuloID, Proveedor, ConceptoSAT, Fecha, Ejercicio, Periodo, Empresa, Mov, MovID, Serie, Folio, RFCEmisor, RFCReceptor, Aprobacion, Importe, Impuesto1, Impuesto2, Retencion1, Retencion2, noCertificado, Sello, CadenaOriginal, Documento, GenerarPDF, Timbrado, UUID, FechaTimbrado, Moneda, TipoCambio, EsPago, SelloSAT, TFDVersion, noCertificadoSAT, TFDCadenaOriginal, VersionCFD, SelloCancelacionSAT, Cancelado, AcuseCancelado, RutaAcuse, montoTotExent, montoTotGrav, montoTotOperacion, montoTotRet,  FechaCancelacion)
SELECT Modulo, ModuloID, Proveedor, ConceptoSAT, Fecha, Ejercicio, Periodo, Empresa, Mov, MovID, Serie, Folio, RFCEmisor, RFCReceptor, Aprobacion, Importe, Impuesto1, Impuesto2, Retencion1, Retencion2, noCertificado, Sello, CadenaOriginal, Documento, GenerarPDF, Timbrado, UUID, FechaTimbrado, Moneda, TipoCambio, EsPago, SelloSAT, TFDVersion, noCertificadoSAT, TFDCadenaOriginal, VersionCFD, SelloCancelacionSAT, Cancelado, AcuseCancelado, RutaAcuse, montoTotExent, montoTotGrav, montoTotOperacion, montoTotRet, @FechaCancelacion
FROM CFDRetencion
WHERE Modulo = @Modulo
AND ModuloID = @ModuloID
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
DELETE CFDRetencion
WHERE Modulo = @Modulo
AND ModuloID = @ModuloID
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
IF @Modulo = 'CXP'
UPDATE Cxp SET CFDRetencionTimbrado = 0 WHERE ID = @ModuloID
ELSE IF @Modulo = 'GAS'
UPDATE Gasto SET CFDRetencionTimbrado = 0 WHERE ID = @ModuloID
ELSE IF @Modulo = 'COMS'
UPDATE Compra SET CFDRetencionTimbrado = 0 WHERE ID = @ModuloID
ELSE IF @Modulo = 'DIN'
UPDATE Dinero SET CFDRetencionTimbrado = 0 WHERE ID = @ModuloID
IF NOT EXISTS(SELECT * FROM AnexoMov WHERE Rama = @Modulo AND ID = @ModuloID AND CFD = 1 AND Direccion = @AlmacenarRuta)
INSERT AnexoMov ( Sucursal,  Rama,    ID,        Nombre,         Direccion,     Tipo,      Icono, CFD)
VALUES (@Sucursal, @Modulo, @ModuloID, @NombreArchivo, @AlmacenarRuta, 'Archivo', 17,   1)
END
END
END
END
IF @Ok IS NULL
BEGIN
SELECT @OkRef = NULL
COMMIT TRAN
END
ELSE
BEGIN
ROLLBACK TRAN
SELECT @OkDesc = Descripcion,
@OkTipo = Tipo
FROM MensajeLista
WHERE Mensaje = @Ok
END
SELECT @Ok, @OkDesc, @OkTipo, @OkRef, NULL
END

