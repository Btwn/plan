SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSMovNuevo
@Empresa		varchar(5),
@Modulo			varchar(5),
@Sucursal		int,
@Usuario		varchar(10),
@Estacion       int,
@ID				varchar(50)  OUTPUT,
@Imagen			varchar(255) OUTPUT,
@IDAnterior		varchar(50) = NULL

AS
BEGIN
DECLARE
@Mov					varchar(20),
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
@MovClave				varchar(20),
@MovSubClave			varchar(20),
@MovAnterior   			varchar(20),
@MovIDAnterior			varchar(20),
@PedidoReferencia		varchar(50),
@SugerirFechaCierre		bit,
@FechaCierre			datetime,
@Caja					varchar(10)
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa)
SELECT @Caja = DefCtaDinero
FROM Usuario WITH (NOLOCK)
WHERE Usuario = @Usuario
EXEC spPOSHost @Host OUTPUT, @Cluster OUTPUT
IF @IDAnterior IS NOT NULL
SELECT @MovClave = m.Clave, @MovSubClave = m.SubClave
FROM MovTipo m WITH (NOLOCK) JOIN POSL p WITH (NOLOCK) ON m.Mov = p.Mov AND m.Modulo = 'POS'
WHERE p.ID = @IDAnterior
SELECT @SugerirFechaCierre = SugerirFechaCierre
FROM POSCfg WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @FechaCierre = Fecha
FROM POSFechaCierre WITH (NOLOCK)
WHERE Sucursal = @Sucursal
SELECT @FechaCierre = dbo.fnPOSFechaCierre(@Empresa,@Sucursal,@FechaCierre,@Caja)
SELECT
@CtaDinero = DefCtaDinero,
@Cajero = DefCajero
FROM Usuario WITH (NOLOCK)
WHERE Usuario = @Usuario
SELECT
@FechaEmision = CASE WHEN @SugerirFechaCierre = 1 THEN @FechaCierre ELSE dbo.fnFechaSinHora(GETDATE())END,
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
@ZonaImpuesto = ISNULL(ISNULL(NULLIF(u.DefZonaImpuesto,''),NULLIF(c.ZonaImpuesto,'')),NULLIF(s.ZonaImpuesto,'')),
@FormaPago = u.DefFormaPago
FROM Usuario u WITH (NOLOCK)
LEFT OUTER JOIN Mon m WITH (NOLOCK) ON u.DefMoneda = m.Moneda
LEFT OUTER JOIN Cte c WITH (NOLOCK) ON u.DefCliente = c.Cliente
LEFT OUTER JOIN Descuento d WITH (NOLOCK) ON c.Descuento = d.Descuento
LEFT OUTER JOIN Sucursal s WITH (NOLOCK) ON s.Sucursal = @Sucursal
WHERE u.Usuario = @Usuario
SELECT @Mov = MovOmision
FROM CtaDinero WITH (NOLOCK)
WHERE  CtaDinero = @CtaDinero
IF @Mov IS NULL
SELECT TOP 1 @Mov = mt.Mov
FROM MovTipo mt WITH (NOLOCK)
WHERE mt.ConsecutivoModulo = 'VTAS'
AND mt.Modulo = 'POS'
ORDER BY mt.Orden
SELECT TOP 1 @Moneda = Moneda
FROM POSLTipoCambioRef WITH (NOLOCK)
WHERE TipoCambio = 1 AND Sucursal = @Sucursal AND EsPrincipal = 1
IF EXISTS(SELECT * FROM POSHost WITH (NOLOCK) WHERE Host = @Host)
SELECT @ImagenNombreAnexo = pc.ImagenNombreAnexo
FROM POSCfg pc WITH (NOLOCK)
WHERE pc.Empresa = @Empresa
SELECT @Imagen = MAX(ac.Direccion)
FROM AnexoCta ac WITH (NOLOCK)
WHERE ac.Nombre = @ImagenNombreAnexo
AND Rama = 'EMP'
AND ac.Cuenta = @Empresa
AND ac.Tipo = 'Imagen'
IF @MovClave = 'POS.P' AND @MovSubClave = 'POS.PEDANT'
BEGIN
SELECT TOP 1 @Mov = Mov
FROM MovTipo WITH (NOLOCK)
WHERE Clave = 'POS.FA' AND SubClave = 'POS.ANTREF'  AND Modulo = 'POS'
SELECT @MovAnterior = p.Mov, @MovIDAnterior = p.MovID, @Cliente = p.Cliente,
@PedidoReferencia = p.Mov+' '+p.MovID, @Modulo = 'CXC'
FROM POSL p WITH (NOLOCK)
WHERE p.ID = @IDAnterior
END
SELECT @ID = NEWID()
INSERT POSL (
ID, Host, Empresa, Modulo, Sucursal, Usuario, Mov, FechaEmision, FechaRegistro, Proyecto, UEN, Moneda, TipoCambio,
Cliente, Almacen, Agente, Cajero, FormaEnvio, Condicion, CtaDinero, Descuento, DescuentoGlobal, ListaPreciosEsp,
ZonaImpuesto, Estatus, Cluster, Caja, PedidoReferencia)
VALUES (
@ID, @Host, @Empresa, @Modulo, @Sucursal, @Usuario, @Mov, @FechaEmision, @FechaRegistro, @Proyecto, @UEN, @Moneda, 1.0,
@Cliente, @Almacen, @Agente, @Cajero, @FormaEnvio, @Condicion, @CtaDinero, @Descuento, @DescuentoGlobal, @ListaPreciosEsp,
@ZonaImpuesto, 'SINAFECTAR', @Cluster, @CtaDinero, @PedidoReferencia)
EXEC spPOSInsertaCliente @Empresa, @ID, NULL, @CtaDinero, @Cliente, @Estacion, @Imagen OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END

