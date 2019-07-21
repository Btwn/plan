SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spValeAfectar
@ID                		int,
@Accion			char(20),
@Empresa	      		char(5),
@Modulo	      		char(5),
@Mov	  	      		char(20),
@MovID             		varchar(20) OUTPUT,
@MovTipo     		char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaEmision      		datetime,
@FechaAfectacion      	datetime,
@FechaConclusion		datetime,
@Proyecto	      		varchar(50),
@Usuario	      		char(10),
@Autorizacion      		char(10),
@DocFuente	      		int,
@Observaciones     		varchar(255),
@Estatus           		char(15),
@EstatusNuevo	      	char(15),
@FechaRegistro     		datetime,
@Ejercicio	      		int,
@Periodo	      		int,
@Tipo			varchar(50),
@Precio			money,
@TipoTieneVigencia		bit,
@FechaInicio			datetime,
@FechaTermino		datetime,
@Cliente			char(10),
@Agente			char(10),
@Condicion			varchar(50),
@Vencimiento			datetime,
@Descuento			varchar(50),
@Concepto			varchar(50),
@Referencia			varchar(50),
@CtaDinero			char(10),
@FormaPago			varchar(50),
@MovNCredito			varchar(20),
@MovNCargo			varchar(20),
@Conexion			bit,
@SincroFinal			bit,
@Sucursal			int,
@SucursalDestino		int,
@SucursalOrigen		int,
@CfgContX			bit,
@CfgContXGenerar		char(20),
@GenerarPoliza		bit,
@GenerarMov			char(20)     OUTPUT,
@IDGenerar			int	     OUTPUT,
@GenerarMovID	  	varchar(20)  OUTPUT,
@Ok                		int          OUTPUT,
@OkRef             		varchar(255) OUTPUT

