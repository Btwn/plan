SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spConciliacionCalc
@ID               		int

AS BEGIN
DECLARE
@Empresa			char(5),
@Sucursal			int,
@MovTipo			varchar(20),
@Fecha			datetime,
@FechaD			datetime,
@FechaA			datetime,
@Concepto			varchar(50),
@Referencia			varchar(50),
@Cargo			money,
@Abono			money,
@TipoMovimiento		varchar(50),
@CtaDinero			varchar(10),
@Cuenta			varchar(20),
@Institucion		varchar(20),
@Auxiliar			int,
@AuxiliarFecha		datetime,
@ContID			int,
@ContD			int,
@CfgTolerancia		int,
@CfgGastosAuto		bit,
@CfgConceptoFijo		varchar(50),
@CfgDiasCargos		int,
@CfgDiasAbonos		int,
@CfgImportesLejanos		bit,
@Modulo			char(5),
@ModuloID			int,
@Manual			int,
@InstitucionConcepto	varchar(50),
@InstitucionAcreedor	varchar(10),
@ConceptoGasto		varchar(50),
@CtaDineroAcreedor		varchar(10),
@Acreedor			varchar(10),
@ObligacionFiscal		varchar(50),
@ObligacionFiscal2		varchar(50),
@Tasa			float,
@TipoImporte		varchar(20),
@UltimaConciliacion		datetime,
@UltimaConciliacionID	int,
@CfgNoSugerirImportesDup	bit,
@CfgSugerirDespuesPeriodo	bit,
@Cont			bit,
@ConteoBanco		int,
@ConteoEmpresa		int,
@ReferenciaBancaria		varchar(50),
@RID                int
DECLARE @ConciliaD TABLE(
ORDEN         int IDENTITY (1,1),
RID           int NULL,
Fecha         datetime NULL,
Concepto      varchar(50)NULL,
Referencia    varchar(50)NULL,
Abono         money NULL,
Cargo         money NULL,
Manual        int NULL)
SELECT @Empresa = e.Empresa, @Sucursal = e.Sucursal, @MovTipo = mt.Clave, @CtaDinero = e.CtaDinero, @Institucion = cta.Institucion, @Cuenta = NULLIF(RTRIM(cta.Cuenta), ''), @CtaDineroAcreedor = NULLIF(RTRIM(cta.Acreedor), ''),
@FechaD = e.FechaD, @FechaA = e.FechaA
FROM Conciliacion e
JOIN CtaDinero cta ON cta.CtaDinero = e.CtaDinero
JOIN MovTipo mt ON mt.Modulo = 'CONC' AND mt.Mov = e.Mov
WHERE e.ID = @ID
SELECT @CfgTolerancia   = ISNULL(ConcToleranciaDec, 2),
@CfgGastosAuto   = ISNULL(ConcGastosAuto, 0),
@CfgConceptoFijo = NULLIF(RTRIM(ConcGastosAutoConceptoFijo), ''),
@CfgDiasCargos   = NULLIF(ConcDiasCargos, 0),
@CfgDiasAbonos   = NULLIF(ConcDiasAbonos, 0),
@CfgImportesLejanos = ISNULL(ConcImportesLejanos, 0),
@CfgNoSugerirImportesDup = ISNULL(ConcNoSugerirImportesDup, 0),
@CfgSugerirDespuesPeriodo = ISNULL(ConcSugerirDespuesPeriodo, 0)
FROM EmpresaCfg2
WHERE Empresa = @Empresa
IF NOT EXISTS(SELECT * FROM ConciliacionD WHERE ID = @ID AND Seccion = 1)
BEGIN
EXEC spConciliacionUltima @Empresa, @CtaDinero, @UltimaConciliacion OUTPUT, @UltimaConciliacionID OUTPUT
IF @UltimaConciliacionID IS NOT NULL
INSERT ConciliacionD (
ID,  Sucursal,  Fecha, Concepto, Referencia, Cargo, Abono, Observaciones, Seccion)
SELECT @ID, @Sucursal, Fecha, Concepto, Referencia, Cargo, Abono, Observaciones, 1
FROM ConciliacionD
WHERE ID = @UltimaConciliacionID AND Seccion IN (0, 1) AND Auxiliar IS NULL
END
UPDATE ConciliacionD
SET TipoMovimiento = NULL, Auxiliar = NULL, ContD = NULL, ConceptoGasto = NULL, Acreedor = NULL, ObligacionFiscal = NULL, ObligacionFiscal2 = NULL, Tasa = NULL, TipoImporte = NULL
WHERE ID = @ID
INSERT @ConciliaD(RID, Fecha, Concepto, Referencia, Abono, Cargo, Manual)
SELECT RID, Fecha, Concepto, NULLIF(RTRIM(Referencia), ''), ROUND(ISNULL(Abono, 0.0), @CfgTolerancia), ROUND(ISNULL(Cargo, 0.0), @CfgTolerancia), NULLIF(Manual, 0)
FROM ConciliacionD
WHERE ID = @ID
ORDER BY Referencia DESC
DECLARE crConciliacionD CURSOR LOCAL READ_ONLY FAST_FORWARD FOR
SELECT RID, Fecha, Concepto, NULLIF(RTRIM(Referencia), ''), ROUND(ISNULL(Abono, 0.0), @CfgTolerancia), ROUND(ISNULL(Cargo, 0.0), @CfgTolerancia), NULLIF(Manual, 0)
FROM @ConciliaD
OPEN crConciliacionD
FETCH NEXT FROM crConciliacionD INTO @RID, @Fecha, @Concepto, @Referencia, @Cargo, @Abono, @Manual
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @TipoMovimiento = NULL, @Auxiliar = NULL, @ContD = NULL, @ConceptoGasto = NULL, @Acreedor = NULL
IF @TipoMovimiento IS NULL AND @Auxiliar IS NULL AND @Referencia IS NOT NULL
EXEC spConciliacionBuscarReferencia @Empresa, @Fecha, @Referencia, @TipoMovimiento = @TipoMovimiento OUTPUT
IF @TipoMovimiento IS NULL
EXEC spInstitucionFinConcepto @Institucion, @Concepto, @TipoMovimiento = @TipoMovimiento OUTPUT, @ConceptoGasto = @InstitucionConcepto OUTPUT, @Acreedor = @InstitucionAcreedor OUTPUT, @ObligacionFiscal = @ObligacionFiscal OUTPUT, @ObligacionFiscal2 = @ObligacionFiscal2 OUTPUT, @Tasa = @Tasa OUTPUT, @TipoImporte = @TipoImporte OUTPUT, @ReferenciaBancaria = @ReferenciaBancaria OUTPUT
IF @CfgGastosAuto = 1 AND @TipoMovimiento IS NULL
BEGIN
SELECT @TipoMovimiento = 'Gasto'
SELECT @ConceptoGasto = ISNULL(@CfgConceptoFijo, @Concepto)
END
IF @Manual IS NOT NULL
BEGIN
IF @TipoMovimiento IS NULL SELECT @TipoMovimiento = 'Tesoreria'
SELECT @Auxiliar = a.ID
FROM Auxiliar a
JOIN Dinero d ON d.ID = a.ModuloID AND d.Estatus IN ('PENDIENTE', 'CONCLUIDO', 'CONCILIADO')
WHERE a.Empresa = @Empresa
AND a.Rama = 'DIN' AND a.Modulo = 'DIN'
AND a.Cuenta = @CtaDinero
AND a.Conciliado = 0
AND ROUND(ISNULL(a.Cargo, 0.0), @CfgTolerancia) = @Cargo
AND ROUND(ISNULL(a.Abono, 0.0), @CfgTolerancia) = @Abono
AND a.ID = @Manual
END
IF @TipoMovimiento = 'Tesoreria' AND @Manual IS NULL
BEGIN
IF @ReferenciaBancaria IS NOT NULL
SELECT @Auxiliar = MIN(a.ID)
FROM Auxiliar a
JOIN Dinero d ON d.ID = a.ModuloID AND d.Estatus IN ('PENDIENTE', 'CONCLUIDO', 'CONCILIADO')
JOIN Cte c ON c.Cliente = d.Contacto AND d.ContactoTipo = 'Cliente'
WHERE a.Empresa = @Empresa
AND a.Rama = 'DIN' AND a.Modulo = 'DIN'
AND a.Cuenta = @CtaDinero
AND a.Conciliado = 0
AND (@CfgSugerirDespuesPeriodo = 1 OR a.Fecha <= @FechaA)
AND ROUND(ISNULL(a.Cargo, 0.0), @CfgTolerancia) = @Cargo
AND ROUND(ISNULL(a.Abono, 0.0), @CfgTolerancia) = @Abono
AND a.ID NOT IN (SELECT Auxiliar FROM ConciliacionD WHERE ID = @ID AND Auxiliar IS NOT NULL)
AND c.ReferenciaBancaria = @ReferenciaBancaria
IF @Auxiliar IS NULL AND @Referencia IS NOT NULL
SELECT @Auxiliar = MIN(a.ID)
FROM Auxiliar a
JOIN Dinero d ON d.ID = a.ModuloID AND d.Estatus IN ('PENDIENTE', 'CONCLUIDO', 'CONCILIADO')
WHERE a.Empresa = @Empresa
AND a.Rama = 'DIN' AND a.Modulo = 'DIN'
AND a.Cuenta = @CtaDinero
AND a.Conciliado = 0
AND (@CfgSugerirDespuesPeriodo = 1 OR a.Fecha <= @FechaA)
AND ROUND(ISNULL(a.Cargo, 0.0), @CfgTolerancia) = @Cargo
AND ROUND(ISNULL(a.Abono, 0.0), @CfgTolerancia) = @Abono
AND a.ID NOT IN (SELECT Auxiliar FROM ConciliacionD WHERE ID = @ID AND Auxiliar IS NOT NULL)
AND (a.MovID = @Referencia OR d.Referencia = @Referencia)
IF @Auxiliar IS NULL
BEGIN
SELECT @Cont = 1
IF @CfgNoSugerirImportesDup = 1
BEGIN
SELECT @ConteoBanco = COUNT(*)
FROM ConciliacionD
WHERE ID = @ID
AND ROUND(ISNULL(Cargo, 0.0), @CfgTolerancia) = @Abono
AND ROUND(ISNULL(Abono, 0.0), @CfgTolerancia) = @Cargo
SELECT @ConteoEmpresa = COUNT(*)
FROM Auxiliar a
JOIN Dinero d ON d.ID = a.ModuloID AND d.Estatus IN ('PENDIENTE', 'CONCLUIDO', 'CONCILIADO')
WHERE a.Empresa = @Empresa
AND a.Rama = 'DIN' AND a.Modulo = 'DIN'
AND a.Cuenta = @CtaDinero
AND a.Conciliado = 0
AND (@CfgSugerirDespuesPeriodo = 1 OR a.Fecha <= @FechaA)
AND ROUND(ISNULL(a.Cargo, 0.0), @CfgTolerancia) = @Cargo
AND ROUND(ISNULL(a.Abono, 0.0), @CfgTolerancia) = @Abono
AND a.ID NOT IN (SELECT Auxiliar FROM ConciliacionD WHERE ID = @ID AND Auxiliar IS NOT NULL)
IF @ConteoBanco > 1 OR @ConteoEmpresa > 1 SELECT @Cont = 0
END
IF @Cont = 1 AND @TipoMovimiento = 'Tesoreria'
BEGIN
IF @Auxiliar IS NULL AND @CfgDiasAbonos IS NOT NULL AND @Cargo <> 0.0
BEGIN
SELECT @AuxiliarFecha = NULL
SELECT @AuxiliarFecha = MIN(a.Fecha)
FROM Auxiliar a
JOIN Dinero d ON d.ID = a.ModuloID AND d.Estatus IN ('PENDIENTE', 'CONCLUIDO', 'CONCILIADO')
WHERE a.Empresa = @Empresa
AND a.Rama = 'DIN' AND a.Modulo = 'DIN'
AND a.Cuenta = @CtaDinero
AND a.Conciliado = 0
AND (@CfgSugerirDespuesPeriodo = 1 OR a.Fecha <= @FechaA)
AND ROUND(ISNULL(a.Cargo, 0.0), @CfgTolerancia) = @Cargo
AND a.ID NOT IN (SELECT Auxiliar FROM ConciliacionD WHERE ID = @ID AND Auxiliar IS NOT NULL)
AND a.Fecha BETWEEN @Fecha AND DATEADD(day, @CfgDiasAbonos, @Fecha)
IF @AuxiliarFecha IS NOT NULL
SELECT @Auxiliar = MIN(a.ID)
FROM Auxiliar a
JOIN Dinero d ON d.ID = a.ModuloID AND d.Estatus IN ('PENDIENTE', 'CONCLUIDO', 'CONCILIADO')
WHERE a.Empresa = @Empresa
AND a.Rama = 'DIN' AND a.Modulo = 'DIN'
AND a.Cuenta = @CtaDinero
AND a.Conciliado = 0
AND (@CfgSugerirDespuesPeriodo = 1 OR a.Fecha <= @FechaA)
AND ROUND(ISNULL(a.Cargo, 0.0), @CfgTolerancia) = @Cargo
AND a.ID NOT IN (SELECT Auxiliar FROM ConciliacionD WHERE ID = @ID AND Auxiliar IS NOT NULL)
AND a.Fecha = @AuxiliarFecha
END
IF @Auxiliar IS NULL AND @CfgDiasCargos IS NOT NULL AND @Abono <> 0.0
BEGIN
SELECT @AuxiliarFecha = NULL
SELECT @AuxiliarFecha = MIN(a.Fecha)
FROM Auxiliar a
JOIN Dinero d ON d.ID = a.ModuloID AND d.Estatus IN ('PENDIENTE', 'CONCLUIDO', 'CONCILIADO')
WHERE a.Empresa = @Empresa
AND a.Rama = 'DIN' AND a.Modulo = 'DIN'
AND a.Cuenta = @CtaDinero
AND a.Conciliado = 0
AND (@CfgSugerirDespuesPeriodo = 1 OR a.Fecha <= @FechaA)
AND ROUND(ISNULL(a.Abono, 0.0), @CfgTolerancia) = @Abono
AND a.ID NOT IN (SELECT Auxiliar FROM ConciliacionD WHERE ID = @ID AND Auxiliar IS NOT NULL)
AND a.Fecha BETWEEN DATEADD(day, -@CfgDiasCargos, @Fecha) AND @Fecha
IF @AuxiliarFecha IS NOT NULL
SELECT @Auxiliar = MIN(a.ID)
FROM Auxiliar a
JOIN Dinero d ON d.ID = a.ModuloID AND d.Estatus IN ('PENDIENTE', 'CONCLUIDO', 'CONCILIADO')
WHERE a.Empresa = @Empresa
AND a.Rama = 'DIN' AND a.Modulo = 'DIN'
AND a.Cuenta = @CtaDinero
AND a.Conciliado = 0
AND (@CfgSugerirDespuesPeriodo = 1 OR a.Fecha <= @FechaA)
AND ROUND(ISNULL(a.Abono, 0.0), @CfgTolerancia) = @Abono
AND a.ID NOT IN (SELECT Auxiliar FROM ConciliacionD WHERE ID = @ID AND Auxiliar IS NOT NULL)
AND a.Fecha = @AuxiliarFecha
END
END
IF @Cont = 1 AND @CfgImportesLejanos = 1 AND @Auxiliar IS NULL
SELECT @Auxiliar = MIN(a.ID)
FROM Auxiliar a
JOIN Dinero d ON d.ID = a.ModuloID AND d.Estatus IN ('PENDIENTE', 'CONCLUIDO', 'CONCILIADO')
WHERE a.Empresa = @Empresa
AND a.Rama = 'DIN' AND a.Modulo = 'DIN'
AND a.Cuenta = @CtaDinero
AND a.Conciliado = 0
AND (@CfgSugerirDespuesPeriodo = 1 OR a.Fecha <= @FechaA)
AND ROUND(ISNULL(a.Cargo, 0.0), @CfgTolerancia) = @Cargo
AND ROUND(ISNULL(a.Abono, 0.0), @CfgTolerancia) = @Abono
AND a.ID NOT IN (SELECT Auxiliar FROM ConciliacionD WHERE ID = @ID AND Auxiliar IS NOT NULL)
END
END
IF @TipoMovimiento = 'Tesoreria' AND @Auxiliar IS NOT NULL AND @MovTipo = 'CONC.BC' AND @Cuenta IS NOT NULL
BEGIN
SELECT @Modulo = NULL, @ModuloID = NULL, @ContID = NULL
SELECT @Modulo = Modulo, @ModuloID = ModuloID FROM Auxiliar WHERE ID = @Auxiliar
IF @Modulo = 'DIN' SELECT @ContID = ContID FROM Dinero WHERE ID = @ModuloID
IF @ContID IS NOT NULL
SELECT @ContD = MIN(RID)
FROM ContD
WHERE ID = @ContID
AND Cuenta = @Cuenta
AND Conciliado = 0
AND ROUND(ISNULL(Debe, 0.0),  @CfgTolerancia) = @Cargo
AND ROUND(ISNULL(Haber, 0.0), @CfgTolerancia) = @Abono
END
IF @TipoMovimiento IN ('Gasto', 'Gasto IVA')
SELECT @Acreedor = ISNULL(@InstitucionAcreedor, @CtaDineroAcreedor), @ConceptoGasto = ISNULL(@ConceptoGasto, ISNULL(@InstitucionConcepto, @Concepto))
/*IF @TipoMovimiento = 'Tesoreria' SELECT @ObligacionFiscal = NULL, @Tasa = NULL*/
IF @TipoMovimiento IS NULL SELECT @TipoMovimiento = 'Tesoreria'
UPDATE ConciliacionD
SET TipoMovimiento = @TipoMovimiento, Auxiliar = @Auxiliar, ContD = @ContD, ConceptoGasto = @ConceptoGasto, Acreedor = @Acreedor, ObligacionFiscal = @ObligacionFiscal, ObligacionFiscal2 = @ObligacionFiscal2, Tasa = @Tasa, TipoImporte = @TipoImporte
WHERE ID = @ID AND RID = @RID
END
FETCH NEXT FROM crConciliacionD INTO @RID, @Fecha, @Concepto, @Referencia, @Cargo, @Abono, @Manual
END
CLOSE crConciliacionD
DEALLOCATE crConciliacionD
RETURN
END

