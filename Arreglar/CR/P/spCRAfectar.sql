SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCRAfectar
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
@UEN				int,
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
@Caja			char(10),
@Cajero			char(10),
@Concepto			varchar(50),
@Referencia			varchar(50),
@CfgPrestamoCxc		bit,
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
@CR				char(20),
@CREstatus			char(15),
@Cantidad			float,
@Importe			money,
@PrecioTotal		money,
@ImporteAplicar		money,
@DescuentoMov		char(20),
@DescuentoImporte		money,
@DescuentoLinea		float,
@FechaVenta			datetime,
@DescripcionExtra		varchar(100),
@CxModulo			char(5),
@CxMov			char(20),
@CxMovID			varchar(20),
@Generar			bit,
@GenerarAfectado		bit,
@GenerarModulo		char(5),
@GenerarMovTipo		char(20),
@GenerarEstatus		char(15),
@GenerarPeriodo 		int,
@GenerarEjercicio 		int,
@FechaCancelacion		datetime,
@GenerarAccion		char(20),
@ZonaImpuesto		varchar(30),
@CfgCosteoNivelSubCuenta 	bit,
@CfgZonaImpuestoNivelCte	bit,
@CfgImpInc			bit,
@CfgPrecioMoneda		bit,
@CfgVentaMultiAlmacen	bit,
@TipoCosteo			varchar(20),
@ClienteNota		char(10),
@ClienteVMOS		char(10),
@AlmacenPrincipal		char(10),
@Almacen			char(10),
@AlmacenD			char(10),
@Posicion			char(10),
@VentaID			int,
@VentaMov			char(20),
@VentaMovID			varchar(20),
@VentaEstatus		char(15),
@Movimiento			varchar(20),
@CtaOrigen			char(10),
@CtaDestino			char(10),
@CtaDinero			char(10),
@FormaPago			varchar(50),
@DineroID			int,
@DineroMov			char(20),
@DineroMovID		varchar(20),
@CxcID			int,
@CxcMov			char(20),
@CxcMovID			varchar(20),
@InvID			int,
@InvMov			char(20),
@InvMovID			varchar(20),
@InvMovTipo			varchar(20),
@InvEstatus			varchar(15),
@AjusteID			int,
@AjusteMov			char(20),
@AjusteMovID		varchar(20),
@SoporteID			int,
@SoporteMov			char(20),
@SoporteMovID		varchar(20),
@ConDesglose		bit,
@Renglon			float,
@RenglonID			int,
@Articulo			char(20),
@SubCuenta			varchar(50),
@Impuesto1			float,
@Impuesto2			float,
@Impuesto3			money,
@Unidad			varchar(50),
@Precio			float,
@Costo			money,
@JuntarImpuestos		float,
@Moneda			char(10),
@TipoCambio			float,
@Cliente			char(10),
@ClienteEnviarA		int,
@Condicion			varchar(50),
@Agente			char(10),
@Cxc			bit,
@Aplica			varchar(20),
@AplicaID			varchar(20),
@AplicaImporte		money,
@ImportePendiente		money,
@Vencimiento		datetime,
@Saldo			money,
@AplicaManual		bit,
@VentaIdentificada		bit,
@MovNota			char(20),
@MovFactura			char(20),
@MovCobro			char(20),
@MovApertura		char(20),
@MovIngreso			char(20),
@MovEgreso			char(20),
@MovRecoleccion		char(20),
@MovFondoInicial		char(20),
@MovDeposito		char(20),
@MovSolicitudDeposito	char(20),
@MovCheque			char(20),
@MovFaltante		char(20),
@MovSobrante		char(20),
@MovRedondeo		char(20),
@MovTransferencia		char(20),
@MovInvFisico		char(20),
@MovInvTransferencia	char(20),
@MovAjuste			char(20),
@MovPrestamoCxc		char(20),
@FechaBanco			datetime,
@ConceptoBanco		varchar(50),
@CRAgente			bit,
@CRMovVenta			varchar(20),
@AlmacenOrigen		char(10),
@AlmacenDestino		char(10),
@SucursalCliente		char(10),
@CFDSerie			varchar(20), 
@CFDFolio			varchar(20), 
@CFDReferencia		varchar(50)  
SELECT @Cantidad		= 0,
@Importe 		= 0.0,
@Agente		= NULL,
@Generar 		= 0,
@GenerarAfectado	= 0,
@IDGenerar		= NULL,
@GenerarModulo		= NULL,
@GenerarMovID	        = NULL,
@GenerarMovTipo        = NULL,
@GenerarEstatus 	= 'SINAFECTAR'
SELECT @CfgCosteoNivelSubCuenta = CosteoNivelSubCuenta,
@ClienteVMOS             = NULLIF(RTRIM(ClienteFacturaVMOS), ''),
@TipoCosteo		  = ISNULL(NULLIF(RTRIM(UPPER(TipoCosteo)), ''), 'PROMEDIO'),
@CfgImpInc 		  = VentaPreciosImpuestoIncluido,
@CfgPrecioMoneda	  = VentaPrecioMoneda,
@ConDesglose 		  = DineroDesgloseObligatorio,
@CRAgente		  = ISNULL(CRAgente, 0),
@CfgZonaImpuestoNivelCte = ISNULL(CRZonaImpuestoNivelCte, 0)
FROM EmpresaCfg
WHERE Empresa = @Empresa
IF @ClienteVMOS IS NULL SELECT @Ok = 10580
IF @CRAgente = 0 SELECT @Agente = @Cajero
SELECT @CfgVentaMultiAlmacen = ISNULL(VentaMultiAlmacen, 0)
FROM EmpresaCfg2
WHERE Empresa = @Empresa
SELECT @MovNota         	= CRNota,
@MovFactura      	= CRFactura,
@MovCobro 		= CxcCobro,
@MovApertura      	= CajaApertura,
@MovIngreso       	= CajaIngreso,
@MovEgreso        	= CajaEgreso,
@MovRecoleccion   	= CajaRecoleccion,
@MovDeposito      	= BancoDeposito,
@MovSolicitudDeposito  = BancoSolicitudDeposito,
@MovCheque        	= BancoCheque,
@MovFaltante      	= CajaFaltanteCaja,
@MovSobrante      	= CajaSobranteCaja,
@MovRedondeo      	= DineroRedondeo,
@MovFondoInicial  	= CajaFondoInicial,
@MovTransferencia      = CajaTransferencia,
@MovInvFisico		= InvFisico,
@MovInvTransferencia	= InvTransferencia,
@MovAjuste		= InvAjuste,
@MovPrestamoCxc	= CRPrestamoCxc
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
/*  IF @Accion = 'AFECTAR' AND @MovTipo = 'CR.Z'
IF (SELECT Clave FROM MovTipo WHERE Modulo = 'DIN' AND Mov = @MovDeposito) NOT IN ('DIN.D', 'DIN.SD')
SELECT @Ok = 35005, @OkRef = @MovDeposito*/
/* CREATE TABLE #DineroOrden (
Orden		int		NOT NULL PRIMARY KEY,
Mov		varchar(20)	NULL)*/
CREATE TABLE #DineroD (
Renglon		float		NULL,
FormaPago	varchar(50)	COLLATE Database_Default NULL,
Referencia	varchar(50)	COLLATE Database_Default NULL,
Importe		money		NULL)
/*  INSERT #DineroOrden (Orden, Mov) VALUES (1, @MovApertura)
INSERT #DineroOrden (Orden, Mov) VALUES (2, @MovIngreso)
INSERT #DineroOrden (Orden, Mov) VALUES (3, @MovRecoleccion)
INSERT #DineroOrden (Orden, Mov) VALUES (4, @MovFaltante)
INSERT #DineroOrden (Orden, Mov) VALUES (5, @MovSobrante)
INSERT #DineroOrden (Orden, Mov) VALUES (6, @MovCorte)
INSERT #DineroOrden (Orden, Mov) VALUES (7, @MovTransferencia)
*/
SELECT @AlmacenPrincipal = NULLIF(RTRIM(AlmacenPrincipal), ''),
@SucursalCliente  = NULLIF(RTRIM(Cliente),'')
FROM Sucursal
WHERE Sucursal = @Sucursal
EXEC xpCRAlmacenPrincipal @ID, @AlmacenPrincipal OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @AlmacenPrincipal IS NULL AND @Ok IS NULL SELECT @Ok = 10570
IF @CfgPrestamoCxc = 1 AND @SucursalCliente IS NULL AND @Ok IS NULL SELECT @Ok = 10581
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
EXEC spMovTipo @Modulo, @GenerarMov, @FechaAfectacion, @Empresa, NULL, NULL, @GenerarMovTipo OUTPUT, @GenerarPeriodo OUTPUT, @GenerarEjercicio OUTPUT, @Ok OUTPUT
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Ok IS NULL SELECT @Ok = 80030
RETURN
END
IF @OK IS NOT NULL RETURN
IF @Conexion = 0
BEGIN TRANSACTION
EXEC spMovEstatus @Modulo, 'AFECTANDO', @ID, @Generar, @IDGenerar, @GenerarAfectado, @Ok OUTPUT
IF @Accion = 'AFECTAR' AND @Estatus = 'SINAFECTAR'
BEGIN
IF (SELECT Sincro FROM Version) = 1
BEGIN
EXEC sp_executesql N'UPDATE CRVenta     SET Sucursal = @Sucursal, SincroC = 1 WHERE ID = @ID AND (Sucursal <> @Sucursal OR SincroC <> 1)', N'@Sucursal int, @ID int', @Sucursal, @ID
EXEC sp_executesql N'UPDATE CRAgente    SET Sucursal = @Sucursal, SincroC = 1 WHERE ID = @ID AND (Sucursal <> @Sucursal OR SincroC <> 1)', N'@Sucursal int, @ID int', @Sucursal, @ID
EXEC sp_executesql N'UPDATE CRCobro     SET Sucursal = @Sucursal, SincroC = 1 WHERE ID = @ID AND (Sucursal <> @Sucursal OR SincroC <> 1)', N'@Sucursal int, @ID int', @Sucursal, @ID
EXEC sp_executesql N'UPDATE CRCaja      SET Sucursal = @Sucursal, SincroC = 1 WHERE ID = @ID AND (Sucursal <> @Sucursal OR SincroC <> 1)', N'@Sucursal int, @ID int', @Sucursal, @ID
EXEC sp_executesql N'UPDATE CRInvFisico SET Sucursal = @Sucursal, SincroC = 1 WHERE ID = @ID AND (Sucursal <> @Sucursal OR SincroC <> 1)', N'@Sucursal int, @ID int', @Sucursal, @ID
EXEC sp_executesql N'UPDATE CRTrans     SET Sucursal = @Sucursal, SincroC = 1 WHERE ID = @ID AND (Sucursal <> @Sucursal OR SincroC <> 1)', N'@Sucursal int, @ID int', @Sucursal, @ID
EXEC sp_executesql N'UPDATE CRSoporte   SET Sucursal = @Sucursal, SincroC = 1 WHERE ID = @ID AND (Sucursal <> @Sucursal OR SincroC <> 1)', N'@Sucursal int, @ID int', @Sucursal, @ID
END
END
IF @Accion <> 'CANCELAR'
EXEC spRegistrarMovimiento @Sucursal, @Empresa, @Modulo, @Mov, @MovID, @ID, @Ejercicio, @Periodo, @FechaRegistro, @FechaEmision,
NULL, @Proyecto, @MovMoneda, @MovTipoCambio,
@Usuario, @Autorizacion, NULL, @DocFuente, @Observaciones,
@Generar, @GenerarMov, @GenerarMovID, @IDGenerar,
@Ok OUTPUT
IF @Accion = 'CANCELAR' AND @Ok IS NULL
BEGIN
DECLARE crCancelarVentas CURSOR LOCAL STATIC FOR
SELECT ID, Mov, MovID, Estatus
FROM Venta
WHERE Empresa = @Empresa AND OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
ORDER BY ID DESC
OPEN crCancelarVentas
FETCH NEXT FROM crCancelarVentas INTO @VentaID, @VentaMov, @VentaMovID, @VentaEstatus
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
EXEC spInv @VentaID, 'VTAS', @Accion, 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, NULL,
@VentaMov, @VentaMovID OUTPUT, NULL, NULL,
@Ok OUTPUT, @OkRef OUTPUT, 0
IF @Ok IS NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'VTAS', @VentaID, @VentaMov, @VentaMovID, @Ok OUTPUT
IF @Ok IS NOT NULL SELECT @OkRef = RTRIM(@OkRef) + ' - ' + RTRIM(@VentaMov) + ' ' + RTRIM(@VentaMovID)
END
FETCH NEXT FROM crCancelarVentas INTO @VentaID, @VentaMov, @VentaMovID, @VentaEstatus
END  
CLOSE crCancelarVentas
DEALLOCATE crCancelarVentas
DECLARE crCancelarDinero CURSOR LOCAL STATIC FOR
SELECT ID, Mov, MovID
FROM Dinero
WHERE Empresa = @Empresa AND OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
ORDER BY ID DESC
OPEN crCancelarDinero
FETCH NEXT FROM crCancelarDinero INTO @DineroID, @DineroMov, @DineroMovID
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
EXEC spDinero @DineroID, 'DIN', @Accion, 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0,
@DineroMov OUTPUT, @DineroMovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'DIN', @DineroID, @DineroMov, @DineroMovID, @Ok OUTPUT
IF @Ok IS NOT NULL SELECT @OkRef = RTRIM(@OkRef) + ' - ' + RTRIM(@DineroMov) + ' ' + RTRIM(@DineroMovID)
END
FETCH NEXT FROM crCancelarDinero INTO @DineroID, @DineroMov, @DineroMovID
END  
CLOSE crCancelarDinero
DEALLOCATE crCancelarDinero
DECLARE crCancelarCxc CURSOR LOCAL STATIC FOR
SELECT ID, Mov, MovID
FROM Cxc
WHERE Empresa = @Empresa AND OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
ORDER BY ID DESC
OPEN crCancelarCxc
FETCH NEXT FROM crCancelarCxc INTO @CxcID, @CxcMov, @CxcMovID
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
EXEC spCx @CxcID, 'CXC', @Accion, 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0,
@CxcMov OUTPUT, @CxcMovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'DIN', @CxcID, @CxcMov, @CxcMovID, @Ok OUTPUT
IF @Ok IS NOT NULL SELECT @OkRef = RTRIM(@OkRef) + ' - ' + RTRIM(@CxcMov) + ' ' + RTRIM(@CxcMovID)
END
FETCH NEXT FROM crCancelarCxc INTO @CxcID, @CxcMov, @CxcMovID
END  
CLOSE crCancelarCxc
DEALLOCATE crCancelarCxc
DECLARE crCancelarInv CURSOR LOCAL STATIC FOR
SELECT i.ID, i.Mov, i.MovID, i.Estatus, mt.Clave
FROM Inv i
JOIN MovTipo mt ON mt.Modulo = 'INV' AND mt.Mov = i.Mov
WHERE i.Empresa = @Empresa AND i.OrigenTipo = @Modulo AND i.Origen = @Mov AND i.OrigenID = @MovID AND i.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
ORDER BY i.ID DESC
OPEN crCancelarInv
FETCH NEXT FROM crCancelarInv INTO @InvID, @InvMov, @InvMovID, @InvEstatus, @InvMovTipo
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF @InvMovTipo = 'INV.IF' AND @InvEstatus = 'CONCLUIDO'
BEGIN
SELECT @InvID = NULL
SELECT @InvID = ID, @InvMov = Mov, @InvMovID = MovID
FROM Inv
WHERE Empresa = @Empresa AND Origen = @InvMov AND OrigenID = @InvMovID AND Estatus IN ('CONCLUIDO', 'PENDIENTE')
END
IF @InvID IS NOT NULL
BEGIN
EXEC spInv @InvID, 'INV', @Accion, 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, NULL,
@InvMov, @InvMovID OUTPUT, NULL, NULL,
@Ok OUTPUT, @OkRef OUTPUT, 0
IF @Ok IS NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'INV', @InvID, @InvMov, @InvMovID, @Ok OUTPUT
END
IF @Ok IS NOT NULL SELECT @OkRef = RTRIM(@OkRef) + ' - ' + RTRIM(@InvMov) + ' ' + RTRIM(@InvMovID)
END
FETCH NEXT FROM crCancelarInv INTO @InvID, @InvMov, @InvMovID, @InvEstatus, @InvMovTipo
END  
CLOSE crCancelarInv
DEALLOCATE crCancelarInv
DECLARE crCancelarSoporte CURSOR LOCAL STATIC FOR
SELECT ID, Mov, MovID
FROM Soporte
WHERE Empresa = @Empresa AND OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
ORDER BY ID DESC
OPEN crCancelarSoporte
FETCH NEXT FROM crCancelarSoporte INTO @SoporteID, @SoporteMov, @SoporteMovID
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
EXEC spSoporte @SoporteID, 'ST', @Accion, 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, NULL,
@SoporteMov, @SoporteMovID OUTPUT, NULL, NULL,
@Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'ST', @SoporteID, @SoporteMov, @SoporteMovID, @Ok OUTPUT
IF @Ok IS NOT NULL SELECT @OkRef = RTRIM(@OkRef) + ' - ' + RTRIM(@InvMov) + ' ' + RTRIM(@InvMovID)
END
FETCH NEXT FROM crCancelarSoporte INTO @SoporteID, @SoporteMov, @SoporteMovID
END  
CLOSE crCancelarSoporte
DEALLOCATE crCancelarSoporte
END
IF @Accion <> 'CANCELAR' AND @Ok IS NULL
BEGIN
IF EXISTS(SELECT * FROM crVenta WHERE ID = @ID)
BEGIN
IF @CfgVentaMultiAlmacen = 1
DECLARE crCRVenta CURSOR LOCAL STATIC FOR
SELECT NULLIF(RTRIM(Cliente), ''), NULLIF(ClienteEnviarA, 0), CONVERT(varchar, NULL), NULLIF(RTRIM(Mov), ''), NULLIF(RTRIM(MovID), ''), Cxc, CFDSerie, CFDFolio 
FROM CRVenta
WHERE ID = @ID AND NULLIF(Importe, 0) IS NOT NULL
GROUP BY NULLIF(RTRIM(Cliente), ''), NULLIF(ClienteEnviarA, 0), NULLIF(RTRIM(Mov), ''), NULLIF(RTRIM(MovID), ''), Cxc, CFDSerie, CFDFolio 
ORDER BY NULLIF(RTRIM(Cliente), ''), NULLIF(ClienteEnviarA, 0), NULLIF(RTRIM(Mov), ''), NULLIF(RTRIM(MovID), ''), Cxc, CFDSerie, CFDFolio 
ELSE
DECLARE crCRVenta CURSOR LOCAL STATIC FOR
SELECT NULLIF(RTRIM(Cliente), ''), NULLIF(ClienteEnviarA, 0), Almacen, NULLIF(RTRIM(Mov), ''), NULLIF(RTRIM(MovID), ''), Cxc, CFDSerie, CFDFolio 
FROM CRVenta
WHERE ID = @ID AND NULLIF(Importe, 0) IS NOT NULL
GROUP BY NULLIF(RTRIM(Cliente), ''), NULLIF(ClienteEnviarA, 0), Almacen, NULLIF(RTRIM(Mov), ''), NULLIF(RTRIM(MovID), ''), Cxc, CFDSerie, CFDFolio 
ORDER BY NULLIF(RTRIM(Cliente), ''), NULLIF(ClienteEnviarA, 0), Almacen, NULLIF(RTRIM(Mov), ''), NULLIF(RTRIM(MovID), ''), Cxc, CFDSerie, CFDFolio 
OPEN crCRVenta
FETCH NEXT FROM crCRVenta INTO @Cliente, @ClienteEnviarA, @Almacen, @VentaMov, @VentaMovID, @Cxc, @CFDSerie, @CFDFolio 
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
SET @CFDReferencia = NULLIF(@CFDSerie,'') + NULLIF(@CFDFolio,'') 
IF @@FETCH_STATUS <> -2
BEGIN
IF @VentaMov IS NULL
BEGIN
SELECT @VentaIdentificada = 0
IF @Cxc = 1
SELECT @VentaMov = @MovFactura
ELSE
SELECT @VentaMov = @MovNota
END ELSE
SELECT @VentaIdentificada = 1
SELECT @Condicion = NULL
SELECT @ZonaImpuesto = ZonaImpuesto FROM Sucursal WHERE Sucursal = @Sucursal
IF @CfgZonaImpuestoNivelCte = 1
SELECT @ZonaImpuesto = ISNULL(NULLIF(RTRIM(ZonaImpuesto), ''), @ZonaImpuesto) FROM Cte WHERE Cliente = @Cliente
IF @Cliente IS NULL
SELECT @ClienteNota = @ClienteVMOS
ELSE BEGIN
SELECT @ClienteNota = @Cliente
SELECT @CRMovVenta = CRMovVenta, @Condicion = Condicion, @ZonaImpuesto = ISNULL(NULLIF(RTRIM(ZonaImpuesto), ''), @ZonaImpuesto)
FROM Cte
WHERE Cliente = @ClienteNota
IF @Cxc = 1 AND @CRMovVenta <> '(Empresa)'
BEGIN
SELECT @VentaMov = @CRMovVenta
IF NULLIF(@VentaMov,'') IS NULL SELECT @OK = 55130, @OKref = 'Ventas Credito (CR) Cliente:'+@ClienteNota
END
END
IF @Ok IS NULL
BEGIN
INSERT Venta (Sucursal,  Empresa,  Mov,       MovID,       FechaEmision,  Moneda,     TipoCambio,     Almacen,                                                Cliente,      EnviarA,         Concepto,  Condicion,  Agente,  Usuario,  Estatus,    OrigenTipo, Origen, OrigenID, UEN,  Proyecto,  CRCFDSerie, CRCFDFolio, Referencia) 
VALUES (@Sucursal, @Empresa, @VentaMov, @VentaMovID, @FechaEmision, @MovMoneda, @MovTipoCambio, ISNULL(NULLIF(RTRIM(@Almacen), ''), @AlmacenPrincipal), @ClienteNota, @ClienteEnviarA, @Concepto, @Condicion, @Agente, @Usuario, 'BORRADOR', @Modulo,    @Mov,   @MovID,   @UEN, @Proyecto, @CFDSerie,  @CFDFolio,  @CFDReferencia) 
SELECT @VentaID = SCOPE_IDENTITY()
SELECT @Renglon = 0.0, @RenglonID = 0
IF @CfgVentaMultiAlmacen = 1
BEGIN
IF @VentaIdentificada = 1
DECLARE crDetalleVenta CURSOR LOCAL STATIC FOR
SELECT crv.Almacen, crv.Articulo, crv.SubCuenta, crv.Posicion, crv.DescripcionExtra, ISNULL(a.Impuesto1, 0), ISNULL(a.Impuesto2, 0), ISNULL(a.Impuesto3, 0), a.Unidad, SUM(crv.Importe*(100.0/(100.0-ISNULL(crv.DescuentoLinea, 0.0)))), SUM(crv.Importe), ISNULL(NULLIF(SUM(crv.Cantidad), 0), 1.0)
FROM CRVenta crv, CR, Art a
WHERE cr.ID = @ID
AND cr.ID = crv.ID
AND a.Articulo = crv.Articulo
/*AND ISNULL(crv.Almacen, '') = ISNULL(@Almacen, '') */
AND ISNULL(crv.Cliente, '') = ISNULL(@Cliente, '')
AND ISNULL(crv.ClienteEnviarA, 0) = ISNULL(@ClienteEnviarA, 0)
AND ISNULL(crv.Cxc, 0) = ISNULL(@Cxc, 0)
AND ISNULL(crv.Mov, '') = ISNULL(@VentaMov, '')
AND ISNULL(crv.MovID, '') = ISNULL(@VentaMovID, '')
GROUP BY crv.Almacen, crv.Articulo, crv.SubCuenta, crv.Posicion, crv.DescuentoLinea, crv.DescripcionExtra, ISNULL(a.Impuesto1, 0), ISNULL(a.Impuesto2, 0), ISNULL(a.Impuesto3, 0), a.Unidad, crv.Precio
ORDER BY crv.Almacen, crv.Articulo, crv.SubCuenta, crv.Posicion, crv.DescuentoLinea, crv.DescripcionExtra, ISNULL(a.Impuesto1, 0), ISNULL(a.Impuesto2, 0), ISNULL(a.Impuesto3, 0), a.Unidad, crv.Precio
ELSE
DECLARE crDetalleVenta CURSOR LOCAL STATIC FOR
SELECT crv.Almacen, crv.Articulo, crv.SubCuenta, crv.Posicion, crv.DescripcionExtra, ISNULL(a.Impuesto1, 0), ISNULL(a.Impuesto2, 0), ISNULL(a.Impuesto3, 0), a.Unidad, SUM(crv.Importe*(100.0/(100.0-ISNULL(crv.DescuentoLinea, 0.0)))), SUM(crv.Importe), ISNULL(NULLIF(SUM(crv.Cantidad), 0), 1.0)
FROM CRVenta crv, CR, Art a
WHERE cr.ID = @ID
AND cr.ID = crv.ID
AND a.Articulo = crv.Articulo
/*AND ISNULL(crv.Almacen, '') = ISNULL(@Almacen, '') */
AND ISNULL(crv.Cliente, '') = ISNULL(@Cliente, '')
AND ISNULL(crv.ClienteEnviarA, 0) = ISNULL(@ClienteEnviarA, 0)
AND ISNULL(crv.Cxc, 0) = ISNULL(@Cxc, 0)
AND crv.Mov IS NULL
AND crv.MovID IS NULL
GROUP BY crv.Almacen, crv.Articulo, crv.SubCuenta, crv.Posicion, crv.DescuentoLinea, crv.DescripcionExtra, ISNULL(a.Impuesto1, 0), ISNULL(a.Impuesto2, 0), ISNULL(a.Impuesto3, 0), a.Unidad, crv.Precio
ORDER BY crv.Almacen, crv.Articulo, crv.SubCuenta, crv.Posicion, crv.DescuentoLinea, crv.DescripcionExtra, ISNULL(a.Impuesto1, 0), ISNULL(a.Impuesto2, 0), ISNULL(a.Impuesto3, 0), a.Unidad, crv.Precio
END ELSE
BEGIN
IF @VentaIdentificada = 1
DECLARE crDetalleVenta CURSOR LOCAL STATIC FOR
SELECT crv.Almacen, crv.Articulo, crv.SubCuenta, crv.Posicion, crv.DescripcionExtra, ISNULL(a.Impuesto1, 0), ISNULL(a.Impuesto2, 0), ISNULL(a.Impuesto3, 0), a.Unidad, SUM(crv.Importe*(100.0/(100.0-ISNULL(crv.DescuentoLinea, 0.0)))), SUM(crv.Importe), ISNULL(NULLIF(SUM(crv.Cantidad), 0), 1.0)
FROM CRVenta crv, CR, Art a
WHERE cr.ID = @ID
AND cr.ID = crv.ID
AND a.Articulo = crv.Articulo
AND ISNULL(crv.Almacen, '') = ISNULL(@Almacen, '')
AND ISNULL(crv.Cliente, '') = ISNULL(@Cliente, '')
AND ISNULL(crv.ClienteEnviarA, 0) = ISNULL(@ClienteEnviarA, 0)
AND ISNULL(crv.Cxc, 0) = ISNULL(@Cxc, 0)
AND ISNULL(crv.Mov, '') = ISNULL(@VentaMov, '')
AND ISNULL(crv.MovID, '') = ISNULL(@VentaMovID, '')
GROUP BY crv.Almacen, crv.Articulo, crv.SubCuenta, crv.Posicion, crv.DescuentoLinea, crv.DescripcionExtra, ISNULL(a.Impuesto1, 0), ISNULL(a.Impuesto2, 0), ISNULL(a.Impuesto3, 0), a.Unidad, crv.Precio
ORDER BY crv.Almacen, crv.Articulo, crv.SubCuenta, crv.Posicion, crv.DescuentoLinea, crv.DescripcionExtra, ISNULL(a.Impuesto1, 0), ISNULL(a.Impuesto2, 0), ISNULL(a.Impuesto3, 0), a.Unidad, crv.Precio
ELSE
DECLARE crDetalleVenta CURSOR LOCAL STATIC FOR
SELECT crv.Almacen, crv.Articulo, crv.SubCuenta, crv.Posicion, crv.DescripcionExtra, ISNULL(a.Impuesto1, 0), ISNULL(a.Impuesto2, 0), ISNULL(a.Impuesto3, 0), a.Unidad, SUM(crv.Importe*(100.0/(100.0-ISNULL(crv.DescuentoLinea, 0.0)))), SUM(crv.Importe), ISNULL(NULLIF(SUM(crv.Cantidad), 0), 1.0)
FROM CRVenta crv, CR, Art a
WHERE cr.ID = @ID
AND cr.ID = crv.ID
AND a.Articulo = crv.Articulo
AND ISNULL(crv.Almacen, '') = ISNULL(@Almacen, '')
AND ISNULL(crv.Cliente, '') = ISNULL(@Cliente, '')
AND ISNULL(crv.ClienteEnviarA, 0) = ISNULL(@ClienteEnviarA, 0)
AND ISNULL(crv.Cxc, 0) = ISNULL(@Cxc, 0)
AND crv.Mov IS NULL
AND crv.MovID IS NULL
GROUP BY crv.Almacen, crv.Articulo, crv.SubCuenta, crv.Posicion, crv.DescuentoLinea, crv.DescripcionExtra, ISNULL(a.Impuesto1, 0), ISNULL(a.Impuesto2, 0), ISNULL(a.Impuesto3, 0), a.Unidad, crv.Precio
ORDER BY crv.Almacen, crv.Articulo, crv.SubCuenta, crv.Posicion, crv.DescuentoLinea, crv.DescripcionExtra, ISNULL(a.Impuesto1, 0), ISNULL(a.Impuesto2, 0), ISNULL(a.Impuesto3, 0), a.Unidad, crv.Precio
END
OPEN crDetalleVenta
FETCH NEXT FROM crDetalleVenta INTO @AlmacenD, @Articulo, @SubCuenta, @Posicion, @DescripcionExtra, @Impuesto1, @Impuesto2, @Impuesto3, @Unidad, @PrecioTotal, @Importe, @Cantidad
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto2 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto3 OUTPUT
EXEC spTipoImpuesto @Modulo, @VentaID, @VentaMov, @FechaEmision, @Empresa, @Sucursal, @Cliente, @ClienteEnviarA, @Articulo = @Articulo, @EnSilencio = 1, @Impuesto1 = @Impuesto1 OUTPUT, @Impuesto2 = @Impuesto2 OUTPUT, @Impuesto3 = @Impuesto3 OUTPUT
SELECT @Precio = CONVERT(float, @PrecioTotal) / NULLIF(@Cantidad, 0.0)
SELECT @DescuentoLinea = NULLIF((1.0-(CONVERT(float, @Importe)/NULLIF(CONVERT(float, @PrecioTotal), 0.0)))*100.0, 0)
SELECT @JuntarImpuestos = ((100.0+ISNULL(@Impuesto2,0.0))*(1+((ISNULL(@Impuesto1,0.0)+ISNULL(@Impuesto3,0.0))/100.0))-100.0)
IF @CfgImpInc = 0
SELECT @Precio = @Precio/(1+(@JuntarImpuestos/100.0))
SELECT @Costo = NULL
EXEC spVerCosto @Sucursal, @Empresa, NULL, @Articulo, @SubCuenta, @Unidad, @TipoCosteo, @MovMoneda, @MovTipoCambio, @Costo OUTPUT, 0, @Precio = @Precio
SELECT @Renglon = @Renglon + 2048.0, @RenglonID = @RenglonID + 1
INSERT VentaD (Sucursal,  ID,       Renglon,  RenglonSub, RenglonID,  Almacen,                                                 Posicion,  Articulo,  SubCuenta,  Unidad,  Impuesto1,  Impuesto2,  Impuesto3,  Cantidad,  CantidadInventario,  Precio,  Costo,  DescuentoLinea,  DescripcionExtra,  Agente,  UEN,  PrecioMoneda, PrecioTipoCambio)
VALUES (@Sucursal, @VentaID, @Renglon, 0,          @RenglonID, ISNULL(NULLIF(RTRIM(@AlmacenD), ''), @AlmacenPrincipal), @Posicion, @Articulo, @SubCuenta, @Unidad, @Impuesto1, @Impuesto2, @Impuesto3, @Cantidad, @Cantidad,           @Precio, @Costo, @DescuentoLinea, @DescripcionExtra, @Agente, @UEN, @MovMoneda,   @MovTipoCambio)
END
FETCH NEXT FROM crDetalleVenta INTO @AlmacenD, @Articulo, @SubCuenta, @Posicion, @DescripcionExtra, @Impuesto1, @Impuesto2, @Impuesto3, @Unidad, @PrecioTotal, @Importe, @Cantidad
END 
CLOSE crDetalleVenta
DEALLOCATE crDetalleVenta
END
IF @Ok IS NULL
BEGIN
EXEC spInv @VentaID, 'VTAS', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, NULL,
@VentaMov, @VentaMovID OUTPUT, NULL, NULL,
@Ok OUTPUT, @OkRef OUTPUT, 0
IF @Ok IN (80030) SELECT @Ok = NULL, @OkRef = NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'VTAS', @VentaID, @VentaMov, @VentaMovID, @Ok OUTPUT
EXEC spCRCFDAfectar @Empresa, @Sucursal, @CFDSerie, @CFDFolio
END
END
FETCH NEXT FROM crCRVenta INTO @Cliente, @ClienteEnviarA, @Almacen, @VentaMov, @VentaMovID, @Cxc, @CFDSerie, @CFDFolio 
END 
CLOSE crCRVenta
DEALLOCATE crCRVenta
END
IF @Ok IS NULL
BEGIN
IF EXISTS(SELECT * FROM CRCobro WHERE ID = @ID AND NULLIF(Importe, 0) IS NOT NULL AND ISNULL(Cxc, 0) = 0)
BEGIN
DECLARE crCRCobro CURSOR LOCAL STATIC FOR
SELECT Moneda, TipoCambio
FROM CRCobro
WHERE ID = @ID AND NULLIF(Importe, 0) IS NOT NULL AND ISNULL(Cxc, 0) = 0
GROUP BY Moneda, TipoCambio
ORDER BY Moneda, TipoCambio
OPEN crCRCobro
FETCH NEXT FROM crCRCobro INTO @Moneda, @TipoCambio
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Ok IS NULL
BEGIN
INSERT Dinero (Sucursal,  SucursalOrigen, Empresa,   Mov,         FechaEmision,  Moneda,  TipoCambio,  Usuario,  Estatus,    CtaDinero,  Cajero,   ConDesglose,  UEN,  Proyecto,  OrigenTipo, Origen, OrigenID)
VALUES (@Sucursal, @Sucursal,      @Empresa,  @MovIngreso, @FechaEmision, @Moneda, @TipoCambio, @Usuario, 'BORRADOR', @Caja,      @Cajero,  1,            @UEN, @Proyecto, @Modulo,    @Mov,   @MovID)
SELECT @DineroID = SCOPE_IDENTITY()
TRUNCATE TABLE #DineroD
INSERT #DineroD (FormaPago, Referencia, Importe)
SELECT FormaPago, Referencia, SUM(Importe)
FROM CRCobro
WHERE ID = @ID AND Moneda = @Moneda AND TipoCambio = @TipoCambio AND ISNULL(Cxc, 0) = 0
GROUP BY FormaPago, Referencia
HAVING NULLIF(SUM(Importe), 0.0) IS NOT NULL
ORDER BY FormaPago, Referencia
EXEC xpCRAfectarCobro @ID, @Accion, @Moneda, @TipoCambio, @DineroID, @Ok OUTPUT, @OkRef OUTPUT
IF EXISTS(SELECT * FROM #DineroD)
BEGIN
SELECT @Renglon = 0.0
UPDATE #DineroD SET @Renglon = Renglon = ISNULL(Renglon, 0) + @Renglon + 2048.0
INSERT DineroD (Sucursal,  ID, Renglon, FormaPago, Referencia, Importe)
SELECT @Sucursal,  @DineroID, Renglon, FormaPago, Referencia, Importe
FROM #DineroD
END ELSE
DELETE Dinero WHERE ID = @DineroID
END
END
FETCH NEXT FROM crCRCobro INTO @Moneda, @TipoCambio
END 
CLOSE crCRCobro
DEALLOCATE crCRCobro
END
IF EXISTS(SELECT * FROM CRCobro WHERE ID = @ID AND NULLIF(Importe, 0) IS NOT NULL AND ISNULL(Cxc, 0) = 1 AND NULLIF(RTRIM(Cliente), '') IS NOT NULL)
BEGIN
DECLARE crCRCobroCxc CURSOR LOCAL STATIC FOR
SELECT Cliente, FormaPago, Referencia, Vencimiento, Moneda, TipoCambio, SUM(Importe)
FROM CRCobro
WHERE ID = @ID AND NULLIF(Importe, 0) IS NOT NULL AND ISNULL(Cxc, 0) = 1
GROUP BY Cliente, FormaPago, Referencia, Vencimiento, Moneda, TipoCambio
ORDER BY Cliente, FormaPago, Referencia, Vencimiento, Moneda, TipoCambio
OPEN crCRCobroCxc
FETCH NEXT FROM crCRCobroCxc INTO @Cliente, @FormaPago, @Referencia, @Vencimiento, @Moneda, @TipoCambio, @Importe
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @AplicaManual = 0, @Saldo = 0.0
IF EXISTS(SELECT * FROM Cxc WHERE Empresa = @Empresa AND Cliente = @Cliente AND Moneda = @Moneda AND Estatus = 'PENDIENTE' AND ISNULL(Saldo, 0.0) > 0.0 AND (RTRIM(Mov)+' '+RTRIM(MovID) = @Referencia OR Vencimiento = @Vencimiento))
SELECT @AplicaManual = 1
INSERT Cxc (Sucursal,  SucursalOrigen, Cliente,  Empresa,   Mov,       FechaEmision,  FormaCobro, Importe,   Moneda,  TipoCambio,  ClienteMoneda,  ClienteTipoCambio,  Usuario,  Estatus,    CtaDinero,  Cajero,   UEN,  Proyecto,  OrigenTipo, Origen, OrigenID, AplicaManual)
VALUES (@Sucursal, @Sucursal,      @Cliente, @Empresa,  @MovCobro, @FechaEmision, @FormaPago, @Importe, @Moneda, @TipoCambio, @Moneda,        @TipoCambio,        @Usuario, 'BORRADOR', @Caja,      @Cajero,  @UEN, @Proyecto, @Modulo,    @Mov,   @MovID,   @AplicaManual)
SELECT @CxcID = SCOPE_IDENTITY()
IF @AplicaManual = 1
BEGIN
SELECT @ImportePendiente = @Importe, @Renglon = 0.0
DECLARE crDetalleCobroCxc CURSOR LOCAL STATIC FOR
SELECT Mov, MovID, ISNULL(Saldo, 0.0)
FROM Cxc
WHERE Empresa = @Empresa AND Cliente = @Cliente AND Moneda = @Moneda AND Estatus = 'PENDIENTE' AND ISNULL(Saldo, 0.0) > 0.0 AND RTRIM(Mov)+' '+RTRIM(MovID) = @Referencia
OPEN crDetalleCobroCxc
FETCH NEXT FROM crDetalleCobroCxc INTO @Aplica, @AplicaID, @Saldo
WHILE @@FETCH_STATUS <> -1 AND ISNULL(@ImportePendiente, 0.0) > 0.0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Saldo > @ImportePendiente SELECT @AplicaImporte = @ImportePendiente ELSE SELECT @AplicaImporte = @Saldo
SELECT @Renglon = @Renglon + 2048.0, @ImportePendiente = @ImportePendiente - @AplicaImporte
INSERT CxcD (Sucursal,  ID,     Renglon,  Aplica,  AplicaID,  Importe)
VALUES (@Sucursal, @CxcID, @Renglon, @Aplica, @AplicaID, @AplicaImporte)
END
FETCH NEXT FROM crDetalleCobroCxc INTO @Aplica, @AplicaID, @Saldo
END 
CLOSE crDetalleCobroCxc
DEALLOCATE crDetalleCobroCxc
IF @ImportePendiente > 0.0
BEGIN
DECLARE crDetalleCobroCxcVence CURSOR LOCAL STATIC FOR
SELECT Mov, MovID, ISNULL(Saldo, 0.0)
FROM Cxc
WHERE Empresa = @Empresa AND Cliente = @Cliente AND Moneda = @Moneda AND Estatus = 'PENDIENTE' AND ISNULL(Saldo, 0.0) > 0.0 AND Vencimiento = @Vencimiento
OPEN crDetalleCobroCxcVence
FETCH NEXT FROM crDetalleCobroCxcVence INTO @Aplica, @AplicaID, @Saldo
WHILE @@FETCH_STATUS <> -1 AND ISNULL(@ImportePendiente, 0.0) > 0.0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF NOT EXISTS(SELECT * FROM CxcD WHERE ID = @CxcID AND Aplica = @Aplica AND AplicaID = @AplicaID)
BEGIN
IF @Saldo > @ImportePendiente SELECT @AplicaImporte = @ImportePendiente ELSE SELECT @AplicaImporte = @Saldo
SELECT @Renglon = @Renglon + 2048.0, @ImportePendiente = @ImportePendiente - @AplicaImporte
INSERT CxcD (Sucursal,  ID,     Renglon,  Aplica,  AplicaID,  Importe)
VALUES (@Sucursal, @CxcID, @Renglon, @Aplica, @AplicaID, @AplicaImporte)
END
END
FETCH NEXT FROM crDetalleCobroCxcVence INTO @Aplica, @AplicaID, @Saldo
END 
CLOSE crDetalleCobroCxcVence
DEALLOCATE crDetalleCobroCxcVence
END
END
END
FETCH NEXT FROM crCRCobroCxc INTO @Cliente, @FormaPago, @Referencia, @Vencimiento, @Moneda, @TipoCambio, @Importe
END 
CLOSE crCRCobroCxc
DEALLOCATE crCRCobroCxc
END
DECLARE crCRCaja CURSOR LOCAL STATIC FOR
SELECT d.Movimiento, CASE WHEN @MovTipo = 'CR.C' THEN @FechaEmision ELSE d.FechaEmision END, d.Concepto, d.CtaDinero, d.Moneda, d.TipoCambio, d.FormaPago, d.Referencia, ISNULL(d.Importe, 0.0)
FROM CRCaja d
WHERE d.ID = @ID 
AND NULLIF(d.Importe, 0.0) IS NOT NULL
AND UPPER(d.Movimiento) NOT IN ('GASTO', 'DEVOLUCION GASTO', 'VENTA ANTICIPO')
OPEN crCRCaja
FETCH NEXT FROM crCRCaja INTO @Movimiento, @FechaBanco, @ConceptoBanco, @CtaDinero, @Moneda, @TipoCambio, @FormaPago, @Referencia, @Importe
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND (UPPER(@Movimiento) <> 'PRESTAMO' OR @CfgPrestamoCxc = 0)
BEGIN
SELECT @DineroMov = NULL, @CtaOrigen = NULL, @CtaDestino = NULL
IF UPPER(@Movimiento) = 'FONDO INICIAL' 	 SELECT @DineroMov = @MovFondoInicial, @CtaOrigen = @CtaDinero, @CtaDestino = @Caja      ELSE
IF UPPER(@Movimiento) = 'RECOLECCION'   	 SELECT @DineroMov = @MovRecoleccion,  @CtaOrigen = @Caja,      @CtaDestino = @CtaDinero ELSE
IF UPPER(@Movimiento) = 'FALTANTE'      	 SELECT @DineroMov = @MovFaltante,     @CtaOrigen = @Caja				 ELSE
IF UPPER(@Movimiento) = 'SOBRANTE'      	 SELECT @DineroMov = @MovSobrante,     @CtaOrigen = @Caja				 ELSE
IF UPPER(@Movimiento) = 'REDONDEO'      	 SELECT @DineroMov = @MovRedondeo,     @CtaOrigen = @Caja				 ELSE
IF UPPER(@Movimiento) = 'DEPOSITO'      	 SELECT @DineroMov = @MovDeposito,     @CtaOrigen = @CtaDinero 			         ELSE
IF UPPER(@Movimiento) = 'SOLICITUD DEPOSITO' SELECT @DineroMov = @MovSolicitudDeposito, @CtaOrigen = @CtaDinero 		  	 ELSE
IF UPPER(@Movimiento) = 'INGRESO ANTICIPO'   SELECT @DineroMov = @MovIngreso,      @CtaOrigen = @CtaDinero 			         ELSE
IF UPPER(@Movimiento) = 'EGRESO ANTICIPO'    SELECT @DineroMov = @MovEgreso,       @CtaOrigen = @CtaDinero 			         ELSE
IF UPPER(@Movimiento) IN ('VENTA CREDITO', 'ANTICIPO GASTO', 'PRESTAMO') SELECT @DineroMov = @MovTransferencia, @CtaOrigen = @Caja, @CtaDestino = @CtaDinero ELSE
IF UPPER(@Movimiento) IN ('COBRO CREDITO', 'DEV. ANTICIPO GASTO', 'DEVOLUCION PRESTAMO', 'APLICACION CREDITO') SELECT @DineroMov = @MovTransferencia, @CtaOrigen = @CtaDinero, @CtaDestino = @Caja
/*          ELSE IF UPPER(@Movimiento) = 'APERTURA'      SELECT @DineroMov = @MovCheque,       @CtaDestino= @CtaDinero*/
ELSE SELECT @Ok = 35005, @OkRef = @Movimiento
IF @Ok IS NULL
BEGIN
INSERT Dinero (Sucursal,  SucursalOrigen, Empresa,   Mov,        FechaEmision,                       Concepto,       Moneda,  TipoCambio,  Usuario,  Estatus,    CtaDinero,   CtaDineroDestino,  Cajero,   ConDesglose,  UEN,  Proyecto,  OrigenTipo, Origen, OrigenID, Referencia,  FormaPago,  Importe)
VALUES (@Sucursal, @Sucursal,      @Empresa,  @DineroMov, ISNULL(@FechaBanco, @FechaEmision), @ConceptoBanco, @Moneda, @TipoCambio, @Usuario, 'BORRADOR', @CtaOrigen,  @CtaDestino,       @Cajero,  1,            @UEN, @Proyecto, @Modulo,    @Mov,   @MovID,   @Referencia, @FormaPago, @Importe)
SELECT @DineroID = SCOPE_IDENTITY()
INSERT DineroD (Sucursal,  ID,        Renglon, FormaPago,  Referencia,  Importe)
VALUES(@Sucursal, @DineroID, 2048.0,  @FormaPago, @Referencia, @Importe)
END
END
FETCH NEXT FROM crCRCaja INTO @Movimiento, @FechaBanco, @ConceptoBanco, @CtaDinero, @Moneda, @TipoCambio, @FormaPago, @Referencia, @Importe
END 
CLOSE crCRCaja
DEALLOCATE crCRCaja
IF @CfgPrestamoCxc = 1
BEGIN
DECLARE crCRPrestamoCxc CURSOR LOCAL STATIC FOR
SELECT Concepto, FormaPago, Referencia, Moneda, TipoCambio, Importe
FROM CRCaja
WHERE ID = @ID AND NULLIF(Importe, 0) IS NOT NULL AND UPPER(Movimiento) = 'PRESTAMO'
OPEN crCRPrestamoCxc
FETCH NEXT FROM crCRPrestamoCxc INTO @Concepto, @FormaPago, @Referencia, @Moneda, @TipoCambio, @Importe
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
INSERT Cxc (Sucursal,  SucursalOrigen, Cliente,          Empresa,   Mov,             FechaEmision,  Referencia,  Concepto,  FormaCobro, Importe,   Moneda,  TipoCambio, ClienteMoneda,  ClienteTipoCambio,  Usuario,  Estatus,    CtaDinero,  Cajero,   UEN,  Proyecto,  OrigenTipo, Origen, OrigenID)
VALUES (@Sucursal, @Sucursal,      @SucursalCliente, @Empresa,  @MovPrestamoCxc, @FechaEmision, @Referencia, @Concepto, @FormaPago, @Importe, @Moneda, @TipoCambio, @Moneda,        @TipoCambio,        @Usuario, 'BORRADOR', @Caja,      @Cajero,  @UEN, @Proyecto, @Modulo,    @Mov,   @MovID)
END
FETCH NEXT FROM crCRPrestamoCxc INTO @Concepto, @FormaPago, @Referencia, @Moneda, @TipoCambio, @Importe
END 
CLOSE crCRPrestamoCxc
DEALLOCATE crCRPrestamoCxc
END
DECLARE crCREgreso CURSOR LOCAL STATIC FOR
SELECT d.Movimiento, d.CtaDinero, d.Moneda, d.TipoCambio
FROM CRCaja d
WHERE d.ID = @ID 
AND UPPER(d.Movimiento) IN ('DEPOSITO', 'SOLICITUD DEPOSITO'/*, 'APERTURA'*/)
GROUP BY /*o.Orden, */d.Movimiento, d.CtaDinero, d.Moneda, d.TipoCambio
ORDER BY /*o.Orden, */d.Movimiento, d.CtaDinero, d.Moneda, d.TipoCambio
OPEN crCREgreso
FETCH NEXT FROM crCREgreso INTO @Movimiento, @CtaDinero, @Moneda, @TipoCambio
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @DineroMov = NULL, @CtaOrigen = @Caja, @CtaDestino = NULL
/*IF UPPER(@Movimiento) = 'APERTURA'
SELECT @DineroMov = @MovIngreso
ELSE*/
SELECT @DineroMov = @MovEgreso
IF @Ok IS NULL
BEGIN
INSERT Dinero (Sucursal,  SucursalOrigen, Empresa,   Mov,        FechaEmision,  Moneda,  TipoCambio,  Usuario,  Estatus,    CtaDinero,   CtaDineroDestino,  Cajero,   ConDesglose,  UEN,  Proyecto,  OrigenTipo, Origen, OrigenID)
VALUES (@Sucursal, @Sucursal,      @Empresa,  @DineroMov, @FechaEmision, @Moneda, @TipoCambio, @Usuario, 'BORRADOR', @CtaOrigen,  @CtaDestino,       @Cajero,  1,            @UEN, @Proyecto, @Modulo,    @Mov,   @MovID)
SELECT @DineroID = SCOPE_IDENTITY()
TRUNCATE TABLE #DineroD
INSERT #DineroD (FormaPago, Referencia, Importe)
SELECT FormaPago, Referencia, SUM(Importe)
FROM CRCaja
WHERE ID = @ID AND Movimiento = @Movimiento AND CtaDinero = @CtaDinero AND Moneda = @Moneda AND TipoCambio = @TipoCambio
GROUP BY FormaPago, Referencia
HAVING NULLIF(SUM(Importe), 0.0) IS NOT NULL
ORDER BY FormaPago, Referencia
SELECT @Renglon = 0.0
UPDATE #DineroD SET @Renglon = Renglon = ISNULL(Renglon, 0) + @Renglon + 2048.0
INSERT DineroD (Sucursal,  ID,        Renglon, FormaPago, Referencia, Importe)
SELECT @Sucursal,  @DineroID, Renglon, FormaPago, Referencia, Importe
FROM #DineroD
END
END
FETCH NEXT FROM crCREgreso INTO @Movimiento, @CtaDinero, @Moneda, @TipoCambio
END 
CLOSE crCREgreso
DEALLOCATE crCREgreso
DECLARE crCRDinero CURSOR LOCAL /*STATIC*/ FOR
SELECT d.ID, d.Mov, "Importe" = (SELECT SUM(Importe) FROM DineroD WHERE ID = d.ID)
FROM Dinero d
WHERE d.Empresa = @Empresa AND d.Estatus = 'BORRADOR' AND d.OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID
OPEN crCRDinero
FETCH NEXT FROM crCRDinero INTO @DineroID, @DineroMov, @Importe
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
UPDATE Dinero SET Importe = @Importe WHERE CURRENT OF crCRDinero
EXEC spDinero @DineroID, 'DIN', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0,
@DineroMov OUTPUT, @DineroMovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IN (21010, 21020, 80030) SELECT @Ok = NULL, @OkRef = NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'DIN', @DineroID, @DineroMov, @DineroMovID, @Ok OUTPUT
END
FETCH NEXT FROM crCRDinero INTO @DineroID, @DineroMov, @Importe
END 
CLOSE crCRDinero
DEALLOCATE crCRDinero
DECLARE crCRCxc CURSOR LOCAL STATIC FOR
SELECT ID, Mov
FROM Cxc
WHERE Empresa = @Empresa AND Estatus = 'BORRADOR' AND OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID
OPEN crCRCxc
FETCH NEXT FROM crCRCxc INTO @CxcID, @CxcMov
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spCx @CxcID, 'CXC', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0,
@CxcMov OUTPUT, @CxcMovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IN (80030) SELECT @Ok = NULL, @OkRef = NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'CXC', @CxcID, @CxcMov, @CxcMovID, @Ok OUTPUT
END
FETCH NEXT FROM crCRCxc INTO @CxcID, @CxcMov
END 
CLOSE crCRCxc
DEALLOCATE crCRCxc
END
END
IF EXISTS(SELECT * FROM CRCaja WHERE ID = @ID AND UPPER(Movimiento) = 'GASTO')
BEGIN
EXEC spGenerarGasto @Accion, @Empresa, @Sucursal, @Usuario, @Modulo, @ID, @Mov, @MovID, @FechaEmision, @FechaRegistro, @Ok OUTPUT, @OkRef OUTPUT, @CRMovimiento = 'Gasto'
IF @Ok BETWEEN 80030 AND 81000 SELECT @Ok = NULL, @OkRef = NULL
END
IF EXISTS(SELECT * FROM CRCaja WHERE ID = @ID AND UPPER(Movimiento) = 'DEVOLUCION GASTO')
BEGIN
EXEC spGenerarGasto @Accion, @Empresa, @Sucursal, @Usuario, @Modulo, @ID, @Mov, @MovID, @FechaEmision, @FechaRegistro, @Ok OUTPUT, @OkRef OUTPUT, @CRMovimiento = 'Devolucion Gasto'
IF @Ok BETWEEN 80030 AND 81000 SELECT @Ok = NULL, @OkRef = NULL
END
IF @Accion <> 'CANCELAR' AND @Ok IS NULL
BEGIN
IF EXISTS(SELECT * FROM CRInvFisico WHERE ID = @ID)
BEGIN
SELECT @InvMov = @MovInvFisico
INSERT Inv (Sucursal,  SucursalOrigen, Empresa,   Mov,     FechaEmision,  Moneda,     TipoCambio,     Usuario,  Estatus,     Almacen,           UEN,  Proyecto,  OrigenTipo, Origen, OrigenID)
VALUES (@Sucursal, @Sucursal,      @Empresa,  @InvMov, @FechaEmision, @MovMoneda, @MovTipoCambio, @Usuario, 'CONFIRMAR', @AlmacenPrincipal, @UEN, @Proyecto, @Modulo,    @Mov,   @MovID)
SELECT @InvID = SCOPE_IDENTITY()
INSERT InvD
(ID,    Renglon,   Articulo,   SubCuenta,   Cantidad,   Unidad,   Almacen,           Posicion)
SELECT @InvID, m.Renglon, m.Articulo, m.SubCuenta, m.Cantidad, a.Unidad, @AlmacenPrincipal, m.Posicion
FROM CRInvFisico m, Art a
WHERE m.ID = @ID AND m.Articulo = a.Articulo
/*        EXEC spInv @InvID, 'INV', 'AFECTAR', 'TODO', @FechaRegistro, @MovAjuste, @Usuario, 1, 0, NULL,
@InvMov, @InvMovID OUTPUT, @AjusteID OUTPUT, NULL,
@Ok OUTPUT, @OkRef OUTPUT, 0
IF @Ok IN (80030, 80070) SELECT @Ok = NULL, @OkRef = NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'INV', @InvID, @InvMov, @InvMovID, @Ok OUTPUT
IF @AjusteID IS NOT NULL
UPDATE Inv SET Estatus = 'CONFIRMAR' WHERE ID = @AjusteID*/
END
IF EXISTS(SELECT * FROM CRTrans WHERE ID = @ID)
BEGIN
DECLARE crCRTrans CURSOR LOCAL STATIC FOR
SELECT NULLIF(RTRIM(AlmacenOrigen), ''), NULLIF(RTRIM(AlmacenDestino), '')
FROM CRTrans
WHERE ID = @ID
GROUP BY AlmacenOrigen, AlmacenDestino
ORDER BY AlmacenOrigen, AlmacenDestino
OPEN crCRTrans
FETCH NEXT FROM crCRTrans INTO @AlmacenOrigen, @AlmacenDestino
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @InvMov = @MovInvTransferencia
INSERT Inv (Sucursal,  SucursalOrigen, Empresa,   Mov,     FechaEmision,  Moneda,     TipoCambio,     Usuario,  Estatus,      Almacen,                                   AlmacenDestino,                             UEN,  Proyecto,  OrigenTipo, Origen, OrigenID)
VALUES (@Sucursal, @Sucursal,      @Empresa,  @InvMov, @FechaEmision, @MovMoneda, @MovTipoCambio, @Usuario, 'SINAFECTAR', ISNULL(@AlmacenOrigen, @AlmacenPrincipal), ISNULL(@AlmacenDestino, @AlmacenPrincipal), @UEN, @Proyecto, @Modulo,    @Mov,   @MovID)
SELECT @InvID = SCOPE_IDENTITY()
INSERT InvD
(ID,    Renglon,   Articulo,   SubCuenta,   Cantidad,   Unidad,   Almacen,                                   Posicion)
SELECT @InvID, m.Renglon, m.Articulo, m.SubCuenta, m.Cantidad, a.Unidad, ISNULL(@AlmacenOrigen, @AlmacenPrincipal), m.Posicion
FROM CRTrans m, Art a
WHERE m.ID = @ID AND m.Articulo = a.Articulo
EXEC spInv @InvID, 'INV', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, NULL,
@InvMov, @InvMovID OUTPUT, NULL, NULL,
@Ok OUTPUT, @OkRef OUTPUT, 0
IF @Ok IN (80030) SELECT @Ok = NULL, @OkRef = NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'INV', @InvID, @InvMov, @InvMovID, @Ok OUTPUT
END
FETCH NEXT FROM crCRTrans INTO @AlmacenOrigen, @AlmacenDestino
END  
CLOSE crCRTrans
DEALLOCATE crCRTrans
END
IF EXISTS(SELECT * FROM CRSoporte WHERE ID = @ID)
BEGIN
DECLARE crCRSoporte CURSOR LOCAL STATIC FOR
SELECT Renglon, Mov
FROM CRSoporte
WHERE ID = @ID
OPEN crCRSoporte
FETCH NEXT FROM crCRSoporte INTO @Renglon, @SoporteMov
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @SoporteMovID = NULL
INSERT Soporte
(Sucursal, SucursalOrigen, Empresa,   Mov, Cliente, Titulo, Problema, Contacto, Telefono, FechaEmision,  Usuario,  Estatus,      UEN,  Proyecto,  OrigenTipo, Origen, OrigenID)
SELECT @Sucursal, @Sucursal,      @Empresa,  Mov, Cliente, Titulo, Problema, Contacto, Telefono, @FechaEmision, @Usuario, 'SINAFECTAR', @UEN, @Proyecto, @Modulo,    @Mov,   @MovID
FROM CRSoporte
WHERE ID = @ID
SELECT @SoporteID = SCOPE_IDENTITY()
EXEC spSoporte @SoporteID, 'ST', @Accion, 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, NULL,
@SoporteMov, @SoporteMovID OUTPUT, NULL, NULL,
@Ok OUTPUT, @OkRef OUTPUT
IF @Ok IN (80030) SELECT @Ok = NULL, @OkRef = NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'ST', @SoporteID, @SoporteMov, @SoporteMovID, @Ok OUTPUT
END
FETCH NEXT FROM crCRSoporte INTO @Renglon, @SoporteMov
END  
CLOSE crCRSoporte
DEALLOCATE crCRSoporte
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
UPDATE CR
SET FechaConclusion  = @FechaConclusion,
FechaCancelacion = @FechaCancelacion,
UltimoCambio     = /*CASE WHEN UltimoCambio IS NULL THEN */@FechaRegistro /*ELSE UltimoCambio END*/,
Estatus          = @EstatusNuevo,
Situacion 	      = CASE WHEN @Estatus <> @EstatusNuevo THEN NULL ELSE Situacion END,
GenerarPoliza    = @GenerarPoliza
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
END
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC xpCRAfectar @ID, @Accion, @Empresa, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaEmision, @FechaAfectacion, @FechaConclusion,
@UEN, @Proyecto, @Usuario, @Autorizacion, @DocFuente, @Observaciones,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo,
@Caja, @Cajero, @Concepto, @Referencia,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen,
@CfgContX, @CfgContXGenerar, @GenerarPoliza,
@GenerarMov, @IDGenerar, @GenerarMovID,
@Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spMovFinal @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion = 'CANCELAR' AND @EstatusNuevo = 'CANCELADO' AND @Ok IS NULL
EXEC spCancelarFlujo @Empresa, @Modulo, @ID, @Ok OUTPUT
IF @Conexion = 0
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
RETURN
END

