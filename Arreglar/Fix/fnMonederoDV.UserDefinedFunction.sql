SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION [dbo].[fnMonederoDV] (
	@Codigo VARCHAR(11)
   ,@EsNuevo BIT
	)
RETURNS BIT
AS
BEGIN

	IF @EsNuevo = 0
		AND EXISTS (SELECT Serie FROM TarjetaMonederoMAVI WITH(NOLOCK) WHERE Serie = SUBSTRING(@Codigo, 1, 8) AND Estatus = 'ACTIVA')
		SET @EsNuevo = 1

	IF (LEN(@Codigo) = 11 AND ISNUMERIC(@Codigo) = 1)
		AND @EsNuevo = 1
	BEGIN
		DECLARE
			@Exp1 VARCHAR(8)
		   ,@Exp2 VARCHAR(8)
		   ,@Exp3 VARCHAR(8)
		   ,@Ini INT
		   ,@Fin INT
		   ,@Resultado INT
		   ,@CodigoImpreso VARCHAR(8)
		   ,@IDCodigo VARCHAR(3)
		   ,@IDCodigoRes VARCHAR(3)
		DECLARE
			@CodigoTbl AS TABLE (
				Codigo INT NULL
			   ,Exp1 INT NULL
			   ,Exp2 INT NULL
			   ,Exp3 INT NULL
			   ,ResExp1 INT NULL
			   ,ResExp2 INT NULL
			   ,ResExp3 INT NULL
			)
		SELECT @Exp1 = '12345678'
			  ,@Exp2 = '87654321'
			  ,@Exp3 = '24681357'
			  ,@CodigoImpreso = SUBSTRING(@Codigo, 1, 8)
			  ,@IDCodigo = RIGHT(@Codigo, 3)
			  ,@Ini = 1
			  ,@Fin = 8
		WHILE @Ini <= @Fin
		BEGIN
		INSERT INTO @CodigoTbl (Codigo, Exp1, Exp2, Exp3)
			SELECT Codigo = SUBSTRING(@CodigoImpreso, @Ini, 1)
				  ,Exp1 = SUBSTRING(@Exp1, @Ini, 1)
				  ,Exp2 = SUBSTRING(@Exp2, @Ini, 1)
				  ,Exp3 = SUBSTRING(@Exp3, @Ini, 1)
		SET @Ini = @Ini + 1
		END
		UPDATE @CodigoTbl
		SET ResExp1 = POWER(Codigo, Exp1)
		   ,ResExp2 = POWER(Codigo, Exp2)
		   ,ResExp3 = POWER(Codigo, Exp3)
		SELECT @IDCodigoRes = CONVERT(VARCHAR(5), (SUM(ResExp1) % 10)) +
		 CONVERT(VARCHAR(5), (SUM(ResExp2) % 10)) +
		 CONVERT(VARCHAR(5), (SUM(ResExp3) % 10))
		FROM @CodigoTbl

		IF @IDCodigo = @IDCodigoRes
			SET @Resultado = 1
		ELSE
			SET @Resultado = 0

	END
	ELSE
		SET @Resultado = 0

	RETURN @Resultado
END
GO