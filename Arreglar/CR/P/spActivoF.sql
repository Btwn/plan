SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spActivoF
@Sucursal			int,
@Empresa			char(5),
@Modulo                      char(5),
@Accion			char(20),
@EsEntrada			bit,
@EsSalida			bit,
@EsTransferencia		bit,
@ID  			int,
@RenglonID			int,
@Almacen			char(10),
@AlmacenDestino		char(10),
@Articulo                    char(20),
@ArtTipo			char(20),
@CantidadMovimiento 		float,
@ArtCosto			float,
@ArtMoneda			char(10),
@FechaEmision		datetime,
@Ok 				int		OUTPUT,
@OkRef 			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Serie		varchar(50),
@Cantidad		float,
@Categoria		varchar(50),
@VidaUtil		int,
@DepreciacionAnual	float,
@Periodicidad 	varchar(20),
@InicioDepreciacion	varchar(20),
@ActivoFID		int,
@ActivoFEstatus	char(15),
@ActivoFAlmacen	char(10),
@Inicio		datetime,
@InicioF	datetime,
@InicioF2	datetime,
@SiguienteAno	int,
@SiguienteAnoF	int,
@SiguienteAnoF2	int,
@AdquisicionFecha	datetime,
@ValorDesecho	money,
@VidaUtilF		int,
@DepreciacionAnualF		float,
@AdquisicionValorF		money,
@AdquisicionFechaF		datetime,
@DepreciacionInicioF	datetime,
@InicioDepreciacionF	varchar(20),
@ValorDesechoF			money,
@VidaUtilF2				int,
@DepreciacionAnualF2	float,
@InicioDepreciacionF2	varchar(20),
@AdquisicionValorF2		money,
@AdquisicionFechaF2		datetime,
@DepreciacionInicioF2	datetime,
@ValorDesechoF2			money,
@PorcentajeDeducible	float
EXEC spExtraerFecha @FechaEmision OUTPUT
DECLARE crSerieLoteMov CURSOR FOR
SELECT NULLIF(RTRIM(s.SerieLote), ''), ISNULL(s.Cantidad, 0.0), NULLIF(RTRIM(a.CategoriaActivoFijo), ''), cat.VidaUtil, NULLIF(cat.DepreciacionAnual, 0.0), cat.MantenimientoPeriodicidad, UPPER(cat.InicioDepreciacion), cat.ValorDesecho, cat.VidaUtilF, NULLIF(cat.DepreciacionAnualF, 0.0), UPPER(cat.InicioDepreciacionF), cat.ValorDesechoF, cat.VidaUtilF2, NULLIF(cat.DepreciacionAnualF2, 0.0), UPPER(cat.InicioDepreciacionF2), cat.ValorDesechoF2, ISNULL(PorcentajeDeducible,0.0)
FROM Art a
JOIN SerieLoteMov s ON a.Articulo = s.Articulo
LEFT OUTER JOIN ActivoFCat cat ON a.CategoriaActivoFijo = cat.Categoria
WHERE Empresa   = @Empresa
AND Modulo    = @Modulo
AND ID        = @ID
AND RenglonID = @RenglonID
AND s.Articulo  = @Articulo
OPEN crSerieLoteMov
FETCH NEXT FROM crSerieLoteMov INTO @Serie, @Cantidad, @Categoria, @VidaUtil, @DepreciacionAnual, @Periodicidad, @InicioDepreciacion, @ValorDesecho, @VidaUtilF, @DepreciacionAnualF, @InicioDepreciacionF, @ValorDesechoF, @VidaUtilF2, @DepreciacionAnualF2, @InicioDepreciacionF2, @ValorDesechoF2, @PorcentajeDeducible
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Inicio = DATEADD(day, -DATEPART(day, @FechaEmision)+1, @FechaEmision)
IF @InicioDepreciacion = 'SIGUIENTE MES' SELECT @Inicio = DATEADD(month, 1, @Inicio) ELSE
IF @InicioDepreciacion = 'SIGUIENTE AÑO'
BEGIN
SELECT @SiguienteAno = DATEPART(year, @FechaEmision)+ 1
EXEC spIntToDateTime 1, 1, @SiguienteAno, @Inicio OUTPUT
END
SELECT @InicioF = DATEADD(day, -DATEPART(day, @FechaEmision)+1, @FechaEmision)
IF @InicioDepreciacionF = 'SIGUIENTE MES' SELECT @InicioF = DATEADD(month, 1, @InicioF) ELSE
IF @InicioDepreciacionF = 'SIGUIENTE AÑO'
BEGIN
SELECT @SiguienteAnoF = DATEPART(year, @FechaEmision)+ 1
EXEC spIntToDateTime 1, 1, @SiguienteAnoF, @InicioF OUTPUT
END
SELECT @InicioF2 = DATEADD(day, -DATEPART(day, @FechaEmision)+1, @FechaEmision)
IF @InicioDepreciacionF2 = 'SIGUIENTE MES' SELECT @InicioF2 = DATEADD(month, 1, @InicioF2) ELSE
IF @InicioDepreciacionF2 = 'SIGUIENTE AÑO'
BEGIN
SELECT @SiguienteAnoF2 = DATEPART(year, @FechaEmision)+ 1
EXEC spIntToDateTime 1, 1, @SiguienteAnoF2, @InicioF2 OUTPUT
END
SELECT @ActivoFID = NULL, @ActivoFEstatus = NULL, @ActivoFAlmacen = NULL, @AdquisicionFecha = NULL
SELECT @ActivoFID = ID, @ActivoFEstatus = Estatus, @ActivoFAlmacen = Almacen, @AdquisicionFecha = AdquisicionFecha
FROM ActivoF
WHERE Empresa  = @Empresa
AND Articulo = @Articulo
AND Serie    = @Serie
IF @EsTransferencia = 1
BEGIN
IF @Almacen = @ActivoFAlmacen
UPDATE ActivoF SET Almacen = @AlmacenDestino WHERE ID = @ActivoFID
ELSE SELECT @Ok = 44040
END ELSE
IF @EsEntrada = 1
BEGIN
IF @ActivoFEstatus IS NULL
INSERT ActivoF (Sucursal,      Empresa,  Articulo,  Serie,  Moneda,     Almacen,  AdquisicionValor, AdquisicionValorF, AdquisicionValorF2, AdquisicionFecha, AdquisicionFechaF, AdquisicionFechaF2, DepreciacionInicio, DepreciacionInicioF, DepreciacionInicioF2, Categoria,  VidaUtil,  DepreciacionAnual,  MantenimientoPeriodicidad, ValorDesecho,  Estatus,  VidaUtilF,  DepreciacionAnualF,  ValorDesechoF,  VidaUtilF2,  DepreciacionAnualF2,  ValorDesechoF2,  PorcentajeDeducible)
VALUES (@Sucursal, @Empresa, @Articulo, @Serie, @ArtMoneda, @Almacen, @ArtCosto,        @ArtCosto,         @ArtCosto,          @FechaEmision,    @FechaEmision,     @FechaEmision,      @Inicio,            @InicioF,            @InicioF2,            @Categoria, @VidaUtil, @DepreciacionAnual, @Periodicidad,             @ValorDesecho, 'ACTIVO', @VidaUtilF, @DepreciacionAnualF, @ValorDesechoF, @VidaUtilF2, @DepreciacionAnualF2, @ValorDesechoF2, @PorcentajeDeducible)
ELSE
IF @ActivoFEstatus = 'INACTIVO'
BEGIN
IF @AdquisicionFecha IS NULL /** JH 24.11.2006 **/ AND @Accion <> 'CANCELAR'
UPDATE ActivoF
SET Almacen = @Almacen,
Categoria = @Categoria,
VidaUtil = @VidaUtil,
DepreciacionAnual = @DepreciacionAnual,
MantenimientoPeriodicidad = @Periodicidad,
AdquisicionValor = CASE @Accion WHEN 'CANCELAR' THEN AdquisicionValor ELSE @ArtCosto END,
AdquisicionFecha = @FechaEmision,
DepreciacionInicio = @Inicio,
Utilizacion = NULL,
DepreciacionAcum = NULL,
DepreciacionUltima = NULL,
ValorRevaluado = NULL,
RevaluacionUltima = NULL,
SeguroAcum = NULL,
ValorDesecho = @ValorDesecho,
Estatus = 'ACTIVO',
VidaUtilF = @VidaUtilF,
DepreciacionAnualF = @DepreciacionAnualF,
AdquisicionValorF = CASE @Accion WHEN 'CANCELAR' THEN AdquisicionValorF ELSE @ArtCosto END,
AdquisicionFechaF = @FechaEmision,
DepreciacionInicioF = @InicioF,
VidaUtilF2 = @VidaUtilF2,
DepreciacionAnualF2 = @DepreciacionAnualF2,
AdquisicionValorF2 = CASE @Accion WHEN 'CANCELAR' THEN AdquisicionValorF2 ELSE @ArtCosto END,
AdquisicionFechaF2 = @FechaEmision,
DepreciacionInicioF2 = @InicioF2,
PorcentajeDeducible = @PorcentajeDeducible
WHERE ID = @ActivoFID
ELSE
UPDATE ActivoF
SET Almacen = @Almacen,
Estatus = 'ACTIVO'
WHERE ID = @ActivoFID
END ELSE SELECT @Ok = 44020
END ELSE
IF @EsSalida = 1
BEGIN
IF @ActivoFEstatus = 'ACTIVO'
UPDATE ActivoF SET Estatus = 'INACTIVO', AdquisicionFecha = CASE WHEN @Accion = 'CANCELAR' THEN NULL ELSE AdquisicionFecha END, AdquisicionFechaF = CASE WHEN @Accion = 'CANCELAR' THEN NULL ELSE AdquisicionFechaF END, AdquisicionFechaF2 = CASE WHEN @Accion = 'CANCELAR' THEN NULL ELSE AdquisicionFechaF2 END WHERE ID = @ActivoFID
ELSE SELECT @Ok = 44030
END
END
FETCH NEXT FROM crSerieLoteMov INTO @Serie, @Cantidad, @Categoria, @VidaUtil, @DepreciacionAnual, @Periodicidad, @InicioDepreciacion, @ValorDesecho, @VidaUtilF, @DepreciacionAnualF, @InicioDepreciacionF, @ValorDesechoF, @VidaUtilF2, @DepreciacionAnualF2, @InicioDepreciacionF2, @ValorDesechoF2, @PorcentajeDeducible
IF @@ERROR <> 0 SELECT @Ok = 1
END
CLOSE crSerieLoteMov
DEALLOCATE crSerieLoteMov
IF @Ok IS NOT NULL
SELECT @OkRef = RTRIM(@Articulo)+' - '+RTRIM(@Serie)
RETURN
END

