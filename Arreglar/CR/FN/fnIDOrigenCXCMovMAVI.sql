SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION [dbo].[fnIDOrigenCXCMovMAVI] (
	@ID INT
	)
RETURNS INT
AS
BEGIN
	DECLARE
		@Mov VARCHAR(20)
	   ,@Movid VARCHAR(20)
	   ,@Origen VARCHAR(20)
	   ,@OrigenId VARCHAR(20)
	   ,@Concepto VARCHAR(50)
	   ,@MovAux VARCHAR(30)
	   ,@movidAux VARCHAR(20)
	   ,@Ciclo BIT = 0
	   ,@Encontrado BIT = 0
	   ,@clave VARCHAR(20)
	SELECT @Mov = Mov
		  ,@Movid = MovID
		  ,@Origen = Origen
		  ,@OrigenId = OrigenID
		  ,@concepto = Concepto
	FROM cxc
	WHERE id = @ID

	IF LEFT(@Mov, 10) = 'NOTA CARGO'
		AND @Origen IS NULL
		AND LEFT(@Concepto, 10) = 'CANC COBRO'
	BEGIN
		SET @MovAux = (
			SELECT Valor
			FROM MovCampoExtra
			WHERE mov = @Mov
			AND id = @ID
			AND CampoExtra IN ('NC_FACTURA', 'NCV_FACTURA', 'NCM_FACTURA')
		)
		SELECT @mov = LEFT(@movaux, CHARINDEX('_', @movaux) - 1)
			  ,@Movid = RIGHT(@MovAux, LEN(@movaux) - CHARINDEX('_', @MovAux))
	END
	ELSE

	IF @Origen IS NOT NULL
	BEGIN

		IF @Origen <> @Mov
		BEGIN
			SELECT @clave = clave
			FROM movtipo
			WHERE Mov = @Mov
			AND Modulo = 'CXC'
			SET @Ciclo = 1
		END

	END

	IF @Ciclo = 1
		AND @clave = 'CXC.D'
	BEGIN
		WHILE @Encontrado = 0
		BEGIN
		SELECT @Mov = @Origen
			  ,@Movid = @OrigenId
		SELECT @Origen = Origen
			  ,@OrigenId = OrigenID
		FROM cxc
		WHERE mov = @Mov
		AND MovID = @Movid

		IF LEFT(@mov, 10) = 'NOTA CARGO'
			AND LEFT(@Concepto, 10) = 'CANC COBRO'
		BEGIN
			SET @ID = (
				SELECT ID
				FROM cxc
				WHERE mov = @Mov
				AND MovID = @Movid
			)
			SET @MovAux = (
				SELECT Valor
				FROM MovCampoExtra
				WHERE mov = @Mov
				AND id = @ID
				AND CampoExtra IN ('NC_FACTURA', 'NCV_FACTURA', 'NCM_FACTURA')
			)
			SELECT @mov = LEFT(@movaux, CHARINDEX('_', @movaux) - 1)
				  ,@Movid = RIGHT(@MovAux, LEN(@movaux) - CHARINDEX('_', @MovAux))
			SET @Encontrado = 1
		END
		ELSE

		IF @Origen IS NULL
			SET @Encontrado = 1
		ELSE

		IF @Mov = @Origen
			AND @Movid = @OrigenId
			OR @Mov IN ('Refinanciamiento', 'Endoso')
			SET @Encontrado = 1

		END
	END

	SELECT @ID = ID
	FROM cxc
	WHERE mov = @Mov
	AND MovID = @Movid
	RETURN @id
END

