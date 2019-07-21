SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPOSValidaPOSLVenta (
@ID varchar(36)
)
RETURNS bit

AS
BEGIN
DECLARE
@Resultado                    bit,
@MovClave                     varchar(20),
@ConsecutivoModulo            varchar(5)
SELECT   @MovClave = mt.Clave , @ConsecutivoModulo =  mt.ConsecutivoModulo
FROM MovTipo mt WITH(NOLOCK) JOIN POSL p WITH(NOLOCK) ON p.Mov = mt.Mov AND mt.Modulo = 'POS'
WHERE p.ID = @ID
SELECT @Resultado = 1
IF @ConsecutivoModulo IN('VTAS','CXC')
IF NOT EXISTS(SELECT * FROM POSLVenta WITH(NOLOCK) WHERE ID = @ID)
SELECT @Resultado = 0
IF @ConsecutivoModulo = 'DIN'
IF NOT EXISTS(SELECT * FROM POSLCobro WITH(NOLOCK) WHERE ID = @ID)
SELECT @Resultado = 0
RETURN (@Resultado)
END

