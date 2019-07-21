SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spSWProv_Xcobrar
@Empresa   varchar(5),
@Proveedor varchar(10),
@FechaD    datetime,
@FechaA    datetime
AS BEGIN
DECLARE @Tasa float
SELECT @Tasa = CxPMoratoriosTasa FROM EmpresaCfg WHERE Empresa = @Empresa;
SELECT @Tasa = ISNULL(@Tasa, 1.00);
SELECT
RTrim(CxPInfo.ID) ID,
RTrim(CxPInfo.Mov) Mov,
RTrim(CxPInfo.MovID) MovID,
(RTrim(CxPInfo.Mov) + ' ' + RTrim(CxPInfo.MovID)) as Movimiento,
CxPInfo.DiasMoratorios Dias,
CxPInfo.Vencimiento,
CASE WHEN CxPInfo.DiasMoratorios < 0 THEN 0 ELSE CxPInfo.Saldo * CxPInfo.DiasMoratorios * @Tasa / 100 END Moratorios,
CxPInfo.Saldo,
RTrim(Moneda) Moneda,
Referencia,
AnexoXml = (SELECT TOP 1 a.Direccion FROM AnexoMov a WHERE a.Tipo = 'Archivo' AND a.Direccion like '%.xml' AND a.id = CxPInfo.id),
AnexoPdf = (SELECT TOP 1 a.Direccion FROM AnexoMov a WHERE a.Tipo = 'Archivo' AND a.Direccion like '%.pdf' AND a.id = CxPInfo.id)
FROM CxPInfo
WHERE CxPInfo.Empresa = @Empresa AND CxPInfo.Proveedor = @Proveedor AND CxPInfo.Vencimiento between @FechaD AND @FechaA
ORDER BY Mov ASC
RETURN
END

