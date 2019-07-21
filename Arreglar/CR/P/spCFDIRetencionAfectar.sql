SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionAfectar
@Estacion		int,
@Empresa		varchar(5),
@Sucursal		int,
@Usuario		varchar(10)

AS
BEGIN
DECLARE @Proveedor		      varchar(10),
@ProveedorAnt		    varchar(10),
@ConceptoSAT		    varchar(2),
@ConceptoSATAnt	    varchar(2),
@RID                  int,
@RIDAnt				varchar(20),
@XML				        varchar(max),
@XMLComprobante	    varchar(max),
@XMLDetalle		      varchar(max),
@XMLComplemento	    varchar(max),
@XMLAddenda		      varchar(max),
@Ok				          int,
@OkRef			        varchar(255),
@MovTimbrado		    varchar(20),
@Concepto			      varchar(50),
@Version			      varchar(5),
@AlmacenarXML		    bit,
@AlmacenarPDF		    bit,
@NomArch			      varchar(255),
@ArchivoQRCode	    varchar(255),
@ArchivoXML		      varchar(255),
@ArchivoPDF		      varchar(255),
@Reporte			      varchar(100),
@Ruta				        varchar(255),
@EnviarPara		      varchar(255),
@EnviarAsunto		    varchar(255),
@EnviarMensaje	    varchar(255),
@Enviar			        bit,
@EnviarXML		      bit,
@EnviarPDF		      bit,
@RFCEmisor		      varchar(20),
@RFCReceptor		    varchar(20),
@CxID				        int,
@montoTotExent	    float,
@montoTotGrav		    float,
@montoTotOperacion  float,
@montoTotRet		    float,
@UUID				        varchar(50),
@Ejerc			        int,
@MesIni			        int,
@MesFin			        int,
@Modulo      varchar(20),
@cGasID             int,
@cContID            int,
@AgruparConceptoSAT bit
SET @Modulo = 'GAS'
SELECT @MovTimbrado = MovTimbrado,
@Concepto = Concepto,
@Version = Version
FROM CFDIRetencionCfg
SELECT @Ok = NULL, @OkRef = NULL
SELECT @AgruparConceptoSAT = ISNULL(AgruparConceptoSATRetenciones,0) FROM EmpresaCfg2 WHERE Empresa = @Empresa
IF EXISTS(SELECT ID FROM ListaModuloID WHERE ID IN (SELECT MODULOID FROM CFDIRetencionD WHERE EstacionTrabajo = @Estacion ))
BEGIN
IF @AgruparConceptoSAT = 1
DECLARE cMovimientos CURSOR FOR
SELECT ID,Modulo
FROM ListaModuloID
WHERE Estacion = @Estacion
ELSE
DECLARE cMovimientos CURSOR FOR
SELECT MIN(ID),Modulo
FROM ListaModuloID
WHERE Estacion = @Estacion
GROUP BY Modulo
OPEN cMovimientos
FETCH NEXT FROM cMovimientos INTO @cGasID,@ConceptoSAT
WHILE @@FETCH_STATUS = 0
BEGIN
IF EXISTS(SELECT * FROM CFDIRetencionD WHERE EstacionTrabajo = @Estacion AND NULLIF(RTRIM(ConceptoSAT), '') IS NULL AND Modulo = @Modulo AND ModuloID = @cGasID)
BEGIN
SELECT @Ok = 1, @OkRef = 'El Concepto ' + Concepto + ' no se ha clasificado acorde el Catálogo del SAT'
FROM CFDIRetencionD
WHERE EstacionTrabajo = @Estacion
AND NULLIF(RTRIM(ConceptoSAT), '') IS NULL
AND Modulo = @Modulo AND ModuloID = @cGasID
UPDATE CFDIRetencionD
SET Ok = @Ok,
OkRef = @OkRef
FROM CFDIRetencionD
WHERE EstacionTrabajo = @Estacion
AND NULLIF(RTRIM(ConceptoSAT), '') IS NULL
AND Modulo = @Modulo AND ModuloID = @cGasID
UPDATE CFDIRetencion
SET Ok = @Ok,
OkRef = @OkRef
FROM CFDIRetencion
WHERE EstacionTrabajo = @Estacion
AND NULLIF(RTRIM(ConceptoSAT), '') IS NULL
AND Modulo = @Modulo AND ModuloID = @cGasID
END
IF NOT EXISTS(SELECT * FROM CFDIRetencionD WHERE EstacionTrabajo = @Estacion AND Modulo = @Modulo AND ModuloID = @cGasID)
BEGIN
SELECT @Ok = 60010
END
IF @Ok IS NULL
BEGIN
SELECT @RFCEmisor = RFC FROM Empresa WHERE Empresa = @Empresa
SELECT @ProveedorAnt = ''
WHILE(1=1)
BEGIN
SELECT @Proveedor = MIN(Proveedor)
FROM CFDIRetencionD
WHERE Proveedor > @ProveedorAnt
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND Modulo = @Modulo AND ModuloID = @cGasID
IF @Proveedor IS NULL BREAK
SELECT @ProveedorAnt = @Proveedor
SELECT @RFCReceptor = NULL
SELECT @RFCReceptor = RFC FROM Prov WHERE Proveedor = @Proveedor
UPDATE CFDIRetencionD
SET Ok = NULL,
OkRef = NULL
FROM CFDIRetencionD
WHERE EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND Proveedor = @Proveedor
AND Modulo = @Modulo AND ModuloID = @cGasID
UPDATE CFDIRetencion
SET Ok = NULL,
OkRef = NULL
FROM CFDIRetencion
WHERE EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND Proveedor = @Proveedor
AND Modulo = @Modulo AND ModuloID = @cGasID
EXEC spCFDIRetencionComplementoVerificar @Estacion, @Empresa, @Sucursal, @Usuario, @Proveedor, @Ok OUTPUT, @OkRef OUTPUT
IF @OK IS NULL
BEGIN
IF @AgruparConceptoSAT = 1
SELECT @RID = MIN(RID)FROM CFDIRetencionD WHERE Proveedor = @Proveedor AND EstacionTrabajo = @Estacion AND Empresa = @Empresa AND ModuloID = @cGasID AND ConceptoSAT = @ConceptoSAT
ELSE
SELECT @ConceptoSATAnt = ''
WHILE(1=1)
BEGIN
IF @AgruparConceptoSAT = 1
BEGIN
SELECT @ConceptoSAT = ConceptoSAT ,  @RIDAnt = isnull(MovID,0)
FROM CFDIRetencionD
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND Ok IS NULL
AND Modulo = @Modulo
AND ModuloID = @cGasID
AND ConceptoSAT = @ConceptoSAT
IF @RID IS NULL BREAK
END
ELSE
BEGIN
SELECT @ConceptoSAT = MIN(ConceptoSAT)
FROM CFDIRetencionD
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND ConceptoSAT > @ConceptoSATAnt
AND Ok IS NULL
AND Modulo = @Modulo AND ModuloID = @cGasID
SELECT @RIDAnt = NULL
IF @ConceptoSAT IS NULL BREAK
SELECT @ConceptoSATAnt = @ConceptoSAT
END
SELECT @Ok = NULL, @OkRef = NULL, @CxID = NULL, @UUID = NULL, @CxID = NULL, @montoTotExent = NULL, @montoTotGrav = NULL, @montoTotOperacion = NULL,
@montoTotRet = NULL, @XML = NULL, @XMLDetalle = NULL, @XMLComplemento = NULL, @XMLAddenda = NULL, @AlmacenarXML = NULL, @AlmacenarPDF = NULL,
@NomArch = NULL, @Reporte = NULL, @Ruta = NULL, @EnviarPara = NULL, @EnviarAsunto = NULL, @EnviarMensaje = NULL, @Enviar = NULL,
@EnviarXML = NULL, @EnviarPDF = NULL
BEGIN TRAN
IF @Ok IS NULL
EXEC spCFDIRetencionGenerar @Estacion, @Empresa, @Sucursal, @Usuario, @Proveedor, @ConceptoSAT,@RIDAnt, @MovTimbrado, @Concepto, @CxID OUTPUT, @montoTotExent OUTPUT, @montoTotGrav OUTPUT, @montoTotOperacion OUTPUT, @montoTotRet OUTPUT, @Ejerc OUTPUT, @MesIni OUTPUT, @MesFin OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @CxID IS NOT NULL AND @Ok IS NULL
EXEC spCFDIRetencionProvPeriodo @Estacion, @CxID, @Empresa, @Proveedor, @ConceptoSAT, @Ok OUTPUT, @OkRef OUTPUT
IF @CxID IS NOT NULL AND @Ok IS NULL
EXEC spCFDIRetencionXMLGenerar @CxID, @Estacion, @Empresa, @Sucursal, @Usuario, @Proveedor, @ConceptoSAT,@RIDAnt, @Version, @XML = @XML OUTPUT, @XMLDetalle = @XMLDetalle OUTPUT, @XMLComplemento = @XMLComplemento OUTPUT, @XMLAddenda = @XMLAddenda OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @CxID IS NOT NULL AND @Ok IS NULL
EXEC spCFDIRetencionAlmacenar @Empresa, @Usuario, @Proveedor, @ConceptoSAT, @Version,
@Ejerc, @MesIni, @MesFin, @AlmacenarXML OUTPUT, @AlmacenarPDF OUTPUT,
@NomArch OUTPUT, @Reporte OUTPUT, @Ruta OUTPUT, @EnviarPara OUTPUT,
@EnviarAsunto OUTPUT, @EnviarMensaje OUTPUT, @Enviar OUTPUT,
@EnviarXML OUTPUT, @EnviarPDF OUTPUT, 0,@RIDAnt
IF @CxID IS NOT NULL AND @Ok IS NULL
BEGIN
SELECT @ArchivoQRCode = @Ruta + '\' + @NomArch + '.bmp',
@ArchivoXML	= @Ruta + '\' + @NomArch + '.xml',
@ArchivoPDF	= @Ruta + '\' + @NomArch + '.pdf'
EXEC spCrearRuta @Ruta, @Ok OUTPUT, @OkRef OUTPUT
END
IF @CxID IS NOT NULL AND @Ok IS NULL
EXEC spCFDIRetencionTimbrar @Estacion, @CxID, @Proveedor, @ConceptoSAT,@RIDAnt, @Empresa, @Version, @Usuario, @RFCEmisor, @RFCReceptor, @ArchivoQRCode, @ArchivoXML, @ArchivoPDF, @montoTotExent, @montoTotGrav, @montoTotOperacion, @montoTotRet, @Ejerc, @MesIni, @MesFin, @UUID OUTPUT, @XML OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @CxID IS NOT NULL AND @Ok IS NULL
EXEC spCFDIRetencionActualizarMov 'AFECTAR', @Estacion, @CxID, @Proveedor, @Empresa, @Version, @ConceptoSAT,@RIDAnt, @UUID, @Ok OUTPUT, @OkRef OUTPUT
IF @CxID IS NOT NULL AND @Ok IS NULL
EXEC spCFDIRetencionAnexoMov @Estacion, @CxID, @Proveedor, @Empresa, @Version, @ConceptoSAT, @RIDAnt, @UUID, @Ruta, @ArchivoQRCode, @ArchivoXML, @ArchivoPDF, 0, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
COMMIT TRAN
ELSE
ROLLBACK TRAN
IF @CxID IS NOT NULL AND @Ok IS NULL
EXEC spCFDIRetencionQRCode @Estacion, @Proveedor, @ConceptoSAT, @Empresa, @Sucursal, @Version, @XML, @Usuario, @ArchivoQRCode, @RFCEmisor, @RFCReceptor, @montoTotExent, @montoTotGrav, @montoTotOperacion, @montoTotRet, @UUID, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NOT NULL
BEGIN
IF @AgruparConceptoSAT = 1
BEGIN
UPDATE CFDIRetencionD
SET Ok = @Ok,
OkRef = @OkRef
FROM CFDIRetencionD
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND ConceptoSAT = @ConceptoSAT
AND RID = @RIDAnt
AND Modulo = @Modulo AND ModuloID = @cGasID
UPDATE CFDIRetencion
SET Ok = @Ok,
OkRef = @OkRef
FROM CFDIRetencion
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND ConceptoSAT = @ConceptoSAT
AND RID = @RIDAnt
AND Modulo = @Modulo AND ModuloID = @cGasID
END
ELSE
BEGIN
UPDATE CFDIRetencionD
SET Ok = @Ok,
OkRef = @OkRef
FROM CFDIRetencionD
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND ConceptoSAT = @ConceptoSAT
AND Modulo = @Modulo AND ModuloID = @cGasID
UPDATE CFDIRetencion
SET Ok = @Ok,
OkRef = @OkRef
FROM CFDIRetencion
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND ConceptoSAT = @ConceptoSAT
AND Modulo = @Modulo AND ModuloID = @cGasID
END
END
ELSE
BEGIN
IF @AgruparConceptoSAT = 1
BEGIN
IF (SELECT Mov FROM CFDIRetencionD WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion AND Empresa = @Empresa
AND Ok IS NULL AND Modulo = @Modulo  AND ModuloID = @cGasID
AND ConceptoSAT = @ConceptoSAT	GROUP BY Mov) = 'Gasto'
DELETE CFDIRetencionD
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND ConceptoSAT = @ConceptoSAT
AND Modulo = @Modulo AND ModuloID = @cGasID
ELSE
DELETE CFDIRetencionD
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND ConceptoSAT = @ConceptoSAT
AND RID = @RID
AND Modulo = @Modulo AND ModuloID = @cGasID
DELETE CFDIRetencion
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND ConceptoSAT = @ConceptoSAT
AND Modulo = @Modulo AND ModuloID = @cGasID
DELETE CFDIRetencionCalcTmp
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND ConceptoSAT = @ConceptoSAT
AND Modulo = @Modulo AND ModuloID = @cGasID
END
ELSE
BEGIN
DELETE CFDIRetencionD
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND ConceptoSAT = @ConceptoSAT
AND Modulo = @Modulo
AND ModuloID = @cGasID
DELETE CFDIRetencion
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND ConceptoSAT = @ConceptoSAT
AND Modulo = @Modulo   AND ModuloID = @cGasID
DELETE CFDIRetencionCalcTmp
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND ConceptoSAT = @ConceptoSAT
AND Modulo = @Modulo AND ModuloID = @cGasID
END
END
SELECT @RID =  MIN(RID)
FROM CFDIRetencionD
WHERE Proveedor =  @Proveedor
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND RID > @RID
AND Ok IS NULL
AND ModuloID = @cGasID
AND ConceptoSAT = @ConceptoSAT
END  
END
ELSE
BEGIN
UPDATE CFDIRetencionD
SET Ok = NULL,
OkRef = NULL
FROM CFDIRetencionD
WHERE EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND Proveedor = @Proveedor
AND Modulo = @Modulo AND ModuloID = @cGasID
UPDATE CFDIRetencion
SET Ok = NULL,
OkRef = NULL
FROM CFDIRetencion
WHERE EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND Proveedor = @Proveedor
AND Modulo = @Modulo AND ModuloID = @cGasID
END
END
END 
/********************************************************************************/
DECLARE cPolizas CURSOR FOR
SELECT ID FROM dbo.fnBuscaMovs(@Modulo,@cGasID,@Empresa) WHERE Modulo = 'CONT'
OPEN cPolizas
FETCH NEXT FROM cPolizas INTO @cContID
WHILE @@FETCH_STATUS = 0
BEGIN
EXEC xpContSAT @Empresa, @Modulo, @cGasID, @cContID, NULL
FETCH NEXT FROM cPolizas INTO @cContID
END
CLOSE cPolizas
DEALLOCATE cPolizas
/********************************************************************************/
FETCH NEXT FROM cMovimientos INTO @cGasID,@ConceptoSAT
END
/********************************************************************************/
CLOSE cMovimientos
DEALLOCATE cMovimientos
END 
ELSE
BEGIN
IF EXISTS(SELECT * FROM CFDIRetencionD WHERE EstacionTrabajo = @Estacion AND NULLIF(RTRIM(ConceptoSAT), '') IS NULL)
BEGIN
SELECT @Ok = 1, @OkRef = 'El Concepto ' + Concepto + ' no se ha clasificado acorde el Catálogo del SAT'
FROM CFDIRetencionD
WHERE EstacionTrabajo = @Estacion
AND NULLIF(RTRIM(ConceptoSAT), '') IS NULL
UPDATE CFDIRetencionD
SET Ok = @Ok,
OkRef = @OkRef
FROM CFDIRetencionD
WHERE EstacionTrabajo = @Estacion
AND NULLIF(RTRIM(ConceptoSAT), '') IS NULL
UPDATE CFDIRetencion
SET Ok = @Ok,
OkRef = @OkRef
FROM CFDIRetencion
WHERE EstacionTrabajo = @Estacion
AND NULLIF(RTRIM(ConceptoSAT), '') IS NULL
END
IF NOT EXISTS(SELECT * FROM CFDIRetencionD WHERE EstacionTrabajo = @Estacion)
BEGIN
SELECT @Ok = 60010
END
IF @Ok IS NULL
BEGIN
SELECT @RFCEmisor = RFC FROM Empresa WHERE Empresa = @Empresa
SELECT @ProveedorAnt = ''
WHILE(1=1)
BEGIN
SELECT @Proveedor = MIN(Proveedor)
FROM CFDIRetencionD
WHERE Proveedor > @ProveedorAnt
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
IF @Proveedor IS NULL BREAK
SELECT @ProveedorAnt = @Proveedor
SELECT @RFCReceptor = NULL
SELECT @RFCReceptor = RFC FROM Prov WHERE Proveedor = @Proveedor
UPDATE CFDIRetencionD
SET Ok = NULL,
OkRef = NULL
FROM CFDIRetencionD
WHERE EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND Proveedor = @Proveedor
UPDATE CFDIRetencion
SET Ok = NULL,
OkRef = NULL
FROM CFDIRetencion
WHERE EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND Proveedor = @Proveedor
EXEC spCFDIRetencionComplementoVerificar @Estacion, @Empresa, @Sucursal, @Usuario, @Proveedor, @Ok OUTPUT, @OkRef OUTPUT
IF @OK IS NULL
BEGIN
IF @AgruparConceptoSAT = 1
SELECT @RID = MIN(RID) FROM CFDIRetencionD WHERE Proveedor = @Proveedor AND EstacionTrabajo = @Estacion AND Empresa = @Empresa
ELSE
SELECT @ConceptoSATAnt = ''
WHILE(1=1)
BEGIN
IF @AgruparConceptoSAT = 1
BEGIN
SELECT @ConceptoSAT = ConceptoSAT ,  @RIDAnt = isnull(MovID,0)
FROM CFDIRetencionD
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND RID = RID
IF @RID IS NULL BREAK
END
ELSE
BEGIN
SELECT @ConceptoSAT = MIN(ConceptoSAT)
FROM CFDIRetencionD
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND ConceptoSAT > @ConceptoSATAnt
AND Ok IS NULL
SELECT @RIDAnt = NULL
IF @ConceptoSAT IS NULL BREAK
SELECT @ConceptoSATAnt = @ConceptoSAT
END
SELECT @Ok = NULL, @OkRef = NULL, @CxID = NULL, @UUID = NULL, @CxID = NULL, @montoTotExent = NULL, @montoTotGrav = NULL, @montoTotOperacion = NULL,
@montoTotRet = NULL, @XML = NULL, @XMLDetalle = NULL, @XMLComplemento = NULL, @XMLAddenda = NULL, @AlmacenarXML = NULL, @AlmacenarPDF = NULL,
@NomArch = NULL, @Reporte = NULL, @Ruta = NULL, @EnviarPara = NULL, @EnviarAsunto = NULL, @EnviarMensaje = NULL, @Enviar = NULL,
@EnviarXML = NULL, @EnviarPDF = NULL
BEGIN TRAN
IF @Ok IS NULL
EXEC spCFDIRetencionGenerar @Estacion, @Empresa, @Sucursal, @Usuario, @Proveedor, @ConceptoSAT,@RIDAnt, @MovTimbrado, @Concepto, @CxID OUTPUT, @montoTotExent OUTPUT, @montoTotGrav OUTPUT, @montoTotOperacion OUTPUT, @montoTotRet OUTPUT, @Ejerc OUTPUT, @MesIni OUTPUT, @MesFin OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @CxID IS NOT NULL AND @Ok IS NULL
EXEC spCFDIRetencionProvPeriodo @Estacion, @CxID, @Empresa, @Proveedor, @ConceptoSAT, @Ok OUTPUT, @OkRef OUTPUT
IF @CxID IS NOT NULL AND @Ok IS NULL
EXEC spCFDIRetencionXMLGenerar @CxID, @Estacion, @Empresa, @Sucursal, @Usuario, @Proveedor, @ConceptoSAT,@RIDAnt, @Version, @XML = @XML OUTPUT, @XMLDetalle = @XMLDetalle OUTPUT, @XMLComplemento = @XMLComplemento OUTPUT, @XMLAddenda = @XMLAddenda OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @CxID IS NOT NULL AND @Ok IS NULL
EXEC spCFDIRetencionAlmacenar @Empresa, @Usuario, @Proveedor, @ConceptoSAT, @Version,
@Ejerc, @MesIni, @MesFin,
@AlmacenarXML OUTPUT, @AlmacenarPDF OUTPUT,
@NomArch OUTPUT, @Reporte OUTPUT, @Ruta OUTPUT, @EnviarPara OUTPUT, @EnviarAsunto OUTPUT, @EnviarMensaje OUTPUT,
@Enviar OUTPUT, @EnviarXML OUTPUT, @EnviarPDF OUTPUT, 0, @RIDAnt
IF @CxID IS NOT NULL AND @Ok IS NULL
BEGIN
SELECT @ArchivoQRCode = @Ruta + '\' + @NomArch + '.bmp',
@ArchivoXML	= @Ruta + '\' + @NomArch + '.xml',
@ArchivoPDF	= @Ruta + '\' + @NomArch + '.pdf'
EXEC spCrearRuta @Ruta, @Ok OUTPUT, @OkRef OUTPUT
END
IF @CxID IS NOT NULL AND @Ok IS NULL
EXEC spCFDIRetencionTimbrar @Estacion, @CxID, @Proveedor, @ConceptoSAT,@RIDAnt, @Empresa, @Version, @Usuario, @RFCEmisor, @RFCReceptor, @ArchivoQRCode, @ArchivoXML, @ArchivoPDF, @montoTotExent, @montoTotGrav, @montoTotOperacion, @montoTotRet, @Ejerc, @MesIni, @MesFin, @UUID OUTPUT, @XML OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @CxID IS NOT NULL AND @Ok IS NULL
EXEC spCFDIRetencionActualizarMov 'AFECTAR', @Estacion, @CxID, @Proveedor, @Empresa, @Version, @ConceptoSAT,@RIDAnt, @UUID, @Ok OUTPUT, @OkRef OUTPUT
IF @CxID IS NOT NULL AND @Ok IS NULL
EXEC spCFDIRetencionAnexoMov @Estacion, @CxID, @Proveedor, @Empresa, @Version, @ConceptoSAT,@RIDAnt, @UUID, @Ruta, @ArchivoQRCode, @ArchivoXML, @ArchivoPDF, 0, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
COMMIT TRAN
ELSE
ROLLBACK TRAN
IF @CxID IS NOT NULL AND @Ok IS NULL
EXEC spCFDIRetencionQRCode @Estacion, @Proveedor, @ConceptoSAT, @Empresa, @Sucursal, @Version, @XML, @Usuario, @ArchivoQRCode, @RFCEmisor, @RFCReceptor, @montoTotExent, @montoTotGrav, @montoTotOperacion, @montoTotRet, @UUID, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NOT NULL
BEGIN
IF @AgruparConceptoSAT = 1
BEGIN
UPDATE CFDIRetencionD
SET Ok = @Ok,
OkRef = @OkRef
FROM CFDIRetencionD
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND ConceptoSAT = @ConceptoSAT
AND RID = @RID
UPDATE CFDIRetencion
SET Ok = @Ok,
OkRef = @OkRef
FROM CFDIRetencion
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND ConceptoSAT = @ConceptoSAT
AND RID = @RID
END
ELSE
BEGIN
UPDATE CFDIRetencionD
SET Ok = @Ok,
OkRef = @OkRef
FROM CFDIRetencionD
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND ConceptoSAT = @ConceptoSAT
UPDATE CFDIRetencion
SET Ok = @Ok,
OkRef = @OkRef
FROM CFDIRetencion
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND ConceptoSAT = @ConceptoSAT
END
END
ELSE
BEGIN
IF @AgruparConceptoSAT = 1
BEGIN
DELETE CFDIRetencionD
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND ConceptoSAT = @ConceptoSAT
AND RID = @RID
DELETE CFDIRetencion
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND ConceptoSAT = @ConceptoSAT
AND MovID = @RIDAnt
DELETE CFDIRetencionCalcTmp
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND ConceptoSAT = @ConceptoSAT
AND MovID = @RIDAnt
END
ELSE
BEGIN
DELETE CFDIRetencionD
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND ConceptoSAT = @ConceptoSAT
DELETE CFDIRetencion
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND ConceptoSAT = @ConceptoSAT
DELETE CFDIRetencionCalcTmp
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND ConceptoSAT = @ConceptoSAT
END
END
SELECT @RID = MIN(RID)
FROM CFDIRetencionD
WHERE Proveedor =  @Proveedor
AND EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND RID > @RID
AND Ok IS NULL
END
END
ELSE
BEGIN
UPDATE CFDIRetencionD
SET Ok = NULL,
OkRef = NULL
FROM CFDIRetencionD
WHERE EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND Proveedor = @Proveedor
UPDATE CFDIRetencion
SET Ok = NULL,
OkRef = NULL
FROM CFDIRetencion
WHERE EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND Proveedor = @Proveedor
END
END
END
END 
DELETE FROM ListaModuloID
IF @OkRef IS NOT NULL
SELECT @OkREf
ELSE
SELECT 'Proceso Concluido'
RETURN
END

