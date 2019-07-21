SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisServiceProcesarInfor
@Sistema          varchar(100),
@ID               int,
@iSolicitud       int,
@Solicitud        varchar(max),
@Version          float,
@Referencia       varchar(100),
@SubReferencia    varchar(100),
@Resultado        varchar(max)    OUTPUT,
@Ok               int    OUTPUT,
@OkRef            varchar(255) OUTPUT

AS BEGIN
IF @Referencia = 'Intelisis.COMS.InsertarMov.COMS_O'           EXEC spISIntelisisCOMSInsertarMovCOMS_O      @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.COMS.Mov.Listado'                  EXEC spIntelisisCOMSMovListado        @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Cuenta.Alm.Listado'                EXEC spIntelisisCuentaAlmListado       @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Cuenta.Art.Insertar'               EXEC spCuentaInsertarArt         @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Cuenta.ArtFam.Listado'             EXEC spIntelisisCuentaArtFamListado       @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Cuenta.Articulo.Listado'           EXEC spIntelisisCuentaArticuloListado      @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Cuenta.ArtLinea.Listado'           EXEC spIntelisisCuentaArtLineaListado      @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Cuenta.Cte.Listado'                EXEC spIntelisisCuentaCteListado       @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Cuenta.CteTipo.Listado'            EXEC spIntelisisCuentaCteTipoListado      @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Cuenta.Departamento.Listado'       EXEC spIntelisisCuentaDepartamentoListado     @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Cuenta.Empresa.Listado'            EXEC spIntelisisCuentaEmpresaListado      @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Cuenta.Mon.Listado'                EXEC spIntelisisCuentaMonListado       @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Cuenta.Mon.Listado'                EXEC spIntelisisMonTipoListado        @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Cuenta.MotivoRechazo.Listado'      EXEC spIntelisisCuentaMotivoRechazoListado     @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Cuenta.Personal.Listado'           EXEC spIntelisisCuentaPersonalListado      @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Cuenta.Planta.Listado'             EXEC spIntelisisCuentaPlantaListado       @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Cuenta.Planta.Usuario.Listado'     EXEC spIntelisisCuentaPlantaUsuarioListado     @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Cuenta.Prov.Listado'               EXEC spIntelisisCuentaProvListado       @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Cuenta.Sucursal.Listado'           EXEC spIntelisisCuentaSucursalListado      @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Cuenta.Unidad.Listado'             EXEC spIntelisisCuentaUnidadListado       @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Cuenta.Usuario.Listado'            EXEC spIntelisisCuentaUsuarioListado      @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.CancelarMov'        EXEC spISIntelisisCancelarMov        @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.ExistenciaMES'      EXEC sp_InvMES            @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Insertar.CancelacionMov'    EXEC spISIntelisisCancelarMov        @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Solicitud.ObjetivosVentas'  EXEC spObjetivoVentasIntelisisMES       @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Transferencia.Alm'          EXEC spIntelisisInterfazInforTransferenciaAlm    @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Transferencia.Art'          EXEC spIntelisisInterfazInforTransferenciaArt    @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Transferencia.ArtContadorLotes'  EXEC spIntelisisInterfazInforTransferenciaArtContadorLotes @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Transferencia.ArtFam'       EXEC spIntelisisInterfazInforTransferenciaArtFam   @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Transferencia.ArtLinea'     EXEC spIntelisisInterfazInforTransferenciaArtLinea   @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Transferencia.COMS_F'       EXEC spInforTransferenciaCOMS_F        @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Transferencia.COMS_O'       EXEC spInforTransferenciaCOMS_O        @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Transferencia.COMS_OC'      EXEC spInforTransferenciaCOMS_OC        @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Transferencia.Cte'          EXEC spIntelisisInterfazInforTransferenciaCte    @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Transferencia.CteTipo'      EXEC spIntelisisInterfazInforTransferenciaCteTipo   @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Transferencia.Departamento'   EXEC spIntelisisInterfazInforTransferenciaDepartamento  @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Transferencia.Empresa'      EXEC spIntelisisInterfazInforTransferenciaEmpresa   @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Transferencia.Mon'          EXEC spIntelisisInterfazInforTransferenciaMon    @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Transferencia.MotivoRechazo'  EXEC spIntelisisInterfazInforTransferenciaMotivoRechazo  @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Transferencia.Opcion'       EXEC spIntelisisInterfazInforTransferenciaArtOpcion   @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Transferencia.OpcionDetalle'  EXEC spIntelisisInterfazInforTransferenciaArtOpcionDetalle @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Transferencia.Personal'     EXEC spIntelisisInterfazInforTransferenciaPersonal   @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Transferencia.Planta'       EXEC spIntelisisInterfazInforTransferenciaPlanta   @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Transferencia.PlantaUsuario'  EXEC spIntelisisInterfazInforTransferenciaPlantaUsuario  @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Transferencia.Prov'         EXEC spIntelisisInterfazInforTransferenciaProv    @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Transferencia.Sucursal'     EXEC spIntelisisInterfazInforTransferenciaSucursal   @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Transferencia.Unidad'       EXEC spIntelisisInterfazInforTransferenciaUnidad   @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Transferencia.Usuario'      EXEC spIntelisisInterfazInforTransferenciaUsuario   @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Transferencia.VTAS_F'       EXEC spInforTransferenciaVTAS_F        @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Transferencia.VTAS_P'       EXEC spInforTransferenciaVTAS_P        @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Interfaz.Infor.Transferencia.VTAS_PR'      EXEC spInforTransferenciaVTAS_PR        @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.INV.InsertarMov.INV_E'        EXEC spISIntelisisINVInsertarMovINV_E      @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.INV.InsertarMov.INV_EST'        EXEC spISIntelisisINVInsertarMovINV_EST      @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.INV.InsertarMov.INV_S'        EXEC spISIntelisisINVInsertarMovINV_S      @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.COMS_INV.InsertarMov.Maquila' EXEC spISIntelisisCOMSInsertarMovCOMS_Maquila      @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.NOM.Rendimiento.NOM_P'        EXEC spIntelisisInterfazInforNOM_P       @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.PC.InsertarMov.PC_C'          EXEC spISIntelisisPCInsertarMovPC_C       @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.VTAS.Mov.Listado'             EXEC spIntelisisVTASMovListado        @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT ELSE
IF @Referencia = 'Intelisis.Art.ActCosto'                 EXEC spISIntelisisActualizarCosto @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

