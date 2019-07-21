SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSerieLoteTransferir
@Empresa	char(5),
@Sucursal	int,
@Usuario	char(10),
@FechaEmision	datetime,
@Articulo	char(20),
@Almacen	char(10),
@AlmacenDestino	char(10)

AS BEGIN
DECLARE
@ID				int,
@Mov			char(20),
@MovID			varchar(20),
@Moneda			char(10),
@TipoCambio			float,
@AlmacenSucursal		int,
@AlmacenDestinoSucursal	int,
@CfgMultiUnidades		bit,
@CfgMultiUnidadesNivel	char(20),
@Renglon			float,
@RenglonID			int,
@RenglonTipo		char(1),
@SubCuenta			varchar(20),
@Cantidad			float,
@CantidadInventario		float,
@ArtTipo			varchar(20),
@Unidad			varchar(50),
@FechaRegistro		datetime,
@Ok				int,
@OkRef			varchar(255)
SELECT @AlmacenSucursal = NULL, @AlmacenDestinoSucursal = NULL, @Ok = NULL, @OkRef = NULL,
@Articulo = NULLIF(NULLIF(RTRIM(@Articulo), '0'), '')
SELECT @AlmacenSucursal = Sucursal FROM Alm WHERE Almacen = @Almacen
SELECT @AlmacenDestinoSucursal = Sucursal FROM Alm WHERE Almacen = @AlmacenDestino
IF (@Almacen = @AlmacenDestino) OR @AlmacenSucursal IS NULL OR @AlmacenDestinoSucursal IS NULL RETURN
SELECT @Moneda = m.Moneda, @TipoCambio = m.TipoCambio
FROM EmpresaCfg cfg, Mon m
WHERE Empresa = @Empresa AND m.Moneda = cfg.ContMoneda
SELECT @CfgMultiUnidades      = MultiUnidades,
@CfgMultiUnidadesNivel = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD')
FROM EmpresaCfg2
WHERE Empresa = @Empresa
SELECT @Mov = CASE WHEN @AlmacenSucursal = @AlmacenDestinoSucursal THEN InvTransferencia ELSE InvSalidaTraspaso END
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
INSERT Inv (Sucursal,         Empresa,  Usuario,  Estatus,      Mov,  FechaEmision,  Moneda,  TipoCambio,  Almacen,  AlmacenDestino)
SELECT      @AlmacenSucursal, @Empresa, @Usuario, 'SINAFECTAR', @Mov, @FechaEmision, @Moneda, @TipoCambio, @Almacen, @AlmacenDestino
SELECT @ID = SCOPE_IDENTITY(), @Renglon = 0.0, @RenglonID = 0
DECLARE crSerieLoteEstatus CURSOR FOR
SELECT Articulo, SubCuenta, SUM(Existencia)
FROM SerieLoteEstatus
WHERE Empresa = @Empresa AND Estatus IN ('APROBADO', 'AUTORIZADO') AND Articulo = ISNULL(@Articulo, Articulo) AND Almacen=@Almacen
GROUP BY Articulo, SubCuenta
ORDER BY Articulo, SubCuenta
OPEN crSerieLoteEstatus
FETCH NEXT FROM crSerieLoteEstatus INTO @Articulo, @SubCuenta, @Cantidad
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2 AND ISNULL(@Cantidad, 0) > 0
BEGIN
SELECT @ArtTipo = Tipo, @Unidad = ISNULL(UnidadTraspaso, Unidad) FROM Art WHERE Articulo = @Articulo
EXEC spRenglonTipo @ArtTipo, @SubCuenta, @RenglonTipo OUTPUT
EXEC xpCantidadInventario @Articulo, @SubCuenta, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
SELECT @Renglon = @Renglon + 2048.0, @RenglonID = @RenglonID + 1
INSERT InvD (Sucursal,         ID,  Renglon,  RenglonID,  RenglonTipo,  Articulo,  SubCuenta,  Almacen,  Cantidad,  Unidad,  CantidadInventario)
VALUES (@AlmacenSucursal, @ID, @Renglon, @RenglonID, @RenglonTipo, @Articulo, @SubCuenta, @Almacen, @Cantidad, @Unidad, @CantidadInventario)
INSERT SerieLoteMov
(Empresa, Modulo, ID,  RenglonID,  Articulo,  SubCuenta,              SerieLote, Cantidad,   CantidadAlterna)
SELECT @Empresa, 'INV',  @ID, @RenglonID, @Articulo, ISNULL(@SubCuenta, ''), SerieLote, Existencia, ExistenciaAlterna
FROM SerieLoteEstatus
WHERE Empresa = @Empresa AND Estatus IN ('APROBADO', 'AUTORIZADO') AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') AND Almacen=@Almacen
END
FETCH NEXT FROM crSerieLoteEstatus INTO @Articulo, @SubCuenta, @Cantidad
END
CLOSE crSerieLoteEstatus
DEALLOCATE crSerieLoteEstatus
IF EXISTS(SELECT * FROM InvD WHERE ID = @ID)
BEGIN
SELECT @FechaRegistro = GETDATE()
EXEC spInv @ID, 'INV', 'AFECTAR', 'TODO', @FechaRegistro, @Mov, @Usuario, 0, 0, NULL,
@Mov, @MovID OUTPUT, NULL, NULL, @Ok OUTPUT, @OkRef OUTPUT, NULL
IF @Ok IS NULL
SELECT 'Se Generaro con Exito '+RTRIM(@Mov)+' '+RTRIM(@MovID)
ELSE
SELECT RTRIM(Descripcion)+' '+RTRIM(@OkRef) FROM MensajeLista WHERE Mensaje = @Ok
END ELSE
BEGIN
DELETE Inv WHERE ID = @ID
SELECT 'No Hay Nada Que Transferir'
END
RETURN
END

