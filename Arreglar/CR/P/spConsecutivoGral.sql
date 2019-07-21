SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spConsecutivoGral]
 @ID INT
,@Modulo VARCHAR(20)
,@AplicaManual BIT
AS
BEGIN
	SET NOCOUNT ON
	DECLARE
		@Mov VARCHAR(20)
	   ,@Usuario VARCHAR(20)
	   ,@MovID VARCHAR(20)
	   ,@Sucursal INT
	   ,@Serie VARCHAR(10)
	   ,@ULTConsecutivo VARCHAR(20)
	   ,@ConsecutivoFiscal INT
	   ,@Empresa VARCHAR(10)
	   ,@Ok INT
	   ,@OkRef VARCHAR(255)
	   ,@NoPadres INT
	   ,@IDPadreMAVI INT
	   ,@MovPadre VARCHAR(20)
	   ,@DividirSeries BIT
	   ,@Condicion VARCHAR(20)
	   ,@Concepto VARCHAR(20)
	SELECT @MovID = MovID
	FROM Cxc
	WHERE ID = @ID

	IF @Modulo = 'CXC'
		AND @MovID IS NULL
	BEGIN
		SELECT @Usuario = Usuario
			  ,@Mov = Mov
			  ,@MovID = MovID
			  ,@Empresa = Empresa
			  ,@Sucursal = Sucursal
		FROM CXC
		WHERE ID = @ID

		IF @AplicaManual = 1
		BEGIN
			SELECT @NoPadres = COUNT(DISTINCT p.ID)
				  ,@IDPadreMAVI = p.ID
			FROM Cxc c
			JOIN CxcD d
				ON c.Mov = d.Aplica
				AND c.MovID = d.AplicaID
			JOIN CXC p
				ON c.PadreMAVI = p.Mov
				AND c.PadreIDMAVI = p.MovID
			WHERE d.ID = @ID
			GROUP BY p.ID
		END
		ELSE
		BEGIN
			SELECT @NoPadres = COUNT(DISTINCT p.ID)
				  ,@IDPadreMAVI = p.ID
			FROM CXC p
			JOIN NegociaMoratoriosMAVI n
				ON n.Origen = p.Mov
				AND n.OrigenID = p.MovID
			WHERE n.IDCobro = @ID
			GROUP BY p.ID
		END

		EXEC spSerieCFDFolio @Sucursal
							,@Empresa
							,@Modulo
							,@Mov
							,@Serie OUTPUT
							,@Ok OUTPUT
							,@OkRef OUTPUT
		SELECT @DividirSeries = DividirSeries
		FROM Consecutivo
		WHERE Tipo = @Mov

		IF @DividirSeries = 1
		BEGIN
			SELECT @MovPadre = Mov
				  ,@Condicion = Condicion
				  ,@Concepto = Concepto
			FROM CXC
			WHERE ID = @IDPadreMAVI
			SELECT @ConsecutivoFiscal = ConsecutivoFiscal
			FROM MovTipo
			WHERE Mov = @MovPadre
			AND Modulo = @Modulo
			SELECT @Condicion = CFD_metodoDePago
			FROM Condicion
			WHERE Condicion = @Condicion

			IF @Condicion = 'CONTADO'
				SELECT @ConsecutivoFiscal = 0

			IF @Concepto LIKE '%SALDO%'
				SELECT @ConsecutivoFiscal = 0

			EXEC spConsecutivoDividirSeries @Serie
										   ,@ConsecutivoFiscal
										   ,@Mov
										   ,@Sucursal
										   ,@UltConsecutivo OUTPUT

			IF @ConsecutivoFiscal = 0
				SELECT @Serie = @Serie + 'C'

		END
		ELSE
			EXEC spConsecutivo @Mov
							  ,@Sucursal
							  ,@UltConsecutivo OUTPUT

		IF @UltConsecutivo IS NULL
			EXEC spConsecutivoAuto @Sucursal
								  ,@Empresa
								  ,'CXC'
								  ,@Mov
								  ,NULL
								  ,NULL
								  ,NULL
								  ,@UltConsecutivo OUTPUT
								  ,@Ok OUTPUT
								  ,@OkRef OUTPUT
								  ,NULL

		SELECT @UltConsecutivo = @Serie + @UltConsecutivo
		UPDATE Cxc
		SET MovID = @UltConsecutivo
		WHERE ID = @ID
	END

	IF @Modulo = 'VTAS'
	BEGIN
		SELECT @Usuario = Usuario
			  ,@Mov = Mov
			  ,@MovID = MovID
			  ,@Empresa = Empresa
			  ,@Sucursal = Sucursal
		FROM Venta
		WHERE ID = @ID
		EXEC spSerieCFDFolio @Sucursal
							,@Empresa
							,'CXC'
							,@Mov
							,@Serie OUTPUT
							,@Ok OUTPUT
							,@OkRef OUTPUT
		SELECT @DividirSeries = DividirSeries
		FROM Consecutivo
		WHERE Tipo = @Mov

		IF @DividirSeries = 1
		BEGIN
			SELECT @ConsecutivoFiscal = ConsecutivoFiscal
			FROM MovTipo
			WHERE Mov = @Mov
			AND Modulo = @Modulo
			EXEC spConsecutivoDividirSeries @Serie
										   ,@ConsecutivoFiscal
										   ,@Mov
										   ,@Sucursal
										   ,@UltConsecutivo OUTPUT

			IF @ConsecutivoFiscal = 0
				SELECT @Serie = @Serie + 'C'

		END
		ELSE
			EXEC spConsecutivo @Mov
							  ,@Sucursal
							  ,@UltConsecutivo OUTPUT

		SELECT @UltConsecutivo = @Serie + @UltConsecutivo
		UPDATE Venta
		SET MovID = @UltConsecutivo
		WHERE ID = @ID
	END

	RETURN
END

