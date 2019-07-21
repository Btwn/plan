SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[spDocAuto]
 @ID INT
,@InteresesMov CHAR(20)
,@DocMov CHAR(20)
,@Usuario CHAR(10) = NULL
,@Conexion BIT = 0
,@SincroFinal BIT = 0
,@Ok INT = NULL OUTPUT
,@OkRef VARCHAR(255) = NULL OUTPUT
AS
BEGIN
	DECLARE
		@Sucursal INT
	   ,@a INT
	   ,@Empresa CHAR(5)
	   ,@Modulo CHAR(5)
	   ,@Cuenta CHAR(10)
	   ,@Moneda CHAR(10)
	   ,@Mov CHAR(20)
	   ,@MovID VARCHAR(20)
	   ,@MovTipo CHAR(20)
	   ,@MovAplicaImporte MONEY
	   ,@Condicion VARCHAR(50)
	   ,@Importe MONEY
	   ,@Impuestos MONEY
	   ,@ImporteDocumentar MONEY
	   ,@ImporteTotal MONEY
	   ,@Intereses MONEY
	   ,@InteresesImpuestos MONEY
	   ,@InteresesConcepto VARCHAR(50)
	   ,@InteresesAplicaImporte MONEY
	   ,@NumeroDocumentos INT
	   ,@PrimerVencimiento DATETIME
	   ,@Periodo CHAR(15)
	   ,@Concepto VARCHAR(50)
	   ,@Observaciones VARCHAR(100)
	   ,@Estatus CHAR(15)
	   ,@DocEstatus CHAR(15)
	   ,@FechaEmision DATETIME
	   ,@FechaRegistro DATETIME
	   ,@MovUsuario CHAR(10)
	   ,@Proyecto VARCHAR(50)
	   ,@Referencia VARCHAR(50)
	   ,@TipoCambio FLOAT
	   ,@Saldo MONEY
	   ,@InteresesID INT
	   ,@InteresesMovID VARCHAR(20)
	   ,@DocID INT
	   ,@DocMovID VARCHAR(20)
	   ,@DocImporte MONEY
	   ,@SumaImporte1 MONEY
	   ,@SumaImporte2 MONEY
	   ,@SumaImporte3 MONEY
	   ,@DocAutoFolio CHAR(20)
	   ,@Importe1 MONEY
	   ,@Importe2 MONEY
	   ,@Importe3 MONEY
	   ,@Dif MONEY
	   ,@Vencimiento DATETIME
	   ,@Dia INT
	   ,@EsQuince BIT
	   ,@ImpPrimerDoc BIT
	   ,@Mensaje VARCHAR(255)
	   ,@PPFechaEmision DATETIME
	   ,@PPVencimiento DATETIME
	   ,@PPDias INT
	   ,@PPFechaProntoPago DATETIME
	   ,@PPDescuentoProntoPago FLOAT
	   ,@ClienteEnviarA INT
	   ,@Cobrador VARCHAR(50)
	   ,@PersonalCobrador CHAR(10)
	   ,@Agente CHAR(10)
	   ,@DesglosarImpuestos BIT
	   ,@AplicaImpuestos MONEY
	   ,@RedondeoMonetarios INT
	   ,@Tasa VARCHAR(50)
	   ,@RamaID INT
	   ,@InteresPorcentaje FLOAT
	   ,@PagoMensual MONEY
	   ,@CapitalAnterior MONEY
	   ,@CapitalInsoluto MONEY
	   ,@CfgDocAutoBorrador BIT
	   ,@CorteDias INT
	   ,@MenosDias INT
	SET @CorteDias = 2
	SELECT @RedondeoMonetarios = RedondeoMonetarios
	FROM Version
	SELECT @EsQuince = 0
		  ,@Saldo = 0.0
		  ,@Proyecto = NULL
		  ,@FechaRegistro = GETDATE()
		  ,@SumaImporte1 = 0.0
		  ,@SumaImporte2 = 0.0
		  ,@SumaImporte3 = 0.0
		  ,@DesglosarImpuestos = 0
	SELECT @Sucursal = Sucursal
		  ,@Empresa = Empresa
		  ,@Modulo = Modulo
		  ,@Cuenta = Cuenta
		  ,@Moneda = Moneda
		  ,@Mov = Mov
		  ,@MovID = MovID
		  ,@ImporteDocumentar = ImporteDocumentar
		  ,@Intereses = ISNULL(Intereses, 0.0)
		  ,@InteresesImpuestos = ISNULL(InteresesImpuestos, 0.0)
		  ,@InteresesConcepto = InteresesConcepto
		  ,@NumeroDocumentos = NumeroDocumentos
		  ,@PrimerVencimiento = PrimerVencimiento
		  ,@Periodo = UPPER(Periodo)
		  ,@Concepto = Concepto
		  ,@Observaciones = Observaciones
		  ,@Estatus = Estatus
		  ,@FechaEmision = FechaEmision
		  ,@MovUsuario = Usuario
		  ,@ImpPrimerDoc = ImpPrimerDoc
		  ,@Condicion = Condicion
		  ,@InteresPorcentaje = NULLIF(Interes / 100, 0)
	FROM DocAuto
	WHERE ID = @ID
	SELECT @TipoCambio = TipoCambio
	FROM Mon
	WHERE Moneda = @Moneda

	IF NULLIF(RTRIM(@Usuario), '') IS NULL
		SELECT @Usuario = @MovUsuario

	SELECT @MovTipo = Clave
	FROM MovTipo
	WHERE Modulo = @Modulo
	AND Mov = @Mov
	SELECT @PPFechaEmision = @FechaEmision
		  ,@DocMov = NULLIF(NULLIF(RTRIM(@DocMov), ''), '0')

	IF @DocMov IS NULL
		SELECT @Ok = 10160

	SELECT @CfgDocAutoBorrador = ISNULL(CASE @Modulo
		 WHEN 'CXC' THEN CxcDocAutoBorrador
		 ELSE CxpDocAutoBorrador
	 END, 0)
	FROM EmpresaCfg2
	WHERE Empresa = @Empresa

	IF @CfgDocAutoBorrador = 1
		SELECT @DocEstatus = 'BORRADOR'
	ELSE
		SELECT @DocEstatus = 'SINAFECTAR'

	IF @MovTipo IN ('CXC.A', 'CXC.AR', 'CXC.DA', 'CXC.NC', 'CXC.DAC', 'CXP.A', 'CXP.DA', 'CXP.NC', 'CXP.DAC')
	BEGIN
		SELECT @Intereses = 0.0
			  ,@InteresesImpuestos = 0.0
		SELECT @DocAutoFolio =
		 CASE @Modulo
			 WHEN 'CXC' THEN NULLIF(RTRIM(CxcDocAnticipoAutoFolio), '')
			 WHEN 'CXP' THEN NULLIF(RTRIM(CxpDocAnticipoAutoFolio), '')
			 ELSE NULL
		 END
		FROM EmpresaCfg
		WHERE Empresa = @Empresa
	END
	ELSE
		SELECT @DocAutoFolio =
		 CASE @Modulo
			 WHEN 'CXC' THEN NULLIF(RTRIM(CxcDocAutoFolio), '')
			 WHEN 'CXP' THEN NULLIF(RTRIM(CxpDocAutoFolio), '')
			 ELSE NULL
		 END
		FROM EmpresaCfg
		WHERE Empresa = @Empresa

	IF @Modulo = 'CXC'
		SELECT @DesglosarImpuestos = ISNULL(CxcCobroImpuestos, 0)
		FROM EmpresaCfg2
		WHERE Empresa = @Empresa

	IF @Estatus = 'SINAFECTAR'
		AND @NumeroDocumentos > 0
	BEGIN

		IF @Modulo = 'CXC'
			SELECT @RamaID = ID
				  ,@Importe = ISNULL(Importe, 0.0)
				  ,@Impuestos = ISNULL(Impuestos, 0.0)
				  ,@Saldo = ISNULL(Saldo, 0.0)
				  ,@Proyecto = Proyecto
				  ,@ClienteEnviarA = ClienteEnviarA
				  ,@Agente = Agente
				  ,@Cobrador = Cobrador
				  ,@PersonalCobrador = PersonalCobrador
			FROM Cxc
			WHERE Empresa = @Empresa
			AND Cliente = @Cuenta
			AND Mov = @Mov
			AND MovID = @MovID
			AND Estatus = 'PENDIENTE'
		ELSE

		IF @Modulo = 'CXP'
			SELECT @RamaID = ID
				  ,@Importe = ISNULL(Importe, 0.0)
				  ,@Impuestos = ISNULL(Impuestos, 0.0)
				  ,@Saldo = ISNULL(Saldo, 0.0)
				  ,@Proyecto = Proyecto
			FROM Cxp
			WHERE Empresa = @Empresa
			AND Proveedor = @Cuenta
			AND Mov = @Mov
			AND MovID = @MovID
			AND Estatus = 'PENDIENTE'

		SELECT @ImporteTotal = @ImporteDocumentar + @Intereses + @InteresesImpuestos

		IF @Saldo < @ImporteDocumentar
			SELECT @Ok = 35190

		IF @Ok IS NULL
		BEGIN

			IF @Conexion = 0
				BEGIN TRANSACTION

			IF @Intereses > 0.0
			BEGIN
				SELECT @Referencia = RTRIM(@Mov) + ' ' + LTRIM(CONVERT(CHAR, @MovID))

				IF @Modulo = 'CXC'
				BEGIN
					INSERT Cxc (Sucursal, OrigenTipo, Origen, OrigenID, Empresa, Mov, FechaEmision, Concepto, Proyecto, Moneda, TipoCambio, Usuario, Referencia, Observaciones, Estatus,
					Cliente, ClienteMoneda, ClienteTipoCambio, Importe, Impuestos,
					ClienteEnviarA, Agente, Cobrador, PersonalCobrador, Tasa, RamaID)
						VALUES (@Sucursal, @Modulo, @Mov, @MovID, @Empresa, @InteresesMov, @FechaEmision, @InteresesConcepto, @Proyecto, @Moneda, @TipoCambio, @Usuario, @Referencia, @Observaciones, @DocEstatus, @Cuenta, @Moneda, @TipoCambio, @Intereses, @InteresesImpuestos, @ClienteEnviarA, @Agente, @Cobrador, @PersonalCobrador, @Tasa, @RamaID)
					SELECT @InteresesID = @@IDENTITY
				END
				ELSE

				IF @Modulo = 'CXP'
				BEGIN
					INSERT Cxp (Sucursal, OrigenTipo, Origen, OrigenID, Empresa, Mov, FechaEmision, Concepto, Proyecto, Moneda, TipoCambio, Usuario, Referencia, Observaciones, Estatus,
					Proveedor, ProveedorMoneda, ProveedorTipoCambio, Importe, Impuestos, Tasa, RamaID)
						VALUES (@Sucursal, @Modulo, @Mov, @MovID, @Empresa, @InteresesMov, @FechaEmision, @InteresesConcepto, @Proyecto, @Moneda, @TipoCambio, @Usuario, @Referencia, @Observaciones, @DocEstatus, @Cuenta, @Moneda, @TipoCambio, @Intereses, @InteresesImpuestos, @Tasa, @RamaID)
					SELECT @InteresesID = @@IDENTITY
				END

				IF @CfgDocAutoBorrador = 0
					EXEC spCx @InteresesID
							 ,@Modulo
							 ,'AFECTAR'
							 ,'TODO'
							 ,@FechaRegistro
							 ,NULL
							 ,@Usuario
							 ,1
							 ,0
							 ,@InteresesMov OUTPUT
							 ,@InteresesMovID OUTPUT
							 ,NULL
							 ,@Ok OUTPUT
							 ,@OkRef OUTPUT

			END
			ELSE
				SELECT @InteresesImpuestos = 0.0

			IF @Periodo = 'QUINCENAL'
			BEGIN
				SELECT @Dia = DATEPART(dd, @PrimerVencimiento)
				SELECT @MenosDias = DATEPART(dd, DATEADD(mm, 1, @PrimerVencimiento))
				SELECT @MenosDias = (@Dia - @MenosDias) + 15

				IF @Dia <= 15
				BEGIN
					SELECT @EsQuince = 1
						  ,@PrimerVencimiento = DATEADD(dd, 15 - @Dia, @PrimerVencimiento)
					SET @PrimerVencimiento = DATEADD(dd, @CorteDias, @PrimerVencimiento)
					UPDATE VENTA
					SET vencimiento = @PrimerVencimiento
					WHERE mov = @Mov
					AND MovID = @MovID
					UPDATE CXC
					SET vencimiento = @PrimerVencimiento
					WHERE mov = @Mov
					AND MovID = @MovID
				END
				ELSE
				BEGIN

					IF @Dia >= 16
						AND @Dia <= 30
					BEGIN
						SELECT @EsQuince = 0
							  ,@PrimerVencimiento = DATEADD(dd, -DATEPART(dd, @PrimerVencimiento), DATEADD(mm, 1, @PrimerVencimiento))
						SET @PrimerVencimiento = DATEADD(dd, @CorteDias, @PrimerVencimiento)

						IF (DATEPART(dd, @PrimerVencimiento) = 1)
							SET @PrimerVencimiento = DATEADD(dd, 1, @PrimerVencimiento)

						IF (DATEPART(dd, @PrimerVencimiento) = 31)
							SET @PrimerVencimiento = DATEADD(dd, 2, @PrimerVencimiento)

						UPDATE VENTA
						SET vencimiento = @PrimerVencimiento
						WHERE mov = @Mov
						AND MovID = @MovID
						UPDATE CXC
						SET vencimiento = @PrimerVencimiento
						WHERE mov = @Mov
						AND MovID = @MovID
					END
					ELSE
					BEGIN
						SELECT @EsQuince = 0
							  ,@PrimerVencimiento = DATEADD(dd, -DATEPART(dd, @PrimerVencimiento), DATEADD(mm, 1, @PrimerVencimiento))
						SET @PrimerVencimiento = DATEADD(dd, @CorteDias + @MenosDias, @PrimerVencimiento)
						UPDATE VENTA
						SET vencimiento = @PrimerVencimiento
						WHERE mov = @Mov
						AND MovID = @MovID
						UPDATE CXC
						SET vencimiento = @PrimerVencimiento
						WHERE mov = @Mov
						AND MovID = @MovID
					END

				END

			END

			IF @ImpPrimerDoc = 1
				AND @ImporteDocumentar = @Importe + @Impuestos
				SELECT @ImporteDocumentar = @Importe

			SELECT @a = 1
				  ,@MovAplicaImporte = ROUND(@ImporteDocumentar / @NumeroDocumentos, @RedondeoMonetarios)
				  ,@InteresesAplicaImporte = ROUND((@Intereses + @InteresesImpuestos) / @NumeroDocumentos, @RedondeoMonetarios)
				  ,@Vencimiento = @PrimerVencimiento
			SELECT @PagoMensual = @MovAplicaImporte + ISNULL(@InteresesAplicaImporte, 0)

			IF @ImpPrimerDoc = 1
				SELECT @DocImporte = @MovAplicaImporte
			ELSE
				SELECT @DocImporte = @MovAplicaImporte + @InteresesAplicaImporte

			SELECT @CapitalAnterior = @ImporteDocumentar
			WHILE (@a <= @NumeroDocumentos)
			AND @Ok IS NULL
			BEGIN
			SELECT @Importe1 = 0.0
				  ,@Importe2 = 0.0
				  ,@Importe3 = 0.0

			IF @ImpPrimerDoc = 1
				AND @a = 1
			BEGIN
				SELECT @Importe1 = @DocImporte + @Impuestos + @Intereses + @InteresesImpuestos
					  ,@Importe2 = @DocImporte + @Impuestos
					  ,@Importe3 = @Intereses + @InteresesImpuestos
			END
			ELSE
			BEGIN
				SELECT @Importe1 = @DocImporte
					  ,@Importe2 = @MovAplicaImporte

				IF @ImpPrimerDoc = 1
					SELECT @Importe3 = 0.0
				ELSE
				BEGIN
					SELECT @Importe3 = @InteresesAplicaImporte

					IF @InteresPorcentaje IS NOT NULL
					BEGIN
						SELECT @CapitalInsoluto = (@ImporteDocumentar * POWER(1 + @InteresPorcentaje, @a)) - (@PagoMensual * ((POWER(1 + @InteresPorcentaje, @a) - 1) / @InteresPorcentaje))
						SELECT @Importe2 = @CapitalAnterior - @CapitalInsoluto
						SELECT @Importe3 = @MovAplicaImporte + @InteresesAplicaImporte - @Importe2
						SELECT @CapitalAnterior = @CapitalInsoluto
					END

				END

			END

			SELECT @SumaImporte1 = @SumaImporte1 + @Importe1
				  ,@SumaImporte2 = @SumaImporte2 + @Importe2
				  ,@SumaImporte3 = @SumaImporte3 + @Importe3

			IF @a = @NumeroDocumentos
			BEGIN
				SELECT @Dif = @SumaImporte2 - @ImporteDocumentar

				IF @Dif <> 0.0
					SELECT @Importe1 = @Importe1 - @Dif
						  ,@Importe2 = @Importe2 - @Dif

				SELECT @Dif = @SumaImporte3 - (@Intereses + @InteresesImpuestos)

				IF @Dif <> 0.0
					SELECT @Importe1 = @Importe1 - @Dif
						  ,@Importe3 = @Importe3 - @Dif

			END

			SELECT @Referencia = RTRIM(@Mov) + ' ' + LTRIM(RTRIM(CONVERT(CHAR, @MovID))) + ' (' + LTRIM(RTRIM(CONVERT(CHAR, @a))) + '/' + LTRIM(RTRIM(CONVERT(CHAR, @NumeroDocumentos))) + ')'

			IF @Mov = @DocAutoFolio
				SELECT @DocMovID = RTRIM(@MovID) + '-' + LTRIM(CONVERT(CHAR, @a))
			ELSE
				SELECT @DocMovID = NULL

			EXEC spCalcularVencimientoPP @Modulo
										,@Empresa
										,@Cuenta
										,@Condicion
										,@PPFechaEmision
										,@PPVencimiento OUTPUT
										,@PPDias OUTPUT
										,@PPFechaProntoPago OUTPUT
										,@PPDescuentoProntoPago OUTPUT
										,@Tasa OUTPUT
										,@Ok OUTPUT

			IF @Modulo = 'CXC'
			BEGIN
				INSERT Cxc (Sucursal, OrigenTipo, Origen, OrigenID, Empresa, Mov, MovID, FechaEmision, Concepto, Proyecto, Moneda, TipoCambio, Usuario, Referencia, Observaciones, Estatus,
				Cliente, ClienteMoneda, ClienteTipoCambio, Importe, Condicion, Vencimiento, AplicaManual, FechaProntoPago, DescuentoProntoPago,
				ClienteEnviarA, Agente, Cobrador, PersonalCobrador, Tasa, RamaID)
					VALUES (@Sucursal, @Modulo, @Mov, @MovID, @Empresa, @DocMov, @DocMovID, @FechaEmision, @Concepto, @Proyecto, @Moneda, @TipoCambio, @Usuario, @Referencia, @Observaciones, @DocEstatus, @Cuenta, @Moneda, @TipoCambio, @Importe1, '(Fecha)', @Vencimiento, 1, @PPFechaProntoPago, @PPDescuentoProntoPago, @ClienteEnviarA, @Agente, @Cobrador, @PersonalCobrador, @Tasa, @RamaID)
				SELECT @DocID = @@IDENTITY

				IF @Importe2 > 0.0
					INSERT CxcD (Sucursal, ID, Renglon, Aplica, AplicaID, Importe)
						VALUES (@Sucursal, @DocID, 2048, @Mov, @MovID, @Importe2)

				IF @Importe3 > 0.0
					INSERT CxcD (Sucursal, ID, Renglon, Aplica, AplicaID, Importe)
						VALUES (@Sucursal, @DocID, 4096, @InteresesMov, @InteresesMovID, @Importe3)

				IF @DesglosarImpuestos = 1
				BEGIN
					SELECT @AplicaImpuestos = NULLIF(SUM(d.Importe * c.IVAFiscal * ISNULL(c.IEPSFiscal, 1)), 0)
					FROM CxcD d
						,Cxc c
					WHERE d.ID = @DocID
					AND c.Empresa = @Empresa
					AND c.Mov = d.Aplica
					AND c.MovID = d.AplicaID
					AND c.Estatus = 'PENDIENTE'
					AND FechaEmision = @FechaEmision

					IF @AplicaImpuestos IS NOT NULL
						UPDATE Cxc
						SET Importe = Importe - @AplicaImpuestos
						   ,Impuestos = @AplicaImpuestos
						WHERE ID = @DocID

				END

			END
			ELSE

			IF @Modulo = 'CXP'
			BEGIN
				INSERT Cxp (Sucursal, OrigenTipo, Origen, OrigenID, Empresa, Mov, MovID, FechaEmision, Concepto, Proyecto, Moneda, TipoCambio, Usuario, Referencia, Observaciones, Estatus,
				Proveedor, ProveedorMoneda, ProveedorTipoCambio, Importe, Condicion, Vencimiento, AplicaManual, FechaProntoPago, DescuentoProntoPago, Tasa, RamaID)
					VALUES (@Sucursal, @Modulo, @Mov, @MovID, @Empresa, @DocMov, @DocMovID, @FechaEmision, @Concepto, @Proyecto, @Moneda, @TipoCambio, @Usuario, @Referencia, @Observaciones, @DocEstatus, @Cuenta, @Moneda, @TipoCambio, @Importe1, '(Fecha)', @Vencimiento, 1, @PPFechaProntoPago, @PPDescuentoProntoPago, @Tasa, @RamaID)
				SELECT @DocID = @@IDENTITY

				IF @Importe2 > 0.0
					INSERT CxpD (Sucursal, ID, Renglon, Aplica, AplicaID, Importe)
						VALUES (@Sucursal, @DocID, 2048, @Mov, @MovID, @Importe2)

				IF @Importe3 > 0.0
					INSERT CxpD (Sucursal, ID, Renglon, Aplica, AplicaID, Importe)
						VALUES (@Sucursal, @DocID, 4096, @InteresesMov, @InteresesMovID, @Importe3)

			END

			IF @CfgDocAutoBorrador = 0
				EXEC spCx @DocID
						 ,@Modulo
						 ,'AFECTAR'
						 ,'TODO'
						 ,@FechaRegistro
						 ,NULL
						 ,@Usuario
						 ,1
						 ,0
						 ,@DocMov OUTPUT
						 ,@DocMovID OUTPUT
						 ,NULL
						 ,@Ok OUTPUT
						 ,@OkRef OUTPUT

			IF @Ok IS NULL
			BEGIN
				SELECT @PPFechaEmision = DATEADD(DAY, 1, @Vencimiento)

				IF ISNUMERIC(@Periodo) = 1
					SELECT @Vencimiento = DATEADD(DAY, CONVERT(INT, @Periodo) * @a, @PrimerVencimiento)
				ELSE

				IF @Periodo = 'SEMANAL'
					SELECT @Vencimiento = DATEADD(wk, @a, @PrimerVencimiento)
				ELSE

				IF @Periodo = 'MENSUAL'
					SELECT @Vencimiento = DATEADD(mm, @a, @PrimerVencimiento)
				ELSE

				IF @Periodo = 'BIMESTRAL'
					SELECT @Vencimiento = DATEADD(mm, @a * 2, @PrimerVencimiento)
				ELSE

				IF @Periodo = 'TRIMESTRAL'
					SELECT @Vencimiento = DATEADD(mm, @a * 3, @PrimerVencimiento)
				ELSE

				IF @Periodo = 'SEMESTRAL'
					SELECT @Vencimiento = DATEADD(mm, @a * 6, @PrimerVencimiento)
				ELSE

				IF @Periodo = 'ANUAL'
					SELECT @Vencimiento = DATEADD(yy, @a, @PrimerVencimiento)
				ELSE

				IF @Periodo = 'QUINCENAL'
				BEGIN

					IF @EsQuince = 1
						SELECT @EsQuince = 0
							  ,@Vencimiento = DATEADD(dd, -15, DATEADD(mm, 1, @Vencimiento))
					ELSE
						SELECT @EsQuince = 1
							  ,@Vencimiento = DATEADD(dd, 15, @Vencimiento)

				END
				ELSE
					SELECT @Ok = 55140

				SELECT @a = @a + 1
			END

			END

			IF @Conexion = 0
			BEGIN

				IF @Ok IS NULL
					COMMIT TRANSACTION
				ELSE
					ROLLBACK TRANSACTION

			END

		END

	END
	ELSE
		SELECT @Ok = 60040

	IF @Ok IS NULL
		SELECT @Mensaje = "Proceso Concluido."
	ELSE
	BEGIN
		SELECT @Mensaje = Descripcion
		FROM MensajeLista
		WHERE Mensaje = @Ok

		IF @OkRef IS NOT NULL
			SELECT @Mensaje = RTRIM(@Mensaje) + '<BR><BR>' + @OkRef

	END

	IF @Conexion = 0
		SELECT @Mensaje

	RETURN
END
GO