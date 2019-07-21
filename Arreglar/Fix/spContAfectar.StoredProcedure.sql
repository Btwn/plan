SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spContAfectar]
 @ID INT
,@Accion CHAR(20)
,@Empresa CHAR(5)
,@Modulo CHAR(5)
,@Mov CHAR(20)
,@MovID VARCHAR(20) OUTPUT
,@MovTipo CHAR(20)
,@MovMoneda CHAR(10)
,@MovTipoCambio FLOAT
,@FechaEmision DATETIME
,@FechaContable DATETIME
,@Concepto VARCHAR(50)
,@Proyecto VARCHAR(50)
,@Usuario CHAR(10)
,@Autorizacion CHAR(10)
,@Referencia VARCHAR(50)
,@UEN INT
,@Observaciones VARCHAR(255)
,@AfectarPresupuesto VARCHAR(30)
,@Estatus CHAR(15)
,@EstatusNuevo CHAR(15)
,@FechaRegistro DATETIME
,@Ejercicio INT
,@Periodo INT
,@ContMoneda CHAR(10)
,@ContTipoCambio FLOAT
,@CtaContabilidad CHAR(20)
,@CtaOrden CHAR(20)
,@Conexion BIT
,@SincroFinal BIT
,@Sucursal INT
,@SucursalDestino INT
,@SucursalOrigen INT
,@CfgMoneda2Auto BIT
,@CfgMultiSucursal BIT
,@CfgRegistro BIT
,@OrigenTipo CHAR(10)
,@Origen CHAR(20)
,@OrigenID VARCHAR(20)
,@GenerarID INT OUTPUT
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
,@AfectarMoneda2 BIT = 0
,@Base CHAR(20)
,@GenerarMov CHAR(20)
,@CfgConsolidacion BIT
,@OrigenEmpresa VARCHAR(5)
,@Intercompania BIT
AS
BEGIN
	DECLARE
		@Ciclo INT
	   ,@Presupuesto BIT
	   ,@PeriodoD INT
	   ,@PeriodoPresupuesto INT
	   ,@Cuenta CHAR(20)
	   ,@UltCuenta CHAR(20)
	   ,@SubCuenta VARCHAR(50)
	   ,@UltSubCuenta VARCHAR(50)
	   ,@SubCuenta2 VARCHAR(50)
	   ,@UltSubCuenta2 VARCHAR(50)
	   ,@SubCuenta3 VARCHAR(50)
	   ,@UltSubCuenta3 VARCHAR(50)
	   ,@Debe MONEY
	   ,@SumaDebe MONEY
	   ,@Haber MONEY
	   ,@Neto MONEY
	   ,@TipoPresupuesto VARCHAR(50)
	   ,@ImportePresupuesto MONEY
	   ,@ImporteReservar MONEY
	   ,@ImporteComprometer MONEY
	   ,@ImporteDevengar MONEY
	   ,@ImporteEjercer MONEY
	   ,@EsCargo BIT
	   ,@TieneMovimientos BIT
	   ,@SinAuxiliares BIT
	   ,@FechaConclusion DATETIME
	   ,@FechaCancelacion DATETIME
	   ,@SucursalPrincipal INT
	   ,@IDOrigen INT
	   ,@MonedaOrigen CHAR(10)
	   ,@SucursalContable INT
	   ,@SucursalSincro INT
	   ,@Renglon FLOAT
	   ,@RenglonSub INT
	   ,@ContX BIT
	   ,@ContXAfectar BIT
	   ,@EstatusCuenta VARCHAR(10)
	SELECT @ContX = ISNULL(ContX, 0)
		  ,@ContXAfectar = ContXAfectar
	FROM EmpresaGral
	WHERE Empresa = @Empresa
	SELECT @TipoPresupuesto = NULL
		  ,@SumaDebe = 0.0

	IF @AfectarMoneda2 = 0
	BEGIN
		SELECT @SucursalPrincipal = Sucursal
		FROM Version
		EXEC spMovConsecutivo @SucursalPrincipal
							 ,@SucursalPrincipal
							 ,@SucursalPrincipal
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
			SELECT @SucursalSincro = ISNULL(@SucursalDestino, @Sucursal)

			IF @Accion = 'SINCRO'
				EXEC spAsignarSucursalEstatus @ID
											 ,@Modulo
											 ,@SucursalSincro
											 ,@Accion

			SELECT @Ok = 80060
				  ,@OkRef = @MovID
			RETURN
		END

	END

	IF @OK IS NOT NULL
		RETURN

	IF @Conexion = 0
		BEGIN TRANSACTION

	IF @AfectarMoneda2 = 0
	BEGIN
		EXEC spMovEstatus @Modulo
						 ,'AFECTANDO'
						 ,@ID
						 ,0
						 ,NULL
						 ,0
						 ,@Ok OUTPUT

		IF @Accion = 'AFECTAR'
			AND @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR')
		BEGIN

			IF @CfgMultiSucursal = 0
			BEGIN
				UPDATE ContD
				SET SucursalContable = @Sucursal
				WHERE ID = @ID
				AND SucursalContable <> @Sucursal
				UPDATE ContReg
				SET Sucursal = @Sucursal
				WHERE ID = @ID
				AND Sucursal <> @Sucursal
			END
			ELSE
			BEGIN
				UPDATE ContD
				SET SucursalContable = @Sucursal
				WHERE ID = @ID
				AND SucursalContable IS NULL
				UPDATE ContReg
				SET Sucursal = @Sucursal
				WHERE ID = @ID
				AND Sucursal IS NULL
			END

			IF (
					SELECT Sincro
					FROM Version
				)
				= 1
				EXEC sp_executesql N'UPDATE ContD SET Sucursal = @Sucursal, SincroC = 1 WHERE ID = @ID AND (Sucursal <> @Sucursal OR SincroC <> 1)'
								  ,N'@Sucursal int, @ID int'
								  ,@Sucursal
								  ,@ID

		END

		IF @Accion NOT IN ('CANCELAR', 'DESAFECTAR')
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
									  ,@Concepto
									  ,@Proyecto
									  ,@MovMoneda
									  ,@MovTipoCambio
									  ,@Usuario
									  ,@Autorizacion
									  ,@Referencia
									  ,@UEN
									  ,@Observaciones
									  ,0
									  ,NULL
									  ,NULL
									  ,NULL
									  ,@Ok OUTPUT

	END

	IF @AfectarMoneda2 = 1
		AND @CfgMoneda2Auto = 1
		EXEC xpContMoneda2Update @ID
								,@ContMoneda
								,@ContTipoCambio
								,@Ok OUTPUT
								,@OkRef OUTPUT

	IF @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR')
		OR @Accion <> 'AFECTAR'
	BEGIN

		IF @Accion = 'AFECTAR'
		BEGIN

			IF @MovTipo = 'CONT.PR'
				UPDATE ContD
				SET Presupuesto = 1
				   ,Empresa = @Empresa
				   ,Ejercicio = ISNULL(Ejercicio, @Ejercicio)
				   ,Periodo = ISNULL(Periodo, @Periodo)
				   ,FechaContable = @FechaContable
				WHERE ID = @ID
			ELSE
				UPDATE ContD
				SET Empresa = @Empresa
				   ,Ejercicio = ISNULL(Ejercicio, @Ejercicio)
				   ,Periodo = ISNULL(Periodo, @Periodo)
				   ,FechaContable = @FechaContable
				WHERE ID = @ID

		END

		IF (@MovTipo = 'CONT.PR' OR @AfectarPresupuesto <> 'NO')
			AND @Accion = 'AFECTAR'
			EXEC spContExplotarPresupuesto @ID
										  ,@Empresa
										  ,@Sucursal
										  ,@SucursalOrigen
										  ,@SucursalContable
										  ,@UEN
										  ,@ContMoneda
										  ,@FechaContable
										  ,@Ejercicio
										  ,@TipoPresupuesto
										  ,@AfectarPresupuesto
										  ,@Ok OUTPUT
										  ,@OkRef OUTPUT

		EXEC xpContAfectarDetalleAntes @ID
									  ,@Accion
									  ,@Empresa
									  ,@Sucursal
									  ,@SucursalOrigen
									  ,@SucursalContable
									  ,@Usuario
									  ,@FechaContable
									  ,@FechaRegistro
									  ,@Ok OUTPUT
									  ,@OkRef OUTPUT
		DECLARE
			crContDetalle
			CURSOR FOR
			SELECT ISNULL(d.SucursalContable, @Sucursal)
				  ,NULLIF(RTRIM(d.Cuenta), '')
				  ,NULLIF(RTRIM(d.SubCuenta), '')
				  ,NULLIF(RTRIM(d.SubCuenta2), '')
				  ,NULLIF(RTRIM(d.SubCuenta3), '')
				  ,ISNULL(CASE
					   WHEN @AfectarMoneda2 = 1 THEN d.Debe2
					   ELSE d.Debe
				   END, 0.0)
				  ,ISNULL(CASE
					   WHEN @AfectarMoneda2 = 1 THEN d.Haber2
					   ELSE d.Haber
				   END, 0.0)
				  ,NULLIF(d.Periodo, 0)
				  ,d.Presupuesto
				  ,d.Renglon
				  ,d.RenglonSub
			FROM ContD d
			JOIN Cta
				ON Cta.Cuenta = d.Cuenta
			WHERE d.ID = @ID
		OPEN crContDetalle
		FETCH NEXT FROM crContDetalle INTO @SucursalContable, @Cuenta, @SubCuenta, @SubCuenta2, @SubCuenta3, @Debe, @Haber, @PeriodoD, @Presupuesto, @Renglon, @RenglonSub

		IF @@ERROR <> 0
			SELECT @Ok = 1

		WHILE @@FETCH_STATUS <> -1
		AND @Ok IS NULL
		BEGIN

		IF @@FETCH_STATUS <> -2
			AND @Cuenta IS NOT NULL
			AND (@Debe <> 0.0 OR @Haber <> 0.0)
			AND @Ok IS NULL
		BEGIN

			IF @SucursalContable IS NULL
				SELECT @Ok = 10200

			SELECT @Neto = @Debe - @Haber
				  ,@SumaDebe = @SumaDebe + @Debe

			IF @MovTipo = 'CONT.PR'
				OR (@Presupuesto = 1 AND @AfectarPresupuesto <> 'NO')
			BEGIN
				SELECT @ImportePresupuesto = NULL
					  ,@ImporteReservar = NULL
					  ,@ImporteEjercer = NULL
				SELECT @AfectarPresupuesto = ISNULL(NULLIF(RTRIM(@AfectarPresupuesto), ''), 'ASIGNAR')
				SELECT @PeriodoPresupuesto = @PeriodoD

				IF @AfectarPresupuesto = 'ASIGNAR'
					SELECT @ImportePresupuesto = @Neto
				ELSE

				IF @AfectarPresupuesto = 'RESERVAR'
					SELECT @ImporteReservar = @Neto
				ELSE

				IF @AfectarPresupuesto = 'COMPROMETER DIRECTO'
					SELECT @ImporteComprometer = @Neto
				ELSE

				IF @AfectarPresupuesto = 'COMPROMETER RESERVADO'
					SELECT @ImporteComprometer = @Neto
						  ,@ImporteReservar = -@Neto
				ELSE

				IF @AfectarPresupuesto = 'DEVENGAR DIRECTO'
					SELECT @ImporteDevengar = @Neto
				ELSE

				IF @AfectarPresupuesto = 'DEVENGAR RESERVADO'
					SELECT @ImporteDevengar = @Neto
						  ,@ImporteReservar = -@Neto
				ELSE

				IF @AfectarPresupuesto = 'DEVENGAR COMPROMETIDO'
					SELECT @ImporteDevengar = @Neto
						  ,@ImporteComprometer = -@Neto
				ELSE

				IF @AfectarPresupuesto = 'EJERCER DIRECTO'
					SELECT @ImporteEjercer = @Neto
				ELSE

				IF @AfectarPresupuesto = 'EJERCER RESERVADO'
					SELECT @ImporteEjercer = @Neto
						  ,@ImporteReservar = -@Neto
				ELSE

				IF @AfectarPresupuesto = 'EJERCER COMPROMETIDO'
					SELECT @ImporteEjercer = @Neto
						  ,@ImporteComprometer = -@Neto
				ELSE

				IF @AfectarPresupuesto = 'EJERCER DEVENGADO'
					SELECT @ImporteEjercer = @Neto
						  ,@ImporteDevengar = -@Neto

				IF @AfectarPresupuesto LIKE 'EJERCER%'
					AND @PeriodoPresupuesto > @Periodo
					SELECT @Ok = 50170
						  ,@OkRef = 'Importe ' + CONVERT(VARCHAR, @Neto) + ' / Periodo ' + CONVERT(VARCHAR, @PeriodoPresupuesto)

				IF @Ok IS NULL
				BEGIN
					EXEC spPresupuesto @SucursalContable
									  ,@Empresa
									  ,@ContMoneda
									  ,'CONT'
									  ,@TipoPresupuesto
									  ,@Cuenta
									  ,@SubCuenta
									  ,@SubCuenta2
									  ,@SubCuenta3
									  ,@UEN
									  ,@ImportePresupuesto
									  ,@ImporteReservar
									  ,@ImporteComprometer
									  ,@ImporteDevengar
									  ,@ImporteEjercer
									  ,@Ejercicio
									  ,@PeriodoPresupuesto
									  ,@Accion
									  ,@Ok OUTPUT
									  ,@OkRef OUTPUT
					EXEC xpOk_50160 @Origen
								   ,@OrigenTipo
								   ,@Cuenta
								   ,@Ok OUTPUT
				END

			END
			ELSE
			BEGIN
				SELECT @SinAuxiliares = 0
					  ,@Ciclo = 0
				WHILE @Cuenta IS NOT NULL
				AND @Ok IS NULL
				BEGIN
				SELECT @Ciclo = @Ciclo + 1

				IF @Ciclo > 50
					SELECT @Ok = 44200

				IF @Debe <> 0.0
				BEGIN

					IF @Accion IN ('CANCELAR', 'DESAFECTAR')
						SELECT @EsCargo = 0
					ELSE
						SELECT @EsCargo = 1

					EXEC spSaldo @SucursalContable
								,@Accion
								,@Empresa
								,@Usuario
								,'CONT'
								,@ContMoneda
								,@ContTipoCambio
								,@Cuenta
								,@SubCuenta
								,NULL
								,NULL
								,@Modulo
								,@ID
								,@Mov
								,@MovID
								,@EsCargo
								,@Debe
								,NULL
								,NULL
								,@FechaContable
								,@Ejercicio
								,@Periodo
								,@Mov
								,@MovID
								,@SinAuxiliares
								,0
								,0
								,@Ok OUTPUT
								,@OkRef OUTPUT
								,@Renglon = @Renglon
								,@RenglonSub = @RenglonSub
								,@SubCuenta2 = @SubCuenta2
								,@SubCuenta3 = @SubCuenta3
								,@Proyecto = @Proyecto
								,@UEN = @UEN
				END

				IF @Haber <> 0.0
				BEGIN

					IF @Accion IN ('CANCELAR', 'DESAFECTAR')
						SELECT @EsCargo = 1
					ELSE
						SELECT @EsCargo = 0

					EXEC spSaldo @SucursalContable
								,@Accion
								,@Empresa
								,@Usuario
								,'CONT'
								,@ContMoneda
								,@ContTipoCambio
								,@Cuenta
								,@SubCuenta
								,NULL
								,NULL
								,@Modulo
								,@ID
								,@Mov
								,@MovID
								,@EsCargo
								,@Haber
								,NULL
								,NULL
								,@FechaContable
								,@Ejercicio
								,@Periodo
								,@Mov
								,@MovID
								,@SinAuxiliares
								,0
								,0
								,@Ok OUTPUT
								,@OkRef OUTPUT
								,@Renglon = @Renglon
								,@RenglonSub = @RenglonSub
								,@SubCuenta2 = @SubCuenta2
								,@SubCuenta3 = @SubCuenta3
								,@Proyecto = @Proyecto
								,@UEN = @UEN
				END

				SELECT @UltCuenta = @Cuenta
				SELECT @Cuenta = NULLIF(RTRIM(Rama), '')
					  ,@TieneMovimientos = TieneMovimientos
					  ,@EstatusCuenta = Estatus
				FROM Cta
				WHERE Cuenta = @Cuenta

				IF @@ERROR <> 0
					SELECT @Ok = 1

				IF @EstatusCuenta IN ('BLOQUEADO', 'BAJA')
					SELECT @Ok = 50070

				IF @TieneMovimientos = 0
				BEGIN

					IF (
							SELECT TieneMovimientos
							FROM Cta
							WHERE Cuenta = @UltCuenta
						)
						= 0
						UPDATE Cta
						SET TieneMovimientos = 1
						WHERE Cuenta = @UltCuenta

				END

				SELECT @SinAuxiliares = 1

				IF UPPER(@Cuenta) IN (@CtaContabilidad, @CtaOrden)
					SELECT @Cuenta = NULL

				END
				WHILE @SubCuenta IS NOT NULL
				AND @Ok IS NULL
				BEGIN

				IF @Debe <> 0.0
				BEGIN

					IF @Accion IN ('CANCELAR', 'DESAFECTAR')
						SELECT @EsCargo = 0
					ELSE
						SELECT @EsCargo = 1

					EXEC spSaldo @SucursalContable
								,@Accion
								,@Empresa
								,@Usuario
								,'CC'
								,@ContMoneda
								,@ContTipoCambio
								,@SubCuenta
								,NULL
								,NULL
								,NULL
								,@Modulo
								,@ID
								,@Mov
								,@MovID
								,@EsCargo
								,@Debe
								,NULL
								,NULL
								,@FechaContable
								,@Ejercicio
								,@Periodo
								,@Mov
								,@MovID
								,@SinAuxiliares
								,0
								,0
								,@Ok OUTPUT
								,@OkRef OUTPUT
								,@Renglon = @Renglon
								,@RenglonSub = @RenglonSub
								,@Proyecto = @Proyecto
								,@UEN = @UEN
				END

				IF @Haber <> 0.0
				BEGIN

					IF @Accion IN ('CANCELAR', 'DESAFECTAR')
						SELECT @EsCargo = 1
					ELSE
						SELECT @EsCargo = 0

					EXEC spSaldo @SucursalContable
								,@Accion
								,@Empresa
								,@Usuario
								,'CC'
								,@ContMoneda
								,@ContTipoCambio
								,@SubCuenta
								,NULL
								,NULL
								,NULL
								,@Modulo
								,@ID
								,@Mov
								,@MovID
								,@EsCargo
								,@Haber
								,NULL
								,NULL
								,@FechaContable
								,@Ejercicio
								,@Periodo
								,@Mov
								,@MovID
								,@SinAuxiliares
								,0
								,0
								,@Ok OUTPUT
								,@OkRef OUTPUT
								,@Renglon = @Renglon
								,@RenglonSub = @RenglonSub
								,@Proyecto = @Proyecto
								,@UEN = @UEN
				END

				SELECT @UltSubCuenta = @SubCuenta
				SELECT @SubCuenta = NULLIF(RTRIM(Rama), '')
					  ,@TieneMovimientos = TieneMovimientos
				FROM CentroCostos
				WHERE CentroCostos = @SubCuenta

				IF @@ERROR <> 0
					SELECT @Ok = 1

				IF @TieneMovimientos = 0
				BEGIN

					IF (
							SELECT TieneMovimientos
							FROM CentroCostos
							WHERE CentroCostos = @UltSubCuenta
						)
						= 0
						UPDATE CentroCostos
						SET TieneMovimientos = 1
						WHERE CentroCostos = @UltSubCuenta

				END

				END
				WHILE @SubCuenta2 IS NOT NULL
				AND @Ok IS NULL
				BEGIN

				IF @Debe <> 0.0
				BEGIN

					IF @Accion IN ('CANCELAR', 'DESAFECTAR')
						SELECT @EsCargo = 0
					ELSE
						SELECT @EsCargo = 1

					EXEC spSaldo @SucursalContable
								,@Accion
								,@Empresa
								,@Usuario
								,'CC2'
								,@ContMoneda
								,@ContTipoCambio
								,@SubCuenta2
								,NULL
								,NULL
								,NULL
								,@Modulo
								,@ID
								,@Mov
								,@MovID
								,@EsCargo
								,@Debe
								,NULL
								,NULL
								,@FechaContable
								,@Ejercicio
								,@Periodo
								,@Mov
								,@MovID
								,@SinAuxiliares
								,0
								,0
								,@Ok OUTPUT
								,@OkRef OUTPUT
								,@Renglon = @Renglon
								,@RenglonSub = @RenglonSub
								,@Proyecto = @Proyecto
								,@UEN = @UEN
				END

				IF @Haber <> 0.0
				BEGIN

					IF @Accion IN ('CANCELAR', 'DESAFECTAR')
						SELECT @EsCargo = 1
					ELSE
						SELECT @EsCargo = 0

					EXEC spSaldo @SucursalContable
								,@Accion
								,@Empresa
								,@Usuario
								,'CC2'
								,@ContMoneda
								,@ContTipoCambio
								,@SubCuenta2
								,NULL
								,NULL
								,NULL
								,@Modulo
								,@ID
								,@Mov
								,@MovID
								,@EsCargo
								,@Haber
								,NULL
								,NULL
								,@FechaContable
								,@Ejercicio
								,@Periodo
								,@Mov
								,@MovID
								,@SinAuxiliares
								,0
								,0
								,@Ok OUTPUT
								,@OkRef OUTPUT
								,@Renglon = @Renglon
								,@RenglonSub = @RenglonSub
								,@Proyecto = @Proyecto
								,@UEN = @UEN
				END

				SELECT @UltSubCuenta2 = @SubCuenta2
				SELECT @SubCuenta2 = NULLIF(RTRIM(Rama), '')
					  ,@TieneMovimientos = TieneMovimientos
				FROM CentroCostos2
				WHERE CentroCostos2 = @SubCuenta2

				IF @@ERROR <> 0
					SELECT @Ok = 1

				IF @TieneMovimientos = 0
				BEGIN

					IF (
							SELECT TieneMovimientos
							FROM CentroCostos2
							WHERE CentroCostos2 = @UltSubCuenta2
						)
						= 0
						UPDATE CentroCostos2
						SET TieneMovimientos = 1
						WHERE CentroCostos2 = @UltSubCuenta2

				END

				END
				WHILE @SubCuenta3 IS NOT NULL
				AND @Ok IS NULL
				BEGIN

				IF @Debe <> 0.0
				BEGIN

					IF @Accion IN ('CANCELAR', 'DESAFECTAR')
						SELECT @EsCargo = 0
					ELSE
						SELECT @EsCargo = 1

					EXEC spSaldo @SucursalContable
								,@Accion
								,@Empresa
								,@Usuario
								,'CC3'
								,@ContMoneda
								,@ContTipoCambio
								,@SubCuenta3
								,NULL
								,NULL
								,NULL
								,@Modulo
								,@ID
								,@Mov
								,@MovID
								,@EsCargo
								,@Debe
								,NULL
								,NULL
								,@FechaContable
								,@Ejercicio
								,@Periodo
								,@Mov
								,@MovID
								,@SinAuxiliares
								,0
								,0
								,@Ok OUTPUT
								,@OkRef OUTPUT
								,@Renglon = @Renglon
								,@RenglonSub = @RenglonSub
								,@Proyecto = @Proyecto
								,@UEN = @UEN
				END

				IF @Haber <> 0.0
				BEGIN

					IF @Accion IN ('CANCELAR', 'DESAFECTAR')
						SELECT @EsCargo = 1
					ELSE
						SELECT @EsCargo = 0

					EXEC spSaldo @SucursalContable
								,@Accion
								,@Empresa
								,@Usuario
								,'CC3'
								,@ContMoneda
								,@ContTipoCambio
								,@SubCuenta3
								,NULL
								,NULL
								,NULL
								,@Modulo
								,@ID
								,@Mov
								,@MovID
								,@EsCargo
								,@Haber
								,NULL
								,NULL
								,@FechaContable
								,@Ejercicio
								,@Periodo
								,@Mov
								,@MovID
								,@SinAuxiliares
								,0
								,0
								,@Ok OUTPUT
								,@OkRef OUTPUT
								,@Renglon = @Renglon
								,@RenglonSub = @RenglonSub
								,@Proyecto = @Proyecto
								,@UEN = @UEN
				END

				SELECT @UltSubCuenta3 = @SubCuenta3
				SELECT @SubCuenta3 = NULLIF(RTRIM(Rama), '')
					  ,@TieneMovimientos = TieneMovimientos
				FROM CentroCostos3
				WHERE CentroCostos3 = @SubCuenta3

				IF @@ERROR <> 0
					SELECT @Ok = 1

				IF @TieneMovimientos = 0
				BEGIN

					IF (
							SELECT TieneMovimientos
							FROM CentroCostos3
							WHERE CentroCostos3 = @UltSubCuenta3
						)
						= 0
						UPDATE CentroCostos3
						SET TieneMovimientos = 1
						WHERE CentroCostos3 = @UltSubCuenta3

				END

				END
			END

		END

		IF @Ok IS NOT NULL
			AND @OkRef IS NULL
		BEGIN
			SELECT @OkRef = 'Cuenta: ' + @Cuenta

			IF @SubCuenta IS NOT NULL
				SELECT @OkRef = @OkRef + ' (' + @SubCuenta + ')'

		END

		FETCH NEXT FROM crContDetalle INTO @SucursalContable, @Cuenta, @SubCuenta, @SubCuenta2, @SubCuenta3, @Debe, @Haber, @PeriodoD, @Presupuesto, @Renglon, @RenglonSub

		IF @@ERROR <> 0
			SELECT @Ok = 1

		END
		CLOSE crContDetalle
		DEALLOCATE crContDetalle
	END

	IF @CfgRegistro = 1
	BEGIN

		IF @Accion = 'DESAFECTAR'
		BEGIN
			DELETE ContReg
			WHERE ID = @ID
			UPDATE Cont
			SET OrigenTipo = NULL
			WHERE ID = @ID
		END
		ELSE

		IF @Accion = 'CANCELAR'
			EXEC spContRegCancelar @ID
								  ,@Ok OUTPUT
								  ,@OkRef OUTPUT
		ELSE
		BEGIN

			IF @EstatusNuevo = 'CONCLUIDO'
				AND @MovTipo IN ('CONT.P', 'CONT.C')
			BEGIN

				IF @OrigenTipo IS NULL
				BEGIN
					EXEC spMovReg @Modulo
								 ,@ID

					IF NOT EXISTS (SELECT * FROM ContReg WHERE ID = @ID)
						INSERT ContReg (ID, Empresa, Sucursal, Modulo, ModuloID, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Debe, Haber)
							SELECT @ID
								  ,@Empresa
								  ,SucursalContable
								  ,@Modulo
								  ,@ID
								  ,Cuenta
								  ,SubCuenta
								  ,SubCuenta2
								  ,SubCuenta3
								  ,Concepto
								  ,ContactoEspecifico
								  ,Debe
								  ,Haber
							FROM ContD
							WHERE ID = @ID

				END
				ELSE
					EXEC spContMovReg @ID
									 ,@Ok OUTPUT
									 ,@OkRef OUTPUT

			END

		END

	END

	IF @AfectarMoneda2 = 0
	BEGIN

		IF @Ok IS NULL
		BEGIN

			IF @EstatusNuevo = 'CANCELADO'
				SELECT @FechaCancelacion = @FechaRegistro
			ELSE
				SELECT @FechaCancelacion = NULL

			IF @EstatusNuevo = 'CONCLUIDO'
				SELECT @FechaConclusion = @FechaEmision
			ELSE

			IF @EstatusNuevo <> 'CANCELADO'
				SELECT @FechaConclusion = NULL

			EXEC spValidarTareas @Empresa
								,@Modulo
								,@ID
								,@EstatusNuevo
								,@Ok OUTPUT
								,@OkRef OUTPUT
			UPDATE Cont
			SET FechaConclusion = @FechaConclusion
			   ,FechaCancelacion = @FechaCancelacion
			   ,FechaContable = @FechaContable
			   ,FechaEmision = @FechaEmision
			   ,UltimoCambio = @FechaRegistro
			   ,Ejercicio = @Ejercicio
			   ,Periodo = @Periodo
			   ,Estatus = @EstatusNuevo
			   ,Situacion =
				CASE
					WHEN @Estatus <> @EstatusNuevo THEN NULL
					ELSE Situacion
				END
			   ,Concepto = @Concepto
			   ,Importe = @SumaDebe
			WHERE ID = @ID

			IF @@ERROR <> 0
				SELECT @Ok = 1

		END

		SELECT @IDOrigen = NULL

		IF @Ok IS NULL
			EXEC spLigarMovCont @Accion
							   ,@Empresa
							   ,@OrigenTipo
							   ,@Origen
							   ,@OrigenID
							   ,@ID
							   ,@Mov
							   ,@MovID
							   ,@IDOrigen OUTPUT

		IF @OrigenTipo IS NOT NULL
			AND @Ok IS NULL
		BEGIN

			IF @IDOrigen IS NULL
				EXEC spMovEnMaxID @OrigenTipo
								 ,@Empresa
								 ,@Origen
								 ,@OrigenID
								 ,@IDOrigen OUTPUT
								 ,@Ok

			IF @IDOrigen IS NOT NULL
				EXEC spMovFlujo @Sucursal
							   ,@Accion
							   ,@Empresa
							   ,@OrigenTipo
							   ,@IDOrigen
							   ,@Origen
							   ,@OrigenID
							   ,'CONT'
							   ,@ID
							   ,@Mov
							   ,@MovID
							   ,@Ok OUTPUT

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
						   ,NULL
						   ,@Ok OUTPUT
						   ,@OkRef OUTPUT

		IF @Accion = 'CANCELAR'
			AND @EstatusNuevo = 'CANCELADO'
			AND @Ok IS NULL
			EXEC spCancelarFlujo @Empresa
								,@Modulo
								,@ID
								,@Ok OUTPUT

	END

	IF @CfgConsolidacion = 1
		AND @OrigenEmpresa IS NULL
		AND @Accion IN ('AFECTAR', 'CANCELAR', 'DESAFECTAR')
		AND @Ok IS NULL
	BEGIN
		SELECT @Referencia = RTRIM(@Mov) + ' ' + RTRIM(@MovID) + ' (' + RTRIM(@Empresa) + ')'
		EXEC spContConsolidar @Empresa
							 ,@Referencia
							 ,@Empresa
							 ,@ID
							 ,@Modulo
							 ,@Accion
							 ,@Base
							 ,@FechaRegistro
							 ,@GenerarMov
							 ,@Usuario
							 ,1
							 ,@SincroFinal
							 ,@Mov
							 ,@MovID
							 ,@Ejercicio
							 ,@Periodo
							 ,@Intercompania
							 ,@Ok OUTPUT
							 ,@OkRef OUTPUT
	END

	IF @Conexion = 0

		IF @Ok IS NULL
			OR @Ok = 80030
			COMMIT TRANSACTION
		ELSE
			ROLLBACK TRANSACTION

	IF @Conexion = 1
		AND @ContX = 1
		AND @ContXAfectar = 1
		EXEC spOk_RAISERROR @Ok
						   ,@OkRef

	RETURN
END
GO