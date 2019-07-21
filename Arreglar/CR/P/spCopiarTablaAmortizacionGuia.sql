SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCopiarTablaAmortizacionGuia
@OModulo		char(5),
@OID         	int,
@DModulo		char(5),
@DID			int

AS BEGIN
DELETE TablaAmortizacionGuia WHERE Modulo = @DModulo AND ID = @DID
INSERT TablaAmortizacionGuia
(Modulo,   ID,   Vencimiento, Capital)
SELECT @DModulo, @DID, Vencimiento, Capital
FROM TablaAmortizacionGuia
WHERE Modulo = @OModulo AND ID = @OID
DELETE TablaAmortizacionMigracion WHERE Modulo = @DModulo AND ID = @DID
INSERT TablaAmortizacionMigracion
(Modulo,   ID,   Amortizacion, FechaD, FechaA, SaldoInicial, Capital, Intereses, InteresesOrdinarios, InteresesMoratorios, TasaDiaria, Pendiente, FechaCobro, IVAInteres,           InteresesOrdinariosIVA) 
SELECT @DModulo, @DID, Amortizacion, FechaD, FechaA, SaldoInicial, Capital, Intereses, InteresesOrdinarios, InteresesMoratorios, TasaDiaria, Pendiente, FechaCobro, IVAInteresPorcentaje, InteresesMoratoriosIVA  
FROM TablaAmortizacionMigracion
WHERE Modulo = @OModulo AND ID = @OID
END

