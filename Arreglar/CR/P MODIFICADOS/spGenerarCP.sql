SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarCP
@Empresa		char(5),
@Sucursal		int,
@Modulo		char(5),
@ID			int,
@Estatus		char(15),
@EstatusNuevo	char(15),
@Usuario		char(10),
@FechaEmision	datetime,
@FechaRegistro	datetime,
@Mov			char(20),
@MovID		varchar(20),
@MovTipo		char(20),
@AfectarCP		varchar(20),
@EsAjuste		bit,
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@CPID		int,
@CPMov		varchar(20),
@CPMovReservado	varchar(20),
@CPMovID		varchar(20),
@OrigenTipo		varchar(10),
@Origen		varchar(20),
@OrigenID		varchar(20),
@Moneda		varchar(10),
@TipoCambio		float,
@Proyecto		varchar(50),
@UEN		int,
@AplicarCP		varchar(20),
@IDAplica		int,
@Aplica		varchar(20),
@AplicaID		varchar(20),
@AplicaImporteTotal	money,
@AplicaFactor	float,
@CxTipoCambio	float,
@FactorCP		float,
@Multiple		bit,
@SepararImpuestos	bit,
@CPImpuesto1	varchar(50),
@CPImpuesto2	varchar(50),
@CPImpuesto3	varchar(50),
@CPRetencion1	varchar(50), 
@CPRetencion2	varchar(50), 
@CPRetencion3	varchar(50), 
@ReservarCP		varchar(20),
@Tipo		varchar(20),
@ContMoneda		varchar(10),
@ContTipoCambio	float
SELECT @CxTipoCambio = NULL
SELECT @ContMoneda = m.Moneda, @ContTipoCambio = m.TipoCambio
FROM EmpresaCfg cfg, Mon m
WITH(NOLOCK) WHERE cfg.Empresa = @Empresa AND m.Moneda = cfg.ContMoneda
SELECT @AplicarCP = NULL, @ReservarCP = NULL
IF @EstatusNuevo = 'CANCELADO'
BEGIN
DECLARE crCP CURSOR LOCAL FOR
SELECT ID, Mov, MovID
FROM CP WITH(NOLOCK)
WHERE Empresa = @Empresa AND Estatus = 'CONCLUIDO' AND OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID
ORDER BY ID
OPEN crCP
FETCH NEXT FROM crCP  INTO @CPID, @CPMov, @CPMovID
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spAfectar 'CP', @CPID, 'CANCELAR', @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
EXEC spMovFlujo @Sucursal, 'CANCELAR', @Empresa, @Modulo, @ID, @Mov, @MovID, 'CP', @CPID, @CPMov, @CPMovID, @Ok OUTPUT
END
FETCH NEXT FROM crCP  INTO @CPID, @CPMov, @CPMovID
END
CLOSE crCP
DEALLOCATE crCP
RETURN
END ELSE
BEGIN
SELECT @CPMov = CPOperacion,
@CPMovReservado = CPReservadoFlujo
FROM EmpresaCfgMov
WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT @ReservarCP = UPPER(ReservarCP)/*,
@AnticiposCP = UPPER(AnticiposCP)*/
FROM MovTipo
WITH(NOLOCK) WHERE Modulo = @Modulo AND Mov = @Mov
EXEC spMovInfo @ID, @Modulo, @Moneda = @Moneda OUTPUT, @TipoCambio = @TipoCambio OUTPUT, @Proyecto = @Proyecto OUTPUT, @UEN = @UEN OUTPUT,
@OrigenTipo = @OrigenTipo OUTPUT, @Origen = @Origen OUTPUT, @OrigenID = @OrigenID OUTPUT
SELECT @FactorCP = 1.0
SELECT @FactorCP = ISNULL(FactorCP, 1.0)
FROM MovTipo
WITH(NOLOCK) WHERE Modulo = @Modulo AND Mov = @Mov
DECLARE @CPD TABLE (
Renglon			int		NOT NULL IDENTITY(2048, 1024) PRIMARY KEY,
ClavePresupuestal		 varchar(50)	NULL,
ClavePresupuestalImpuesto1 varchar(50)	NULL,
ClavePresupuestalRetencion1 varchar(50)	NULL, 
AfectarCP			varchar(20)	NULL,
AplicarCP			varchar(20)	NULL,
Aplica			varchar(20)	NULL,
AplicaID			varchar(20)	NULL,
AplicaTipoCambio		float		NULL,
Importe			money           NULL,
Impuesto1			money		NULL,
Impuesto2			money		NULL,
Impuesto3			money		NULL,
Retencion1		money		NULL, 
Retencion2		money		NULL, 
Retencion3		money		NULL, 
ImporteTotal		AS		ISNULL(Importe, 0.0)+ISNULL(Impuesto1, 0.0)+ISNULL(Impuesto2, 0.0)+ISNULL(Impuesto3, 0.0)-ISNULL(Retencion1, 0.0), 
Presupuesto		money		NULL,
Comprometido		money		NULL,
Comprometido2		money		NULL,
Devengado			money		NULL,
Devengado2		money		NULL,
Ejercido			money		NULL,
EjercidoPagado		money		NULL,
Anticipos			money		NULL,
RemanenteDisponible	money		NULL,
Sobrante			money		NULL)
IF @ReservarCP IN ('SI', 'DESRESERVAR')
BEGIN
EXEC spCPVerificarCalMov @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
IF @ReservarCP = 'SI' SELECT @Tipo = 'Ampliacion' ELSE SELECT @Tipo = 'Reduccion'
INSERT CP (
Sucursal,  Empresa,  Usuario,  Mov,             Moneda,      TipoCambio,      FechaEmision,  Proyecto,  UEN,  Estatus,      OrigenTipo, Origen, OrigenID)
VALUES (@Sucursal, @Empresa, @Usuario, @CPMovReservado, @ContMoneda, @ContTipoCambio, @FechaEmision, @Proyecto, @UEN, 'SINAFECTAR', @Modulo,    @Mov,   @MovID)
SELECT @CPID = SCOPE_IDENTITY()
INSERT @CPD (ClavePresupuestal, Importe)
SELECT ClavePresupuestal, SUM(Importe)
FROM CPCalMov
WITH(NOLOCK) WHERE Modulo = @Modulo AND ModuloID = @ID
GROUP BY ClavePresupuestal
INSERT CPD (
ID,    Sucursal,  Renglon, Tipo,  ClavePresupuestal, Importe)
SELECT @CPID, @Sucursal, Renglon, @Tipo, ClavePresupuestal, Importe*@TipoCambio/@ContTipoCambio
FROM @CPD
INSERT CPCal(
ID,    Sucursal,  ClavePresupuestal, Tipo, Ejercicio, Periodo, Importe)
SELECT @CPID, @Sucursal, ClavePresupuestal, Tipo, Ejercicio, Periodo, Importe*@TipoCambio/@ContTipoCambio
FROM CPCalMov
WITH(NOLOCK) WHERE Modulo = @Modulo AND ModuloID = @ID
EXEC spAfectar 'CP', @CPID, 'AFECTAR', @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
BEGIN
SELECT @CPMovID = MovID FROM CP WITH(NOLOCK) WHERE ID = @CPID
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @Modulo, @ID, @Mov, @MovID, 'CP', @CPID, @CPMovReservado, @CPMovID, @Ok OUTPUT
END
SELECT @CPID = NULL, @CPMovID = NULL
DELETE @CPD
END
END
IF @EsAjuste = 1
BEGIN
INSERT @CPD (
ClavePresupuestal,   AfectarCP,  Importe)
SELECT d.ClavePresupuestal, @AfectarCP, CASE @AfectarCP
WHEN 'Presupuesto'     THEN d.Presupuesto
WHEN 'Comprometido'    THEN d.Comprometido
WHEN 'Comprometido 2'  THEN d.Comprometido2
WHEN 'Devengado'       THEN d.Devengado
WHEN 'Devengado 2'     THEN d.Devengado2
WHEN 'Ejercido'        THEN d.Ejercido
WHEN 'Ejercido Pagado' THEN d.EjercidoPagado
WHEN 'Remanente Disp.' THEN d.RemanenteDisponible
WHEN 'Sobrante'        THEN d.Ejercido
WHEN 'Anticipos'       THEN d.Anticipos
END
FROM CP e
 WITH(NOLOCK) JOIN CPD d  WITH(NOLOCK) ON d.ID = e.ID
