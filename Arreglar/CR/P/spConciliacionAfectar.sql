SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spConciliacionAfectar
@ID                		int,
@Accion			char(20),
@Empresa	      		char(5),
@Modulo	      		char(5),
@Mov	  	      		char(20),
@MovID             		varchar(20)	OUTPUT,
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
@Concepto     		varchar(50),
@Referencia			varchar(50),
@Estatus           		char(15),
@EstatusNuevo	      	char(15),
@FechaRegistro     		datetime,
@Ejercicio	      		int,
@Periodo	      		int,
@MovUsuario			char(10),
@CtaDinero			varchar(10),
@Institucion			varchar(20),
@Cuenta			varchar(20),
@FechaD			datetime,
@FechaA			datetime,
/*@SaldoAnterior		money,
@Cargos			money,
@Abonos			money,
@SaldoFinal			money,*/
@Conexion			bit,
@SincroFinal			bit,
@Sucursal			int,
@SucursalDestino		int,
@SucursalOrigen		int,
@CfgTolerancia		int,
@CfgRepetirFecha		bit,
@CfgTraslaparFecha		bit,
@CfgContX			bit,
@CfgContXGenerar		char(20),
@GenerarPoliza		bit,
@Generar			bit,
@GenerarMov			char(20),
@GenerarAfectado		bit,
@IDGenerar			int	     	OUTPUT,
@GenerarMovID	  	varchar(20)	OUTPUT,
@Ok                		int          OUTPUT,
@OkRef             		varchar(255) OUTPUT

