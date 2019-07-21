SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMAFActualizarIndicadorAF
@ID			int,
@FechaConclusion	datetime,
@Ok			int		OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
DECLARE	@ActivoFID		int,
@AFArticulo		varchar(20),
@AFSerie		varchar(50),
@Inspeccion		int,
@InspeccionUnidad	varchar(20),
@SiguienteInspeccion	datetime
SELECT @AFArticulo = AFArticulo, @AFSerie = AFSerie FROM Gestion WITH (NOLOCK)  WHERE ID = @ID
SELECT @ActivoFID = ID,  @Inspeccion = Inspeccion, @InspeccionUnidad = InspeccionUnidad FROM ActivoF  WITH (NOLOCK) WHERE Articulo = @AFArticulo AND Serie = @AFSerie
UPDATE ActivoFIndicador
SET Lectura = gafi.Lectura
FROM ActivoFIndicador afi WITH (NOLOCK)  JOIN GestionActivoFIndicador gafi WITH (NOLOCK) 
ON afi.Indicador = gafi.Indicador
WHERE afi.ActivoFID = @ActivoFID
AND gafi.ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
SET @SiguienteInspeccion = CASE @InspeccionUnidad
WHEN 'Dias'    THEN DATEADD(dd,@Inspeccion,@FechaConclusion)
WHEN 'Semanas' THEN DATEADD(ww,@Inspeccion,@FechaConclusion)
WHEN 'Meses'   THEN DATEADD(mm,@Inspeccion,@FechaConclusion)
WHEN 'Años'    THEN DATEADD(yy,@Inspeccion,@FechaConclusion)
END
UPDATE ActivoF SET UltimaInspeccion = @FechaConclusion, SiguienteInspeccion = @SiguienteInspeccion WHERE Articulo = @AFArticulo AND Serie = @AFSerie
END
END

