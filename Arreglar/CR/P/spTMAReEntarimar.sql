SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spTMAReEntarimar
@ID					int,
@Mov				varchar(20),
@MovID				varchar(20),
@Usuario			varchar(10),
@Accion				char(20),
@Empresa			char(5),
@Sucursal			int,
@Tarima				varchar(20),
@Almacen			varchar(10),
@PosicionAnterior	varchar(10),
@PosicionNueva		varchar(10),
@Cantidad			float,
@Unidad				varchar(20),
@CantidadPicking	float,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS
BEGIN
DECLARE @FechaEmision		datetime,
@MovAjuste		varchar(20),
@InvID			int,
@OrdenID			int,
@InvMov			varchar(20),
@OrdenMov			varchar(20),
@InvMovID			varchar(20),
@Moneda			varchar(10),
@Articulo			varchar(20),
@RenglonTipo		varchar(1),
@Factor			float,
@Costo			float,
@DefPosicionRecibo varchar(10),
@ArticuloCaducidad  varchar(20),
@FechaCaducidad     datetime 
SELECT @DefPosicionRecibo = DefPosicionRecibo FROM Alm WHERE Almacen = @Almacen
SELECT @MovAjuste = Mov FROM MovTipo WHERE Modulo = 'INV' AND Clave = 'INV.A' AND SubClave = 'INV.ATMAORENT'
SELECT @OrdenMov = InvOrdenEntarimado FROM EmpresaCfgMov WHERE Empresa = @Empresa
IF @Accion = 'AFECTAR'
BEGIN
SELECT @FechaEmision = GETDATE()
EXEC spExtraerFecha @FechaEmision OUTPUT
SELECT @Moneda = ContMoneda FROM EmpresaCfg WHERE Empresa = @Empresa
EXEC spRenglonTipo @Articulo, '', @RenglonTipo OUTPUT
SELECT @Articulo = Articulo FROM ArtDisponibleTarima WHERE Tarima = @Tarima AND Almacen = @Almacen
SELECT @Factor = dbo.fnArtUnidadFactor(@Empresa, @Articulo, @Unidad)
SELECT @Costo = ISNULL(CostoPromedio,0.0) FROM ArtCosto WHERE Articulo = @Articulo AND Sucursal = @Sucursal AND Empresa = @Empresa
SELECT @FechaCaducidad=FechaCaducidad
FROM TMAD
WHERE ID = @ID
INSERT INTO Inv(
Empresa,  Mov,        FechaEmision,  Moneda, TipoCambio,  Usuario, Estatus,      Almacen, OrigenTipo,  Origen,  OrigenID, Sucursal,  PosicionWMS) 
SELECT Empresa, @MovAjuste, @FechaEmision, @Moneda, 1,          @Usuario, 'SINAFECTAR', Almacen, 'TMA',      @Mov,    @MovID,    Sucursal, @DefPosicionRecibo
FROM TMA
WHERE ID = @ID
SELECT @InvID = SCOPE_IDENTITY()
INSERT INTO InvD(
ID,    Renglon, RenglonSub,  RenglonTipo,   Cantidad,  Almacen,  Articulo,  Costo,          Unidad,  Factor,   CantidadInventario,  Tarima)
SELECT @InvID, 2048,    0,          @RenglonTipo, -@Cantidad, @Almacen, @Articulo, @Costo*@Factor, @Unidad, @Factor, -@CantidadPicking,    @Tarima
INSERT INTO InvD(
ID,    Renglon, RenglonSub,  RenglonTipo,  Cantidad,  Almacen,  Articulo,  Costo,          Unidad,  Factor,  CantidadInventario, Tarima, FechaCaducidad)  
SELECT @InvID, 2048,    1,          @RenglonTipo, @Cantidad, @Almacen, @Articulo, @Costo*@Factor, @Unidad, @Factor, @CantidadPicking,    '', @FechaCaducidad
EXEC spAfectar 'INV', @InvID, @Accion, @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SELECT @InvMov = Mov, @InvMovID = MovID FROM Inv WHERE ID = @InvID
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, 'TMA', @ID, @Mov, @MovID, 'INV', @InvID, @InvMov, @InvMovID, @Ok OUTPUT
IF @Ok IS NULL
EXEC spGenerarOrdenEntarimado 'INV', @InvID, @Accion, @Empresa, @Sucursal, @Usuario, @InvMov, @InvMovID, 'INV.A', @Almacen, @Ok OUTPUT, @OkRef OUTPUT
END
END
ELSE IF @Accion = 'CANCELAR'
BEGIN
SELECT @InvID = ID,
@InvMov = Mov,
@InvMovID = MovID
FROM Inv
WHERE Mov = @MovAjuste
AND OrigenTipo = 'TMA'
AND Origen = @Mov
AND OrigenID = @MovID
SELECT @OrdenID = ID
FROM Inv
WHERE Mov = @OrdenMov
AND OrigenTipo = 'INV'
AND Origen = @InvMov
AND OrigenID = @InvMovID
AND Estatus NOT IN('CANCELADO')
IF @OrdenID IS NOT NULL
EXEC spAfectar 'INV', @OrdenID, @Accion, @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL AND @InvID IS NOT NULL
EXEC spAfectar 'INV', @InvID, @Accion, @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, 'TMA', @ID, @Mov, @MovID, 'INV', @InvID, @InvMov, @InvMovID, @Ok OUTPUT
END
RETURN
END

