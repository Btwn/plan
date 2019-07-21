SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCFDCxcImporte
(
@ID				int,
@Importe		float,
@Renglon		int
)
RETURNS float

AS BEGIN
DECLARE
@Empresa			varchar(5),
@CfgCobroImpuestos	int,
@MovTipo			varchar(20),
@AplicaID			varchar(20),
@Aplica				varchar(20),
@IDAplica			varchar(20),
@Importe2			float,
@Impuestos			float,
@Retenciones		float,
@Porcentaje			float,
@TipoCambio         float,
@SAT_MN                  bit
SELECT @Empresa = c.Empresa,
@MovTipo = m.Clave,
@TipoCambio = c.TipoCambio,
@SAT_MN = m.SAT_MN
FROM Cxc c
JOIN MovTipo m
ON c.Mov = m.Mov AND m.Modulo = 'CXC'
WHERE c.ID = @ID
SELECT @CfgCobroImpuestos = ISNULL(CxcCobroImpuestos, 0) FROM EmpresaCfg2 WHERE Empresa = @Empresa
IF (@MovTipo IN ('CXC.C', 'CXC.CD', 'CXC.D', 'CXC.DM') AND @CfgCobroImpuestos = 0) OR @MovTipo NOT IN('CXC.F','CXC.FA','CXC.DFA','CXC.AF','CXC.CA','CXC.IM','CXC.RM','CXC.A','CXC.AR','CXC.AA','CXC.DE','CXC.CAP','CXC.RA')
BEGIN
IF @Renglon <> 0
BEGIN
SELECT @Aplica = Aplica,
@AplicaID = AplicaID
FROM CxcD
WHERE ID = @ID
AND Renglon = @Renglon
SELECT @IDAplica = ID
FROM Cxc
WHERE Mov = @Aplica
AND MovID = @AplicaID
SELECT @Importe2 = ISNULL(Importe,0.0),
@Impuestos = ISNULL(Impuestos,0.0),
@Retenciones = ISNULL(Retencion,0.0)
FROM Cxc
WHERE ID = @IDAplica
SELECT @Porcentaje = @Importe/(@Importe2 + @Impuestos - @Retenciones)
SELECT @Importe = @Importe - (@Porcentaje * @Impuestos) + (@Porcentaje * @Retenciones)
END
ELSE
BEGIN
SELECT @Impuestos = ISNULL(SUM(ISNULL(Importe,0.0)),0.0)/CASE WHEN @SAT_MN = 1 THEN @TipoCambio ELSE 1 END FROM CFDCXCMovImpuesto WHERE ID = @ID
SELECT @Retenciones = ISNULL(SUM(ISNULL(Importe,0.0)),0.0)/CASE WHEN @SAT_MN = 1 THEN @TipoCambio ELSE 1 END FROM CFDCXCMovRetencion WHERE ID = @ID
SELECT @Importe = @Importe - @Impuestos + @Retenciones
END
END
ELSE
BEGIN
SELECT @Impuestos = (ISNULL(Impuestos,0.0)),
@Retenciones = ISNULL(Retencion,0.0)
FROM Cxc WHERE ID = @ID
SELECT @Importe = @Importe - @Impuestos + @Retenciones
END
RETURN (@Importe)
END

