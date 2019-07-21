SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spGenerarEstadoCuenta3
@Estacion			int	,
@Modulo				char(5) ,
@Empresa			char(5)

AS BEGIN
DECLARE
@FechaA				datetime,
@Cuenta				varchar(10),
@Sucursal			int,
@EstatusEspecifico	varchar(15) ,
@ClienteEnviarA		int,
@Moneda             varchar(20),
@Titulo				varchar(100) 
SELECT
@FechaA	= InfoFechaA,
@Cuenta	= InfoCliente,
@Sucursal = InfoSucursalEdoCta,
@EstatusEspecifico = InfoEstatusEspecifico,
@ClienteEnviarA = InfoClienteEnviarA,
@Moneda= InfoMoneda,
@Titulo = RepTitulo
FROM RepParam
WITH(NOLOCK) WHERE Estacion = @Estacion
CREATE TABLE #CxcCuentaCorriente(
Sucursal       int          NULL,
Empresa		     char(5)      NULL,
Rama           char(5)      NULL,
Moneda         char(10)     NULL,
Grupo          char(10)     NULL,
Cliente        char(20)     NULL,
Subcuenta      varchar(50)  NULL,
ClienteEnviarA int          NULL,
Estatus        varchar(15)  NULL,
FechaRegistro  datetime     NULL,
FechaConclusion  datetime		NULL,
Efectivo       money        NULL,
Consumos       money        NULL,
Vales          money        NULL,
Redondeo       money        NULL
)
EXEC spExtraerFecha @FechaA OUTPUT
SET @Cuenta = NULLIF(NULLIF(RTRIM(@Cuenta), ''),'(Todos)')
SET @Sucursal = NULLIF(@Sucursal,-1)
IF @EstatusEspecifico = 'Pendientes' SET @EstatusEspecifico = 'PENDIENTE' ELSE
IF @EstatusEspecifico = 'Concluidos' SET @EstatusEspecifico = 'CONCLUIDO' ELSE
SET @EstatusEspecifico = NULLIF(NULLIF(RTRIM(@EstatusEspecifico), ''),'(Todos)')
SET @ClienteEnviarA  = NULLIF(RTRIM(@ClienteEnviarA ), '')
SET @Moneda = NULLIF(NULLIF(RTRIM(@Moneda), ''),'(Todas)')
DELETE EstadoCuenta WHERE Estacion = @Estacion AND Modulo = @Modulo
IF @Modulo = 'CXC'
BEGIN
INSERT INTO #CxcCuentaCorriente(Sucursal, Empresa, Rama, Moneda, Grupo, Cliente, Subcuenta, ClienteEnviarA, Estatus, FechaRegistro, FechaConclusion, Efectivo, Consumos, Vales, Redondeo)
SELECT
a.Sucursal,
a.Empresa,
a.Rama,
a.Moneda,
a.Grupo,
"Cliente" = a.Cuenta,
a.Subcuenta,
c.ClienteEnviarA,
c.Estatus,
c.FechaRegistro,
c.FechaConclusion,
"Efectivo" = SUM(ISNULL(a.Cargo,0))- SUM(ISNULL(a.Abono,0)),
"Consumos" = CONVERT(money, NULL),
"Vales" = CONVERT(money, NULL),
"Redondeo" = CONVERT(money, NULL)
FROM Auxiliar a
 WITH(NOLOCK) JOIN Cxc c  WITH(NOLOCK) ON a.Modulo = 'CXC' AND a.ModuloID = c.ID
WHERE
a.Rama = 'CEFE'
GROUP BY
a.Sucursal, a.Empresa, a.Rama, a.Moneda, a.Grupo, a.Cuenta, a.Subcuenta, c.ClienteEnviarA, c.Estatus, c.FechaRegistro, c.FechaConclusion
UNION
SELECT
a.Sucursal,
a.Empresa,
a.Rama,
a.Moneda,
a.Grupo,
"Cliente" = a.Cuenta,
a.Subcuenta,
v.EnviarA,
v.Estatus,
v.FechaRegistro,
v.FechaConclusion,
"Efectivo" = CONVERT(money, NULL),
"Consumos" = SUM(ISNULL(a.Cargo,0))- SUM(ISNULL(a.Abono,0)),
"Vales" = CONVERT(money, NULL),
"Redondeo" = CONVERT(money, NULL)
FROM Auxiliar a
 WITH(NOLOCK) JOIN Venta v  WITH(NOLOCK) ON a.Modulo = 'VTAS' AND a.ModuloID = v.ID
