SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnDIOTEsImportacion(
@Modulo							varchar(5),
@Mov							varchar(20)
)
RETURNS bit
AS
BEGIN
DECLARE @Clave		varchar(20),
@Valor		bit
SELECT @Clave = Clave FROM MovTipo WITH(NOLOCK) WHERE Modulo = @Modulo AND Mov = @Mov
SELECT @Valor = CASE
WHEN @Clave IN ('COMS.EI','COMS.GX') THEN 1
ELSE 0
END
RETURN @Valor
END

