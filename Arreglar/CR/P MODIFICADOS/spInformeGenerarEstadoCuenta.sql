SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInformeGenerarEstadoCuenta
@Estacion			int,
@Empresa			varchar(5),
@Modulo				varchar(5),
@FechaD				datetime,
@Cuenta				char(10),
@Sucursal			int,
@EstatusEspecifico	varchar(15) = NULL,
@GraficarTipo		varchar(30)

AS BEGIN
DECLARE
@Graficar			int,
@Moneda				varchar(30),
@SaldoDescripcion	varchar(50),
@SaldoImporte		float,
@Dividir			int
EXEC spExtraerFecha @FechaD OUTPUT
IF @Cuenta = '0' SELECT @Cuenta = NULL
IF @Sucursal = -1 SELECT @Sucursal = NULL
SELECT @EstatusEspecifico = NULLIF(RTRIM(@EstatusEspecifico), '')
IF @EstatusEspecifico = '0' SELECT @EstatusEspecifico = NULL
DELETE EstadoCuenta WHERE Estacion = @Estacion AND Modulo = @Modulo
IF @Modulo = 'CXC'
BEGIN
INSERT EstadoCuenta (Empresa,  Estacion,  Modulo,  Cuenta,    Grafica,   SaldoDescripcion, SaldoImporte,                            Moneda)
SELECT  @Empresa, @Estacion, @Modulo, c.Cliente, 1,         'Saldo a Favor',       ISNULL(SUM(0.0-ISNULL(c.Efectivo,0.0)),0.0), c.Moneda
FROM CxcCuentaCorriente c  WITH(NOLOCK) JOIN Cte
 WITH(NOLOCK) ON Cte.Cliente = c.Cliente
WHERE c.Empresa = @Empresa
AND c.Cliente = ISNULL(@Cuenta, c.Cliente)
GROUP BY c.Cliente, c.Moneda
INSERT EstadoCuenta (Empresa,  Estacion,  Modulo,  Cuenta,    Grafica,   SaldoDescripcion, SaldoImporte,                            Moneda)
SELECT  @Empresa, @Estacion, @Modulo, c.Cliente, 1,         'Consumos Pendientes',       ISNULL(SUM(ISNULL(c.Consumos,0.0)),0.0), c.Moneda
FROM CxcCuentaCorriente c  WITH(NOLOCK) JOIN Cte
 WITH(NOLOCK) ON Cte.Cliente = c.Cliente
WHERE c.Empresa = @Empresa
AND c.Cliente = ISNULL(@Cuenta, c.Cliente)
GROUP BY c.Cliente, c.Moneda
INSERT EstadoCuenta (Empresa,  Estacion,  Modulo,  Cuenta,    Grafica,   SaldoDescripcion, SaldoImporte,                         Moneda)
SELECT  @Empresa, @Estacion, @Modulo, c.Cliente, 1,         'Vales en Circulacíon',          ISNULL(SUM(ISNULL(c.Vales,0.0)),0.0), c.Moneda
FROM CxcCuentaCorriente c  WITH(NOLOCK) JOIN Cte
 WITH(NOLOCK) ON Cte.Cliente = c.Cliente
WHERE c.Empresa = @Empresa
AND c.Cliente = ISNULL(@Cuenta, c.Cliente)
GROUP BY c.Cliente, c.Moneda
INSERT EstadoCuenta (Empresa,  Estacion,  Modulo,  Cuenta,    Grafica,   SaldoDescripcion, SaldoImporte,                            Moneda)
SELECT  @Empresa, @Estacion, @Modulo, c.Cliente, 1,         'Redondeo',       ISNULL(SUM(ISNULL(c.Redondeo,0.0)),0.0), c.Moneda
FROM CxcCuentaCorriente c  WITH(NOLOCK) JOIN Cte
 WITH(NOLOCK) ON Cte.Cliente = c.Cliente
