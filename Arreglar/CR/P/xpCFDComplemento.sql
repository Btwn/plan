SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpCFDComplemento
@Estacion	   int,
@Modulo		   char(5),
@ID			   int,
@Empresa	   char(5),
@Sucursal	   int,
@Cliente	   varchar(10),
@Validar	   bit,
@Moneda        varchar(10),
@TipoCambio    float,
@Layout		   varchar(50),
@cfgDecimales  int,
@Total         float,
@EmpresaRFC    varchar(20),
@Ok		       int          OUTPUT,
@OkRef    	   varchar(255) OUTPUT
AS BEGIN
DECLARE
@Mov						  varchar(20),
@MovTipo                     varchar(20),
@MovTipoSubClave		      varchar(20),
@Renglon                     float,
@TipoOperacion               varchar(1),
@ClavePedimento              varchar(20),
@CertificadoOrigen           varchar(1),
@NumCertificadoOrigen        varchar(50),
@NumeroExportadorConfiable   varchar(50),
@Incoterm                    varchar(20),
@Subdivision                 varchar(1),
@TipoCambioUSD               float,
@TotalUSD                    float,
@NumRegIdTrib                varchar(40),
@RepresentanteCURP           varchar(20),
@Articulo                    varchar(20),
@FraccionArancelaria         varchar(100),
@Cantidad                    float,
@Unidad                      varchar(50),
@Precio                      float,
@TotalDUSD                   float,
@Marca                       varchar(50),
@Modelo                      varchar(50),
@SubModelo                   varchar(50),
@NumeroSerie                 varchar(50),
@UnidadClave		          varchar(50),
@ClienteRFC                  varchar(20),
@ClienteNombre               varchar(100),
@ClienteDireccion            varchar(100),
@ClienteDireccionNumero      varchar(20),
@ClienteDireccionNumeroInt   varchar(20),
@ClienteColonia              varchar(100),
@ClientePoblacion            varchar(100),
@ClienteObservaciones        varchar(100),
@ClienteDelegacion           varchar(100),
@ClienteEstado               varchar(30),
@ClientePais                 varchar(30),
@ClienteCodigoPostal         varchar(15),
@ClienteNumRegIdTrib         varchar(40),
@ClienteCURP                 varchar(40),
@Complemento                 varchar(50),
@TipoProceso                 varchar(50),
@TipoComite                  varchar(50),
@IdContabilidad              varchar(6),
@ClaveEntidad                varchar(10),
@Ambito                      varchar(50),
@EntidadIdContabilidad       varchar(6)
EXEC spMovInfo @ID, @Modulo, @Mov OUTPUT
SELECT @MovTipo = Clave, @MovTipoSubClave = SubClave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov
SELECT @Complemento = TipoComplemento FROM CteCFD WHERE Cliente = @Cliente
IF (@Modulo = 'VTAS' AND @Validar = 0) AND ((@MovTipoSubClave = 'CFDI.COMERCIOEXT') OR (ISNULL(@Complemento,'') = 'Comercio Exterior'))
BEGIN
SELECT @TipoOperacion = CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación' THEN '2' WHEN 'Exportación de Servicios' THEN 'A' ELSE NULL END,
@ClavePedimento = CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE CASE ISNULL(Empresa.ClavePedimento,'') WHEN '' THEN NULL ELSE SATClavePedimento.Clave END END,
@CertificadoOrigen = CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE CASE ISNULL(Empresa.CertificadoOrigen,'') WHEN 'Funge como Certificado de Origen' THEN '1' WHEN 'No Funge como Certificado de Origen' THEN '0' ELSE NULL END END,
@NumCertificadoOrigen = CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE CASE ISNULL(Empresa.CertificadoOrigen,'') WHEN 'No Funge como Certificado de Origen' THEN NULL ELSE CASE ISNULL(Empresa.NumCertificadoOrigen,'') WHEN '' THEN NULL ELSE Empresa.NumCertificadoOrigen END END END,
@NumeroExportadorConfiable = CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE CASE ISNULL(Empresa.NumeroExportadorConfiable,'') WHEN '' THEN NULL ELSE Empresa.NumeroExportadorConfiable END END,
@Incoterm = CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE CASE ISNULL(vcfd.Incoterm,'') WHEN '' THEN NULL ELSE vcfd.Incoterm END END,
@Subdivision = CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE CASE ISNULL(vcfd.Subdivision,'') WHEN 'No tiene subdivisión' THEN '0' WHEN 'Si tiene subdivisión' THEN '1' ELSE NULL END END,
@TipoCambioUSD = CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE CASE ISNULL(Mon.Clave,'') WHEN 'USD' THEN Mon.TipoCambio ELSE dbo.fnMonTipoCambioUSD(Mon.Moneda) END END,
@NumRegIdTrib = CteCFD.NumRegIdTrib,
@TotalUSD = CASE ISNULL(Empresa.TipoOperacion, '') WHEN 'Exportación de Servicios' THEN NULL ELSE (SELECT CONVERT(DECIMAL(20,2), SUM((VentaD.Cantidad - ISNULL(VentaD.CantidadObsequio,0.0)) * CONVERT(DECIMAL(20,2), dbo.fnVentaDTotalUSD(Moneda, (vtc.Importe/( VentaD.Cantidad - ISNULL(VentaD.CantidadObsequio,0.0)))))))
FROM VentaTCalc vtc LEFT JOIN VentaD ON vtc.ID = VentaD.ID AND vtc.Renglon = VentaD.Renglon WHERE vtc.ID = @ID) END,
@ClienteNumRegIdTrib = DestinatarioCFD.NumRegIdTrib,
@ClienteRFC = CASE ISNULL(DestinatarioCFD.NumRegIdTrib,'') WHEN '' THEN Destinatario.RFC ELSE NULL END,
@ClienteCURP = Destinatario.CURP,
@ClienteNombre = Destinatario.Nombre,
@ClienteDireccion = Destinatario.Direccion,
@ClienteDireccionNumero = Destinatario.DireccionNumero,
@ClienteDireccionNumeroInt = Destinatario.DireccionNumeroInt,
@ClienteColonia = CASE ISNULL(cdd.ClaveColonia,'') WHEN '' THEN Destinatario.Colonia ELSE cdd.ClaveColonia END ,
@ClientePoblacion = CASE ISNULL(cdd.ClaveLocalidad,'') WHEN '' THEN Destinatario.Poblacion ELSE cdd.ClaveLocalidad END,
@ClienteObservaciones = Destinatario.EntreCalles,
@ClienteDelegacion = CASE ISNULL(cdd.ClaveMunicipio,'') WHEN '' THEN Destinatario.Delegacion ELSE cdd.ClaveMunicipio END,
@ClienteEstado = CASE ISNULL(cdd.ClaveEstado,'') WHEN '' THEN Destinatario.Estado ELSE cdd.ClaveEstado END,
@ClientePais = CASE ISNULL(cdd.ClavePais,'') WHEN '' THEN Destinatario.Pais ELSE cdd.ClavePais END,
@ClienteCodigoPostal = CASE ISNULL(cdd.ClaveCP,'') WHEN '' THEN Destinatario.CodigoPostal ELSE cdd.ClaveCP END
FROM Venta v LEFT OUTER JOIN VentaCFDIRelacionado vcfd
ON v.ID = vcfd.ID LEFT OUTER JOIN CteCFD
ON v.Cliente =  CteCFD.Cliente LEFT OUTER JOIN Mon
ON v.Moneda = Mon.Moneda LEFT OUTER JOIN Cte Destinatario
ON vcfd.Destinatario = Destinatario.Cliente LEFT OUTER JOIN CteCFD DestinatarioCFD
ON Destinatario.Cliente = DestinatarioCFD.Cliente LEFT OUTER JOIN Empresa
ON v.Empresa = Empresa.Empresa LEFT OUTER JOIN SATClavePedimento
ON Empresa.ClavePedimento = SATClavePedimento.Descripcion LEFT OUTER JOIN EmpresaDireccionFiscal ed
ON v.Empresa = ed.Empresa LEFT OUTER JOIN CteDireccionFiscal cd
ON v.Cliente = cd.Cliente LEFT OUTER JOIN SucursalDireccionFiscal sd
ON v.Sucursal = sd.Sucursal LEFT OUTER JOIN CteDireccionFiscal cdd
ON vcfd.Destinatario = cdd.Cliente LEFT OUTER JOIN CteEnviarADireccionFiscal cad
ON v.Cliente = cad.Cliente AND v.EnviarA = cad.ID
WHERE v.ID = @ID
SELECT @RepresentanteCURP = CASE LEN(@EmpresaRFC) WHEN 12 THEN NULL ELSE RepresentanteCURP END FROM Empresa WHERE Empresa = @Empresa
IF @Layout = 'SAT_3.2'
BEGIN
SELECT  '<cfdi:Complemento> ' +
'<cce:ComercioExterior' +
dbo.fnXML('Version', '1.0')+
dbo.fnXML('TipoOperacion', @TipoOperacion)+
dbo.fnXML('ClaveDePedimento', @ClavePedimento)+
dbo.fnXML('CertificadoOrigen', @CertificadoOrigen)+
dbo.fnXML('NumCertificadoOrigen', @NumCertificadoOrigen)+
dbo.fnXML('NumeroExportadorConfiable', @NumeroExportadorConfiable)+
dbo.fnXML('Incoterm', @Incoterm)+
dbo.fnXML('Subdivision', @Subdivision)+
dbo.fnXMLDecimal('TipoCambioUSD', @TipoCambioUSD, @cfgDecimales)+
dbo.fnXMLDecimal('TotalUSD', @TotalUSD, 2)+
'>'
IF ISNULL(@RepresentanteCURP,'') <> ''
SELECT  '<cce:Emisor' +
dbo.fnXML('CURP', @RepresentanteCURP)+
'/>'
IF ISNULL(@NumRegIdTrib,'') <> ''
SELECT  '<cce:Receptor' +
dbo.fnXML('NumRegIdTrib', @NumRegIdTrib)+
'/>'
IF (ISNULL(@ClienteNumRegIdTrib,'') <> '') OR (ISNULL(@ClienteRFC,'') <> '') OR (ISNULL(@ClienteCURP,'') <> '') OR (ISNULL(@ClienteNombre,'') <> '')
SELECT  '<cce:Destinatario' +
dbo.fnXML('NumRegIdTrib', @ClienteNumRegIdTrib)+
dbo.fnXML('RFC', @ClienteRFC)+
dbo.fnXML('CURP', @ClienteCURP)+
dbo.fnXML('Nombre', @ClienteNombre)+
'>'
IF (ISNULL(@ClienteDireccion,'') <> '') OR (ISNULL(@ClienteDireccionNumero,'') <> '') OR (ISNULL(@ClienteDireccionNumeroInt,'') <> '') OR (ISNULL(@ClienteColonia,'') <> '') OR
(ISNULL(@ClientePoblacion,'') <> '') OR (ISNULL(@ClienteObservaciones,'') <> '') OR (ISNULL(@ClienteDelegacion,'') <> '') OR (ISNULL(@ClienteEstado,'') <> '') OR
(ISNULL(@ClientePais,'') <> '') OR (ISNULL(@ClienteCodigoPostal,'') <> '')
SELECT   '<cce:Domicilio' +
dbo.fnXML('Calle', @ClienteDireccion)+
dbo.fnXML('NumeroExterior', @ClienteDireccionNumero)+
dbo.fnXML('NumeroInterior', @ClienteDireccionNumeroInt)+
dbo.fnXML('Colonia', @ClienteColonia)+
dbo.fnXML('Localidad', @ClientePoblacion)+
dbo.fnXML('Referencia', @ClienteObservaciones)+
dbo.fnXML('Municipio', @ClienteDelegacion)+
dbo.fnXML('Estado', @ClienteEstado)+
dbo.fnXML('Pais', @ClientePais)+
dbo.fnXML('CodigoPostal', @ClienteCodigoPostal)+
'/>'
IF (ISNULL(@ClienteNumRegIdTrib,'') <> '') OR (ISNULL(@ClienteRFC,'') <> '') OR (ISNULL(@ClienteCURP,'') <> '') OR (ISNULL(@ClienteNombre,'') <> '')
SELECT   '</cce:Destinatario>'
IF ISNULL(@TipoOperacion,'') <> 'A'
BEGIN
SELECT   '<cce:Mercancias>'
SELECT @Renglon = MIN(Renglon) FROM VentaD WHERE ID = @ID
WHILE @Renglon IS NOT NULL
BEGIN
SELECT @Articulo = NULL, @Cantidad = NULL, @Unidad = NULL, @Precio = NULL, @TotalDUSD = NULL, @FraccionArancelaria = NULL, @Marca = NULL, @Modelo = NULL,
@SubModelo = NULL, @NumeroSerie = NULL, @UnidadClave = NULL
SELECT @Articulo = vtc.Articulo, @Cantidad = vtc.Cantidad, @Unidad = vtc.Unidad, @Precio = dbo.fnVentaDTotalUSD(Moneda, (vtc.Importe/(VentaD.Cantidad - ISNULL(VentaD.CantidadObsequio,0.0)))),
@TotalDUSD = CONVERT(DECIMAL(20,2), (VentaD.Cantidad - ISNULL(VentaD.CantidadObsequio,0.0)) * CONVERT(DECIMAL(20,2), dbo.fnVentaDTotalUSD(Moneda, (vtc.Importe/( VentaD.Cantidad - ISNULL(VentaD.CantidadObsequio,0.0))))))
FROM VentaTCalc vtc LEFT JOIN VentaD ON vtc.ID = VentaD.ID AND vtc.Renglon = VentaD.Renglon WHERE vtc.ID = @ID AND vtc.Renglon = @Renglon
SELECT @FraccionArancelaria = FraccionArancelaria, @Marca = Marca, @Modelo = Modelo, @SubModelo = SubModelo FROM SATArticuloInfo WHERE Articulo = @Articulo
SELECT @NumeroSerie = SerieLote
FROM VentaD d
JOIN Art a ON d.Articulo = a.Articulo
JOIN SerieLoteMov s ON s.Modulo = 'VTAS' AND d.Id = s.ID AND d.RenglonID = s.RenglonID AND d.Articulo = s.Articulo AND ISNULL(d.Subcuenta,'') = ISNULL(s.Subcuenta,'')
WHERE a.Tipo IN ('Serie', 'Lote') AND d.ID = @ID AND d.Renglon = @Renglon AND s.Empresa = @Empresa
SELECT @UnidadClave = Clave FROM Unidad WHERE Unidad = @Unidad
IF ISNULL(@Layout,'') = 'SAT_3.2'
BEGIN
SELECT @UnidadClave = NULL
SELECT @UnidadClave = Valor FROM TablaSTD WHERE TablaST = 'CFDFLEX_UNIDADES' AND Nombre = @Unidad
END
SELECT '<cce:Mercancia' +
dbo.fnXML('NoIdentificacion', @Articulo)+
dbo.fnXML('FraccionArancelaria', @FraccionArancelaria)+
dbo.fnXMLDecimal('CantidadAduana', @Cantidad, 3)+
dbo.fnXML('UnidadAduana', @UnidadClave)+
dbo.fnXMLDecimal('ValorUnitarioAduana', @Precio, 2)+
dbo.fnXMLDecimal('ValorDolares', @TotalDUSD, 2)+
'>'
IF (ISNULL(@Marca,'') <> '') OR (ISNULL(@Modelo,'') <> '') OR (ISNULL(@SubModelo,'') <> '') OR (ISNULL(@NumeroSerie,'') <> '')
SELECT '<cce:DescripcionesEspecificas' +
dbo.fnXML('Marca', @Marca)+
dbo.fnXML('Modelo', @Modelo)+
dbo.fnXML('SubModelo', @SubModelo)+
dbo.fnXML('NumeroSerie', @NumeroSerie)+
'/>'
SELECT '</cce:Mercancia>'
SELECT @Renglon = MIN(Renglon) FROM VentaD WHERE ID = @ID AND Renglon > @Renglon
END
SELECT '</cce:Mercancias>'
END
SELECT  '</cce:ComercioExterior> ' +
'</cfdi:Complemento>'
END
END
IF (@Modulo = 'VTAS' AND @Validar = 0) AND ((@MovTipoSubClave = 'CFDI.INE') OR (ISNULL(@Complemento,'') = 'INE'))
BEGIN
SELECT @TipoProceso = CASE ISNULL(Venta.EnviarA,-1) WHEN -1 THEN CteCFD.TipoProceso ELSE CteEnviarA.TipoProceso END,
@TipoComite = CASE ISNULL(Venta.EnviarA,-1) WHEN -1 THEN CteCFD.TipoComite ELSE CteEnviarA.TipoComite END,
@IdContabilidad = CASE ISNULL(Venta.EnviarA,-1) WHEN -1 THEN CteCFD.IdContabilidad ELSE CteEnviarA.IdContabilidad END,
@ClaveEntidad = CASE ISNULL(Venta.EnviarA,-1) WHEN -1 THEN CteCFD.ClaveEntidad ELSE CteEnviarA.ClaveEntidad END,
@Ambito = CASE ISNULL(Venta.EnviarA,-1) WHEN -1 THEN CteCFD.Ambito ELSE CteEnviarA.Ambito END,
@EntidadIdContabilidad = CASE ISNULL(Venta.EnviarA,-1) WHEN -1 THEN CteCFD.EntidadIdContabilidad ELSE CteEnviarA.EntidadIdContabilidad END
FROM Venta JOIN Cte
ON Cte.Cliente = Venta.Cliente LEFT OUTER JOIN CteCFD
ON CteCFD.Cliente = Venta.Cliente LEFT OUTER JOIN CteEnviarA
ON Venta.Cliente = CteEnviarA.Cliente AND Venta.EnviarA = CteEnviarA.ID
WHERE Venta.ID = @ID
IF @Layout = 'SAT_3.2'
BEGIN
SELECT  '<cfdi:Complemento> ' +
'<ine:INE' +
dbo.fnXML('Version', '1.1')+
dbo.fnXML('TipoProceso', @TipoProceso)+
dbo.fnXML('TipoComite', @TipoComite)+
dbo.fnXML('IdContabilidad', @IdContabilidad)+
'>'
IF ISNULL(@ClaveEntidad,'') <> ''
SELECT  '<ine:Entidad' +
dbo.fnXML('ClaveEntidad', @ClaveEntidad)+
dbo.fnXML('Ambito', @Ambito)+
'>'
IF ISNULL(@EntidadIdContabilidad,'') <> ''
SELECT  '<ine:Contabilidad' +
dbo.fnXML('IdContabilidad', @EntidadIdContabilidad)+
'/>'
IF ISNULL(@ClaveEntidad,'') <> ''
SELECT  '</ine:Entidad>'
SELECT  '</ine:INE> ' +
'</cfdi:Complemento>'
END
END
RETURN
END

