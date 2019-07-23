SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spDineroRelacionar]
 @Empresa CHAR(5)
,@Accion CHAR(20)
,@Modulo CHAR(5)
,@ID INT
,@Mov CHAR(20)
,@MovID VARCHAR(20)
,@CtaDinero CHAR(10)
AS
BEGIN
	DECLARE
		@OModulo CHAR(5)
	   ,@OID INT
	DECLARE
		crMovFlujo
		CURSOR LOCAL STATIC FOR
		SELECT OModulo
			  ,OID
		FROM MovFlujo WITH(NOLOCK)
		WHERE DID = @ID
		AND DModulo = @Modulo
		AND Empresa = @Empresa
	OPEN crMovFlujo
	FETCH NEXT FROM crMovFlujo INTO @OModulo, @OID
	WHILE @@FETCH_STATUS <> -1
	BEGIN

	IF @@FETCH_STATUS <> -2
	BEGIN

		IF @OModulo = @Modulo
			SELECT @OModulo = OModulo
				  ,@OID = OID
			FROM MovFlujo WITH(NOLOCK)
			WHERE Cancelado = 0
			AND DID = @OID
			AND DModulo = @OModulo
			AND Empresa = @Empresa

		IF @OModulo = @Modulo
			SELECT @OModulo = OModulo
				  ,@OID = OID
			FROM MovFlujo WITH(NOLOCK)
			WHERE Cancelado = 0
			AND DID = @OID
			AND DModulo = @OModulo
			AND Empresa = @Empresa

		IF @OModulo = @Modulo
			SELECT @OModulo = OModulo
				  ,@OID = OID
			FROM MovFlujo WITH(NOLOCK)
			WHERE Cancelado = 0
			AND DID = @OID
			AND DModulo = @OModulo
			AND Empresa = @Empresa

		IF @OModulo = @Modulo
			SELECT @OModulo = OModulo
				  ,@OID = OID
			FROM MovFlujo WITH(NOLOCK)
			WHERE Cancelado = 0
			AND DID = @OID
			AND DModulo = @OModulo
			AND Empresa = @Empresa

		IF @OModulo = @Modulo
			SELECT @OModulo = OModulo
				  ,@OID = OID
			FROM MovFlujo WITH(NOLOCK)
			WHERE Cancelado = 0
			AND DID = @OID
			AND DModulo = @OModulo
			AND Empresa = @Empresa

		IF @OModulo IS NOT NULL
			AND @OID IS NOT NULL
		BEGIN

			IF @Accion = 'CANCELAR'
				SELECT @Mov = NULL
					  ,@MovID = NULL
					  ,@CtaDinero = NULL

			IF @OModulo = 'CXC'
				UPDATE Cxc WITH(ROWLOCK)
				SET GenerarDinero = 0
				   ,Dinero = @Mov
				   ,DineroID = @MovID
				   ,DineroCtaDinero = @CtaDinero
				WHERE ID = @OID
				AND (@Accion = 'CANCELAR'
				OR DineroID IS NULL)
			ELSE

			IF @OModulo = 'CXP'
				UPDATE Cxp WITH(ROWLOCK)
				SET GenerarDinero = 0
				   ,Dinero = @Mov
				   ,DineroID = @MovID
				   ,DineroCtaDinero = @CtaDinero
				WHERE ID = @OID
				AND (@Accion = 'CANCELAR'
				OR DineroID IS NULL)
			ELSE

			IF @OModulo = 'GAS'
				UPDATE Gasto WITH(ROWLOCK)
				SET GenerarDinero = 0
				   ,Dinero = @Mov
				   ,DineroID = @MovID
				   ,DineroCtaDinero = @CtaDinero
				WHERE ID = @OID
				AND (@Accion = 'CANCELAR'
				OR DineroID IS NULL)
			ELSE

			IF @OModulo = 'VTAS'
				UPDATE Venta WITH(ROWLOCK)
				SET GenerarDinero = 0
				   ,Dinero = @Mov
				   ,DineroID = @MovID
				   ,DineroCtaDinero = @CtaDinero
				WHERE ID = @OID
				AND (@Accion = 'CANCELAR'
				OR DineroID IS NULL)

		END

	END

	FETCH NEXT FROM crMovFlujo INTO @OModulo, @OID
	END
	CLOSE crMovFlujo
	DEALLOCATE crMovFlujo
	RETURN
END
GO