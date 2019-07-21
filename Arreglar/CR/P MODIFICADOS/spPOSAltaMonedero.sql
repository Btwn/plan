SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSAltaMonedero
@ID				varchar(36),
@Usuario	    varchar(10),
@Empresa        varchar(5),
@Sucursal       int,
@Cliente		varchar(10),
@NoTarjeta		varchar(20),
@Ok				int = NULL		OUTPUT

AS
BEGIN
DECLARE
@IDGenerar				varchar(36),
@Mov					varchar(20),
@MovID					varchar(20),
@FechaEmision			datetime,
@FechaRegistro			datetime,
@Concepto				varchar(50),
@Proyecto				varchar(50),
@UEN					int,
@Moneda					varchar(10),
@MonedaTarjeta			varchar(10),
@TipoCambioTarjeta		float,
@TipoCambio				float,
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
@Prefijo				varchar(5),
@Consecutivo			int,
@noAprobacion			int,
@fechaAprobacion		datetime,
@OkRef					varchar(255),
@RedondeoMonetarios		int,
@TipoMonedero			varchar(50),
@SugerirFechaCierre		bit,
@FechaCierre			datetime,
@Caja					varchar(10)
SELECT @Caja = Caja
FROM POSL WITH (NOLOCK)
WHERE ID = @ID
SELECT @TipoMonedero = TipoMonedero, @Mov = MovEmision
FROM POSCfg WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @MonedaTarjeta = Moneda
FROM ValeTipo WITH (NOLOCK)
WHERE Tipo = @TipoMonedero
SELECT @MonedaTarjeta = ISNULL(NULLIF(@MonedaTarjeta,''),@Moneda)
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa)
EXEC spPOSHost @Host OUTPUT, @Cluster OUTPUT
IF @Mov IS NULL
SELECT TOP 1  @Mov = Mov
FROM MovTipo WITH (NOLOCK)
WHERE Modulo = 'POS' AND Clave = 'POS.ET'
SELECT
@CtaDinero = DefCtaDinero,
@Cajero = DefCajero
FROM Usuario WITH (NOLOCK)
WHERE Usuario = @Usuario
SELECT @SugerirFechaCierre = SugerirFechaCierre
FROM POSCfg WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @FechaCierre = Fecha
FROM POSFechaCierre WITH (NOLOCK)
WHERE Sucursal = @Sucursal
SELECT @FechaCierre = dbo.fnPOSFechaCierre(@Empresa,@Sucursal,@FechaCierre,@Caja)
SELECT
@FechaEmision = CASE WHEN @SugerirFechaCierre = 1 THEN @FechaCierre ELSE dbo.fnFechaSinHora(GETDATE())END,
@FechaRegistro = GETDATE(),
@Proyecto = u.DefProyecto,
@UEN = u.UEN,
@Almacen = ISNULL(u.DefAlmacen, c.AlmacenDef),
@Cajero = u.DefCajero,
@FormaEnvio = c.FormaEnvio,
@Condicion = c.Condicion,
@CtaDinero = u.DefCtaDinero
FROM Usuario u WITH (NOLOCK)
LEFT OUTER JOIN Mon m WITH (NOLOCK) ON u.DefMoneda = m.Moneda
LEFT OUTER JOIN Cte c WITH (NOLOCK) ON u.DefCliente = c.Cliente
LEFT OUTER JOIN Sucursal s WITH (NOLOCK) ON s.Sucursal = @Sucursal
WHERE u.Usuario = @Usuario
SELECT  @Moneda = Moneda
FROM POSLTipoCambioRef WITH (NOLOCK)
WHERE TipoCambio = 1.0 AND Sucursal = @Sucursal  AND EsPrincipal = 1
SELECT @TipoCambio = TipoCambio
FROM POSLTipoCambioRef WITH (NOLOCK)
WHERE Moneda = @MonedaTarjeta AND Sucursal = @Sucursal
IF @TipoCambio IS NULL
SELECT @MonedaTarjeta = @Moneda
SELECT @TipoCambio = ISNULL(@TipoCambio,1.0)
SELECT @IDGenerar = NEWID()
INSERT POSL (
ID, Host, Empresa, Modulo, Sucursal, Usuario, Mov, FechaEmision, FechaRegistro, Proyecto, UEN, Moneda, TipoCambio, Cliente,
Almacen, Agente, Cajero, FormaEnvio, Condicion, CtaDinero, Estatus, Monedero, IDR, Cluster, Caja)
VALUES (
@IDGenerar, @Host, @Empresa, 'VALE', @Sucursal, @Usuario, @Mov, @FechaEmision, @FechaRegistro, @Proyecto, @UEN, @MonedaTarjeta, @TipoCambio, @Cliente,
@Almacen, @Agente, @Cajero, @FormaEnvio, @Condicion, @CtaDinero, 'SINAFECTAR', @NoTarjeta, @ID, @Cluster, @CtaDinero)
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL
EXEC spPOSConsecutivoAuto @Empresa, @Sucursal, @Mov,
@MovID OUTPUT, @Prefijo OUTPUT, @Consecutivo OUTPUT, @noAprobacion OUTPUT, @FechaAprobacion OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
UPDATE POSL WITH (ROWLOCK) SET MovID = ISNULL(MovID, @MovID),
Prefijo = ISNULL(Prefijo, @Prefijo),
Consecutivo = ISNULL(Consecutivo, @Consecutivo),
noAprobacion = ISNULL(noAprobacion, @NoAprobacion),
fechaAprobacion = ISNULL(fechaAprobacion, @fechaAprobacion),
Estatus = 'CONCLUIDO',
FechaRegistro = @FechaRegistro
WHERE ID = @IDGenerar
IF @@ERROR <>0
SET @Ok = 1
IF @Ok IS NULL AND NOT EXISTS (SELECT * FROM POSValeSerie WITH (NOLOCK) WHERE Serie = @NoTarjeta)
INSERT POSValeSerie (
Serie, Sucursal, Estatus, Moneda, Tipo, Cliente)
SELECT
@NoTarjeta, @Sucursal, 'DISPONIBLE', @MonedaTarjeta, @TipoMonedero, @Cliente
IF @Ok IS NULL AND  EXISTS (SELECT * FROM POSValeSerie WITH (NOLOCK) WHERE Serie = @NoTarjeta AND Cliente IS NULL)
UPDATE POSValeSerie SET Cliente = @Cliente WHERE Serie = @NoTarjeta
RETURN
END

