SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnDIOTTipoDocumento(
@Modulo							varchar(5),
@Mov							varchar(20)
)
RETURNS varchar(20)
AS
BEGIN
DECLARE @Clave		varchar(20),
@Valor		varchar(20)
SELECT @Clave = Clave FROM MovTipo WITH(NOLOCK) WHERE Modulo = @Modulo AND Mov = @Mov
SELECT @Valor = CASE
WHEN @Clave IN ('COMS.F','COMS.FL','COMS.EG', 'COMS.EI','COMS.CA','COMS.GX') THEN 'Factura'
WHEN @Clave IN ('COMS.B') THEN 'Nota Credito'
WHEN @Clave IN ('COMS.D') THEN 'Devolucion'
WHEN @Clave IN ('GAS.A','GAS.ASC','GAS.G','GAS.GTC','GAS.GP','GAS.C','GAS.CCH','GAS.CP','GAS.CB') THEN 'Factura'
WHEN @Clave IN ('GAS.DA','GAS.DG','GAS.DC','GAS.DGP','GAS.OI','GAS.AB') THEN 'Nota Credito'
WHEN @Clave IN ('CXP.AF','CXP.A') THEN 'Anticipo'
WHEN @Clave IN ('CXP.CA','CXP.F','CXP.CD','CXP.D') THEN 'Factura'
WHEN @Clave IN ('CXP.NC') THEN 'Devolucion'
WHEN @Clave IN ('CXP.CA') THEN 'Nota Credito'
ELSE 'Factura'
END
RETURN @Valor
END