WHERE
a.Rama = 'CNO'
GROUP BY
a.Sucursal, a.Empresa, a.Rama, a.Moneda, a.Grupo, a.Cuenta, a.Subcuenta, v.EnviarA, v.Estatus, v.FechaRegistro, v.FechaConclusion
UNION
SELECT
a.Sucursal,
a.Empresa,
a.Rama,
a.Moneda,
a.Grupo,
"Cliente" = a.Cuenta,
a.Subcuenta,
c.ClienteEnviarA,
c.Estatus,
c.FechaRegistro,
c.FechaConclusion,
"Efectivo" = CONVERT(money, NULL),
"Consumos" = CONVERT(money, NULL),
"Vales" = CONVERT(money, NULL),
"Redondeo" = SUM(ISNULL(a.Cargo,0))- SUM(ISNULL(a.Abono,0))
FROM Auxiliar a
 WITH(NOLOCK) JOIN Cxc c  WITH(NOLOCK) ON a.Modulo = 'CXC' AND a.ModuloID = c.ID
WHERE
a.Rama = 'CRND'
GROUP BY
a.Sucursal, a.Empresa, a.Rama, a.Moneda, a.Grupo, a.Cuenta, a.Subcuenta, c.ClienteEnviarA, c.Estatus, c.FechaRegistro, c.FechaConclusion
INSERT EstadoCuenta (Empresa, Estacion, Modulo, Cuenta, Efectivo, Consumos, Vales, Redondeo, Moneda, ClienteEnviarA)
SELECT @Empresa, @Estacion, @Modulo, Cliente, SUM(Efectivo), SUM(Consumos), SUM(Vales), SUM(Redondeo), Moneda, ClienteEnviarA
FROM #CxcCuentaCorriente
WHERE Empresa = @Empresa
AND Cliente = ISNULL(@Cuenta, Cliente)
AND Moneda = ISNULL(@Moneda, Moneda)
AND ISNULL(ClienteEnviarA,'') = ISNULL(@ClienteEnviarA, ISNULL(ClienteEnviarA,''))
AND Estatus NOT IN ('SINAFECTAR','CANCELADO')
AND dbo.fnFechaSinHora(FechaRegistro) <= @FechaA
AND Estatus = CASE WHEN @EstatusEspecifico IS NULL THEN Estatus ELSE @EstatusEspecifico END
GROUP BY Cliente, Moneda, ClienteEnviarA
INSERT EstadoCuenta (Empresa,  Estacion,  Modulo,  Cuenta,   Moneda,   AuxiliarID, ModuloID,   Vencimiento,   Referencia,   ClienteEnviarA)
SELECT  @Empresa, @Estacion, @Modulo, a.Cuenta, a.Moneda, a.ID,       a.ModuloID, c.Vencimiento, c.Referencia, c.ClienteEnviarA
FROM Auxiliar a  WITH(NOLOCK) JOIN Cxc c
WITH(NOLOCK) ON c.Empresa = a.Empresa AND c.ID = a.ModuloID JOIN Cxc ca
WITH(NOLOCK) ON ca.Empresa = c.Empresa AND ca.Mov = a.Aplica AND ca.MovID = a.AplicaID JOIN MovTipo mt
WITH(NOLOCK) ON mt.Mov = ca.Mov JOIN MovTipo mt2 WITH(NOLOCK)
ON mt2.Mov = c.Mov
WHERE a.Modulo = 'CXC'
AND mt2.Modulo = 'CXC'
AND ISNULL(mt2.Interno,0) = 0
AND mt.Clave IN ('CXC.A', 'CXC.AR', 'CXC.F', 'CXC.FAC', 'CXC.FA', 'CXC.D', 'CXC.DM', 'CXC.DA', 'CXC.DP', 'CXC.NC', 'CXC.DAC', 'CXC.NCD','CXC.NCF', 'CXC.DV', 'CXC.NCP', 'CXC.CA', 'CXC.CAD', 'CXC.CAP','CXC.CD', 'CXC.RM', 'CXC.IM', 'CXC.SD', 'CXC.SCH')
AND c.Estatus NOT IN ('SINAFECTAR','CANCELADO')
AND dbo.fnFechaSinHora(c.FechaRegistro) <= @FechaA
AND (ca.Estatus = 'PENDIENTE' OR (ca.Estatus = 'CONCLUIDO' AND ca.FechaConclusion >= @FechaA))
AND ca.Estatus = CASE WHEN @EstatusEspecifico IS NULL THEN ca.Estatus ELSE @EstatusEspecifico END
AND a.Cuenta = ISNULL(@Cuenta, a.Cuenta)
AND ISNULL(c.ClienteEnviarA,'') = ISNULL(@ClienteEnviarA, ISNULL(c.ClienteEnviarA,''))
AND a.Empresa = @Empresa 
AND a.Moneda = ISNULL(@Moneda,a.Moneda)
ORDER BY a.Moneda, a.Cuenta, a.Aplica, a.AplicaID, a.ID
END ELSE
IF @Modulo = 'CXP'
BEGIN
INSERT EstadoCuenta (Estacion, Modulo, Cuenta, Efectivo, Vales, Redondeo, Moneda)
SELECT @Estacion, @Modulo, Proveedor, SUM(Efectivo), SUM(Vales), SUM(Redondeo), Moneda
FROM CxpCuentaCorriente
WITH(NOLOCK) WHERE Empresa = @Empresa AND Proveedor = CASE WHEN @Cuenta IS NULL THEN Proveedor ELSE @Cuenta END
GROUP BY Proveedor, Moneda
INSERT EstadoCuenta (Empresa,  Estacion,  Modulo,  Cuenta,   Moneda,   AuxiliarID, ModuloID,   Vencimiento,   Referencia)
SELECT  @Empresa, @Estacion, @Modulo, a.Cuenta, a.Moneda, a.ID,       a.ModuloID, c.Vencimiento, c.Referencia
FROM Auxiliar a  WITH(NOLOCK) JOIN Cxp c
 WITH(NOLOCK) ON c.Empresa = a.Empresa AND c.ID = a.ModuloID JOIN Cxp ca
 WITH(NOLOCK) ON ca.Empresa = c.Empresa AND ca.Mov = a.Aplica AND ca.MovID = a.AplicaID JOIN MovTipo mt
 WITH(NOLOCK) ON mt.Mov = ca.Mov JOIN MovTipo mt2 WITH(NOLOCK)
