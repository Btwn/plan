SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSImportarPedidoFactura
@ID                 int,
@IDPOS              varchar(36),
@Estacion           int

AS
BEGIN
DECLARE
@MovGenerar           varchar(20),
@Host                 varchar(20),
@Cluster              varchar(20),
@Zona                 varchar(50),
@Cajero               varchar(10),
@CtaDinero            varchar(10),
@CtaDineroDestino     varchar(10),
@Sucursal             int,
@Ok                   int,
@Empresa              varchar(5),
@cfgImpuestoIncluido   bit,
@MovClavePedido       varchar(20),
@MovSubClavePedido    varchar(20),
@MonedaPrincipal      varchar(10),
@MonedaOrigen         varchar(10),
@TipoCambioOrigen     float ,
@SugerirFechaCierre   bit,
@FechaCierre          datetime,
@FechaEmision         datetime,
@Caja                 varchar(10)
SELECT @MovGenerar = Mov, @Host = Host, @Cluster = Cluster, @Zona = Zona, @Cajero = Cajero, @CtaDinero = CtaDinero,
@Sucursal = Sucursal, @CtaDineroDestino = CtaDineroDestino, @Empresa = Empresa, @Caja = Caja
FROM POSL WITH (NOLOCK)
WHERE ID = @IDPOS
SELECT @cfgImpuestoIncluido = ISNULL(VentaPreciosImpuestoIncluido,0)
FROM EmpresaCfg WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @SugerirFechaCierre = SugerirFechaCierre
FROM POSCfg WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @FechaCierre = Fecha
FROM POSFechaCierre WITH (NOLOCK)
WHERE Sucursal = @Sucursal
SELECT @FechaCierre = dbo.fnPOSFechaCierre(@Empresa,@Sucursal,@FechaCierre,@Caja)
SELECT @FechaEmision = CASE WHEN @SugerirFechaCierre = 1 THEN @FechaCierre ELSE dbo.fnFechaSinHora(GETDATE())END
SELECT  @MonedaPrincipal = Moneda
FROM POSLTipoCambioRef m WITH (NOLOCK)
WHERE TipoCambio = 1 AND Sucursal = @Sucursal AND EsPrincipal = 1
SELECT @MonedaOrigen = Moneda
FROM POSVentaPedidoTemp WITH (NOLOCK)
WHERE ID = @ID AND Estacion = @Estacion
SELECT @TipoCambioOrigen = TipoCambio
FROM POSLTipoCambioRef WITH (NOLOCK)
WHERE Moneda =  @MonedaOrigen AND Sucursal = @Sucursal
DELETE POSL WHERE ID= @IDPOS
DELETE POSLVenta WHERE ID= @IDPOS
SELECT @MovClavePedido = m.Clave, @MovSubClavePedido = m.SubClave
FROM MovTipo m WITH (NOLOCK) JOIN POSVentaPedidoTemp p WITH (NOLOCK) ON m.Mov = p.Mov AND m.Modulo = 'VTAS'
WHERE p.ID = @ID
INSERT POSL (
ID, Empresa, Mov, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda, TipoCambio, Usuario, Referencia, Estatus,
Observaciones, Cliente, EnviarA, Almacen, Agente, FormaEnvio, Condicion, Vencimiento, CtaDinero, Descuento, DescuentoGlobal, Causa,
Atencion, AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, Sucursal, OrigenTipo, Origen, OrigenID, Host, Cluster, Nombre, Direccion, DireccionNumero,
DireccionNumeroInt, EntreCalles, Delegacion, Colonia, Poblacion, Estado, Pais, Zona, CodigoPostal, RFC, CURP, Modulo, Cajero,
CtaDineroDestino, Directo, Caja, PedidoReferencia, PedidoReferenciaID)
SELECT
@IDPOS, p.Empresa, @MovGenerar, @FechaEmision, GETDATE(), p.Concepto, p.Proyecto, p.UEN, @MonedaPrincipal, 1.0, p.Usuario, p.Referencia, 'SINAFECTAR',
p.Observaciones, p.Cliente, p.EnviarA, p.Almacen, p.Agente, p.FormaEnvio, p.Condicion, p.Vencimiento, @CtaDinero, p.Descuento, p.DescuentoGlobal, p.Causa,
p.Atencion, p.AtencionTelefono, p.ListaPreciosEsp, p.ZonaImpuesto, @Sucursal, 'VTAS', p.Mov, p.MovID, @Host, @Cluster, c.Nombre, c.Direccion, c.DireccionNumero,
c.DireccionNumeroInt, c.EntreCalles, c.Delegacion, c.Colonia, c.Poblacion, c.Estado, c.Pais, @Zona, c.CodigoPostal, c.RFC, c.CURP,'VTAS', @Cajero,
@CtaDineroDestino, 0, @CtaDinero, CASE WHEN @MovClavePedido = 'VTAS.P' AND @MovSubClavePedido = 'VTAS.PEDANT'
THEN Mov+' '+MovID
ELSE NULL
END, CASE WHEN @MovClavePedido = 'VTAS.P' AND @MovSubClavePedido = 'VTAS.PEDANT'
THEN ID
ELSE NULL
END
FROM POSVentaPedidoTemp p WITH (NOLOCK) JOIN Cte c WITH (NOLOCK) ON p.Cliente = c.Cliente
WHERE p.ID = @ID AND p.Estacion = @Estacion
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL
INSERT POSLVenta(
ID, Renglon, RenglonID, Aplica, AplicaID, RenglonTipo, Cantidad, CantidadObsequio, Articulo, SubCuenta,
Precio,	PrecioSugerido,
DescuentoLinea, Impuesto1, Impuesto2, Impuesto3, Unidad, Factor, Puntos,
PrecioImpuestoInc,
Almacen, Aplicado, Codigo)
SELECT
@IDPOS, Renglon, RenglonID, Aplica, AplicaID, RenglonTipo, Cantidad, CantidadObsequio, Articulo, SubCuenta,
CASE WHEN @cfgImpuestoIncluido = 1
THEN  dbo.fnPOSPrecioSinImpuestos(CASE WHEN @MonedaOrigen<> @MonedaPrincipal
THEN Precio*ISNULL(@TipoCambioOrigen,1.0)
ELSE Precio
END, Impuesto1, Impuesto2, Impuesto3)
ELSE CASE WHEN @MonedaOrigen<> @MonedaPrincipal
THEN Precio*ISNULL(@TipoCambioOrigen,1.0)
ELSE Precio
END
END, CASE WHEN @cfgImpuestoIncluido = 1
THEN dbo.fnPOSPrecioSinImpuestos(CASE WHEN @MonedaOrigen<> @MonedaPrincipal
THEN Precio*ISNULL(@TipoCambioOrigen,1.0)
ELSE CASE WHEN @MonedaOrigen<> @MonedaPrincipal
THEN Precio*ISNULL(@TipoCambioOrigen,1.0)
ELSE Precio
END
END, Impuesto1, Impuesto2, Impuesto3)
ELSE CASE WHEN @MonedaOrigen<> @MonedaPrincipal
THEN Precio*ISNULL(@TipoCambioOrigen,1.0)
ELSE Precio
END
END,
DescuentoLinea, Impuesto1, Impuesto2, Impuesto3, Unidad, Factor, Puntos,
CASE WHEN @cfgImpuestoIncluido = 0
THEN dbo.fnPOSPrecioConImpuestos(CASE WHEN @MonedaOrigen<> @MonedaPrincipal
THEN Precio*ISNULL(@TipoCambioOrigen,1.0)
ELSE CASE WHEN @MonedaOrigen<> @MonedaPrincipal
THEN Precio*ISNULL(@TipoCambioOrigen,1.0)
ELSE Precio
END
END,Impuesto1, Impuesto2, Impuesto3, @Empresa)
ELSE CASE WHEN @MonedaOrigen<> @MonedaPrincipal
THEN Precio*ISNULL(@TipoCambioOrigen,1.0)
ELSE Precio
END
END, Almacen, 1, Codigo
FROM POSVentaPedidoDTemp WITH (NOLOCK)
WHERE ID = @ID  AND Estacion = @Estacion
IF @@ERROR <> 0
SET @Ok = 1
SELECT @IDPOS
END

