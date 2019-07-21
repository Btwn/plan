SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnAlmPosTieneCapacidad (@Empresa varchar(5), @Almacen varchar(10), @Posicion varchar(20), @Tarima varchar(20))
RETURNS bit

AS BEGIN
DECLARE
@Capacidad	int,
@Tarimas	int,
@Pendientes	int,
@Resultado	bit,
@Tipo	varchar(20)
SELECT @Resultado = 0, @Capacidad = 0, @Tarimas = 0, @Pendientes = 0
SELECT @Capacidad = Capacidad,
@Tipo = Tipo
FROM AlmPos WITH (NOLOCK)
WHERE Almacen = @Almacen AND Posicion = @Posicion
IF @Tipo = 'DOMICILIO'
SELECT @Tarimas = ISNULL(COUNT(*), 0)
FROM Tarima WITH (NOLOCK)
WHERE Almacen = @Almacen AND Posicion = @Posicion AND Estatus = 'ALTA' AND dbo.fnTarimaEnPuntoReorden(@Empresa, @Almacen, Tarima, dbo.fnArticuloEnTarima(@Empresa, Tarima)) = 0
ELSE
SELECT @Tarimas = ISNULL(COUNT(*), 0)
FROM Tarima WITH (NOLOCK)
WHERE Almacen = @Almacen AND Posicion = @Posicion AND Estatus = 'ALTA'
AND Tarima <> ISNULL(@Tarima, '')
SELECT @Pendientes = ISNULL(COUNT(*), 0)
FROM TMAD d WITH (NOLOCK)
JOIN TMA e WITH (NOLOCK) ON e.ID = d.ID AND e.Empresa = @Empresa AND e.Estatus = 'PENDIENTE'
JOIN MovTipo mt WITH (NOLOCK) ON mt.Modulo = 'TMA' AND mt.Mov = e.Mov AND mt.Clave IN ('TMA.SADO', 'TMA.OADO')
WHERE d.EstaPendiente = 1 AND d.PosicionDestino = @Posicion
IF @Capacidad > @Tarimas + @Pendientes SELECT @Resultado = 1
RETURN(@Resultado)
END

