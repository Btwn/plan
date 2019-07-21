SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spActivoFijoAfectar
@ID                		int,
@Accion			char(20),
@Empresa	      		char(5),
@Modulo	      		char(5),
@Mov	  	      		char(20),
@MovID             		varchar(20)	OUTPUT,
@MovTipo     		char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaEmision      		datetime,
@FechaAfectacion      	datetime,
@FechaConclusion		datetime,
@Condicion			varchar(50),
@Vencimiento			datetime,
@Proyecto	      		varchar(50),
@Usuario	      		char(10),
@Autorizacion      		char(10),
@DocFuente	      		int,
@Observaciones     		varchar(255),
@Concepto			varchar(50),
@Estatus           		char(15),
@EstatusNuevo	      	char(15),
@FechaRegistro     		datetime,
@Ejercicio	      		int,
@Periodo	      		int,
@Proveedor			char(10),
@Personal			char(10),
@Espacio			char(10),
@ContUso			varchar(20),
@ContUso2		varchar(20),
@ContUso3		varchar(20),
@FormaPago			varchar(50),
@CtaDinero			char(10),
@Todo			bit,
@Revaluar			bit,
@ValorMercado		bit,
@FechaRegistroAnterior	datetime,
@Conexion			bit,
@SincroFinal			bit,
@Sucursal			int,
@SucursalDestino		int,
@SucursalOrigen		int,
@CfgTabla			varchar(50),
@CfgAfectarDinero		bit,
@CfgContX			bit,
@CfgContXGenerar		char(20),
@GenerarPoliza		bit,
@GenerarMov			char(20),
@IDGenerar			int	     	OUTPUT,
@GenerarMovID	  	varchar(20)	OUTPUT,
@AFGenerarGasto		bit,
@AFGenerarGastoCfg	varchar(20),
@Ok                		int          OUTPUT,
@OkRef             		varchar(255) OUTPUT,
@SubClave			varchar(20) = NULL,
@SubClaveFiscal		int	    = NULL

