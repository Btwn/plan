SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSeriesLotesMayoreoDisminuir
@Sucursal			int,
@SucursalAlmacen		int,
@SucursalAlmacenDestino	int,
@Empresa			char(5),
@Accion			char(20),
@Almacen			char(10),
@AlmacenDestino		char(10),
@Articulo                    char(20),
@SubCuentaNull		varchar(50),
@SubCuenta			varchar(50),
@ArtTipo			char(20),
@SerieLote			varchar(50),
@Propiedades			char(20),
@Cliente			varchar(10),
@Localizacion		varchar(10),
@Cantidad			float,
@EsSalida			bit,
@EsTransferencia		bit,
@AlmacenTipo			char(20),
@FechaEmision		datetime,
@Ok 				int		OUTPUT,
@AlmacenTarima		varchar(20)	= '',
@AlmacenDestinoTarima	varchar(20)	= '',
@MovTipo					varchar(20)

AS BEGIN
DECLARE
@CantidadAlterna	   	float,
@Existencia  	   	float,
@ExistenciaActivoFijo  	float,
@CostoPromedio	   	float,
@UltimaEntrada		datetime,
@UltimaSalida		datetime
EXEC spExtraerFecha @FechaEmision OUTPUT
SELECT @Existencia = 0
SELECT @Existencia = ISNULL(Existencia, 0)
FROM SerieLote
WHERE Sucursal = @SucursalAlmacen AND Empresa = @Empresa AND Articulo = @Articulo AND Tarima = @AlmacenTarima AND SubCuenta = @SubCuenta AND Almacen = @Almacen AND SerieLote = @SerieLote
IF @MovTipo = 'INV.T'
SET @AlmacenDestinoTarima = ''
IF @Existencia <= @Cantidad AND @MovTipo IN ('VTAS.N','VTAS.FM') AND (SELECT NotasBorrador FROM EmpresaCFG WHERE Empresa = @Empresa) = 1
BEGIN
SELECT @Ok = NULL
SELECT @CostoPromedio = AVG(CostoPromedio)
FROM SerieLote
WHERE Sucursal = @SucursalAlmacen AND Empresa = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND SerieLote = @SerieLote AND Almacen = @Almacen AND Tarima = @AlmacenTarima
UPDATE SerieLote
SET Existencia        = NULLIF(ROUND(Existencia - @Cantidad, 8), 0.0),
@CantidadAlterna  = (@Cantidad * ExistenciaAlterna / Existencia),
ExistenciaAlterna = NULLIF(ExistenciaAlterna - (@Cantidad * ExistenciaAlterna / Existencia), 0.0),
UltimaSalida      = CASE WHEN @EsSalida = 1 THEN @FechaEmision ELSE UltimaSalida END
WHERE Sucursal = @SucursalAlmacen AND Empresa = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Almacen = @Almacen AND Tarima = @AlmacenTarima AND SerieLote = @SerieLote
IF @@ROWCOUNT = 0
IF NOT EXISTS (SELECT SerieLote FROM SerieLote WHERE Sucursal = @SucursalAlmacen AND Empresa = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Almacen = @Almacen AND Tarima = @AlmacenTarima AND SerieLote = @SerieLote)
INSERT SerieLote (Sucursal,                Empresa,  Articulo,  SubCuenta,  Almacen,         Tarima,                SerieLote,  Propiedades,  Cliente, Localizacion,  Existencia,  ExistenciaAlterna, CostoPromedio,  UltimaEntrada, UltimaSalida)
VALUES (@SucursalAlmacen, @Empresa, @Articulo, @SubCuenta, @Almacen, @AlmacenTarima, @SerieLote, @Propiedades, @Cliente, @Localizacion, -@Cantidad,  -@CantidadAlterna,  @CostoPromedio, @UltimaEntrada, @UltimaSalida)
END ELSE
BEGIN
IF @AlmacenTipo = 'ACTIVOS FIJOS'
BEGIN
UPDATE SerieLote
SET ExistenciaActivoFijo = NULLIF(ISNULL(ExistenciaActivoFijo, 0.0) - @Cantidad, 0.0),
UltimaSalida = CASE WHEN @EsSalida = 1 THEN @FechaEmision ELSE UltimaSalida END
WHERE Sucursal = @SucursalAlmacen AND Empresa = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Almacen = @Almacen AND Tarima = @AlmacenTarima AND SerieLote = @SerieLote AND ISNULL(ExistenciaActivoFijo, 0) > 0
END
IF @AlmacenTipo <> 'ACTIVOS FIJOS'
BEGIN
IF EXISTS(SELECT * FROM SerieLote WHERE Sucursal = @SucursalAlmacen AND Empresa = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Almacen = @Almacen AND Tarima = @AlmacenTarima AND SerieLote = @SerieLote AND Existencia > 0)
BEGIN
UPDATE SerieLote
SET Existencia        = NULLIF(ROUND(Existencia - @Cantidad, 8), 0.0),
@CantidadAlterna  = (@Cantidad * ExistenciaAlterna / Existencia),
ExistenciaAlterna = NULLIF(ExistenciaAlterna - (@Cantidad * ExistenciaAlterna / Existencia), 0.0),
UltimaSalida      = CASE WHEN @EsSalida = 1 THEN @FechaEmision ELSE UltimaSalida END
WHERE Sucursal = @SucursalAlmacen AND Empresa = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Almacen = @Almacen AND Tarima = @AlmacenTarima AND SerieLote = @SerieLote AND Existencia > 0
IF @@ROWCOUNT = 0 SELECT @Ok = 20090
END
END
SELECT @Existencia = 0, @ExistenciaActivoFijo = 0
SELECT @ExistenciaActivoFijo = ISNULL(ExistenciaActivoFijo, 0),
@Existencia = ISNULL(Existencia, 0),
@UltimaEntrada = UltimaEntrada,
@UltimaSalida	= UltimaSalida
FROM SerieLote
WHERE Sucursal = @SucursalAlmacen AND Empresa = @Empresa AND Articulo = @Articulo AND Tarima = @AlmacenTarima AND SubCuenta = @SubCuenta AND Almacen = @Almacen AND SerieLote = @SerieLote
IF @Existencia < 0 OR @ExistenciaActivoFijo < 0 SELECT @Ok = 20510
IF @Existencia < 0 AND (SELECT NotasBorrador FROM EmpresaCFG WHERE Empresa = @Empresa) = 1
SELECT @Ok = NULL
IF @ArtTipo = 'PARTIDA' AND @Existencia > 0 AND @Cantidad > 0 AND @Accion <> 'CANCELAR' AND @Ok IS NULL SELECT @Ok = 20580
IF @EsTransferencia = 1 AND @Ok IS NULL
BEGIN
IF @AlmacenTipo = 'ACTIVOS FIJOS'
UPDATE SerieLote
SET ExistenciaActivoFijo = ISNULL(ExistenciaActivoFijo, 0.0) + @Cantidad
WHERE Sucursal = @SucursalAlmacenDestino AND Empresa = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND SerieLote = @SerieLote AND Almacen = @AlmacenDestino AND Tarima = @AlmacenDestinoTarima
ELSE
UPDATE SerieLote
SET Existencia = ISNULL(Existencia, 0.0) + @Cantidad,
ExistenciaAlterna = NULLIF(ISNULL(ExistenciaAlterna, 0.0) + @CantidadAlterna, 0.0)
WHERE Sucursal = @SucursalAlmacenDestino AND Empresa = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND SerieLote = @SerieLote AND Almacen = @AlmacenDestino AND Tarima = @AlmacenDestinoTarima
IF @@ROWCOUNT = 0
BEGIN
SELECT @CostoPromedio = AVG(CostoPromedio)
FROM SerieLote
WHERE Sucursal = @SucursalAlmacen AND Empresa = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND SerieLote = @SerieLote AND Almacen = @Almacen AND Tarima = @AlmacenTarima
IF @AlmacenTipo = 'ACTIVOS FIJOS'
INSERT SerieLote (Sucursal,                Empresa,  Articulo,  SubCuenta,  Almacen,         Tarima,                SerieLote,  Propiedades,  Cliente,  Localizacion,  ExistenciaActivoFijo, CostoPromedio,  UltimaEntrada, UltimaSalida)
VALUES (@SucursalAlmacenDestino, @Empresa, @Articulo, @SubCuenta, @AlmacenDestino, @AlmacenDestinoTarima, @SerieLote, @Propiedades, @Cliente, @Localizacion, @Cantidad,            @CostoPromedio, @UltimaEntrada, @UltimaSalida)
ELSE
INSERT SerieLote (Sucursal,                Empresa,  Articulo,  SubCuenta,  Almacen,         Tarima,                SerieLote,  Propiedades,  Cliente, Localizacion,  Existencia,  ExistenciaAlterna, CostoPromedio,  UltimaEntrada, UltimaSalida)
VALUES (@SucursalAlmacenDestino, @Empresa, @Articulo, @SubCuenta, @AlmacenDestino, @AlmacenDestinoTarima, @SerieLote, @Propiedades, @Cliente, @Localizacion, @Cantidad,  @CantidadAlterna,  @CostoPromedio, @UltimaEntrada, @UltimaSalida)
END
SELECT @Existencia = 0, @ExistenciaActivoFijo = 0
SELECT @ExistenciaActivoFijo = ISNULL(ExistenciaActivoFijo, 0), @Existencia = ISNULL(Existencia, 0)
FROM SerieLote
WHERE Sucursal = @SucursalAlmacenDestino AND Empresa = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Almacen = @AlmacenDestino AND Tarima = @AlmacenDestinoTarima AND SerieLote = @SerieLote
IF @Existencia < 0 OR @ExistenciaActivoFijo < 0 SELECT @Ok = 20510
END
END
RETURN
END

