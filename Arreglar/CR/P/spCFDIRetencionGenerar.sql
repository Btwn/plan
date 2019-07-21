SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionGenerar
@Estacion			int,
@Empresa			varchar(5),
@Sucursal			int,
@Usuario			varchar(10),
@Proveedor			varchar(10),
@ConceptoSAT		varchar(2),
@IDMov	            varchar(20),
@MovTimbrado		varchar(20),
@Concepto			varchar(50),
@CxID				int				OUTPUT,
@montoTotExent		float			OUTPUT,
@montoTotGrav		float			OUTPUT,
@montoTotOperacion	float			OUTPUT,
@montoTotRet		float			OUTPUT,
@Ejerc				int				OUTPUT,
@MesIni				int				OUTPUT,
@MesFin				int				OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS
BEGIN
DECLARE @FechaEmision			datetime,
@Moneda				varchar(10),
@Mov					varchar(20),
@MovID				varchar(20),
@Importe				float,
@Modulo	            varchar(5),
@ModuloID	            int,
@RetencionISR         money,
@RetencionIVA         money,
@RetmontoTotGrav      money,
@RetmontoTotExent     money,
@ImporteGasto         money,
@AgruparConceptoSAT   bit
CREATE TABLE #CxpD(
RID			int			IDENTITY,
Importe		float		NULL,
Aplica		varchar(20)	COLLATE Database_Default	NULL,
AplicaID	varchar(20)	COLLATE Database_Default	NULL
)
SELECT @Moneda = ContMoneda FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @FechaEmision = GETDATE()
EXEC spExtraerFecha @FechaEmision OUTPUT
SELECT @AgruparConceptoSAT = ISNULL(AgruparConceptoSATRetenciones,0) FROM EmpresaCfg2 WHERE Empresa = @Empresa
IF @AgruparConceptoSAT  = 1
BEGIN
INSERT INTO #CxpD(
Importe,                                     Aplica, AplicaID)
SELECT SUM(Importe+IVA+IEPS-Retencion1-Retencion2), Mov,    MovID
FROM CFDIRetencion
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
AND MovID = @IDMov
GROUP BY Mov, MovID
SELECT @Importe = Importe FROM #CxpD WHERE AplicaID = @IDMov
END
ELSE
BEGIN
INSERT INTO #CxpD(
Importe,                                     Aplica, AplicaID)
SELECT SUM(Importe+IVA+IEPS-Retencion1-Retencion2), Mov,    MovID
FROM CFDIRetencion
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
GROUP BY Mov, MovID
SELECT @Importe = SUM(Importe) FROM #CxpD
END
INSERT INTO Cxp(
Empresa,  Mov,          FechaEmision,  Moneda, TipoCambio,  Usuario, Estatus,       Proveedor, FormaPago, AplicaManual,  Sucursal,  ProveedorMoneda, ProveedorTipoCambio,  Concepto,  Importe)
SELECT @Empresa, @MovTimbrado, @FechaEmision, @Moneda, 1,          @Usuario, 'SINAFECTAR', @Proveedor, NULL,      1,            @Sucursal, @Moneda,          1,                   @Concepto, @Importe
SELECT @CxID = SCOPE_IDENTITY()
INSERT INTO CxpD(
ID,   Renglon,  Importe, Aplica, AplicaID)
SELECT @CxID, RID*2048, Importe, Aplica, AplicaID
FROM #CxpD
IF @CxID IS NOT NULL
EXEC spAfectar 'CXP', @CxID, 'AFECTAR', @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
BEGIN TRAN
SELECT @Mov = Mov, @MovID = MovID FROM Cxp WHERE ID = @CxID
IF(SELECT ISNULL(PeriodosEspecificos, 0) FROM CFDIRetencionCfg) = 0
BEGIN
SELECT @Ejerc = YEAR(FechaEmision)
FROM CFDIRetencionD
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
IF @AgruparConceptoSAT  = 1
SELECT @MesIni = MIN(Periodo),
@MesFin = MAX(Periodo),
@montoTotOperacion = SUM(NULLIF(ISNULL(Importe,0.0) /*+ ISNULL(IVA,0.0) + ISNULL(IEPS,0.0) - ISNULL(Retencion1,0.0) - ISNULL(Retencion2,0.0)*/, 0))
FROM CFDIRetencionCalcTmp
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
AND MovID = @IDMov
ELSE
SELECT @MesIni = MIN(Periodo),
@MesFin = MAX(Periodo),
/*@MesIni = MIN(MONTH(FechaEmision)),
@MesFin = MAX(MONTH(FechaEmision)),*/
@montoTotOperacion = SUM(NULLIF(ISNULL(Importe,0.0) /*+ ISNULL(IVA,0.0) + ISNULL(IEPS,0.0) - ISNULL(Retencion1,0.0) - ISNULL(Retencion2,0.0)*/, 0))
FROM CFDIRetencionCalcTmp
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
END
ELSE
BEGIN
SELECT @Ejerc = Ejerc, @MesIni = MesIni, @MesFin = MesFin FROM CFDIRetencionCfg
IF @AgruparConceptoSAT  = 1
SELECT @montoTotOperacion = NULLIF(ISNULL(Importe,0.0),0)/* + ISNULL(IVA,0.0) + ISNULL(IEPS,0.0) , 0)*/
FROM CFDIRetencionCalcTmp
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
AND MovID = @IDMov
ELSE
SELECT @montoTotOperacion = SUM(NULLIF(ISNULL(Importe,0.0) /*+ ISNULL(IVA,0.0) + ISNULL(IEPS,0.0) - ISNULL(Retencion1,0.0) - ISNULL(Retencion2,0.0)*/, 0))
FROM CFDIRetencionCalcTmp
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
END
IF EXISTS(SELECT * FROM CFDIRetSATRetencion WHERE Clave LIKE @ConceptoSAT AND COMPLEMENTO IS NOT NULL) AND @ConceptoSAT IN ('14', '18') 
SELECT DISTINCT @montoTotGrav = RG.Gravado, @montoTotExent = RG.Exento
FROM CFDIRetGastoComplemento RG, CFDIRetencionD RD
WHERE RG.ID = RD.ModuloID AND RD.Proveedor LIKE @Proveedor AND RD.EstacionTrabajo = @Estacion AND RD.ConceptoSAT LIKE @ConceptoSAT AND RD.Empresa LIKE @Empresa
ELSE
IF EXISTS(SELECT COUNT(*) FROM CFDIRetSATRetencion WHERE Clave LIKE @ConceptoSAT AND COMPLEMENTO IS NOT NULL) AND @ConceptoSAT IN ('06','07','08','09','19') 
SELECT DISTINCT @montoTotGrav = EGC.Gravado, @montoTotExent = EGC.Exento
FROM CFDIEnajenacionGastoComplemento EGC, CFDIRetencionD RD
WHERE EGC.ID = RD.ModuloID AND RD.Proveedor LIKE @Proveedor AND RD.EstacionTrabajo = @Estacion AND RD.ConceptoSAT LIKE @ConceptoSAT AND RD.Empresa LIKE @Empresa
ELSE
IF EXISTS(SELECT * FROM CFDIRetSATRetencion WHERE Clave LIKE @ConceptoSAT AND COMPLEMENTO IS NOT NULL) AND @ConceptoSAT IN ('16') 
SELECT DISTINCT @montoTotGrav = RSI.Gravado, @montoTotExent = RSI.Exento
FROM CFDIRetSATIntereses RSI, CFDIRetencionD RD
WHERE RSI.ID = RD.ModuloID AND RD.Proveedor LIKE @Proveedor AND RD.EstacionTrabajo = @Estacion AND RD.ConceptoSAT LIKE @ConceptoSAT AND RD.Empresa LIKE @Empresa
ELSE
IF EXISTS(SELECT * FROM CFDIRetSATRetencion WHERE Clave LIKE @ConceptoSAT AND Complemento IS NULL)
SELECT DISTINCT @montoTotGrav = RG.Gravado, @montoTotExent = RG.Exento
FROM CFDIRetGastoComplemento RG, CFDIRetencionD RD
WHERE RG.ID = RD.ModuloID AND RD.Proveedor LIKE @Proveedor AND RD.EstacionTrabajo = @Estacion AND RD.ConceptoSAT LIKE @ConceptoSAT AND RD.Empresa LIKE @Empresa
IF @AgruparConceptoSAT  = 1
SELECT @montoTotRet = SUM(NULLIF(ISNULL(IEPS,0.0) + ISNULL(Retencion1,0.0) + ISNULL(Retencion2,0.0), 0))
FROM CFDIRetencionCalcTmp
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
AND MovID = @IDMov
ELSE
SELECT @montoTotRet = SUM(NULLIF(ISNULL(IEPS,0.0) + ISNULL(Retencion1,0.0) + ISNULL(Retencion2,0.0), 0))
FROM CFDIRetencionCalcTmp
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
UPDATE CFDIRetencionD
SET 
FolioInt          = RTRIM(@MovID),
Ejerc	         = @Ejerc,
MesIni	         = @MesIni,
MesFin	         = @MesFin,
montoTotOperacion = @montoTotOperacion,
montoTotExent     = @montoTotExent,
montoTotGrav      = @montoTotGrav,
montoTotRet       = @montoTotRet
FROM CFDIRetencionD
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
SELECT @montoTotRet = 0.0, @montoTotGrav = 0.0, @montoTotExent = 0.0, @montoTotOperacion = 0.0
IF @AgruparConceptoSAT  = 1
DECLARE crArtInv CURSOR FOR
SELECT Modulo, ModuloID
FROM CFDIRetencionCalcTmp
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
AND MovID = @IDMov
ELSE
DECLARE crArtInv CURSOR FOR
SELECT Modulo, ModuloID
FROM CFDIRetencionCalcTmp
WHERE Proveedor = @Proveedor
AND EstacionTrabajo = @Estacion
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
OPEN crArtInv
FETCH NEXT FROM crArtInv INTO @Modulo, @ModuloID
WHILE @@FETCH_STATUS = 0
BEGIN
IF @Modulo = 'GAS'
BEGIN
IF (SELECT COUNT(Concepto) FROM GastoD WHERE ID = @ModuloID
AND Concepto IN(Select Concepto From CFDIRetencionConcepto Where Modulo = 'GAS' AND CFDIRetClave = @ConceptoSAT)) > 2
SELECT @Ok = 1
IF @OK <> 1
BEGIN
SELECT @RetmontoTotGrav = ISNULL(RetmontoTotGrav,0.00),
@RetmontoTotExent = ISNULL(RetmontoTotExent,0.00)
FROM CFDIRetSATRetencion
WHERE CLAVE = @ConceptoSAT
IF @AgruparConceptoSAT  = 1
SELECT @ImporteGasto = ISNULL(SUM(GD.Importe),0.00),
@RetencionISR = ISNULL(SUM(GD.Retencion),0.00),
@RetencionIVA = ISNULL(SUM(GD.Retencion2),0.00)
FROM GastoD GD
JOIN Gasto G ON GD.ID = G.ID
WHERE G.ID = @ModuloID
AND GD.Concepto in (Select Concepto From CFDIRetencionConcepto Where Modulo = 'GAS' AND CFDIRetClave = @ConceptoSAT)
ELSE
SELECT @ImporteGasto = ISNULL(SUM(GD.Importe),0.00),
@RetencionISR = ISNULL(SUM(GD.Retencion),0.00),
@RetencionIVA = ISNULL(SUM(GD.Retencion2),0.00)
FROM GastoD GD
JOIN Gasto G ON GD.ID = G.ID
WHERE G.ID = @ModuloID
AND GD.Concepto in (Select Concepto From CFDIRetencionConcepto Where Modulo = 'GAS' AND CFDIRetClave = @ConceptoSAT)
GROUP BY GD.Concepto
SELECT @montoTotRet = @montoTotRet + @RetencionISR + @RetencionIVA
SELECT @montoTotGrav = @montoTotGrav + (@ImporteGasto*@RetmontoTotGrav)/100
SELECT @montoTotExent = @montoTotExent + (@ImporteGasto*@RetmontoTotExent)/100
SELECT @montoTotOperacion = @montoTotOperacion + @ImporteGasto
UPDATE CFDIRetencionD
SET montoTotOperacion = @montoTotOperacion,
montoTotGrav      = @montoTotGrav,
montoTotExent     = @montoTotExent,
montoTotRet       = @montoTotRet
WHERE Proveedor       = @Proveedor
AND EstacionTrabajo = @Estacion
AND ConceptoSAT     = @ConceptoSAT
AND Empresa         = @Empresa
END
END
SELECT @OK = NULL
FETCH NEXT FROM crArtInv INTO @Modulo, @ModuloID
END
CLOSE crArtInv
DEALLOCATE crArtInv
IF @Ok = 1
ROLLBACK TRAN
ELSE
COMMIT TRAN
END
ELSE
SELECT @CxID = NULL
END

