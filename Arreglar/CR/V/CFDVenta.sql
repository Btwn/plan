SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CFDVenta AS
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
((vtce.ImporteTotal-ISNULL((AnticiposFacturados-ISNULL(AnticiposImpuestos,0.0)),0))-(ISNULL(Venta.Retencion,0.0)+ISNULL(AnticiposImpuestos,0.0)))*dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN)) VentaImporteTotal,
((vtce.ImporteTotal-ISNULL((AnticiposFacturados-ISNULL(AnticiposImpuestos,0.0)),0))-(ISNULL(Venta.Retencion,0.0)+ISNULL(AnticiposImpuestos,0.0)))*dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN)) VentaTotal,
vtce.DescuentosTotales*dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN)) VentaDescuentoImporte,
dbo.fnCFDVentaMovImpuestoExcento(Venta.ID,(vtce.Impuestos-ISNULL(AnticiposImpuestos,0.0))*dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN))) VentaImpuestos,
Venta.FormaPagoTipo VentaFormaPago,
LOWER(mt.CFD_TipoDeComprobante) VentaTipoComprobante,
CASE WHEN Venta.Estatus IN ('CONCLUIDO','PENDIENTE') THEN 'ORIGINAL' ELSE 'DELETE' END VentaEstatusCancelacion,
CASE
WHEN mt.Clave IN ('VTAS.F','VTAS.FM','VTAS.FR') THEN 'INVOICE'
WHEN mt.Clave IN ('VTAS.B','VTAS.D','VTAS.DF')  THEN 'CREDIT_NOTE'
END VentaTipoDocumento,
Venta.Mov VentaMov,
Venta.MovID VentaMovID,
dbo.fnNumeroEnEspanol(vtce.TotalNeto, CASE WHEN ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN) = 1 THEN 'M.N.' ELSE Venta.Moneda END) VentaImporteLetra,
Venta.OrdenCompra VentaOrdenCompra,
Venta.FechaOrdenCompra VentaOrdenCompraFecha,
Mon.Clave  VentaMoneda ,
Venta.TipoCambio VentaTipoCambio,
Venta.Estatus VentaEstatus,
Venta.Departamento,
dbo.fnCFDVentaMovRetencionExcento(Venta.ID,Venta.Retencion)*dbo.fnCFDTipoCambioMN(Venta.TipoCambio, ISNULL(mt.SAT_MN, EmpresaCFD.SAT_MN)) VentaRetencionTotal,
Venta.Vencimiento VentaVencimiento,
Venta.FechaRequerida VentaFechaRequerida,
Venta.FechaOrdenCompra VentaFechaOrdenCompra,
Venta.ReferenciaOrdenCompra VentaReferenciaOrdenCompra,
Venta.Atencion VentaAtencion,
Venta.Observaciones VentaObservaciones,
Venta.AtencionTelefono VentaAtencionTelefono,
NULLIF(RIGHT(Venta.Referencia, 4),'No Aplica') NumCtaPago,
mt.Clave VentaClaveAfectacion,
mt.SubClave VentaSubClaveAfectacion,
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
YEAR(CFDFolio.fechaAprobacion) CFDanoAprobacion,
CFDFolio.noAprobacion CFDnoAprobacion,
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
Venta.ID CFDModuloID,
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
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación' THEN '2' WHEN 'Exportación de Servicios' THEN 'A' ELSE NULL END vcfdTipoOperacion,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE CASE ISNULL(Empresa.ClavePedimento,'') WHEN '' THEN NULL ELSE SATClavePedimento.Clave END END vcfdClavePedimento,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE CASE ISNULL(Empresa.CertificadoOrigen,'') WHEN 'Funge como Certificado de Origen' THEN '1' WHEN 'No Funge como Certificado de Origen' THEN '0' ELSE NULL END END vcfdCertificadoOrigen,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE CASE ISNULL(Empresa.CertificadoOrigen,'') WHEN 'No Funge como Certificado de Origen' THEN NULL ELSE CASE ISNULL(Empresa.NumCertificadoOrigen,'') WHEN '' THEN NULL ELSE Empresa.NumCertificadoOrigen END END END vcfdNumCertificadoOrigen,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE CASE ISNULL(Empresa.NumeroExportadorConfiable,'') WHEN '' THEN NULL ELSE Empresa.NumeroExportadorConfiable END END vcfdNumeroExportadorConfiable,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE CASE ISNULL(vcfd.Incoterm,'') WHEN '' THEN NULL ELSE vcfd.Incoterm END END vcfdIncoterm,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE CASE ISNULL(vcfd.Subdivision,'') WHEN 'No tiene subdivisión' THEN '0' WHEN 'Si tiene subdivisión' THEN '1' ELSE NULL END END vcfdSubdivision,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE CASE ISNULL(Mon.Clave,'') WHEN 'USD' THEN Mon.TipoCambio ELSE dbo.fnMonTipoCambioUSD(Mon.Moneda) END END vcfdTipoCambioUSD,
CteCFD.NumRegIdTrib CteNumRegIdTrib,
CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE CONVERT(DECIMAL(20,2), (SELECT SUM(VentaDTotalUSD) FROM CFDVentaDExt WHERE ID = Venta.ID)) END VentaTotalUSD,
DestinatarioCFD.NumRegIdTrib DestinatarioNumRegIdTrib,
CASE ISNULL(DestinatarioCFD.NumRegIdTrib,'') WHEN '' THEN Destinatario.RFC ELSE NULL END DestinatarioRFC,
Destinatario.CURP DestinatarioCURP,
Destinatario.Nombre DestinatarioNombre,
Destinatario.Direccion DestinatarioDireccion,
Destinatario.DireccionNumero DestinatarioDireccionNumero,
Destinatario.DireccionNumeroInt DestinatarioDireccionNumeroInt,
Destinatario.Colonia DestinatarioColonia,
Destinatario.Poblacion DestinatarioPoblacion,
Destinatario.Delegacion DestinatarioDelegacion,
Destinatario.Estado DestinatarioEstado,
Destinatario.CodigoPostal DestinatarioCodigoPostal,
Destinatario.EntreCalles DestinatarioEntreCalles,
CASE ISNULL(cdd.ClaveColonia,'')   WHEN '' THEN Destinatario.Colonia      ELSE cdd.ClaveColonia   END ClaveDestinatarioColonia,
CASE ISNULL(cdd.ClaveLocalidad,'') WHEN '' THEN Destinatario.Poblacion    ELSE cdd.ClaveLocalidad END ClaveDestinatarioPoblacion,
CASE ISNULL(cdd.ClaveMunicipio,'') WHEN '' THEN Destinatario.Delegacion   ELSE cdd.ClaveMunicipio END ClaveDestinatarioDelegacion,
CASE ISNULL(cdd.ClaveEstado,'')    WHEN '' THEN Destinatario.Estado       ELSE cdd.ClaveEstado    END ClaveDestinatarioEstado,
CASE ISNULL(cdd.ClavePais,'')      WHEN '' THEN Destinatario.Pais         ELSE cdd.ClavePais      END ClaveDestinatarioPais,
CASE ISNULL(cdd.ClaveCP,'')        WHEN '' THEN Destinatario.CodigoPostal ELSE cdd.ClaveCP        END ClaveDestinatarioCodigoPostal,
CASE ISNULL(ed.ClaveColonia,'')    WHEN '' THEN Empresa.Colonia           ELSE ed.ClaveColonia    END ClaveEmpresaColonia,
CASE ISNULL(ed.ClaveLocalidad,'')  WHEN '' THEN Empresa.Poblacion         ELSE ed.ClaveLocalidad  END ClaveEmpresaLocalidad,
CASE ISNULL(ed.ClaveMunicipio,'')  WHEN '' THEN Empresa.Delegacion        ELSE ed.ClaveMunicipio  END ClaveEmpresaMunicipio,
CASE ISNULL(ed.ClaveEstado,'')     WHEN '' THEN Empresa.Estado            ELSE ed.ClaveEstado     END ClaveEmpresaEstado,
CASE ISNULL(ed.ClavePais,'')       WHEN '' THEN Empresa.Pais              ELSE ed.ClavePais       END ClaveEmpresaPais,
CASE ISNULL(ed.ClaveCP,'')         WHEN '' THEN Empresa.CodigoPostal      ELSE ed.ClaveCP         END ClaveEmpresaCodigoPostal,
CASE ISNULL(sd.ClaveColonia,'')    WHEN '' THEN Sucursal.Colonia          ELSE sd.ClaveColonia    END ClaveSucursalColonia,
CASE ISNULL(sd.ClaveLocalidad,'')  WHEN '' THEN Sucursal.Poblacion        ELSE sd.ClaveLocalidad  END ClaveSucursalLocalidad,
CASE ISNULL(sd.ClaveMunicipio,'')  WHEN '' THEN Sucursal.Delegacion       ELSE sd.ClaveMunicipio  END ClaveSucursalMunicipio,
CASE ISNULL(sd.ClaveEstado,'')     WHEN '' THEN Sucursal.Estado           ELSE sd.ClaveEstado     END ClaveSucursalEstado,
CASE ISNULL(sd.ClavePais,'')       WHEN '' THEN Sucursal.Pais             ELSE sd.ClavePais       END ClaveSucursalPais,
CASE ISNULL(sd.ClaveCP,'')         WHEN '' THEN Sucursal.CodigoPostal     ELSE sd.ClaveCP         END ClaveSucursalCodigoPostal,
CASE ISNULL(cad.ClaveColonia,'')   WHEN '' THEN CteEnviarA.Colonia        ELSE cad.ClaveColonia   END ClaveCteEnviarAColonia,
CASE ISNULL(cad.ClaveLocalidad,'') WHEN '' THEN CteEnviarA.Poblacion      ELSE cad.ClaveLocalidad END ClaveCteEnviarALocalidad,
CASE ISNULL(cad.ClaveMunicipio,'') WHEN '' THEN CteEnviarA.Delegacion     ELSE cad.ClaveMunicipio END ClaveCteEnviarAMunicipio,
CASE ISNULL(cad.ClaveEstado,'')    WHEN '' THEN CteEnviarA.Estado         ELSE cad.ClaveEstado    END ClaveCteEnviarAEstado,
CASE ISNULL(cad.ClavePais,'')      WHEN '' THEN CteEnviarA.Pais           ELSE cad.ClavePais      END ClaveCteEnviarAPais,
CASE ISNULL(cad.ClaveCP,'')        WHEN '' THEN CteEnviarA.CodigoPostal   ELSE cad.ClaveCP        END ClaveCteEnviarACodigoPostal,
CASE ISNULL(cd.ClaveColonia,'')    WHEN '' THEN Cte.Colonia               ELSE cd.ClaveColonia    END ClaveClienteColonia,
CASE ISNULL(cd.ClaveLocalidad,'')  WHEN '' THEN Cte.Poblacion             ELSE cd.ClaveLocalidad  END ClaveClienteLocalidad,
CASE ISNULL(cd.ClaveMunicipio,'')  WHEN '' THEN Cte.Delegacion            ELSE cd.ClaveMunicipio  END ClaveClienteMunicipio,
CASE ISNULL(cd.ClaveEstado,'')     WHEN '' THEN Cte.Estado                ELSE cd.ClaveEstado     END ClaveClienteEstado,
CASE ISNULL(cd.ClavePais,'')       WHEN '' THEN Cte.Pais                  ELSE cd.ClavePais       END ClaveClientePais,
CASE ISNULL(cd.ClaveCP,'')         WHEN '' THEN Cte.CodigoPostal          ELSE cd.ClaveCP         END ClaveClienteCodigoPostal,
CASE LEN(Empresa.RFC) WHEN 12 THEN NULL ELSE Empresa.RepresentanteCURP END EmpresaRepresentanteCURP,
Cte.CURP ClienteCURP
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
ON CFD.ModuloID = Venta.ID AND CFD.Modulo = 'VTAS' LEFT OUTER JOIN VentaCFDIRelacionado vcfd
ON Venta.ID = vcfd.ID LEFT OUTER JOIN SATClavePedimento
ON Empresa.ClavePedimento = SATClavePedimento.Descripcion LEFT OUTER JOIN Cte Destinatario
ON vcfd.Destinatario = Destinatario.Cliente LEFT OUTER JOIN CteCFD DestinatarioCFD
ON Destinatario.Cliente = DestinatarioCFD.Cliente LEFT OUTER JOIN EmpresaDireccionFiscal ed
ON Venta.Empresa = ed.Empresa LEFT OUTER JOIN CteDireccionFiscal cd
ON Venta.Cliente = cd.Cliente LEFT OUTER JOIN SucursalDireccionFiscal sd
ON Venta.Sucursal = sd.Sucursal LEFT OUTER JOIN CteDireccionFiscal cdd
ON vcfd.Destinatario = cdd.Cliente LEFT OUTER JOIN CteEnviarADireccionFiscal cad
ON Venta.Cliente = cad.Cliente AND Venta.EnviarA = cad.ID

