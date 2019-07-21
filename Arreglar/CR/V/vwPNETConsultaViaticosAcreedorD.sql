SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.vwPNETConsultaViaticosAcreedorD
AS
SELECT
C.Cliente [Cliente],
AU.MovID [Movimiento],
CONVERT(VARCHAR(10),AU.Fecha,105) [Fecha],
CONVERT(varchar(50),ISNULL(CXC.Vencimiento,''),105) AS [Vencimiento],
AU.Cargo [Cargo],
AU.Abono [Abono],
CXC.Saldo [Saldo],
ISNULL(AU.Moneda,'') [Moneda],
CONVERT(MONEY,ROUND(ISNULL(AU.TipoCambio,0.00),2)) AS [TipoCambio],
ISNULL(CXC.Estatus,'') [Estatus],
ISNULL(CXC.Concepto,'') [Concepto],
AU.AplicaID,
AU.Aplica,
AU.MovID,
AU.Mov,
AU.ModuloID
FROM EstadoCuenta EC
JOIN Cte C ON EC.Cuenta = C.Cliente
LEFT JOIN Auxiliar AU ON EC.AuxiliarID = Au.ID
LEFT JOIN CXC CXC ON CXC.ID = AU.ModuloID
LEFT JOIN MovTipo MT ON MT.Modulo = AU.Modulo AND CXC.Mov = MT.Mov
WHERE /*C.Cliente = '001'*/
EC.Modulo='CXC'
AND MT.Clave NOT IN ('CXC.EST','CXC.SD','CXC.SCH')
AND CXC.Estatus  NOT IN ('CANCELADO')
/*AND AU.AplicaID = RTRIM(@Origen)*/
GROUP BY AU.Fecha, AU.Mov, AU.MovID, CXC.Concepto, CXC.Estatus, AU.Moneda, AU.TipoCambio, AU.Cargo, AU.Abono,CXC.Saldo,CXC.Vencimiento,AU.AplicaID,AU.Aplica,AU.MovID,AU.Mov,AU.ModuloID,C.Cliente

