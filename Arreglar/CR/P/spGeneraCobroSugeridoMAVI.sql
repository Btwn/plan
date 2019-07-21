SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spGeneraCobroSugeridoMAVI]
 @Modulo CHAR(5)
,@ID INT
,@Usuario VARCHAR(10)
,@Estacion INT
AS
BEGIN
	DECLARE
		@Empresa CHAR(5)
	   ,@Sucursal INT
	   ,@Hoy DATETIME
	   ,@Moneda CHAR(10)
	   ,@TipoCambio FLOAT
	   ,@Renglon FLOAT
	   ,@Aplica VARCHAR(20)
	   ,@AplicaID VARCHAR(20)
	   ,@AplicaMovTipo VARCHAR(20)
	   ,@Importe MONEY
	   ,@SumaImporte MONEY
	   ,@Impuestos MONEY
	   ,@DesglosarImpuestos BIT
	   ,@IDDetalle INT
	   ,@IDCxc INT
	   ,@ImporteReal MONEY
	   ,@ImporteAPagar MONEY
	   ,@ImporteMoratorio MONEY
	   ,@ImporteACondonar MONEY
	   ,@MovGenerar VARCHAR(20)
	   ,@UEN INT
	   ,@ImporteTotal MONEY
	   ,@Mov VARCHAR(20)
	   ,@MovID VARCHAR(20)
	   ,@MovPadre VARCHAR(20)
	   ,@Ok INT
	   ,@OkRef VARCHAR(255)
	   ,@Cliente VARCHAR(10)
	   ,@CteMoneda VARCHAR(10)
	   ,@CteTipoCambio FLOAT
	   ,@FechaAplicacion DATETIME
	   ,@ClienteEnviarA INT
	   ,@TotalMov MONEY
	   ,@CampoExtra VARCHAR(50)
	   ,@Consecutivo VARCHAR(20)
	   ,@ValorCampoExtra VARCHAR(255)
	   ,@Concepto VARCHAR(50)
	   ,@MoratorioAPagar MONEY
	   ,@MovIDGen VARCHAR(20)
	   ,@MovCobro VARCHAR(20)
	   ,@GeneraNC CHAR(1)
	   ,@Origen VARCHAR(20)
	   ,@OrigenID VARCHAR(20)
	   ,@Impuesto MONEY
	   ,@DefImpuesto FLOAT
	   ,@ImporteDoc MONEY
	   ,@Bonificacion MONEY
	   ,@MovIDGenerado VARCHAR(20)
	   ,@TotalAPagar MONEY
	   ,@IDCargoMor INT
	   ,@InteresPorPolitica MONEY
	   ,@MovIDCgo VARCHAR(20)
	   ,@IDPadre INT
	   ,@SaldoIniDia MONEY
	   ,@PorcAbonoCapital FLOAT
	   ,@PorcMoratorioBonificar FLOAT
	   ,@TotalMoratorio MONEY
	   ,@MoratorioBonificado MONEY
	   ,@MoratorioXPagar MONEY
	   ,@TotalCobrosDia MONEY
	   ,@PorcIntaBonificar FLOAT
	   ,@PorcPAgoCapital FLOAT
	   ,@Nota VARCHAR(100)
	   ,@CobroxPolitica INT
	   ,@MoratoriosaBonificar MONEY
	   ,@VencimientoMasAntiguo DATETIME
	   ,@IDCargoMorEst INT
	   ,@IdCargoMoratorio INT
	   ,@IdCargoMoratorioEst INT
	   ,@SaldoNCPend MONEY
	   ,@SaldoEstPend MONEY
	   ,@EstatusNCEst VARCHAR(15)
	   ,@EstatusNC VARCHAR(15)
	   ,@IDUltCobro INT
	   ,@TotalMoratUltCob MONEY
	   ,@EstatusCargoMor VARCHAR(15)
	   ,@EstatusCargoMorEst VARCHAR(15)
	   ,@TotalBonificacion MONEY
	   ,@min INT
	   ,@max INT
	   ,@m1 INT
	   ,@m2 INT
	   ,@FechaEmision DATETIME
	   ,@Quincena INT
	   ,@Year INT = YEAR(GETDATE())
	SELECT @Quincena =
	 CASE
		 WHEN DAY(GETDATE()) > 16 THEN MONTH(GETDATE()) * 2
		 ELSE (MONTH(GETDATE()) * 2) - 1
	 END
	SELECT @Quincena =
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
	SET @CobroxPolitica = 0
	SET @FechaAplicacion = GETDATE()
	SELECT @CteMoneda = ClienteMoneda
		  ,@CteTipoCambio = ClienteTipoCambio
		  ,@Cliente = Cliente
	FROM CXC
	WHERE ID = @ID
	SELECT @CobroxPolitica = ISNULL(TipoCobro, 0)
	FROM TipoCobroMAVI
	WHERE IdCobro = @ID
	SELECT @DesglosarImpuestos = 0
		  ,@Renglon = 0.0
		  ,@SumaImporte = 0.0
		  ,@ImporteTotal = NULLIF(@ImporteTotal, 0.0)
	SELECT @Renglon = 1024.0
	SELECT @GeneraNC = '1'

	IF EXISTS (SELECT ID FROM tempdb.sys.sysobjects WHERE id = OBJECT_ID('tempdb.dbo.#crDetalle') AND type = 'U')
		DROP TABLE #crDetalle

	IF EXISTS (SELECT ID FROM tempdb.sys.sysobjects WHERE id = OBJECT_ID('tempdb.dbo.#crDoc') AND type = 'U')
		DROP TABLE #crDoc

	IF NOT EXISTS (SELECT * FROM NegociaMoratoriosMAVI WHERE IDCobro = @ID)
	BEGIN
		SELECT 'No hay sugerencia a cobrar..'
		RETURN
	END

	BEGIN TRANSACTION BonMAVI

	IF @Modulo = 'CXC'
	BEGIN
		UPDATE CXC
		SET AplicaManual = 1
		WHERE id = @ID
		SELECT @Empresa = Empresa
			  ,@Sucursal = Sucursal
			  ,@Hoy = FechaEmision
			  ,@Moneda = Moneda
			  ,@TipoCambio = TipoCambio
			  ,@ClienteEnviarA = ClienteEnviarA
			  ,@MovCobro = Mov
		FROM Cxc
		WHERE ID = @ID
		DELETE CxcD
		WHERE ID = @ID
		DELETE DetalleAfectacionMAVI
		WHERE IDCobro = @ID
		SELECT TOP 1 @ClienteEnviarA = ClienteEnviarA
					,@FechaEmision = FechaEmision
		FROM Cxc C
		INNER JOIN NegociaMoratoriosMAVI N
			ON C.Mov = N.Mov
			AND C.MovID = N.MovID
		WHERE N.IDCobro = @ID
		EXEC spGeneraNCredPPMAVI @ID
								,@Usuario
								,@Ok OUTPUT
								,@OkRef OUTPUT

		IF @Ok IS NULL
			AND (@ClienteEnviarA NOT IN (3, 4, 7, 11) OR @FechaEmision BETWEEN '2014-05-01' AND '2014-07-10')
			EXEC spGeneraNCredAPMAVI @ID
									,@Usuario
									,@Ok OUTPUT
									,@OkRef OUTPUT

		IF @Ok IS NULL
			AND @ClienteEnviarA = 7
			EXEC spGeneraNCredBonifMAVI @ID
									   ,@Usuario
									   ,@Ok OUTPUT
									   ,@OkRef OUTPUT

		IF @Ok IS NULL
		BEGIN
			SELECT SUM(ISNULL(MoratorioAPagar, 0) - ISNULL(ImporteACondonar, 0)) ImporteMoratorio
				  ,Origen
				  ,OrigenID
				  ,ROW_NUMBER() OVER (ORDER BY OrigenID) Id
			INTO #crDetalle
			FROM NegociaMoratoriosMAVI
			WHERE IDCobro = @ID
			AND Estacion = @Estacion
			AND MoratorioAPagar > 0
			GROUP BY Origen
					,OrigenID
			SELECT @min = MIN(id)
				  ,@max = MAX(Id)
			FROM #CrDetalle
			WHILE @min <= @max
			BEGIN

			IF @OK IS NULL
			BEGIN
				SELECT @Origen = ORIGEN
					  ,@OrigenID = OrigenID
					  ,@ImporteMoratorio = ImporteMoratorio
				FROM #CrDetalle
				WHERE ID = @min
				SELECT @UEN = UEN
					  ,@ClienteEnviarA = ClienteEnviarA
				FROM CXC
				WHERE Mov = @Origen
				AND MovId = @OrigenID

				IF @ImporteMoratorio > 0
				BEGIN
					SELECT @MovGenerar = dbo.fnMaviObtieneMovSaldoMoratorios(@Origen, 'Moratorios', @UEN)

					IF @MovGenerar IS NULL
						SELECT @MovGenerar = 'Nota Cargo'

					IF @MovGenerar = 'Endoso'
						SELECT @MovGenerar = 'Nota Cargo'

					SELECT @DefImpuesto = 1 + ISNULL(DefImpuesto, 15.0) / 100
					FROM EmpresaGral
					WHERE Empresa = @Empresa
					SELECT @Importe = @ImporteMoratorio / @DefImpuesto
					SELECT @Impuesto = @ImporteMoratorio - @Importe

					IF @MovGenerar IN ('Nota Cargo', 'Nota Cargo VIU')
						SELECT @Concepto = 'MORATORIOS MENUDEO'

					IF @MovGenerar = 'Nota Cargo Mayoreo'
						SELECT @Concepto = 'MORATORIOS MAYOREO'

					IF @GeneraNC = '1'
					BEGIN
						INSERT INTO Cxc (Empresa, Mov, MovID, FechaEmision, Concepto, UltimoCambio, Moneda, TipoCambio, Usuario, Referencia,
						Estatus, Cliente, ClienteEnviarA, ClienteMoneda, ClienteTipoCambio, Vencimiento,
						Importe, Impuestos, AplicaManual, ConDesglose, Saldo,
						ConTramites, VIN, Sucursal, SucursalOrigen, UEN, PersonalCobrador, FechaOriginal, Nota,
						Comentarios, LineaCredito, TipoAmortizacion, TipoTasa, Amortizaciones, Comisiones, ComisionesIVA,
						FechaRevision, ContUso, TieneTasaEsp, TasaEsp, Codigo)
							VALUES (@Empresa, @MovGenerar, NULL, dbo.fnFechaSinHora(@FechaAplicacion), @Concepto, @FechaAplicacion, @Moneda, @TipoCambio, @Usuario, NULL, 'SINAFECTAR', @Cliente, @ClienteEnviarA, @Moneda, @TipoCambio, @FechaAplicacion, @Importe, @Impuesto, 0, 0, ISNULL(@Importe, 0) + ISNULL(@Impuesto, 0), 0, NULL, @Sucursal, @Sucursal, @UEN, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL)
						SELECT @IDCxc = SCOPE_IDENTITY()
						EXEC spAfectar 'CXC'
									  ,@IDCxc
									  ,'AFECTAR'
									  ,'Todo'
									  ,NULL
									  ,@Usuario
									  ,NULL
									  ,1
									  ,@Ok OUTPUT
									  ,@OkRef OUTPUT
									  ,NULL
									  ,@Conexion = 1
						INSERT INTO DetalleAfectacionMAVI (IDCobro, ID, Mov, MovID, ValorOK, ValorOKRef)
							VALUES (@ID, @IDCxc, @MovGenerar, @MovIDGen, @Ok, @OkRef)
						UPDATE NegociaMoratoriosMAVI
						SET NotaCargoMorId = @IDCxc
						WHERE IDCobro = @ID
						AND Estacion = @Estacion
						AND MoratorioAPagar > 0
						AND Origen = @Origen
						AND OrigenID = @OrigenId
						SELECT @MovIDGen = MovId
						FROM CXC
						WHERE ID = @IDCxc
						INSERT CxcD (ID, Sucursal, Renglon, Aplica, AplicaID, Importe, InteresesOrdinarios, InteresesMoratorios, ImpuestoAdicional)
							VALUES (@ID, @Sucursal, @Renglon, @MovGenerar, @MovIDGen, NULLIF(@ImporteMoratorio, 0.0), 0.0, 0.0, 0.0)
						SELECT @Renglon = @Renglon + 1024.0

						IF @Ok = 80030
							SELECT @Ok = NULL

						IF @Ok IS NULL
						BEGIN

							IF NOT EXISTS (SELECT * FROM MovCampoExtra WHERE Modulo = @Modulo AND Mov = @MovGenerar AND ID = @IDCxc)
							BEGIN
								SELECT @AplicaId = MovId
								FROM CXC
								WHERE ID = @IDCxc

								IF @MovGenerar = 'Nota Cargo'
									SELECT @CampoExtra = 'NC_FACTURA'

								IF @MovGenerar = 'Nota Cargo VIU'
									SELECT @CampoExtra = 'NCV_FACTURA'

								IF @MovGenerar = 'Nota Cargo Mayoreo'
									SELECT @CampoExtra = 'NCM_FACTURA'

								SELECT @ValorCampoExtra = RTRIM(@Origen) + '_' + RTRIM(@OrigenId)

								IF @MovGenerar IN ('Nota Cargo', 'Nota Cargo VIU', 'Nota Cargo Mayoreo')
									INSERT INTO MovCampoExtra (Modulo, Mov, ID, CampoExtra, Valor)
										VALUES ('CXC', @MovGenerar, @IDCxc, @CampoExtra, @ValorCampoExtra)

							END

						END

					END

				END

			END

			SET @min = @min + 1
			END
			SELECT Mov
				  ,MovID
				  ,ImporteReal
				  ,ImporteAPagar
				  ,ImporteMoratorio
				  ,ImporteACondonar
				  ,Bonificacion
				  ,TotalAPagar
				  ,ROW_NUMBER() OVER (ORDER BY MovID) id
			INTO #crDoc
			FROM NegociaMoratoriosMAVI
			WHERE IDCobro = @ID
			AND Estacion = @Estacion
			AND ImporteAPagar > 0
			SELECT @m1 = MIN(id)
				  ,@m2 = MAX(id)
			FROM #CrDoc
			WHILE @m1 <= @m2
			BEGIN

			IF @OK IS NULL
			BEGIN
				SELECT @Mov = Mov
					  ,@MovID = MovID
					  ,@ImporteReal = ImporteReal
					  ,@ImporteAPagar = ImporteAPagar
					  ,@ImporteMoratorio = ImporteMoratorio
					  ,@ImporteACondonar = ImporteACondonar
					  ,@Bonificacion = Bonificacion
					  ,@TotalAPagar = TotalAPagar
				FROM #CrDoc
				WHERE id = @m1
				SELECT @ImporteDoc = ISNULL(@ImporteAPagar, 0) - ISNULL(@Bonificacion, 0)

				IF @ImporteDoc > 0
				BEGIN
					INSERT CxcD (ID, Sucursal, Renglon, Aplica, AplicaID, Importe, InteresesOrdinarios, InteresesMoratorios, ImpuestoAdicional)
						VALUES (@ID, @Sucursal, @Renglon, @Mov, @MovID, NULLIF(@ImporteDoc, 0.0), 0.0, 0.0, 0.0)
					SELECT @Renglon = @Renglon + 1024.0
				END

			END

			SET @m1 = @m1 + 1
			END

			IF @CobroxPolitica = 1
			BEGIN
				UPDATE CXC
				SET Concepto = 'POLITICA QUITA MORATORIOS'
				WHERE ID = @ID
				SELECT @InteresPorPolitica = MIN(InteresPorPolitica)
				FROM NegociaMoratoriosMAVI
				WHERE IDCobro = @ID
				AND InteresPorPolitica > 0
				SELECT @Origen = Origen
					  ,@OrigenID = OrigenID
				FROM NegociaMoratoriosMAVI
				WHERE IDCobro = @ID
				GROUP BY Origen
						,OrigenID
				SELECT @IDPadre = ID
					  ,@UEN = UEN
					  ,@ClienteEnviarA = ClienteEnviarA
				FROM CXC
				WHERE Mov = @Origen
				AND MovID = @OrigenID
				SELECT @ImporteTotal = SUM(ISNULL(ImporteAPagar, 0))
				FROM NegociaMoratoriosMAVI
				WHERE IDCobro = @ID

				IF NOT EXISTS (SELECT * FROM CobroXPoliticaHistMAVI WHERE Mov = @Origen AND MovID = @OrigenID AND CONVERT(VARCHAR(8), FechaEmision, 112) = CONVERT(VARCHAR(8), @FechaAplicacion, 112) AND EstatusCobro = 'CONCLUIDO')
				BEGIN
					SET @TotalBonificacion = 0
					SELECT @TotalBonificacion = SUM(ISNULL(Bonificacion, 0))
					FROM NegociaMoratoriosMAVI
					WHERE IDCobro = @ID
					SELECT @SaldoIniDia = dbo.fnSaldoPMMAVI(@IDPadre) + ISNULL(@TotalBonificacion, 0)
					SELECT @TotalCobrosDia = @ImporteTotal
				END
				ELSE
				BEGIN
					SELECT TOP 1 @SaldoIniDia = SaldoInicioDelDia
					FROM CobroXPoliticaHistMAVI
					WHERE Mov = @Origen
					AND MovID = @OrigenID
					AND CONVERT(VARCHAR(8), FechaEmision, 112) = CONVERT(VARCHAR(8), @FechaAplicacion, 112)
					AND EstatusCobro = 'CONCLUIDO'
					ORDER BY IDCobro ASC
					SELECT @TotalCobrosDia = SUM(ImporteCobro) + ISNULL(@ImporteTotal, 0)
					FROM CobroXPoliticaHistMAVI
					WHERE Mov = @Origen
					AND MovID = @OrigenID
					AND CONVERT(VARCHAR(8), FechaEmision, 112) = CONVERT(VARCHAR(8), @FechaAplicacion, 112)
					AND EstatusCobro = 'CONCLUIDO'
					SELECT @IdCargoMoratorioEst = 0
					SELECT TOP 1 @IDUltCobro = idCobro
								,@PorcMoratorioBonificar = PorcMoratorioBonificar
								,@IdCargoMoratorioEst = IdCargoMoratorioEst
								,@TotalMoratUltCob = TotalMoratorio
					FROM CobroXPoliticaHistMAVI
					WHERE Mov = @Origen
					AND MovID = @OrigenID
					AND CONVERT(VARCHAR(8), FechaEmision, 112) = CONVERT(VARCHAR(8), @FechaAplicacion, 112)
					AND EstatusCobro = 'CONCLUIDO'
					ORDER BY IDCobro DESC
					SELECT @InteresPorPolitica = @TotalMoratUltCob

					IF @PorcMoratorioBonificar <= 100
					BEGIN
						SELECT @SaldoEstPend = ISNULL(Importe, 0) + ISNULL(Impuestos, 0)
							  ,@EstatusNCEst = Estatus
						FROM CXC
						WHERE ID = @IdCargoMoratorioEst

						IF @IdCargoMoratorioEst > 0
						BEGIN
							EXEC spAfectar 'CXC'
										  ,@IdCargoMoratorioEst
										  ,'CANCELAR'
										  ,'Todo'
										  ,NULL
										  ,@Usuario
										  ,NULL
										  ,1
										  ,@Ok OUTPUT
										  ,@OkRef OUTPUT
										  ,NULL
										  ,@Conexion = 1
							UPDATE CobroxPoliticaHistMAVI
							SET EstatusCargoMorEst = 'CANCELADO'
							WHERE IdCargoMoratorioEst = @IdCargoMoratorioEst
						END

					END

				END

				IF @SaldoIniDia > 0
					SELECT @PorcAbonoCapital = (@TotalCobrosDia / @SaldoIniDia) * 100.0

				SELECT @PorcIntaBonificar = 0
				SELECT TOP 1 @PorcIntaBonificar = ISNULL(CON.PorcDeBonificacionDeInteres, 0)
				FROM dbo.TcIRM0906_ConfigDivisionYParam CON
				INNER JOIN dbo.MaviRecuperacion MA
					ON ISNULL(CON.Division, '') = ISNULL(MA.Division, '')
				WHERE MA.CLIENTE = @CLIENTE
				AND MA.Ejercicio = @Year
				AND MA.QUINCENA = @Quincena
				AND @PorcAbonoCapital >= con.PorcdeAbonoFinal
				ORDER BY CON.PorcDeBonificacionDeInteres DESC
				SELECT @Nota = NULL

				IF @PorcIntaBonificar > 0.0
				BEGIN
					SELECT @PorcMoratorioBonificar = ISNULL(@InteresPorPolitica, 0) - (ISNULL(@InteresPorPolitica, 0) * (ISNULL(@PorcIntaBonificar, 0) / 100.0))
					SELECT @MoratorioXPagar = @PorcMoratorioBonificar
					SELECT @MoratoriosaBonificar = ISNULL(@InteresPorPolitica, 0) - ISNULL(@PorcMoratorioBonificar, 0)
					SELECT @Nota = 'IM Bonificado:' + CONVERT(VARCHAR(20), @MoratoriosaBonificar)
				END
				ELSE
				BEGIN
					UPDATE NegociaMoratoriosMAVI
					SET InteresAPAgarConPolitica = 0
					WHERE IDCobro = @ID
					SELECT @Nota = 'IM Bonificado: 0'
					SELECT @MoratoriosaBonificar = 0
					SELECT @MoratorioXPagar = ISNULL(@InteresPorPolitica, 0) - ISNULL(@PorcMoratorioBonificar, 0)
				END

				SELECT @EstatusCargoMorEst = NULL

				IF @InteresPorPolitica > 0
					AND @PorcIntaBonificar > 0
					AND @PorcIntaBonificar <= 100
				BEGIN
					SELECT @EstatusCargoMorEst = 'CONCLUIDO'
					INSERT INTO Cxc (Empresa, Mov, MovID, FechaEmision, Concepto, UltimoCambio, Moneda, TipoCambio, Usuario, Referencia,
					Estatus, Cliente, ClienteEnviarA, ClienteMoneda, ClienteTipoCambio, Condicion, Vencimiento,
					Importe, Impuestos, AplicaManual, ConDesglose, Saldo,
					ConTramites, VIN, Sucursal, SucursalOrigen, UEN, PersonalCobrador, FechaOriginal, Nota,
					Comentarios, LineaCredito, TipoAmortizacion, TipoTasa, Amortizaciones, Comisiones, ComisionesIVA,
					FechaRevision, ContUso, TieneTasaEsp, TasaEsp, Codigo, PadreMAVI, PadreIDMAVI, IDPadreMAVI)
						VALUES (@Empresa, 'Cargo Moratorio Est', NULL, @FechaAplicacion, @Concepto, @FechaAplicacion, @Moneda, @TipoCambio, @Usuario, NULL, 'SINAFECTAR', @Cliente, @ClienteEnviarA, @Moneda, @TipoCambio, '(Fecha)', @FechaAplicacion, @MoratoriosaBonificar, @Impuesto, 0, 0, ISNULL(@MoratoriosaBonificar, 0) + ISNULL(@Impuesto, 0), 0, NULL, @Sucursal, @Sucursal, @UEN, NULL, NULL, @Nota, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, 'Cargo Moratorio Est', NULL, @IDPadre)
					SELECT @IDCargoMorEst = @@IDENTITY
					EXEC spAfectar 'CXC'
								  ,@IDCargoMorEst
								  ,'AFECTAR'
								  ,'Todo'
								  ,NULL
								  ,@Usuario
								  ,NULL
								  ,1
								  ,@Ok OUTPUT
								  ,@OkRef OUTPUT
								  ,NULL
								  ,@Conexion = 1
					SELECT @MovIDCgo = MovId
					FROM CXC
					WHERE ID = @IDCargoMorEst
					UPDATE Cxc
					SET PadreIDMAVI = @MovIDCgo
					WHERE ID = @IDCargoMorEst
					INSERT INTO DetalleAfectacionMAVI (IDCobro, ID, Mov, MovID, ValorOK, ValorOKRef)
						VALUES (@ID, @IDCargoMorEst, 'Cargo Moratorio Est', @MovIDGen, @Ok, @OkRef)

					IF NOT EXISTS (SELECT * FROM MovCampoExtra WHERE Modulo = @Modulo AND Mov = 'Cargo Moratorio Est' AND ID = @IDCargoMorEst)
					BEGIN
						SELECT @CampoExtra = 'CM_FACTURA'
						SELECT @ValorCampoExtra = RTRIM(@Origen) + '_' + RTRIM(@OrigenId)
						INSERT INTO MovCampoExtra (Modulo, Mov, ID, CampoExtra, Valor)
							VALUES ('CXC', 'Cargo Moratorio Est', @IDCargoMorEst, @CampoExtra, @ValorCampoExtra)
					END

					SELECT @VencimientoMasAntiguo = MIN(Vencimiento)
					FROM Cxc
					WHERE PadreMAVI = @Origen
					AND PadreIDMAVI = @OrigenID
					AND Estatus = 'PENDIENTE'

					IF @VencimientoMasAntiguo IS NULL
						SELECT @VencimientoMasAntiguo = @FechaAplicacion

				END

				INSERT INTO CobroXPoliticaHistMAVI (IdCobro, FechaEmision, EstatusCobro, ImporteCobro, Cliente, Mov, MovID,
				SaldoIniciodelDia, TotalCobrosdelDia, PorcAbonoCapital, PorcMoratorioBonificar, TotalMoratorio, MoratorioBonificado,
				MoratorioXPagar, IdCargoMoratorioEst, EstatusCargoMorEst)
					VALUES (@ID, @FechaAplicacion, 'SINAFECTAR', @ImporteTotal, @Cliente, @Origen, @OrigenID, @SaldoIniDia, @TotalCobrosDia, @PorcAbonoCapital, @PorcIntaBonificar, @InteresPorPolitica, ISNULL(@MoratoriosaBonificar, 0), ISNULL(@MoratorioXPagar, 0), ISNULL(@IDCargoMorEst, 0), @EstatusCargoMorEst)
			END

			SELECT @Impuestos = SUM(d.importe * ISNULL(ca.IVAFiscal, 0))
			FROM CXCD d
			JOIN CxcAplica ca
				ON d.Aplica = ca.Mov
				AND d.AplicaID = ca.MovID
				AND ca.Empresa = @Empresa
			WHERE d.ID = @ID
			SELECT @TotalMov = SUM(d.Importe - ISNULL(d.Importe * ca.IVAFiscal, 0))
			FROM CXCD d
			JOIN CxcAplica ca
				ON d.Aplica = ca.Mov
				AND d.AplicaID = ca.MovID
				AND ca.Empresa = @Empresa
			WHERE d.ID = @ID
			UPDATE CXC
			SET Importe = ISNULL(ROUND(@TotalMov, 2), 0.00)
			   ,Impuestos = ISNULL(ROUND(@Impuestos, 2), 0.00)
			   ,Saldo = ISNULL(ROUND(@TotalMov, 2), 0.00) + ISNULL(ROUND(@impuestos, 2), 0.00)
			WHERE ID = @ID
			EXEC spAfectar 'CXC'
						  ,@ID
						  ,'AFECTAR'
						  ,'Todo'
						  ,NULL
						  ,@Usuario
						  ,NULL
						  ,1
						  ,@Ok OUTPUT
						  ,@OkRef OUTPUT
						  ,NULL
						  ,@Conexion = 1
			SELECT @MovIDGenerado = MovID
			FROM CXC
			WHERE ID = @ID
			UPDATE CXC
			SET Referencia = RTRIM(@MovCobro) + '_' + RTRIM(@MovIDGenerado)
			WHERE IDCobroBonifMAVI = @ID

			IF @IDCargoMorEst > 0
				UPDATE CXC
				SET Referencia = RTRIM(@MovCobro) + '_' + RTRIM(@MovIDGenerado)
				WHERE ID = @IDCargoMorEst

		END

		IF @Ok IS NULL
			OR @Ok = 80030
		BEGIN
			COMMIT TRANSACTION BonMAVI
			SELECT 'Proceso concluido..'
		END
		ELSE
		BEGIN
			SELECT @OkRef = Descripcion
			FROM MensajeLista
			WHERE Mensaje = @Ok
			ROLLBACK TRANSACTION BonMAVI
			SELECT @OkRef
		END

		RETURN
	END

	IF EXISTS (SELECT ID FROM tempdb.sys.sysobjects WHERE id = OBJECT_ID('tempdb.dbo.#crDetalle') AND type = 'U')
		DROP TABLE #crDetalle

	IF EXISTS (SELECT ID FROM tempdb.sys.sysobjects WHERE id = OBJECT_ID('tempdb.dbo.#crDoc') AND type = 'U')
		DROP TABLE #crDoc

END

