SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnWMSPosicionDestinoLista (@Almacen varchar(20), @Articulo varchar(20), @Tipo varchar(20), @Empresa char(5) = NULL, @Tarima varchar(20) = NULL,  @TMAID int = NULL, @ValidarCapacidad bit = 0)
RETURNS @Resultado TABLE (
Almacen      varchar(10),
Posicion     varchar(10),
Tipo         varchar(20),
Descripcion  varchar(100),
Pasillo      int,
Fila         int,
Nivel        int,
Zona         varchar(50),
Capacidad    int,
Estatus	   varchar(15),
ArticuloEsp  varchar(20),
Alto         float,
Largo        float,
Ancho        float,
Volumen      float,
PesoMaximo   float,
Orden        int,
TipoRotacion varchar(10),
Subtipo      varchar(20)
)
AS BEGIN
DECLARE
@MovTipo	varchar(20)
IF EXISTS (SELECT * FROM ArtZona WITH(NOLOCK) WHERE Articulo = @Articulo AND NULLIF(NULLIF(Zona, '(Todas)'), '') IS NULL)
OR NOT EXISTS (SELECT * FROM ArtZona WITH(NOLOCK) WHERE Articulo = @Articulo)
INSERT @Resultado
SELECT Almacen, Posicion, Tipo, Descripcion, Pasillo, Fila, Nivel, ISNULL(NULLIF(Zona, ''), ''), Capacidad, Estatus, ArticuloEsp, Alto, Largo, Ancho, Volumen, PesoMaximo, Orden, TipoRotacion,
CASE WHEN Tipo = 'Ubicacion' AND ISNULL(Zona,'') = '' AND ISNULL(ArticuloEsp,'') = '' THEN 'Caótica'
WHEN Tipo = 'Ubicacion' AND ISNULL(Zona,'') <> '' AND ISNULL(ArticuloEsp,'') = '' THEN 'Semi Caótica'
ELSE 'Específica' END Subtipo
FROM AlmPos WITH(NOLOCK)
WHERE CASE WHEN (@Tipo <> 'Surtido' AND Tipo IN( 'Ubicacion', 'Domicilio', 'Surtido', 'Recibo'))
OR (@Tipo = 'Surtido' AND Tipo IN( 'Ubicacion', 'Domicilio'))
THEN 1
ELSE 0
END = 1
AND ISNULL(NULLIF(ArticuloEsp,''), @Articulo) = @Articulo
AND Almacen = @Almacen
AND Estatus='ALTA' 
ELSE
INSERT @Resultado
SELECT Almacen, Posicion, Tipo, Descripcion, Pasillo, Fila, Nivel, ISNULL(NULLIF(Zona, ''), ''), Capacidad, Estatus, ArticuloEsp, Alto, Largo, Ancho, Volumen, PesoMaximo, Orden, TipoRotacion,
CASE WHEN Tipo = 'Ubicacion' AND ISNULL(Zona,'') = '' AND ISNULL(ArticuloEsp,'') = '' THEN 'Caótica'
WHEN Tipo = 'Ubicacion' AND ISNULL(Zona,'') <> '' AND ISNULL(ArticuloEsp,'') = '' THEN 'Semi Caótica'
ELSE 'Específica' END Subtipo
FROM AlmPos WITH(NOLOCK)
WHERE CASE WHEN @Tipo <> 'Surtido' AND Tipo IN('Domicilio')
THEN 1
ELSE 0
END = 1
AND ISNULL(NULLIF(ArticuloEsp,''), @Articulo) = @Articulo
AND Almacen = @Almacen
AND Estatus='ALTA' 
UNION ALL
SELECT Almacen, Posicion, Tipo, Descripcion, Pasillo, Fila, Nivel, ISNULL(NULLIF(Zona, ''), ''), Capacidad, Estatus, ArticuloEsp, Alto, Largo, Ancho, Volumen, PesoMaximo, Orden, TipoRotacion,
CASE WHEN Tipo = 'Ubicacion' AND ISNULL(Zona,'') = '' AND ISNULL(ArticuloEsp,'') = '' THEN 'Caótica'
WHEN Tipo = 'Ubicacion' AND ISNULL(Zona,'') <> '' AND ISNULL(ArticuloEsp,'') = '' THEN 'Semi Caótica'
ELSE 'Específica' END Subtipo
FROM AlmPos WITH(NOLOCK)
WHERE CASE WHEN (@Tipo <> 'Surtido' AND Tipo IN( 'Ubicacion', 'Surtido', 'Recibo'))
OR (@Tipo = 'Surtido' AND Tipo IN( 'Ubicacion', 'Domicilio'))
THEN 1
ELSE 0
END = 1
AND ISNULL(NULLIF(ArticuloEsp,''), @Articulo) = @Articulo
AND ISNULL(NULLIF(NULLIF(Zona, '(Todas)'), ''), '') IN  (SELECT ISNULL(Zona, '') FROM ArtZona WITH(NOLOCK) WHERE Articulo = @Articulo)
AND Almacen = @Almacen
AND Estatus='ALTA' 
UNION ALL
SELECT Almacen, Posicion, Tipo, Descripcion, Pasillo, Fila, Nivel, ISNULL(NULLIF(Zona, ''), ''), Capacidad, Estatus, ArticuloEsp, Alto, Largo, Ancho, Volumen, PesoMaximo, Orden, TipoRotacion,
CASE WHEN Tipo = 'Ubicacion' AND ISNULL(Zona,'') = '' AND ISNULL(ArticuloEsp,'') = '' THEN 'Caótica'
WHEN Tipo = 'Ubicacion' AND ISNULL(Zona,'') <> '' AND ISNULL(ArticuloEsp,'') = '' THEN 'Semi Caótica'
ELSE 'Específica' END Subtipo
FROM AlmPos WITH(NOLOCK)
WHERE 1 = CASE WHEN (@Tipo <> 'Surtido' AND Tipo IN( 'Ubicacion', 'Domicilio', 'Surtido', 'Recibo'))OR (@Tipo = 'Surtido' AND Tipo IN( 'Ubicacion', 'Domicilio')) THEN 1 ELSE 0 END
AND ISNULL(NULLIF(ArticuloEsp,''), @Articulo) = @Articulo
AND ISNULL(NULLIF(NULLIF(Zona, '(Todas)'), ''), '') = ''
AND Almacen = @Almacen
AND Estatus='ALTA' 
SELECT @MovTipo = Clave FROM TMA A WITH(NOLOCK) JOIN MOVTIPO B WITH(NOLOCK) ON A.Mov = B.Mov AND B.Modulo = 'TMA' WHERE A.ID = @TMAID
IF @ValidarCapacidad = 1 AND @TMAID IS NOT NULL
BEGIN
IF @MovTipo = 'TMA.SADO'
DELETE @Resultado
WHERE dbo.fnAlmPosTieneCapacidadWMS (@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 0
AND Tipo <> 'DOMICILIO'
IF @MovTipo <> 'TMA.SADO'
DELETE @Resultado
WHERE dbo.fnAlmPosTieneCapacidadWMS (@Empresa, @Almacen, Posicion, @Articulo, @TMAID, 0) = 0
END
INSERT @Resultado
SELECT Almacen, Posicion, Tipo, Descripcion, Pasillo, Fila, Nivel, ISNULL(NULLIF(Zona, ''), ''), Capacidad, Estatus, ArticuloEsp, Alto, Largo, Ancho, Volumen, PesoMaximo, Orden, TipoRotacion,
CASE WHEN Tipo = 'Ubicacion' AND ISNULL(Zona,'') = '' AND ISNULL(ArticuloEsp,'') = '' THEN 'Caótica'
WHEN Tipo = 'Ubicacion' AND ISNULL(Zona,'') <> '' AND ISNULL(ArticuloEsp,'') = '' THEN 'Semi Caótica'
ELSE 'Específica' END Subtipo
FROM AlmPos WITH(NOLOCK)
WHERE Tipo = 'Cross Docking'
AND Almacen = @Almacen
AND Estatus='ALTA' 
RETURN
END

