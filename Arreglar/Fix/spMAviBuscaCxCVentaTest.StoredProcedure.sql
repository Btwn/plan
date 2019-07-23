SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spMAviBuscaCxCVentaTest]
 @MovIdCxc VARCHAR(20)
,@MovCxc VARCHAR(20)
,@IdMovResul VARCHAR(20) OUTPUT
,@MovResul VARCHAR(20) OUTPUT
,@IdOrigen INT OUTPUT
AS
BEGIN
	DECLARE
		@Tipo VARCHAR(20)
	   ,@IdNvo VARCHAR(20)
	   ,@IdMovNvo VARCHAR(20)
	   ,@IdMovNvo2 VARCHAR(20)
	   ,@MovtipoNvo VARCHAR(20)
	   ,@IdOrigenNvo INT
	   ,@IdCXC INT
	   ,@Aplica VARCHAR(20)
	   ,@AplicaID VARCHAR(20)
	   ,@IDdetalle VARCHAR(20)
	   ,@Contador INT
	   ,@ContadorD INT
	   ,@Concepto VARCHAR(50)
	   ,@CveAfecta VARCHAR(20)
	SELECT @Tipo = 'CxC'
		  ,@IdNvo = @MovIdCxc
		  ,@IdMovNvo = @MovCxc
		  ,@Contador = 0
		  ,@ContadorD = 0
		  ,@MovtipoNvo = ''
	SELECT @IdCXC = Id
		  ,@Concepto = Concepto
	FROM CXC WITH(NOLOCK)
	WHERE Mov = @MovCxc
	AND mOViD = @MovIdCxc
	SELECT @CveAfecta = Clave
	FROM MovTipo WITH(NOLOCK)
	WHERE Modulo = 'CXC'
	AND Mov = @MovCxc

	IF @CveAfecta = 'CXC.CA'
		AND @Concepto = 'Monedero Electronico'
		SELECT @IdMovResul = @MovIdCxc
			  ,@MovResul = @MovCxc
			  ,@IdOrigen = @IdCXC
	ELSE
	BEGIN
		WHILE @MovtipoNvo NOT IN ('VTAS.F', 'CXC.EST')
		AND @Contador < 10
		BEGIN
		SELECT @Tipo = OModulo
			  ,@IdMovNvo = OMov
			  ,@IdNvo = (OMovId)
			  ,@IdOrigenNvo = ISNULL(mf.OID, 0)
			  ,@MovtipoNvo = Mt.Clave
		FROM MovFlujo mf WITH(NOLOCK)
			,Movtipo Mt WITH(NOLOCK)
		WHERE mf.OMov = Mt.Mov
		AND mf.DMov = @IdMovNvo
		AND mf.DMovID = @IdNvo
		AND DModulo = 'CXC'
		ORDER BY OMovId DESC

		IF @MovtipoNvo = 'CXC.EST'
		BEGIN
			SELECT @IdOrigenNvo = OID
				  ,@IdNvo = OMovID
				  ,@IdMovNvo = OMov
			FROM MovFlujo mf WITH(NOLOCK)
				,Movtipo Mt WITH(NOLOCK)
			WHERE mf.OMov = Mt.Mov
			AND mf.DMov = @MovCxC
			AND mf.DMovID = @MovIDCxC
			AND DModulo = 'CXC'
			ORDER BY OMovId DESC
		END

		SELECT @Contador = @Contador + 1
		END

		IF @Contador > 10
			SELECT @IdNvo = NULL
				  ,@IdMovNvo = NULL
				  ,@IdOrigenNvo = 0

		SELECT @Aplica = Aplica
			  ,@AplicaID = AplicaID
		FROM CxcD WITH(NOLOCK)
		WHERE Id = @IdOrigen

		IF NOT @AplicaID IS NULL
		BEGIN
			DECLARE
				crCxCCte
				CURSOR FOR
				SELECT Id
				FROM CXc WITH(NOLOCK)
				WHERE Mov = @Aplica
				AND MovId = @AplicaID
			OPEN crCxCCte
			FETCH NEXT FROM crCxCCte INTO @IdMovNvo2
			WHILE @MovtipoNvo <> 'VTAS.F'
			AND @ContadorD < 10
			BEGIN
			SELECT @Tipo = OModulo
				  ,@IdMovNvo = OMov
				  ,@IdNvo = (OMovId)
				  ,@IdOrigenNvo = mf.OID
				  ,@MovtipoNvo = Mt.Clave
			FROM MovFlujo mf WITH(NOLOCK)
				,Movtipo Mt WITH(NOLOCK)
			WHERE mf.OMov = Mt.Mov
			AND mf.DMov = @IdMovNvo2
			AND mf.DMovID = @IdNvo
			AND DModulo = 'CXC'
			ORDER BY OMovId DESC
			SELECT @ContadorD = @ContadorD + 1
			FETCH NEXT FROM crCxCCte INTO @IdMovNvo2
			END
			CLOSE crCxCCte
			DEALLOCATE crCxCCte
		END

		SELECT @IdMovResul = @IdNvo
			  ,@MovResul = @IdMovNvo
			  ,@IdOrigen = @IdOrigenNvo
		RETURN
	END

END
GO