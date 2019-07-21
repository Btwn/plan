SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvAjusteSaldosMenores
@Empresa	char(5),
@SucursalOrigen	int,
@Usuario	char(10),
@FechaEmision	datetime

AS BEGIN
DECLARE
@CfgMultiUnidades		bit,
@CfgMultiUnidadesNivel	char(20),
@Sucursal			int,
@InvID			int,
@Moneda			char(10),
@TipoCambio			float,
@Ajuste			float,
@Almacen			char(10),
@UltAlmacen			char(10),
@Articulo			char(20),
@SubCuenta			varchar(50),
@ArtTipo			varchar(20),
@Unidad			varchar(50),
@Cantidad			float,
@CantidadInventario		float,
@InvMov			varchar(20),
@Renglon			float,
@RenglonID			int,
@RenglonTipo		char(1),
@Conteo			int,
@Ok				int,
@OkRef			varchar(255)
SELECT @UltAlmacen = NULL, @Ok = NULL, @OkRef = NULL, @Conteo = 0, @InvID = NULL
EXEC spExtraerFecha @FechaEmision OUTPUT
SELECT @Moneda = m.Moneda, @TipoCambio = m.TipoCambio
FROM EmpresaCfg cfg WITH(NOLOCK), Mon m WITH(NOLOCK)
WHERE m.Moneda = cfg.ContMoneda AND cfg.Empresa = @Empresa
SELECT @CfgMultiUnidades       = MultiUnidades,
@CfgMultiUnidadesNivel  = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD'),
@Ajuste = ABS(ISNULL(InvAjusteSaldosMenores, 0.0))
FROM EmpresaCfg2 WITH(NOLOCK)
WHERE Empresa = @Empresa
SELECT @InvMov = InvAjusteSaldosMenores
FROM EmpresaCfgMov WITH(NOLOCK)
WHERE Empresa = @Empresa
BEGIN TRANSACTION
DECLARE crSaldoU CURSOR FOR
SELECT s.Grupo, s.Cuenta, s.SubCuenta, -s.SaldoU, a.Tipo, a.Unidad
FROM SaldoU s WITH(NOLOCK)
JOIN Art a WITH(NOLOCK) ON a.Articulo = s.Cuenta
WHERE s.Empresa = @Empresa AND s.Rama = 'INV' AND ABS(s.SaldoU) > 0 AND ABS(s.SaldoU) <= @Ajuste
ORDER BY s.Grupo, s.Cuenta, s.SubCuenta
OPEN crSaldoU
FETCH NEXT FROM crSaldoU INTO @Almacen, @Articulo, @SubCuenta, @Cantidad, @ArtTipo, @Unidad
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF @Almacen <> @UltAlmacen
BEGIN
IF @InvID IS NOT NULL UPDATE Inv WITH(ROWLOCK) SET RenglonID = @RenglonID WHERE ID = @InvID
IF @Ok IS NULL
BEGIN
SELECT @Sucursal = @SucursalOrigen
SELECT @Sucursal = ISNULL(Sucursal, @SucursalOrigen) FROM Alm WITH(NOLOCK) WHERE Almacen = @Almacen
INSERT Inv (Sucursal, SucursalOrigen,  Empresa,  Usuario,  Estatus,     Mov,     FechaEmision,  FechaRequerida, Almacen,  Moneda,  TipoCambio)
SELECT @Sucursal, @SucursalOrigen, @Empresa, @Usuario, 'CONFIRMAR', @InvMov, @FechaEmision, @FechaEmision,  @Almacen, @Moneda, @TipoCambio
SELECT @InvID = SCOPE_IDENTITY()
SELECT @Renglon = 0.0, @RenglonID = 0, @Conteo = @Conteo + 1
END
END
IF @Ok IS NULL AND @InvID IS NOT NULL
BEGIN
EXEC spRenglonTipo @ArtTipo, @SubCuenta, @RenglonTipo OUTPUT
EXEC xpCantidadInventario @Articulo, @SubCuenta, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
SELECT @Renglon = @Renglon + 2048.0, @RenglonID = @RenglonID + 1
INSERT InvD (ID,     Renglon,  RenglonSub,  RenglonID,  RenglonTipo,  Almacen,  Articulo,  SubCuenta,  Cantidad,  Unidad,  CantidadInventario)
VALUES (@InvID, @Renglon, 0,           @RenglonID, @RenglonTipo, @Almacen, @Articulo, @SubCuenta, @Cantidad, @Unidad, @CantidadInventario)
END
END
FETCH NEXT FROM crSaldoU INTO @Almacen, @Articulo, @SubCuenta, @Cantidad, @ArtTipo, @Unidad
END 
CLOSE crSaldoU
DEALLOCATE crSaldoU
IF @InvID IS NOT NULL UPDATE Inv WITH(ROWLOCK) SET RenglonID = @RenglonID WHERE ID = @InvID
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
SELECT 'Se Generaron '+LTRIM(CONVERT(char, @Conteo))+ ' '+@InvMov+' (por Confirmar)'
END ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT Descripcion+' '+ISNULL(RTRIM(@OkRef), '') FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
END
RETURN
END

