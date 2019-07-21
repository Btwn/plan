SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spDIOTProcesar
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
@Signo				int
SELECT @RIDAnt = 0
WHILE(1=1)
BEGIN
SELECT @RID = MIN(RID)
FROM #Pagos
WHERE RID > @RIDAnt
IF @RID IS NULL BREAK
SELECT @RIDAnt = @RID
SELECT @Aplica = NULL, @AplicaID = NULL, @Importe = NULL, @ImportePago = NULL, @Factor = NULL, @FechaPago = NULL
SELECT @Aplica = Aplica, @AplicaID = AplicaID, @ImportePago = ISNULL(Importe, 0), @Mov = Mov, @MovID = MovID, @FechaPago = FechaEmision FROM #Pagos WHERE RID = @RID
SELECT @Importe = SUM(CASE ISNULL(BaseIVAImportacion,0.0) WHEN -1 THEN ISNULL(IVA,0.0) ELSE NULLIF(ISNULL(Importe,0.0) + ISNULL(IVA,0.0) + ISNULL(IEPS,0.0) + ISNULL(ISAN,0.0) - ISNULL(Retencion1,0.0) - ISNULL(Retencion2,0.0) - ISNULL(BaseIVAImportacion,0.0) /*- ISNULL(Retencion3,0.0)*/, 0) END)
FROM #Documentos
WHERE Empresa = @Empresa
AND Mov = @Aplica
AND MovID = @AplicaID
AND Pago = @Mov
AND PagoID = @MovID
SELECT @Factor = @ImportePago / NULLIF(@Importe, 0)
INSERT INTO DIOTD(
EstacionTrabajo, Empresa, Mov, MovID, Pago, PagoID, Proveedor, Nombre, RFC, TipoOperacion, Tasa, TipoDocumento, TipoTercero, Pais, Nacionalidad, FechaEmision,  FechaPago, Ejercicio, Periodo, EsImportacion, EsExcento, Concepto, ConceptoClave, Factor,
Importe,
IVA,
Retencion2, ImportadorRegistro, BaseIVAImportacion, DineroMov, DineroMovID, PorcentajeDeducible,
DineroMov2, DineroMovID2, DineroImporte, DineroFormaPago, ContID, ContMov, ContMovID)
SELECT @Estacion, Empresa, Mov, MovID, Pago, PagoID, Proveedor, Nombre, RFC, TipoOperacion, Tasa, TipoDocumento, TipoTercero, Pais, Nacionalidad, FechaEmision, @FechaPago, Ejercicio, Periodo, EsImportacion, EsExcento, Concepto, ConceptoClave, @Factor,
ISNULL(SUM(BaseIVA)*@Factor,0),
CASE TipoOperacion
WHEN 2 THEN ISNULL(SUM(IVA)*@Factor,0)
WHEN 3 THEN ISNULL(SUM(IVA)*@Factor,0)
ELSE        ISNULL(SUM(Importe*(Tasa/100.0))*@Factor,0)
END,
ISNULL(SUM(Retencion2)*@Factor,0),
ImportadorRegistro, SUM(BaseIVAImportacion), DineroMov, DineroMovID, PorcentajeDeducible,
DineroMov2, DineroMovID2, DineroImporte, DineroFormaPago, ContID, ContMov, ContMovID
FROM #Documentos
WHERE Empresa = @Empresa AND Mov = @Aplica AND MovID = @AplicaID AND Pago = @Mov AND PagoID = @MovID
GROUP BY Empresa, Mov, MovID, Pago, PagoID, Proveedor, Nombre, RFC, Tasa, TipoDocumento, TipoTercero, Pais,
Nacionalidad, FechaEmision, Ejercicio, Periodo, EsImportacion, EsExcento, Concepto, ConceptoClave,
TipoOperacion, ImportadorRegistro, DineroMov, DineroMovID, PorcentajeDeducible,
DineroMov2, DineroMovID2, DineroImporte, DineroFormaPago, ContID, ContMov, ContMovID
END
UPDATE DIOTD
SET Importe = Importe*-1,
IVA = IVA*-1,
Retencion2 = Retencion2*-1
FROM DIOTD
JOIN DIOTIVARubro ON DIOTD.TipoOperacion = DIOTIVARubro.Rubro
WHERE EstacionTrabajo = @Estacion
AND DIOTIVARubro.Signo = 'Negativo'
INSERT INTO DIOT(
EstacionTrabajo, Rubro,         Descripcion, Importe,      IVA)
SELECT @Estacion,        TipoOperacion, Descripcion, SUM(Importe), SUM(IVA)
FROM DIOTIVARubro
JOIN DIOTD ON DIOTIVARubro.Rubro = DIOTD.TipoOperacion
WHERE EstacionTrabajo = @Estacion
GROUP BY TipoOperacion, Descripcion
INSERT INTO DIOT(
EstacionTrabajo, Rubro, Descripcion, Importe, IVA)
SELECT @Estacion,        Rubro, Descripcion, 0,       0
FROM DIOTIVARubro
WHERE Rubro NOT IN(SELECT Rubro FROM DIOT WHERE EstacionTrabajo = @Estacion)
END

