SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDCorteCxc AS
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,Corte.ID))))) + RTRIM(LTRIM(CONVERT(varchar,Corte.ID))) +
REPLICATE(' ',12) +
REPLICATE(' ',7) +
REPLICATE(' ',50)
OrdenExportacion,
Corte.ID ID,
dbo.fnSerieConsecutivo(Corte.MovID) CorteSerie,
dbo.fnFolioConsecutivo(Corte.MovID) CorteFolio,
CONVERT(datetime,Corte.FechaRegistro, 126) CorteFechaRegistro,
Corte.Mov CorteMov,
Corte.MovID CorteMovID,
Corte.Moneda CorteMoneda,
Corte.TipoCambio CorteTipoCambio,
Corte.Estatus CorteEstatus,
Corte.Ejercicio CorteEjercicio,
Corte.Periodo CortePeriodo,
Corte.CorteFechaD CorteFechaDe,
Corte.FechaConclusion CorteFechaA,
'Del ' + CONVERT(varchar, Corte.CorteFechaD, 103) + ' al ' + CONVERT(varchar, Corte.FechaConclusion, 103) CortePeriodoFechas,
Corte.Concepto CorteConcepto,
Corte.CorteCuentaDe CorteClienteDe,
Corte.CorteCuentaA CorteClienteA,
Empresa.GLN EmpresaGLN,
Empresa.Nombre EmpresaNombre,
Empresa.RFC EmpresaRFC,
Empresa.Direccion EmpresaCalle,
Empresa.DireccionNumero EmpresaNumeroExterior,
Empresa.DireccionNumeroInt EmpresaNumeroInterior,
Empresa.Colonia EmpresaColonia,
Empresa.Poblacion EmpresaLocalidad,
Empresa.Delegacion EmpresaMunicipio,
Empresa.Estado EmpresaEstado,
Empresa.Pais EmpresaPais,
Empresa.CodigoPostal EmpresaCodigoPostal,
Sucursal.GLN SucursalGLN,
Sucursal.Nombre SucursalNombre,
Sucursal.RFC SucursalRFC,
Sucursal.Direccion SucursalCalle,
Sucursal.DireccionNumero SucursalNumeroExterior,
Sucursal.DireccionNumeroInt SucursalNumeroInterior,
Sucursal.Colonia SucursalColonia,
Sucursal.Delegacion + ', ' + Sucursal.Estado SucursalLocalidad,
Sucursal.Delegacion SucursalMunicipio,
Sucursal.Estado SucursalEstado,
Sucursal.Pais SucursalPais,
Sucursal.CodigoPostal SucursalCodigoPostal,
Cte.Cliente ClienteClave,
Cte.Nombre ClienteNombre,
Cte.RFC ClienteRFC,
Cte.GLN ClienteGLN,
Cte.Direccion ClienteCalle,
Cte.DireccionNumero ClienteNumeroExterior,
Cte.DireccionNumeroInt ClienteNumeroInterior,
Cte.Colonia ClienteColonia,
Cte.Poblacion ClienteLocalidad,
Cte.Delegacion ClienteMunicipio,
Cte.Estado ClienteEstado,
Cte.Pais ClientePais,
Cte.CodigoPostal ClienteCodigoPostal,
RTRIM(ISNULL(Cte.Direccion,'') + ' ' + ISNULL(Cte.DireccionNumero,'') + ' ' + ISNULL(Cte.DireccionNumeroInt,'')) + ', ' + ISNULL(Cte.Colonia,'') ClienteDireccion,
YEAR(CFDFolio.fechaAprobacion) CFDanoAprobacion,
CFDFolio.noAprobacion CFDnoAprobacion,
LOWER(mt.CFD_TipoDeComprobante) CorteTipoComprobante
FROM Corte
JOIN Empresa  ON Corte.Empresa = Empresa.Empresa
JOIN Sucursal ON Corte.Sucursal = Sucursal.Sucursal
JOIN Cte		ON Corte.CorteCuentaTipo = 'Cliente' AND Cte.Cliente BETWEEN Corte.CorteCuentaDe AND Corte.CorteCuentaA
JOIN MovTipo mt ON mt.Mov = Corte.Mov AND mt.Modulo = 'CORTE'
LEFT OUTER JOIN CFDFolio ON CFDFolio.Empresa = Corte.Empresa
AND CFDFolio.Modulo = mt.ConsecutivoModulo
AND CFDFolio.Mov = mt.ConsecutivoMov
AND CFDFolio.FechaAprobacion <= Corte.FechaRegistro
AND dbo.fnFolioConsecutivo(Corte.MovID) BETWEEN CFDFolio.FolioD AND CFDFolio.FolioA
AND ISNULL(dbo.fnSerieConsecutivo(Corte.MovID),'') = ISNULL(CFDFolio.Serie,'')
AND (CASE WHEN ISNULL(CFDFolio.Nivel,'') = 'Sucursal' THEN ISNULL(CFDFolio.Sucursal,0) ELSE Corte.Sucursal END) = Corte.Sucursal
AND CFDFolio.Estatus = 'ALTA'
LEFT OUTER JOIN CFD ON CFD.ModuloID = Corte.ID AND CFD.Modulo = 'CORTE'

