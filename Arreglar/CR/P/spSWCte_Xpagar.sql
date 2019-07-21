SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spSWCte_Xpagar
@Empresa varchar(5),
@Cliente varchar(10),
@FechaD   Datetime,
@FechaA   Datetime
AS BEGIN
DECLARE @Tasa FLOAT;
SELECT @Tasa = CxCMoratoriosTasa FROM EmpresaCfg WHERE Empresa = @Empresa;
SELECT @Tasa = ISNULL(@Tasa, 1.00);
SELECT
CxcInfo.ID,
RTrim(CxcInfo.Mov) Mov,
RTrim(CxcInfo.MovID) MovID,
(RTrim(CxcInfo.Mov) + ' ' + RTrim(CxcInfo.MovID)) as Movimiento,
CxcInfo.DiasMoratorios Dias,
CxcInfo.Saldo,
CxcInfo.Vencimiento,
CONVERT(char(12), CxcInfo.Vencimiento, 106) FechaVencimiento,
CxcInfo.FechaEmision, CONVERT(char(12), CxcInfo.FechaEmision, 106) Emision,
CASE WHEN CxcInfo.DiasMoratorios < 0 THEN 0 ELSE CxcInfo.Saldo * CxcInfo.DiasMoratorios * @Tasa / 100 END Moratorios,
RTrim(CxcInfo.Moneda) Moneda,
CxcInfo.Empresa,
CxcInfo.Cliente,
CxcInfo.Vencimiento
FROM CxcInfo 
WHERE CxcInfo.ID IS NOT NULL AND
CxcInfo.Empresa = @Empresa AND
CxcInfo.Cliente = @Cliente AND
CxcInfo.Vencimiento BETWEEN @FechaD AND @FechaA AND
CxcInfo.Mov NOT IN ('Cobro Posfechado')
ORDER BY Dias DESC
RETURN
END

