SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSAccionDisparar
@Empresa					varchar(5),
@Sucursal					int,
@Modulo						varchar(5),
@Usuario					varchar(10),
@Caja						varchar(10),
@Estacion					int,
@ID							varchar(50)		OUTPUT,
@Codigo						varchar(50)		OUTPUT,
@CodigoAccion				varchar(50)		OUTPUT,
@Accion						varchar(50)		OUTPUT,
@FormaPago					varchar(50)		OUTPUT,
@Importe					float			OUTPUT,
@CantidadNotasEnProceso		int,
@Imagen						varchar(255)	OUTPUT,
@Mensaje					varchar(255)	OUTPUT,
@Ok							int				OUTPUT,
@OkRef						varchar(255)	OUTPUT,
@Expresion					varchar(255)    OUTPUT

AS
BEGIN
DECLARE
@MovimientosTraspasados		int,
@Host						varchar(20),
@Cluster					varchar(20),
@MovID						varchar(20),
@Estatus					varchar(20),
@RedondeoMonetarios			int,
@UsuarioPerfil				varchar(10),
@Cajero						varchar(10),
@MovVenta					varchar(20),
@IDVenta					int,
@MovClave					varchar(20),
@MovSubClave				varchar(20),
@WebService					bit,
@Cliente					varchar(10),
@CxcLocal					bit,
@PedidoReferencia			varchar(50),
@PedidoReferenciaID			int,
@RefPedidoSinWS				bit,
@UsuarioAutoriza			varchar(10),
@UsuarioAutorizaPerfil		varchar(10)
SELECT @UsuarioPerfil = POSPerfil
FROM Usuario
WHERE Usuario = @Usuario
SELECT @UsuarioPerfil = ISNULL(NULLIF(@UsuarioPerfil,''),@Usuario)
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa)
SELECT @WebService = ISNULL(WebService,0), @CxcLocal = ISNULL(CxcLocal,0), @RefPedidoSinWS = ISNULL(RefPedidoSinWS,0)
FROM POSCfg
WHERE Empresa = @Empresa
EXEC spPOSHost @Host	OUTPUT, @Cluster OUTPUT
EXEC spPOSUsuarioAccion @Usuario,@UsuarioPerfil, @Sucursal, @CodigoAccion, @ID, @Ok OUTPUT, @OkRef OUTPUT
SELECT
@MovID = p.MovID,
@Estatus = p.Estatus,
@Cliente = p.Cliente,
@MovClave = mt.Clave,
@MovSubClave = mt.SubClave,
@PedidoReferencia = p.PedidoReferencia,
@PedidoReferenciaID = p.PedidoReferenciaID,
@UsuarioAutoriza = p.UsuarioAutoriza
FROM POSL p JOIN MovTipo mt ON p.Mov = mt.Mov AND mt.Modulo = 'POS'
WHERE p.ID = @ID
SELECT @UsuarioAutorizaPerfil = POSPerfil
FROM Usuario
WHERE Usuario = @UsuarioAutoriza
IF @CodigoAccion = 'ASIGNAR CAJA'
BEGIN
IF EXISTS(SELECT * FROM POSLAccion WHERE Host = @Host AND Caja = @Caja AND Accion = @CodigoAccion)
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
SELECT @Codigo = NULL,@Accion = NULL
SELECT @Mensaje = 'POR FAVOR INTRODUZCA LA CAJA'
INSERT POSLAccion (
Host,  Caja, Accion)
VALUES (
@Host, @Caja,@CodigoAccion )
END
IF @CodigoAccion = 'BENEFICIARIO'
BEGIN
IF EXISTS(SELECT * FROM POSLAccion WHERE Host = @Host AND Caja = @Caja AND Accion = @CodigoAccion)
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
SELECT @Codigo = NULL,@Accion = NULL
SELECT @Mensaje = 'POR FAVOR INTRODUZCA EL BENEFICIARIO'
INSERT POSLAccion (
Host,  Caja, Accion)
VALUES (
@Host, @Caja,@CodigoAccion )
END
IF @CodigoAccion = 'INTRODUCIR CONCEPTOCXC'
BEGIN
IF EXISTS(SELECT * FROM POSLAccion WHERE Host = @Host AND Caja = @Caja AND Accion = @CodigoAccion)
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
SELECT @Codigo = NULL,@Accion = NULL
SELECT @Mensaje = 'POR FAVOR INTRODUZCA EL NUMERO DEL CONCEPTO'
INSERT POSLAccion (
Host,  Caja, Accion)
VALUES (
@Host, @Caja,@CodigoAccion )
END
IF @CodigoAccion = 'ALMACEN DESTINO'
BEGIN
IF EXISTS(SELECT * FROM POSLAccion WHERE Host = @Host AND Caja = @Caja AND Accion = @CodigoAccion)
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
SELECT @Codigo = NULL,@Accion = NULL
SELECT @Mensaje = CASE WHEN @MovClave = 'POS.INVD'
THEN ' POR FAVOR INTRODUZCA EL NUMERO ALMACEN DESTINO'
ELSE ' POR FAVOR INTRODUZCA EL NUMERO ALMACEN ORIGEN'
END
INSERT POSLAccion (
Host,  Caja, Accion)
VALUES (
@Host, @Caja,@CodigoAccion )
END
IF @CodigoAccion = 'SUSTITUTOS ACCESORIOS'
BEGIN
SELECT @MovVenta = MovSustitutos
FROM POSCfg
WHERE Empresa = @Empresa
INSERT Venta (
Empresa, Mov, FechaEmision, FechaRegistro, Concepto, Proyecto, UEN, Moneda, TipoCambio, Usuario, Referencia, Estatus,
Observaciones, Cliente, EnviarA, Almacen, Agente, FormaEnvio, Condicion, Vencimiento, CtaDinero, Descuento, DescuentoGlobal, Causa, Atencion,
AtencionTelefono, ListaPreciosEsp, ZonaImpuesto, Sucursal, OrigenTipo, Origen, OrigenID, GenerarDinero, SucursalOrigen, ServicioAseguradora)
SELECT @Empresa, @MovVenta, p.FechaEmision,  p.FechaRegistro, p.Concepto, p.Proyecto, p.UEN, p.Moneda, p.TipoCambio, p.Usuario, p.Referencia, 'SINAFECTAR',
p.Observaciones, p.Cliente, p.EnviarA, p.Almacen, p.Agente, p.FormaEnvio, p.Condicion, p.Vencimiento, p.CtaDinero, 0.0, 0.0, p.Causa, p.Atencion,
p.AtencionTelefono, p.ListaPreciosEsp, p.ZonaImpuesto, p.Sucursal, 'POS', p.Mov, p.OrigenID, 0, p.Sucursal, p.Cajero
FROM POSL p
WHERE p.ID = @ID
SELECT @IDVenta = SCOPE_IDENTITY()
IF @Ok IS NULL
SELECT @Expresion = 'Asigna(Info.ID,'+CONVERT(varchar,@IDVenta)+')  FormaModal('+CHAR(39)+'VentaPOS'+CHAR(39)+')'
DELETE POSLAccion WHERE Host = @Host AND Caja = @Caja
END
IF @CodigoAccion = 'FORMA ENVIO' AND @Ok IS NULL
BEGIN
SELECT @Codigo = NULL
SELECT @Mensaje = 'POR FAVOR INTRODUZCA LA FORMA DE ENVIO'
END
IF @CodigoAccion = 'PESAR'
BEGIN
DELETE POSLAccion
WHERE Host = @Host
AND Caja = @Caja
AND Accion = @CodigoAccion
INSERT POSLAccion (
Host, Caja, Accion)
VALUES (
@Host, @Caja, @CodigoAccion)
SELECT @Codigo = NULL
SELECT @Mensaje = 'FAVOR DE INTRODUCIR EL PESO'
END
IF @CodigoAccion = 'MODIFICAR AGENTE'
BEGIN
DELETE POSLAccion
WHERE Host = @Host
AND Caja = @Caja
AND Accion = @CodigoAccion
INSERT POSLAccion (
Host, Caja, Accion)
VALUES (
@Host, @Caja, @CodigoAccion)
SELECT @Codigo = NULL
SELECT @Mensaje = 'FAVOR DE INTRODUCIR EL AGENTE'
END
IF @CodigoAccion = 'REGRESAR' AND @Ok IS NULL
BEGIN
SELECT @Codigo = NULL
END
IF @CodigoAccion = 'MODIFICAR CONDICION' AND @Ok IS NULL
BEGIN
SELECT @Codigo = NULL
SELECT @Mensaje = 'POR FAVOR INTRODUZCA LA CONDICION'
END
IF @CodigoAccion = 'INTRODUCIR CONCEPTODIN' AND @Ok IS NULL
BEGIN
SELECT @Codigo = NULL
SELECT @Mensaje = 'POR FAVOR INTRODUZCA EL CONCEPTO DE DINERO'
END
IF @CodigoAccion = 'MODIFICAR CAJA' AND @Ok IS NULL
BEGIN
SELECT @Codigo = NULL
SELECT @Mensaje = 'POR FAVOR INTRODUZCA LA CAJA'
END
IF @CodigoAccion = 'MODIFICAR REFERENCIA'
BEGIN
SELECT @Codigo = NULL
SELECT @Mensaje = 'POR FAVOR INTRODUZCA LA REFERENCIA'
END
IF @CodigoAccion = 'MODIFICAR CAJERO' AND @Ok IS NULL
BEGIN
SELECT @Codigo = NULL
SELECT @Mensaje = 'POR FAVOR INTRODUZCA LA CLAVE DEL CAJERO'
END
IF @CodigoAccion = 'REVERSAR COBRO' AND @Ok IS NULL
BEGIN
SELECT @Codigo = NULL
SELECT @Mensaje = 'POR FAVOR INTRODUZCA LA FORMA DE PAGO'
END
IF @CodigoAccion = 'MATRIZ OPCIONES'
BEGIN
SELECT @Codigo = NULL
SELECT @Mensaje = 'POR FAVOR INTRODUZCA LA CLAVE DEL ARTICULO'
END
IF @CodigoAccion = 'INTRODUCIR CUENTA DINERO' AND @Ok IS NULL
BEGIN
SELECT @Codigo = NULL
SELECT @Mensaje = 'POR FAVOR INTRODUZCA LA CUENTA DE DINERO'
IF EXISTS(SELECT 1 FROM POSLAccion WHERE Host = @Host AND Caja = @Caja AND Accion = @CodigoAccion)
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
INSERT POSLAccion (
Host,  Caja, Accion)
VALUES (
@Host, @Caja, @CodigoAccion)
END
IF @CodigoAccion = 'MODIFICAR COMPONENTE' AND @Ok IS NULL
BEGIN
SELECT @Codigo = NULL,@Accion = NULL
SELECT @Mensaje = 'POR FAVOR INTRODUZCA NUMERO DEL JUEGO A MODIFICAR'
IF EXISTS(SELECT 1 FROM POSLAccion WHERE Host = @Host AND Caja = @Caja AND Accion = @CodigoAccion)
DELETE FROM POSLAccion WHERE Host = @Host AND Caja = @Caja
INSERT POSLAccion (
Host,  Caja, Accion)
VALUES (
@Host, @Caja, @CodigoAccion)
END
IF @CodigoAccion = 'VER CORTE CAJA' AND @Ok IS NULL
BEGIN
SELECT @Codigo = NULL
SELECT @Accion = 'VER CORTE CAJA'
END
IF @CodigoAccion = 'VERIFICAR SALDO' AND @Ok IS NULL
BEGIN
SELECT @Mensaje = 'POR FAVOR INGRESE EL FOLIO DEL SALDO O MONEDERO'
END
IF @CodigoAccion = 'CONSULTAR INV' AND @Ok IS NULL
BEGIN
SELECT @Mensaje = 'POR FAVOR INGRESE EL CODIGO DEL ARTICULO'
END
IF @CodigoAccion = 'VERIFICAR PRECIOS' AND @Ok IS NULL
BEGIN
SELECT @Mensaje = 'POR FAVOR INGRESE EL CODIGO DEL ARTICULO BUSCAR'
END
IF @CodigoAccion = 'BUSCAR MOVIMIENTO' AND @Ok IS NULL
BEGIN
SELECT @Mensaje = 'POR FAVOR INGRESE EL ID DEL MOVIMIENTO'
END
IF @CodigoAccion = 'MODIFICAR CANTIDAD' AND @Ok IS NULL
BEGIN
SELECT @Mensaje = 'POR FAVOR INGRESE LA CANTIDAD'
END
IF @CodigoAccion = 'MULTIPLICAR CANTIDAD' AND @Ok IS NULL
BEGIN
SELECT @Mensaje = 'POR FAVOR INGRESE LA CANTIDAD'
END
IF @CodigoAccion = 'CANCELACION DINERO' AND @Ok IS NULL
BEGIN
SELECT @Mensaje = 'POR FAVOR INGRESE EL ID DEL MOVIMIENTO ORIGINAL'
INSERT POSLAccion (
Host, Caja, Accion)
VALUES (
@Host, @Caja, 'REVERSAR MOV')
END
IF @CodigoAccion = 'DEVOLUCION TOTAL' AND @Ok IS NULL
BEGIN
SELECT @Mensaje = 'POR FAVOR INGRESE EL ID DE LA VENTA ORIGINAL'
END
IF @CodigoAccion = 'DEVOLUCION TOTAL' AND @MovClave NOT IN('POS.F','POS.N','POS.NPC','POS.P')
SELECT @Ok = 35005
IF @CodigoAccion = 'DEVOLUCION PARCIAL' AND @Ok IS NULL
BEGIN
SELECT @Mensaje = 'POR FAVOR INGRESE EL ID DE LA VENTA ORIGINAL'
END
IF @CodigoAccion = 'DEVOLUCION PARCIAL' AND @MovClave NOT IN('POS.F','POS.N','POS.NPC','POS.P')
SELECT @Ok = 35005
IF @CodigoAccion = 'REFERENCIAR VENTA' AND @Ok IS NULL
BEGIN
SELECT @Mensaje = 'POR FAVOR INGRESE EL ID DE LA VENTA ORIGINAL'
INSERT POSLAccion (
Host, Caja, Accion)
VALUES (
@Host, @Caja, 'REFERENCIAR VENTA')
END
IF  @CodigoAccion = 'REFERENCIAR VENTA' AND @MovClave NOT IN('POS.N')AND @MovSubClave <> 'POS.DREF'
SELECT @Ok = 35005
IF @CodigoAccion = 'FACTURAR PEDIDO' AND @Ok IS NULL
BEGIN
IF @MovClave NOT IN ('POS.F','POS.N','POS.NPC')
SELECT @Ok = 35005
IF @CxcLocal = 1
BEGIN
IF @Ok IS NULL
EXEC spPOSSolicitudPedidoLocal  @ID, @Empresa, @Estacion, @Sucursal, @Usuario, @Ok OUTPUT, @OkRef OUTPUT
END
ELSE
BEGIN
IF @WebService = 0
SELECT @Ok = 30445
IF @Ok IS NULL
EXEC spPOSWSSolicitudPedido  @ID, @Empresa, @Estacion, @Sucursal, @Usuario, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL
SELECT @Expresion = 'Asigna(Info.Cliente,'+CHAR(39)+@Cliente+CHAR(39)+')  FormaModal('+CHAR(39)+'POSVentaPedidoTemp'+CHAR(39)+')'
END
IF @CodigoAccion = 'SELECCIONARCTE' AND @MovClave IN('POS.FA') AND @MovSubClave = 'POS.ANTREF'
BEGIN
SELECT @Expresion = 'FormaModal('+CHAR(39)+'POSCteLista'+CHAR(39)+')'
SELECT @Mensaje = 'SELECCIONE EL CLIENTE'
END
IF @CodigoAccion = 'REFERENCIAR PEDIDO' AND @MovClave IN('POS.FA') AND @MovSubClave = 'POS.ANTREF'
BEGIN
IF @WebService = 0
SELECT @Ok = 30445
IF @Ok IS NULL
EXEC spPOSWSSolicitudPedido  @ID, @Empresa, @Estacion, @Sucursal, @Usuario, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
SELECT @Expresion = 'Asigna(Info.Cliente,'+CHAR(39)+@Cliente+CHAR(39)+')  FormaModal('+CHAR(39)+'POSVentaPedidoTemp2'+CHAR(39)+')'
IF @Ok IS  NOT NULL  AND @RefPedidoSinWS = 1
BEGIN
SELECT  @Ok = NULL, @OkRef = NULL
SELECT @Mensaje = 'ERROR DE CONEXI±N DEL WEB SERVICE POR FAVOR INGRESE EL ID DEL PEDIDO A REFERENCIAR'
INSERT POSLAccion (
Host, Caja, Accion)
VALUES (
@Host, @Caja, 'REFERENCIAR PEDIDOMANUAL')
END
END
IF @MovClave IN('POS.CXCD', 'POS.CXCC')
BEGIN
IF @WebService = 0
SELECT @Ok = 30445
IF @Ok IS NULL AND @MovClave IN('POS.CXCD')
EXEC spPOSWSSolicitudCxcPendiente  @ID, @Empresa, @Estacion, @Sucursal, @Usuario, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL  AND @MovClave = 'POS.CXCC'
BEGIN
SELECT @Expresion = 'Asigna(Info.Cliente,'+CHAR(39)+@Cliente+CHAR(39)+')  FormaModal('+CHAR(39)+'POSSugerirCobro'+CHAR(39)+')'
SELECT @Mensaje = ' SELECCIONE EL DOCUMENTO A COBRAR '
END
IF @Ok IS NULL  AND @MovClave = 'POS.CXCD'
BEGIN
SELECT @Expresion = 'Asigna(Info.Cliente,'+CHAR(39)+@Cliente+CHAR(39)+')  FormaModal('+CHAR(39)+'POSCxcPendiente2'+CHAR(39)+')'
SELECT @Mensaje = ' SELECCIONE EL MOVIMIENTO A DEVOLVER '
END
END
IF @CodigoAccion = 'ANTICIPOS FACTURADOS' AND @Ok IS NULL
BEGIN
IF @MovClave NOT IN('POS.F','POS.N')
IF @MovSubClave <> 'POS.FACCRED'
SELECT @Ok = 35005
IF @CxcLocal = 1
BEGIN
IF @Ok IS NULL
EXEC spPOSSolicitudAnticiposCxcLocal  @ID, @Empresa, @Estacion, @Sucursal, @Usuario, @Ok OUTPUT, @OkRef OUTPUT
END
ELSE
BEGIN
IF @WebService = 0
SELECT @Ok = 30445
IF @Ok IS NULL
EXEC spPOSWSSolicitudAnticiposCxc  @ID, @Empresa, @Estacion, @Sucursal, @Usuario, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL
BEGIN
IF NULLIF(@PedidoReferencia,'') IS NOT NULL AND NULLIF(@PedidoReferenciaID,0) IS NOT NULL
SELECT @Expresion = 'Asigna(Info.Cliente,'+CHAR(39)+@Cliente+CHAR(39)+')  FormaModal('+CHAR(39)+'POSCxcAnticipoTemp2'+CHAR(39)+')'
ELSE
SELECT @Expresion = 'Asigna(Info.Cliente,'+CHAR(39)+@Cliente+CHAR(39)+')  FormaModal('+CHAR(39)+'POSCxcAnticipoTemp'+CHAR(39)+')'
END
END
IF @CodigoAccion = 'BUSCAR ARTICULOS' AND @Ok IS NULL
BEGIN
SELECT @Mensaje = 'POR FAVOR INGRESE PARTE DE LA DESCRIPCION DEL PRODUCTO'
END
IF @CodigoAccion = 'CANCELAR PARTIDA' AND @Ok IS NULL
BEGIN
SELECT @Mensaje = 'POR FAVOR INGRESE EL ARTICULO A CANCELAR'
END
IF @CodigoAccion = 'ELIMINAR MOVIMIENTO' AND @Ok IS NULL
BEGIN
EXEC spPOSMovEliminar @Empresa, @Modulo, @Sucursal, @Usuario, @Estacion, @ID OUTPUT, @Mensaje OUTPUT, @Imagen OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
DELETE FROM POSLAccion WHERE Host = @Host AND Accion = @CodigoAccion AND Caja = @Caja
DELETE FROM POSCxcAnticipoTemp WHERE Empresa = @Empresa AND Estacion = @Estacion
DELETE FROM POSCxcAnticipoTempD WHERE  Sucursal = @Sucursal AND Estacion = @Estacion
END
IF @CodigoAccion =   'BLOQUEAR CAJA' AND @Ok IS NULL
BEGIN
SELECT TOP 1 @Cajero = pec.Cajero
FROM POSEstatusCaja  pec
WHERE Caja = @Caja
AND Abierto = 1
EXEC spPOSEstatusCaja @Caja, @Host, @Cajero, @Usuario,  NULL, 1, @ok OUTPUT, @OkRef OUTPUT
DELETE FROM POSLAccion WHERE Host = @Host AND Accion = @CodigoAccion AND Caja = @Caja
IF @Ok IS NULL
SELECT @Mensaje = 'CAJA BLOQUEADA'
END
IF @CodigoAccion =   'DESBLOQUEAR CAJA' AND @Ok IS NULL
BEGIN
SELECT TOP 1 @Cajero = pec.Cajero
FROM POSEstatusCaja  pec
WHERE Caja = @Caja
AND Abierto = 1
IF NOT EXISTS(SELECT * FROM POSUsuarioAccion  WHERE Accion = 'DESBLOQUEAR CAJA' AND Usuario = ISNULL(NULLIF(@UsuarioAutorizaPerfil,''),@UsuarioAutoriza))
SELECT @OK = 46130
IF NOT EXISTS(SELECT * FROM Usuario WHERE Usuario = @UsuarioAutoriza AND ISNULL(POSEsSupervisor,0) = 1)
BEGIN
IF @UsuarioAutoriza <> @Usuario
SELECT @OK = 46130
END
IF @Ok IS NULL
EXEC spPOSEstatusCaja @Caja, @Host, @Cajero, @Usuario,  NULL, 0, @ok OUTPUT, @OkRef OUTPUT
DELETE FROM POSLAccion WHERE Host = @Host AND Accion = @CodigoAccion AND Caja = @Caja
IF @Ok IS NULL
SELECT @Mensaje = 'CAJA DESBLOQUEADA'
UPDATE POSL SET UsuarioAutoriza = NULL WHERE ID = @ID
END
IF @CodigoAccion = 'CAMBIAR MOVIMIENTO' AND @Ok IS NULL
BEGIN
IF @MovID IS NOT NULL OR @Estatus <> 'SINAFECTAR'
SELECT @Ok = 10015, @OkRef = 'Solo se pueden cambiar Movimientos Sin Afectar y/o sin aplicaciones'
IF @Ok IS NULL
SELECT @Mensaje = 'POR FAVOR INGRESE EL NOMBRE DEL MOVIMIENTO'
IF @Ok IS NOT NULL
BEGIN
DELETE FROM POSLAccion WHERE Host = @Host AND Accion = @CodigoAccion AND Caja = @Caja
SELECT @CodigoAccion = NULL
END
END
IF @CodigoAccion = 'MOVIMIENTO NUEVO' AND @Ok IS NULL
BEGIN
IF (SELECT COUNT(ID) FROM POSL WHERE Host = @Host AND CtaDinero = @Caja AND Estatus = 'SINAFECTAR') >= ISNULL(@CantidadNotasEnProceso,1)
SELECT @Ok = 61010, @OkRef = 'No puede tener mas de ' + CONVERT(varchar, ISNULL(@CantidadNotasEnProceso,1)) + ' movimiento(s) en proceso'
ELSE
BEGIN
IF EXISTS(SELECT 1 FROM POSL p INNER JOIN MovTipo mt ON p.Mov = mt.Mov AND mt.Modulo = 'POS'
AND mt.Clave IN ('POS.CC', 'POS.CPC', 'POS.AC','POS.ACM','POS.CCM','POS.CPCM','POS.IC','POS.EC','POS.AP')
WHERE p.Host = @Host AND (CtaDinero = @Caja OR CtaDineroDestino = @Caja) AND p.Estatus = 'SINAFECTAR' ) AND @Ok IS NULL
BEGIN
SELECT TOP 1 @ID = p.ID FROM POSL p INNER JOIN MovTipo mt ON p.Mov = mt.Mov AND mt.Modulo = 'POS'
AND mt.Clave IN ('POS.CC', 'POS.CPC', 'POS.AC','POS.ACM','POS.CCM','POS.CPCM','POS.AP')
WHERE p.Host = @Host AND (CtaDinero = @Caja OR CtaDineroDestino = @Caja) AND p.Estatus = 'SINAFECTAR'
SELECT @Ok = 61010, @OkRef = 'No puede insertar movimientos nuevos mientras tenga Aperturas o Cortes sin afectar'
END
ELSE
BEGIN
SELECT @ID = NULL
EXEC spPOSMovNuevo @Empresa, @Modulo, @Sucursal, @Usuario, @Estacion, @ID OUTPUT, @Imagen OUTPUT
END
END
DELETE FROM POSLAccion WHERE Host = @Host AND Accion = @CodigoAccion AND Caja = @Caja
END
IF @CodigoAccion = 'COPIAR OTRO MOV VENTAS' AND @Ok IS NULL
BEGIN
SELECT @Mensaje = 'POR FAVOR INGRESE EL CODIGO DEL MOVIMIENTO'
END
END

