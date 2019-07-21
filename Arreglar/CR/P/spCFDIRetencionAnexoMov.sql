SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionAnexoMov
@Estacion				int,
@ID						int,
@Proveedor				varchar(10),
@Empresa				varchar(5),
@Version				varchar(5),
@ConceptoSAT			varchar(50),
@RIDAnt                 varchar(20),
@UUID					varchar(50),
@Ruta					varchar(255),
@ArchivoQRCode			varchar(255),
@ArchivoXML				varchar(255),
@ArchivoPDF				varchar(255),
@EsPDF					bit,
@Ok						int				OUTPUT,
@OkRef					varchar(255)	OUTPUT

AS
BEGIN
DECLARE @NomArchivoQRCode	varchar(255),
@NomArchivoXML	varchar(255),
@NomArchivoPDF	varchar(255),
@ModuloPago		varchar(5),
@ModuloPagoAnt	varchar(5),
@IDPago			int,
@IDPagoAnt		int,
@ModuloAux		varchar(5),
@ModuloAuxAnt		varchar(5),
@ModuloID			int,
@ModuloIDAnt		int,
@Sucursal			int
SELECT @Ruta = @Ruta + '\'
SELECT @NomArchivoQRCode = REPLACE(@ArchivoQRCode, @Ruta, ''),
@NomArchivoXML	   = REPLACE(@ArchivoXML, @Ruta, ''),
@NomArchivoPDF	   = REPLACE(@ArchivoPDF, @Ruta, '')
IF NULLIF(RTRIM(@UUID), '') IS NOT NULL
BEGIN
SELECT @Sucursal = Sucursal FROM Cxp WHERE ID = @ID
IF @EsPDF = 1
IF NOT EXISTS(SELECT * FROM AnexoMov WHERE Rama = 'CXP' AND ID = @ID AND CFD = 1 AND Nombre = @NomArchivoPDF)
INSERT AnexoMov (Sucursal,  Rama,  ID,  Nombre,         Direccion,  Tipo,      Icono, CFD)
VALUES (@Sucursal, 'CXP', @ID, @NomArchivoPDF, @ArchivoPDF, 'Archivo', 745,   1)
IF NOT EXISTS(SELECT * FROM AnexoMov WHERE Rama = 'CXP' AND ID = @ModuloID AND CFD = 1 AND Nombre = @NomArchivoXML)
INSERT AnexoMov (Sucursal,  Rama,  ID,  Nombre,         Direccion,  Tipo,      Icono, CFD)
VALUES (@Sucursal, 'CXP', @ID, @NomArchivoXML, @ArchivoXML, 'Archivo', 17,    1)
SELECT @ModuloPagoAnt = ''
WHILE(1=1)
BEGIN
SELECT @ModuloPago = MIN(ModuloPago)
FROM CFDIRetencionD
WHERE EstacionTrabajo = @Estacion
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
AND ModuloPago > @ModuloPagoAnt
IF @ModuloPago IS NULL BREAK
SELECT @ModuloPagoAnt = @ModuloPago
SELECT @IDPagoAnt = 0
WHILE(1=1)
BEGIN
IF(SELECT ISNULL(AgruparConceptoSATRetenciones,0) FROM EmpresaCfg2 WHERE Empresa = @Empresa) = 1
SELECT @IDPago = MIN(IDPago)
FROM CFDIRetencionD
WHERE EstacionTrabajo = @Estacion
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
AND ModuloPago = @ModuloPago
AND MovID = @RIDAnt
AND IDPago > @IDPagoAnt
ELSE
SELECT @IDPago = MIN(IDPago)
FROM CFDIRetencionD
WHERE EstacionTrabajo = @Estacion
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
AND ModuloPago = @ModuloPago
AND IDPago > @IDPagoAnt
IF @IDPago IS NULL BREAK
SELECT @IDPagoAnt = @IDPago
SELECT @Sucursal = Sucursal
FROM CFDIRetencionD
WHERE EstacionTrabajo = @Estacion
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
AND ModuloPago = @ModuloPago
AND IDPago = @IDPago
IF @EsPDF = 1
IF NOT EXISTS(SELECT * FROM AnexoMov WHERE Rama = @ModuloPago AND ID = @IDPago AND CFD = 1 AND Nombre = @NomArchivoPDF)
INSERT AnexoMov (Sucursal,  Rama,        ID,      Nombre,         Direccion,  Tipo,      Icono, CFD)
VALUES (@Sucursal, @ModuloPago, @IDPago, @NomArchivoPDF, @ArchivoPDF, 'Archivo', 745,   1)
IF NOT EXISTS(SELECT * FROM AnexoMov WHERE Rama = @ModuloPago AND ID = @IDPago AND CFD = 1 AND Nombre = @NomArchivoXML)
INSERT AnexoMov (Sucursal,  Rama,        ID,      Nombre,         Direccion,  Tipo,      Icono, CFD)
VALUES (@Sucursal, @ModuloPago, @IDPago, @NomArchivoXML, @ArchivoXML, 'Archivo', 17,    1)
SELECT @ModuloAuxAnt = ''
WHILE(1=1)
BEGIN
SELECT @ModuloAux = MIN(Modulo)
FROM CFDIRetencionD
WHERE EstacionTrabajo = @Estacion
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
AND ModuloPago = @ModuloPago
AND IDPago = @IDPago
AND Modulo > @ModuloAuxAnt
IF @ModuloAux IS NULL BREAK
SELECT @ModuloAuxAnt = @ModuloAux
SELECT @ModuloIDAnt = 0
WHILE(1=1)
BEGIN
SELECT @ModuloID = MIN(ModuloID)
FROM CFDIRetencionD
WHERE EstacionTrabajo = @Estacion
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
AND ModuloPago = @ModuloPago
AND IDPago = @IDPago
AND Modulo = @ModuloAux
AND ModuloID > @ModuloIDAnt
IF @ModuloID IS NULL BREAK
SELECT @ModuloIDAnt = @ModuloID
SELECT @Sucursal = Sucursal
FROM CFDIRetencionD
WHERE EstacionTrabajo = @Estacion
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
AND ModuloPago = @ModuloPago
AND IDPago = @IDPago
AND Modulo = @ModuloAux
AND ModuloID = @ModuloID
IF @EsPDF = 1
IF NOT EXISTS(SELECT * FROM AnexoMov WHERE Rama = @ModuloAux AND ID = @ModuloID AND CFD = 1 AND Nombre = @NomArchivoPDF)
INSERT AnexoMov (Sucursal,  Rama,       ID,        Nombre,         Direccion,  Tipo,      Icono, CFD)
VALUES (@Sucursal, @ModuloAux, @ModuloID, @NomArchivoPDF, @ArchivoPDF, 'Archivo', 745,   1)
IF NOT EXISTS(SELECT * FROM AnexoMov WHERE Rama = @ModuloAux AND ID = @ModuloID AND CFD = 1 AND Nombre = @NomArchivoXML)
INSERT AnexoMov (Sucursal,  Rama,       ID,        Nombre,         Direccion,  Tipo,      Icono, CFD)
VALUES (@Sucursal, @ModuloAux, @ModuloID, @NomArchivoXML, @ArchivoXML, 'Archivo', 17,    1)
END
END
END
END
END
RETURN
END

