SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spGeneraNCredAPMAVI]
 @ID INT
,@Usuario VARCHAR(10)
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
AS
BEGIN
	DECLARE
		@Empresa CHAR(5)
	   ,@Sucursal INT
	   ,@Hoy DATETIME
	   ,@Vencimiento DATETIME
	   ,@Moneda CHAR(10)
	   ,@TipoCambio FLOAT
	   ,@Contacto CHAR(10)
	   ,@Renglon FLOAT
	   ,@Aplica VARCHAR(20)
	   ,@AplicaID VARCHAR(20)
	   ,@ImpReal MONEY
	   ,@MoratorioAPagar MONEY
	   ,@Origen VARCHAR(20)
	   ,@OrigenID VARCHAR(20)
	   ,@MovPadre VARCHAR(20)
	   ,@MovPadre1 VARCHAR(20)
	   ,@MovIDPadre VARCHAR(20)
	   ,@AdelantoPagos MONEY
	   ,@UEN INT
	   ,@MovCrear VARCHAR(20)
	   ,@Mov VARCHAR(20)
	   ,@IDCxc INT
	   ,@FechaAplicacion DATETIME
	   ,@CtaDinero VARCHAR(10)
	   ,@Concepto VARCHAR(50)
	   ,@IDPol INT
	   ,@NumDoctos INT
	   ,@ImpDocto MONEY
	   ,@MovID VARCHAR(20)
	   ,@TotalMov MONEY
	   ,@Referencia VARCHAR(100)
	   ,@CanalVenta INT
	   ,@Impuestos MONEY
	   ,@SdoDoc MONEY
	   ,@ImpTotalBonif MONEY
	   ,@DefImpuesto FLOAT
	   ,@IDCxc2 INT
	   ,@HayNotasCredCanc INT
	   ,@minboni INT
	   ,@maxboni INT
	   ,@mindet INT
	   ,@maxdet INT
	   ,@minboni2 INT
	   ,@maxboni2 INT
	   ,@mindet2 INT
	   ,@maxdet2 INT
	SET @FechaAplicacion = GETDATE()
	SELECT @Empresa = Empresa
		  ,@Sucursal = Sucursal
		  ,@Hoy = FechaEmision
		  ,@Moneda = Moneda
		  ,@TipoCambio = TipoCambio
		  ,@Contacto = Cliente
	FROM Cxc
	WHERE ID = @ID

	IF EXISTS (SELECT ID FROM tempdb.sys.sysobjects WHERE id = OBJECT_ID('tempdb.dbo.#crGenBonifAP') AND type = 'U')
		DROP TABLE #crGenBonifAP

	CREATE TABLE #crGenBonifAP (
		ID INT PRIMARY KEY IDENTITY (1, 1) NOT NULL
	   ,AdelantoPagos MONEY NULL
	   ,Origen VARCHAR(25) NULL
	   ,OrigenID VARCHAR(25) NULL
	   ,IDAdelantoPagos INT
	)

	IF EXISTS (SELECT ID FROM tempdb.sys.sysobjects WHERE id = OBJECT_ID('tempdb.dbo.#crDetNCBonifAP') AND type = 'U')
		DROP TABLE #crDetNCBonifAP

	CREATE TABLE #crDetNCBonifAP (
		ID INT PRIMARY KEY IDENTITY (1, 1) NOT NULL
	   ,Mov VARCHAR(25) NULL
	   ,MovID VARCHAR(25) NULL
	   ,AdelantoPagos MONEY NULL
	)

	IF EXISTS (SELECT ID FROM tempdb.sys.sysobjects WHERE id = OBJECT_ID('tempdb.dbo.#crGenBonifAP2') AND type = 'U')
		DROP TABLE #crGenBonifAP2

	CREATE TABLE #crGenBonifAP2 (
		ID INT PRIMARY KEY IDENTITY (1, 1) NOT NULL
	   ,AdelantoPagos MONEY NULL
	   ,Origen VARCHAR(25) NULL
	   ,OrigenID VARCHAR(25) NULL
	   ,IDAdelantoPagos INT
	)

	IF EXISTS (SELECT ID FROM tempdb.sys.sysobjects WHERE id = OBJECT_ID('tempdb.dbo.#crDetNCBonifAP2') AND type = 'U')
		DROP TABLE #crDetNCBonifAP2

	CREATE TABLE #crDetNCBonifAP2 (
		ID INT PRIMARY KEY IDENTITY (1, 1) NOT NULL
	   ,Mov VARCHAR(25) NULL
	   ,MovID VARCHAR(25) NULL
	   ,AdelantoPagos MONEY NULL
	)
	SELECT @HayNotasCredCanc = COUNT(*)
	FROM NegociaMoratoriosMAVI
	WHERE IDCobro = @ID
	AND AdelantoPagos > 0
	AND NotaCreditoxCanc = '1'

	IF @HayNotasCredCanc = 0
	BEGIN
		INSERT INTO #crGenBonifAP (AdelantoPagos, Origen, OrigenID, IDAdelantoPagos)
			SELECT SUM(ISNULL(AdelantoPagos, 0))
				  ,Origen
				  ,OrigenId
				  ,IDAdelantoPagos
			FROM NegociaMoratoriosMAVI
			WHERE IDCobro = @ID
			AND AdelantoPagos > 0
			GROUP BY Origen
					,OrigenId
					,IDAdelantoPagos
		SELECT @minboni = MIN(ID)
			  ,@maxboni = MAX(ID)
		FROM #crGenBonifAP
		WHILE @minboni <= @maxboni
		BEGIN
		SELECT @AdelantoPagos = AdelantoPagos
			  ,@Origen = Origen
			  ,@OrigenID = OrigenID
			  ,@IDPol = IDAdelantoPagos
		FROM #crGenBonifAP
		WHERE ID = @minboni
		SET @Renglon = 1024.0
		SET @ImpTotalBonif = @AdelantoPagos
		SELECT @UEN = UEN
			  ,@CanalVenta = ClienteEnviarA
		FROM CXC
		WHERE Mov = @Origen
		AND MovId = @OrigenID
		SELECT @MovPadre = @Origen
		SELECT @MovCrear = ISNULL(MovCrear, 'Nota Credito')
		FROM MovCrearBonifMAVI
		WHERE Mov = @Movpadre
		AND UEN = @UEN

		IF @MovCrear IS NULL
			SELECT @MovCrear = 'Nota Credito'

		SELECT @Concepto = Concepto
		FROM MaviBonificacionConf
		WHERE ID = @IDPol
		INSERT INTO Cxc (Empresa, Mov, MovID, FechaEmision, UltimoCambio, Concepto, Proyecto, Moneda, TipoCambio, Usuario, Autorizacion, Referencia, DocFuente,
		Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Cliente, ClienteEnviarA, ClienteMoneda, ClienteTipoCambio,
		Cobrador, Condicion, Vencimiento, FormaCobro, CtaDinero, Importe, Impuestos, Retencion, AplicaManual, ConDesglose, FormaCobro1, FormaCobro2,
		FormaCobro3, FormaCobro4, FormaCobro5, Referencia1, Referencia2, Referencia3, Referencia4, Referencia5, Importe1, Importe2, Importe3,
		Importe4, Importe5, Cambio, DelEfectivo, Agente, ComisionTotal, ComisionPendiente, MovAplica, MovAplicaID, OrigenTipo, Origen, OrigenID,
		Poliza, PolizaID, FechaConclusion, FechaCancelacion, Dinero, DineroID, DineroCtaDinero, ConTramites, VIN, Sucursal, SucursalOrigen, Cajero,
		UEN, PersonalCobrador, FechaOriginal, Nota, Comentarios, LineaCredito, TipoAmortizacion, TipoTasa, Amortizaciones, Comisiones, ComisionesIVA,
		FechaRevision, ContUso, TieneTasaEsp, TasaEsp, Codigo)
			VALUES (@Empresa, @MovCrear, NULL, CAST(CONVERT(VARCHAR, @FechaAplicacion, 101) AS DATETIME), @FechaAplicacion, @Concepto, NULL, @Moneda, @TipoCambio, @Usuario, NULL, @Referencia, NULL, NULL, 'SINAFECTAR', NULL, NULL, NULL, NULL, @Contacto, @CanalVenta, @Moneda, @TipoCambio, NULL, NULL, @FechaAplicacion, NULL, @CtaDinero, NULL, NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, @Sucursal, @Sucursal, NULL, @UEN, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL)
		SELECT @IDCxc = @@IDENTITY
		INSERT INTO #crDetNCBonifAP
			SELECT Mov
				  ,MovID
				  ,AdelantoPagos
			FROM NegociaMoratoriosMAVI
			WHERE IDCobro = @ID
			AND AdelantoPagos > 0
			AND Origen = @Origen
			AND OrigenId = @OrigenID
		SELECT @mindet = MIN(ID)
			  ,@maxdet = MAX(ID)
		FROM #crDetNCBonifAP
		WHILE @mindet <= @maxdet
		BEGIN
		SELECT @Mov = Mov
			  ,@MovID = MovID
			  ,@ImpDocto = AdelantoPagos
		FROM #crDetNCBonifAP
		WHERE ID = @mindet

		IF @ImpTotalBonif > 0
		BEGIN
			SELECT @SdoDoc = Saldo
			FROM CXC
			WHERE Mov = @Mov
			AND MovId = @MovId

			IF @ImpDocto > @SdoDoc
			BEGIN
				SELECT @ImpDocto = @SdoDoc
				SET @ImpTotalBonif = @ImpTotalBonif - @ImpDocto
				INSERT INTO CxcD (ID, Renglon, RenglonSub, Aplica, AplicaID, Importe, Fecha, Sucursal, SucursalOrigen, DescuentoRecargos, InteresesOrdinarios,
				InteresesMoratorios, InteresesOrdinariosQuita, InteresesMoratoriosQuita, ImpuestoAdicional, Retencion)
					VALUES (@IDCxc, @Renglon, 0, @Mov, @MovId, @ImpDocto, NULL, @Sucursal, @Sucursal, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				SET @Renglon = @Renglon + 1024.0
				UPDATE NegociaMoratoriosMAVI
				SET NotaCredBonId = @IDCxc
				WHERE IDCobro = @ID
				AND Origen = @Origen
				AND OrigenId = @OrigenID
				AND IDNoAtraso = @IdPol
			END
			ELSE
			BEGIN

				IF @ImpDocto <= @SdoDoc
				BEGIN
					SET @ImpTotalBonif = @ImpTotalBonif - @ImpDocto
					INSERT INTO CxcD (ID, Renglon, RenglonSub, Aplica, AplicaID, Importe, Fecha, Sucursal, SucursalOrigen, DescuentoRecargos, InteresesOrdinarios,
					InteresesMoratorios, InteresesOrdinariosQuita, InteresesMoratoriosQuita, ImpuestoAdicional, Retencion)
						VALUES (@IDCxc, @Renglon, 0, @Mov, @MovId, @ImpDocto, NULL, @Sucursal, @Sucursal, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
					SET @Renglon = @Renglon + 1024.0
					UPDATE NegociaMoratoriosMAVI
					SET NotaCredBonId = @IDCxc
					WHERE IDCobro = @ID
					AND Origen = @Origen
					AND OrigenId = @OrigenID
					AND IDNoAtraso = @IdPol
				END

			END

		END

		SET @mindet = @mindet + 1
		END
		SELECT @Impuestos = SUM(d.Importe * ISNULL(ca.IVAFiscal, 1.00))
		FROM CXCD d
		JOIN CxcAplica ca
			ON d.Aplica = ca.Mov
			AND d.AplicaID = ca.MovID
			AND ca.Empresa = @Empresa
		WHERE d.ID = @IDCxc
		SELECT @TotalMov = SUM(d.Importe - ISNULL(d.Importe * ca.IVAFiscal, 0))
		FROM CXCD d
		JOIN CxcAplica ca
			ON d.Aplica = ca.Mov
			AND d.AplicaID = ca.MovID
			AND ca.Empresa = @Empresa
		WHERE d.ID = @IDCxc
		UPDATE CXC
		SET Importe = ISNULL(ROUND(@TotalMov, 2), 0.00)
		   ,Impuestos = ISNULL(ROUND(@Impuestos, 2), 0.00)
		   ,Saldo = ISNULL(ROUND(@TotalMov, 2), 0.00) + ISNULL(ROUND(@impuestos, 2), 0.00)
		   ,IDCobroBonifMAVI = @ID
		WHERE ID = @IDCxc
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
			VALUES (@ID, @IDCxc, @MovCrear, NULL, @Ok, @OkRef)

		IF @ImpTotalBonif > 0
		BEGIN
			SELECT @DefImpuesto = DefImpuesto
			FROM EmpresaGral
			WHERE Empresa = @Empresa
			INSERT INTO Cxc (Empresa, Mov, MovID, FechaEmision, UltimoCambio, Concepto, Proyecto, Moneda, TipoCambio, Usuario, Autorizacion, Referencia, DocFuente,
			Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Cliente, ClienteEnviarA, ClienteMoneda, ClienteTipoCambio,
			Cobrador, Condicion, Vencimiento, FormaCobro, CtaDinero, Importe, Impuestos, Retencion, AplicaManual, ConDesglose, FormaCobro1, FormaCobro2,
			FormaCobro3, FormaCobro4, FormaCobro5, Referencia1, Referencia2, Referencia3, Referencia4, Referencia5, Importe1, Importe2, Importe3,
			Importe4, Importe5, Cambio, DelEfectivo, Agente, ComisionTotal, ComisionPendiente, MovAplica, MovAplicaID, OrigenTipo, Origen, OrigenID,
			Poliza, PolizaID, FechaConclusion, FechaCancelacion, Dinero, DineroID, DineroCtaDinero, ConTramites, VIN, Sucursal, SucursalOrigen, Cajero,
			UEN, PersonalCobrador, FechaOriginal, Nota, Comentarios, LineaCredito, TipoAmortizacion, TipoTasa, Amortizaciones, Comisiones, ComisionesIVA,
			FechaRevision, ContUso, TieneTasaEsp, TasaEsp, Codigo)
				VALUES (@Empresa, @MovCrear, NULL, CAST(CONVERT(VARCHAR, @FechaAplicacion, 101) AS DATETIME), @FechaAplicacion, @Concepto, NULL, @Moneda, @TipoCambio, @Usuario, NULL, @Referencia, NULL, NULL, 'SINAFECTAR', NULL, NULL, NULL, NULL, @Contacto, @CanalVenta, @Moneda, @TipoCambio, NULL, NULL, @FechaAplicacion, NULL, @CtaDinero, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, @Sucursal, @Sucursal, NULL, @UEN, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL)
			SELECT @IDCxc2 = @@IDENTITY
			UPDATE CXC
			SET Importe = ROUND(@ImpTotalBonif / (1 + @DefImpuesto / 100.0), 2)
			   ,Impuestos = ROUND(@ImpTotalBonif / (1 + @DefImpuesto / 100.0), 2) * (@DefImpuesto / 100.0)
			   ,Saldo = ROUND(@ImpTotalBonif / (1 + @DefImpuesto / 100.0), 2) + ROUND(@ImpTotalBonif / (1 + @DefImpuesto / 100.0), 2) * (@DefImpuesto / 100.0)
			   ,IDCobroBonifMAVI = @ID
			WHERE ID = @IDCxc2
			EXEC spAfectar 'CXC'
						  ,@IDCxc2
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
				VALUES (@ID, @IDCxc2, @MovCrear, NULL, @Ok, @OkRef)
		END

		SET @minboni = @minboni + 1
		END
	END
	ELSE
	BEGIN
		INSERT INTO #crGenBonifAP (AdelantoPagos, Origen, OrigenID, IDAdelantoPagos)
			SELECT SUM(ISNULL(AdelantoPagos, 0))
				  ,Origen
				  ,OrigenId
				  ,IDAdelantoPagos
			FROM NegociaMoratoriosMAVI
			WHERE IDCobro = @ID
			AND AdelantoPagos > 0
			AND NotaCreditoxCanc = '1'
			GROUP BY Origen
					,OrigenId
					,IDAdelantoPagos
		SELECT @minboni = MIN(ID)
			  ,@maxboni = MAX(ID)
		FROM #crGenBonifAP
		WHILE @minboni <= @maxboni
		BEGIN
		SELECT @AdelantoPagos = AdelantoPagos
			  ,@Origen = Origen
			  ,@OrigenID = OrigenID
			  ,@IDPol = IDAdelantoPagos
		FROM #crGenBonifAP
		SET @Renglon = 1024.0
		SET @ImpTotalBonif = @AdelantoPagos
		SELECT @UEN = UEN
			  ,@CanalVenta = ClienteEnviarA
		FROM CXC
		WHERE Mov = @Origen
		AND MovId = @OrigenID
		SELECT @MovPadre = @Origen
		SELECT @MovCrear = ISNULL(MovCrear, 'Nota Credito')
		FROM MovCrearBonifMAVI
		WHERE Mov = @Movpadre
		AND UEN = @UEN

		IF @MovPadre = 'Credilana'
			SET @MovCrear = 'Nota Credito'

		IF @MovPadre = 'Prestamo Personal'
			SET @MovCrear = 'Nota Credito VIU'

		IF @MovCrear IS NULL
			SELECT @MovCrear = 'Nota Credito'

		SELECT @Concepto = Concepto
		FROM MaviBonificacionConf
		WHERE ID = @IDPol
		INSERT INTO Cxc (Empresa, Mov, MovID, FechaEmision, UltimoCambio, Concepto, Proyecto, Moneda, TipoCambio, Usuario, Autorizacion, Referencia, DocFuente,
		Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Cliente, ClienteEnviarA, ClienteMoneda, ClienteTipoCambio,
		Cobrador, Condicion, Vencimiento, FormaCobro, CtaDinero, Importe, Impuestos, Retencion, AplicaManual, ConDesglose, FormaCobro1, FormaCobro2,
		FormaCobro3, FormaCobro4, FormaCobro5, Referencia1, Referencia2, Referencia3, Referencia4, Referencia5, Importe1, Importe2, Importe3,
		Importe4, Importe5, Cambio, DelEfectivo, Agente, ComisionTotal, ComisionPendiente, MovAplica, MovAplicaID, OrigenTipo, Origen, OrigenID,
		Poliza, PolizaID, FechaConclusion, FechaCancelacion, Dinero, DineroID, DineroCtaDinero, ConTramites, VIN, Sucursal, SucursalOrigen, Cajero,
		UEN, PersonalCobrador, FechaOriginal, Nota, Comentarios, LineaCredito, TipoAmortizacion, TipoTasa, Amortizaciones, Comisiones, ComisionesIVA,
		FechaRevision, ContUso, TieneTasaEsp, TasaEsp, Codigo)
			VALUES (@Empresa, @MovCrear, NULL, CAST(CONVERT(VARCHAR, @FechaAplicacion, 101) AS DATETIME), @FechaAplicacion, @Concepto, NULL, @Moneda, @TipoCambio, @Usuario, NULL, @Referencia, NULL, NULL, 'SINAFECTAR', NULL, NULL, NULL, NULL, @Contacto, @CanalVenta, @Moneda, @TipoCambio, NULL, NULL, @FechaAplicacion, NULL, @CtaDinero, NULL, NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, @Sucursal, @Sucursal, NULL, @UEN, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL)
		SELECT @IDCxc = @@IDENTITY
		INSERT INTO #crDetNCBonifAP (Mov, MovID, AdelantoPagos)
			SELECT Mov
				  ,MovID
				  ,AdelantoPagos
			FROM NegociaMoratoriosMAVI
			WHERE IDCobro = @ID
			AND AdelantoPagos > 0
			AND NotaCreditoxCanc = '1'
			AND Origen = @Origen
			AND OrigenId = @OrigenID
		SELECT @mindet = MIN(ID)
			  ,@maxdet = MAX(ID)
		FROM #crDetNCBonifAP
		WHILE @mindet <= @maxdet
		BEGIN
		SELECT @Mov = Mov
			  ,@MovID = MovID
			  ,@ImpDocto = AdelantoPagos
		FROM #crDetNCBonifAP
		WHERE ID = @mindet

		IF @ImpTotalBonif > 0
		BEGIN
			SELECT @SdoDoc = Saldo
			FROM CXC
			WHERE Mov = @Mov
			AND MovId = @MovId

			IF @ImpDocto > @SdoDoc
			BEGIN
				SELECT @ImpDocto = @SdoDoc
				SET @ImpTotalBonif = @ImpTotalBonif - @ImpDocto
				INSERT INTO CxcD (ID, Renglon, RenglonSub, Aplica, AplicaID, Importe, Fecha, Sucursal, SucursalOrigen, DescuentoRecargos, InteresesOrdinarios,
				InteresesMoratorios, InteresesOrdinariosQuita, InteresesMoratoriosQuita, ImpuestoAdicional, Retencion)
					VALUES (@IDCxc, @Renglon, 0, @Mov, @MovId, @ImpDocto, NULL, @Sucursal, @Sucursal, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				SET @Renglon = @Renglon + 1024.0
				UPDATE NegociaMoratoriosMAVI
				SET NotaCredBonId = @IDCxc
				WHERE IDCobro = @ID
				AND Origen = @Origen
				AND OrigenId = @OrigenID
				AND IDNoAtraso = @IdPol
			END
			ELSE
			BEGIN

				IF @ImpDocto <= @SdoDoc
				BEGIN
					SET @ImpTotalBonif = @ImpTotalBonif - @ImpDocto
					INSERT INTO CxcD (ID, Renglon, RenglonSub, Aplica, AplicaID, Importe, Fecha, Sucursal, SucursalOrigen, DescuentoRecargos, InteresesOrdinarios,
					InteresesMoratorios, InteresesOrdinariosQuita, InteresesMoratoriosQuita, ImpuestoAdicional, Retencion)
						VALUES (@IDCxc, @Renglon, 0, @Mov, @MovId, @ImpDocto, NULL, @Sucursal, @Sucursal, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
					SET @Renglon = @Renglon + 1024.0
					UPDATE NegociaMoratoriosMAVI
					SET NotaCredBonId = @IDCxc
					WHERE IDCobro = @ID
					AND Origen = @Origen
					AND OrigenId = @OrigenID
					AND IDNoAtraso = @IdPol
				END

			END

		END

		SET @mindet = @mindet + 1
		END
		SELECT @Impuestos = SUM(d.Importe * ISNULL(ca.IVAFiscal, 1.00))
		FROM CXCD d
		JOIN CxcAplica ca
			ON d.Aplica = ca.Mov
			AND d.AplicaID = ca.MovID
			AND ca.Empresa = @Empresa
		WHERE d.ID = @IDCxc
		SELECT @TotalMov = SUM(d.Importe - ISNULL(d.Importe * ca.IVAFiscal, 0))
		FROM CXCD d
		JOIN CxcAplica ca
			ON d.Aplica = ca.Mov
			AND d.AplicaID = ca.MovID
			AND ca.Empresa = @Empresa
		WHERE d.ID = @IDCxc
		UPDATE CXC
		SET Importe = ISNULL(ROUND(@TotalMov, 2), 0.00)
		   ,Impuestos = ISNULL(ROUND(@Impuestos, 2), 0.00)
		   ,Saldo = ISNULL(ROUND(@TotalMov, 2), 0.00) + ISNULL(ROUND(@impuestos, 2), 0.00)
		   ,IDCobroBonifMAVI = @ID
		WHERE ID = @IDCxc
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
			VALUES (@ID, @IDCxc, @MovCrear, NULL, @Ok, @OkRef)
		SET @minboni = @minboni + 1
		END
		INSERT INTO #crGenBonifAP2 (AdelantoPagos, Origen, OrigenID, IDAdelantoPagos)
			SELECT SUM(ISNULL(AdelantoPagos, 0))
				  ,Origen
				  ,OrigenId
				  ,IDAdelantoPagos
			FROM NegociaMoratoriosMAVI
			WHERE IDCobro = @ID
			AND AdelantoPagos > 0
			AND NotaCreditoxCanc IS NULL
			GROUP BY Origen
					,OrigenId
					,IDAdelantoPagos
		SELECT @minboni2 = MIN(ID)
			  ,@maxboni2 = MAX(ID)
		FROM #crGenBonifAP2
		WHILE @minboni2 <= @maxboni2
		BEGIN
		SELECT @AdelantoPagos = AdelantoPagos
			  ,@Origen = Origen
			  ,@OrigenID = OrigenID
			  ,@IDPol = IDAdelantoPagos
		FROM #crGenBonifAP2
		WHERE ID = @minboni2
		SET @Renglon = 1024.0
		SET @ImpTotalBonif = @AdelantoPagos
		SELECT @UEN = UEN
			  ,@CanalVenta = ClienteEnviarA
		FROM CXC
		WHERE Mov = @Origen
		AND MovId = @OrigenID
		SELECT @MovPadre = @Origen
		SELECT @MovCrear = ISNULL(MovCrear, 'Nota Credito')
		FROM MovCrearBonifMAVI
		WHERE Mov = @Movpadre
		AND UEN = @UEN

		IF @MovCrear IS NULL
			SELECT @MovCrear = 'Nota Credito'

		SELECT @Concepto = Concepto
		FROM MaviBonificacionConf
		WHERE ID = @IDPol
		INSERT INTO Cxc (Empresa, Mov, MovID, FechaEmision, UltimoCambio, Concepto, Proyecto, Moneda, TipoCambio, Usuario, Autorizacion, Referencia, DocFuente,
		Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Cliente, ClienteEnviarA, ClienteMoneda, ClienteTipoCambio,
		Cobrador, Condicion, Vencimiento, FormaCobro, CtaDinero, Importe, Impuestos, Retencion, AplicaManual, ConDesglose, FormaCobro1, FormaCobro2,
		FormaCobro3, FormaCobro4, FormaCobro5, Referencia1, Referencia2, Referencia3, Referencia4, Referencia5, Importe1, Importe2, Importe3,
		Importe4, Importe5, Cambio, DelEfectivo, Agente, ComisionTotal, ComisionPendiente, MovAplica, MovAplicaID, OrigenTipo, Origen, OrigenID,
		Poliza, PolizaID, FechaConclusion, FechaCancelacion, Dinero, DineroID, DineroCtaDinero, ConTramites, VIN, Sucursal, SucursalOrigen, Cajero,
		UEN, PersonalCobrador, FechaOriginal, Nota, Comentarios, LineaCredito, TipoAmortizacion, TipoTasa, Amortizaciones, Comisiones, ComisionesIVA,
		FechaRevision, ContUso, TieneTasaEsp, TasaEsp, Codigo)
			VALUES (@Empresa, @MovCrear, NULL, CAST(CONVERT(VARCHAR, @FechaAplicacion, 101) AS DATETIME), @FechaAplicacion, @Concepto, NULL, @Moneda, @TipoCambio, @Usuario, NULL, @Referencia, NULL, NULL, 'SINAFECTAR', NULL, NULL, NULL, NULL, @Contacto, @CanalVenta, @Moneda, @TipoCambio, NULL, NULL, @FechaAplicacion, NULL, @CtaDinero, NULL, NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, @Sucursal, @Sucursal, NULL, @UEN, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL)
		SELECT @IDCxc = @@IDENTITY
		INSERT INTO #crDetNCBonifAP2 (Mov, MovID, AdelantoPagos)
			SELECT Mov
				  ,MovID
				  ,AdelantoPagos
			FROM NegociaMoratoriosMAVI
			WHERE IDCobro = @ID
			AND AdelantoPagos > 0
			AND NotaCreditoxCanc IS NULL
			AND Origen = @Origen
			AND OrigenId = @OrigenID
		SELECT @mindet2 = MIN(ID)
			  ,@maxdet2 = MAX(ID)
		FROM #crDetNCBonifAP2
		WHILE @mindet2 <= @maxdet2
		BEGIN
		SELECT @Mov = Mov
			  ,@MovID = MovID
			  ,@ImpDocto = AdelantoPagos
		FROM #crDetNCBonifAP2
		WHERE ID = @mindet2

		IF @ImpTotalBonif > 0
		BEGIN
			SELECT @SdoDoc = Saldo
			FROM CXC
			WHERE Mov = @Mov
			AND MovId = @MovId

			IF @ImpDocto > @SdoDoc
			BEGIN
				SELECT @ImpDocto = @SdoDoc
				SET @ImpTotalBonif = @ImpTotalBonif - @ImpDocto
				INSERT INTO CxcD (ID, Renglon, RenglonSub, Aplica, AplicaID, Importe, Fecha, Sucursal, SucursalOrigen, DescuentoRecargos, InteresesOrdinarios,
				InteresesMoratorios, InteresesOrdinariosQuita, InteresesMoratoriosQuita, ImpuestoAdicional, Retencion)
					VALUES (@IDCxc, @Renglon, 0, @Mov, @MovId, @ImpDocto, NULL, @Sucursal, @Sucursal, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				SET @Renglon = @Renglon + 1024.0
				UPDATE NegociaMoratoriosMAVI
				SET NotaCredBonId = @IDCxc
				WHERE IDCobro = @ID
				AND Origen = @Origen
				AND OrigenId = @OrigenID
				AND IDNoAtraso = @IdPol
			END
			ELSE
			BEGIN

				IF @ImpDocto <= @SdoDoc
				BEGIN
					SET @ImpTotalBonif = @ImpTotalBonif - @ImpDocto
					INSERT INTO CxcD (ID, Renglon, RenglonSub, Aplica, AplicaID, Importe, Fecha, Sucursal, SucursalOrigen, DescuentoRecargos, InteresesOrdinarios,
					InteresesMoratorios, InteresesOrdinariosQuita, InteresesMoratoriosQuita, ImpuestoAdicional, Retencion)
						VALUES (@IDCxc, @Renglon, 0, @Mov, @MovId, @ImpDocto, NULL, @Sucursal, @Sucursal, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
					SET @Renglon = @Renglon + 1024.0
					UPDATE NegociaMoratoriosMAVI
					SET NotaCredBonId = @IDCxc
					WHERE IDCobro = @ID
					AND Origen = @Origen
					AND OrigenId = @OrigenID
					AND IDNoAtraso = @IdPol
				END

			END

		END

		SET @mindet2 = @mindet2 + 1
		END
		SELECT @Impuestos = SUM(d.Importe * ISNULL(ca.IVAFiscal, 1.00))
		FROM CXCD d
		JOIN CxcAplica ca
			ON d.Aplica = ca.Mov
			AND d.AplicaID = ca.MovID
			AND ca.Empresa = @Empresa
		WHERE d.ID = @IDCxc
		SELECT @TotalMov = SUM(d.Importe - ISNULL(d.Importe * ca.IVAFiscal, 0))
		FROM CXCD d
		JOIN CxcAplica ca
			ON d.Aplica = ca.Mov
			AND d.AplicaID = ca.MovID
			AND ca.Empresa = @Empresa
		WHERE d.ID = @IDCxc
		UPDATE CXC
		SET Importe = ISNULL(ROUND(@TotalMov, 2), 0.00)
		   ,Impuestos = ISNULL(ROUND(@Impuestos, 2), 0.00)
		   ,Saldo = ISNULL(ROUND(@TotalMov, 2), 0.00) + ISNULL(ROUND(@impuestos, 2), 0.00)
		   ,IDCobroBonifMAVI = @ID
		WHERE ID = @IDCxc
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
			VALUES (@ID, @IDCxc, @MovCrear, NULL, @Ok, @OkRef)

		IF @ImpTotalBonif > 0
		BEGIN
			SELECT @DefImpuesto = DefImpuesto
			FROM EmpresaGral
			WHERE Empresa = @Empresa
			INSERT INTO Cxc (Empresa, Mov, MovID, FechaEmision, UltimoCambio, Concepto, Proyecto, Moneda, TipoCambio, Usuario, Autorizacion, Referencia, DocFuente,
			Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Cliente, ClienteEnviarA, ClienteMoneda, ClienteTipoCambio,
			Cobrador, Condicion, Vencimiento, FormaCobro, CtaDinero, Importe, Impuestos, Retencion, AplicaManual, ConDesglose, FormaCobro1, FormaCobro2,
			FormaCobro3, FormaCobro4, FormaCobro5, Referencia1, Referencia2, Referencia3, Referencia4, Referencia5, Importe1, Importe2, Importe3,
			Importe4, Importe5, Cambio, DelEfectivo, Agente, ComisionTotal, ComisionPendiente, MovAplica, MovAplicaID, OrigenTipo, Origen, OrigenID,
			Poliza, PolizaID, FechaConclusion, FechaCancelacion, Dinero, DineroID, DineroCtaDinero, ConTramites, VIN, Sucursal, SucursalOrigen, Cajero,
			UEN, PersonalCobrador, FechaOriginal, Nota, Comentarios, LineaCredito, TipoAmortizacion, TipoTasa, Amortizaciones, Comisiones, ComisionesIVA,
			FechaRevision, ContUso, TieneTasaEsp, TasaEsp, Codigo)
				VALUES (@Empresa, @MovCrear, NULL, CAST(CONVERT(VARCHAR, @FechaAplicacion, 101) AS DATETIME), @FechaAplicacion, @Concepto, NULL, @Moneda, @TipoCambio, @Usuario, NULL, @Referencia, NULL, NULL, 'SINAFECTAR', NULL, NULL, NULL, NULL, @Contacto, @CanalVenta, @Moneda, @TipoCambio, NULL, NULL, @FechaAplicacion, NULL, @CtaDinero, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, @Sucursal, @Sucursal, NULL, @UEN, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL)
			SELECT @IDCxc2 = @@IDENTITY
			UPDATE CXC
			SET Importe = ROUND(@ImpTotalBonif / (1 + @DefImpuesto / 100.0), 2)
			   ,Impuestos = ROUND(@ImpTotalBonif / (1 + @DefImpuesto / 100.0), 2) * (@DefImpuesto / 100.0)
			   ,Saldo = ROUND(@ImpTotalBonif / (1 + @DefImpuesto / 100.0), 2) + ROUND(@ImpTotalBonif / (1 + @DefImpuesto / 100.0), 2) * (@DefImpuesto / 100.0)
			   ,IDCobroBonifMAVI = @ID
			WHERE ID = @IDCxc2
			EXEC spAfectar 'CXC'
						  ,@IDCxc2
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
				VALUES (@ID, @IDCxc2, @MovCrear, NULL, @Ok, @OkRef)
		END

		SET @minboni2 = @minboni2 + 1
		END
	END

END
	RETURN

