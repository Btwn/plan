SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spSugerirCobroMAVI]
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
	   ,@MoratorioAPagar MONEY
	   ,@Origen VARCHAR(20)
	   ,@OrigenID VARCHAR(20)
	   ,@MovPadre VARCHAR(20)
	   ,@MovPadreID VARCHAR(20)
	   ,@MovPadre1 VARCHAR(20)
	   ,@MovIDPadre VARCHAR(20)
	   ,@PadreMAviPend VARCHAR(20)
	   ,@PadreMaviIDPend VARCHAR(20)
	   ,@NotaCredxCanc CHAR(1)
	   ,@Mov VARCHAR(20)
	   ,@AplicaNota VARCHAR(20)
	   ,@AplicaIDNota VARCHAR(20)
	DELETE NegociaMoratoriosMAVI
	WHERE IDCobro = @ID
	DELETE FROM HistCobroMoratoriosMAVI
	WHERE IDCobro = @ID

	IF EXISTS (SELECT * FROM TipoCobroMAVI WITH(NOLOCK) WHERE IDCobro = @ID)
		UPDATE TipoCobroMAVI WITH(ROWLOCK)
		SET TipoCobro = 0
		WHERE IDCobro = @ID
	ELSE
		INSERT INTO TipoCobroMAVI (IDCobro, TipoCobro)
			VALUES (@ID, 0)

	CREATE TABLE #NotaXCanc (
		Mov VARCHAR(20) NULL
	   ,MovID VARCHAR(20) NULL
	)
	INSERT INTO #NotaXCanc (Mov, MovID)
		SELECT DISTINCT d.mov
					   ,d.movid
		FROM negociamoratoriosmavi c WITH(NOLOCK)
			,cxcpendiente d WITH(NOLOCK)
			,cxc n WITH(NOLOCK)
		WHERE c.mov IN ('Nota Cargo', 'Nota Cargo VIU')
		AND d.cliente = @Contacto
		AND d.mov = c.mov
		AND d.movid = c.movid
		AND d.padremavi IN ('Credilana', 'Prestamo Personal')
		AND n.mov = c.mov
		AND n.movid = c.movid
		AND n.concepto IN ('CANC COBRO CRED Y PP')
	SELECT @DesglosarImpuestos = 0
		  ,@Renglon = 0.0
		  ,@SumaImporte = 0.0
		  ,@ImporteTotal = NULLIF(@ImporteTotal, 0.0)
		  ,@SugerirPago = UPPER(@SugerirPago)
	SELECT @Empresa = Empresa
		  ,@Sucursal = Sucursal
		  ,@Hoy = FechaEmision
		  ,@Moneda = Moneda
		  ,@TipoCambio = TipoCambio
		  ,@Contacto = Cliente
		  ,@Mov = Mov
	FROM Cxc WITH(NOLOCK)
	WHERE ID = @ID

	IF @SugerirPago <> 'IMPORTE ESPECIFICO'
		SELECT @ImporteTotal = 9999999

	SELECT @MontoMinimoMor = ISNULL(MontoMinMoratorioMAVI, 0.0)
	FROM EmpresaCfg2 WITH(NOLOCK)
	WHERE Empresa = @Empresa

	IF @Modulo = 'CXC'
	BEGIN
		SELECT @Empresa = Empresa
			  ,@Sucursal = Sucursal
			  ,@Hoy = FechaEmision
			  ,@Moneda = Moneda
			  ,@TipoCambio = TipoCambio
			  ,@Contacto = Cliente
		FROM Cxc WITH(NOLOCK)
		WHERE ID = @ID
		DELETE CxcD
		WHERE ID = @ID
		DECLARE
			crAplica
			CURSOR FOR
			SELECT p.Mov
				  ,p.MovID
				  ,p.Vencimiento
				  ,mt.Clave
				  ,ISNULL(p.Saldo * mt.Factor * p.MovTipoCambio / @TipoCambio, 0.0)
				  ,ISNULL(p.InteresesOrdinarios * mt.Factor * p.MovTipoCambio / @TipoCambio, 0.0)
				  ,ISNULL(p.InteresesFijos * p.MovTipoCambio / @TipoCambio, 0.0)
				  ,ISNULL(p.InteresesMoratorios * mt.Factor * p.MovTipoCambio / @TipoCambio, 0.0)
				  ,ISNULL(p.Origen, p.Mov)
				  ,ISNULL(p.OrigenID, p.MovId)
				  ,p.PadreMAVI
				  ,p.PadreIDMAVI
			FROM CxcPendiente p WITH(NOLOCK)
			JOIN MovTipo mt WITH(NOLOCK)
				ON mt.Modulo = @Modulo
				AND mt.Mov = p.Mov
			LEFT OUTER JOIN CfgAplicaOrden a WITH(NOLOCK)
				ON a.Modulo = @Modulo
				AND a.Mov = p.Mov
			LEFT OUTER JOIN Cxc r WITH(NOLOCK)
				ON r.ID = p.RamaID
			LEFT OUTER JOIN TipoAmortizacion ta WITH(NOLOCK)
				ON ta.TipoAmortizacion = r.TipoAmortizacion
			WHERE p.Empresa = @Empresa
			AND p.Cliente = @Contacto
			AND mt.Clave NOT IN ('CXC.SCH', 'CXC.SD', 'CXC.NC')
			ORDER BY a.Orden, p.Vencimiento, p.Mov, p.MovID
		SELECT @DesglosarImpuestos = ISNULL(CxcCobroImpuestos, 0)
		FROM EmpresaCfg2 WITH(NOLOCK)
		WHERE Empresa = @Empresa
	END
	ELSE
		RETURN

	OPEN crAplica
	FETCH NEXT FROM crAplica INTO @Aplica, @AplicaID, @Vencimiento, @AplicaMovTipo, @Capital, @InteresesOrdinarios, @InteresesFijos, @InteresesMoratorios, @Origen, @OrigenID
	, @PadreMAviPend, @PadreMaviIDPend
	WHILE @@FETCH_STATUS <> -1
	AND ((@SugerirPago = 'SALDO VENCIDO'
	AND @Vencimiento <= @Hoy
	AND @ImporteTotal > @SumaImporte)
	OR (@SugerirPago = 'IMPORTE ESPECIFICO'
	AND @ImporteTotal > @SumaImporte)
	OR @SugerirPago = 'SALDO TOTAL')
	BEGIN

	IF @@FETCH_STATUS <> -2
	BEGIN
		SELECT @CondonaMoratorios = 0
			  ,@GeneraMoratorioMAVI = NULL
			  ,@IDDetalle = 0
			  ,@MoratorioAPagar = 0
		SELECT @IDDetalle = ID
		FROM CXC WITH(NOLOCK)
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

				IF EXISTS (SELECT * FROM CondonaMorxSistMAVI WITH(NOLOCK) WHERE IDCobro = @ID AND IDMov = @IDDetalle AND Estatus = 'ALTA')
					UPDATE CondonaMorxSistMAVI WITH(ROWLOCK)
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

			IF @InteresesMoratorios > 0
				AND @InteresesMoratorios > @MontoMinimoMor
			BEGIN

				IF @SumaImporte + @InteresesMoratorios > @ImporteTotal
					SELECT @MoratorioAPagar = @ImporteTotal - @SumaImporte

				SELECT @SumaImporte = @SumaImporte + @MoratorioAPagar

				IF @InteresesMoratorios > 0
				BEGIN
					INSERT NegociaMoratoriosMAVI (IDCobro, Estacion, Usuario, Mov, MovID, ImporteReal, ImporteAPagar, ImporteMoratorio, ImporteACondonar, MoratorioAPagar, Origen, OrigenID)
						VALUES (@ID, @Estacion, @Usuario, @Aplica, @AplicaId, @Capital, 0, @InteresesMoratorios, 0, @MoratorioAPagar, @PadreMAviPend, @PadreMaviIDPend)

					IF @Aplica IN ('Nota Cargo', 'Nota Cargo VIU')
					BEGIN
						SELECT @AplicaNota = ISNULL(Mov, 'NA')
							  ,@AplicaIDNota = ISNULL(MovID, 'NA')
						FROM #NotaXCanc
						WHERE Mov = @Aplica
						AND MovID = @AplicaID

						IF @AplicaNota <> 'NA'
							AND @AplicaIDNota <> 'NA'
							UPDATE NegociaMoratoriosMAVI WITH(ROWLOCK)
							SET NotaCreditoxCanc = '1'
							WHERE IDCobro = @ID
							AND Estacion = @Estacion
							AND Mov = @Aplica
							AND MovID = @AplicaID

					END

				END

			END

		END
		ELSE
			SELECT @InteresesMoratorios = 0

		FETCH NEXT FROM crAplica INTO @Aplica, @AplicaID, @Vencimiento, @AplicaMovTipo, @Capital, @InteresesOrdinarios, @InteresesFijos, @InteresesMoratorios, @Origen, @OrigenID
		, @PadreMAviPend, @PadreMaviIDPend
	END

	END
	CLOSE crAplica
	DEALLOCATE crAplica

	IF @Modulo = 'CXC'
		AND @SumaImporte <= @ImporteTotal
	BEGIN
		SELECT @Empresa = Empresa
			  ,@Sucursal = Sucursal
			  ,@Hoy = FechaEmision
			  ,@Moneda = Moneda
			  ,@TipoCambio = TipoCambio
			  ,@Contacto = Cliente
		FROM Cxc WITH(NOLOCK)
		WHERE ID = @ID
		DECLARE
			crDocto
			CURSOR FOR
			SELECT p.Mov
				  ,p.MovID
				  ,p.Vencimiento
				  ,mt.Clave
				  ,ROUND(ISNULL(p.Saldo * mt.Factor * p.MovTipoCambio / @TipoCambio, 0.0), 2)
				  ,ISNULL(p.InteresesOrdinarios * mt.Factor * p.MovTipoCambio / @TipoCambio, 0.0)
				  ,ISNULL(p.InteresesFijos * p.MovTipoCambio / @TipoCambio, 0.0)
				  ,ISNULL(p.InteresesMoratorios * mt.Factor * p.MovTipoCambio / @TipoCambio, 0.0)
				  ,ISNULL(p.Origen, p.Mov)
				  ,ISNULL(p.OrigenID, p.MovID)
				  ,p.PadreMAVI
				  ,p.PadreIDMAVI
			FROM CxcPendiente p WITH(NOLOCK)
			JOIN MovTipo mt WITH(NOLOCK)
				ON mt.Modulo = @Modulo
				AND mt.Mov = p.Mov
			LEFT OUTER JOIN CfgAplicaOrden a WITH(NOLOCK)
				ON a.Modulo = @Modulo
				AND a.Mov = p.Mov
			LEFT OUTER JOIN Cxc r WITH(NOLOCK)
				ON r.ID = p.RamaID
			LEFT OUTER JOIN TipoAmortizacion ta WITH(NOLOCK)
				ON ta.TipoAmortizacion = r.TipoAmortizacion
			WHERE p.Empresa = @Empresa
			AND p.Cliente = @Contacto
			AND mt.Clave NOT IN ('CXC.SCH', 'CXC.SD', 'CXC.NC')
			ORDER BY a.Orden, p.Vencimiento, p.Mov, p.MovID
	END
	ELSE
		RETURN

	OPEN crDocto
	FETCH NEXT FROM crDocto INTO @Aplica, @AplicaID, @Vencimiento, @AplicaMovTipo, @Capital, @InteresesOrdinarios, @InteresesFijos, @InteresesMoratorios, @Origen, @OrigenID
	, @PadreMAviPend, @PadreMaviIDPend
	WHILE @@FETCH_STATUS <> -1
	AND ((@SugerirPago = 'SALDO VENCIDO'
	AND @Vencimiento <= @Hoy
	AND @ImporteTotal > @SumaImporte)
	OR (@SugerirPago = 'IMPORTE ESPECIFICO'
	AND @ImporteTotal > @SumaImporte)
	OR @SugerirPago = 'SALDO TOTAL')
	BEGIN

	IF @@FETCH_STATUS <> -2
	BEGIN
		SELECT @ImpReal = @Capital

		IF @SumaImporte + @Capital > @ImporteTotal
			SELECT @Capital = @ImporteTotal - @SumaImporte

		IF @Capital > 0
		BEGIN
			SELECT @SumaImporte = @SumaImporte + @Capital

			IF EXISTS (SELECT * FROM NegociaMoratoriosMAVI WITH(NOLOCK) WHERE IDCobro = @ID AND Estacion = @Estacion AND Mov = @Aplica AND MovID = @AplicaID)
			BEGIN
				UPDATE NegociaMoratoriosMAVI WITH(ROWLOCK)
				SET ImporteAPagar = @Capital
				WHERE Estacion = @Estacion
				AND Mov = @Aplica
				AND MovID = @AplicaID
				AND IDCobro = @ID

				IF @Aplica IN ('Nota Cargo', 'Nota Cargo VIU')
				BEGIN
					SELECT @AplicaNota = ISNULL(Mov, 'NA')
						  ,@AplicaIDNota = ISNULL(MovID, 'NA')
					FROM #NotaXCanc
					WHERE Mov = @Aplica
					AND MovID = @AplicaID

					IF @AplicaNota <> 'NA'
						AND @AplicaIDNota <> 'NA'
						UPDATE NegociaMoratoriosMAVI WITH(ROWLOCK)
						SET NotaCreditoxCanc = '1'
						WHERE IDCobro = @ID
						AND Estacion = @Estacion
						AND Mov = @Aplica
						AND MovID = @AplicaID

				END

			END
			ELSE
			BEGIN
				INSERT NegociaMoratoriosMAVI (IDCobro, Estacion, Usuario, Mov, MovID, ImporteReal, ImporteAPagar, ImporteMoratorio, ImporteACondonar, Origen, OrigenID)
					VALUES (@ID, @Estacion, @Usuario, @Aplica, @AplicaId, @ImpReal, @Capital, 0, 0, @PadreMAviPend, @PadreMaviIDPend)

				IF @Aplica IN ('Nota Cargo', 'Nota Cargo VIU')
				BEGIN
					SELECT @AplicaNota = ISNULL(Mov, 'NA')
						  ,@AplicaIDNota = ISNULL(MovID, 'NA')
					FROM #NotaXCanc
					WHERE Mov = @Aplica
					AND MovID = @AplicaID

					IF @AplicaNota <> 'NA'
						AND @AplicaIDNota <> 'NA'
						UPDATE NegociaMoratoriosMAVI WITH(ROWLOCK)
						SET NotaCreditoxCanc = '1'
						WHERE IDCobro = @ID
						AND Estacion = @Estacion
						AND Mov = @Aplica
						AND MovID = @AplicaID

				END

			END

		END

		FETCH NEXT FROM crDocto INTO @Aplica, @AplicaID, @Vencimiento, @AplicaMovTipo, @Capital, @InteresesOrdinarios, @InteresesFijos, @InteresesMoratorios, @Origen, @OrigenID
		, @PadreMAviPend, @PadreMaviIDPend
	END

	END
	CLOSE crDocto
	DEALLOCATE crDocto
	DROP TABLE #NotaXCanc
	EXEC spOrigenNCxCancMAVI @ID
	EXEC spOrigenCobrosInstMAVI @ID
	EXEC spTipoPagoBonifMAVI @SugerirPago
							,@ID
	EXEC spBonifMonto @ID
	EXEC spImpTotalBonifMAVI @ID
	RETURN
END
GO