SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpConceptoComplemento
@Estacion				int,
@Modulo					char(5),
@ID						int,
@Layout					varchar(20),
@Validar				bit,
@Version				varchar(10),
@Renglon				float,
@RenglonSub				int,
@Codigo 				varchar(30),
@Unidad 				varchar(50),
@UnidadClave 			varchar(50),
@UnidadFactor 			float,
@Articulo 				varchar(20),
@SubCuenta 				varchar(50),
@ArtDescripcion1 		varchar(255),
@ArtDescripcion2 		varchar(255),
@ArtTipoEmpaque 		varchar(50),
@TipoEmpaqueClave 		varchar(20),
@TipoEmpaqueTipo 		varchar(20),
@Paquetes 				int,
@CantidadEmpaque		float,
@EAN13 					varchar(20),
@DUN14 					varchar(20),
@SKUCliente				varchar(20),
@SKUEmpresa				varchar(20),
@noIdentificacion 		varchar(50),
@AgruparDetalle			bit,
@Cliente				varchar(20),
@OrdenCompra			varchar(50),
@TipoAddenda			varchar(50),
@Cantidad				float,
@Precio					float,
@DescuentoLinea			float,
@DescuentoGlobalLinea	float,
@Impuesto1Linea			float,
@Impuesto2Linea			float,
@SubTotalLinea			float,
@TotalLinea				float,
@ImporteLinea			float,
@Ok						int			 OUTPUT,
@OkRef					varchar(255) OUTPUT
AS BEGIN
DECLARE
@Mov						varchar(20),
@MovTipoSubClave			varchar(20),
@TerceroProv				varchar(20),
@TerceroCte					varchar(20),
@TerceroRFC					varchar(20),
@TerceroNombre				varchar(100),
@TerceroDireccion			varchar(100),
@TerceroDireccionNumero		varchar(20),
@TerceroDireccionNumeroInt	varchar(20),
@TerceroColonia				varchar(100),
@TerceroPoblacion			varchar(100),
@TerceroObservaciones		varchar(100),
@TerceroDelegacion			varchar(100),
@TerceroEstado				varchar(30),
@TerceroPais				varchar(30),
@TerceroCodigoPostal		varchar(15),
@TerceroGLN					varchar(50),
@TerceroTelefonos			varchar(100),
@Empresa					varchar(10),
@MovTipo					varchar(20),
@Contacto					varchar(20),
@ClienteRFC					varchar(20),
@p					char(1),
@RetencionTotal		float,
@RetencionFlete		float,
@RetencionPitex		float,
@CfgDecimales		int,
@TasaImpuesto1 float,
@ImporteImpuesto1 float,
@TasaImpuesto2 float,
@ImporteImpuesto2 float,
@RenglonId		int,
@Pedimento varchar(20),
@Aduana varchar(20),
@PedimentoFEcha datetime,
@Retencion1 float,
@Retencion2 float,
@SerieLote	varchar(20)
EXEC spMovInfo @ID, @Modulo, @Mov OUTPUT, @Contacto = @Contacto OUTPUT, @Empresa = @Empresa OUTPUT
SELECT @CfgDecimales = ISNULL(Decimales,2) FROM EmpresaCFD WHERE Empresa = @Empresa
SELECT @MovTipo = Clave, @MovTipoSubClave = SubClave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov
IF @Modulo = 'VTAS' AND @Validar = 0 AND (@MovTipoSubClave = 'CFDI.TERCEROSPROV' OR @MovTipoSubClave ='CFDI.TERCEROSCTE')
BEGIN
SELECT @RenglonID = RenglonID FROM VentaD WHERE ID = @ID AND Renglon = @Renglon AND REnglonSub = @RenglonSub AND Articulo = @Articulo
SELECT @ClienteRFC = RFC FROM Cte WHERE Cliente = @Contacto
EXEC spMovInfo @ID, @Modulo, @Mov OUTPUT
SELECT  @MovTipoSubClave = SubClave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov
IF @Modulo = 'VTAS'  AND @MovTipoSubClave = 'CFDI.TERCEROSPROV'
BEGIN
SELECT @TerceroProv = Proveedor FROM CFDVentaDProv WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub AND Articulo = @Articulo
IF NULLIF(@TerceroProv,'') IS NULL
RETURN
SELECT @TerceroRFC = RFC, @TerceroNombre = Nombre, @TerceroDireccion = Direccion, @TerceroDireccionNumero = DireccionNumero, @TerceroDireccionNumeroInt = DireccionNumeroInt,
@TerceroColonia = Colonia, @TerceroPoblacion = Poblacion, @TerceroObservaciones = NULLIF(RTRIM(EntreCalles/*Observaciones*/),''), @TerceroDelegacion = Delegacion, @TerceroEstado = Estado,
@TerceroPais = Pais, @TerceroCodigoPostal = CodigoPostal, @TerceroTelefonos = Telefonos
FROM Prov
WHERE Proveedor = @TerceroProv
END
ELSE IF @Modulo = 'VTAS'  AND @MovTipoSubClave = 'CFDI.TERCEROSCTE'
BEGIN
SELECT @TerceroCte = Cliente FROM CFDVentaDCte WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub AND Articulo = @Articulo
IF NULLIF(@TerceroCte,'') IS NULL
RETURN
SELECT @TerceroRFC = RFC, @TerceroNombre = Nombre, @TerceroDireccion = Direccion, @TerceroDireccionNumero = DireccionNumero, @TerceroDireccionNumeroInt = DireccionNumeroInt,
@TerceroColonia = Colonia, @TerceroPoblacion = Poblacion, @TerceroObservaciones = NULLIF(RTRIM(EntreCalles/*Observaciones*/),''), @TerceroDelegacion = Delegacion, @TerceroEstado = Estado,
@TerceroPais = Pais, @TerceroCodigoPostal = CodigoPostal, @TerceroTelefonos = Telefonos
FROM Cte
WHERE Cliente  = @TerceroCte
END
SELECT '<cfdi:ComplementoConcepto>
<terceros:PorCuentadeTerceros xsi:schemaLocation='+char(34)+'http://www.sat.gob.mx/terceros http://www.sat.gob.mx/sitio_internet/cfd/terceros/terceros11.xsd'+char(34)+
dbo.fnXML('version', '1.1')+
dbo.fnXML('nombre', @TerceroNombre)+
dbo.fnXML('rfc', @TerceroRFC)+'>'
SELECT '<terceros:InformacionFiscalTercero '+
dbo.fnXML('calle', @TerceroDireccion)+
dbo.fnXML('noExterior', @TerceroDireccionNumero)+
dbo.fnXML('noInterior', @TerceroDireccionNumeroInt)+
dbo.fnXML('colonia', @TerceroColonia)+
dbo.fnXML('localidad', @TerceroPoblacion)+
dbo.fnXML('municipio', @TerceroDelegacion)+
dbo.fnXML('estado', @TerceroEstado)+
dbo.fnXML('pais', @TerceroPais)+
dbo.fnXML('codigoPostal', @TerceroCodigoPostal)+'/>'
DECLARE crSerieLoteMov CURSOR LOCAL FOR
SELECT Top 1 s.SerieLote, dbo.fnLimpiarRFC(s.Propiedades), p.Fecha1, p.Aduana
FROM SerieLoteMov s
JOIN SerieLoteProp p ON p.Propiedades = s.Propiedades
WHERE s.Empresa = @Empresa AND s.Modulo = @Modulo AND s.ID = @ID AND s.RenglonID = @RenglonID AND s.Articulo = @Articulo AND ISNULL(s.SubCuenta, '') = ISNULL(@SubCuenta, '')
GROUP BY s.SerieLote, s.Propiedades, p.Fecha1, p.Aduana
ORDER BY s.SerieLote, s.Propiedades, p.Fecha1, p.Aduana
OPEN crSerieLoteMov
FETCH NEXT FROM crSerieLoteMov INTO @SerieLote, @Pedimento, @PedimentoFecha, @Aduana
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT  '<terceros:InformacionAduanera'+
dbo.fnXML('numero', @Pedimento)+
dbo.fnXMLDatetimeFmt('fecha', @PedimentoFecha, 'AAAA-MM-DD')+
dbo.fnXML('aduana', @Aduana)+
'/>'
END
FETCH NEXT FROM crSerieLoteMov INTO @SerieLote, @Pedimento, @PedimentoFecha, @Aduana
END
CLOSE crSerieLoteMov
DEALLOCATE crSerieLoteMov
SELECT '<terceros:Impuestos>'
IF @MovTipo IN ('VTAS.F', 'VTAS.D', 'VTAS.DF', 'VTAS.B')
BEGIN
IF @ClienteRFC IS NOT NULL AND LEN(@ClienteRFC) >= 9
BEGIN
SELECT @p = SUBSTRING(@ClienteRFC, 4, 1)
IF UPPER(@p) NOT IN ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z')
BEGIN
IF @Articulo = 'FLETE'
SELECT @RetencionFlete = @SubTotalLinea * 0.04
END
END
IF EXISTS(SELECT * FROM Cte WHERE Cliente = @Cliente AND NULLIF(RTRIM(PITEX), '') IS NOT NULL)
SELECT @RetencionPitex = @Impuesto1Linea
END
IF @RetencionFlete IS NOT NULL OR @RetencionPitex IS NOT NULL
BEGIN
SELECT  '<terceros:Retenciones>'
SELECT  '<terceros:Retencion'+
dbo.fnXML('impuesto', 'IVA')+
dbo.fnXMLDecimal('importe', ISNULL(@RetencionFlete,0.0)+ISNULL(@RetencionPitex,0.0), @CfgDecimales)+
'/>'
SELECT  '</terceros:Retenciones>'
END
ELSE
BEGIN
SELECT @Retencion1 = Retencion1, @Retencion2 = Retencion2 from Ventatcalc WHERE ID = @ID AND Renglon = @Renglon AND REnglonSub = @RenglonSub AND Articulo = @Articulo
IF @Retencion1 > 0 OR @Retencion2 > 0
BEGIN
SELECT  '<terceros:Retenciones>'
IF @Retencion1 > 0
SELECT  '<terceros:Retencion'+
dbo.fnXML('impuesto', 'ISR')+
dbo.fnXMLDecimal('importe', @SubTotalLinea*@Retencion1/100, @CfgDecimales)+
'/>'
IF @Retencion2 > 0
SELECT  '<terceros:Retencion'+
dbo.fnXML('impuesto', 'IVA')+
dbo.fnXMLDecimal('importe', @SubTotalLinea*@Retencion2/100, @CfgDecimales)+
'/>'
SELECT  '</terceros:Retenciones>'
END
END
IF @Modulo = 'VTAS'
AND (Exists (SELECT * FROM VentaTCalc V JOIN Art a ON v.articulo = a.Articulo WHERE v.ID = @ID AND a.Impuesto1Excento = 0 AND Impuesto1Total IS NOT NULL)
OR Exists (SELECT * FROM VentaTCalc V JOIN Art a ON v.articulo = a.Articulo WHERE v.ID = @ID AND a.Excento2 = 0 AND NULLIF(Impuesto2Total,0.0) IS NOT NULL))
BEGIN
SELECT  '<terceros:Traslados>'
SELECT @TasaImpuesto1 = v.Impuesto1, @ImporteImpuesto1 = v.Impuesto1Total
FROM VentaTCalc V
JOIN Art a ON v.articulo = a.Articulo
WHERE v.ID = @ID AND v.Renglon = @Renglon AND v.RenglonSub = @RenglonSub AND v.Articulo = @Articulo
AND a.Impuesto1Excento = 0
SELECT  '<terceros:Traslado'+
dbo.fnXML('impuesto', 'IVA')+
dbo.fnXMLFloat2('tasa', @TasaImpuesto1)+
dbo.fnXMLDecimal('importe', @ImporteImpuesto1, @CfgDecimales)+
'/>'
SELECT @TasaImpuesto2 = v.Impuesto2, @ImporteImpuesto2 = v.Impuesto2Total
FROM VentaTCalc v
JOIN Art a ON v.Articulo = a.Articulo
WHERE v.ID = @ID AND v.Renglon = @Renglon AND v.RenglonSub = @RenglonSub AND v.Articulo = @Articulo
AND a.Excento2 = 0
IF @ImporteImpuesto2 IS NOT NULL AND NOT( @ImporteImpuesto2 = 0 AND @TasaImpuesto2=0)
SELECT  '<terceros:Traslado'+
dbo.fnXML('impuesto', 'IEPS')+
dbo.fnXMLFloat2('tasa', @TasaImpuesto2)+
dbo.fnXMLDecimal('importe', @ImporteImpuesto2, @CfgDecimales)+
'/>'
SELECT  '</terceros:Traslados>'
END
SELECT  '</terceros:Impuestos>'+
'</terceros:PorCuentadeTerceros>'+
'</cfdi:ComplementoConcepto>'
END
RETURN
END

