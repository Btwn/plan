SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSVerificaComponenteCB
@ID                 varchar(36),
@Estacion           int,
@Codigo             varchar(50),
@ArticuloPrincipal  varchar(20),
@RenglonID          int,
@Articulo           varchar(20),
@SubCuenta          varchar(50),
@Numero             int,
@Mensaje            varchar(255) OUTPUT

AS
BEGIN
DECLARE
@Ok                 int,
@Juego2             varchar(10),
@Juego3             varchar(10),
@Opcion2			varchar(20),
@SubCuenta2		    varchar(50),
@Inserto            bit
DECLARE @Tabla table (
Juego	varchar(20))
DECLARE @TablaD table(
ID             int,
Juego          varchar(20),
Opcion         varchar(20),
SubCuenta      varchar(50))
SET @Inserto = 0
INSERT @Tabla(Juego)
SELECT Juego
FROM POSArtComponente
WHERE  ArticuloP = @ArticuloPrincipal AND Articulo = @Articulo AND SubCuenta = @SubCuenta
IF @@ERROR <> 0
SET @Ok = 1
INSERT @TablaD(
ID, Juego, Opcion, SubCuenta)
SELECT
a.ID, a.Juego, a.Opcion, a.SubCuenta
FROM POSArtJuegoComponente a
WHERE  NULLIF(a.Opcion,'') IS NOT NULL AND a.Estacion = @Estacion AND a.RID = @ID AND Articulo = @ArticuloPrincipal
AND RenglonID = @RenglonID AND a.Opcional = 1 AND a.Juego IN(SELECT Juego FROM @Tabla)
IF @@ERROR <> 0
SET @Ok = 1
IF EXISTS(SELECT a.Opcion FROM POSArtJuegoComponente a WHERE NULLIF(a.Opcion,'') IS NOT NULL AND a.Estacion = @Estacion
AND a.RID = @ID AND Articulo = @ArticuloPrincipal AND RenglonID = @RenglonID AND a.Opcional = 1
AND a.Juego IN(SELECT Juego FROM @Tabla) AND (SELECT COUNT(Juego) FROM POSArtComponente WHERE  ArticuloP = @ArticuloPrincipal
AND Articulo = a.Articulo AND SubCuenta = a.SubCuenta)>1)
BEGIN
DECLARE crJuegoComponente CURSOR FOR
SELECT a.Juego, a.Opcion, a.SubCuenta
FROM POSArtJuegoComponente a
WHERE NULLIF(a.Opcion,'') IS NOT NULL AND a.Estacion = @Estacion AND a.RID = @ID AND Articulo = @ArticuloPrincipal
AND RenglonID = @RenglonID AND a.Opcional = 1
AND a.Juego IN(SELECT Juego FROM @Tabla)
OPEN crJuegoComponente
FETCH NEXT FROM crJuegoComponente INTO  @Juego2, @Opcion2, @SubCuenta2
WHILE @@FETCH_STATUS <> -1 AND @Inserto = 0 AND @Ok IS NULL
BEGIN
SELECT TOP 1 @Juego3 = a.Juego
FROM POSArtJuegoComponente a
WHERE NULLIF(a.Opcion,'') IS NULL AND a.Estacion = @Estacion AND a.RID = @ID
AND Articulo = @ArticuloPrincipal AND RenglonID = @RenglonID
AND @Opcion2 IN (SELECT Articulo FROM POSArtComponente WHERE  ArticuloP = @ArticuloPrincipal
AND Juego = a.Juego AND SubCuenta = @SubCuenta2)
AND a.Opcional = 1
AND a.Juego <> @Juego2
IF @Juego3 IS NOT NULL
BEGIN
UPDATE POSArtJuegoComponente
SET ArtSubCuenta = CASE WHEN NULLIF(@SubCuenta2,'') IS NOT NULL
THEN @Opcion2+' ('+@SubCuenta2+')'
ELSE @Opcion2
END, Opcion = @Opcion2, SubCuenta = @SubCuenta2
WHERE RID = @ID AND Juego = @Juego3 AND Estacion = @Estacion
IF @@ROWCOUNT > 1
SET @Inserto = 1
IF @@ERROR <> 0
SET @Ok = 1
UPDATE POSArtJuegoComponente
SET ArtSubCuenta = NULL, Opcion = NULL, SubCuenta = NULL
WHERE RID = @ID AND Juego = @Juego2 AND Estacion = @Estacion
END
FETCH NEXT FROM crJuegoComponente INTO @Juego2, @Opcion2, @SubCuenta2
END
CLOSE crJuegoComponente
DEALLOCATE crJuegoComponente
END
IF @Ok IS NULL AND @Numero < 10
EXEC spPOSInsertaComponenteCB @ID, @Codigo, @Estacion, @ArticuloPrincipal, @RenglonID, @Numero, @Mensaje OUTPUT
END

