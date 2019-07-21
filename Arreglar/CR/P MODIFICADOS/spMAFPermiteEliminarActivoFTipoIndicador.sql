SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMAFPermiteEliminarActivoFTipoIndicador
@Tipo			varchar(50),
@ActivoFID		int,
@Indicador		varchar(50),
@DependeDe		varchar(20),
@Modo			varchar(20)

AS BEGIN
DECLARE	@AFArticulo		varchar(20),
@AFSerie		varchar(50)
IF @DependeDe = 'ActivoFTipo'
BEGIN
IF @Modo = 'Preguntar' IF NOT EXISTS(SELECT * FROM GestionActivoFIndicador WITH (NOLOCK)  WHERE RTRIM(Tipo) = RTRIM(@Tipo) AND RTRIM(Indicador) = RTRIM(@Indicador)) AND NOT EXISTS(SELECT * FROM ActivoFIndicador afi WITH (NOLOCK)  JOIN ACTIVOF af WITH (NOLOCK)  ON afi.ActivoFID = af.ID WHERE af.Tipo = @Tipo AND afi.Indicador = @Indicador) SELECT 1 ELSE SELECT 0 ELSE
IF @Modo = 'Eliminar'  IF NOT EXISTS(SELECT * FROM GestionActivoFIndicador WITH (NOLOCK)  WHERE RTRIM(Tipo) = RTRIM(@Tipo) AND RTRIM(Indicador) = RTRIM(@Indicador)) AND NOT EXISTS(SELECT * FROM ActivoFIndicador afi WITH (NOLOCK)  JOIN ACTIVOF af WITH (NOLOCK)  ON afi.ActivoFID = af.ID WHERE af.Tipo = @Tipo AND afi.Indicador = @Indicador) DELETE FROM ActivoFTipoIndicador   WHERE Tipo = @Tipo AND Indicador = @Indicador
END
ELSE
IF @DependeDe = 'ActivoF'
BEGIN
SELECT @AFArticulo = Articulo, @AFSerie = Serie FROM ActivoF WITH (NOLOCK)  WHERE ID = @ActivoFID
IF @Modo = 'Preguntar' IF NOT EXISTS(SELECT * FROM GestionActivoFIndicador gaf  WITH (NOLOCK) JOIN Gestion g  WITH (NOLOCK) ON gaf.ID = g.ID WHERE gaf.Indicador = @Indicador AND g.AFArticulo = @AFArticulo AND g.AFSerie = @AFSerie) SELECT 1 ELSE SELECT 0 ELSE
IF @Modo = 'Eliminar'  IF NOT EXISTS(SELECT * FROM GestionActivoFIndicador gaf  WITH (NOLOCK) JOIN Gestion g WITH (NOLOCK)  ON gaf.ID = g.ID WHERE gaf.Indicador = @Indicador AND g.AFArticulo = @AFArticulo AND g.AFSerie = @AFSerie) DELETE FROM ActivoFIndicador  WHERE ActivoFID = @ActivoFID AND Indicador = @Indicador
END
END

