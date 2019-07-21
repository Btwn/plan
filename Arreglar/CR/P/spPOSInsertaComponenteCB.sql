SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSInsertaComponenteCB
@ID						varchar(36),
@Codigo					varchar(50),
@Estacion				int,
@ArticuloPrincipal		varchar(20),
@RenglonID				int,
@Numero					int = 0,
@Mensaje				varchar(255) OUTPUT

AS
BEGIN
DECLARE
@Articulo           varchar(20),
@SubCuenta			varchar(50),
@Ok                 int,
@Juego              varchar(10),
@JuegoC             varchar(10)
SET @Numero = ISNULL(@Numero,0) + 1
SELECT @Mensaje = NULL,@Ok = NULL
IF NULLIF(@Codigo,'') IS NULL
RETURN
SELECT @Articulo = Cuenta, @SubCuenta = NULLIF(SubCuenta,'')
FROM CB
WHERE Codigo = @Codigo
AND TipoCuenta = 'Articulos'
SELECT @Juego = MAX(Juego)
FROM POSArtComponente
WHERE ArticuloP = @ArticuloPrincipal
IF NOT EXISTS(SELECT * FROM POSArtComponente WHERE ArticuloP = @ArticuloPrincipal AND Articulo = @Articulo AND SubCuenta = @SubCuenta )
SELECT @Ok = 4, @Mensaje = 'EL ARTICULO NO CORRESPONDE AL JUEGO'
IF @Ok IS NULL
BEGIN
SELECT TOP 1 @JuegoC = a.Juego
FROM POSArtJuegoComponente a
WHERE NULLIF(a.Opcion,'') IS NULL AND a.Estacion = @Estacion AND a.RID = @ID AND Articulo = @ArticuloPrincipal AND RenglonID = @RenglonID
AND @Articulo IN (SELECT Articulo FROM POSArtComponente WHERE  ArticuloP = @ArticuloPrincipal AND Juego = a.Juego AND SubCuenta = @SubCuenta)
AND a.Opcional = 1
IF @JuegoC IS NOT NULL
UPDATE POSArtJuegoComponente SET ArtSubCuenta = CASE WHEN NULLIF(@SubCuenta,'') IS NOT NULL
THEN @Articulo+' ('+@SubCuenta+')'
ELSE @Articulo
END, Opcion = @Articulo, SubCuenta = @SubCuenta
WHERE RID = @ID AND Juego = @JuegoC AND Estacion = @Estacion
ELSE
IF @JuegoC IS  NULL
EXEC spPOSVerificaComponenteCB @ID, @Estacion, @Codigo, @ArticuloPrincipal, @RenglonID ,@Articulo, @SubCuenta, @Numero, @Mensaje OUTPUT
END
END

