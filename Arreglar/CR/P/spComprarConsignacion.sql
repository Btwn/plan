SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spComprarConsignacion
@Sucursal		int,
@Empresa		char(5),
@Usuario		char(10),
@Articulo		char(20),
@SubCuenta		varchar(50),
@Almacen		char(10),
@Tarima			varchar(20),
@Cantidad		float,
@Modulo			char(5),
@Mov			char(20),
@MovID			varchar(20),
@FechaRegistro		datetime,
@Ejercicio		int,
@Periodo		int,
@Ok                	int          OUTPUT,
@OkRef			varchar(255) OUTPUT

AS BEGIN
DECLARE
@OrigenID			int,
@ID  			int,
@UltID			int,
@ContID			int,
@Renglon			float,
@RenglonID			int,
@Requiere   		float,
@Obtenido			float,
@Posicion			varchar(10),
@Aplica			char(20),
@UltAplica			char(20),
@AplicaID			varchar(20),
@UltAplicaID		varchar(20),
@PendienteInventario	float,
@Costo			money,
@MovUnidad			varchar(50),
@Factor			float,
@DescTipo			char(1),
@Desc			money,
@Impuesto1			float,
@Impuesto2			float,
@Impuesto3			money,
@DescExtra			varchar(255),
@DestinoTipo 		char(20),
@Destino			char(20),
@DestinoID   		varchar(20),
@GenerarMov 		char(20),
@GenerarMovID 		varchar(20),
@FechaCaducidad		datetime
SELECT @Requiere = @Cantidad, @UltID = NULL, @UltAplica = NULL, @UltAplicaID = NULL, @SubCuenta = NULLIF(RTRIM(@SubCuenta), '')
SELECT @GenerarMov = CompraEntrada FROM EmpresaCfgMov WHERE Empresa = @Empresa
SELECT @OrigenID = dbo.fnModuloID (@Empresa, @Modulo, @Mov, @MovID, @Ejercicio, @Periodo)
DECLARE crComprarConsig CURSOR
FOR SELECT Compra.Mov, Compra.MovID, CompraD.Posicion, ISNULL(CompraD.CantidadPendiente*NULLIF(CompraD.Factor, 0.0), 0.0), CompraD.Unidad, CompraD.Factor, CompraD.Costo, CompraD.DescuentoTipo, CompraD.DescuentoLinea, CompraD.Impuesto1, CompraD.Impuesto2, CompraD.Impuesto3, CompraD.DescripcionExtra, CompraD.DestinoTipo, CompraD.Destino, CompraD.DestinoID, CompraD.FechaCaducidad
FROM CompraD, Compra, MovTipo
WHERE Compra.Estatus = 'PENDIENTE'
AND MovTipo.Mov = Compra.Mov
AND MovTipo.Clave = 'COMS.CC'
AND CompraD.ID = Compra.ID
AND CompraD.Almacen = @Almacen
AND CompraD.Articulo = @Articulo
AND ISNULL(CompraD.SubCuenta, '') = ISNULL(@SubCuenta, '')
AND ISNULL(CompraD.Tarima, '') = ISNULL(@Tarima, '')
AND CompraD.CantidadPendiente > 0.0
ORDER BY Compra.Mov, Compra.MovID
OPEN crComprarConsig
FETCH NEXT FROM crComprarConsig INTO @Aplica, @AplicaID, @Posicion, @PendienteInventario, @MovUnidad, @Factor, @Costo, @DescTipo, @Desc, @Impuesto1, @Impuesto2, @Impuesto3, @DescExtra, @DestinoTipo, @Destino, @DestinoID, @FechaCaducidad
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @OK IS NULL AND @Requiere > 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Aplica <> @UltAplica OR @AplicaID <> @UltAplicaID
BEGIN
IF @UltID IS NOT NULL
EXEC spInv @UltID, 'COMS', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, NULL,
@UltAplica OUTPUT, @UltAplicaID OUTPUT, @ID OUTPUT, @ContID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT, 0
IF @Ok IS NULL
BEGIN
SELECT @GenerarMovID = NULL
EXEC spMovGenerar @Sucursal, @Empresa, 'COMS', @Ejercicio, @Periodo, @Usuario, @FechaRegistro, 'SINAFECTAR',
@Almacen, NULL,
@Aplica, @AplicaID, 0,
@GenerarMov, NULL, @GenerarMovID OUTPUT, @ID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
SELECT @Renglon = 0, @RenglonID = 0, @UltAplica = @Aplica, @UltAplicaID = @AplicaID, @UltID = @ID
UPDATE Compra SET OrigenTipo = @Modulo, Origen = @Mov, OrigenID = @MovID WHERE ID = @ID
END
END
IF @Requiere < @PendienteInventario
SELECT @Obtenido = @Requiere
ELSE
SELECT @Obtenido = @PendienteInventario
SELECT @Requiere = @Requiere - @Obtenido, @Renglon = @Renglon + 2048, @RenglonID = @RenglonID + 1
IF @OK IS NULL
BEGIN
INSERT INTO CompraD (Sucursal, ID,  Renglon,  RenglonSub, RenglonID,  Aplica,  AplicaID,  Posicion,  Almacen,  Tarima,  Articulo,  SubCuenta,  Cantidad,          Unidad,     Factor,  CantidadInventario, Costo,  DescuentoTipo, DescuentoLinea, Impuesto1,  Impuesto2,  Impuesto3,  DescripcionExtra, DestinoTipo,  Destino,  DestinoID, FechaCaducidad)
VALUES (@Sucursal, @ID, @Renglon, 0,         @RenglonID, @Aplica, @AplicaID, @Posicion, @Almacen, @Tarima, @Articulo, @SubCuenta, @Obtenido/@Factor, @MovUnidad, @Factor, @Obtenido,          @Costo, @DescTipo,     @Desc,          @Impuesto1, @Impuesto2, @Impuesto3, @DescExtra,       @DestinoTipo, @Destino, @DestinoID, @FechaCaducidad)
IF (SELECT Tipo FROM Art WHERE Articulo = @Articulo) IN ('SERIE', 'LOTE', 'VIN', 'PARTIDA')
INSERT SerieLoteMov (Empresa,  Sucursal,  Modulo, ID,  RenglonID,  Articulo,  SubCuenta,              SerieLote, Cantidad, ArtCostoInv)
SELECT  @Empresa, @Sucursal, 'COMS', @ID, @RenglonID, @Articulo, ISNULL(@SubCuenta, ''), SerieLote, Cantidad, ArtCostoInv
FROM fnSerieLoteMovParcialConExistencia (@Empresa, @Modulo, @OrigenID, @Articulo, @SubCuenta, @Obtenido, @Almacen)
END
IF @@ERROR <> 0 SELECT @Ok = 1
END
IF @Requiere > 0
FETCH NEXT FROM crComprarConsig INTO @Aplica, @AplicaID, @Posicion, @PendienteInventario, @MovUnidad, @Factor, @Costo, @DescTipo, @Desc, @Impuesto1, @Impuesto2, @Impuesto3, @DescExtra, @DestinoTipo, @Destino, @DestinoID, @FechaCaducidad
IF @@ERROR <> 0 SELECT @Ok = 1
END
CLOSE crComprarConsig
DEALLOCATE crComprarConsig
IF @Requiere = 0
IF @UltID IS NOT NULL
EXEC spInv @UltID, 'COMS', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, NULL,
@UltAplica OUTPUT, @UltAplicaID OUTPUT, @ID OUTPUT, @ContID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT, 0
ELSE
IF @Ok IS NULL SELECT @Ok = 30130
END

