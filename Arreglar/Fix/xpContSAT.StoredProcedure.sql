SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[xpContSAT]
 @Empresa CHAR(5)
,@Modulo CHAR(5)
,@ID INT
,@ContID INT = NULL
,@Personal VARCHAR(10) = NULL
AS
BEGIN
	DECLARE
		@MovTipo VARCHAR(20)
	   ,@Mov VARCHAR(20)
	   ,@ContRelacionarComp BIT
	   ,@ContArrastrarCompOrigen BIT
	   ,@Timbra INT
	   ,@MetodoPagoSAT INT
	   ,@MetodoPago VARCHAR(255)
	   ,@TipoCambio FLOAT
	   ,@TipoPoliza VARCHAR(20)
	   ,@AsociaMovPosterior BIT
	   ,@AsociaMovAnterior BIT
	   ,@ClaveAfectacion VARCHAR(20)
	   ,@cModulo VARCHAR(5)
	   ,@cID INT
	DECLARE
		@MovsPosteriores TABLE (
			Modulo VARCHAR(5) NULL
		   ,ID INT NULL
		)
	SELECT @Mov = dbo.fnModuloMov(@Modulo, @ID)
	SELECT @Timbra = dbo.fnDesplegarCfdConcentrado(@Empresa, @Modulo)
	SELECT @ClaveAfectacion = Clave
		  ,@MovTipo = Clave
		  ,@ContRelacionarComp = ISNULL(ContRelacionarComp, 0)
		  ,@ContArrastrarCompOrigen = ISNULL(ContArrastrarCompOrigen, 0)
		  ,@AsociaMovPosterior = AsociaMovPosterior
		  ,@AsociaMovAnterior = AsociaMovAnterior
	FROM MovTipo
	WHERE Modulo = @Modulo
	AND Mov = @Mov

	IF @ContRelacionarComp = 0
		AND @ContArrastrarCompOrigen = 0
		AND @AsociaMovAnterior = 0
	BEGIN
		RETURN
	END

	SELECT @TipoPoliza = B.TipoPoliza
	FROM CONT A
	JOIN MovTipo B
		ON A.Mov = B.Mov
		AND B.Modulo = 'CONT'
	WHERE A.ID = @ContID

	IF (@Timbra = 1)
	BEGIN
		EXEC spActualizaMonedaTipoCambio @ID
										,@Modulo
										,@Empresa
	END

	IF @Mov IS NOT NULL
		EXEC spReconstruirMovImpuesto @Modulo
									 ,@ID

	IF @Modulo = 'FIS'
		RETURN

	IF (OBJECT_ID('Tempdb..#Movs')) IS NOT NULL
		DROP TABLE #Movs

	CREATE TABLE #Movs (
		Num INT
	   ,ID INT
	   ,Modulo VARCHAR(5) COLLATE Database_Default
	   ,Mov VARCHAR(20) COLLATE Database_Default
	   ,MovID VARCHAR(20) COLLATE Database_Default
	   ,Tipo INT
	)
	CREATE INDEX MovsMov ON #Movs (Mov, MovID)
	CREATE INDEX MovsMovduloId ON #Movs (Modulo, ID)
	INSERT INTO #Movs (Num, ID, Modulo, Mov, MovID, Tipo)
		SELECT Num
			  ,ID
			  ,Modulo
			  ,Mov
			  ,MovID
			  ,Tipo
		FROM dbo.fnBuscaOrigen(@Modulo, @ID, @Empresa)

	IF @Modulo = 'DIN'
		AND @ContID IS NOT NULL
		AND UPPER(LTRIM(RTRIM(@TipoPoliza))) = 'EGRESOS'
	BEGIN

		IF NOT EXISTS (SELECT * FROM Dinero WHERE ConDesglose = 1 AND ID = @ID)
		BEGIN
			SELECT @MetodoPagoSAT = MetodoPagoSAT
				  ,@MetodoPago = C.Descripcion
			FROM Dinero A
			JOIN FormaPago B
				ON A.FormaPago = B.FormaPago
			JOIN ContSATMetodoPago C
				ON C.Clave = B.MetodoPagoSAT
			WHERE A.ID = @ID

			IF @MetodoPagoSAT = 2
			BEGIN

				IF NOT EXISTS (SELECT * FROM ContSATCheque WHERE Modulo = @Modulo AND ModuloID = @ID)
				BEGIN
					INSERT ContSATCheque (Modulo, ModuloID, ContID, ModuloRenglon, CtaOrigen, BancoOrigen, Monto,
					Fecha, Beneficiario, RFC, NumeroCheque, Moneda, TipoCambio)
						SELECT @Modulo
							  ,@ID
							  ,@ContID
							  ,0
							  ,c.CtaDinero
							  ,i.Institucion
							  ,ISNULL(d.Importe, 0) + ISNULL(d.Impuestos, 0)
							  ,d.FechaEmision
							  ,d.BeneficiarioNombre
							  ,dbo.fnRFCContactoTipo(@ID)
							  ,d.NumeroCheque
							  ,'MXN'
							  ,CASE
								   WHEN dbo.fnBuscaClaveMoneda(d.Moneda) IS NULL THEN NULL
								   ELSE ISNULL(d.TipoCambio, NULL)
							   END
						FROM Dinero d
						JOIN CtaDinero c
							ON c.CtaDinero = d.CtaDinero
						LEFT JOIN CFDINominaInstitucionFin i
							ON i.Institucion = c.BancoSucursal
						WHERE d.ID = @ID
					UPDATE Dinero
					SET RFCReceptor = dbo.fnRFCContactoTipo(@ID)
					WHERE NULLIF(RFCReceptor, '') IS NULL
					AND ID = @ID
				END

			END

			IF @MetodoPagoSAT = 3
			BEGIN

				IF NOT EXISTS (SELECT * FROM ContSATTranferencia WHERE Modulo = @Modulo AND ModuloID = @ID)
				BEGIN

					IF @Modulo = 'DIN'
					BEGIN
						EXEC spContSATDineroActualizarCtaDineroRfc @ID
					END

					INSERT ContSATTranferencia (Modulo, ModuloID, ContID, ModuloRenglon, CtaOrigen, BancoOrigen, Monto,
					Fecha, Beneficiario, RFC, CtaDestino, BancoDestino, Moneda, TipoCambio)
						SELECT @Modulo
							  ,@ID
							  ,@ContID
							  ,0
							  ,c.CtaDinero
							  ,i.Institucion
							  ,ROUND(ISNULL(d.Importe, 0) + ISNULL(d.Impuestos, 0), 2)
							  ,d.FechaEmision
							  ,d.BeneficiarioNombre
							  ,dbo.fnRFCContactoTipo(@ID)
							  ,d.CtaBeneficiario
							  ,f.Institucion
							  ,'MXN'
							  ,CASE
								   WHEN dbo.fnBuscaClaveMoneda(d.Moneda) IS NULL THEN NULL
								   ELSE ISNULL(d.TipoCambio, NULL)
							   END
						FROM Dinero d
						JOIN CtaDinero c
							ON c.CtaDinero = d.CtaDinero
						LEFT JOIN CtaDinero cta
							ON cta.CtaDinero = d.CtaBeneficiario
						LEFT JOIN CFDINominaInstitucionFin i
							ON i.Institucion = c.BancoSucursal
						LEFT JOIN CFDINominaInstitucionFin f
							ON f.Institucion = cta.BancoSucursal
						WHERE d.ID = @ID
						EXCEPT
						SELECT Modulo
							  ,ModuloID
							  ,ContID
							  ,ModuloRenglon
							  ,CtaOrigen
							  ,BancoOrigen
							  ,Monto
							  ,Fecha
							  ,Beneficiario
							  ,RFC
							  ,CtaDestino
							  ,BancoDestino
							  ,Moneda
							  ,TipoCambio
						FROM ContSATTranferencia
						WHERE ModuloID = @ID
					UPDATE Dinero
					SET RFCReceptor = dbo.fnRFCContactoTipo(@ID)
					WHERE NULLIF(RFCReceptor, '') IS NULL
					AND ID = @ID
				END

			END

			IF (@MetodoPagoSAT IS NULL OR @MetodoPagoSAT NOT IN (2, 3))
			BEGIN

				IF NOT EXISTS (SELECT * FROM ContSATOtroMetodoPago WHERE Modulo = @Modulo AND ModuloID = @ID)
				BEGIN
					INSERT ContSATOtroMetodoPago (Modulo, ModuloID, ContID, ClaveMetPago, MetPago, Fecha,
					Beneficiario, RFC, Monto, Moneda, TipoCambio, FormaPago)
						SELECT @Modulo
							  ,@ID
							  ,@ContID
							  ,ISNULL(@MetodoPagoSAT, 99)
							  ,ISNULL(@MetodoPago, 'Otros')
							  ,d.FechaEmision
							  ,d.BeneficiarioNombre
							  ,dbo.fnRFCContactoTipo(@ID)
							  ,ROUND(ISNULL(d.Importe, 0) + ISNULL(d.Impuestos, 0), 2)
							  ,'MXN'
							  ,CASE
								   WHEN dbo.fnBuscaClaveMoneda(d.Moneda) IS NULL THEN NULL
								   ELSE ISNULL(d.TipoCambio, NULL)
							   END
							  ,d.FormaPago
						FROM Dinero d
						JOIN CtaDinero c
							ON c.CtaDinero = d.CtaDinero
						LEFT JOIN CFDINominaInstitucionFin i
							ON i.Institucion = c.BancoSucursal
						WHERE d.ID = @ID
					UPDATE Dinero
					SET RFCReceptor = dbo.fnRFCContactoTipo(@ID)
					WHERE NULLIF(RFCReceptor, '') IS NULL
					AND ID = @ID
				END

			END

		END

		IF EXISTS (SELECT * FROM Dinero WHERE ConDesglose = 1 AND ID = @ID)
		BEGIN

			IF EXISTS (SELECT 1 FROM Dinero A JOIN DineroD B ON A.ID = B.ID JOIN FormaPago C ON C.FormaPago = B.FormaPago WHERE A.ID = @ID AND C.MetodoPagoSAT = 2)
			BEGIN
				INSERT ContSATCheque (Modulo, ModuloID, ContID, ModuloRenglon, CtaOrigen, BancoOrigen, Monto,
				Fecha, Beneficiario, RFC, NumeroCheque, Moneda, TipoCambio)
					SELECT @Modulo
						  ,@ID
						  ,@ContID
						  ,B.Renglon
						  ,D.CtaDinero
						  ,E.Institucion
						  ,ISNULL(B.Importe, 0)
						  ,A.FechaEmision
						  ,A.BeneficiarioNombre
						  ,dbo.fnRFCContactoTipo(@ID)
						  ,B.NumeroCheque
						  ,'MXN'
						  ,CASE
							   WHEN dbo.fnBuscaClaveMoneda(A.Moneda) IS NULL THEN NULL
							   ELSE ISNULL(A.TipoCambio, NULL)
						   END
					FROM Dinero A
					JOIN DineroD B
						ON A.ID = B.ID
					JOIN FormaPago C
						ON C.FormaPago = B.FormaPago
					JOIN CtaDinero D
						ON D.CtaDinero = A.CtaDinero
					LEFT JOIN CFDINominaInstitucionFin E
						ON E.Institucion = D.BancoSucursal
					WHERE A.ID = @ID
					AND C.MetodoPagoSAT = 2
					EXCEPT
					SELECT Modulo
						  ,ModuloID
						  ,ContID
						  ,ModuloRenglon
						  ,CtaOrigen
						  ,BancoOrigen
						  ,Monto
						  ,Fecha
						  ,Beneficiario
						  ,RFC
						  ,NumeroCheque
						  ,Moneda
						  ,TipoCambio
					FROM ContSATCheque
					WHERE ModuloID = @ID
					AND contid = @ContID
			END

			IF EXISTS (SELECT 1 FROM Dinero A JOIN DineroD B ON A.ID = B.ID JOIN FormaPago C ON C.FormaPago = B.FormaPago WHERE A.ID = @ID AND C.MetodoPagoSAT = 3)
			BEGIN

				IF @Modulo = 'DIN'
					AND @ClaveAfectacion IN ('DIN.AB', 'DIN.CB')
				BEGIN
					EXEC spContSATDineroActualizarCtaDineroRfc @ID
					INSERT ContSATTranferencia (Modulo, ModuloID, ContID, ModuloRenglon, CtaOrigen, BancoOrigen, Monto,
					Fecha, Beneficiario, RFC, CtaDestino, BancoDestino, Moneda, TipoCambio)
						SELECT @Modulo
							  ,@ID
							  ,@ContID
							  ,B.Renglon
							  ,D.CtaDinero
							  ,F.Institucion
							  ,ROUND(ISNULL(B.Importe, 0), 2)
							  ,A.FechaEmision
							  ,A.BeneficiarioNombre
							  ,dbo.fnRFCContactoTipo(@ID)
							  ,A.CtaBeneficiario
							  ,E.Institucion
							  ,'MXN'
							  ,CASE
								   WHEN dbo.fnBuscaClaveMoneda(A.Moneda) IS NULL THEN NULL
								   ELSE ISNULL(A.TipoCambio, NULL)
							   END
						FROM Dinero A
						JOIN DineroD B
							ON A.ID = B.ID
						JOIN FormaPago C
							ON C.FormaPago = B.FormaPago
						JOIN CtaDinero D
							ON D.CtaDinero = A.CtaDinero
						LEFT JOIN CtaDinero E
							ON E.CtaDinero = A.CtaBeneficiario
						LEFT JOIN CFDINominaInstitucionFin F
							ON F.Institucion = D.BancoSucursal
						LEFT JOIN CFDINominaInstitucionFin G
							ON G.Institucion = E.BancoSucursal
						WHERE A.ID = @ID
						AND C.MetodoPagoSAT IN (3)
						EXCEPT
						SELECT Modulo
							  ,ModuloID
							  ,ContID
							  ,ModuloRenglon
							  ,CtaOrigen
							  ,BancoOrigen
							  ,Monto
							  ,Fecha
							  ,Beneficiario
							  ,RFC
							  ,CtaDestino
							  ,BancoDestino
							  ,Moneda
							  ,TipoCambio
						FROM ContSATTranferencia
						WHERE ModuloID = @ID
						AND contid = @ContID
				END
				ELSE
				BEGIN
					INSERT ContSATTranferencia (Modulo, ModuloID, ContID, ModuloRenglon, CtaOrigen, BancoOrigen, Monto,
					Fecha, Beneficiario, RFC, CtaDestino, BancoDestino, Moneda, TipoCambio)
						SELECT @Modulo
							  ,@ID
							  ,@ContID
							  ,B.Renglon
							  ,D.CtaDinero
							  ,F.Institucion
							  ,ROUND(ISNULL(B.Importe, 0), 2)
							  ,A.FechaEmision
							  ,A.BeneficiarioNombre
							  ,dbo.fnRFCContactoTipo(@ID)
							  ,B.CtaBeneficiario
							  ,G.Institucion
							  ,'MXN'
							  ,CASE
								   WHEN dbo.fnBuscaClaveMoneda(A.Moneda) IS NULL THEN NULL
								   ELSE ISNULL(A.TipoCambio, NULL)
							   END
						FROM Dinero A
						JOIN DineroD B
							ON A.ID = B.ID
						JOIN FormaPago C
							ON C.FormaPago = B.FormaPago
						JOIN CtaDinero D
							ON D.CtaDinero = A.CtaDinero
						LEFT JOIN CtaDinero E
							ON E.CtaDinero = A.CtaBeneficiario
						LEFT JOIN CFDINominaInstitucionFin F
							ON F.Institucion = D.BancoSucursal
						LEFT JOIN CFDINominaInstitucionFin G
							ON G.Institucion = E.BancoSucursal
						WHERE A.ID = @ID
						AND C.MetodoPagoSAT IN (3)
						EXCEPT
						SELECT Modulo
							  ,ModuloID
							  ,ContID
							  ,ModuloRenglon
							  ,CtaOrigen
							  ,BancoOrigen
							  ,Monto
							  ,Fecha
							  ,Beneficiario
							  ,RFC
							  ,CtaDestino
							  ,BancoDestino
							  ,Moneda
							  ,TipoCambio
						FROM ContSATTranferencia
						WHERE ModuloID = @ID
						AND contid = @ContID
				END

			END

			IF EXISTS (SELECT 1 FROM Dinero A JOIN DineroD B ON A.ID = B.ID JOIN FormaPago C ON C.FormaPago = B.FormaPago WHERE A.ID = @ID AND C.MetodoPagoSAT NOT IN (2, 3))
			BEGIN
				INSERT ContSATOtroMetodoPago (Modulo, ModuloID, ContID, ClaveMetPago, MetPago, Fecha,
				Beneficiario, RFC, Monto, Moneda, TipoCambio, FormaPago,
				ModuloRenglon)
					SELECT @Modulo
						  ,@ID
						  ,@ContID
						  ,ISNULL(C.MetodoPagoSAT, 99)
						  ,ISNULL(M.Descripcion, 'Otros')
						  ,A.FechaEmision
						  ,A.BeneficiarioNombre
						  ,dbo.fnRFCContactoTipo(@ID)
						  ,B.Importe
						  ,'MXN'
						  ,CASE
							   WHEN dbo.fnBuscaClaveMoneda(A.Moneda) IS NULL THEN NULL
							   ELSE ISNULL(A.TipoCambio, NULL)
						   END
						  ,B.FormaPago
						  ,B.Renglon
					FROM Dinero A
					JOIN DineroD B
						ON A.ID = B.ID
					JOIN FormaPago C
						ON C.FormaPago = B.FormaPago
					JOIN CtaDinero D
						ON D.CtaDinero = A.CtaDinero
					JOIN ContSATMetodoPago M
						ON M.Clave = C.MetodoPagoSAT
					LEFT JOIN CFDINominaInstitucionFin E
						ON E.Institucion = D.BancoSucursal
					WHERE A.ID = @ID
					AND C.MetodoPagoSAT NOT IN (2, 3)
					EXCEPT
					SELECT Modulo
						  ,ModuloID
						  ,ContID
						  ,ClaveMetPago
						  ,MetPago
						  ,Fecha
						  ,Beneficiario
						  ,RFC
						  ,Monto
						  ,Moneda
						  ,TipoCambio
						  ,FormaPago
						  ,ModuloRenglon
					FROM ContSATOtroMetodoPago
					WHERE ModuloID = @ID
					AND contid = @ContID
			END

		END

	END

	IF @ContArrastrarCompOrigen = 1
	BEGIN

		IF (
				SELECT COUNT(DISTINCT C.ID)
				FROM #Movs A
				JOIN ContSATCFDCBB C
					ON A.Modulo = C.Modulo
					AND A.ID = C.ModuloID
				JOIN Cont CO
					ON CO.OrigenTipo = C.Modulo
					AND CO.Origen = A.Mov
				WHERE C.ContID IS NULL
			)
			>= 1
		BEGIN
			UPDATE ContSATCFDCBB
			SET ContID = @ContID
			WHERE ID IN (SELECT DISTINCT C.ID FROM #Movs A JOIN ContSATCFDCBB C ON A.Modulo = C.Modulo AND A.ID = C.ModuloID JOIN Cont CO ON CO.OrigenTipo = C.Modulo AND CO.Origen = A.Mov WHERE C.ContID IS NULL)
		END

		IF (
				SELECT COUNT(DISTINCT C.ID)
				FROM #Movs A
				JOIN ContSATExtranjero C
					ON A.Modulo = C.Modulo
					AND A.ID = C.ModuloID
				JOIN Cont CO
					ON CO.OrigenTipo = C.Modulo
					AND CO.Origen = A.Mov
				WHERE C.ContID IS NULL
			)
			>= 1
		BEGIN
			UPDATE ContSATExtranjero
			SET ContID = @ContID
			WHERE ID IN (SELECT DISTINCT C.ID FROM #Movs A JOIN ContSATExtranjero C ON A.Modulo = C.Modulo AND A.ID = C.ModuloID JOIN Cont CO ON CO.OrigenTipo = C.Modulo AND CO.Origen = A.Mov WHERE C.ContID IS NULL)
		END

	END

	IF @ContArrastrarCompOrigen = 1
		AND @Modulo = 'DIN'
	BEGIN

		IF (
				SELECT COUNT(DISTINCT C.ID)
				FROM #Movs A
				JOIN ContSATCFDCBB C
					ON A.Modulo = C.Modulo
					AND A.ID = C.ModuloID
				JOIN Cont CO
					ON CO.OrigenTipo = C.Modulo
					AND CO.Origen = A.Mov
				WHERE C.ContID IS NOT NULL
			)
			>= 1
		BEGIN
			INSERT INTO ContSATCFDCBB (Modulo, ModuloID, ContID, SerieCFDCBB, NumFolCFDCBB, RFCBeneficiario, MontoTotal, Moneda, TipoCambio)
				SELECT DISTINCT @Modulo
							   ,@Id
							   ,@ContID
							   ,C.SerieCFDCBB
							   ,C.NumFolCFDCBB
							   ,C.RFCBeneficiario
							   ,C.MontoTotal
							   ,C.Moneda
							   ,C.TipoCambio
				FROM #Movs A
				JOIN ContSATCFDCBB C
					ON A.Modulo = C.Modulo
					AND A.ID = C.ModuloID
				JOIN Cont CO
					ON CO.OrigenTipo = C.Modulo
					AND CO.Origen = A.Mov
				WHERE C.ContID IS NOT NULL
		END

		IF (
				SELECT COUNT(DISTINCT C.ID)
				FROM #Movs A
				JOIN ContSATExtranjero C
					ON A.Modulo = C.Modulo
					AND A.ID = C.ModuloID
				JOIN Cont CO
					ON CO.OrigenTipo = C.Modulo
					AND CO.Origen = A.Mov
				WHERE C.ContID IS NOT NULL
			)
			>= 1
		BEGIN
			INSERT INTO ContSATExtranjero (Modulo, ModuloID, ContID, NumFactExt, TaxID, MontoTotal, Moneda, TipoCambio)
				SELECT DISTINCT @Modulo
							   ,@Id
							   ,@ContID
							   ,C.NumFactExt
							   ,C.TaxID
							   ,C.MontoTotal
							   ,C.Moneda
							   ,C.TipoCambio
				FROM #Movs A
				JOIN ContSATExtranjero C
					ON A.Modulo = C.Modulo
					AND A.ID = C.ModuloID
				JOIN Cont CO
					ON CO.OrigenTipo = C.Modulo
					AND CO.Origen = A.Mov
				WHERE C.ContID IS NOT NULL
		END

	END

	IF @ContRelacionarComp = 1
		AND @ContID IS NOT NULL
	BEGIN

		IF @Modulo = 'DIN'
		BEGIN
			INSERT ContSATComprobante (Modulo, ModuloID, ContID, ModuloRenglon, UUID,
			Monto, RFC, EsCheque, EsTransferencia, Moneda,
			TipoCambio)
				SELECT B.Modulo
					  ,B.ModuloID
					  ,@ContID
					  ,B.ModuloRenglon
					  ,B.UUID
					  ,B.Monto
					  ,B.RFCEmisor
					  ,CASE
						   WHEN @MetodoPagoSAT = 2 THEN 1
						   ELSE 0
					   END
					  ,CASE
						   WHEN @MetodoPagoSAT = 3 THEN 1
						   ELSE 0
					   END
					  ,'MXN'
					  ,CASE
						   WHEN dbo.fnBuscaClaveMoneda(B.Moneda) IS NULL THEN NULL
						   ELSE ISNULL(B.TipoCambio, NULL)
					   END
				FROM #Movs A
				JOIN CFDEgreso B
					ON A.Modulo = B.Modulo
					AND A.ID = B.ModuloID
				LEFT JOIN ContSATComprobante t
					ON t.Modulo = B.Modulo
					AND t.ModuloID = B.ModuloID
					AND t.ContID = @ContID
				WHERE B.UUID IS NOT NULL
				AND t.ModuloID IS NULL
				EXCEPT
				SELECT Modulo
					  ,ModuloID
					  ,ContID
					  ,ModuloRenglon
					  ,UUID
					  ,Monto
					  ,RFC
					  ,EsCheque
					  ,EsTransferencia
					  ,Moneda
					  ,TipoCambio
				FROM ContSATComprobante
		END
		ELSE
		BEGIN
			INSERT ContSATComprobante (Modulo, ModuloID, ContID, ModuloRenglon, UUID, Monto, RFC, EsCheque, EsTransferencia, Moneda, TipoCambio)
				SELECT B.Modulo
					  ,B.ModuloID
					  ,@ContID
					  ,B.ModuloRenglon
					  ,B.UUID
					  ,B.Monto
					  ,B.RFCEmisor
					  ,0
					  ,0
					  ,'MXN'
					  ,CASE
						   WHEN dbo.fnBuscaClaveMoneda(B.Moneda) IS NULL THEN NULL
						   ELSE ISNULL(B.TipoCambio, NULL)
					   END
				FROM #Movs A
				JOIN CFDEgreso B
					ON A.Modulo = B.Modulo
					AND A.ID = B.ModuloID
				LEFT JOIN ContSATComprobante t
					ON t.Modulo = B.Modulo
					AND t.ModuloID = B.ModuloID
					AND t.ContID = @ContID
				WHERE B.UUID IS NOT NULL
				AND t.ModuloID IS NULL
				EXCEPT
				SELECT Modulo
					  ,ModuloID
					  ,ContID
					  ,ModuloRenglon
					  ,UUID
					  ,Monto
					  ,RFC
					  ,EsCheque
					  ,EsTransferencia
					  ,Moneda
					  ,TipoCambio
				FROM ContSATComprobante
			INSERT ContSATComprobante (Modulo, ModuloID, ContID, ModuloRenglon, UUID, Monto, RFC,
			EsCheque, EsTransferencia, Moneda, TipoCambio)
				SELECT B.Modulo
					  ,B.ModuloID
					  ,@ContID
					  ,0
					  ,B.UUID
					  ,ROUND(ISNULL(B.Importe, 0) + ISNULL(B.Impuesto1, 0) + ISNULL(B.Impuesto2, 0), 2)
					  ,B.RFC
					  ,0
					  ,0
					  ,'MXN'
					  ,CASE
						   WHEN dbo.fnBuscaClaveMoneda(B.Moneda) IS NULL THEN NULL
						   ELSE ISNULL(B.TipoCambio, NULL)
					   END
				FROM #Movs A
				JOIN CFD B
					ON A.Modulo = B.Modulo
					AND A.ID = B.ModuloID
				LEFT JOIN ContSATComprobante t
					ON t.Modulo = B.Modulo
					AND t.ModuloID = B.ModuloID
					AND t.ContID = @ContID
				WHERE ISNULL(Cancelado, 0) = 0
				AND B.UUID IS NOT NULL
				AND t.ModuloID IS NULL
				EXCEPT
				SELECT Modulo
					  ,ModuloID
					  ,ContID
					  ,ModuloRenglon
					  ,UUID
					  ,Monto
					  ,RFC
					  ,EsCheque
					  ,EsTransferencia
					  ,Moneda
					  ,TipoCambio
				FROM ContSATComprobante
			INSERT ContSATComprobante (Modulo, ModuloID, ContID, ModuloRenglon, UUID, Monto,
			RFC, EsCheque, EsTransferencia, Personal, Moneda, TipoCambio)
				SELECT B.Modulo
					  ,B.ModuloID
					  ,@ContID
					  ,0
					  ,B.UUID
					  ,ISNULL(B.Importe, 0)
					  ,B.RFCReceptor
					  ,0
					  ,0
					  ,B.Personal
					  ,'MXN'
					  ,CASE
						   WHEN dbo.fnBuscaClaveMoneda(B.Moneda) IS NULL THEN NULL
						   ELSE ISNULL(B.TipoCambio, NULL)
					   END
				FROM #Movs A
				JOIN CFDNomina B
					ON A.Modulo = B.Modulo
					AND A.ID = B.ModuloID
				LEFT JOIN ContSATComprobante t
					ON t.Modulo = B.Modulo
					AND t.ModuloID = B.ModuloID
					AND t.ContID = @ContID
				WHERE ISNULL(Cancelado, 0) = 0
				AND B.UUID IS NOT NULL
				AND t.ModuloID IS NULL
				EXCEPT
				SELECT Modulo
					  ,ModuloID
					  ,ContID
					  ,ModuloRenglon
					  ,UUID
					  ,Monto
					  ,RFC
					  ,EsCheque
					  ,EsTransferencia
					  ,Personal
					  ,Moneda
					  ,TipoCambio
				FROM ContSATComprobante
		END

	END

	IF @ContArrastrarCompOrigen = 1
	BEGIN

		IF EXISTS (SELECT * FROM MovImpuesto m JOIN CFDEgreso c ON m.OrigenModulo = c.Modulo AND m.OrigenModuloID = c.ModuloID WHERE m.Modulo = @Modulo AND m.ModuloID = @ID)
		BEGIN
			INSERT ContSATComprobante (Modulo, ModuloID, ContID, ModuloRenglon, UUID, Monto, RFC, EsCheque, EsTransferencia, Moneda, TipoCambio)
				SELECT c.Modulo
					  ,c.ModuloID
					  ,@ContID
					  ,c.ModuloRenglon
					  ,c.UUID
					  ,c.Monto
					  ,c.RFCEmisor
					  ,0
					  ,0
					  ,'MXN'
					  ,CASE
						   WHEN dbo.fnBuscaClaveMoneda(c.Moneda) IS NULL THEN NULL
						   ELSE ISNULL(c.TipoCambio, NULL)
					   END
				FROM #Movs M
				JOIN CFDEgreso c
					ON M.Modulo = c.Modulo
					AND M.ID = c.ModuloID
				LEFT JOIN ContSATComprobante t
					ON t.Modulo = c.Modulo
					AND t.ModuloID = c.ModuloID
					AND t.ContID = @ContID
				WHERE c.UUID IS NOT NULL
				AND c.Modulo NOT IN ('VTAS', 'CXC')
				AND t.ModuloID IS NULL
				EXCEPT
				SELECT Modulo
					  ,ModuloID
					  ,ContID
					  ,ModuloRenglon
					  ,UUID
					  ,Monto
					  ,RFC
					  ,EsCheque
					  ,EsTransferencia
					  ,Moneda
					  ,TipoCambio
				FROM ContSATComprobante
		END

		IF EXISTS (SELECT * FROM MovImpuesto m JOIN CFD c ON m.OrigenModulo = c.Modulo AND m.OrigenModuloID = c.ModuloID WHERE m.Modulo = @Modulo AND m.ModuloID = @ID)
		BEGIN

			IF @ContID IS NOT NULL
			BEGIN
				INSERT ContSATComprobante (Modulo, ModuloID, ContID, ModuloRenglon, UUID, Monto,
				RFC, EsCheque, EsTransferencia, Moneda, TipoCambio)
					SELECT c.Modulo
						  ,c.ModuloID
						  ,@ContID
						  ,0
						  ,c.UUID
						  ,ROUND(ISNULL(c.Importe, 0) + ISNULL(c.Impuesto1, 0) + ISNULL(c.Impuesto2, 0), 2)
						  ,c.RFC
						  ,0
						  ,0
						  ,'MXN'
						  ,CASE
							   WHEN dbo.fnBuscaClaveMoneda(c.Moneda) IS NULL THEN NULL
							   ELSE ISNULL(c.TipoCambio, NULL)
						   END
					FROM #Movs M
					JOIN CFD c
						ON m.Modulo = c.Modulo
						AND m.ID = c.ModuloID
					LEFT JOIN ContSATComprobante t
						ON t.Modulo = c.Modulo
						AND t.ModuloID = c.ModuloID
						AND t.ContID = @ContID
					WHERE ISNULL(c.Cancelado, 0) = 0
					AND c.UUID IS NOT NULL
					AND t.ModuloID IS NULL
					EXCEPT
					SELECT Modulo
						  ,ModuloID
						  ,ContID
						  ,ModuloRenglon
						  ,UUID
						  ,Monto
						  ,RFC
						  ,EsCheque
						  ,EsTransferencia
						  ,Moneda
						  ,TipoCambio
					FROM ContSATComprobante
			END

		END

	END

	IF @ContID IS NULL
	BEGIN
		INSERT ContSATComprobante (Modulo, ModuloID, ContID, ModuloRenglon, UUID, Monto, RFC, EsCheque, EsTransferencia, Moneda, TipoCambio)
			SELECT c.Modulo
				  ,c.ModuloID
				  ,co.ID
				  ,c.ModuloRenglon
				  ,c.UUID
				  ,c.Monto
				  ,c.RFCEmisor
				  ,0
				  ,0
				  ,'MXN'
				  ,CASE
					   WHEN dbo.fnBuscaClaveMoneda(c.Moneda) IS NULL THEN NULL
					   ELSE ISNULL(c.TipoCambio, NULL)
				   END
			FROM #Movs A
			JOIN CFDEgreso c
				ON A.Modulo = C.Modulo
				AND A.ID = C.ModuloID
			JOIN Mov m
				ON m.Modulo = m.Modulo
				AND m.ID = c.ModuloID
				AND m.Empresa = c.Empresa
			JOIN Cont co
				ON co.Empresa = c.Empresa
				AND ISNULL(co.OrigenTipo, 'CONT') = c.Modulo
				AND ISNULL(co.Origen, co.Mov) = m.Mov
				AND ISNULL(co.OrigenID, co.MovID) = m.MovID
			LEFT JOIN ContSATComprobante t
				ON t.Modulo = c.Modulo
				AND t.ModuloID = c.ModuloID
			WHERE c.Modulo = @Modulo
			AND c.ModuloID = @ID
			AND c.Empresa = @Empresa
			AND c.UUID IS NOT NULL
			AND t.ModuloID IS NULL
			EXCEPT
			SELECT Modulo
				  ,ModuloID
				  ,ContID
				  ,ModuloRenglon
				  ,UUID
				  ,Monto
				  ,RFC
				  ,EsCheque
				  ,EsTransferencia
				  ,Moneda
				  ,TipoCambio
			FROM ContSATComprobante
		INSERT ContSATComprobante (Modulo, ModuloID, ContID, ModuloRenglon, UUID, Monto,
		RFC, EsCheque, EsTransferencia, Moneda, TipoCambio)
			SELECT c.Modulo
				  ,c.ModuloID
				  ,co.ID
				  ,0
				  ,c.UUID
				  ,ROUND(ISNULL(c.Importe, 0) + ISNULL(c.Impuesto1, 0) + ISNULL(c.Impuesto2, 0), 2)
				  ,c.RFC
				  ,0
				  ,0
				  ,'MXN'
				  ,CASE
					   WHEN dbo.fnBuscaClaveMoneda(c.Moneda) IS NULL THEN NULL
					   ELSE ISNULL(c.TipoCambio, NULL)
				   END
			FROM #Movs A
			JOIN CFD c
				ON A.Modulo = C.Modulo
				AND A.ID = C.ModuloID
			JOIN Mov m
				ON m.Modulo = m.Modulo
				AND m.ID = c.ModuloID
				AND m.Empresa = c.Empresa
			JOIN Cont co
				ON co.Empresa = c.Empresa
				AND co.OrigenTipo = c.Modulo
				AND co.Origen = m.Mov
				AND co.OrigenID = m.MovID
			LEFT JOIN ContSATComprobante t
				ON t.Modulo = c.Modulo
				AND t.ModuloID = c.ModuloID
			WHERE c.Modulo = @Modulo
			AND c.ModuloID = @ID
			AND c.Empresa = @Empresa
			AND ISNULL(c.Cancelado, 0) = 0
			AND c.UUID IS NOT NULL
			AND t.ModuloID IS NULL
			EXCEPT
			SELECT Modulo
				  ,ModuloID
				  ,ContID
				  ,ModuloRenglon
				  ,UUID
				  ,Monto
				  ,RFC
				  ,EsCheque
				  ,EsTransferencia
				  ,Moneda
				  ,TipoCambio
			FROM ContSATComprobante
		INSERT ContSATComprobante (Modulo, ModuloID, ContID, ModuloRenglon, UUID, Monto,
		RFC, EsCheque, EsTransferencia, Personal, Moneda, TipoCambio)
			SELECT c.Modulo
				  ,c.ModuloID
				  ,co.ID
				  ,0
				  ,c.UUID
				  ,ISNULL(c.Importe, 0)
				  ,c.RFCReceptor
				  ,0
				  ,0
				  ,c.Personal
				  ,'MXN'
				  ,CASE
					   WHEN dbo.fnBuscaClaveMoneda(c.Moneda) IS NULL THEN NULL
					   ELSE ISNULL(c.TipoCambio, NULL)
				   END
			FROM #Movs A
			JOIN CFDNomina c
				ON A.Modulo = C.Modulo
				AND A.ID = C.ModuloID
			JOIN Mov m
				ON m.Modulo = m.Modulo
				AND m.ID = c.ModuloID
				AND m.Empresa = c.Empresa
			JOIN Cont co
				ON co.Empresa = c.Empresa
				AND co.OrigenTipo = c.Modulo
				AND co.Origen = m.Mov
				AND co.OrigenID = m.MovID
			LEFT JOIN ContSATComprobante t
				ON t.Modulo = c.Modulo
				AND t.ModuloID = c.ModuloID
			WHERE c.Modulo = @Modulo
			AND c.ModuloID = @ID
			AND c.Empresa = @Empresa
			AND c.Personal = @Personal
			AND ISNULL(c.Cancelado, 0) = 0
			AND c.UUID IS NOT NULL
			AND t.ModuloID IS NULL
			EXCEPT
			SELECT Modulo
				  ,ModuloID
				  ,ContID
				  ,ModuloRenglon
				  ,UUID
				  ,Monto
				  ,RFC
				  ,EsCheque
				  ,EsTransferencia
				  ,Personal
				  ,Moneda
				  ,TipoCambio
			FROM ContSATComprobante
	END

	IF @ClaveAfectacion IN ('GAS.AB', 'GAS.CB')
	BEGIN
		INSERT INTO @MovsPosteriores (Modulo, ID)
			SELECT Modulo
				  ,ID
			FROM dbo.fnBuscaMovs(@Modulo, @ID, @Empresa)
		DECLARE
			cMovPosterior
			CURSOR FOR
			SELECT Modulo
				  ,ID
			FROM @MovsPosteriores
		OPEN cMovPosterior
		FETCH NEXT FROM cMovPosterior INTO @cModulo, @cID
		WHILE @@FETCH_STATUS = 0
		BEGIN

		IF @cModulo = 'DIN'
		BEGIN
			EXEC spContSATDineroActualizarCtaDineroRfc @cID
		END

		IF @cModulo = 'CONT'
		BEGIN
			INSERT ContSATComprobante (Modulo, ModuloID, ContID, ModuloRenglon, UUID,
			Monto, RFC, EsCheque, EsTransferencia, Moneda, TipoCambio)
				SELECT B.Modulo
					  ,B.ModuloID
					  ,@cID
					  ,B.ModuloRenglon
					  ,B.UUID
					  ,B.Monto
					  ,B.RFCEmisor
					  ,0
					  ,0
					  ,'MXN'
					  ,CASE
						   WHEN dbo.fnBuscaClaveMoneda(B.Moneda) IS NULL THEN NULL
						   ELSE ISNULL(B.TipoCambio, NULL)
					   END
				FROM dbo.fnBuscaOrigen(@Modulo, @ID, @Empresa) A
				JOIN CFDEgreso B
					ON A.Modulo = B.Modulo
					AND A.ID = B.ModuloID
				WHERE B.UUID IS NOT NULL
				EXCEPT
				SELECT Modulo
					  ,ModuloID
					  ,ContID
					  ,ModuloRenglon
					  ,UUID
					  ,Monto
					  ,RFC
					  ,EsCheque
					  ,EsTransferencia
					  ,Moneda
					  ,TipoCambio
				FROM ContSATComprobante
		END

		FETCH NEXT FROM cMovPosterior INTO @cModulo, @cID
		END
		CLOSE cMovPosterior
		DEALLOCATE cMovPosterior
	END

	IF @AsociaMovAnterior = 1
	BEGIN
		EXEC spAsociacionRetroactiva @Modulo
									,@ID
									,@Empresa
	END

	IF (OBJECT_ID('Tempdb..#Movs')) IS NOT NULL
		DROP TABLE #Movs

	RETURN
END
GO