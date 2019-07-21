SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[xpMovFinal]
 @Empresa CHAR(5)
,@Sucursal INT
,@Modulo CHAR(5)
,@ID INT
,@Estatus CHAR(15)
,@EstatusNuevo CHAR(15)
,@Usuario VARCHAR(10)
,@FechaEmision DATETIME
,@FechaRegistro DATETIME
,@Mov CHAR(20)
,@MovID VARCHAR(20)
,@MovTipo CHAR(20)
,@IDGenerar INT
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
AS
BEGIN
	DECLARE
		@Concepto VARCHAR(50)
	   ,@AFArticulo VARCHAR(20)
	   ,@AFSerie VARCHAR(20)
	   ,@Lectura INT
	   ,@Control INT
	   ,@AutorizarGasto INT
	   ,@Articulo VARCHAR(20)
	   ,@Origen CHAR(20)
	   ,@OrigenID CHAR(20)
	   ,@IDOrigen CHAR(20)
	   ,@DMov VARCHAR(20)
	   ,@DmovID VARCHAR(20)
	   ,@OID INT
	   ,@IDCxc INT
	   ,@IDNCCxc INT
	   ,@IDCxcPend INT
	   ,@IDCxcPendNC INT
	   ,@IDDestino INT
	   ,@Mensaje VARCHAR(255)
	   ,@MovSaldar VARCHAR(20)
	   ,@Cliente VARCHAR(10)
	   ,@Moneda VARCHAR(10)
	   ,@CteMoneda VARCHAR(10)
	   ,@TipoCambio FLOAT
	   ,@CteTipoCambio FLOAT
	   ,@Renglon FLOAT
	   ,@RenglonSub INT
	   ,@CondPago VARCHAR(50)
	   ,@IVA MONEY
	   ,@UEN INT
	   ,@CteEnviarA INT
	   ,@IDD INT
	   ,@Clave VARCHAR(20)
	   ,@Aplica VARCHAR(20)
	   ,@AplicaID VARCHAR(20)
	   ,@Observaciones VARCHAR(100)
	   ,@FechaActual DATETIME
	   ,@Importe MONEY
	   ,@ImporteInteres MONEY
	   ,@InteresesMoratorios MONEY
	   ,@CargoxMoratorioMavi MONEY
	   ,@TotalInteresMoratorio MONEY
	   ,@MovMor VARCHAR(20)
	   ,@ValorCampoExtra VARCHAR(255)
	   ,@ImporteMoratorio MONEY
	   ,@MoratorioAPagar MONEY
	   ,@PendienteMoratorios MONEY
	   ,@ImporteACondonar MONEY
	   ,@FinMovMor INT
	   ,@FinCadenaMovMor INT
	   ,@IDMovMor INT
	   ,@IDNCMor INT
	   ,@MovMorId VARCHAR(20)
	   ,@IDDoc INT
	   ,@UsuarioCondona VARCHAR(10)
	   ,@MontoMinimoMor FLOAT
	   ,@FechaOriginal DATETIME
	   ,@Remanente MONEY
	   ,@IDNCBon INT
	   ,@FechaOriginalAnt DATETIME
	   ,@InteresMoratorioAnt MONEY
	   ,@MasCobrosMor INT
	   ,@FechaAnterior DATETIME
	   ,@RemananteAnt MONEY
	   ,@IDMAx INT
	   ,@CondxSist INT
	   ,@TipoCondonacion VARCHAR(25)
	   ,@FechaOrigAnt DATETIME
	   ,@InteresesMoratoriosAnt MONEY
	   ,@IDFActCXC INT
	   ,@Subclave VARCHAR(20)
	   ,@MovPadre VARCHAR(20)
	   ,@MovIDPadre VARCHAR(20)
	   ,@IDPadre INT
	   ,@CxcID INT
	   ,@FechaAplicacion DATETIME
	   ,@IDCobro INT
	   ,@HayNCA INT
	   ,@TipoCobro INT
	   ,@IdCargoMoratorio INT
	   ,@Padre VARCHAR(20)
	   ,@PadreID VARCHAR(20)
	   ,@IdCargoMoratorioEst INT
	   ,@IdCobroCargoMoratorioEstAnt INT
	   ,@IDCargoMoratorioEstAnt INT
	   ,@Vencimiento DATETIME
	   ,@PorcMoratorioBonificar FLOAT
	   ,@MoratorioXPagar MONEY
	   ,@RemanenteNvo MONEY
	   ,@DocMasAntiguo INT
	   ,@FechaAntigua DATETIME
	   ,@IDDocPendiente INT
	   ,@MovDocV VARCHAR(20)
	   ,@MovIDDocV VARCHAR(20)
	   ,@Estadistico INT
	   ,@MovTipoCFDFlex BIT
	   ,@CFDFlex BIT
	   ,@eDoc BIT
	   ,@XML VARCHAR(MAX)
	   ,@eDocOk INT
	   ,@eDocOkRef VARCHAR(255)
	   ,@NoPadres INT
	   ,@IDPadreMAVI INT
	   ,@PadreMAVI VARCHAR(20)
	   ,@PadreIDMAVI VARCHAR(20)
	   ,@AplicaManual INT
	   ,@NoParcialidad INT
	   ,@Condicion VARCHAR(20)
	   ,@dAplica VARCHAR(20)
	   ,@dAplicaID VARCHAR(20)
	SET @FechaAplicacion = GETDATE()
	SET @FechaAplicacion = CONVERT(VARCHAR(8), @FechaAplicacion, 112)
	SELECT @AutorizarGasto = AutorizarGasto
	FROM Usuario
	WHERE Usuario = @Usuario

	IF @EstatusNuevo IN ('PENDIENTE', 'CONCLUIDO', 'PROCESAR')
		AND @Ok IS NULL
		EXEC spReconstruirMovImpuesto @Modulo
									 ,@ID

	IF @Modulo = 'GAS'
		AND UPPER(@Mov) IN ('Gasto', 'Solicitud')
		AND @AutorizarGasto = 0
	BEGIN
		SELECT d.Concepto
			  ,d.AFArticulo
			  ,d.AFSerie
			  ,0 ID
		INTO #Paso1
		FROM Gasto g
		JOIN GastoD d
			ON d.ID = g.ID
		WHERE MovID = @MovID
		AND g.AF = 1
		AND g.ID = @ID
		SELECT d.Concepto
			  ,d.AFArticulo
			  ,d.AFSerie
			  ,MAX(ISNULL(d.ID, 0)) ID
		INTO #Paso1A
		FROM GastoD d
		JOIN Gasto g
			ON g.ID = d.ID
		JOIN #Paso1 p
			ON p.Concepto = d.Concepto
			AND p.AFArticulo = d.AFArticulo
			AND p.AFSerie = d.AFSerie
		WHERE g.MovID <> @MovID
		AND g.Estatus = 'CONCLUIDO'
		GROUP BY d.Concepto
				,d.AFArticulo
				,d.AFSerie
		UPDATE #Paso1
		SET #Paso1.ID = #Paso1A.ID
		FROM #Paso1A
		WHERE #Paso1.Concepto = #Paso1A.Concepto
		AND #Paso1.AFArticulo = #Paso1A.AFArticulo
		AND #Paso1.AFSerie = #Paso1A.AFSerie
		DROP TABLE #Paso1A
		SELECT d.Concepto
			  ,d.AFArticulo
			  ,d.AFSerie
			  ,MAX(ISNULL(Lectura, 0)) Lectura
		INTO #Paso2
		FROM GastoD d
		JOIN Gasto g
			ON g.ID = d.ID
		JOIN #Paso1 p
			ON p.Concepto = d.Concepto
			AND p.AFArticulo = d.AFArticulo
			AND p.AFSerie = d.AFSerie
			AND p.ID = d.ID
		WHERE g.MovID <> @MovID
		GROUP BY d.Concepto
				,d.AFArticulo
				,d.AFSerie
		DROP TABLE #Paso1
		DECLARE
			crMAVILectura
			CURSOR FOR
			SELECT Concepto
				  ,AFArticulo
				  ,AFSerie
				  ,Lectura
			FROM #Paso2
		OPEN crMAVILectura
		FETCH NEXT FROM crMAVILectura INTO @Concepto, @AFArticulo, @AFSerie, @Lectura
		WHILE @@FETCH_STATUS = 0
		AND @Ok IS NULL
		BEGIN
		SELECT @Control = COUNT(0)
		FROM Gasto g
		JOIN GastoD d
			ON d.ID = g.ID
		WHERE d.Concepto = @Concepto
		AND d.AFArticulo = @AFArticulo
		AND d.AFSerie = @AFSerie
		AND d.Lectura < @Lectura
		AND g.MovID = @MovID

		IF @Control > 0
			SELECT @Ok = 5000
				  ,@OkRef = 'La lectura del concepto ' + LTRIM(RTRIM(@Concepto)) + ' para el ' + RTRIM(LTRIM(@AFSerie))
				   + ' es incorrecta'

		FETCH NEXT FROM crMAVILectura INTO @Concepto, @AFArticulo, @AFSerie, @Lectura
		END
		CLOSE crMAVILectura
		DEALLOCATE crMAVILectura
	END

	IF @Modulo = 'VTAS'
		AND @MovTipo = 'VTAS.F'
		AND @EstatusNuevo = 'CONCLUIDO'
		UPDATE a
		SET UltimoMov = RTRIM(@MovID) + ' ' + RTRIM(@Mov)
		   ,FechaUltimoMov = GETDATE()
		FROM Art a
		JOIN VentaD d
			ON a.Articulo = d.Articulo
		WHERE d.ID = @ID

	IF @Modulo = 'COMS'
		AND @MovTipo IN ('COMS.O', 'COMS.OI', 'COMS.OG')
		AND @EstatusNuevo = 'PENDIENTE'
		UPDATE a
		SET UltimoMov = RTRIM(@MovID) + ' ' + RTRIM(@Mov)
		   ,FechaUltimoMov = GETDATE()
		FROM Art a
		JOIN CompraD d
			ON a.Articulo = d.Articulo
		WHERE d.ID = @ID

	IF @Modulo = 'CXC'
		AND @Mov = 'Sol Refinanciamiento'
		AND @Estatus = 'SINAFECTAR'
		AND @EstatusNuevo = 'CONCLUIDO'
		UPDATE Cxc
		SET Estatus = 'PENDIENTE'
		WHERE ID = @ID
		AND Mov = 'Sol Refinanciamiento'

	IF @Modulo = 'CXC'
		AND @Mov = 'Refinanciamiento'
		AND @Estatus = 'SINAFECTAR'
		AND @EstatusNuevo IN ('PENDIENTE', 'CONCLUIDO')
	BEGIN
		SELECT @Cliente = Cliente
			  ,@Origen = Origen
			  ,@OrigenID = OrigenID
		FROM Cxc
		WHERE ID = @ID
		SELECT @OID = dbo.fnIDDelMovimientoMAVI(@Origen, @OrigenID)
		SELECT @Concepto = 'REFINANCIAMIENTO'

		IF EXISTS (SELECT ID FROM Cxc WHERE ID = @OID)
		BEGIN
			INSERT INTO MovFlujo
				VALUES (@Sucursal, @Empresa, @Modulo, @OID, @Origen, @OrigenID, @Modulo, @ID, @Mov, @MovID, 0)
			UPDATE Cxc
			SET Estatus = 'CONCLUIDO'
			WHERE ID = @OID
			AND Mov = 'Sol Refinanciamiento'
			DECLARE
				crRefinanciamientos
				CURSOR FOR
				SELECT Aplica
					  ,AplicaID
					  ,IDOrigen
				FROM MaviRefinaciamientos
				WHERE ID = @OID
				ORDER BY ID DESC
			OPEN crRefinanciamientos
			FETCH NEXT FROM crRefinanciamientos INTO @Aplica, @AplicaID, @IDOrigen
			WHILE @@FETCH_STATUS = 0
			BEGIN
			CREATE TABLE #DocPendtes (
				IDDoc INT NULL
			)
			CREATE TABLE #NCACobro (
				IDNota INT NULL
			   ,Saldo MONEY NULL
			   ,IVAFiscal MONEY NULL
			)
			INSERT #DocPendtes (IDDoc)
				SELECT ID
				FROM Cxc
				WHERE OrigenID = @AplicaID
				AND Origen = @Aplica
				AND Mov = 'Documento'
				AND Estatus = 'PENDIENTE'
			SELECT @HayNCA = ISNULL(COUNT(mov), 0)
			FROM Cxc
			WHERE PadreIDMAVI = @AplicaID
			AND PadreMAVI = @Aplica
			AND Estatus = 'PENDIENTE'
			AND Mov IN ('Nota Cargo')
			AND Concepto IN ('CANC COBRO FACTURA', 'CANC COBRO CRED Y PP')

			IF @HayNCA <> 0
				AND @Aplica <> 'Credilana'
			BEGIN
				INSERT #DocPendtes (IDDoc)
					SELECT ID
					FROM Cxc
					WHERE PadreIDMAVI = @AplicaID
					AND PadreMAVI = @Aplica
					AND Estatus = 'PENDIENTE'
					AND Mov IN ('Nota Cargo')
					AND Concepto IN ('CANC COBRO FACTURA', 'CANC COBRO CRED Y PP')
			END

			IF @HayNCA <> 0
				AND @Aplica = 'Credilana'
			BEGIN
				INSERT #NCACobro (IDNota, Saldo, IVAFiscal)
					SELECT ID
						  ,Saldo
						  ,IVAFiscal
					FROM Cxc
					WHERE PadreIDMAVI = @AplicaID
					AND PadreMAVI = @Aplica
					AND Estatus = 'PENDIENTE'
					AND Mov IN ('Nota Cargo')
					AND Concepto IN ('CANC COBRO FACTURA', 'CANC COBRO CRED Y PP')
			END

			IF @Aplica = 'Credilana'
				AND @HayNCA <> 0
			BEGIN
				SELECT @Moneda = NULL
					  ,@TipoCambio = NULL
					  ,@CteMoneda = NULL
					  ,@CteTipoCambio = NULL
					  ,@Importe = 0
					  ,@IVA = 0
					  ,@UEN = NULL
					  ,@CteEnviarA = NULL
				SELECT @MovSaldar = 'Nota Credito'
				SELECT @UEN = UEN
					  ,@CteEnviarA = ClienteEnviarA
					  ,@Moneda = C.Moneda
					  ,@TipoCambio = C.TipoCambio
					  ,@CteMoneda = C.ClienteMoneda
					  ,@CteTipoCambio = C.ClienteTipoCambio
				FROM Cxc C
				WHERE C.ID = @IDOrigen
				SELECT @Importe = SUM(ISNULL(Saldo, 0))
					  ,@IVA = SUM((ISNULL(Saldo, 0.0) * ISNULL(IVAFiscal, 0)))
				FROM #NCACobro
				INSERT INTO Cxc (Empresa, Mov, UEN, ClienteEnviarA, Importe, Impuestos, FechaEmision, UltimoCambio, Moneda, TipoCambio, Usuario, Estatus, Cliente, ClienteMoneda, ClienteTipoCambio, Vencimiento, AplicaManual, GenerarPoliza, Ejercicio, Periodo,
				FechaRegistro, FechaConclusion, Sucursal, FechaOriginal, FechaRevision, SucursalOrigen, Concepto)
					VALUES (@Empresa, @MovSaldar, @UEN, @CteEnviarA, (@Importe - @IVA), @IVA, CAST(CONVERT(VARCHAR, GETDATE(), 101) AS DATETIME), GETDATE(), @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', @Cliente, @CteMoneda, @CteTipoCambio, GETDATE(), 1, 1, DATEPART(yy, GETDATE()), DATEPART(mm, GETDATE()), GETDATE(), GETDATE(), @Sucursal, GETDATE(), GETDATE(), @Sucursal, @Concepto)
				SELECT @IDNCCxc = @@Identity
				SELECT @Renglon = 1024
					  ,@RenglonSub = 0
				INSERT INTO RefinIDInvolucra (ID, IDCxc)
					VALUES (@ID, @IDNCCxc)
				DECLARE
					crCxcDNC
					CURSOR FOR
					SELECT IDNota
					FROM #NCACobro
					ORDER BY IDNota ASC
				OPEN crCxcDNC
				FETCH NEXT FROM crCxcDNC INTO @IDCxcPendNC
				WHILE @@FETCH_STATUS = 0
				BEGIN
				INSERT INTO CxcD (ID, Renglon, RenglonSub, Importe, Aplica, AplicaID, Sucursal, SucursalOrigen)
					SELECT @IDNCCxc
						  ,@Renglon
						  ,@RenglonSub
						  ,Saldo
						  ,Mov
						  ,MovID
						  ,Sucursal
						  ,Sucursal
					FROM Cxc
					WHERE ID = @IDCxcPendNC
				SELECT @Renglon = @Renglon + 1024
				FETCH NEXT FROM crCxcDNC INTO @IDCxcPendNC
				END
				CLOSE crCxcDNC
				DEALLOCATE crCxcDNC
				EXEC spAfectar 'CXC'
							  ,@IDNCCxc
							  ,'AFECTAR'
							  ,@EnSilencio = 1
							  ,@Conexion = 1
							  ,@Ok = @Ok OUTPUT
							  ,@OkRef = @Okref OUTPUT

				IF @Ok = 80030
					SELECT @Ok = NULL

				IF @Ok = NULL
				BEGIN
					SELECT @DMov = MovID
					FROM Cxc
					WHERE ID = @IDNCCxc
					INSERT INTO MovFlujo
						VALUES (@Sucursal, @Empresa, @Modulo, @ID, @Mov, @MovID, @Modulo, @IDNCCxc, @MovSaldar, @DMov, 0)
				END

			END

			SELECT @Moneda = NULL
				  ,@TipoCambio = NULL
				  ,@CteMoneda = NULL
				  ,@CteTipoCambio = NULL
				  ,@Importe = 0
				  ,@IVA = 0
				  ,@UEN = NULL
				  ,@CteEnviarA = NULL
			SELECT @MovSaldar = dbo.fnMaviObtieneMovSaldo(@Aplica, 'REFINANCIAMIENTO')
			SELECT @UEN = UEN
				  ,@CteEnviarA = ClienteEnviarA
				  ,@Moneda = C.Moneda
				  ,@TipoCambio = C.TipoCambio
				  ,@CteMoneda = C.ClienteMoneda
				  ,@CteTipoCambio = C.ClienteTipoCambio
				  ,@Importe = dbo.fnSaldoPendienteMovPadreMAVI(C.ID)
				  ,@IVA = dbo.fnIVAPendienteMovPadreMAVI(C.ID)
			FROM Cxc C
			WHERE C.ID = @IDOrigen
			INSERT INTO Cxc (Empresa, Mov, UEN, ClienteEnviarA, Importe, Impuestos, FechaEmision, UltimoCambio, Moneda, TipoCambio, Usuario, Estatus, Cliente, ClienteMoneda, ClienteTipoCambio, Vencimiento, AplicaManual, GenerarPoliza, Ejercicio, Periodo,
			FechaRegistro, FechaConclusion, Sucursal, FechaOriginal, FechaRevision, SucursalOrigen, Concepto)
				VALUES (@Empresa, @MovSaldar, @UEN, @CteEnviarA, (@Importe - @IVA), @IVA, CAST(CONVERT(VARCHAR, GETDATE(), 101) AS DATETIME), GETDATE(), @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', @Cliente, @CteMoneda, @CteTipoCambio, GETDATE(), 1, 1, DATEPART(yy, GETDATE()), DATEPART(mm, GETDATE()), GETDATE(), GETDATE(), @Sucursal, GETDATE(), GETDATE(), @Sucursal, @Concepto)
			SELECT @IDCxc = @@Identity
			SELECT @Renglon = 1024
				  ,@RenglonSub = 0
			INSERT INTO RefinIDInvolucra (ID, IDCxc)
				VALUES (@ID, @IDCxc)

			IF ((
					SELECT Estatus
					FROM Cxc
					WHERE ID = @IDOrigen
				)
				= 'PENDIENTE')
			BEGIN
				DECLARE
					crCxcD
					CURSOR FOR
					SELECT ID
					FROM Cxc
					WHERE MovID = @AplicaID
					AND Mov = @Aplica
					ORDER BY ID ASC
			END
			ELSE
			BEGIN
				DECLARE
					crCxcD
					CURSOR FOR
					SELECT IDDoc
					FROM #DocPendtes
					ORDER BY IDDoc ASC
			END

			OPEN crCxcD
			FETCH NEXT FROM crCxcD INTO @IDCxcPend
			WHILE @@FETCH_STATUS = 0
			BEGIN
			INSERT INTO CxcD (ID, Renglon, RenglonSub, Importe, Aplica, AplicaID, Sucursal, SucursalOrigen)
				SELECT @IDCxc
					  ,@Renglon
					  ,@RenglonSub
					  ,Saldo
					  ,Mov
					  ,MovID
					  ,Sucursal
					  ,Sucursal
				FROM Cxc
				WHERE ID = @IDCxcPend
			SELECT @Renglon = @Renglon + 1024
			FETCH NEXT FROM crCxcD INTO @IDCxcPend
			END
			CLOSE crCxcD
			DEALLOCATE crCxcD
			EXEC spAfectar 'CXC'
						  ,@IDCxc
						  ,'AFECTAR'
						  ,@EnSilencio = 1
						  ,@Conexion = 1
						  ,@Ok = @Ok OUTPUT
						  ,@OkRef = @Okref OUTPUT

			IF @Ok = 80030
				SELECT @Ok = NULL

			IF @Ok = NULL
			BEGIN
				SELECT @DMov = MovID
				FROM Cxc
				WHERE ID = @IDCxc
				INSERT INTO MovFlujo
					VALUES (@Sucursal, @Empresa, @Modulo, @ID, @Mov, @MovID, @Modulo, @IDCxc, @MovSaldar, @DMov, 0)
			END

			FETCH NEXT FROM crRefinanciamientos INTO @Aplica, @AplicaID, @IDOrigen
			DROP TABLE #DocPendtes
			DROP TABLE #NCACobro
			END
			CLOSE crRefinanciamientos
			DEALLOCATE crRefinanciamientos
		END
		ELSE
			SELECT @Ok = 100019

	END

	IF @Modulo = 'CXC'
		AND @Mov = 'Refinanciamiento'
		AND @Estatus IN ('PENDIENTE', 'CONCLUIDO')
		AND @EstatusNuevo = 'CANCELADO'
	BEGIN
		SELECT @Origen = Origen
			  ,@OrigenID = OrigenID
		FROM Cxc
		WHERE ID = @ID
		SELECT @OID = dbo.fnIDDelMovimientoMAVI(@Origen, @OrigenID)
		UPDATE Cxc
		SET Estatus = 'CANCELADO'
		WHERE ID = @OID
		AND Mov = 'Sol Refinanciamiento'
		DECLARE
			crFlujo
			CURSOR FOR
			SELECT DID
			FROM MovFlujo
			WHERE OID = @ID
			AND Cancelado = 0
		OPEN crFlujo
		FETCH NEXT FROM crFlujo INTO @IDCxc
		WHILE @@FETCH_STATUS = 0
		BEGIN
		EXEC spAfectar 'CXC'
					  ,@IDCxc
					  ,'CANCELAR'
					  ,'Todo'
					  ,@EnSilencio = 1
					  ,@Conexion = 1
					  ,@Ok = @Ok OUTPUT
					  ,@OkRef = @Okref OUTPUT

		IF @Ok = 80030
			SELECT @Ok = NULL

		FETCH NEXT FROM crFlujo INTO @IDCxc
		END
		CLOSE crFlujo
		DEALLOCATE crFlujo
	END

	IF @Modulo = 'CXC'
		AND @EstatusNuevo IN ('PENDIENTE', 'CONCLUIDO')
	BEGIN
		SELECT @IdPadre = dbo.fnIDOrigenCXCMovMAVI(@ID)
		SELECT @MovPadre = Mov
			  ,@MovIDPadre = MovID
		FROM CXC
		WHERE ID = @IDPadre

		IF @MovPadre IS NOT NULL
			AND @MovIDPadre IS NOT NULL
			UPDATE CXC
			SET PadreMAVI = @MovPadre
			   ,PadreIDMAVI = @MovIDPadre
			WHERE ID = @ID

	END

	IF @Modulo = 'CXC'
		AND @EstatusNuevo IN ('CONCLUIDO', 'PENDIENTE')
	BEGIN
		SELECT @MovTipo = Clave
		FROM MovTipo
		WHERE Modulo = 'CXC'
		AND Mov = @Mov

		IF @MovTipo = 'CXC.CA'
		BEGIN
			SELECT @Concepto = Concepto
			FROM Cxc
			WHERE ID = @ID

			IF @Concepto LIKE 'Canc%'
			BEGIN
				INSERT INTO CXCDNC (ID, Renglon, Aplica, AplicaID)
					SELECT ID
						  ,1
						  ,PadreMAVI
						  ,PadreIDMAVI
					FROM CXC
					WHERE ID = @ID
			END
			ELSE
			BEGIN
				INSERT INTO CXCDNC (ID, Renglon, Aplica, AplicaID)
					SELECT ID
						  ,1
						  ,Origen
						  ,OrigenID
					FROM NegociaMoratoriosMAVI
					WHERE NotaCargoMorID = @ID
			END

		END

		SELECT @MovTipo = Clave
		FROM MovTipo
		WHERE Modulo = 'CXC'
		AND Mov = @Mov

		IF @MovTipo = 'CXC.NC'
		BEGIN
			INSERT INTO CXCDNC (ID, Renglon, Aplica, AplicaID)
				SELECT ID
					  ,1
					  ,Origen
					  ,OrigenID
				FROM NegociaMoratoriosMAVI
				WHERE NotaCredBonID = @ID
		END

		IF @MovTipo IN ('CXC.F', 'CXC.CAP')
		BEGIN
			UPDATE CXC
			SET PonderacionCalifMAVI = '*'
			WHERE ID = @ID
		END

		IF @Modulo = 'CXC'
			AND @EstatusNuevo IN ('PENDIENTE', 'CONCLUIDO')
			AND @MovTipo = 'CXC.DM'
		BEGIN
			UPDATE CXC
			SET PonderacionCalifMAVI = 'I'
			   ,CalificacionMAVI = 0
			WHERE ID = @ID
		END

	END

	IF @Modulo = 'CXC'
		AND @EstatusNuevo IN ('PENDIENTE', 'CONCLUIDO')
		AND @MovTipo = 'CXC.NC'
	BEGIN
		INSERT INTO CXCDNC (ID, Renglon, Aplica, AplicaID)
			SELECT TOP 1 ID
						,Renglon
						,Aplica
						,AplicaID
			FROM CXCD
			WHERE ID = @ID
		SELECT @Mov = Mov
		FROM CXC
		WHERE ID = @ID
		SELECT @Subclave = Subclave
		FROM MovTipo
		WHERE Mov = @Mov
		AND Modulo = 'CXC'

		IF @Subclave = 'CXC.AI'
		BEGIN
			SELECT @Concepto = Concepto
			FROM CXC
			WHERE ID = @ID

			IF @Concepto IN ('ADJUDICACION + DE 12', 'ADJ CREDILANA/PP + DE 12', 'ADJUDICACION 1 A 12', 'OK ADJ CREDILANA/PP + DE 12', 'OK ADJUDICACION + DE 12', 'OK ADJUDICACION 1 A 12')
			BEGIN
				UPDATE CXC
				SET PonderacionCalifMAVI = 'A'
				   ,CalificacionMAVI = 0
				WHERE ID = @ID
			END

		END

	END

	IF @Modulo = 'CXC'
		AND @MovTipo = 'CXC.C'
		AND @EstatusNuevo = 'CONCLUIDO'
	BEGIN
		SELECT @TipoCobro = ISNULL(TipoCobro, 0)
		FROM TipoCobroMAVI
		WHERE IDCobro = @ID

		IF @TipoCobro = 1
		BEGIN
			SELECT @PorcMoratorioBonificar = ISNULL(PorcMoratorioBonificar, 0)
				  ,@MoratorioXPagar = ISNULL(MoratorioXPagar, 0)
			FROM CobroXPoliticaHistMAVI
			WHERE IdCobro = @ID

			IF @MoratorioXPagar = 0
				SELECT @RemanenteNvo = 0
			ELSE
				SELECT @RemanenteNvo = @MoratorioXPagar

			SELECT @Padre = Origen
				  ,@PadreID = OrigenID
			FROM NegociaMoratoriosMAVI
			WHERE IDCobro = @ID
			UPDATE CobroXPoliticaHistMAVI
			SET EstatusCobro = 'CONCLUIDO'
			WHERE IDCobro = @ID
			DECLARE
				crCobroPol
				CURSOR FOR
				SELECT Mov
					  ,MovID
				FROM CXC
				WHERE PadreMAVI = @Padre
				AND PAdreIDMAVI = @PadreID
				AND Estatus = 'PENDIENTE'
				AND (Vencimiento <= @FechaAplicacion OR InteresesMoratoriosMAVI > 0)
				UNION
				SELECT Mov
					  ,MovID
				FROM NegociaMoratoriosMAVI
				WHERE IDCobro = @ID
				UNION
				SELECT Mov
					  ,MovID
				FROM CondonaMorxSistMAVI
				WHERE IDCobro = @ID
				GROUP BY Mov
						,MovID
			OPEN crCobroPol
			FETCH NEXT FROM crCobroPol INTO @Mov, @MovID
			WHILE @@FETCH_STATUS <> -1
			BEGIN

			IF @@FETCH_STATUS <> -2
			BEGIN
				SELECT @IDMovMor = ID
					  ,@FechaAnterior = FechaOriginalAnt
					  ,@RemananteAnt = InteresMoratorioAnt
					  ,@Vencimiento = Vencimiento
				FROM CXC
				WHERE Mov = @Mov
				AND MovID = @MovID

				IF EXISTS (SELECT * FROM HistCobroMoratoriosMAVI WHERE IDCobro = @ID AND Mov = @Mov AND MovID = @MovID)
					DELETE HistCobroMoratoriosMAVI
					WHERE IDCobro = @ID
						AND Mov = @Mov
						AND MovID = @MovID

				INSERT INTO HistCobroMoratoriosMAVI (IDCobro, Mov, MovID, FechaCobro, FechaOriginalAnt, InteresMoratoriosAnt)
					VALUES (@ID, @Mov, @MovID, @FechaAplicacion, @FechaAnterior, @RemananteAnt)

				IF (@Vencimiento <= @FechaAplicacion)
				BEGIN
					UPDATE Cxc
					SET FechaOriginalAnt = FechaOriginal
					   ,FechaOriginal = @FechaAplicacion
					WHERE ID = @IDMovMor
				END

				UPDATE Cxc
				SET InteresMoratorioAnt = ISNULL(InteresesMoratoriosMAVI, 0)
				WHERE ID = @IDMovMor
				UPDATE Cxc
				SET InteresesMoratoriosMAVI = 0
				WHERE ID = @IDMovMor
			END

			FETCH NEXT FROM crCobroPol INTO @Mov, @MovID
			END
			CLOSE crCobroPol
			DEALLOCATE crCobroPol

			IF @MoratorioXPagar > 0
			BEGIN
				SELECT @Remanente = @MoratorioXPagar
				SELECT @IDDocPendiente = NULL
				SELECT @IDDocPendiente = MIN(Id)
				FROM NegociaMoratoriosMAVI
				WHERE IDCobro = @ID
				AND ROUND(ImporteAPagar, 0) < ROUND(ImporteReal, 0)

				IF @IDDocPendiente IS NULL
					SELECT @IDDocPendiente = MIN(ID)
					FROM CXC
					WHERE PadreMAVI = @Padre
					AND PadreIDMAVI = @PadreID
					AND Estatus = 'PENDIENTE'
					AND MOVID NOT IN (SELECT MovID FROM NegociaMoratoriosMAVI WHERE IDCobro = @ID)
				ELSE
				BEGIN
					SELECT @MovDocV = Mov
						  ,@MovIDDocV = MovID
					FROM NegociaMoratoriosMAVI
					WHERE IDCobro = @ID
					SELECT @IDDocPendiente = MIN(ID)
					FROM CXC
					WHERE PadreMAVI = @Padre
					AND PadreIDMAVI = @PadreID
					AND Estatus = 'PENDIENTE'
					AND Mov = @MovDocV
					AND MovID = @MovIDDocV
				END

				UPDATE CXC
				SET InteresesMoratoriosMAVI = ROUND(@MoratorioXPagar, 2)
				WHERE ID = @IDDocPendiente
				UPDATE CobroXPoliticaHistMAVI
				SET IdCxcMasViejo = @DocMasAntiguo
				WHERE IdCobro = @ID
			END

		END

		IF EXISTS (SELECT * FROM CondonaMorxSistMAVI WHERE IDCobro = @ID AND Estatus = 'ALTA')
		BEGIN
			INSERT INTO CondonaMoratoriosMAVI (Usuario, FechaAutorizacion, IDMov, RenglonMov, Mov, MovID, MontoOriginal, MontoCondonado, TipoCondonacion, Estatus, IDCobro)
				SELECT Usuario
					  ,FechaAutorizacion
					  ,IDMov
					  ,RenglonMov
					  ,Mov
					  ,MovID
					  ,MontoOriginal
					  ,MontoCondonado
					  ,TipoCondonacion
					  ,Estatus
					  ,IDCobro
				FROM CondonaMorxSistMAVI
				WHERE IDCobro = @ID
				AND Estatus = 'ALTA'
		END

		IF @TipoCobro = 0
		BEGIN

			IF (
					SELECT COUNT(*)
					FROM CondonaMorxSistMAVI
					WHERE IdCobro = @ID
				)
				> 0
			BEGIN
				SET @FechaAplicacion = GETDATE()
				SET @FechaAplicacion = CONVERT(VARCHAR(8), @FechaAplicacion, 112)
				DECLARE
					crCondxSist1
					CURSOR FOR
					SELECT CondonaMorxSistMAVI.Mov
						  ,CondonaMorxSistMAVI.MovID
						  ,cxc.ID
						  ,cxc.fechaoriginalAnt
						  ,cxc.InteresMoratorioAnt
					FROM CondonaMorxSistMAVI
					JOIN CXc
						ON cxc.Mov = CondonaMorxSistMAVI.Mov
						AND cxc.MovID = CondonaMorxSistMAVI.MovID
					WHERE CondonaMorxSistMAVI.IdCobro = @ID
				OPEN crCondxSist1
				FETCH NEXT FROM crCondxSist1 INTO @Mov, @MovID, @CxcID, @FechaOriginal, @ImporteMoratorio
				WHILE @@FETCH_STATUS <> -1
				BEGIN

				IF @@FETCH_STATUS <> -2
				BEGIN
					UPDATE Cxc
					SET FechaOriginalAnt = FechaOriginal
					   ,FechaOriginal = @FechaAplicacion
					WHERE ID = @CxcID
					INSERT INTO HistCobroMoratoriosMAVI (IDCobro, Mov, MOvID, FEchaCobro, FechaOriginalAnt, InteresMoratoriosAnt)
						VALUES (@ID, @Mov, @MovID, @FechaAplicacion, @FechaOriginal, @ImporteMoratorio)
				END

				FETCH NEXT FROM crCondxSist1 INTO @Mov, @MovID, @CxcID, @FechaOriginal, @ImporteMoratorio
				END
				CLOSE crCondxSist1
				DEALLOCATE crCondxSist1
			END

			DECLARE
				crHist
				CURSOR FAST_FORWARD FOR
				SELECT Mov
					  ,MovID
					  ,ImporteMoratorio
					  ,MoratorioAPagar
					  ,ImporteACondonar
					  ,UsuarioCondona
				FROM NegociaMoratoriosMAVI
				WHERE IDCobro = @ID
				AND ImporteACondonar = ImporteMoratorio
				AND ImporteACondonar > 0
			OPEN crHist
			FETCH NEXT FROM crHist INTO @MovMor, @MovMorID, @ImporteMoratorio, @MoratorioAPagar, @ImporteACondonar, @UsuarioCondona
			WHILE @@Fetch_Status = 0
			BEGIN
			INSERT INTO CondonaMoratoriosMAVI (Usuario, FechaAutorizacion, IDMov, RenglonMov, Mov, MovID, MontoOriginal, MontoCondonado, TipoCondonacion, Estatus, IDCobro)
				VALUES (@UsuarioCondona, GETDATE(), @ID, 0, @MovMor, @MovMorID, @ImporteMoratorio, @ImporteACondonar, 'Por Usuario', 'ALTA', @ID)
			FETCH NEXT FROM crHist INTO @MovMor, @MovMorID, @ImporteMoratorio, @MoratorioAPagar, @ImporteACondonar, @UsuarioCondona
			END
			CLOSE crHist
			DEALLOCATE crHist
			EXEC spCalculaRemanenteMAVI @ID
									   ,'2'
			EXEC spCalculaRemanenteMAVI @ID
									   ,'1'
		END

		SELECT @ImporteMoratorio = 0
		SELECT @MoratorioAPagar = 0
		SELECT @PendienteMoratorios = 0
		SELECT @ImporteACondonar = 0
		SELECT @ID = ID
			  ,@Estatus = Estatus
			  ,@Mov = Mov
			  ,@Usuario = Usuario
			  ,@Empresa = Empresa
		FROM CXC
		WHERE ID = @ID
		SET @FechaActual = GETDATE()
		CREATE TABLE #DetalleCobro (
			ID INT IDENTITY (1, 1) NOT NULL
		   ,IDCobro INT NULL
		   ,Aplica VARCHAR(20) NULL
		   ,AplicaID VARCHAR(20) NULL
		   ,Importe MONEY NULL
		)
		INSERT INTO #DetalleCobro (IDCobro, Aplica, AplicaID, Importe)
			SELECT @ID
				  ,Aplica
				  ,AplicaID
				  ,Importe
			FROM CxcD
			WHERE ID = @ID
		DECLARE
			C1
			CURSOR FAST_FORWARD FOR
			SELECT Aplica
				  ,AplicaID
				  ,Importe
			FROM #DetalleCobro
			WHERE IDCobro = @ID
		OPEN C1
		FETCH NEXT FROM C1 INTO @Aplica, @AplicaID, @Importe
		WHILE @@Fetch_Status = 0
		BEGIN
		SELECT @ImporteInteres = 0.0
			  ,@InteresesMoratorios = 0.0

		IF @Aplica IN ('Nota Cargo', 'Nota Cargo VIU', 'Nota Cargo Mayoreo')
		BEGIN
			SELECT @IDD = ID
			FROM Cxc
			WHERE Mov = @Aplica
			AND MovID = @AplicaID
			DECLARE
				crFechaOriginal
				CURSOR FAST_FORWARD FOR
				SELECT Mov
					  ,MovID
					  ,ImporteMoratorio
					  ,MoratorioAPagar
					  ,ImporteACondonar
					  ,UsuarioCondona
				FROM NegociaMoratoriosMAVI
				WHERE IDCobro = @ID
				AND NotaCargoMorId = @IDD
				AND MoratorioAPagar <> ImporteACondonar
			OPEN crFechaOriginal
			FETCH NEXT FROM crFechaOriginal INTO @MovMor, @MovMorID, @ImporteMoratorio, @MoratorioAPagar, @ImporteACondonar, @UsuarioCondona
			WHILE @@Fetch_Status = 0
			BEGIN
			SELECT @IDMovMor = ID
				  ,@FechaAnterior = FechaOriginalAnt
				  ,@RemananteAnt = InteresMoratorioAnt
			FROM CXC
			WHERE Mov = @MovMor
			AND MovId = @MovMorID

			IF @ImporteMoratorio <> @MoratorioAPagar
			BEGIN
				SELECT @Remanente = ISNULL(Remanente, 0)
				FROM NegociaMoratoriosMAVI
				WHERE IDCobro = @ID
				AND Mov = @MovMor
				AND MovId = @MovMorID
			END

			IF @ImporteACondonar > 0
				AND @ImporteACondonar <> @ImporteMoratorio
			BEGIN

				IF EXISTS (SELECT * FROM CondonaMoratoriosMAVI WHERE IdCobro = @ID AND IDMov = @IDD AND TipoCondonacion = 'Por Usuario' AND Estatus = 'ALTA')
				BEGIN
					UPDATE CondonaMoratoriosMAVI
					SET MontoOriginal = @ImporteMoratorio
					   ,MontoCondonado = @ImporteACondonar
					   ,Usuario = @UsuarioCondona
					WHERE IDCobro = @ID
					AND IDMov = @IDD
					AND TipoCondonacion = 'Por Usuario'
					SELECT @Remanente = ISNULL(Remanente, 0)
					FROM NegociaMoratoriosMAVI
					WHERE IDCobro = @ID
					AND Mov = @MovMor
					AND MovId = @MovMorID
				END
				ELSE
					INSERT INTO CondonaMoratoriosMAVI (Usuario, FechaAutorizacion, IDMov, RenglonMov, Mov, MovID, MontoOriginal, MontoCondonado, TipoCondonacion, Estatus, IDCobro)
						VALUES (@UsuarioCondona, GETDATE(), @ID, 0, @MovMor, @MovMorID, @ImporteMoratorio, @ImporteACondonar, 'Por Usuario', 'ALTA', @ID)

			END

			FETCH NEXT FROM crFechaOriginal INTO @MovMor, @MovMorID, @ImporteMoratorio, @MoratorioAPagar, @ImporteACondonar, @UsuarioCondona
			END
			CLOSE crFechaOriginal
			DEALLOCATE crFechaOriginal
		END

		FETCH NEXT FROM C1 INTO @Aplica, @AplicaID, @Importe
		END
		CLOSE C1
		DEALLOCATE C1
		DROP TABLE #DetalleCobro
		SELECT TOP 1 @dAplica = aplica
					,@dAplicaID = aplicaid
		FROM cxcd
		WHERE id = @ID
		SELECT @PadreMAVI = padremavi
			  ,@PadreIDMAVI = padreidmavi
		FROM cxc
		WHERE mov = @dAplica
		AND movid = @dAplicaID
		SELECT @IDPAdreMAVI = Id
		FROM cxc
		WHERE mov = @PadreMAVI
		AND movid = @PadreIDMAVI

		IF (@PadreMAVI) IN ('Nota Cargo', 'Nota Cargo VIU', 'Nota Cargo Mayoreo')
		BEGIN
			SELECT @PadreMAVI = Origen
				  ,@PadreIDMAVI = OrigenID
			FROM NegociaMoratoriosMAVI
			WHERE NotaCargoMorId = @IDPadreMAVI
			SELECT @IDPadreMAVI = ID
			FROM CXC
			WHERE Mov = @PadreMAVI
			AND MovID = @PadreIDMAVI
		END

		SELECT @PadreMAVI = Mov
		FROM CXC
		WHERE ID = @IDPadreMAVI
		AND Concepto NOT LIKE 'Canc%'

		IF (@PadreMAVI) IN ('Nota Cargo', 'Nota Cargo VIU', 'Nota Cargo Mayoreo')
		BEGIN
			SELECT @PadreMAVI = PadreMAVI
				  ,@PadreIDMAVI = PadreIDMAVI
			FROM CXC
			WHERE Id = @IDPadreMAVI
			SELECT @IDPadreMAVI = ID
			FROM CXC
			WHERE Mov = @PadreMAVI
			AND MovID = @PadreIDMAVI
		END

		IF (@PadreMAVI) IN ('Nota Credito', 'Nota Credito VIU', 'Nota Credito Mayoreo')
		BEGIN
			SELECT @PadreMAVI = Origen
				  ,@PadreIDMAVI = OrigenID
			FROM NegociaMoratoriosMAVI
			WHERE NotaCredBonID = @IDPadreMAVI
			SELECT @IDPadreMAVI = ID
			FROM CXC
			WHERE Mov = @PadreMAVI
			AND MovID = @PadreIDMAVI
		END

		SELECT @NoParcialidad = COUNT(IDCobro)
		FROM NoParcialidadCFD
		WHERE IDPadre = @IDPadreMAVI
		AND Estatus = 'CONCLUIDO'
		SELECT @NoParcialidad = @NoParcialidad + 1
		INSERT INTO NoParcialidadCFD (IdPadre, IdCobro, NoParcialidad, Cantidad, Unidad, Articulo, Descripcion, Precio, PrecioTotal, Estatus)
			SELECT @IdPadreMAVI
				  ,@ID
				  ,@NoParcialidad
				  ,1
				  ,'Pieza'
				  ,'Parcialidad ' + CONVERT(VARCHAR, @NoParcialidad)
				  ,@PadreMAVI + ' ' + @PadreIDMAVI
				  ,Importe
				  ,(Importe + Impuestos)
				  ,'CONCLUIDO'
			FROM CXC
			WHERE ID = @ID
		UPDATE CXC
		SET NoParcialidad = @NoParcialidad
		WHERE ID = @ID
	END

	IF @Modulo = 'CXC'
		AND @EstatusNuevo = 'CONCLUIDO'
		AND @MovTipo IN ('CXC.F', 'CXC.CAP')
	BEGIN
		SELECT @Cliente = cxc.Cliente
			  ,@Mov = Cxc.Mov
			  ,@CteEnviarA = cxc.ClienteEnviarA
		FROM CXC
		WHERE cxc.ID = @ID
		SELECT @Subclave = Subclave
		FROM MovTipo
		WHERE Mov = @Mov
		AND Modulo = 'CXC'

		IF @SubClave IS NULL
			AND ((
				SELECT TOP 1 Categoria
				FROM CteEnviarA
				WHERE ID = @CteEnviarA
				AND Cliente = @Cliente
			)
			IN ('CREDITO MENUDEO', 'ASOCIADOS', 'INSTITUCIONES'))
		BEGIN

			IF NOT EXISTS (SELECT * FROM CXCMAVI WHERE ID = @ID)
				INSERT INTO CxcMAVI (ID, MaxDiasVencidosMAVI, MopAnteriorMAVI, MopMavi, MaxDiasInactivosMAVI)
					VALUES (@ID, 0, 0, 0, 0)

		END

	END

	IF @Modulo = 'CXC'
		AND @MovTipo = 'CXC.NC'
		AND @EstatusNuevo = 'CANCELADO'
	BEGIN
		SELECT @Mov = Mov
		FROM CXC
		WHERE ID = @ID
		SELECT @Subclave = Subclave
		FROM MovTipo
		WHERE Mov = @Mov
		AND Modulo = 'CXC'

		IF @Subclave = 'CXC.AI'
		BEGIN
			SELECT @Concepto = Concepto
			FROM CXC
			WHERE ID = @ID

			IF @Concepto IN ('ADJUDICACION + DE 12', 'ADJ CREDILANA/PP + DE 12', 'ADJUDICACION 1 A 12', 'OK ADJ CREDILANA/PP + DE 12', 'OK ADJUDICACION + DE 12', 'OK ADJUDICACION 1 A 12')
			BEGIN
				UPDATE CXC
				SET PonderacionCalifMAVI = '*'
				WHERE ID = @ID
			END

		END

	END

	IF @Modulo = 'CXC'
		AND @EstatusNuevo = 'CANCELADO'
		AND @MovTipo = 'CXC.DM'
	BEGIN
		UPDATE CXC
		SET PonderacionCalifMAVI = NULL
		WHERE ID = @ID
	END

	IF @Modulo = 'CXC'
		AND @MovTipo = 'CXC.C'
		AND @EstatusNuevo = 'CANCELADO'
	BEGIN
		SELECT @TipoCobro = ISNULL(TipoCobro, 0)
		FROM TipoCobroMAVI
		WHERE IDCobro = @ID

		IF @TipoCobro = 0
		BEGIN
			DECLARE
				crCancelCobroNor
				CURSOR FAST_FORWARD FOR
				SELECT Mov
					  ,MovID
				FROM HistCobroMoratoriosMAVI
				WHERE IDCobro = @ID
			OPEN crCancelCobroNor
			FETCH NEXT FROM crCancelCobroNor INTO @MovMor, @MovMorID
			WHILE @@Fetch_Status = 0
			BEGIN
			SELECT @FechaAnterior = NULL
				  ,@RemananteAnt = 0
				  ,@FechaOrigAnt = NULL
				  ,@InteresesMoratoriosAnt = 0
			SELECT @FechaAnterior = FechaOriginalAnt
				  ,@RemananteAnt = InteresMoratoriosAnt
			FROM HistCobroMoratoriosMAVI
			WHERE Mov = @MovMor
			AND MovID = @MovMorID
			AND IDCobro = @ID
			SELECT @FechaOrigAnt = FechaOriginalAnt
				  ,@InteresesMoratoriosAnt = interesmoratorioant
				  ,@IDDoc = ID
			FROM CXC
			WHERE Mov = @MovMor
			AND MovID = @MovMorID
			UPDATE CXC
			SET FechaOriginal = ISNULL(FechaOriginalAnt, NULL)
			   ,InteresesMoratoriosMAVI = ISNULL(Interesmoratorioant, 0)
			WHERE ID = @IDDoc
			UPDATE CXC
			SET interesmoratorioant = ISNULL(@RemananteAnt, 0)
			   ,FechaOriginalAnt = ISNULL(@FechaAnterior, NULL)
			WHERE ID = @IDDoc

			IF @TipoCobro = 0
				DELETE HistCobroMoratoriosMAVI
				WHERE Mov = @MovMor
					AND MovID = @MovMorID
					AND IDCobro = @ID

			FETCH NEXT FROM crCancelCobroNor INTO @MovMor, @MovMorID
			END
			CLOSE crCancelCobroNor
			DEALLOCATE crCancelCobroNor
		END

		IF EXISTS (SELECT * FROM CondonaMoratoriosMAVI WHERE IDCobro = @ID AND Estatus = 'ALTA' AND TipoCondonacion = 'Por Sistema')
		BEGIN
			DECLARE
				crCancelCond
				CURSOR FAST_FORWARD FOR
				SELECT Mov
					  ,MovID
					  ,TipoCondonacion
				FROM CondonaMoratoriosMAVI
				WHERE IDCobro = @ID
				AND Estatus = 'ALTA'
				AND TipoCondonacion = 'Por Sistema'
			OPEN crCancelCond
			FETCH NEXT FROM crCancelCond INTO @MovMor, @MovMorID, @TipoCondonacion
			WHILE @@Fetch_Status = 0
			BEGIN
			UPDATE CondonaMoratoriosMAVI
			SET Estatus = 'CANCELADO'
			WHERE IDCobro = @ID
			AND Estatus = 'ALTA'
			AND TipoCondonacion = 'Por Sistema'
			AND Mov = @MovMor
			AND MovID = @MovMorID
			FETCH NEXT FROM crCancelCond INTO @MovMor, @MovMorID, @TipoCondonacion
			END
			CLOSE crCancelCond
			DEALLOCATE crCancelCond
		END

		DECLARE
			crCondxUsua
			CURSOR FAST_FORWARD FOR
			SELECT Mov
				  ,MovID
				  ,ImporteMoratorio
				  ,MoratorioAPagar
				  ,ImporteACondonar
				  ,UsuarioCondona
			FROM NegociaMoratoriosMAVI
			WHERE IDCobro = @ID
			AND ImporteACondonar > 0
		OPEN crCondxUsua
		FETCH NEXT FROM crCondxUsua INTO @MovMor, @MovMorID, @ImporteMoratorio, @MoratorioAPagar, @ImporteACondonar, @UsuarioCondona
		WHILE @@Fetch_Status = 0
		BEGIN
		UPDATE CondonaMoratoriosMAVI
		SET Estatus = 'CANCELADO'
		WHERE IDCobro = @ID
		AND Estatus = 'ALTA'
		AND Mov = @MovMor
		AND MovID = @MovMorID
		SELECT @PendienteMoratorios = ISNULL(@ImporteMoratorio, 0) - ISNULL(@ImporteACondonar, 0) - ISNULL(@MoratorioAPagar, 0)
		SELECT @IDMovMor = ID
		FROM CXC
		WHERE Mov = @MovMor
		AND MovID = @MovMorID
		FETCH NEXT FROM crCondxUsua INTO @MovMor, @MovMorID, @ImporteMoratorio, @MoratorioAPagar, @ImporteACondonar, @UsuarioCondona
		END
		CLOSE crCondxUsua
		DEALLOCATE crCondxUsua

		IF EXISTS (SELECT * FROM CXC WHERE IDCobroBonifMAVI = @ID)
		BEGIN
			DECLARE
				crCancBon
				CURSOR FAST_FORWARD FOR
				SELECT ID
				FROM CXC
				WHERE IDCobroBonifMAVI = @ID
				AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
			OPEN crCancBon
			FETCH NEXT FROM crCancBon INTO @IDNCBon
			WHILE @@Fetch_Status = 0
			BEGIN
			EXEC spAfectar 'CXC'
						  ,@IDNCBon
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
			FETCH NEXT FROM crCancBon INTO @IDNCBon
			END
			CLOSE crCancBon
			DEALLOCATE crCancBon
		END

		IF @TipoCobro = 1
		BEGIN

			IF EXISTS (SELECT * FROM CobroXPoliticaHistMAVI WHERE IdCobro = @ID)
			BEGIN
				UPDATE CobroXPoliticaHistMAVI
				SET EstatusCobro = 'CANCELADO'
				WHERE IDCobro = @ID
				SELECT @Origen = Mov
					  ,@OrigenID = MovID
				FROM CobroXPoliticaHistMAVI
				WHERE IdCobro = @ID
				SELECT @IdCobroCargoMoratorioEstAnt = MAX(IDcobro)
				FROM CobroXPoliticaHistMAVI
				WHERE Mov = @Origen
				AND MovID = @OrigenID
				AND EstatusCobro = 'CONCLUIDO'

				IF @IdCobroCargoMoratorioEstAnt > 0
				BEGIN
					SET @Estadistico = 0
					SELECT @Estadistico = IdCargoMoratorioEst
					FROM CobroXPoliticaHistMAVI
					WHERE IdCobro = @IdCobroCargoMoratorioEstAnt

					IF @Estadistico > 0
					BEGIN
						UPDATE CobroXPoliticaHistMAVI
						SET EstatusCargoMorEst = 'CONCLUIDO'
						WHERE IDCobro = @IdCobroCargoMoratorioEstAnt
						UPDATE Cxc
						SET Estatus = 'CONCLUIDO'
						WHERE ID = @Estadistico
					END

				END

				SELECT @IdCargoMoratorioEst = IdCargoMoratorioEst
				FROM CobroXPoliticaHistMAVI
				WHERE IdCobro = @ID

				IF @IdCargoMoratorioEst > 0
				BEGIN
					UPDATE CobroXPoliticaHistMAVI
					SET EstatusCargoMorEst = 'CANCELADO'
					WHERE IdCobro = @ID
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
				END

			END

			CREATE TABLE #HIST (
				ID INT NULL
			)
			INSERT INTO #HIST
				SELECT c.id
				FROM HistCobroMoratoriosMAVI h
					,cxc c
				WHERE h.IDCobro = @ID
				AND c.mov = h.mov
				AND c.movid = h.movid
			DECLARE
				crCancelCobroPol
				CURSOR FAST_FORWARD FOR
				SELECT Mov
					  ,MovID
				FROM HistCobroMoratoriosMAVI
				WHERE IDCobro = @ID
			OPEN crCancelCobroPol
			FETCH NEXT FROM crCancelCobroPol INTO @MovMor, @MovMorID
			WHILE @@Fetch_Status = 0
			BEGIN
			SELECT @FechaAnterior = NULL
				  ,@RemananteAnt = 0
				  ,@FechaOrigAnt = NULL
				  ,@InteresesMoratoriosAnt = 0
			SELECT @IDMAx = MAX(IDCobro)
			FROM HistCobroMoratoriosMAVI
			WHERE Mov = @MovMor
			AND MovID = @MovMorID
			SELECT @FechaAnterior = FechaOriginalAnt
				  ,@RemananteAnt = InteresMoratoriosAnt
			FROM HistCobroMoratoriosMAVI
			WHERE Mov = @MovMor
			AND MovID = @MovMorID
			AND IDCobro = @IDMAx
			SELECT @FechaOrigAnt = FechaOriginalAnt
				  ,@InteresesMoratoriosAnt = interesmoratorioant
				  ,@IDDoc = ID
			FROM CXC
			WHERE Mov = @MovMor
			AND MovID = @MovMorID
			UPDATE CXC
			SET FechaOriginal = @FechaOrigAnt
			   ,InteresesMoratoriosMAVI = @InteresesMoratoriosAnt
			   ,interesmoratorioant = @RemananteAnt
			   ,FechaOriginalAnt = @FechaAnterior
			WHERE ID = @IDDoc
			DELETE HistCobroMoratoriosMAVI
			WHERE Mov = @MovMor
				AND MovID = @MovMorID
				AND IDCobro = @IDMAx
			FETCH NEXT FROM crCancelCobroPol INTO @MovMor, @MovMorID
			END
			CLOSE crCancelCobroPol
			DEALLOCATE crCancelCobroPol
			SET @FechaAplicacion = GETDATE()
			SET @FechaAplicacion = CONVERT(VARCHAR(8), @FechaAplicacion, 112)
			SET @IDDoc = NULL
			SELECT @Padre = Origen
				  ,@PadreID = OrigenID
			FROM NegociaMoratoriosMAVI
			WHERE IDCobro = @ID
			SELECT @IDDoc = MIN(ID)
			FROM CXC
			WHERE PadreMAVI = @Padre
			AND PAdreIDMAVI = @PadreID
			AND Estatus = 'PENDIENTE'
			AND (Vencimiento <= @FechaAplicacion OR InteresesMoratoriosMAVI > 0)
			AND ID NOT IN (SELECT ID FROM #HIST)

			IF @IDDoc IS NOT NULL
			BEGIN
				SELECT @FechaAnterior = NULL
					  ,@RemananteAnt = 0
					  ,@FechaOrigAnt = NULL
					  ,@InteresesMoratoriosAnt = 0
				SELECT @FechaAnterior = vencimiento
					  ,@FechaOrigAnt = FechaOriginalAnt
					  ,@InteresesMoratoriosAnt = ISNULL(interesmoratorioant, 0)
				FROM CXC
				WHERE ID = @IDDoc
				UPDATE CXC
				SET FechaOriginal = @FechaOrigAnt
				   ,InteresesMoratoriosMAVI = @InteresesMoratoriosAnt
				   ,interesmoratorioant = @RemananteAnt
				   ,FechaOriginalAnt = @FechaAnterior
				WHERE ID = @IDDoc
			END

			DROP TABLE #HIST
		END

		UPDATE NoParcialidadCFD
		SET ESTATUS = 'CANCELADO'
		WHERE IDCobro = @ID
	END

	IF @Modulo = 'CXP'
		AND @Mov = 'Documento'
		AND @EstatusNuevo = 'PENDIENTE'
	BEGIN
		SELECT @Mov = Mov
			  ,@Origen = Origen
			  ,@OrigenID = OrigenID
		FROM CXP
		WHERE ID = @ID

		IF @Mov = 'Documento'
		BEGIN
			SELECT @UEN = UEN
			FROM CXP
			WHERE Mov = @Origen
			AND MovId = @OrigenID
			UPDATE CXP
			SET UEN = @UEN
			WHERE ID = @ID
		END

	END

	IF @Modulo = 'CXC'
		AND @Mov = 'Documento'
		AND @EstatusNuevo = 'PENDIENTE'
	BEGIN
		SELECT @Mov = Mov
			  ,@Origen = Origen
			  ,@OrigenID = OrigenID
		FROM CXC
		WHERE ID = @ID

		IF @Mov = 'Documento'
		BEGIN
			SELECT @UEN = UEN
			FROM CXC
			WHERE Mov = @Origen
			AND MovId = @OrigenID
			UPDATE CXC
			SET UEN = @UEN
			WHERE ID = @ID
		END

	END

	IF @Modulo = 'CXC'
		AND @EstatusNuevo IN ('CONCLUIDO', 'PENDIENTE')
	BEGIN
		DECLARE
			@SucursalV INT
		   ,@OT VARCHAR(10)

		IF @MovTipo IN ('CXC.F', 'CXC.CAP')
		BEGIN
			SELECT @OT = (
				 SELECT OrigenTipo
				 FROM CXC
				 WHERE ID = @ID
			 )

			IF @OT = 'VTAS'
				AND (
					SELECT DB_NAME()
				)
				!= 'Mavicob'
			BEGIN
				SELECT @SucursalV = (
					 SELECT v.SucursalVenta
					 FROM Venta v
						 ,CXC c
					 WHERE C.ID = @ID
					 AND v.Mov = c.Origen
					 AND v.MovID = c.OrigenID
				 )
				UPDATE CXC
				SET Sucursal = @SucursalV
				WHERE ID = @ID
				UPDATE CXC
				SET SucursalOrigen = @SucursalV
				WHERE ID = @ID
			END

		END

	END

	SELECT @CFDFlex = ISNULL(CFDFlex, 0)
		  ,@eDoc = ISNULL(eDoc, 0)
	FROM EmpresaGral
	WHERE Empresa = @Empresa
	SELECT @MovTipoCFDFlex = ISNULL(CFDFlex, 0)
	FROM MovTipo
	WHERE Mov = @Mov
	AND Modulo = @Modulo

	IF @Modulo = 'CXC'
	BEGIN
		SELECT @MovTipo = MovTIpo.Clave
			  ,@Mov = cxc.Mov
		FROM CXC
		JOIN MovTipo
			ON MovTipo.Mov = CXC.Mov
		WHERE MovTipo.Modulo = 'CXC'
		AND CXC.ID = @ID

		IF @MovTipo = 'CXC.CA'
		BEGIN
			SELECT @IDPadreMAVI = c.ID
			FROM CXC c
			JOIN NegociaMoratoriosMAVI d
				ON c.Mov = d.Mov
				AND c.MovID = d.MovID
			WHERE d.IDCobro = @ID
			SELECT @MovTipo = MovTIpo.Clave
			FROM CXC
			JOIN MovTipo
				ON MovTipo.Mov = CXC.Mov
			WHERE MovTipo.Modulo = 'CXC'
			AND CXC.ID = @IDPadreMAVI

			IF @MovTipo = 'CXC.CA'
			BEGIN
				SELECT @Concepto = Concepto
					  ,@MovIDPadre = MovID
				FROM Cxc
				WHERE ID = @IDPadreMAVI

				IF @Concepto LIKE '%SALDO%'
					OR @MovIDPadre LIKE 'Z%'
				BEGIN
					SELECT @MovTipoCFDFlex = 0
						  ,@eDoc = 0
					PRINT 'Nota Cargo Saldo Inicial o Recaptura: ' + @MovIDPAdre
				END

			END

		END

		IF @Mov IN ('Cobro', 'Cobro Instituciones')
		BEGIN
			SELECT TOP 1 @IDPadreMAVI = p.ID
			FROM Cxc c
			JOIN CxcD d
				ON c.Mov = d.Aplica
				AND c.MovID = d.AplicaID
			JOIN CXC p
				ON c.PadreMAVI = p.Mov
				AND c.PadreIDMAVI = p.MovID
			WHERE d.ID = @ID
			GROUP BY p.ID

			IF @IDPadreMAVI IS NULL
				SELECT @IDPadreMAVI = c.ID
				FROM CXC c
				JOIN NegociaMoratoriosMAVI d
					ON c.Mov = d.Origen
					AND c.MovID = d.OrigenID
				WHERE d.IDCobro = @ID

			PRINT 'CXCDetalle: ' + CONVERT(VARCHAR(20), ISNULL(@IDPadreMAVI, 999999))
			SELECT @MovTipo = MovTIpo.Clave
			FROM CXC
			JOIN MovTipo
				ON MovTipo.Mov = CXC.Mov
			WHERE MovTipo.Modulo = 'CXC'
			AND CXC.ID = @IDPadreMAVI

			IF @MovTipo = 'CXC.CA'
			BEGIN
				SELECT @Concepto = Concepto
					  ,@MovIDPadre = MovID
				FROM Cxc
				WHERE ID = @IDPadreMAVI

				IF @Concepto LIKE '%SALDO%'
					OR @MovIDPadre LIKE 'Z%'
				BEGIN
					SELECT @MovTipoCFDFlex = 0
						  ,@eDoc = 0
					PRINT 'Nota Cargo Saldo Inicial o Recaptura: ' + @MovIDPAdre
				END
				ELSE
				BEGIN

					IF @Concepto LIKE 'Canc%'
					BEGIN
						SELECT @PadreMAVI = PadreMAVI
							  ,@PadreIDMAVI = PadreIDMAVI
						FROM CXC
						WHERE ID = @IDPadreMAVI
					END
					ELSE
					BEGIN
						SELECT @PadreMAVI = Origen
							  ,@PadreIDMAVI = OrigenID
						FROM NegociaMoratoriosMAVI
						WHERE NotaCargoMorID = @ID
					END

					SELECT @IDPAdreMAVI = ID
					FROM CXC
					WHERE Mov = @PadreMAVI
					AND MovID = @PadreIDMAVI
				END

			END

			IF @MovTipo = 'CXC.NC'
			BEGIN
				SELECT @PadreMAVI = Origen
					  ,@PadreIDMAVI = OrigenID
				FROM NegociaMoratoriosMAVI
				WHERE NotaCredBonID = @ID
				SELECT @IDPAdreMAVI = ID
				FROM CXC
				WHERE Mov = @PadreMAVI
				AND MovID = @PadreIDMAVI
			END

			SELECT @PadreMAVI = Mov
				  ,@Condicion = Condicion
			FROM CXC
			WHERE ID = @IDPadreMAVI

			IF (
					SELECT ConsecutivoFiscal
					FROM movtipo
					WHERE mov = @PadreMAVI
					AND Modulo = 'CXC'
				)
				= 0
				SELECT @MovTipoCFDFlex = 0
					  ,@eDoc = 0

			IF (
					SELECT Concepto
					FROM CXC
					WHERE ID = @IDPadreMAVI
				)
				LIKE '%Canc%'
				SELECT @MovTipoCFDFlex = 0
					  ,@eDoc = 0

			SELECT @Condicion = CFD_metodoDePago
			FROM Condicion
			WHERE Condicion = @Condicion

			IF @Condicion = 'CONTADO'
				SELECT @MovTipoCFDFlex = 0
					  ,@eDoc = 0

		END

	END

	IF @Modulo = 'CXC'
		AND @EstatusNuevo IN ('CONCLUIDO', 'PENDIENTE')
	BEGIN
		SELECT @MovTipo = Clave
		FROM MovTipo
		WHERE Modulo = 'CXC'
		AND Mov = @Mov

		IF @MovTipo = 'CXC.NC'
		BEGIN
			SELECT @Concepto = Concepto
			FROM Cxc
			WHERE ID = @ID

			IF @Concepto LIKE '%SALDOS INICIALES%'
			BEGIN
				SELECT @MovTipoCFDFlex = 0
					  ,@eDoc = 0
				PRINT 'Nota Credito Saldo Inicial: ' + CONVERT(VARCHAR, @ID)
			END

		END

	END

	IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
		AND @eDoc = 1
		AND @MovTipoCFDFlex = 0
	BEGIN
		SELECT @eDocOk = NULL
			  ,@eDocOkRef = NULL
		EXEC speDocXML @@SPID
					  ,@Empresa
					  ,@Modulo
					  ,@Mov
					  ,@ID
					  ,NULL
					  ,@EstatusNuevo
					  ,1
					  ,0
					  ,@XML OUTPUT
					  ,@eDocOk OUTPUT
					  ,@eDocOkRef OUTPUT

		IF @eDocOk IS NOT NULL
			SELECT @Ok = @eDocOk
				  ,@OkRef = @eDocOkRef

	END

	IF (@MovTipoCFDFlex = 1)
		AND (@CFDFlex = 1)
		AND (@eDoc = 1)
		AND (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
	BEGIN
		SELECT @eDocOk = NULL
			  ,@eDocOkRef = NULL
		EXEC spCFDFlex @@SPID
					  ,@Empresa
					  ,@Modulo
					  ,@ID
					  ,@EstatusNuevo
					  ,@eDocOk OUTPUT
					  ,@eDocOkRef OUTPUT
		PRINT @Mov + CONVERT(VARCHAR(20), ISNULL(@ID, 999992)) + 'spCFDFlex: ' + CONVERT(VARCHAR(20), ISNULL(@eDocOk, 999992)) + ISNULL(@eDocOkRef, 'SinReferencia')

		IF @eDocOk IS NOT NULL
			SELECT @Ok = @eDocOk
				  ,@OkRef = @eDocOkRef

	END

	IF (@MovTipoCFDFlex = 1)
		AND (@CFDFlex = 1)
		AND (@eDoc = 1)
		AND (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
	BEGIN
		SELECT @eDocOk = NULL
			  ,@eDocOkRef = NULL
		EXEC spCFDFlexCancelar @@SPID
							  ,@Empresa
							  ,@Modulo
							  ,@ID
							  ,@EstatusNuevo
							  ,@eDocOk OUTPUT
							  ,@eDocOkRef OUTPUT

		IF @eDocOk IS NOT NULL
			SELECT @Ok = @eDocOk
				  ,@OkRef = @eDocOkRef

	END

	PRINT ISNULL(@OK, 9999999)
	PRINT ISNULL(@OkRef, 'Sin ref.')

	IF @Modulo = 'VTAS'
		AND @Estatus = 'CONCLUIDO'
		AND @EstatusNuevo = 'CANCELADO'
		AND @Ok IS NULL
	BEGIN

		IF @MovTipo IN ('VTAS.F')
			EXEC xpCancelarMonederoCXCF @Empresa
									   ,@ID
									   ,@Usuario
									   ,@Sucursal
									   ,@Ok OUTPUT
									   ,@OkRef OUTPUT

	END

	IF @Modulo IN ('DIN')
		AND @Ok IS NULL
	BEGIN
		EXEC xpActualizarContSATComprobante @Modulo
										   ,@ID
	END

	IF EXISTS (SELECT ContX FROM EMPRESAGRAL WHERE Empresa = @Empresa AND ContX = 1)
		AND @Modulo = 'CONT'
		AND @Ok IS NULL
	BEGIN
		EXEC spContSATConexionContable @Empresa
									  ,@Modulo
									  ,@ID
	END

	IF @Modulo IN ('CXC', 'VTAS')
		AND @Ok IS NULL
		EXEC xpContSAT @Empresa
					  ,@Modulo
					  ,@ID

	IF @Modulo IN ('GAS', 'CXP')
		EXEC spAsociacionRetroactiva @Modulo
									,@ID
									,@Empresa

	RETURN
END

