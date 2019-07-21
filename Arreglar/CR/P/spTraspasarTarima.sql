SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTraspasarTarima
@Modulo		varchar(5),
@ID               	int,
@Accion		varchar(20),
@Empresa          	varchar(5),
@Usuario		varchar(10),
@Mov		varchar(20),
@MovID		varchar(20),
@MovTipo		varchar(20),
@FechaEmision	datetime,
@TarimaNueva	varchar(20),
@TarimaAnterior	varchar(20),
@Ok			int           	OUTPUT,
@OkRef		varchar(255)  	OUTPUT

AS BEGIN
DECLARE
@InvID	int,
@InvMov	varchar(20),
@InvMovID	varchar(20),
@Almacen	varchar(10),
@Sucursal	int,
@Moneda	varchar(10),
@TipoCambio	float,
@TipoCosteo	varchar(20),
@Cantidad	float,
@Costo	float,
@Renglon	float,
@RenglonID	int,
@Articulo	varchar(20),
@SubCuenta	varchar(50),
@Proveedor	varchar(10),
@Unidad	varchar(50)
SELECT @InvMov = InvEntarimado FROM EmpresaCfgMov WHERE Empresa = @Empresa
IF @Accion = 'CANCELAR'
SELECT @InvID = ID FROM Inv WHERE Mov = @InvMov AND OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
ELSE BEGIN
SELECT @Almacen = Almacen FROM Tarima WHERE Tarima = @TarimaAnterior
SELECT @Sucursal = Sucursal FROM Alm WHERE Almacen = @Almacen
SELECT @Moneda = ContMoneda FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @TipoCambio = TipoCambio FROM Mon WHERE Moneda = @Moneda
SELECT @TipoCosteo = ISNULL(NULLIF(RTRIM(UPPER(TipoCosteo)), ''), 'PROMEDIO')
FROM EmpresaCfg
WHERE Empresa = @Empresa
INSERT Inv (
Empresa,  Sucursal,  Mov,     Almacen,  FechaEmision,  Usuario,  Estatus,      Moneda,  TipoCambio,  OrigenTipo, Origen, OrigenID)
VALUES (@Empresa, @Sucursal, @InvMov, @Almacen, @FechaEmision, @Usuario, 'SINAFECTAR', @Moneda, @TipoCambio, @Modulo,    @Mov,   @MovID)
SELECT @InvID = SCOPE_IDENTITY()
DECLARE crTarimaExistencia CURSOR LOCAL FOR
SELECT e.Articulo, e.SubCuenta, e.Inventario, a.Proveedor, a.Unidad
FROM ArtSubExistenciaInvTarima e
JOIN Art a ON a.Articulo = e.Articulo
WHERE e.Empresa = @Empresa AND e.Almacen = @Almacen AND e.Tarima = @TarimaAnterior
AND NULLIF(e.Inventario, 0.0) IS NOT NULL
SELECT @Renglon = 0.0, @RenglonID = 0
OPEN crTarimaExistencia
FETCH NEXT FROM crTarimaExistencia INTO @Articulo, @SubCuenta, @Cantidad, @Proveedor, @Unidad
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Renglon = @Renglon + 2048.0, @RenglonID = @RenglonID + 1
SELECT @Costo = NULL
EXEC spVerCosto @Sucursal, @Empresa, @Proveedor, @Articulo, @SubCuenta, @Unidad, @TipoCosteo, @Moneda, @TipoCambio, @Costo OUTPUT, 0
INSERT InvD (
ID,     Renglon,  Seccion, RenglonSub, RenglonID,  Sucursal,  Almacen,  Articulo,  SubCuenta,              Cantidad,  Unidad,  Costo,  Tarima)
SELECT @InvID, @Renglon, NULL,    0,          @RenglonID, @Sucursal, @Almacen, @Articulo, ISNULL(@SubCuenta, ''), @Cantidad, @Unidad, @Costo, @TarimaAnterior
INSERT SerieLoteMov (
Sucursal,  Empresa, Modulo, ID,     RenglonID,  Articulo, SubCuenta, SerieLote, Cantidad,   CantidadAlterna,   Propiedades, Cliente, Localizacion, ArtCostoInv)
SELECT @Sucursal, Empresa, 'INV',  @InvID, @RenglonID, Articulo, SubCuenta, SerieLote, Existencia, ExistenciaAlterna, Propiedades, Cliente, Localizacion, CostoInv
FROM SerieLote
WHERE Empresa = @Empresa AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') AND Tarima = @TarimaAnterior
SELECT @RenglonID = @RenglonID + 1
INSERT InvD (
ID,     Renglon,  Seccion, RenglonSub, RenglonID,  Sucursal,  Almacen,  Articulo,  SubCuenta,              Cantidad,  Unidad,  Costo,  Tarima)
SELECT @InvID, @Renglon, 1,       1,          @RenglonID, @Sucursal, @Almacen, @Articulo, ISNULL(@SubCuenta, ''), @Cantidad, @Unidad, @Costo, @TarimaNueva
INSERT SerieLoteMov (
Sucursal,  Empresa, Modulo, ID,     RenglonID,  Articulo, SubCuenta, SerieLote, Cantidad,   CantidadAlterna,   Propiedades, Cliente, Localizacion, ArtCostoInv)
SELECT @Sucursal, Empresa, 'INV',  @InvID, @RenglonID, Articulo, SubCuenta, SerieLote, Existencia, ExistenciaAlterna, Propiedades, Cliente, Localizacion, CostoInv
FROM SerieLote
WHERE Empresa = @Empresa AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') AND Tarima = @TarimaAnterior
END
FETCH NEXT FROM crTarimaExistencia INTO @Articulo, @SubCuenta, @Cantidad, @Proveedor, @Unidad
END 
CLOSE crTarimaExistencia
DEALLOCATE crTarimaExistencia
END
IF @InvID IS NOT NULL
BEGIN
EXEC spAfectar 'INV', @InvID, @Accion, 'TODO', @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @InvMov = Mov, @InvMovID = MovID FROM Inv WHERE ID = @InvID
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'INV', @InvID, @InvMov, @InvMovID, @Ok OUTPUT
END
RETURN
END

