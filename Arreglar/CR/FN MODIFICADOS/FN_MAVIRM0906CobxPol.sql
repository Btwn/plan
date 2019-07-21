SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION [dbo].[FN_MAVIRM0906CobxPol] (
	@ID INT
	)
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE
		@COB VARCHAR(10)
	   ,@DV INT
	   ,@DI INT
	   ,@DVEC INT
	   ,@DINAC INT
	   ,@SECC VARCHAR(50)
	   ,@Cliente VARCHAR(10)
	   ,@Quincena INT
	   ,@Year INT = YEAR(GETDATE())
	SELECT @Cliente = C.Cliente
		  ,@SECC = ISNULL(CE.SeccionCobranzaMAVI, '')
		  ,@DVEC = ISNULL(CM.DiasVencActMAVI, 0)
		  ,@DINAC = ISNULL(CM.DiasInacActMAVI, 0)
	FROM CxcMavi CM WITH (NOLOCK)
	JOIN Cxc C WITH (NOLOCK)
		ON C.ID = CM.ID
	JOIN TablaStD T WITH (NOLOCK)
		ON T.TablaSt = 'MOVIMIENTOS COBRO X POLITICA'
		AND T.Nombre = C.Mov
	LEFT JOIN CteEnviarA CE WITH (NOLOCK)
		ON CE.ID = C.ClienteEnviarA
		AND CE.Cliente = C.Cliente
	WHERE CM.ID = @ID

	IF ISNULL(@Cliente, '') != ''
		AND ISNULL(@SECC, '') != 'INSTITUCIONES'
		AND (ISNULL(@DVEC, 0) > 0 OR ISNULL(@DINAC, 0) > 0)
	BEGIN
		SET @Quincena =
		CASE
			WHEN DAY(GETDATE()) > 16 THEN MONTH(GETDATE()) * 2
			ELSE (MONTH(GETDATE()) * 2) - 1
		END
		SET @Quincena =
		CASE
			WHEN DAY(GETDATE()) = 1 THEN @Quincena - 1
			ELSE @Quincena
		END
		SELECT @Year =
			   CASE
				   WHEN DAY(GETDATE()) = 1
					   AND MONTH(GETDATE()) = 1 THEN @Year - 1
				   ELSE @Year
			   END
			  ,@Quincena =
			   CASE
				   WHEN DAY(GETDATE()) = 1
					   AND MONTH(GETDATE()) = 1 THEN 24
				   ELSE @Quincena
			   END
		SELECT TOP 1 @DV = ISNULL(CON.DV, 0)
					,@DI = ISNULL(CON.DI, 0)
		FROM TcIRM0906_ConfigDivisionYParam CON WITH (NOLOCK)
		JOIN MaviRecuperacion MA WITH (NOLOCK)
			ON ISNULL(CON.Division, '') = ISNULL(MA.Division, '')
			AND MA.Quincena = @Quincena
			AND MA.Ejercicio = @Year
			AND MA.Cliente = @Cliente
		SELECT @DV = ISNULL(@DV, 0)
			  ,@DI = ISNULL(@DI, 0)
			  ,@DVEC = ISNULL(@DVEC, 0)
			  ,@DINAC = ISNULL(@DINAC, 0)
		SET @COB =
		CASE
			WHEN ((@DVEC >= @DV AND @DV <> 0) OR (@DINAC >= @DI AND @DI <> 0)) THEN 'SI'
			ELSE 'NO'
		END
	END

	SET @COB = ISNULL(@COB, 'NO')
	RETURN @COB
END