WHERE e.Empresa = @Empresa AND e.Estatus = 'CONCLUIDO' AND e.OrigenTipo = @Modulo AND e.Origen = @Mov AND e.OrigenID = @MovID
INSERT @CPD (
ClavePresupuestal,   AfectarCP,  Importe)
SELECT d.ClavePresupuestal, @AfectarCP, CASE @AfectarCP
WHEN 'Presupuesto'     THEN d.Presupuesto
WHEN 'Comprometido'    THEN d.Comprometido
WHEN 'Comprometido 2'  THEN d.Comprometido2
WHEN 'Devengado'       THEN d.Devengado
WHEN 'Devengado 2'     THEN d.Devengado2
WHEN 'Ejercido'        THEN d.Ejercido
WHEN 'Ejercido Pagado' THEN d.EjercidoPagado
WHEN 'Remanente Disp.' THEN d.RemanenteDisponible
WHEN 'Sobrante'        THEN d.Ejercido
WHEN 'Anticipos'       THEN d.Anticipos
END
FROM CP e
 WITH(NOLOCK) JOIN CPD d  WITH(NOLOCK) ON d.ID = e.ID
WHERE e.Empresa = @Empresa AND e.Estatus = 'CONCLUIDO' AND d.Aplica = @Mov AND d.AplicaID = @MovID
END ELSE
IF @Modulo = 'GAS'
BEGIN
IF @MovTipo IN ('GAS.A', 'GAS.DA', 'GAS.C', 'GAS.CCH', 'GAS.G', 'GAS.GTC', 'GAS.GP', 'GAS.CP', 'GAS.DA', 'GAS.SR', 'GAS.ASC', 'GAS.CI')
BEGIN
SELECT @AplicarCP = mt.AfectarCP,
@Aplica = g.MovAplica,
@AplicaID = g.MovAplicaID,
@AplicaImporteTotal = ISNULL(g.Importe, 0.0)+ISNULL(g.Impuestos, 0.0)-ISNULL(g.Retencion, 0.0), 
@Multiple = ISNULL(g.Multiple, 0)
FROM Gasto g
 WITH(NOLOCK) JOIN MovTipo mt  WITH(NOLOCK) ON mt.Modulo = @Modulo AND mt.Mov = g.MovAplica
