SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarEstadoCuenta
@Estacion				int,
@Empresa				char(5),
@Modulo				char(5),
@FechaD				datetime,
@Cuenta				char(10),
@Sucursal				int,
@EstatusEspecifico		char(15) = NULL,
@FechaA				datetime = NULL
AS BEGIN
EXEC spExtraerFecha @FechaD OUTPUT
IF @Cuenta = '0' SELECT @Cuenta = NULL
IF @Sucursal = -1 SELECT @Sucursal = NULL
SELECT @EstatusEspecifico = NULLIF(RTRIM(@EstatusEspecifico), '')
IF @EstatusEspecifico = '0' SELECT @EstatusEspecifico = NULL
DELETE EstadoCuenta WHERE Estacion = @Estacion AND Modulo = @Modulo
IF @Modulo = 'CXC'
BEGIN
INSERT EstadoCuenta (Estacion, Modulo, Cuenta, Efectivo, Consumos, Vales, Redondeo, Moneda)
SELECT @Estacion, @Modulo, c.Cliente, SUM(Efectivo), SUM(Consumos), SUM(Vales), SUM(Redondeo), c.Moneda
FROM CxcCuentaCorriente c, Cte
WHERE c.Empresa = @Empresa
AND c.Cliente = ISNULL(@Cuenta, c.Cliente)
AND cte.Cliente = c.Cliente
GROUP BY c.Cliente, c.Moneda
INSERT EstadoCuenta (Estacion, Modulo, Cuenta, Moneda, AuxiliarID, ModuloID)
SELECT @Estacion, @Modulo, a.Cuenta, a.Moneda, a.ID, a.ModuloID
FROM Auxiliar a, Cxc c, Cxc ca, MovTipo mt, Cte
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
AND (ca.Estatus = 'PENDIENTE' OR (ca.Estatus = 'CONCLUIDO' AND ca.FechaConclusion >= @FechaD AND ca.FechaConclusion <= ISNULL(@FechaA,ca.FechaConclusion)))
AND ca.Estatus = CASE WHEN @EstatusEspecifico IS NULL THEN ca.Estatus ELSE @EstatusEspecifico END
ORDER BY a.Moneda, a.Cuenta, a.Aplica, a.AplicaID, a.ID
INSERT EstadoCuenta (Estacion, Modulo, Cuenta, Moneda, AuxiliarID, ModuloID)
SELECT @Estacion, @Modulo, a.Cuenta, a.Moneda, a.ID, a.ModuloID
FROM Auxiliar a, Dinero c, Dinero ca, MovTipo mt, Cte
WHERE a.Empresa  = @Empresa AND a.Rama = @Modulo
AND a.Aplica   = ca.Mov
AND a.AplicaID = ca.MovID
AND a.ModuloID = c.ID AND a.Modulo = 'DIN'
AND c.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND c.Empresa  = a.Empresa
AND a.Cuenta = ISNULL(@Cuenta, a.Cuenta)
AND a.Cuenta = cte.Cliente
AND ca.Empresa = c.Empresa
AND ca.Mov = mt.Mov AND mt.Clave IN ('DIN.SD','DIN.D','DIN.CH','DIN.SCH')
AND (ca.Estatus = 'PENDIENTE' OR (ca.Estatus = 'CONCLUIDO' AND ca.FechaConclusion >= @FechaD AND ca.FechaConclusion <= ISNULL(@FechaA,ca.FechaConclusion)))
AND ca.Estatus = CASE WHEN @EstatusEspecifico IS NULL THEN ca.Estatus ELSE @EstatusEspecifico END
ORDER BY a.Moneda, a.Cuenta, a.Aplica, a.AplicaID, a.ID
END ELSE
IF @Modulo = 'CXP'
BEGIN
INSERT EstadoCuenta (Estacion, Modulo, Cuenta, Efectivo, Vales, Redondeo, Moneda)
SELECT @Estacion, @Modulo, Proveedor, SUM(Efectivo), SUM(Vales), SUM(Redondeo), Moneda
FROM CxpCuentaCorriente
WHERE Empresa = @Empresa AND Proveedor = CASE WHEN @Cuenta IS NULL THEN Proveedor ELSE @Cuenta END
GROUP BY Proveedor, Moneda
INSERT EstadoCuenta (Estacion, Modulo, Cuenta, Moneda, AuxiliarID, ModuloID)
SELECT @Estacion, @Modulo, a.Cuenta, a.Moneda, a.ID, a.ModuloID
FROM Auxiliar a, Cxp c, Cxp ca, MovTipo mt
WHERE a.Empresa  = @Empresa AND Rama = @Modulo
AND a.Aplica   = ca.Mov
AND a.AplicaID = ca.MovID
AND a.ModuloID = c.ID AND a.Modulo = 'CXP'
AND c.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND c.Empresa  = a.Empresa
AND ca.Empresa = c.Empresa
AND ca.Proveedor = CASE WHEN @Cuenta IS NULL THEN ca.Proveedor ELSE @Cuenta END
AND ca.Mov = mt.Mov AND mt.Clave IN ('CXP.A', 'CXP.F', 'CXP.D', 'CXP.DM', 'CXP.PAG', 'CXP.DA', 'CXP.DP', 'CXP.NC', 'CXP.DAC', 'CXP.NCD','CXP.NCF', 'CXP.NCP', 'CXP.CA', 'CXP.CAD', 'CXP.CAP','CXP.CD', 'CXP.FAC', 'CXP.SD', 'CXP.SCH')
AND (ca.Estatus = 'PENDIENTE' OR (ca.Estatus = 'CONCLUIDO' AND ca.FechaConclusion >= @FechaD AND ca.FechaConclusion <= ISNULL(@FechaA,ca.FechaConclusion)))
AND ca.Estatus = CASE WHEN @EstatusEspecifico IS NULL THEN ca.Estatus ELSE @EstatusEspecifico END
ORDER BY a.Moneda, a.Cuenta, a.Aplica, a.AplicaID, a.ID
INSERT EstadoCuenta (Estacion, Modulo, Cuenta, Moneda, AuxiliarID, ModuloID)
SELECT @Estacion, @Modulo, a.Cuenta, a.Moneda, a.ID, a.ModuloID
FROM Auxiliar a, Dinero c, Dinero ca, MovTipo mt, Prov
WHERE a.Empresa  = @Empresa AND a.Rama = @Modulo
AND a.Aplica   = ca.Mov
AND a.AplicaID = ca.MovID
AND a.ModuloID = c.ID AND a.Modulo = 'DIN'
AND c.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND c.Empresa  = a.Empresa
AND a.Cuenta = ISNULL(@Cuenta, a.Cuenta)
AND a.Cuenta = Prov.Proveedor
AND ca.Empresa = c.Empresa
AND ca.Mov = mt.Mov AND mt.Clave IN ('DIN.SD','DIN.D','DIN.CH','DIN.SCH')
AND (ca.Estatus = 'PENDIENTE' OR (ca.Estatus = 'CONCLUIDO' AND ca.FechaConclusion >= @FechaD AND ca.FechaConclusion <= ISNULL(@FechaA,ca.FechaConclusion)))
AND ca.Estatus = CASE WHEN @EstatusEspecifico IS NULL THEN ca.Estatus ELSE @EstatusEspecifico END
ORDER BY a.Moneda, a.Cuenta, a.Aplica, a.AplicaID, a.ID
END
END

