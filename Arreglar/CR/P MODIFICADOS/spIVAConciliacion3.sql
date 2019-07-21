SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIVAConciliacion3
@ID			AS INT,
@Auxiliar	AS INT,
@RID		AS INT,
@Tipo		AS VARCHAR(20)

AS
BEGIN
SELECT Dinero.IvaFiscal * Dinero.Importe * Dinero.TipoCambio
FROM Dinero WITH (NOLOCK)
JOIN Auxiliar  WITH (NOLOCK) ON Dinero.ID = Auxiliar.ModuloID
AND Auxiliar.ID = @Auxiliar
AND Auxiliar.Modulo = 'DIN'
AND Dinero.mov IN ('Cheque Devolucion','Transf Devolucion')
JOIN ConciliacionD  WITH (NOLOCK) ON ConciliacionD.ID = @ID AND RID = @RID
AND ConciliacionD.Seccion = 0
AND 1 = CASE WHEN @Tipo = 'Abono' AND ConciliacionD.Abono IS NOT NULL THEN 1
WHEN @Tipo = 'Cargo' AND ConciliacionD.Cargo IS NOT NULL THEN 1
ELSE 0 END
END

