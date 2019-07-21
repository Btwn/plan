SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spEmbarqueAfectar]
 @ID INT
,@Accion CHAR(20)
,@Empresa CHAR(5)
,@Modulo CHAR(5)
,@Mov CHAR(20)
,@MovID VARCHAR(20) OUTPUT
,@MovTipo CHAR(20)
,@FechaEmision DATETIME
,@FechaAfectacion DATETIME
,@FechaConclusion DATETIME
,@Proyecto VARCHAR(50)
,@Usuario CHAR(10)
,@Autorizacion CHAR(10)
,@DocFuente INT
,@Observaciones VARCHAR(255)
,@Referencia VARCHAR(50)
,@Concepto VARCHAR(50)
,@Estatus CHAR(15)
,@EstatusNuevo CHAR(15)
,@FechaRegistro DATETIME
,@Ejercicio INT
,@Periodo INT
,@FechaSalida DATETIME
,@FechaRetorno DATETIME
,@Vehiculo CHAR(10)
,@PersonalCobrador VARCHAR(10)
,@Conexion BIT
,@SincroFinal BIT
,@Sucursal INT
,@SucursalDestino INT
,@SucursalOrigen INT
,@AntecedenteID INT
,@AntecedenteMovTipo CHAR(20)
,@CtaDinero CHAR(10)
,@CfgAfectarCobros BIT
,@CfgModificarVencimiento BIT
,@CfgEstadoTransito VARCHAR(50)
,@CfgEstadoPendiente VARCHAR(50)
,@CfgGastoTarifa BIT
,@CfgAfectarGastoTarifa BIT
,@CfgBaseProrrateo VARCHAR(20)
,@CfgDesembarquesParciales BIT
,@CfgContX BIT
,@CfgContXGenerar CHAR(20)
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
	   ,@EmbarqueMov INT
	   ,@EmbarqueMovID INT
	   ,@Estado CHAR(30)
	   ,@EstadoTipo CHAR(20)
	   ,@FechaHora DATETIME
	   ,@Importe MONEY
	   ,@Forma VARCHAR(50)
	   ,@DetalleReferencia VARCHAR(50)
	   ,@DetalleObservaciones VARCHAR(100)
	   ,@MovModulo CHAR(5)
	   ,@MovModuloID INT
	   ,@MovMov CHAR(20)
	   ,@MovMovID VARCHAR(20)
	   ,@MovMovTipo CHAR(20)
	   ,@MovEstatus CHAR(15)
	   ,@MovMoneda CHAR(10)
	   ,@MovCondicion VARCHAR(50)
	   ,@MovVencimiento DATETIME
	   ,@MovImporte MONEY
	   ,@MovImpuestos MONEY
	   ,@MovTipoCambio FLOAT
	   ,@MovPorcentaje FLOAT
	   ,@Peso FLOAT
	   ,@AplicaImporte MONEY
	   ,@Volumen FLOAT
	   ,@Paquetes INT
	   ,@Cliente CHAR(10)
	   ,@Proveedor CHAR(10)
	   ,@ClienteProveedor CHAR(10)
	   ,@ClienteEnviarA INT
	   ,@Agente CHAR(10)
	   ,@SumaPeso FLOAT
	   ,@SumaVolumen FLOAT
	   ,@SumaPaquetes INT
	   ,@SumaImportePesos MONEY
	   ,@SumaImpuestosPesos MONEY
	   ,@SumaImporteEmbarque MONEY
	   ,@FechaCancelacion DATETIME
	   ,@AntecedenteEstatus CHAR(15)
	   ,@GenerarAccion CHAR(20)
	   ,@Dias INT
	   ,@CxModulo CHAR(5)
	   ,@CxMov CHAR(20)
	   ,@CxMovID VARCHAR(20)
	   ,@CteModificarVencimiento VARCHAR(20)
	   ,@EnviarAModificarVencimiento VARCHAR(20)
	   ,@ModificarVencimiento BIT
	   ,@GastoAnexoTotalPesos MONEY
	   ,@DiaRetorno DATETIME
	   ,@TienePendientes BIT
	SELECT @Generar = 0
		  ,@GenerarAfectado = 0
		  ,@IDGenerar = NULL
		  ,@GenerarModulo = NULL
		  ,@GenerarMovID = NULL
		  ,@GenerarMovTipo = NULL
		  ,@GenerarEstatus = 'SINAFECTAR'
		  ,@TienePendientes = 0
		  ,@GastoAnexoTotalPesos = NULL

	IF @CfgDesembarquesParciales = 1
		AND @MovTipo IN ('EMB.E', 'EMB.OC')
		AND @EstatusNuevo = 'CONCLUIDO'
	BEGIN

		IF EXISTS (SELECT d.id FROM EmbarqueD d JOIN EmbarqueMov m ON d.EmbarqueMov = m.ID JOIN EmbarqueEstado e ON d.Estado = e.Estado WHERE d.ID = @ID AND UPPER(e.Tipo) = 'PENDIENTE' AND d.DesembarqueParcial = 0)
			SELECT @TienePendientes = 1
				  ,@EstatusNuevo = 'PENDIENTE'

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
						 ,@Concepto
						 ,@Accion
						 ,@Conexion
						 ,@SincroFinal
						 ,@MovID OUTPUT
						 ,@Ok OUTPUT
						 ,@OkRef OUTPUT

	IF @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR')
		AND @Accion <> 'CANCELAR'
		AND @Ok IS NULL
	BEGIN
		EXEC spMovChecarConsecutivo @Empresa
								   ,@Modulo
								   ,@Mov
								   ,@MovID
								   ,NULL
								   ,@Ejercicio
								   ,@Periodo
								   ,@Ok OUTPUT
								   ,@OkRef OUTPUT
	END

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
			SELECT @Ok = 80030

		RETURN
	END

	IF @OK IS NOT NULL
		RETURN

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
		AND @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR')

		IF (
				SELECT Sincro
				FROM Version
			)
			= 1
			EXEC sp_executesql N'UPDATE EmbarqueD SET Sucursal = @Sucursal, SincroC = 1 WHERE ID = @ID AND (Sucursal <> @Sucursal OR SincroC <> 1)'
							  ,N'@Sucursal int, @ID int'
							  ,@Sucursal
							  ,@ID

	IF @Accion <> 'CANCELAR'
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
								  ,NULL
								  ,NULL
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

	SELECT @SumaPeso = 0.0
		  ,@SumaVolumen = 0.0
		  ,@SumaPaquetes = 0.0
		  ,@SumaImportePesos = 0.0
		  ,@SumaImpuestosPesos = 0.0
		  ,@SumaImporteEmbarque = 0.0
	DECLARE
		crEmbarque
		CURSOR FOR
		SELECT NULLIF(d.EmbarqueMov, 0)
			  ,d.Estado
			  ,d.FechaHora
			  ,NULLIF(RTRIM(d.Forma), '')
			  ,ISNULL(d.Importe, 0.0)
			  ,NULLIF(RTRIM(d.Referencia), '')
			  ,NULLIF(RTRIM(d.Observaciones), '')
			  ,m.ID
			  ,m.Modulo
			  ,m.ModuloID
			  ,m.Mov
			  ,m.MovID
			  ,m.Importe
			  ,m.Impuestos
			  ,m.Moneda
			  ,m.TipoCambio
			  ,ISNULL(m.Peso, 0.0)
			  ,ISNULL(m.Volumen, 0.0)
			  ,ISNULL(d.Paquetes, 0)
			  ,NULLIF(RTRIM(m.Cliente), '')
			  ,NULLIF(RTRIM(m.Proveedor), '')
			  ,m.ClienteEnviarA
			  ,UPPER(e.Tipo)
			  ,ISNULL(d.MovPorcentaje, 0)
		FROM EmbarqueD d
		JOIN EmbarqueMov m
			ON d.EmbarqueMov = m.ID
		LEFT OUTER JOIN EmbarqueEstado e
			ON d.Estado = e.Estado
		WHERE d.ID = @ID
		AND d.DesembarqueParcial = 0
	OPEN crEmbarque
	FETCH NEXT FROM crEmbarque INTO @EmbarqueMov, @Estado, @FechaHora, @Forma, @Importe, @DetalleReferencia, @DetalleObservaciones, @EmbarqueMovID, @MovModulo, @MovModuloID, @MovMov, @MovMovID, @MovImporte, @MovImpuestos, @MovMoneda, @MovTipoCambio, @Peso, @Volumen, @Paquetes, @Cliente, @Proveedor, @ClienteEnviarA, @EstadoTipo, @MovPorcentaje

	IF @@ERROR <> 0
		SELECT @Ok = 1

	IF @@FETCH_STATUS = -1
		SELECT @Ok = 60010

	WHILE @@FETCH_STATUS <> -1
	AND @Ok IS NULL
	BEGIN

	IF @Accion = 'AFECTAR'
		AND @MovTipo = 'EMB.OC'
		AND @MovModulo = 'CXC'
		AND @EstadoTipo = 'COBRADO'

		IF @Importe < ISNULL((
				SELECT ISNULL(Saldo, 0.0) --+ ISNULL(SaldoInteresesOrdinarios, 0.0) + ISNULL(SaldoInteresesMoratorios, 0.0)
				FROM Cxc
				WHERE ID = @MovModuloID
			)
			, 0)
			SELECT @EstadoTipo = 'COBRO PARCIAL'

	IF @@FETCH_STATUS <> -2
		AND @EmbarqueMov IS NOT NULL
		AND @Ok IS NULL
	BEGIN

		IF @MovTipo IN ('EMB.E', 'EMB.OC')
		BEGIN

			IF @Accion = 'AFECTAR'
				AND @Estatus = 'SINAFECTAR'
			BEGIN

				IF @MovTipo = 'EMB.OC'
					AND @MovModulo = 'CXC'
					UPDATE Cxc
					SET PersonalCobrador = @PersonalCobrador
					WHERE ID = @MovModuloID
					AND ISNULL(PersonalCobrador, '') <> @PersonalCobrador

				UPDATE EmbarqueD
				SET Estado = @CfgEstadoTransito
				WHERE CURRENT OF crEmbarque
				UPDATE EmbarqueMov
				SET MovPorcentaje = ISNULL(MovPorcentaje, 0) + @MovPorcentaje
				WHERE ID = @EmbarqueMovID
			END

			IF @Accion = 'CANCELAR'
			BEGIN
				UPDATE EmbarqueD
				SET Estado = @CfgEstadoPendiente
				WHERE CURRENT OF crEmbarque
				UPDATE EmbarqueMov
				SET MovPorcentaje = ISNULL(MovPorcentaje, 0) - @MovPorcentaje
				WHERE ID = @EmbarqueMovID
			END

			IF @MovModulo IN ('VTAS', 'COMS')
				AND @MovTipo = 'EMB.E'
				AND ((@Accion = 'AFECTAR' AND @Estatus = 'SINAFECTAR') OR (@Accion = 'CANCELAR' AND (@Estatus = 'PENDIENTE' OR @EstadoTipo <> 'DESEMBARCAR')) OR (@EstadoTipo = 'DESEMBARCAR' AND @Accion = 'AFECTAR'))
			BEGIN

				IF @MovModulo = 'VTAS'
				BEGIN
					UPDATE VentaD
					SET CantidadEmbarcada =
					CASE
						WHEN @Accion = 'CANCELAR'
							OR @EstadoTipo = 'DESEMBARCAR' THEN ISNULL(d.CantidadEmbarcada, 0) - ISNULL(e.Cantidad, 0)
						ELSE ISNULL(d.CantidadEmbarcada, 0) + ISNULL(e.Cantidad, 0)
					END
					FROM EmbarqueDArt e, VentaD d
					WHERE e.ID = @ID
					AND e.EmbarqueMov = @EmbarqueMov
					AND e.Modulo = @MovModulo
					AND e.ModuloID = d.ID
					AND e.Renglon = d.Renglon
					AND e.RenglonSub = d.RenglonSub

					IF EXISTS (SELECT * FROM EmbarqueDArt e, VentaD d WHERE e.ID = @ID AND e.EmbarqueMov = @EmbarqueMov AND e.Modulo = @MovModulo AND e.ModuloID = d.ID AND d.CantidadEmbarcada <> d.Cantidad - ISNULL(d.CantidadCancelada, 0))
						UPDATE EmbarqueMov
						SET AsignadoID = NULL
						WHERE ID = @EmbarqueMov

				END
				ELSE

				IF @MovModulo = 'COMS'
				BEGIN
					UPDATE CompraD
					SET CantidadEmbarcada =
					CASE
						WHEN @Accion = 'CANCELAR'
							OR @EstadoTipo = 'DESEMBARCAR' THEN ISNULL(d.CantidadEmbarcada, 0) - ISNULL(e.Cantidad, 0)
						ELSE ISNULL(d.CantidadEmbarcada, 0) + ISNULL(e.Cantidad, 0)
					END
					FROM EmbarqueDArt e, CompraD d
					WHERE e.ID = @ID
					AND e.EmbarqueMov = @EmbarqueMov
					AND e.Modulo = @MovModulo
					AND e.ModuloID = d.ID
					AND e.Renglon = d.Renglon
					AND e.RenglonSub = d.RenglonSub

					IF EXISTS (SELECT * FROM EmbarqueDArt e, CompraD d WHERE e.ID = @ID AND e.EmbarqueMov = @EmbarqueMov AND e.Modulo = @MovModulo AND e.ModuloID = d.ID AND d.CantidadEmbarcada <> d.Cantidad - ISNULL(d.CantidadCancelada, 0))
						UPDATE EmbarqueMov
						SET AsignadoID = NULL
						WHERE ID = @EmbarqueMov

				END

			END

			IF (@Accion = 'AFECTAR' AND @Estatus = 'PENDIENTE')
				OR (@Accion = 'CANCELAR' AND @Estatus = 'CONCLUIDO')
			BEGIN
				SELECT @GenerarAccion = @Accion
				SELECT @MovMovTipo = NULL
					  ,@MovEstatus = NULL
					  ,@Agente = NULL
				SELECT @MovMovTipo = Clave
				FROM MovTipo
				WHERE Modulo = @MovModulo
				AND Mov = @MovMov

				IF @MovModulo = 'VTAS'
				BEGIN
					SELECT @MovEstatus = Estatus
						  ,@Agente = Agente
						  ,@MovCondicion = Condicion
						  ,@MovVencimiento = Vencimiento
					FROM Venta
					WHERE ID = @MovModuloID

					IF @EstadoTipo IN ('ENTREGADO', 'COBRADO')
						AND @FechaHora IS NOT NULL
						AND @Accion <> 'CANCELAR'
						AND @Ok IS NULL
					BEGIN
						SELECT @ModificarVencimiento = @CfgModificarVencimiento
						SELECT @CteModificarVencimiento = ISNULL(UPPER(ModificarVencimiento), '(EMPRESA)')
						FROM Cte
						WHERE Cliente = @Cliente

						IF @CteModificarVencimiento = 'SI'
							SELECT @ModificarVencimiento = 1
						ELSE

						IF @CteModificarVencimiento = 'NO'
							SELECT @ModificarVencimiento = 0

						IF NULLIF(@ClienteEnviarA, 0) IS NOT NULL
						BEGIN
							SELECT @EnviarAModificarVencimiento = RTRIM(UPPER(ModificarVencimiento))
							FROM CteEnviarA
							WHERE Cliente = @Cliente
							AND ID = @ClienteEnviarA

							IF @EnviarAModificarVencimiento = 'SI'
								SELECT @ModificarVencimiento = 1
							ELSE

							IF @EnviarAModificarVencimiento = 'NO'
								SELECT @ModificarVencimiento = 0

						END

						IF @ModificarVencimiento = 1
							EXEC spEmbarqueModificarVencimiento @FechaHora
															   ,@Empresa
															   ,@MovModuloID
															   ,@MovMov
															   ,@MovMovID
															   ,@MovCondicion
															   ,@MovVencimiento
															   ,@Ok OUTPUT

					END

				END
				ELSE

				IF @MovModulo = 'INV'
					SELECT @MovEstatus = Estatus
					FROM Inv
					WHERE ID = @MovModuloID
				ELSE

				IF @MovModulo = 'COMS'
					SELECT @MovEstatus = Estatus
					FROM Compra
					WHERE ID = @MovModuloID
				ELSE

				IF @MovModulo = 'CXC'
					SELECT @MovEstatus = Estatus
					FROM Cxc
					WHERE ID = @MovModuloID
				ELSE

				IF @MovModulo = 'DIN'
					SELECT @MovEstatus = Estatus
					FROM Dinero
					WHERE ID = @MovModuloID

				IF ((@Accion <> 'CANCELAR' AND (@EstadoTipo = 'DESEMBARCAR')) OR (@EstadoTipo = 'COBRO PARCIAL' AND @MovTipo = 'EMB.OC'))
					OR (@Accion = 'CANCELAR' AND @Estatus = 'CONCLUIDO' AND @EstadoTipo <> 'DESEMBARCAR')
				BEGIN
					UPDATE EmbarqueMov
					SET AsignadoID = NULL
					WHERE ID = @EmbarqueMov
				END

				IF @EstadoTipo = 'ENTREGADO'
				BEGIN

					IF @MovMovTipo IN ('DIN.CH', 'DIN.CHE')
						AND @MovEstatus = 'PENDIENTE'
						EXEC spDinero @MovModuloID
									 ,@MovModulo
									 ,'AFECTAR'
									 ,'TODO'
									 ,@FechaRegistro
									 ,NULL
									 ,@Usuario
									 ,1
									 ,0
									 ,@GenerarMov
									 ,@GenerarMovID
									 ,@IDGenerar
									 ,@Ok OUTPUT
									 ,@OkRef OUTPUT

				END

				IF @EstadoTipo IN ('COBRADO', 'COBRO PARCIAL', 'PAGADO')
				BEGIN
					SELECT @ClienteProveedor = NULL

					IF @EstadoTipo IN ('COBRADO', 'COBRO PARCIAL')
					BEGIN
						SELECT @ClienteProveedor = @Cliente

						IF @CfgAfectarCobros = 0
							AND @Accion <> 'CANCELAR'
							SELECT @GenerarAccion = 'GENERAR'

					END
					ELSE

					IF @EstadoTipo = 'PAGADO'
						SELECT @ClienteProveedor = @Proveedor

					IF @ClienteProveedor IS NOT NULL
					BEGIN

						IF @Importe > @MovImporte
							SELECT @AplicaImporte = ISNULL(@MovImporte, 0.0) + ISNULL(@MovImpuestos, 0.0)
						ELSE
							SELECT @AplicaImporte = @Importe

						EXEC spGenerarCx @Sucursal
										,@SucursalOrigen
										,@SucursalDestino
										,@GenerarAccion
										,NULL
										,@Empresa
										,@Modulo
										,@ID
										,@Mov
										,@MovID
										,NULL
										,@MovMoneda
										,@MovTipoCambio
										,@FechaEmision
										,NULL
										,@Proyecto
										,@Usuario
										,NULL
										,@DetalleReferencia
										,NULL
										,NULL
										,@FechaRegistro
										,@Ejercicio
										,@Periodo
										,NULL
										,NULL
										,@ClienteProveedor
										,@ClienteEnviarA
										,@Agente
										,@Estado
										,@CtaDinero
										,@Forma
										,@Importe
										,NULL
										,NULL
										,NULL
										,NULL
										,@MovMov
										,@MovMovID
										,@AplicaImporte
										,NULL
										,NULL
										,@GenerarModulo
										,@GenerarMov
										,@GenerarMovID
										,@Ok OUTPUT
										,@OkRef OUTPUT
										,@PersonalCobrador = @PersonalCobrador
					END

				END

				IF @Ok = 80030
					SELECT @Ok = NULL
						  ,@OkRef = NULL

				IF @EstadoTipo IN ('ENTREGADO', 'COBRADO')
					AND @Accion <> 'CANCELAR'
				BEGIN

					IF @MovModulo = 'VTAS'
						UPDATE Venta
						SET FechaEntrega = @FechaHora
						WHERE ID = @MovModuloID
					ELSE

					IF @MovModulo = 'COMS'
						UPDATE Compra
						SET FechaEntrega = @FechaHora
						WHERE ID = @MovModuloID
					ELSE

					IF @MovModulo = 'INV'
						UPDATE Inv
						SET FechaEntrega = @FechaHora
						WHERE ID = @MovModuloID
					ELSE

					IF @MovModulo = 'CXC'
						UPDATE Cxc
						SET FechaEntrega = @FechaHora
						WHERE ID = @MovModuloID
					ELSE

					IF @MovModulo = 'DIN'
						UPDATE Dinero
						SET FechaEntrega = @FechaHora
						WHERE ID = @MovModuloID

				END

			END
			ELSE
			BEGIN
				EXEC spMovFlujo @Sucursal
							   ,@Accion
							   ,@Empresa
							   ,@MovModulo
							   ,@MovModuloID
							   ,@MovMov
							   ,@MovMovID
							   ,@Modulo
							   ,@ID
							   ,@Mov
							   ,@MovID
							   ,@Ok OUTPUT

				IF @Accion = 'CANCELAR'
					UPDATE EmbarqueMov
					SET AsignadoID = @AntecedenteID
					WHERE ID = @EmbarqueMov

			END

		END

		IF @TienePendientes = 1
			AND @EstadoTipo NOT IN ('PENDIENTE', NULL, '')
			UPDATE EmbarqueD
			SET DesembarqueParcial = 1
			WHERE CURRENT OF crEmbarque

		SELECT @SumaPeso = @SumaPeso + @Peso
			  ,@SumaVolumen = @SumaVolumen + @Volumen
			  ,@SumaPaquetes = @SumaPaquetes + @Paquetes
			  ,@SumaImportePesos = @SumaImportePesos + (@MovImporte * @MovTipoCambio)
			  ,@SumaImpuestosPesos = @SumaImpuestosPesos + (@MovImpuestos * @MovTipoCambio)
			  ,@SumaImporteEmbarque = @SumaImporteEmbarque + (((ISNULL(@MovImporte, 0) + ISNULL(@MovImpuestos, 0)) * @MovTipoCambio)) * (@MovPorcentaje / 100)
	END

	FETCH NEXT FROM crEmbarque INTO @EmbarqueMov, @Estado, @FechaHora, @Forma, @Importe, @DetalleReferencia, @DetalleObservaciones, @EmbarqueMovID, @MovModulo, @MovModuloID, @MovMov, @MovMovID, @MovImporte, @MovImpuestos, @MovMoneda, @MovTipoCambio, @Peso, @Volumen, @Paquetes, @Cliente, @Proveedor, @ClienteEnviarA, @EstadoTipo, @MovPorcentaje

	IF @@ERROR <> 0
		SELECT @Ok = 1

	END
	CLOSE crEmbarque
	DEALLOCATE crEmbarque

	IF @CfgGastoTarifa = 1
		AND @EstatusNuevo = 'CONCLUIDO'
		AND @Accion <> 'CANCELAR'
		AND @Ok IS NULL
	BEGIN
		EXEC spGastoAnexoTarifa @Sucursal
							   ,@Empresa
							   ,@Modulo
							   ,@ID
							   ,@Mov
							   ,@MovID
							   ,@FechaEmision
							   ,@FechaRegistro
							   ,@Usuario
							   ,@CfgAfectarGastoTarifa
							   ,@Ok OUTPUT
							   ,@OkRef OUTPUT
	END

	IF (@EstatusNuevo = 'CONCLUIDO' OR @Accion = 'CANCELAR')
		AND @Ok IS NULL
	BEGIN
		EXEC spGastoAnexo @Empresa
						 ,@Modulo
						 ,@ID
						 ,@Accion
						 ,@FechaRegistro
						 ,@Usuario
						 ,@GastoAnexoTotalPesos OUTPUT
						 ,@Ok OUTPUT
						 ,@OkRef OUTPUT
		EXEC spGastoAnexoEliminar @Empresa
								 ,@Modulo
								 ,@ID
	END

	IF @Ok IS NULL
	BEGIN

		IF @TienePendientes = 1
			UPDATE Embarque
			SET Estatus = @EstatusNuevo
			   ,UltimoCambio = @FechaRegistro
			WHERE ID = @ID
		ELSE
		BEGIN

			IF @EstatusNuevo = 'CANCELADO'
				SELECT @FechaCancelacion = @FechaRegistro
			ELSE
				SELECT @FechaCancelacion = NULL

			IF @EstatusNuevo = 'CONCLUIDO'
				SELECT @FechaConclusion = @FechaRegistro
			ELSE

			IF @EstatusNuevo <> 'CANCELADO'
				SELECT @FechaConclusion = NULL

			IF @EstatusNuevo = 'CONCLUIDO'
				AND @FechaRetorno IS NULL
				SELECT @FechaRetorno = @FechaRegistro

			SELECT @DiaRetorno = @FechaRetorno
			EXEC spExtraerFecha @DiaRetorno OUTPUT

			IF @CfgContX = 1
				AND @CfgContXGenerar <> 'NO'
			BEGIN

				IF @Estatus = 'SINAFECTAR'
					AND @EstatusNuevo <> 'CANCELADO'
					SELECT @GenerarPoliza = 1
				ELSE

				IF @Estatus <> 'SINAFECTAR'
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
			UPDATE Embarque
			SET Peso = NULLIF(@SumaPeso, 0.0)
			   ,Volumen = NULLIF(@SumaVolumen, 0.0)
			   ,Paquetes = NULLIF(@SumaPaquetes, 0.0)
			   ,Importe = NULLIF(@SumaImportePesos, 0.0)
			   ,Impuestos = NULLIF(@SumaImpuestosPesos, 0.0)
			   ,ImporteEmbarque = NULLIF(@SumaImporteEmbarque, 0.0)
			   ,Gastos = NULLIF(@GastoAnexoTotalPesos, 0.0)
			   ,FechaSalida = @FechaSalida
			   ,FechaRetorno = @FechaRetorno
			   ,DiaRetorno = @DiaRetorno
			   ,FechaConclusion = @FechaConclusion
			   ,FechaCancelacion = @FechaCancelacion
			   ,UltimoCambio = @FechaRegistro
			   ,Estatus = @EstatusNuevo
			   ,Situacion =
				CASE
					WHEN @Estatus <> @EstatusNuevo THEN NULL
					ELSE Situacion
				END
			   ,GenerarPoliza = @GenerarPoliza
			WHERE ID = @ID

			IF @@ERROR <> 0
				SELECT @Ok = 1

		END

		IF @EstatusNuevo = 'CONCLUIDO'
		BEGIN
			UPDATE EmbarqueD
			SET DesembarqueParcial = 0
			WHERE ID = @ID
			AND DesembarqueParcial = 1
			UPDATE EmbarqueMov
			SET Gastos = ISNULL(Gastos, 0) + (((e.Importe + e.Impuestos) * e.TipoCambio) * @GastoAnexoTotalPesos) / (@SumaImportePesos + @SumaImpuestosPesos)
			FROM EmbarqueMov e, EmbarqueD d
			WHERE d.ID = @ID
			AND d.EmbarqueMov = e.ID
			UPDATE EmbarqueMov
			SET Concluido = 1
			WHERE AsignadoID = @ID

			IF @CfgBaseProrrateo = 'IMPORTE'
				UPDATE Venta
				SET EmbarqueGastos = ISNULL(EmbarqueGastos, 0) + (((e.Importe + e.Impuestos) * e.TipoCambio) * @GastoAnexoTotalPesos) / (@SumaImportePesos + @SumaImpuestosPesos)
				FROM EmbarqueMov e, EmbarqueD d, Venta v
				WHERE d.ID = @ID
				AND d.EmbarqueMov = e.ID
				AND e.Modulo = 'VTAS'
				AND e.ModuloID = v.ID
			ELSE

			IF @CfgBaseProrrateo = 'PAQUETES'
				UPDATE Venta
				SET EmbarqueGastos = ISNULL(EmbarqueGastos, 0) + (e.Paquetes * @GastoAnexoTotalPesos) / @SumaPaquetes
				FROM EmbarqueMov e, EmbarqueD d, Venta v
				WHERE d.ID = @ID
				AND d.EmbarqueMov = e.ID
				AND e.Modulo = 'VTAS'
				AND e.ModuloID = v.ID
			ELSE

			IF @CfgBaseProrrateo = 'PESO'
				UPDATE Venta
				SET EmbarqueGastos = ISNULL(EmbarqueGastos, 0) + (e.Peso * @GastoAnexoTotalPesos) / @SumaPeso
				FROM EmbarqueMov e, EmbarqueD d, Venta v
				WHERE d.ID = @ID
				AND d.EmbarqueMov = e.ID
				AND e.Modulo = 'VTAS'
				AND e.ModuloID = v.ID
			ELSE

			IF @CfgBaseProrrateo = 'VOLUMEN'
				UPDATE Venta
				SET EmbarqueGastos = ISNULL(EmbarqueGastos, 0) + (e.Volumen * @GastoAnexoTotalPesos) / @SumaVolumen
				FROM EmbarqueMov e, EmbarqueD d, Venta v
				WHERE d.ID = @ID
				AND d.EmbarqueMov = e.ID
				AND e.Modulo = 'VTAS'
				AND e.ModuloID = v.ID
			ELSE

			IF @CfgBaseProrrateo = 'PESO/VOLUMEN'
				UPDATE Venta
				SET EmbarqueGastos = ISNULL(EmbarqueGastos, 0) + (((ISNULL(e.Peso, 0) * ISNULL(e.Volumen, 0)) * e.TipoCambio) * @GastoAnexoTotalPesos) / (@SumaPeso * @SumaVolumen)
				FROM EmbarqueMov e, EmbarqueD d, Venta v
				WHERE d.ID = @ID
				AND d.EmbarqueMov = e.ID
				AND e.Modulo = 'VTAS'
				AND e.ModuloID = v.ID

		END

		UPDATE Vehiculo
		SET Estatus =
		CASE
			WHEN @EstatusNuevo = 'PENDIENTE' THEN 'ENTRANSITO'
			ELSE 'DISPONIBLE'
		END
		WHERE Vehiculo = @Vehiculo

		IF @@ERROR <> 0
			SELECT @Ok = 1

	END

	IF @Vehiculo IS NOT NULL
	BEGIN

		IF (
				SELECT TieneMovimientos
				FROM Vehiculo
				WHERE Vehiculo = @Vehiculo
			)
			= 0
			UPDATE Vehiculo
			SET TieneMovimientos = 1
			WHERE Vehiculo = @Vehiculo

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

	IF @Conexion = 0

		IF @Ok IS NULL
			OR @Ok BETWEEN 80030 AND 81000
			COMMIT TRANSACTION
		ELSE
			ROLLBACK TRANSACTION

	RETURN
END

