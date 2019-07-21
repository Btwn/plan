SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spMESSaldoInicial
@Empresa	varchar ( 5)
AS
BEGIN
DECLARE
@Articulo	varchar(20),
@SubCuenta  varchar(50),
@Almacen    varchar(10),
@Sucursal	int,
@ArtCosto	float,
@Fecha		datetime
IF NOT EXISTS (SELECT * FROM SaldoInicialMes)
BEGIN
SELECT @Fecha = GETDATE()
INSERT INTO SaldoInicialMes (Articulo,   Subcuenta,			Almacen,	Lote, Cantidad,
Moneda,	 EstatusIntelIMES,	Sucursal,	Unidad)
SELECT						 a.Articulo, u.SubCuenta,		u.Grupo,	'',   SUM(ISNULL(u.CargoU, 0)-ISNULL(u.AbonoU, 0)),
m.Moneda,	 0,					u.Sucursal, a.Unidad
FROM AuxiliarU u
JOIN Art a				ON u.Cuenta = a.Articulo
JOIN MonMes m				ON u.Moneda = m.Descripcion
JOIN ArtCostoEmpresa ac	ON ac.Empresa = @Empresa AND a.Articulo = ac.Articulo
WHERE u.Rama			= 'INV'
AND a.TipoArticulo	IS NOT NULL
AND u.Empresa		= @Empresa
GROUP BY a.Articulo, u.SubCuenta, u.Grupo, m.Moneda, u.Sucursal, a.Unidad
HAVING SUM(ISNULL(u.CargoU, 0)-ISNULL(u.AbonoU, 0)) > 0
DECLARE crActualizaCosto CURSOR FOR
SELECT Articulo, SubCuenta, Almacen, Sucursal FROM SaldoInicialMes
OPEN crActualizaCosto
FETCH NEXT FROM crActualizaCosto INTO @Articulo, @SubCuenta, @Almacen, @Sucursal
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @ArtCosto = CostoPromedio FROM ArtCosto WHERE Articulo = @Articulo AND Sucursal = @Sucursal AND Empresa = @Empresa
UPDATE SaldoInicialMes SET Costo	= @ArtCosto, FechaProcesado = @Fecha
WHERE Articulo = @Articulo
AND SubCuenta = @SubCuenta
AND Almacen = @Almacen
END
FETCH NEXT FROM crActualizaCosto INTO @Articulo, @SubCuenta, @Almacen, @Sucursal
END
CLOSE crActualizaCosto
DEALLOCATE crActualizaCosto
END
SELECT 'Proceso Concluido'
RETURN
END

