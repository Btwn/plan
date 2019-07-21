SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spTMAArtDomicilioInicializarOpcion
@Empresa		varchar(5),
@Almacen		varchar(10),
@Articulo		varchar(20),
@SubCuenta		varchar(20)

AS
BEGIN
DECLARE @Posicion		varchar(10),
@PosicionAnt	varchar(10),
@Tarima		varchar(20),
@TarimaAnt	varchar(20),
@Moneda		varchar(10),
@Sucursal		int,
@FechaEmision	datetime,
@Ok			int,
@OkRef		varchar(255),
@WMSAuxiliar	bit 
SELECT @FechaEmision = GETDATE()
EXEC spExtraerFecha @FechaEmision OUTPUT
SELECT @Sucursal = Sucursal FROM Alm WHERE Almacen = @Almacen
SELECT @SubCuenta = ISNULL(@SubCuenta, '')
SELECT @Moneda = MonedaCosto FROM Art WHERE Articulo = @Articulo
SELECT @PosicionAnt = ''
SELECT @WMSAuxiliar = WMSAuxiliar FROM Version 
WHILE(1=1)
BEGIN
SELECT @Posicion = MIN(Posicion)
FROM AlmPos
WHERE Almacen = @Almacen
AND Posicion > @PosicionAnt
AND ArticuloEsp = @Articulo
AND Tipo = 'Domicilio'
AND SubCuenta=@SubCuenta
IF @Posicion IS NULL BREAK
SELECT @PosicionAnt = @Posicion
IF NOT EXISTS(SELECT * FROM Tarima WHERE Posicion = @Posicion)
BEGIN
SELECT @Ok = NULL, @OkRef = NULL, @Tarima = NULL
EXEC spConsecutivo 'Tarima', @Sucursal, @Tarima OUTPUT
EXEC spTarimaAlta @Empresa, @Sucursal, '', @Almacen, @FechaEmision, @FechaEmision, @Tarima, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
UPDATE Tarima SET Posicion = @Posicion, SubCuenta=@SubCuenta WHERE Tarima = @Tarima 
END
SELECT @TarimaAnt = ''
WHILE(1=1)
BEGIN
SELECT @Tarima = MIN(Tarima)
FROM Tarima
WHERE Almacen = @Almacen
AND Posicion = @Posicion
AND Tarima > @TarimaAnt
AND Estatus = 'ALTA'
IF @Tarima IS NULL BREAK
SELECT @TarimaAnt = @Tarima
IF NOT EXISTS(SELECT * FROM ArtDisponibleTarima WHERE Tarima = @Tarima AND Almacen = @Almacen AND Empresa = @Empresa AND Articulo <> @Articulo)
IF NOT EXISTS(SELECT Grupo FROM SaldoUGral WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Grupo = @Almacen AND Cuenta = @Articulo AND SubCuenta = @SubCuenta AND Rama IN('INV','WMS') AND Moneda = @Moneda AND SubGrupo = @Tarima)
BEGIN
IF @WMSAuxiliar = 1 
BEGIN 
INSERT INTO SaldoUWMS(
Sucursal,  Empresa, Rama,   Moneda,  Grupo,    SubGrupo,  Cuenta,    SubCuenta, Saldo, SaldoU, PorConciliar, PorConciliarU, UltimoCambio)
SELECT @Sucursal, @Empresa, 'WMS', @Moneda, @Almacen, @Tarima,   @Articulo, @SubCuenta, 0,     0,      0,            0,             GETDATE()
END ELSE BEGIN 
EXEC dbo.sp_executesql N'INSERT INTO SaldoU(
Sucursal,  Empresa, Rama,   Moneda,  Grupo,    SubGrupo,  Cuenta,    SubCuenta, Saldo, SaldoU, PorConciliar, PorConciliarU, UltimoCambio)
SELECT @Sucursal, @Empresa, ''INV'', @Moneda, @Almacen, @Tarima,  @Articulo, @SubCuenta, 0,     0,      0,            0,             GETDATE()',
N'@Sucursal int, @Empresa varchar(5), @Moneda varchar(20), @Almacen varchar(20), @Tarima varchar(20), @Articulo varchar(20), @SubCuenta varchar(50)',
@Sucursal, @Empresa, @Moneda, @Almacen, @Tarima, @Articulo, @SubCuenta
END 
END
END
END
RETURN
END

