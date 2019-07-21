SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisServiceProcesarMovil
@Sistema       varchar(100),
@ID		  int,
@iSolicitud	  int,
@Solicitud     varchar(max),
@Version	  float,
@Referencia    varchar(100),
@SubReferencia varchar(100),
@Resultado     varchar(max)    OUTPUT,
@Ok		  int		OUTPUT,
@OkRef	  varchar(255)	OUTPUT

AS BEGIN
IF @Referencia = 'Intelisis.Config.Usuario.Verificar' EXEC spISIntelisisConfigUsuarioVerificar  @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Cuenta.ArtCat' EXEC spISCuentaArtCat @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Cuenta.ArtFam' EXEC spISCuentaArtFam @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Cuenta.ArtGrupo' EXEC spISCuentaArtGrupo @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Cuenta.ArtLinea' EXEC spISCuentaArtLinea @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Cuenta.Unidad' EXEC spISCuentaUnidad @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Catalogo.AgenteCte.Listado' EXEC spISIntelisisCatalogoAgenteCteListado @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Catalogo.AgenteArt.Listado' EXEC spISIntelisisCatalogoAgenteArtListado @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

