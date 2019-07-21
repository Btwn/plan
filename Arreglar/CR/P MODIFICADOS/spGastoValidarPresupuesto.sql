SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGastoValidarPresupuesto
@Empresa	char(5),
@ID		int,
@FechaEmision	datetime,
@FechaRequerida	datetime,
@Acreedor	char(10),
@AntecedenteID	int,
@MovMoneda	char(10),
@Ok		int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Mes		int,
@Ano		int,
@Dias		int,
@CfgValidar		bit,
@CfgValidarCC	bit,
@CfgValidarFR	bit,
@CfgProvPresupuesto	char(10),
@AcreedorValidar	char(10),
@FechaValidar	datetime,
@Concepto		varchar(50),
@ContUso		varchar(20),
@ContUso2		varchar(20),
@ContUso3		varchar(20),
@Validar		varchar(20),
@Importe		money,
@Presupuesto	money,
@Acumulado		money,
@Pendiente		money,
@Devoluciones	money,
@Diferencia		money,
@FechaD		datetime,
@FechaA		datetime
SELECT @CfgValidar         = ISNULL(GastoValidarPresupuesto, 0),
@CfgValidarCC       = ISNULL(GastoValidarPresupuestoCC, 0),
@CfgValidarFR       = ISNULL(GastoValidarPresupuestoFR, 0),
@CfgProvPresupuesto = ProvPresupuesto
FROM EmpresaCfg2 WITH (NOLOCK)
WHERE Empresa = @Empresa
IF @CfgValidar = 0 AND @CfgValidarCC = 0 RETURN
IF @CfgValidarFR = 1
SELECT @FechaValidar = ISNULL(@FechaRequerida, @FechaEmision)
ELSE
SELECT @FechaValidar = @FechaEmision
EXEC spExtraerFecha @FechaValidar OUTPUT
SELECT @Mes = DATEPART(month, @FechaValidar),
@Ano = DATEPART(year, @FechaValidar)
EXEC spDiasMes @Mes, @Ano, @Dias OUTPUT
IF @CfgValidarCC = 1
DECLARE crGasto CURSOR FOR
SELECT g.Concepto, NULLIF(RTRIM(g.ContUso), ''), NULLIF(RTRIM(g.ContUso2), ''), NULLIF(RTRIM(g.ContUso3), ''), UPPER(c.ValidarPresupuesto), SUM(g.Importe-ISNULL(g.Provision, 0.0))
FROM GastoD g WITH (NOLOCK), Concepto c
WITH(NOLOCK) WHERE g.ID = @ID AND g.Concepto = c.Concepto AND UPPER(c.ValidarPresupuesto) IN ('MENSUAL', 'ACUMULADO', 'ANUAL')
GROUP BY g.Concepto, g.ContUso, g.ContUso2, g.ContUso3, UPPER(c.ValidarPresupuesto)
ELSE
DECLARE crGasto CURSOR FOR
SELECT g.Concepto, CONVERT(varchar(20), NULL), CONVERT(varchar(20), NULL), CONVERT(varchar(20), NULL), UPPER(c.ValidarPresupuesto), SUM(g.Importe-ISNULL(g.Provision, 0.0))
FROM GastoD g WITH (NOLOCK), Concepto c
WITH(NOLOCK) WHERE g.ID = @ID AND g.Concepto = c.Concepto AND UPPER(c.ValidarPresupuesto) IN ('MENSUAL', 'ACUMULADO', 'ANUAL')
GROUP BY g.Concepto, UPPER(c.ValidarPresupuesto)
OPEN crGasto
FETCH NEXT FROM crGasto INTO @Concepto, @ContUso, @ContUso2, @ContUso3, @Validar, @Importe
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Presupuesto = 0.0, @Acumulado = 0.0, @Pendiente = 0.0, @Devoluciones = 0.0
IF @Validar = 'MENSUAL'
BEGIN
EXEC spIntToDateTime 1,     @Mes, @Ano, @FechaD OUTPUT
EXEC spIntToDateTime @Dias, @Mes, @Ano, @FechaA OUTPUT
END ELSE
IF @Validar = 'ACUMULADO'
BEGIN
EXEC spIntToDateTime 1,     1,    @Ano, @FechaD OUTPUT
EXEC spIntToDateTime @Dias, @Mes, @Ano, @FechaA OUTPUT
END ELSE
IF @Validar = 'ANUAL'
BEGIN
EXEC spIntToDateTime 1,   1, @Ano, @FechaD OUTPUT
EXEC spIntToDateTime 31, 12, @Ano, @FechaA OUTPUT
END
IF @CfgValidarFR = 1
BEGIN
SELECT @Presupuesto = ISNULL(SUM(d.Importe*mt.Factor), 0.0)
FROM Gasto e WITH (NOLOCK), GastoD d WITH (NOLOCK), MovTipo mt
WITH(NOLOCK) WHERE e.Empresa = @Empresa AND e.ID = d.ID AND e.Estatus IN ('PENDIENTE', 'CONCLUIDO') AND e.FechaRequerida BETWEEN @FechaD AND @FechaA
AND d.Concepto = @Concepto AND e.Moneda = @MovMoneda
AND ISNULL(d.ContUso, '')  = ISNULL(ISNULL(@ContUso, d.ContUso), '')
AND ISNULL(d.ContUso2, '') = ISNULL(ISNULL(@ContUso2, d.ContUso2), '')
AND ISNULL(d.ContUso3, '') = ISNULL(ISNULL(@ContUso3, d.ContUso3), '')
AND mt.Modulo = 'GAS' AND mt.Mov = e.Mov AND mt.Clave IN ('GAS.PR', 'GAS.DPR')
SELECT @Acumulado = ISNULL(SUM(d.Importe), 0.0)-ISNULL(SUM(d.Provision), 0.0)
FROM Gasto e WITH (NOLOCK), GastoD d WITH (NOLOCK), MovTipo mt
WITH(NOLOCK) WHERE e.Empresa = @Empresa AND e.ID = d.ID AND e.FechaRequerida BETWEEN @FechaD AND @FechaA
AND d.Concepto = @Concepto AND e.Moneda = @MovMoneda
AND ISNULL(d.ContUso, '')  = ISNULL(ISNULL(@ContUso, d.ContUso), '')
AND ISNULL(d.ContUso2, '') = ISNULL(ISNULL(@ContUso2, d.ContUso2), '')
AND ISNULL(d.ContUso3, '') = ISNULL(ISNULL(@ContUso3, d.ContUso3), '')
AND mt.Modulo = 'GAS' AND e.Estatus IN ('PENDIENTE', 'CONCLUIDO') AND mt.Mov = e.Mov AND mt.Clave IN ('GAS.G', 'GAS.P', 'GAS.GTC', 'GAS.C', 'GAS.CCH')
SELECT @Pendiente = ISNULL(SUM(d.Importe), 0.0)
FROM Gasto e WITH (NOLOCK), GastoD d WITH (NOLOCK), MovTipo mt
WITH(NOLOCK) WHERE e.Empresa = @Empresa AND e.ID = d.ID AND e.FechaRequerida BETWEEN @FechaD AND @FechaA
AND d.Concepto = @Concepto AND e.Moneda = @MovMoneda
AND ISNULL(d.ContUso, '')  = ISNULL(ISNULL(@ContUso, d.ContUso), '')
AND ISNULL(d.ContUso2, '') = ISNULL(ISNULL(@ContUso2, d.ContUso2), '')
AND ISNULL(d.ContUso3, '') = ISNULL(ISNULL(@ContUso3, d.ContUso3), '')
AND mt.Modulo = 'GAS' AND e.Estatus = 'PENDIENTE' AND mt.Mov = e.Mov AND mt.Clave IN ('GAS.S', 'GAS.A')
AND e.ID <> @AntecedenteID
SELECT @Devoluciones = ISNULL(SUM(d.Importe), 0.0)-ISNULL(SUM(d.Provision), 0.0)
FROM Gasto e WITH (NOLOCK), GastoD d WITH (NOLOCK), MovTipo mt
WITH(NOLOCK) WHERE e.Empresa = @Empresa AND e.ID = d.ID AND e.Estatus = 'CONCLUIDO' AND e.FechaRequerida BETWEEN @FechaD AND @FechaA
AND d.Concepto = @Concepto AND e.Moneda = @MovMoneda
AND ISNULL(d.ContUso, '')  = ISNULL(ISNULL(@ContUso, d.ContUso), '')
AND ISNULL(d.ContUso2, '') = ISNULL(ISNULL(@ContUso2, d.ContUso2), '')
AND ISNULL(d.ContUso3, '') = ISNULL(ISNULL(@ContUso3, d.ContUso3), '')
AND mt.Modulo = 'GAS' AND mt.Mov = e.Mov AND mt.Clave IN ('GAS.OI', 'GAS.DG', 'GAS.DC')
END ELSE
BEGIN
SELECT @Presupuesto = ISNULL(SUM(d.Importe*mt.Factor), 0.0)
FROM Gasto e WITH (NOLOCK) , GastoD d WITH (NOLOCK), MovTipo mt
WITH(NOLOCK) WHERE e.Empresa = @Empresa AND e.ID = d.ID AND e.Estatus IN ('PENDIENTE', 'CONCLUIDO') AND e.FechaEmision BETWEEN @FechaD AND @FechaA
AND d.Concepto = @Concepto AND e.Moneda = @MovMoneda
AND ISNULL(d.ContUso, '')  = ISNULL(ISNULL(@ContUso, d.ContUso), '')
AND ISNULL(d.ContUso2, '') = ISNULL(ISNULL(@ContUso2, d.ContUso2), '')
AND ISNULL(d.ContUso3, '') = ISNULL(ISNULL(@ContUso3, d.ContUso3), '')
AND mt.Modulo = 'GAS' AND mt.Mov = e.Mov AND mt.Clave IN ('GAS.PR', 'GAS.DPR')
SELECT @Acumulado = ISNULL(SUM(d.Importe), 0.0)-ISNULL(SUM(d.Provision), 0.0)
FROM Gasto e WITH (NOLOCK), GastoD d WITH (NOLOCK), MovTipo mt
WITH(NOLOCK) WHERE e.Empresa = @Empresa AND e.ID = d.ID AND e.FechaEmision BETWEEN @FechaD AND @FechaA
AND d.Concepto = @Concepto AND e.Moneda = @MovMoneda
AND ISNULL(d.ContUso, '')  = ISNULL(ISNULL(@ContUso, d.ContUso), '')
AND ISNULL(d.ContUso2, '') = ISNULL(ISNULL(@ContUso2, d.ContUso2), '')
AND ISNULL(d.ContUso3, '') = ISNULL(ISNULL(@ContUso3, d.ContUso3), '')
AND mt.Modulo = 'GAS' AND e.Estatus IN ('PENDIENTE', 'CONCLUIDO') AND mt.Mov = e.Mov AND mt.Clave IN ('GAS.G', 'GAS.P', 'GAS.GTC', 'GAS.C', 'GAS.CCH')
SELECT @Pendiente = ISNULL(SUM(d.Importe), 0.0)
FROM Gasto e WITH (NOLOCK), GastoD d WITH (NOLOCK), MovTipo mt
WITH(NOLOCK) WHERE e.Empresa = @Empresa AND e.ID = d.ID AND e.FechaEmision BETWEEN @FechaD AND @FechaA
AND d.Concepto = @Concepto AND e.Moneda = @MovMoneda
AND ISNULL(d.ContUso, '')  = ISNULL(ISNULL(@ContUso, d.ContUso), '')
AND ISNULL(d.ContUso2, '') = ISNULL(ISNULL(@ContUso2, d.ContUso2), '')
AND ISNULL(d.ContUso3, '') = ISNULL(ISNULL(@ContUso3, d.ContUso3), '')
AND mt.Modulo = 'GAS' AND e.Estatus = 'PENDIENTE' AND mt.Mov = e.Mov AND mt.Clave IN ('GAS.S', 'GAS.A')
AND e.ID <> @AntecedenteID
SELECT @Devoluciones = ISNULL(SUM(d.Importe), 0.0)-ISNULL(SUM(d.Provision), 0.0)
FROM Gasto e WITH(NOLOCK), GastoD d WITH(NOLOCK), MovTipo mt
WITH(NOLOCK) WHERE e.Empresa = @Empresa AND e.ID = d.ID AND e.Estatus = 'CONCLUIDO' AND e.FechaEmision BETWEEN @FechaD AND @FechaA
AND d.Concepto = @Concepto AND e.Moneda = @MovMoneda
AND ISNULL(d.ContUso, '')  = ISNULL(ISNULL(@ContUso, d.ContUso), '')
AND ISNULL(d.ContUso2, '') = ISNULL(ISNULL(@ContUso2, d.ContUso2), '')
AND ISNULL(d.ContUso3, '') = ISNULL(ISNULL(@ContUso3, d.ContUso3), '')
AND mt.Modulo = 'GAS' AND mt.Mov = e.Mov AND mt.Clave IN ('GAS.OI', 'GAS.DG', 'GAS.DC')
END
SELECT @Acumulado = @Acumulado - @Devoluciones
SELECT @Diferencia = @Presupuesto - @Acumulado - @Pendiente - @Importe
IF @Diferencia < 0.0
SELECT @Ok = 20900, @OkRef = RTRIM(@Concepto)+'<BR><BR>Presupuesto: '+LTRIM(CONVERT(char, @Presupuesto))+'<BR>Acumulado: '+LTRIM(CONVERT(char, @Acumulado))+'<BR>Pendiente: '+LTRIM(CONVERT(char, @Pendiente))+'<BR>Excedente: '+LTRIM(CONVERT(char, -@Diferencia))
END
FETCH NEXT FROM crGasto  INTO @Concepto, @ContUso, @ContUso2, @ContUso3, @Validar, @Importe
END
CLOSE crGasto
DEALLOCATE crGasto
END

