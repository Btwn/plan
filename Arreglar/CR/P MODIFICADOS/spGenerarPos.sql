SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarPos
@Empresa		char(5),
@Estacion		int,
@Moneda		char(10),             
@MonedaVer		char(20),
@SimularMeses	int,
@Intervalo		int	 = 7,
@ConDinero		char(2)  = 'SI',
@ConInv		char(2)  = 'SI',
@ConCxc		char(2)  = 'SI',
@ConCxp		char(2)  = 'SI',
@ConGastos		char(2)  = 'SI',
@ConVentas		char(2)  = 'SI',
@ConCompras		char(2)  = 'SI',
@Nivel		char(20) = 'MOVIMIENTO'   

AS BEGIN
SET nocount ON
DECLARE
@Ok			int,
@OkRef		varchar(255),
@Rama 		char(5),
@Mov		char(20),
@MovID		varchar(20),
@MovTipo		char(20),
@MonedaEspecifica	char(10),
@Cuenta		char(20),
@Referencia		char(50),
@Periodicidad	char(50),
@Nombre		char(100),
@Observaciones	char(100),
@FechaEmision	datetime,
@Vencimiento	datetime,
@SimulaVencimiento  datetime,
@TipoCambio		float,
@SumaDisponible	money,
@SumaVigente5	money,
@SumaVigente4	money,
@SumaVigente3	money,
@SumaVigente2	money,
@SumaVigente1	money,
@SumaVencido1	money,
@SumaVencido2	money,
@SumaVencido3	money,
@SumaVencido4	money,
@SumaVencido5	money,
@TotalVigente5	money,
@TotalVigente4	money,
@TotalVigente3	money,
@TotalVigente2	money,
@TotalVigente1	money,
@TotalVencido1	money,
@TotalVencido2	money,
@TotalVencido3	money,
@TotalVencido4	money,
@TotalVencido5	money,
@AcumVigente	money,
@AcumVigente5	money,
@AcumVigente4	money,
@AcumVigente3	money,
@AcumVigente2	money,
@AcumVigente1	money,
@AcumVencido	money,
@AcumVencido1	money,
@AcumVencido2	money,
@AcumVencido3	money,
@AcumVencido4	money,
@AcumVencido5	money,
@Saldo		money,
@Hoy		datetime
SELECT @ConDinero = UPPER(@ConDinero), @ConCxc = UPPER(@ConCxc), @ConCxp = UPPER(@ConCxp), @ConGastos = UPPER(@ConGastos),
@ConInv = UPPER(@ConInv), @ConVentas = UPPER(@ConVentas), @ConCompras = UPPER(@ConCompras), @Nivel = UPPER(@Nivel),
@Moneda = NULLIF(RTRIM(@Moneda), ''), @Hoy = GETDATE(), @TipoCambio = 1.0
SELECT @SumaDisponible = 0.0
SELECT @TotalVigente5 = 0.0, @TotalVigente4 = 0.0, @TotalVigente3 = 0.0, @TotalVigente2 = 0.0, @TotalVigente1 = 0.0,
@TotalVencido5 = 0.0, @TotalVencido4 = 0.0, @TotalVencido3 = 0.0, @TotalVencido2 = 0.0, @TotalVencido1 = 0.0
IF UPPER(@MonedaVer) = 'MONEDA ESPECIFICA' SELECT @MonedaEspecifica = @Moneda ELSE SELECT @MonedaEspecifica = NULL
EXEC spExtraerFecha @Hoy OUTPUT
SELECT @SimulaVencimiento = DATEADD(mm, @SimularMeses, @Hoy)
DELETE VerPos WHERE Estacion = @Estacion
IF @MonedaEspecifica IS NULL
SELECT @TipoCambio = TipoCambio FROM Mon WITH(NOLOCK) WHERE Moneda = @Moneda
IF @ConDinero = 'SI'
BEGIN
SELECT @SumaVigente5 = 0.0, @SumaVigente4 = 0.0, @SumaVigente3 = 0.0, @SumaVigente2 = 0.0, @SumaVigente1 = 0.0,
@SumaVencido5 = 0.0, @SumaVencido4 = 0.0, @SumaVencido3 = 0.0, @SumaVencido2 = 0.0, @SumaVencido1 = 0.0
IF @MonedaEspecifica IS NOT NULL
DECLARE crDineroSaldo CURSOR FOR
SELECT s.CtaDinero, c.Descripcion, SUM(s.Saldo)
FROM DineroSaldo s, CtaDinero c
WITH(NOLOCK) WHERE s.CtaDinero = c.CtaDinero AND s.Empresa = @Empresa AND s.Moneda = @MonedaEspecifica
GROUP BY s.CtaDinero, c.Descripcion
ORDER BY s.CtaDinero, c.Descripcion
ELSE
DECLARE crDineroSaldo CURSOR FOR
SELECT s.CtaDinero, c.Descripcion, CONVERT(money, SUM(s.Saldo*Mon.TipoCambio)/@TipoCambio)
FROM DineroSaldo s, CtaDinero c, Mon
WITH(NOLOCK) WHERE s.CtaDinero = c.CtaDinero AND s.Empresa = @Empresa AND s.Moneda = Mon.Moneda
GROUP BY s.CtaDinero, c.Descripcion
ORDER BY s.CtaDinero, c.Descripcion
OPEN crDineroSaldo
FETCH NEXT FROM crDineroSaldo  INTO @Cuenta, @Nombre, @Saldo
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
INSERT INTO VerPos (Estacion,  Orden, Modulo, Cuenta,  Nombre,  Disponible)
VALUES (@Estacion, 1,     'DIN',  @Cuenta, @Nombre, @Saldo)
SELECT @SumaDisponible = @SumaDisponible + ISNULL(@Saldo, 0)
END
FETCH NEXT FROM crDineroSaldo  INTO @Cuenta, @Nombre, @Saldo
END
CLOSE crDineroSaldo
DEALLOCATE crDineroSaldo
IF @MonedaEspecifica IS NOT NULL
DECLARE crDineroPendientes CURSOR FOR
SELECT p.CtaDinero, c.Descripcion, p.Mov, p.MovID, p.Referencia, p.Observaciones, p.FechaEmision, p.FechaProgramada, m.Clave, ISNULL(p.Saldo, 0.0)
FROM Dinero p
LEFT OUTER JOIN CtaDinero c  WITH(NOLOCK) ON p.CtaDinero = c.CtaDinero
JOIN MovTipo m  WITH(NOLOCK) ON p.Mov = m.Mov
WHERE m.Modulo = 'DIN'
AND m.Clave IN ('DIN.I', 'DIN.SD', 'DIN.E', 'DIN.SCH')
AND p.Empresa = @Empresa
AND p.Estatus = 'PENDIENTE'
AND p.Moneda = @MonedaEspecifica
ELSE
DECLARE crDineroPendientes CURSOR FOR
SELECT p.CtaDinero, c.Descripcion, p.Mov, p.MovID, p.Referencia, p.Observaciones, p.FechaEmision, p.FechaProgramada, m.Clave, CONVERT(money, (ISNULL(p.Saldo, 0.0)*Mon.TipoCambio)/@TipoCambio)
FROM Dinero p
LEFT OUTER JOIN CtaDinero c  WITH(NOLOCK) ON p.CtaDinero = c.CtaDinero
JOIN MovTipo m  WITH(NOLOCK) ON p.Mov = m.Mov
JOIN Mon  WITH(NOLOCK) ON p.Moneda = Mon.Moneda
WHERE m.Modulo = 'DIN'
AND m.Clave IN ('DIN.I', 'DIN.SD', 'DIN.E', 'DIN.SCH')
AND p.Empresa = @Empresa
AND p.Estatus = 'PENDIENTE'
OPEN crDineroPendientes
FETCH NEXT FROM crDineroPendientes  INTO @Cuenta, @Nombre, @Mov, @MovID, @Referencia, @Observaciones, @FechaEmision, @Vencimiento, @MovTipo, @Saldo
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @MovTipo IN ('DIN.E', 'DIN.SCH') SELECT @Saldo = -@Saldo
EXEC spPosAgregarMov @Estacion, 1, 'DIN', @Cuenta, @Nombre, @Mov, @MovID, @Referencia, @Observaciones, @FechaEmision, @Vencimiento, @Hoy, @Intervalo, @Saldo,
@SumaVigente1  OUTPUT, @SumaVigente2  OUTPUT, @SumaVigente3  OUTPUT, @SumaVigente4  OUTPUT, @SumaVigente5  OUTPUT,
@SumaVencido1  OUTPUT, @SumaVencido2  OUTPUT, @SumaVencido3  OUTPUT, @SumaVencido4  OUTPUT, @SumaVencido5  OUTPUT,
@TotalVigente1 OUTPUT, @TotalVigente2 OUTPUT, @TotalVigente3 OUTPUT, @TotalVigente4 OUTPUT, @TotalVigente5 OUTPUT,
@TotalVencido1 OUTPUT, @TotalVencido2 OUTPUT, @TotalVencido3 OUTPUT, @TotalVencido4 OUTPUT, @TotalVencido5 OUTPUT
END
FETCH NEXT FROM crDineroPendientes  INTO @Cuenta, @Nombre, @Mov, @MovID, @Referencia, @Observaciones, @FechaEmision, @Vencimiento, @MovTipo, @Saldo
END
CLOSE crDineroPendientes
DEALLOCATE crDineroPendientes
EXEC spPosAgregarTotal @Estacion, 1, 'DIN', @SumaDisponible,
@SumaVigente1, @SumaVigente2, @SumaVigente3, @SumaVigente4, @SumaVigente5,
@SumaVencido1, @SumaVencido2, @SumaVencido3, @SumaVencido4, @SumaVencido5
END
IF @ConInv = 'SI'
BEGIN
SELECT @Saldo = 0.0
IF @MonedaEspecifica IS NOT NULL
SELECT @Saldo = ISNULL(SUM(Saldo), 0)
FROM SaldoU s
WITH(NOLOCK) WHERE s.Empresa = @Empresa
AND s.Rama = 'INV'
AND s.Moneda = @MonedaEspecifica
ELSE
SELECT @Saldo = SUM(ISNULL(s.Saldo, 0)*Mon.TipoCambio)/@TipoCambio
FROM SaldoU s, Mon
WITH(NOLOCK) WHERE s.Empresa = @Empresa
AND s.Rama = 'INV'
AND s.Moneda = Mon.Moneda
EXEC spPosAgregarTotal @Estacion, 2, 'INV', @Saldo,
NULL, NULL, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL
SELECT @SumaDisponible = @SumaDisponible + @Saldo
END
IF @ConCxc = 'SI'
BEGIN
SELECT @SumaVigente5 = 0.0, @SumaVigente4 = 0.0, @SumaVigente3 = 0.0, @SumaVigente2 = 0.0, @SumaVigente1 = 0.0,
@SumaVencido5 = 0.0, @SumaVencido4 = 0.0, @SumaVencido3 = 0.0, @SumaVencido2 = 0.0, @SumaVencido1 = 0.0
IF @MonedaEspecifica IS NOT NULL
DECLARE crCxcPendientes CURSOR FOR
SELECT p.Cliente, Cte.Nombre, p.Mov, p.MovID, p.Referencia, p.Observaciones, p.FechaEmision, p.Vencimiento, m.Clave, ISNULL(p.Saldo*m.Factor, 0.0)
FROM Cxc p, Cte, MovTipo m
WITH(NOLOCK) WHERE p.Empresa = @Empresa
AND p.Estatus = 'PENDIENTE'
AND p.Moneda  = @MonedaEspecifica
AND p.Cliente = Cte.Cliente
AND p.Mov     = m.Mov AND m.Modulo = 'CXC'
AND m.Clave NOT IN('CXC.SD','CXC.SCH')
ELSE
DECLARE crCxcPendientes CURSOR FOR
SELECT p.Cliente, Cte.Nombre, p.Mov, p.MovID, p.Referencia, p.Observaciones, p.FechaEmision, p.Vencimiento, m.Clave, CONVERT(money, (ISNULL(p.Saldo*m.Factor, 0.0)*Mon.TipoCambio)/@TipoCambio)
FROM Cxc p, Cte, MovTipo m, Mon
WITH(NOLOCK) WHERE p.Empresa = @Empresa
AND p.Estatus = 'PENDIENTE'
AND p.Moneda  = Mon.Moneda
AND p.Cliente = Cte.Cliente
AND p.Mov     = m.Mov AND m.Modulo = 'CXC'
AND m.Clave NOT IN('CXC.SD','CXC.SCH')
OPEN crCxcPendientes
FETCH NEXT FROM crCxcPendientes  INTO @Cuenta, @Nombre, @Mov, @MovID, @Referencia, @Observaciones, @FechaEmision, @Vencimiento, @MovTipo, @Saldo
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @MovTipo IN ('CXC.NC','CXC.DAC','CXC.NCD','CXC.NCF','CXC.DV','CXC.NCP') SELECT @Saldo = -@Saldo
EXEC spPosAgregarMov @Estacion, 3, 'CXC', @Cuenta, @Nombre, @Mov, @MovID, @Referencia, @Observaciones, @FechaEmision, @Vencimiento, @Hoy, @Intervalo, @Saldo,
@SumaVigente1  OUTPUT, @SumaVigente2  OUTPUT, @SumaVigente3  OUTPUT, @SumaVigente4  OUTPUT, @SumaVigente5  OUTPUT,
@SumaVencido1  OUTPUT, @SumaVencido2  OUTPUT, @SumaVencido3  OUTPUT, @SumaVencido4  OUTPUT, @SumaVencido5  OUTPUT,
@TotalVigente1 OUTPUT, @TotalVigente2 OUTPUT, @TotalVigente3 OUTPUT, @TotalVigente4 OUTPUT, @TotalVigente5 OUTPUT,
@TotalVencido1 OUTPUT, @TotalVencido2 OUTPUT, @TotalVencido3 OUTPUT, @TotalVencido4 OUTPUT, @TotalVencido5 OUTPUT
END
FETCH NEXT FROM crCxcPendientes  INTO @Cuenta, @Nombre, @Mov, @MovID, @Referencia, @Observaciones, @FechaEmision, @Vencimiento, @MovTipo, @Saldo
END
CLOSE crCxcPendientes
DEALLOCATE crCxcPendientes
EXEC spPosAgregarTotal @Estacion, 3, 'CXC', NULL,
@SumaVigente1, @SumaVigente2, @SumaVigente3, @SumaVigente4, @SumaVigente5,
@SumaVencido1, @SumaVencido2, @SumaVencido3, @SumaVencido4, @SumaVencido5
END
IF @ConCxp = 'SI'
BEGIN
SELECT @SumaVigente5 = 0.0, @SumaVigente4 = 0.0, @SumaVigente3 = 0.0, @SumaVigente2 = 0.0, @SumaVigente1 = 0.0,
@SumaVencido5 = 0.0, @SumaVencido4 = 0.0, @SumaVencido3 = 0.0, @SumaVencido2 = 0.0, @SumaVencido1 = 0.0
IF @MonedaEspecifica IS NOT NULL
DECLARE crCxpPendientes CURSOR FOR
SELECT p.Proveedor, Prov.Nombre, p.Mov, p.MovID, p.Referencia, p.Observaciones, p.FechaEmision, p.Vencimiento, m.Clave, ISNULL(-p.Saldo, 0.0)
FROM Cxp p, Prov, MovTipo m
WITH(NOLOCK) WHERE p.Empresa   = @Empresa
AND p.Estatus   = 'PENDIENTE'
AND p.Moneda    = @MonedaEspecifica
AND p.Proveedor = Prov.Proveedor
AND p.Mov       = m.Mov AND m.Modulo = 'CXP'
AND m.Clave NOT IN('CXP.SD','CXP.SCH')
ELSE
DECLARE crCxpPendientes CURSOR FOR
SELECT p.Proveedor, Prov.Nombre, p.Mov, p.MovID, p.Referencia, p.Observaciones, p.FechaEmision, p.Vencimiento, m.Clave, CONVERT(money, (ISNULL(-p.Saldo, 0.0)*Mon.TipoCambio)/@TipoCambio)
FROM Cxp p, Prov, MovTipo m, Mon
WITH(NOLOCK) WHERE p.Empresa   = @Empresa
AND p.Estatus   = 'PENDIENTE'
AND p.Moneda    = Mon.Moneda
AND p.Proveedor = Prov.Proveedor
AND p.Mov       = m.Mov AND m.Modulo = 'CXP'
AND m.Clave NOT IN('CXP.SD','CXP.SCH')
OPEN crCxpPendientes
FETCH NEXT FROM crCxpPendientes  INTO @Cuenta, @Nombre, @Mov, @MovID, @Referencia, @Observaciones, @FechaEmision, @Vencimiento, @MovTipo, @Saldo
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @MovTipo IN ('CXP.NC','CXP.DAC','CXP.NCD','CXP.NCF','CXP.NCP') SELECT @Saldo = -@Saldo
EXEC spPosAgregarMov @Estacion, 4, 'CXP', @Cuenta, @Nombre, @Mov, @MovID, @Referencia, @Observaciones, @FechaEmision, @Vencimiento, @Hoy, @Intervalo, @Saldo,
@SumaVigente1  OUTPUT, @SumaVigente2  OUTPUT, @SumaVigente3  OUTPUT, @SumaVigente4  OUTPUT, @SumaVigente5  OUTPUT,
@SumaVencido1  OUTPUT, @SumaVencido2  OUTPUT, @SumaVencido3  OUTPUT, @SumaVencido4  OUTPUT, @SumaVencido5  OUTPUT,
@TotalVigente1 OUTPUT, @TotalVigente2 OUTPUT, @TotalVigente3 OUTPUT, @TotalVigente4 OUTPUT, @TotalVigente5 OUTPUT,
@TotalVencido1 OUTPUT, @TotalVencido2 OUTPUT, @TotalVencido3 OUTPUT, @TotalVencido4 OUTPUT, @TotalVencido5 OUTPUT
END
FETCH NEXT FROM crCxpPendientes  INTO @Cuenta, @Nombre, @Mov, @MovID, @Referencia, @Observaciones, @FechaEmision, @Vencimiento, @MovTipo, @Saldo
END
CLOSE crCxpPendientes
DEALLOCATE crCxpPendientes
EXEC spPosAgregarTotal @Estacion, 4, 'CXP', NULL,
@SumaVigente1, @SumaVigente2, @SumaVigente3, @SumaVigente4, @SumaVigente5,
@SumaVencido1, @SumaVencido2, @SumaVencido3, @SumaVencido4, @SumaVencido5
END
IF @ConGastos = 'SI'
BEGIN
SELECT @Referencia = NULL
SELECT @SumaVigente5 = 0.0, @SumaVigente4 = 0.0, @SumaVigente3 = 0.0, @SumaVigente2 = 0.0, @SumaVigente1 = 0.0,
@SumaVencido5 = 0.0, @SumaVencido4 = 0.0, @SumaVencido3 = 0.0, @SumaVencido2 = 0.0, @SumaVencido1 = 0.0
IF @MonedaEspecifica IS NOT NULL
DECLARE crGastoRecurrente CURSOR FOR
SELECT p.Acreedor, Prov.Nombre, p.Mov, p.MovID, p.Observaciones, p.FechaEmision, p.Vencimiento, NULLIF(RTRIM(p.Periodicidad), ''), (ISNULL(p.Importe, 0.0) - ISNULL(p.Retencion, 0.0) + ISNULL(p.Impuestos, 0.0))
FROM Gasto p, Prov
WITH(NOLOCK) WHERE p.Empresa     = @Empresa
AND p.Estatus    = 'RECURRENTE'
AND p.Moneda      = @MonedaEspecifica
AND p.Vencimiento <= @SimulaVencimiento
AND p.Acreedor    = Prov.Proveedor
ELSE
DECLARE crGastoRecurrente CURSOR FOR
SELECT p.Acreedor, Prov.Nombre, p.Mov, p.MovID, p.Observaciones, p.FechaEmision, p.Vencimiento, NULLIF(RTRIM(p.Periodicidad), ''), CONVERT(money, ((ISNULL(p.Importe, 0.0) - ISNULL(p.Retencion, 0.0) + ISNULL(p.Impuestos, 0.0))*Mon.TipoCambio)/@TipoCambio)
FROM Gasto p, Prov, Mon
WITH(NOLOCK) WHERE p.Empresa     = @Empresa
AND p.Estatus    = 'RECURRENTE'
AND p.Moneda      = Mon.Moneda
AND p.Acreedor    = Prov.Proveedor
AND p.Vencimiento <= @SimulaVencimiento
OPEN crGastoRecurrente
FETCH NEXT FROM crGastoRecurrente  INTO @Cuenta, @Nombre, @Mov, @MovID, @Observaciones, @FechaEmision, @Vencimiento, @Periodicidad, @Saldo
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Saldo = -@Saldo
EXEC spExtraerFecha @Vencimiento OUTPUT
WHILE @Periodicidad IS NOT NULL AND @Vencimiento <= @SimulaVencimiento
BEGIN
EXEC spPosAgregarMov @Estacion, 5, 'GAS', @Cuenta, @Nombre, @Mov, @MovID, @Referencia, @Observaciones, @FechaEmision, @Vencimiento, @Hoy, @Intervalo, @Saldo,
@SumaVigente1  OUTPUT, @SumaVigente2  OUTPUT, @SumaVigente3  OUTPUT, @SumaVigente4  OUTPUT, @SumaVigente5  OUTPUT,
@SumaVencido1  OUTPUT, @SumaVencido2  OUTPUT, @SumaVencido3  OUTPUT, @SumaVencido4  OUTPUT, @SumaVencido5  OUTPUT,
@TotalVigente1 OUTPUT, @TotalVigente2 OUTPUT, @TotalVigente3 OUTPUT, @TotalVigente4 OUTPUT, @TotalVigente5 OUTPUT,
@TotalVencido1 OUTPUT, @TotalVencido2 OUTPUT, @TotalVencido3 OUTPUT, @TotalVencido4 OUTPUT, @TotalVencido5 OUTPUT
EXEC spCalcularPeriodicidad @Vencimiento, @Periodicidad, @Vencimiento OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
END
FETCH NEXT FROM crGastoRecurrente  INTO @Cuenta, @Nombre, @Mov, @MovID, @Observaciones, @FechaEmision, @Vencimiento, @Periodicidad, @Saldo
END
CLOSE crGastoRecurrente
DEALLOCATE crGastoRecurrente
EXEC spPosAgregarTotal @Estacion, 5, 'GAS', NULL,
@SumaVigente1, @SumaVigente2, @SumaVigente3, @SumaVigente4, @SumaVigente5,
@SumaVencido1, @SumaVencido2, @SumaVencido3, @SumaVencido4, @SumaVencido5
END
IF @ConVentas = 'SI'
BEGIN
SELECT @SumaVigente5 = 0.0, @SumaVigente4 = 0.0, @SumaVigente3 = 0.0, @SumaVigente2 = 0.0, @SumaVigente1 = 0.0,
@SumaVencido5 = 0.0, @SumaVencido4 = 0.0, @SumaVencido3 = 0.0, @SumaVencido2 = 0.0, @SumaVencido1 = 0.0
IF @MonedaEspecifica IS NOT NULL
DECLARE crVentasPendientes CURSOR FOR
SELECT p.Cliente, Cte.Nombre, p.Mov, p.MovID, p.Referencia, p.Observaciones, p.FechaEmision, p.Vencimiento, ISNULL(p.Saldo, 0.0)
FROM Venta p, Cte
WITH(NOLOCK) WHERE p.Estatus = 'PENDIENTE'
AND p.Empresa = @Empresa
AND p.Cliente = Cte.Cliente
AND p.Moneda = @MonedaEspecifica
ELSE
DECLARE crVentasPendientes CURSOR FOR
SELECT p.Cliente, Cte.Nombre, p.Mov, p.MovID, p.Referencia, p.Observaciones, p.FechaEmision, p.Vencimiento, Convert(money, ISNULL(p.Saldo, 0.0)*Mon.TipoCambio/@TipoCambio)
FROM Venta p, Cte, Mon
WITH(NOLOCK) WHERE p.Estatus = 'PENDIENTE'
AND p.Empresa = @Empresa
AND p.Cliente = Cte.Cliente
AND p.Moneda = Mon.Moneda
OPEN crVentasPendientes
FETCH NEXT FROM crVentasPendientes  INTO @Cuenta, @Nombre, @Mov, @MovID, @Referencia, @Observaciones, @FechaEmision, @Vencimiento, @Saldo
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spPosAgregarMov @Estacion, 6, 'VTAS', @Cuenta, @Nombre, @Mov, @MovID, @Referencia, @Observaciones, @FechaEmision, @Vencimiento, @Hoy, @Intervalo, @Saldo,
@SumaVigente1  OUTPUT, @SumaVigente2  OUTPUT, @SumaVigente3  OUTPUT, @SumaVigente4  OUTPUT, @SumaVigente5  OUTPUT,
@SumaVencido1  OUTPUT, @SumaVencido2  OUTPUT, @SumaVencido3  OUTPUT, @SumaVencido4  OUTPUT, @SumaVencido5  OUTPUT,
@TotalVigente1 OUTPUT, @TotalVigente2 OUTPUT, @TotalVigente3 OUTPUT, @TotalVigente4 OUTPUT, @TotalVigente5 OUTPUT,
@TotalVencido1 OUTPUT, @TotalVencido2 OUTPUT, @TotalVencido3 OUTPUT, @TotalVencido4 OUTPUT, @TotalVencido5 OUTPUT
END
FETCH NEXT FROM crVentasPendientes  INTO @Cuenta, @Nombre, @Mov, @MovID, @Referencia, @Observaciones, @FechaEmision, @Vencimiento, @Saldo
END
CLOSE crVentasPendientes
DEALLOCATE crVentasPendientes
EXEC spPosAgregarTotal @Estacion, 6, 'VTAS', NULL,
@SumaVigente1, @SumaVigente2, @SumaVigente3, @SumaVigente4, @SumaVigente5,
@SumaVencido1, @SumaVencido2, @SumaVencido3, @SumaVencido4, @SumaVencido5
END
IF @ConCompras = 'SI'
BEGIN
SELECT @SumaVigente5 = 0.0, @SumaVigente4 = 0.0, @SumaVigente3 = 0.0, @SumaVigente2 = 0.0, @SumaVigente1 = 0.0,
@SumaVencido5 = 0.0, @SumaVencido4 = 0.0, @SumaVencido3 = 0.0, @SumaVencido2 = 0.0, @SumaVencido1 = 0.0
IF @MonedaEspecifica IS NOT NULL
DECLARE crComprasPendientes CURSOR FOR
SELECT p.Proveedor, prov.Nombre, p.Mov, p.MovID, p.Referencia, p.Observaciones, p.FechaEmision, p.Vencimiento, ISNULL(p.Saldo, 0.0)
FROM Compra p, Prov
WITH(NOLOCK) WHERE p.Estatus = 'PENDIENTE'
AND p.Empresa = @Empresa
AND p.Proveedor = Prov.Proveedor
AND p.Moneda = @MonedaEspecifica
ELSE
DECLARE crComprasPendientes CURSOR FOR
SELECT p.Proveedor, prov.Nombre, p.Mov, p.MovID, p.Referencia, p.Observaciones, p.FechaEmision, p.Vencimiento, Convert(money, ISNULL(p.Saldo, 0.0)*Mon.TipoCambio/@TipoCambio)
FROM Compra p, Prov, Mon
WITH(NOLOCK) WHERE p.Estatus = 'PENDIENTE'
AND p.Empresa = @Empresa
AND p.Proveedor = Prov.Proveedor
AND p.Moneda = Mon.Moneda
OPEN crComprasPendientes
FETCH NEXT FROM crComprasPendientes  INTO @Cuenta, @Nombre, @Mov, @MovID, @Referencia, @Observaciones, @FechaEmision, @Vencimiento, @Saldo
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Saldo = -@Saldo
EXEC spPosAgregarMov @Estacion, 7, 'COMS', @Cuenta, @Nombre, @Mov, @MovID, @Referencia, @Observaciones, @FechaEmision, @Vencimiento, @Hoy, @Intervalo, @Saldo,
@SumaVigente1  OUTPUT, @SumaVigente2  OUTPUT, @SumaVigente3  OUTPUT, @SumaVigente4  OUTPUT, @SumaVigente5  OUTPUT,
@SumaVencido1  OUTPUT, @SumaVencido2  OUTPUT, @SumaVencido3  OUTPUT, @SumaVencido4  OUTPUT, @SumaVencido5  OUTPUT,
@TotalVigente1 OUTPUT, @TotalVigente2 OUTPUT, @TotalVigente3 OUTPUT, @TotalVigente4 OUTPUT, @TotalVigente5 OUTPUT,
@TotalVencido1 OUTPUT, @TotalVencido2 OUTPUT, @TotalVencido3 OUTPUT, @TotalVencido4 OUTPUT, @TotalVencido5 OUTPUT
END
FETCH NEXT FROM crComprasPendientes  INTO @Cuenta, @Nombre, @Mov, @MovID, @Referencia, @Observaciones, @FechaEmision, @Vencimiento, @Saldo
END
CLOSE crComprasPendientes
DEALLOCATE crComprasPendientes
EXEC spPosAgregarTotal @Estacion, 7, 'COMS', NULL,
@SumaVigente1, @SumaVigente2, @SumaVigente3, @SumaVigente4, @SumaVigente5,
@SumaVencido1, @SumaVencido2, @SumaVencido3, @SumaVencido4, @SumaVencido5
END
EXEC spPosAgregarTotal @Estacion, 99, 'zz', @SumaDisponible,
@TotalVigente1, @TotalVigente2, @TotalVigente3, @TotalVigente4, @TotalVigente5,
@TotalVencido1, @TotalVencido2, @TotalVencido3, @TotalVencido4, @TotalVencido5
SELECT @AcumVencido5   = @SumaDisponible + @TotalVencido5
SELECT @AcumVencido4   = @AcumVencido5   + @TotalVencido4
SELECT @AcumVencido3   = @AcumVencido4   + @TotalVencido3
SELECT @AcumVencido2   = @AcumVencido3   + @TotalVencido2
SELECT @AcumVencido1   = @AcumVencido2   + @TotalVencido1
SELECT @AcumVigente1   = @AcumVencido1   + @TotalVigente1
SELECT @AcumVigente2   = @AcumVigente1   + @TotalVigente2
SELECT @AcumVigente3   = @AcumVigente2   + @TotalVigente3
SELECT @AcumVigente4   = @AcumVigente3   + @TotalVigente4
SELECT @AcumVigente5   = @AcumVigente4   + @TotalVigente5
SELECT @AcumVencido = @SumaDisponible + @TotalVencido5 + @TotalVencido4 + @TotalVencido3 + @TotalVencido2 + @TotalVencido1
SELECT @AcumVigente = @AcumVencido    + @TotalVigente1 + @TotalVigente2 + @TotalVigente3 + @TotalVigente4 + @TotalVigente5
INSERT INTO VerPos (Estacion,  Orden, Modulo, Periodo, Cuenta,  Disponible,      Vencido,      Vencido5,      Vencido4,      Vencido3,      Vencido2,      Vencido1,      Vigente,      Vigente1,      Vigente2,      Vigente3,      Vigente4,      Vigente5)
VALUES (@Estacion, 100,   'zz',   1000,    'Flujo', @SumaDisponible, @AcumVencido, @AcumVencido5, @AcumVencido4, @AcumVencido3, @AcumVencido2, @AcumVencido1, @AcumVigente, @AcumVigente1, @AcumVigente2, @AcumVigente3, @AcumVigente4, @AcumVigente5)
END

