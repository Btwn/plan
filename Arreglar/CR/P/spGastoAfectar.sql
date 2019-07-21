SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spGastoAfectar]
 @ID INT
,@Accion CHAR(20)
,@Base CHAR(20)
,@Empresa CHAR(5)
,@Modulo CHAR(5)
,@Mov CHAR(20)
,@MovID VARCHAR(20) OUTPUT
,@MovTipo CHAR(20)
,@MovMoneda CHAR(10)
,@MovTipoCambio FLOAT
,@FechaEmision DATETIME
,@FechaAfectacion DATETIME
,@FechaConclusion DATETIME
,@Proyecto VARCHAR(50)
,@Usuario CHAR(10)
,@Autorizacion CHAR(10)
,@DocFuente INT
,@Observaciones VARCHAR(255)
,@Estatus CHAR(15)
,@EstatusNuevo CHAR(15)
,@FechaRegistro DATETIME
,@Ejercicio INT
,@Periodo INT
,@Acreedor CHAR(10)
,@Periodicidad CHAR(20)
,@Condicion VARCHAR(50)
,@Vencimiento DATETIME
,@CtaDinero CHAR(10)
,@FormaPago VARCHAR(50)
,@Importe MONEY
,@RetencionTotal MONEY
,@ImpuestoTotal MONEY
,@Saldo MONEY
,@Anticipo MONEY
,@MovAplica CHAR(20)
,@MovAplicaID VARCHAR(20)
,@Multiple BIT
,@Nota VARCHAR(100)
,@Conexion BIT
,@SincroFinal BIT
,@Sucursal INT
,@SucursalDestino INT
,@SucursalOrigen INT
,@AntecedenteID INT
,@AntecedenteEstatus CHAR(15)
,@AntecedenteSaldo MONEY
,@AntecedenteImporteTotal MONEY
,@AntecedenteMovTipo CHAR(20)
,@CXP BIT
,@Origen CHAR(20)
,@OrigenID VARCHAR(20)
,@OrigenMovTipo CHAR(20)
,@AnexoModulo CHAR(5)
,@AnexoID INT
,@CfgGastoCopiarImporte BIT
,@CfgGastoSolicitudAnticipoImpuesto BIT
,@RetencionAlPago BIT
,@CfgRetencionMov CHAR(20)
,@CfgRetencionAcreedor CHAR(10)
,@CfgRetencionConcepto VARCHAR(50)
,@CfgRetencion2Acreedor CHAR(10)
,@CfgRetencion2Concepto VARCHAR(50)
,@CfgRetencion3Acreedor CHAR(10)
,@CfgRetencion3Concepto VARCHAR(50)
,@CfgContX BIT
,@CfgContXGenerar CHAR(20)
,@CfgGastoAutoCargos BIT
,@CfgBorradorComprobantes BIT
,@CfgBorradorCajaChica BIT
,@CfgGenerarAnticiposBorrador BIT
,@CfgConceptoCxp BIT
,@ConceptoCxp VARCHAR(50)
,@GenerarPoliza BIT
,@GenerarMov CHAR(20)
,@IDGenerar INT OUTPUT
,@GenerarMovID VARCHAR(20) OUTPUT
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
AS
BEGIN
	DECLARE
		@Generar BIT
	   ,@GenerarAfectado BIT
	   ,@GenerarModulo CHAR(5)
	   ,@GenerarMovTipo CHAR(20)
	   ,@GenerarEstatus CHAR(15)
	   ,@GenerarPeriodo INT
	   ,@GenerarEjercicio INT
	   ,@DineroImporte MONEY
	   ,@DineroMov CHAR(20)
	   ,@DineroMovID VARCHAR(20)
	   ,@CxModulo CHAR(5)
	   ,@CxMov CHAR(20)
	   ,@CxMovID VARCHAR(20)
	   ,@CxImporte MONEY
	   ,@CxImpuestos MONEY
	   ,@CxRetencion MONEY
	   ,@CxRetencion2 MONEY
	   ,@CxRetencion3 MONEY
	   ,@CxConcepto VARCHAR(50)
	   ,@Dias INT
	   ,@ConceptoLinea VARCHAR(50)
	   ,@FechaLinea DATETIME
	   ,@ReferenciaLinea VARCHAR(50)
	   ,@ImporteLinea FLOAT
	   ,@RetencionLinea FLOAT
	   ,@Retencion2Linea FLOAT
	   ,@Retencion3Linea FLOAT
	   ,@ImpuestosLinea FLOAT
	   ,@Impuestos2Linea FLOAT
	   ,@Impuestos3Linea FLOAT
	   ,@Impuestos5Linea FLOAT
	   ,@ImpuestosLineaTotal FLOAT
	   ,@TotalLinea FLOAT
	   ,@ImporteTotal FLOAT
	   ,@ImporteSinRetenciones MONEY
	   ,@ImportePendiente MONEY
	   ,@ImporteAplicado MONEY
	   ,@SumaRetencion MONEY
	   ,@SumaRetencion2 MONEY
	   ,@SumaRetencion3 MONEY
	   ,@SumaImporte MONEY
	   ,@SumaRetenciones MONEY
	   ,@SumaImpuestos MONEY
	   ,@SumaImpuestos2 MONEY
	   ,@SumaImpuestos3 MONEY
	   ,@SumaImpuestos5 MONEY
	   ,@FechaCancelacion DATETIME
	   ,@AntecedenteEstatusNuevo CHAR(15)
	   ,@AntecedenteFechaConclusion DATETIME
	   ,@AntecedenteMov CHAR(20)
	   ,@AntecedenteMovID CHAR(20)
	   ,@CxAgente CHAR(10)
	   ,@CxComision MONEY
	   ,@AnexoMov CHAR(20)
	   ,@AnexoMovID VARCHAR(20)
	   ,@Renglon FLOAT
	   ,@RenglonSub INT
	   ,@ContUso VARCHAR(20)
	   ,@ContUso2 VARCHAR(20)
	   ,@ContUso3 VARCHAR(20)
	   ,@ClavePresupuestal VARCHAR(50)
	   ,@ClavePresupuestalImpuesto1 VARCHAR(50)
	   ,@VIN VARCHAR(20)
	   ,@Espacio CHAR(10)
	   ,@AFArticulo VARCHAR(20)
	   ,@AFSerie VARCHAR(50)
	   ,@Lectura INT
	   ,@LecturaAnterior INT
	   ,@Deducible FLOAT
	   ,@Referencia VARCHAR(50)
	   ,@EndosarA VARCHAR(20)
	   ,@Conteo INT
	   ,@RedondeoMonetarios INT
	   ,@PPTO BIT
	   ,@CP BIT
	   ,@GastoAnticipoMov VARCHAR(20)
	   ,@AfectarOtrosModulos BIT
	   ,@SistemaDetallista BIT
	   ,@MovImpuesto BIT
	   ,@Excento1 BIT
	   ,@Excento2 BIT
	   ,@Excento3 BIT
	   ,@TipoImpuesto1 VARCHAR(10)
	   ,@TipoImpuesto2 VARCHAR(10)
	   ,@TipoImpuesto3 VARCHAR(10)
	   ,@TipoImpuesto5 VARCHAR(10)
	   ,@TipoRetencion1 VARCHAR(10)
	   ,@TipoRetencion2 VARCHAR(10)
	   ,@TipoRetencion3 VARCHAR(10)
	   ,@CuentaPresupuesto VARCHAR(20)
	   ,@Fiscal BIT
	   ,@FiscalGenerarRetenciones BIT
	   ,@SubFolio VARCHAR(20)
	   ,@n INT
	   ,@CfgInv BIT
	   ,@CfgInvAlmacen VARCHAR(10)
	   ,@CantidadPendiente FLOAT
	   ,@CantidadReservada FLOAT
	   ,@Cantidad FLOAT
	   ,@Articulo VARCHAR(20)
	   ,@Disponible FLOAT
	   ,@AntecedenteTienePendientesInv BIT
	   ,@Precio FLOAT
	   ,@GastoEjercido MONEY
	   ,@GastoPendiente MONEY
	   ,@GastoDisponible MONEY
	   ,@Retencion MONEY
	   ,@Retencion2 MONEY
	   ,@Retencion3 MONEY
	   ,@CfgFormaCobroDA VARCHAR(50)
	   ,@CfgRetencion2BaseImpuesto1 BIT
	   ,@CfgImpuesto2Info BIT
	   ,@CfgImpuesto3Info BIT
	   ,@SubClave VARCHAR(20)
	   ,@EsEcuador BIT
	   ,@GasConceptoMultiple BIT
	   ,@AplicaMov VARCHAR(20)
	   ,@AplicaMovID VARCHAR(20)
	   ,@AplicaEjercicio INT
	   ,@AplicaPeriodo INT
	   ,@AplicaFechaEmision DATETIME
	   ,@AcreedorRef CHAR(10)
	   ,@IVAFiscal FLOAT
	   ,@IEPSFiscal FLOAT
	   ,@OrigenGasto VARCHAR(20)
	   ,@OrigenIDGasto VARCHAR(20)
	SELECT @SubClave = SubClave
	FROM MovTipo
	WHERE Mov = @Mov
	AND Modulo = @Modulo
	SELECT @RedondeoMonetarios = dbo.fnRedondeoMonetarios()
	SELECT @CfgImpuesto2Info = ISNULL(Impuesto2Info, 0)
		  ,@CfgImpuesto3Info = ISNULL(Impuesto2Info, 0)
		  ,@CfgRetencion2BaseImpuesto1 = ISNULL(Retencion2BaseImpuesto1, 0)
	FROM Version
	SELECT @Generar = 0
		  ,@GenerarAfectado = 0
		  ,@IDGenerar = NULL
		  ,@GenerarModulo = NULL
		  ,@GenerarMovID = NULL
		  ,@GenerarMovTipo = NULL
		  ,@GenerarEstatus = 'SINAFECTAR'
		  ,@Referencia = RTRIM(@Mov) + ' ' + RTRIM(@MovID)
		  ,@MovImpuesto = 0
	SELECT @EsEcuador = ISNULL(EsEcuador, 0)
	FROM Empresa
	WHERE Empresa = @Empresa
	SELECT @CfgFormaCobroDA = NULLIF(RTRIM(CxcFormaCobroDA), '')
	FROM EmpresaCfg
	WHERE Empresa = @Empresa
	SELECT @CfgInv = ISNULL(GastoConceptosInventariables, 0)
		  ,@CfgInvAlmacen = GastoAlmacen
		  ,@FiscalGenerarRetenciones = ISNULL(FiscalGenerarRetenciones, 0)
		  ,@GasConceptoMultiple = ISNULL(GasConceptoMultiple, 0)
	FROM EmpresaCfg2
	WHERE Empresa = @Empresa
	SELECT @PPTO = PPTO
		  ,@CP = CP
		  ,@SistemaDetallista = SistemaDetallista
		  ,@Fiscal = ISNULL(Fiscal, 0)
	FROM EmpresaGral
	WHERE Empresa = @Empresa

	IF @MovTipo NOT IN ('GAS.S', 'GAS.SR', 'GAS.PR', 'GAS.PRP', 'GAS.DPR')
		AND @Accion <> 'CANCELAR'
	BEGIN
		SELECT @MovImpuesto = 1
		CREATE TABLE #GastoMovImpuesto (
			Renglon FLOAT NOT NULL
		   ,RenglonSub INT NOT NULL
		   ,Impuesto1 FLOAT NULL
		   ,Impuesto2 FLOAT NULL
		   ,Impuesto3 FLOAT NULL
		   ,Impuesto5 FLOAT NULL
		   ,Importe1 MONEY NULL
		   ,Importe2 MONEY NULL
		   ,Importe3 MONEY NULL
		   ,Importe5 MONEY NULL
		   ,SubTotal MONEY NULL
		   ,LoteFijo VARCHAR(20) COLLATE Database_Default NULL
		   ,OrigenConcepto VARCHAR(50) COLLATE Database_Default NULL
		   ,OrigenDeducible FLOAT NULL DEFAULT 100
		   ,OrigenFecha DATETIME NULL
		   ,Retencion1 FLOAT NULL
		   ,Retencion2 FLOAT NULL
		   ,Retencion3 FLOAT NULL
		   ,Excento1 BIT NULL DEFAULT 0
		   ,Excento2 BIT NULL DEFAULT 0
		   ,Excento3 BIT NULL DEFAULT 0
		   ,TipoImpuesto1 VARCHAR(10) COLLATE Database_Default NULL
		   ,TipoImpuesto2 VARCHAR(10) COLLATE Database_Default NULL
		   ,TipoImpuesto3 VARCHAR(10) COLLATE Database_Default NULL
		   ,TipoImpuesto5 VARCHAR(10) COLLATE Database_Default NULL
		   ,TipoRetencion1 VARCHAR(10) COLLATE Database_Default NULL
		   ,TipoRetencion2 VARCHAR(10) COLLATE Database_Default NULL
		   ,TipoRetencion3 VARCHAR(10) COLLATE Database_Default NULL
		   ,ContUso VARCHAR(20) COLLATE Database_Default NULL
		   ,ContUso2 VARCHAR(20) COLLATE Database_Default NULL
		   ,ContUso3 VARCHAR(20) COLLATE Database_Default NULL
		   ,ClavePresupuestal VARCHAR(50) COLLATE Database_Default NULL
		   ,ClavePresupuestalImpuesto1 VARCHAR(50) COLLATE Database_Default NULL
		   ,SubFolio VARCHAR(20) COLLATE Database_Default NULL
		   ,ImporteBruto MONEY NULL
		)
	END

	EXEC spMovConsecutivo @Sucursal
						 ,@SucursalOrigen
						 ,@SucursalDestino
						 ,@Empresa
						 ,@Usuario
						 ,@Modulo
						 ,@Ejercicio
						 ,@Periodo
						 ,@ID
						 ,@Mov
						 ,NULL
						 ,@Estatus
						 ,NULL
						 ,@Accion
						 ,@Conexion
						 ,@SincroFinal
						 ,@MovID OUTPUT
						 ,@Ok OUTPUT
						 ,@OkRef OUTPUT

	IF @Ok = 60300
		AND @Accion = 'CANCELAR'
		AND @OrigenMovTipo IN ('GAS.GP', 'GAS.CP', 'GAS.DGP')
		SELECT @Ok = NULL
			  ,@OkRef = NULL

	IF @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR')
		AND @Accion <> 'CANCELAR'
		AND @Ok IS NULL
		EXEC spMovChecarConsecutivo @Empresa
								   ,@Modulo
								   ,@Mov
								   ,@MovID
								   ,NULL
								   ,@Ejercicio
								   ,@Periodo
								   ,@Ok OUTPUT
								   ,@OkRef OUTPUT

	IF @Accion IN ('CONSECUTIVO', 'SINCRO')
		AND @Ok IS NULL
	BEGIN

		IF @Accion = 'SINCRO'
			EXEC spAsignarSucursalEstatus @ID
										 ,@Modulo
										 ,@SucursalDestino
										 ,@Accion

		SELECT @Ok = 80060
			  ,@OkRef = @MovID
		RETURN
	END

	IF NOT EXISTS (SELECT Proveedor FROM Prov WHERE Proveedor = @Acreedor)
		SELECT @Ok = 26050
			  ,@OkRef = @Acreedor

	IF @OK IS NOT NULL
		RETURN

	IF @Accion = 'GENERAR'
		AND @Ok IS NULL
	BEGIN
		EXEC spMovGenerar @Sucursal
						 ,@Empresa
						 ,@Modulo
						 ,@Ejercicio
						 ,@Periodo
						 ,@Usuario
						 ,@FechaRegistro
						 ,@GenerarEstatus
						 ,NULL
						 ,NULL
						 ,@Mov
						 ,@MovID
						 ,0
						 ,@GenerarMov
						 ,NULL
						 ,@GenerarMovID OUTPUT
						 ,@IDGenerar OUTPUT
						 ,@Ok OUTPUT
						 ,@OkRef OUTPUT
		EXEC spMovTipo @Modulo
					  ,@GenerarMov
					  ,@FechaAfectacion
					  ,@Empresa
					  ,NULL
					  ,NULL
					  ,@GenerarMovTipo OUTPUT
					  ,@GenerarPeriodo OUTPUT
					  ,@GenerarEjercicio OUTPUT
					  ,@Ok OUTPUT

		IF @@ERROR <> 0
			SELECT @Ok = 1

		IF @Ok IS NULL
			SELECT @FechaEmision = FechaEmision
			FROM Gasto
			WHERE ID = @IDGenerar

		IF @MovTipo IN ('GAS.S', 'GAS.P', 'GAS.A')
			EXEC spCalcularVencimiento 'GAS'
									  ,@Empresa
									  ,@Acreedor
									  ,@Condicion
									  ,@FechaEmision
									  ,@Vencimiento OUTPUT
									  ,@Dias OUTPUT
									  ,@Ok OUTPUT
		ELSE
			EXEC spExtraerFecha @Vencimiento OUTPUT

		SELECT @SumaImporte = SUM(Importe)
			  ,@SumaRetenciones = SUM(ISNULL(Retencion, 0.0) + ISNULL(Retencion2, 0.0) + ISNULL(Retencion3, 0.0))
			  ,@SumaImpuestos = SUM(ISNULL(Impuestos, 0.0) +
			   CASE
				   WHEN @CfgImpuesto2Info = 1 THEN 0.0
				   ELSE ISNULL(Impuestos2, 0.0)
			   END +
			   CASE
				   WHEN @CfgImpuesto3Info = 1 THEN 0.0
				   ELSE ISNULL(Impuestos3, 0.0)
			   END + ISNULL(Impuestos5, 0.0))
		FROM GastoD
		WHERE ID = @IDGenerar
		UPDATE Gasto
		SET MovAplica = @Mov
		   ,MovAplicaID = @MovID
		   ,Saldo = NULL
		   ,Anticipo = NULL
		   ,FormaPago = NULL
		   ,Importe = @SumaImporte
		   ,Retencion = @SumaRetenciones
		   ,Impuestos = @SumaImpuestos
		   ,Vencimiento = @Vencimiento
		WHERE ID = @IDGenerar

		IF @GenerarMovTipo IN ('GAS.DA', 'GAS.ASC', 'GAS.SR')
			UPDATE Gasto
			SET Importe = @Saldo
			WHERE ID = @IDGenerar
		ELSE
			EXEC spGastoCopiarDetalle @Sucursal
									 ,@ID
									 ,@IDGenerar
									 ,@MovTipo
									 ,@GenerarMovTipo
									 ,@CfgGastoCopiarImporte
									 ,@CfgGastoSolicitudAnticipoImpuesto
									 ,@Ok OUTPUT

		IF @MovTipo = 'GAS.PR'
		BEGIN
			UPDATE Gasto
			SET MovAplica = NULL
			   ,MovAplicaID = NULL
			WHERE ID = @IDGenerar
			DECLARE
				crPresupuesto
				CURSOR FOR
				SELECT Concepto
					  ,ContUso
					  ,ContUso2
					  ,ContUso3
					  ,Cantidad
					  ,Precio
				FROM GastoD
				WHERE ID = @IDGenerar
			OPEN crPresupuesto
			FETCH NEXT FROM crPresupuesto INTO @ConceptoLinea, @ContUso, @ContUso2, @ContUso3, @Cantidad, @Precio
			WHILE @@FETCH_STATUS <> -1
			AND @Ok IS NULL
			BEGIN

			IF @@FETCH_STATUS <> -2
			BEGIN
				SELECT @ImporteLinea = @Cantidad * @Precio
				EXEC spVerGastoEjercido @Empresa
									   ,@FechaEmision
									   ,@FechaEmision
									   ,@ConceptoLinea
									   ,@MovMoneda
									   ,@ContUso
									   ,@EnSilencio = 1
									   ,@GastoEjercido = @GastoEjercido OUTPUT
									   ,@ContUso2 = @ContUso2
									   ,@ContUso3 = @ContUso3
				EXEC spVerGastoPendiente @Empresa
										,@FechaEmision
										,@FechaEmision
										,@ConceptoLinea
										,@MovMoneda
										,@ContUso
										,@EnSilencio = 1
										,@GastoPendiente = @GastoPendiente OUTPUT
										,@ContUso2 = @ContUso2
										,@ContUso3 = @ContUso3
				SELECT @GastoDisponible = @ImporteLinea - @GastoEjercido - @GastoPendiente

				IF @GastoDisponible > 0.0
				BEGIN
					SELECT @Cantidad = ROUND(dbo.fnR3(@ImporteLinea, @Cantidad, @GastoDisponible), 0)
					SELECT @Importe = @Cantidad * @Precio
					SELECT @Retencion = @Importe * (Retencion / 100.0)
						  ,@Retencion2 =
						   CASE
							   WHEN @CfgRetencion2BaseImpuesto1 = 1 THEN @Importe * (Impuestos / 100.0) * (Retencion2 / 100.0)
							   ELSE @Importe * (Retencion2 / 100.0)
						   END
						  ,@Retencion3 = @Importe * (Retencion3 / 100.0)
						  ,@ImpuestosLinea = @Importe * (Impuestos / 100.0)
					FROM Concepto
					WHERE Modulo = 'GAS'
					AND Concepto = @ConceptoLinea
					UPDATE GastoD
					SET Cantidad = @Cantidad
					   ,Importe = @Importe
					   ,Impuestos = @ImpuestosLinea
					   ,Retencion = @Retencion
					   ,Retencion2 = @Retencion2
					   ,Retencion3 = @Retencion3
					WHERE CURRENT OF crPresupuesto
				END
				ELSE
					DELETE GastoD
					WHERE CURRENT OF crPresupuesto

			END

			FETCH NEXT FROM crPresupuesto INTO @ConceptoLinea, @ContUso, @ContUso2, @ContUso3, @Cantidad, @Precio
			END
			CLOSE crPresupuesto
			DEALLOCATE crPresupuesto
		END
		ELSE

		IF @GenerarMovTipo = 'GAS.CI'
		BEGIN
			DELETE GastoD
				FROM GastoD d
				JOIN Concepto c
					ON c.Modulo = @Modulo
					AND c.Concepto = d.Concepto
					AND (c.EsInventariable = 0
					OR NULLIF(c.Articulo, '') IS NULL)
			WHERE d.ID = @IDGenerar
			DECLARE
				crConsumo
				CURSOR FOR
				SELECT d.Renglon
					  ,d.RenglonSub
					  ,c.Articulo
					  ,ISNULL(i.CantidadPendiente, 0.0) - ISNULL(CantidadCancelada, 0)
					  ,ISNULL(i.CantidadReservada, 0.0)
				FROM GastoD d
				JOIN Concepto c
					ON c.Modulo = @Modulo
					AND c.Concepto = d.Concepto
					AND c.EsInventariable = 1
				JOIN Art a
					ON a.Articulo = c.Articulo
				JOIN InvD i
					ON i.ID = d.InvID
					AND i.Renglon = d.Renglon
					AND i.RenglonSub = d.RenglonSub
				WHERE d.ID = @ID
			OPEN crConsumo
			FETCH NEXT FROM crConsumo INTO @Renglon, @RenglonSub, @Articulo, @CantidadPendiente, @CantidadReservada
			WHILE @@FETCH_STATUS <> -1
			AND @Ok IS NULL
			BEGIN

			IF @@FETCH_STATUS <> -2
			BEGIN
				SELECT @Cantidad = NULL

				IF @Base = 'PENDIENTE'
					SELECT @Cantidad = @CantidadPendiente + @CantidadReservada
				ELSE

				IF @Base = 'RESERVADO'
					SELECT @Cantidad = @CantidadReservada
				ELSE

				IF @Base = 'DISPONIBLE'
				BEGIN
					SELECT @Cantidad = @CantidadReservada

					IF @CantidadPendiente > 0.0
					BEGIN
						SELECT @Disponible = SUM(Disponible)
						FROM ArtDisponible
						WHERE Empresa = @Empresa
						AND Articulo = @Articulo
						AND Almacen = @CfgInvAlmacen

						IF @CantidadPendiente > @Disponible
							SELECT @Cantidad = @Cantidad + @Disponible
						ELSE
							SELECT @Cantidad = @Cantidad + @CantidadPendiente

					END

				END

				IF NULLIF(@Cantidad, 0.0) IS NULL
					DELETE GastoD
					WHERE ID = @IDGenerar
						AND Renglon = @Renglon
						AND RenglonSub = @RenglonSub
				ELSE
					UPDATE GastoD
					SET Cantidad = @Cantidad
					   ,Importe = dbo.fnR3(Cantidad, Importe, @Cantidad)
					WHERE ID = @IDGenerar
					AND Renglon = @Renglon
					AND RenglonSub = @RenglonSub

			END

			FETCH NEXT FROM crConsumo INTO @Renglon, @RenglonSub, @Articulo, @CantidadPendiente, @CantidadReservada
			END
			CLOSE crConsumo
			DEALLOCATE crConsumo
		END

		IF @GenerarMovTipo = 'GAS.A'
			AND @CfgGenerarAnticiposBorrador = 1
		BEGIN
			EXEC spValidarTareas @Empresa
								,@Modulo
								,@IDGenerar
								,'BORRADOR'
								,@Ok OUTPUT
								,@OkRef OUTPUT
			UPDATE Gasto
			SET Estatus = 'BORRADOR'
			WHERE ID = @IDGenerar
		END

		IF @Ok IS NULL
			SELECT @Ok = 80030

		RETURN
	END

	IF @OK IS NOT NULL
		RETURN

	IF @Estatus = 'SINAFECTAR'
		AND @Accion = 'AFECTAR'
		AND ((@CfgBorradorComprobantes = 1 AND @MovTipo = 'GAS.C') OR (@CfgBorradorCajaChica = 1 AND @MovTipo = 'GAS.CCH'))
	BEGIN
		EXEC spValidarTareas @Empresa
							,@Modulo
							,@ID
							,'BORRADOR'
							,@Ok OUTPUT
							,@OkRef OUTPUT
		UPDATE Gasto
		SET Estatus = 'BORRADOR'
		WHERE ID = @ID
		RETURN
	END

	IF @Conexion = 0
		BEGIN TRANSACTION

	EXEC spMovEstatus @Modulo
					 ,'AFECTANDO'
					 ,@ID
					 ,@Generar
					 ,@IDGenerar
					 ,@GenerarAfectado
					 ,@Ok OUTPUT

	IF @Accion = 'AFECTAR'
		AND @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR')
	BEGIN

		IF (
				SELECT Sincro
				FROM Version
			)
			= 1
			EXEC sp_executesql N'UPDATE GastoD SET Sucursal = @Sucursal, SincroC = 1 WHERE ID = @ID AND (Sucursal <> @Sucursal OR SincroC <> 1)'
							  ,N'@Sucursal int, @ID int'
							  ,@Sucursal
							  ,@ID

		IF @SistemaDetallista = 1

			IF (
					SELECT EditarDeptoDetallista
					FROM MovTipo
					WHERE Modulo = @Modulo
					AND Mov = @Mov
				)
				= 0
				UPDATE GastoD
				SET DepartamentoDetallista = c.DepartamentoDetallista
				FROM GastoD d, Concepto c
				WHERE d.ID = @ID
				AND c.Modulo = 'GAS'
				AND c.Concepto = d.Concepto

	END

	IF @Accion <> 'CANCELAR'
	BEGIN
		EXEC spRegistrarMovimiento @Sucursal
								  ,@Empresa
								  ,@Modulo
								  ,@Mov
								  ,@MovID
								  ,@ID
								  ,@Ejercicio
								  ,@Periodo
								  ,@FechaRegistro
								  ,@FechaEmision
								  ,NULL
								  ,@Proyecto
								  ,@MovMoneda
								  ,@MovTipoCambio
								  ,@Usuario
								  ,@Autorizacion
								  ,NULL
								  ,@DocFuente
								  ,@Observaciones
								  ,@Generar
								  ,@GenerarMov
								  ,@GenerarMovID
								  ,@IDGenerar
								  ,@Ok OUTPUT

		IF @MovTipo IN ('GAS.S', 'GAS.P', 'GAS.A')
			EXEC spCalcularVencimiento 'CXP'
									  ,@Empresa
									  ,@Acreedor
									  ,@Condicion
									  ,@FechaEmision
									  ,@Vencimiento OUTPUT
									  ,@Dias OUTPUT
									  ,@Ok OUTPUT
		ELSE

		IF @MovTipo = 'GAS.GR'
			SELECT @Vencimiento = ISNULL(CASE
				 WHEN ConVigencia = 1 THEN VigenciaDesde
			 END, @FechaEmision)
			FROM Gasto
			WHERE ID = @ID

		EXEC spExtraerFecha @Vencimiento OUTPUT
	END

	IF @MovTipo NOT IN ('GAS.DA', 'GAS.ASC', 'GAS.SR')
	BEGIN
		SELECT @Importe = 0.0
			  ,@RetencionTotal = 0.0
			  ,@ImpuestoTotal = 0.0
			  ,@SumaRetencion = 0.0
			  ,@SumaRetencion2 = 0.0
			  ,@SumaRetencion3 = 0.0
			  ,@SumaImpuestos = 0.0
			  ,@SumaImpuestos2 = 0.0
			  ,@SumaImpuestos3 = 0.0
			  ,@SumaImpuestos5 = 0.0
		SELECT @n = 0
			  ,@SubFolio = NULL
		DECLARE
			crGasto
			CURSOR FOR
			SELECT Renglon
				  ,RenglonSub
				  ,NULLIF(RTRIM(Concepto), '')
				  ,Fecha
				  ,NULLIF(RTRIM(Referencia), '')
				  ,ISNULL(Importe, 0.0)
				  ,ISNULL(Retencion, 0.0)
				  ,ISNULL(Retencion2, 0.0)
				  ,ISNULL(Retencion3, 0.0)
				  ,ISNULL(Impuestos, 0.0)
				  ,ISNULL(Impuestos2, 0.0)
				  ,ISNULL(Impuestos3, 0.0)
				  ,ISNULL(Impuestos5, 0.0)
				  ,NULLIF(RTRIM(ContUso), '')
				  ,NULLIF(RTRIM(VIN), '')
				  ,NULLIF(RTRIM(Espacio), '')
				  ,AFArticulo
				  ,AFSerie
				  ,Lectura
				  ,LecturaAnterior
				  ,ISNULL(PorcentajeDeducible, 100)
				  ,NULLIF(RTRIM(ContUso2), '')
				  ,NULLIF(RTRIM(ContUso3), '')
				  ,NULLIF(RTRIM(ClavePresupuestal), '')
				  ,ISNULL(Cantidad, 0.0)
			FROM GastoD
			WHERE ID = @ID
		OPEN crGasto
		FETCH NEXT FROM crGasto INTO @Renglon, @RenglonSub, @ConceptoLinea, @FechaLinea, @ReferenciaLinea, @ImporteLinea, @RetencionLinea, @Retencion2Linea, @Retencion3Linea, @ImpuestosLinea, @Impuestos2Linea, @Impuestos3Linea, @Impuestos5Linea, @ContUso, @VIN, @Espacio, @AFArticulo, @AFSerie, @Lectura, @LecturaAnterior, @Deducible, @ContUso2, @ContUso3, @ClavePresupuestal, @Cantidad

		IF @@ERROR <> 0
			SELECT @Ok = 1

		IF @@FETCH_STATUS = -1
			SELECT @Ok = 60010

		WHILE @@FETCH_STATUS <> -1
		AND @Ok IS NULL
		BEGIN

		IF @@FETCH_STATUS <> -2
			AND @ConceptoLinea IS NOT NULL
			AND @Ok IS NULL
		BEGIN

			IF @CfgImpuesto2Info = 1
				SELECT @Impuestos2Linea = 0.0

			IF @CfgImpuesto3Info = 1
				SELECT @Impuestos3Linea = 0.0

			SELECT @CuentaPresupuesto = NULL
				  ,@Excento1 = 0
				  ,@Excento2 = 0
				  ,@Excento3 = 0
				  ,@TipoImpuesto1 = NULL
				  ,@TipoImpuesto2 = NULL
				  ,@TipoImpuesto3 = NULL
				  ,@TipoImpuesto5 = NULL
				  ,@TipoRetencion1 = NULL
				  ,@TipoRetencion2 = NULL
				  ,@TipoRetencion3 = NULL
			SELECT @CuentaPresupuesto = NULLIF(RTRIM(CuentaPresupuesto), '')
				  ,@Excento1 = ISNULL(Impuesto1Excento, 0)
				  ,@Excento2 = ISNULL(Excento2, 0)
				  ,@Excento3 = ISNULL(Excento3, 0)
				  ,@TipoImpuesto1 = TipoImpuesto1
				  ,@TipoImpuesto2 = TipoImpuesto2
				  ,@TipoImpuesto3 = TipoImpuesto3
				  ,@TipoImpuesto5 = TipoImpuesto5
				  ,@TipoRetencion1 = TipoRetencion1
				  ,@TipoRetencion2 = TipoRetencion2
				  ,@TipoRetencion3 = TipoRetencion3
				  ,@ClavePresupuestalImpuesto1 = ClavePresupuestalImpuesto1
			FROM Concepto
			WHERE Modulo = @Modulo
			AND Concepto = @ConceptoLinea

			IF @CP = 0
				SELECT @ClavePresupuestalImpuesto1 = NULL

			IF @PPTO = 1
				AND @Accion <> 'CANCELAR'
				AND @CuentaPresupuesto IS NULL
			BEGIN
				SELECT @Ok = 40035
					  ,@OkRef = @ConceptoLinea
				EXEC xpOk_40035 @Empresa
							   ,@Usuario
							   ,@Accion
							   ,@Modulo
							   ,@ID
							   ,@Ok OUTPUT
							   ,@OkRef OUTPUT
			END

			IF @MovTipo NOT IN ('GAS.S', 'GAS.P', 'GAS.A', 'GAS.G', 'GAS.GTC', 'GAS.GP', 'GAS.C', 'GAS.ASC', 'GAS.CCH', 'GAS.CP', 'GAS.DG', 'GAS.DGP', 'GAS.OI', 'GAS.GR', 'GAS.CTO', 'GAS.DC', 'GAS.EST', 'GAS.CI')
				AND (@RetencionLinea <> 0 OR @Retencion2Linea <> 0 OR @Retencion3Linea <> 0)
				SELECT @Ok = 30550

			SELECT @TotalLinea = @ImporteLinea - @RetencionLinea - @Retencion2Linea - @Retencion3Linea + @ImpuestosLinea + @Impuestos2Linea + @Impuestos3Linea + @Impuestos5Linea

			IF @MovTipo IN ('GAS.GP', 'GAS.CP', 'GAS.DGP', 'GAS.PRP')
				EXEC spGastoDProrrateo @Empresa
									  ,@Sucursal
									  ,@ID
									  ,@Renglon
									  ,@RenglonSub
									  ,@ConceptoLinea
									  ,@TotalLinea
									  ,@ContUso
									  ,@Espacio
									  ,@Ok OUTPUT
									  ,@OkRef OUTPUT
									  ,@ContUso2 = @ContUso2
									  ,@ContUso3 = @ContUso3

			IF @MovTipo IN ('GAS.S', 'GAS.P', 'GAS.A')
				AND (@ImpuestosLinea <> 0.0 OR @Impuestos2Linea <> 0.0 OR @Impuestos3Linea <> 0.0 OR @Impuestos5Linea <> 0.0 OR @RetencionLinea <> 0.0 OR @Retencion2Linea <> 0.0 OR @Retencion3Linea <> 0.0)
				AND @CfgGastoSolicitudAnticipoImpuesto = 0
			BEGIN
				UPDATE GastoD
				SET Retencion = NULL
				   ,Retencion2 = NULL
				   ,Retencion3 = NULL
				   ,Impuestos = NULL
				   ,Impuestos2 = NULL
				   ,Impuestos3 = NULL
				   ,Impuestos5 = NULL
				WHERE CURRENT OF crGasto
				SELECT @RetencionLinea = 0.0
					  ,@Retencion2Linea = 0.0
					  ,@Retencion3Linea = 0.0
					  ,@ImpuestosLinea = 0.0
					  ,@Impuestos2Linea = 0.0
					  ,@Impuestos3Linea = 0.0
					  ,@Impuestos5Linea = 0.0
			END

			IF @MovTipo IN ('GAS.G', 'GAS.GTC', 'GAS.C', 'GAS.CCH')
				UPDATE Concepto
				SET UltimoCosto = @ImporteLinea
				   ,UltimoGasto = @FechaEmision
				   ,MonedaCosto = @MovMoneda
				WHERE Concepto = @ConceptoLinea
				AND Modulo = 'GAS'

			IF @MovTipo IN ('GAS.G', 'GAS.GTC', 'GAS.C', 'GAS.CCH')
				AND @AFArticulo IS NOT NULL
				AND @AFSerie IS NOT NULL
				AND @Lectura IS NOT NULL
			BEGIN
				EXEC spActivoFLectura @Accion
									 ,@Empresa
									 ,@AFArticulo
									 ,@AFSerie
									 ,@ConceptoLinea
									 ,@FechaEmision
									 ,@Lectura
									 ,@LecturaAnterior OUTPUT

				IF @Accion <> 'CANCELAR'
					UPDATE GastoD
					SET LecturaAnterior = @LecturaAnterior
					WHERE CURRENT OF crGasto

			END

			SELECT @Importe = @Importe + @ImporteLinea
				  ,@SumaRetencion = @SumaRetencion + @RetencionLinea
				  ,@SumaRetencion2 = @SumaRetencion2 + @Retencion2Linea
				  ,@SumaRetencion3 = @SumaRetencion3 + @Retencion3Linea
				  ,@SumaImpuestos = @SumaImpuestos + @ImpuestosLinea
				  ,@SumaImpuestos2 = @SumaImpuestos2 + @Impuestos2Linea
				  ,@SumaImpuestos3 = @SumaImpuestos3 + @Impuestos3Linea
				  ,@SumaImpuestos5 = @SumaImpuestos5 + @Impuestos5Linea

			IF (@Fiscal = 0 OR @FiscalGenerarRetenciones = 1)
				AND @RetencionAlPago = 0
				AND @MovTipo IN ('GAS.G', 'GAS.GTC', 'GAS.DG', 'GAS.C', 'GAS.CCH', 'GAS.DGP', 'GAS.OI', 'GAS.DC')
			BEGIN

				IF @RetencionLinea <> 0.0
					AND @CfgRetencionConcepto IN ('(Concepto Gasto)', 'ISR - (Concepto Gasto)')
				BEGIN
					EXEC spGastoConcepto @CfgRetencionConcepto
										,@ConceptoLinea
										,@CxConcepto OUTPUT

					IF @CfgRetencionAcreedor IS NULL
						SELECT @Ok = 70100
					ELSE
						EXEC spGenerarCx @Sucursal
										,@SucursalOrigen
										,@SucursalDestino
										,@Accion
										,NULL
										,@Empresa
										,@Modulo
										,@ID
										,@Mov
										,@MovID
										,@MovTipo
										,@MovMoneda
										,@MovTipoCambio
										,@FechaEmision
										,@CxConcepto
										,@Proyecto
										,@Usuario
										,@Autorizacion
										,@Referencia
										,@DocFuente
										,@Observaciones
										,@FechaRegistro
										,@Ejercicio
										,@Periodo
										,NULL
										,NULL
										,@CfgRetencionAcreedor
										,NULL
										,NULL
										,NULL
										,NULL
										,NULL
										,@RetencionLinea
										,NULL
										,NULL
										,NULL
										,NULL
										,NULL
										,NULL
										,NULL
										,NULL
										,@CfgRetencionMov
										,@CxModulo OUTPUT
										,@CxMov OUTPUT
										,@CxMovID OUTPUT
										,@Ok OUTPUT
										,@OkRef OUTPUT
										,@Nota = @Nota
										,@ContUso = @ContUso

				END

				IF @Retencion2Linea <> 0.0
					AND @CfgRetencion2Concepto IN ('(Concepto Gasto)', 'IVA - (Concepto Gasto)')
				BEGIN
					EXEC spGastoConcepto @CfgRetencion2Concepto
										,@ConceptoLinea
										,@CxConcepto OUTPUT

					IF @CfgRetencion2Acreedor IS NULL
						SELECT @Ok = 70100
					ELSE
						EXEC spGenerarCx @Sucursal
										,@SucursalOrigen
										,@SucursalDestino
										,@Accion
										,NULL
										,@Empresa
										,@Modulo
										,@ID
										,@Mov
										,@MovID
										,@MovTipo
										,@MovMoneda
										,@MovTipoCambio
										,@FechaEmision
										,@CxConcepto
										,@Proyecto
										,@Usuario
										,@Autorizacion
										,@Referencia
										,@DocFuente
										,@Observaciones
										,@FechaRegistro
										,@Ejercicio
										,@Periodo
										,NULL
										,NULL
										,@CfgRetencion2Acreedor
										,NULL
										,NULL
										,NULL
										,NULL
										,NULL
										,@Retencion2Linea
										,NULL
										,NULL
										,NULL
										,NULL
										,NULL
										,NULL
										,NULL
										,NULL
										,@CfgRetencionMov
										,@CxModulo OUTPUT
										,@CxMov OUTPUT
										,@CxMovID OUTPUT
										,@Ok OUTPUT
										,@OkRef OUTPUT
										,@Nota = @Nota
										,@ContUso = @ContUso

				END

				IF @Retencion3Linea <> 0.0
					AND @CfgRetencion3Concepto IN ('(Concepto Gasto)', 'R3 - (Concepto Gasto)')
				BEGIN
					EXEC spGastoConcepto @CfgRetencion3Concepto
										,@ConceptoLinea
										,@CxConcepto OUTPUT

					IF @CfgRetencion3Acreedor IS NULL
						SELECT @Ok = 70100
					ELSE
						EXEC spGenerarCx @Sucursal
										,@SucursalOrigen
										,@SucursalDestino
										,@Accion
										,NULL
										,@Empresa
										,@Modulo
										,@ID
										,@Mov
										,@MovID
										,@MovTipo
										,@MovMoneda
										,@MovTipoCambio
										,@FechaEmision
										,@CxConcepto
										,@Proyecto
										,@Usuario
										,@Autorizacion
										,@Referencia
										,@DocFuente
										,@Observaciones
										,@FechaRegistro
										,@Ejercicio
										,@Periodo
										,NULL
										,NULL
										,@CfgRetencion3Acreedor
										,NULL
										,NULL
										,NULL
										,NULL
										,NULL
										,@Retencion3Linea
										,NULL
										,NULL
										,NULL
										,NULL
										,NULL
										,NULL
										,NULL
										,NULL
										,@CfgRetencionMov
										,@CxModulo OUTPUT
										,@CxMov OUTPUT
										,@CxMovID OUTPUT
										,@Ok OUTPUT
										,@OkRef OUTPUT
										,@Nota = @Nota
										,@ContUso = @ContUso

				END

			END

			IF @MovImpuesto = 1
			BEGIN

				IF @MovTipo = 'GAS.GTC'
				BEGIN
					SELECT @n = @n + 1
					SELECT @SubFolio = CONVERT(VARCHAR(20), @n)
				END

				INSERT #GastoMovImpuesto (Renglon, RenglonSub, OrigenConcepto, OrigenDeducible, OrigenFecha,
				Impuesto1,
				Impuesto2,
				Impuesto3,
				Impuesto5,
				Importe1,
				Importe2,
				Importe3,
				Importe5,
				Retencion1,
				Retencion2,
				Retencion3,
				Excento1,
				Excento2,
				Excento3,
				TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoImpuesto5,
				TipoRetencion1, TipoRetencion2, TipoRetencion3,
				SubTotal,
				ContUso,
				ContUso2,
				ContUso3,
				ClavePresupuestal,
				ClavePresupuestalImpuesto1,
				ImporteBruto,
				SubFolio)
					SELECT @Renglon
						  ,@RenglonSub
						  ,@ConceptoLinea
						  ,ISNULL(@Deducible, 100)
						  ,ISNULL(@FechaLinea, @FechaEmision)
						  ,ROUND((@ImpuestosLinea / NULLIF(@ImporteLinea, 0.0)) * 100.0, @RedondeoMonetarios)
						  ,ROUND((@Impuestos2Linea / NULLIF(@ImporteLinea, 0.0)) * 100.0, @RedondeoMonetarios)
						  ,ROUND((@Impuestos3Linea / NULLIF(@Cantidad, 0.0)), @RedondeoMonetarios)
						  ,ROUND(@Impuestos5Linea, @RedondeoMonetarios)
						  ,@ImpuestosLinea
						  ,@Impuestos2Linea
						  ,@Impuestos3Linea
						  ,@Impuestos5Linea
						  ,ROUND((@RetencionLinea / NULLIF(@ImporteLinea, 0.0)) * 100.0, @RedondeoMonetarios)
						  ,ROUND((@Retencion2Linea / NULLIF(CASE
							   WHEN @CfgRetencion2BaseImpuesto1 = 1 THEN @ImpuestosLinea
							   ELSE @ImporteLinea
						   END, 0.0)) * 100.0, @RedondeoMonetarios)
						  ,ROUND((@Retencion3Linea / NULLIF(@ImporteLinea, 0.0)) * 100.0, @RedondeoMonetarios)
						  ,@Excento1
						  ,@Excento2
						  ,@Excento3
						  ,@TipoImpuesto1
						  ,@TipoImpuesto2
						  ,@TipoImpuesto3
						  ,@TipoImpuesto5
						  ,@TipoRetencion1
						  ,@TipoRetencion2
						  ,@TipoRetencion3
						  ,@ImporteLinea
						  ,@ContUso
						  ,@ContUso2
						  ,@ContUso3
						  ,@ClavePresupuestal
						  ,@ClavePresupuestalImpuesto1
						  ,@ImporteLinea
						  ,@SubFolio
			END

		END

		FETCH NEXT FROM crGasto INTO @Renglon, @RenglonSub, @ConceptoLinea, @FechaLinea, @ReferenciaLinea, @ImporteLinea, @RetencionLinea, @Retencion2Linea, @Retencion3Linea, @ImpuestosLinea, @Impuestos2Linea, @Impuestos3Linea, @Impuestos5Linea, @ContUso, @VIN, @Espacio, @AFArticulo, @AFSerie, @Lectura, @LecturaAnterior, @Deducible, @ContUso2, @ContUso3, @ClavePresupuestal, @Cantidad

		IF @@ERROR <> 0
			SELECT @Ok = 1

		END
		CLOSE crGasto
		DEALLOCATE crGasto
	END

	IF @MovImpuesto = 1
	BEGIN
		DELETE MovImpuesto
		WHERE Modulo = @Modulo
			AND ModuloID = @ID
		INSERT MovImpuesto (Modulo, ModuloID, OrigenModulo, OrigenModuloID, OrigenConcepto, OrigenDeducible, OrigenFecha, LoteFijo, Impuesto1, Impuesto2, Impuesto3, Impuesto5, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoImpuesto5, TipoRetencion1, TipoRetencion2, TipoRetencion3, SubFolio, Importe1, Importe2, Importe3, Importe5, SubTotal, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, ImporteBruto)
			SELECT @Modulo
				  ,@ID
				  ,@Modulo
				  ,@ID
				  ,OrigenConcepto
				  ,ISNULL(OrigenDeducible, 100)
				  ,OrigenFecha
				  ,LoteFijo
				  ,Impuesto1
				  ,Impuesto2
				  ,Impuesto3
				  ,Impuesto5
				  ,Retencion1
				  ,Retencion2
				  ,Retencion3
				  ,Excento1
				  ,Excento2
				  ,Excento3
				  ,TipoImpuesto1
				  ,TipoImpuesto2
				  ,TipoImpuesto3
				  ,TipoImpuesto5
				  ,TipoRetencion1
				  ,TipoRetencion2
				  ,TipoRetencion3
				  ,SubFolio
				  ,SUM(Importe1)
				  ,SUM(Importe2)
				  ,SUM(Importe3)
				  ,SUM(Importe5)
				  ,SUM(SubTotal)
				  ,ContUso
				  ,ContUso2
				  ,ContUso3
				  ,ClavePresupuestal
				  ,ClavePresupuestalImpuesto1
				  ,SUM(ImporteBruto)
			FROM #GastoMovImpuesto
			GROUP BY OrigenConcepto
					,ISNULL(OrigenDeducible, 100)
					,OrigenFecha
					,LoteFijo
					,Impuesto1
					,Impuesto2
					,Impuesto3
					,Impuesto5
					,Retencion1
					,Retencion2
					,Retencion3
					,Excento1
					,Excento2
					,Excento3
					,TipoImpuesto1
					,TipoImpuesto2
					,TipoImpuesto3
					,TipoImpuesto5
					,TipoRetencion1
					,TipoRetencion2
					,TipoRetencion3
					,SubFolio
					,ContUso
					,ContUso2
					,ContUso3
					,ClavePresupuestal
					,ClavePresupuestalImpuesto1
			ORDER BY OrigenConcepto, ISNULL(OrigenDeducible, 100), OrigenFecha, LoteFijo, Impuesto1, Impuesto2, Impuesto3, Impuesto5, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoImpuesto5, TipoRetencion1, TipoRetencion2, TipoRetencion3, SubFolio, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1
	END

	SELECT @RetencionTotal = @SumaRetencion + @SumaRetencion2 + @SumaRetencion3
	SELECT @ImpuestoTotal = @SumaImpuestos + @SumaImpuestos2 + @SumaImpuestos3 + @SumaImpuestos5
	SELECT @ImporteTotal = ROUND(ISNULL(@Importe, 0.0) - ISNULL(@RetencionTotal, 0.0) + ISNULL(@ImpuestoTotal, 0.0), @RedondeoMonetarios)
	SELECT @ImporteSinRetenciones = ROUND(ISNULL(@Importe, 0.0) - ISNULL(@RetencionTotal, 0.0), @RedondeoMonetarios)
	SELECT @ImportePendiente = @ImporteTotal

	IF @MovTipo IN ('GAS.C', 'GAS.ASC', 'GAS.CCH', 'GAS.CP', 'GAS.OI')
		AND @Accion = 'CANCELAR'
		SELECT @ImportePendiente = @ImportePendiente - ISNULL(SUM(Importe), 0)
		FROM Dinero
		WHERE Empresa = @Empresa
		AND OrigenTipo = @Modulo
		AND Origen = @Mov
		AND OrigenID = @MovID
		AND Estatus IN ('PENDIENTE', 'CONCLUIDO')

	IF @Multiple = 1
	BEGIN
		CREATE TABLE #GastoAplica (
			ID INT NOT NULL PRIMARY KEY
		   ,Estatus CHAR(15) COLLATE Database_Default NULL
		   ,FechaConclusion DATETIME NULL
		   ,Saldo MONEY NULL
		)
		DECLARE
			crGastoAplica
			CURSOR LOCAL FOR
			SELECT g.ID
				  ,g.Mov
				  ,g.MovID
				  ,g.Estatus
				  ,ISNULL(g.Saldo, 0.0)
				  ,ISNULL(g.Importe, 0.0) - ISNULL(g.Retencion, 0.0) + ISNULL(g.Impuestos, 0.0)
				  ,ISNULL(ga.Importe, 0.0)
				  ,mt.Clave
			FROM GastoAplica ga
				,Gasto g
				,MovTipo mt
			WHERE ga.ID = @ID
			AND g.Empresa = @Empresa
			AND g.Mov = ga.Aplica
			AND g.MovID = ga.AplicaID
			AND g.Estatus IN ('PENDIENTE', 'CONCLUIDO')
			AND mt.Modulo = @Modulo
			AND mt.Mov = g.Mov
			ORDER BY ga.Renglon
		OPEN crGastoAplica
		FETCH NEXT FROM crGastoAplica INTO @AntecedenteID, @AntecedenteMov, @AntecedenteMovID, @AntecedenteEstatus, @AntecedenteSaldo, @AntecedenteImporteTotal, @ImporteAplicado, @AntecedenteMovTipo
		WHILE @@FETCH_STATUS <> -1
		AND @Ok IS NULL
		BEGIN

		IF @@FETCH_STATUS <> -2
			AND @Ok IS NULL
			AND @ImportePendiente > 0.0
		BEGIN

			IF @MovTipo IN ('GAS.A', 'GAS.C', 'GAS.ASC', 'GAS.CCH', 'GAS.G', 'GAS.GTC', 'GAS.GP', 'GAS.CP', 'GAS.DA', 'GAS.SR', 'GAS.CI')
				AND @AntecedenteID IS NOT NULL
				AND @Ok IS NULL
			BEGIN

				IF @Accion <> 'CANCELAR'
				BEGIN
					EXEC spMovInfo @AntecedenteID
								  ,@Modulo
								  ,@Mov = @AplicaMov OUTPUT
								  ,@MovID = @AplicaMovID OUTPUT
								  ,@FechaEmision = @AplicaFechaEmision OUTPUT
								  ,@Ejercicio = @AplicaEjercicio OUTPUT
								  ,@Periodo = @AplicaPeriodo OUTPUT

					IF @Ok IS NULL
						AND @Accion <> 'CANCELAR'
						EXEC spValidarFechaAplicacion @Sucursal
													 ,@Accion
													 ,@Empresa
													 ,@Modulo
													 ,@ID
													 ,@Mov
													 ,@MovID
													 ,@FechaEmision
													 ,@Ejercicio
													 ,@Periodo
													 ,@AplicaMov
													 ,@AplicaMovID
													 ,@Modulo
													 ,@AntecedenteID
													 ,@AplicaFechaEmision
													 ,@AplicaEjercicio
													 ,@AplicaPeriodo
													 ,@Ok = @Ok OUTPUT
													 ,@OkRef = @OkRef OUTPUT

					IF @Ok IS NULL
						AND @Accion <> 'CANCELAR'
						EXEC spEmpresaValidarFechaAplicacion @Sucursal
															,@Accion
															,@Empresa
															,@Modulo
															,@ID
															,@Mov
															,@MovID
															,@FechaEmision
															,@Ejercicio
															,@Periodo
															,@AplicaMov
															,@AplicaMovID
															,@Modulo
															,@AntecedenteID
															,@AplicaFechaEmision
															,@AplicaEjercicio
															,@AplicaPeriodo
															,@Ok = @Ok OUTPUT
															,@OkRef = @OkRef OUTPUT

					IF @AntecedenteMovTipo IN ('GAS.A', 'GAS.S', 'GAS.P')
					BEGIN

						IF @AntecedenteMovTipo IN ('GAS.S', 'GAS.P')
							OR @ImportePendiente > @AntecedenteSaldo
							SELECT @ImporteAplicado = @AntecedenteSaldo
						ELSE
							SELECT @ImporteAplicado = @ImportePendiente

						SELECT @ImportePendiente = @ImportePendiente - @ImporteAplicado

						IF @MovTipo IN ('GAS.G', 'GAS.GTC', 'GAS.GP', 'GAS.C', 'GAS.ASC', 'GAS.CCH', 'GAS.CP')
							AND @AntecedenteMovTipo = 'GAS.A'
							SELECT @Anticipo = @Anticipo + @ImporteAplicado

						SELECT @AntecedenteSaldo = @AntecedenteSaldo - @ImporteAplicado

						IF @AntecedenteMovTipo IN ('GAS.S', 'GAS.P')
							SELECT @AntecedenteSaldo = 0.0

						UPDATE GastoAplica
						SET Importe = @ImporteAplicado
						WHERE CURRENT OF crGastoAplica
					END

				END
				ELSE
					SELECT @AntecedenteSaldo = @AntecedenteSaldo + @ImporteAplicado

				SELECT @AntecedenteSaldo = ROUND(@AntecedenteSaldo, 2)

				IF @AntecedenteSaldo = 0.0
					SELECT @AntecedenteEstatusNuevo = 'CONCLUIDO'
						  ,@AntecedenteFechaConclusion = @FechaEmision
				ELSE
					SELECT @AntecedenteEstatusNuevo = 'PENDIENTE'
						  ,@AntecedenteFechaConclusion = NULL

				EXEC spValidarTareas @Empresa
									,@Modulo
									,@AntecedenteID
									,@AntecedenteEstatusNuevo
									,@Ok OUTPUT
									,@OkRef OUTPUT

				IF NOT EXISTS (SELECT * FROM #GastoAplica WHERE ID = @AntecedenteID)
					INSERT #GastoAplica (ID, Estatus, FechaConclusion, Saldo)
						VALUES (@AntecedenteID, @AntecedenteEstatusNuevo, @AntecedenteFechaConclusion, @AntecedenteSaldo)

				IF @Ok IS NULL
					OR @Ok BETWEEN 80030 AND 81000
					EXEC spMovFinal @Empresa
								   ,@Sucursal
								   ,@Modulo
								   ,@AntecedenteID
								   ,@AntecedenteEstatus
								   ,@AntecedenteEstatusNuevo
								   ,@Usuario
								   ,@FechaEmision
								   ,@FechaRegistro
								   ,@AntecedenteMov
								   ,@AntecedenteMovID
								   ,@AntecedenteMovTipo
								   ,@IDGenerar
								   ,@Ok OUTPUT
								   ,@OkRef OUTPUT

				EXEC spMovFlujo @Sucursal
							   ,@Accion
							   ,@Empresa
							   ,@Modulo
							   ,@AntecedenteID
							   ,@AntecedenteMov
							   ,@AntecedenteMovID
							   ,@Modulo
							   ,@ID
							   ,@Mov
							   ,@MovID
							   ,@Ok OUTPUT
			END

		END

		FETCH NEXT FROM crGastoAplica INTO @AntecedenteID, @AntecedenteMov, @AntecedenteMovID, @AntecedenteEstatus, @AntecedenteSaldo, @AntecedenteImporteTotal, @ImporteAplicado, @AntecedenteMovTipo

		IF @@ERROR <> 0
			SELECT @Ok = 1

		END
		CLOSE crGastoAplica
		DEALLOCATE crGastoAplica
		UPDATE Gasto
		SET Estatus = ga.Estatus
		   ,FechaConclusion = ga.FechaConclusion
		   ,Saldo = NULLIF(ga.Saldo, 0.0)
		FROM Gasto g, #GastoAplica ga
		WHERE g.ID = ga.ID
	END
	ELSE
	BEGIN

		IF @MovTipo IN ('GAS.A', 'GAS.C', 'GAS.ASC', 'GAS.CCH', 'GAS.G', 'GAS.GTC', 'GAS.GP', 'GAS.CP', 'GAS.DA', 'GAS.SR', 'GAS.CI')
			AND @AntecedenteID IS NOT NULL
			AND @Ok IS NULL
		BEGIN

			IF @Accion <> 'CANCELAR'
			BEGIN
				EXEC spMovInfo @AntecedenteID
							  ,@Modulo
							  ,@Mov = @AplicaMov OUTPUT
							  ,@MovID = @AplicaMovID OUTPUT
							  ,@FechaEmision = @AplicaFechaEmision OUTPUT
							  ,@Ejercicio = @AplicaEjercicio OUTPUT
							  ,@Periodo = @AplicaPeriodo OUTPUT

				IF @Ok IS NULL
					AND @Accion <> 'CANCELAR'
					EXEC spValidarFechaAplicacion @Sucursal
												 ,@Accion
												 ,@Empresa
												 ,@Modulo
												 ,@ID
												 ,@Mov
												 ,@MovID
												 ,@FechaEmision
												 ,@Ejercicio
												 ,@Periodo
												 ,@AplicaMov
												 ,@AplicaMovID
												 ,@Modulo
												 ,@AntecedenteID
												 ,@AplicaFechaEmision
												 ,@AplicaEjercicio
												 ,@AplicaPeriodo
												 ,@Ok = @Ok OUTPUT
												 ,@OkRef = @OkRef OUTPUT

				IF @Ok IS NULL
					AND @Accion <> 'CANCELAR'
					EXEC spEmpresaValidarFechaAplicacion @Sucursal
														,@Accion
														,@Empresa
														,@Modulo
														,@ID
														,@Mov
														,@MovID
														,@FechaEmision
														,@Ejercicio
														,@Periodo
														,@AplicaMov
														,@AplicaMovID
														,@Modulo
														,@AntecedenteID
														,@AplicaFechaEmision
														,@AplicaEjercicio
														,@AplicaPeriodo
														,@Ok = @Ok OUTPUT
														,@OkRef = @OkRef OUTPUT

				IF @AntecedenteMovTipo IN ('GAS.S', 'GAS.P')
					SELECT @AntecedenteSaldo = 0.0
				ELSE

				IF @AntecedenteMovTipo IN ('GAS.A')
				BEGIN

					IF @MovTipo IN ('GAS.G', 'GAS.GTC', 'GAS.GP', 'GAS.C', 'GAS.ASC', 'GAS.CCH', 'GAS.CP')
						SELECT @Anticipo = @AntecedenteSaldo

					SELECT @AntecedenteSaldo = @AntecedenteSaldo - @ImportePendiente

					IF @AntecedenteMovTipo = 'GAS.S'
						SELECT @AntecedenteSaldo = 0.0

				END

			END
			ELSE
			BEGIN

				IF @AntecedenteMovTipo IN ('GAS.S', 'GAS.P')
					SELECT @AntecedenteSaldo = @AntecedenteImporteTotal
				ELSE

				IF @AntecedenteMovTipo IN ('GAS.A')
				BEGIN
					SELECT @AntecedenteSaldo = @AntecedenteSaldo + @ImportePendiente
				END

			END

			SELECT @AntecedenteSaldo = ROUND(@AntecedenteSaldo, 2)

			IF @AntecedenteSaldo < 0.0
				SELECT @AntecedenteSaldo = 0.0
			ELSE

			IF @AntecedenteSaldo > @AntecedenteImporteTotal
				SELECT @AntecedenteSaldo = @AntecedenteImporteTotal

			IF ISNULL(@AntecedenteSaldo, 0) = 0.0
				SELECT @AntecedenteEstatusNuevo = 'CONCLUIDO'
					  ,@AntecedenteFechaConclusion = @FechaEmision
			ELSE
				SELECT @AntecedenteEstatusNuevo = 'PENDIENTE'
					  ,@AntecedenteFechaConclusion = NULL

			EXEC spValidarTareas @Empresa
								,@Modulo
								,@AntecedenteID
								,@AntecedenteEstatusNuevo
								,@Ok OUTPUT
								,@OkRef OUTPUT
			UPDATE Gasto
			SET Estatus = @AntecedenteEstatusNuevo
			   ,FechaConclusion = @AntecedenteFechaConclusion
			   ,Saldo = NULLIF(@AntecedenteSaldo, 0.0)
			WHERE ID = @AntecedenteID

			IF @Ok IS NULL
				OR @Ok BETWEEN 80030 AND 81000
				EXEC spMovFinal @Empresa
							   ,@Sucursal
							   ,@Modulo
							   ,@AntecedenteID
							   ,@AntecedenteEstatus
							   ,@AntecedenteEstatusNuevo
							   ,@Usuario
							   ,@FechaEmision
							   ,@FechaRegistro
							   ,@MovAplica
							   ,@MovAplicaID
							   ,@AntecedenteMovTipo
							   ,@IDGenerar
							   ,@Ok OUTPUT
							   ,@OkRef OUTPUT

			EXEC spMovFlujo @Sucursal
						   ,@Accion
						   ,@Empresa
						   ,@Modulo
						   ,@AntecedenteID
						   ,@MovAplica
						   ,@MovAplicaID
						   ,@Modulo
						   ,@ID
						   ,@Mov
						   ,@MovID
						   ,@Ok OUTPUT
		END

	END

	IF @Ok IS NULL
	BEGIN

		IF @EstatusNuevo = 'PENDIENTE'
			AND @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR')
			SELECT @Saldo = @ImporteTotal

		IF @EstatusNuevo = 'CANCELADO'
			SELECT @FechaCancelacion = @FechaRegistro
				  ,@Saldo = NULL
		ELSE
			SELECT @FechaCancelacion = NULL

		IF @EstatusNuevo = 'CONCLUIDO'
			SELECT @FechaConclusion = @FechaEmision
				  ,@Saldo = NULL
		ELSE

		IF @EstatusNuevo <> 'CANCELADO'
			SELECT @FechaConclusion = NULL

		IF @CfgContX = 1
			AND @CfgContXGenerar <> 'NO'
		BEGIN

			IF @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR')
				AND @EstatusNuevo <> 'CANCELADO'
				SELECT @GenerarPoliza = 1
			ELSE

			IF @Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR')
				AND @EstatusNuevo = 'CANCELADO'

				IF @GenerarPoliza = 1
					SELECT @GenerarPoliza = 0
				ELSE
					SELECT @GenerarPoliza = 1

		END

		EXEC spValidarTareas @Empresa
							,@Modulo
							,@ID
							,@EstatusNuevo
							,@Ok OUTPUT
							,@OkRef OUTPUT
		UPDATE Gasto
		SET Importe = @Importe
		   ,Retencion = @RetencionTotal
		   ,Impuestos = @ImpuestoTotal
		   ,Saldo = NULLIF(@Saldo, 0.0)
		   ,Anticipo = NULLIF(@Anticipo, 0.0)
		   ,IVAFiscal = CONVERT(FLOAT, NULLIF(@SumaImpuestos, 0)) / NULLIF(@Importe + @ImpuestoTotal - @RetencionTotal, 0)
		   ,IEPSFiscal = CONVERT(FLOAT, NULLIF(@SumaImpuestos2, 0)) / NULLIF(@Importe + @ImpuestoTotal - @RetencionTotal, 0)
		   ,FechaConclusion = @FechaConclusion
		   ,FechaCancelacion = @FechaCancelacion
		   ,UltimoCambio =
			CASE
				WHEN UltimoCambio IS NULL THEN @FechaRegistro
				ELSE UltimoCambio
			END
		   ,Vencimiento = @Vencimiento
		   ,Estatus = @EstatusNuevo
		   ,Situacion =
			CASE
				WHEN @Estatus <> @EstatusNuevo THEN NULL
				ELSE Situacion
			END
		   ,GenerarPoliza = @GenerarPoliza
		   ,Autorizacion = @Autorizacion
		   ,Mensaje = NULL
		WHERE ID = @ID

		IF @@ERROR <> 0
			SELECT @Ok = 1

		IF @MovTipo IN ('GAS.DA', 'GAS.SR', 'GAS.ASC')
			AND @AntecedenteID IS NOT NULL
			UPDATE Gasto
			SET IVAFiscal = (
				SELECT IVAFiscal
				FROM Gasto
				WHERE ID = @AntecedenteID
			)
			WHERE ID = @ID

	END

	SELECT @IVAFiscal = IVAFiscal
		  ,@IEPSFiscal = IEPSFiscal
	FROM Gasto
	WHERE ID = @ID
	SELECT @AfectarOtrosModulos = 0

	IF (@MovTipo IN ('GAS.A', 'GAS.DA', 'GAS.ASC') OR (@MovTipo IN ('GAS.G', 'GAS.GTC', 'GAS.GP', 'GAS.C', 'GAS.CCH', 'GAS.CP', 'GAS.DG', 'GAS.DC', 'GAS.DGP', 'GAS.OI', 'GAS.CB', 'GAS.AB') AND @ImporteTotal - @Anticipo > 0))
		AND @OrigenMovTipo NOT IN ('GAS.GP', 'GAS.CP', 'GAS.DGP')
		SELECT @AfectarOtrosModulos = 1

	EXEC xpGastoAfectarOtrosModulos @MovTipo
								   ,@OrigenMovTipo
								   ,@AfectarOtrosModulos OUTPUT
								   ,@Ok OUTPUT
								   ,@OkRef OUTPUT

	IF @AfectarOtrosModulos = 1
		AND @Ok IS NULL
	BEGIN

		IF (@Fiscal = 0 OR @FiscalGenerarRetenciones = 1)
			AND @RetencionAlPago = 0
			AND @MovTipo IN ('GAS.G', 'GAS.GTC', 'GAS.DG', 'GAS.C', 'GAS.CCH', 'GAS.DGP', 'GAS.OI')
		BEGIN

			IF @SumaRetencion <> 0.0
				AND @CfgRetencionConcepto NOT IN ('(Concepto Gasto)', 'ISR - (Concepto Gasto)')
				AND @Mov NOT IN ('Sin Comprobante', 'Sin Comprobante Inst', 'Reposicion Rechazada')
			BEGIN

				IF @CfgRetencionAcreedor IS NULL
					SELECT @Ok = 70100
				ELSE
					EXEC spGenerarCx @Sucursal
									,@SucursalOrigen
									,@SucursalDestino
									,@Accion
									,NULL
									,@Empresa
									,@Modulo
									,@ID
									,@Mov
									,@MovID
									,@MovTipo
									,@MovMoneda
									,@MovTipoCambio
									,@FechaEmision
									,@CfgRetencionConcepto
									,@Proyecto
									,@Usuario
									,@Autorizacion
									,@Referencia
									,@DocFuente
									,@Observaciones
									,@FechaRegistro
									,@Ejercicio
									,@Periodo
									,NULL
									,NULL
									,@CfgRetencionAcreedor
									,NULL
									,NULL
									,NULL
									,NULL
									,NULL
									,@SumaRetencion
									,NULL
									,NULL
									,NULL
									,NULL
									,NULL
									,NULL
									,NULL
									,NULL
									,@CfgRetencionMov
									,@CxModulo OUTPUT
									,@CxMov OUTPUT
									,@CxMovID OUTPUT
									,@Ok OUTPUT
									,@OkRef OUTPUT
									,@Nota = @Nota

			END

			IF @SumaRetencion2 <> 0.0
				AND @CfgRetencion2Concepto NOT IN ('(Concepto Gasto)', 'IVA - (Concepto Gasto)')
				AND @Mov NOT IN ('Sin Comprobante', 'Sin Comprobante Inst', 'Reposicion Rechazada')
			BEGIN

				IF @CfgRetencion2Acreedor IS NULL
					SELECT @Ok = 70100
				ELSE
					EXEC spGenerarCx @Sucursal
									,@SucursalOrigen
									,@SucursalDestino
									,@Accion
									,NULL
									,@Empresa
									,@Modulo
									,@ID
									,@Mov
									,@MovID
									,@MovTipo
									,@MovMoneda
									,@MovTipoCambio
									,@FechaEmision
									,@CfgRetencion2Concepto
									,@Proyecto
									,@Usuario
									,@Autorizacion
									,@Referencia
									,@DocFuente
									,@Observaciones
									,@FechaRegistro
									,@Ejercicio
									,@Periodo
									,NULL
									,NULL
									,@CfgRetencion2Acreedor
									,NULL
									,NULL
									,NULL
									,NULL
									,NULL
									,@SumaRetencion2
									,NULL
									,NULL
									,NULL
									,NULL
									,NULL
									,NULL
									,NULL
									,NULL
									,@CfgRetencionMov
									,@CxModulo OUTPUT
									,@CxMov OUTPUT
									,@CxMovID OUTPUT
									,@Ok OUTPUT
									,@OkRef OUTPUT
									,@Nota = @Nota

			END

			IF @SumaRetencion3 <> 0.0
				AND @CfgRetencion3Concepto NOT IN ('(Concepto Gasto)', 'R3 - (Concepto Gasto)')
				AND @Mov NOT IN ('Sin Comprobante', 'Sin Comprobante Inst', 'Reposicion Rechazada')
			BEGIN

				IF @CfgRetencion3Acreedor IS NULL
					SELECT @Ok = 70100
				ELSE
					EXEC spGenerarCx @Sucursal
									,@SucursalOrigen
									,@SucursalDestino
									,@Accion
									,NULL
									,@Empresa
									,@Modulo
									,@ID
									,@Mov
									,@MovID
									,@MovTipo
									,@MovMoneda
									,@MovTipoCambio
									,@FechaEmision
									,@CfgRetencion3Concepto
									,@Proyecto
									,@Usuario
									,@Autorizacion
									,@Referencia
									,@DocFuente
									,@Observaciones
									,@FechaRegistro
									,@Ejercicio
									,@Periodo
									,NULL
									,NULL
									,@CfgRetencion3Acreedor
									,NULL
									,NULL
									,NULL
									,NULL
									,NULL
									,@SumaRetencion3
									,NULL
									,NULL
									,NULL
									,NULL
									,NULL
									,NULL
									,NULL
									,NULL
									,@CfgRetencionMov
									,@CxModulo OUTPUT
									,@CxMov OUTPUT
									,@CxMovID OUTPUT
									,@Ok OUTPUT
									,@OkRef OUTPUT
									,@Nota = @Nota

			END

		END

		IF @MovTipo IN ('GAS.G', 'GAS.GTC', 'GAS.GP', 'GAS.DG', 'GAS.DGP', 'GAS.ASC')
		BEGIN

			IF @Anticipo > 0.0
				AND @MovTipo <> 'GAS.ASC'
				SELECT @Ok = 30420

			SELECT @CxImporte = @Importe
				  ,@CxImpuestos = @ImpuestoTotal
				  ,@CxRetencion = @SumaRetencion
				  ,@CxRetencion2 = @SumaRetencion2
				  ,@CxRetencion3 = @SumaRetencion3

			IF @SubClave = 'GAS.GE/GT'
			BEGIN
				DECLARE
					@GTImpuesto1Mov VARCHAR(20)
				   ,@GTImpuesto1Acreedor VARCHAR(10)
				SELECT @GTImpuesto1Mov = NULLIF(RTRIM(Impuesto1Mov), '')
					  ,@GTImpuesto1Acreedor = NULLIF(RTRIM(Impuesto1Acreedor), '')
				FROM EmpresaCfgGT
				WHERE Empresa = @Empresa

				IF @GTImpuesto1Mov IS NULL
					OR @GTImpuesto1Acreedor IS NULL
					SELECT @Ok = 20500
						  ,@OkRef = 'EmpresaCfgGT'

				EXEC spGenerarCx @Sucursal
								,@SucursalOrigen
								,@SucursalDestino
								,@Accion
								,NULL
								,@Empresa
								,@Modulo
								,@ID
								,@Mov
								,@MovID
								,@MovTipo
								,@MovMoneda
								,@MovTipoCambio
								,@FechaEmision
								,@CfgRetencionConcepto
								,@Proyecto
								,@Usuario
								,@Autorizacion
								,@Referencia
								,@DocFuente
								,@Observaciones
								,@FechaRegistro
								,@Ejercicio
								,@Periodo
								,NULL
								,NULL
								,@GTImpuesto1Acreedor
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,@ImpuestoTotal
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,@GTImpuesto1Mov
								,@CxModulo OUTPUT
								,@CxMov OUTPUT
								,@CxMovID OUTPUT
								,@Ok OUTPUT
								,@OkRef OUTPUT
								,@Nota = @Nota
				SELECT @CxImporte = @CxImporte - ISNULL(@CxRetencion, 0.0)
				SELECT @CxRetencion = NULL
					  ,@CxImpuestos = NULL
			END

			IF @MovTipo = 'GAS.ASC'
			BEGIN
				SELECT @CxAgente = NULLIF(RTRIM(Agente), '')
				FROM Prov
				WHERE Proveedor = @Acreedor

				IF @CxAgente IS NULL
					SELECT @Ok = 20935
						  ,@OkRef = @Acreedor

				SELECT @CxComision = @ImporteTotal
					  ,@CxImporte = NULL
					  ,@CxImpuestos = NULL
					  ,@CxRetencion = NULL
					  ,@CxRetencion2 = NULL
					  ,@CxRetencion3 = NULL
			END

			IF @Ok IS NULL
			BEGIN

				IF @MovTipo = 'GAS.GTC'
				BEGIN
					SELECT @Conteo = 0
					DECLARE
						crGastoD
						CURSOR FOR
						SELECT NULLIF(RTRIM(EndosarA), '')
							  ,NULLIF(RTRIM(Concepto), '')
							  ,NULLIF(RTRIM(Referencia), '')
							  ,ISNULL(Importe, 0.0)
							  ,ISNULL(Retencion, 0.0)
							  ,ISNULL(Retencion2, 0.0)
							  ,ISNULL(Retencion3, 0.0)
							  ,ISNULL(Impuestos, 0.0)
							  ,ISNULL(Impuestos2, 0.0)
							  ,ISNULL(Impuestos3, 0.0)
							  ,ISNULL(Impuestos5, 0.0)
						FROM GastoD
						WHERE ID = @ID
					OPEN crGastoD
					FETCH NEXT FROM crGastoD INTO @EndosarA, @ConceptoLinea, @ReferenciaLinea, @ImporteLinea, @RetencionLinea, @Retencion2Linea, @Retencion3Linea, @ImpuestosLinea, @Impuestos2Linea, @Impuestos3Linea, @Impuestos5Linea
					WHILE @@FETCH_STATUS <> -1
					AND @Ok IS NULL
					BEGIN

					IF @@FETCH_STATUS <> -2
						AND @Ok IS NULL
					BEGIN

						IF @CfgImpuesto2Info = 1
							SELECT @Impuestos2Linea = 0.0

						IF @CfgImpuesto3Info = 1
							SELECT @Impuestos3Linea = 0.0

						SELECT @ImpuestosLineaTotal = @ImpuestosLinea + @Impuestos2Linea + @Impuestos3Linea + @Impuestos5Linea
						SELECT @Conteo = @Conteo + 1
						EXEC spGenerarCx @Sucursal
										,@SucursalOrigen
										,@SucursalDestino
										,@Accion
										,NULL
										,@Empresa
										,@Modulo
										,@ID
										,@Mov
										,@MovID
										,@MovTipo
										,@MovMoneda
										,@MovTipoCambio
										,@FechaEmision
										,@ConceptoLinea
										,@Proyecto
										,@Usuario
										,@Autorizacion
										,@ReferenciaLinea
										,@DocFuente
										,@Observaciones
										,@FechaRegistro
										,@Ejercicio
										,@Periodo
										,@Condicion
										,@Vencimiento
										,@EndosarA
										,NULL
										,@CxAgente
										,NULL
										,NULL
										,NULL
										,@ImporteLinea
										,@ImpuestosLineaTotal
										,@RetencionLinea
										,@ImporteLinea
										,NULL
										,NULL
										,NULL
										,NULL
										,NULL
										,NULL
										,@CxModulo OUTPUT
										,@CxMov OUTPUT
										,@CxMovID OUTPUT
										,@Ok OUTPUT
										,@OkRef OUTPUT
										,@Retencion2 = @Retencion2Linea
										,@Retencion3 = @Retencion3Linea
										,@Conteo = @Conteo
										,@Nota = @Nota
					END

					FETCH NEXT FROM crGastoD INTO @EndosarA, @ConceptoLinea, @ReferenciaLinea, @ImporteLinea, @RetencionLinea, @Retencion2Linea, @Retencion3Linea, @ImpuestosLinea, @Impuestos2Linea, @Impuestos3Linea, @Impuestos5Linea
					END
					CLOSE crGastoD
					DEALLOCATE crGastoD
				END
				ELSE
				BEGIN

					IF @GasConceptoMultiple = 1
					BEGIN
						DECLARE
							crCursorConcepto
							CURSOR FOR
							SELECT ISNULL(SUM(d.Importe), 0)
								  ,SUM(ISNULL(d.Impuestos, 0) + ISNULL(CASE
									   WHEN @CfgImpuesto2Info = 1 THEN 0.0
									   ELSE d.Impuestos2
								   END, 0) + ISNULL(CASE
									   WHEN @CfgImpuesto3Info = 1 THEN 0.0
									   ELSE d.Impuestos3
								   END, 0))
								  ,SUM(ISNULL(d.Retencion, 0))
								  ,SUM(ISNULL(d.Retencion2, 0))
								  ,c.ConceptoCxp
							FROM GastoD d
							JOIN Concepto c
								ON c.Concepto = d.Concepto
							WHERE d.ID = @ID
							AND c.Modulo = @Modulo
							GROUP BY c.ConceptoCxp
						OPEN crCursorConcepto
						FETCH NEXT FROM crCursorConcepto INTO @CxImporte, @CxImpuestos, @CxRetencion, @CxRetencion2, @ConceptoCxp
						WHILE @@FETCH_STATUS = 0
						AND @Ok IS NULL
						BEGIN
						SELECT @ImporteTotal = ROUND(ISNULL(@CxImporte, 0.0) - ISNULL(@CxRetencion, 0.0) + ISNULL(@CxImpuestos, 0.0), @RedondeoMonetarios)

						IF @MovTipo = 'GAS.ASC'
							SELECT @CxComision = @ImporteTotal
								  ,@CxImporte = NULL
								  ,@CxImpuestos = NULL
								  ,@CxRetencion = NULL
								  ,@CxRetencion2 = NULL
								  ,@CxRetencion3 = NULL

						EXEC spGenerarCx @Sucursal
										,@SucursalOrigen
										,@SucursalDestino
										,@Accion
										,NULL
										,@Empresa
										,@Modulo
										,@ID
										,@Mov
										,@MovID
										,@MovTipo
										,@MovMoneda
										,@MovTipoCambio
										,@FechaEmision
										,@ConceptoCxp
										,@Proyecto
										,@Usuario
										,@Autorizacion
										,@Referencia
										,@DocFuente
										,@Observaciones
										,@FechaRegistro
										,@Ejercicio
										,@Periodo
										,@Condicion
										,@Vencimiento
										,@Acreedor
										,NULL
										,@CxAgente
										,NULL
										,@CtaDinero
										,NULL
										,@CxImporte
										,@CxImpuestos
										,@CxRetencion
										,@CxComision
										,NULL
										,NULL
										,NULL
										,NULL
										,NULL
										,NULL
										,@CxModulo OUTPUT
										,@CxMov OUTPUT
										,@CxMovID OUTPUT
										,@Ok OUTPUT
										,@OkRef OUTPUT
										,@Retencion2 = @CxRetencion2
										,@Retencion3 = @CxRetencion3
										,@Nota = @Nota
										,@CopiarMovImpuesto = 1
						FETCH NEXT FROM crCursorConcepto INTO @CxImporte, @CxImpuestos, @CxRetencion, @CxRetencion2, @ConceptoCxp
						END
						CLOSE crCursorConcepto
						DEALLOCATE crCursorConcepto
					END
					ELSE
					BEGIN
						EXEC spGenerarCx @Sucursal
										,@SucursalOrigen
										,@SucursalDestino
										,@Accion
										,NULL
										,@Empresa
										,@Modulo
										,@ID
										,@Mov
										,@MovID
										,@MovTipo
										,@MovMoneda
										,@MovTipoCambio
										,@FechaEmision
										,@ConceptoCxp
										,@Proyecto
										,@Usuario
										,@Autorizacion
										,@Referencia
										,@DocFuente
										,@Observaciones
										,@FechaRegistro
										,@Ejercicio
										,@Periodo
										,@Condicion
										,@Vencimiento
										,@Acreedor
										,NULL
										,@CxAgente
										,NULL
										,@CtaDinero
										,NULL
										,@CxImporte
										,@CxImpuestos
										,@CxRetencion
										,@CxComision
										,NULL
										,NULL
										,NULL
										,NULL
										,NULL
										,NULL
										,@CxModulo OUTPUT
										,@CxMov OUTPUT
										,@CxMovID OUTPUT
										,@Ok OUTPUT
										,@OkRef OUTPUT
										,@IVAFiscal = @IVAfiscal
										,@IEPSFiscal = @IEPSFiscal
										,@Retencion2 = @CxRetencion2
										,@Retencion3 = @CxRetencion3
										,@Nota = @Nota
										,@CopiarMovImpuesto = 1
					END

				END

			END

		END
		ELSE
		BEGIN

			IF @MovTipo IN ('GAS.C', 'GAS.CCH', 'GAS.CP', 'GAS.OI')
				SELECT @DineroImporte = @ImporteTotal - @Anticipo
			ELSE
				SELECT @DineroImporte = @ImporteTotal

			IF ROUND(@DineroImporte, 1) > 0.0
			BEGIN

				IF @MovTipo IN ('GAS.A', 'GAS.DA')
					AND (
						SELECT ISNULL(GastoAnticipoCxp, 0)
						FROM EmpresaCfg2
						WHERE Empresa = @Empresa
					)
					= 1
				BEGIN

					IF @Estatus = 'PENDIENTE'
						AND @EstatusNuevo = 'CONCLUIDO'
						AND @MovTipo = 'GAS.A'
						SELECT @OK = 60090

					SELECT @GastoAnticipoMov =
					 CASE @MovTipo
						 WHEN 'GAS.A' THEN CxpGastoAnticipo
						 WHEN 'GAS.DA' THEN CxpGastoDevAnticipo
					 END
					FROM EmpresaCfgMov
					WHERE Empresa = @Empresa
					EXEC spGenerarCx @Sucursal
									,@SucursalOrigen
									,@SucursalDestino
									,@Accion
									,NULL
									,@Empresa
									,@Modulo
									,@ID
									,@Mov
									,@MovID
									,@MovTipo
									,@MovMoneda
									,@MovTipoCambio
									,@FechaEmision
									,@ConceptoLinea
									,@Proyecto
									,@Usuario
									,@Autorizacion
									,@ReferenciaLinea
									,@DocFuente
									,@Observaciones
									,@FechaRegistro
									,@Ejercicio
									,@Periodo
									,'(Fecha)'
									,@FechaEmision
									,@Acreedor
									,NULL
									,@CxAgente
									,NULL
									,@CtaDinero
									,NULL
									,@DineroImporte
									,NULL
									,NULL
									,NULL
									,NULL
									,NULL
									,NULL
									,NULL
									,NULL
									,@GastoAnticipoMov
									,@CxModulo OUTPUT
									,@CxMov OUTPUT
									,@CxMovID OUTPUT
									,@Ok OUTPUT
									,@OkRef OUTPUT
									,@ModuloEspecifico = 'CXP'
									,@MovIDEspecifico = @MovID
									,@CopiarMovImpuesto = 1
				END
				ELSE
				BEGIN

					IF @MovTipo IN ('GAS.DA', 'GAS.DC', 'GAS.OI')
						AND UPPER(@FormaPago) = UPPER(@CfgFormaCobroDA)
						EXEC spDepositoAnticipado @Sucursal
												 ,@Accion
												 ,@ID
												 ,@Mov
												 ,@MovID
												 ,@Empresa
												 ,@Modulo
												 ,@CtaDinero
												 ,@DineroImporte
												 ,@MovMoneda
												 ,@RedondeoMonetarios
												 ,0
												 ,@FormaPago
												 ,@CfgFormaCobroDA
												 ,@Referencia
												 ,@Ok OUTPUT
												 ,@OkRef OUTPUT
					ELSE
					BEGIN

						IF @MovTipo IN ('GAS.CB', 'GAS.AB')
							SELECT @DineroImporte = @ImporteSinRetenciones

						EXEC spGenerarDinero @Sucursal
											,@SucursalOrigen
											,@SucursalDestino
											,@Accion
											,@Empresa
											,@Modulo
											,@ID
											,@Mov
											,@MovID
											,@MovTipo
											,@MovMoneda
											,@MovTipoCambio
											,@FechaAfectacion
											,NULL
											,@Proyecto
											,@Usuario
											,@Autorizacion
											,@Referencia
											,@DocFuente
											,@Observaciones
											,0
											,0
											,@FechaRegistro
											,@Ejercicio
											,@Periodo
											,@FormaPago
											,NULL
											,NULL
											,@Acreedor
											,@CtaDinero
											,NULL
											,@DineroImporte
											,NULL
											,NULL
											,NULL
											,NULL
											,@DineroMov OUTPUT
											,@DineroMovID OUTPUT
											,@Ok OUTPUT
											,@OkRef OUTPUT
					END

					IF @MovTipo IN ('GAS.CB', 'GAS.AB')
						AND NULLIF(@ImpuestoTotal, 0.0) IS NOT NULL
					BEGIN

						IF @Ok = 80030
							SELECT @Ok = NULL
								  ,@OkRef = NULL

						EXEC spGenerarDinero @Sucursal
											,@SucursalOrigen
											,@SucursalDestino
											,@Accion
											,@Empresa
											,@Modulo
											,@ID
											,@Mov
											,@MovID
											,@MovTipo
											,@MovMoneda
											,@MovTipoCambio
											,@FechaAfectacion
											,NULL
											,@Proyecto
											,@Usuario
											,@Autorizacion
											,@Referencia
											,@DocFuente
											,@Observaciones
											,0
											,0
											,@FechaRegistro
											,@Ejercicio
											,@Periodo
											,@FormaPago
											,NULL
											,NULL
											,@Acreedor
											,@CtaDinero
											,NULL
											,@ImpuestoTotal
											,NULL
											,NULL
											,NULL
											,NULL
											,@DineroMov OUTPUT
											,@DineroMovID OUTPUT
											,@Ok OUTPUT
											,@OkRef OUTPUT
											,@SeparacionDelIVA = 1
					END

				END

			END

		END

	END

	IF @OrigenMovTipo = 'GAS.GR'
		EXEC spAfectarMovRecurrente @Accion
								   ,@Empresa
								   ,@Modulo
								   ,@Origen
								   ,@OrigenID
								   ,@Ok OUTPUT
								   ,@OkRef OUTPUT

	IF @MovTipo = 'GAS.CTO'
		EXEC spMovContratoGenerar @Accion
								 ,@Empresa
								 ,@Sucursal
								 ,@Usuario
								 ,@Modulo
								 ,@ID
								 ,@Mov
								 ,@MovID
								 ,@FechaRegistro
								 ,@Ok OUTPUT
								 ,@OkRef OUTPUT

	IF @CfgGastoAutoCargos = 1
		AND @MovTipo IN ('GAS.G', 'GAS.GTC', 'GAS.C', 'GAS.CCH', 'GAS.DC', 'GAS.DG')
		AND @Ok IS NULL
		EXEC xpCompraAutoCargos @Sucursal
							   ,@SucursalOrigen
							   ,@SucursalDestino
							   ,@Accion
							   ,@Modulo
							   ,@Empresa
							   ,@ID
							   ,@Mov
							   ,@MovID
							   ,@MovTipo
							   ,@MovMoneda
							   ,@MovTipoCambio
							   ,@FechaEmision
							   ,NULL
							   ,@Proyecto
							   ,@Usuario
							   ,@Autorizacion
							   ,NULL
							   ,@DocFuente
							   ,@Observaciones
							   ,@FechaRegistro
							   ,@Ejercicio
							   ,@Periodo
							   ,@Condicion
							   ,@Vencimiento
							   ,@Acreedor
							   ,@Importe
							   ,@ImpuestoTotal
							   ,NULL
							   ,@Ok OUTPUT
							   ,@OkRef OUTPUT

	IF (
			SELECT TieneMovimientos
			FROM Prov
			WHERE Proveedor = @Acreedor
		)
		= 0
		UPDATE Prov
		SET TieneMovimientos = 1
		WHERE Proveedor = @Acreedor

	SELECT @AcreedorRef = AcreedorRef
	FROM GastoD
	WHERE ID = @ID

	IF ISNULL(@AcreedorRef, '') <> ''

		IF (
				SELECT TieneMovimientos
				FROM Prov
				WHERE Proveedor = @AcreedorRef
			)
			= 0
			UPDATE Prov
			SET TieneMovimientos = 1
			WHERE Proveedor = @AcreedorRef

	IF @MovTipo IN ('GAS.GP', 'GAS.CP', 'GAS.DGP', 'GAS.PRP')
	BEGIN

		IF @Ok = 80030
			SELECT @Ok = NULL
				  ,@OkRef = NULL

		EXEC spGastoProrratear @Sucursal
							  ,@ID
							  ,@Modulo
							  ,@Accion
							  ,@Empresa
							  ,@Usuario
							  ,@FechaRegistro
							  ,@Mov
							  ,@MovID
							  ,@MovTipo
							  ,@Ok OUTPUT
							  ,@OkRef OUTPUT
	END

	IF @CfgInv = 1
		AND @MovTipo IN ('GAS.S', 'GAS.SR', 'GAS.CI')
	BEGIN

		IF @MovTipo = 'GAS.CI'
		BEGIN
			SELECT @OrigenGasto = Origen
				  ,@OrigenIDGasto = OrigenID
			FROM Gasto
			WHERE Empresa = @Empresa
			AND Sucursal = @Sucursal
			AND Mov = @Origen
			AND MovID = @OrigenID

			IF NOT EXISTS (SELECT ID FROM Inv WHERE Empresa = @Empresa AND Sucursal = @Sucursal AND OrigenTipo = 'GAS' AND Origen = @OrigenGasto AND OrigenID = @OrigenIDGasto AND Estatus = 'CONCLUIDO')
				AND EXISTS (SELECT * FROM GastoD d JOIN Concepto c ON d.Concepto = c.Concepto AND c.Modulo = @Modulo AND c.EsInventariable = 1 WHERE d.ID = @ID)
				EXEC spGastoInv @ID
							   ,@Accion
							   ,@Empresa
							   ,@Usuario
							   ,@Sucursal
							   ,@Modulo
							   ,@Mov
							   ,@MovID
							   ,@MovTipo
							   ,@MovMoneda
							   ,@MovTipoCambio
							   ,@FechaEmision
							   ,@Estatus
							   ,@AntecedenteID
							   ,@CfgInvAlmacen
							   ,@Ok OUTPUT
							   ,@OkRef OUTPUT

		END
		ELSE

		IF @MovTipo = 'GAS.SR'
			OR EXISTS (SELECT * FROM GastoD d JOIN Concepto c ON d.Concepto = c.Concepto AND c.Modulo = @Modulo AND c.EsInventariable = 1 WHERE d.ID = @ID)
			EXEC spGastoInv @ID
						   ,@Accion
						   ,@Empresa
						   ,@Usuario
						   ,@Sucursal
						   ,@Modulo
						   ,@Mov
						   ,@MovID
						   ,@MovTipo
						   ,@MovMoneda
						   ,@MovTipoCambio
						   ,@FechaEmision
						   ,@Estatus
						   ,@AntecedenteID
						   ,@CfgInvAlmacen
						   ,@Ok OUTPUT
						   ,@OkRef OUTPUT

	END

	IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
		AND @EsEcuador = 1
		EXEC spEcuadorAutorizacion @Sucursal
								  ,@Empresa
								  ,@Modulo
								  ,@ID
								  ,@Accion
								  ,@EstatusNuevo
								  ,@Ok OUTPUT
								  ,@OkRef OUTPUT

	IF @Ok IS NULL
		EXEC spGastoAfectarClavePresupuestal @ID
											,@Accion
											,@Empresa
											,@Usuario
											,@Modulo
											,@Mov
											,@MovID
											,@MovTipo
											,@MovMoneda
											,@FechaEmision
											,@Estatus
											,@EstatusNuevo
											,@Acreedor
											,@Ok OUTPUT
											,@OkRef OUTPUT

	IF @Ok IS NULL
		EXEC xpGastoAfectar @ID
						   ,@Accion
						   ,@Empresa
						   ,@Usuario
						   ,@Modulo
						   ,@Mov
						   ,@MovID
						   ,@MovTipo
						   ,@MovMoneda
						   ,@FechaEmision
						   ,@Estatus
						   ,@EstatusNuevo
						   ,@Acreedor
						   ,@Ok OUTPUT
						   ,@OkRef OUTPUT

	IF @Ok IS NULL
		OR @Ok = 80030
		EXEC spGastoGenerarEntrada @ID
								  ,@Accion
								  ,@Empresa
								  ,@Usuario
								  ,@Modulo
								  ,@Mov
								  ,@MovID
								  ,@MovTipo
								  ,@MovMoneda
								  ,@FechaEmision
								  ,@Estatus
								  ,@EstatusNuevo
								  ,@Acreedor
								  ,@Ok OUTPUT
								  ,@OkRef OUTPUT

	IF @PPTO = 1
		AND @Accion <> 'CANCELAR'
		AND @Ok IS NULL
	BEGIN

		IF @MovTipo IN ('GAS.DA', 'GAS.SR', 'GAS.ASC')
			AND @AntecedenteID IS NOT NULL
		BEGIN

			IF @Multiple = 1
				SELECT @Ok = 20176
			ELSE
			BEGIN
				DELETE MovPresupuesto
				WHERE Modulo = @Modulo
					AND ModuloID = @ID
				INSERT MovPresupuesto (Modulo, ModuloID, CuentaPresupuesto, Importe)
					SELECT @Modulo
						  ,@ID
						  ,CuentaPresupuesto
						  ,@ImporteTotal * Importe / NULLIF(@AntecedenteImporteTotal, 0.0)
					FROM MovPresupuesto
					WHERE Modulo = @Modulo
					AND ModuloID = @AntecedenteID
			END

		END
		ELSE
			EXEC spModuloAgregarMovPresupuesto @Modulo
											  ,@ID
											  ,@Ok OUTPUT
											  ,@OkRef OUTPUT

	END

	IF @Ok IS NULL
		OR @Ok BETWEEN 80030 AND 81000
		EXEC spMovFinal @Empresa
					   ,@Sucursal
					   ,@Modulo
					   ,@ID
					   ,@Estatus
					   ,@EstatusNuevo
					   ,@Usuario
					   ,@FechaEmision
					   ,@FechaRegistro
					   ,@Mov
					   ,@MovID
					   ,@MovTipo
					   ,@IDGenerar
					   ,@Ok OUTPUT
					   ,@OkRef OUTPUT

	IF @Accion = 'CANCELAR'
		AND @EstatusNuevo = 'CANCELADO'
		AND @Ok IS NULL
		EXEC spCancelarFlujo @Empresa
							,@Modulo
							,@ID
							,@Ok OUTPUT

	IF @AnexoID IS NOT NULL
		AND @AnexoModulo IS NOT NULL
	BEGIN
		SELECT @AnexoMov = Mov
			  ,@AnexoMovID = MovID
		FROM Mov
		WHERE Empresa = @Empresa
		AND Modulo = @AnexoModulo
		AND ID = @AnexoID
		EXEC spMovFlujo @Sucursal
					   ,@Accion
					   ,@Empresa
					   ,@AnexoModulo
					   ,@AnexoID
					   ,@AnexoMov
					   ,@AnexoMovID
					   ,@Modulo
					   ,@ID
					   ,@Mov
					   ,@MovID
					   ,@Ok OUTPUT
	END

	IF @Conexion = 0

		IF @Ok IS NULL
			OR @Ok BETWEEN 80030 AND 81000
			COMMIT TRANSACTION
		ELSE
		BEGIN
			DECLARE
				@PolizaDescuadrada TABLE (
					Cuenta VARCHAR(20) NULL
				   ,SubCuenta VARCHAR(50) NULL
				   ,Concepto VARCHAR(50) NULL
				   ,Debe MONEY NULL
				   ,Haber MONEY NULL
				   ,SucursalContable INT NULL
				)

			IF EXISTS (SELECT * FROM PolizaDescuadrada WHERE Modulo = @Modulo AND ID = @ID)
				INSERT @PolizaDescuadrada (Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable)
					SELECT Cuenta
						  ,SubCuenta
						  ,Concepto
						  ,Debe
						  ,Haber
						  ,SucursalContable
					FROM PolizaDescuadrada
					WHERE Modulo = @Modulo
					AND ID = @ID

			ROLLBACK TRANSACTION
			DELETE PolizaDescuadrada
			WHERE Modulo = @Modulo
				AND ID = @ID
			INSERT PolizaDescuadrada (Modulo, ID, Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable)
				SELECT @Modulo
					  ,@ID
					  ,Cuenta
					  ,SubCuenta
					  ,Concepto
					  ,Debe
					  ,Haber
					  ,SucursalContable
				FROM @PolizaDescuadrada
		END

	RETURN
END

