SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[spCancelarFlujo]
 @Empresa CHAR(5)
,@Modulo CHAR(5)
,@ID INT
,@Ok INT OUTPUT
,@CancelarHijos BIT = 0
,@Usuario VARCHAR(10) = NULL
AS
BEGIN
	DECLARE
		@DModulo CHAR(5)
	   ,@DID INT

	IF @CancelarHijos = 1
	BEGIN
		DECLARE
			crMovFlujo
			CURSOR LOCAL STATIC FOR
			SELECT DModulo
				  ,DID
			FROM MovFlujo
			WHERE Empresa = @Empresa
			AND OModulo = @Modulo
			AND OID = @ID
			AND Cancelado = 0
			AND DModulo <> 'CONTP'
		OPEN crMovFlujo
		FETCH NEXT FROM crMovFlujo INTO @DModulo, @DID
		WHILE @@FETCH_STATUS <> -1
		AND @Ok IS NULL
		BEGIN

		IF @@FETCH_STATUS <> -2
			EXEC spAfectar @DModulo
						  ,@DID
						  ,'CANCELAR'
						  ,@EnSilencio = 1
						  ,@Conexion = 1
						  ,@Usuario = @Usuario
						  ,@Ok = @Ok OUTPUT

		FETCH NEXT FROM crMovFlujo INTO @DModulo, @DID
		END
		CLOSE crMovFlujo
		DEALLOCATE crMovFlujo
	END

	UPDATE MovFlujo
	SET Cancelado = 1
	WHERE Empresa = @Empresa
	AND OModulo = @Modulo
	AND OID = @ID
	AND Cancelado = 0

	IF @@ERROR <> 0
		SELECT @Ok = 1

	UPDATE MovFlujo
	SET Cancelado = 1
	WHERE Empresa = @Empresa
	AND DModulo = @Modulo
	AND DID = @ID
	AND Cancelado = 0

	IF @@ERROR <> 0
		SELECT @Ok = 1

	RETURN
END
GO