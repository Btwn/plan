SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPCSet
@Sucursal	int,
@Empresa	char(5),
@Articulo	char(20),
@SubCuenta	varchar(50),
@Unidad		varchar(50),
@MovMoneda	char(10),
@MovTipoCambio	float,
@Lista		varchar(20),
@Precio		money,
@EstatusNuevo	varchar(15),
@Proveedor	varchar(10) = NULL,
@SucursalEsp	int = NULL

AS BEGIN
DECLARE
@ArtMoneda			char(10),
@ArtFactor			float,
@ArtTipoCambio		float,
@ArtPrecio			money,
@ListaMoneda		char(10),
@ListaFactor		float,
@ListaTipoCambio	float,
@ListaPrecio		money,
@Ok					int,
@PrecioNivelUnidad	bit
SELECT @PrecioNivelUnidad= PrecioNivelUnidad FROM EmpresaCfg2  WHERE Empresa=@Empresa
SELECT @SubCuenta = NULLIF(RTRIM(NULLIF(@SubCuenta, '0')), ''), @Unidad = NULLIF(RTRIM(@Unidad), '')
IF NOT EXISTS(SELECT * FROM ListaPrecios WHERE Lista = @Lista)
INSERT ListaPrecios (Lista, Moneda) VALUES (@Lista, @MovMoneda)
SELECT @ArtMoneda = CASE WHEN @Lista IN ('(Ultimo Costo)', '(Costo Promedio)', '(Costo Estandar)', '(Costo Reposicion)', '(Costo Proveedor)', '(Ultimo Costo Prov)') THEN MonedaCosto ELSE MonedaPrecio END
FROM Art
WHERE Articulo = @Articulo
EXEC spMoneda NULL, @MovMoneda, @MovTipoCambio, @ArtMoneda, @ArtFactor OUTPUT, @ArtTipoCambio OUTPUT, @Ok OUTPUT
SELECT @ArtPrecio = @Precio / @ArtFactor
IF SUBSTRING (@Lista, 1, 1) = '(' AND @SubCuenta IS NULL
BEGIN
IF @Lista = '(Precio Lista)'     UPDATE Art SET UltimoCambio = GETDATE(), PrecioLista     = @ArtPrecio, EstatusPrecio = CASE WHEN @EstatusNuevo IS NULL THEN EstatusPrecio ELSE @EstatusNuevo END, TieneMovimientos = 1 WHERE Articulo = @Articulo ELSE
IF @Lista = '(Precio 2)'         UPDATE Art SET UltimoCambio = GETDATE(), Precio2         = @ArtPrecio WHERE Articulo = @Articulo ELSE
IF @Lista = '(Precio 3)'         UPDATE Art SET UltimoCambio = GETDATE(), Precio3         = @ArtPrecio WHERE Articulo = @Articulo ELSE
IF @Lista = '(Precio 4)'         UPDATE Art SET UltimoCambio = GETDATE(), Precio4         = @ArtPrecio WHERE Articulo = @Articulo ELSE
IF @Lista = '(Precio 5)'         UPDATE Art SET UltimoCambio = GETDATE(), Precio5         = @ArtPrecio WHERE Articulo = @Articulo ELSE
IF @Lista = '(Precio 6)'         UPDATE Art SET UltimoCambio = GETDATE(), Precio6         = @ArtPrecio WHERE Articulo = @Articulo ELSE
IF @Lista = '(Precio 7)'         UPDATE Art SET UltimoCambio = GETDATE(), Precio7         = @ArtPrecio WHERE Articulo = @Articulo ELSE
IF @Lista = '(Precio 8)'         UPDATE Art SET UltimoCambio = GETDATE(), Precio8         = @ArtPrecio WHERE Articulo = @Articulo ELSE
IF @Lista = '(Precio 9)'         UPDATE Art SET UltimoCambio = GETDATE(), Precio9         = @ArtPrecio WHERE Articulo = @Articulo ELSE
IF @Lista = '(Precio 10)'        UPDATE Art SET UltimoCambio = GETDATE(), Precio10        = @ArtPrecio WHERE Articulo = @Articulo ELSE
IF @Lista = '(Precio Minimo)'    UPDATE Art SET UltimoCambio = GETDATE(), PrecioMinimo    = @ArtPrecio WHERE Articulo = @Articulo ELSE
IF @Lista = '(Incentivo)'        UPDATE Art SET UltimoCambio = GETDATE(), Incentivo       = @ArtPrecio WHERE Articulo = @Articulo
END
IF @Lista IN ('(Costo Estandar)', '(Costo Reposicion)', '(Ultimo Costo)', '(Costo Promedio)', '(Costo Proveedor)', '(Ultimo Costo Prov)')
BEGIN
IF @SubCuenta IS NULL
BEGIN
IF @Lista = '(Costo Estandar)'   UPDATE Art SET UltimoCambio = GETDATE(), CostoEstandar   = @ArtPrecio, EstatusCosto = CASE WHEN @EstatusNuevo IS NULL THEN EstatusCosto ELSE @EstatusNuevo END, TieneMovimientos = 1 WHERE Articulo = @Articulo ELSE
IF @Lista = '(Costo Reposicion)' UPDATE Art SET UltimoCambio = GETDATE(), CostoReposicion = @ArtPrecio, EstatusCosto = CASE WHEN @EstatusNuevo IS NULL THEN EstatusCosto ELSE @EstatusNuevo END, TieneMovimientos = 1 WHERE Articulo = @Articulo
ELSE
BEGIN
IF @Lista = '(Ultimo Costo)'
BEGIN
UPDATE ArtCosto SET UltimoCosto = @ArtPrecio WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Articulo = @Articulo
IF @@ROWCOUNT = 0 INSERT ArtCosto (Sucursal, Empresa, Articulo, UltimoCosto) VALUES (@Sucursal, @Empresa, @Articulo, @ArtPrecio)
END ELSE
IF @Lista = '(Costo Promedio)'
BEGIN
UPDATE ArtCosto SET CostoPromedio = @ArtPrecio WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Articulo = @Articulo
IF @@ROWCOUNT = 0 INSERT ArtCosto (Sucursal, Empresa, Articulo, CostoPromedio) VALUES (@Sucursal, @Empresa, @Articulo, @ArtPrecio)
END ELSE
IF @Lista IN ('(Costo Proveedor)', '(Ultimo Costo Prov)')
BEGIN
IF @SucursalEsp IS NULL
BEGIN
IF @Lista = '(Costo Proveedor)' AND @Proveedor IS NOT NULL
BEGIN
UPDATE ArtProv SET CostoAutorizado = @ArtPrecio WHERE Articulo = @Articulo AND SubCuenta = '' AND Proveedor = @Proveedor
IF @@ROWCOUNT = 0 INSERT ArtProv (Articulo, SubCuenta, Proveedor, CostoAutorizado) VALUES (@Articulo, '', @Proveedor, @ArtPrecio)
END ELSE
IF @Lista = '(Ultimo Costo Prov)' AND @Proveedor IS NOT NULL
BEGIN
UPDATE ArtProv SET UltimoCosto = @ArtPrecio WHERE Articulo = @Articulo AND SubCuenta = '' AND Proveedor = @Proveedor
IF @@ROWCOUNT = 0 INSERT ArtProv (Articulo, SubCuenta, Proveedor, UltimoCosto) VALUES (@Articulo, '', @Proveedor, @ArtPrecio)
END
END ELSE
BEGIN
IF @Lista = '(Costo Proveedor)' AND @Proveedor IS NOT NULL
BEGIN
UPDATE ArtProvSucursal SET CostoAutorizado = @ArtPrecio WHERE Articulo = @Articulo AND SubCuenta = '' AND Proveedor = @Proveedor AND Sucursal = @SucursalEsp
IF @@ROWCOUNT = 0 INSERT ArtProvSucursal (Articulo, SubCuenta, Proveedor, Sucursal, CostoAutorizado) VALUES (@Articulo, '', @Proveedor, @SucursalEsp, @ArtPrecio)
END ELSE
IF @Lista = '(Ultimo Costo Prov)' AND @Proveedor IS NOT NULL
BEGIN
UPDATE ArtProvSucursal SET UltimoCosto = @ArtPrecio WHERE Articulo = @Articulo AND SubCuenta = '' AND Proveedor = @Proveedor AND Sucursal = @SucursalEsp
IF @@ROWCOUNT = 0 INSERT ArtProvSucursal (Articulo, SubCuenta, Proveedor, Sucursal, UltimoCosto) VALUES (@Articulo, '', @Proveedor, @SucursalEsp, @ArtPrecio)
END
END
END
END
END ELSE
BEGIN
IF @Lista = '(Costo Estandar)'   UPDATE ArtSub SET CostoEstandar   = @ArtPrecio WHERE Articulo = @Articulo AND SubCuenta = @SubCuenta ELSE
IF @Lista = '(Costo Reposicion)' UPDATE ArtSub SET CostoReposicion = @ArtPrecio WHERE Articulo = @Articulo AND SubCuenta = @SubCuenta
ELSE
BEGIN
IF @Lista = '(Ultimo Costo)'
BEGIN
UPDATE ArtSubCosto SET UltimoCosto = @ArtPrecio WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta
IF @@ROWCOUNT = 0 INSERT ArtSubCosto (Sucursal, Empresa, Articulo, SubCuenta, UltimoCosto) VALUES (@Sucursal, @Empresa, @Articulo, @SubCuenta, @ArtPrecio)
END ELSE
IF @Lista = '(Costo Promedio)'
BEGIN
UPDATE ArtSubCosto SET CostoPromedio = @ArtPrecio WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta
IF @@ROWCOUNT = 0 INSERT ArtSubCosto (Sucursal, Empresa, Articulo, SubCuenta, CostoPromedio) VALUES (@Sucursal, @Empresa, @Articulo, @SubCuenta, @ArtPrecio)
END ELSE
IF @Lista IN ('(Costo Proveedor)', '(Ultimo Costo Prov)')
BEGIN
IF @SucursalEsp IS NULL
BEGIN
IF @Lista = '(Costo Proveedor)' AND @Proveedor IS NOT NULL
BEGIN
UPDATE ArtProv SET CostoAutorizado = @ArtPrecio WHERE Articulo = @Articulo AND SubCuenta = @SubCuenta AND Proveedor = @Proveedor
IF @@ROWCOUNT = 0 INSERT ArtProv (Articulo, SubCuenta, Proveedor, CostoAutorizado) VALUES (@Articulo, @SubCuenta, @Proveedor, @ArtPrecio)
END ELSE
IF @Lista = '(Ultimo Costo Prov)' AND @Proveedor IS NOT NULL
BEGIN
UPDATE ArtProv SET UltimoCosto = @ArtPrecio WHERE Articulo = @Articulo AND SubCuenta = @SubCuenta AND Proveedor = @Proveedor
IF @@ROWCOUNT = 0 INSERT ArtProv (Articulo, SubCuenta, Proveedor, UltimoCosto) VALUES (@Articulo, @SubCuenta, @Proveedor, @ArtPrecio)
END
END ELSE
BEGIN
IF @Lista = '(Costo Proveedor)' AND @Proveedor IS NOT NULL
BEGIN
UPDATE ArtProvSucursal SET CostoAutorizado = @ArtPrecio WHERE Articulo = @Articulo AND SubCuenta = @SubCuenta AND Proveedor = @Proveedor AND Sucursal = @SucursalEsp
IF @@ROWCOUNT = 0 INSERT ArtProvSucursal (Articulo, SubCuenta, Proveedor, Sucursal, CostoAutorizado) VALUES (@Articulo, @SubCuenta, @Proveedor, @SucursalEsp, @ArtPrecio)
END ELSE
IF @Lista = '(Ultimo Costo Prov)' AND @Proveedor IS NOT NULL
BEGIN
UPDATE ArtProvSucursal SET UltimoCosto = @ArtPrecio WHERE Articulo = @Articulo AND SubCuenta = @SubCuenta AND Proveedor = @Proveedor AND Sucursal = @SucursalEsp
IF @@ROWCOUNT = 0 INSERT ArtProvSucursal (Articulo, SubCuenta, Proveedor, Sucursal, UltimoCosto) VALUES (@Articulo, @SubCuenta, @Proveedor, @SucursalEsp, @ArtPrecio)
END
END
END
END
END
END
DECLARE crListaPrecios CURSOR
FOR SELECT Moneda
FROM ListaPrecios
WHERE Lista = @Lista
OPEN crListaPrecios
FETCH NEXT FROM crListaPrecios INTO @ListaMoneda
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spMoneda NULL, @MovMoneda, @MovTipoCambio, @ListaMoneda, @ListaFactor OUTPUT, @ListaTipoCambio OUTPUT, @Ok OUTPUT
SELECT @ListaPrecio = @Precio / @ListaFactor
IF @Unidad IS NULL OR @PrecioNivelUnidad=0
BEGIN
IF @SubCuenta IS NULL
BEGIN
UPDATE ListaPreciosD SET Precio = @ListaPrecio WHERE Lista = @Lista AND Moneda = @ListaMoneda AND Articulo = @Articulo
IF @@ROWCOUNT = 0
INSERT ListaPreciosD (Lista, Moneda, Articulo, Precio) VALUES (@Lista, @ListaMoneda, @Articulo, @ListaPrecio)
END ELSE
BEGIN
UPDATE ListaPreciosSub SET Precio = @ListaPrecio WHERE Lista = @Lista AND Moneda = @ListaMoneda AND Articulo = @Articulo AND SubCuenta = @SubCuenta
IF @@ROWCOUNT = 0
INSERT ListaPreciosSub (Lista, Moneda, Articulo, SubCuenta, Precio) VALUES (@Lista, @ListaMoneda, @Articulo, @SubCuenta, @ListaPrecio)
END
END ELSE
BEGIN
IF @SubCuenta IS NULL
BEGIN
UPDATE ListaPreciosDUnidad SET Precio = @ListaPrecio WHERE Lista = @Lista AND Moneda = @ListaMoneda AND Articulo = @Articulo AND Unidad = @Unidad
IF @@ROWCOUNT = 0
INSERT ListaPreciosDUnidad (Lista, Moneda, Articulo, Unidad, Precio) VALUES (@Lista, @ListaMoneda, @Articulo, @Unidad, @ListaPrecio)
UPDATE ListaPreciosD SET Precio = NULL WHERE Lista = @Lista AND Moneda = @ListaMoneda AND Articulo = @Articulo
IF @@ROWCOUNT = 0
INSERT ListaPreciosD (Lista, Moneda, Articulo) VALUES (@Lista, @ListaMoneda, @Articulo)
END ELSE
BEGIN
UPDATE ListaPreciosSubUnidad SET Precio = @ListaPrecio WHERE Lista = @Lista AND Moneda = @ListaMoneda AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Unidad = @Unidad
IF @@ROWCOUNT = 0
INSERT ListaPreciosSubUnidad (Lista, Moneda, Articulo, SubCuenta, Unidad, Precio) VALUES (@Lista, @ListaMoneda, @Articulo, @SubCuenta, @Unidad, @ListaPrecio)
UPDATE ListaPreciosD SET Precio = NULL WHERE Lista = @Lista AND Moneda = @ListaMoneda AND Articulo = @Articulo
IF @@ROWCOUNT = 0
INSERT ListaPreciosD (Lista, Moneda, Articulo) VALUES (@Lista, @ListaMoneda, @Articulo)
UPDATE ListaPreciosSub SET Precio = null WHERE Lista = @Lista AND Moneda = @ListaMoneda AND Articulo = @Articulo AND SubCuenta = @SubCuenta
IF @@ROWCOUNT = 0
INSERT ListaPreciosSub (Lista, Moneda, Articulo, SubCuenta) VALUES (@Lista, @ListaMoneda, @Articulo, @SubCuenta)
END
END
END
FETCH NEXT FROM crListaPrecios INTO @ListaMoneda
END  
CLOSE crListaPrecios
DEALLOCATE crListaPrecios
END

