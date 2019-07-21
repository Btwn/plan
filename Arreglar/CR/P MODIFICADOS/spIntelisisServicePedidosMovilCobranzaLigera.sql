SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisServicePedidosMovilCobranzaLigera
@Sistema       varchar(100),
@ID			   int,
@iSolicitud	   int,
@Solicitud     varchar(max),
@Version	   float,
@Referencia    varchar(100),
@SubReferencia varchar(100),
@Resultado     varchar(max)  OUTPUT,
@Ok			   int			 OUTPUT,
@OkRef		   varchar(255)	 OUTPUT

AS
BEGIN
IF @Referencia = 'Intelisis.Movil.Login.Listado'            EXEC spISIntelisisMovilLoginListado            @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Movil.MovilUsuarioCfg.Listado'	EXEC spISIntelisisMovilMovilUsuarioCfgListado  @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Movil.Art.Listado'              EXEC spISIntelisisMovilArtListado              @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Movil.Cte.Listado'	            EXEC spISIntelisisMovilCteListado	           @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Movil.Metadato.Listado'	        EXEC spISIntelisisMovilMetadatoListado	       @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Movil.Cte.Alta'					EXEC spISIntelisisMovilCteAlta		           @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Movil.CampanaD.Actualizar'		EXEC spISIntelisisMovilCampanaDActualizar	   @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Movil.Venta.Alta'				EXEC spISIntelisisMovilVentaAlta			   @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Movil.Cte.Actualizar'			EXEC spISIntelisisMovilCteActualizar		   @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Movil.Venta.Consulta'			EXEC spISIntelisisMovilVentaConsulta		   @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Movil.Venta.Template'			EXEC spISIntelisisMovilVentaTemplate		   @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Movil.ArtCat.Listado'           EXEC spISIntelisisMovilArtCatListado           @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Movil.ArtGrupo.Listado'	        EXEC spISIntelisisMovilArtGrupoListado	       @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Movil.ArtFam.Listado'	        EXEC spISIntelisisMovilArtFamListado	       @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Movil.ArtLinea.Listado'	        EXEC spISIntelisisMovilArtLineaListado	       @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Movil.ArtJuego.Listado'	        EXEC spISIntelisisMovilArtJuegoListado	       @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Movil.ArtOpcion.Listado'	    EXEC spISIntelisisMovilArtOpcionListado	       @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Movil.Alm.Listado'	            EXEC spISIntelisisMovilAlmListado	           @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Movil.ArtSubDisponible.Listado'	EXEC spISIntelisisMovilArtSubDisponibleListado @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Movil.CteEnviarA.Listado'	    EXEC spISIntelisisMovilCteEnviarAListado	   @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Movil.Visita.Listado'	        EXEC spISIntelisisMovilVisitaListado	       @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Movil.Clientes.Listado'			EXEC spISIntelisisMovilClientesListado		   @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Movil.Cobro.Alta'   			EXEC spISIntelisisMovilCobroAlta               @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Referencia = 'Intelisis.Movil.Agenda.Actualizar'		EXEC spISIntelisisMovilAgendaActualizar		@ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Movil.Agenda.Listado'			EXEC spISIntelisisMovilAgendaListado		    @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Referencia = 'Intelisis.Movil.Cte.Pendientes'           EXEC spISIntelisisMovilCtePendientes           @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Movil.Cte.PendientesEnvio'      EXEC spISIntelisisMovilCxCPendientesEnvio      @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
RETURN
END

