SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTransferirLoteGenerar
@Estacion	int,
@Empresa	char(5),
@Articulo	char(20),
@SubCuenta	varchar(20),
@Almacen	char(10),
@Usuario	char(10),
@FechaEmision	datetime

AS BEGIN
DECLARE
@Sucursal			int,
@ID				int,
@Mov			char(20),
@Destino			char(10),
@Lotes			int,
@Consecutivo		int,
@Referencia			varchar(50),
@Moneda			char(10),
@TipoCambio			float,
@Cantidad			float,
@Unidad			varchar(50),
@Conteo			int,
@Ok				int,
@OkRef			varchar(255),
@CfgSeriesLotesAutoOrden	varchar(20),
@SeriesLotesAutoOrden	varchar(20)
SELECT @Conteo = 0, @Ok = NULL, @OkRef = NULL
SELECT @CfgSeriesLotesAutoOrden    = ISNULL(UPPER(RTRIM(SeriesLotesAutoOrden)), 'NO')
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @SeriesLotesAutoOrden = ISNULL(NULLIF(NULLIF(RTRIM(UPPER(SeriesLotesAutoOrden)), ''), '(EMPRESA)'), @CfgSeriesLotesAutoOrden)
FROM Art
WHERE Articulo = @Articulo
SELECT @SubCuenta = ISNULL(NULLIF(RTRIM(@SubCuenta), '0'), '')
SELECT @Unidad = Unidad FROM Art WHERE Articulo = @Articulo
SELECT @Mov = InvTransferencia FROM EmpresaCfgMov WHERE Empresa = @Empresa
SELECT @Sucursal = Sucursal FROM Alm WHERE Almacen = @Almacen
SELECT @Moneda = m.Moneda, @TipoCambio = m.TipoCambio
FROM EmpresaCfg cfg, Mon m
WHERE cfg.Empresa = @Empresa AND m.Moneda = cfg.ContMoneda
EXEC spConsecutivo 'Transferir Lotes', @Sucursal, @Consecutivo OUTPUT
SELECT @Referencia = CONVERT(varchar, @Consecutivo)
DECLARE crTransferirLote CURSOR
FOR SELECT Almacen, Cantidad
FROM TransferirLote
WHERE Estacion = @Estacion AND ISNULL(Cantidad, 0) > 0
OPEN crTransferirLote
FETCH NEXT FROM crTransferirLote INTO @Destino, @Lotes
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
INSERT Inv (UltimoCambio, Sucursal,  Empresa, Usuario,    Estatus,     Mov,  FechaEmision,  Almacen,  AlmacenDestino, Moneda,  TipoCambio,  Referencia, RenglonID)
SELECT GETDATE(),     @Sucursal, @Empresa, @Usuario, 'SINAFECTAR', @Mov, @FechaEmision, @Almacen, @Destino,       @Moneda, @TipoCambio, @Referencia, 1
SELECT @ID = SCOPE_IDENTITY()
INSERT SerieLoteMov (Empresa, Sucursal, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad)
SELECT @Empresa, @Sucursal, 'INV', @ID, 1, @Articulo, @SubCuenta, SerieLote, Existencia
FROM SerieLote
WHERE Empresa = @Empresa AND Almacen = @Almacen AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND SerieLote IN (SELECT SerieLote FROM dbo.fnCantidadLote(@Empresa, @Almacen, @Articulo, @SubCuenta, @Lotes, @SeriesLotesAutoOrden))
SELECT @Cantidad = SUM(Cantidad) FROM SerieLoteMov WHERE Empresa = @Empresa AND Modulo = 'INV' AND ID = @ID AND RenglonID = 1 AND Articulo = @Articulo
INSERT InvD (Sucursal,  ID,  Renglon, RenglonSub, RenglonID, Articulo,  SubCuenta,  Cantidad,  CantidadInventario,  Unidad, Almacen)
SELECT @Sucursal, @ID,  2048.0, 0,          1,         @Articulo, @SubCuenta, @Cantidad, @Cantidad,           @Unidad, @Almacen
EXEC spAfectar 'INV', @ID, @Usuario = @Usuario, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
UPDATE CB
SET Referencia = @Referencia
WHERE TipoCuenta = 'Articulos' AND Cuenta = @Articulo AND SerieLote IN (SELECT SerieLote FROM SerieLoteMov WHERE Empresa = @Empresa AND Modulo = 'INV' AND ID = @ID)
SELECT @Conteo = @Conteo + 1
END
FETCH NEXT FROM crTransferirLote INTO @Destino, @Lotes
END  
CLOSE crTransferirLote
DEALLOCATE crTransferirLote
IF @Ok IS NULL
SELECT 'Se Generaron '+LTRIM(CONVERT(char, @Conteo))+' '+RTRIM(@Mov)
ELSE
SELECT Descripcion+' '+ISNULL(RTRIM(@OkRef), '') FROM MensajeLista WHERE Mensaje = @Ok
RETURN
END

