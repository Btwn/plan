SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSAUXGenerar
@Modulo			varchar(5),
@ID		        int,
@Accion			varchar(20),
@Base			varchar(20),
@FechaRegistro	datetime,
@GenerarMov		char(20),
@Empresa        varchar(5),
@Sucursal		int,
@Usuario		varchar(10),
@Conexion		bit,
@SincroFinal	bit,
@Mov			varchar(20),
@MovID			varchar(20),
@MovTipo		varchar(20),
@Almacen		varchar(10),
@FechaEmision	datetime,
@ModuloDestino	varchar(5),
@MovDestino		varchar(20),
@Ok             int           	OUTPUT,
@OkRef          varchar(255)  	OUTPUT

AS BEGIN
DECLARE
@CfgMultiUnidades		bit,
@CfgMultiUnidadesNivel	char(20),
@Moneda					varchar(10),
@TipoCambio				float,
@TipoCosteo				varchar(20),
@IDGenerar				int,
@MovIDDestino			varchar(20),
@DetalleTipo			varchar(20),
@Articulo				varchar(20),
@Servicio				varchar(20),
@Cantidad				float,
@ContID					int,
@Renglon				float,
@SubProducto			varchar(50),
@SubCuenta				varchar(50),
@ArtTipo	         	varchar(20),
@VolverAfectar			int,
@RenglonID				int,
@Merma					float,
@Unidad					varchar(50),
@RenglonTipo			char(1),
@Desperdicio			float,
@CantidadInventario		float,
@Costo					float,
@MovIDGenerar			varchar(20),
@CantidadArt			float,
@FechaEntrega			datetime,
@Juego					varchar	(10),
@RenglonJgo				float,
@Opcion					varchar (20),
@FechaRequerida			datetime,
@AccionSAUX				varchar(20)
IF @Accion = 'CANCELAR'
BEGIN
SELECT @IDGenerar = NULL
IF @Modulo = 'VTAS'
SELECT @IDGenerar = s.ID, @MovDestino = s.Mov, @MovIDDestino = s.MovID
FROM SAUX s
JOIN Venta v
ON s.OrigenTipo = @Modulo
AND s.Origen = v.Mov
AND s.OrigenID = v.MovID
AND s.Empresa = v.Empresa
WHERE s.OrigenTipo = @Modulo
AND s.Origen = @Mov
AND s.OrigenID = @MovID
AND s.Empresa = @Empresa
ELSE
IF @Modulo = 'COMS'
SELECT @IDGenerar = s.ID, @MovDestino = s.Mov, @MovIDDestino = s.MovID
FROM SAUX s
JOIN Compra v
ON s.OrigenTipo = @Modulo
AND s.Origen = v.Mov
AND s.OrigenID = v.MovID
AND s.Empresa = v.Empresa
WHERE s.OrigenTipo = @Modulo
AND s.Origen = @Mov
AND s.OrigenID = @MovID
AND s.Empresa = @Empresa
IF @IDGenerar IS NOT NULL
EXEC spAfectar @ModuloDestino, @IDGenerar, @Accion, 'Todo', NULL, @Usuario, @@SPID, @Conexion = 1, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
RETURN
END
SELECT @Renglon = 0.0, @RenglonID = 0
IF @Ok IS NULL
IF @Modulo = 'VTAS'
INSERT SAUX (Empresa,  Sucursal,   Usuario,  Mov,         MovID, Contacto,   EnviarA,   FechaEmision,  FechaEntrega,   Concepto,   Proyecto,   Referencia,   Observaciones,   Estatus,       Situacion,   SituacionFecha,   SituacionUsuario,   SituacionNota,   Origen, OrigenID, OrigenTipo, UltimoCambio, TipoContacto, UEN)
SELECT       @Empresa, v.Sucursal, @Usuario, @MovDestino, NULL,  v.Cliente, v.EnviarA, @FechaEmision, v.FechaEntrega, v.Concepto, v.Proyecto, v.Referencia, v.Observaciones, 'SINAFECTAR',  v.Situacion, v.SituacionFecha, v.SituacionUsuario, v.SituacionNota, @Mov,   @MovID,   @Modulo,    @FechaEmision, 'Cliente',    UEN
FROM Venta v
WHERE v.ID = @ID
ELSE
IF @Modulo = 'COMS'
INSERT SAUX (Empresa,  Sucursal,   Usuario,  Mov,         MovID, Contacto,     FechaEmision,  FechaEntrega,   Concepto,   Proyecto,   Referencia,   Observaciones,   Estatus,       Situacion,   SituacionFecha,   SituacionUsuario,   SituacionNota,   Origen, OrigenID, OrigenTipo, UltimoCambio, TipoContacto, UEN)
SELECT       @Empresa, v.Sucursal, @Usuario, @MovDestino, NULL,  v.Proveedor, @FechaEmision, v.FechaEntrega, v.Concepto, v.Proyecto, v.Referencia, v.Observaciones, 'SINAFECTAR',  v.Situacion, v.SituacionFecha, v.SituacionUsuario, v.SituacionNota, @Mov,   @MovID,   @Modulo,    @FechaEmision, 'Proveedor',  UEN
FROM Compra v
WHERE v.ID = @ID
SELECT @IDGenerar = @@IDENTITY
IF @Modulo = 'VTAS'
DECLARE crArticulo CURSOR FOR
SELECT d.Articulo, d.SubCuenta, d.Cantidad, v.FechaEntrega
FROM VentaD d
JOIN Venta v	 ON v.ID = d.ID
WHERE d.ID = @ID
ELSE
IF @Modulo = 'COMS'
DECLARE crArticulo CURSOR FOR
SELECT d.Articulo, d.SubCuenta, d.Cantidad, v.FechaEntrega
FROM CompraD d
JOIN Compra v	 ON v.ID = d.ID
WHERE d.ID = @ID
OPEN crArticulo
FETCH NEXT FROM crArticulo INTO @Articulo, @SubProducto, @CantidadArt, @FechaEntrega
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
DECLARE crDetalle CURSOR FOR
SELECT Servicio, ISNULL(Cantidad,1) * @CantidadArt
FROM SAUXArtServicio
WHERE Articulo = @Articulo
OPEN crDetalle
FETCH NEXT FROM crDetalle INTO @Servicio, @Cantidad
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL AND ISNULL(@Cantidad, 0) <> 0
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @Renglon = @Renglon + 2048.0
IF @Modulo = 'VTAS'
SELECT TOP 1 @FechaRequerida = FechaRequerida FROM VentaD WHERE ID = @ID AND Articulo = @Articulo
ELSE
IF @Modulo = 'COMS'
SELECT TOP 1 @FechaRequerida = FechaRequerida FROM CompraD WHERE ID = @ID AND Articulo = @Articulo
INSERT SAUXD (ID,         Renglon, Producto,  SubProducto,  Servicio,  Codigo, Cantidad,  CantidadPendeiente, CantidadCancelada, CantidadA, FechaRequerida, FechaInicio, FechaFin,  FechaEntrega, Observaciones, Prioridad,       Estado, Aplica, AplicaID)
VALUES (@IDGenerar, @Renglon, @Articulo, @SubProducto, @Servicio, NULL,   @Cantidad, @Cantidad,          0,                 NULL,      NULL,           NULL,        NULL,     @FechaEntrega, NULL,          'Normal',  'SINAFECTAR',   @Mov,   @MovID)
UPDATE SAUXD SET FechaRequerida = @FechaRequerida WHERE ID = @IDGenerar AND Renglon = @Renglon
END
FETCH NEXT FROM crDetalle INTO @Servicio, @Cantidad
END
CLOSE crDetalle
DEALLOCATE crDetalle
END
FETCH NEXT FROM crArticulo INTO @Articulo, @SubProducto, @CantidadArt, @FechaEntrega
END
CLOSE crArticulo
DEALLOCATE crArticulo
IF @Accion = 'RESERVARPARCIAL'
SET @AccionSAUX = 'AFECTAR'
ELSE
SET @AccionSAUX = @Accion
IF ISNULL(@Renglon,0) = 0
DELETE Inv WHERE ID = @IDGenerar
ELSE
IF @Ok IS NULL
EXEC spAfectar @Modulo = @ModuloDestino, @ID = @IDGenerar, @Accion = @AccionSAUX, @Base = 'Todo', @GenerarMov = NULL,
@Usuario = @Usuario ,@Conexion = 1, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END

