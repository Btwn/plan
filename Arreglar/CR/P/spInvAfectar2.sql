SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvAfectar2
@ID                		int,
@Accion			varchar(20),
@Base			varchar(20),
@Empresa	      		varchar(5),
@Usuario			varchar(10),
@Modulo	      		varchar(5),
@Mov	  	      		varchar(20),
@MovID             		varchar(20),
@MovTipo     		varchar(20),
@MovMoneda	      		varchar(10),
@MovTipoCambio	 	float,
@Estatus	 	      	varchar(15),
@EstatusNuevo	      	varchar(15),
@FechaEmision		datetime,
@FechaRegistro		datetime,
@FechaAfectacion    		datetime,
@Conexion			bit,
@SincroFinal			bit,
@Sucursal			int,
@UtilizarID			int,
@UtilizarMovTipo    		varchar(20),
@EsEcuador                   bit,
@IDGenerar                   int,
@GenerarOP                   bit,
@ClienteProv                 varchar(10),
@ServicioSerie               varchar(20),
@OrigenTipo                  varchar(10),
@Ok				int		OUTPUT,
@OkRef			varchar(255)	OUTPUT,
@OPORT			bit,
@SubClave		        varchar(20),
@Origen			varchar(20),
@OrigenID		        varchar(20),
@CfgVentaPuntosEnVales       bit,
@AlmacenDestinoOriginal      varchar(20),
@Almacen                     varchar(20),
@Referencia                  varchar(50),
@IDTransito                  int,
@ContID                      int,
@Estacion                    int,
@TransitoSucursal            int,
@TransitoMov                 varchar(20),
@TransitoMovID               varchar(20),
@TransitoEstatus             varchar(15),
@TraspasoExpressMov          varchar(20),
@TraspasoExpressMovID        varchar(20),
@CFGProdInterfazInfor        bit,
@OrigenMovTipo               varchar(20),
@Proyecto	      		    varchar(50),
@Tarima                      varchar(20),
@Articulo                    varchar(20)

