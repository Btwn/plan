SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGuatemalaLibroCompra
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
@TotalCantidadImportacion		int,
@TotalImporteImportacion		money,
@TotalImpuestoImportacion		money,
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
@TotalTotalImporteImportacion		money,
@TotalTotalIVAImportacion		money,
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
SET @Transaccion = 'spGuatemalaLibroCompra' + RTRIM(LTRIM(CONVERT(varchar,@Estacion)))
BEGIN TRANSACTION @Transaccion
SET @Estatus = 'CONCLUIDO'
SELECT
@LineasPorPagina = InfoLineasPorPagina,
@Ejercicio = InfoEjercicio,
@Periodo = InfoPeriodoD,
@Empresa = InfoEmpresa
FROM RepParam
WHERE Estacion = @Estacion
DECLARE @Tabla	TABLE
(
Tipo						varchar(20),
DocumentoNo					varchar(20),
DiaDoc						varchar(2),
MesDoc						varchar(2),
AnoDoc						varchar(4),
TipoDeDocumento					varchar(30),
Nombre						varchar(100),
TotalFactura					money,
Importacion					money,
IVAImportacion					money,
ServiciosNeto					money,
IVAServicios					money,
BienesNeto					money,
IVABienes					money,
TotalExcento					money
)
DECLARE @CompraTotalGuatemala		TABLE
(
Modulo				varchar(5),
ID				int,
TotalCantidadImportacion		float,
TotalImporteImportacion		money,
TotalImpuestoImportacion		money,
TotalCantidadServicio		float,
TotalImporteServicio		money,
TotalImpuestoServicio		money,
TotalCantidadBienes		float,
TotalImporteBienes		money,
TotalImpuestoBienes		money,
TotalExcento			money
)
INSERT @CompraTotalGuatemala (Modulo, ID, TotalCantidadImportacion, TotalImporteImportacion, TotalImpuestoImportacion, TotalCantidadServicio, TotalImporteServicio, TotalImpuestoServicio, TotalCantidadBienes, TotalImporteBienes, TotalImpuestoBienes, TotalExcento)
SELECT
cg.Modulo,
cg.ID,
CASE WHEN mt.Clave = 'COMS.EI' OR fr.Extranjero = 1 THEN TotalCantidadServicio + TotalCantidadBienes ELSE 0.0 END TotalCantidadImportacion,
CASE WHEN mt.Clave = 'COMS.EI' OR fr.Extranjero = 1 THEN TotalImporteServicio + TotalImporteBienes ELSE 0.0 END TotalImporteImportacion,
CASE WHEN mt.Clave = 'COMS.EI' OR fr.Extranjero = 1 THEN TotalImpuestoServicio + TotalImpuestoBienes ELSE 0.0 END TotalImpuestoImportacion,
CASE WHEN mt.Clave = 'COMS.EI' OR fr.Extranjero = 1 THEN 0.0 ELSE TotalCantidadServicio END TotalCantidadServicio,
CASE WHEN mt.Clave = 'COMS.EI' OR fr.Extranjero = 1 THEN 0.0 ELSE TotalImporteServicio END TotalImporteServicio,
CASE WHEN mt.Clave = 'COMS.EI' OR fr.Extranjero = 1 THEN 0.0 ELSE TotalImpuestoServicio END TotalImpuestoServicio,
CASE WHEN mt.Clave = 'COMS.EI' OR fr.Extranjero = 1 THEN 0.0 ELSE TotalCantidadBienes END TotalCantidadBienes,
CASE WHEN mt.Clave = 'COMS.EI' OR fr.Extranjero = 1 THEN 0.0 ELSE TotalImporteBienes END TotalImporteBienes,
CASE WHEN mt.Clave = 'COMS.EI' OR fr.Extranjero = 1 THEN 0.0 ELSE TotalImpuestoBienes END TotalImpuestoBienes,
cg.TotalExcento
FROM CompraGuatemala cg LEFT OUTER JOIN Compra c
ON cg.ID = c.ID AND cg.Modulo = 'COMS' LEFT OUTER JOIN MovTipo mt
ON c.Mov = mt.Mov AND mt.Modulo = 'COMS' LEFT OUTER JOIN Gasto g
ON cg.ID = g.ID AND cg.Modulo = 'GAS' LEFT OUTER JOIN Prov p
ON p.Proveedor = g.Acreedor LEFT OUTER JOIN FiscalRegimen fr
ON p.FiscalRegimen = fr.FiscalRegimen
DECLARE @LibroCompraGuatemalaTemp		TABLE
(
Empresa				varchar(5),
Modulo				varchar(5),
ID				int,
DocumentoNo			varchar(50),
Dia				int,
Mes				int,
Ano				int,
TipodeDocumento			varchar(50),
Nombre				varchar(100),
TotalFactura			money,
Estatus				varchar(15),
Periodo				int,
Ejercicio			int
)
INSERT @LibroCompraGuatemalaTemp (Empresa, Modulo, ID, DocumentoNo, Dia, Mes, Ano, TipodeDocumento, Nombre, TotalFactura, Estatus, Periodo, Ejercicio)
SELECT
c.Empresa,
'COMS' Modulo,
c.ID,
c.Referencia As DocumentoNo,
ISNULL(RIGHT('0' + CONVERT(varchar,DATEPART(DAY, ISNULL(c.FechaProveedor,C.FechaEmision))),2),'') Dia,
ISNULL(RIGHT('0' + CONVERT(varchar,DATEPART(MONTH, ISNULL(c.FechaProveedor,c.FechaEmision))),2),'') Mes,
ISNULL(CONVERT(varchar,DATEPART(YEAR, ISNULL(c.FechaProveedor,c.FechaEmision))),'') Ano,
CASE
WHEN mt.Clave = 'COMS.F'  THEN 'Factura'
WHEN mt.Clave = 'COMS.EG' THEN 'Factura'
WHEN mt.Clave = 'COMS.EI' THEN 'Factura'
WHEN mt.Clave = 'COMS.F' AND mt.SubClave = 'COMS.CE/GT' THEN 'Factura'
WHEN mt.Clave = 'COMS.D'  THEN 'Nota de Cargo'
END TipodeDocumento,
p.Nombre,
(ISNULL(c.Importe,0.0) + ISNULL(c.Impuestos,0.0)) * c.TipoCambio TotalFactura,
ISNULL(c.Estatus,'') Estatus,
ISNULL(c.Periodo,0) Periodo,
ISNULL(c.Ejercicio,0) Ejercicio
FROM Compra c JOIN MovTipo mt
ON mt.Mov = ISNULL(c.Mov,'') AND mt.Modulo = 'COMS' JOIN Prov p
ON p.Proveedor = c.Proveedor
WHERE mt.Clave IN ('COMS.F','COMS.EG','COMS.EI','COMS.D')
UNION ALL
SELECT
g.Empresa,
'GAS' Modulo,
g.ID,
g.Nota As DocumentoNo,
ISNULL(RIGHT('0' + CONVERT(varchar,DATEPART(DAY, ISNULL(g.FechaRequerida,G.FechaEmision))),2),'') Dia,
ISNULL(RIGHT('0' + CONVERT(varchar,DATEPART(MONTH, ISNULL(g.FechaRequerida,g.FechaEmision))),2),'') Mes,
ISNULL(CONVERT(varchar,DATEPART(YEAR, ISNULL(g.FechaRequerida,g.FechaEmision))),'') Ano,
CASE
WHEN mt.Clave = 'GAS.A'   THEN 'Factura'
WHEN mt.Clave = 'GAS.G'   THEN 'Factura'
WHEN mt.Clave = 'GAS.GTC' THEN 'Factura'
WHEN mt.Clave = 'GAS.CP'  THEN 'Factura'
WHEN mt.Clave = 'GAS.OI'  THEN 'Factura'
WHEN mt.Clave = 'GAS.G' AND mt.SubClave = 'GAS.CE/GT' THEN 'Factura'
WHEN mt.Clave = 'GAS.DG'  THEN 'Nota de Cargo'
WHEN mt.Clave = 'GAS.DC'  THEN 'Nota de Cargo'
WHEN mt.Clave = 'GAS.DGP' THEN 'Nota de Cargo'
WHEN mt.Clave = 'GAS.CB'  THEN 'Nota de Cargo'
WHEN mt.Clave = 'GAS.AB'  THEN 'Nota de Cargo'
END TipodeDocumento,
p.Nombre,
(ISNULL(g.Importe,0.0) + ISNULL(g.Impuestos,0.0)) * g.TipoCambio TotalFactura,
ISNULL(g.Estatus,'') Estatus,
ISNULL(g.Periodo,0) Periodo,
ISNULL(g.Ejercicio,0) Ejercicio
FROM Gasto g JOIN MovTipo mt
ON mt.Mov = ISNULL(g.Mov,'') AND mt.Modulo = 'GAS' JOIN Prov p
ON p.Proveedor = g.Acreedor
WHERE mt.Clave IN ('GAS.A','GAS.G','GAS.GTC','GAS.CP','GAS.OI','GAS.G','GAS.DG','GAS.DC','GAS.DGP','GAS.CB','GAS.AB')
DECLARE @LibroCompraGuatemala		TABLE
(
Empresa				varchar(5),
DocumentoNo			varchar(50),
Dia				int,
Mes				int,
Ano				int,
TipodeDocumento			varchar(50),
Nombre				varchar(100),
TotalFactura			money,
TotalCantidadImportacion	float,
TotalImporteImportacion		money,
TotalImpuestoImportacion	money,
ImportacionNeto			money,
TotalCantidadServicio		float,
TotalImporteServicio		money,
TotalImpuestoServicio		money,
ServicioNeto			money,
TotalCantidadBienes		float,
TotalImporteBienes		money,
TotalImpuestoBienes		money,
BienesNeto			money,
TotalExcento			money,
Estatus				varchar(15),
Periodo				int,
Ejercicio			int
)
INSERT @LibroCompraGuatemala (Empresa, DocumentoNo, Dia, Mes, Ano, TipodeDocumento, Nombre, TotalFactura, TotalCantidadImportacion, TotalImporteImportacion, TotalImpuestoImportacion,	 ImportacionNeto, TotalCantidadServicio, TotalImporteServicio, TotalImpuestoServicio, ServicioNeto, TotalCantidadBienes, TotalImporteBienes, TotalImpuestoBienes, BienesNeto, TotalExcento, Estatus, Periodo, Ejercicio)
SELECT
lcgt.Empresa,
lcgt.DocumentoNo,
lcgt.Dia,
lcgt.Mes,
lcgt.Ano,
lcgt.TipodeDocumento,
lcgt.Nombre,
lcgt.TotalFactura,
ctg.TotalCantidadImportacion,
ctg.TotalImporteImportacion,
ctg.TotalImpuestoImportacion,
(ctg.TotalImporteImportacion + ctg.TotalImpuestoImportacion) AS ImportacionNeto,
ctg.TotalCantidadServicio,
ctg.TotalImporteServicio,
ctg.TotalImpuestoServicio,
(ctg.TotalImporteServicio + ctg.TotalImpuestoServicio) AS ServicioNeto,
ctg.TotalCantidadBienes,
ctg.TotalImporteBienes,
ctg.TotalImpuestoBienes,
(ctg.TotalImporteBienes + ctg.TotalImpuestoBienes) AS BienesNeto,
ctg.TotalExcento,
lcgt.Estatus,
lcgt.Periodo,
lcgt.Ejercicio
FROM @LibroCompraGuatemalaTemp lcgt JOIN @CompraTotalGuatemala ctg
ON ctg.ID = lcgt.ID AND ctg.Modulo = lcgt.Modulo
SET @Ok = NULL
SET @Contador = 1
SET @TotalTotalFactura = 0.0
SET @TotalTotalImporteImportacion = 0.0
SET @TotalTotalIVAImportacion = 0.0
SET @TotalTotalServicioNeto = 0.0
SET @TotalTotalServicioIVA = 0.0
SET @TotalTotalBienesNeto = 0.0
SET @TotalTotalBienesIVA = 0.0
SET @TotalTotalExcento = 0.0
DECLARE crLibroCompraGuatemala CURSOR FOR
SELECT DocumentoNo, Dia, Mes, Ano, TipoDeDocumento, Nombre, TotalFactura, TotalCantidadImportacion, TotalImporteImportacion, TotalImpuestoImportacion,	TotalCantidadServicio, TotalImporteServicio, TotalImpuestoServicio, ServicioNeto, TotalCantidadBienes, TotalImporteBienes, TotalImpuestoBienes, BienesNeto, TotalExcento
FROM @LibroCompraGuatemala lcg
WHERE lcg.Estatus = @Estatus AND Periodo = @Periodo AND Ejercicio = @Ejercicio AND Empresa = @Empresa
ORDER BY Ano, Mes, Dia
OPEN crLibroCompraGuatemala
FETCH NEXT FROM crLibroCompraGuatemala INTO @DocumentoNo, @Dia, @Mes, @Ano, @TipoDeDocumento, @Nombre, @TotalFactura, @TotalCantidadImportacion, @TotalImporteImportacion, @TotalImpuestoImportacion,	@TotalCantidadServicio, @TotalImporteServicio, @TotalImpuestoServicio, @ServicioNeto, @TotalCantidadBienes, @TotalImporteBienes, @TotalImpuestoBienes, @BienesNeto, @TotalExcento
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
INSERT INTO @Tabla (Tipo,      DocumentoNo,  DiaDoc,  MesDoc,  AnoDoc,  TipoDeDocumento,  Nombre,  TotalFactura,  Importacion,              IVAImportacion,             ServiciosNeto,         IVAServicios,            BienesNeto,           IVABienes,            TotalExcento)
VALUES ('Detalle', @DocumentoNo, @Dia,    @Mes,    @Ano, @TipoDeDocumento, @Nombre, @TotalFactura, @TotalImporteImportacion, @TotalImpuestoImportacion,  @TotalImporteServicio, @TotalImpuestoServicio,  @TotalImporteBienes,  @TotalImpuestoBienes, @TotalExcento)
IF @TipoDeDocumento = 'Factura'
BEGIN
SET @TotalTotalFactura = @TotalTotalFactura + @TotalFactura
SET @TotalTotalImporteImportacion = @TotalTotalImporteImportacion + @TotalImporteImportacion
SET @TotalTotalIVAImportacion = @TotalTotalIVAImportacion + @TotalImpuestoImportacion
SET @TotalTotalServicioNeto = @TotalTotalServicioNeto + @TotalImporteServicio
SET @TotalTotalServicioIVA = @TotalTotalServicioIVA + @TotalImpuestoServicio
SET @TotalTotalBienesNeto = @TotalTotalBienesNeto + @TotalImporteBienes
SET @TotalTotalBienesIVA = @TotalTotalBienesIVA + @TotalImpuestoBienes
SET @TotalTotalExcento =  @TotalTotalExcento + @TotalExcento
END
ELSE
BEGIN
SET @TotalTotalFactura = @TotalTotalFactura - @TotalFactura
SET @TotalTotalImporteImportacion = @TotalTotalImporteImportacion - @TotalImporteImportacion
SET @TotalTotalIVAImportacion = @TotalTotalIVAImportacion - @TotalImpuestoImportacion
SET @TotalTotalServicioNeto = @TotalTotalServicioNeto - @TotalImporteServicio
SET @TotalTotalServicioIVA = @TotalTotalServicioIVA - @TotalImpuestoServicio
SET @TotalTotalBienesNeto = @TotalTotalBienesNeto - @TotalImporteBienes
SET @TotalTotalBienesIVA = @TotalTotalBienesIVA - @TotalImpuestoBienes
SET @TotalTotalExcento =  @TotalTotalExcento - @TotalExcento
END
IF @Contador = @LineasPorPagina
BEGIN
INSERT @Tabla (Tipo,          TotalFactura,         Importacion,                   IVAImportacion,             ServiciosNeto,            IVAServicios,            BienesNeto,            IVABienes,            TotalExcento       )
VALUES ('Total Van',   @TotalTotalFactura,   @TotalTotalImporteImportacion, @TotalTotalIVAImportacion,  @TotalTotalServicioNeto,  @TotalTotalServicioIVA,  @TotalTotalBienesNeto, @TotalTotalBienesIVA, @TotalTotalExcento )
INSERT @Tabla (Tipo,          TotalFactura,         Importacion,                   IVAImportacion,             ServiciosNeto,            IVAServicios,            BienesNeto,            IVABienes,            TotalExcento       )
VALUES ('Total Vienen',@TotalTotalFactura,   @TotalTotalImporteImportacion, @TotalTotalIVAImportacion,  @TotalTotalServicioNeto,  @TotalTotalServicioIVA,  @TotalTotalBienesNeto, @TotalTotalBienesIVA, @TotalTotalExcento )
SET @Contador = 0
END
SET @Contador = @Contador + 1
FETCH NEXT FROM crLibroCompraGuatemala INTO @DocumentoNo, @Dia, @Mes, @Ano, @TipoDeDocumento, @Nombre, @TotalFactura, @TotalCantidadImportacion, @TotalImporteImportacion, @TotalImpuestoImportacion,	@TotalCantidadServicio, @TotalImporteServicio, @TotalImpuestoServicio, @ServicioNeto, @TotalCantidadBienes, @TotalImporteBienes, @TotalImpuestoBienes, @BienesNeto, @TotalExcento
END
CLOSE crLibroCompraGuatemala
DEALLOCATE crLibroCompraGuatemala
INSERT @Tabla (Tipo,           TotalFactura,         Importacion,                   IVAImportacion,             ServiciosNeto,            IVAServicios,            BienesNeto,            IVABienes,            TotalExcento       )
VALUES ('Total General',@TotalTotalFactura,   @TotalTotalImporteImportacion, @TotalTotalIVAImportacion,  @TotalTotalServicioNeto,  @TotalTotalServicioIVA,  @TotalTotalBienesNeto, @TotalTotalBienesIVA, @TotalTotalExcento )
SELECT * FROM @Tabla
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION @Transaccion
END ELSE
BEGIN
ROLLBACK TRANSACTION @Transaccion
SELECT 'ERROR: ' + CONVERT(varchar,@Ok) + (SELECT Descripcion FROM MensajeLista WHERE Mensaje = @Ok) +'. ' + ISNULL(@OkRef,'')
END
END

