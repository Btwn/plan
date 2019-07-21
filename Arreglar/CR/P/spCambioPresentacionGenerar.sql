SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCambioPresentacionGenerar
@Empresa               char(5),
@Almacen               char(10),
@Articulo              char(20),
@NuevaPresentacion     char(20),
@Cantidad              float,
@Unidad                varchar(50),
@Modulo                char(5),
@ID                    int

AS BEGIN
DECLARE
@Fecha		       datetime,
@IDGenerar                 int,
@CfgMultiUnidades	       bit,
@CfgMultiUnidadesNivel     char(20),
@Origen         	       varchar(20),
@OrigenID         	       varchar(20),
@IDDestino		       int,
@DestinoTipo	       char(10),
@Destino		       varchar(20),
@DestinoID		       varchar(20),
@DestinoMoneda	       char(10),
@ArtTipo                   varchar(20),
@SubCuenta                 varchar(50),
@Mov 		       char(20),
@MovID 		       varchar(20),
@Moneda     	       char(10),
@TipoCambio 	       float,
@Ok         	       int,
@OkRef      	       varchar(255),
@Usuario    	       char(10),
@Sucursal   	       int,
@SucursalOrigen	       int,
@RenglonTipo               char(1),
@CantidadInventario        float
SELECT @Ok = 0,@OkRef = NULL, @SubCuenta = NULL, @DestinoTipo = NULL, @Destino = NULL, @DestinoID = NULL
SELECT @Fecha = GETDATE()
EXEC spExtraerFecha @Fecha OUTPUT
SELECT @Mov = cfg.InvCambioPresentacion
FROM EmpresaCfgMov cfg
WHERE cfg.Empresa = @Empresa
SELECT @CfgMultiUnidades       = MultiUnidades,
@CfgMultiUnidadesNivel  = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD')
FROM EmpresaCfg2
WHERE Empresa = @Empresa
SELECT @Sucursal = Sucursal,
@SucursalOrigen = SucursalOrigen,
@Usuario = Usuario,
@Origen = Mov,
@OrigenID = MovID,
@Moneda = Moneda,
@TipoCambio = TipoCambio
FROM Inv
WHERE ID = @ID
INSERT INTO Inv  (Empresa,     Mov,  FechaEmision, Moneda,  TipoCambio,  Estatus    ,  Directo,  Almacen,  Usuario,  Sucursal,  SucursalOrigen,   OrigenTipo,  Origen,  OrigenID)
VALUES           (@Empresa,    @Mov, @Fecha,       @Moneda, @TipoCambio, 'SINAFECTAR', 1,        @Almacen, @Usuario, @Sucursal, @SucursalOrigen,  'INV',       @Origen, @OrigenID)
SELECT @IDGenerar = SCOPE_IDENTITY()
SELECT @ArtTipo = Tipo FROM Art WHERE Articulo = @Articulo
EXEC spRenglonTipo @ArtTipo, @SubCuenta, @RenglonTipo OUTPUT
EXEC xpCantidadInventario @Articulo, @SubCuenta, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
INSERT INTO InvD
(ID,         Renglon, RenglonID,  RenglonTipo,  Almacen,  Articulo,   SubCuenta,  ArticuloDestino,    Cantidad,  Unidad,  CantidadInventario,  Sucursal,  SucursalOrigen)
VALUES  (@IDGenerar, 2048.0,  1,          @RenglonTipo, @Almacen, @Articulo,  @SubCuenta, @NuevaPresentacion, @Cantidad, @Unidad, @CantidadInventario, @Sucursal, @SucursalOrigen)
EXEC spAfectar 'INV', @IDGenerar, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @Mov = ISNULL(Mov, ''), @MovID = ISNULL(MovID, '')
FROM Inv
WHERE ID = @IDGenerar
IF @Ok IS NULL
EXEC xpCambioPresentacionGenerar @Empresa, @Almacen, @Articulo, @NuevaPresentacion, @Cantidad, @Unidad, @Modulo, @ID
IF @Ok IS NULL
BEGIN
SELECT @DestinoTipo = DestinoTipo, @Destino = Destino, @DestinoID = DestinoID FROM InvD WHERE ID = @ID AND Articulo = @NuevaPresentacion
IF @DestinoTipo = 'VTAS'
BEGIN
EXEC spMovEnID @DestinoTipo, @Empresa, @Destino, @DestinoID, @IDDestino OUTPUT, @DestinoMoneda OUTPUT, @Ok OUTPUT
UPDATE VentaD SET DescripcionExtra = @Articulo WHERE ID = @IDDestino AND Articulo = @NuevaPresentacion AND NULLIF(CantidadOrdenada, 0) IS NOT NULL
END
END
IF @Ok IS NULL
SELECT 'Se Genero con Exito ' + @Mov + ' ' + @MovID
ELSE
SELECT Descripcion + ' ' + ISNULL(RTRIM(@OkRef), '') FROM MensajeLista WHERE Mensaje = @Ok
RETURN
END

