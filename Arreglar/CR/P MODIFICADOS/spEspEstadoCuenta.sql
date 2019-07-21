SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spEspEstadoCuenta
@Estacion	int,
@Empresa	char(5),
@ClienteD	char(10),
@ClienteA	char(10),
@FechaD	datetime,
@FechaA	datetime,
@Moneda	char(10),
@SinMovAplicacion  bit = 0
/*
Fast Forward Panama
Version 7
Fecha: 2007-11-28
JNAVARRETE
*/
AS BEGIN
DECLARE
@Plazo1 int,
@Plazo2 int,
@Plazo3 int,
@Plazo4 int,
@ID  int,
@SaldoMovil money,
@Cargo money,
@Abono money,
@Cliente char(10),
@ClienteAnterior char(10),
@cr_Moneda char(10),
@cr_MonedaAnterior char(10)
SELECT @Moneda=NULLIF(@Moneda,'Null')
SELECT @Moneda=NULLIF(@Moneda,'')
SELECT @Plazo1=CxcPlazo1, @Plazo2=CxcPlazo2, @Plazo3=CxcPlazo3, @Plazo4=CxcPlazo4 FROM EmpresaCfg WHERE Empresa=@Empresa
EXEC spVerAuxCorte @Estacion, @Empresa, 'CXC', '18991230', @FechaA, @ClienteD, @ClienteA
DELETE espCxcEstadoCuentaAntiguedad WHERE Estacion=@Estacion
INSERT INTO espCxcEstadoCuentaAntiguedad
SELECT
@Estacion, v.Moneda, v.Cuenta, v.Mov, v.MovID, v.ModuloID, v.Saldo, Cxc.Vencimiento, m.Clave,
'Dias'=CASE WHEN m.Clave IN
('CXC.F','CXC.FA','CXC.AF','CXC.CA','CXC.CAD','CXC.CAP','CXC.VV','CXC.CD','CXC.D','CXC.DM','CXC.DA','CXC.DP','CXC.NCP','CXC.FAC','CXC.DAC')
THEN DATEDIFF(dd,Cxc.Vencimiento,@FechaA) ELSE NULL END,
NULL, NULL, NULL, NULL, NULL, NULL, NULL
FROM
VerAuxCorte v
LEFT OUTER JOIN Cxc  WITH(NOLOCK) ON v.ModuloID=Cxc.ID
LEFT OUTER JOIN MovTipo m  WITH(NOLOCK) ON v.Mov=m.Mov AND m.Modulo='CXC'
WHERE v.Estacion=@Estacion AND v.Empresa=@Empresa
UPDATE espCxcEstadoCuentaAntiguedad WITH(ROWLOCK) SET
Posfechado=CASE WHEN MovTipo='CXC.NCP' THEN Saldo ELSE NULL END,
AlCorriente=CASE WHEN ISNULL(Dias,0)<=0 THEN Saldo ELSE NULL END,
Plazo1=CASE WHEN @Plazo1>0 AND ISNULL(Dias,0)>0 AND ISNULL(Dias,0)<=@Plazo1 THEN Saldo ELSE NULL END,
Plazo2=CASE WHEN @Plazo2>0 AND ISNULL(Dias,0)>@Plazo1 AND ISNULL(Dias,0)<=@Plazo2 THEN Saldo ELSE NULL END,
Plazo3=CASE WHEN @Plazo3>0 AND ISNULL(Dias,0)>@Plazo2 AND ISNULL(Dias,0)<=@Plazo3 THEN Saldo ELSE NULL END,
Plazo4=CASE WHEN @Plazo4>0 AND ISNULL(Dias,0)>@Plazo3 AND ISNULL(Dias,0)<=@Plazo4 THEN Saldo ELSE NULL END,
PlazoMayor=CASE WHEN ISNULL(Dias,0)>@Plazo4 THEN Saldo ELSE NULL END
WHERE Estacion=@Estacion
DELETE espCxcEstadoCuentaClaveClientes WHERE Estacion=@Estacion
INSERT INTO espCxcEstadoCuentaClaveClientes
SELECT @Estacion,
Cte.Cliente,
Mon.Moneda
FROM Cte CROSS  WITH(NOLOCK) JOIN Mon
WHERE Cte.Cliente BETWEEN @ClienteD AND @ClienteA AND
Mon.Moneda=ISNULL(@Moneda,Mon.Moneda) AND
Cte.TieneMovimientos=1
DELETE espCxcEstadoCuentaAux WHERE Estacion=@Estacion
INSERT INTO espCxcEstadoCuentaAux
SELECT
@Estacion,
Auxiliar.ID,
Auxiliar.Moneda,
Auxiliar.Cuenta,
Auxiliar.ModuloID,
Auxiliar.Mov,
Auxiliar.MovID,
Auxiliar.Fecha,
Auxiliar.Cargo,
Auxiliar.Abono,
Auxiliar.TipoCambio,
'Dias'=CASE WHEN MovTipo.Clave IN
('CXC.F','CXC.FA','CXC.AF','CXC.CA','CXC.CAD','CXC.CAP','CXC.VV','CXC.CD','CXC.D','CXC.DM','CXC.DA','CXC.DP','CXC.NCP','CXC.FAC','CXC.DAC')
THEN DATEDIFF(dd,Cxc.Vencimiento,@FechaA) ELSE NULL END,
Aplica.ID,
Aplica.Mov,
Aplica.MovID
FROM
espCxcEstadoCuentaClaveClientes
JOIN Auxiliar   WITH(NOLOCK) ON espCxcEstadoCuentaClaveClientes.Cliente=Auxiliar.Cuenta
AND espCxcEstadoCuentaClaveClientes.Moneda=Auxiliar.Moneda
JOIN Cxc    WITH(NOLOCK) ON  Auxiliar.ModuloID=Cxc.ID
AND Auxiliar.Modulo='CXC'
JOIN Cxc Aplica   WITH(NOLOCK) ON  Auxiliar.Aplica=Aplica.Mov
AND Auxiliar.AplicaID=Aplica.MovID
AND Auxiliar.Empresa=Aplica.Empresa
AND Auxiliar.Cuenta=Aplica.Cliente
JOIN MovTipo mtAplica  WITH(NOLOCK) ON Auxiliar.Aplica=mtAplica.Mov
AND mtAplica.Modulo='CXC'
JOIN MovTipo   WITH(NOLOCK) ON Auxiliar.Mov=MovTipo.Mov
AND MovTipo.Modulo='CXC'
WHERE
espCxcEstadoCuentaClaveClientes.Estacion=@Estacion AND
Aplica.Estatus NOT IN ('SINAFECTAR', 'CANCELADO') AND
Auxiliar.Moneda=ISNULL(@Moneda,Auxiliar.Moneda) AND
mtAplica.Clave IN ('CXC.A', 'CXC.F', 'CXC.FA', 'CXC.D', 'CXC.DA', 'CXC.DP', 'CXC.NC', 'CXC.NCD', 'CXC.DV', 'CXC.NCP', 'CXC.CA', 'CXC.CAD',
'CXC.CAP','CXC.CD', 'CXC.FAC', 'CXC.RM', 'CXC.IM', 'CXC.AR', 'CXC.DM', 'CXC.DAC', 'CXC.NCF') AND
Auxiliar.Fecha BETWEEN @FechaD AND @FechaA AND
Auxiliar.EsCancelacion = 0 AND
Cxc.Estatus NOT IN ('SINAFECTAR', 'CANCELADO') AND
Auxiliar.Empresa=@Empresa
IF @SinMovAplicacion=1
BEGIN
DELETE espCxcEstadoCuentaAux
FROM espCxcEstadoCuentaAux  WITH(NOLOCK) JOIN MovTipo  WITH(NOLOCK) ON espCxcEstadoCuentaAux.Mov=MovTipo.Mov AND MovTipo.Modulo='CXC'
WHERE MovTipo.Clave IN ('CXC.ANC') AND Estacion=@Estacion
END
DELETE espCxcEstadoCuentaSaldos WHERE Estacion=@Estacion
DECLARE curTempCtes CURSOR LOCAL FOR
SELECT Cliente, Moneda FROM espCxcEstadoCuentaClaveClientes WHERE Estacion=@Estacion
DECLARE @C_Cte  char(10),
@C_Mon  char(10),
@SInicial money,
@SFinal  money,
@Posfechado money,
@AlCorriente money,
@Rango1  money,
@Rango2  money,
@Rango3  money,
@Rango4  money,
@RangoMayor money,
@CargosA money,
@AbonosA money,
@FechaAMasUno datetime
SELECT @FechaAMasUno=DATEADD(dd,1,@FechaA)
OPEN curTempCtes
FETCH NEXT FROM curTempCtes  INTO @C_Cte, @C_Mon
WHILE @@FETCH_STATUS<>-1
BEGIN
IF @@FETCH_STATUS<>-2
BEGIN
EXEC dbo.spPUVerSaldoInicialM @Empresa, 'CXC', @C_Mon, @C_Cte, @FechaD, NULL, @SInicial OUTPUT
SELECT @SInicial=ISNULL(@SInicial, 0)
EXEC dbo.spPUVerSaldoInicialM @Empresa, 'CXC', @C_Mon, @C_Cte, @FechaAMasUno, NULL, @SFinal OUTPUT
SELECT @SFinal=ISNULL(@SFinal, 0)
SELECT
@Posfechado=SUM(ISNULL(Posfechado,0)),
@AlCorriente=SUM(ISNULL(AlCorriente,0)),
@Rango1=SUM(ISNULL(Plazo1,0)),
@Rango2=SUM(ISNULL(Plazo2,0)),
@Rango3=SUM(ISNULL(Plazo3,0)),
@Rango4=SUM(ISNULL(Plazo4,0)),
@RangoMayor=SUM(ISNULL(PlazoMayor,0))
FROM espCxcEstadoCuentaAntiguedad
WITH(NOLOCK) WHERE Estacion=@Estacion AND Moneda=@C_Mon AND Cuenta=@C_Cte
SELECT @CargosA=SUM(ISNULL(Cargo,0)) FROM espCxcEstadoCuentaAux WHERE Estacion=@Estacion AND Cliente=@C_Cte AND Moneda=@C_Mon
SELECT @AbonosA=SUM(ISNULL(Abono,0)) FROM espCxcEstadoCuentaAux WHERE Estacion=@Estacion AND Cliente=@C_Cte AND Moneda=@C_Mon
INSERT INTO espCxcEstadoCuentaSaldos
VALUES (@Estacion, @C_Cte, @C_Mon, @SInicial, @SFinal, @Posfechado, @AlCorriente, @Rango1, @Rango2, @Rango3, @Rango4, @RangoMayor, @CargosA, @AbonosA)
END
FETCH NEXT FROM curTempCtes  INTO @C_Cte, @C_Mon
END
CLOSE curTempCtes
DEALLOCATE curTempCtes
DELETE espCxcEstadoCuenta WHERE Estacion=@Estacion
INSERT INTO espCxcEstadoCuenta (Estacion, Cliente, EnviarA, Moneda, AuxiliarID, IDMov, Mov, MovID, FechaEmision, Cargo, Abono, TipoCambio, Vencimiento, Dias,
IDAplica, Aplica, AplicaID, FechaAplica, SaldoInicial, SaldoFinal, Posfechado, AlCorriente, Rango1, Rango2, Rango3, Rango4, RangoMayor, CargoA, AbonosA)
SELECT
@Estacion,
espCxcEstadoCuentaClaveClientes.Cliente,
Cxc.ClienteEnviarA,
espCxcEstadoCuentaClaveClientes.Moneda,
espCxcEstadoCuentaAux.AuxiliarID,
espCxcEstadoCuentaAux.IDMov,
espCxcEstadoCuentaAux.Mov,
espCxcEstadoCuentaAux.MovID,
espCxcEstadoCuentaAux.FechaEmision,
espCxcEstadoCuentaAux.Cargo,
espCxcEstadoCuentaAux.Abono,
espCxcEstadoCuentaAux.TipoCambio,
'Vencimiento'=CASE WHEN MovTipo.Clave IN
('CXC.F','CXC.FA','CXC.AF','CXC.CA','CXC.CAD','CXC.CAP','CXC.VV','CXC.CD','CXC.D','CXC.DM','CXC.DA','CXC.DP','CXC.NCP','CXC.FAC','CXC.DAC')
THEN Cxc.Vencimiento ELSE NULL END,
espCxcEstadoCuentaAux.Dias,
espCxcEstadoCuentaAux.IDAplica,
espCxcEstadoCuentaAux.Aplica,
espCxcEstadoCuentaAux.AplicaID,
'FechaAplica'=Aplica.FechaEmision,
espCxcEstadoCuentaSaldos.Inicial,
espCxcEstadoCuentaSaldos.Final,
espCxcEstadoCuentaSaldos.Posfechado,
espCxcEstadoCuentaSaldos.AlCorriente,
espCxcEstadoCuentaSaldos.Rango1,
espCxcEstadoCuentaSaldos.Rango2,
espCxcEstadoCuentaSaldos.Rango3,
espCxcEstadoCuentaSaldos.Rango4,
espCxcEstadoCuentaSaldos.RangoMayor,
espCxcEstadoCuentaSaldos.CargosA,
espCxcEstadoCuentaSaldos.AbonosA
FROM
espCxcEstadoCuentaClaveClientes
LEFT OUTER JOIN espCxcEstadoCuentaAux ON
espCxcEstadoCuentaClaveClientes.Estacion=espCxcEstadoCuentaAux.Estacion
AND espCxcEstadoCuentaClaveClientes.Cliente=espCxcEstadoCuentaAux.Cliente
AND espCxcEstadoCuentaClaveClientes.Moneda=espCxcEstadoCuentaAux.Moneda
LEFT OUTER JOIN Cxc Aplica  WITH(NOLOCK) ON espCxcEstadoCuentaAux.IDAplica=Aplica.ID
LEFT OUTER JOIN Cxc   WITH(NOLOCK) ON espCxcEstadoCuentaAux.IDMov=Cxc.ID
JOIN espCxcEstadoCuentaSaldos ON
espCxcEstadoCuentaClaveClientes.Estacion=espCxcEstadoCuentaSaldos.Estacion AND
espCxcEstadoCuentaClaveClientes.Cliente=espCxcEstadoCuentaSaldos.Cliente AND
espCxcEstadoCuentaClaveClientes.Moneda=espCxcEstadoCuentaSaldos.Moneda
LEFT OUTER JOIN MovTipo   WITH(NOLOCK) ON espCxcEstadoCuentaAux.Mov=MovTipo.Mov AND MovTipo.Modulo='CXC'
WHERE espCxcEstadoCuentaClaveClientes.Estacion=@Estacion
ORDER BY
espCxcEstadoCuentaClaveClientes.Cliente, espCxcEstadoCuentaAux.Moneda, espCxcEstadoCuentaAux.FechaEmision, Cxc.ID
SELECT @SaldoMovil=0
DECLARE crSaldoMovil CURSOR LOCAL FOR
SELECT ID, Cliente, Moneda, Cargo, Abono FROM espCxcEstadoCuenta WITH(NOLOCK) WHERE Estacion=@Estacion
OPEN crSaldoMovil
FETCH NEXT FROM crSaldoMovil  INTO @ID, @Cliente, @cr_Moneda, @Cargo, @Abono
SELECT @ClienteAnterior=@Cliente, @cr_MonedaAnterior=@cr_Moneda
WHILE @@FETCH_STATUS<>-1
BEGIN
IF @@FETCH_STATUS<>-2
BEGIN
IF NOT (@ClienteAnterior=@Cliente AND @cr_MonedaAnterior=@cr_Moneda) SELECT @SaldoMovil=0
SELECT @SaldoMovil=@SaldoMovil+ISNULL(@Cargo,0)-ISNULL(@Abono,0)
UPDATE espCxcEstadoCuenta  WITH(ROWLOCK) SET SaldoMovil=@SaldoMovil WHERE ID=@ID
SELECT @ClienteAnterior=@Cliente, @cr_MonedaAnterior=@cr_Moneda
END
FETCH NEXT FROM crSaldoMovil  INTO @ID, @Cliente, @cr_Moneda, @Cargo, @Abono
END
CLOSE crSaldoMovil
DEALLOCATE crSaldoMovil
UPDATE espCxcEstadoCuenta  WITH(ROWLOCK) SET SaldoMovil=SaldoMovil+ISNULL(SaldoInicial,0) WHERE Estacion=@Estacion
END