WHERE g.ID = @ID
IF @Multiple = 1 SELECT @Ok = 25610
END
/*INSERT @CPD (
ClavePresupuestal, Importe,  Impuesto1, Impuesto2, Impuesto3, AfectarCP,  AplicarCP)
SELECT ClavePresupuestal, SubTotal, Importe1,  Importe2,  Importe3,  @AfectarCP, @AplicarCP
FROM MovImpuesto
WITH(NOLOCK) WHERE Modulo = @Modulo AND ModuloID = @ID*/
IF @MovTipo IN ('GAS.DA', 'GAS.SR', 'GAS.ASC')
BEGIN
SELECT @IDAplica = MAX(ID) FROM Gasto WHERE Empresa = @Empresa AND Estatus IN ('CONCLUIDO', 'PENDIENTE') AND Mov = @Aplica AND MovID = @AplicaID
SELECT @AplicaFactor = @AplicaImporteTotal / NULLIF(ISNULL(Importe, 0.0)+ISNULL(Impuestos, 0.0)-ISNULL(Retencion, 0.0), 0.0) FROM Gasto WHERE ID = @IDAplica 
INSERT @CPD (
ClavePresupuestal,   ClavePresupuestalImpuesto1,   ClavePresupuestalRetencion1,   Importe,                           Impuesto1,                           AfectarCP,  AplicarCP,  Aplica,  AplicaID) 
SELECT d.ClavePresupuestal, c.ClavePresupuestalImpuesto1, c.ClavePresupuestalRetencion1, SUM(d.ImporteLinea*@AplicaFactor), SUM(d.ImpuestosLinea*@AplicaFactor), @AfectarCP, @AplicarCP, @Aplica, @AplicaID 
FROM GastoT d
LEFT OUTER JOIN Concepto c  WITH(NOLOCK) ON c.Modulo = @Modulo AND c.Concepto = d.Concepto
WHERE d.ID = @IDAplica
GROUP BY d.ClavePresupuestal, c.ClavePresupuestalImpuesto1, c.ClavePresupuestalRetencion1 
ORDER BY d.ClavePresupuestal, c.ClavePresupuestalImpuesto1, c.ClavePresupuestalRetencion1 
END ELSE
INSERT @CPD (
ClavePresupuestal,   ClavePresupuestalImpuesto1,   Importe,             Impuesto1,             Retencion1,             AfectarCP,  AplicarCP,  Aplica,  AplicaID) 
SELECT d.ClavePresupuestal, c.ClavePresupuestalImpuesto1, SUM(d.ImporteLinea), SUM(d.ImpuestosLinea), SUM(d.Retencion), @AfectarCP, @AplicarCP, @Aplica, @AplicaID 
FROM GastoT d
LEFT OUTER JOIN Concepto c  WITH(NOLOCK) ON c.Modulo = @Modulo AND c.Concepto = d.Concepto
WHERE d.ID = @ID
GROUP BY d.ClavePresupuestal, c.ClavePresupuestalImpuesto1, c.ClavePresupuestalRetencion1 
ORDER BY d.ClavePresupuestal, c.ClavePresupuestalImpuesto1, c.ClavePresupuestalRetencion1 
END ELSE
IF @Modulo = 'COMS'
BEGIN
INSERT @CPD (
ClavePresupuestal,   ClavePresupuestalImpuesto1,   AfectarCP,  AplicarCP,    Aplica,   AplicaID,   Importe,          Impuesto1,             Impuesto2,             Impuesto3)
SELECT d.ClavePresupuestal, a.ClavePresupuestalImpuesto1, @AfectarCP, mt.AfectarCP, d.Aplica, d.AplicaID, SUM(d.SubTotal), SUM(d.Impuesto1Total), SUM(d.Impuesto2Total), SUM(d.Impuesto3Total)
FROM CompraTCalc d
LEFT OUTER JOIN MovTipo mt  WITH(NOLOCK) ON mt.Modulo = @Modulo AND mt.Mov = d.Aplica AND UPPER(NULLIF(RTRIM(mt.AfectarCP), '')) NOT IN (NULL, 'NO')
LEFT OUTER JOIN Art a  WITH(NOLOCK) ON a.Articulo = d.Articulo
WHERE d.ID = @ID
GROUP BY d.ClavePresupuestal, a.ClavePresupuestalImpuesto1, mt.AfectarCP, d.Aplica, d.AplicaID
ORDER BY d.ClavePresupuestal, a.ClavePresupuestalImpuesto1, mt.AfectarCP, d.Aplica, d.AplicaID
END ELSE
BEGIN
IF @Modulo = 'CXC' SELECT @CxTipoCambio = ClienteTipoCambio   FROM Cxc WHERE ID = @ID ELSE
IF @Modulo = 'CXP' SELECT @CxTipoCambio = ProveedorTipoCambio FROM Cxp WITH(NOLOCK) WHERE ID = @ID
SELECT @AplicarCP = AplicarCP
FROM MovTipo
WITH(NOLOCK) WHERE Modulo = @Modulo AND Mov = @Mov
INSERT @CPD (
ClavePresupuestal,    ClavePresupuestalImpuesto1,    AfectarCP,  AplicarCP,  Aplica, AplicaID, Importe,          Impuesto1,        Impuesto2,        Impuesto3)
SELECT mi.ClavePresupuestal, mi.ClavePresupuestalImpuesto1, @AfectarCP, @AplicarCP, m.Mov,  m.MovID,  SUM(mi.SubTotal), SUM(mi.Importe1), SUM(mi.Importe2), SUM(mi.Importe3)
FROM MovImpuesto mi
 WITH(NOLOCK) JOIN Mov m  WITH(NOLOCK) ON m.Empresa = @Empresa AND m.Modulo = mi.OrigenModulo AND m.ID = mi.OrigenModuloID
