SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spSugerirCobroxFact]
 @SugerirPago VARCHAR(20)
,@Modulo CHAR(5)
,@ID INT
,@ImporteTotal MONEY
,@Usuario VARCHAR(10)
,@Estacion INT
,@OrigenModulo VARCHAR(10) = NULL
AS
BEGIN
	DECLARE
		@Empresa CHAR(5)
	   ,@Sucursal INT
	   ,@Hoy DATETIME
	   ,@Vencimiento DATETIME
	   ,@DiasCredito INT
	   ,@DiasVencido INT
	   ,@TasaDiaria FLOAT
	   ,@Moneda CHAR(10)
	   ,@TipoCambio FLOAT
	   ,@Contacto CHAR(10)
	   ,@Renglon FLOAT
	   ,@Aplica VARCHAR(20)
	   ,@AplicaID VARCHAR(20)
	   ,@AplicaMovTipo VARCHAR(20)
	   ,@Capital MONEY
	   ,@Intereses MONEY
	   ,@InteresesOrdinarios MONEY
	   ,@InteresesFijos MONEY
	   ,@InteresesMoratorios MONEY
	   ,@ImpuestoAdicional FLOAT
	   ,@Importe MONEY
	   ,@SumaImporte MONEY
	   ,@Impuestos MONEY
	   ,@DesglosarImpuestos BIT
	   ,@LineaCredito VARCHAR(20)
	   ,@Metodo INT
	   ,@GeneraMoratorioMAVI CHAR(1)
	   ,@MontoMinimoMor FLOAT
	   ,@CondonaMoratorios INT
	   ,@IDDetalle INT
	   ,@ImpReal MONEY
	   ,@ClaveID INT
	   ,@Mov VARCHAR(20)
	   ,@MovID VARCHAR(20)
	   ,@Valor VARCHAR(50)
	   ,@MovNC VARCHAR(20)
	   ,@MovIDNC VARCHAR(20)
	   ,@IdNc INT
	   ,@MoratorioAPagar MONEY
	   ,@Concepto VARCHAR(50)
	   ,@Origen VARCHAR(20)
	   ,@OrigenID VARCHAR(20)
	   ,@NotaCredxCanc CHAR(1)
	   ,@AplicaNota VARCHAR(20)
	   ,@AplicaIDNota VARCHAR(20)
	   ,@min INT
	   ,@max INT
	   ,@IDPOS VARCHAR(50)
	   ,@MovClave VARCHAR(20)
	DELETE NegociaMoratoriosMAVI
	WHERE IDCobro = @ID
	DELETE FROM HistCobroMoratoriosMAVI
	WHERE IDCobro = @ID

	IF EXISTS (SELECT * FROM TipoCobroMAVI WHERE IDCobro = @ID)
		UPDATE TipoCobroMAVI
		SET TipoCobro = 0
		WHERE IDCobro = @ID
	ELSE
		INSERT INTO TipoCobroMAVI (IDCobro, TipoCobro)
			VALUES (@ID, 0)

	SELECT @DesglosarImpuestos = 0
		  ,@Renglon = 0.0
		  ,@SumaImporte = 0.0
		  ,@ImporteTotal = NULLIF(@ImporteTotal, 0.0)
		  ,@SugerirPago = UPPER(@SugerirPago)
		  ,@MoratorioAPagar = 0
	SELECT @Empresa = Empresa
		  ,@Sucursal = Sucursal
		  ,@Hoy = FechaEmision
		  ,@Moneda = Moneda
		  ,@TipoCambio = TipoCambio
		  ,@Contacto = Cliente
	FROM Cxc
	WHERE ID = @ID
	DELETE CxcD
	WHERE ID = @ID
	SELECT @MontoMinimoMor = ISNULL(MontoMinMoratorioMAVI, 0)
	FROM EmpresaCfg2
	WHERE Empresa = @Empresa
	CREATE TABLE #NotaXCanc (
		Mov VARCHAR(20) NULL
	   ,MovID VARCHAR(20) NULL
	)
	INSERT INTO #NotaXCanc (Mov, MovID)
		SELECT DISTINCT d.mov
					   ,d.movid
		FROM negociamoratoriosmavi c
			,cxcpendiente d
			,cxc n
		WHERE c.mov IN ('Nota Cargo')
		AND d.cliente = @Contacto
		AND d.mov = c.mov
		AND d.movid = c.movid
		AND d.padremavi IN ('Credilana')
		AND n.mov = c.mov
		AND n.movid = c.movid
		AND n.concepto IN ('CANC COBRO CRED Y PP')
	CREATE TABLE #MovsPendientes (
		ID INT IDENTITY (1, 1) NOT NULL
	   ,Aplica VARCHAR(20) NULL
	   ,AplicaID VARCHAR(20) NULL
	   ,Vencimiento DATETIME NULL
	   ,Clave VARCHAR(20) NULL
	   ,Saldo MONEY NULL
	   ,Origen VARCHAR(20) NULL
	   ,OrigenId VARCHAR(20) NULL
	   ,NotaCredxCanc CHAR(1) NULL
	)
	DECLARE
		@crLista AS TABLE (
			ID INT IDENTITY (1, 1)
		   ,Clave VARCHAR(255)
		)
	INSERT INTO @crLista (Clave)
		SELECT Clave
		FROM ListaSt
		WHERE Estacion = @Estacion
	SELECT @min = MIN(ID)
		  ,@max = MAX(ID)
	FROM @crLista
	WHILE @min <= @max
	AND @ImporteTotal >= @SumaImporte
	BEGIN
	SELECT @ClaveID = Clave
	FROM @crLista
	WHERE ID = @min

	IF @ImporteTotal >= @SumaImporte
	BEGIN
		SELECT @Mov = Mov
			  ,@MovId = MovId
		FROM CXC
		WHERE ID = @ClaveID
		SELECT @Valor = RTRIM(@Mov) + '_' + RTRIM(@MovId)
		INSERT INTO #MovsPendientes (Aplica, AplicaId, Vencimiento, Clave, Saldo, Origen, OrigenID)
			SELECT c.Mov
				  ,c.MovID
				  ,c.Vencimiento
				  ,mt.Clave
				  ,ISNULL(c.Saldo * mt.Factor * c.TipoCambio / @TipoCambio, 0.0)
				  ,c.PadreMAVI
				  ,c.PadreIDMAVI
			FROM Cxc C
			JOIN MovTipo mt
				ON mt.Modulo = @Modulo
				AND mt.Mov = c.Mov
			WHERE c.Empresa = @Empresa
			AND c.Cliente = @Contacto
			AND c.estatus = 'PENDIENTE'
			AND mt.Clave NOT IN ('CXC.SCH', 'CXC.SD', 'CXC.NC')
			AND PadreMAVI = @Mov
			AND PadreIDMAVI = @MovID
	END

	SET @min = @min + 1
	END
	DECLARE
		@crAplica AS TABLE (
			ID INT IDENTITY (1, 1)
		   ,Aplica VARCHAR(25)
		   ,AplicaId VARCHAR(25)
		   ,Vencimiento DATETIME
		   ,Clave VARCHAR(10)
		   ,Saldo MONEY
		   ,origen VARCHAR(25)
		   ,Origenid VARCHAR(25)
		   ,NotaCredxCanc CHAR(1)
		)
	INSERT INTO @crAplica (Aplica, AplicaId, Vencimiento, Clave, Saldo, origen, Origenid, NotaCredxCanc)
		SELECT Aplica
			  ,AplicaId
			  ,Vencimiento
			  ,Clave
			  ,Saldo
			  ,Origen
			  ,OrigenID
			  ,NotaCredxCanc
		FROM #MovsPendientes
		ORDER BY Vencimiento
	SELECT @min = MIN(ID)
		  ,@max = MAX(ID)
	FROM @crAplica
	WHILE @min <= @max
	AND @ImporteTotal > @SumaImporte
	BEGIN
	SELECT @Aplica = Aplica
		  ,@AplicaID = AplicaId
		  ,@Vencimiento = Vencimiento
		  ,@AplicaMovTipo = Clave
		  ,@Capital = Saldo
		  ,@Origen = origen
		  ,@OrigenID = Origenid
		  ,@NotaCredxCanc = NotaCredxCanc
	FROM @crAplica
	WHERE ID = @min
	SELECT @CondonaMoratorios = 0
		  ,@GeneraMoratorioMAVI = NULL
		  ,@IDDetalle = 0
		  ,@MoratorioAPagar = 0
	SELECT @IDDetalle = ID
	FROM CXC
	WHERE Mov = @Aplica
	AND MovId = @AplicaID
	SELECT @GeneraMoratorioMAVI = dbo.fnGeneraMoratorioMAVI(@IDDetalle)

	IF @GeneraMoratorioMAVI = '1'
	BEGIN
		SELECT @InteresesMoratorios = 0
		SELECT @InteresesMoratorios = dbo.fnInteresMoratorioMAVI(@IDDetalle)
		SELECT @MoratorioAPagar = @InteresesMoratorios

		IF @InteresesMoratorios <= @MontoMinimoMor
			AND @InteresesMoratorios > 0
		BEGIN

			IF EXISTS (SELECT * FROM CondonaMorxSistMAVI WHERE IDCobro = @ID AND IDMov = @IDDetalle AND Estatus = 'ALTA')
				UPDATE CondonaMorxSistMAVI
				SET MontoOriginal = @InteresesMoratorios
				   ,MontoCondonado = @InteresesMoratorios
				WHERE IDCobro = @ID
				AND IDMov = @IDDetalle
				AND Estatus = 'ALTA'
			ELSE
				INSERT INTO CondonaMorxSistMAVI (Usuario, FechaAutorizacion, IDMov, RenglonMov, Mov, MovID, MontoOriginal, MontoCondonado, TipoCondonacion, Estatus, IDCobro)
					VALUES (@Usuario, GETDATE(), @IDDetalle, 0, @Aplica, @AplicaID, @InteresesMoratorios, @InteresesMoratorios, 'Por Sistema', 'ALTA', @ID)

			SELECT @InteresesMoratorios = 0
		END

	END
	ELSE
		SELECT @InteresesMoratorios = 0

	IF @InteresesMoratorios > 0
	BEGIN

		IF @SumaImporte + @InteresesMoratorios > @ImporteTotal
			SELECT @MoratorioAPagar = @ImporteTotal - @SumaImporte

		SELECT @SumaImporte = @SumaImporte + @MoratorioAPagar
		INSERT NegociaMoratoriosMAVI (IDCobro, Estacion, Usuario, Mov, MovID, ImporteReal, ImporteAPagar, ImporteMoratorio, ImporteACondonar, MoratorioAPagar, Origen, OrigenID)
			VALUES (@ID, @Estacion, @Usuario, @Aplica, @AplicaId, @Capital, 0, @InteresesMoratorios, 0, @MoratorioAPagar, @Origen, @OrigenId)

		IF @Aplica IN ('Nota Cargo')
		BEGIN
			SELECT @AplicaNota = ISNULL(Mov, 'NA')
				  ,@AplicaIDNota = ISNULL(MovID, 'NA')
			FROM #NotaXCanc
			WHERE Mov = @Aplica
			AND MovID = @AplicaID

			IF @AplicaNota <> 'NA'
				AND @AplicaIDNota <> 'NA'
				UPDATE NegociaMoratoriosMAVI
				SET NotaCreditoxCanc = '1'
				WHERE IDCobro = @ID
				AND Estacion = @Estacion
				AND Mov = @Aplica
				AND MovID = @AplicaID

		END

	END

	SET @min = @min + 1
	END

	IF @Modulo = 'CXC'
		AND @SumaImporte <= @ImporteTotal
	BEGIN
		DECLARE
			@crDocto AS TABLE (
				ID INT IDENTITY (1, 1)
			   ,Aplica VARCHAR(25)
			   ,AplicaId VARCHAR(25)
			   ,Vencimiento DATETIME
			   ,Clave VARCHAR(10)
			   ,Saldo MONEY
			   ,Origen VARCHAR(25)
			   ,Origenid VARCHAR(25)
			   ,NotaCredxCanc CHAR(1)
			)
		INSERT INTO @crDocto (Aplica, AplicaId, Vencimiento, Clave, Saldo, Origen, Origenid, NotaCredxCanc)
			SELECT Aplica
				  ,AplicaId
				  ,Vencimiento
				  ,Clave
				  ,Saldo
				  ,Origen
				  ,OrigenID
				  ,NotaCredxCanc
			FROM #MovsPendientes
			ORDER BY Vencimiento
		SELECT @min = MIN(ID)
			  ,@max = MAX(ID)
		FROM @crDocto
		WHILE @min <= @max
		AND @ImporteTotal >= @SumaImporte
		BEGIN
		SELECT @Aplica = Aplica
			  ,@AplicaID = AplicaId
			  ,@Vencimiento = Vencimiento
			  ,@AplicaMovTipo = Clave
			  ,@Capital = Saldo
			  ,@Origen = Origen
			  ,@OrigenID = Origenid
			  ,@NotaCredxCanc = NotaCredxCanc
		FROM @crDocto
		WHERE ID = @min
		SELECT @ImpReal = @Capital

		IF @SumaImporte + @Capital > @ImporteTotal
			SELECT @Capital = @ImporteTotal - @SumaImporte

		SELECT @SumaImporte = @SumaImporte + @Capital

		IF @Capital > 0

			IF EXISTS (SELECT * FROM NegociaMoratoriosMAVI WHERE IDCobro = @ID AND Estacion = @Estacion AND Mov = @Aplica AND MovID = @AplicaID)
			BEGIN
				UPDATE NegociaMoratoriosMAVI
				SET ImporteAPagar = @Capital
				WHERE Estacion = @Estacion
				AND Mov = @Aplica
				AND MovID = @AplicaID

				IF @Aplica IN ('Nota Cargo')
				BEGIN
					SELECT @AplicaNota = ISNULL(Mov, 'NA')
						  ,@AplicaIDNota = ISNULL(MovID, 'NA')
					FROM #NotaXCanc
					WHERE Mov = @Aplica
					AND MovID = @AplicaID

					IF @AplicaNota <> 'NA'
						AND @AplicaIDNota <> 'NA'
						UPDATE NegociaMoratoriosMAVI
						SET NotaCreditoxCanc = '1'
						WHERE IDCobro = @ID
						AND Estacion = @Estacion
						AND Mov = @Aplica
						AND MovID = @AplicaID

				END

			END
			ELSE
				INSERT NegociaMoratoriosMAVI (IDCobro, Estacion, Usuario, Mov, MovID, ImporteReal, ImporteAPagar, ImporteMoratorio, ImporteACondonar, Origen, OrigenID, NotaCreditoxCanc)
					VALUES (@ID, @Estacion, @Usuario, @Aplica, @AplicaId, @ImpReal, @Capital, @InteresesMoratorios, 0, @Origen, @OrigenID, @NotaCredxCanc)

		IF @Aplica IN ('Nota Cargo')
		BEGIN
			SELECT @AplicaNota = ISNULL(Mov, 'NA')
				  ,@AplicaIDNota = ISNULL(MovID, 'NA')
			FROM #NotaXCanc
			WHERE Mov = @Aplica
			AND MovID = @AplicaID

			IF @AplicaNota <> 'NA'
				AND @AplicaIDNota <> 'NA'
				UPDATE NegociaMoratoriosMAVI
				SET NotaCreditoxCanc = '1'
				WHERE IDCobro = @ID
				AND Estacion = @Estacion
				AND Mov = @Aplica
				AND MovID = @AplicaID

		END

		SET @min = @min + 1
		END
	END

	DROP TABLE #NotaXCanc
	DROP TABLE #MovsPendientes
	EXEC spTipoPagoBonifMAVI @SugerirPago
							,@ID
	EXEC spBonifMonto @ID
	EXEC spImpTotalBonifMAVI @ID
	RETURN
END