WHERE c.Empresa = @Empresa
AND c.Cliente = ISNULL(@Cuenta, c.Cliente)
GROUP BY c.Cliente, c.Moneda
INSERT EstadoCuenta (Empresa,  Estacion,  Modulo,  Cuenta,   Grafica, SaldoDescripcion, SaldoImporte,                                             Moneda)
SELECT @Empresa, @Estacion, @Modulo, a.Cuenta, 1,       c.Mov,            ISNULL(SUM(ISNULL(a.Cargo,0.0)-ISNULL(a.Abono,0.0)),0.0), a.Moneda
FROM Auxiliar a WITH(NOLOCK), Cxc c WITH(NOLOCK), Cxc ca WITH(NOLOCK), MovTipo mt, Cte WITH(NOLOCK)
WHERE a.Empresa  = @Empresa AND a.Rama = @Modulo
AND a.Aplica   = ca.Mov
AND a.AplicaID = ca.MovID
AND a.ModuloID = c.ID AND a.Modulo = 'CXC'
AND c.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND c.Empresa  = a.Empresa
AND a.Cuenta = ISNULL(@Cuenta, a.Cuenta)
AND c.Cliente = cte.Cliente
AND ca.Empresa = c.Empresa
AND ca.Mov = mt.Mov AND mt.Clave IN ('CXC.A', 'CXC.AR', 'CXC.F', 'CXC.FAC', 'CXC.FA', 'CXC.D', 'CXC.DM', 'CXC.DA', 'CXC.DP', 'CXC.NC', 'CXC.DAC', 'CXC.NCD','CXC.NCF', 'CXC.DV', 'CXC.NCP', 'CXC.CA', 'CXC.CAD', 'CXC.CAP','CXC.CD', 'CXC.RM', 'CXC.IM', 'CXC.SD', 'CXC.SCH')
AND (ca.Estatus = 'PENDIENTE' OR (ca.Estatus = 'CONCLUIDO' AND ca.FechaConclusion >= @FechaD))
AND ca.Estatus = CASE WHEN @EstatusEspecifico IS NULL THEN ca.Estatus ELSE @EstatusEspecifico END
GROUP BY a.Cuenta, a.Moneda, c.Mov
INSERT EstadoCuenta (Empresa, Estacion, Modulo, Cuenta, Moneda, AuxiliarID, ModuloID)
SELECT @Empresa, @Estacion, @Modulo, a.Cuenta, a.Moneda, a.ID, a.ModuloID
FROM Auxiliar a WITH(NOLOCK), Cxc c WITH(NOLOCK), Cxc ca WITH(NOLOCK), MovTipo mt, Cte
WITH(NOLOCK) WHERE a.Empresa  = @Empresa AND a.Rama = @Modulo
AND a.Aplica   = ca.Mov
AND a.AplicaID = ca.MovID
AND a.ModuloID = c.ID AND a.Modulo = 'CXC'
AND c.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND c.Empresa  = a.Empresa
AND a.Cuenta = ISNULL(@Cuenta, a.Cuenta)
AND c.Cliente = cte.Cliente
AND ca.Empresa = c.Empresa
AND ca.Mov = mt.Mov AND mt.Clave IN ('CXC.A', 'CXC.AR', 'CXC.F', 'CXC.FAC', 'CXC.FA', 'CXC.D', 'CXC.DM', 'CXC.DA', 'CXC.DP', 'CXC.NC', 'CXC.DAC', 'CXC.NCD','CXC.NCF', 'CXC.DV', 'CXC.NCP', 'CXC.CA', 'CXC.CAD', 'CXC.CAP','CXC.CD', 'CXC.RM', 'CXC.IM', 'CXC.SD', 'CXC.SCH')
AND (ca.Estatus = 'PENDIENTE' OR (ca.Estatus = 'CONCLUIDO' AND ca.FechaConclusion >= @FechaD))
AND ca.Estatus = CASE WHEN @EstatusEspecifico IS NULL THEN ca.Estatus ELSE @EstatusEspecifico END
ORDER BY a.Moneda, a.Cuenta, a.Aplica, a.AplicaID, a.ID
INSERT EstadoCuenta (Empresa, Estacion, Modulo, Cuenta, Moneda, AuxiliarID, ModuloID)
SELECT @Empresa, @Estacion, @Modulo, a.Cuenta, a.Moneda, a.ID, a.ModuloID
FROM Auxiliar a WITH(NOLOCK), Dinero c WITH(NOLOCK), Dinero ca WITH(NOLOCK), MovTipo mt WITH(NOLOCK), Cte
WITH(NOLOCK) WHERE a.Empresa  = @Empresa AND a.Rama = @Modulo
AND a.Aplica   = ca.Mov
AND a.AplicaID = ca.MovID
AND a.ModuloID = c.ID AND a.Modulo = 'DIN'
AND c.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND c.Empresa  = a.Empresa
AND a.Cuenta = ISNULL(@Cuenta, a.Cuenta)
AND a.Cuenta = cte.Cliente
AND ca.Empresa = c.Empresa
AND ca.Mov = mt.Mov AND mt.Clave IN ('DIN.SD','DIN.D','DIN.CH','DIN.SCH')
AND (ca.Estatus = 'PENDIENTE' OR (ca.Estatus = 'CONCLUIDO' AND ca.FechaConclusion >= @FechaD))
AND ca.Estatus = CASE WHEN @EstatusEspecifico IS NULL THEN ca.Estatus ELSE @EstatusEspecifico END
ORDER BY a.Moneda, a.Cuenta, a.Aplica, a.AplicaID, a.ID
END ELSE
IF @Modulo = 'CXP'
BEGIN
INSERT EstadoCuenta (Empresa,  Estacion,  Modulo,  Cuenta,    Grafica, SaldoDescripcion, SaldoImporte,                          Moneda)
SELECT  @Empresa, @Estacion, @Modulo, Proveedor, 1,       'Saldo a Favor',       ISNULL(SUM(ISNULL(Efectivo,0.0)),0.0), Moneda
FROM CxpCuentaCorriente
WITH(NOLOCK) WHERE Empresa = @Empresa
AND Proveedor = ISNULL(@Cuenta, Proveedor)
GROUP BY Proveedor, Moneda
INSERT EstadoCuenta (Empresa,  Estacion,  Modulo,  Cuenta,    Grafica, SaldoDescripcion, SaldoImporte, Moneda)
SELECT  @Empresa, @Estacion, @Modulo, Proveedor, 1,       'Vales en Circulacíon',          ISNULL(SUM(ISNULL(Vales,0.0)),0.0),   Moneda
FROM CxpCuentaCorriente
WITH(NOLOCK) WHERE Empresa = @Empresa
AND Proveedor = ISNULL(@Cuenta, Proveedor)
GROUP BY Proveedor, Moneda
INSERT EstadoCuenta (Empresa,  Estacion,  Modulo,  Cuenta,    Grafica, SaldoDescripcion, SaldoImporte,  Moneda)
SELECT  @Empresa, @Estacion, @Modulo, Proveedor, 1,       'Redondeo',       ISNULL(SUM(ISNULL(Redondeo,0.0)),0.0), Moneda
FROM CxpCuentaCorriente
WITH(NOLOCK) WHERE Empresa = @Empresa
AND Proveedor = ISNULL(@Cuenta, Proveedor)
GROUP BY Proveedor, Moneda
INSERT EstadoCuenta (Empresa,  Estacion,  Modulo,  Cuenta,   Grafica, SaldoDescripcion, SaldoImporte,                                             Moneda)
SELECT @Empresa, @Estacion, @Modulo, a.Cuenta, 1,       c.Mov,            ISNULL(SUM(ISNULL(a.Cargo,0.0)-ISNULL(a.Abono,0.0)),0.0), a.Moneda
FROM Auxiliar a WITH(NOLOCK), Cxp c WITH(NOLOCK), Cxp ca WITH(NOLOCK), MovTipo mt
WITH(NOLOCK) WHERE a.Empresa  = @Empresa AND Rama = @Modulo
AND a.Aplica   = ca.Mov
AND a.AplicaID = ca.MovID
AND a.ModuloID = c.ID AND a.Modulo = 'CXP'
AND c.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND c.Empresa  = a.Empresa
AND ca.Empresa = c.Empresa
AND ca.Proveedor = CASE WHEN @Cuenta IS NULL THEN ca.Proveedor ELSE @Cuenta END
AND ca.Mov = mt.Mov AND mt.Clave IN ('CXP.A', 'CXP.F', 'CXP.D', 'CXP.DM', 'CXP.PAG', 'CXP.DA', 'CXP.DP', 'CXP.NC', 'CXP.DAC', 'CXP.NCD','CXP.NCF', 'CXP.NCP', 'CXP.CA', 'CXP.CAD', 'CXP.CAP','CXP.CD', 'CXP.FAC', 'CXP.SD', 'CXP.SCH')
AND (ca.Estatus = 'PENDIENTE' OR (ca.Estatus = 'CONCLUIDO' AND ca.FechaConclusion >= @FechaD))
AND ca.Estatus = CASE WHEN @EstatusEspecifico IS NULL THEN ca.Estatus ELSE @EstatusEspecifico END
GROUP BY a.Cuenta, a.Moneda, c.Mov
INSERT EstadoCuenta (Empresa, Estacion, Modulo, Cuenta, Moneda, AuxiliarID, ModuloID)
SELECT @Empresa, @Estacion, @Modulo, a.Cuenta, a.Moneda, a.ID, a.ModuloID
FROM Auxiliar a WITH(NOLOCK), Cxp c WITH(NOLOCK), Cxp ca WITH(NOLOCK), MovTipo mt
WITH(NOLOCK) WHERE a.Empresa  = @Empresa AND Rama = @Modulo
AND a.Aplica   = ca.Mov
AND a.AplicaID = ca.MovID
AND a.ModuloID = c.ID AND a.Modulo = 'CXP'
AND c.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND c.Empresa  = a.Empresa
AND ca.Empresa = c.Empresa
AND ca.Proveedor = CASE WHEN @Cuenta IS NULL THEN ca.Proveedor ELSE @Cuenta END
AND ca.Mov = mt.Mov AND mt.Clave IN ('CXP.A', 'CXP.F', 'CXP.D', 'CXP.DM', 'CXP.PAG', 'CXP.DA', 'CXP.DP', 'CXP.NC', 'CXP.DAC', 'CXP.NCD','CXP.NCF', 'CXP.NCP', 'CXP.CA', 'CXP.CAD', 'CXP.CAP','CXP.CD', 'CXP.FAC', 'CXP.SD', 'CXP.SCH')
AND (ca.Estatus = 'PENDIENTE' OR (ca.Estatus = 'CONCLUIDO' AND ca.FechaConclusion >= @FechaD))
AND ca.Estatus = CASE WHEN @EstatusEspecifico IS NULL THEN ca.Estatus ELSE @EstatusEspecifico END
ORDER BY a.Moneda, a.Cuenta, a.Aplica, a.AplicaID, a.ID
INSERT EstadoCuenta (Empresa, Estacion, Modulo, Cuenta, Moneda, AuxiliarID, ModuloID)
SELECT @Empresa, @Estacion, @Modulo, a.Cuenta, a.Moneda, a.ID, a.ModuloID
FROM Auxiliar a WITH(NOLOCK), Dinero c WITH(NOLOCK), Dinero ca WITH(NOLOCK), MovTipo mt WITH(NOLOCK), Prov
WITH(NOLOCK) WHERE a.Empresa  = @Empresa AND a.Rama = @Modulo
AND a.Aplica   = ca.Mov
AND a.AplicaID = ca.MovID
AND a.ModuloID = c.ID AND a.Modulo = 'DIN'
AND c.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND c.Empresa  = a.Empresa
AND a.Cuenta = ISNULL(@Cuenta, a.Cuenta)
AND a.Cuenta = Prov.Proveedor
AND ca.Empresa = c.Empresa
AND ca.Mov = mt.Mov AND mt.Clave IN ('DIN.SD','DIN.D','DIN.CH','DIN.SCH')
AND (ca.Estatus = 'PENDIENTE' OR (ca.Estatus = 'CONCLUIDO' AND ca.FechaConclusion >= @FechaD))
AND ca.Estatus = CASE WHEN @EstatusEspecifico IS NULL THEN ca.Estatus ELSE @EstatusEspecifico END
ORDER BY a.Moneda, a.Cuenta, a.Aplica, a.AplicaID, a.ID
END
DECLARE crTotales CURSOR FAST_FORWARD FOR
SELECT Moneda, Cuenta, SaldoDescripcion, SaldoImporte
FROM EstadoCuenta WITH(NOLOCK)
WHERE  Estacion = @Estacion
AND Grafica = 1
AND SaldoDescripcion IN('Saldo a Favor', 'Vales en Circulacíon', 'Redondeo', 'Consumos Pendientes')
AND SaldoImporte > 0
GROUP BY Moneda, Cuenta, SaldoDescripcion, SaldoImporte
OPEN crTotales
FETCH NEXT FROM crTotales INTO @Moneda, @Cuenta, @SaldoDescripcion, @SaldoImporte
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Dividir = COUNT(*) FROM EstadoCuenta WHERE Estacion = @Estacion AND Grafica = 0 AND Cuenta = @Cuenta AND Moneda = @Moneda
SELECT @SaldoImporte = @SaldoImporte / dbo.fnEvitarDivisionCero(@Dividir)
IF @SaldoDescripcion = 'Saldo a Favor'
BEGIN
UPDATE EstadoCuenta
 WITH(ROWLOCK) SET Efectivo = @SaldoImporte
