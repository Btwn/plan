SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMAFGenerarServicios
@Empresa		varchar(5),
@Sucursal		int,
@Accion			varchar(20),
@Usuario		varchar(10),
@ID			int,
@AFArticulo		varchar(20),
@AFSerie		varchar(50),
@Automatico		bit,
@Ok			int		OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
DECLARE	@Tipo			varchar(50),
@ActivoFID		int,
@Servicio		varchar(50),
@Unico			bit,
@Inspeccion		int,
@InspeccionUnidad	varchar(20),
@Resultado		bit,
@MAFCiclo			int 
SELECT @Tipo = Tipo, @ActivoFID = ID FROM ActivoF WITH(NOLOCK) WHERE Articulo = @AFArticulo AND Serie = @AFSerie
DECLARE crActivoFTipoServicio CURSOR FOR
SELECT afts.Servicio, afts.Unico, afts.Inspeccion, afts.InspeccionUnidad
FROM ActivoFTipoServicio afts WITH(NOLOCK)
WHERE afts.Tipo = @Tipo
OPEN crActivoFTipoServicio
FETCH NEXT FROM crActivoFTipoServicio INTO @Servicio, @Unico, @Inspeccion, @InspeccionUnidad
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SET @MAFCiclo = NULL 
EXEC spMAFCalcularActivoFTipoServicio @AFArticulo, @AFSerie, @Servicio, @Resultado OUTPUT, @Automatico, @MAFCiclo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT 
IF @Ok IS NULL AND @Resultado = 1
EXEC spMAFGenerarServicio @Empresa, @Sucursal, @Accion, @Usuario, @Servicio, @ID, @AFArticulo, @AFSerie, @MAFCiclo, @Ok OUTPUT, @OkRef OUTPUT 
FETCH NEXT FROM crActivoFTipoServicio INTO @Servicio, @Unico, @Inspeccion, @InspeccionUnidad
END
CLOSE crActivoFTipoServicio
DEALLOCATE crActivoFTipoServicio
END

