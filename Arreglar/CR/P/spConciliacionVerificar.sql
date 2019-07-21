SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spConciliacionVerificar
@ID               		int,
@Accion			char(20),
@Empresa          		char(5),
@Usuario			char(10),
@Modulo	      		char(5),
@Mov              		char(20),
@MovID			varchar(20),
@MovTipo	      		char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaEmision		datetime,
@Estatus			char(15),
@EstatusNuevo		char(15),
@CtaDinero			varchar(10),
@Institucion		varchar(20),
@Cuenta			varchar(20),
@FechaD			datetime,
@FechaA			datetime,
/*@SaldoAnterior		money,
@Cargos			money,
@Abonos			money,
@SaldoFinal			money,*/
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@CfgTolerancia		int,
@CfgRepetirFecha		bit,
@CfgTraslaparFecha		bit,
@Ok               		int          OUTPUT,
@OkRef            		varchar(255) OUTPUT

AS BEGIN
DECLARE
@RID			int,
@UltRID			int,
@Seccion			int,
@UltimaConciliacion		datetime,
@UltimaConciliacionID	int,
@Fecha			datetime,
@Concepto			varchar(50),
@Referencia			varchar(50),
@Cargo			money,
@Abono			money,
@Importe			money,
@Manual			int,
@TipoMovimiento		varchar(20),
@UltTipoMovimiento		varchar(20),
@Auxiliar 			int,
@ContD			int,
@ConceptoGasto		varchar(50),
@PermiteAbonoNoIdentificado	bit,
@CfgIVAIntegrado		bit,
@Acreedor			varchar(10),
@DetalleImporte		money,
@AuxiliarImporte		money,
@PermiteCargoNoIdentificado bit/*,
@SumaCargos		money,
@SumaAbonos		money*/
IF @Accion = 'CANCELAR'
BEGIN
IF @Conexion = 0
IF EXISTS (SELECT * FROM MovFlujo WHERE Cancelado = 0 AND Empresa = @Empresa AND DModulo = @Modulo AND DID = @ID AND OModulo <> DModulo)
SELECT @Ok = 60070
END ELSE
BEGIN
IF @CfgRepetirFecha = 0
IF EXISTS(SELECT * FROM Conciliacion WHERE Empresa = @Empresa AND CtaDinero = @CtaDinero AND Estatus = 'CONCLUIDO' AND (FechaD BETWEEN @FechaD AND @FechaA OR FechaA BETWEEN @FechaD AND @FechaA))
SELECT @Ok = 51090
IF @CfgTraslaparFecha = 0 AND @Ok IS NULL
BEGIN
EXEC spConciliacionUltima @Empresa, @CtaDinero, @UltimaConciliacion OUTPUT, @UltimaConciliacionID OUTPUT
IF DATEDIFF(day, @UltimaConciliacion, @FechaD) <> 1 SELECT @Ok = 51095
END
/*IF @Ok IS NULL
BEGIN
SELECT @SumaCargos = SUM(Cargo), @SumaAbonos = SUM(Abono)
FROM ConciliacionD
WHERE ID = @ID
IF ROUND(@SumaCargos, 2) <> ROUND(@Cargos, 2) OR ROUND(@SumaAbonos, 2) <> ROUND(@Abonos, 2)
SELECT @Ok = 51020
END*/
IF @Ok IS NULL
BEGIN
IF @CtaDinero IS NULL SELECT @Ok = 40030 ELSE
IF @MovMoneda <> (SELECT Moneda FROM CtaDinero WHERE CtaDinero = @CtaDinero) SELECT @Ok = 30080 ELSE
/*IF ROUND(@SaldoAnterior, 2) <> (SELECT ROUND(SaldoConciliado, 2) FROM DineroSaldo WHERE Empresa = @Empresa AND Moneda = @MovMoneda AND CtaDinero = @CtaDinero)
SELECT @Ok = 51080*/
IF @MovTipo = 'CONC.BC'
BEGIN
IF @Cuenta IS NULL SELECT @Ok = 51035 /*ELSE
IF ROUND(@SaldoAnterior, 2) <> (SELECT ROUND(SaldoConciliado, 2) FROM CtaSaldo WHERE Empresa = @Empresa AND Moneda = @MovMoneda AND Cuenta = @Cuenta)
SELECT @Ok = 51085*/
END
END
IF @Ok IS NULL
BEGIN
SELECT @CfgIVAIntegrado = ISNULL(ConcliarIVAIntegrado, 0)
FROM InstitucionFin
WHERE Institucion = @Institucion
DECLARE crConciliacionD CURSOR LOCAL FOR
SELECT Seccion, Fecha, Concepto, NULLIF(RTRIM(Referencia), ''), ISNULL(Cargo, 0.0), ISNULL(Abono, 0.0), NULLIF(Manual, 0), NULLIF(RTRIM(TipoMovimiento), ''), Auxiliar, ContD, NULLIF(RTRIM(ConceptoGasto), ''), NULLIF(RTRIM(Acreedor), '')
FROM ConciliacionD
WHERE ID = @ID
OPEN crConciliacionD
FETCH NEXT FROM crConciliacionD INTO @Seccion, @Fecha, @Concepto, @Referencia, @Cargo, @Abono, @Manual, @TipoMovimiento, @Auxiliar, @ContD, @ConceptoGasto, @Acreedor
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Importe = ROUND(@Cargo - @Abono, @CfgTolerancia)
IF @Seccion = 0 AND @Fecha NOT BETWEEN @FechaD AND @FechaA SELECT @Ok = 51010
IF @TipoMovimiento = 'Gasto' AND @Acreedor      IS NULL SELECT @Ok = 51030 ELSE
IF @TipoMovimiento = 'Gasto' AND @ConceptoGasto IS NULL SELECT @Ok = 51040 ELSE
IF @TipoMovimiento = 'Gasto IVA'
BEGIN
IF @CfgIVAIntegrado = 0 AND @ConceptoGasto IS NULL SELECT @Ok = 51040 ELSE
IF @CfgIVAIntegrado = 1 AND (@UltTipoMovimiento <> 'Gasto' OR @RID - 1 <> @UltRID) SELECT @Ok = 51160
END ELSE
IF @TipoMovimiento = 'Tesoreria' AND @Auxiliar IS NULL
BEGIN
EXEC spInstitucionFinConcepto @Institucion, @Concepto, @PermiteAbonoNoIdentificado = @PermiteAbonoNoIdentificado OUTPUT, @PermiteCargoNoIdentificado = @PermiteCargoNoIdentificado OUTPUT
IF @Abono > 0.0 AND @PermiteAbonoNoIdentificado = 1
SELECT @Ok = @Ok
IF @Cargo > 0.0 AND @PermiteCargoNoIdentificado = 1
SELECT @Ok = @Ok
END ELSE
IF @TipoMovimiento = 'Tesoreria' AND @MovTipo = 'CONC.BC' AND @ContD IS NULL SELECT @Ok = 51070 ELSE
IF @Auxiliar IS NOT NULL IF @Importe <> ROUND((SELECT ISNULL(Abono, 0.0)-ISNULL(Cargo, 0.0) FROM Auxiliar WHERE ID = @Auxiliar), @CfgTolerancia)
SELECT @Ok = 51120
IF @ContD IS NOT NULL IF @Importe <> ROUND((SELECT ISNULL(Haber, 0.0)-ISNULL(Debe, 0.0) FROM ContD WHERE RID = @ContD), @CfgTolerancia)
SELECT @Ok = 51130
END
IF @Ok IS NOT NULL AND @OkRef IS NULL
SELECT @OkRef = dbo.fnDateTimeToDDMMMAA(@Fecha)+' - '+@Concepto+' '+@Referencia+' '+CONVERT(varchar, @Importe)
SELECT @UltRID = @RID, @UltTipoMovimiento = @TipoMovimiento
FETCH NEXT FROM crConciliacionD INTO @Seccion, @Fecha, @Concepto, @Referencia, @Cargo, @Abono, @Manual, @TipoMovimiento, @Auxiliar, @ContD, @ConceptoGasto, @Acreedor
END
CLOSE crConciliacionD
DEALLOCATE crConciliacionD
END
END
IF @Ok IS NULL
BEGIN
SELECT @DetalleImporte = 0.0, @AuxiliarImporte = 0.0
SELECT @DetalleImporte = SUM(ISNULL(d.Abono, 0.0)-ISNULL(d.Cargo, 0.0))
FROM ConciliacionCompensacion c
JOIN ConciliacionD d ON d.ID = c.ID AND d.RID = c.ConciliacionD
WHERE c.ID = @ID
SELECT @AuxiliarImporte = SUM(ISNULL(a.Cargo, 0.0)-ISNULL(a.Abono, 0.0))
FROM ConciliacionCompensacion c
JOIN Auxiliar a ON a.ID = c.Manual
WHERE c.ID = @ID
IF ROUND(@DetalleImporte, 0) <> ROUND(@AuxiliarImporte, 0) SELECT @Ok = 25500, @OkRef = 'Compensacion Manual'
END
RETURN
END

