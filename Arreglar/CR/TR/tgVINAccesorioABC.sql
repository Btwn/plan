SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgVINAccesorioABC ON VINAccesorio

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@VIN		varchar(20),
@TipoUnidad		varchar(20),
@Empresa		varchar(5),
@Articulo		varchar(20),
@Tabla		varchar(50),
@TablaISAN		varchar(50),
@TablaISANLujo	varchar(50),
@ImporteISANLujo	float,
@ArtImpuesto1	float,
@ArtImpuesto2	float,
@PrecioDistribuidor	money,
@PrecioPublico	money,
@PrecioContado	money,
@ISANPublico	money,
@ISANContado	money,
@IVAPublico		money,
@IVAContado		money,
@ISANLujo		money
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ISANPublico = NULL, @ISANContado = NULL,
@IVAPublico  = NULL, @IVAContado  = NULL
SELECT @VIN = MIN(VIN) FROM Inserted
IF @VIN IS NULL
SELECT @VIN = MIN(VIN) FROM Deleted
SELECT @Empresa = Empresa,
@Articulo = Articulo,
@TipoUnidad = UPPER(TipoUnidad)
FROM VIN
WHERE VIN = @VIN
SELECT @TablaISAN = TablaISAN, @TablaISANLujo = TablaISANLujo, @ImporteISANLujo = ImporteISANLujo FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @ArtImpuesto1 = Impuesto1, @ArtImpuesto2 = NULLIF(Impuesto2, 0) FROM Art WHERE Articulo = @Articulo
SELECT @PrecioDistribuidor = SUM(PrecioDistribuidor),
@PrecioPublico      = SUM(PrecioPublico),
@PrecioContado      = SUM(PrecioContado)
FROM VINAccesorio
WHERE VIN = @VIN AND Estatus = 'ALTA'
IF @TipoUnidad = 'NUEVO'
BEGIN
IF @ArtImpuesto2 IS NOT NULL
SELECT @ISANPublico =  @PrecioPublico * (@ArtImpuesto2/100.0)
ELSE
EXEC spTablaImpuesto @TablaISAN, NULL, '(Sin Periodo)', @PrecioPublico, @ISANPublico OUTPUT
IF @PrecioPublico >= @ImporteISANLujo
BEGIN
EXEC spTablaImpuesto @TablaISANLujo, NULL, '(Sin Periodo)', @PrecioPublico, @ISANLujo OUTPUT
SELECT @ISANPublico = @ISANPublico - ISNULL(@ISANLujo, 0.0)
END
IF @ArtImpuesto2 IS NOT NULL
SELECT @ISANContado =  @PrecioContado * (@ArtImpuesto2/100.0)
ELSE
EXEC spTablaImpuesto @TablaISAN, NULL, '(Sin Periodo)', @PrecioContado, @ISANContado OUTPUT
IF @PrecioContado >= @ImporteISANLujo
BEGIN
EXEC spTablaImpuesto @TablaISANLujo, NULL, '(Sin Periodo)', @PrecioContado, @ISANLujo OUTPUT
SELECT @ISANContado = @ISANContado - ISNULL(@ISANLujo, 0.0)
END
END
SELECT @IVAPublico = (@PrecioPublico + ISNULL(@ISANPublico, 0)) * (@ArtImpuesto1/100)
SELECT @IVAContado = (@PrecioContado + ISNULL(@ISANContado, 0)) * (@ArtImpuesto1/100)
UPDATE VIN
SET PrecioDistribuidor = @PrecioDistribuidor,
PrecioPublico      = @PrecioPublico,
PrecioContado      = @PrecioContado,
ISANPublico	    = @ISANPublico,
ISANContado	    = @ISANContado,
IVAPublico	    = @IVAPublico,
IVAContado	    = @IVAContado
WHERE VIN = @VIN
IF (SELECT VINCostoSumaAccesorios FROM EmpresaCfg2 WHERE Empresa = @Empresa) = 1
UPDATE SerieLote SET CostoPromedio = @PrecioDistribuidor WHERE Empresa = @Empresa AND SerieLote = @VIN AND Existencia > 0
END

