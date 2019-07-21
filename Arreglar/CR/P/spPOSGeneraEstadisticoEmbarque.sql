SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSGeneraEstadisticoEmbarque
@Empresa			                varchar(5),
@Modulo				                varchar(5),
@Sucursal			                int,
@Usuario			                varchar(10),
@Estacion			                int,
@IDText       	              varchar(36),
@ID					                  varchar(50)	OUTPUT,
@POSDefMovEmbarque            varchar(20),
@ContMoneda					          varchar(10),
@ContMonedaTC				          float,
@ArticuloTarjeta              varchar(20),
@AlmacenTarjeta               varchar(20),
@VentaPreciosImpuestoIncluido bit,
@Ok					                  int		        OUTPUT,
@OkRef				                varchar(255)	OUTPUT

AS
BEGIN
DECLARE
@IDNuevo                INT,
@ArticuloRedondeo				varchar(20),
@CodigoRedondeo					varchar(50),
@Ubicacion              varchar(1000),
@POSMovID               varchar(20),
@Contador               int,
@MapaLatitud            float,
@MapaLongitud           float
SELECT @POSMovID = MovID FROM POSL WHERE ID = @IDText
SET @Contador = 1
DECLARE crDatos CURSOR LOCAL FOR
SELECT Ubicacion, MapaLatitud, MapaLongitud
FROM POSLVentaEmbarques
WHERE ID = @IDText and TipoDireccion <> 'Se LLeva'
GROUP BY Ubicacion, MapaLatitud, MapaLongitud
OPEN crDatos
FETCH NEXT FROM crDatos INTO @Ubicacion, @MapaLatitud, @MapaLongitud
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
INSERT Venta (
Empresa, Mov, MovID, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda, TipoCambio, Usuario, Referencia,
Estatus, Observaciones, Cliente, EnviarA, Almacen, Agente, FormaEnvio, Condicion, Vencimiento, CtaDinero, Descuento,
DescuentoGlobal, Causa, Atencion, AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, Sucursal, OrigenTipo,
Origen, OrigenID, ReferenciaOrdenCompra, GenerarDinero, SucursalOrigen, Ubicacion, MapaLatitud, MapaLongitud)
SELECT
p.Empresa, @POSDefMovEmbarque, @POSMovID+'-'+Convert(Varchar(10), @Contador ), p.FechaEmision, p.FechaRegistro, p.Concepto, p.Proyecto, p.UEN, p.Moneda,
CASE WHEN p.Moneda <> @ContMoneda
THEN  (p.TipoCambio/@ContMonedaTC)
ELSE p.TipoCambio
END, p.Usuario, p.Referencia,
'SINAFECTAR', p.Observaciones, p.Cliente, p.EnviarA, p.Almacen, p.Agente, p.FormaEnvio, p.Condicion, p.Vencimiento, p.CtaDinero, p.Descuento,
0.0, p.Causa, p.Atencion, p.AtencionTelefono, p.ListaPreciosEsp, p.ZonaImpuesto, p.Sucursal, 'POS',
p.Mov, p.MovID, @ID, 0, p.Sucursal, @Ubicacion, @MapaLatitud, @MapaLongitud
FROM POSL p
WHERE p.ID = @IDText
IF @@ERROR <> 0
SET @Ok = 1
SELECT @IDNuevo = SCOPE_IDENTITY()
SELECT @CodigoRedondeo = pc.RedondeoVentaCodigo
FROM POSCfg pc
WHERE pc.Empresa = @Empresa
SELECT @ArticuloRedondeo = Cuenta
FROM CB
WHERE Codigo = @CodigoRedondeo
AND TipoCuenta = 'Articulos'
INSERT VentaD (
ID, Renglon, RenglonID, Aplica, AplicaID, RenglonTipo, Cantidad, CantidadObsequio, Almacen, EnviarA, Articulo, SubCuenta, Precio,
DescuentoLinea, Impuesto1, Impuesto2, Impuesto3, Unidad, Factor, Sucursal, Puntos, POSDesGlobal, POSDesLinea, Codigo )
SELECT @IDNuevo, pmv.Renglon, pmv.RenglonID, pmv.Aplica, pmv.AplicaID, pmv.RenglonTipo, e.Cantidad, pmv.CantidadObsequio,
CASE WHEN pmv.Articulo= @ArticuloTarjeta THEN ISNULL(pmv.Almacen,@AlmacenTarjeta) ELSE p.Almacen END,
p.EnviarA,
pmv.Articulo,
pmv.SubCuenta,
CASE WHEN @VentaPreciosImpuestoIncluido = 1 THEN pmv.PrecioImpuestoInc ELSE pmv.Precio END,
dbo.fnPOSCalcDescuentosVenta(CASE WHEN ISNULL(pmv.AplicaDescGlobal, 1) = 1 THEN ISNULL(p.DescuentoGlobal,0.0) ELSE 0 END,pmv.DescuentoLinea),
pmv.Impuesto1,
pmv.Impuesto2,
pmv.Impuesto3,
pmv.Unidad,
1,
@Sucursal,
pmv.Puntos,
CASE WHEN ISNULL(pmv.AplicaDescGlobal, 1) = 1 THEN ISNULL(p.DescuentoGlobal,0.0) ELSE 0 END,
ISNULL(pmv.DescuentoLinea,0.0),
pmv.Codigo
FROM POSLVenta pmv JOIN POSL p ON pmv.ID = p.ID
JOIN POSLVentaEmbarques e ON e.ID = pmv.ID AND e.Renglon = pmv.Renglon AND e.RenglonID = pmv.RenglonID AND e.Articulo = pmv.Articulo
WHERE pmv.ID = @IDText AND e.Ubicacion = @Ubicacion
INSERT INTO VentaDEmbarques (ID,       Renglon, RenglonID, Articulo, Cantidad, TipoDireccion, Ubicacion, MapaLatitud, MapaLongitud)
SELECT                       @IDNuevo, Renglon, RenglonID, Articulo, Cantidad, TipoDireccion, Ubicacion, MapaLatitud, MapaLongitud
FROM POSLVentaEmbarques
WHERE ID = @IDText AND Ubicacion = @Ubicacion
IF @Ok IS NULL AND @IDNuevo IS NOT NULL
EXEC spAfectar 'VTAS', @IDNuevo, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 0, @Ok = @ok OUTPUT, @OkRef = @OkRef OUTPUT
SET @Contador = @Contador + 1
FETCH NEXT FROM crDatos INTO @Ubicacion, @MapaLatitud, @MapaLongitud
END
END
CLOSE crDatos
DEALLOCATE crDatos
RETURN
END

