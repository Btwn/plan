SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fneCommerceOrigen(@Modulo  varchar(5), @ID  int, @Nivel  int)
RETURNS bit

AS BEGIN
DECLARE
@Resultado   bit,
@OModulo     varchar(5),
@OID         int ,
@Tipo        varchar(20)
SET @Resultado = 0
SELECT @OModulo = mf.OModulo, @OID = mf.OID
FROM MovFLujo mf WITH(NOLOCK)
WHERE DModulo = @Modulo AND DID = @ID
IF @Modulo = 'VTAS'
IF EXISTS(SELECT * FROM Venta WITH(NOLOCK) WHERE ID = @OID AND OrigenTipo = 'eCommerce')
SELECT @Resultado = 1
IF ISNULL(@Resultado,0) = 0 AND @Nivel < 15
BEGIN
SET @Nivel = @Nivel + 1
SELECT @Resultado = dbo.fneCommerceOrigen(@OModulo, @OID,@Nivel)
END
IF @Modulo = 'VTAS'
IF EXISTS(SELECT * FROM Venta WITH(NOLOCK) WHERE ID = @ID AND OrigenTipo = 'eCommerce')
SELECT @Resultado = 1
RETURN (@Resultado)
END

