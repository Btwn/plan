SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInforReservarSolicitudInv
@Modulo	char(5),
@ID          int,
@Accion	char(20),
@Base	char(20),
@GenerarMov	char(20),
@Usuario	char(10),
@SincroFinal	bit,
@EnSilencio	bit,
@Ok          int 	     OUTPUT,
@OkRef       varchar(255) OUTPUT

AS BEGIN
DECLARE
@ArticuloD            varchar(20),
@CantidadD            float,
@SubCuenta            varchar(50),
@SubCuentaD           varchar(50),
@UnidadD              varchar(50),
@AlmacenD             varchar(20),
@Empresa              varchar(5),
@CantidadReservada    float,
@CantidadReservar     float,
@CantidadPendiente    float,
@IDSol                int,
@RenglonD             float,
@UnidadP              varchar(50),
@IDAcceso             int,
@Estacion             int,
@ProdInterfazINFOR    bit,
@MovClave             varchar(20),
@OrigenTipo           varchar(20),
@OrigenID             varchar(20),
@Origen               varchar(20),
@ReservarSolicitudesFacory bit
IF @Modulo = 'COMS' AND @Accion = 'AFECTAR'
BEGIN
SELECT @IDAcceso = dbo.fnAccesoID(@@SPID)
SELECT @Estacion = EstacionTrabajo  FROM Acceso WHERE ID = @IDAcceso
SELECT @Empresa = Empresa FROM Compra WHERE ID = @ID
SELECT @ProdInterfazINFOR = ISNULL(ProdInterfazINFOR,0) FROM EmpresaGral WHERE Empresa = @Empresa
SELECT @MovClave = mt.Clave FROM Compra c JOIN MovTipo mt ON c.Mov = mt.Mov AND mt.Modulo = 'COMS' WHERE c.ID = @ID
SELECT @Origen = Origen, @OrigenID = OrigenID FROM Compra WHERE ID =  @ID
SELECT @OrigenTipo = OrigenTipo FROM Compra WHERE Empresa = @Empresa AND Mov = @Origen AND MovID = @OrigenID
SELECT @ReservarSolicitudesFacory = ISNULL(ReservarSolicitudesFacory,0) FROM EmpresaCfg WHERE Empresa = @Empresa
BEGIN TRAN
IF @ProdInterfazINFOR = 1 AND @MovClave = 'COMS.F' AND @OrigenTipo = 'I:MES' AND @ReservarSolicitudesFacory = 1
BEGIN
IF @OK IS NULL  AND EXISTS(SELECT * FROM Inv i JOIN InvD d ON d.ID = i.ID JOIN MovTipo m ON m.Mov = i.Mov AND m.Modulo = 'INV' JOIN Compra c ON c.ID = @ID JOIN CompraD cd ON c.ID = cd.ID AND cd.Articulo = d.Articulo AND ISNULL(cd.SubCuenta,'') = ISNULL(d.SubCuenta,'') AND ISNULL(cd.Almacen,c.Almacen) = ISNULL(d.Almacen,i.Almacen) WHERE m.Clave = 'INV.SOL' AND i.Estatus = 'PENDIENTE' AND i.OrigenTipo = 'I:MES' AND ISNULL(d.CantidadPendiente,0.0) > 0 )
BEGIN
DECLARE crArt CURSOR LOCAL FAST_FORWARD FOR
SELECT d.Articulo, d.Cantidad, d.SubCuenta, d.Unidad, ISNULL(d.Almacen,c.Almacen)
FROM Compra c JOIN CompraD d ON c.ID = d.ID
WHERE c.ID = @ID
OPEN crArt
FETCH NEXT FROM crArt INTO  @ArticuloD, @CantidadD, @SubCuentaD, @UnidadD, @AlmacenD
WHILE @@FETCH_STATUS <> -1
BEGIN
SELECT @CantidadReservar = (@CantidadD * dbo.fnArtUnidadFactor(@Empresa, @ArticuloD, @UnidadD))
DECLARE crSolicitudInv CURSOR LOCAL FAST_FORWARD FOR
SELECT d.ID, d.Renglon, ISNULL(d.CantidadPendiente,0), d.Unidad, ISNULL(d.CantidadReservada,0)
FROM Inv i JOIN InvD d ON d.ID = i.ID JOIN MovTipo m ON m.Mov = i.Mov AND m.Modulo = 'INV'
WHERE m.Clave = 'INV.SOL'
AND i.Estatus = 'PENDIENTE'
AND i.OrigenTipo = 'I:MES'
AND ISNULL(d.CantidadPendiente,0.0) > 0
AND d.Articulo = @ArticuloD
AND ISNULL(d.SubCuenta,'') = ISNULL(@SubCuenta,'')
AND ISNULL(d.Almacen,i.Almacen) = @AlmacenD
ORDER BY d.FechaRequerida, i.ID
OPEN crSolicitudInv
FETCH NEXT FROM crSolicitudInv INTO  @IDSol, @RenglonD, @CantidadPendiente, @UnidadP, @CantidadReservada
WHILE @@FETCH_STATUS <> -1 AND @CantidadReservar > 0 AND @Ok IS NULL
BEGIN
IF ISNULL(@CantidadReservar,0)>= @CantidadPendiente
BEGIN
UPDATE InvD SET CantidadA = CantidadPendiente WHERE ID = @IDSol AND Renglon = @RenglonD
SET @CantidadReservar = @CantidadReservar - @CantidadPendiente
IF @@ROWCOUNT <> 0 AND EXISTS(SELECT * FROM InvD WHERE ID = @IDSol AND ISNULL(CantidadA,0) >0)
EXEC  spAfectar 'INV', @IDSol, 'RESERVAR', 'Seleccion', NULL, @Usuario, NULL, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @EnSilencio = 1, @Conexion = 0, @Estacion = @Estacion
END
ELSE
BEGIN
UPDATE InvD
SET CantidadA = @CantidadReservar
WHERE ID = @IDSol AND Renglon = @RenglonD
SET @CantidadReservar = 0
IF @@ROWCOUNT <> 0 AND EXISTS(SELECT * FROM InvD WHERE ID = @IDSol AND ISNULL(CantidadA,0) >0)
EXEC  spAfectar 'INV', @IDSol, 'RESERVAR', 'Seleccion', NULL, @Usuario, NULL, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @EnSilencio = 1, @Conexion = 1, @Estacion = @Estacion
END
FETCH NEXT FROM crSolicitudInv INTO @IDSol, @RenglonD, @CantidadPendiente, @UnidadP, @CantidadReservada
END
CLOSE crSolicitudInv
DEALLOCATE crSolicitudInv
FETCH NEXT FROM crArt INTO @ArticuloD, @CantidadD, @SubCuentaD, @UnidadD, @AlmacenD
END
CLOSE crArt
DEALLOCATE crArt
END
END
IF @Ok IS NULL
COMMIT TRAN
ELSE
ROLLBACK TRAN
SELECT @Ok = NULL
END
RETURN
END