WHERE Estacion = @Estacion
AND Grafica = 0
AND Cuenta = @Cuenta
AND Moneda = @Moneda
IF @@ROWCOUNT = 0
INSERT EstadoCuenta (Empresa, Estacion, Modulo, Cuenta, Moneda, AuxiliarID, ModuloID, Efectivo, SaldoDescripcion)
SELECT @Empresa, @Estacion, @Modulo, @Cuenta, @Moneda, '', '', @SaldoImporte, @SaldoDescripcion
END
ELSE
IF @SaldoDescripcion = 'Vales en Circulacíon'
BEGIN
UPDATE EstadoCuenta
 WITH(ROWLOCK) SET Vales = @SaldoImporte
WHERE Estacion = @Estacion
AND Grafica = 0
AND Cuenta = @Cuenta
AND Moneda = @Moneda
IF @@ROWCOUNT = 0
INSERT EstadoCuenta (Empresa, Estacion, Modulo, Cuenta, Moneda, AuxiliarID, ModuloID, Vales, SaldoDescripcion)
SELECT @Empresa, @Estacion, @Modulo, @Cuenta, @Moneda, '', '', @SaldoImporte, @SaldoDescripcion
END
ELSE
IF @SaldoDescripcion = 'Redondeo'
BEGIN
UPDATE EstadoCuenta
 WITH(ROWLOCK) SET Redondeo = @SaldoImporte
