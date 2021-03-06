SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCFDVentafgtTipoActivo
(
@Modulo			varchar(5),
@Mov			varchar(20)
)
RETURNS varchar(255)

AS BEGIN
DECLARE
@Resultado	varchar(10)
SELECT @Resultado = CFD_tipoDeComprobante FROM MovTipo WITH (NOLOCK) WHERE Modulo = @Modulo AND Mov = @Mov
RETURN (@Resultado)
END

