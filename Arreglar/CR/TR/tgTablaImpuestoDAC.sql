SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgTablaImpuestoDAC ON TablaImpuestoD

FOR INSERT, UPDATE
AS BEGIN
IF dbo.fnEstaSincronizando() = 1 RETURN
IF UPDATE(LimiteInferior) OR UPDATE(LimiteSuperior) OR UPDATE(Cuota) OR UPDATE(Porcentaje)
INSERT TablaImpuestoHist (Fecha,     TablaImpuesto, PeriodoTipo, LimiteInferior, LimiteSuperior, Cuota, Porcentaje)
SELECT GETDATE(), TablaImpuesto, PeriodoTipo, LimiteInferior, LimiteSuperior, Cuota, Porcentaje
FROM Inserted
END

