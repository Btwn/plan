SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisServiceProcesarPOS
@Sistema       varchar(100),
@ID				int,
@iSolicitud		int,
@Solicitud		varchar(max),
@Version		float,
@Referencia		varchar(100),
@SubReferencia	varchar(100),
@Resultado		varchar(max)    OUTPUT,
@Ok				int				OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
IF @Referencia = 'Intelisis.POS.AnticiposFactCte'			EXEC spPOSISAnticiposFacturados			@ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT	ELSE
IF @Referencia = 'Intelisis.POS.CxcPendienteCte'			EXEC spPOSISCxcPendienteCliente			@ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT	ELSE
IF @Referencia = 'Intelisis.POS.PedidosCte'				EXEC spPOSISPedidosCliente				@ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT	ELSE
IF @Referencia = 'Intelisis.POS.ImportarVenta'				EXEC spPOSISImportarVenta				@ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT	ELSE
IF @Referencia = 'Intelisis.POS.CteInfo'					EXEC spPOSISClienteInfo					@ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT	ELSE
IF @Referencia = 'Intelisis.POS.ArtInfo'					EXEC spPOSISArtInfo						@ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT	ELSE
IF @Referencia = 'Intelisis.POS.AfectarVenta'				EXEC spPOSISAfectarVenta				@ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT	ELSE
IF @Referencia = 'Intelisis.POS.MonederoInfo'				EXEC spPOSISMonederoInfo				@ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT	ELSE
IF @Referencia = 'Intelisis.POS.AuxiliarPMon'				EXEC spPOSISAuxiliarPMon				@ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT	ELSE
IF @Referencia = 'Intelisis.POS.TarjetaMonedero'			EXEC spPOSISTarjetaMonedero				@ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT	ELSE
IF @Referencia = 'Intelisis.POS.TarjetaMonederoActivar'	EXEC spPOSISTarjetaMonederoActivar		@ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT	ELSE
IF @Referencia = 'Intelisis.POS.MonederoRedimir'			EXEC spPOSISMonederoRedimir				@ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

