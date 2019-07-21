SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDINominaDProcesar
@Estacion					int,
@ID							int,
@Empresa					varchar(5),
@Sucursal					int,
@Mov						varchar(20),
@MovID						varchar(20),
@Version					varchar(5),
@Timbrar					bit,
@Usuario					varchar(10),
@PersonalEsp				varchar(10),
@NominaTimbrar				bit,
@Estatus					varchar(15),
@RFCEmisor					varchar(20),
@Ok							int			OUTPUT,
@OkRef						varchar(255)OUTPUT

AS
BEGIN
DECLARE @Personal					varchar(10),
@PersonalAnt				varchar(10),
@XML						varchar(max),
@XMLComprobante			varchar(max),
@XMLComplemento			varchar(max),
@Importe					float,
@TotalPercepciones		float,
@TotalDeducciones			float,
@TotalDeduccionesSinISR	float,
@PercepcionesTotalGravado	float,
@PercepcionesTotalExcento	float,
@DeduccionesTotalGravado	float,
@DeduccionesTotalExcento	float,
@TotalDescuento			float,
@Timbrado					varchar(15),
@AlmacenarXML				bit,
@AlmacenarPDF				bit,
@NomArch					varchar(255),
@ArchivoQRCode			varchar(255),
@ArchivoXML				varchar(255),
@ArchivoPDF				varchar(255),
@Reporte					varchar(100),
@Ruta						varchar(255),
@EnviarPara				varchar(255),
@EnviarAsunto				varchar(255),
@EnviarMensaje			varchar(255),
@Enviar					bit,
@EnviarXML				bit,
@EnviarPDF				bit,
@Cancelado				bit,
@ManejadorObjeto			int,
@IDArchivo				int,
@RFCReceptor				varchar(20),
@NoTimbrado				int
SELECT @PersonalAnt = ''
WHILE(1=1)
BEGIN
IF @PersonalEsp IS NULL
SELECT @Personal = MIN(Personal)
FROM NominaD
WHERE ID = @ID
AND Personal > @PersonalAnt
ELSE
SELECT @Personal = MIN(Personal)
FROM NominaD
WHERE ID = @ID
AND Personal > @PersonalAnt
AND Personal = @PersonalEsp
IF @Personal IS NULL BREAK
SELECT @PersonalAnt = @Personal
SELECT @Timbrado = NULL
SELECT @Timbrado = Timbrado FROM CFDINominaRecibo WHERE ID = @ID AND Personal = @Personal
SELECT @NoTimbrado = MAX(NoTimbrado) FROM CFDNominaCancelado WHERE Modulo = 'NOM' AND ModuloID = @ID AND Personal = @Personal
SELECT @NoTimbrado = ISNULL(@NoTimbrado, 0) + 1
SELECT @Ok = NULL, @OkRef = NULL, @RFCReceptor = NULL
SELECT @RFCReceptor = Registro2 FROM Personal WHERE Personal = @Personal
IF ISNULL(@Timbrado, 'No Timbrado') = 'No Timbrado'
BEGIN
IF @Ok IS NULL
EXEC spCFDINominaReciboEliminar @Estacion, @ID, @Personal, @Timbrado, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spCFDINominaRecibo @Estacion, @ID, @Personal, @Empresa, @TotalPercepciones OUTPUT, @TotalDeducciones OUTPUT, @PercepcionesTotalGravado OUTPUT, @PercepcionesTotalExcento OUTPUT, @DeduccionesTotalGravado OUTPUT, @DeduccionesTotalExcento OUTPUT, @TotalDescuento OUTPUT, @Importe OUTPUT, @TotalDeduccionesSinISR OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spCFDINominaReciboD @Estacion, @ID, @Personal, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spCFDINominaXMLGenerar @Estacion, @ID, @Empresa, @Mov, @MovID, @Version, @Personal, @TotalPercepciones, @TotalDeducciones, @PercepcionesTotalGravado, @PercepcionesTotalExcento, @DeduccionesTotalGravado, @DeduccionesTotalExcento, @XML OUTPUT, @XMLComprobante OUTPUT, @XMLComplemento OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spCFDINominaVerificar @Estacion, @ID, @Empresa, @Mov, @MovID, @Version, @Personal, @XML, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
UPDATE CFDINominaRecibo SET Documento = @XML WHERE ID = @ID AND Personal = @Personal
IF @Ok IS NULL AND @Timbrar = 1
BEGIN
EXEC spCFDNominaAlmacenar 'NOM', @ID, @AlmacenarXML OUTPUT, @AlmacenarPDF OUTPUT, @NomArch OUTPUT, @Reporte OUTPUT, @Ruta OUTPUT, @EnviarPara OUTPUT,
@EnviarAsunto OUTPUT, @EnviarMensaje OUTPUT, @Personal OUTPUT, @Sucursal OUTPUT, @Enviar OUTPUT, @EnviarXML OUTPUT, @EnviarPDF OUTPUT,
0, @NoTimbrado
SELECT @ArchivoQRCode = CASE @NominaTimbrar WHEN 0 THEN NULL ELSE @Ruta + '\' + @NomArch + '.bmp' END,
@ArchivoXML	  = @Ruta + '\' + @NomArch + '.xml',
@ArchivoPDF	  = CASE @NominaTimbrar WHEN 0 THEN NULL ELSE @Ruta + '\' + @NomArch + '.pdf' END
EXEC spCrearRuta @Ruta, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @NominaTimbrar = 1
EXEC spCFDINominaTimbrar @Estacion, @ID, @Personal, @Empresa, @Sucursal, @Mov, @MovID, @Version, @Usuario, @Estatus, @RFCEmisor, @RFCReceptor, @Importe, @ArchivoXML, @NoTimbrado, @XML OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @NominaTimbrar = 1
EXEC spCFDINominaQRCode @Estacion, @ID, @Personal, @Empresa, @Sucursal, @Mov, @MovID, @Version, @XML, @Usuario, @ArchivoQRCode, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spCFDINominaActualizaTimbrado @Estacion, @ID, @Personal, @Empresa, @Sucursal, @Mov, @MovID, @Version, @XML, @Usuario, @ArchivoQRCode, @ArchivoXML, @ArchivoPDF, @NominaTimbrar, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spCFDINominaAnexoMov @ID, @Sucursal, @Personal, @Ruta, @ArchivoQRCode, @ArchivoXML, @ArchivoPDF, 0, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL OR @Ok = 71680
BEGIN
DECLARE @ParamPeriodoNomina varchar(25)
SELECT @ParamPeriodoNomina = CONVERT(varchar(10), FechaInicialPago, 105) + ' al ' + convert(varchar(10), FechaFinalPago, 105)
FROM CFDINominaRecibo
WHERE ID = @ID AND Personal = @Personal
IF (NULLIF(@Personal, '') IS NOT NULL AND NULLIF(@ParamPeriodoNomina, '') IS NOT NULL)
BEGIN
EXEC spPNetEnviarCorreoPersonal @Personal, 'Generar Nómina', @ParamPeriodoNomina
END
END
END
IF @Ok IS NOT NULL
UPDATE CFDINominaRecibo
SET Ok = @Ok,
OkRef = @OkRef
WHERE ID = @ID
AND Personal = @Personal
IF @Ok = 71680 AND @Timbrar = 1
BEGIN
UPDATE CFDINominaRecibo SET Timbrado = 'Timbrado', Ok = NULL, OkRef = NULL WHERE ID = @ID AND Personal = @Personal
UPDATE CFDNomina SET Timbrado = 1 WHERE Modulo = 'NOM' AND ModuloID = @ID AND Personal = @Personal
END
END
END
RETURN
END

