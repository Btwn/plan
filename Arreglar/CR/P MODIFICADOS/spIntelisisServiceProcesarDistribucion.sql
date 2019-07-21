SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisServiceProcesarDistribucion
@Sistema         varchar(100),
@ID              int,
@iSolicitud      int,
@Solicitud       varchar(max),
@Version         float,
@Referencia      varchar(100),
@SubReferencia   varchar(100),
@Resultado       varchar(max) OUTPUT,
@Ok              int          OUTPUT,
@OkRef           varchar(255) OUTPUT

AS BEGIN
IF @Referencia = 'Intelisis.Distribucion.Mensaje' EXEC spIntelisisDistribucionMensaje @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Distribucion.Empresa' EXEC spIntelisisDistribucionEmpresa @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Distribucion.EmpresaCfg' EXEC spIntelisisDistribucionEmpresaCfg @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Distribucion.Sucursal' EXEC spIntelisisDistribucionSucursal @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Distribucion.InventarioFisicoLista' EXEC spIntelisisDistribucionInventarioFisicoLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Distribucion.InventarioDetalle' EXEC spIntelisisDistribucionInventarioDetalle @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Referencia = 'Intelisis.Distribucion.MovimientosInventarioLista' EXEC spIntelisisDistribucionMovimientosInventarioLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Distribucion.AlmacenesLista' EXEC spIntelisisDistribucionAlmacenesLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Distribucion.MonedasLista' EXEC spIntelisisDistribucionMonedasLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Distribucion.GenerarInventario' EXEC spIntelisisDistribucionGenerarInventario @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Distribucion.CbInfo' EXEC spIntelisisDistribucionCbInfo @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef ELSE
IF @Referencia = 'Intelisis.Distribucion.ArticuloInfo' EXEC spIntelisisDistribucionArticuloInfo @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef ELSE
IF @Referencia = 'Intelisis.Distribucion.GuardarInventario' EXEC spIntelisisDistribucionGuardarInventario @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef ELSE
IF @Referencia = 'Intelisis.Distribucion.SerieLoteLista' EXEC spIntelisisDistribucionSerieLoteLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef ELSE
IF @Referencia = 'Intelisis.Distribucion.GuardarSerieLoteMov' EXEC spIntelisisDistribucionGuardarSerieLoteMov @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef ELSE
IF @Referencia = 'Intelisis.Distribucion.InfoSerieLote' EXEC spIntelisisDistribucionInfoSerieLote @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef ELSE
IF @Referencia = 'Intelisis.Distribucion.MovimientosRecepcionLista' EXEC spIntelisisDistribucionMovimientosRecepcionLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef ELSE
IF @Referencia = 'Intelisis.Distribucion.OrdenCompraLista' EXEC spIntelisisDistribucionOrdenCompraLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef ELSE
IF @Referencia = 'Intelisis.Distribucion.OrdenCompraDetalle' EXEC spIntelisisDistribucionOrdenCompraDetalle @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef ELSE
IF @Referencia = 'Intelisis.Distribucion.AfectarOrdenCompra' EXEC spIntelisisDistribucionAfectarOrdenCompra @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef ELSE
IF @Referencia = 'Intelisis.Distribucion.MovimientosSurtidoLista' EXEC spIntelisisDistribucionMovimientosSurtidoLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef ELSE
IF @Referencia = 'Intelisis.Distribucion.TransitoLista' EXEC spIntelisisDistribucionTransitoLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef ELSE
IF @Referencia = 'Intelisis.Distribucion.TransitoDetalle' EXEC spIntelisisDistribucionTransitoDetalle @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef ELSE
IF @Referencia = 'Intelisis.Distribucion.InfoSerieLoteMov' EXEC spIntelisisDistribucionInfoSerieLoteMov @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef ELSE
IF @Referencia = 'Intelisis.Distribucion.AfectarTransito' EXEC spIntelisisDistribucionAfectarTransito @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef ELSE
IF @Referencia = 'Intelisis.Distribucion.OrdenSurtidoLista' EXEC spIntelisisDistribucionOrdenSurtidoLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef ELSE
IF @Referencia = 'Intelisis.Distribucion.OrdenSurtidoDetalle' EXEC spIntelisisDistribucionOrdenSurtidoDetalle @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef ELSE
IF @Referencia = 'Intelisis.Distribucion.MovimientosGenerar' EXEC spIntelisisDistribucionMovimientosGenerar @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef ELSE
IF @Referencia = 'Intelisis.Distribucion.AfectarOrdenSurtido' EXEC spIntelisisDistribucionAfectarOrdenSurtido @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef ELSE
IF @Referencia = 'Intelisis.Distribucion.SalidaTraspasoLista' EXEC spIntelisisDistribucionSalidaTraspasoLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef ELSE
IF @Referencia = 'Intelisis.Distribucion.SalidaTraspasoDetalle' EXEC spIntelisisDistribucionSalidaTraspasoDetalle @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef ELSE
IF @Referencia = 'Intelisis.Distribucion.AfectarSalidaTraspaso' EXEC spIntelisisDistribucionAfectarSalidaTraspaso @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef
END

