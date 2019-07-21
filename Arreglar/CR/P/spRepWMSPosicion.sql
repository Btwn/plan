SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRepWMSPosicion
@Estacion		int

AS BEGIN
DECLARE
@Orden			varchar(20),
@Zona			varchar(50),
@Tipo			varchar(20),
@Estatus		varchar(15),
@Almacen		varchar(20),
@Articulo		varchar(20),
@Titulo			varchar(100)
SELECT @Orden		= InfoOrdenWMS,
@Zona		= InfoZona,
@Tipo		= InfoTipo,
@Estatus	= InfoEstatusTarima,
@Almacen	= InfoAlmacenWMS,
@Articulo	= InfoArticuloEsp,
@Titulo	= RepTitulo
FROM RepParam
WHERE Estacion = @Estacion
IF LEN(@Zona) = 0 OR @Zona = '(Todas)' OR @Zona = 'Todas' SET @Zona = NULL
IF LEN(@Tipo) = 0 OR @Tipo = '(Todos)' OR @Tipo = 'Todos' SET @Tipo = NULL
IF LEN(@Estatus) = 0 OR @Estatus = '(Todos)' OR @Estatus = 'Todos' SET @Estatus = NULL
IF LEN(@Almacen) = 0 OR @Almacen = '(Todos)' OR @Almacen = 'Todos' SET @Almacen = NULL
IF LEN(@Articulo) = 0 OR @Articulo = '(Todos)' OR @Articulo = 'Todos' SET @Articulo = NULL
SELECT ISNULL(p.Zona, '') as Zona, p.Tipo, t.Tarima, t.Posicion, p.Descripcion, p.Estatus, p.Pasillo, p.Fila, p.Nivel, a.Articulo, a.Descripcion1, p.Capacidad, p.Alto, p.Largo, p.Ancho, p.PesoMaximo, @Titulo as Titulo, p.Estatus
FROM Artdisponibletarima d
JOIN Art a ON a.Articulo = d.Articulo
JOIN Tarima t ON t.Tarima = d.Tarima AND t.Estatus = 'ALTA'
JOIN AlmPos p ON p.Posicion = t.Posicion
JOIN Alm l ON p.Almacen = l.Almacen AND l.WMS = 1
WHERE ISNULL(a.Articulo, '(Todos)') = ISNULL(@Articulo, ISNULL(a.Articulo, '(Todos)'))
AND ISNULL(p.Zona, '(Todos)') = ISNULL(@Zona, ISNULL(p.Zona, '(Todos)'))
AND ISNULL(p.Tipo, '(Todos)') = ISNULL(@Tipo, ISNULL(p.Tipo, '(Todos)'))
AND p.Estatus = ISNULL(@Estatus, p.Estatus)
AND ISNULL(p.Almacen, '(Todas)') = ISNULL(@Almacen, ISNULL(p.Almacen, '(Todas)'))
ORDER BY p.Zona, CASE @Orden WHEN 'Tarima' THEN d.Tarima WHEN 'Articulo' THEN d.Articulo WHEN 'Posición' THEN t.Posicion WHEN 'Fecha de Entrada' THEN CONVERT(varchar,t.Alta) WHEN 'Fecha de Caducidad' THEN CONVERT(varchar,t.FechaCaducidad) END
RETURN
END

