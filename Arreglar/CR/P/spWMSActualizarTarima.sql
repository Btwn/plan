SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSActualizarTarima
@Estacion		int,
@Almacen        varchar(20),
@Articulo       varchar(20),
@SubCuenta      varchar(50),
@PosicionOrigen varchar(20),
@Tipo           varchar(20),
@CantidadTarima float,
@Tarima         varchar(20)

AS BEGIN
DECLARE @Disponible float
SELECT Disponible=NULL
SELECT TOP 1
@Disponible	= ISNULL(adt.Disponible  ,0)
FROM ArtDisponibleTarima adt
JOIN Tarima t ON adt.Almacen =t.Almacen AND adt.Tarima = t.Tarima
JOIN AlmPos ap ON t.Almacen = ap.Almacen AND t.Posicion = ap.Posicion
WHERE adt.Almacen = @Almacen
AND adt.Articulo = @Articulo
AND ap.Tipo = @Tipo
AND adt.Tarima = @Tarima
AND t.SubCuenta=@SubCuenta 
AND ap.SubCuenta=t.SubCuenta 
IF @Disponible=@CantidadTarima
UPDATE WMSSurtidoProcesarD
SET Tarima = @Tarima 
WHERE Estacion = @Estacion
AND Articulo = @Articulo
AND ISNULL(SubCuenta, '') = ISNULL(ISNULL(@SubCuenta, SubCuenta), '')
AND PosicionOrigen = @PosicionOrigen
AND Tipo     = @Tipo
AND CantidadTarima = @CantidadTarima
ELSE
SELECT 'Favor de Seleccionar una Tarima Válida!'
RETURN
END

