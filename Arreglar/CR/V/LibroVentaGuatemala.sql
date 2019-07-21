SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW LibroVentaGuatemala
AS
SELECT
v.Empresa,
ISNULL(v.MovId,'') As DocumentoNo,
RIGHT('0' + CONVERT(varchar,DATEPART(DAY, v.FechaEmision)),2) Dia,
RIGHT('0' + CONVERT(varchar,DATEPART(MONTH, v.FechaEmision)),2) Mes,
CONVERT(varchar,DATEPART(YEAR, v.FechaEmision)) Ano,
CASE
WHEN (mt.Clave = 'VTAS.F') THEN 'Factura'
WHEN (mt.Clave = 'VTAS.EST') AND (mt.SubClave = 'VTAS.FA') THEN 'Factura'
WHEN (mt.Clave = 'VTAS.D') THEN 'Devolucion'
WHEN (vtg.GuatemalaLibroVentaExento = 1) AND (mt.Clave NOT IN ('VTAS.F','VTAS.D','VTAS.EST'))THEN 'Exento'
END TipodeDocumento,
cte.Nombre,
ISNULL(v.Importe,0.0) + ISNULL(v.Impuestos,0.0) TotalFactura,
CASE WHEN v.Estatus <> 'CANCELADO' THEN vtg.TotalCantidadExportacion ELSE 0.0 END TotalCantidadExportacion,
CASE WHEN v.Estatus <> 'CANCELADO' THEN vtg.TotalImporteExportacion ELSE 0.0 END TotalImporteExportacion,
CASE WHEN v.Estatus <> 'CANCELADO' THEN vtg.TotalImpuestoExportacion ELSE 0.0 END TotalImpuestoExportacion,
CASE WHEN v.Estatus <> 'CANCELADO' THEN (vtg.TotalImporteExportacion + vtg.TotalImpuestoExportacion) ELSE 0.0 END ExpotacionNeto,
CASE WHEN v.Estatus <> 'CANCELADO' THEN vtg.TotalCantidadServicio ELSE 0.0 END TotalCantidadServicio,
CASE WHEN v.Estatus <> 'CANCELADO' THEN vtg.TotalImporteServicio ELSE 0.0 END TotalImporteServicio,
CASE WHEN v.Estatus <> 'CANCELADO' THEN vtg.TotalImpuestoServicio ELSE 0.0 END TotalImpuestoServicio,
CASE WHEN v.Estatus <> 'CANCELADO' THEN (vtg.TotalImporteServicio + vtg.TotalImpuestoServicio) ELSE 0.0 END ServicioNeto,
CASE WHEN v.Estatus <> 'CANCELADO' THEN vtg.TotalCantidadBienes ELSE 0.0 END TotalCantidadBienes,
CASE WHEN v.Estatus <> 'CANCELADO' THEN vtg.TotalImporteBienes ELSE 0.0 END TotalImporteBienes,
CASE WHEN v.Estatus <> 'CANCELADO' THEN vtg.TotalImpuestoBienes ELSE 0.0 END TotalImpuestoBienes,
CASE WHEN v.Estatus <> 'CANCELADO' THEN (vtg.TotalImporteBienes + vtg.TotalImpuestoBienes) ELSE 0.0 END BienesNeto,
CASE WHEN v.Estatus <> 'CANCELADO' THEN vtg.TotalExcento ELSE 0.0 END TotalExcento,
vtg.GuatemalaLibroVentaExento,
v.Estatus,
v.Periodo,
v.Ejercicio
FROM	Venta v JOIN MovTipo mt
ON  v.Mov = mt.Mov AND mt.Modulo = 'VTAS' JOIN Cte
ON  v.Cliente = Cte.Cliente JOIN VentaTotalGuatemala vtg
ON  v.ID = vtg.ID AND vtg.Modulo = 'VTAS'
WHERE mt.Clave IN ('VTAS.F','VTAS.D','VTAS.B') OR (mt.Clave IN ('VTAS.EST') AND mt.SubClave in ('VTAS.FA'))
UNION ALL
SELECT
v.Empresa,
ISNULL(v.MovId,'') As DocumentoNo,
RIGHT('0' + CONVERT(varchar,DATEPART(DAY, v.FechaEmision)),2) Dia,
RIGHT('0' + CONVERT(varchar,DATEPART(MONTH, v.FechaEmision)),2) Mes,
CONVERT(varchar,DATEPART(YEAR, v.FechaEmision)) Ano,
CASE
WHEN (mt.Clave = 'CXC.CA') THEN 'Nota De Debito'
WHEN (mt.Clave = 'CXC.NC') THEN 'Nota Credito'
END TipodeDocumento,
cte.Nombre,
ISNULL(v.Importe,0.0) + ISNULL(v.Impuestos,0.0) TotalFactura,
CASE WHEN v.Estatus <> 'CANCELADO' THEN vtg.TotalCantidadExportacion ELSE 0.0 END TotalCantidadExportacion,
CASE WHEN v.Estatus <> 'CANCELADO' THEN vtg.TotalImporteExportacion ELSE 0.0 END TotalImporteExportacion,
CASE WHEN v.Estatus <> 'CANCELADO' THEN vtg.TotalImpuestoExportacion ELSE 0.0 END TotalImpuestoExportacion,
CASE WHEN v.Estatus <> 'CANCELADO' THEN (vtg.TotalImporteExportacion + vtg.TotalImpuestoExportacion) ELSE 0.0 END ExpotacionNeto,
CASE WHEN v.Estatus <> 'CANCELADO' THEN vtg.TotalCantidadServicio ELSE 0.0 END TotalCantidadServicio,
CASE WHEN v.Estatus <> 'CANCELADO' THEN vtg.TotalImporteServicio ELSE 0.0 END TotalImporteServicio,
CASE WHEN v.Estatus <> 'CANCELADO' THEN vtg.TotalImpuestoServicio ELSE 0.0 END TotalImpuestoServicio,
CASE WHEN v.Estatus <> 'CANCELADO' THEN (vtg.TotalImporteServicio + vtg.TotalImpuestoServicio) ELSE 0.0 END ServicioNeto,
CASE WHEN v.Estatus <> 'CANCELADO' THEN vtg.TotalCantidadBienes ELSE 0.0 END TotalCantidadBienes,
CASE WHEN v.Estatus <> 'CANCELADO' THEN vtg.TotalImporteBienes ELSE 0.0 END TotalImporteBienes,
CASE WHEN v.Estatus <> 'CANCELADO' THEN vtg.TotalImpuestoBienes ELSE 0.0 END TotalImpuestoBienes,
CASE WHEN v.Estatus <> 'CANCELADO' THEN (vtg.TotalImporteBienes + vtg.TotalImpuestoBienes) ELSE 0.0 END BienesNeto,
CASE WHEN v.Estatus <> 'CANCELADO' THEN vtg.TotalExcento ELSE 0.0 END TotalExcento,
vtg.GuatemalaLibroVentaExento,
v.Estatus,
v.Periodo,
v.Ejercicio
FROM	Cxc v JOIN MovTipo mt
ON  v.Mov = mt.Mov AND mt.Modulo = 'CXC' JOIN Cte
ON  v.Cliente = Cte.Cliente JOIN VentaTotalGuatemala vtg
ON  v.ID = vtg.ID AND vtg.Modulo = 'CXC'
WHERE mt.Clave IN ('CXC.CA','CXC.NC')

