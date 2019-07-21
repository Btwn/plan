SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spArtDisponible
@Empresa		char(5),
@Almacen		char(10),
@Articulo		char(20),
@Consignacion 	bit,
@AlmacenTipo		char(20),
@Factor		float,
@Disponible		float   OUTPUT,
@Ok			int	OUTPUT,
@Tarima		varchar(20) = NULL

AS BEGIN
SELECT @Disponible = NULL, @Tarima = ISNULL(dbo.fnAlmacenTarima(@Almacen, @Tarima), '')
IF @AlmacenTipo = 'ACTIVOS FIJOS' AND @Consignacion = 0
SELECT @Disponible = Disponible
FROM ActivoFDisponible 
WHERE Empresa = @Empresa
AND Almacen = @Almacen
AND Articulo = @Articulo
ELSE
IF @Consignacion = 1
SELECT @Disponible = Consignacion
FROM ArtConsignacion
WHERE Empresa = @Empresa
AND Almacen = @Almacen
AND Articulo = @Articulo
ELSE
IF @Tarima <> ''
SELECT @Disponible = Disponible
FROM ArtDisponibleTarima
WHERE Empresa = @Empresa
AND Almacen = @Almacen
AND Tarima = @Tarima
AND Articulo = @Articulo
ELSE
SELECT @Disponible = Disponible
FROM ArtDisponible
WHERE Empresa = @Empresa
AND Almacen = @Almacen
AND Articulo = @Articulo
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @Disponible = ISNULL(@Disponible, 0.0) / ISNULL(@Factor, 1.0)  
RETURN
END

