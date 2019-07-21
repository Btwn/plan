SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNetCteEdoCtaInfoGeneral
@Desde			varchar(100),
@Hasta			varchar(100),
@Cliente		varchar(10),
@Empresa		varchar(50)
AS BEGIN
DECLARE
@DesdeD		date,
@HastaD		date,
@CreditoConLimite   BIT,
@CreditoDisponible	VARCHAR(255)
SET @DesdeD =  Convert(date,@Desde,120)
SET @HastaD =  Convert(date,@Hasta,120)
EXEC spGenerarEstadoCuenta @@SPID, @Empresa, 'CXC', @DesdeD, @Cliente, -1, NULL, @HastaD
SELECT @CreditoConLimite = CreditoConLimite FROM Cte WHERE Cliente = @Cliente
IF(@CreditoConLimite = 1)
BEGIN
SELECT ISNULL(c.Nombre,'') [NombreCliente],
ISNULL(A.Nombre,'') [AgenteVentas],
C.Condicion [CondicionPago],
'PESOS' [Moneda],
dbo.fnFormatoMonedaDec(CONVERT(DECIMAL(30,10),(X.Saldo * M.TipoCambio)), 2) [SaldoTotal],
dbo.fnFormatoMonedaDec(CONVERT(DECIMAL(30,10),C.CreditoLimite),2) [LimiteSaldo],
dbo.fnFormatoMonedaDec(CONVERT(DECIMAL(30,10),(C.CreditoLimite - (X.Saldo * M.TipoCambio))),2) [CreditoDisponible]
FROM EstadoCuenta EC
JOIN Cte C ON EC.Cuenta = C.Cliente
LEFT JOIN Auxiliar AU ON EC.AuxiliarID = Au.ID
LEFT JOIN CxcSaldo X ON X.Cliente = C.Cliente
LEFT JOIN Mon M ON M.Moneda = X.Moneda
LEFT JOIN Agente A ON A.Agente = C.Agente
WHERE C.Cliente = @Cliente
AND EC.Modulo='CXC'
AND AU.FECHA BETWEEN @DesdeD AND @HastaD
GROUP BY c.Nombre, X.Saldo, M.TipoCambio, m.moneda, C.CreditoConLimite, A.Nombre, C.Condicion, C.CreditoMoneda, C.CreditoLimite
END
ELSE
BEGIN
SELECT ISNULL(c.Nombre,'') [NombreCliente],
ISNULL(A.Nombre,'') [AgenteVentas],
C.Condicion [CondicionPago],
'PESOS' [Moneda],
dbo.fnFormatoMonedaDec(CONVERT(DECIMAL(30,10),(X.Saldo * M.TipoCambio)), 2) [SaldoTotal],
'No cuenta con un límite de Crédito' [LimiteSaldo],
'No cuenta con un límite de Crédito' [CreditoDisponible]
FROM EstadoCuenta EC
JOIN Cte C ON EC.Cuenta = C.Cliente
LEFT JOIN Auxiliar AU ON EC.AuxiliarID = Au.ID
LEFT JOIN CxcSaldo X ON X.Cliente = C.Cliente
LEFT JOIN Mon M ON M.Moneda = X.Moneda
LEFT JOIN Agente A ON A.Agente = C.Agente
WHERE C.Cliente = @Cliente
AND EC.Modulo='CXC'
AND AU.FECHA BETWEEN @DesdeD AND @HastaD
GROUP BY c.Nombre, X.Saldo, M.TipoCambio, m.moneda, C.CreditoConLimite, A.Nombre, C.Condicion, C.CreditoMoneda, C.CreditoLimite
END
RETURN
END

