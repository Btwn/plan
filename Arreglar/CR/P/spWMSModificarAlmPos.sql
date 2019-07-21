SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSModificarAlmPos
@Almacen			varchar(20),
@Posicion			varchar(20),
@Articulo			varchar(20),
@Resultado			bit  = 0

AS BEGIN
DECLARE
@ArticuloOriginal		varchar(20),
@Tipo					varchar(20)
SELECT @ArticuloOriginal	= ArticuloEsp,
@Tipo				= Tipo
FROM AlmPos
WHERE Almacen = @Almacen
AND Posicion = @Posicion
IF EXISTS( SELECT *
FROM TMA w JOIN TMAD d
ON w.ID = d.ID JOIN ArtDisponibleTarima t
ON d.Tarima = t.Tarima JOIN MovTipo m
ON w.Mov = m.Modulo AND m.Modulo = 'TMA'
WHERE w.Estatus IN('PENDIENTE', 'PROCESAR')
AND 1 = CASE WHEN (@Tipo = 'Domicilio' AND t.Articulo = @Articulo) OR (@Tipo <> 'Domicilio' AND t.Articulo = @ArticuloOriginal) THEN 1 ELSE 0 END
AND m.Clave IN ('TMA.ADO', 'TMA.RADO', 'TMA.SUR', 'TMA.TSUR')
)
SELECT @Resultado = 1
SELECT @Resultado
END

