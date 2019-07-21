SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDFlex AS
SELECT
CFD.Modulo,
CFD.ModuloID,
CFD.Fecha,
CFD.Ejercicio,
CFD.Periodo,
CFD.Empresa,
CFD.MovID,
CFD.Serie,
CFD.Folio,
CFD.RFC,
CFD.Aprobacion,
CFD.Importe,
CFD.Impuesto1,
CFD.Impuesto2,
CFD.FechaCancelacion,
CFD.noCertificado,
CFD.Sello,
CFD.CadenaOriginal,
CFD.Documento,
Convert(varchar(50),CFD.UUID) UUIDTexto,
Convert(varchar(50),CFD.OrigenUUID) OrigenUUIDTexto,
CFD.GenerarPDF,
CASE WHEN ISNULL(CFD.GenerarPDF,0) = 1 THEN 'CONCLUIDO' ELSE 'PENDIENTE' END Estatus,
CASE WHEN ISNULL(CFD.Timbrado,0) = 1 AND ISNULL(CFD.Cancelado,0) = 0 THEN 434 WHEN ISNULL(CFD.Cancelado,0) = 1 THEN 431 ELSE 435 END Icono,
CFD.Timbrado,
CFD.UUID,
CFD.FechaTimbrado,
CASE CFD.Modulo
WHEN 'VTAS' THEN Venta.Estatus
WHEN 'COMS' THEN Compra.Estatus
WHEN 'CXC'  THEN Cxc.Estatus
WHEN 'CXP'  THEN Cxp.Estatus
END EstatusMov,
CFD.OrigenUUID,
CFD.OrigenSerie,
CFD.OrigenFolio,
CFD.ParcialidadNumero,
CFD.Cancelado,
CFD.AcuseCancelado,
CFD.RutaAcuse,
CASE CFD.Modulo
WHEN 'VTAS' THEN Venta.Mov
WHEN 'COMS' THEN Compra.Mov
WHEN 'CXC'  THEN Cxc.Mov
WHEN 'CXP'  THEN Cxp.Mov
END Mov,
dbo.fnFechaSinHora(CFD.Fecha) FechaSinHora
FROM CFD
LEFT OUTER JOIN Venta  ON 'VTAS' = CFD.Modulo AND Venta.ID  = CFD.ModuloID
LEFT OUTER JOIN Compra ON 'COMS' = CFD.Modulo AND Compra.ID = CFD.ModuloID
LEFT OUTER JOIN Cxc    ON 'CXC'  = CFD.Modulo AND Cxc.ID    = CFD.ModuloID
LEFT OUTER JOIN Cxp    ON 'CXP'  = CFD.Modulo AND Cxp.ID    = CFD.ModuloID

