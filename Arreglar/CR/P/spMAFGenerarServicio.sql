SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMAFGenerarServicio
@Empresa		varchar(5),
@Sucursal		int,
@Accion			varchar(20),
@Usuario		varchar(10),
@Servicio		varchar(50),
@ID			int,
@AFArticulo		varchar(20),
@AFSerie		varchar(50),
@MAFCiclo			int,
@Ok			int		OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@MAFServicioTaller		varchar(10),
@MAFServicioUsuario		varchar(10),
@MAFServicioMov		varchar(20),
@MAFServicioConcepto	varchar(50),
@MAFServicioCliente		varchar(10),
@Tipo			varchar(50),
@Moneda			varchar(10),
@TipoCambio			float,
@FechaEmision		datetime,
@ServicioDescripcion	varchar(100),
@AF				int,
@Origen			varchar(20),
@OrigenID			varchar(20),
@IDGenerar			int,
@MovGenerar			varchar(20),
@MovIDGenerar		varchar(20),
@Articulo			varchar(20),
@SubCuenta			varchar(50),
@Cantidad			float,
@AlmacenEsp			varchar(10),
@ListaPreciosEsp            varchar(20),
@Unidad			varchar(50),
@ArtTipo			varchar(20),
@Precio			float,
@Renglon			float,
@RenglonID			int,
@RenglonTipo		char(1),
@Factor			float,
@Decimales			int
IF @Accion = 'AFECTAR'
BEGIN
SET @FechaEmision = dbo.fnFechaSinHora(GETDATE())
IF @ID IS NOT NULL
SELECT @AFArticulo = AFArticulo, @AFSerie = AFSerie, @Origen = Mov, @OrigenID = MovID FROM Gestion WHERE ID = @ID
SELECT
@MAFServicioTaller = NULLIF(MAFServicioTaller,''),
@MAFServicioUsuario = NULLIF(MAFServicioUsuario,''),
@MAFServicioMov = NULLIF(MAFServicioMov,''),
@MAFServicioConcepto = NULLIF(MAFServicioConcepto,''),
@MAFServicioCliente = NULLIF(MAFServicioCliente,'')
FROM EmpresaCfg2
WHERE Empresa = @Empresa
SELECT @Tipo = Tipo, @AF = ID FROM ActivoF WHERE Articulo = @AFArticulo AND Serie = @AFSerie
SELECT
@MAFServicioTaller = ISNULL(NULLIF(ServicioTallerEsp,''),@MAFServicioTaller),
@MAFServicioUsuario = ISNULL(NULLIF(ServicioUsuarioEsp,''),@MAFServicioUsuario),
@MAFServicioMov = ISNULL(NULLIF(ServicioMovEsp,''),@MAFServicioMov),
@MAFServicioConcepto = ISNULL(NULLIF(ServicioConceptoEsp,''),@MAFServicioConcepto),
@MAFServicioCliente = ISNULL(NULLIF(ServicioClienteEsp,''),@MAFServicioCliente),
@ServicioDescripcion = SUBSTRING(Descripcion,1,100)
FROM ActivoFTipoServicio
WHERE Tipo = @Tipo
AND Servicio = @Servicio
SELECT @Moneda = NULLIF(DefMoneda,'') FROM Cte WHERE Cliente = @MAFServicioCliente
SELECT @TipoCambio = TipoCambio FROM Mon WHERE Moneda = @Moneda
IF @MAFServicioTaller IS NULL AND @Ok IS NULL SELECT @Ok = 20390, @OkRef = 'Defina el Taller en la configuración de Servicios del Activo Fijo.'
IF @MAFServicioUsuario IS NULL AND @Ok IS NULL SELECT @Ok = 71010
IF @MAFServicioMov IS NULL AND @Ok IS NULL SELECT @Ok = 14055
IF @MAFServicioConcepto IS NULL AND @Ok IS NULL SELECT @Ok = 20480
IF @MAFServicioCliente IS NULL AND @Ok IS NULL SELECT @Ok = 40010
IF @Moneda IS NULL AND @Ok IS NULL SELECT @Ok = 30040
IF @Ok IS NULL
BEGIN
INSERT Venta (Empresa,  Mov,             FechaEmision,  Concepto,             Moneda,  TipoCambio,  Usuario,             Estatus,      Directo, Prioridad, Cliente,             Almacen,            FechaRequerida, Vencimiento,   ServicioTipo, ServicioArticulo, ServicioSerie, ServicioDescripcion,  ServicioFecha, Sucursal,  AF,  AFArticulo,  AFSerie,  OrigenTipo, Origen,  OrigenID,  MAFCiclo)
VALUES (@Empresa, @MAFServicioMov, @FechaEmision, @MAFServicioConcepto, @Moneda, @TipoCambio, @MAFServicioUsuario, 'SINAFECTAR', 1,       'Normal',  @MAFServicioCliente, @MAFServicioTaller, @FechaEmision,  @FechaEmision, @Servicio,    @AFArticulo,      @AFSerie,      @ServicioDescripcion, @FechaEmision, @Sucursal, @AF, @AFArticulo, @AFSerie, 'GES',      @Origen, @OrigenID, @MAFCiclo)
IF @@ERROR <> 0 SET @Ok = 1
SET @IDGenerar = SCOPE_IDENTITY()
END
IF @Ok IS NULL
BEGIN
DECLARE crServicioTipoPlantilla CURSOR FOR
SELECT stp.Articulo, stp.SubCuenta, stp.Cantidad, stp.AlmacenEsp, stp.ListaPreciosEsp, a.Unidad, a.Tipo
FROM ServicioTipoPlantilla stp JOIN Art a
ON a.Articulo = stp.Articulo
WHERE stp.Tipo = @Servicio
ORDER BY stp.Orden
SET @Renglon = 2048.0
SET @RenglonID = 1
OPEN crServicioTipoPlantilla
FETCH NEXT FROM crServicioTipoPlantilla INTO @Articulo, @SubCuenta, @Cantidad, @AlmacenEsp, @ListaPreciosEsp, @Unidad, @ArtTipo
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
EXEC spPCGet @Sucursal, @Empresa, @SubCuenta, NULL, @Unidad, @Moneda, @TipoCambio, @ListaPreciosEsp, @Precio OUTPUT
EXEC spRenglonTipo @ArtTipo, @Subcuenta, @RenglonTipo OUTPUT
EXEC spUnidadFactor @Empresa, @Articulo, @SubCuenta, @Unidad, @Factor OUTPUT, @Decimales OUTPUT
INSERT VentaD (ID,         Renglon,  RenglonSub,  RenglonID,  RenglonTipo,  Cantidad,  Unidad,  Almacen,                                           Articulo,  SubCuenta,  Precio,  FechaRequerida, Sucursal,  CantidadInventario)
VALUES (@IDGenerar, @Renglon, 0,           @RenglonID, @RenglonTipo, @Cantidad, @Unidad, ISNULL(NULLIF(@AlmacenEsp,''),@MAFServicioTaller), @Articulo, @SubCuenta, @Precio, @FechaEmision,  @Sucursal, @Cantidad * @Factor)
IF @@ERROR <> 0 SET @Ok = 1
SET @Renglon = @Renglon + 2048.0
SET @RenglonID = @RenglonID + 1
FETCH NEXT FROM crServicioTipoPlantilla INTO @Articulo, @SubCuenta, @Cantidad, @AlmacenEsp, @ListaPreciosEsp, @Unidad, @ArtTipo
END
CLOSE crServicioTipoPlantilla
DEALLOCATE crServicioTipoPlantilla
END
IF @Ok IS NULL
EXEC spAfectar 'VTAS', @IDGenerar, 'AFECTAR', 'Todo', NULL, @Usuario, NULL, 1, @Ok OUTPUT, @OkRef OUTPUT, NULL, 1, @@SPID
IF @Ok IS NULL AND @ID IS NOT NULL
BEGIN
SELECT @MovIDGenerar = MovID FROM Venta WHERE ID = @IDGenerar
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, 'GES', @ID, @Origen, @OrigenID, 'VTAS', @IDGenerar, @MAFServicioMov, @MovIDGenerar, @Ok OUTPUT
END
END ELSE
IF @Accion = 'CANCELAR'
BEGIN
SELECT
@IDGenerar = mf.DID
FROM MovFlujo mf JOIN MovTipo mt
ON mt.Mov = mf.DMov AND mt.Modulo = mf.DModulo JOIN Venta v
ON v.ID = mf.DID
WHERE mf.OID = @ID
AND mf.OModulo = 'GES'
AND mt.Modulo = 'VTAS'
AND mt.Clave = 'VTAS.S'
AND v.Estatus IN ('CONFIRMAR','PENDIENTE')
IF @IDGenerar IS NOT NULL
EXEC spAfectar 'VTAS', @IDGenerar, 'CANCELAR', 'Todo', NULL, @Usuario, NULL, 1, @Ok OUTPUT, @OkRef OUTPUT, NULL, 1, @@SPID
END
END

