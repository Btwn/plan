SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDineroAplicar
@Sucursal			int,
@ID		  		int,
@Accion			char(20),
@Empresa			char(5),
@Usuario			char(10),
@Modulo			char(5),
@Mov			char(20),
@MovID			varchar(20),
@MovTipo			char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaEmision		datetime,
@FechaRegistro		datetime,
@FechaAfectacion		datetime,
@Ejercicio			int,
@Periodo			int,
@CtaDinero			char(10),
@CtaDineroFactor		float,
@CtaDineroTipoCambio	float,
@ImporteTotal		money,
@CfgContX			bit,
@CfgContXGenerar		char(20),
@VerificarAplica		bit,
@Ok 			int		OUTPUT,
@OkRef 			varchar(255)	OUTPUT,
@EstacionTrabajo int = NULL 

AS BEGIN
DECLARE
@EsCargo		bit,
@Abono		bit,
@IDAplica		int,
@AplicaMov		char(20),
@AplicaMovID	varchar(20),
@AplicaMovTipo	char(20),
@AplicaEstatus	char(15),
@AplicaEstatusNuevo	char(15),
@AplicaImporte	money,
@AplicaMoneda	char(10),
@AplicaContacto	char(10),
@AplicaContactoTipo	varchar(20),
@AplicaFactor	float,
@AplicaTotal	money,
@AplicaTipoCambio	float,
@CxModulo		char(5),
@CxID 		int,
@CxEsCargo		bit,
@CxContacto		char(10),
@CxImporte		money,
@Contacto		char(10),
@ContactoTipo	varchar(20),
@Saldo		money,
@SaldoNuevo		money,
@CtaDineroImporte	money,
@ImporteAplicado	money,
@ImporteDetalle	money,
@Renglon		float,
@PrimeraVez		bit,
@PPTO		bit,
@AplicaFechaEmision		datetime,
@AplicaEjercicio		int,
@AplicaPeriodo			int,
@Proyecto           varchar(50),
@AplicaProyecto     varchar(50),
@CP                 bit
SELECT @PPTO = PPTO, @CP = ISNULL(CP,0)  FROM EmpresaGral WHERE Empresa = @Empresa
IF @VerificarAplica = 0
BEGIN
CREATE TABLE #DineroAplicaMovImpuesto (
Impuesto1		float		NULL,
Impuesto2		float		NULL,
Impuesto3		float		NULL,
Importe1		money		NULL,
Importe2		money		NULL,
Importe3		money		NULL,
SubTotal		money		NULL,
TipoImpuesto1		varchar(10)	COLLATE Database_Default NULL,
TipoImpuesto2		varchar(10)	COLLATE Database_Default NULL,
TipoImpuesto3		varchar(10)	COLLATE Database_Default NULL,
TipoRetencion1		varchar(10)	COLLATE Database_Default NULL,
TipoRetencion2		varchar(10)	COLLATE Database_Default NULL,
TipoRetencion3		varchar(10)	COLLATE Database_Default NULL,
LoteFijo		varchar(20)	COLLATE Database_Default NULL,
OrigenModulo		varchar(5)	COLLATE Database_Default NULL,
OrigenModuloID		int		NULL,
OrigenConcepto		varchar(50)	COLLATE Database_Default NULL,
OrigenDeducible		float		NULL	DEFAULT 100,
OrigenFecha		datetime	NULL,
Retencion1		float		NULL,
Retencion2		float		NULL,
Retencion3		float		NULL,
Excento1		bit		NULL	DEFAULT 0,
Excento2		bit		NULL	DEFAULT 0,
Excento3		bit		NULL	DEFAULT 0,
ContUso			varchar(20)	COLLATE Database_Default NULL,
ContUso2		varchar(20)	COLLATE Database_Default NULL,
ContUso3		varchar(20)	COLLATE Database_Default NULL,
ClavePresupuestal		varchar(50)	COLLATE Database_Default NULL,
ClavePresupuestalImpuesto1	varchar(50)	COLLATE Database_Default NULL,
DescuentoGlobal		float		NULL
)
IF @PPTO = 1
CREATE TABLE #DineroAplicaMovPresupuesto (
Importe		money		NULL,
CuentaPresupuesto	varchar(20)	COLLATE Database_Default NULL)
END
SELECT @Proyecto = NULLIF(Proyecto,'') FROM Dinero WHERE ID = @ID
SELECT @ImporteAplicado = 0.0, @PrimeraVez = 1, @Contacto = NULL, @ContactoTipo = NULL
DECLARE crDineroDetalle CURSOR FOR
SELECT NULLIF(RTRIM(d.Aplica), ''), d.AplicaID, ISNULL(SUM(d.Importe), 0.0), mt.Clave
FROM DineroD d, MovTipo mt
WHERE ID = @ID AND mt.Modulo = 'DIN' AND mt.Mov = d.Aplica
GROUP BY mt.Clave, NULLIF(RTRIM(d.Aplica), ''), d.AplicaID
ORDER BY mt.Clave, NULLIF(RTRIM(d.Aplica), ''), d.AplicaID
OPEN crDineroDetalle
FETCH NEXT FROM crDineroDetalle INTO @AplicaMov, @AplicaMovID, @AplicaImporte, @AplicaMovTipo
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @AplicaImporte <> 0.0 AND @Ok IS NULL
BEGIN
SELECT @CtaDineroImporte = @AplicaImporte / @CtaDineroFactor
SELECT @IDAplica = NULL, @Saldo = NULL
SELECT @IDAplica = ID, @Saldo = ISNULL(Saldo, 0.0), @AplicaEstatus = Estatus, @AplicaMoneda = NULLIF(RTRIM(Moneda), ''), @AplicaContacto = Contacto, @AplicaContactoTipo = ContactoTipo, @AplicaTotal = Importe, @AplicaTipoCambio = TipoCambio,
@AplicaFechaEmision = FechaEmision, @AplicaEjercicio = Ejercicio, @AplicaPeriodo = Periodo, @AplicaProyecto = NULLIF(Proyecto,'')
FROM Dinero
WHERE Empresa = @Empresa AND Mov = @AplicaMov AND MovID = @AplicaMovID AND Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'POSFECHADO', 'CANCELADO')
IF @@ERROR <> 0 SELECT @Ok = 1
IF  @CP = 1
IF @Proyecto <> @AplicaProyecto
SET @Ok = 70216
IF @Ok IS NULL AND @Accion <> 'CANCELAR'
EXEC spValidarFechaAplicacion @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @FechaEmision, @Ejercicio, @Periodo,
@AplicaMov, @AplicaMovID, @Modulo, @IDAplica, @AplicaFechaEmision, @AplicaEjercicio, @AplicaPeriodo, @Ok = @Ok OUTPUT,
@OkRef = @OkRef OUTPUT
IF @Ok IS NULL AND @Accion <> 'CANCELAR'
EXEC spEmpresaValidarFechaAplicacion @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @FechaEmision, @Ejercicio, @Periodo,
@AplicaMov, @AplicaMovID, @Modulo, @IDAplica, @AplicaFechaEmision, @AplicaEjercicio, @AplicaPeriodo, @Ok = @Ok OUTPUT,
@OkRef = @OkRef OUTPUT
IF @VerificarAplica = 0 AND @IDAplica IS NOT NULL
BEGIN
IF NULLIF(RTRIM(@AplicaMoneda), '') <> NULLIF(RTRIM(@MovMoneda), '') SELECT @AplicaFactor = (@AplicaImporte * @MovTipoCambio) / NULLIF(CONVERT(float, @AplicaTotal * @AplicaTipoCambio), 0)
ELSE SELECT @AplicaFactor = (@AplicaImporte) / NULLIF(CONVERT(float, @AplicaTotal), 0)
EXEC xpDineroAplicaFactorMovImpuesto @Sucursal, @ID, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio, @IDAplica, @AplicaMov, @AplicaMovID, @AplicaMovTipo, @AplicaImporte, @VerificarAplica, @AplicaFactor OUTPUT, @Ok OUTPUT,  @OkRef OUTPUT
INSERT #DineroAplicaMovImpuesto (
OrigenModulo, OrigenModuloID, OrigenConcepto, OrigenDeducible, OrigenFecha, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, Impuesto1, Impuesto2, Impuesto3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, Importe1,               Importe2,               Importe3,               SubTotal,               ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal)
SELECT OrigenModulo, OrigenModuloID, OrigenConcepto, OrigenDeducible, OrigenFecha, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, Impuesto1, Impuesto2, Impuesto3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, Importe1*@AplicaFactor, Importe2*@AplicaFactor, Importe3*@AplicaFactor, SubTotal*@AplicaFactor, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal
FROM MovImpuesto
WHERE Modulo = @Modulo
AND ModuloID = @IDAplica
IF @PPTO = 1
INSERT #DineroAplicaMovPresupuesto
(CuentaPresupuesto, Importe)
SELECT CuentaPresupuesto, Importe*@AplicaFactor
FROM MovPresupuesto
WHERE Modulo = @Modulo
AND ModuloID = @IDAplica
END
IF @VerificarAplica = 1
BEGIN
IF @PrimeraVez = 1
SELECT @PrimeraVez = 0, @Contacto = @AplicaContacto, @ContactoTipo = @AplicaContactoTipo
ELSE
IF @MovTipo IN ('DIN.CH', 'DIN.CHE') AND (@Contacto <> @AplicaContacto OR @ContactoTipo <> @AplicaContactoTipo)
BEGIN
IF EXISTS(SELECT * FROM EmpresaGral WHERE Empresa = @Empresa AND ContAuto = 1 AND ContAutoChequesMultiContacto = 0) AND
(SELECT NULLIF(RTRIM(ContMov), '') FROM MovClave WHERE Modulo = @Modulo AND Clave = @MovTipo) IS NOT NULL
SELECT @Ok = 40180
END
EXEC spAplicaOk @Empresa, @Usuario, @Modulo, @IDAplica, @Ok OUTPUT, @OkRef OUTPUT
END
IF (@MovTipo IN ('DIN.CH', 'DIN.CHE','DIN.E', 'DIN.F') AND @AplicaMovTipo NOT IN ('DIN.SCH', 'DIN.E', 'DIN.F')) OR
(@MovTipo IN ('DIN.D', 'DIN.DE', 'DIN.I') AND @AplicaMovTipo NOT IN ('DIN.SD',  'DIN.I', 'DIN.TI')) OR
(@MovTipo IN ('DIN.INV', 'DIN.RET') AND @AplicaMovTipo NOT IN ('DIN.INV'))
SELECT @Ok = 20180
IF @Saldo IS NULL SELECT @Ok = 30120
IF @AplicaMoneda <> @MovMoneda AND @Ok IS NULL SELECT @Ok = 30280
IF @Accion <> 'CANCELAR' AND @Ok IS NULL
BEGIN
IF @AplicaEstatus <> 'PENDIENTE' SELECT @Ok = 30060
IF ROUND(@Saldo, 2) < ROUND(@CtaDineroImporte, 2) SELECT @Ok = 30070
END
IF @Ok IS NULL
BEGIN
IF @VerificarAplica = 0
BEGIN
IF @Accion <> 'CANCELAR' SELECT @EsCargo = 0, @ImporteDetalle = - @CtaDineroImporte ELSE SELECT @EsCargo = 1, @ImporteDetalle = @CtaDineroImporte
SELECT @CxID = NULL, @CxEsCargo = 0
IF @AplicaMovTipo IN ('DIN.SD', 'DIN.SCH')
BEGIN
IF @AplicaContactoTipo = 'Cliente'   SELECT @CxModulo = 'CXC' ELSE
IF @AplicaContactoTipo = 'Proveedor' SELECT @CxModulo = 'CXP'
IF @CxModulo = 'CXC' SELECT @CxID = ID, @CxContacto = Cliente   FROM Cxc WHERE Empresa = @Empresa AND Mov = @AplicaMov AND MovID = @AplicaMovID AND Estatus IN ('PENDIENTE', 'CONCLUIDO') ELSE
IF @CxModulo = 'CXP' SELECT @CxID = ID, @CxContacto = Proveedor FROM Cxp WHERE Empresa = @Empresa AND Mov = @AplicaMov AND MovID = @AplicaMovID AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
IF (@AplicaMovTipo = 'DIN.SCH' AND @CxModulo = 'CXC') OR (@AplicaMovTipo = 'DIN.SD' AND @CxModulo = 'CXP') SELECT @CxEsCargo = 1
END
/** JH 25.10.2006 **/
IF @Accion = 'CANCELAR'
SELECT @SaldoNuevo = @Saldo + @ImporteDetalle
ELSE
SELECT @SaldoNuevo = ROUND(@Saldo + @ImporteDetalle, 0)
/** JH 25.10.2006 **/
IF @SaldoNuevo = 0.0
BEGIN
SELECT @AplicaEstatusNuevo = 'CONCLUIDO'
EXEC spValidarTareas @Empresa, @Modulo, @IDAplica, @AplicaEstatusNuevo, @Ok OUTPUT, @OkRef OUTPUT
UPDATE Dinero SET Saldo = NULL, Estatus = @AplicaEstatusNuevo, FechaConclusion = @FechaEmision WHERE ID = @IDAplica
IF @CxID IS NOT NULL
BEGIN
IF @CxModulo = 'CXC' UPDATE Cxc SET Saldo = NULL, Estatus = @AplicaEstatusNuevo, FechaConclusion = @FechaEmision WHERE ID = @CxID ELSE
IF @CxModulo = 'CXP' UPDATE Cxp SET Saldo = NULL, Estatus = @AplicaEstatusNuevo, FechaConclusion = @FechaEmision WHERE ID = @CxID
END
END ELSE
BEGIN
SELECT @AplicaEstatusNuevo = 'PENDIENTE'
EXEC spValidarTareas @Empresa, @Modulo, @IDAplica, @AplicaEstatusNuevo, @Ok OUTPUT, @OkRef OUTPUT
UPDATE Dinero SET Saldo = @Saldo + @ImporteDetalle, Estatus = @AplicaEstatusNuevo, FechaConclusion = NULL WHERE ID = @IDAplica
IF @CxID IS NOT NULL
BEGIN
IF @CxModulo = 'CXC' UPDATE Cxc SET Saldo = @Saldo + @ImporteDetalle, Estatus = @AplicaEstatusNuevo, FechaConclusion = NULL WHERE ID = @CxID ELSE
IF @CxModulo = 'CXP' UPDATE Cxp SET Saldo = @Saldo + @ImporteDetalle, Estatus = @AplicaEstatusNuevo, FechaConclusion = NULL WHERE ID = @CxID
END
END
IF @CxID IS NOT NULL
BEGIN
SELECT @CxImporte = -@ImporteDetalle
EXEC spSaldo @Sucursal, @Accion, @Empresa, @Usuario, @CxModulo, @MovMoneda, @MovTipoCambio, @CxContacto, NULL, NULL, NULL,
@Modulo, @ID, @Mov, @MovID, @CxEsCargo, @CxImporte, NULL, NULL,
@FechaAfectacion, @Ejercicio, @Periodo, @AplicaMov, @AplicaMovID, 0, 0, 0,
@Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spMovFinal @Empresa, @Sucursal, @Modulo, @IDAplica, @AplicaEstatus, @AplicaEstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @AplicaMov, @AplicaMovID, @AplicaMovTipo, NULL, @Ok OUTPUT, @OkRef OUTPUT, @EstacionTrabajo 
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @IDAplica, @AplicaMov, @AplicaMovID, @Modulo, @ID, @Mov, @MovID, @Ok OUTPUT
END
END
IF @AplicaImporte < 0.0 AND @MovTipo NOT IN ('DIN.C', 'DIN.CP', 'DIN.D', 'DIN.RE', 'DIN.REI', 'DIN.RND', 'DIN.CB', 'DIN.AB') SELECT @Ok = 30100
IF @Ok IS NOT NULL
SELECT @OkRef = RTRIM(@AplicaMov)+' '+LTRIM(Convert(char, @AplicaMovID))
IF @Ok IS NULL
SELECT @ImporteAplicado = @ImporteAplicado + @AplicaImporte
END 
FETCH NEXT FROM crDineroDetalle INTO @AplicaMov, @AplicaMovID, @AplicaImporte, @AplicaMovTipo
IF @@ERROR <> 0 SELECT @Ok = 1
END 
CLOSE crDineroDetalle
DEALLOCATE crDineroDetalle
IF @Ok IS NULL AND @ImporteAplicado < @ImporteTotal AND @Accion <> 'CANCELAR' SELECT @Ok = 30070
IF @VerificarAplica = 1 AND @MovTipo IN ('DIN.CH', 'DIN.CHE')
UPDATE Dinero SET Contacto = @Contacto, ContactoTipo = @ContactoTipo WHERE ID = @ID AND (Contacto <> @Contacto OR ContactoTipo <> @ContactoTipo)
IF @VerificarAplica = 0
BEGIN
DELETE MovImpuesto WHERE Modulo = @Modulo AND ModuloID = @ID
IF EXISTS(SELECT * FROM #DineroAplicaMovImpuesto)
BEGIN
INSERT MovImpuesto (
Modulo,  ModuloID, OrigenModulo, OrigenModuloID, OrigenConcepto, OrigenDeducible,		    OrigenFecha, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, Impuesto1, Impuesto2, Impuesto3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, Importe1,      Importe2,      Importe3,      SubTotal,      ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal)
SELECT @Modulo, @ID,      OrigenModulo, OrigenModuloID, OrigenConcepto, ISNULL(OrigenDeducible, 100), OrigenFecha, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, Impuesto1, Impuesto2, Impuesto3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, SUM(Importe1), SUM(Importe2), SUM(Importe3), SUM(SubTotal), ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal
FROM #DineroAplicaMovImpuesto
GROUP BY OrigenModulo, OrigenModuloID, OrigenConcepto, ISNULL(OrigenDeducible, 100), OrigenFecha, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, Impuesto1, Impuesto2, Impuesto3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal
ORDER BY OrigenModulo, OrigenModuloID, OrigenConcepto, ISNULL(OrigenDeducible, 100), OrigenFecha, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, Impuesto1, Impuesto2, Impuesto3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal
END
IF @PPTO = 1
BEGIN
DELETE MovPresupuesto WHERE Modulo = @Modulo AND ModuloID = @ID
IF EXISTS(SELECT * FROM #DineroAplicaMovPresupuesto)
BEGIN
INSERT MovPresupuesto
(Modulo,  ModuloID, CuentaPresupuesto, Importe)
SELECT @Modulo, @ID,      CuentaPresupuesto, SUM(Importe)
FROM #DineroAplicaMovPresupuesto
GROUP BY CuentaPresupuesto
ORDER BY CuentaPresupuesto
END
END
END
RETURN
END

