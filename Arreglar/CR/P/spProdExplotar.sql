SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spProdExplotar
@Sucursal		int,
@Empresa		char(5),
@Usuario		char(10),
@Accion			char(20),
@Modulo			char(5),
@ID			int,
@FechaRegistro		datetime,
@Preliminar		bit,
@Ok             	int          OUTPUT,
@OkRef          	varchar(255) OUTPUT,
@EnSilencio		bit = 0

AS BEGIN
DECLARE
@Mov			 char(20),
@MovID			 varchar(20),
@MovAlmacen			 char(10),
@FechaEmision		 datetime,
@CfgMovOrdenConsumo		 char(20),
@CfgMovOrdenTransferencia	 char(20),
@CfgMovSolicitudMaterial 	 char(20),
@CfgTransferenciaConcentrada bit,
@CfgMermaIncluida		 bit,
@CfgDesperdicioIncluido	 bit,
@CfgMultiUnidades		 bit,
@CfgMultiUnidadesNivel	 char(20),
@CfgTipoMerma		 char(1),
@CfgProdAutoLote		 char(20),
@AutoReservar		 bit,
@GenerarOrdenConsumo	 bit,
@InvID			 int,
@InvMov			 char(20),
@InvMovID			 varchar(20),
@InvEstatus		 	 char(15),
@IDGenerar			 int,
@ContID			 int,
@VolverAfectar		 bit,
@Renglon			 float,
@RenglonID			 int,
@RenglonSub			 int,
@Articulo			 char(20),
@SubCuenta			 varchar(50),
@Cantidad			 float,
@Volumen			 float,
@Unidad			 varchar(50),
@Factor			 float,
@Almacen			 char(10),
@AlmacenSucursal		 int,
@AlmacenDestino		 char(10),
@Ruta			 varchar(20),
@FechaEntrega		 datetime,
@FechaOrdenar		 datetime,
@ProdSerieLote		 varchar(50),
@ArtSeProduce		 bit,
@Decimales			 int,
@Refrencia			 varchar(50),
@RenglonExp			 float
IF @FechaRegistro IS NULL SELECT @FechaRegistro = GETDATE()
SELECT @Mov          = Mov,
@MovID	       = MovID,
@MovAlmacen   = Almacen,
@FechaEmision = FechaEmision
FROM Prod
WHERE ID = @ID
IF @Accion = 'CANCELAR'
BEGIN
DECLARE crInv CURSOR FOR
SELECT ID, Mov, MovID, Estatus
FROM Inv
WHERE Empresa = @Empresa AND OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
OPEN crInv
FETCH NEXT FROM crInv INTO @InvID, @InvMov, @InvMovID, @InvEstatus
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF @InvEstatus NOT IN ('CONFIRMAR', 'PENDIENTE') SELECT @Ok = 60060
IF EXISTS(SELECT * FROM Inv WHERE OrigenTipo = 'INV' and Origen = @InvMov AND OrigenID = @InvMovID AND Estatus = 'CONCLUIDO') SELECT @Ok = 60060
IF @InvID IS NOT NULL AND @Ok IS NULL
EXEC spInv @InvID, 'INV', @Accion, 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, NULL,
@InvMov OUTPUT, @InvMovID OUTPUT, @IDGenerar OUTPUT, @ContID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT, @VolverAfectar
IF @Ok IS NOT NULL SELECT @OkRef = 'Produccion - '+RTRIM(@InvMov)+' '+LTRIM(CONVERT(char, @InvMovID))
END
FETCH NEXT FROM crInv INTO @InvID, @InvMov, @InvMovID, @InvEstatus
END
CLOSE crInv
DEALLOCATE crInv
RETURN
END
SELECT @CfgMovOrdenTransferencia = ProdOrdenTransferencia,
@CfgMovSolicitudMaterial  = ProdSolicitudMaterial,
@CfgMovOrdenConsumo       = ProdOrdenConsumo
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
SELECT @CfgMermaIncluida 	 = ProdMermaIncluida,
@CfgDesperdicioIncluido = ProdDesperdicioIncluido,
@GenerarOrdenConsumo    = ProdGenerarConsumo,
@CfgMultiUnidades       = MultiUnidades,
@CfgMultiUnidadesNivel  = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD'),
@CfgTipoMerma		 = ISNULL(ProdTipoMerma, '%'),
@CfgProdAutoLote	 = ISNULL(UPPER(ProdAutoLote) , 'NO'),
@CfgTransferenciaConcentrada = ProdTransferenciaConcentrada
FROM EmpresaCfg2
WHERE Empresa = @Empresa
IF @Ok IS NOT NULL RETURN
SELECT @AutoReservar = AutoReservar,
@FechaEntrega = FechaEntrega
FROM Prod
WHERE ID = @ID
SELECT @RenglonExp = 0
IF @Preliminar = 1
BEGIN
DELETE ProdProgramaMaterial WHERE ID = @ID
DELETE ProdProgramaRuta     WHERE ID = @ID
EXEC spProdAutoSerieLote @CfgProdAutoLote, @Sucursal, @ID
END
IF NOT EXISTS (SELECT * FROM ProdProgramaMaterial WHERE ID = @ID)
BEGIN
DECLARE crOrden CURSOR FOR
SELECT d.Renglon, d.RenglonSub, d.Articulo, d.SubCuenta, ISNULL(d.Cantidad, 0), d.Unidad, d.Factor, NULLIF(d.Volumen, 0), d.Almacen, d.ProdSerieLote, d.Ruta, a.SeProduce
FROM ProdD d, Art a
WHERE d.ID = @ID  AND d.Articulo = a.Articulo AND AutoGenerado = 0
OPEN crOrden
FETCH NEXT FROM crOrden INTO @Renglon, @RenglonSub, @Articulo, @SubCuenta, @Cantidad, @Unidad, @Factor, @Volumen, @Almacen, @ProdSerieLote, @Ruta, @ArtSeProduce
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL AND @Cantidad > 0
BEGIN
/*EXEC xpUnidadFactorProd @CfgMultiUnidades, @CfgMultiUnidadesNivel,
@Articulo, @SubCuenta, @Unidad,
@Factor OUTPUT, @Decimales OUTPUT, @Ok OUTPUT, @OkRef OUTPUT*/
IF @Ok IS NULL
IF @ArtSeProduce = 1
BEGIN
EXEC spProdExp @ID, @Ruta, @ProdSerieLote,
@Articulo, @SubCuenta, @Articulo, @SubCuenta, @Cantidad, @Unidad, @Factor, @Volumen, @Almacen,
@CfgMultiUnidades, @CfgMultiUnidadesNivel, @CfgMermaIncluida, @CfgDesperdicioIncluido, @CfgTipoMerma,
@FechaEntrega,
@RenglonExp OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
UPDATE ProdProgramaRuta
SET Cantidad    = ISNULL(Cantidad, 0)    + @Cantidad
WHERE ID = @ID AND Producto = @Articulo AND SubProducto =  @SubCuenta AND Lote = @ProdSerieLote AND Unidad = @Unidad AND Ruta = @Ruta
IF @@ROWCOUNT = 0
BEGIN
SELECT @RenglonExp  = @RenglonExp + 2048
INSERT ProdProgramaRuta (ID,  Renglon, OrdenID, Producto,  SubProducto, Lote, Cantidad,  Unidad, Ruta, Centro, Operacion, Orden)
SELECT @ID, @RenglonExp, r.OrdenID, @Articulo, @SubCuenta,  @ProdSerieLote, @Cantidad, @Unidad, @Ruta, r.Centro, r.Operacion, r.Orden
FROM ProdRutaD r
WHERE r.Ruta = @Ruta
END
END ELSE SELECT @Ok = 25010, @OkRef = @Articulo
IF @Ruta IS NOT NULL
BEGIN
IF (SELECT TieneMovimientos FROM ProdRuta WHERE Ruta = @Ruta) = 0
UPDATE ProdRuta SET TieneMovimientos = 1 WHERE Ruta = @Ruta
END
END
FETCH NEXT FROM crOrden INTO @Renglon, @RenglonSub, @Articulo, @SubCuenta, @Cantidad, @Unidad, @Factor, @Volumen, @Almacen, @ProdSerieLote, @Ruta, @ArtSeProduce
END
CLOSE crOrden
DEALLOCATE crOrden
EXEC spProdProgramaRutaCalcFechas @ID
END
IF @Preliminar = 1 UPDATE Prod SET Estatus = 'BORRADOR' WHERE ID = @ID
IF @Preliminar = 0
BEGIN
DECLARE crProdExpOT CURSOR FOR
SELECT DISTINCT AlmacenOrigen, AlmacenDestino
FROM ProdProgramaMaterial
WHERE ID = @ID AND AlmacenOrigen <> AlmacenDestino
OPEN crProdExpOT
FETCH NEXT FROM crProdExpOT INTO @Almacen, @AlmacenDestino
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF UPPER(@Almacen) = '(DEMANDA)' SELECT @Almacen = @MovAlmacen
SELECT @AlmacenSucursal = Sucursal FROM Alm WHERE Almacen = @Almacen
IF @CfgTransferenciaConcentrada = 1
EXEC spProdOrdenConcentrada @AlmacenSucursal, @Empresa, @Usuario, @AutoReservar, @CfgMovOrdenTransferencia, @Almacen, @AlmacenDestino,
@Modulo, @ID, @Mov, @MovID, @FechaEmision, @FechaRegistro,
@CfgMultiUnidades, @CfgMultiUnidadesNivel,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
EXEC spProdOrdenDesglosada @AlmacenSucursal, @Empresa, @Usuario, @AutoReservar, 0, @CfgMovOrdenTransferencia, @Almacen, @AlmacenDestino,
@Modulo, @ID, @Mov, @MovID, @FechaEmision, @FechaRegistro,
@CfgMultiUnidades, @CfgMultiUnidadesNivel,
@Ok OUTPUT, @OkRef OUTPUT
END
FETCH NEXT FROM crProdExpOT INTO @Almacen, @AlmacenDestino
END
CLOSE crProdExpOT
DEALLOCATE crProdExpOT
IF @GenerarOrdenConsumo = 1 AND @Ok IS NULL
BEGIN
DECLARE crProdExpSM CURSOR FOR
SELECT DISTINCT AlmacenDestino FROM ProdProgramaMaterial WHERE ID = @ID
OPEN crProdExpSM
FETCH NEXT FROM crProdExpSM INTO @Almacen
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @AlmacenSucursal = Sucursal FROM Alm WHERE Almacen = @Almacen
EXEC spProdOrdenDesglosada @AlmacenSucursal, @Empresa, @Usuario, 0, 1, @CfgMovOrdenConsumo, @Almacen, NULL,
@Modulo, @ID, @Mov, @MovID, @FechaEmision, @FechaRegistro,
@CfgMultiUnidades, @CfgMultiUnidadesNivel,
@Ok OUTPUT, @OkRef OUTPUT
END
FETCH NEXT FROM crProdExpSM INTO @Almacen
END
CLOSE crProdExpSM
DEALLOCATE crProdExpSM
END
END
IF @Ok IS NULL OR @Ok >= 80000
EXEC xpProdExplotar @Sucursal, @Empresa, @Usuario, @Accion, @Modulo, @ID, @FechaRegistro,@Preliminar,@Ok OUTPUT,@OkRef OUTPUT
IF @Preliminar = 1 AND @EnSilencio = 0
BEGIN
IF @Ok IS NULL
EXEC spAfectar @Modulo, @ID, 'VERIFICAR', 'TODO', NULL, @Usuario, 0, 1, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IN (NULL, 80000)
SELECT "Mensaje" = CONVERT(Char, NULL)
ELSE
SELECT "Mensaje" = Descripcion + ' '+RTRIM(@OkRef)
FROM MensajeLista
WHERE Mensaje = @Ok
END
RETURN
END

