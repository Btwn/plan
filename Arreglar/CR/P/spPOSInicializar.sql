SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSInicializar
@Empresa		varchar(5),
@Sucursal		int,
@Usuario		varchar(10),
@Estacion          int,
@ID		varchar(50),
@DirectorioTrabajo      varchar(255) = NULL

AS
BEGIN
DECLARE
@FechaEmision			datetime,
@FechaRegistro			datetime,
@Concepto				varchar(50),
@Proyecto				varchar(50),
@UEN					int,
@Moneda					varchar(10),
@TipoCambio				float,
@Cliente				varchar(10),
@Almacen				varchar(10),
@Agente					varchar(10),
@Cajero					varchar(10),
@FormaEnvio				varchar(50),
@Condicion				varchar(50),
@Vencimiento			varchar(50),
@CtaDinero				varchar(10),
@Descuento				varchar(50),
@DescuentoGlobal		varchar(50),
@ListaPreciosEsp		varchar(20),
@ZonaImpuesto			varchar(50),
@FormaPago				varchar(50),
@ImagenNombreAnexo		varchar(255),
@Host					varchar(20),
@Cluster				varchar(20),
@Ok						int,
@OkRef					varchar(255),
@RedondeoMonetarios		int,
@MovClave				varchar(50),
@SugerirFechaCierre		bit,
@FechaCierre			datetime,
@Caja					varchar(10)
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa)
SELECT @MovClave = m.Clave
FROM MovTipo m JOIN POSL p ON m.Mov = p.Mov AND m.Modulo = 'POS'
WHERE  p.ID = @ID
SELECT
@CtaDinero = DefCtaDinero,
@Cajero = DefCajero
FROM Usuario
WHERE Usuario = @Usuario
SELECT @SugerirFechaCierre = SugerirFechaCierre
FROM POSCfg
WHERE Empresa = @Empresa
IF ISNULL(@DirectorioTrabajo,'') <> ''
BEGIN
DELETE POSUsuarioEstacion
WHERE Empresa  = @Empresa
AND Sucursal = @Sucursal
AND Estacion = @Estacion
AND Usuario  = @Usuario
INSERT POSUsuarioEstacion(Empresa, Sucursal, Estacion, Usuario, Directorio)
VALUES (@Empresa, @Sucursal, @Estacion, @Usuario, @DirectorioTrabajo)
END
SELECT @FechaCierre = Fecha
FROM POSFechaCierre
WHERE Sucursal = @Sucursal
SELECT @FechaCierre = dbo.fnPOSFechaCierre(@Empresa,@Sucursal,@FechaCierre,@CtaDinero)
SELECT @FechaEmision = CASE WHEN @SugerirFechaCierre = 1
THEN @FechaCierre
ELSE dbo.fnFechaSinHora(GETDATE())
END,
@FechaRegistro = GETDATE(),
@Proyecto = u.DefProyecto,
@UEN = u.UEN,
@TipoCambio = ROUND(m.TipoCambio,@RedondeoMonetarios),
@Cliente = u.DefCliente,
@Almacen = ISNULL(u.DefAlmacen, c.AlmacenDef),
@Agente = ISNULL(u.DefAgente, c.Agente),
@Cajero = u.DefCajero,
@FormaEnvio = c.FormaEnvio,
@Condicion = c.Condicion,
@CtaDinero = u.DefCtaDinero,
@Descuento = c.Descuento,
@DescuentoGlobal = d.Porcentaje,
@ListaPreciosEsp = ISNULL(ISNULL(ISNULL(NULLIF(u.DefListaPreciosEsp,''), NULLIF(c.ListaPreciosEsp,'')), NULLIF(s.ListaPreciosEsp,'')),'(Precio Lista)'),
@ZonaImpuesto = ISNULL(ISNULL(NULLIF(c.ZonaImpuesto,''),NULLIF(u.DefZonaImpuesto,'')),NULLIF(s.ZonaImpuesto,'')),
@FormaPago = u.DefFormaPago
FROM Usuario u
LEFT OUTER JOIN Mon m ON u.DefMoneda = m.Moneda
LEFT OUTER JOIN Cte c ON u.DefCliente = c.Cliente
LEFT OUTER JOIN Descuento d ON c.Descuento = d.Descuento
LEFT OUTER JOIN Sucursal s ON s.Sucursal = @Sucursal
WHERE u.Usuario = @Usuario
SELECT TOP 1 @Moneda = Moneda
FROM POSLTipoCambioRef
WHERE TipoCambio = 1 AND Sucursal = @Sucursal AND EsPrincipal = 1
IF @MovClave IN('POS,N','POS.F')
BEGIN
UPDATE POSL SET
Usuario = @Usuario,
FechaEmision = @FechaEmision,
FechaRegistro = @FechaRegistro,
Proyecto = @Proyecto,
UEN = @UEN,
Moneda = @Moneda,
TipoCambio = @TipoCambio,
Cliente = @Cliente,
Almacen = @Almacen,
Agente = @Agente,
Cajero = @Cajero,
FormaEnvio = @FormaEnvio,
Condicion = @Condicion,
CtaDinero = @CtaDinero,
Descuento = @Descuento,
DescuentoGlobal = @DescuentoGlobal,
ListaPreciosEsp = @ListaPreciosEsp,
ZonaImpuesto = @ZonaImpuesto,
Caja = @CtaDinero
WHERE ID = @ID
END
END

