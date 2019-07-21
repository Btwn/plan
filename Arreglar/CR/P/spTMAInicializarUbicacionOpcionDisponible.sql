SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTMAInicializarUbicacionOpcionDisponible
@Empresa          		varchar(5),
@Sucursal			int,
@Almacen			varchar(10),
@TMAID                 int,
@Articulo			varchar(20),
@Tarima             varchar(20),
@SubCuenta          varchar(50),
@ID                 int

AS BEGIN
DECLARE
@Renglon		float,
@Zona			varchar(50),
@ArticuloTipo      varchar(20),
@PosicionSubCuenta varchar(50),
@Domicilio		varchar(20),
@Pasillo		int,
@Fila			int,
@TipoEspecial	varchar(20),
@Nivel			int
SELECT @TipoEspecial = TipoEspecial FROM Tarima WHERE Tarima = @Tarima
SELECT TOP 1 @Domicilio = Posicion
FROM AlmPos
WHERE Almacen = @Almacen AND ArticuloEsp = @Articulo AND UPPER(Tipo) = 'DOMICILIO' AND Estatus = 'ALTA'
SELECT @Pasillo = CASE ISNUMERIC(Pasillo) WHEN 1 THEN Pasillo ELSE 0 END, @Fila = Fila, @Nivel = Nivel
FROM AlmPos
WHERE Almacen = @Almacen AND Posicion = @Domicilio
SELECT @PosicionSubCuenta=null
SELECT TOP 1 @PosicionSubCuenta=ap.Posicion
FROM AlmPos ap
WHERE ap.Almacen = @Almacen AND UPPER(ap.Tipo) = 'UBICACION'
AND ap.Estatus = 'ALTA' AND ISNULL(ap.Zona, '') <> 'Virtuales'
AND ISNULL(ap.TipoTarimaEsp, '') = ISNULL(ISNULL(@TipoEspecial, ap.TipoTarimaEsp), '')
AND ap.ArticuloEsp = @Articulo
AND NULLIF(ap.SubCuenta,'') IS NULL
GROUP BY ap.Pasillo, ap.Fila, ap.Nivel, ap.Posicion
ORDER BY Abs(ISNULL(CASE ISNUMERIC(Pasillo) WHEN 1 THEN Pasillo ELSE 0 END, 0)-@Pasillo), Abs(ISNULL(Fila, 0)-@Fila),
Abs(ISNULL(Nivel, 0)-@Nivel)
IF @PosicionSubCuenta IS NULL
BEGIN
SELECT TOP 1 @PosicionSubCuenta=ap.Posicion
FROM AlmPos ap
WHERE ap.Almacen = @Almacen AND UPPER(ap.Tipo) = 'UBICACION'
AND ap.Estatus = 'ALTA' AND ISNULL(ap.Zona, '') <> 'Virtuales'
AND ISNULL(ap.TipoTarimaEsp, '') = ISNULL(ISNULL(@TipoEspecial, ap.TipoTarimaEsp), '')
AND ap.Zona IN(SELECT Zona FROM ArtZona WHERE Articulo = @Articulo)
AND NULLIF(ap.SubCuenta,'') IS NULL
AND NULLIF(ap.ArticuloEsp, '') IS NULL
GROUP BY ap.Pasillo, ap.Fila, ap.Nivel, ap.Posicion
ORDER BY Abs(ISNULL(CASE ISNUMERIC(Pasillo) WHEN 1 THEN Pasillo ELSE 0 END, 0)-@Pasillo), Abs(ISNULL(Fila, 0)-@Fila),
Abs(ISNULL(Nivel, 0)-@Nivel)
END
IF @PosicionSubCuenta IS NULL
BEGIN
SELECT TOP 1 @PosicionSubCuenta=ap.Posicion
FROM AlmPos ap
WHERE ap.Almacen = @Almacen AND UPPER(ap.Tipo) = 'UBICACION'
AND ap.Estatus = 'ALTA' AND ISNULL(ap.Zona, '') <> 'Virtuales'
AND NULLIF(ap.SubCuenta,'') IS NULL
AND NULLIF(ap.ArticuloEsp, '') IS NULL
GROUP BY ap.Pasillo, ap.Fila, ap.Nivel, ap.Posicion
ORDER BY Abs(ISNULL(CASE ISNUMERIC(Pasillo) WHEN 1 THEN Pasillo ELSE 0 END, 0)-@Pasillo), Abs(ISNULL(Fila, 0)-@Fila),
Abs(ISNULL(Nivel, 0)-@Nivel)
END
IF @PosicionSubCuenta IS NOT NULL
IF NOT EXISTS(SELECT * FROM AlmPos WHERE ArticuloEsp=@Articulo AND SubCuenta=@SubCuenta)
BEGIN
UPDATE AlmPos
SET SubCuenta=@SubCuenta
WHERE Posicion=@PosicionSubCuenta AND SubCuenta IS NULL
END
RETURN
END

