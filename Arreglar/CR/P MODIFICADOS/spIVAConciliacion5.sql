SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIVAConciliacion5
@ID			AS INT,
@Auxiliar	AS INT,
@RID		AS INT,
@Tipo		AS VARCHAR(20)

AS
BEGIN
SELECT (Round(((Dinero.IEPSFiscal * Dinero.Importe)/((Dinero.Importe-((Dinero.IEPSFiscal * Dinero.Importe)+(Dinero.IVAFiscal * Dinero.Importe)))*Dinero.TipoCambio))*100,0))
FROM Dinero WITH (NOLOCK)
JOIN Auxiliar WITH (NOLOCK) ON Dinero.ID = Auxiliar.ModuloID
AND Auxiliar.ID = @Auxiliar
AND Auxiliar.Modulo = 'DIN'
AND Dinero.mov IN ('Deposito','Deposito Corte Caja','Deposito Electronico','Cheque','Cheque Anticipo','Cheque Electronico','Transf Anticipo','Cheque Devolucion','Transf Devolucion')
JOIN ConciliacionD WITH (NOLOCK) on ConciliacionD.ID = @ID and RID = @RID
AND ConciliacionD.Seccion = 0
AND 1 = CASE WHEN @Tipo = 'Abono' AND ConciliacionD.Abono IS NOT NULL THEN 1
WHEN @Tipo = 'Cargo' AND ConciliacionD.Cargo IS NOT NULL THEN 1
ELSE 0 END
END
PRINT "******************* SP Conciliacion ******************"

