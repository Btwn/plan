SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDVentaINE AS
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,Venta.ID))))) + RTRIM(LTRIM(CONVERT(varchar,Venta.ID))) +
REPLICATE(' ',12) +
REPLICATE(' ',7) +
REPLICATE(' ',50)
OrdenExportacion,
Venta.ID ID,
CASE ISNULL(Venta.EnviarA,-1) WHEN -1 THEN CteCFD.TipoProceso ELSE CteEnviarA.TipoProceso END TipoProceso,
CASE ISNULL(Venta.EnviarA,-1) WHEN -1 THEN CteCFD.TipoComite ELSE CteEnviarA.TipoComite END TipoComite,
CASE ISNULL(Venta.EnviarA,-1) WHEN -1 THEN CteCFD.IdContabilidad ELSE CteEnviarA.IdContabilidad END IdContabilidad,
CASE ISNULL(Venta.EnviarA,-1) WHEN -1 THEN CteCFD.ClaveEntidad ELSE CteEnviarA.ClaveEntidad END ClaveEntidad,
CASE ISNULL(Venta.EnviarA,-1) WHEN -1 THEN CteCFD.Ambito ELSE CteEnviarA.Ambito END Ambito,
CASE ISNULL(Venta.EnviarA,-1) WHEN -1 THEN CteCFD.EntidadIdContabilidad ELSE CteEnviarA.EntidadIdContabilidad END EntidadIdContabilidad
FROM Venta JOIN Empresa
ON Venta.Empresa = Empresa.Empresa JOIN Cte
ON Cte.Cliente = Venta.Cliente JOIN Sucursal
ON Venta.Sucursal = Sucursal.Sucursal JOIN VentaTCalcExportacion vtce
ON vtce.ID = Venta.ID JOIN MovTipo mt
ON mt.Mov = Venta.Mov AND mt.Modulo = 'VTAS' LEFT OUTER JOIN EmpresaCFD
ON Venta.Empresa = EmpresaCFD.Empresa LEFT OUTER JOIN Condicion
ON Condicion.Condicion = Venta.Condicion LEFT OUTER JOIN Descuento
ON Descuento.Descuento = Venta.Descuento  LEFT OUTER JOIN Mon
ON Mon.Moneda =venta.Moneda LEFT OUTER JOIN CFDFolio
ON CFDFolio.Empresa = Venta.Empresa
AND CFDFolio.Modulo = mt.ConsecutivoModulo
AND CFDFolio.Mov = mt.ConsecutivoMov
AND CFDFolio.FechaAprobacion <= Venta.FechaRegistro
AND dbo.fnFolioConsecutivo(Venta.MovID) BETWEEN CFDFolio.FolioD AND CFDFolio.FolioA
AND ISNULL(dbo.fnSerieConsecutivo(Venta.MovID),'') = ISNULL(CFDFolio.Serie,'')
AND (CASE WHEN ISNULL(CFDFolio.Nivel,'') = 'Sucursal' THEN ISNULL(CFDFolio.Sucursal,0) ELSE Venta.Sucursal END) = Venta.Sucursal
AND CFDFolio.Estatus = 'ALTA'
LEFT OUTER JOIN CteEmpresaCFD
ON Venta.Cliente = CteEmpresaCFD.Cliente AND Venta.Empresa = CteEmpresaCFD.Empresa LEFT OUTER JOIN   CteDeptoEnviarA
ON CteDeptoEnviarA.Empresa = Venta.Empresa AND CteDeptoEnviarA.Departamento = Venta.Departamento AND CteDeptoEnviarA.Cliente = Venta.Cliente AND CteDeptoEnviarA.EnviarA = Venta.EnviarA LEFT OUTER JOIN CteCFD
ON CteCFD.Cliente = Venta.Cliente LEFT OUTER JOIN VentaEntrega
ON Venta.ID = VentaEntrega.ID LEFT OUTER JOIN CteEnviarA
ON Venta.Cliente = CteEnviarA.Cliente AND Venta.EnviarA = CteEnviarA.ID LEFT OUTER JOIN CteDepto
ON Venta.Cliente = CteDepto.Cliente AND Venta.Departamento=CteDepto.Departamento LEFT OUTER JOIN CFD
ON CFD.ModuloID = Venta.ID AND CFD.Modulo = 'VTAS'