AS BEGIN
DECLARE
@Vale			char(20),
@ValeEstatus		char(15),
@Cantidad			int,
@Importe			money,
@ImporteAplicar		money,
@DescuentoMov		char(20),
@DescuentoImporte		money,
@DescuentoGlobal		float,
@FechaVenta			datetime,
@CxModulo			char(5),
@CxMov			char(20),
@CxMovID			varchar(20),
@DineroMov			char(20),
@DineroMovID		varchar(20),
@Generar				bit,
@GenerarAfectado		bit,
@GenerarModulo			char(5),
@GenerarMovTipo			char(20),
@GenerarEstatus			char(15),
@GenerarPeriodo 		int,
@GenerarEjercicio 		int,
@FechaCancelacion		datetime,
@GenerarAccion			char(20),
@RedondeoMonetarios		int,
@TipoTarjeta			bit,
@ArticuloTarjetas		char(20),
@AlmacenTarjetas		char(10),
@UEN					int,
@IDInv					int,
@MovIDInv				varchar(20),
@CfgMultiUnidades		bit,
@CfgMultiUnidadesNivel	char(20),
@CantidadInventario		float,
@Unidad					varchar(50),
@Factor					int, 
@EsCancelacion			bit, 
@TarjetaDestino			varchar(20), 
@SaldoDestino			money,		 
@POS                                bit ,
@OrigenTipo                         varchar(20),
@Serie                  varchar(20),
@EstatusPOS				varchar(15),
@TipoPOS				varchar(50)
SELECT  @POS = POS
FROM EmpresaGral
WHERE Empresa = @Empresa
SELECT @OrigenTipo = OrigenTipo FROM Vale WHERE ID = @ID
SELECT @Factor = 1 
SELECT @EsCancelacion = 0 
SELECT @RedondeoMonetarios = RedondeoMonetarios FROM Version
SELECT @Cantidad		= 0,
@Importe 		= 0.0,
@DescuentoGlobal	= NULL,
@Generar 		= 0,
@GenerarAfectado	= 0,
@IDGenerar		= NULL,
@GenerarModulo		= NULL,
@GenerarMovID	        = NULL,
@GenerarMovTipo        = NULL,
@GenerarEstatus 	= 'SINAFECTAR',
@ArticuloTarjetas 	= NULL
EXEC spMovConsecutivo @Sucursal, @SucursalOrigen, @SucursalDestino, @Empresa, @Usuario, @Modulo, @Ejercicio, @Periodo, @ID, @Mov, NULL, @Estatus, @Concepto, @Accion, @Conexion, @SincroFinal, @MovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR') AND @Accion <> 'CANCELAR' AND @Ok IS NULL
EXEC spMovChecarConsecutivo	@Empresa, @Modulo, @Mov, @MovID, NULL, @Ejercicio, @Periodo, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion IN ('CONSECUTIVO', 'SINCRO') AND @Ok IS NULL
BEGIN
IF @Accion = 'SINCRO' EXEC spAsignarSucursalEstatus @ID, @Modulo, @SucursalDestino, @Accion
SELECT @Ok = 80060, @OkRef = @MovID
RETURN
END
IF @OK IS NOT NULL RETURN
IF @Accion = 'GENERAR' AND @Ok IS NULL
BEGIN
EXEC spMovGenerar @Sucursal, @Empresa, @Modulo, @Ejercicio, @Periodo, @Usuario, @FechaRegistro, @GenerarEstatus,
NULL, NULL,
@Mov, @MovID, 0,
@GenerarMov, NULL, @GenerarMovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spMovTipo @Modulo, @GenerarMov, @FechaAfectacion, NULL, NULL, NULL, @GenerarMovTipo OUTPUT, @GenerarPeriodo OUTPUT, @GenerarEjercicio OUTPUT, @Ok OUTPUT
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Ok IS NULL SELECT @Ok = 80030
RETURN
END
IF @OK IS NOT NULL RETURN
IF @Conexion = 0
BEGIN TRANSACTION
EXEC spMovEstatus @Modulo, 'AFECTANDO', @ID, @Generar, @IDGenerar, @GenerarAfectado, @Ok OUTPUT
IF @Accion = 'AFECTAR' AND @Estatus = 'SINAFECTAR'
IF (SELECT Sincro FROM Version) = 1
EXEC sp_executesql N'UPDATE ValeD SET Sucursal = @Sucursal, SincroC = 1 WHERE ID = @ID AND (Sucursal <> @Sucursal OR SincroC <> 1)', N'@Sucursal int, @ID int', @Sucursal, @ID
IF @Accion <> 'CANCELAR'
EXEC spRegistrarMovimiento @Sucursal, @Empresa, @Modulo, @Mov, @MovID, @ID, @Ejercicio, @Periodo, @FechaRegistro, @FechaEmision,
NULL, @Proyecto, @MovMoneda, @MovTipoCambio,
@Usuario, @Autorizacion, NULL, @DocFuente, @Observaciones,
@Generar, @GenerarMov, @GenerarMovID, @IDGenerar,
@Ok OUTPUT
IF @MovTipo IN ('VALE.V', 'VALE.D', 'VALE.EV') AND @Descuento IS NOT NULL
SELECT @DescuentoGlobal = Porcentaje
FROM Descuento
WHERE Descuento = @Descuento
SELECT @Cantidad = COUNT(*)
FROM ValeD
WHERE ID = @ID
IF @MovTipo IN ('VALE.E', 'VALE.EV', 'VALE.ET', 'VALE.EO')
SELECT @Importe = @Precio * @Cantidad
ELSE
IF @MovTipo IN ('VALE.AT', 'VALE.TT', 'VALE.CS','VALE.AMLDI','VALE.ACTMLDI')
SELECT @Importe = SUM(d.Importe)
FROM ValeD d, ValeSerie s
WHERE d.ID = @ID AND s.Serie = d.Serie
ELSE
SELECT @Importe = SUM(s.Precio)
FROM ValeD d, ValeSerie s
WHERE d.ID = @ID AND s.Serie = d.Serie
IF @MovTipo IN ('VALE.E', 'VALE.EV', 'VALE.ET', 'VALE.EO')
BEGIN
IF @MovTipo = 'VALE.ET' SELECT @TipoTarjeta = 1 ELSE SELECT @TipoTarjeta = 0
IF @Accion = 'CANCELAR'
BEGIN
UPDATE ValeSerie SET Estatus = 'CANCELADO' FROM ValeD d, ValeSerie s WHERE d.ID = @ID AND s.Serie = d.Serie
IF @POS = 1
BEGIN
IF EXISTS(SELECT * FROM POSValeSerie WHERE Serie IN(SELECT Serie FROM ValeD WHERE ID = @ID))
UPDATE POSValeSerie SET Estatus = 'CANCELADO' FROM POSValeSerie s JOIN ValeD d ON s.Serie = d.Serie WHERE d.ID = @ID
END
IF @MovTipo = 'VALE.ET'
BEGIN
INSERT INTO AuxiliarValeSerie(Sucursal, Mov, MovID, Modulo, ModuloID, Serie, Ejercicio, Periodo, Fecha, Cargo, Abono, PorConciliar, EsCancelacion)
SELECT @Sucursal, @Mov, @MovID, @Modulo, @ID, Serie, @Ejercicio, @Periodo, @FechaEmision, -@Precio, NULL, 0, 1
FROM ValeD
WHERE ID = @ID
SELECT @IDInv = DID FROM MovFlujo WHERE OModulo = @Modulo AND OID = @ID AND DModulo = 'INV'
IF @IDInv is not null
EXEC spAfectar 'INV', @IDInv, @Accion, 'Todo', NULL, @Usuario, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @EnSilencio = 1, @Conexion = 1
END
END
ELSE
BEGIN
IF @MovTipo in ('VALE.E', 'VALE.ET')
SELECT @ValeEstatus = 'DISPONIBLE', @FechaVenta = NULL
ELSE
SELECT @ValeEstatus = 'CIRCULACION', @FechaVenta = @FechaEmision
IF @MovTipo in ('VALE.E', 'VALE.ET') AND @OrigenTipo IN ('POS') BEGIN
SELECT @Serie = NULL, @EstatusPOS = NULL
SELECT @Serie = ISNULL(Serie, '') FROM ValeD WHERE ID = @ID AND Serie NOT IN(SELECT Serie FROM ValeSerie)
IF NULLIF(@Serie, '') IS NOT NULL
SELECT @EstatusPOS = Estatus FROM POSValeSerie WHERE Serie = @Serie and Moneda = @MovMoneda and Tipo = @Tipo
IF @EstatusPOS = 'CIRCULACION' AND @ValeEstatus = 'DISPONIBLE'
SELECT @ValeEstatus = @EstatusPOS
END
IF @MovTipo = 'VALE.ET'
SELECT @ArticuloTarjetas = NULLIF(Articulo,'') FROM Vale WHERE ID = @ID
INSERT ValeSerie (Serie, Tipo, IDEmision, FechaEmision, FechaInicio, FechaTermino, Precio, Moneda, Estatus, Cliente, FechaVenta, TipoTarjeta, Articulo, Empresa)
SELECT Serie, @Tipo, @ID, @FechaEmision, @FechaInicio, @FechaTermino, @Precio, @MovMoneda, @ValeEstatus, @Cliente, @FechaVenta, @TipoTarjeta, @ArticuloTarjetas, @Empresa 
FROM ValeD
WHERE ID = @ID
AND Serie NOT IN(SELECT Serie FROM ValeSerie) 
IF NOT EXISTS(SELECT * FROM POSValeSerie WHERE Serie IN(SELECT Serie FROM ValeD WHERE ID = @ID))
INSERT POSValeSerie(Serie, Sucursal, Estatus,       Moneda,     Tipo,          Cliente)
SELECT              Serie, Sucursal, @ValeEstatus,  @MovMoneda, @TipoTarjeta,  NULL
FROM ValeD
WHERE ID = @ID
UPDATE ValeSerie 
SET Tipo				= @Tipo,
IDEmision		= @ID,
FechaEmision		= @FechaEmision,
FechaInicio		= @FechaInicio,
FechaTermino		= @FechaTermino,
Precio			= @Precio,
Moneda			= @MovMoneda,
Estatus			= @ValeEstatus,
Cliente			= @Cliente,
FechaVenta		= @FechaVenta,
TipoTarjeta		= @TipoTarjeta,
Articulo			= @ArticuloTarjetas,
Empresa			= @Empresa,
FechaCancelacion = NULL
FROM ValeD
WHERE ValeD.ID = @ID
AND ValeD.Serie IN(SELECT Serie FROM ValeSerie WHERE Estatus = 'CANCELADO')
IF @MovTipo = 'VALE.ET'
BEGIN
INSERT INTO AuxiliarValeSerie(Sucursal, Mov, MovID, Modulo, ModuloID, Serie, Ejercicio, Periodo, Fecha, Cargo, Abono, PorConciliar, EsCancelacion)
SELECT @Sucursal, @Mov, @MovID, @Modulo, @ID, Serie, @Ejercicio, @Periodo, @FechaEmision, @Precio, NULL, 0, 0
FROM ValeD
WHERE ID = @ID
SELECT @Unidad = Unidad FROM Art WHERE Articulo = @ArticuloTarjetas
SELECT @AlmacenTarjetas = Almacen FROM Vale WHERE ID = @ID
SELECT @UEN = UEN FROM Vale WHERE ID = @ID
INSERT INTO Inv(Empresa, Mov, FechaEmision, 		Proyecto, 	UEN, Moneda, TipoCambio, 	Usuario, Referencia, 				Estatus, Directo, Almacen, OrigenTipo, Origen, OrigenID, Sucursal, SucursalOrigen, SucursalDestino)
VALUES(@Empresa, 'Entrada Diversa', @FechaEmision, @Proyecto, @UEN, @MovMoneda, @MovTipoCambio, @Usuario, RTRIM(@Mov) + ' ' + RTRIM(@MovID), 'SINAFECTAR', 1, @AlmacenTarjetas, 'VALE', @Mov, @MovID, @Sucursal, @SucursalOrigen, @SucursalDestino)
SELECT @IDInv = SCOPE_IDENTITY()
EXEC xpCantidadInventario @ArticuloTarjetas, NULL, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
INSERT INTO InvD(ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Cantidad, Almacen, Articulo, Costo, Unidad, Factor, CantidadInventario, Sucursal, SucursalOrigen)
VALUES(@IDInv, 2048, 0, 1, 'S', @Cantidad, @AlmacenTarjetas, @ArticuloTarjetas, 0.01, @Unidad, 1, @CantidadInventario, @Sucursal, @SucursalOrigen)
INSERT INTO SerieLoteMov(Empresa, Modulo, ID, RenglonID, Articulo, SerieLote, Cantidad, Sucursal)
SELECT @Empresa, 'INV', @IDInv, 1, @ArticuloTarjetas, Serie, 1, @Sucursal
FROM ValeD
WHERE ID = @ID
EXEC spAfectar 'INV', @IDInv, @Accion, 'Todo', NULL, @Usuario, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @EnSilencio = 1, @Conexion = 1
IF @Ok is null
BEGIN
SELECT @MovIDInv = MovID FROM Inv WHERE ID = @IDInv
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'INV', @IDInv, 'Entrada Diversa', @MovIDInv, @Ok = @OK OUTPUT
END
END
END
END ELSE
IF @MovTipo in ('VALE.C', 'VALE.CT')
BEGIN
IF @Accion = 'CANCELAR'
UPDATE ValeSerie SET FechaCancelacion = NULL, Estatus = 'DISPONIBLE' FROM ValeD d, ValeSerie s WHERE d.ID = @ID AND s.Serie = d.Serie
ELSE
UPDATE ValeSerie SET FechaCancelacion = @FechaEmision, Estatus = 'CANCELADO' FROM ValeD d, ValeSerie s WHERE d.ID = @ID AND s.Serie = d.Serie
END ELSE
IF @MovTipo IN ('VALE.V', 'VALE.O'/*, 'VALE.OT'*/)
BEGIN
IF @Accion = 'CANCELAR'
UPDATE ValeSerie SET FechaVenta = NULL, Cliente = NULL, Estatus = 'DISPONIBLE' FROM ValeD d, ValeSerie s WHERE d.ID = @ID AND s.Serie = d.Serie
ELSE
UPDATE ValeSerie SET FechaVenta = @FechaEmision, Cliente = @Cliente, Estatus = 'CIRCULACION' FROM ValeD d, ValeSerie s WHERE d.ID = @ID AND s.Serie = d.Serie
END ELSE
IF @MovTipo = 'VALE.D'
BEGIN
IF @Accion = 'CANCELAR'
UPDATE ValeSerie SET FechaVenta = @FechaEmision, Cliente = @Cliente, Estatus = 'CIRCULACION' FROM ValeD d, ValeSerie s WHERE d.ID = @ID AND s.Serie = d.Serie
ELSE
UPDATE ValeSerie SET FechaVenta = NULL, Cliente = NULL, Estatus = 'DISPONIBLE' FROM ValeD d, ValeSerie s WHERE d.ID = @ID AND s.Serie = d.Serie
END ELSE
IF @MovTipo in ('VALE.B', 'VALE.BT')
BEGIN
IF @Accion = 'CANCELAR'
UPDATE ValeSerie SET FechaBloqueo = NULL, Estatus = CASE WHEN Cliente IS NULL THEN 'DISPONIBLE' ELSE 'CIRCULACION' END FROM ValeD d, ValeSerie s WHERE d.ID = @ID AND s.Serie = d.Serie
ELSE
UPDATE ValeSerie SET FechaBloqueo = @FechaEmision, Estatus = 'BLOQUEADO' FROM ValeD d, ValeSerie s WHERE d.ID = @ID AND s.Serie = d.Serie
END ELSE
IF @MovTipo in ('VALE.DB', 'VALE.DBT')
BEGIN
IF @Accion = 'CANCELAR'
UPDATE ValeSerie SET Estatus = 'BLOQUEADO' FROM ValeD d, ValeSerie s WHERE d.ID = @ID AND s.Serie = d.Serie
ELSE
UPDATE ValeSerie SET FechaBloqueo = NULL, Estatus = CASE WHEN Cliente IS NULL THEN 'DISPONIBLE' ELSE 'CIRCULACION' END FROM ValeD d, ValeSerie s WHERE d.ID = @ID AND s.Serie = d.Serie
END ELSE
IF @MovTipo = 'VALE.A'
BEGIN
IF @Accion = 'CANCELAR'
UPDATE ValeSerie SET Estatus = 'COBRADO', FechaAplicacion = NULL FROM ValeD d, ValeSerie s WHERE d.ID = @ID AND s.Serie = d.Serie
ELSE
UPDATE ValeSerie SET FechaAplicacion = @FechaEmision, Estatus = 'CONCLUIDO' FROM ValeD d, ValeSerie s WHERE d.ID = @ID AND s.Serie = d.Serie
END ELSE
IF @MovTipo = 'VALE.CM'
BEGIN
IF @Accion = 'CANCELAR'
UPDATE ValeSerie SET Estatus = 'CIRCULACION' FROM ValeD d, ValeSerie s WHERE d.ID = @ID AND s.Serie = d.Serie
ELSE
UPDATE ValeSerie SET Estatus = 'COBRADO' FROM ValeD d, ValeSerie s WHERE d.ID = @ID AND s.Serie = d.Serie
END
IF @Importe > 0.0 OR @MovTipo = 'VALE.AT'
BEGIN
IF @MovTipo IN ('VALE.V', 'VALE.D', 'VALE.EV', 'VALE.O'/*, 'VALE.OT'*/)
EXEC spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @Modulo, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, NULL, @Proyecto, @Usuario,  NULL, NULL, NULL, NULL,
@FechaRegistro, @Ejercicio, @Periodo,
@Condicion, @Vencimiento, @Cliente, NULL, @Agente, NULL, NULL, NULL,
@Importe, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, NULL,
@CxModulo OUTPUT, @CxMov OUTPUT, @CxMovID OUTPUT, @Ok OUTPUT, @OkRef  OUTPUT
IF @MovTipo IN ('VALE.V', 'VALE.D', 'VALE.EV') AND @DescuentoGlobal > 0
BEGIN
SELECT @DescuentoImporte = ROUND(@Importe * (@DescuentoGlobal / 100), @RedondeoMonetarios)
IF @MovTipo IN ('VALE.V', 'VALE.EV')
SELECT @DescuentoMov = @MovNCredito
ELSE
SELECT @DescuentoMov = @MovNCargo
EXEC spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @Modulo, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, NULL, @Proyecto, @Usuario,  NULL, NULL, NULL, NULL,
@FechaRegistro, @Ejercicio, @Periodo,
@Condicion, @Vencimiento, @Cliente, NULL, @Agente, NULL, NULL, NULL,
@DescuentoImporte, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, @DescuentoMov,
@CxModulo OUTPUT, @CxMov OUTPUT, @CxMovID OUTPUT, @Ok OUTPUT, @OkRef  OUTPUT
END
IF @MovTipo = 'VALE.A' AND @Ok IS NULL
BEGIN
DECLARE crValeCliente CURSOR FOR
SELECT s.Cliente, SUM(s.Precio)
FROM ValeD d, ValeSerie s
WHERE d.ID = @ID AND s.Serie = d.Serie
GROUP BY s.Cliente
OPEN crValeCliente
FETCH NEXT FROM crValeCliente INTO @Cliente, @ImporteAplicar
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
EXEC spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @Modulo, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, NULL, @Proyecto, @Usuario,  NULL, NULL, NULL, NULL,
@FechaRegistro, @Ejercicio, @Periodo,
NULL, NULL, @Cliente, NULL, NULL, NULL, NULL, NULL,
@ImporteAplicar, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, NULL,
@CxModulo OUTPUT, @CxMov OUTPUT, @CxMovID OUTPUT, @Ok OUTPUT, @OkRef  OUTPUT
IF @Ok = 80030 SELECT @Ok = NULL
END
FETCH NEXT FROM crValeCliente INTO @Cliente, @ImporteAplicar
END
CLOSE crValeCliente
DEALLOCATE crValeCliente
IF @Ok IS NULL
EXEC spGenerarDinero @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones, 0, 0,
@FechaRegistro, @Ejercicio, @Periodo,
@FormaPago, NULL, NULL,
NULL, @CtaDinero, NULL, @Importe, NULL,
NULL, NULL, NULL,
@DineroMov OUTPUT, @DineroMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
IF @Ok = 80030 SELECT @Ok = NULL
IF @Ok = NULL
EXEC xpValeAplicacion  @Sucursal, @Accion, @Modulo, @Empresa, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio, @FechaEmision,
@Concepto, @Proyecto, @Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones, @FechaRegistro, @Ejercicio, @Periodo,
@Ok OUTPUT, @OkRef OUTPUT
END
IF @MovTipo = 'VALE.AT' AND @Ok IS NULL
BEGIN
/*
DECLARE crValeCliente CURSOR FOR
SELECT s.Cliente, SUM(d.Importe)
FROM ValeD d, ValeSerie s
WHERE d.ID = @ID AND s.Serie = d.Serie
GROUP BY s.Cliente
OPEN crValeCliente
FETCH NEXT FROM crValeCliente INTO @Cliente, @ImporteAplicar
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
EXEC spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @Modulo, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, NULL, @Proyecto, @Usuario,  NULL, NULL, NULL, NULL,
@FechaRegistro, @Ejercicio, @Periodo,
NULL, NULL, @Cliente, NULL, NULL, NULL, NULL, NULL,
@ImporteAplicar, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, NULL,
@CxModulo OUTPUT, @CxMov OUTPUT, @CxMovID OUTPUT, @Ok OUTPUT, @OkRef  OUTPUT
IF @Ok = 80030 SELECT @Ok = NULL
END
FETCH NEXT FROM crValeCliente INTO @Cliente, @ImporteAplicar
END
CLOSE crValeCliente
DEALLOCATE crValeCliente
*/
IF @Ok IS NULL
BEGIN
SELECT @Importe = Abs(@Importe)
EXEC spGenerarDinero @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaAfectacion, @Concepto, @Proyecto, @Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones, 0, 0,
@FechaRegistro, @Ejercicio, @Periodo,
@FormaPago, NULL, NULL,
NULL, @CtaDinero, NULL, @Importe, NULL,
NULL, NULL, NULL,
@DineroMov OUTPUT, @DineroMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok = 80030 SELECT @Ok = NULL
IF @Ok = NULL
EXEC xpValeAplicacion  @Sucursal, @Accion, @Modulo, @Empresa, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio, @FechaEmision,
@Concepto, @Proyecto, @Usuario, @Autorizacion, @Referencia, @DocFuente, @Observaciones, @FechaRegistro, @Ejercicio, @Periodo,
@Ok OUTPUT, @OkRef OUTPUT
END
IF @MovTipo = 'VALE.CS' AND @Ok IS NULL
BEGIN
IF @Accion = 'CANCELAR' SELECT @Factor = -1, @EsCancelacion = 1
INSERT INTO AuxiliarValeSerie(Sucursal, Mov, MovID, Modulo, ModuloID, Serie, Ejercicio, Periodo, Fecha, Cargo, Abono, PorConciliar, EsCancelacion)
SELECT @Sucursal, @Mov, @MovID, @Modulo, @ID, Serie, @Ejercicio, @Periodo, @FechaEmision, NULL, Importe * @Factor, 0, @EsCancelacion
FROM ValeD
WHERE ID = @ID
END
IF @MovTipo = 'VALE.TT' AND @Ok IS NULL
BEGIN
IF @Accion = 'CANCELAR' SELECT @Factor = -1, @EsCancelacion = 1
INSERT INTO AuxiliarValeSerie(Sucursal, Mov, MovID, Modulo, ModuloID, Serie, Ejercicio, Periodo, Fecha, Cargo, Abono, PorConciliar, EsCancelacion)
SELECT @Sucursal, @Mov, @MovID, @Modulo, @ID, Serie, @Ejercicio, @Periodo, @FechaEmision, NULL, Importe * @Factor, 0, @EsCancelacion
FROM ValeD
WHERE ID = @ID
SELECT @TarjetaDestino = TarjetaDestino FROM Vale WHERE ID = @ID
SELECT @SaldoDestino = SUM(Importe) FROM ValeD WHERE ID = @ID
INSERT INTO AuxiliarValeSerie(Sucursal, Mov, MovID, Modulo, ModuloID, Serie, Ejercicio, Periodo, Fecha, Cargo, Abono, PorConciliar, EsCancelacion)
VALUES(@Sucursal, @Mov, @MovID, @Modulo, @ID, @TarjetaDestino, @Ejercicio, @Periodo, @FechaEmision, @SaldoDestino * @Factor, NULL, 0, @EsCancelacion)
END
END 
IF @Ok IN (NULL, 80030)
BEGIN
IF @EstatusNuevo = 'CANCELADO' SELECT @FechaCancelacion = @FechaRegistro ELSE SELECT @FechaCancelacion = NULL
IF @EstatusNuevo = 'CONCLUIDO' SELECT @FechaConclusion  = @FechaEmision  ELSE IF @EstatusNuevo <> 'CANCELADO' SELECT @FechaConclusion  = NULL
IF @CfgContX = 1 AND @CfgContXGenerar <> 'NO'
BEGIN
IF @Estatus =  'SINAFECTAR' AND @EstatusNuevo <> 'CANCELADO' SELECT @GenerarPoliza = 1 ELSE
IF @Estatus <> 'SINAFECTAR' AND @EstatusNuevo =  'CANCELADO' IF @GenerarPoliza = 1 SELECT @GenerarPoliza = 0 ELSE SELECT @GenerarPoliza = 1
END
EXEC spValidarTareas @Empresa, @Modulo, @ID, @EstatusNuevo, @Ok OUTPUT, @OkRef OUTPUT
UPDATE Vale
SET Cantidad         = @Cantidad,
Importe	      = @Importe,
DescuentoGlobal  = @DescuentoGlobal,
FechaConclusion  = @FechaConclusion,
FechaCancelacion = @FechaCancelacion,
UltimoCambio     = /*CASE WHEN UltimoCambio IS NULL THEN */@FechaRegistro /*ELSE UltimoCambio END*/,
Estatus          = @EstatusNuevo,
Situacion 	      = CASE WHEN @Estatus <> @EstatusNuevo THEN NULL ELSE Situacion END,
GenerarPoliza    = @GenerarPoliza
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
END
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spMovFinal @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @MovTipo = 'VALE.ACTMLDI' AND @Estatus = 'PENDIENTE' AND @EstatusNuevo = 'CONCLUIDO' AND @OrigenTipo NOT IN('POS')
BEGIN
EXEC spLDIValeActivarMonedero @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @Accion, @FechaEmision, @Ejercicio, @Periodo, @Usuario, @Sucursal, @MovMoneda, @MovTipoCambio, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL AND (@MovTipo = 'VALE.AMLDI' AND @Estatus = 'PENDIENTE' AND @EstatusNuevo = 'CONCLUIDO' AND @Accion = 'AFECTAR' AND @OrigenTipo NOT IN('POS'))
OR (@Estatus = 'CONCLUIDO' AND @EstatusNuevo = 'CANCELADO' AND @Accion = 'CANCELAR' AND @OrigenTipo NOT IN('POS'))
BEGIN
EXEC spLDIValeGenerarAbonoMonedero @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @Accion, @FechaEmision, @Ejercicio, @Periodo, @Usuario, @Sucursal, @MovMoneda, @MovTipoCambio, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NOT NULL SET @Estatus = 'PENDIENTE'
END
IF @Accion = 'CANCELAR' AND @EstatusNuevo = 'CANCELADO' AND @Ok IS NULL
EXEC spCancelarFlujo @Empresa, @Modulo, @ID, @Ok OUTPUT
IF @Conexion = 0
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
RETURN
END

