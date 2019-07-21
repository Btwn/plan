SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spISEmidaActualizarCatalogo
@ID					int,
@iSolicitud			int,
@SubReferencia		varchar(100),
@Resultado			varchar(max)	OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT,
@CambiarEstatus		bit = 1			OUTPUT

AS
BEGIN
DECLARE @Estacion		int,
@Empresa		varchar(5),
@URL			varchar(255),
@SiteID		varchar(20),
@Version		varchar(2)
SELECT @Estacion = Estacion, @Empresa = Empresa, @URL = URL, @SiteID = SiteID, @Version = Version
FROM OPENXML (@iSolicitud, '/Intelisis/Solicitud/Emida',1)
WITH (Estacion int, Empresa varchar(5), URL varchar(255), SiteID varchar(20), Version varchar(2))
IF @SubReferencia = 'CarrierList'
EXEC spISEmidaActualizarCatalogoCarrierList @ID, @iSolicitud, @Estacion, @Empresa, @URL, @SiteID, @Version, @Resultado = @Resultado OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
ELSE IF @SubReferencia = 'ProductList'
EXEC spISEmidaActualizarCatalogoProductList @ID, @iSolicitud, @Estacion, @Empresa, @URL, @SiteID, @Version, @Resultado = @Resultado OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
RETURN
END

