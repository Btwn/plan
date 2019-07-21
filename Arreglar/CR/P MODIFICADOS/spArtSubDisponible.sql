SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spArtSubDisponible
@Empresa		char(5),
@Almacen		char(10),
@Articulo		char(20),
@ArtTipo		char(20),
@SubCuenta		varchar(50),
@Consignacion 	bit,
@AlmacenTipo		char(20),
@Factor		float,
@Disponible		float 	OUTPUT,
@Ok			int	OUTPUT,
@Tarima		varchar(20) = NULL

AS BEGIN
SELECT @Disponible = NULL, @SubCuenta = ISNULL(RTRIM(@SubCuenta), ''), @Tarima = ISNULL(dbo.fnAlmacenTarima(@Almacen, @Tarima), '')
IF @AlmacenTipo = 'ACTIVOS FIJOS' AND @Consignacion = 0
SELECT @Disponible = Disponible
FROM ActivoFSubDisponible
WHERE Empresa   = @Empresa
AND Almacen   = @Almacen
AND Articulo  = @Articulo
AND SubCuenta = @SubCuenta
ELSE
IF @Consignacion = 1
SELECT @Disponible = Consignacion
FROM ArtSubConsignacion
WHERE Empresa   = @Empresa
AND Almacen   = @Almacen
AND Articulo  = @Articulo
AND SubCuenta = @SubCuenta
ELSE
IF @Tarima <> ''
SELECT @Disponible = Disponible
FROM ArtSubDisponibleTarima
WHERE Empresa   = @Empresa
AND Almacen   = @Almacen
AND Tarima    = @Tarima
AND Articulo  = @Articulo
AND SubCuenta = @SubCuenta
ELSE
SELECT @Disponible = Disponible
FROM ArtSubDisponible
WHERE Empresa   = @Empresa
AND Almacen   = @Almacen
AND Articulo  = @Articulo
AND SubCuenta = @SubCuenta
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @Disponible = ISNULL(@Disponible, 0.0) / ISNULL(@Factor, 1.0)  
RETURN
END

