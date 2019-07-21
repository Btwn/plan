SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCorteGenerarEstadoCuentaSimple
@Estacion			int,
@Empresa			char(5),
@Modulo				char(5),
@FechaD				datetime,
@CuentaD			char(10),
@CuentaA			char(10),
@Sucursal			int,
@EstatusEspecifico	char(15) = NULL,
@Moneda				varchar(10)

AS BEGIN
DECLARE
@Ejercicio				int,
@Periodo				int,
@CuentaCursor			varchar(10),
@MonedaCursor			varchar(10)
DECLARE @AgrupacionGrafica TABLE
(
Cuenta					varchar(10) COLLATE DATABASE_DEFAULT NULL,
Moneda					varchar(10) COLLATE DATABASE_DEFAULT NULL,
Ejercicio					int NULL,
Periodo					int NULL
)
DECLARE @GraficaTemporal TABLE
(
Estacion					int NULL,
Empresa					varchar(5) COLLATE DATABASE_DEFAULT NULL,
Modulo					varchar(5)  COLLATE DATABASE_DEFAULT NULL,
Moneda					varchar(10) COLLATE DATABASE_DEFAULT NULL,
Cuenta					varchar(10) COLLATE DATABASE_DEFAULT NULL,
SaldoDescripcion			varchar(50) COLLATE DATABASE_DEFAULT NULL,
SaldoImporte				float NULL
)
EXEC spExtraerFecha @FechaD OUTPUT
IF @CuentaD = '0' SELECT @CuentaD = NULL
IF @CuentaD = '' SELECT @CuentaD = NULL
IF @CuentaD IN ('', '(Todos)') SELECT @CuentaD = NULL
IF @CuentaA = '0' SELECT @CuentaA = NULL
IF @CuentaA = '' SELECT @CuentaA = NULL
IF @CuentaA IN ('', '(Todos)') SELECT @CuentaA = NULL
IF @Sucursal = -1 SELECT @Sucursal = NULL
SELECT @EstatusEspecifico = NULLIF(RTRIM(@EstatusEspecifico), '')
IF @EstatusEspecifico = '0' SELECT @EstatusEspecifico = NULL
DELETE EstadoCuenta WHERE Estacion = @Estacion AND Modulo = @Modulo
DELETE EstadoCuentaGrafica WHERE Estacion = @Estacion AND Modulo = @Modulo
IF @Modulo = 'CXC'
BEGIN
INSERT @AgrupacionGrafica (Cuenta,   Moneda,   Ejercicio,   Periodo)
SELECT  a.Cuenta, a.Moneda, a.Ejercicio, a.Periodo
FROM Auxiliar a JOIN Cxc c
ON c.Empresa = a.Empresa AND c.ID = a.ModuloID JOIN Cxc ca
ON ca.Empresa = c.Empresa AND ca.Mov = a.Aplica AND ca.MovID = a.AplicaID JOIN MovTipo mt
ON mt.Mov = ca.Mov JOIN MovTipo mt2
ON mt2.Mov = c.Mov
WHERE a.Modulo = 'CXC'
AND mt2.Modulo = 'CXC'
AND ISNULL(mt2.Interno,0) = 0
AND mt.Clave IN ('CXC.A', 'CXC.AR', 'CXC.F', 'CXC.FAC', 'CXC.FA', 'CXC.D', 'CXC.DM', 'CXC.DA', 'CXC.DP', 'CXC.NC', 'CXC.DAC', 'CXC.NCD','CXC.NCF', 'CXC.DV', 'CXC.NCP', 'CXC.CA', 'CXC.CAD', 'CXC.CAP','CXC.CD', 'CXC.RM', 'CXC.IM', 'CXC.SD', 'CXC.SCH')
AND c.Estatus NOT IN ('SINAFECTAR','CANCELADO')
AND (ca.Estatus = 'PENDIENTE' OR (ca.Estatus = 'CONCLUIDO' AND ca.FechaConclusion >= @FechaD))
AND ca.Estatus = CASE WHEN @EstatusEspecifico IS NULL THEN ca.Estatus ELSE @EstatusEspecifico END
AND a.Cuenta BETWEEN ISNULL(@CuentaD, a.Cuenta) AND ISNULL(@CuentaA, a.Cuenta)
AND c.Moneda = ISNULL(@Moneda, c.Moneda)
AND a.Empresa = @Empresa 
GROUP BY a.Cuenta, a.Moneda, a.Ejercicio, a.Periodo
INSERT @AgrupacionGrafica (Cuenta,   Moneda,   Ejercicio,   Periodo)
SELECT  a.Cuenta, a.Moneda, a.Ejercicio, a.Periodo
FROM Auxiliar a JOIN Dinero c
ON c.Empresa = a.Empresa AND c.ID = a.ModuloID JOIN Dinero ca
ON ca.Empresa = c.Empresa AND ca.Mov = a.Aplica AND ca.MovID = a.AplicaID JOIN MovTipo mt
ON mt.Mov = ca.Mov JOIN MovTipo mt2
ON mt2.Mov = c.Mov
WHERE a.Modulo = 'DIN'
AND mt2.Modulo = 'DIN'
AND ISNULL(mt2.Interno,0) = 0
AND mt.Clave IN ('DIN.SD','DIN.D','DIN.CH','DIN.SCH')
AND c.Estatus NOT IN ('SINAFECTAR','CANCELADO')
AND (ca.Estatus = 'PENDIENTE' OR (ca.Estatus = 'CONCLUIDO' AND ca.FechaConclusion >= @FechaD))
AND ca.Estatus = CASE WHEN @EstatusEspecifico IS NULL THEN ca.Estatus ELSE @EstatusEspecifico END
AND a.Cuenta BETWEEN ISNULL(@CuentaD, a.Cuenta) AND ISNULL(@CuentaA, a.Cuenta)
AND c.Moneda = ISNULL(@Moneda, c.Moneda)
AND a.Empresa = @Empresa 
GROUP BY a.Cuenta, a.Moneda, a.Ejercicio, a.Periodo
DECLARE crCuenta CURSOR FOR
SELECT Cuenta
FROM @AgrupacionGrafica
GROUP BY Cuenta
OPEN crCuenta
FETCH NEXT FROM crCuenta INTO @CuentaCursor
WHILE @@FETCH_STATUS = 0
BEGIN
DECLARE crMoneda CURSOR FOR
SELECT Moneda
FROM @AgrupacionGrafica
WHERE Cuenta = @CuentaCursor
GROUP BY Moneda
OPEN crMoneda
FETCH NEXT FROM crMoneda INTO @MonedaCursor
WHILE @@FETCH_STATUS = 0
BEGIN
DECLARE crAuxiliar CURSOR FOR
SELECT TOP 4 Ejercicio, Periodo
FROM @AgrupacionGrafica
WHERE Cuenta = @CuentaCursor
AND Moneda = @MonedaCursor
GROUP BY Ejercicio, Periodo
ORDER BY Ejercicio DESC, Periodo DESC
OPEN crAuxiliar
FETCH NEXT FROM crAuxiliar INTO @Ejercicio, @Periodo
WHILE @@FETCH_STATUS = 0
BEGIN
INSERT @GraficaTemporal (Empresa,  Estacion,  Modulo,  Moneda,   Cuenta,   SaldoDescripcion,                                                                                             SaldoImporte)
SELECT  @Empresa, @Estacion, @Modulo, a.Moneda, a.Cuenta, CONVERT(varchar,@Ejercicio) + '-' + CASE WHEN @Periodo < 10 THEN '0' ELSE '' END + CONVERT(varchar,@Periodo), ISNULL(SUM(dbo.fnImporteAMonedaContable(ISNULL(a.Cargo,0.0)-ISNULL(a.Abono,0.0),c.TipoCambio,ec.ContMoneda)),0.0)
FROM Auxiliar a JOIN Cxc c
ON c.Empresa = a.Empresa AND c.ID = a.ModuloID JOIN Cxc ca
ON ca.Empresa = c.Empresa AND ca.Mov = a.Aplica AND ca.MovID = a.AplicaID JOIN MovTipo mt
ON mt.Mov = ca.Mov JOIN MovTipo mt2
ON mt2.Mov = c.Mov JOIN EmpresaCFG ec
ON ec.Empresa = a.Empresa
WHERE a.Modulo = 'CXC'
AND mt2.Modulo = 'CXC'
AND ISNULL(mt2.Interno,0) = 0
AND mt.Clave IN ('CXC.A', 'CXC.AR', 'CXC.F', 'CXC.FAC', 'CXC.FA', 'CXC.D', 'CXC.DM', 'CXC.DA', 'CXC.DP', 'CXC.NC', 'CXC.DAC', 'CXC.NCD','CXC.NCF', 'CXC.DV', 'CXC.NCP', 'CXC.CA', 'CXC.CAD', 'CXC.CAP','CXC.CD', 'CXC.RM', 'CXC.IM', 'CXC.SD', 'CXC.SCH')
AND c.Estatus NOT IN ('SINAFECTAR','CANCELADO')
AND (ca.Estatus = 'PENDIENTE' OR (ca.Estatus = 'CONCLUIDO' AND ca.FechaConclusion >= @FechaD))
AND ca.Estatus = CASE WHEN @EstatusEspecifico IS NULL THEN ca.Estatus ELSE @EstatusEspecifico END
AND (a.Ejercicio < @Ejercicio OR (a.Ejercicio = @Ejercicio AND a.Periodo <= @Periodo))
AND a.Cuenta = @CuentaCursor
AND a.Moneda = @MonedaCursor
AND a.Empresa = @Empresa 
GROUP BY a.Cuenta, a.Moneda
INSERT @GraficaTemporal (Empresa,  Estacion,  Modulo,  Moneda,   Cuenta,   SaldoDescripcion,                                                                                             SaldoImporte)
SELECT  @Empresa, @Estacion, @Modulo, a.Moneda, a.Cuenta, CONVERT(varchar,@Ejercicio) + '-' + CASE WHEN @Periodo < 10 THEN '0' ELSE '' END + CONVERT(varchar,@Periodo), ISNULL(SUM(dbo.fnImporteAMonedaContable(ISNULL(a.Cargo,0.0)-ISNULL(a.Abono,0.0),c.TipoCambio,ec.ContMoneda)),0.0)
FROM Auxiliar a JOIN Dinero c
ON c.Empresa = a.Empresa AND c.ID = a.ModuloID JOIN Dinero ca
ON ca.Empresa = c.Empresa AND ca.Mov = a.Aplica AND ca.MovID = a.AplicaID JOIN MovTipo mt
ON mt.Mov = ca.Mov JOIN MovTipo mt2
ON mt2.Mov = c.Mov JOIN EmpresaCFG ec
ON ec.Empresa = a.Empresa
WHERE a.Modulo = 'DIN'
AND mt2.Modulo = 'DIN'
AND ISNULL(mt2.Interno,0) = 0
AND mt.Clave IN ('DIN.SD','DIN.D','DIN.CH','DIN.SCH')
AND c.Estatus NOT IN ('SINAFECTAR','CANCELADO')
AND (ca.Estatus = 'PENDIENTE' OR (ca.Estatus = 'CONCLUIDO' AND ca.FechaConclusion >= @FechaD))
AND ca.Estatus = CASE WHEN @EstatusEspecifico IS NULL THEN ca.Estatus ELSE @EstatusEspecifico END
AND (a.Ejercicio < @Ejercicio OR (a.Ejercicio = @Ejercicio AND a.Periodo <= @Periodo))
AND a.Cuenta = @CuentaCursor
AND a.Moneda = @MonedaCursor
AND a.Empresa = @Empresa 
GROUP BY a.Cuenta, a.Moneda
FETCH NEXT FROM crAuxiliar INTO @Ejercicio, @Periodo
END
CLOSE crAuxiliar
DEALLOCATE crAuxiliar
FETCH NEXT FROM crMoneda INTO @MonedaCursor
END
CLOSE crMoneda
DEALLOCATE crMoneda
FETCH NEXT FROM crCuenta INTO @CuentaCursor
END
CLOSE crCuenta
DEALLOCATE crCuenta
DELETE FROM EstadoCuentaGrafica WHERE Estacion = @Estacion AND Modulo = @Modulo
INSERT EstadoCuentaGrafica (Empresa,  Estacion,  Modulo,  Moneda,   Cuenta,   SaldoDescripcion, SaldoImporte, Grafica)
SELECT  Empresa,  Estacion,  Modulo,  Moneda,   Cuenta,   SaldoDescripcion, SaldoImporte, 1
FROM  @GraficaTemporal
ORDER  BY Cuenta, SaldoDescripcion
INSERT EstadoCuenta (Empresa,  Estacion,  Modulo,  Cuenta,   Moneda,   AuxiliarID, ModuloID,   Vencimiento,   Referencia)
SELECT  @Empresa, @Estacion, @Modulo, a.Cuenta, a.Moneda, a.ID,       a.ModuloID, c.Vencimiento, c.Referencia
FROM Auxiliar a JOIN Cxc c
ON c.Empresa = a.Empresa AND c.ID = a.ModuloID JOIN Cxc ca
ON ca.Empresa = c.Empresa AND ca.Mov = a.Aplica AND ca.MovID = a.AplicaID JOIN MovTipo mt
ON mt.Mov = ca.Mov JOIN MovTipo mt2
ON mt2.Mov = c.Mov
WHERE a.Modulo = 'CXC'
AND mt2.Modulo = 'CXC'
AND ISNULL(mt2.Interno,0) = 0
AND mt.Clave IN ('CXC.A', 'CXC.AR', 'CXC.F', 'CXC.FAC', 'CXC.FA', 'CXC.D', 'CXC.DM', 'CXC.DA', 'CXC.DP', 'CXC.NC', 'CXC.DAC', 'CXC.NCD','CXC.NCF', 'CXC.DV', 'CXC.NCP', 'CXC.CA', 'CXC.CAD', 'CXC.CAP','CXC.CD', 'CXC.RM', 'CXC.IM', 'CXC.SD', 'CXC.SCH')
AND c.Estatus NOT IN ('SINAFECTAR','CANCELADO')
AND (ca.Estatus = 'PENDIENTE' OR (ca.Estatus = 'CONCLUIDO' AND ca.FechaConclusion >= @FechaD))
AND ca.Estatus = CASE WHEN @EstatusEspecifico IS NULL THEN ca.Estatus ELSE @EstatusEspecifico END
AND a.Cuenta BETWEEN ISNULL(@CuentaD, a.Cuenta) AND ISNULL(@CuentaA, a.Cuenta)
AND a.Empresa = @Empresa 
ORDER BY a.Moneda, a.Cuenta, a.Aplica, a.AplicaID, a.ID
INSERT EstadoCuenta (Empresa,  Estacion,  Modulo,  Cuenta,   Moneda,   AuxiliarID, ModuloID,   Vencimiento,   Referencia)
SELECT  @Empresa, @Estacion, @Modulo, a.Cuenta, a.Moneda, a.ID,       a.ModuloID, c.Vencimiento, c.Referencia
FROM Auxiliar a JOIN Dinero c
ON c.Empresa = a.Empresa AND c.ID = a.ModuloID JOIN Dinero ca
ON ca.Empresa = c.Empresa AND ca.Mov = a.Aplica AND ca.MovID = a.AplicaID JOIN MovTipo mt
ON mt.Mov = ca.Mov JOIN MovTipo mt2
ON mt2.Mov = c.Mov
WHERE a.Modulo = 'DIN'
AND mt2.Modulo = 'DIN'
AND ISNULL(mt2.Interno,0) = 0
AND mt.Clave IN ('DIN.SD','DIN.D','DIN.CH','DIN.SCH')
AND c.Estatus NOT IN ('SINAFECTAR','CANCELADO')
AND (ca.Estatus = 'PENDIENTE' OR (ca.Estatus = 'CONCLUIDO' AND ca.FechaConclusion >= @FechaD))
AND ca.Estatus = CASE WHEN @EstatusEspecifico IS NULL THEN ca.Estatus ELSE @EstatusEspecifico END
AND a.Cuenta BETWEEN ISNULL(@CuentaD, a.Cuenta) AND ISNULL(@CuentaA, a.Cuenta)
AND a.Empresa = @Empresa 
ORDER BY a.Moneda, a.Cuenta, a.Aplica, a.AplicaID, a.ID
END ELSE
IF @Modulo = 'CXP'
BEGIN
INSERT @AgrupacionGrafica (Cuenta,   Moneda,   Ejercicio,   Periodo)
SELECT  a.Cuenta, a.Moneda, a.Ejercicio, a.Periodo
FROM Auxiliar a JOIN Cxp c
ON c.Empresa = a.Empresa AND c.ID = a.ModuloID JOIN Cxp ca
ON ca.Empresa = c.Empresa AND ca.Mov = a.Aplica AND ca.MovID = a.AplicaID JOIN MovTipo mt
ON mt.Mov = ca.Mov JOIN MovTipo mt2
ON mt2.Mov = c.Mov
WHERE a.Modulo = 'CXP'
AND mt2.Modulo = 'CXP'
AND ISNULL(mt2.Interno,0) = 0
AND mt.Clave IN ('CXP.A', 'CXP.F', 'CXP.D', 'CXP.DM', 'CXP.PAG', 'CXP.DA', 'CXP.DP', 'CXP.NC', 'CXP.DAC', 'CXP.NCD','CXP.NCF', 'CXP.NCP', 'CXP.CA', 'CXP.CAD', 'CXP.CAP','CXP.CD', 'CXP.FAC', 'CXP.SD', 'CXP.SCH')
AND c.Estatus NOT IN ('SINAFECTAR','CANCELADO')
AND (ca.Estatus = 'PENDIENTE' OR (ca.Estatus = 'CONCLUIDO' AND ca.FechaConclusion >= @FechaD))
AND ca.Estatus = CASE WHEN @EstatusEspecifico IS NULL THEN ca.Estatus ELSE @EstatusEspecifico END
AND a.Cuenta BETWEEN ISNULL(@CuentaD, a.Cuenta) AND ISNULL(@CuentaA, a.Cuenta)
AND c.Moneda = ISNULL(@Moneda, c.Moneda)
AND a.Empresa = @Empresa 
GROUP BY a.Cuenta, a.Moneda, a.Ejercicio, a.Periodo
DECLARE crCuenta CURSOR FOR
SELECT Cuenta
FROM @AgrupacionGrafica
GROUP BY Cuenta
OPEN crCuenta
FETCH NEXT FROM crCuenta INTO @CuentaCursor
WHILE @@FETCH_STATUS = 0
BEGIN
DECLARE crMoneda CURSOR FOR
SELECT Moneda
FROM @AgrupacionGrafica
WHERE Cuenta = @CuentaCursor
GROUP BY Moneda
OPEN crMoneda
FETCH NEXT FROM crMoneda INTO @MonedaCursor
WHILE @@FETCH_STATUS = 0
BEGIN
DECLARE crAuxiliar CURSOR FOR
SELECT TOP 4 Ejercicio, Periodo
FROM @AgrupacionGrafica
WHERE Cuenta = @CuentaCursor
AND Moneda = @MonedaCursor
GROUP BY Ejercicio, Periodo
ORDER BY Ejercicio DESC, Periodo DESC
OPEN crAuxiliar
FETCH NEXT FROM crAuxiliar INTO @Ejercicio, @Periodo
WHILE @@FETCH_STATUS = 0
BEGIN
INSERT @GraficaTemporal (Empresa,  Estacion,  Modulo,  Moneda,   Cuenta,   SaldoDescripcion,                                                                                             SaldoImporte)
SELECT  @Empresa, @Estacion, @Modulo, a.Moneda, a.Cuenta, CONVERT(varchar,@Ejercicio) + '-' + CASE WHEN @Periodo < 10 THEN '0' ELSE '' END + CONVERT(varchar,@Periodo), ISNULL(SUM(dbo.fnImporteAMonedaContable(ISNULL(a.Cargo,0.0)-ISNULL(a.Abono,0.0),c.TipoCambio,ec.ContMoneda)),0.0)
FROM Auxiliar a JOIN Cxp c
ON c.Empresa = a.Empresa AND c.ID = a.ModuloID JOIN Cxp ca
ON ca.Empresa = c.Empresa AND ca.Mov = a.Aplica AND ca.MovID = a.AplicaID JOIN MovTipo mt
ON mt.Mov = ca.Mov JOIN MovTipo mt2
ON mt2.Mov = c.Mov JOIN EmpresaCfg ec
ON ec.Empresa = a.Empresa
WHERE a.Modulo = 'CXP'
AND mt2.Modulo = 'CXP'
AND ISNULL(mt2.Interno,0) = 0
AND mt.Clave IN ('CXP.A', 'CXP.F', 'CXP.D', 'CXP.DM', 'CXP.PAG', 'CXP.DA', 'CXP.DP', 'CXP.NC', 'CXP.DAC', 'CXP.NCD','CXP.NCF', 'CXP.NCP', 'CXP.CA', 'CXP.CAD', 'CXP.CAP','CXP.CD', 'CXP.FAC', 'CXP.SD', 'CXP.SCH')
AND c.Estatus NOT IN ('SINAFECTAR','CANCELADO')
AND (ca.Estatus = 'PENDIENTE' OR (ca.Estatus = 'CONCLUIDO' AND ca.FechaConclusion >= @FechaD))
AND ca.Estatus = CASE WHEN @EstatusEspecifico IS NULL THEN ca.Estatus ELSE @EstatusEspecifico END
AND (a.Ejercicio < @Ejercicio OR (a.Ejercicio = @Ejercicio AND a.Periodo <= @Periodo))
AND a.Cuenta = @CuentaCursor
AND a.Moneda = @MonedaCursor
AND a.Empresa = @Empresa 
GROUP BY a.Cuenta, a.Moneda
FETCH NEXT FROM crAuxiliar INTO @Ejercicio, @Periodo
END
CLOSE crAuxiliar
DEALLOCATE crAuxiliar
FETCH NEXT FROM crMoneda INTO @MonedaCursor
END
CLOSE crMoneda
DEALLOCATE crMoneda
FETCH NEXT FROM crCuenta INTO @CuentaCursor
END
CLOSE crCuenta
DEALLOCATE crCuenta
DELETE FROM EstadoCuentaGrafica WHERE Estacion = @Estacion AND Modulo = @Modulo
INSERT EstadoCuentaGrafica (Empresa,  Estacion,  Modulo,  Moneda,   Cuenta,   SaldoDescripcion, SaldoImporte, Grafica)
SELECT  Empresa,  Estacion,  Modulo,  Moneda,   Cuenta,   SaldoDescripcion, SaldoImporte, 1
FROM  @GraficaTemporal
ORDER  BY Cuenta, SaldoDescripcion
INSERT EstadoCuenta (Empresa,  Estacion,  Modulo,  Cuenta,   Moneda,   AuxiliarID, ModuloID,   Vencimiento,   Referencia)
SELECT  @Empresa, @Estacion, @Modulo, a.Cuenta, a.Moneda, a.ID,       a.ModuloID, c.Vencimiento, c.Referencia
FROM Auxiliar a JOIN Cxp c
ON c.Empresa = a.Empresa AND c.ID = a.ModuloID JOIN Cxp ca
ON ca.Empresa = c.Empresa AND ca.Mov = a.Aplica AND ca.MovID = a.AplicaID JOIN MovTipo mt
ON mt.Mov = ca.Mov JOIN MovTipo mt2
ON mt2.Mov = c.Mov
WHERE a.Modulo = 'CXP'
AND mt2.Modulo = 'CXP'
AND ISNULL(mt2.Interno,0) = 0
AND mt.Clave IN ('CXP.A', 'CXP.F', 'CXP.D', 'CXP.DM', 'CXP.PAG', 'CXP.DA', 'CXP.DP', 'CXP.NC', 'CXP.DAC', 'CXP.NCD','CXP.NCF', 'CXP.NCP', 'CXP.CA', 'CXP.CAD', 'CXP.CAP','CXP.CD', 'CXP.FAC', 'CXP.SD', 'CXP.SCH')
AND c.Estatus NOT IN ('SINAFECTAR','CANCELADO')
AND (ca.Estatus = 'PENDIENTE' OR (ca.Estatus = 'CONCLUIDO' AND ca.FechaConclusion >= @FechaD))
AND ca.Estatus = CASE WHEN @EstatusEspecifico IS NULL THEN ca.Estatus ELSE @EstatusEspecifico END
AND a.Cuenta BETWEEN ISNULL(@CuentaD, a.Cuenta) AND ISNULL(@CuentaA, a.Cuenta)
AND a.Empresa = @Empresa 
ORDER BY a.Moneda, a.Cuenta, a.Aplica, a.AplicaID, a.ID
INSERT EstadoCuenta (Empresa,  Estacion,  Modulo,  Cuenta,   Moneda,   AuxiliarID, ModuloID,   Vencimiento,   Referencia)
SELECT  @Empresa, @Estacion, @Modulo, a.Cuenta, a.Moneda, a.ID,       a.ModuloID, c.Vencimiento, c.Referencia
FROM Auxiliar a JOIN Dinero c
ON c.Empresa = a.Empresa AND c.ID = a.ModuloID JOIN Dinero ca
ON ca.Empresa = c.Empresa AND ca.Mov = a.Aplica AND ca.MovID = a.AplicaID JOIN MovTipo mt
ON mt.Mov = ca.Mov JOIN MovTipo mt2
ON mt2.Mov = c.Mov
WHERE a.Modulo = 'DIN'
AND mt2.Modulo = 'DIN'
AND ISNULL(mt2.Interno,0) = 0
AND mt.Clave IN ('DIN.SD','DIN.D','DIN.CH','DIN.SCH')
AND c.Estatus NOT IN ('SINAFECTAR','CANCELADO')
AND (ca.Estatus = 'PENDIENTE' OR (ca.Estatus = 'CONCLUIDO' AND ca.FechaConclusion >= @FechaD))
AND ca.Estatus = CASE WHEN @EstatusEspecifico IS NULL THEN ca.Estatus ELSE @EstatusEspecifico END
AND a.Cuenta BETWEEN ISNULL(@CuentaD, a.Cuenta) AND ISNULL(@CuentaA, a.Cuenta)
AND a.Empresa = @Empresa 
ORDER BY a.Moneda, a.Cuenta, a.Aplica, a.AplicaID, a.ID
END
END

