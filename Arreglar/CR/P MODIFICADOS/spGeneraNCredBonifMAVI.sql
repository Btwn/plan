SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spGeneraNCredBonifMAVI]
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
	   ,@ContadoComercial MONEY
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
	   ,@Impuestos MONEY
	   ,@CanalVenta INT
	   ,@DocsPend INT
	   ,@SdoDoc MONEY
	   ,@ImpTotalBonif MONEY
	   ,@IDCxc2 INT
	   ,@DefImpuesto FLOAT
	   ,@min INT
	   ,@max INT
	   ,@mindet INT
	   ,@maxdet INT
	SET @DocsPend = 0
	SET @FechaAplicacion = GETDATE()
	SELECT @Empresa = Empresa
		  ,@Sucursal = Sucursal
		  ,@Hoy = FechaEmision
		  ,@Moneda = Moneda
		  ,@TipoCambio = TipoCambio
		  ,@Contacto = Cliente
	FROM Cxc
WITH(NOLOCK) WHERE ID = @ID

	IF EXISTS (SELECT ID FROM tempdb.sys.sysobjects WHERE id = OBJECT_ID('tempdb.dbo.#crGenBonif') AND type = 'U')
		DROP TABLE #crGenBonif

	CREATE TABLE #crGenBonif (
		ID INT PRIMARY KEY IDENTITY (1, 1) NOT NULL
	   ,ContadoComercial MONEY NULL
	   ,Origen VARCHAR(25) NULL
	   ,OrigenID VARCHAR(25) NULL
	   ,IDContadoComercial INT
	)

	IF EXISTS (SELECT ID FROM tempdb.sys.sysobjects WHERE id = OBJECT_ID('tempdb.dbo.#crDetNCBonif') AND type = 'U')
		DROP TABLE #crDetNCBonif

	CREATE TABLE #crDetNCBonif (
		ID INT PRIMARY KEY IDENTITY (1, 1) NOT NULL
	   ,Mov VARCHAR(25) NULL
	   ,MovID VARCHAR(25) NULL
	   ,ContadoComercial MONEY NULL
	)
	INSERT INTO #crGenBonif (ContadoComercial, Origen, OrigenID, IDContadoComercial)
		SELECT SUM(ISNULL(ContadoComercial, 0))
			  ,Origen
			  ,OrigenId
			  ,IDContadoComercial
		FROM NegociaMoratoriosMAVI
WITH(NOLOCK) WHERE IDCobro = @ID
		AND ContadoComercial > 0
		GROUP BY Origen
				,OrigenId
				,IDContadoComercial
	SELECT @min = MIN(ID)
		  ,@max = MAX(ID)
	FROM #crGenBonif
	WHILE @min <= @max
	BEGIN
	SELECT @ContadoComercial = ContadoComercial
		  ,@Origen = Origen
		  ,@OrigenID = OrigenID
		  ,@IDPol = IDContadoComercial
	FROM #crGenBonif
	WHERE ID = @min
	SET @ImpTotalBonif = @ContadoComercial
	SET @Renglon = 1024.0
	SELECT @UEN = UEN
		  ,@CanalVenta = ClienteEnviarA
	FROM CXC
WITH(NOLOCK) WHERE Mov = @Origen
	AND MovId = @OrigenID
	SELECT @MovPadre = @Origen
	SELECT @MovCrear = ISNULL(MovCrear, 'Nota Credito')
	FROM MovCrearBonifMAVI
WITH(NOLOCK) WHERE Mov = @Movpadre
	AND UEN = @UEN

	IF @MovCrear IS NULL
		SELECT @MovCrear = 'Nota Credito'

	SELECT @Concepto = Concepto
	FROM MaviBonificacionConf
WITH(NOLOCK) WHERE ID = @IDPol
	SELECT @DocsPend = COUNT(*)
	FROM CXC
WITH(NOLOCK) WHERE PadreMAVI = @Origen
	AND PadreIDMAVI = @OrigenID
	AND Estatus = 'PENDIENTE'

	IF @DocsPend > 0
	BEGIN
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
		INSERT INTO #crDetNCBonif (Mov, MovID, ContadoComercial)
			SELECT Mov
				  ,MovID
				  ,ContadoComercial
			FROM NegociaMoratoriosMAVI
