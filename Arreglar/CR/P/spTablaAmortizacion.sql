SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTablaAmortizacion
@Modulo				char(5),
@ID					int,
@Usuario			char(10),
@Generar			bit	     = 0,
@FechaRegistro		datetime     = NULL,
@Ok             	int          = NULL OUTPUT,
@OkRef          	varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Empresa		   char(5),
@CfgPlazoDias	   varchar(20),
@ImpuestoPct	   float,
@MinimoDias		   int,
@Sucursal		   int,
@Mov		   char(20),
@MovID		   varchar(20),
@FechaEmision	   datetime,
@Vencimiento	   datetime,
@LineaCredito     	   varchar(20),
@TipoTasa	   	   varchar(20),
@TieneTasaEsp	   bit,
@TasaEsp		   float,
@TipoAmortizacion 	   varchar(20),
@Impuestos		   money,
@ImporteTotal	   money,
@TotalComisiones	   money,
@Capital        	   money,
@CapitalBase	   money,
@InteresTotal      	   money,
@Plazo                 int,
@Periodo               int,
@Amortizacion          int,
@Amortizaciones        int,
@PeriodoInicial        datetime,
@PeriodoFinal          datetime,
@Dias                  int,
@TasaDiaria            float,
@SaldoCapital          money,
@SaldoInicial          money,
@SaldoIntereses        money,
@SaldoFinal            money,
@ImporteAmortizacion   money,
@ImporteCapital        money,
@ImporteIntereses      money,
@ImporteImpuestos	   money,
@ImporteRetencion	   money,
@SaldoRetencion	   money,
@Metodo	           int,
@PagoInhabiles         varchar(20),        
@PagoVencimiento       varchar(20),        
@PagoDias              int,
@PagoPromedio          money,
@PeriodosGraciaCapital int,
@Uso		   varchar(20),
@UltFecha              datetime,
@FechaAmortizacion     datetime,
@SumaCapital           money,
@SumaImpuestos	   money,
@Mensualidad           money,
@Intereses             money,
@InteresesAnticipados  money,
@RecorrerVencimiento   int,
@ComisionesFinanciadas bit,
@RedondeoMonetarios    int,
@Hoy		   datetime,
@Guia		   bit,
@Migracion		     bit,
@MinistracionHipotecaria bit,
@PorcentajeResidual      float,
@MovBajaParcial	     char(20),
@Referencia5	     varchar(50),
@TieneImporteFijo	     bit,
@ImporteFijo             money,
@Acreedor		     varchar(10),
@LCMoneda		     varchar(10),
@Moneda		     varchar(10),
@TipoCambio		     float,
@TasaRetencion	     float,
@ACCobroIntereses		varchar(20), 
@Deudor					varchar(10), 
@Concepto				varchar(50), 
@Impuesto1				float,       
@TipoImpuesto1			varchar(10), 
@MovTipo				varchar(20), 
@SubMovTipo				varchar(20), 
@ZonaImpuesto			varchar(30), 
@IVAInteres				float,       
@IVAInteresPorcentaje	float        
SELECT @Hoy = GETDATE(), @InteresesAnticipados = NULL, @Guia = 0, @Migracion = 0, @TieneTasaEsp = 0
EXEC spExtraerFecha @Hoy OUTPUT
IF EXISTS(SELECT * FROM TablaAmortizacionGuia WHERE Modulo = @Modulo AND ID = @ID)
SELECT @Guia = 1
IF EXISTS(SELECT * FROM TablaAmortizacionMigracion WHERE Modulo = @Modulo AND ID = @ID)
SELECT @Migracion = 1
IF @Modulo = 'VTAS'
BEGIN
SELECT @Moneda = Moneda, @TipoCambio = TipoCambio, @Mov = Mov, @MovID = MovID, @Empresa = Empresa, @Sucursal = Sucursal, @FechaEmision = FechaEmision, @Vencimiento = Vencimiento, @LineaCredito = LineaCredito, @TipoTasa = TipoTasa, @TieneTasaEsp = ISNULL(TieneTasaEsp, 0), @TasaEsp = TasaEsp, @TipoAmortizacion = TipoAmortizacion, @TotalComisiones = ISNULL(Comisiones, 0.0)+ISNULL(ComisionesIVA, 0.0), @Deudor = Cliente, @Concepto = Concepto FROM Venta  WHERE ID = @ID 
SELECT @Impuestos = SUM(Impuestos), @ImporteTotal = SUM(ImporteTotal) FROM VentaTCalc WHERE ID = @ID
SELECT @MovTipo = Clave, @SubMovTipo = SubClave FROM MovTipo WHERE Mov = @Mov AND Modulo = @Modulo 
SELECT @Impuesto1 = Impuestos FROM Concepto WHERE Concepto = @Concepto AND Modulo = @Modulo
SELECT @ZonaImpuesto = ZonaImpuesto FROM Cte WHERE Cliente = @Deudor
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spTipoImpuesto @Modulo, @ID, @Mov, @FechaEmision, @Empresa, @Sucursal, @Deudor, @Concepto = @Concepto, @VerTipos = 0, @EnSilencio = 1, @Impuesto1 = @Impuesto1 OUTPUT, @TipoImpuesto1 = @TipoImpuesto1 OUTPUT, @ConceptoMov = 1
END ELSE
IF @Modulo = 'COMS'
BEGIN
SELECT @Moneda = Moneda, @TipoCambio = TipoCambio, @Mov = Mov, @MovID = MovID, @Empresa = Empresa, @Sucursal = Sucursal, @FechaEmision = FechaEmision, @Vencimiento = Vencimiento, @LineaCredito = LineaCredito, @TipoTasa = TipoTasa, @TieneTasaEsp = ISNULL(TieneTasaEsp, 0), @TasaEsp = TasaEsp, @TipoAmortizacion = TipoAmortizacion, @TotalComisiones = ISNULL(Comisiones, 0.0)+ISNULL(ComisionesIVA, 0.0), @Acreedor = Proveedor, @Concepto = Concepto FROM Compra WHERE ID = @ID 
SELECT @Impuestos = SUM(Impuestos), @ImporteTotal = SUM(ImporteTotal) FROM CompraTCalc WHERE ID = @ID
SELECT @MovTipo = Clave, @SubMovTipo = SubClave FROM MovTipo WHERE Mov = @Mov AND Modulo = @Modulo 
SELECT @Impuesto1 = Impuestos FROM Concepto WHERE Concepto = @Concepto AND Modulo = @Modulo
SELECT @ZonaImpuesto = ZonaImpuesto FROM Prov WHERE Proveedor = @Acreedor
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spTipoImpuesto @Modulo, @ID, @Mov, @FechaEmision, @Empresa, @Sucursal, @Deudor, @Concepto = @Concepto, @VerTipos = 0, @EnSilencio = 1, @Impuesto1 = @Impuesto1 OUTPUT, @TipoImpuesto1 = @TipoImpuesto1 OUTPUT, @ConceptoMov = 1
END ELSE
IF @Modulo = 'CXC'
BEGIN 
SELECT @Moneda = Moneda, @TipoCambio = TipoCambio, @Mov = Mov, @MovID = MovID, @Empresa = Empresa, @Sucursal = Sucursal, @FechaEmision = FechaEmision, @Vencimiento = Vencimiento, @LineaCredito = LineaCredito, @TipoTasa = TipoTasa, @TieneTasaEsp = ISNULL(TieneTasaEsp, 0), @TasaEsp = TasaEsp, @TipoAmortizacion = TipoAmortizacion, @Impuestos = ISNULL(Impuestos, 0.0), @ImporteTotal = ISNULL(Importe, 0.0) + ISNULL(Impuestos, 0.0) - ISNULL(Retencion, 0.0), @TotalComisiones = ISNULL(Comisiones, 0.0)+ISNULL(ComisionesIVA, 0.0), @Referencia5 = NULLIF(RTRIM(Referencia5), ''), @Deudor = Cliente, @Concepto = Concepto FROM Cxc    WHERE ID = @ID 
SELECT @MovTipo = Clave, @SubMovTipo = SubClave FROM MovTipo WHERE Mov = @Mov AND Modulo = @Modulo 
SELECT @Impuesto1 = Impuestos FROM Concepto WHERE Concepto = @Concepto AND Modulo = @Modulo
SELECT @ZonaImpuesto = ZonaImpuesto FROM Cte WHERE Cliente = @Deudor
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spTipoImpuesto @Modulo, @ID, @Mov, @FechaEmision, @Empresa, @Sucursal, @Deudor, @Concepto = @Concepto, @VerTipos = 0, @EnSilencio = 1, @Impuesto1 = @Impuesto1 OUTPUT, @TipoImpuesto1 = @TipoImpuesto1 OUTPUT
END ELSE 
IF @Modulo = 'CXP'
BEGIN 
SELECT @Moneda = Moneda, @TipoCambio = TipoCambio, @Mov = Mov, @MovID = MovID, @Empresa = Empresa, @Sucursal = Sucursal, @FechaEmision = FechaEmision, @Vencimiento = Vencimiento, @LineaCredito = LineaCredito, @TipoTasa = TipoTasa, @TieneTasaEsp = ISNULL(TieneTasaEsp, 0), @TasaEsp = TasaEsp, @TipoAmortizacion = TipoAmortizacion, @Impuestos = ISNULL(Impuestos, 0.0), @ImporteTotal = ISNULL(Importe, 0.0) + ISNULL(Impuestos, 0.0) - ISNULL(Retencion, 0.0) - ISNULL(Retencion2, 0.0) - ISNULL(Retencion3, 0.0), @TotalComisiones = ISNULL(Comisiones, 0.0)+ISNULL(ComisionesIVA, 0.0), @Acreedor = Proveedor, @Concepto = Concepto FROM Cxp WHERE ID = @ID 
SELECT @MovTipo = Clave, @SubMovTipo = SubClave FROM MovTipo WHERE Mov = @Mov AND Modulo = @Modulo 
SELECT @Impuesto1 = Impuestos FROM Concepto WHERE Concepto = @Concepto AND Modulo = @Modulo
SELECT @ZonaImpuesto = ZonaImpuesto FROM Prov WHERE Proveedor = @Acreedor
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spTipoImpuesto @Modulo, @ID, @Mov, @FechaEmision, @Empresa, @Sucursal, @Acreedor, @Concepto = @Concepto, @VerTipos = 0, @EnSilencio = 1, @Impuesto1 = @Impuesto1 OUTPUT, @TipoImpuesto1 = @TipoImpuesto1 OUTPUT
END ELSE 
IF @Modulo = 'CREDI'
BEGIN 
SELECT @Moneda = Moneda, @TipoCambio = TipoCambio, @Mov = Mov, @MovID = MovID, @Empresa = Empresa, @Sucursal = Sucursal, @FechaEmision = FechaEmision, @Vencimiento = Vencimiento, @LineaCredito = LineaCredito, @TipoTasa = TipoTasa, @TieneTasaEsp = ISNULL(TieneTasaEsp, 0), @TasaEsp = TasaEsp, @TipoAmortizacion = TipoAmortizacion, @Impuestos = 0.0, @ImporteTotal = ISNULL(Importe, 0.0), @TotalComisiones = ISNULL(Comisiones, 0.0)+ISNULL(ComisionesIVA, 0.0), @Deudor = Deudor, @Acreedor = Acreedor, @Concepto = Concepto FROM Credito WHERE ID = @ID
SELECT @MovTipo = Clave, @SubMovTipo = SubClave FROM MovTipo WHERE Mov = @Mov AND Modulo = @Modulo 
SELECT @Impuesto1 = Impuestos FROM Concepto WHERE Concepto = @Concepto AND Modulo = @Modulo
IF @MovTipo IN ('CREDI.FON','CREDI.DA','CFEDI.FOA')
BEGIN
SELECT @ZonaImpuesto = ZonaImpuesto FROM Cte WHERE Cliente = @Deudor
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spTipoImpuesto @Modulo, @ID, @Mov, @FechaEmision, @Empresa, @Sucursal, @Acreedor, @Concepto = @Concepto, @VerTipos = 0, @EnSilencio = 1, @Impuesto1 = @Impuesto1 OUTPUT, @TipoImpuesto1 = @TipoImpuesto1 OUTPUT
END
ELSE IF @MovTipo IN ('CFEDI.FEX','CREDI.FIN','CREDI.CES','CREDI.DIS','CREDI.BTB')
BEGIN
SELECT @ZonaImpuesto = ZonaImpuesto FROM Prov WHERE Proveedor = @Acreedor
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spTipoImpuesto @Modulo, @ID, @Mov, @FechaEmision, @Empresa, @Sucursal, @Deudor, @Concepto = @Concepto, @VerTipos = 0, @EnSilencio = 1, @Impuesto1 = @Impuesto1 OUTPUT, @TipoImpuesto1 = @TipoImpuesto1 OUTPUT
END
END
SELECT @ACCobroIntereses = UPPER(ACCobroIntereses) FROM EmpresaCfg WHERE Empresa = @Empresa
IF NULLIF(RTRIM(@TipoAmortizacion), '') IS NULL RETURN
IF @Migracion = 0 AND (SELECT ACPermitirMovFechaAnterior FROM EmpresaCfg WHERE Empresa = @Empresa) = 0
IF @Hoy>@FechaEmision OR (EXISTS(SELECT * FROM FechaTrabajo WHERE Empresa = @Empresa AND Sucursal = @Sucursal AND FechaTrabajo>@FechaEmision)) SELECT @Ok = 12010
IF @Ok IS NOT NULL RETURN
DELETE TablaAmortizacion WHERE Modulo = @Modulo AND ID = @ID
SET DATEFIRST 7
SELECT @RedondeoMonetarios = RedondeoMonetarios FROM Version
IF @Migracion = 0
BEGIN
SELECT @CfgPlazoDias = UPPER(ACPlazoDias)
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @ImpuestoPct = DefImpuesto
FROM EmpresaGral
WHERE Empresa = @Empresa
SELECT @MovBajaParcial = ACBajaParcial
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
SELECT @Metodo	        = Metodo,
@PagoInhabiles         = UPPER(PagoInhabiles),
@PagoVencimiento       = UPPER(PagoVencimiento),
@PagoDias              = NULLIF(PagoDias, 0),
@ComisionesFinanciadas = ISNULL(ComisionesFinanciadas, 0)
FROM TipoAmortizacion
WHERE TipoAmortizacion = @TipoAmortizacion
SELECT @PeriodosGraciaCapital = ISNULL(PeriodosGraciaCapital, 0),
@MinistracionHipotecaria = ISNULL(MinistracionHipotecaria, 0),
@PorcentajeResidual = ISNULL(PorcentajeResidual, 0.0),
@TieneImporteFijo = ISNULL(TieneImporteFijo, 0),
@ImporteFijo = NULLIF(ImporteFijo, 0.0),
@Uso = Uso,
@Acreedor = NULLIF(RTRIM(Acreedor), ''),
@LCMoneda = Moneda
FROM LC
WHERE LineaCredito = @LineaCredito
IF @LCMoneda <> @Moneda SELECT @Ok = 30046, @OkRef = @LCMoneda
IF (@MinistracionHipotecaria = 1 AND @Metodo <> 40) OR (@MinistracionHipotecaria = 0 AND @Metodo = 40)
SELECT @Ok = 12020
IF @Metodo = 40 RETURN
EXEC xpPorcentajeResidual @Modulo, @ID, @PorcentajeResidual OUTPUT
IF @Metodo <> 50 SELECT @PorcentajeResidual = 0.0
SELECT @Capital = @ImporteTotal, @RecorrerVencimiento = 0
IF @ComisionesFinanciadas = 1
SELECT @Capital = @Capital + @TotalComisiones
IF @PagoInhabiles IN ('POSTERIOR HABIL', 'ANTERIOR HABIL')
BEGIN
IF @PagoInhabiles = 'ANTERIOR HABIL' SELECT @RecorrerVencimiento = -1 ELSE SELECT @RecorrerVencimiento = 1
SELECT @Vencimiento = dbo.fnChecarDiaHabil(@Vencimiento, @RecorrerVencimiento)
END
EXEC spTipoTasa @TipoTasa, @TasaDiaria OUTPUT, @TieneTasaEsp = @TieneTasaEsp, @TasaEsp = @TasaEsp, @TasaRetencion = @TasaRetencion OUTPUT
IF @CfgPlazoDias = 'MESES 30'
SELECT @Plazo = DATEDIFF(month, @FechaEmision, @Vencimiento)*30
ELSE
SELECT @Plazo = DATEDIFF(day, @FechaEmision, @Vencimiento)
CREATE TABLE #TablaAmortizacion (
ID									int             NOT NULL IDENTITY(1,1) PRIMARY KEY,
Vencimiento							datetime        NULL,
SaldoInicial							money		    NULL,
Capital								money           NULL,
Intereses								money           NULL,
IVAInteresPorcentaje					float			NULL, 
IVAInteres							float           NULL, 
Retencion								money			NULL)
IF @Guia = 1
BEGIN
SELECT @Metodo = 0
SELECT @SumaCapital = ISNULL(SUM(Capital), 0.0)
FROM TablaAmortizacionGuia
WHERE Modulo = @Modulo AND ID = @ID
IF @Capital <> @SumaCapital
UPDATE TablaAmortizacionGuia
SET Capital = ISNULL(Capital, 0.0) - (@SumaCapital - @Capital)
WHERE Modulo = @Modulo AND ID = @ID AND Vencimiento = (SELECT MAX(Vencimiento) FROM TablaAmortizacionGuia WHERE Modulo = @Modulo AND ID = @ID)
INSERT #TablaAmortizacion
(Vencimiento, Capital)
SELECT Vencimiento, Capital
FROM TablaAmortizacionGuia
WHERE Modulo = @Modulo AND ID = @ID
END ELSE
BEGIN
IF @Metodo IN (20,21,22) INSERT #TablaAmortizacion (Vencimiento, Capital) VALUES (@Vencimiento, @Capital)
IF @Metodo IN (10,11,12,20,30,31,50)
BEGIN
IF @Metodo IN (50,30) SELECT @MinimoDias = 16 ELSE SELECT @MinimoDias = 1
INSERT #TablaAmortizacion (Vencimiento) SELECT FechaA FROM dbo.fnProyectarFecha (@FechaEmision, @Vencimiento, @RecorrerVencimiento, @PagoVencimiento, @PagoDias, @MinimoDias, @TipoAmortizacion) ORDER BY Periodo
SELECT @Amortizaciones = COUNT(*), @UltFecha = MAX(Vencimiento) FROM #TablaAmortizacion
END
END
IF @Metodo IN (30,31,50)
BEGIN
IF @Metodo = 50
BEGIN
SELECT @CapitalBase = (@ImporteTotal - @Impuestos) * (1.0-(@PorcentajeResidual/100.0))
IF @Mov = @MovBajaParcial AND @Referencia5 IS NOT NULL AND dbo.fnEsNumerico(@Referencia5) = 1
SELECT @CapitalBase = CONVERT(money, @Referencia5)
END ELSE SELECT @CapitalBase = @Capital
EXEC spPagosIgualesCalcTotal @Metodo, @CapitalBase, @TasaDiaria, @Plazo, @Amortizaciones, @ImporteAmortizacion OUTPUT, @InteresTotal OUTPUT
SELECT @Amortizacion = 1, @SaldoCapital = @CapitalBase, @SaldoIntereses = @InteresTotal
WHILE @Amortizacion <= @Amortizaciones
BEGIN
EXEC spPagosIgualesCalcAmortizacion @Metodo, @CapitalBase, @InteresTotal, @TasaDiaria, @Plazo, @Amortizaciones, @ImporteAmortizacion, @Amortizacion, @SaldoCapital OUTPUT, @SaldoIntereses OUTPUT, @ImporteCapital OUTPUT, @ImporteIntereses OUTPUT
SELECT @ImporteRetencion = ROUND(@ImporteCapital*(@TasaRetencion/100.0)*@Plazo, @RedondeoMonetarios)
IF @ACCobroIntereses = 'FIJOS' 
SELECT @IVAInteres = ISNULL(@ImporteIntereses,0.0) * (ISNULL(@Impuesto1,0.0)/100.0), @IVAInteresPorcentaje = ISNULL(@Impuesto1,0.0) 
ELSE 
SELECT @IVAInteres = NULL, @IVAInteresPorcentaje = ISNULL(@Impuesto1,0.0) 
UPDATE #TablaAmortizacion SET Capital = @ImporteCapital, Intereses = @ImporteIntereses, IVAInteres = @IVAInteres, IVAInteresPorcentaje = @IVAInteresPorcentaje, Retencion = @ImporteRetencion WHERE ID = @Amortizacion
SELECT @Amortizacion = @Amortizacion + 1
END
END
IF @Metodo IN (10,11,12) AND ISNULL(@Amortizaciones, 0) > 0
BEGIN
IF @PeriodosGraciaCapital >= @Amortizaciones SELECT @PeriodosGraciaCapital = @Amortizaciones - 1
UPDATE #TablaAmortizacion SET Capital = ROUND(@Capital/(@Amortizaciones-@PeriodosGraciaCapital), @RedondeoMonetarios) WHERE ID > @PeriodosGraciaCapital
SELECT @SumaCapital = SUM(Capital) FROM #TablaAmortizacion
IF @SumaCapital <> @Capital
UPDATE #TablaAmortizacion SET Capital = Capital + (@Capital-@SumaCapital) WHERE Vencimiento = @UltFecha
END
IF @Metodo NOT IN (30, 31)
BEGIN
SELECT @SaldoCapital =  @Capital, @SumaImpuestos = 0.0, @SaldoIntereses = 0.0, @SaldoRetencion = 0.0, @UltFecha = @FechaEmision
DECLARE crIntereses CURSOR FOR
SELECT Vencimiento, ISNULL(Capital, 0.0)
FROM #TablaAmortizacion
ORDER BY Vencimiento
OPEN crIntereses
FETCH NEXT FROM crIntereses INTO @FechaAmortizacion, @ImporteCapital
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Dias = DATEDIFF(day, @UltFecha, @FechaAmortizacion)
SELECT @ImporteIntereses = ROUND(@SaldoCapital*(@TasaDiaria/100.0)*@Dias, @RedondeoMonetarios)
SELECT @ImporteRetencion = ROUND(@SaldoCapital*(@TasaRetencion/100.0)*@Dias, @RedondeoMonetarios)
IF @ACCobroIntereses = 'FIJOS' 
SELECT @IVAInteres = ISNULL(@ImporteIntereses,0.0) * (ISNULL(@Impuesto1,0.0)/100.0), @IVAInteresPorcentaje = ISNULL(@Impuesto1,0.0) 
ELSE 
SELECT @IVAInteres = NULL, @IVAInteresPorcentaje = ISNULL(@Impuesto1,0.0) 
IF @Metodo = 50
UPDATE #TablaAmortizacion SET SaldoInicial = @SaldoCapital, Intereses = @ImporteIntereses, IVAInteres = @IVAInteres, IVAInteresPorcentaje = @IVAInteresPorcentaje, Retencion = @ImporteRetencion WHERE CURRENT OF crIntereses 
ELSE IF @Metodo IN (0, 10, 20, 50)
UPDATE #TablaAmortizacion SET Intereses = @ImporteIntereses, IVAInteres = @IVAInteres, IVAInteresPorcentaje = @IVAInteresPorcentaje, Retencion = @ImporteRetencion WHERE CURRENT OF crIntereses 
ELSE
SELECT @SaldoIntereses = @SaldoIntereses + @ImporteIntereses, @SaldoRetencion = @SaldoRetencion + @ImporteRetencion
IF @Metodo = 50
BEGIN
SELECT @ImporteImpuestos = (@ImporteCapital + @ImporteIntereses) * (@ImpuestoPct/100.0)
IF @SumaImpuestos + @ImporteImpuestos > @Impuestos SELECT @ImporteImpuestos = @Impuestos - @SumaImpuestos
SELECT @SumaImpuestos = @SumaImpuestos + @ImporteImpuestos,
@SaldoCapital = @SaldoCapital - @ImporteCapital - @ImporteImpuestos
END ELSE
SELECT @SaldoCapital = @SaldoCapital - @ImporteCapital
SELECT @UltFecha = @FechaAmortizacion
END
FETCH NEXT FROM crIntereses INTO @FechaAmortizacion, @ImporteCapital
END  
CLOSE crIntereses
DEALLOCATE crIntereses
IF @Metodo IN (11, 21) INSERT #TablaAmortizacion (Vencimiento, Intereses, Retencion) VALUES (@Vencimiento, @SaldoIntereses, @SaldoRetencion) ELSE
IF @Metodo IN (12, 22) SELECT @InteresesAnticipados = @SaldoIntereses
END
SELECT @SaldoCapital =  @Capital, @UltFecha = @FechaEmision, @Periodo = 1
DECLARE crTablaAmortizacion CURSOR FOR
SELECT Vencimiento, ISNULL(SUM(SaldoInicial), 0), ISNULL(SUM(Capital), 0), ISNULL(SUM(Intereses), 0), ISNULL(SUM(IVAInteres), 0.0), ISNULL(AVG(IVAInteresPorcentaje), 0.0), ISNULL(SUM(Retencion), 0) 
FROM #TablaAmortizacion
GROUP BY Vencimiento
ORDER BY Vencimiento
OPEN crTablaAmortizacion
FETCH NEXT FROM crTablaAmortizacion INTO @FechaAmortizacion, @SaldoInicial, @ImporteCapital, @ImporteIntereses, @IVAInteres, @IVAInteresPorcentaje, @ImporteRetencion 
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2 AND (ROUND(@ImporteCapital, 4)<>0.0 OR ROUND(@ImporteIntereses, 4)<>0.0)
BEGIN
IF @Metodo <> 50 SELECT @SaldoInicial = @SaldoCapital
EXEC xpTablaAmortizacion @Modulo, @ID, @Periodo, @ImporteCapital OUTPUT, @ImporteIntereses OUTPUT, @SaldoInicial OUTPUT
INSERT TablaAmortizacion
(Modulo, ID,  Amortizacion, FechaD,    FechaA,             SaldoInicial,             Capital,                    Intereses,                    IVAInteres,              IVAInteresPorcentaje,              Retencion) 
SELECT @Modulo, @ID, @Periodo,     @UltFecha, @FechaAmortizacion, ISNULL(@SaldoInicial, 0), ISNULL(@ImporteCapital, 0), ISNULL(@ImporteIntereses, 0), ISNULL(@IVAInteres,0.0), ISNULL(@IVAInteresPorcentaje,0.0), ISNULL(@ImporteRetencion, 0) 
SELECT @Periodo = @Periodo + 1, @UltFecha = @FechaAmortizacion, @SaldoCapital = @SaldoCapital - @ImporteCapital
END
FETCH NEXT FROM crTablaAmortizacion INTO @FechaAmortizacion, @SaldoInicial, @ImporteCapital, @ImporteIntereses, @IVAInteres, @IVAInteresPorcentaje, @ImporteRetencion 
END  
CLOSE crTablaAmortizacion
DEALLOCATE crTablaAmortizacion
SELECT @Vencimiento = @UltFecha
SELECT @Amortizaciones = @Periodo - 1
END ELSE
BEGIN
INSERT TablaAmortizacion
(Modulo, ID, Amortizacion, FechaD, FechaA, SaldoInicial, Capital, Intereses, IVAInteres, IVAInteresPorcentaje) 
SELECT Modulo, ID, Amortizacion, FechaD, FechaA, SaldoInicial, Capital, Intereses, IVAInteres, IVAInteresPorcentaje  
FROM TablaAmortizacionMigracion
WHERE Modulo = @Modulo AND ID = @ID
SELECT @Amortizaciones = MAX(Amortizacion)
FROM TablaAmortizacionMigracion
WHERE Modulo = @Modulo AND ID = @ID
SELECT @InteresesAnticipados = NULL
END
IF @Modulo = 'CXC' UPDATE Cxc SET Amortizaciones = @Amortizaciones, InteresesAnticipados = @InteresesAnticipados WHERE ID = @ID ELSE
IF @Modulo = 'CXP' UPDATE Cxp SET Amortizaciones = @Amortizaciones, InteresesAnticipados = @InteresesAnticipados WHERE ID = @ID
IF @Ok IS NULL AND @Generar = 1
BEGIN
EXEC spTablaAmortizacionGenerar @Empresa, @Sucursal, @Usuario, @Modulo, @ID, @Mov, @MovID, @FechaEmision, @FechaRegistro, @TipoTasa, @TasaDiaria, @TieneTasaEsp, @TasaEsp, @TipoAmortizacion, @Amortizaciones, @LineaCredito, @Ok OUTPUT, @OkRef OUTPUT, @Migracion = @Migracion
IF @Guia = 1 AND @ImporteFijo IS NOT NULL
UPDATE LC SET TieneImporteFijo = 1 WHERE LineaCredito = @LineaCredito
IF UPPER(@Uso) = 'FONDEO' AND @Acreedor IS NOT NULL AND EXISTS(SELECT * FROM LCGasto WHERE LineaCredito = @LineaCredito)
EXEC spLCGastoGenerar @Empresa, @Sucursal, @Usuario, @Modulo, @ID, @Mov, @MovID, @FechaEmision, @FechaRegistro, @Moneda, @TipoCambio, @ImporteTotal, @LineaCredito, @Acreedor, @Ok OUTPUT, @OkRef OUTPUT
END
RETURN
END