WHERE Estacion = @Estacion
AND Grafica = 0
AND Cuenta = @Cuenta
AND Moneda = @Moneda
IF @@ROWCOUNT = 0
INSERT EstadoCuenta (Empresa, Estacion, Modulo, Cuenta, Moneda, AuxiliarID, ModuloID, Redondeo, SaldoDescripcion)
SELECT @Empresa, @Estacion, @Modulo, @Cuenta, @Moneda, '', '', @SaldoImporte, @SaldoDescripcion
END
ELSE
IF @SaldoDescripcion = 'Consumos Pendientes'
BEGIN
UPDATE EstadoCuenta
 WITH(ROWLOCK) SET Consumos = @SaldoImporte
WHERE Estacion = @Estacion
AND Grafica = 0
AND Cuenta = @Cuenta
AND Moneda = @Moneda
IF @@ROWCOUNT = 0
INSERT EstadoCuenta (Empresa, Estacion, Modulo, Cuenta, Moneda, AuxiliarID, ModuloID, Consumos, SaldoDescripcion)
SELECT @Empresa, @Estacion, @Modulo, @Cuenta, @Moneda, '', '', @SaldoImporte, @SaldoDescripcion
END
FETCH NEXT FROM crTotales INTO @Moneda, @Cuenta, @SaldoDescripcion, @SaldoImporte
END
CLOSE crTotales
DEALLOCATE crTotales
UPDATE EstadoCuenta
 WITH(ROWLOCK) SET Efectivo = 0.00,
