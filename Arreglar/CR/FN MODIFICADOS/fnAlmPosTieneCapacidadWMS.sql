SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnAlmPosTieneCapacidadWMS (@Empresa varchar(5), @Almacen varchar(10), @Posicion varchar(20), @Articulo varchar(20), @TMAID int, @Verificar bit)
RETURNS bit

AS BEGIN
DECLARE
@Tarimas	int,
@Pendientes	int,
@Resultado	bit,
@Tipo	varchar(20),
@PesoTarima				float,
@VolumenTarima			float,
@Hoy					datetime,
@PesoMaximo				float,
@Volumen				float,
@Capacidad				int,
@Alta					datetime,
@WMSRotacionArticulo	bit,
@RotacionArt			varchar(10),
@RotacionAlmPos			varchar(10),
@ZonaPos				varchar(50),
@ArtPos					varchar(20),
@CantidadTarima			int,
@PermiteEstibar			bit,
@EstibaMaxima			int,
@EstibaMismaFecha		bit
SELECT @ZonaPos = ISNULL(Zona,''),
@ArtPos = ISNULL(ArticuloEsp,'')
FROM AlmPos WITH (NOLOCK)
WHERE Almacen = @Almacen
AND Posicion = @Posicion
SELECT @WMSRotacionArticulo = ISNULL(WMSRotacionArticulo, 0) FROM EmpresaCfg WITH (NOLOCK) WHERE Empresa = @Empresa
SELECT @Resultado		= 0,
@Capacidad		= 0,
@Tarimas		= 0,
@Pendientes	= 0,
@PesoTarima	= 0,
@VolumenTarima	= 0,
@Hoy			= NULL,
@PesoMaximo	= 0,
@Volumen		= 0,
@Alta			= NULL,
@RotacionArt	= '',
@RotacionAlmPos = '',
@Hoy			= dbo.fnFechaSinHora(GETDATE())
SELECT @PesoTarima		= PesoTarima,
@VolumenTarima		= VolumenTarima,
@PermiteEstibar	= ISNULL(PermiteEstibar,0),
@EstibaMismaFecha	= ISNULL(EstibaMismaFecha,0),
@EstibaMaxima		= ISNULL(EstibaMaxima,1)
FROM Art WITH (NOLOCK)
WHERE Articulo = @Articulo
IF @WMSRotacionArticulo = 1 AND @ZonaPos <> '' OR @WMSRotacionArticulo = 1 AND @ArtPos <> ''
BEGIN
SELECT @RotacionArt = ISNULL(TipoRotacion, '') FROM Art WITH (NOLOCK) WHERE Articulo = @Articulo
SELECT @RotacionAlmPos = ISNULL(TipoRotacion, '') FROM AlmPos WITH (NOLOCK) WHERE Posicion = @Posicion AND Almacen = @Almacen
END
IF EXISTS (SELECT * FROM ArtUnidad WITH (NOLOCK) WHERE Articulo = @Articulo)
SELECT TOP 1 @PesoTarima = Peso, @VolumenTarima = Volumen
FROM ArtUnidad WITH (NOLOCK)
WHERE Articulo = @Articulo AND	Factor = 1
SELECT @PesoMaximo = a.PesoMaximo, @Volumen = a.Volumen, @Capacidad = a.Capacidad, @Alta = ISNULL(dbo.fnFechaSinHora(t.Alta), @Hoy), @Tipo = a.Tipo
FROM AlmPos a WITH (NOLOCK)
LEFT OUTER JOIN Tarima t WITH (NOLOCK)
ON a.Posicion = t.Posicion
WHERE a.Posicion = @Posicion
AND a.Almacen = @Almacen
IF @PermiteEstibar = 1 AND @EstibaMaxima > 1 
BEGIN
SELECT @PesoMaximo = @PesoMaximo * @EstibaMaxima
SELECT @Volumen = @Volumen * @EstibaMaxima
END
IF @Tipo = 'DOMICILIO'
BEGIN
SELECT @Tarimas = ISNULL(COUNT(*), 0)
FROM Tarima t WITH (NOLOCK)
JOIN ArtDisponibleTarima a WITH (NOLOCK) ON t.Tarima = a.Tarima
WHERE t.Almacen = @Almacen AND t.Posicion = @Posicion AND t.Estatus = 'ALTA' AND t.Tarima NOT LIKE '%-%' AND a.Disponible > 0
SELECT @Pendientes = ISNULL(COUNT(*), 0)
FROM TMAD d WITH (NOLOCK)
JOIN TMA e WITH (NOLOCK) ON e.ID = d.ID AND e.Empresa = @Empresa AND e.Estatus IN('PENDIENTE')
JOIN MovTipo mt WITH (NOLOCK) ON mt.Modulo = 'TMA' AND mt.Mov = e.Mov AND mt.Clave IN ('TMA.SADO', 'TMA.SRADO')
WHERE d.EstaPendiente = 1
AND d.PosicionDestino = @Posicion
AND e.Mov <> (SELECT ISNULL(Origen,'') FROM TMA WITH (NOLOCK) WHERE ID = @TMAID)
AND e.MovID <> (SELECT ISNULL(OrigenID,'') FROM TMA WITH (NOLOCK) WHERE ID = @TMAID)
SELECT @Pendientes = @Pendientes + ISNULL(COUNT(*), 0)
FROM TMAD d WITH (NOLOCK)
JOIN TMA e WITH (NOLOCK) ON e.ID = d.ID AND e.Empresa = @Empresa AND e.Estatus IN('PENDIENTE')
JOIN MovTipo mt WITH (NOLOCK) ON mt.Modulo = 'TMA' AND mt.Mov = e.Mov AND mt.Clave IN ('TMA.OADO', 'TMA.ORADO')
WHERE d.EstaPendiente = 1
AND d.PosicionDestino = @Posicion
AND e.Mov <> (SELECT ISNULL(Origen,'') FROM TMA WITH (NOLOCK) WHERE ID = @TMAID)
AND e.MovID <> (SELECT ISNULL(OrigenID,'') FROM TMA WITH (NOLOCK) WHERE ID = @TMAID)
IF @Verificar = 0
SELECT @Pendientes = @Pendientes + COUNT(*) FROM TMAD WITH (NOLOCK) WHERE ID = @TMAID AND PosicionDestino = @Posicion AND CapacidadPosicion = 1
ELSE
SELECT @Pendientes = @Pendientes + COUNT(*) FROM TMAD WITH (NOLOCK) WHERE ID = @TMAID AND PosicionDestino = @Posicion
IF @Verificar = 0
IF 1 > @Tarimas + @Pendientes SELECT @Resultado = 1 ELSE SELECT @Resultado = 0
ELSE
IF 1 = @Tarimas + @Pendientes SELECT @Resultado = 1 ELSE SELECT @Resultado = 0
IF (SELECT m.Clave FROM MovTipo m WITH (NOLOCK) JOIN TMA t WITH (NOLOCK) ON m.Mov = t.Mov AND m.Modulo = 'TMA' WHERE t.id = @TMAID) IN ('TMA.SRADO', 'TMA.ORADO', 'TMA.RADO')
SELECT @Resultado = 1
RETURN(@Resultado)
END
ELSE
BEGIN
SELECT @CantidadTarima = ISNULL(Capacidad,0) FROM AlmPos WITH (NOLOCK) WHERE Almacen = @Almacen AND Posicion = @Posicion
SELECT @Tarimas = ISNULL(COUNT(*), 0) FROM Tarima WITH (NOLOCK) WHERE Almacen = @Almacen AND Posicion = @Posicion AND Estatus = 'ALTA'
SELECT @Pendientes = ISNULL(COUNT(*), 0)
FROM TMAD d WITH (NOLOCK)
JOIN TMA e WITH (NOLOCK) ON e.ID = d.ID AND e.Empresa = @Empresa AND e.Estatus IN('PENDIENTE')
JOIN MovTipo mt WITH (NOLOCK) ON mt.Modulo = 'TMA' AND mt.Mov = e.Mov AND mt.Clave IN ('TMA.SADO', 'TMA.SRADO')
WHERE d.EstaPendiente = 1
AND d.PosicionDestino = @Posicion
AND e.Mov <> (SELECT ISNULL(Origen,'') FROM TMA WITH (NOLOCK) WHERE ID = @TMAID)
AND e.MovID <> (SELECT ISNULL(OrigenID,'') FROM TMA WITH (NOLOCK) WHERE ID = @TMAID)
SELECT @Pendientes = @Pendientes + ISNULL(COUNT(*), 0)
FROM TMAD d WITH (NOLOCK)
JOIN TMA e WITH (NOLOCK) ON e.ID = d.ID AND e.Empresa = @Empresa AND e.Estatus IN('PENDIENTE')
JOIN MovTipo mt WITH (NOLOCK) ON mt.Modulo = 'TMA' AND mt.Mov = e.Mov AND mt.Clave IN ('TMA.OADO', 'TMA.ORADO')
WHERE d.EstaPendiente = 1
AND d.PosicionDestino = @Posicion
AND e.Mov <> (SELECT ISNULL(Origen,'') FROM TMA WITH (NOLOCK) WHERE ID = @TMAID)
AND e.MovID <> (SELECT ISNULL(OrigenID,'') FROM TMA WITH (NOLOCK) WHERE ID = @TMAID)
IF @Verificar = 0
SELECT @Pendientes = @Pendientes + COUNT(*) FROM TMAD WITH (NOLOCK) WHERE ID = @TMAID AND PosicionDestino = @Posicion AND CapacidadPosicion = 1
ELSE
SELECT @Pendientes = @Pendientes + COUNT(*) FROM TMAD WITH (NOLOCK) WHERE ID = @TMAID AND PosicionDestino = @Posicion
SELECT @PesoTarima		= @PesoTarima *		CASE WHEN (@Tarimas + @Pendientes + 0) = 0 THEN .999 ELSE (@Tarimas + @Pendientes + CASE WHEN @Verificar = 0 THEN 1 ELSE 0 END) END,
@VolumenTarima	= @VolumenTarima *	CASE WHEN (@Tarimas + @Pendientes + 0) = 0 THEN .999 ELSE (@Tarimas + @Pendientes + CASE WHEN @Verificar = 0 THEN 1 ELSE 0 END) END
IF @PermiteEstibar = 1
BEGIN
IF @Verificar = 0
IF @RotacionArt = @RotacionAlmPos  AND @PesoTarima  < @PesoMaximo AND @VolumenTarima < @Volumen SELECT @Resultado = 1 ELSE SELECT @Resultado = 0
ELSE
IF @RotacionArt = @RotacionAlmPos  AND @PesoTarima  <= @PesoMaximo AND @VolumenTarima <= @Volumen AND @Pendientes <> 0 SELECT @Resultado = 1 ELSE SELECT @Resultado = 0
END
IF @Verificar = 0
IF @RotacionArt = @RotacionAlmPos  AND @PesoTarima  <= @PesoMaximo AND @VolumenTarima <= @Volumen SELECT @Resultado = 1 ELSE SELECT @Resultado = 0
ELSE
IF @RotacionArt = @RotacionAlmPos  AND @PesoTarima  <= @PesoMaximo AND @VolumenTarima <= @Volumen AND @Pendientes <> 0 SELECT @Resultado = 1 ELSE SELECT @Resultado = 0
IF @EstibaMismaFecha = 1
BEGIN
IF @Verificar = 0
IF @RotacionArt = @RotacionAlmPos  AND @Hoy = @Alta AND @PesoTarima  <= @PesoMaximo AND @VolumenTarima <= @Volumen SELECT @Resultado = 1 ELSE SELECT @Resultado = 0
ELSE
IF @RotacionArt = @RotacionAlmPos  AND @Hoy = @Alta AND @PesoTarima  <= @PesoMaximo AND @VolumenTarima <= @Volumen AND @Pendientes <> 0 SELECT @Resultado = 1 ELSE SELECT @Resultado = 0
END
IF @Verificar = 0
IF (@CantidadTarima * CASE WHEN @PermiteEstibar = 1 AND @EstibaMaxima > 0 THEN @EstibaMaxima ELSE 1 END) > @Pendientes + @Tarimas AND @Resultado = 1
SELECT @Resultado = 1
ELSE
SELECT @Resultado = 0
ELSE
IF (@CantidadTarima * CASE WHEN @PermiteEstibar = 1 AND @EstibaMaxima > 0 THEN @EstibaMaxima ELSE 1 END) >= @Pendientes + @Tarimas AND @Resultado = 1
SELECT @Resultado = 1
ELSE
SELECT @Resultado = 0
END
RETURN(@Resultado)
END

