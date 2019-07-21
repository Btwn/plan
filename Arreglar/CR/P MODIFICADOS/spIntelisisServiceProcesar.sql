SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisServiceProcesar
@ID	int

AS BEGIN
DECLARE
@Sistema		varchar(100),
@Contenido		varchar(100),
@Referencia		varchar(100),
@SubReferencia  varchar(100),
@Version		float,
@Estatus		varchar(15),
@EstatusNuevo	varchar(15),
@Solicitud		varchar(max),
@iSolicitud		int,
@Resultado		varchar(max),
@Ok				int,
@OkRef			varchar(255),
@CambiarEstatus	bit,
@EsContParalela	bit
SELECT @EsContParalela = 0
SELECT @Ok = NULL, @OkRef = NULL, @CambiarEstatus = 1 
SELECT @Sistema = Sistema, @Contenido = Contenido, @Referencia = Referencia, @SubReferencia = SubReferencia, @Version = Version, @Estatus = Estatus, @Solicitud = Solicitud
FROM IntelisisService WITH(NOLOCK)
WHERE ID = @ID
IF @Estatus IN('SINPROCESAR')
BEGIN
IF @Sistema IN('Intelisis', 'SDK','Infor')
BEGIN
IF @Contenido = 'Solicitud'
BEGIN
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
BEGIN TRY 
IF @Referencia = 'Intelisis.CXP.InsertarMov.CXP_F' EXEC spISIntelisisCXPInsertarMovCXP_F @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'IntelisisCRM.CRM' EXEC spISIntelisisCRM @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @CambiarEstatus OUTPUT ELSE 
IF @Referencia = 'SDK.ReportePDF' EXEC spISSDKReportePDF @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @CambiarEstatus OUTPUT ELSE
IF @Referencia = 'CRM.CRM' EXEC spISCRM @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @CambiarEstatus OUTPUT
EXEC spIntelisisServiceProcesarInfor @Sistema, @ID, @iSolicitud, @Solicitud, @Version, @Referencia,@SubReferencia, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spIntelisisServiceProcesarAutorizacion @Sistema, @ID, @iSolicitud, @Solicitud, @Version, @Referencia,@SubReferencia, @CambiarEstatus, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spIntelisisServiceProcesarNotificacion @Sistema, @ID, @iSolicitud, @Solicitud, @Version, @Referencia,@SubReferencia, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @CambiarEstatus OUTPUT            
EXEC spIntelisisServiceProcesarOportunidad @Sistema, @ID, @iSolicitud, @Solicitud, @Version, @Referencia,@SubReferencia, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @CambiarEstatus OUTPUT
EXEC spIntelisisServiceProcesareDocIn @Sistema, @ID, @iSolicitud, @Solicitud, @Version, @Referencia,@SubReferencia, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spIntelisisServiceEmida @ID, @iSolicitud, @Referencia, @SubReferencia, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @CambiarEstatus OUTPUT 
EXEC spIntelisisServiceProcesarWMS @Sistema, @ID, @iSolicitud, @Solicitud, @Version, @Referencia, @SubReferencia, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT 
EXEC spIntelisisServiceProcesareCommerce @Sistema, @ID, @iSolicitud, @Solicitud, @Version, @Referencia,@SubReferencia, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT 
EXEC spIntelisisServiceProcesarPOS @Sistema, @ID, @iSolicitud, @Solicitud, @Version, @Referencia,@SubReferencia, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT 
EXEC spIntelisisServiceProcesarMovil @Sistema, @ID, @iSolicitud, @Solicitud, @Version, @Referencia,@SubReferencia, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT 
EXEC xpIntelisisServiceProcesar @Sistema, @ID, @iSolicitud, @Solicitud, @Version, @Referencia,@SubReferencia, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @CambiarEstatus OUTPUT
IF LEFT(LTRIM(RTRIM(ISNULL(@Referencia,''))),22) = 'Intelisis.Distribucion' EXEC spIntelisisServiceProcesarDistribucion @Sistema, @ID, @iSolicitud, @Solicitud, @Version, @Referencia,@SubReferencia, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spIntelisisServicePedidosMovilCobranzaLigera @Sistema, @ID, @iSolicitud, @Solicitud, @Version, @Referencia,@SubReferencia, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT 
END TRY 
BEGIN CATCH
IF @Ok IS NOT NULL
SET @Ok = @Ok
END CATCH
EXEC sp_xml_removedocument @iSolicitud
IF @CambiarEstatus = 1
BEGIN
IF @Ok IS NULL OR @Ok IN (80030)
SELECT @EstatusNuevo = 'PROCESADO'
ELSE
SELECT @EstatusNuevo = 'ERROR'
IF @EsContParalela = 0
SELECT @OkRef = ISNULL(Descripcion,'')+ @OkRef
FROM MensajeLista WITH(NOLOCK) WHERE   Mensaje = @Ok
UPDATE IntelisisService
 WITH(ROWLOCK) SET Estatus = @EstatusNuevo,
Resultado = @Resultado,
Ok = @Ok,
OkRef = @OkRef
WHERE ID = @ID
END
END
END
END
RETURN
END