ON mt2.Mov = c.Mov
WHERE a.Modulo = 'CXP'
AND mt2.Modulo = 'CXP'
AND ISNULL(mt2.Interno,0) = 0
AND mt.Clave IN ('CXP.A', 'CXP.F', 'CXP.D', 'CXP.DM', 'CXP.PAG', 'CXP.DA', 'CXP.DP', 'CXP.NC', 'CXP.DAC', 'CXP.NCD','CXP.NCF', 'CXP.NCP', 'CXP.CA', 'CXP.CAD', 'CXP.CAP','CXP.CD', 'CXP.FAC', 'CXP.SD', 'CXP.SCH')
AND c.Estatus NOT IN ('SINAFECTAR','CANCELADO')
AND (ca.Estatus = 'PENDIENTE' OR (ca.Estatus = 'CONCLUIDO' AND ca.FechaConclusion >= @FechaA))
AND ca.Estatus = CASE WHEN @EstatusEspecifico IS NULL THEN ca.Estatus ELSE @EstatusEspecifico END
AND a.Cuenta = ISNULL(@Cuenta, a.Cuenta)
AND a.Moneda = ISNULL(@Moneda,a.Moneda)
AND a.Empresa = @Empresa 
ORDER BY a.Moneda, a.Cuenta, a.Aplica, a.AplicaID, a.ID
INSERT EstadoCuenta (Empresa,  Estacion,  Modulo,  Cuenta,   Moneda,   AuxiliarID, ModuloID,   Vencimiento,   Referencia)
SELECT  @Empresa, @Estacion, @Modulo, a.Cuenta, a.Moneda, a.ID,       a.ModuloID, c.Vencimiento, c.Referencia
FROM Auxiliar a  WITH(NOLOCK) JOIN Dinero c
 WITH(NOLOCK) ON c.Empresa = a.Empresa AND c.ID = a.ModuloID JOIN Dinero ca
 WITH(NOLOCK) ON ca.Empresa = c.Empresa AND ca.Mov = a.Aplica AND ca.MovID = a.AplicaID JOIN MovTipo mt
 WITH(NOLOCK) ON mt.Mov = ca.Mov JOIN MovTipo mt2 WITH(NOLOCK)
ON mt2.Mov = c.Mov
WHERE a.Modulo = 'DIN'
AND mt2.Modulo = 'DIN'
AND ISNULL(mt2.Interno,0) = 0
AND mt.Clave IN ('DIN.SD','DIN.D','DIN.CH','DIN.SCH')
AND c.Estatus NOT IN ('SINAFECTAR','CANCELADO')
AND (ca.Estatus = 'PENDIENTE' OR (ca.Estatus = 'CONCLUIDO' AND ca.FechaConclusion >= @FechaA))
AND ca.Estatus = CASE WHEN @EstatusEspecifico IS NULL THEN ca.Estatus ELSE @EstatusEspecifico END
AND a.Cuenta = ISNULL(@Cuenta, a.Cuenta)
AND a.Moneda = ISNULL(@Moneda,a.Moneda)
AND a.Empresa = @Empresa 
ORDER BY a.Moneda, a.Cuenta, a.Aplica, a.AplicaID, a.ID
END
END

