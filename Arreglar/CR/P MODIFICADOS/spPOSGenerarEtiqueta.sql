SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSGenerarEtiqueta
@Estacion   int,
@Articulo   varchar(5),
@SubCuenta  varchar(50),
@Unidad     varchar(50),
@Nombre     varchar(50),
@Moneda     varchar(10),
@Empresa    varchar(5),
@Sucursal   int,
@Cantidad   int= NULL

AS
BEGIN
DECLARE
@Plantilla            varchar(max),
@EspecificarCopias    bit,
@Tipo                 varchar(20),
@ListaPrecios         varchar(20),
@Precio               float,
@Codigo               varchar(50),
@Descuento            float,
@Descripcion1         varchar(100),
@NombreCorto          varchar(20),
@CantidadE            int,
@Resultado            varchar(max),
@ContMoneda		varchar(10),
@ContMonedaTC	        float,
@TipoCambio           float
DECLARE @Tabla table(Columna varchar(max))
SELECT @ContMoneda = ec.ContMoneda, @TipoCambio = 1
FROM EmpresaCfg ec WITH (NOLOCK)
WHERE ec.Empresa = @Empresa
SELECT @ContMonedaTC = TipoCambio
FROM POSLTipoCambioRef WITH (NOLOCK)
WHERE Sucursal = @Sucursal AND Moneda = @ContMoneda
SELECT @TipoCambio = CASE WHEN @Moneda <> @ContMoneda THEN  (ISNULL(@TipoCambio,1)/@ContMonedaTC) ELSE ISNULL(@TipoCambio,1) END
SELECT @Plantilla = Plantilla, @EspecificarCopias = EspecificarCopias, @Tipo = Tipo
FROM POSFormatoEtiqueta WITH (NOLOCK)
WHERE Nombre = Nombre
SELECT @ListaPrecios = ListaPreciosEsp
FROM Sucursal WITH (NOLOCK)
WHERE Sucursal = @Sucursal
SELECT TOP 1 @Precio = Precio
FROM ListaPreciosD WITH (NOLOCK)
WHERE Lista = @ListaPrecios AND Articulo = @Articulo
SELECT @Codigo = Codigo
FROM CB WITH (NOLOCK)
WHERE Cuenta = @Articulo
AND SubCuenta = @Subcuenta
AND TipoCuenta = 'Articulos'
SELECT @Descripcion1 = Descripcion1 ,  @NombreCorto = NombreCorto
FROM Art WITH (NOLOCK)
WHERE Articulo = @Articulo
EXEC spArtPrecio @Articulo = @Articulo, @Cantidad = 1, @UnidadVenta = @Unidad, @Precio = @Precio OUTPUT, @Descuento = @Descuento OUTPUT,
@SubCuenta = @SubCuenta, @Moneda = @Moneda, @TipoCambio = @TipoCambio, @Empresa = @Empresa, @Sucursal = @Sucursal
SELECT @Plantilla = REPLACE(@Plantilla,'[PRECIO]',CONVERT(varchar,@Precio))
SELECT @Plantilla = REPLACE(@Plantilla,'[CANTIDAD]',CONVERT(varchar,@Cantidad))
SELECT @Plantilla = REPLACE(@Plantilla,'[ARTICULO]',@Articulo)
SELECT @Plantilla = REPLACE(@Plantilla,'[CODIGO]',@Codigo)
SELECT @Plantilla = REPLACE(@Plantilla,'[DESCRIPCION]',@Descripcion1)
SELECT @Plantilla = REPLACE(@Plantilla,'[NOMBRECORTO]',@NombreCorto)
INSERT @Tabla
SELECT @Plantilla
IF @Tipo = 'Existencias'
SELECT @Cantidad = Inventario
FROM  ArtSubExistenciaInv WITH (NOLOCK)
WHERE Articulo = @Articulo
AND SubCuenta = ISNULL(@SubCuenta,'')
AND Sucursal  = @Sucursal
AND Empresa = @Empresa
IF @EspecificarCopias = 0
BEGIN
SET @CantidadE = 1
WHILE @CantidadE < @Cantidad
BEGIN
INSERT @Tabla
SELECT @Plantilla
SET @CantidadE = @CantidadE +1
END
END
SELECT * FROM @Tabla
END