WHERE mi.Modulo = @Modulo AND mi.ModuloID = @ID
GROUP BY mi.ClavePresupuestal, mi.ClavePresupuestalImpuesto1, m.Mov, m.MovID
ORDER BY mi.ClavePresupuestal, mi.ClavePresupuestalImpuesto1, m.Mov, m.MovID
IF @Modulo = 'DIN' AND @TipoCambio = 1.0
UPDATE @CPD
SET Aplica = NULL, AplicaID = NULL
END
IF EXISTS(SELECT * FROM @CPD) AND @Ok IS NULL
BEGIN
SELECT @SepararImpuestos = ISNULL(CPSepararImpuestos, 0),
@CPImpuesto1 = NULLIF(RTRIM(CPClavePresupuestalImpuesto1), ''),
@CPImpuesto2 = NULLIF(RTRIM(CPClavePresupuestalImpuesto2), ''),
@CPImpuesto3 = NULLIF(RTRIM(CPClavePresupuestalImpuesto3), ''),
@CPRetencion1 = NULLIF(RTRIM(CPClavePresupuestalRetencion1), ''), 
@CPRetencion2 = NULLIF(RTRIM(CPClavePresupuestalRetencion2), ''), 
@CPRetencion3 = NULLIF(RTRIM(CPClavePresupuestalRetencion3), '')  
FROM EmpresaCfg
WITH(NOLOCK) WHERE Empresa = @Empresa
INSERT CP (
Sucursal,  Empresa,  Usuario,  Mov,    Moneda,      TipoCambio,      FechaEmision,  Proyecto,  UEN,  Estatus,      OrigenTipo, Origen, OrigenID)
VALUES (@Sucursal, @Empresa, @Usuario, @CPMov, @ContMoneda, @ContTipoCambio, @FechaEmision, @Proyecto, @UEN, 'SINAFECTAR', @Modulo,    @Mov,   @MovID)
SELECT @CPID = SCOPE_IDENTITY()
IF @EsAjuste = 1
SELECT @FactorCP = -@FactorCP
/* si tiene ClavePresupuestalImpuesto1 especifico a nivel articulo o concepto */
INSERT @CPD (
ClavePresupuestal,          AfectarCP, AplicarCP, Aplica, AplicaID, Importe)
SELECT ClavePresupuestalImpuesto1, AfectarCP, AplicarCP, Aplica, AplicaID, Impuesto1
FROM @CPD
WHERE NULLIF(Impuesto1, 0.0) IS NOT NULL AND ClavePresupuestalImpuesto1 IS NOT NULL
UPDATE @CPD
SET Impuesto1 = NULL
WHERE NULLIF(Impuesto1, 0.0) IS NOT NULL AND ClavePresupuestalImpuesto1 IS NOT NULL
INSERT @CPD (
ClavePresupuestal,           AfectarCP, AplicarCP, Aplica, AplicaID, Importe)
SELECT ClavePresupuestalRetencion1, AplicarCP, AfectarCP, Aplica, AplicaID, Impuesto1
FROM @CPD
WHERE NULLIF(Impuesto1, 0.0) IS NOT NULL AND NULLIF(ClavePresupuestalRetencion1,'') IS NOT NULL
UPDATE @CPD
SET Retencion1 = NULL
WHERE NULLIF(Retencion1, 0.0) IS NOT NULL AND NULLIF(ClavePresupuestalRetencion1,'') IS NOT NULL
/* ClavePresupuestalImpuesto1 */
IF @SepararImpuestos = 1
BEGIN
IF @CPImpuesto1 IS NOT NULL
INSERT @CPD (
ClavePresupuestal, AfectarCP, AplicarCP, Aplica, AplicaID, Importe)
SELECT @CPImpuesto1,      AfectarCP, AplicarCP, Aplica, AplicaID, Impuesto1
FROM @CPD
WHERE NULLIF(Impuesto1, 0.0) IS NOT NULL AND ClavePresupuestalImpuesto1 IS NULL
IF @CPImpuesto2 IS NOT NULL
INSERT @CPD (
ClavePresupuestal, AfectarCP, AplicarCP, Aplica, AplicaID, Importe)
SELECT @CPImpuesto2,      AfectarCP, AplicarCP, Aplica, AplicaID, Impuesto2
FROM @CPD
WHERE NULLIF(Impuesto2, 0.0) IS NOT NULL
IF @CPImpuesto3 IS NOT NULL
INSERT @CPD (
ClavePresupuestal, AfectarCP, AplicarCP, Aplica, AplicaID, Importe)
SELECT @CPImpuesto3,      AfectarCP, AplicarCP, Aplica, AplicaID, Impuesto3
FROM @CPD
WHERE NULLIF(Impuesto3, 0.0) IS NOT NULL
IF @CPRetencion1 IS NOT NULL
INSERT @CPD (
ClavePresupuestal, AfectarCP, AplicarCP, Aplica, AplicaID, Importe)
SELECT @CPRetencion1,     AplicarCP, AfectarCP, Aplica, AplicaID, Retencion1
FROM @CPD
WHERE NULLIF(Retencion1, 0.0) IS NOT NULL AND NULLIF(ClavePresupuestalRetencion1,'') IS NULL 
IF @CPRetencion2 IS NOT NULL
INSERT @CPD (
ClavePresupuestal, AfectarCP, AplicarCP, Aplica, AplicaID, Importe)
SELECT @CPRetencion2,     AplicarCP, AfectarCP, Aplica, AplicaID, Retencion2
FROM @CPD
WHERE NULLIF(Retencion2, 0.0) IS NOT NULL
IF @CPRetencion3 IS NOT NULL
INSERT @CPD (
ClavePresupuestal, AfectarCP, AplicarCP, Aplica, AplicaID, Importe)
SELECT @CPRetencion3,     AplicarCP, AfectarCP, Aplica, AplicaID, Retencion3
FROM @CPD
WHERE NULLIF(Retencion3, 0.0) IS NOT NULL
UPDATE @CPD
SET Impuesto1 = NULL, Impuesto2 = NULL, Impuesto3 = NULL, Retencion1 = NULL, Retencion2 = NULL, Retencion3 = NULL 
END
UPDATE @CPD
SET AplicaTipoCambio = m.TipoCambio
FROM @CPD d
JOIN Mov m  WITH(NOLOCK) ON m.Empresa = @Empresa AND m.Mov = d.Aplica AND m.MovID = d.AplicaID
UPDATE @CPD
SET Importe = Importe * @TipoCambio / @ContTipoCambio,
Impuesto1 = Impuesto1 * @TipoCambio / @ContTipoCambio,
Impuesto2 = Impuesto2 * @TipoCambio / @ContTipoCambio,
Impuesto3 = Impuesto3 * @TipoCambio / @ContTipoCambio
/*
UPDATE @CPD
SET 
Presupuesto	 = CASE WHEN AfectarCP = 'Presupuesto'     THEN ImporteTotal ELSE 0.0 END + CASE WHEN AplicarCP = 'Presupuesto'     THEN -dbo.fnR3(@TipoCambio, ImporteTotal, ISNULL(AplicaTipoCambio, 1)) ELSE 0.0 END,
Comprometido	 = CASE WHEN AfectarCP = 'Comprometido'    THEN ImporteTotal ELSE 0.0 END + CASE WHEN AplicarCP = 'Comprometido'    THEN -dbo.fnR3(@TipoCambio, ImporteTotal, ISNULL(AplicaTipoCambio, 1)) ELSE 0.0 END,
Comprometido2	 = CASE WHEN AfectarCP = 'Comprometido 2'  THEN ImporteTotal ELSE 0.0 END + CASE WHEN AplicarCP = 'Comprometido 2'  THEN -dbo.fnR3(@TipoCambio, ImporteTotal, ISNULL(AplicaTipoCambio, 1)) ELSE 0.0 END,
Devengado  	 = CASE WHEN AfectarCP = 'Devengado'       THEN ImporteTotal ELSE 0.0 END + CASE WHEN AplicarCP = 'Devengado'       THEN -dbo.fnR3(@TipoCambio, ImporteTotal, ISNULL(AplicaTipoCambio, 1)) ELSE 0.0 END,
Devengado2	         = CASE WHEN AfectarCP = 'Devengado 2'     THEN ImporteTotal ELSE 0.0 END + CASE WHEN AplicarCP = 'Devengado 2'     THEN -dbo.fnR3(@TipoCambio, ImporteTotal, ISNULL(AplicaTipoCambio, 1)) ELSE 0.0 END,
Ejercido		 = CASE WHEN AfectarCP = 'Ejercido'        THEN ImporteTotal ELSE 0.0 END + CASE WHEN AplicarCP = 'Ejercido'        THEN -dbo.fnR3(@TipoCambio, ImporteTotal, ISNULL(AplicaTipoCambio, 1)) ELSE 0.0 END,
EjercidoPagado	 = CASE WHEN AfectarCP = 'Ejercido Pagado' THEN ImporteTotal ELSE 0.0 END + CASE WHEN AplicarCP = 'Ejercido Pagado' THEN -dbo.fnR3(@TipoCambio, ImporteTotal, ISNULL(AplicaTipoCambio, 1)) ELSE 0.0 END,
RemanenteDisponible = CASE WHEN AfectarCP = 'Remanente Disp.' THEN ImporteTotal ELSE 0.0 END + CASE WHEN AplicarCP = 'Remanente Disp.' THEN -dbo.fnR3(@TipoCambio, ImporteTotal, ISNULL(AplicaTipoCambio, 1)) ELSE 0.0 END,
Sobrante		 = CASE WHEN AfectarCP = 'Sobrante'        THEN ImporteTotal ELSE 0.0 END + CASE WHEN AplicarCP = 'Sobrante'        THEN -dbo.fnR3(@TipoCambio, ImporteTotal, ISNULL(AplicaTipoCambio, 1)) ELSE 0.0 END,
Anticipos		 = CASE WHEN AfectarCP = 'Anticipos'       THEN ImporteTotal ELSE 0.0 END + CASE WHEN AplicarCP = 'Anticipos'       THEN -dbo.fnR3(@TipoCambio, ImporteTotal, ISNULL(AplicaTipoCambio, 1)) ELSE 0.0 END
*/
UPDATE @CPD
SET 
Presupuesto	 = CASE WHEN AfectarCP = 'Presupuesto'     THEN ImporteTotal END,
Comprometido	 = CASE WHEN AfectarCP = 'Comprometido'    THEN ImporteTotal END,
Comprometido2	 = CASE WHEN AfectarCP = 'Comprometido 2'  THEN ImporteTotal END,
Devengado  	 = CASE WHEN AfectarCP = 'Devengado'       THEN ImporteTotal END,
Devengado2	         = CASE WHEN AfectarCP = 'Devengado 2'     THEN ImporteTotal END,
Ejercido		 = CASE WHEN AfectarCP = 'Ejercido'        THEN ImporteTotal END,
EjercidoPagado	 = CASE WHEN AfectarCP = 'Ejercido Pagado' THEN ImporteTotal END,
RemanenteDisponible = CASE WHEN AfectarCP = 'Remanente Disp.' THEN ImporteTotal END,
Sobrante		 = CASE WHEN AfectarCP = 'Sobrante'        THEN ImporteTotal END,
Anticipos		 = CASE WHEN AfectarCP = 'Anticipos'       THEN ImporteTotal END
IF @CxTipoCambio IS NOT NULL
BEGIN
UPDATE @CPD
SET Presupuesto	 = ISNULL(Presupuesto, 0.0)		- ISNULL(CASE WHEN AplicarCP = 'Presupuesto'     THEN ImporteTotal/@CxTipoCambio*ISNULL(AplicaTipoCambio, 1) END, 0.0),
Comprometido	 = ISNULL(Comprometido, 0.0)		- ISNULL(CASE WHEN AplicarCP = 'Comprometido'    THEN ImporteTotal/@CxTipoCambio*ISNULL(AplicaTipoCambio, 1) END, 0.0),
Comprometido2	 = ISNULL(Comprometido2, 0.0)		- ISNULL(CASE WHEN AplicarCP = 'Comprometido 2'  THEN ImporteTotal/@CxTipoCambio*ISNULL(AplicaTipoCambio, 1) END, 0.0),
Devengado  	 = ISNULL(Devengado, 0.0)		- ISNULL(CASE WHEN AplicarCP = 'Devengado'       THEN ImporteTotal/@CxTipoCambio*ISNULL(AplicaTipoCambio, 1) END, 0.0),
Devengado2        = ISNULL(Devengado2, 0.0)		- ISNULL(CASE WHEN AplicarCP = 'Devengado 2'     THEN ImporteTotal/@CxTipoCambio*ISNULL(AplicaTipoCambio, 1) END, 0.0),
Ejercido		 = ISNULL(Ejercido, 0.0)		- ISNULL(CASE WHEN AplicarCP = 'Ejercido'        THEN ImporteTotal/@CxTipoCambio*ISNULL(AplicaTipoCambio, 1) END, 0.0),
EjercidoPagado	 = ISNULL(EjercidoPagado, 0.0)		- ISNULL(CASE WHEN AplicarCP = 'Ejercido Pagado' THEN ImporteTotal/@CxTipoCambio*ISNULL(AplicaTipoCambio, 1) END, 0.0),
RemanenteDisponible = ISNULL(RemanenteDisponible, 0.0)	- ISNULL(CASE WHEN AplicarCP = 'Remanente Disp.' THEN ImporteTotal/@CxTipoCambio*ISNULL(AplicaTipoCambio, 1) END, 0.0),
Sobrante		 = ISNULL(Sobrante, 0.0)		- ISNULL(CASE WHEN AplicarCP = 'Sobrante'        THEN ImporteTotal/@CxTipoCambio*ISNULL(AplicaTipoCambio, 1) END, 0.0),
Anticipos	 = ISNULL(Anticipos, 0.0)		- ISNULL(CASE WHEN AplicarCP = 'Anticipos'       THEN ImporteTotal/@CxTipoCambio*ISNULL(AplicaTipoCambio, 1) END, 0.0)
END ELSE
BEGIN
UPDATE @CPD
SET Presupuesto	 = ISNULL(Presupuesto, 0.0)		- ISNULL(CASE WHEN AplicarCP = 'Presupuesto'     THEN ImporteTotal*ISNULL(AplicaTipoCambio, 1)/@TipoCambio END, 0.0),
Comprometido	 = ISNULL(Comprometido, 0.0)		- ISNULL(CASE WHEN AplicarCP = 'Comprometido'    THEN ImporteTotal*ISNULL(AplicaTipoCambio, 1)/@TipoCambio END, 0.0),
Comprometido2	 = ISNULL(Comprometido2, 0.0)		- ISNULL(CASE WHEN AplicarCP = 'Comprometido 2'  THEN ImporteTotal*ISNULL(AplicaTipoCambio, 1)/@TipoCambio END, 0.0),
Devengado  	 = ISNULL(Devengado, 0.0)		- ISNULL(CASE WHEN AplicarCP = 'Devengado'       THEN ImporteTotal*ISNULL(AplicaTipoCambio, 1)/@TipoCambio END, 0.0),
Devengado2        = ISNULL(Devengado2, 0.0)		- ISNULL(CASE WHEN AplicarCP = 'Devengado 2'     THEN ImporteTotal*ISNULL(AplicaTipoCambio, 1)/@TipoCambio END, 0.0),
Ejercido		 = ISNULL(Ejercido, 0.0)		- ISNULL(CASE WHEN AplicarCP = 'Ejercido'        THEN ImporteTotal*ISNULL(AplicaTipoCambio, 1)/@TipoCambio END, 0.0),
EjercidoPagado	 = ISNULL(EjercidoPagado, 0.0)		- ISNULL(CASE WHEN AplicarCP = 'Ejercido Pagado' THEN ImporteTotal*ISNULL(AplicaTipoCambio, 1)/@TipoCambio END, 0.0),
RemanenteDisponible = ISNULL(RemanenteDisponible, 0.0)	- ISNULL(CASE WHEN AplicarCP = 'Remanente Disp.' THEN ImporteTotal*ISNULL(AplicaTipoCambio, 1)/@TipoCambio END, 0.0),
Sobrante		 = ISNULL(Sobrante, 0.0)		- ISNULL(CASE WHEN AplicarCP = 'Sobrante'        THEN ImporteTotal*ISNULL(AplicaTipoCambio, 1)/@TipoCambio END, 0.0),
Anticipos	 = ISNULL(Anticipos, 0.0)		- ISNULL(CASE WHEN AplicarCP = 'Anticipos'       THEN ImporteTotal*ISNULL(AplicaTipoCambio, 1)/@TipoCambio END, 0.0)
END
/*IF @AnticiposCP = 'SI'
UPDATE @CPD SET Anticipos = ImporteTotal
IF @AnticiposCP = 'DESANTICIPAR'
UPDATE @CPD SET Anticipos = -ImporteTotal*/
INSERT CPD (
ID,   Sucursal,   Renglon,      ClavePresupuestal, Aplica, AplicaID, Presupuesto,                             Comprometido,                             Comprometido2,                             Devengado,                             Devengado2,                             Ejercido,                             EjercidoPagado,                             Anticipos,                             RemanenteDisponible,                             Sobrante)
SELECT @CPID, @Sucursal, MIN(Renglon), ClavePresupuestal, Aplica, AplicaID, NULLIF(SUM(Presupuesto)*@FactorCP, 0.0), NULLIF(SUM(Comprometido)*@FactorCP, 0.0), NULLIF(SUM(Comprometido2)*@FactorCP, 0.0), NULLIF(SUM(Devengado)*@FactorCP, 0.0), NULLIF(SUM(Devengado2)*@FactorCP, 0.0), NULLIF(SUM(Ejercido)*@FactorCP, 0.0), NULLIF(SUM(EjercidoPagado)*@FactorCP, 0.0), NULLIF(SUM(Anticipos)*@FactorCP, 0.0), NULLIF(SUM(RemanenteDisponible)*@FactorCP, 0.0), NULLIF(SUM(Sobrante)*@FactorCP, 0.0)
FROM @CPD
WHERE NULLIF(RTRIM(ClavePresupuestal), '') IS NOT NULL
GROUP BY ClavePresupuestal, Aplica, AplicaID
HAVING (NULLIF(SUM(Presupuesto)*@FactorCP, 0.0) IS NOT NULL) OR (NULLIF(SUM(Comprometido)*@FactorCP, 0.0) IS NOT NULL) OR (NULLIF(SUM(Comprometido2)*@FactorCP, 0.0) IS NOT NULL) OR (NULLIF(SUM(Devengado)*@FactorCP, 0.0) IS NOT NULL) OR (NULLIF(SUM(Devengado2)*@FactorCP, 0.0) IS NOT NULL) OR (NULLIF(SUM(Ejercido)*@FactorCP, 0.0) IS NOT NULL) OR (NULLIF(SUM(EjercidoPagado)*@FactorCP, 0.0) IS NOT NULL) OR (NULLIF(SUM(Anticipos)*@FactorCP, 0.0) IS NOT NULL) OR (NULLIF(SUM(RemanenteDisponible)*@FactorCP, 0.0) IS NOT NULL) OR (NULLIF(SUM(Sobrante)*@FactorCP, 0.0) IS NOT NULL)
IF @@ERROR <> 0
SELECT @Ok = 1
IF @Ok IS NULL
EXEC spAfectar 'CP', @CPID, 'AFECTAR', @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
BEGIN
SELECT @CPMovID = MovID FROM CP WITH(NOLOCK) WHERE ID = @CPID
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @Modulo, @ID, @Mov, @MovID, 'CP', @CPID, @CPMov, @CPMovID, @Ok OUTPUT
END
END
END
RETURN
END

