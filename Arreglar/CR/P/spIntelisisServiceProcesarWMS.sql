SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisServiceProcesarWMS
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
IF @Referencia = 'Intelisis.WMS.Solicitud.Empresa' EXEC spIntelisisWMSSolicitudEmpresa @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.Solicitud.Sucursal' EXEC spIntelisisWMSSolicitudSucursal @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.Validar.Usuario' EXEC spIntelisisWMSValidarUsuario @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.Validar.Montacarga' EXEC spIntelisisWMSValidarMontacarga @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.Solicitud.ValidaSucursal' EXEC spIntelisisWMSValidaSucursal @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.TMA.AfectarMov.TMA_SADO' EXEC spISIntelisisTMAAfectarTMA_SADO @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.TMA.AfectarMov.TMA_OADO' EXEC spISIntelisisTMAAfectarTMA_OADO @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.MapeoMovMovilListado' EXEC spIntelisisMapeoMovMovilListado  @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.MontacargaListado' EXEC spIntelisisMontacargaListado  @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT  ELSE
IF @Referencia = 'Intelisis.TarimasPorAfectarListado' EXEC spIntelisisTarimasPorAfectarListado  @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT  ELSE
IF @Referencia = 'Intelisis.InfoTarimasPorAfectarListado' EXEC spIntelisisWMSInfoTarimasPorAfectarListado  @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT  ELSE
IF @Referencia = 'Intelisis.WMS.OSUR.Pendiente' EXEC spIntelisisWMSOSurtidoPendientes  @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT  ELSE
IF @Referencia = 'Intelisis.WMS.OSUR.MovListado' EXEC spIntelisisWMSOSURMovListado  @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT  ELSE
IF @Referencia = 'Intelisis.WMS.OSUR.Tarima' EXEC spIntelisisWMSOSURTarima  @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.TMA.AfectarMov.TMA_OSUR' EXEC spISIntelisisTMAAfectarTMA_OSUR @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.TMA.AfectarMov.TMA_SUR' EXEC spISIntelisisTMAAfectarTMA_SUR @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.TMA.ValidarMov.COMS_O' EXEC spIntelisisWMSValidarMovCOMS_O @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.TMA.ActualizarAnden' EXEC spIntelisisWMSActualizarAnden @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.TMA.InfoCOMS_O' EXEC spIntelisisWMSInfoOrdenCompra @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.TMA.ValidarCB' EXEC spIntelisisWMSValidarCB @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.TMA.InfoCB' EXEC spIntelisisWMSInfoCB @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT  ELSE
IF @Referencia = 'Intelisis.TMA.InfoCB_COMS' EXEC spIntelisisWMSInfoCB_COMS @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT  ELSE
IF @Referencia = 'Intelisis.TMA.ValidarSoloCB' EXEC spIntelisisWMSValidarSoloCB @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.TMA.AfectarCOMS_O' EXEC spIntelisisWMSAfectarOC @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.InfoTarimasSurtidoPikingListado' EXEC spIntelisisWMSInfoTarimasSurtidoP @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.TMA.ValidarCB.OSURP' EXEC spIntelisisWMSValidarCBOSURP @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.TMA.ValidarCntidadTarima.OSURP' EXEC spIntelisisWMSValidarCB @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.TMA.AfectarMov.TMA_OSURP' EXEC spISIntelisisTMAAfectarTMA_OSURP @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.TMA.Afectar.TSURP' EXEC spISIntelisisTMAAfectarTMA_TSURP @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.TMA.INV_IFListado' EXEC spIntelisisINVINV_IFListado @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.Validar.PosicionTarima' EXEC spIntelisisWMSValidarPosicionTarima @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.INV.AfectarMov.INV_IF' EXEC spISIntelisisINVAfectarINV_IF @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.INV.AfectarINV_SOL' EXEC spIntelisisINVAfectarINV_SOL @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.TMA.TareasAsignadasListado' EXEC spIntelisisWMSTareasAsignadasListado @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.SerieLoteProp' EXEC spIntelisisWMSSerieLoteProp @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.SerieLotePropLista' EXEC spIntelisisWMSSerieLotePropLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.VaidaArticuloCB' EXEC spIntelisisWMSVaidaArticuloCB @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.ListaDetalleINV' EXEC spIntelisisWMSListaDetalleINV @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE 
IF @Referencia = 'Intelisis.ArticuloEspPosicion' EXEC spIntelisisArticuloEspPosicion @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE 
IF @Referencia = 'Intelisis.ArticuloUnidadListado' EXEC spIntelisisArticuloUnidadListado @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE 
IF @Referencia = 'Intelisis.ArticuloUnidadFactor' EXEC spIntelisisArticuloUnidadFactor @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.TMA.DetalleMov.COMS_O' EXEC spIntelisisWMSDetalleMovCOMS_O @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.TMA.GenerarMov.TMA_SRADO' EXEC spISIntelisisTMAProcesarTMA_SRADO @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.ArticuloPosicionRADO' EXEC spIntelisisArticuloPosicionRADO @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.ArticuloEPosicionDestinoRADO' EXEC spIntelisisArticuloPosicionDestinoRADO @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.TMA.AfectarMov.TMA_RADO' EXEC spISIntelisisTMAAfectarTMA_RADO @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE 
IF @Referencia = 'Intelisis.ArticuloPosicionRADOPck' EXEC spIntelisisArticuloPosicionRADOPck @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.RADOPck.MovListado' EXEC spIntelisisRADOPck_MovListado  @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT  ELSE
IF @Referencia = 'Intelisis.ArticuloEPosicionDestinoRADOPck' EXEC spIntelisisArticuloPosicionDestinoRADOPck @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.TMA.AfectarMov.TMA_RADOPck' EXEC spISIntelisisTMAAfectarTMA_RADOPck @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.TMA.InfoPesoTarima' EXEC spIntelisisWMSInfoPesoTarima @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.TMA.InfoCB_IF' EXEC spIntelisisWMSInfoCB_IF @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.ArticuloPosicionORENT' EXEC spIntelisisArticuloPosicionORENT @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.TMA.AfectarMov.TMA_ORENT' EXEC spISIntelisisTMAAfectarTMA_ORENT @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.InfoPosicion' EXEC spIntelisisWMSInfoPosicion @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.InfoTarima' EXEC spIntelisisWMSInfoTarima @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.OrdenCompraLista' EXEC spIntelisisWMSOrdenCompraLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.EntradaCompraLista' EXEC spIntelisisWMSEntradaCompraLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.TotalCB' EXEC spIntelisisWMSTotalCB @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.InfoArticuloSerieLote' EXEC spIntelisisWMSInfoArticuloSerieLote @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.ArticuloCBLista' EXEC spIntelisisWMSArticuloCBLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.TMA.AfectarMov.TMA_OPCKTARIMA' EXEC spIntelisisTMAAfectarMovTMA_OPCKTARIMA @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.TMA.AfectarMov.TMA_PCKTARIMATRAN' EXEC spIntelisisTMAAfectarMovTMA_PCKTARIMATRAN @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.InventarioDetalle' EXEC spIntelisisWMSInventarioDetalle @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.InfoSerieLote' EXEC spIntelisisWMSInfoSerieLote @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.SerieLoteActualizar' EXEC spIntelisisWMSSerieLoteActualizar @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.InventarioActualizar' EXEC spIntelisisWMSInventarioActualizar @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.OrdenCompraActualizar' EXEC spIntelisisWMSOrdenCompraActualizar @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.InfoDetalleMov.COMS_O' EXEC spIntelisisWMSInfoDetalleMovCOMS_O @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.ValidarZona' EXEC spIntelisisWMSValidarZona @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.InfoSerieLoteSurtido' EXEC spIntelisisWMSInfoSerieLoteSurtido @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.OSUR.TarimasPckListado' EXEC spIntelisisWMSOSURTarimasPckListado @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.InfoSerieLoteSurtidoConsolidado' EXEC spIntelisisWMSInfoSerieLoteSurtidoConsolidado @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.Movil' EXEC spIntelisisWMSMovil @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.TarimasPorCerrarLista' EXEC spIntelisisWMSTarimasPorCerrarLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.TarimasPorCerrarCuenta' EXEC spIntelisisWMSTarimasPorCerrarCuenta @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.CerrarTarimasSurtidoTransitoPCK' EXEC spIntelisisWMSCerrarTarimasSurtidoTransitoPCK @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.TarimasPorMarcarLista' EXEC spIntelisisWMSTarimasPorMarcarLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.TarimasLista' EXEC spIntelisisWMSTarimasLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.CambiarTarima' EXEC spIntelisisWMSCambiarTarima @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.TarimasArticuloLista' EXEC spIntelisisWMSTarimasArticuloLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.PocisionesArticuloLista' EXEC spIntelisisWMSPosicionesArticuloLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.GenerarSolicitudReacomodo' EXEC spIntelisisWMSGenerarSolicitudReacomodo @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.Info' EXEC spIntelisisWMSInfo @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.AlmacenesLista' EXEC spIntelisisWMSAlmacenesLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.MonedasLista' EXEC spIntelisisWMSMonedasLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.GenerarInventarioFisico' EXEC spIntelisisWMSGenerarInventarioFisico @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.MovimientosRecoleccionLista' EXEC spIntelisisWMSMovimientosRecoleccionLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.TarimasRecoleccionLista' EXEC spIntelisisWMSTarimasRecoleccionLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.CerrarRecoleccion' EXEC spIntelisisWMSCerrarRecoleccion @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.RecoleccionLista' EXEC spIntelisisWMSRecoleccionLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.RecoleccionImprimir' EXEC spIntelisisWMSRecoleccionImprimir @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.ArticuloImprimir' EXEC spIntelisisWMSArticuloImprimir @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.PosicionTarimasLista' EXEC spIntelisisWMSPosicionTarimasLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.InventarioLista' EXEC spIntelisisWMSInventarioLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.MovimientosInvLista' EXEC spIntelisisWMSMovimientosInvLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.GuardarInventario' EXEC spIntelisisWMSGuardarInventario @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.GuardarSerieLoteMov' EXEC spIntelisisWMSGuardarSerieLoteMov @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.InfoTarimaArticulo' EXEC spIntelisisWMSInfoTarimaArticulo @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.TMA.InfoCOMS_OImprimir' EXEC spIntelisisWMSInfoOrdenCompraImprimirCPLC @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.UsuarioCfg' EXEC spIntelisisWMSUsuarioCfg @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.InfoCodigoBarrasSurtido' EXEC spIntelisisWMSInfoCodigoBarrasSurtido @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.MovilLog' EXEC spIntelisisWMSMovilLog @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.EtiquetaSurtidoImprimir' EXEC spIntelisisWMSEtiquetaSurtidoImprimir @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.MovimientoCompleto' EXEC spIntelisisWMSMovimientoCompleto @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.GenerarSurtidoPerdido' EXEC spIntelisisWMSGenerarSurtidoPerdido @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.OrdenSurtidoPckLista' EXEC spIntelisisWMSOrdenSurtidoPckLista @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.WMS.TarimasPorCerrar' EXEC spIntelisisWMSTarimasPorCerrar @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

