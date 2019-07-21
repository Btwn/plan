SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGuatemalaLibroVenta
(
@Estacion			int
)

AS
BEGIN
DECLARE
@Transaccion				varchar(50),
@Ok					int,
@OkRef					varchar(255),
@DocumentoNo				varchar(20),
@Dia					varchar(2),
@Mes					varchar(2),
@Ano					varchar(4),
@TipoDeDocumento			varchar(30),
@Nombre					varchar(100),
@TotalFactura				money,
@TotalCantidadExportacion		int,
@TotalImporteExportacion		money,
@TotalImpuestoExportacion		money,
@TotalCantidadServicio			int,
@TotalImporteServicio			money,
@TotalImpuestoServicio			money,
@ServicioNeto				money,
@TotalCantidadBienes			int,
@TotalImporteBienes			money,
@TotalImpuestoBienes			money,
@BienesNeto				money,
@TotalExcento				money,
@TotalTotalFactura			money,
@TotalTotalImporteExportacion		money,
@TotalTotalIVAExportacion		money,
@TotalTotalServicioNeto			money,
@TotalTotalServicioIVA			money,
@TotalTotalBienesNeto			money,
@TotalTotalBienesIVA			money,
@TotalTotalExcento			money,
@Contador				int,
@LineasPorPagina			int,
@Ejercicio				int,
@Periodo				int,
@Estatus				varchar(15),
@Empresa				varchar(5)
SET @Transaccion = 'spGuatemalaLibroVenta' + RTRIM(LTRIM(CONVERT(varchar,@Estacion)))
BEGIN TRANSACTION @Transaccion
SET @Estatus = 'CONCLUIDO'
SELECT
@LineasPorPagina = InfoLineasPorPagina,
@Ejercicio = InfoEjercicio,
@Periodo = InfoPeriodoD,
@Empresa = InfoEmpresa
FROM RepParam
WITH(NOLOCK) WHERE Estacion = @Estacion
DECLARE @Tabla	TABLE (
Tipo						varchar(20),
DocumentoNo					varchar(20),
DiaDoc						varchar(2),
MesDoc						varchar(2),
AnoDoc						varchar(4),
TipoDeDocumento				varchar(30),
Nombre						varchar(100),
TotalFactura				money,
Exportacion					money,
IVAExportacion				money,
ServiciosNeto				money,
IVAServicios				money,
BienesNeto					money,
IVABienes					money,
TotalExcento				money)
SET @Ok = NULL
SET @Contador = 1
SET @TotalTotalFactura = 0.0
SET @TotalTotalImporteExportacion = 0.0
SET @TotalTotalIVAExportacion = 0.0
SET @TotalTotalServicioNeto = 0.0
SET @TotalTotalServicioIVA = 0.0
SET @TotalTotalBienesNeto = 0.0
SET @TotalTotalBienesIVA = 0.0
SET @TotalTotalExcento = 0.0
DECLARE crLibroVentaGuatemala CURSOR FOR
SELECT DocumentoNo, Dia, Mes, Ano, TipoDeDocumento, Nombre, TotalFactura, TotalCantidadExportacion, TotalImporteExportacion, TotalImpuestoExportacion,	TotalCantidadServicio, TotalImporteServicio, TotalImpuestoServicio, ServicioNeto, TotalCantidadBienes, TotalImporteBienes, TotalImpuestoBienes, BienesNeto, TotalExcento
FROM LibroVentaGuatemala lvg
WITH(NOLOCK) WHERE Estatus IN ('CONCLUIDO','CANCELADO') AND Periodo = @Periodo AND Ejercicio = @Ejercicio AND Empresa = @Empresa
ORDER BY DocumentoNo
OPEN crLibroVentaGuatemala
FETCH NEXT FROM crLibroVentaGuatemala  INTO @DocumentoNo, @Dia, @Mes, @Ano, @TipoDeDocumento, @Nombre, @TotalFactura, @TotalCantidadExportacion, @TotalImporteExportacion, @TotalImpuestoExportacion,	@TotalCantidadServicio, @TotalImporteServicio, @TotalImpuestoServicio, @ServicioNeto, @TotalCantidadBienes, @TotalImporteBienes, @TotalImpuestoBienes, @BienesNeto, @TotalExcento
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
INSERT INTO @Tabla (Tipo,      DocumentoNo,  DiaDoc,  MesDoc,  AnoDoc,  TipoDeDocumento,  Nombre,  TotalFactura,  Exportacion,              IVAExportacion,             ServiciosNeto,         IVAServicios,            BienesNeto,           IVABienes,            TotalExcento)
VALUES ('Detalle', @DocumentoNo, @Dia,    @Mes,    @Ano,    @TipoDeDocumento, @Nombre, @TotalFactura, @TotalImporteExportacion, @TotalImpuestoExportacion,  @TotalImporteServicio, @TotalImpuestoServicio,  @TotalImporteBienes,  @TotalImpuestoBienes, @TotalExcento)
IF @TipoDeDocumento = 'Factura'
BEGIN
SET @TotalTotalFactura = @TotalTotalFactura + @TotalFactura
SET @TotalTotalImporteExportacion = @TotalTotalImporteExportacion + @TotalImporteExportacion
SET @TotalTotalIVAExportacion = @TotalTotalIVAExportacion + @TotalImpuestoExportacion
SET @TotalTotalServicioNeto = @TotalTotalServicioNeto + @TotalImporteServicio
SET @TotalTotalServicioIVA = @TotalTotalServicioIVA + @TotalImpuestoServicio
SET @TotalTotalBienesNeto = @TotalTotalBienesNeto + @TotalImporteBienes
SET @TotalTotalBienesIVA = @TotalTotalBienesIVA + @TotalImpuestoBienes
SET @TotalTotalExcento =  @TotalTotalExcento + @TotalExcento
END
ELSE
BEGIN
SET @TotalTotalFactura = @TotalTotalFactura - @TotalFactura
SET @TotalTotalImporteExportacion = @TotalTotalImporteExportacion - @TotalImporteExportacion
SET @TotalTotalIVAExportacion = @TotalTotalIVAExportacion - @TotalImpuestoExportacion
SET @TotalTotalServicioNeto = @TotalTotalServicioNeto - @TotalImporteServicio
SET @TotalTotalServicioIVA = @TotalTotalServicioIVA - @TotalImpuestoServicio
SET @TotalTotalBienesNeto = @TotalTotalBienesNeto - @TotalImporteBienes
SET @TotalTotalBienesIVA = @TotalTotalBienesIVA - @TotalImpuestoBienes
SET @TotalTotalExcento =  @TotalTotalExcento - @TotalExcento
END
IF @Contador = @LineasPorPagina
BEGIN
INSERT @Tabla (Tipo,          TotalFactura,         Exportacion,                   IVAExportacion,             ServiciosNeto,            IVAServicios,            BienesNeto,            IVABienes,            TotalExcento       )
VALUES ('Total Van',   @TotalTotalFactura,   @TotalTotalImporteExportacion, @TotalTotalIVAExportacion,  @TotalTotalServicioNeto,  @TotalTotalServicioIVA,  @TotalTotalBienesNeto, @TotalTotalBienesIVA, @TotalTotalExcento )
INSERT @Tabla (Tipo,          TotalFactura,         Exportacion,                   IVAExportacion,             ServiciosNeto,            IVAServicios,            BienesNeto,            IVABienes,            TotalExcento       )
VALUES ('Total Vienen',@TotalTotalFactura,   @TotalTotalImporteExportacion, @TotalTotalIVAExportacion,  @TotalTotalServicioNeto,  @TotalTotalServicioIVA,  @TotalTotalBienesNeto, @TotalTotalBienesIVA, @TotalTotalExcento )
SET @Contador = 0
END
SET @Contador = @Contador + 1
FETCH NEXT FROM crLibroVentaGuatemala  INTO @DocumentoNo, @Dia, @Mes, @Ano, @TipoDeDocumento, @Nombre, @TotalFactura, @TotalCantidadExportacion, @TotalImporteExportacion, @TotalImpuestoExportacion,	@TotalCantidadServicio, @TotalImporteServicio, @TotalImpuestoServicio, @ServicioNeto, @TotalCantidadBienes, @TotalImporteBienes, @TotalImpuestoBienes, @BienesNeto, @TotalExcento
END
CLOSE crLibroVentaGuatemala
DEALLOCATE crLibroVentaGuatemala
INSERT @Tabla (Tipo,           TotalFactura,         Exportacion,                   IVAExportacion,             ServiciosNeto,            IVAServicios,            BienesNeto,            IVABienes,            TotalExcento       )
VALUES ('Total General',@TotalTotalFactura,   @TotalTotalImporteExportacion, @TotalTotalIVAExportacion,  @TotalTotalServicioNeto,  @TotalTotalServicioIVA,  @TotalTotalBienesNeto, @TotalTotalBienesIVA, @TotalTotalExcento )
SELECT * FROM @Tabla
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION @Transaccion
END ELSE
BEGIN
ROLLBACK TRANSACTION @Transaccion
SELECT 'ERROR: ' + CONVERT(varchar,@Ok) + (SELECT Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok) +'. ' + ISNULL(@OkRef,'')
END
END