AS BEGIN
DECLARE
@RID			int,
@Especial			varchar(50),
@SubEspecial		varchar(50),
@Fecha			datetime,
@TieneSubConceptos		bit,
@NominaSubConcepto		varchar(10),
@FechaCancelacion		datetime,
@GenerarMovTipo		char(20),
@GenerarPeriodo		int,
@GenerarEjercicio		int,
@Cargo			money,
@Abono			money,
@DineroCargo		money,
@DineroAbono		money,
@Importe			money,
@Manual			int,
@TipoMovimiento		varchar(20),
@Auxiliar			int,
@ContD			int,
@ConceptoGasto		varchar(50),
@Acreedor			varchar(10),
@Saldo			money,
@CargoBancarioMov		varchar(20),
@CargoBancarioIVAMov	varchar(20),
@AbonoBancarioMov		varchar(20),
@AbonoBancarioIVAMov	varchar(20),
@GastoID			int,
@GastoMov			varchar(20),
@GastoMovID			varchar(20),
@GastoImporte		money,
@GastoImpuestos		money,
@Clase			varchar(50),
@SubClase 			varchar(50),
@PorcentajeDeducible	float,
@DefFormaPago		varchar(50),
@DineroID			int,
@PPTO			bit,
@SaldoLibros		money,
@SaldoConciliado		money,
@CxModulo			varchar(5),
@CxID			int,
@MovCobro			varchar(20),
@MovPago			varchar(20),
@IVAFiscal			float,
@GenerarCxID		int,
@GenerarCxMov		varchar(20),
@GenerarCxMovID		varchar(20),
@GenerarCxImporteTotal	float,
@GenerarCxImpuestos		float,
@FormaPagoEfectivo		varchar(50),
@PermiteAbonoNoIdentificado	bit,
@CfgIVAIntegrado		bit,
@PermiteCargoNoIdentificado bit
SELECT @PPTO = PPTO FROM EmpresaGral WHERE Empresa = @Empresa
SELECT @FormaPagoEfectivo = FormaPagoEfectivo
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @MovCobro = CxcCobro,
@MovPago = CxpPago
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
SELECT @CfgIVAIntegrado = ISNULL(ConcliarIVAIntegrado, 0)
FROM InstitucionFin
WHERE Institucion = @Institucion
CREATE TABLE #MovImpuesto (
Impuesto1		float		NULL,
Impuesto2		float		NULL,
Impuesto3		float		NULL,
Importe1		money		NULL,
Importe2		money		NULL,
Importe3		money		NULL,
SubTotal		money		NULL,
TipoImpuesto1	varchar(10)	COLLATE Database_Default NULL,
TipoImpuesto2	varchar(10)	COLLATE Database_Default NULL,
TipoImpuesto3	varchar(10)	COLLATE Database_Default NULL,
TipoRetencion1	varchar(10)	COLLATE Database_Default NULL,
TipoRetencion2	varchar(10)	COLLATE Database_Default NULL,
TipoRetencion3	varchar(10)	COLLATE Database_Default NULL,
LoteFijo		varchar(20)	COLLATE Database_Default NULL,
OrigenModulo	varchar(5)	COLLATE Database_Default NULL,
OrigenModuloID	int		NULL,
OrigenConcepto	varchar(50)	COLLATE Database_Default NULL,
OrigenDeducible	float		NULL	DEFAULT 100,
OrigenFecha	datetime	NULL,
Retencion1	float		NULL,
Retencion2	float		NULL,
Retencion3	float		NULL,
Excento1		bit		NULL	DEFAULT 0,
Excento2		bit		NULL	DEFAULT 0,
Excento3		bit		NULL	DEFAULT 0,
ContUso		varchar(20)	COLLATE Database_Default NULL,
ContUso2		varchar(20)	COLLATE Database_Default NULL,
ContUso3		varchar(20)	COLLATE Database_Default NULL,
ClavePresupuestal	varchar(30)	COLLATE Database_Default NULL,
DescuentoGlobal			float		NULL,
AplicaModulo              varchar(20) NULL,
AplicaID                  int NULL,
)
IF @PPTO = 1
CREATE TABLE #MovPresupuesto (
Importe			money		NULL,
CuentaPresupuesto	varchar(20)	COLLATE Database_Default NULL)
SELECT @DefFormaPago = FormaPagoEfectivo
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @CargoBancarioMov    = GastoCargoBancario,
@CargoBancarioIVAMov = GastoCargoBancarioIVA,
@AbonoBancarioMov    = GastoAbonoBancario,
@AbonoBancarioIVAMov = GastoAbonoBancarioIVA
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
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
EXEC spMovGenerar @Sucursal, @Empresa, @Modulo, @Ejercicio, @Periodo, @Usuario, @FechaRegistro, 'SINAFECTAR',
NULL, NULL,
@Mov, @MovID, 0,
@GenerarMov, NULL, @GenerarMovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spMovTipo @Modulo, @GenerarMov, @FechaAfectacion, @Empresa, NULL, NULL, @GenerarMovTipo OUTPUT, @GenerarPeriodo OUTPUT, @GenerarEjercicio OUTPUT, @Ok OUTPUT
IF @Ok IS NULL SELECT @Ok = 80030
RETURN
END
IF @Conexion = 0
BEGIN TRANSACTION
EXEC spMovEstatus @Modulo, 'AFECTANDO', @ID, @Generar, @IDGenerar, @GenerarAfectado, @Ok OUTPUT
IF @Accion <> 'CANCELAR'
EXEC spRegistrarMovimiento @Sucursal, @Empresa, @Modulo, @Mov, @MovID, @ID, @Ejercicio, @Periodo, @FechaRegistro, @FechaEmision,
NULL, @Proyecto, @MovMoneda, @MovTipoCambio,
@Usuario, @Autorizacion, NULL, @DocFuente, @Observaciones,
@Generar, @GenerarMov, @GenerarMovID, @IDGenerar,
@Ok OUTPUT
IF @Accion IN ('AFECTAR', 'CANCELAR')
BEGIN
DECLARE crConciliacionD CURSOR LOCAL READ_ONLY FAST_FORWARD FOR
SELECT RID, Fecha, Concepto, NULLIF(RTRIM(Referencia), ''), NULLIF(RTRIM(Observaciones), ''), ISNULL(Cargo, 0.0), ISNULL(Abono, 0.0), NULLIF(Manual, 0), NULLIF(RTRIM(TipoMovimiento), ''), Auxiliar, ContD, NULLIF(RTRIM(ConceptoGasto), ''), NULLIF(RTRIM(Acreedor), '')
FROM ConciliacionD
WHERE ID = @ID AND Seccion IN (0, 1)
OPEN crConciliacionD
FETCH NEXT FROM crConciliacionD INTO @RID, @Fecha, @Concepto, @Referencia, @Observaciones, @Cargo, @Abono, @Manual, @TipoMovimiento, @Auxiliar, @ContD, @ConceptoGasto, @Acreedor
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0 AND @Ok IS NULL
BEGIN
SELECT @Importe = @Cargo - @Abono
IF @@FETCH_STATUS <> -2 AND @Importe <> 0.0
BEGIN
IF @Auxiliar IS NULL AND @Accion = 'AFECTAR'
BEGIN
EXEC spInstitucionFinConcepto @Institucion, @Concepto, @PermiteAbonoNoIdentificado = @PermiteAbonoNoIdentificado OUTPUT, @PermiteCargoNoIdentificado = @PermiteCargoNoIdentificado OUTPUT
IF @PermiteAbonoNoIdentificado = 1 AND @PermiteCargoNoIdentificado = 1
SELECT @Ok = 51135
ELSE
BEGIN
IF @TipoMovimiento = 'Tesoreria' AND @Abono > 0.0 AND @PermiteAbonoNoIdentificado = 1
BEGIN
EXEC spConciliacionDepositoAnticipado @Empresa, @Sucursal, @ID, @Mov, @MovID, @MovTipo, @CtaDinero, @Institucion, @Cuenta, @Fecha, @Concepto, @Referencia, @Observaciones, @Abono, @Auxiliar OUTPUT, @ContD OUTPUT, @CfgTolerancia, @Usuario, @Ok OUTPUT, @OkRef OUTPUT
UPDATE ConciliacionD SET Auxiliar = @Auxiliar, ContD = @ContD WHERE ID = @ID AND RID = @RID
END
/*DSG Crear Un Cargo No Identificado*/
IF @TipoMovimiento = 'Tesoreria' AND @Cargo > 0.0 AND @PermiteCargoNoIdentificado = 1
BEGIN
EXEC spConciliacionCargoNoIdentificado @Empresa, @Sucursal, @ID, @Mov, @MovID, @MovTipo, @CtaDinero, @Institucion, @Cuenta, @Fecha, @Concepto, @Referencia, @Observaciones, @Cargo, @Auxiliar OUTPUT, @ContD OUTPUT, @CfgTolerancia, @Usuario, @Ok OUTPUT, @OkRef OUTPUT
UPDATE ConciliacionD SET Auxiliar = @Auxiliar, ContD = @ContD WHERE ID = @ID AND RID = @RID
END
END
IF @TipoMovimiento = 'Gasto' OR (@TipoMovimiento = 'Gasto IVA' AND @CfgIVAIntegrado = 0)
BEGIN
SELECT @PorcentajeDeducible = 100.0, @GastoImporte = 0.0, @GastoImpuestos = 0.0
SELECT @Clase = Clase, @SubClase = SubClase, @PorcentajeDeducible = PorcentajeDeducible FROM Concepto WHERE Modulo = 'GAS' AND Concepto = @ConceptoGasto
IF @TipoMovimiento = 'Gasto IVA' AND @CfgIVAIntegrado = 0
BEGIN
IF @Importe > 0.0
SELECT @GastoMov = @CargoBancarioIVAMov, @GastoImporte = @Importe
ELSE
SELECT @GastoMov = @AbonoBancarioIVAMov, @GastoImporte = -@Importe
END ELSE
BEGIN
IF @Importe > 0.0
SELECT @GastoMov = @CargoBancarioMov, @GastoImporte = @Importe
ELSE
SELECT @GastoMov = @AbonoBancarioMov, @GastoImporte = -@Importe
IF @CfgIVAIntegrado = 1
SELECT @GastoImpuestos = ISNULL(CASE WHEN @Cargo > 0.0 THEN Cargo ELSE Abono END, 0.0)
FROM ConciliacionD
WHERE ID = @ID AND RID = @RID + 1 AND TipoMovimiento = 'Gasto IVA'
END
INSERT Gasto (Sucursal,  Empresa,  Mov,       FechaEmision,  Moneda,     TipoCambio,     Usuario,  FormaPago,     Estatus,      UltimoCambio, Acreedor,  CtaDinero,  Clase,  SubClase,  OrigenTipo, Origen, OrigenID, Prioridad)
VALUES (@Sucursal, @Empresa, @GastoMov, @Fecha,        @MovMoneda, @MovTipoCambio, @Usuario, @DefFormaPago, 'SINAFECTAR', GETDATE(),    @Acreedor, @CtaDinero, @Clase, @SubClase, @Modulo,    @Mov,   @MovID,   'Normal')
SELECT @GastoID = SCOPE_IDENTITY()
INSERT GastoD (ID,       Renglon,  Concepto,       Fecha,  Referencia,  Cantidad,  Precio,        Importe,       Impuestos,       Sucursal,  PorcentajeDeducible)
VALUES (@GastoID, 2048.0,   @ConceptoGasto, @Fecha, @Referencia, 1,         @GastoImporte, @GastoImporte, @GastoImpuestos, @Sucursal, @PorcentajeDeducible)
EXEC spGasto @GastoID, 'GAS', @Accion, 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, @GastoMov, @GastoMovID OUTPUT, NULL, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'GAS', @GastoID, @GastoMov, @GastoMovID, @Ok OUTPUT
IF @Ok IS NULL
BEGIN
IF @GastoImpuestos <> 0.0
BEGIN
SELECT @DineroID = NULL
SELECT @DineroID = MIN(ID) FROM Dinero WHERE Empresa = @Empresa AND OrigenTipo = 'GAS' AND Origen = @GastoMov AND OrigenID = @GastoMovID AND Estatus IN ('CONCLUIDO', 'CONCILIADO') AND ROUND(Importe, 2) = ROUND(@GastoImpuestos, 2) AND FechaEmision = @Fecha
IF @Importe > 0.0
SELECT @DineroCargo = @GastoImpuestos, @DineroAbono = NULL
ELSE
SELECT @DineroCargo = NULL, @DineroAbono = @GastoImpuestos
EXEC spConciliacionBuscarAux @Empresa, @MovTipo, @DineroID, @CtaDinero, @Cuenta, @DineroAbono, @DineroCargo, @Auxiliar OUTPUT, @ContD OUTPUT, @CfgTolerancia, @Ok OUTPUT, @OkRef OUTPUT
UPDATE ConciliacionD SET Auxiliar = @Auxiliar, ContD = @ContD WHERE ID = @ID AND RID = @RID + 1
END
SELECT @DineroID = NULL
SELECT @DineroID = MIN(ID) FROM Dinero WHERE Empresa = @Empresa AND OrigenTipo = 'GAS' AND Origen = @GastoMov AND OrigenID = @GastoMovID AND Estatus IN ('CONCLUIDO', 'CONCILIADO') AND ROUND(Importe, 2) = ROUND(@GastoImporte, 2) AND FechaEmision = @Fecha
IF @Importe > 0.0
SELECT @DineroCargo = @GastoImporte, @DineroAbono = NULL
ELSE
SELECT @DineroCargo = NULL, @DineroAbono = @GastoImporte
EXEC spConciliacionBuscarAux @Empresa, @MovTipo, @DineroID, @CtaDinero, @Cuenta, @DineroAbono, @DineroCargo, @Auxiliar OUTPUT, @ContD OUTPUT, @CfgTolerancia, @Ok OUTPUT, @OkRef OUTPUT
UPDATE ConciliacionD SET Auxiliar = @Auxiliar, ContD = @ContD WHERE ID = @ID AND RID = @RID
END
END ELSE
IF @TipoMovimiento IN ('Cuenta por Cobrar', 'Cuenta por Pagar')
BEGIN
SELECT @CxModulo = NULL
EXEC spConciliacionBuscarReferencia @Empresa, @Fecha, @Referencia, @TipoMovimiento, @CxModulo OUTPUT, @CxID OUTPUT, @IVAFiscal OUTPUT
IF @CxID IS NOT NULL
BEGIN
IF @CxModulo = 'CXC'
SELECT @GenerarCxMov = @MovCobro, @GenerarCxImporteTotal =  @Abono
ELSE
SELECT @GenerarCxMov = @MovPago, @GenerarCxImporteTotal =  @Cargo
EXEC @GenerarCxID = spAfectar @CxModulo, @CxID, 'GENERAR', 'Todo', @GenerarCxMov, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @GenerarCxImpuestos = @GenerarCxImporteTotal * @IVAFiscal
IF @CxModulo = 'CXC'
BEGIN
UPDATE Cxc SET CtaDinero = @CtaDinero, FormaCobro = @FormaPagoEfectivo, Importe = @GenerarCxImporteTotal - ISNULL(@GenerarCxImpuestos, 0.0), Impuestos = @GenerarCxImpuestos WHERE ID = @GenerarCxID
UPDATE CxcD SET Importe = @GenerarCxImporteTotal WHERE ID = @GenerarCxID
END ELSE
BEGIN
UPDATE Cxp SET CtaDinero = @CtaDinero, FormaPago  = @FormaPagoEfectivo, Importe = @GenerarCxImporteTotal - ISNULL(@GenerarCxImpuestos, 0.0), Impuestos = @GenerarCxImpuestos WHERE ID = @GenerarCxID
UPDATE CxpD SET Importe = @GenerarCxImporteTotal WHERE ID = @GenerarCxID
END
EXEC spAfectar @CxModulo, @GenerarCxID, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
IF @CxModulo = 'CXC'
SELECT @GenerarCxMovID = MovID FROM Cxc WHERE ID = @GenerarCxID
ELSE
SELECT @GenerarCxMovID = MovID FROM Cxp WHERE ID = @GenerarCxID
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @CxModulo, @GenerarCxID, @GenerarCxMov, @GenerarCxMovID, @Ok OUTPUT
IF @Ok IS NULL
BEGIN
SELECT @DineroID = NULL
SELECT @DineroID = MIN(ID) FROM Dinero WHERE Empresa = @Empresa AND OrigenTipo = @CxModulo AND Origen = @GenerarCxMov AND OrigenID = @GenerarCxMovID AND Estatus IN ('CONCLUIDO', 'CONCILIADO')
IF @DineroID IS NULL
SELECT @Ok = 51170, @OkRef = @FormaPagoEfectivo
ELSE BEGIN
EXEC spConciliacionBuscarAux @Empresa, @MovTipo, @DineroID, @CtaDinero, @Cuenta, @Abono, @Cargo, @Auxiliar OUTPUT, @ContD OUTPUT, @CfgTolerancia, @Ok OUTPUT, @OkRef OUTPUT
UPDATE ConciliacionD SET Auxiliar = @Auxiliar, ContD = @ContD WHERE ID = @ID AND RID = @RID
END
END
END
END
END
/*IF @Auxiliar IS NULL
SELECT @Ok = 51060
ELSE */
IF @Auxiliar NOT IN (NULL, -1)
BEGIN
IF @Accion = 'AFECTAR'
BEGIN
IF EXISTS(SELECT * FROM ConciliacionCompensacion WHERE ID = @ID AND ConciliacionD = @RID)
SELECT @Ok = 51180, @OkRef = 'Detalle'
IF EXISTS(SELECT * FROM ConciliacionCompensacion WHERE ID = @ID AND Manual = @Auxiliar)
SELECT @Ok = 51180, @OkRef = 'Auxiliar'
INSERT #MovImpuesto (
OrigenModulo,    OrigenModuloID,    OrigenConcepto,    OrigenDeducible,		     OrigenFecha,    LoteFijo,    Retencion1,    Retencion2,    Retencion3,    Excento1,    Excento2,    Excento3,    Impuesto1,    Impuesto2,    Impuesto3,    Importe1,    Importe2,    Importe3,    TipoImpuesto1,    TipoImpuesto2,    TipoImpuesto3,    TipoRetencion1,    TipoRetencion2,    TipoRetencion3,    SubTotal,    ContUso,    ContUso2,    ContUso3,    ClavePresupuestal,    DescuentoGlobal, AplicaModulo, aplicaID)
SELECT mi.OrigenModulo, mi.OrigenModuloID, mi.OrigenConcepto, ISNULL(mi.OrigenDeducible, 100), mi.OrigenFecha, mi.LoteFijo, mi.Retencion1, mi.Retencion2, mi.Retencion3, mi.Excento1, mi.Excento2, mi.Excento3, mi.Impuesto1, mi.Impuesto2, mi.Impuesto3, mi.Importe1, mi.Importe2, mi.Importe3, mi.TipoImpuesto1, mi.TipoImpuesto2, mi.TipoImpuesto3, mi.TipoRetencion1, mi.TipoRetencion2, mi.TipoRetencion3, mi.SubTotal, mi.ContUso, mi.ContUso2, mi.ContUso3, mi.ClavePresupuestal, mi.DescuentoGlobal,
CASE WHEN (mt.clave = 'DIN.CH' AND omt.Clave = 'CXC.CAP') OR (mt.clave = 'DIN.D' AND omt.Clave = 'CXP.CAP') THEN mi.Modulo ELSE NULL END,
CASE WHEN (mt.clave = 'DIN.CH' AND omt.Clave = 'CXC.CAP') OR (mt.clave = 'DIN.D' AND omt.Clave = 'CXP.CAP') THEN mi.ModuloID ELSE NULL END
FROM MovImpuesto mi
JOIN Auxiliar a ON a.ID = @Auxiliar
JOIN MovTipo mt ON a.Modulo = mt.Modulo AND a.Mov = mt.Mov
JOIN Mov om ON om.Empresa = @Empresa AND om.Modulo = mi.OrigenModulo AND om.ID = mi.OrigenModuloID
JOIN MovTipo omt ON omt.Modulo = om.Modulo AND omt.Mov  = om.Mov
WHERE mi.Modulo = a.Modulo AND mi.ModuloID = a.ModuloID
IF @PPTO = 1
INSERT #MovPresupuesto (
CuentaPresupuesto,    Importe)
SELECT mp.CuentaPresupuesto, mp.Importe
FROM MovPresupuesto mp
JOIN Auxiliar a ON a.ID = @Auxiliar
WHERE mp.Modulo = a.Modulo AND mp.ModuloID = a.ModuloID
UPDATE Auxiliar SET Conciliado = 1, FechaConciliacion = @Fecha WHERE ID = @Auxiliar AND Conciliado = 0
IF @@ROWCOUNT = 0 SELECT @Ok = 51100
END ELSE
BEGIN
UPDATE Auxiliar SET Conciliado = 0, FechaConciliacion = NULL   WHERE ID = @Auxiliar AND Conciliado = 1
IF @@ROWCOUNT = 0 SELECT @Ok = 51100
END
END
IF @MovTipo = 'CONC.BC'
BEGIN
IF @ContD IS NULL
SELECT @Ok = 51070
ELSE BEGIN
IF @Accion = 'AFECTAR'
UPDATE ContD SET Conciliado = 1, FechaConciliacion = @Fecha WHERE RID = @ContD AND Conciliado = 0
ELSE
UPDATE ContD SET Conciliado = 0, FechaConciliacion = NULL   WHERE RID = @ContD AND Conciliado = 1
IF @@ROWCOUNT = 0 SELECT @Ok = 51110
END
END
END
IF @Ok IS NOT NULL AND @OkRef IS NULL
SELECT @OkRef = dbo.fnDateTimeToDDMMMAA(@Fecha)+' - '+@Concepto+' '+@Referencia+' '+CONVERT(varchar, @Importe)
FETCH NEXT FROM crConciliacionD INTO @RID, @Fecha, @Concepto, @Referencia, @Observaciones, @Cargo, @Abono, @Manual, @TipoMovimiento, @Auxiliar, @ContD, @ConceptoGasto, @Acreedor
END
CLOSE crConciliacionD
DEALLOCATE crConciliacionD
IF @Ok IS NULL AND EXISTS(SELECT * FROM ConciliacionCompensacion WHERE ID = @ID)
BEGIN
IF @Accion = 'AFECTAR'
BEGIN
INSERT #MovImpuesto (
OrigenModulo,    OrigenModuloID,    OrigenConcepto,    OrigenDeducible,		 OrigenFecha,    LoteFijo,    Retencion1,    Retencion2,    Retencion3,    Excento1,    Excento2,    Excento3,    Impuesto1,    Impuesto2,    Impuesto3,    Importe1,    Importe2,    Importe3,    TipoImpuesto1,    TipoImpuesto2,    TipoImpuesto3,    TipoRetencion1,    TipoRetencion2,    TipoRetencion3,    SubTotal,    ContUso,    ContUso2,    ContUso3,    ClavePresupuestal,    DescuentoGlobal)
SELECT mi.OrigenModulo, mi.OrigenModuloID, mi.OrigenConcepto, ISNULL(mi.OrigenDeducible, 100), mi.OrigenFecha, mi.LoteFijo, mi.Retencion1, mi.Retencion2, mi.Retencion3, mi.Excento1, mi.Excento2, mi.Excento3, mi.Impuesto1, mi.Impuesto2, mi.Impuesto3, mi.Importe1, mi.Importe2, mi.Importe3, mi.TipoImpuesto1, mi.TipoImpuesto2, mi.TipoImpuesto3, mi.TipoRetencion1, mi.TipoRetencion2, mi.TipoRetencion3, mi.SubTotal, mi.ContUso, mi.ContUso2, mi.ContUso3, mi.ClavePresupuestal, mi.DescuentoGlobal
FROM MovImpuesto mi
JOIN Auxiliar a ON a.ID IN (SELECT Manual FROM ConciliacionCompensacion WHERE ID = @ID)
WHERE mi.Modulo = a.Modulo AND mi.ModuloID = a.ModuloID
IF @PPTO = 1
INSERT #MovPresupuesto (
CuentaPresupuesto,    Importe)
SELECT mp.CuentaPresupuesto, mp.Importe
FROM MovPresupuesto mp
JOIN Auxiliar a ON a.ID IN (SELECT Manual FROM ConciliacionCompensacion WHERE ID = @ID)
WHERE mp.Modulo = a.Modulo AND mp.ModuloID = a.ModuloID
UPDATE ConciliacionD
SET Auxiliar = -1
WHERE ID = @ID AND RID IN (SELECT ConciliacionD FROM ConciliacionCompensacion WHERE ID = @ID)
UPDATE Auxiliar
SET Conciliado = 1, FechaConciliacion = @Fecha
WHERE ID IN (SELECT Manual FROM ConciliacionCompensacion WHERE ID = @ID) AND Conciliado = 0
END ELSE
UPDATE Auxiliar
SET Conciliado = 0, FechaConciliacion = NULL
WHERE ID IN (SELECT Manual FROM ConciliacionCompensacion WHERE ID = @ID) AND Conciliado = 1
END
IF @Accion = 'AFECTAR'
BEGIN
DELETE ConciliacionD WHERE ID = @ID AND Seccion = 2
CREATE TABLE #ConciliacionD (
ModuloID	int		NULL,
Fecha		datetime	NULL,
Referencia	varchar(50)	COLLATE Database_Default NULL,
Concepto	varchar(50)	COLLATE Database_Default NULL,
Cargo		money		NULL,
Abono		money		NULL)
CREATE INDEX ModuloID ON #ConciliacionD (ModuloID)
INSERT #ConciliacionD (
ModuloID, Fecha, Referencia,                      Cargo,   Abono)
SELECT ModuloID, Fecha, RTRIM(a.Mov)+' '+RTRIM(a.MovID), a.Abono, a.Cargo
FROM Auxiliar a
WHERE a.Empresa = @Empresa AND a.Modulo = 'DIN' AND a.Rama = 'DIN' AND a.Cuenta = @CtaDinero AND a.Fecha <= @FechaA AND a.Conciliado = 0
AND a.ModuloID NOT IN (SELECT d.ID FROM Dinero d WHERE d.Empresa=@Empresa AND d.Estatus = 'CANCELADO' AND (d.CtaDinero=@CtaDinero OR d.CtaDineroDestino = @CtaDinero))
UPDATE #ConciliacionD
SET Concepto = mi.Descripcion
FROM #ConciliacionD a
LEFT OUTER JOIN Dinero d ON d.ID = a.ModuloID AND d.Estatus IN ('PENDIENTE', 'CONCLUIDO', 'CONCILIADO')
LEFT OUTER JOIN MensajeInstitucion mi ON mi.Institucion = @Institucion AND mi.Mensaje = d.InstitucionMensaje
INSERT ConciliacionD (
ID,  Sucursal,  Seccion, Fecha, Concepto, Referencia, Cargo, Abono)
SELECT @ID, @Sucursal, 2,       Fecha, Concepto, Referencia, Cargo, Abono
FROM #ConciliacionD
DROP TABLE #ConciliacionD
END
IF @Ok IN (NULL, 80030)
BEGIN
IF @EstatusNuevo = 'CANCELADO' SELECT @FechaCancelacion = @FechaRegistro ELSE SELECT @FechaCancelacion = NULL
IF @EstatusNuevo = 'CONCLUIDO' SELECT @FechaConclusion  = @FechaEmision  ELSE IF @EstatusNuevo <> 'CANCELADO' SELECT @FechaConclusion  = NULL
IF @CfgContX = 1 AND @CfgContXGenerar <> 'NO'
BEGIN
IF @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') AND @EstatusNuevo <> 'CANCELADO' SELECT @GenerarPoliza = 1 ELSE
IF @Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') AND @EstatusNuevo =  'CANCELADO' IF @GenerarPoliza = 1 SELECT @GenerarPoliza = 0 ELSE SELECT @GenerarPoliza = 1
END
EXEC spValidarTareas @Empresa, @Modulo, @ID, @EstatusNuevo, @Ok OUTPUT, @OkRef OUTPUT
UPDATE Conciliacion
SET FechaConclusion  = @FechaConclusion,
FechaCancelacion = @FechaCancelacion,
UltimoCambio     = CASE WHEN UltimoCambio IS NULL THEN @FechaRegistro ELSE UltimoCambio END,
Estatus          = @EstatusNuevo,
Situacion 	= CASE WHEN @Estatus<>@EstatusNuevo THEN NULL ELSE Situacion END,
GenerarPoliza    = @GenerarPoliza
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Accion = 'AFECTAR'
BEGIN
SELECT @SaldoLibros = NULL, @SaldoConciliado = NULL
SELECT @SaldoLibros = SUM(ISNULL(a.Cargo, 0.0)-ISNULL(a.Abono, 0.0))
FROM Auxiliar a
WHERE a.Empresa = @Empresa AND a.Rama = 'DIN' AND a.Cuenta = @CtaDinero AND a.Fecha <= @FechaA
SELECT @SaldoConciliado = SUM(ISNULL(a.Cargo, 0.0)-ISNULL(a.Abono, 0.0))
FROM Auxiliar a
WHERE a.Empresa = @Empresa AND a.Rama = 'DIN' AND a.Cuenta = @CtaDinero AND a.Fecha <= @FechaA AND a.Conciliado = 1
UPDATE Conciliacion
SET SaldoLibros = @SaldoLibros,
SaldoConciliado = @SaldoConciliado
WHERE ID = @ID
END
END
END
IF @Accion = 'AFECTAR'
BEGIN
DELETE MovImpuesto WHERE Modulo = @Modulo AND ModuloID = @ID
IF EXISTS(SELECT * FROM #MovImpuesto)
INSERT MovImpuesto (
Modulo,  ModuloID, OrigenModulo, OrigenModuloID, OrigenConcepto, OrigenDeducible,	      OrigenFecha, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, Impuesto1, Impuesto2, Impuesto3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, Importe1,      Importe2,      Importe3,      SubTotal,      ContUso, ContUso2, ContUso3, ClavePresupuestal, DescuentoGlobal, AplicaModulo, AplicaID)
SELECT @Modulo, @ID,      OrigenModulo, OrigenModuloID, OrigenConcepto, ISNULL(OrigenDeducible, 100), OrigenFecha, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, Impuesto1, Impuesto2, Impuesto3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, SUM(Importe1), SUM(Importe2), SUM(Importe3), SUM(SubTotal), ContUso, ContUso2, ContUso3, ClavePresupuestal, DescuentoGlobal, AplicaModulo, AplicaID
FROM #MovImpuesto
GROUP BY OrigenModulo, OrigenModuloID, OrigenConcepto, ISNULL(OrigenDeducible, 100), OrigenFecha, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, Impuesto1, Impuesto2, Impuesto3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, ContUso, ContUso2, ContUso3, ClavePresupuestal, DescuentoGlobal, AplicaModulo, AplicaID
ORDER BY OrigenModulo, OrigenModuloID, OrigenConcepto, ISNULL(OrigenDeducible, 100), OrigenFecha, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, Impuesto1, Impuesto2, Impuesto3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, ContUso, ContUso2, ContUso3, ClavePresupuestal, DescuentoGlobal, AplicaModulo, AplicaID
IF @PPTO = 1
BEGIN
DELETE MovPresupuesto WHERE Modulo = @Modulo AND ModuloID = @ID
IF EXISTS(SELECT * FROM #MovPresupuesto)
INSERT MovPresupuesto (
Modulo,  ModuloID, CuentaPresupuesto, Importe)
SELECT @Modulo, @ID,      CuentaPresupuesto, SUM(Importe)
FROM #MovPresupuesto
GROUP BY CuentaPresupuesto
ORDER BY CuentaPresupuesto
END
END
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spMovFinal @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion = 'CANCELAR' AND @EstatusNuevo = 'CANCELADO' AND @Ok IS NULL
EXEC spCancelarFlujo @Empresa, @Modulo, @ID, @Ok OUTPUT, @CancelarHijos = 1,@Usuario=@Usuario
/*IF @Accion = 'CANCELAR'
SELECT @Saldo = @SaldoAnterior
ELSE SELECT @Saldo = @SaldoFinal
IF @Ok IS NULL
BEGIN
IF ROUND(@Saldo, 2) <> (SELECT ROUND(SaldoConciliado, 2) FROM DineroSaldo WHERE Empresa = @Empresa AND Moneda = @MovMoneda AND CtaDinero = @CtaDinero)
SELECT @Ok = 51025
IF @MovTipo = 'CONC.BC'
IF ROUND(@Saldo, 2) <> (SELECT ROUND(SaldoConciliado, 2) FROM CtaSaldo WHERE Empresa = @Empresa AND Moneda = @MovMoneda AND Cuenta = @Cuenta)
SELECT @Ok = 51026
END*/
IF @Conexion = 0
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
COMMIT TRANSACTION
ELSE
BEGIN
DECLARE @PolizaDescuadrada TABLE (Cuenta varchar(20) NULL, SubCuenta varchar(50) NULL, Concepto varchar(50) NULL, Debe money NULL, Haber money NULL, SucursalContable int NULL)
IF EXISTS(SELECT * FROM PolizaDescuadrada WHERE Modulo = @Modulo AND ID = @ID)
INSERT @PolizaDescuadrada (Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable) SELECT Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable FROM PolizaDescuadrada WHERE Modulo = @Modulo AND ID = @ID
/*        DECLARE @PolizaDescuadradaSesion TABLE (Modulo varchar(5) NULL, ID int NULL, RID int NULL, Cuenta varchar(20) NULL, SubCuenta varchar(50) NULL, Concepto varchar(50) NULL, Debe money NULL, Haber money NULL, SucursalContable int NULL)
INSERT @PolizaDescuadradaSesion (Modulo, ID, RID, Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable) SELECT Modulo, ID, RID, Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable FROM PolizaDescuadrada */
ROLLBACK TRANSACTION
DELETE PolizaDescuadrada WHERE Modulo = @Modulo AND ID = @ID
INSERT PolizaDescuadrada (Modulo, ID, Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable) SELECT @Modulo, @ID, Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable FROM @PolizaDescuadrada
/*TRUNCATE TABLE PolizaDescuadradaSesion
INSERT PolizaDescuadradaSesion (Modulo, ID, RID, Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable) SELECT Modulo, ID, RID, Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable FROM @PolizaDescuadradaSesion*/
END
RETURN
END

