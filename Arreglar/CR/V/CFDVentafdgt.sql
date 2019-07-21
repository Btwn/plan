SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDVentafdgt AS
SELECT
REPLICATE('0',20-LEN(RTRIM(LTRIM(CONVERT(varchar,Venta.ID))))) + RTRIM(LTRIM(CONVERT(varchar,Venta.ID))) +
REPLICATE(' ',12) +
REPLICATE(' ',7) +
REPLICATE(' ',50)
OrdenExportacion,
Venta.ID ID,
dbo.fnSerieConsecutivo(Venta.MovID) VentaSerie,
dbo.fnFolioConsecutivo(Venta.MovID) VentaFolio,
CONVERT(datetime,Venta.FechaRegistro, 126) VentaFechaRegistro,
Venta.Condicion VentaCondicion,
vtce.ImporteDescuentoGlobal*dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN)) VentaImporteDescuentoGlobal,
vtce.ImporteSobrePrecio*dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN)) VentaImporteSobrePrecio,
(vtce.SubTotal -ISNULL((AnticiposFacturados-ISNULL(AnticiposImpuestos,0.0)),0))*dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN)) VentaSubTotal ,
(vtce.Impuesto1Total-ISNULL(AnticiposImpuestos,0.0))*dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN)) VentaImpuesto1Total,
vtce.Impuesto2Total*dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN)) VentaImpuesto2Total,
vtce.Impuesto3Total*dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN)) VentaImpuesto3Total,
(vtce.ImporteTotal-ISNULL((AnticiposFacturados-ISNULL(AnticiposImpuestos,0.0)),0))*dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN)) VentaImporteTotal,
((vtce.ImporteTotal-ISNULL((AnticiposFacturados-ISNULL(AnticiposImpuestos,0.0)),0))-(ISNULL(Venta.Retencion,0.0)+ISNULL(AnticiposImpuestos,0.0)))*dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN)) VentaTotal,
vtce.DescuentosTotales*dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN)) VentaDescuentoImporte,
(vtce.Impuestos-ISNULL(AnticiposImpuestos,0.0))*dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN)) VentaImpuestos,
Venta.FormaPagoTipo VentaFormaPago,
LOWER(mt.CFD_TipoDeComprobante) VentaTipoComprobante,
CASE WHEN Venta.Estatus IN ('CONCLUIDO','PENDIENTE') THEN 'ORIGINAL' ELSE 'DELETE' END VentaEstatusCancelacion,
CASE
WHEN mt.Clave IN ('VTAS.F','VTAS.FM','VTAS.FR') THEN 'INVOICE'
WHEN mt.Clave IN ('VTAS.B','VTAS.D','VTAS.DF')  THEN 'CREDIT_NOTE'
END VentaTipoDocumento,
Venta.Mov VentaMov,
Venta.MovID VentaMovID,
dbo.fnNumeroEnEspanol(vtce.TotalNeto, CASE WHEN ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN) = 1 THEN 'M.N.' ELSE Venta.Moneda END) VentaImporteSinRetencionesLetra,
dbo.fnNumeroEnEspanol(vtce.TotalNeto-ISNULL(Venta.Retencion,0.00), CASE WHEN ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN) = 1 THEN 'M.N.' ELSE Venta.Moneda END) VentaImporteLetra,
Venta.OrdenCompra VentaOrdenCompra,
Venta.FechaOrdenCompra VentaOrdenCompraFecha,
CASE WHEN ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN) = 1 THEN 'M.N.' ELSE Venta.Moneda END VentaMoneda,
Venta.TipoCambio VentaTipoCambio,
Venta.Estatus VentaEstatus,
Venta.Departamento,
Venta.Retencion VentaRetencionTotal,
Venta.Vencimiento VentaVencimiento,
Venta.FechaRequerida VentaFechaRequerida,
Venta.FechaOrdenCompra VentaFechaOrdenCompra,
Venta.ReferenciaOrdenCompra VentaReferenciaOrdenCompra,
Venta.Atencion VentaAtencion,
Venta.Observaciones VentaObservaciones,
Venta.AtencionTelefono VentaAtencionTelefono,
Venta.Referencia VentaReferencia,
NULLIF(RIGHT(Venta.Referencia, 4),'no indentificado') NumCtaPago,
mt.Clave VentaClaveAfectacion,
mt.SubClave VentaSubClaveAfectacion,
Empresa.GLN EmpresaGLN,
Empresa.Nombre EmpresaNombre,
REPLACE(Empresa.RFC,'-','') EmpresaRFC,
Empresa.Direccion EmpresaCalle,
Empresa.DireccionNumero EmpresaNumeroExterior,
Empresa.DireccionNumeroInt EmpresaNumeroInterior,
Empresa.Colonia EmpresaColonia,
Empresa.Poblacion EmpresaLocalidad,
Empresa.Delegacion EmpresaMunicipio,
Empresa.Estado EmpresaEstado,
Empresa.Pais EmpresaPais,
Empresa.CodigoPostal EmpresaCodigoPostal,
Sucursal.Sucursal Sucursal,
Sucursal.GLN SucursalGLN,
Sucursal.Nombre SucursalNombre,
REPLACE(Sucursal.RFC,'-','') SucursalRFC,
Sucursal.Direccion SucursalCalle,
Sucursal.DireccionNumero SucursalNumeroExterior,
Sucursal.DireccionNumeroInt SucursalNumeroInterior,
Sucursal.Colonia SucursalColonia,
Sucursal.Delegacion + ', ' + Sucursal.Estado SucursalLocalidad,
Sucursal.Delegacion SucursalMunicipio,
Sucursal.Estado SucursalEstado,
Sucursal.Pais SucursalPais,
Sucursal.CodigoPostal SucursalCodigoPostal,
CteEnviarA.GLN CteEnviarAGLN,
CteEnviarA.Nombre CteEnviarANombre,
CteEnviarA.Direccion CteEnviarACalle,
CteEnviarA.DireccionNumero CteEnviarANumeroExterior,
CteEnviarA.DireccionNumeroInt CteEnviarANumeroInterior,
CteEnviarA.Colonia CteEnviarAColonia,
CteEnviarA.Poblacion CteEnviarALocalidad,
CteEnviarA.Delegacion CteEnviarAMunicipio,
CteEnviarA.Estado CteEnviarAEstado,
CteEnviarA.Pais CteEnviarAPais,
CteEnviarA.CodigoPostal CteEnviarACodigoPostal,
CteEnviarA.Clave CteEnviarAClave,
CteEmpresaCFD.EmisorID ClienteEmisorID,
ISNULL(CteDeptoEnviarA.ProveedorID, CteEmpresaCFD.ProveedorID) ClienteProveedorID,
Cte.Cliente ClienteClave,
Cte.Nombre ClienteNombre,
REPLACE(Cte.RFC,'-','') ClienteRFC,
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
Cte.Telefonos ClienteTelefonos,
RTRIM(ISNULL(Cte.Direccion,'') + ' ' + ISNULL(Cte.DireccionNumero,'') + ' ' + ISNULL(Cte.DireccionNumeroInt,'')) + ', ' + ISNULL(Cte.Colonia,'') ClienteDireccion,
CASE
WHEN Condicion.TipoCondicion = 'Credito' THEN 'DATE_OF_INVOICE'
WHEN Condicion.TipoCondicion = 'Contado' THEN 'EFFECTIVE_DATE'
END VentaTipoPago,
Cte.PersonalCobrador ClientePersonalCobrador,
CteCFD.ReceptorID ClienteReceptorID,
CteDepto.Clave CteDeptoClave,
CteDepto.Contacto CteDeptocontacto,
ISNULL(Condicion.DiasVencimiento,0) CondicionDiasVencimiento,
Condicion.CFD_MetodoDePago CondicionMetodoDePago,
Condicion.CFD_FormaDePago CondicionFormaDePago,
Condicion.DescuentoProntoPago CondicionDescuentoProntoPago,
Descuento.Clave VentaDescuentoGlobalClave,
Descuento.Porcentaje VentaPorcentajeDescuentoGlobal,
CFDFolio.fechaAprobacion CFDFoliofechaAprobacion,
CFDFolio.FolioD CFDFolioFolioD,
CFDFolio.FolioA CFDFolioFolioA,
CFDFolio.noAprobacion CFDFolionoAprobacion,
GETDATE() VariosAhora,
RTRIM('VTAS')+CONVERT(varchar, Venta.ID) VariosModuloID,
VentaEntrega.Embarque	VentaEntregaEmbarque,
VentaEntrega.EmbarqueFecha VentaEntregaEmbarqueFecha,
VentaEntrega.EmbarqueReferencia VentaEntregaEmbarqueReferencia,
VentaEntrega.Recibo VentaEntregaRecibo,
VentaEntrega.ReciboFecha VentaEntregaReciboFecha,
VentaEntrega.ReciboReferencia VentaEntregaReciboReferencia,
VentaEntrega.Sucursal VentaEntregaSucursal,
VentaEntrega.SucursalOrigen VentaEntregaSucursalOrigen,
VentaEntrega.EntregaMercancia VentaEntregaEntregaMercancia,
VentaEntrega.TotalCajas VentaEntregaTotalCajas,
CFD.Modulo CFDModulo,
CFD.ModuloID CFDModuloID,
CFD.Fecha CFDFecha,
CFD.Ejercicio CFDEjercicio,
CFD.Periodo CFDPeriodo,
CFD.Empresa CFDEmpresa,
CFD.MovID CFDMovID,
CFD.Serie CFDSerie,
CFD.Folio CFDFolio,
CFD.RFC CFDRFC,
CFD.Aprobacion CFDAprobacion,
CFD.Importe CFDImporte,
CFD.Impuesto1 CFDImpuesto1,
CFD.Impuesto2 CFDImpuesto2,
CFD.FechaCancelacion CFDFechaCancelacion,
CFD.noCertificado CFDnoCertificado,
CFD.Sello CFDSello,
CFD.CadenaOriginal CFDCadenaOriginal,
CFD.CadenaOriginal1 CFDCadenaOriginal1,
CFD.CadenaOriginal2 CFDCadenaOriginal2,
CFD.CadenaOriginal3 CFDCadenaOriginal3,
CFD.CadenaOriginal4 CFDCadenaOriginal4,
CFD.CadenaOriginal5 CFDCadenaOriginal5,
CFD.GenerarPDF CFDGenerarPDF,
CFD.Retencion1 CFDRetencion1,
CFD.Retencion2 CFDRetencion2,
CFD.TipoCambio CFDTipoCambio,
CFD.Timbrado CFDTimbrado,
CFD.UUID CFDUUID,
CFD.FechaTimbrado CFDFechaTimbrado,
CFD.SelloSAT CFDSelloSAT,
CFD.TFDVersion CFDTFDVersion,
CFD.noCertificadoSAT CFDnoCertificadoSAT,
dbo.fnCFDVentafdgtFormEmail(Venta.Cliente, Venta.Empresa) fdgtFormEmail,
dbo.fnCFDVentafdgtToEmail(Venta.Cliente, Venta.Empresa) fdgtToEmail,
dbo.fnCFDVentafdgtCcEmail(Venta.Cliente, Venta.Empresa)  fdgtCcEmail,
dbo.fnCFDVentafdgtFormatsEmail(Venta.Cliente, Venta.Empresa) fdgtFormatsEmail,
dbo.fnCFDVentafdgtInformacionDeRegimenIsr(Venta.Empresa) fdgtInformacionDeRegimenIsr,
dbo.fnCFDVentafdgtDispositivoElectronicoVendedor(Venta.Empresa) fdgtDispositivoElectronicoVendedor,
mt.CFD_tipoDeComprobante mtTipoDeCombrobante
FROM Venta JOIN Empresa
ON Venta.Empresa = Empresa.Empresa JOIN EmpresaGral
ON Empresa.Empresa = EmpresaGral.Empresa JOIN Cte
ON Cte.Cliente = Venta.Cliente JOIN Sucursal
ON Venta.Sucursal = Sucursal.Sucursal JOIN VentaTCalcExportacion vtce
ON vtce.ID = Venta.ID JOIN MovTipo mt
ON mt.Mov = Venta.Mov AND mt.Modulo = 'VTAS' LEFT OUTER JOIN EmpresaCFD
ON Venta.Empresa = EmpresaCFD.Empresa LEFT OUTER JOIN Condicion
ON Condicion.Condicion = Venta.Condicion LEFT OUTER JOIN Descuento
ON Descuento.Descuento = Venta.Descuento LEFT OUTER JOIN CFDFolio
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