Vales = 0.00,
Redondeo = 0.00,
Consumos = 0.00
WHERE Estacion = @Estacion
AND Grafica = 1
DECLARE crGraficar CURSOR FAST_FORWARD FOR
SELECT Moneda, Cuenta
FROM EstadoCuenta WITH(NOLOCK)
WHERE  Estacion = @Estacion
AND Grafica = 1
GROUP BY Moneda, Cuenta
OPEN crGraficar
FETCH NEXT FROM crGraficar INTO @Moneda, @Cuenta
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Graficar = NULL
SELECT @Graficar = ISNULL(COUNT(DISTINCT SaldoDescripcion),0)
FROM EstadoCuenta
WITH(NOLOCK) WHERE Estacion = @Estacion
AND Modulo = @Modulo
AND Grafica = 1
AND Moneda = @Moneda
AND Cuenta = @Cuenta
IF @GraficarTipo = 'Mas Sobresalientes' AND @Graficar > 5
DELETE EstadoCuenta
WHERE SaldoDescripcion NOT IN(
SELECT  TOP 5 SaldoDescripcion
FROM
(
SELECT
'SaldoDescripcion'  = SaldoDescripcion,
'SaldoImporte'      = SUM(SaldoImporte)
FROM EstadoCuenta
WITH(NOLOCK) WHERE Estacion = @Estacion
AND Modulo = @Modulo
AND Grafica = 1
AND Moneda = @Moneda
AND Cuenta = @Cuenta
GROUP BY Moneda, SaldoDescripcion
) AS x
GROUP BY x.SaldoDescripcion
ORDER BY SUM(ISNULL(x.SaldoImporte,0.00))DESC)
AND Estacion = @Estacion
AND Modulo = @Modulo
AND Grafica = 1
AND Moneda = @Moneda
AND Cuenta = @Cuenta
IF @GraficarTipo = 'Menos Sobresalientes' AND @Graficar > 5
DELETE EstadoCuenta
WHERE SaldoDescripcion NOT IN(
SELECT  TOP 5 SaldoDescripcion
FROM
(
SELECT
'SaldoDescripcion'  = SaldoDescripcion,
'SaldoImporte'      = SUM(SaldoImporte)
FROM EstadoCuenta
WITH(NOLOCK) WHERE Estacion = @Estacion
AND Modulo = @Modulo
AND Grafica = 1
AND Moneda = @Moneda
AND Cuenta = @Cuenta
GROUP BY Moneda, SaldoDescripcion
) AS x
GROUP BY x.SaldoDescripcion
ORDER BY SUM(ISNULL(x.SaldoImporte,0.00))ASC)
AND Estacion = @Estacion
AND Modulo = @Modulo
AND Grafica = 1
AND Moneda = @Moneda
AND Cuenta = @Cuenta
FETCH NEXT FROM crGraficar INTO @Moneda, @Cuenta
END
CLOSE crGraficar
DEALLOCATE crGraficar
END

