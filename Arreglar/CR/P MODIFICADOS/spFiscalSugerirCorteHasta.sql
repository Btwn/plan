SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spFiscalSugerirCorteHasta
@Empresa		char(5),
@Sucursal		int,
@Usuario		char(10),
@Desde		datetime,
@Hasta		datetime,
@Mov			varchar(20),
@Conteo		int		OUTPUT,
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@ObligacionFiscal	varchar(50),
@Acreedor		varchar(10),
@Condicion		varchar(50),
@Vencimiento	datetime,
@TotalMN		money,
@Moneda		varchar(10),
@TipoCambio		float,
@FiscalID		int
DECLARE
@CorteFiscal        TABLE (ObligacionFiscal varchar(50) NULL, Importe money, OtrosImpuestos money, Tasa float NULL, Excento bit NULL, Deducible float NULL, OrigenModulo varchar(5), OrigenModuloID	int, Contacto varchar(10), ContactoTipo	varchar(20), AFArticulo	varchar(20), AFSerie varchar(20), Acreedor varchar(10) NULL, Condicion varchar(50) NULL)
SELECT @Moneda = m.Moneda, @TipoCambio = m.TipoCambio
FROM EmpresaCfg cfg, Mon m
WITH(NOLOCK) WHERE cfg.Empresa = @Empresa AND m.Moneda = cfg.ContMoneda
INSERT @CorteFiscal (
ObligacionFiscal,   Importe,                               OtrosImpuestos,                               Tasa,   Excento,   Deducible,   OrigenModulo,   OrigenModuloID,   Contacto,   ContactoTipo,   AFArticulo,   AFSerie,   Acreedor,                                   Condicion)
SELECT d.ObligacionFiscal, SUM(d.Importe*e.TipoCambio*dbo.fnFactorFiscal(mt.FactorFiscalEsp,mt.FactorFiscal,mt.Factor)), SUM(d.OtrosImpuestos*e.TipoCambio*dbo.fnFactorFiscal(mt.FactorFiscalEsp,mt.FactorFiscal,mt.Factor)), d.Tasa, d.Excento, d.Deducible, d.OrigenModulo, d.OrigenModuloID, d.Contacto, d.ContactoTipo, d.AFArticulo, d.AFSerie, 'Acreedor' = NULLIF(RTRIM(o.Acreedor), ''), 'Condicion' = NULLIF(RTRIM(o.Condicion), '') 
FROM FiscalD d
 WITH(NOLOCK) JOIN Fiscal e  WITH(NOLOCK) ON e.ID = d.ID
JOIN MovTipo mt  WITH(NOLOCK) ON mt.Modulo = 'FIS' AND mt.Mov = e.Mov
LEFT OUTER JOIN ObligacionFiscal o  WITH(NOLOCK) ON o.ObligacionFiscal = d.ObligacionFiscal
WHERE e.Empresa = @Empresa AND e.Estatus = 'CONCLUIDO' AND e.FechaEmision BETWEEN @Desde AND @Hasta
GROUP BY d.ObligacionFiscal, d.Tasa, d.Excento, d.Deducible, d.OrigenModulo, d.OrigenModuloID, d.Contacto, d.ContactoTipo, d.AFArticulo, d.AFSerie, NULLIF(RTRIM(o.Acreedor), ''), NULLIF(RTRIM(o.Condicion), '')
HAVING ISNULL(ROUND(SUM(d.Neto*e.TipoCambio*dbo.fnFactorFiscal(mt.FactorFiscalEsp,mt.FactorFiscal,mt.Factor)), 4), 0.0) <> 0.0 
UPDATE @CorteFiscal
SET Importe = -Importe, OtrosImpuestos = -OtrosImpuestos
FROM @CorteFiscal c JOIN ObligacionFiscal p  WITH(NOLOCK) ON c.ObligacionFiscal = p.ObligacionFiscal
WHERE p.Tipo IN ('Retencion 1', 'Retencion 2', 'Retencion 2')
DECLARE crAcreedorFiscal CURSOR LOCAL FOR
SELECT Acreedor, Condicion, ObligacionFiscal
FROM @CorteFiscal
GROUP BY Acreedor, Condicion, ObligacionFiscal
OPEN crAcreedorFiscal
FETCH NEXT FROM crAcreedorFiscal  INTO @Acreedor, @Condicion, @ObligacionFiscal
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spCalcularVencimiento 'CXP', @Empresa, @Acreedor, @Condicion, @Hasta, @Vencimiento OUTPUT, NULL, @Ok OUTPUT
INSERT Fiscal (
Sucursal,  Empresa,  Usuario,  Mov,  Moneda,  TipoCambio,  FechaEmision, Concepto,          Acreedor,  Condicion,  Vencimiento,  Estatus,      OrigenTipo)
VALUES (@Sucursal, @Empresa, @Usuario, @Mov, @Moneda, @TipoCambio, @Hasta,       @ObligacionFiscal, @Acreedor, @Condicion, @Vencimiento, 'CONFIRMAR', 'FIS/CORTE')
SELECT @FiscalID = SCOPE_IDENTITY()
INSERT FiscalD (
ID,        ObligacionFiscal,  Importe,      OtrosImpuestos,      Tasa, Excento, Deducible,		       OrigenModulo, OrigenModuloID, Contacto, ContactoTipo, AFArticulo, AFSerie, Renglon)
SELECT @FiscalID, @ObligacionFiscal, SUM(Importe), SUM(OtrosImpuestos), Tasa, Excento, ISNULL(Deducible, 100.0), OrigenModulo, OrigenModuloID, Contacto, ContactoTipo, AFArticulo, AFSerie, ROW_NUMBER() OVER(ORDER BY ContactoTipo, Contacto, OrigenModulo, OrigenModuloID)
FROM @CorteFiscal
WHERE Acreedor = @Acreedor AND ObligacionFiscal = @ObligacionFiscal/*AND ISNULL(TotalMN, 0.0) < 0.0*/
GROUP BY Tasa, Excento, ISNULL(Deducible, 100.0), OrigenModulo, OrigenModuloID, Contacto, ContactoTipo, AFArticulo, AFSerie
ORDER BY Tasa, Excento, ISNULL(Deducible, 100.0), OrigenModulo, OrigenModuloID, Contacto, ContactoTipo, AFArticulo, AFSerie
IF @@ROWCOUNT = 0
DELETE Fiscal WHERE ID = @FiscalID
ELSE
SELECT @Conteo = @Conteo + 1
END
FETCH NEXT FROM crAcreedorFiscal  INTO @Acreedor, @Condicion, @ObligacionFiscal
END
CLOSE crAcreedorFiscal
DEALLOCATE crAcreedorFiscal
RETURN
END

