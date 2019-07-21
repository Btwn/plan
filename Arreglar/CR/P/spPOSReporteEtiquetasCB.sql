SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSReporteEtiquetasCB
@Estacion     int,
@Empresa      varchar(5),
@Sucursal     int

AS
BEGIN
DECLARE
@Codigo               varchar(30),
@Articulo             varchar(20),
@ListaPrecios         varchar(20),
@Precio               float,
@Descuento            float,
@Descripcion1         varchar(100),
@NombreCorto          varchar(20),
@CantidadE            int,
@Cantidad             int,
@SubCuenta            varchar(50),
@Unidad               varchar(50),
@Moneda               varchar(10),
@Impuesto1            float,
@Impuesto2            float,
@Impuesto3            float,
@Fecha                datetime,
@cfgImpuestoIncluido  bit,
@ImpuestoIncluido     bit
DECLARE @Tabla table(
ID        int identity,
Articulo  varchar(20),
Descripcion varchar(100),
Precio     float,
Codigo     varchar(30))
SELECT @Fecha = GETDATE()
SELECT @ListaPrecios = ListaPreciosEsp
FROM Sucursal
WHERE Sucursal = @Sucursal
SELECT @cfgImpuestoIncluido = ISNULL(VentaPreciosImpuestoIncluido,0)
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @ImpuestoIncluido = ISNULL(ImpuestoIncluido,0)
FROM POSCfg
WHERE Empresa = @Empresa
SELECT @Moneda = Moneda
FROM POSLTipoCambioRef m
WHERE TipoCambio = 1 AND Sucursal = @Sucursal AND EsPrincipal = 1
DECLARE crLista CURSOR local FOR
SELECT p.Codigo, p.Articulo , p.SubCuenta, p.Cantidad, a.Descripcion1, ISNULL(c.Unidad,a.Unidad)
FROM POSArtCBTemp p JOIN Art a ON p.Articulo = a.Articulo
JOIN CB c ON c.Codigo = p.Codigo
WHERE p.Estacion = @Estacion AND p.Cantidad >0
OPEN crLista
FETCH NEXT FROM crLista INTO @Codigo, @Articulo,  @SubCuenta, @Cantidad, @Descripcion1, @Unidad
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Impuesto1 = a.Impuesto1, @Impuesto2 = a.Impuesto2, @Impuesto3 = a.Impuesto3 FROM Art a
EXEC spTipoImpuesto 'VTAS', 0, NULL, @Fecha, @Empresa, @Sucursal, NULL, NULL, @Articulo = @Articulo, @EnSilencio = 1,
@Impuesto1 = @Impuesto1 OUTPUT, @Impuesto2 = @Impuesto2 OUTPUT, @Impuesto3 = @Impuesto3 OUTPUT
EXEC spArtPrecio @Articulo = @Articulo, @Cantidad = 1, @UnidadVenta = @Unidad,
@Precio = @Precio OUTPUT, @Descuento = @Descuento OUTPUT, @SubCuenta = @SubCuenta, @Moneda = @Moneda, @TipoCambio = 1,
@Empresa = @Empresa, @Sucursal = @Sucursal,@ListaPreciosEsp = @ListaPrecios
SELECT @Precio = CASE WHEN @cfgImpuestoIncluido = 0 AND @ImpuestoIncluido = 1
THEN  dbo.fnPOSPrecioConImpuestos(@Precio,@Impuesto1, @Impuesto2, @Impuesto3, @Empresa)
WHEN @cfgImpuestoIncluido = 1 AND @ImpuestoIncluido = 0
THEN dbo.fnPOSPrecioSinImpuestos(@Precio,@Impuesto1, @Impuesto2, @Impuesto3)
ELSE @Precio
END
SET @CantidadE = 0
WHILE @CantidadE < @Cantidad
BEGIN
INSERT @Tabla(
Articulo,  Descripcion,   Precio,  Codigo)
SELECT
@Articulo, @Descripcion1, @Precio, @Codigo
SET @CantidadE = @CantidadE +1
END
SET @Precio = NULL
FETCH NEXT FROM crLista INTO @Codigo, @Articulo,  @SubCuenta, @Cantidad, @Descripcion1, @Unidad
END
CLOSE crLista
DEALLOCATE crLista
SELECT * FROM @Tabla
END

