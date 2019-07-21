SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSSugerirCobro
@SugerirPago		varchar(20),
@Modulo				char(5),
@ID					varchar(36),
@ImporteTotal		money = NULL

AS
BEGIN
DECLARE
@Empresa						char(5),
@Sucursal						int,
@Hoy							datetime,
@Vencimiento					datetime,
@DiasCredito					int,
@DiasVencido					int,
@TasaDiaria						float,
@Moneda							char(10),
@TipoCambio						float,
@Contacto						char(10),
@Renglon						float,
@Aplica							varchar(20),
@AplicaID						varchar(20),
@AplicaMovTipo					varchar(20),
@Capital						money,
@SaldoInteresesOrdinarios		money,
@SaldoInteresesMoratorios		money,
@SaldoMoratorios				money,
@ImpuestoAdicional				float,
@Importe						money,
@SumaImporte					money,
@Impuestos						money,
@DesglosarImpuestos 			bit,
@LineaCredito					varchar(20),
@Metodo							int,
@Estacion						int,
@TasaMoratorios					float,
@SaldoTotal						money,
@Mydate							datetime
SELECT @DesglosarImpuestos = 0 , @Renglon = 0.0, @SumaImporte = 0.0, @ImporteTotal = NULLIF(@ImporteTotal, 0.0),
@SugerirPago = UPPER(@SugerirPago), @SaldoMoratorios = 0.0
IF @SugerirPago <> 'IMPORTE ESPECIFICO'
SELECT @ImporteTotal = NULL
IF @Modulo = 'CXC'
BEGIN
SELECT @Empresa = Empresa, @Sucursal = 0, @Hoy = FechaEmision, @Moneda = Moneda, @TipoCambio = TipoCambio, @Contacto = Cliente
FROM POSL
WHERE ID = @ID
SELECT @TasaMoratorios = ISNULL(CxcMoratoriosTasa,0)/100
FROM EmpresaCfg
WHERE Empresa = @Empresa
DECLARE crAplica CURSOR FOR
SELECT
p.Estacion,
p.Mov,
p.MovID,
p.Vencimiento,
mt.Clave,
ISNULL(p.Saldo*mt.Factor*p.MovTipoCambio/@TipoCambio, 0.0),
ISNULL(p.SaldoInteresesOrdinarios*mt.Factor*p.MovTipoCambio/@TipoCambio, 0.0),
ABS(ISNULL(p.SaldoInteresesMoratorios,0)-ISNULL(p.Saldo*mt.Factor*p.MovTipoCambio/@TipoCambio, 0.0)*ISNULL(p.DiasMoratorios*@TasaMoratorios, 0.0)),
ta.Metodo,
p.LineaCredito,
p.Cliente
FROM POSCxcAnticipoTemp p
JOIN MovTipo mt ON mt.Modulo = @Modulo AND mt.Mov = p.Mov
LEFT OUTER JOIN CfgAplicaOrden a ON a.Modulo = @Modulo AND a.Mov = p.Mov
LEFT OUTER JOIN Cxc r ON r.ID = p.RamaID
LEFT OUTER JOIN TipoAmortizacion ta ON ta.TipoAmortizacion = r.TipoAmortizacion
WHERE p.Empresa = @Empresa AND p.Cliente = @Contacto AND mt.Clave NOT IN ('CXC.SCH','CXC.SD')
ORDER BY a.Orden, p.Vencimiento, p.Mov, p.MovID
SELECT @DesglosarImpuestos = ISNULL(CxcCobroImpuestos, 0) FROM EmpresaCfg2 WHERE Empresa = @Empresa
END
ELSE
IF @Modulo = 'CXP'
BEGIN
DECLARE crAplica CURSOR FOR
SELECT
p.Estacion,
p.Mov,
p.MovID,
p.Vencimiento,
mt.Clave,
ISNULL(p.Saldo*mt.Factor*p.MovTipoCambio/@TipoCambio, 0.0),
ISNULL(p.SaldoInteresesOrdinarios*mt.Factor*p.MovTipoCambio/@TipoCambio, 0.0),
ISNULL(p.SaldoInteresesMoratorios*mt.Factor*p.MovTipoCambio/@TipoCambio, 0.0),
ta.Metodo,
p.LineaCredito,
p.Cliente
FROM POSCxcAnticipoTemp p
JOIN MovTipo mt ON mt.Modulo = @Modulo AND mt.Mov = p.Mov
LEFT OUTER JOIN CfgAplicaOrden a ON a.Modulo = @Modulo AND a.Mov = p.Mov
LEFT OUTER JOIN Cxc r ON r.ID = p.RamaID
LEFT OUTER JOIN TipoAmortizacion ta ON ta.TipoAmortizacion = r.TipoAmortizacion
ORDER BY a.Orden, p.Vencimiento, p.Mov, p.MovID
END
ELSE
RETURN
IF (SELECT Grupo FROM Cte WHERE Cliente =  @Contacto) = 'Par'
BEGIN
SELECT @Mydate = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@Hoy))),DATEADD(mm,1,@Hoy)))
END
ELSE
SELECT @Mydate = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@Hoy))+15),DATEADD(mm,1,@Hoy)))
OPEN crAplica
FETCH NEXT FROM crAplica INTO @Estacion, @Aplica, @AplicaID, @Vencimiento, @AplicaMovTipo, @Capital, @SaldoInteresesOrdinarios, @SaldoInteresesMoratorios,
@Metodo, @LineaCredito, @Contacto
WHILE @@FETCH_STATUS <> -1 AND ((@SugerirPago = 'MINIMO' AND @Vencimiento<=@Mydate) OR (@SugerirPago = 'SALDO VENCIDO' AND @Vencimiento<=@Hoy) OR
(@SugerirPago = 'IMPORTE ESPECIFICO' AND @ImporteTotal > @SumaImporte) OR @SugerirPago = 'SALDO TOTAL')
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @SaldoMoratorios = SUM(ISNULL(h.Moratorios,0))
FROM POSHistMoratorios h JOIN CxcD d ON d.ID = h.IDGenerado AND h.Aplica = d.Aplica AND h.AplicaID = d.AplicaID
JOIN Cxc c ON c.ID = d.ID
WHERE c.Estatus = 'CONCLUIDO' AND d.Aplica = @Aplica AND d.AplicaID = @AplicaID
IF @SaldoMoratorios = NULL
SELECT @SaldoMoratorios = 0.0
IF @Metodo IN (12, 22)
SELECT @SaldoInteresesOrdinarios = 0.0
IF @Metodo = 50
SELECT @ImpuestoAdicional = DefImpuesto
FROM EmpresaGral
WHERE Empresa = @Empresa ELSE SELECT @ImpuestoAdicional = NULL
IF @SumaImporte + @SaldoInteresesMoratorios > @ImporteTotal
SELECT @SaldoInteresesMoratorios = (@ImporteTotal - @SumaImporte)
SELECT @SumaImporte = @SumaImporte + @SaldoInteresesMoratorios
IF @SumaImporte + @SaldoInteresesOrdinarios > @ImporteTotal
SELECT @SaldoInteresesOrdinarios = @ImporteTotal - @SumaImporte
SELECT @SumaImporte = @SumaImporte + @SaldoInteresesOrdinarios
SELECT @SaldoInteresesMoratorios = @SaldoInteresesMoratorios-@SaldoMoratorios
IF @SaldoInteresesMoratorios <> 0.0 OR @SaldoInteresesOrdinarios <> 0.0 OR @Capital <> 0.0
BEGIN
SELECT @Renglon = @Renglon + 2048.0
IF @Modulo = 'CXC'
INSERT POSCxcAnticipoTempD (
Estacion, ID, Sucursal, Renglon, Aplica, AplicaID, Importe, InteresesOrdinarios,
InteresesMoratorios, ImpuestoAdicional, TasaMoratorios)
VALUES (
@Estacion, 0, @Sucursal, @Renglon, @Aplica, @AplicaID, NULLIF(@Capital, 0.0), NULLIF(@SaldoInteresesOrdinarios, 0.0),
ABS(NULLIF(@SaldoInteresesMoratorios, 0.0)), @ImpuestoAdicional, @TasaMoratorios)
ELSE
INSERT POSCxcAnticipoTempD (
Estacion, ID, Sucursal, Renglon, Aplica, AplicaID, Importe, InteresesOrdinarios,
InteresesMoratorios, TasaMoratorios)
VALUES (
@Estacion, 0, @Sucursal, @Renglon, @Aplica, @AplicaID, NULLIF(@Capital, 0.0), NULLIF(@SaldoInteresesOrdinarios, 0.0),
ABS(NULLIF(@SaldoInteresesMoratorios, 0.0)), @TasaMoratorios)
END
FETCH NEXT FROM crAplica INTO @Estacion, @Aplica, @AplicaID, @Vencimiento, @AplicaMovTipo, @Capital, @SaldoInteresesOrdinarios,
@SaldoInteresesMoratorios, @Metodo, @LineaCredito, @Contacto
END
END
CLOSE crAplica
DEALLOCATE crAplica
SELECT @SaldoTotal = @ImporteTotal-SUM(ISNULL(InteresesMoratorios,0))
FROM POSCxcAnticipoTempD
WHERE Estacion = @Estacion
IF @SaldoTotal > 0
SELECT @Capital = 0.0
SELECT @SumaImporte = 0.0
BEGIN
DECLARE crAplicaD CURSOR FOR
SELECT Estacion, Sucursal, Renglon, Aplica, AplicaID, Importe
FROM POSCxcAnticipoTempD
WHERE Estacion = @Estacion
OPEN crAplicaD
FETCH NEXT FROM crAplicaD INTO @Estacion, @Sucursal, @Renglon, @Aplica, @AplicaID, @Capital
WHILE @@FETCH_STATUS <> -1 AND ((@SugerirPago = 'MINIMO' AND @Vencimiento<=@Mydate) OR(@SugerirPago = 'SALDO VENCIDO' AND @Vencimiento<=@Hoy)
OR (@SugerirPago = 'IMPORTE ESPECIFICO' AND @ImporteTotal > @SumaImporte) OR @SugerirPago = 'SALDO TOTAL')
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @SumaImporte + @Capital > @SaldoTotal
SELECT @Capital = @SaldoTotal - @SumaImporte
SELECT @SumaImporte = @SumaImporte + @Capital
IF @SaldoTotal > 0.0
BEGIN
IF @Modulo = 'CXC'
UPDATE POSCxcAnticipoTempD SET Importe = @Capital, Aplicado = 1
WHERE Estacion = @Estacion AND Sucursal = @Sucursal AND Renglon = @Renglon AND Aplica = @Aplica AND AplicaID = @AplicaID
ELSE
UPDATE POSCxcAnticipoTempD SET Importe = @SaldoTotal, Aplicado = 1
WHERE Estacion = @Estacion AND Sucursal = @Sucursal AND Renglon = @Renglon AND Aplica = @Aplica AND AplicaID = @AplicaID
END
IF @SaldoTotal = 0.0
BEGIN
IF @Modulo = 'CXC'
UPDATE POSCxcAnticipoTempD SET Importe = 0.0 , Aplicado = 1
WHERE Estacion = @Estacion AND Sucursal = @Sucursal AND Renglon = @Renglon AND Aplica = @Aplica AND AplicaID = @AplicaID
ELSE
UPDATE POSCxcAnticipoTempD SET Importe = 0.0, Aplicado = 1
WHERE Estacion = @Estacion AND Sucursal = @Sucursal AND Renglon = @Renglon AND Aplica = @Aplica AND AplicaID = @AplicaID
END
FETCH NEXT FROM crAplicaD INTO  @Estacion, @Sucursal, @Renglon, @Aplica, @AplicaID, @Capital
END
END
CLOSE crAplicaD
DEALLOCATE crAplicaD
END
RETURN
END

