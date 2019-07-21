SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSSVerConcentradoFormaPago
@Empresa		varchar(5)

AS
BEGIN
SELECT
p.CtaDinero,
pc.FormaPago,
Importe = SUM(pc.Importe),
ComisionPorcentaje = MAX(fpd.Descuento),
Comision = SUM(pc.Importe) - (SUM(pc.Importe) * (MAX(fpd.Descuento)/100)),
IVA = SUM(pc.Importe) - (SUM(pc.Importe) * (MAX(fpd.Descuento)/100)) * (MAX(eg.DefImpuesto) / 100)
FROM POSL p
INNER JOIN POSLCobro pc ON p.ID = pc.ID
LEFT OUTER JOIN FormaPagoDesc fpd ON fpd.FormaPago = pc.FormaPago
LEFT OUTER JOIN EmpresaGral eg ON eg.Empresa = @Empresa
WHERE p.Empresa = @Empresa
GROUP BY p.CtaDinero, pc.FormaPago
ORDER BY p.CtaDinero, pc.FormaPago
END

