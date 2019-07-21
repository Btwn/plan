SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMAFCalcularActivoFTipoServicio
@AFArticulo		varchar(20),
@AFSerie		varchar(50),
@Servicio		varchar(50),
@Resultado		bit		OUTPUT,
@Automatico		bit,
@MAFCiclo			int		OUTPUT, 
@Ok			int		OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
DECLARE	@Tipo			varchar(50),
@ActivoFID		int,
@Indicador		varchar(50),
@Lectura		varchar(100),
@ResultadoCondicion	bit,
@SQL			nvarchar(MAX),
@Operador		varchar(1),
@ResultadoOperador	varchar(5),
@RetornoEjecucion	int,
@TotalCondiciones	int,
@Contador		int,
@CaracterNulo		varchar(1)
SELECT @Tipo = Tipo, @ActivoFID = ID FROM ActivoF WHERE Articulo = @AFArticulo AND Serie = @AFSerie
SELECT @TotalCondiciones = Count(*)
FROM ActivoFTipoServicioCondicion aftsc
WHERE aftsc.Tipo = @Tipo AND aftsc.Servicio = @Servicio
SET @Contador = 1
SET @CaracterNulo = 'X'
SET @SQL = 'SET @Resultado = CASE '
DECLARE crActivoFTipoServicioCondicion CURSOR FOR
SELECT aftsc.Indicador, afi.Lectura
FROM ActivoFTipoServicioCondicion aftsc JOIN ActivoFIndicador afi
ON aftsc.Indicador = afi.Indicador
WHERE afi.ActivoFID = @ActivoFID AND aftsc.Tipo = @Tipo AND aftsc.Servicio = @Servicio
ORDER BY aftsc.Orden
OPEN crActivoFTipoServicioCondicion
FETCH NEXT FROM crActivoFTipoServicioCondicion INTO @Indicador, @Lectura
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
EXEC spMAFCalcularActivoFTipoServicioCondicion @AFArticulo, @AFSerie, @Indicador, @Servicio, @Lectura, @ResultadoCondicion OUTPUT, @Operador OUTPUT, @Automatico, @MAFCiclo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT 
IF @Contador = @TotalCondiciones AND NULLIF(@Operador,'') IS NOT NULL SELECT @Ok = 10060, @OkRef = 'Operador incorrecto. Servicio:' + @Servicio
IF @Contador = @TotalCondiciones SET @CaracterNulo = ''
SET @ResultadoOperador =
CASE LTRIM(RTRIM(UPPER(@Operador)))
WHEN 'Y' THEN ' & '
WHEN 'O' THEN ' | '
WHEN ''  THEN @CaracterNulo
END
IF @ResultadoOperador = 'X' SELECT @Ok = 10060, @OkRef = 'Operador incorrecto. Servicio:' + @Servicio
SET @SQL = @SQL + RTRIM(CONVERT(varchar,@ResultadoCondicion)) + ISNULL(@ResultadoOperador,'')
SET @Contador = @Contador + 1
FETCH NEXT FROM crActivoFTipoServicioCondicion INTO @Indicador, @Lectura
END
CLOSE crActivoFTipoServicioCondicion
DEALLOCATE crActivoFTipoServicioCondicion
IF @Ok IS NULL
BEGIN
SET @SQL = @SQL + ' WHEN 1 THEN 1 ELSE 0 END'
EXEC @RetornoEjecucion = sp_executesql @SQL, N'@Resultado bit OUTPUT', @Resultado = @Resultado OUTPUT
IF @RetornoEjecucion <> 0 SELECT @Ok = 1
END
IF @Ok IS NULL AND @Resultado = 1
BEGIN
IF EXISTS(SELECT * FROM MAFServicioAbierto WHERE AFArticulo = @AFArticulo AND AFSerie = @AFSerie AND ServicioTipo = @Servicio) OR EXISTS(SELECT * FROM MAFServicioUnico WHERE AFArticulo = @AFArticulo AND AFSerie = @AFSerie AND ServicioTipo = @Servicio)
OR EXISTS(SELECT * FROM MAFServicioCiclico WHERE AFArticulo = @AFArticulo AND AFSerie = @AFSerie AND ServicioTipo = @Servicio AND MAFCiclo = @MAFCiclo)
SET @Resultado = 0
END
END