AS BEGIN
DECLARE	@OID				int,
@PosicionD          char(10),
@WMS                bit,
@AlmacenDestino     varchar(10),
@IDOrden            int,
@CfgEspacios        bit
SELECT @WMS = NULLIF(WMS,''),
@CfgEspacios = Espacios
FROM EmpresaGral
WHERE Empresa = @Empresa
/*
IF @WMS = 1 AND @Modulo = 'INV' AND @MovTipo IN('INV.T','INV.EI') AND @Accion = 'AFECTAR' AND @Ok IN (NULL, 80030)  
BEGIN
SELECT @AlmacenDestino = NULLIF(AlmacenDestino,''),@PosicionD = NULLIF(PosicionDWMS,'')
FROM Inv
WHERE ID= @ID
IF EXISTS(SELECT * FROM Alm WHERE Almacen = @AlmacenDestino AND WMS = 1)
BEGIN
IF @PosicionD IS NOT NULL
EXEC spGenerarOrdenEntarimado @Modulo, @ID, @Accion, @Empresa, @Sucursal, @Usuario, @Mov, @MovID, @MovTipo, @AlmacenDestino, @Ok OUTPUT, @OkRef OUTPUT
END
IF @MovTipo = 'INV.EI'
UPDATE InvD SET Tarima = NULL WHERE ID = @ID
IF @Modulo = 'INV' AND @Accion = 'CANCELAR' AND @MovTipo = 'INV.E'
BEGIN
SELECT @IDOrden = ID FROM Inv WHERE Origen = @Mov AND OrigenID = @MovID
IF @IDOrden IS NOT NULL
UPDATE Inv SET OrigenTipo = @Modulo WHERE ID = @IDOrden
END
END
*/
IF @Ok IS NULL AND @Accion NOT IN('CANCELAR')
BEGIN
IF EXISTS(SELECT * FROM SerieLoteMov WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID AND Sucursal NOT IN (SELECT Sucursal  FROM Alm WHERE Almacen = @Almacen))
UPDATE SerieLoteMov
SET Sucursal = (SELECT Sucursal  FROM Alm WHERE Almacen = @Almacen)
WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID
END
/* TransferirA */
IF @MovTipo IN ('VTAS.D', 'VTAS.DCR') AND @Ok IN (NULL, 80030)
BEGIN
SELECT @Ok = NULL
IF EXISTS(SELECT * FROM VentaD WHERE ID = @ID AND ISNULL(NULLIF(RTRIM(TransferirA), ''), Almacen) <> Almacen)
EXEC spInvTransferirA @Empresa, @Sucursal, @Usuario, @Accion, @Modulo, @ID, @Mov, @MovID, @FechaEmision, @FechaRegistro, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spInvFacturaFlexibleAfectar @Empresa, @Sucursal, @Usuario, @Accion, @Estatus, @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000) AND @EsEcuador = 1
EXEC spEcuadorAutorizacion @Sucursal, @Empresa, @Modulo, @ID, @Accion, @EstatusNuevo, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spGTInvAfectar @ID, @Accion, @Base, @Empresa, @Usuario, @Modulo, @Mov, @MovID, @MovTipo,
@MovMoneda, @MovTipoCambio, @Estatus, @EstatusNuevo, @FechaEmision, @FechaRegistro, @FechaAfectacion, @Conexion, @SincroFinal, @Sucursal,
@UtilizarID, @UtilizarMovTipo, @IDGenerar,
@Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spInvFacturaProrrateadaAfectar @ID, @Accion, @Base, @Empresa, @Usuario, @Modulo, @Mov, @MovID, @MovTipo,
@MovMoneda, @MovTipoCambio, @Estatus, @EstatusNuevo, @FechaEmision, @FechaRegistro, @FechaAfectacion, @Conexion, @SincroFinal, @Sucursal,
@UtilizarID, @UtilizarMovTipo,
@Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spInvPedidoProrrateadoAfectar  @ID, @Accion, @Base, @Empresa, @Usuario, @Modulo, @Mov, @MovID, @MovTipo,
@MovMoneda, @MovTipoCambio, @Estatus, @EstatusNuevo, @FechaEmision, @FechaRegistro, @FechaAfectacion, @Conexion, @SincroFinal, @Sucursal,
@UtilizarID, @UtilizarMovTipo,
@Ok OUTPUT, @OkRef OUTPUT
IF @MovTipo = 'VTAS.S' AND @GenerarOP = 1 AND @EstatusNuevo IN ('PENDIENTE', 'CANCELADO') AND @Estatus <> @EstatusNuevo
EXEC spAutoGenerarOP @Sucursal, @Accion, @Modulo, @ID, @Mov, @MovID, @MovTipo, @Empresa, @Usuario, @FechaRegistro, @ClienteProv, @ServicioSerie, @Ok OUTPUT, @OkRef OUTPUT
IF @MovTipo = 'INV.EP' AND @EstatusNuevo = 'CANCELADO' AND @Ok IS NULL AND @Accion = 'CANCELAR'
EXEC spInvEntradaProductoCancelarConsumoMaterial @Accion, @Empresa, @ID, @Ok OUTPUT, @OkRef OUTPUT
IF @MovTipo = 'INV.CM' AND @EstatusNuevo = 'CONCLUIDO' AND @Ok IS NULL AND @OrigenTipo = 'INV/EP'
EXEC spInvConsumoMaterialAfectarEntradaProducto @Accion, @Empresa, @Sucursal, @ID, @Mov, @MovID, @Ok OUTPUT, @OkRef OUTPUT
IF @MovTipo = 'VTAS.C' AND ISNULL(@SubClave, '') = 'VTAS.COPORT' AND @OrigenTipo = 'OPORT'
BEGIN
SELECT @OID = ID FROM Oportunidad WHERE Mov = @Origen and MovID = @OrigenID AND Empresa = @Empresa
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @OrigenTipo, @OID, @Origen, @OrigenID, @Modulo, @ID, @Mov, @MovID, @Ok OUTPUT
END
IF @Modulo = 'COMS' AND @MovTipo = 'COMS.F' AND @SubClave = 'COMS.EMAQUILA' AND @CFGProdInterfazInfor = 1 AND @Ok IS NULL
EXEC spCompraEntradaMaquilaGenerarEntradaProd @Accion, @Empresa, @Sucursal, @ID, @Mov, @MovID, @Ok OUTPUT, @OkRef OUTPUT
IF @CfgVentaPuntosEnVales = 1 AND @Accion IN ('AFECTAR', 'RESERVARPARCIAL', 'CANCELAR') AND @Mov IN (SELECT Mov FROM EmpresaCfgPuntosEnValesMov WHERE Empresa = @Empresa) AND (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
EXEC spVentaPuntosEnVales @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @Accion, @FechaEmision, @Usuario, @Sucursal, @MovMoneda, @MovTipoCambio, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @MovTipo = 'COMS.GX'
IF EXISTS(SELECT * FROM CompraD WHERE ID = @ID AND EsEstadistica = 1)
EXEC spInvGenerarEstadistica @Empresa, @Sucursal, @Modulo, @ID, @Mov, @MovID, @Accion, @ClienteProv, @Ok OUTPUT, @OkRef OUTPUT
/* Generar Transito */
IF @MovTipo IN ('INV.SI', 'INV.DTI') AND @Ok IS NULL AND @Accion <> 'VERIFICAR'
BEGIN
IF @Accion <> 'CANCELAR'
BEGIN
EXEC @IDGenerar = spMovCopiar @Sucursal, @Modulo, @ID, @Usuario, @FechaRegistro, 1, @CopiarArtCostoInv = 1
IF @IDGenerar IS NOT NULL
BEGIN
IF @MovTipo = 'INV.DTI'
BEGIN
UPDATE Inv SET Almacen = @AlmacenDestinoOriginal, AlmacenDestino = @Almacen WHERE ID = @IDGenerar
UPDATE InvD SET Almacen = @AlmacenDestinoOriginal WHERE ID = @IDGenerar
END
UPDATE Inv
SET Referencia      = RTRIM(@Mov)+ ' ' + RTRIM(@MovID),
SucursalDestino = (SELECT a.Sucursal  FROM Inv i, Alm a  WHERE i.ID = @IDGenerar AND a.Almacen = i.AlmacenDestino),
Mov             = (SELECT InvTransito FROM EmpresaCfgMov WHERE Empresa = @Empresa),
OrigenTipo = @Modulo,
Origen     = @Mov,
OrigenID   = @MovID
WHERE ID = @IDGenerar
UPDATE SerieLoteMov
SET Sucursal = (SELECT Sucursal  FROM Alm WHERE Almacen = @AlmacenDestinoOriginal)
WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @IDGenerar
EXEC xpGenerarTransito @Empresa, @Sucursal, @Usuario, @Modulo, @MovTipo, @Referencia, @ID, @IDGenerar
END
END ELSE
SELECT @IDGenerar = @IDTransito
IF @Ok IN (NULL, 80030)
BEGIN
SELECT @Ok = NULL, @OkRef = NULL
EXEC spInv @IDGenerar, @Modulo, @Accion, 'TODO', @FechaRegistro, NULL, @Usuario, 1, @SincroFinal, 'TRANSITO',
@Mov, @MovID, @IDGenerar, @ContID,
@Ok OUTPUT, @OkRef OUTPUT/*, @VolverAfectar*/, @Estacion 
SELECT @TransitoSucursal = Sucursal, @TransitoMov = Mov, @TransitoMovID = MovID, @TransitoEstatus = Estatus FROM Inv WHERE ID = @IDGenerar
IF @Ok IN (NULL, 80030)
BEGIN
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @Modulo, @IDGenerar, @TransitoMov, @TransitoMovID, @Ok OUTPUT
IF @Accion = 'CANCELAR' AND @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
END ELSE SELECT @OkRef = @TransitoMov
END
/* Traspaso Express */
IF (SELECT TraspasoExpress FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov) = 1 AND @Ok IN (NULL, 80030) AND @Accion <> 'CANCELAR'  AND @TransitoEstatus = 'PENDIENTE'
BEGIN
SELECT @Ok = NULL, @OkRef = NULL
SELECT @IDTransito = @IDGenerar
EXEC @IDGenerar = spMovCopiar @Sucursal, @Modulo, @IDTransito, @Usuario, @FechaRegistro, 1, @CopiarArtCostoInv = 1
IF @IDGenerar IS NOT NULL
BEGIN
UPDATE Inv
SET Mov             = (SELECT InvReciboTraspaso FROM EmpresaCfgMov WHERE Empresa = @Empresa),
OrigenTipo      = @Modulo,
Origen          = @TransitoMov,
OrigenID        = @TransitoMovID,
Directo         = 0
WHERE ID = @IDGenerar
UPDATE InvD
SET Aplica   = @TransitoMov,
AplicaID = @TransitoMovID
WHERE ID = @IDGenerar
EXEC spInv @IDGenerar, @Modulo, @Accion, 'TODO', @FechaRegistro, NULL, @Usuario, 1, @SincroFinal, NULL,
@Mov, @MovID, @IDGenerar, @ContID,
@Ok OUTPUT, @OkRef OUTPUT/*, @VolverAfectar*/, @Estacion 
SELECT @TraspasoExpressMov = Mov, @TraspasoExpressMovID = MovID FROM Inv WHERE ID = @IDGenerar
IF @Ok IN (NULL, 80030)
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @IDTransito, @TransitoMov, @TransitoMovID, @Modulo, @IDGenerar, @TraspasoExpressMov, @TraspasoExpressMovID, @Ok OUTPUT
ELSE
SELECT @OkRef = @TraspasoExpressMov
END
END
END
IF @OrigenMovTipo <> 'INV.IF'
BEGIN
SELECT @AlmacenDestino = NULLIF(AlmacenDestino,'')
FROM Inv
WHERE ID= @ID
IF @MovTipo='INV.T' AND @WMS = 1 AND EXISTS(SELECT * FROM Alm WHERE Almacen = @AlmacenDestino AND WMS = 1) AND @Accion IN ('AFECTAR', 'CANCELAR', 'RESERVARPARCIAL') AND @OrigenTipo <> 'TMA' AND @Ok IS NULL
BEGIN
EXEC spFlujoWMS @Modulo, @ID, @Accion, @Empresa, @Sucursal, @Usuario, @Mov, @MovID, @MovTipo, @Almacen, @FechaEmision, @Proyecto, @Tarima, @Articulo, @Ok OUTPUT, @OkRef OUTPUT
END
END
END

