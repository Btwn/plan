SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSVerificadorPrecios
@ID			varchar(36),
@Codigo		varchar(50),
@Usuario	varchar(10),
@Estacion	int,
@Ticket		varchar(MAX)	OUTPUT,
@Ok			int				OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS
BEGIN
DECLARE
@Articulo				varchar(20),
@Descripcion1			varchar(100),
@SubCuenta				varchar(50),
@Unidad					varchar(50),
@UnidadCodigo			varchar(50),
@Precio					float,
@DescuentoLinea			float,
@FechaEmision			datetime,
@Agente					varchar(10),
@Moneda					varchar(20),
@TipoCambio				float,
@Condicion				varchar(50),
@Almacen				varchar(10),
@Proyecto				varchar(50),
@FormaEnvio				varchar(50),
@Mov					varchar(20),
@Empresa				varchar(5),
@Sucursal				int,
@ListaPreciosEsp		varchar(20),
@Cliente				varchar(10),
@String					varchar(MAX),
@OFER					bit,
@OfertaTipo				varchar(50),
@OfertaForma			varchar(50),
@OfertaObsequio			varchar(20),
@OfertaPorcentaje		float,
@OfertaImporte			float,
@RedondeoMonetarios		int,
@OfertaPrecio			float,
@OfertaCantidad			float,
@Usar					varchar(50),
@ContMoneda				varchar(10),
@ContMonedaTC	        float,
@ImpuestoIncluido		bit,
@Impuesto1				float,
@Impuesto2				float,
@Impuesto3				float,
@Caja					varchar(10),
@Host					varchar(20),
@DirectorioEstilo		varchar(256)
SELECT @ContMoneda = ec.ContMoneda
FROM EmpresaCfg ec WITH (NOLOCK)
WHERE ec.Empresa = @Empresa
SELECT @DirectorioEstilo = Directorio
FROM POSUsuarioEstacion WITH (NOLOCK)
WHERE Empresa = @Empresa
AND Sucursal = @Sucursal
AND Usuario = @Usuario
AND Estacion = @Estacion
SELECT @ContMonedaTC = TipoCambio FROM POSLTipoCambioRef WITH (NOLOCK) WHERE Sucursal = @Sucursal AND Moneda = @ContMoneda
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa)
SELECT @Ticket = NULL
IF EXISTS(SELECT 1 FROM Art WITH (NOLOCK) WHERE Articulo = @Codigo)
SELECT @Articulo = @Codigo
ELSE
SELECT
@Articulo = Cuenta,
@SubCuenta = SubCuenta,
@UnidadCodigo = nullif(Unidad,'')
FROM CB WITH (NOLOCK)
WHERE Codigo = @Codigo
IF @Articulo IS NULL
SELECT @Ok = 72040
IF @Ok IS NULL
BEGIN
SELECT
@Descripcion1 = a.Descripcion1,
@Unidad = a.Unidad
FROM Art a WITH (NOLOCK)
WHERE a.Articulo = @Articulo
IF @UnidadCodigo IS NOT NULL
SELECT @Unidad = @UnidadCodigo
SELECT
@FechaEmision		= FechaEmision,
@Agente				= Agente,
@Moneda				= Moneda,
@TipoCambio			= TipoCambio,
@Condicion			= Condicion,
@Almacen			= Almacen,
@Proyecto			= Proyecto,
@FormaEnvio			= FormaEnvio,
@Mov				= Mov,
@Empresa			= Empresa,
@Sucursal			= Sucursal,
@ListaPreciosEsp	= ListaPreciosEsp,
@Cliente			= Cliente,
@Caja				= Caja,
@Host				= Host
FROM POSL WITH (NOLOCK)
WHERE ID = @ID
SELECT @OFER = 0
FROM EmpresaGral WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @ImpuestoIncluido = VentaPreciosImpuestoIncluido FROM EmpresaCfg WITH (NOLOCK) WHERE Empresa = @Empresa
SELECT @TipoCambio = CASE WHEN @Moneda <> @ContMoneda THEN  (ISNULL(@TipoCambio,1)/@ContMonedaTC) ELSE ISNULL(@TipoCambio,1) END
EXEC spPOSArtPrecio @Articulo = @Articulo, @Cantidad = 1, @UnidadVenta = @Unidad, @Precio = @Precio OUTPUT,
@Descuento = @DescuentoLinea OUTPUT, @SubCuenta = @SubCuenta, @FechaEmision = @FechaEmision,
@Agente = @Agente, @Moneda = @Moneda, @TipoCambio = @TipoCambio, @Condicion = @Condicion,
@Almacen = @Almacen, @Proyecto = @Proyecto, @FormaEnvio = @FormaEnvio, @Mov = @Mov,
@Empresa = @Empresa, @Sucursal = @Sucursal, @ListaPreciosEsp = @ListaPreciosEsp,
@Cliente = @Cliente, @VentaID = @ID
SELECT @Precio = ROUND(@Precio,@RedondeoMonetarios)
IF @ImpuestoIncluido = 0
BEGIN
SELECT @Impuesto1 = ISNULL(Impuesto1,0), @Impuesto2 = ISNULL(Impuesto2,0), @Impuesto3 = ISNULL(Impuesto3,0) FROM Art WITH (NOLOCK) WHERE Articulo = @Articulo
SELECT @Precio = dbo.fnPOSPrecioConImpuestos(@Precio, @Impuesto1, @Impuesto2, @Impuesto3, @Empresa)
END
SELECT @DescuentoLinea = ROUND(@DescuentoLinea,@RedondeoMonetarios)
SET @String = ''
SET @String = @String + '<!DOCTYPE HTML>'
SET @String = @String + '<html>'
SET @String = @String + '<head>'
SET @String = @String + '<title>Ticket POS</title>'
SET @String = @String + '<meta name="viewport" content="width=device-width, initial-scale=1">'
SET @String = @String + '<meta http-equiv="Content-Type" content="text/html; charset=latin1" />'
SET @String = @String + '<meta name="keywords" content="POS, SDK"/>'
SET @String = @String + '<base href="'+@DirectorioEstilo+'">'
SET @String = @String + '<link href="web/css/bootstrap.min.css" rel="stylesheet" type="text/css" />'
SET @String = @String + '<link href="web/css/style.css" rel="stylesheet" type="text/css" />'
SET @String = @String + '<link rel="stylesheet" href="web/css/morris.css" type="text/css"/>'
SET @String = @String + '<link href="web/css/font-awesome.css" rel="stylesheet">'
SET @String = @String + '<link rel="stylesheet" type="text/css" href="web/css/table-style.css" />'
SET @String = @String + '<link rel="stylesheet" type="text/css" href="web/css/basictable.css" />'
SET @String = @String + '<link rel="stylesheet" href="web/css/icon-font.min.css" type="text/css" />'
SET @String = @String + '</head>'
SET @String = @String + '<body>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
SELECT @String = @String + '<table width="100%" style="margin:0;">'
SELECT @String = @String + '  <tr style="border-bottom:0px;">'
SELECT @String = @String + '    <th style="text-align:left; padding:3px 12px; border-bottom:0px; background:#337ab7;">  </th>'
SELECT @String = @String + '  </tr>'
SELECT @String = @String + '</table>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
SELECT @String = @String + '<table width="100%" style="margin:0;">'
SELECT @String = @String + '  <tr style="border-bottom:0px;">'
SELECT @String = @String + '    <th style="text-align:left; padding:3px 12px; border-bottom:0px; background:#337ab7;">  </th>'
SELECT @String = @String + '  </tr>'
SELECT @String = @String + '</table>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
SELECT @String = @String + '<table width="100%" style="margin:0;">'
SELECT @String = @String + '  <tr style="border-bottom:0px;">'
SELECT @String = @String + '    <th style="text-align:left; padding:3px 12px; border-bottom:0px; background:#337ab7;"> V E R I F I C A D O R   D E   P R E C I O S </th>'
SELECT @String = @String + '  </tr>'
SELECT @String = @String + '</table>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
SELECT @String = @String + '<table width="100%" style="margin:0;">'
SELECT @String = @String + '  <tr style="border-bottom:0px;">'
SELECT @String = @String + '    <th style="text-align:left; padding:3px 12px; border-bottom:0px; background:#337ab7;">'+ @Articulo + ' ' + @Descripcion1 +'</th>'
SELECT @String = @String + '  </tr>'
SELECT @String = @String + '</table>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
SELECT @String = @String + '<table width="100%" style="margin:0;">'
SELECT @String = @String + '  <tr style="border-bottom:0px;">'
SELECT @String = @String + '    <th style="text-align:left; padding:3px 12px; border-bottom:0px; background:#337ab7;">'+ 'Precio:    '  +dbo.fnFormatoMoneda( @Precio,@Empresa) +'</th>'
SELECT @String = @String + '  </tr>'
SELECT @String = @String + '</table>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
IF ISNULL(@OFER,0) = 0 AND @DescuentoLinea IS NOT NULL
BEGIN
SELECT @String = @String + '<table width="100%" style="margin:0;">'
SELECT @String = @String + '  <tr style="border-bottom:0px;">'
SELECT @String = @String + '    <th style="text-align:left; padding:3px 12px; border-bottom:0px; background:#337ab7;">'+ 'Descuento: '  + CONVERT(varchar, @DescuentoLinea, 101) + '%' +'</th>'
SELECT @String = @String + '  </tr>'
SELECT @String = @String + '</table>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
END
IF @DescuentoLinea IS NOT NULL
BEGIN
SELECT @String = @String + '<table width="100%" style="margin:0;">'
SELECT @String = @String + '  <tr style="border-bottom:0px;">'
SELECT @String = @String + '    <th style="text-align:left; padding:3px 12px; border-bottom:0px; background:#337ab7;">'+ '******** Precio Neto ' + dbo.fnFormatoMoneda(@Precio - (@Precio * (ISNULL(@DescuentoLinea,0)/100)),@Empresa) + ' ********' +'</th>'
SELECT @String = @String + '  </tr>'
SELECT @String = @String + '</table>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
END
SET @String = ''
SET @String = @String + '</body>'
SET @String = @String + '</html>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
END
IF @Ok IS NOT NULL
BEGIN
SET @String = ''
SET @String = @String + '<!DOCTYPE HTML>'
SET @String = @String + '<html>'
SET @String = @String + '<head>'
SET @String = @String + '<title>Ticket POS</title>'
SET @String = @String + '<meta name="viewport" content="width=device-width, initial-scale=1">'
SET @String = @String + '<meta http-equiv="Content-Type" content="text/html; charset=latin1" />'
SET @String = @String + '<meta name="keywords" content="POS, SDK"/>'
SET @String = @String + '<base href="'+@DirectorioEstilo+'">'
SET @String = @String + '<link href="web/css/bootstrap.min.css" rel="stylesheet" type="text/css" />'
SET @String = @String + '<link href="web/css/style.css" rel="stylesheet" type="text/css" />'
SET @String = @String + '<link rel="stylesheet" href="web/css/morris.css" type="text/css"/>'
SET @String = @String + '<link href="web/css/font-awesome.css" rel="stylesheet">'
SET @String = @String + '<link rel="stylesheet" type="text/css" href="web/css/table-style.css" />'
SET @String = @String + '<link rel="stylesheet" type="text/css" href="web/css/basictable.css" />'
SET @String = @String + '<link rel="stylesheet" href="web/css/icon-font.min.css" type="text/css" />'
SET @String = @String + '</head>'
SET @String = @String + '<body>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
SELECT @String = @String + '<table width="100%" style="margin:0;">'
SELECT @String = @String + '  <tr style="border-bottom:0px;">'
SELECT @String = @String + '    <th style="text-align:left; padding:3px 12px; border-bottom:0px; background:#337ab7;">  </th>'
SELECT @String = @String + '  </tr>'
SELECT @String = @String + '</table>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
SELECT @String = @String + '<table width="100%" style="margin:0;">'
SELECT @String = @String + '  <tr style="border-bottom:0px;">'
SELECT @String = @String + '    <th style="text-align:left; padding:3px 12px; border-bottom:0px; background:#337ab7;">  </th>'
SELECT @String = @String + '  </tr>'
SELECT @String = @String + '</table>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
SELECT @String = @String + '<table width="100%" style="margin:0;">'
SELECT @String = @String + '  <tr style="border-bottom:0px;">'
SELECT @String = @String + '    <th style="text-align:left; padding:3px 12px; border-bottom:0px; background:#337ab7;"> V E R I F I C A D O R   D E   P R E C I O S </th>'
SELECT @String = @String + '  </tr>'
SELECT @String = @String + '</table>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
SELECT @String = @String + '<table width="100%" style="margin:0;">'
SELECT @String = @String + '  <tr style="border-bottom:0px;">'
SELECT @String = @String + '    <th style="text-align:left; padding:3px 12px; border-bottom:0px; background:#337ab7;"> El Código no Existe, '+ @Codigo + ' </th>'
SELECT @String = @String + '  </tr>'
SELECT @String = @String + '</table>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
SET @String = ''
SET @String = @String + '</body>'
SET @String = @String + '</html>'
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
SET @String = ''
END
END

