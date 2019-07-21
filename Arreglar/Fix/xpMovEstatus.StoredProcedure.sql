SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[xpMovEstatus]
 @Empresa CHAR(5)
,@Sucursal INT
,@Modulo CHAR(5)
,@ID INT
,@Estatus CHAR(15)
,@EstatusNuevo CHAR(15)
,@Usuario CHAR(10)
,@FechaEmision DATETIME
,@FechaRegistro DATETIME
,@Mov CHAR(20)
,@MovID VARCHAR(20)
,@MovTipo CHAR(20)
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
AS
BEGIN
	DECLARE
		@Accion VARCHAR(20)
	   ,@Moneda VARCHAR(10)
	   ,@TipoCambio FLOAT
	   ,@UEN INT
	   ,@Puntos MONEY
	   ,@PuntosVta MONEY
	   ,@SaldoPuntos MONEY
	   ,@DiferenciaPuntos MONEY
	   ,@Rama VARCHAR(5)
	   ,@Cuenta VARCHAR(50)
	   ,@SubCuenta VARCHAR(50)
	   ,@Grupo VARCHAR(10)
	   ,@CTE VARCHAR(10)
	   ,@EjercicioAfectacion INT
	   ,@PeriodoAfectacion INT
	   ,@AcumulaSinDetalles BIT
	   ,@AcumulaEnLinea BIT
	   ,@GeneraAuxiliar BIT
	   ,@GeneraSaldo BIT
	   ,@Conciliar BIT
	   ,@EsResultados BIT
	   ,@PasaPuntosGen INT
	   ,@Renglon FLOAT
	   ,@RenglonSub INT
	   ,@RenglonID INT
	   ,@ImpFac MONEY
	   ,@ImpDev MONEY
	   ,@PtosREdime MONEY

	IF @Modulo = 'VTAS'
		AND @MovTipo IN ('VTAS.F', 'VTAS.D')
	BEGIN
		SELECT @Rama = 'MONEL'
			  ,@SubCuenta = ''
			  ,@Grupo = 'ME'
			  ,@AcumulaSinDetalles = 1
			  ,@AcumulaEnLinea = 1
			  ,@GeneraAuxiliar = 1
			  ,@GeneraSaldo = 1
			  ,@Conciliar = 0
			  ,@EsResultados = 0

		IF @MovTipo IN ('VTAS.F')
		BEGIN

			IF @EstatusNuevo = 'CONCLUIDO'
			BEGIN
				SELECT @Accion = 'AFECTAR'

				IF EXISTS (SELECT * FROM TarjetaSerieMovMAVI WHERE Modulo = @Modulo AND ID = @ID)
				BEGIN
					SELECT @Moneda = V.Moneda
						  ,@TipoCambio = V.TipoCambio
						  ,@UEN = V.Uen
						  ,@EjercicioAfectacion = V.Ejercicio
						  ,@PeriodoAfectacion = V.Periodo
						  ,@Cuenta = NULLIF(T.Serie, '')
						  ,@Puntos = ISNULL(T.Importe, 0.0)
					FROM Venta V
					JOIN VentaD D
						ON V.ID = D.ID
					JOIN TarjetaSerieMovMAVI T
						ON V.ID = T.ID
					WHERE V.ID = @ID

					IF @Cuenta IS NOT NULL
						AND ISNULL(@Puntos, 0.0) > 0.0
					BEGIN

						IF EXISTS (SELECT * FROM TarjetaMonederoMAVI T WHERE T.Serie = @Cuenta AND T.Estatus IN ('ACTIVA'))
						BEGIN
							SELECT @SaldoPuntos = SUM(ISNULL(Saldo, 0.0))
							FROM SaldoP
							WHERE Empresa = @Empresa
							AND Rama = @Rama
							AND Moneda = @Moneda
							AND Grupo = @Grupo
							AND Cuenta = @Cuenta
							AND UEN = ISNULL(NULLIF(@UEN, ''), '0')

							IF @SaldoPuntos >= @Puntos
							BEGIN
								EXEC spSaldoP @Sucursal
											 ,@Accion
											 ,@Empresa
											 ,@Rama
											 ,@Moneda
											 ,@TipoCambio
											 ,@Cuenta
											 ,@SubCuenta
											 ,@Grupo
											 ,@Modulo
											 ,@ID
											 ,@Mov
											 ,@MovID
											 ,NULL
											 ,@Puntos
											 ,@FechaEmision
											 ,@EjercicioAfectacion
											 ,@PeriodoAfectacion
											 ,@AcumulaSinDetalles
											 ,@AcumulaEnLinea
											 ,@GeneraAuxiliar
											 ,@GeneraSaldo
											 ,@Conciliar
											 ,@Mov
											 ,@MovID
											 ,@EsResultados
											 ,@Ok OUTPUT
											 ,@OkRef OUTPUT
											 ,@Renglon = @Renglon
											 ,@RenglonSub = @RenglonSub
											 ,@RenglonID = @RenglonID
											 ,@UEN = @UEN

								IF @OK IS NULL
									EXEC xpGenerarNCMonedero @Empresa
															,@Sucursal
															,@Usuario
															,@ID
															,@Mov
															,@MovID
															,@FechaEmision
															,@FechaRegistro
															,@Puntos
															,@Accion
															,@Cuenta
															,1
															,@Ok OUTPUT
															,@OkRef OUTPUT

								IF @OK IS NULL
									EXEC xpMonederoGenerarEstadistica @Empresa
																	 ,@Sucursal
																	 ,@Modulo
																	 ,@ID
																	 ,@MovTipo
																	 ,@Mov
																	 ,@MovID
																	 ,@Accion
																	 ,@Puntos
																	 ,@Cuenta
																	 ,0
																	 ,@Ok OUTPUT
																	 ,@OkRef OUTPUT

							END
							ELSE
							BEGIN
								EXEC spSaldoP @Sucursal
											 ,@Accion
											 ,@Empresa
											 ,@Rama
											 ,@Moneda
											 ,@TipoCambio
											 ,@Cuenta
											 ,@SubCuenta
											 ,@Grupo
											 ,@Modulo
											 ,@ID
											 ,@Mov
											 ,@MovID
											 ,NULL
											 ,@SaldoPuntos
											 ,@FechaEmision
											 ,@EjercicioAfectacion
											 ,@PeriodoAfectacion
											 ,@AcumulaSinDetalles
											 ,@AcumulaEnLinea
											 ,@GeneraAuxiliar
											 ,@GeneraSaldo
											 ,@Conciliar
											 ,@Mov
											 ,@MovID
											 ,@EsResultados
											 ,@Ok OUTPUT
											 ,@OkRef OUTPUT
											 ,@Renglon = @Renglon
											 ,@RenglonSub = @RenglonSub
											 ,@RenglonID = @RenglonID
											 ,@UEN = @UEN

								IF @OK IS NULL
									EXEC xpGenerarNCMonedero @Empresa
															,@Sucursal
															,@Usuario
															,@ID
															,@Mov
															,@MovID
															,@FechaEmision
															,@FechaRegistro
															,@SaldoPuntos
															,@Accion
															,@Cuenta
															,1
															,@Ok OUTPUT
															,@OkRef OUTPUT

								IF @OK IS NULL
									EXEC xpMonederoGenerarEstadistica @Empresa
																	 ,@Sucursal
																	 ,@Modulo
																	 ,@ID
																	 ,@MovTipo
																	 ,@Mov
																	 ,@MovID
																	 ,@Accion
																	 ,@SaldoPuntos
																	 ,@Cuenta
																	 ,0
																	 ,@Ok OUTPUT
																	 ,@OkRef OUTPUT

								IF @Ok IS NULL
									UPDATE TarjetaSerieMovMAVI
									SET Importe = @SaldoPuntos
									WHERE Empresa = @Empresa
									AND Modulo = @Modulo
									AND ID = @ID
									AND Serie = @Cuenta

							END

						END
						ELSE
							SELECT @OK = 99005
								  ,@OKRef = @Cuenta

					END

				END

				IF EXISTS (SELECT * FROM PoliticasMonederoAplicadasMavi WHERE Modulo = @Modulo AND ID = @ID)
				BEGIN
					SELECT @Moneda = V.Moneda
						  ,@TipoCambio = V.TipoCambio
						  ,@UEN = V.Uen
						  ,@EjercicioAfectacion = V.Ejercicio
						  ,@PeriodoAfectacion = V.Periodo
						  ,@Cuenta =
						   CASE
							   WHEN vc.Categoria = 'ASOCIADOS' THEN NULLIF(C.SerieMonedero, '')
							   ELSE NULLIF(T.Serie, '')
						   END
						  ,@Puntos = SUM(ISNULL(D.Puntos, 0.0))
						  ,@CTE = V.Cliente
					FROM Venta V
					JOIN VentaD D
						ON V.ID = D.ID
					JOIN TarjetaSerieMovMAVI T
						ON V.ID = T.ID
					JOIN VentasCanalMAVI VC
						ON VC.ID = V.EnviarA
					LEFT JOIN CTE C
						ON V.Cliente = c.Cliente
					WHERE V.ID = @ID
					GROUP BY V.Moneda
							,V.TipoCambio
							,V.Uen
							,V.Ejercicio
							,V.Periodo
							,T.Serie
							,c.SerieMonedero
							,vc.Categoria
							,v.cliente
					SELECT @pasaPuntosGen = 1

					IF EXISTS (SELECT Id FROM CxC JOIN CONDICION CO ON cxc.condicion = co.condicion WHERE MOV = @Mov AND MOVID = @MovId AND dbo.fnClaveAfectacionMavi(Mov, 'VTAS') = 'VTAS.F' AND co.tipocondicion = 'CONTADO' AND co.grupo = 'MENUDEO' AND Estatus <> 'CONCLUIDO' AND ISNULL(Saldo, 0) > 0)
						SELECT @pasaPuntosGen = 0

					IF @Cuenta IS NOT NULL
						AND ISNULL(@Puntos, 0.0) > 0.0
					BEGIN

						IF EXISTS (SELECT * FROM TarjetaMonederoMAVI T WHERE T.Serie = @Cuenta AND T.Estatus IN ('ACTIVA'))
						BEGIN

							IF @pasaPuntosGen = 1
							BEGIN
								EXEC spSaldoP @Sucursal
											 ,@Accion
											 ,@Empresa
											 ,@Rama
											 ,@Moneda
											 ,@TipoCambio
											 ,@Cuenta
											 ,@SubCuenta
											 ,@Grupo
											 ,@Modulo
											 ,@ID
											 ,@Mov
											 ,@MovID
											 ,@Puntos
											 ,NULL
											 ,@FechaEmision
											 ,@EjercicioAfectacion
											 ,@PeriodoAfectacion
											 ,@AcumulaSinDetalles
											 ,@AcumulaEnLinea
											 ,@GeneraAuxiliar
											 ,@GeneraSaldo
											 ,@Conciliar
											 ,@Mov
											 ,@MovID
											 ,@EsResultados
											 ,@Ok OUTPUT
											 ,@OkRef OUTPUT
											 ,@Renglon = @Renglon
											 ,@RenglonSub = @RenglonSub
											 ,@RenglonID = @RenglonID
											 ,@UEN = @UEN

								IF @OK IS NULL
									EXEC xpMonederoGenerarEstadistica @Empresa
																	 ,@Sucursal
																	 ,@Modulo
																	 ,@ID
																	 ,@MovTipo
																	 ,@Mov
																	 ,@MovID
																	 ,@Accion
																	 ,@Puntos
																	 ,@Cuenta
																	 ,1
																	 ,@Ok OUTPUT
																	 ,@OkRef OUTPUT

								IF @OK IS NULL
									EXEC spMAVISaldaNCargoMonedero @Cte
																  ,@Cuenta
																  ,@UEN
																  ,@Sucursal

							END
							ELSE
								UPDATE PoliticasMonederoAplicadasMavi
								SET cveEstatus = 'P'
								WHERE Modulo = 'VTAS'
								AND ID = @ID
								AND cveEstatus IS NULL

						END
						ELSE
							SELECT @OK = 99005
								  ,@OKRef = @Cuenta

					END

				END

			END

			IF @EstatusNuevo = 'CANCELADO'
			BEGIN
				SELECT @Accion = 'CANCELAR'

				IF EXISTS (SELECT * FROM TarjetaSerieMovMAVI WHERE Modulo = @Modulo AND ID = @ID)
				BEGIN
					SELECT @Moneda = V.Moneda
						  ,@TipoCambio = V.TipoCambio
						  ,@UEN = V.Uen
						  ,@EjercicioAfectacion = V.Ejercicio
						  ,@PeriodoAfectacion = V.Periodo
						  ,@Cuenta = NULLIF(T.Serie, '')
						  ,@Puntos = ISNULL(T.Importe, 0.0)
					FROM Venta V
					JOIN VentaD D
						ON V.ID = D.ID
					JOIN TarjetaSerieMovMAVI T
						ON V.ID = T.ID
					WHERE V.ID = @ID

					IF @Cuenta IS NOT NULL
						AND ISNULL(@Puntos, 0.0) > 0.0
					BEGIN

						IF EXISTS (SELECT * FROM TarjetaMonederoMAVI T WHERE T.Serie = @Cuenta AND T.Estatus IN ('ACTIVA'))
						BEGIN
							SELECT @SaldoPuntos = SUM(ISNULL(Saldo, 0.0))
							FROM SaldoP
							WHERE Empresa = @Empresa
							AND Rama = @Rama
							AND Moneda = @Moneda
							AND Grupo = @Grupo
							AND Cuenta = @Cuenta
							AND UEN = ISNULL(NULLIF(@UEN, ''), '0')
							EXEC spSaldoP @Sucursal
										 ,@Accion
										 ,@Empresa
										 ,@Rama
										 ,@Moneda
										 ,@TipoCambio
										 ,@Cuenta
										 ,@SubCuenta
										 ,@Grupo
										 ,@Modulo
										 ,@ID
										 ,@Mov
										 ,@MovID
										 ,@Puntos
										 ,NULL
										 ,@FechaEmision
										 ,@EjercicioAfectacion
										 ,@PeriodoAfectacion
										 ,@AcumulaSinDetalles
										 ,@AcumulaEnLinea
										 ,@GeneraAuxiliar
										 ,@GeneraSaldo
										 ,@Conciliar
										 ,@Mov
										 ,@MovID
										 ,@EsResultados
										 ,@Ok OUTPUT
										 ,@OkRef OUTPUT
										 ,@Renglon = @Renglon
										 ,@RenglonSub = @RenglonSub
										 ,@RenglonID = @RenglonID
										 ,@UEN = @UEN
						END

					END

				END

				IF EXISTS (SELECT * FROM PoliticasMonederoAplicadasMavi WHERE Modulo = @Modulo AND ID = @ID AND ISNULL(cveEstatus, '') <> 'P')
				BEGIN
					SELECT @Moneda = V.Moneda
						  ,@TipoCambio = V.TipoCambio
						  ,@UEN = V.Uen
						  ,@EjercicioAfectacion = V.Ejercicio
						  ,@PeriodoAfectacion = V.Periodo
						  ,@Cuenta =
						   CASE
							   WHEN vc.Categoria = 'ASOCIADOS' THEN NULLIF(C.SerieMonedero, '')
							   ELSE NULLIF(T.Serie, '')
						   END
						  ,@Puntos = SUM(ISNULL(D.Puntos, 0.0))
					FROM Venta V
					JOIN VentaD D
						ON V.ID = D.ID
					JOIN TarjetaSerieMovMAVI T
						ON V.ID = T.ID
					JOIN VentasCanalMAVI VC
						ON VC.ID = V.EnviarA
					LEFT JOIN CTE C
						ON V.Cliente = c.Cliente
					WHERE V.ID = @ID
					GROUP BY V.Moneda
							,V.TipoCambio
							,V.Uen
							,V.Ejercicio
							,V.Periodo
							,T.Serie
							,c.SerieMonedero
							,vc.Categoria

					IF @Cuenta IS NOT NULL
						AND ISNULL(@Puntos, 0.0) > 0.0
					BEGIN

						IF EXISTS (SELECT * FROM TarjetaMonederoMAVI T WHERE T.Serie = @Cuenta AND T.Estatus IN ('ACTIVA'))
						BEGIN
							SELECT @SaldoPuntos = SUM(ISNULL(Saldo, 0.0))
							FROM SaldoP
							WHERE Empresa = @Empresa
							AND Rama = @Rama
							AND Moneda = @Moneda
							AND Grupo = @Grupo
							AND Cuenta = @Cuenta
							AND UEN = ISNULL(NULLIF(@UEN, ''), '0')

							IF @SaldoPuntos >= @Puntos
							BEGIN
								EXEC spSaldoP @Sucursal
											 ,@Accion
											 ,@Empresa
											 ,@Rama
											 ,@Moneda
											 ,@TipoCambio
											 ,@Cuenta
											 ,@SubCuenta
											 ,@Grupo
											 ,@Modulo
											 ,@ID
											 ,@Mov
											 ,@MovID
											 ,NULL
											 ,@Puntos
											 ,@FechaEmision
											 ,@EjercicioAfectacion
											 ,@PeriodoAfectacion
											 ,@AcumulaSinDetalles
											 ,@AcumulaEnLinea
											 ,@GeneraAuxiliar
											 ,@GeneraSaldo
											 ,@Conciliar
											 ,@Mov
											 ,@MovID
											 ,@EsResultados
											 ,@Ok OUTPUT
											 ,@OkRef OUTPUT
											 ,@Renglon = @Renglon
											 ,@RenglonSub = @RenglonSub
											 ,@RenglonID = @RenglonID
											 ,@UEN = @UEN
							END
							ELSE
							BEGIN
								SELECT @DiferenciaPuntos = @Puntos - @SaldoPuntos
								EXEC spSaldoP @Sucursal
											 ,@Accion
											 ,@Empresa
											 ,@Rama
											 ,@Moneda
											 ,@TipoCambio
											 ,@Cuenta
											 ,@SubCuenta
											 ,@Grupo
											 ,@Modulo
											 ,@ID
											 ,@Mov
											 ,@MovID
											 ,NULL
											 ,@SaldoPuntos
											 ,@FechaEmision
											 ,@EjercicioAfectacion
											 ,@PeriodoAfectacion
											 ,@AcumulaSinDetalles
											 ,@AcumulaEnLinea
											 ,@GeneraAuxiliar
											 ,@GeneraSaldo
											 ,@Conciliar
											 ,@Mov
											 ,@MovID
											 ,@EsResultados
											 ,@Ok OUTPUT
											 ,@OkRef OUTPUT
											 ,@Renglon = @Renglon
											 ,@RenglonSub = @RenglonSub
											 ,@RenglonID = @RenglonID
											 ,@UEN = @UEN

								IF @OK IS NULL
									EXEC xpGenerarNCMonedero @Empresa
															,@Sucursal
															,@Usuario
															,@ID
															,@Mov
															,@MovID
															,@FechaEmision
															,@FechaRegistro
															,@DiferenciaPuntos
															,'AFECTAR'
															,@Cuenta
															,0
															,@Ok OUTPUT
															,@OkRef OUTPUT

							END

						END
						ELSE
						BEGIN

							IF @OK IS NULL
								EXEC xpGenerarNCMonedero @Empresa
														,@Sucursal
														,@Usuario
														,@ID
														,@Mov
														,@MovID
														,@FechaEmision
														,@FechaRegistro
														,@Puntos
														,'AFECTAR'
														,@Cuenta
														,0
														,@Ok OUTPUT
														,@OkRef OUTPUT

						END

					END

				END

			END

		END

		IF @MovTipo IN ('VTAS.D')
		BEGIN

			IF @EstatusNuevo = 'CONCLUIDO'
			BEGIN
				SELECT @Accion = 'AFECTAR'

				IF EXISTS (SELECT * FROM TarjetaSerieMovMAVI WHERE Modulo = @Modulo AND ID = @ID)
				BEGIN
					SELECT @Moneda = V.Moneda
						  ,@TipoCambio = V.TipoCambio
						  ,@UEN = V.Uen
						  ,@EjercicioAfectacion = V.Ejercicio
						  ,@PeriodoAfectacion = V.Periodo
						  ,@Cuenta = NULLIF(T.Serie, '')
						  ,@ImpFac = vf.importe + vf.impuestos
						  ,@ImpDev = v.importe + v.impuestos
						  ,@PtosREdime = ISNULL(T.Importe, 0.0)
						  ,@Puntos = ROUND(@PtosRedime / CAST(@ImpFac AS DECIMAL(18, 9)) * (@ImpDev), 2)
					FROM Venta V
					JOIN VentaD D
						ON V.ID = D.ID
					JOIN Venta vf
						ON Vf.ID = D.IDCopiaMAVI
					JOIN TarjetaSerieMovMAVI T
						ON V.ID = T.ID
					WHERE V.ID = @ID

					IF @PtosREdime <> @Puntos
						UPDATE TarjetaSerieMovMAVI
						SET Importe = @Puntos
						WHERE Empresa = @Empresa
						AND Modulo = @Modulo
						AND ID = @ID
						AND Serie = @Cuenta

					IF @Cuenta IS NOT NULL
						AND ISNULL(@Puntos, 0.0) > 0.0
					BEGIN

						IF EXISTS (SELECT * FROM TarjetaMonederoMAVI T WHERE T.Serie = @Cuenta AND T.Estatus IN ('ACTIVA'))
						BEGIN
							EXEC spSaldoP @Sucursal
										 ,@Accion
										 ,@Empresa
										 ,@Rama
										 ,@Moneda
										 ,@TipoCambio
										 ,@Cuenta
										 ,@SubCuenta
										 ,@Grupo
										 ,@Modulo
										 ,@ID
										 ,@Mov
										 ,@MovID
										 ,@Puntos
										 ,NULL
										 ,@FechaEmision
										 ,@EjercicioAfectacion
										 ,@PeriodoAfectacion
										 ,@AcumulaSinDetalles
										 ,@AcumulaEnLinea
										 ,@GeneraAuxiliar
										 ,@GeneraSaldo
										 ,@Conciliar
										 ,@Mov
										 ,@MovID
										 ,@EsResultados
										 ,@Ok OUTPUT
										 ,@OkRef OUTPUT
										 ,@Renglon = @Renglon
										 ,@RenglonSub = @RenglonSub
										 ,@RenglonID = @RenglonID
										 ,@UEN = @UEN

							IF @OK IS NULL
								EXEC xpMonederoGenerarEstadistica @Empresa
																 ,@Sucursal
																 ,@Modulo
																 ,@ID
																 ,@MovTipo
																 ,@Mov
																 ,@MovID
																 ,@Accion
																 ,@Puntos
																 ,@Cuenta
																 ,0
																 ,@Ok OUTPUT
																 ,@OkRef OUTPUT

							IF @OK IS NULL
								AND ISNULL(@Puntos, 0.0) > 0.0
							BEGIN
								EXEC xpGenerarNCMonedero @Empresa
														,@Sucursal
														,@Usuario
														,@ID
														,@Mov
														,@MovID
														,@FechaEmision
														,@FechaRegistro
														,@Puntos
														,@Accion
														,@Cuenta
														,0
														,@Ok OUTPUT
														,@OkRef OUTPUT

								IF @Ok IS NULL
									EXEC xpAplicarNotaCargoDevolucionMonedero @Empresa
																			 ,@Sucursal
																			 ,@Usuario
																			 ,@ID
																			 ,@Mov
																			 ,@MovID
																			 ,@FechaEmision
																			 ,@FechaRegistro
																			 ,@Puntos
																			 ,@Accion
																			 ,@Cuenta
																			 ,@Ok OUTPUT
																			 ,@OkRef OUTPUT

							END

						END

					END

				END

				IF EXISTS (SELECT * FROM PoliticasMonederoAplicadasMavi WHERE Modulo = @Modulo AND ID = @ID AND ISNULL(cveEstatus, '') <> 'P')
				BEGIN
					SELECT @Moneda = V.Moneda
						  ,@TipoCambio = V.TipoCambio
						  ,@UEN = V.Uen
						  ,@EjercicioAfectacion = V.Ejercicio
						  ,@PeriodoAfectacion = V.Periodo
						  ,@Cuenta =
						   CASE
							   WHEN vc.Categoria = 'ASOCIADOS' THEN NULLIF(C.SerieMonedero, '')
							   ELSE NULLIF(T.Serie, '')
						   END
						  ,@Puntos = SUM(ISNULL(D.Puntos, 0.0))
					FROM Venta V
					JOIN VentaD D
						ON V.ID = D.ID
					JOIN TarjetaSerieMovMAVI T
						ON V.ID = T.ID
					JOIN VentasCanalMAVI VC
						ON VC.ID = V.EnviarA
					LEFT JOIN CTE C
						ON V.Cliente = c.Cliente
					WHERE V.ID = @ID
					GROUP BY V.Moneda
							,V.TipoCambio
							,V.Uen
							,V.Ejercicio
							,V.Periodo
							,T.Serie
							,C.SerieMonedero
							,vc.Categoria

					IF @Cuenta IS NOT NULL
						AND ISNULL(@Puntos, 0.0) > 0.0
					BEGIN

						IF EXISTS (SELECT * FROM TarjetaMonederoMAVI T WHERE T.Serie = @Cuenta AND T.Estatus IN ('ACTIVA'))
						BEGIN
							SELECT @SaldoPuntos = SUM(ISNULL(Saldo, 0.0))
							FROM SaldoP
							WHERE Empresa = @Empresa
							AND Rama = @Rama
							AND Moneda = @Moneda
							AND Grupo = @Grupo
							AND Cuenta = @Cuenta
							AND UEN = ISNULL(NULLIF(@UEN, ''), '0')

							IF @SaldoPuntos >= @Puntos
							BEGIN
								EXEC spSaldoP @Sucursal
											 ,@Accion
											 ,@Empresa
											 ,@Rama
											 ,@Moneda
											 ,@TipoCambio
											 ,@Cuenta
											 ,@SubCuenta
											 ,@Grupo
											 ,@Modulo
											 ,@ID
											 ,@Mov
											 ,@MovID
											 ,NULL
											 ,@Puntos
											 ,@FechaEmision
											 ,@EjercicioAfectacion
											 ,@PeriodoAfectacion
											 ,@AcumulaSinDetalles
											 ,@AcumulaEnLinea
											 ,@GeneraAuxiliar
											 ,@GeneraSaldo
											 ,@Conciliar
											 ,@Mov
											 ,@MovID
											 ,@EsResultados
											 ,@Ok OUTPUT
											 ,@OkRef OUTPUT
											 ,@Renglon = @Renglon
											 ,@RenglonSub = @RenglonSub
											 ,@RenglonID = @RenglonID
											 ,@UEN = @UEN

								IF @OK IS NULL
									EXEC xpMonederoGenerarEstadistica @Empresa
																	 ,@Sucursal
																	 ,@Modulo
																	 ,@ID
																	 ,@MovTipo
																	 ,@Mov
																	 ,@MovID
																	 ,@Accion
																	 ,@Puntos
																	 ,@Cuenta
																	 ,1
																	 ,@Ok OUTPUT
																	 ,@OkRef OUTPUT

							END
							ELSE
							BEGIN
								SELECT @DiferenciaPuntos = @Puntos - @SaldoPuntos
								EXEC spSaldoP @Sucursal
											 ,@Accion
											 ,@Empresa
											 ,@Rama
											 ,@Moneda
											 ,@TipoCambio
											 ,@Cuenta
											 ,@SubCuenta
											 ,@Grupo
											 ,@Modulo
											 ,@ID
											 ,@Mov
											 ,@MovID
											 ,NULL
											 ,@SaldoPuntos
											 ,@FechaEmision
											 ,@EjercicioAfectacion
											 ,@PeriodoAfectacion
											 ,@AcumulaSinDetalles
											 ,@AcumulaEnLinea
											 ,@GeneraAuxiliar
											 ,@GeneraSaldo
											 ,@Conciliar
											 ,@Mov
											 ,@MovID
											 ,@EsResultados
											 ,@Ok OUTPUT
											 ,@OkRef OUTPUT
											 ,@Renglon = @Renglon
											 ,@RenglonSub = @RenglonSub
											 ,@RenglonID = @RenglonID
											 ,@UEN = @UEN

								IF @OK IS NULL
									EXEC xpMonederoGenerarEstadistica @Empresa
																	 ,@Sucursal
																	 ,@Modulo
																	 ,@ID
																	 ,@MovTipo
																	 ,@Mov
																	 ,@MovID
																	 ,@Accion
																	 ,@SaldoPuntos
																	 ,@Cuenta
																	 ,1
																	 ,@Ok OUTPUT
																	 ,@OkRef OUTPUT

								IF @OK IS NULL
									EXEC xpGenerarNCMonedero @Empresa
															,@Sucursal
															,@Usuario
															,@ID
															,@Mov
															,@MovID
															,@FechaEmision
															,@FechaRegistro
															,@DiferenciaPuntos
															,@Accion
															,@Cuenta
															,0
															,@Ok OUTPUT
															,@OkRef OUTPUT

							END

						END
						ELSE
							SELECT @OK = 99005
								  ,@OKRef = @Cuenta

					END

				END

			END

			IF @EstatusNuevo = 'CANCELADO'
			BEGIN
				SELECT @Accion = 'CANCELAR'

				IF EXISTS (SELECT * FROM PoliticasMonederoAplicadasMavi WHERE Modulo = @Modulo AND ID = @ID AND ISNULL(cveEstatus, '') <> 'P')
				BEGIN
					SELECT @Moneda = V.Moneda
						  ,@TipoCambio = V.TipoCambio
						  ,@UEN = V.Uen
						  ,@EjercicioAfectacion = V.Ejercicio
						  ,@PeriodoAfectacion = V.Periodo
						  ,@Cuenta =
						   CASE
							   WHEN vc.Categoria = 'ASOCIADOS' THEN NULLIF(C.SerieMonedero, '')
							   ELSE NULLIF(T.Serie, '')
						   END
						  ,@Puntos = SUM(ISNULL(AP.Abono, 0.0))
					FROM Venta V
					JOIN TarjetaSerieMovMAVI T
						ON V.ID = T.ID
					LEFT JOIN CTE C
						ON V.Cliente = c.Cliente
					JOIN VentasCanalMAVI VC
						ON VC.ID = V.EnviarA
					LEFT JOIN AuxiliarP AP
						ON V.ID = AP.ModuloID
						AND AP.Modulo = 'VTAS'
						AND Abono > 0
						AND EsCancelacion = 0
					WHERE V.ID = @ID
					GROUP BY V.Moneda
							,V.TipoCambio
							,V.Uen
							,V.Ejercicio
							,V.Periodo
							,T.Serie
							,c.SerieMonedero
							,vc.Categoria
					SELECT @PuntosVta = SUM(ISNULL(D.Puntos, 0.0))
					FROM Venta V
					JOIN VentaD D
						ON V.ID = D.ID
					JOIN TarjetaSerieMovMAVI T
						ON V.ID = T.ID
					LEFT JOIN CTE C
						ON V.Cliente = c.Cliente
					WHERE V.ID = @ID
					GROUP BY NULLIF(C.SerieMonedero, NULLIF(T.Serie, ''))

					IF @Cuenta IS NOT NULL
						AND ISNULL(@PuntosVta, 0.0) > 0.0
					BEGIN

						IF EXISTS (SELECT * FROM TarjetaMonederoMAVI T WHERE T.Serie = @Cuenta AND T.Estatus IN ('ACTIVA'))
						BEGIN

							IF ISNULL(@PuntosVta, 0.0) <> 0.0
							BEGIN
								EXEC spSaldoP @Sucursal
											 ,@Accion
											 ,@Empresa
											 ,@Rama
											 ,@Moneda
											 ,@TipoCambio
											 ,@Cuenta
											 ,@SubCuenta
											 ,@Grupo
											 ,@Modulo
											 ,@ID
											 ,@Mov
											 ,@MovID
											 ,@Puntos
											 ,NULL
											 ,@FechaEmision
											 ,@EjercicioAfectacion
											 ,@PeriodoAfectacion
											 ,@AcumulaSinDetalles
											 ,@AcumulaEnLinea
											 ,@GeneraAuxiliar
											 ,@GeneraSaldo
											 ,@Conciliar
											 ,@Mov
											 ,@MovID
											 ,@EsResultados
											 ,@Ok OUTPUT
											 ,@OkRef OUTPUT
											 ,@Renglon = @Renglon
											 ,@RenglonSub = @RenglonSub
											 ,@RenglonID = @RenglonID
											 ,@UEN = @UEN
							END

						END
						ELSE
							SELECT @OK = 99005
								  ,@OKRef = @Cuenta

					END

				END

				IF EXISTS (SELECT * FROM TarjetaSerieMovMAVI WHERE Modulo = @Modulo AND ID = @ID)
				BEGIN
					SELECT @Moneda = V.Moneda
						  ,@TipoCambio = V.TipoCambio
						  ,@UEN = V.Uen
						  ,@EjercicioAfectacion = V.Ejercicio
						  ,@PeriodoAfectacion = V.Periodo
						  ,@Cuenta = NULLIF(T.Serie, '')
						  ,@Puntos = ISNULL(T.Importe, 0.0)
					FROM Venta V
					JOIN VentaD D
						ON V.ID = D.ID
					JOIN TarjetaSerieMovMAVI T
						ON V.ID = T.ID
					WHERE V.ID = @ID

					IF @Cuenta IS NOT NULL
						AND ISNULL(@Puntos, 0.0) > 0.0
					BEGIN

						IF EXISTS (SELECT * FROM TarjetaMonederoMAVI T WHERE T.Serie = @Cuenta AND T.Estatus IN ('ACTIVA'))
						BEGIN
							SELECT @SaldoPuntos = SUM(ISNULL(Saldo, 0.0))
							FROM SaldoP
							WHERE Empresa = @Empresa
							AND Rama = @Rama
							AND Moneda = @Moneda
							AND Grupo = @Grupo
							AND Cuenta = @Cuenta
							AND UEN = ISNULL(NULLIF(@UEN, ''), '0')

							IF @SaldoPuntos >= @Puntos
							BEGIN
								EXEC spSaldoP @Sucursal
											 ,@Accion
											 ,@Empresa
											 ,@Rama
											 ,@Moneda
											 ,@TipoCambio
											 ,@Cuenta
											 ,@SubCuenta
											 ,@Grupo
											 ,@Modulo
											 ,@ID
											 ,@Mov
											 ,@MovID
											 ,NULL
											 ,@Puntos
											 ,@FechaEmision
											 ,@EjercicioAfectacion
											 ,@PeriodoAfectacion
											 ,@AcumulaSinDetalles
											 ,@AcumulaEnLinea
											 ,@GeneraAuxiliar
											 ,@GeneraSaldo
											 ,@Conciliar
											 ,@Mov
											 ,@MovID
											 ,@EsResultados
											 ,@Ok OUTPUT
											 ,@OkRef OUTPUT
											 ,@Renglon = @Renglon
											 ,@RenglonSub = @RenglonSub
											 ,@RenglonID = @RenglonID
											 ,@UEN = @UEN
							END
							ELSE
							BEGIN
								SELECT @DiferenciaPuntos = @Puntos - @SaldoPuntos
								EXEC spSaldoP @Sucursal
											 ,@Accion
											 ,@Empresa
											 ,@Rama
											 ,@Moneda
											 ,@TipoCambio
											 ,@Cuenta
											 ,@SubCuenta
											 ,@Grupo
											 ,@Modulo
											 ,@ID
											 ,@Mov
											 ,@MovID
											 ,NULL
											 ,@SaldoPuntos
											 ,@FechaEmision
											 ,@EjercicioAfectacion
											 ,@PeriodoAfectacion
											 ,@AcumulaSinDetalles
											 ,@AcumulaEnLinea
											 ,@GeneraAuxiliar
											 ,@GeneraSaldo
											 ,@Conciliar
											 ,@Mov
											 ,@MovID
											 ,@EsResultados
											 ,@Ok OUTPUT
											 ,@OkRef OUTPUT
											 ,@Renglon = @Renglon
											 ,@RenglonSub = @RenglonSub
											 ,@RenglonID = @RenglonID
											 ,@UEN = @UEN

								IF @OK IS NULL
									EXEC xpGenerarNCMonedero @Empresa
															,@Sucursal
															,@Usuario
															,@ID
															,@Mov
															,@MovID
															,@FechaEmision
															,@FechaRegistro
															,@DiferenciaPuntos
															,'AFECTAR'
															,@Cuenta
															,0
															,@Ok OUTPUT
															,@OkRef OUTPUT

							END

						END

					END

				END

			END

		END

	END

	RETURN
END
GO