WITH(NOLOCK) WHERE IDCobro = @ID
			AND ContadoComercial > 0
			AND Origen = @Origen
			AND OrigenId = @OrigenID
		SELECT @mindet = MIN(ID)
			  ,@maxdet = MAX(ID)
		FROM #crDetNCBonif
		WHILE @mindet <= @maxdet
		BEGIN
		SELECT @Mov = Mov
			  ,@MovID = MovID
			  ,@ImpDocto = ContadoComercial
		FROM #crDetNCBonif
		WHERE ID = @mindet

		IF @ImpTotalBonif > 0
		BEGIN
			SELECT @SdoDoc = Saldo
			FROM CXC
WITH(NOLOCK) WHERE Mov = @Mov
			AND MovId = @MovId

			IF @ImpDocto > @SdoDoc
			BEGIN
				SELECT @ImpDocto = @SdoDoc
				SET @ImpTotalBonif = @ImpTotalBonif - @ImpDocto
				INSERT INTO CxcD (ID, Renglon, RenglonSub, Aplica, AplicaID, Importe, Fecha, Sucursal, SucursalOrigen, DescuentoRecargos, InteresesOrdinarios,
				InteresesMoratorios, InteresesOrdinariosQuita, InteresesMoratoriosQuita, ImpuestoAdicional, Retencion)
					VALUES (@IDCxc, @Renglon, 0, @Mov, @MovId, @ImpDocto, NULL, @Sucursal, @Sucursal, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				SET @Renglon = @Renglon + 1024.0
				UPDATE NegociaMoratoriosMAVI WITH(ROWLOCK)
		SET NotaCredBonId = @IDCxc
				WHERE IDCobro = @ID
				AND Origen = @Origen
				AND OrigenId = @OrigenID
				AND IDContadoComercial = @IdPol
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
					UPDATE NegociaMoratoriosMAVI WITH(ROWLOCK)
		SET NotaCredBonId = @IDCxc
					WHERE IDCobro = @ID
					AND Origen = @Origen
					AND OrigenId = @OrigenID
					AND IDContadoComercial = @IdPol
				END

			END

		END

		SET @mindet = @mindet + 1
		END
		SELECT @Impuestos = SUM(d.Importe * ISNULL(ca.IVAFiscal, 0.00))
		FROM CXCD d
		 WITH(NOLOCK) JOIN CxcAplica ca WITH(NOLOCK)
			ON d.Aplica = ca.Mov
			AND d.AplicaID = ca.MovID
			AND ca.Empresa = @Empresa
		WHERE d.ID = @IDCxc
		SELECT @TotalMov = SUM(d.Importe - ISNULL(d.Importe * ca.IVAFiscal, 0))
		FROM CXCD d
		 WITH(NOLOCK) JOIN CxcAplica ca WITH(NOLOCK)
			ON d.Aplica = ca.Mov
			AND d.AplicaID = ca.MovID
			AND ca.Empresa = @Empresa
		WHERE d.ID = @IDCxc
		UPDATE CXC WITH(ROWLOCK)
		SET Importe = ISNULL(ROUND(@TotalMov, 2), 0.00)
		   ,Impuestos = ISNULL(ROUND(@Impuestos, 2), 0.00)
		   ,Saldo = ISNULL(ROUND(@TotalMov, 2), 0.00) + ISNULL(ROUND(@impuestos, 2), 0.00)
		   ,IDCobroBonifMAVI = @ID
		WHERE ID = @IDCxc
	END

	IF @IDCxc > 0
	BEGIN
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
	END

	IF @ImpTotalBonif > 0
	BEGIN
		SELECT @DefImpuesto = DefImpuesto
		FROM EmpresaGral
WITH(NOLOCK) WHERE Empresa = @Empresa
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
		UPDATE CXC WITH(ROWLOCK)
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

	SET @min = @min + 1
	END
END
	RETURN

