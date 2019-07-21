SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionProcesar
@Estacion		int,
@Empresa		varchar(5),
@FechaD			datetime,
@FechaA			datetime

AS
BEGIN
DECLARE @RID					int,
@RIDAnt				int,
@ImportePago			float,
@Aplica				varchar(20),
@AplicaID				varchar(20),
@Importe				float,
@Mov					varchar(20),
@MovID				varchar(20),
@Factor				float,
@FechaPago			datetime,
@Signo				int,
@Dinero				varchar(20),
@DineroID				varchar(20),
@IDPago				int,
@ModuloPago			varchar(5),
@EsRetencion			bit,
@EsIEPS				bit,
@Ejercicio			int,
@Periodo				int
SELECT @RIDAnt = 0
WHILE(1=1)
BEGIN
SELECT @RID = MIN(RID)
FROM #Pagos
WHERE RID > @RIDAnt
IF @RID IS NULL BREAK
SELECT @RIDAnt = @RID
SELECT @Aplica = NULL, @AplicaID = NULL, @Importe = NULL, @ImportePago = NULL, @Factor = NULL, @FechaPago = NULL, @Dinero =	NULL, @DineroID = NULL, @IDPago = NULL, @ModuloPago = NULL,
@Ejercicio = NULL, @Periodo = NULL
SELECT @Aplica = Aplica,
@AplicaID = AplicaID,
@ImportePago = ISNULL(Importe, 0),
@Mov = Mov,
@MovID = MovID,
@FechaPago = FechaEmision,
@Dinero = Dinero,
@DineroID = DineroID,
@IDPago = ID,
@ModuloPago = Modulo,
@EsRetencion = ISNULL(EsRetencion, 0),
@EsIEPS = ISNULL(EsIEPS, 0),
@Ejercicio = Ejercicio,
@Periodo	= Periodo
FROM #Pagos
WHERE RID = @RID
IF EXISTS(SELECT * FROM #Documentos WHERE Empresa = @Empresa AND Mov = @Aplica AND MovID = @AplicaID AND Pago = @Mov AND PagoID = @MovID AND ISNULL(EsRetencion, 0) = 1)
OR EXISTS(SELECT * FROM #Documentos WHERE Empresa = @Empresa AND Mov = @Aplica AND MovID = @AplicaID AND Pago = @Mov AND PagoID = @MovID AND ISNULL(EsComplemento, 0) = 1)
OR EXISTS(SELECT * FROM #Documentos WHERE Empresa = @Empresa AND Mov = @Aplica AND MovID = @AplicaID AND Pago = @Mov AND PagoID = @MovID AND ISNULL(EsIEPS, 0) = 1)
BEGIN
IF @EsRetencion = 0
SELECT @Importe = SUM(NULLIF(ISNULL(Importe,0.0) + ISNULL(IVA,0.0) + ISNULL(IEPS,0.0) + ISNULL(ISAN,0.0) - ISNULL(Retencion1,0.0) - ISNULL(Retencion2,0.0), 0))
FROM #Documentos
WHERE Empresa = @Empresa
AND Mov = @Aplica
AND MovID = @AplicaID
AND Pago = @Mov
AND PagoID = @MovID
AND ISNULL(EsRetencion, 0) = @EsRetencion
AND ISNULL(EsIEPS, 0) = @EsIEPS
ELSE
BEGIN
SELECT @ImportePago = SUM(ISNULL(Importe, 0))
FROM #Pagos
WHERE Modulo = @ModuloPago
AND ID = @IDPago
SELECT @Importe = SUM(NULLIF(ISNULL(Retencion1,0.0) + ISNULL(Retencion2,0.0), 0))
FROM #Documentos
WHERE Empresa = @Empresa
AND Pago = @Mov
AND PagoID = @MovID
AND ISNULL(EsRetencion, 0) = @EsRetencion
AND ISNULL(EsIEPS, 0) = @EsIEPS
END
SELECT @Factor = ROUND(@ImportePago / NULLIF(@Importe, 0), 3)
INSERT INTO CFDIRetencionD(
Modulo,
EstacionTrabajo,
Empresa,
Mov,
MovID,
Pago,
PagoID,
Proveedor,
Tasa,
FechaEmision,
FechaPago,
Ejercicio,
Periodo,
Concepto,
ConceptoClave,
ConceptoSAT,
Factor,
Importe,
IVA,
IEPS,
Retencion2,
Retencion1,
DineroMov,
DineroMovID,
ImportePago,
Sucursal,
ModuloID,
IDPago,
ModuloPago,
TipoTercero,
PorcentajeDeducible,
EsComplemento,
EsRetencion,
EsIEPS)
SELECT Modulo,
@Estacion,
Empresa,
Mov,
MovID,
Pago,
PagoID,
Proveedor,
Tasa,
FechaEmision,
@FechaPago,
@Ejercicio,
@Periodo,
Concepto,
ConceptoClave,
ConceptoSAT,
@Factor,
CASE @EsRetencion WHEN 0 THEN ISNULL(SUM(Importe),0) ELSE ISNULL(Importe,0) END,
CASE @EsRetencion WHEN 0 THEN ISNULL(SUM(IVA),0) ELSE ISNULL(IVA,0) END,
CASE @EsRetencion WHEN 0 THEN ISNULL(SUM(IEPS),0) ELSE ISNULL(IEPS,0) END,
CASE @EsIEPS WHEN 1 THEN 0 ELSE ISNULL(SUM(Retencion2),0) END,
CASE @EsIEPS WHEN 1 THEN 0 ELSE ISNULL(SUM(Retencion1),0) END,
@Dinero,
@DineroID,
@ImportePago,
Sucursal,
ModuloID,
@IDPago,
@ModuloPago,
dbo.fnCFDIRetTipoTercero(Proveedor),
PorcentajeDeducible,
ISNULL(EsComplemento, 0),
ISNULL(EsRetencion, 0),
ISNULL(EsIEPS, 0)
FROM #Documentos
WHERE Empresa = @Empresa AND Mov = @Aplica AND MovID = @AplicaID AND Pago = @Mov AND PagoID = @MovID
GROUP BY Modulo, Empresa, Mov, MovID, Pago, PagoID, Proveedor, Tasa, FechaEmision, /*Ejercicio, Periodo, */Concepto, ConceptoClave, ConceptoSAT, Sucursal, ModuloID, PorcentajeDeducible, EsComplemento, EsRetencion, EsIEPS,
Importe, IVA, IEPS
END
IF (SELECT COUNT(Concepto) FROM GastoD WITH (NOLOCK) WHERE id = (SELECT MAX(ModuloID) FROM CFDIRetencionD WITH (NOLOCK)  WHERE EstacionTrabajo = @Estacion) AND Timbrado <> 1 ) > 0
DELETE FROM CFDIRetencionD WHERE ModuloID = (SELECT MAX(ModuloID) FROM CFDIRetencionD WITH (NOLOCK) WHERE EstacionTrabajo = @Estacion) AND Concepto IN
(SELECT Concepto FROM GastoD WITH (NOLOCK) WHERE ID = (SELECT MAX(ModuloID) FROM CFDIRetencionD WITH (NOLOCK) WHERE EstacionTrabajo = @Estacion) AND Timbrado = 1)
END
EXEC spCFDIRetencionRecalcEncabezado @Estacion
END

