SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNetProvEdoCtaInfoGeneral
@Desde			varchar(100),
@Hasta			varchar(100),
@Proveedor		varchar(10),
@Empresa		varchar(50)
AS BEGIN
DECLARE
@DesdeD		date,
@HastaD		date
SET @DesdeD =  CONVERT(date,@Desde,120)
SET @HastaD =  CONVERT(date,@Hasta,120)
EXEC spGenerarEstadoCuenta @@SPID, @Empresa, 'CXP', @DesdeD, @Proveedor, -1, NULL, @HastaD
SELECT ISNULL(P.Nombre,'') [ProveedorD],
ISNULL(A.Agente,'') [AgenteVentas],
ISNULL(P.Condicion,'') [CondicionPago],
ISNULL(P.DefMoneda,'') [Moneda],
(X.Saldo * M.TipoCambio) [SaldoTotal]
FROM EstadoCuenta EC
JOIN Prov P ON P.Proveedor = EC.Cuenta
LEFT JOIN Auxiliar AU ON EC.AuxiliarID = Au.ID
LEFT JOIN CxpSaldo X ON X.Proveedor = p.Proveedor
LEFT JOIN Mon M ON M.Moneda = X.Moneda AND M.Moneda = P.DefMoneda
LEFT JOIN Agente A ON A.Agente = p.Agente
WHERE P.Proveedor = @Proveedor
AND EC.Modulo='CXP'
AND AU.FECHA BETWEEN @Desde AND @Hasta
GROUP BY P.Nombre, A.Agente, p.Condicion, p.DefMoneda, X.Saldo, M.TipoCambio
RETURN
END

