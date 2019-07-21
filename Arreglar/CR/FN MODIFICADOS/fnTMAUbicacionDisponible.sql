SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnTMAUbicacionDisponible (@Empresa varchar(5), @Almacen varchar(10), @Articulo varchar(20), @TMAID int, @Tarima varchar(20), @SubCuenta varchar(50))  
RETURNS varchar(20)

AS BEGIN
DECLARE
@Resultado		  varchar(20),
@Domicilio		  varchar(20),
@Pasillo		  int,
@Fila			  int,
@Zona			  varchar(50),
@TipoEspecial	  varchar(20),
@Nivel			  int,
@ZonaArt          varchar(30), 
@PosicionArticulo bit,  
@ContZonaArt      int,
@ContPosicion     int,
@AlmZona          varchar(50)
DECLARE  @Posicion TABLE (Posicion varchar(20), SSPID INT)
SELECT @Resultado = NULL
SELECT @TipoEspecial = TipoEspecial FROM Tarima WITH(NOLOCK) WHERE Tarima = @Tarima
SELECT TOP 1 @Domicilio = Posicion
FROM AlmPos WITH(NOLOCK)
WHERE Almacen = @Almacen AND ArticuloEsp = @Articulo AND UPPER(Tipo) = 'DOMICILIO' AND Estatus = 'ALTA'
SELECT @Pasillo = CASE ISNUMERIC(Pasillo) WHEN 1 THEN Pasillo ELSE 0 END, @Fila = Fila, @Nivel = Nivel
FROM AlmPos WITH(NOLOCK)
WHERE Almacen = @Almacen AND Posicion = @Domicilio
SELECT @ZonaArt = NULLIF(Zona,NULL)
FROM ArtZona WITH(NOLOCK)
WHERE Articulo = @Articulo
SELECT @ZonaArt = NULLIF(Zona,NULL)
FROM ArtZona WITH(NOLOCK)
WHERE Articulo = @Articulo
SELECT @ContZonaArt =  COUNT(*)
FROM ArtZona WITH(NOLOCK)
WHERE Articulo = @Articulo
SELECT @ContPosicion = COUNT(*)
FROM AlmPos WITH(NOLOCK)
WHERE Almacen = @Almacen
AND UPPER(Tipo) = 'UBICACION'
AND Estatus = 'ALTA'
AND ISNULL(Zona, '') <> 'Virtuales'
AND ArticuloEsp = @Articulo
SELECT @AlmZona = ISNULL(Zona,'')
FROM AlmPos WITH(NOLOCK)
WHERE Almacen = @Almacen
AND UPPER(Tipo) = 'UBICACION'
AND Estatus = 'ALTA'
AND ISNULL(Zona, '') <> 'Virtuales'
AND ArticuloEsp = @Articulo
SELECT @PosicionArticulo = ISNULL(PosicionArticulo,1)
FROM EmpresaCfg WITH(NOLOCK)
WHERE Empresa = @Empresa
IF @ContZonaArt >= 1 AND @ContPosicion >= 1 AND @AlmZona <> '' /* El Art Tiene Zonas y posiciones configurados */
BEGIN
DELETE @Posicion
INSERT INTO @Posicion
SELECT ap.Posicion, @@SPID
FROM AlmPos ap WITH(NOLOCK)
WHERE ap.Almacen = @Almacen AND UPPER(ap.Tipo) = 'UBICACION' AND ap.Estatus = 'ALTA' AND ISNULL(ap.Zona, '') <> 'Virtuales'
AND ISNULL(ap.TipoTarimaEsp, '') = ISNULL(ISNULL(@TipoEspecial, ap.TipoTarimaEsp), '')
AND ap.ArticuloEsp = @Articulo
AND ap.Zona IN (SELECT Zona FROM ArtZona WITH(NOLOCK) WHERE Articulo = @Articulo)
GROUP BY ap.Pasillo, ap.Fila, ap.Nivel, ap.Posicion
ORDER BY Abs(ISNULL(CASE ISNUMERIC(Pasillo) WHEN 1 THEN Pasillo ELSE 0 END, 0)-@Pasillo), Abs(ISNULL(Fila, 0)-@Fila), Abs(ISNULL(Nivel, 0)-@Nivel)
IF @PosicionArticulo = 1
BEGIN
IF @Articulo IN (SELECT Articulo FROM PosicionArt WITH(NOLOCK))
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK) WHERE Articulo = @Articulo)
IF @Articulo NOT IN (SELECT Articulo FROM PosicionArt WITH(NOLOCK))
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion NOT IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK))
IF @Resultado IS NULL
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion NOT IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK))
IF @Resultado IS NULL
BEGIN
DELETE @Posicion
INSERT INTO @Posicion
SELECT ap.Posicion, @@SPID
FROM AlmPos ap WITH(NOLOCK)
WHERE ap.Almacen = @Almacen AND UPPER(ap.Tipo) = 'UBICACION' AND ap.Estatus = 'ALTA' AND ISNULL(ap.Zona, '') <> 'Virtuales'
AND ISNULL(ap.TipoTarimaEsp, '') = ISNULL(ISNULL(@TipoEspecial, ap.TipoTarimaEsp), '')
AND ap.ArticuloEsp = @Articulo
GROUP BY ap.Pasillo, ap.Fila, ap.Nivel, ap.Posicion
ORDER BY Abs(ISNULL(CASE ISNUMERIC(Pasillo) WHEN 1 THEN Pasillo ELSE 0 END, 0)-@Pasillo), Abs(ISNULL(Fila, 0)-@Fila), Abs(ISNULL(Nivel, 0)-@Nivel)
IF @Articulo IN (SELECT Articulo FROM PosicionArt WITH(NOLOCK))
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK) WHERE Articulo = @Articulo)
IF @Articulo NOT IN (SELECT Articulo FROM PosicionArt WITH(NOLOCK))
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion NOT IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK))
IF @Resultado IS NULL
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion NOT IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK))
END
IF @Resultado IS NULL
BEGIN
DELETE @Posicion
INSERT INTO @Posicion
SELECT ap.Posicion, @@SPID
FROM AlmPos ap WITH(NOLOCK)
WHERE ap.Almacen = @Almacen AND UPPER(ap.Tipo) = 'UBICACION' AND ap.Estatus = 'ALTA' AND ISNULL(ap.Zona, '') <> 'Virtuales'
AND ISNULL(ap.TipoTarimaEsp, '') = ISNULL(ISNULL(NULL, ap.TipoTarimaEsp), '')
AND NULLIF(ap.ArticuloEsp, '') IS NULL
AND ap.Zona IN (SELECT Zona FROM ArtZona WITH(NOLOCK) WHERE Articulo = @Articulo)
GROUP BY ap.Pasillo, ap.Fila, ap.Nivel, ap.Posicion
ORDER BY Abs(ISNULL(CASE ISNUMERIC(Pasillo) WHEN 1 THEN Pasillo ELSE 0 END, 0)-@Pasillo), Abs(ISNULL(Fila, 0)-@Fila), Abs(ISNULL(Nivel, 0)-@Nivel)
IF @Articulo IN (SELECT Articulo FROM PosicionArt WITH(NOLOCK))
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK) WHERE Articulo = @Articulo)
IF @Articulo NOT IN (SELECT Articulo FROM PosicionArt WITH(NOLOCK))
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion NOT IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK))
IF @Resultado IS NULL
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion NOT IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK))
END
IF @Resultado IS NULL
BEGIN
DELETE @Posicion
INSERT INTO @Posicion
SELECT ap.Posicion, @@SPID
FROM AlmPos ap WITH(NOLOCK)
WHERE ap.Almacen = @Almacen AND UPPER(ap.Tipo) = 'UBICACION' AND ap.Estatus = 'ALTA' AND ISNULL(ap.Zona, '') <> 'Virtuales'
AND ISNULL(ap.TipoTarimaEsp, '') = ISNULL(ISNULL(NULL, ap.TipoTarimaEsp), '')
AND NULLIF(ap.ArticuloEsp, '') IS NULL
AND ISNULL(ap.Zona, '') = ''
GROUP BY ap.Pasillo, ap.Fila, ap.Nivel, ap.Posicion
ORDER BY Abs(ISNULL(CASE ISNUMERIC(Pasillo) WHEN 1 THEN Pasillo ELSE 0 END, 0)-@Pasillo), Abs(ISNULL(Fila, 0)-@Fila), Abs(ISNULL(Nivel, 0)-@Nivel)
IF @Articulo IN (SELECT Articulo FROM PosicionArt WITH(NOLOCK))
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK) WHERE Articulo = @Articulo)
IF @Articulo NOT IN (SELECT Articulo FROM PosicionArt WITH(NOLOCK))
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion NOT IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK))
IF @Resultado IS NULL
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
END
END
ELSE
BEGIN
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
END
END
IF @ContZonaArt >= 1 AND @ContPosicion >= 1 AND @AlmZona = ''/* El Art No Tiene Zonas configurados pero posiciones configurados sin zonas*/
BEGIN
DELETE @Posicion
INSERT INTO @Posicion
SELECT ap.Posicion, @@SPID
FROM AlmPos ap WITH(NOLOCK)
WHERE ap.Almacen = @Almacen AND UPPER(ap.Tipo) = 'UBICACION' AND ap.Estatus = 'ALTA' AND ISNULL(ap.Zona, '') <> 'Virtuales'
AND ISNULL(ap.TipoTarimaEsp, '') = ISNULL(ISNULL(@TipoEspecial, ap.TipoTarimaEsp), '')
AND ap.ArticuloEsp = @Articulo
GROUP BY ap.Pasillo, ap.Fila, ap.Nivel, ap.Posicion
ORDER BY Abs(ISNULL(CASE ISNUMERIC(Pasillo) WHEN 1 THEN Pasillo ELSE 0 END, 0)-@Pasillo), Abs(ISNULL(Fila, 0)-@Fila), Abs(ISNULL(Nivel, 0)-@Nivel)
IF @PosicionArticulo = 1
BEGIN
IF @Articulo IN (SELECT Articulo FROM PosicionArt WITH(NOLOCK))
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK) WHERE Articulo = @Articulo)
IF @Articulo NOT IN (SELECT Articulo FROM PosicionArt WITH(NOLOCK))
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion NOT IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK))
IF @Resultado IS NULL
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion NOT IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK))
IF @Resultado IS NULL
BEGIN
DELETE @Posicion
INSERT INTO @Posicion
SELECT ap.Posicion, @@SPID
FROM AlmPos ap WITH(NOLOCK)
WHERE ap.Almacen = @Almacen AND UPPER(ap.Tipo) = 'UBICACION' AND ap.Estatus = 'ALTA' AND ISNULL(ap.Zona, '') <> 'Virtuales'
AND ISNULL(ap.TipoTarimaEsp, '') = ISNULL(ISNULL(NULL, ap.TipoTarimaEsp), '')
AND NULLIF(ap.ArticuloEsp, '') IS NULL
AND ap.Zona IN (SELECT Zona FROM ArtZona WITH(NOLOCK) WHERE Articulo = @Articulo)
GROUP BY ap.Pasillo, ap.Fila, ap.Nivel, ap.Posicion
ORDER BY Abs(ISNULL(CASE ISNUMERIC(Pasillo) WHEN 1 THEN Pasillo ELSE 0 END, 0)-@Pasillo), Abs(ISNULL(Fila, 0)-@Fila), Abs(ISNULL(Nivel, 0)-@Nivel)
IF @Articulo IN (SELECT Articulo FROM PosicionArt WITH(NOLOCK))
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK) WHERE Articulo = @Articulo)
IF @Articulo NOT IN (SELECT Articulo FROM PosicionArt WITH(NOLOCK))
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion NOT IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK))
IF @Resultado IS NULL
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion NOT IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK))
END
IF @Resultado IS NULL
BEGIN
DELETE @Posicion
INSERT INTO @Posicion
SELECT ap.Posicion, @@SPID
FROM AlmPos ap WITH(NOLOCK)
WHERE ap.Almacen = @Almacen AND UPPER(ap.Tipo) = 'UBICACION' AND ap.Estatus = 'ALTA' AND ISNULL(ap.Zona, '') <> 'Virtuales'
AND ISNULL(ap.TipoTarimaEsp, '') = ISNULL(ISNULL(NULL, ap.TipoTarimaEsp), '')
AND NULLIF(ap.ArticuloEsp, '') IS NULL
AND ISNULL(ap.Zona, '') = ''
GROUP BY ap.Pasillo, ap.Fila, ap.Nivel, ap.Posicion
ORDER BY Abs(ISNULL(CASE ISNUMERIC(Pasillo) WHEN 1 THEN Pasillo ELSE 0 END, 0)-@Pasillo), Abs(ISNULL(Fila, 0)-@Fila), Abs(ISNULL(Nivel, 0)-@Nivel)
IF @Articulo IN (SELECT Articulo FROM PosicionArt WITH(NOLOCK))
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK) WHERE Articulo = @Articulo)
IF @Articulo NOT IN (SELECT Articulo FROM PosicionArt WITH(NOLOCK))
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion NOT IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK))
IF @Resultado IS NULL
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion NOT IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK))
END
END
ELSE
BEGIN
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
END
END
IF @ContZonaArt = 0 AND @ContPosicion >= 1 /* El Art No Tiene Zonas configurados pero posiciones configurados sin zonas*/
BEGIN
DELETE @Posicion
INSERT INTO @Posicion
SELECT ap.Posicion, @@SPID
FROM AlmPos ap WITH(NOLOCK)
WHERE ap.Almacen = @Almacen AND UPPER(ap.Tipo) = 'UBICACION' AND ap.Estatus = 'ALTA' AND ISNULL(ap.Zona, '') <> 'Virtuales'
AND ISNULL(ap.TipoTarimaEsp, '') = ISNULL(ISNULL(@TipoEspecial, ap.TipoTarimaEsp), '')
AND ap.ArticuloEsp = @Articulo
GROUP BY ap.Pasillo, ap.Fila, ap.Nivel, ap.Posicion
ORDER BY Abs(ISNULL(CASE ISNUMERIC(Pasillo) WHEN 1 THEN Pasillo ELSE 0 END, 0)-@Pasillo), Abs(ISNULL(Fila, 0)-@Fila), Abs(ISNULL(Nivel, 0)-@Nivel)
IF @PosicionArticulo = 1
BEGIN
IF @Articulo IN (SELECT Articulo FROM PosicionArt WITH(NOLOCK))
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK) WHERE Articulo = @Articulo)
IF @Articulo NOT IN (SELECT Articulo FROM PosicionArt WITH(NOLOCK))
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion NOT IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK))
IF @Resultado IS NULL
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion NOT IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK))
IF @Resultado IS NULL
BEGIN
DELETE @Posicion
INSERT INTO @Posicion
SELECT ap.Posicion, @@SPID
FROM AlmPos ap WITH(NOLOCK)
WHERE ap.Almacen = @Almacen AND UPPER(ap.Tipo) = 'UBICACION' AND ap.Estatus = 'ALTA' AND ISNULL(ap.Zona, '') <> 'Virtuales'
AND ISNULL(ap.TipoTarimaEsp, '') = ISNULL(ISNULL(NULL, ap.TipoTarimaEsp), '')
AND NULLIF(ap.ArticuloEsp, '') IS NULL
AND ap.Zona IN (SELECT Zona FROM ArtZona WITH(NOLOCK) WHERE Articulo = @Articulo)
GROUP BY ap.Pasillo, ap.Fila, ap.Nivel, ap.Posicion
ORDER BY Abs(ISNULL(CASE ISNUMERIC(Pasillo) WHEN 1 THEN Pasillo ELSE 0 END, 0)-@Pasillo), Abs(ISNULL(Fila, 0)-@Fila), Abs(ISNULL(Nivel, 0)-@Nivel)
IF @Articulo IN (SELECT Articulo FROM PosicionArt WITH(NOLOCK))
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK) WHERE Articulo = @Articulo)
IF @Articulo NOT IN (SELECT Articulo FROM PosicionArt WITH(NOLOCK))
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion NOT IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK))
IF @Resultado IS NULL
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion NOT IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK))
END
IF @Resultado IS NULL
BEGIN
DELETE @Posicion
INSERT INTO @Posicion
SELECT ap.Posicion, @@SPID
FROM AlmPos ap WITH(NOLOCK)
WHERE ap.Almacen = @Almacen AND UPPER(ap.Tipo) = 'UBICACION' AND ap.Estatus = 'ALTA' AND ISNULL(ap.Zona, '') <> 'Virtuales'
AND ISNULL(ap.TipoTarimaEsp, '') = ISNULL(ISNULL(NULL, ap.TipoTarimaEsp), '')
AND NULLIF(ap.ArticuloEsp, '') IS NULL
AND ISNULL(ap.Zona, '') = ''
GROUP BY ap.Pasillo, ap.Fila, ap.Nivel, ap.Posicion
ORDER BY Abs(ISNULL(CASE ISNUMERIC(Pasillo) WHEN 1 THEN Pasillo ELSE 0 END, 0)-@Pasillo), Abs(ISNULL(Fila, 0)-@Fila), Abs(ISNULL(Nivel, 0)-@Nivel)
IF @Articulo IN (SELECT Articulo FROM PosicionArt WITH(NOLOCK))
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK) WHERE Articulo = @Articulo)
IF @Articulo NOT IN (SELECT Articulo FROM PosicionArt WITH(NOLOCK))
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion NOT IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK))
IF @Resultado IS NULL
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion NOT IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK))
END
END
ELSE
BEGIN
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
END
END
IF @ContZonaArt >= 1 AND @ContPosicion = 0  /* El Art Tiene Zonas */
BEGIN
DELETE @Posicion
INSERT INTO @Posicion
SELECT ap.Posicion, @@SPID
FROM AlmPos ap WITH(NOLOCK)
WHERE ap.Almacen = @Almacen AND UPPER(ap.Tipo) = 'UBICACION' AND ap.Estatus = 'ALTA' AND ISNULL(ap.Zona, '') <> 'Virtuales'
AND ISNULL(ap.TipoTarimaEsp, '') = ISNULL(ISNULL(NULL, ap.TipoTarimaEsp), '')
AND NULLIF(ap.ArticuloEsp, '') IS NULL
AND ap.Zona IN (SELECT Zona FROM ArtZona WITH(NOLOCK) WHERE Articulo = @Articulo)
GROUP BY ap.Pasillo, ap.Fila, ap.Nivel, ap.Posicion
ORDER BY Abs(ISNULL(CASE ISNUMERIC(Pasillo) WHEN 1 THEN Pasillo ELSE 0 END, 0)-@Pasillo), Abs(ISNULL(Fila, 0)-@Fila), Abs(ISNULL(Nivel, 0)-@Nivel)
IF @PosicionArticulo = 1
BEGIN
IF @Articulo IN (SELECT Articulo FROM PosicionArt WITH(NOLOCK))
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK) WHERE Articulo = @Articulo)
IF @Articulo NOT IN (SELECT Articulo FROM PosicionArt WITH(NOLOCK))
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion NOT IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK))
IF @Resultado IS NULL
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion NOT IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK))
IF @Resultado IS NULL
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
IF @RESULTADO IS NULL
BEGIN
DELETE @Posicion
INSERT INTO @Posicion
SELECT ap.Posicion, @@SPID
FROM AlmPos ap WITH(NOLOCK)
WHERE ap.Almacen = @Almacen AND UPPER(ap.Tipo) = 'UBICACION' AND ap.Estatus = 'ALTA' AND ISNULL(ap.Zona, '') <> 'Virtuales'
AND ISNULL(ap.TipoTarimaEsp, '') = ISNULL(ISNULL(NULL, ap.TipoTarimaEsp), '')
AND NULLIF(ap.ArticuloEsp, '') IS NULL
AND ISNULL(ap.Zona, '') = ''
GROUP BY ap.Pasillo, ap.Fila, ap.Nivel, ap.Posicion
ORDER BY Abs(ISNULL(CASE ISNUMERIC(Pasillo) WHEN 1 THEN Pasillo ELSE 0 END, 0)-@Pasillo), Abs(ISNULL(Fila, 0)-@Fila), Abs(ISNULL(Nivel, 0)-@Nivel)
IF @Articulo IN (SELECT Articulo FROM PosicionArt WITH(NOLOCK))
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK) WHERE Articulo = @Articulo)
IF @Articulo NOT IN (SELECT Articulo FROM PosicionArt WITH(NOLOCK))
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion NOT IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK))
IF @Resultado IS NULL
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion NOT IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK))
IF @Resultado IS NULL
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
END
END
ELSE
BEGIN
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
END
END
IF @ContZonaArt = 0 AND @ContPosicion = 0  /* El Art No Tiene Zonas Ni posiciones configurados */
BEGIN
DELETE @Posicion
INSERT INTO @Posicion
SELECT ap.Posicion, @@SPID
FROM AlmPos ap WITH(NOLOCK)
WHERE ap.Almacen = @Almacen AND UPPER(ap.Tipo) = 'UBICACION' AND ap.Estatus = 'ALTA' AND ISNULL(ap.Zona, '') <> 'Virtuales'
AND ISNULL(ap.TipoTarimaEsp, '') = ISNULL(ISNULL(NULL, ap.TipoTarimaEsp), '')
AND NULLIF(ap.ArticuloEsp, '') IS NULL
AND ISNULL(ap.Zona, '') = ''
GROUP BY ap.Pasillo, ap.Fila, ap.Nivel, ap.Posicion
ORDER BY Abs(ISNULL(CASE ISNUMERIC(Pasillo) WHEN 1 THEN Pasillo ELSE 0 END, 0)-@Pasillo), Abs(ISNULL(Fila, 0)-@Fila), Abs(ISNULL(Nivel, 0)-@Nivel)
IF @PosicionArticulo = 1
BEGIN
IF @Articulo IN (SELECT Articulo FROM PosicionArt WITH(NOLOCK))
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK) WHERE Articulo = @Articulo)
IF @Articulo NOT IN (SELECT Articulo FROM PosicionArt WITH(NOLOCK))
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
AND Posicion NOT IN (SELECT Posicion FROM PosicionArt WITH(NOLOCK))
IF @Resultado IS NULL
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
END
ELSE
BEGIN
SELECT TOP 1 @Resultado = Posicion
FROM @Posicion
WHERE dbo.fnAlmPosTieneCapacidadWMS(@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 1
END
END
RETURN(@Resultado)
END