AS BEGIN
DECLARE
@a					int,
@DineroMov				char(20),
@DineroMovID			varchar(20),
@Generar				bit,
@GenerarAfectado			bit,
@GenerarModulo			char(5),
@GenerarMovTipo			char(20),
@GenerarEstatus			char(15),
@GenerarPeriodo 			int,
@GenerarEjercicio 			int,
@Articulo				char(20),
@ArtMoneda				char(10),
@ArtTipoCambio			float,
@ArtFactor				float,
@Serie				varchar(50),
@Horas				float,
@Importe				money,
@Impuestos				money,
@NuevoValor				money,
@ArtImporte    			money,
@SumaImporte			money,
@SumaImpuestos			money,
@SumaDepreciacion			money,
@ImporteTotal			money,
@FechaCancelacion			datetime,
@AdquisicionFecha			datetime,
@AdquisicionValor			money,
@AdquisicionPeridodo 		int,
@AdquisicionEjercicio 		int,
@AdquisicionIndice			float,
@DepreciacionInicio 		datetime,
@DepreciacionPeridodo 		int,
@DepreciacionEjercicio 		int,
@DepreciacionIndice			float,
@DepreciacionUltima			datetime,
@DepreciacionUltimaPeridodo 	int,
@DepreciacionUltimaEjercicio 	int,
@DepreciacionUltimaIndice		float,
@FechaEmisionIndice			float,
@RevaluacionUltima			datetime,
@RevaluacionPeridodo 		int,
@RevaluacionEjercicio 		int,
@RevaluacionIndice			float,
@Revaluacion			money,
@ValorRevaluado			money,
@DepreciacionAcum			money,
@ActualizacionCapital		money,
@ActualizacionGastos		money,
@ActualizacionDepreciacion		money,
@Depreciacion			money,
@DepreciacionPorcentaje		float,
@MesesDepreciados			int,
@Dias				int,
@MesesDepreciado			int,
@ValorAnterior			money,
@ValorActual			money,
@ValorDesecho			money,
@DepreciacionAnterior		datetime,
@RevaluacionAnterior		datetime,
@ReparacionAnterior			datetime,
@MantenimientoAnterior		datetime,
@MantenimientoSiguiente		datetime,
@MantenimientoSiguienteAnt		datetime,
@MantenimientoPeriodicidad 		varchar(20),
@PolizaMantenimientoAnterior 	datetime,
@PolizaSeguroAnterior		datetime,
@EsDevolucion			bit,
@DepreciacionFecha			datetime,
@DepreciacionMeses			int,
@DepreciacionAnual			float,
@VidaUtil				int,
@Inflacion				float,
@Factor				float,
@IDActivoF				int,
@IDAnterior				int,
@Categoria				varchar(50),
@CategoriaVidaUtil			int,
@CategoriaDepreciacionAnualAjustada	bit,
@CategoriaMetodoDepreciacion	varchar(50),
@SumaDigitos			float,
@MovTipoGenerarGasto	bit,
@AFMovGenerarGastoCfg	varchar(20)
SELECT @Generar 		= 0,
@GenerarAfectado	= 0,
@IDGenerar		= NULL,
@GenerarModulo		= NULL,
@GenerarMovID	        = NULL,
@GenerarMovTipo        = NULL,
@GenerarEstatus 	= 'SINAFECTAR'
SELECT @MovTipoGenerarGasto	= ISNULL(GenerarGasto, 0),
@AFMovGenerarGastoCfg	= AFMovGenerarGastoCfg
FROM MovTipo
WHERE Modulo = @Modulo
AND Mov	= @Mov
IF @MovTipo IN ('AF.PM', 'AF.PS')
EXEC spCalcularVencimiento 'CXP', @Empresa, @Proveedor, @Condicion, @FechaEmision, @Vencimiento OUTPUT, @Dias OUTPUT, @Ok OUTPUT
EXEC spMovConsecutivo @Sucursal, @SucursalOrigen, @SucursalDestino, @Empresa, @Usuario, @Modulo, @Ejercicio, @Periodo, @ID, @Mov, NULL, @Estatus, @Concepto, @Accion, @Conexion, @SincroFinal, @MovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR') AND @Accion <> 'CANCELAR' AND @Ok IS NULL
EXEC spMovChecarConsecutivo	@Empresa, @Modulo, @Mov, @MovID, NULL, @Ejercicio, @Periodo, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion IN ('CONSECUTIVO', 'SINCRO') AND @Ok IS NULL
BEGIN
IF @Accion = 'SINCRO' EXEC spAsignarSucursalEstatus @ID, @Modulo, @SucursalDestino, @Accion
SELECT @Ok = 80060, @OkRef = @MovID
RETURN
END
IF @Accion = 'AFECTAR' AND @Ok IS NULL
BEGIN
IF EXISTS(SELECT Articulo, Serie, COUNT(*) FROM ActivoFijoD WHERE ID = @ID GROUP BY Articulo, Serie HAVING COUNT(*) > 1)
BEGIN
SELECT TOP 1 'Artículo Duplicado: <BR>Art.:'+ Articulo+' Serie: '+Serie FROM ActivoFijoD WHERE ID = @ID GROUP BY Articulo, Serie HAVING COUNT(*) > 1
SELECT @Ok = 10245
END
END
IF @OK IS NOT NULL RETURN
IF @Accion = 'GENERAR' AND @Ok IS NULL
BEGIN
EXEC spMovGenerar @Sucursal, @Empresa, @Modulo, @Ejercicio, @Periodo, @Usuario, @FechaRegistro, @GenerarEstatus,
NULL, NULL,
@Mov, @MovID, 0,
@GenerarMov, NULL, @GenerarMovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spMovTipo @Modulo, @GenerarMov, @FechaAfectacion, @Empresa, NULL, NULL, @GenerarMovTipo OUTPUT, @GenerarPeriodo OUTPUT, @GenerarEjercicio OUTPUT, @Ok OUTPUT
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Ok IS NULL SELECT @Ok = 80030
RETURN
END
IF @OK IS NOT NULL RETURN
IF @Conexion = 0
BEGIN TRANSACTION
EXEC spMovEstatus @Modulo, 'AFECTANDO', @ID, @Generar, @IDGenerar, @GenerarAfectado, @Ok OUTPUT
IF @Accion = 'AFECTAR' AND @Estatus = 'SINAFECTAR'
IF (SELECT Sincro FROM Version) = 1
EXEC sp_executesql N'UPDATE ActivoFijoD SET Sucursal = @Sucursal, SincroC = 1 WHERE ID = @ID AND (Sucursal <> @Sucursal OR SincroC <> 1)', N'@Sucursal int, @ID int', @Sucursal, @ID
IF @Accion <> 'CANCELAR'
EXEC spRegistrarMovimiento @Sucursal, @Empresa, @Modulo, @Mov, @MovID, @ID, @Ejercicio, @Periodo, @FechaRegistro, @FechaEmision,
NULL, @Proyecto, @MovMoneda, @MovTipoCambio,
@Usuario, @Autorizacion, NULL, @DocFuente, @Observaciones,
@Generar, @GenerarMov, @GenerarMovID, @IDGenerar,
@Ok OUTPUT
IF @MovTipo IN ('AF.DP', 'AF.RV') AND @Todo = 1 AND @Estatus = 'SINAFECTAR' AND @Accion <> 'CANCELAR'
EXEC spActivoFijoCopiarTodo @Sucursal, @Empresa, @ID, @MovTipo, @MovMoneda, @FechaEmision, @Ok OUTPUT, @SubClave = @SubClave, @SubClaveFiscal = @SubClaveFiscal
IF @MovTipo = 'AF.RV' OR (@MovTipo IN ('AF.DP', 'AF.DT') AND @Revaluar = 1)
EXEC spTablaAnual @CfgTabla, @Ejercicio, @Periodo, 1, @FechaEmisionIndice OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion = 'CANCELAR'
BEGIN
SELECT @IDAnterior = NULL
IF @MovTipo IN ('AF.DP', 'AF.DT')
SELECT @IDAnterior = MIN(af.ID)
FROM ActivoFijo af, ActivoFijoD d, ActivoFijoD da, MovTipo mt
WHERE af.Mov=mt.Mov
AND af.Empresa = @Empresa
AND mt.Modulo = 'AF'
AND mt.clave IN ('AF.DP', 'AF.DT')
AND af.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND af.FechaRegistro > @FechaRegistroAnterior
AND d.ID = af.ID
AND da.ID = @ID AND da.Articulo = d.Articulo AND da.Serie = d.Serie
ELSE
SELECT @IDAnterior = MIN(af.ID)
FROM ActivoFijo af, ActivoFijoD d, ActivoFijoD da, MovTipo mt
WHERE af.Mov=mt.Mov
AND af.Empresa = @Empresa
AND mt.Modulo = 'AF'
AND mt.clave = @MovTipo
AND af.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND af.FechaRegistro > @FechaRegistroAnterior
AND d.ID = af.ID
AND da.ID = @ID AND da.Articulo = d.Articulo AND da.Serie = d.Serie
IF @IDAnterior IS NOT NULL AND @MovTipo NOT IN ('AF.MA', 'AF.PM', 'AF.PS', 'AF.RE')
SELECT @Ok = 60190, @OkRef = RTRIM(Mov)+' '+RTRIM(MovID) FROM ActivoFijo WHERE ID = @IDAnterior
END
SELECT @SumaImporte      = 0.0,
@SumaImpuestos    = 0.0,
@SumaDepreciacion = 0.0
IF @SubClaveFiscal = 1
DECLARE crActivoFijo CURSOR FOR
SELECT NULLIF(RTRIM(d.Articulo), ''), NULLIF(RTRIM(d.Serie), ''), ISNULL(d.Importe, 0.0), ISNULL(d.Impuestos, 0.0), ISNULL(d.Horas, 0.0),
ISNULL(d.Depreciacion, 0.0), ISNULL(d.MesesDepreciados, 0), ISNULL(d.NuevoValor, 0.0), ISNULL(d.Inflacion, 0.0), ISNULL(d.ActualizacionCapital, 0.0), ISNULL(d.ActualizacionGastos, 0.0), ISNULL(d.ActualizacionDepreciacion, 0.0),
ISNULL(d.ValorAnterior, 0.0), d.DepreciacionAnterior, d.RevaluacionAnterior, d.ReparacionAnterior, d.MantenimientoAnterior, d.MantenimientoSiguienteAnterior, d.PolizaMantenimientoAnterior, d.PolizaSeguroAnterior,
NULLIF(RTRIM(af.Moneda), ''), af.AdquisicionFechaF, af.DepreciacionInicioF, ISNULL(af.AdquisicionValorF, 0.0), ISNULL(af.ValorRevaluadoF, 0.0), ISNULL(af.DepreciacionAcumF, 0.0), af.DepreciacionUltimaF, af.RevaluacionUltimaF, ISNULL(af.VidaUtilF, 0), ISNULL(af.DepreciacionAnualF, 0), ISNULL(af.DepreciacionMesesF, 0), NULLIF(RTRIM(af.MantenimientoPeriodicidad), ''), af.ID, af.Categoria, af.ValorDesechoF
FROM ActivoFijoD d, Art a, ActivoF af
WHERE d.ID = @ID
AND d.Articulo = a.Articulo
AND d.Articulo = af.Articulo
AND d.Serie    = af.Serie
AND af.Empresa = @Empresa
ELSE
IF @SubClaveFiscal = 2
DECLARE crActivoFijo CURSOR FOR
SELECT NULLIF(RTRIM(d.Articulo), ''), NULLIF(RTRIM(d.Serie), ''), ISNULL(d.Importe, 0.0), ISNULL(d.Impuestos, 0.0), ISNULL(d.Horas, 0.0),
ISNULL(d.Depreciacion, 0.0), ISNULL(d.MesesDepreciados, 0), ISNULL(d.NuevoValor, 0.0), ISNULL(d.Inflacion, 0.0), ISNULL(d.ActualizacionCapital, 0.0), ISNULL(d.ActualizacionGastos, 0.0), ISNULL(d.ActualizacionDepreciacion, 0.0),
ISNULL(d.ValorAnterior, 0.0), d.DepreciacionAnterior, d.RevaluacionAnterior, d.ReparacionAnterior, d.MantenimientoAnterior, d.MantenimientoSiguienteAnterior, d.PolizaMantenimientoAnterior, d.PolizaSeguroAnterior,
NULLIF(RTRIM(af.Moneda), ''), af.AdquisicionFechaF2, af.DepreciacionInicioF2, ISNULL(af.AdquisicionValorF2, 0.0), ISNULL(af.ValorRevaluadoF2, 0.0), ISNULL(af.DepreciacionAcumF2, 0.0), af.DepreciacionUltimaF2, af.RevaluacionUltimaF2, ISNULL(af.VidaUtilF2, 0), ISNULL(af.DepreciacionAnualF2, 0), ISNULL(af.DepreciacionMesesF2, 0), NULLIF(RTRIM(af.MantenimientoPeriodicidad), ''), af.ID, af.Categoria, af.ValorDesechoF2
FROM ActivoFijoD d, Art a, ActivoF af
WHERE d.ID = @ID
AND d.Articulo = a.Articulo
AND d.Articulo = af.Articulo
AND d.Serie    = af.Serie
AND af.Empresa = @Empresa
ELSE
DECLARE crActivoFijo CURSOR FOR
SELECT NULLIF(RTRIM(d.Articulo), ''), NULLIF(RTRIM(d.Serie), ''), ISNULL(d.Importe, 0.0), ISNULL(d.Impuestos, 0.0), ISNULL(d.Horas, 0.0),
ISNULL(d.Depreciacion, 0.0), ISNULL(d.MesesDepreciados, 0), ISNULL(d.NuevoValor, 0.0), ISNULL(d.Inflacion, 0.0), ISNULL(d.ActualizacionCapital, 0.0), ISNULL(d.ActualizacionGastos, 0.0), ISNULL(d.ActualizacionDepreciacion, 0.0),
ISNULL(d.ValorAnterior, 0.0), d.DepreciacionAnterior, d.RevaluacionAnterior, d.ReparacionAnterior, d.MantenimientoAnterior, d.MantenimientoSiguienteAnterior, d.PolizaMantenimientoAnterior, d.PolizaSeguroAnterior,
NULLIF(RTRIM(af.Moneda), ''), af.AdquisicionFecha, af.DepreciacionInicio, ISNULL(af.AdquisicionValor, 0.0), ISNULL(af.ValorRevaluado, 0.0), ISNULL(af.DepreciacionAcum, 0.0), af.DepreciacionUltima, af.RevaluacionUltima, ISNULL(af.VidaUtil, 0), ISNULL(af.DepreciacionAnual, 0), ISNULL(af.DepreciacionMeses, 0), NULLIF(RTRIM(af.MantenimientoPeriodicidad), ''), af.ID, af.Categoria, af.ValorDesecho
FROM ActivoFijoD d, Art a, ActivoF af
WHERE d.ID = @ID
AND d.Articulo = a.Articulo
AND d.Articulo = af.Articulo
AND d.Serie    = af.Serie
AND af.Empresa = @Empresa
OPEN crActivoFijo
FETCH NEXT
FROM crActivoFijo
INTO @Articulo, @Serie, @Importe, @Impuestos, @Horas,
@Depreciacion, @MesesDepreciados, @NuevoValor, @Inflacion, @ActualizacionCapital, @ActualizacionGastos, @ActualizacionDepreciacion,
@ValorAnterior, @DepreciacionAnterior, @RevaluacionAnterior, @ReparacionAnterior, @MantenimientoAnterior, @MantenimientoSiguienteAnt, @PolizaMantenimientoAnterior, @PolizaSeguroAnterior,
@ArtMoneda, @AdquisicionFecha, @DepreciacionInicio, @AdquisicionValor, @ValorRevaluado, @DepreciacionAcum, @DepreciacionUltima, @RevaluacionUltima, @VidaUtil, @DepreciacionAnual, @DepreciacionMeses, @MantenimientoPeriodicidad, @IDActivoF, @Categoria, @ValorDesecho
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @MovTipo NOT IN ('AF.A', 'AF.D') AND @Articulo IS NOT NULL AND @Serie IS NOT NULL AND @Ok IS NULL
BEGIN
IF @SubClaveFiscal = 1
SELECT @CategoriaMetodoDepreciacion = UPPER(MetodoDepreciacionF), @CategoriaVidaUtil = VidaUtilF, @CategoriaDepreciacionAnualAjustada = ISNULL(DepreciacionAnualAjustadaF, 0) FROM ActivoFCat WHERE Categoria = @Categoria
ELSE
IF @SubClaveFiscal = 2
SELECT @CategoriaMetodoDepreciacion = UPPER(MetodoDepreciacionF2), @CategoriaVidaUtil = VidaUtilF2, @CategoriaDepreciacionAnualAjustada = ISNULL(DepreciacionAnualAjustadaF2, 0) FROM ActivoFCat WHERE Categoria = @Categoria
ELSE
SELECT @CategoriaMetodoDepreciacion = UPPER(MetodoDepreciacion), @CategoriaVidaUtil = VidaUtil, @CategoriaDepreciacionAnualAjustada = ISNULL(DepreciacionAnualAjustada, 0) FROM ActivoFCat WHERE Categoria = @Categoria
EXEC spMoneda NULL, @MovMoneda, @MovTipoCambio, @ArtMoneda, @ArtFactor OUTPUT, @ArtTipoCambio OUTPUT, @Ok OUTPUT
SELECT @ArtImporte = @Importe / @ArtFactor
IF @ValorRevaluado > 0 SELECT @ValorActual = @ValorRevaluado ELSE SELECT @ValorActual = @AdquisicionValor
SELECT @ValorActual = @ValorActual - ISNULL(@ValorDesecho, 0.0)
IF @Accion <> 'CANCELAR'
BEGIN
IF @MovTipo = 'AF.RV' AND @RevaluacionUltima >= @FechaEmision SELECT @Ok = 44120
IF @MovTipo = 'AF.RV' OR (@MovTipo IN ('AF.DP', 'AF.DT') AND @Revaluar = 1)
BEGIN
IF @SubClaveFiscal = 1
SELECT @ValorAnterior = ValorRevaluadoF, @RevaluacionAnterior = RevaluacionUltimaF FROM ActivoF WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie
ELSE
IF @SubClaveFiscal = 2
SELECT @ValorAnterior = ValorRevaluadoF2, @RevaluacionAnterior = RevaluacionUltimaF2 FROM ActivoF WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie
ELSE
SELECT @ValorAnterior = ValorRevaluado, @RevaluacionAnterior = RevaluacionUltima FROM ActivoF WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie
END
IF @MovTipo IN ('AF.DP', 'AF.DT')
BEGIN
IF @SubClaveFiscal = 1
SELECT @DepreciacionAnterior = DepreciacionUltimaF FROM ActivoF WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie
ELSE
IF @SubClaveFiscal = 2
SELECT @DepreciacionAnterior = DepreciacionUltimaF2 FROM ActivoF WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie
ELSE
SELECT @DepreciacionAnterior = DepreciacionUltima FROM ActivoF WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie
END
IF @MovTipo = 'AF.RE' SELECT @ReparacionAnterior = ReparacionUltima FROM ActivoF WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie ELSE
IF @MovTipo = 'AF.MA' SELECT @MantenimientoAnterior = MantenimientoUltimo, @MantenimientoSiguienteAnt = MantenimientoSiguiente FROM ActivoF WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie ELSE
IF @MovTipo = 'AF.PM' SELECT @PolizaMantenimientoAnterior = MantenimientoVence FROM ActivoF WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie ELSE
IF @MovTipo = 'AF.PS' SELECT @PolizaSeguroAnterior = SeguroVence FROM ActivoF WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie
IF @MovTipo IN ('AF.DP', 'AF.DT', 'AF.RV')
BEGIN
SELECT @DepreciacionFecha = @FechaEmision
IF @MovTipo IN ('AF.DP', 'AF.DT')
BEGIN
IF @MovTipo = 'AF.DT'
SELECT @MesesDepreciados = @VidaUtil - @DepreciacionMeses
ELSE
SELECT @MesesDepreciados = DATEDIFF(month, ISNULL(@DepreciacionUltima, DATEADD(month, -1, @DepreciacionInicio)), @FechaEmision)
IF @MesesDepreciados < 0 SELECT @MesesDepreciados = 0
IF @MesesDepreciados > (@VidaUtil - @DepreciacionMeses)
BEGIN
SELECT @DepreciacionFecha = DATEADD(month, @VidaUtil - @DepreciacionMeses - @MesesDepreciados, @FechaEmision)
SELECT @MesesDepreciados = (@VidaUtil - @DepreciacionMeses)
END
IF @MesesDepreciados < 0 AND @MovTipo <> 'AF.RV' SELECT @Ok = 44100
END ELSE
IF @MovTipo = 'AF.RV'
BEGIN
SELECT @MesesDepreciados = DATEDIFF(month, ISNULL(@RevaluacionUltima, DATEADD(month, -1, @DepreciacionInicio)), @FechaEmision)
IF @MesesDepreciados < 0 SELECT @MesesDepreciados = 0
END
EXEC spPeriodoEjercicio @Empresa, @Modulo, @DepreciacionFecha, @DepreciacionPeridodo OUTPUT, @DepreciacionEjercicio OUTPUT, @Ok OUTPUT
IF @MovTipo = 'AF.RV' OR (@MovTipo IN ('AF.DP', 'AF.DT') AND @Revaluar = 1)
EXEC spTablaAnual @CfgTabla, @DepreciacionEjercicio, @DepreciacionPeridodo, 1, @DepreciacionIndice OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
SELECT @DepreciacionPorcentaje = NULL, @Depreciacion = NULL
IF /*@MovTipo IN ('AF.DP', 'AF.DT') AND */@MesesDepreciados > 0
BEGIN
IF @CategoriaMetodoDepreciacion = 'SUMA DIGITOS'
BEGIN
SELECT @SumaDigitos = dbo.fnSumaDigitos(@CategoriaVidaUtil)
SELECT @DepreciacionPorcentaje = 0.0, @a = 0
WHILE @a<@MesesDepreciados
BEGIN
SELECT @DepreciacionPorcentaje = @DepreciacionPorcentaje + (((@VidaUtil - @DepreciacionMeses - @a) / @SumaDigitos)* 100.0)
SELECT @a = @a + 1
END
END ELSE
BEGIN
IF @DepreciacionAnual = 0.0 
SELECT @DepreciacionPorcentaje = 100.0 / @VidaUtil
ELSE BEGIN
IF @CategoriaDepreciacionAnualAjustada = 1
SELECT @DepreciacionPorcentaje = 100.0 / @DepreciacionAnual
ELSE SELECT @DepreciacionPorcentaje = @DepreciacionAnual / 12.0
IF ((@Depreciacion + @DepreciacionAcum) >= @AdquisicionValor) OR ABS((@Depreciacion + @DepreciacionAcum) - @AdquisicionValor) < 1.0
BEGIN
SELECT @Depreciacion = @AdquisicionValor - @DepreciacionAcum
SELECT @DepreciacionPorcentaje = (@AdquisicionValor - @DepreciacionAcum) / (@AdquisicionValor /100.0)
END
END
END
IF @CategoriaMetodoDepreciacion = 'SUMA DIGITOS'
SELECT @Depreciacion = @AdquisicionValor * (@DepreciacionPorcentaje / 100.0) 
ELSE
SELECT @Depreciacion = @AdquisicionValor * (@DepreciacionPorcentaje / 100.0) * @MesesDepreciados
END
IF (@MesesDepreciados > 0 OR @MovTipo = 'AF.RV') AND ((@MovTipo = 'AF.RV' AND (@Todo = 1 OR @ValorMercado = 0)) OR (@MovTipo IN ('AF.DP', 'AF.DT') AND @Revaluar = 1))
BEGIN
EXEC spPeriodoEjercicio @Empresa, @Modulo, @AdquisicionFecha, @AdquisicionPeridodo OUTPUT, @AdquisicionEjercicio OUTPUT, @Ok OUTPUT
EXEC spTablaAnual @CfgTabla, @AdquisicionEjercicio, @AdquisicionPeridodo, 1, @AdquisicionIndice OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SELECT @Factor = @FechaEmisionIndice / @AdquisicionIndice
SELECT @NuevoValor = @AdquisicionValor * @Factor
SELECT @Revaluacion = @NuevoValor - @ValorActual
IF @MovTipo IN ('AF.RV', 'AF.DP', 'AF.DT')
BEGIN
IF @RevaluacionUltima IS NOT NULL
BEGIN
EXEC spPeriodoEjercicio @Empresa, @Modulo, @RevaluacionUltima, @RevaluacionPeridodo OUTPUT, @RevaluacionEjercicio OUTPUT, @Ok OUTPUT
EXEC spTablaAnual @CfgTabla, @RevaluacionEjercicio, @RevaluacionPeridodo, 1, @RevaluacionIndice OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
SELECT @Inflacion = ((@FechaEmisionIndice / @RevaluacionIndice) - 1) * 100.0
END ELSE
SELECT @Inflacion = ((@FechaEmisionIndice / @AdquisicionIndice) - 1) * 100.0
IF @MesesDepreciados > 0
SELECT @ActualizacionDepreciacion = (@Depreciacion/@MesesDepreciados) * (@Inflacion / 100.0)
ELSE
SELECT @ActualizacionDepreciacion = 0.0
SELECT @ActualizacionCapital = @Revaluacion /*- @ActualizacionDepreciacion*/
SELECT @ActualizacionGastos = 0.0
END
END
END
END
END
IF @Ok IS NULL
BEGIN
IF @MovTipo IN ('AF.DP', 'AF.DT', 'AF.RV')
BEGIN
IF @MovTipo IN ('AF.DP', 'AF.DT') AND @MesesDepreciados > 0
BEGIN
IF @SubClaveFiscal = 1
BEGIN
IF @EstatusNuevo = 'CONCLUIDO' UPDATE ActivoF SET DepreciacionMesesF = ISNULL(DepreciacionMesesF, 0) + @MesesDepreciados, DepreciacionUltimaF = @DepreciacionFecha,    DepreciacionAcumF = ISNULL(DepreciacionAcumF, 0.0) + @Depreciacion WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie ELSE
IF @EstatusNuevo = 'CANCELADO' UPDATE ActivoF SET DepreciacionMesesF = ISNULL(DepreciacionMesesF, 0) - @MesesDepreciados, DepreciacionUltimaF = @DepreciacionAnterior, DepreciacionAcumF = ISNULL(DepreciacionAcumF, 0.0) - @Depreciacion WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie
END ELSE
IF @SubClaveFiscal = 2
BEGIN
IF @EstatusNuevo = 'CONCLUIDO' UPDATE ActivoF SET DepreciacionMesesF2 = ISNULL(DepreciacionMesesF2, 0) + @MesesDepreciados, DepreciacionUltimaF2 = @DepreciacionFecha,    DepreciacionAcumF2 = ISNULL(DepreciacionAcumF2, 0.0) + @Depreciacion WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie ELSE
IF @EstatusNuevo = 'CANCELADO' UPDATE ActivoF SET DepreciacionMesesF2 = ISNULL(DepreciacionMesesF2, 0) - @MesesDepreciados, DepreciacionUltimaF2 = @DepreciacionAnterior, DepreciacionAcumF2 = ISNULL(DepreciacionAcumF2, 0.0) - @Depreciacion WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie
END ELSE
BEGIN
IF @EstatusNuevo = 'CONCLUIDO' UPDATE ActivoF SET DepreciacionMeses = ISNULL(DepreciacionMeses, 0) + @MesesDepreciados, DepreciacionUltima = @DepreciacionFecha,    DepreciacionAcum = ISNULL(DepreciacionAcum, 0.0) + @Depreciacion WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie ELSE
IF @EstatusNuevo = 'CANCELADO' UPDATE ActivoF SET DepreciacionMeses = ISNULL(DepreciacionMeses, 0) - @MesesDepreciados, DepreciacionUltima = @DepreciacionAnterior, DepreciacionAcum = ISNULL(DepreciacionAcum, 0.0) - @Depreciacion WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie
END
END
IF @MovTipo = 'AF.RV' OR (@MovTipo IN ('AF.DP', 'AF.DT') AND @Revaluar = 1 AND @MesesDepreciados > 0)
BEGIN
IF @SubClaveFiscal = 1
BEGIN
IF @EstatusNuevo = 'CONCLUIDO' UPDATE ActivoF SET RevaluacionUltimaF = @DepreciacionFecha,   ValorRevaluadoF = @NuevoValor    WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie ELSE
IF @EstatusNuevo = 'CANCELADO' UPDATE ActivoF SET RevaluacionUltimaF = @RevaluacionAnterior, ValorRevaluadoF = @ValorAnterior WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie
END ELSE
IF @SubClaveFiscal = 2
BEGIN
IF @EstatusNuevo = 'CONCLUIDO' UPDATE ActivoF SET RevaluacionUltimaF2 = @DepreciacionFecha,   ValorRevaluadoF2 = @NuevoValor    WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie ELSE
IF @EstatusNuevo = 'CANCELADO' UPDATE ActivoF SET RevaluacionUltimaF2 = @RevaluacionAnterior, ValorRevaluadoF2 = @ValorAnterior WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie
END ELSE
BEGIN
IF @EstatusNuevo = 'CONCLUIDO' UPDATE ActivoF SET RevaluacionUltima = @DepreciacionFecha,   ValorRevaluado = @NuevoValor    WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie ELSE
IF @EstatusNuevo = 'CANCELADO' UPDATE ActivoF SET RevaluacionUltima = @RevaluacionAnterior, ValorRevaluado = @ValorAnterior WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie
END
END
END ELSE
IF @MovTipo = 'AF.RE'
BEGIN
IF @EstatusNuevo = 'PENDIENTE' UPDATE ActivoF SET Estatus = 'REPARACION' WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie ELSE
IF @EstatusNuevo = 'CONCLUIDO' UPDATE ActivoF SET Estatus = 'ACTIVO', ReparacionUltima = @FechaEmision,       ReparacionAcum = ISNULL(ReparacionAcum, 0.0) + @ArtImporte, Reparaciones = ISNULL(Reparaciones, 0) + 1, ReparacionHoras = ISNULL(ReparacionHoras, 0.0) + @Horas WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie ELSE
IF @EstatusNuevo = 'CANCELADO' UPDATE ActivoF SET Estatus = 'ACTIVO', ReparacionUltima = @ReparacionAnterior, ReparacionAcum = ISNULL(ReparacionAcum, 0.0) - @ArtImporte, Reparaciones = ISNULL(Reparaciones, 0) - 1, ReparacionHoras = ISNULL(ReparacionHoras, 0.0) - @Horas WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie
END ELSE
IF @MovTipo = 'AF.MA'
BEGIN
IF @Accion <> 'CANCELAR'
EXEC spCalcularPeriodicidad @FechaEmision, @MantenimientoPeriodicidad, @MantenimientoSiguiente OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @EstatusNuevo = 'PENDIENTE' UPDATE ActivoF SET Estatus = 'MANTENIMIENTO', MantenimientoSiguiente = @MantenimientoSiguiente                                           	     								                                                                                                                    WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie ELSE
IF @EstatusNuevo = 'CONCLUIDO' UPDATE ActivoF SET Estatus = 'ACTIVO',        MantenimientoSiguiente = @MantenimientoSiguiente, MantenimientoUltimo = @FechaEmision, 	    MantenimientoAcum = ISNULL(MantenimientoAcum, 0.0) + @ArtImporte, Mantenimientos = ISNULL(Mantenimientos, 0) + 1, MantenimientoHoras = ISNULL(MantenimientoHoras, 0.0) + @Horas WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie ELSE
IF @EstatusNuevo = 'CANCELADO' UPDATE ActivoF SET Estatus = 'ACTIVO',  	 MantenimientoUltimo = @MantenimientoAnterior, MantenimientoSiguiente = @MantenimientoSiguienteAnt, MantenimientoAcum = ISNULL(MantenimientoAcum, 0.0) - @ArtImporte, Mantenimientos = ISNULL(Mantenimientos, 0) - 1, MantenimientoHoras = ISNULL(MantenimientoHoras, 0.0) - @Horas WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie
END ELSE
IF @MovTipo = 'AF.PM'
BEGIN
IF @EstatusNuevo = 'VIGENTE'   UPDATE ActivoF SET MantenimientoVence = @Vencimiento,        	 MantenimientoAcum = ISNULL(MantenimientoAcum, 0.0) + @ArtImporte WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie ELSE
IF @EstatusNuevo = 'CANCELADO' UPDATE ActivoF SET MantenimientoVence = @PolizaMantenimientoAnterior, MantenimientoAcum = ISNULL(MantenimientoAcum, 0.0) - @ArtImporte WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie
END ELSE
IF @MovTipo = 'AF.PS'
BEGIN
IF @EstatusNuevo = 'VIGENTE'   UPDATE ActivoF SET SeguroVence = @Vencimiento, 	   SeguroAcum = ISNULL(SeguroAcum, 0.0) + @ArtImporte WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie ELSE
IF @EstatusNuevo = 'CANCELADO' UPDATE ActivoF SET SeguroVence = @PolizaSeguroAnterior, SeguroAcum = ISNULL(SeguroAcum, 0.0) - @ArtImporte WHERE Empresa = @Empresa AND Articulo = @Articulo AND Serie = @Serie
END
EXEC spSerieLoteFlujo @Sucursal, @Sucursal, @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Articulo, NULL, @Serie, NULL, 0
SELECT @SumaImporte      = @SumaImporte      + ISNULL(@Importe, 0),
@SumaImpuestos    = @SumaImpuestos    + ISNULL(@Impuestos, 0),
@SumaDepreciacion = @SumaDepreciacion + ISNULL(@Depreciacion, 0)
IF @Accion <> 'CANCELAR'
BEGIN
UPDATE ActivoFijoD
SET NuevoValor			  = @NuevoValor,
Depreciacion			  = @Depreciacion,
DepreciacionPorcentaje	  = @DepreciacionPorcentaje,
Inflacion			  = @Inflacion,
MesesDepreciados		  = @MesesDepreciados,
ActualizacionDepreciacion	  = @ActualizacionDepreciacion,
ActualizacionCapital		  = @ActualizacionCapital,
ActualizacionGastos		  = @ActualizacionGastos,
ValorAnterior		  = @ValorAnterior,
DepreciacionAnterior		  = @DepreciacionAnterior,
RevaluacionAnterior		  = @RevaluacionAnterior,
ReparacionAnterior		  = @ReparacionAnterior,
MantenimientoSiguienteAnterior = @MantenimientoSiguienteAnt,
MantenimientoAnterior	  = @MantenimientoAnterior,
PolizaMantenimientoAnterior	  = @PolizaMantenimientoAnterior,
PolizaSeguroAnterior		  = @PolizaSeguroAnterior
WHERE CURRENT OF crActivoFijo
END
END
END
IF @@FETCH_STATUS <> -2 AND @MovTipo IN ('AF.A', 'AF.D') AND @Ok IS NULL
BEGIN
IF (@MovTipo = 'AF.A' AND @Accion = 'AFECTAR') OR (@MovTipo = 'AF.D' AND @Accion = 'CANCELAR')
SELECT @EsDevolucion = 0
ELSE
SELECT @EsDevolucion = 1
IF @Personal IS NOT NULL UPDATE ActivoF SET Responsable  = CASE WHEN @EsDevolucion = 0 THEN @Personal ELSE NULL END WHERE ID = @IDActivoF
IF @Espacio  IS NOT NULL UPDATE ActivoF SET Espacio      = CASE WHEN @EsDevolucion = 0 THEN @Espacio  ELSE NULL END WHERE ID = @IDActivoF
IF @ContUso  IS NOT NULL UPDATE ActivoF SET CentroCostos = CASE WHEN @EsDevolucion = 0 THEN @ContUso  ELSE NULL END WHERE ID = @IDActivoF
IF @ContUso2  IS NOT NULL UPDATE ActivoF SET ContUso2 = CASE WHEN @EsDevolucion = 0 THEN @ContUso2  ELSE NULL END WHERE ID = @IDActivoF
IF @ContUso3  IS NOT NULL UPDATE ActivoF SET ContUso3 = CASE WHEN @EsDevolucion = 0 THEN @ContUso3  ELSE NULL END WHERE ID = @IDActivoF
END
IF @Ok IS NOT NULL AND @OkRef IS NULL
SELECT @OkRef = RTRIM(@Articulo)+' - '+RTRIM(@Serie)
FETCH NEXT
FROM crActivoFijo
INTO @Articulo, @Serie, @Importe, @Impuestos, @Horas,
@Depreciacion, @MesesDepreciados, @NuevoValor, @Inflacion, @ActualizacionCapital, @ActualizacionGastos, @ActualizacionDepreciacion,
@ValorAnterior, @DepreciacionAnterior, @RevaluacionAnterior, @ReparacionAnterior, @MantenimientoAnterior, @MantenimientoSiguienteAnt, @PolizaMantenimientoAnterior, @PolizaSeguroAnterior,
@ArtMoneda, @AdquisicionFecha, @DepreciacionInicio, @AdquisicionValor, @ValorRevaluado, @DepreciacionAcum, @DepreciacionUltima, @RevaluacionUltima, @VidaUtil, @DepreciacionAnual, @DepreciacionMeses, @MantenimientoPeriodicidad, @IDActivoF, @Categoria, @ValorDesecho
IF @@ERROR <> 0 SELECT @Ok = 1
END  
CLOSE crActivoFijo
DEALLOCATE crActivoFijo
SELECT @ImporteTotal = @SumaImporte + @SumaImpuestos
IF @Ok IS NULL
BEGIN
IF @EstatusNuevo = 'CANCELADO' SELECT @FechaCancelacion = @FechaRegistro ELSE SELECT @FechaCancelacion = NULL
IF @EstatusNuevo = 'CONCLUIDO' SELECT @FechaConclusion  = @FechaEmision  ELSE IF @EstatusNuevo <> 'CANCELADO' SELECT @FechaConclusion  = NULL
IF @CfgContX = 1 AND @CfgContXGenerar <> 'NO'
BEGIN
IF @EstatusNuevo = 'CONCLUIDO' SELECT @GenerarPoliza = 1 ELSE
IF @Estatus = 'CONCLUIDO' AND @EstatusNuevo = 'CANCELADO' IF @GenerarPoliza = 1 SELECT @GenerarPoliza = 0 ELSE SELECT @GenerarPoliza = 1
END
EXEC spValidarTareas @Empresa, @Modulo, @ID, @EstatusNuevo, @Ok OUTPUT, @OkRef OUTPUT
UPDATE ActivoFijo
SET Importe	      = NULLIF(@SumaImporte, 0.0),
Impuestos        = NULLIF(@SumaImpuestos, 0.0),
FechaConclusion  = @FechaConclusion,
FechaCancelacion = @FechaCancelacion,
UltimoCambio     = /*CASE WHEN UltimoCambio IS NULL THEN */@FechaRegistro /*ELSE UltimoCambio END*/,
Vencimiento      = @Vencimiento,
Estatus          = @EstatusNuevo,
Situacion 	      = CASE WHEN @Estatus<>@EstatusNuevo THEN NULL ELSE Situacion END,
GenerarPoliza    = @GenerarPoliza
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
END
IF @AFGenerarGasto = 1 AND @EstatusNuevo IN ('CONCLUIDO', 'CANCELADO', 'VIGENTE') AND @Ok IS NULL
BEGIN
IF (@AFGenerarGastoCfg = 'Empresa' AND @MovTipo IN ('AF.DP', 'AF.DT') AND @SumaDepreciacion > 0.0) OR(@AFGenerarGastoCfg = 'Movimiento' AND @MovTipoGenerarGasto = 1 AND @MovTipo IN ('AF.DP', 'AF.DT') AND @SumaDepreciacion > 0.0)
EXEC spGenerarGasto @Accion, @Empresa, @Sucursal, @Usuario, @Modulo, @ID, @Mov, @MovID, @FechaEmision, @FechaRegistro, @Ok OUTPUT, @OkRef OUTPUT, @MovTipo = @MovTipo, @MovTipoGenerarGasto = @MovTipoGenerarGasto
ELSE IF @AFGenerarGastoCfg = 'Movimiento' AND @MovTipoGenerarGasto = 1 AND @MovTipo IN ('AF.RE', 'AF.MA', 'AF.PM', 'AF.PS', 'AF.RV') AND @ImporteTotal > 0.0
EXEC spGenerarGasto @Accion, @Empresa, @Sucursal, @Usuario, @Modulo, @ID, @Mov, @MovID, @FechaEmision, @FechaRegistro, @Ok OUTPUT, @OkRef OUTPUT, @MovTipo = @MovTipo, @MovTipoGenerarGasto = @MovTipoGenerarGasto
END
IF @CfgAfectarDinero = 1 AND @MovTipo IN ('AF.RE', 'AF.MA', 'AF.PS', 'AF.PM') AND @EstatusNuevo IN ('CONCLUIDO', 'CANCELADO', 'VIGENTE') AND @ImporteTotal > 0.0
EXEC spGenerarDinero @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, NULL, @Proyecto, @Usuario, @Autorizacion, NULL, @DocFuente, @Observaciones, 0, 0,
@FechaRegistro, @Ejercicio, @Periodo,
@FormaPago, NULL, NULL,
@Proveedor, @CtaDinero, NULL, @ImporteTotal, NULL,
NULL, NULL, NULL,
@DineroMov OUTPUT, @DineroMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spMovFinal @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion = 'CANCELAR' AND @EstatusNuevo = 'CANCELADO' AND @Ok IS NULL
EXEC spCancelarFlujo @Empresa, @Modulo, @ID, @Ok OUTPUT
IF @Conexion = 0
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
COMMIT TRANSACTION
ELSE
BEGIN
DECLARE @PolizaDescuadrada TABLE (Cuenta varchar(20) NULL, SubCuenta varchar(50) NULL, Concepto varchar(50) NULL, Debe money NULL, Haber money NULL, SucursalContable int NULL)
IF EXISTS(SELECT * FROM PolizaDescuadrada WHERE Modulo = @Modulo AND ID = @ID)
INSERT @PolizaDescuadrada (Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable) SELECT Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable FROM PolizaDescuadrada WHERE Modulo = @Modulo AND ID = @ID
ROLLBACK TRANSACTION
DELETE PolizaDescuadrada WHERE Modulo = @Modulo AND ID = @ID
INSERT PolizaDescuadrada (Modulo, ID, Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable) SELECT @Modulo, @ID, Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable FROM @PolizaDescuadrada
END
RETURN
END

