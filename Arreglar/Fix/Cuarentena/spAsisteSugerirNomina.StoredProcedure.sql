SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spAsisteSugerirNomina]
 @Empresa CHAR(5)
,@Sucursal INT
,@Usuario CHAR(10)
,@Modulo CHAR(5)
,@ID INT
,@Mov CHAR(20)
,@MovID VARCHAR(20)
,@Accion CHAR(20)
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
AS
BEGIN
	DECLARE
		@Moneda CHAR(10)
	   ,@TipoCambio FLOAT
	   ,@GenerarFaltas BIT
	   ,@GenerarRetardos BIT
	   ,@GenerarHorasExtras BIT
	   ,@MovFaltas CHAR(20)
	   ,@MovRetardos CHAR(20)
	   ,@MovHorasExtras CHAR(20)
	   ,@NominaID INT
	   ,@Minutos INT
	   ,@Horas CHAR(5)
	   ,@Concepto VARCHAR(50)
	   ,@MovTipo VARCHAR(20)
	   ,@FechaD DATETIME
	   ,@FechaA DATETIME
	   ,@HerramHorasExtra BIT
		 ,@GenerarBancoHoras BIT
	   ,@EstatusExtra CHAR(15)
		 ,@HM CHAR(5)
	SELECT @MovTipo = MT.Clave
	FROM Asiste A
	JOIN MovTipo MT
		ON MT.Mov = A.Mov
		AND MT.Modulo = @Modulo
	WHERE A.ID = @ID

	IF @Accion = 'CANCELAR'
	BEGIN
		DECLARE
			crCancelarNomina
			CURSOR FOR
			SELECT ID
			FROM Nomina
			WHERE OrigenTipo = @Modulo
			AND Origen = @Mov
			AND OrigenID = @MovID
		OPEN crCancelarNomina
		FETCH NEXT FROM crCancelarNomina INTO @NominaID
		WHILE @@FETCH_STATUS <> -1
		AND @Ok IS NULL
		BEGIN

		IF @@FETCH_STATUS <> -2
			AND @Ok IS NULL
		BEGIN

			IF @MovTipo = 'ASIS.C'

				IF EXISTS (SELECT * FROM MovFlujo WHERE Cancelado = 0 AND Empresa = @Empresa AND OModulo = @Modulo AND OID = @ID AND OModulo <> DModulo)

					IF @Accion = 'CANCELAR'
						SELECT @Ok = 60060

			IF @Ok IS NULL
				EXEC spAfectar 'NOM'
							  ,@NominaID
							  ,@Accion
							  ,@EnSilencio = 1
							  ,@Ok = @Ok OUTPUT
							  ,@OkRef = @OkRef OUTPUT

		END

		FETCH NEXT FROM crCancelarNomina INTO @NominaID
		END
		CLOSE crCancelarNomina
		DEALLOCATE crCancelarNomina
	END
	ELSE
	BEGIN
		SELECT @Moneda = ContMoneda
			  ,@GenerarFaltas = AsisteGenerarFaltas
			  ,@GenerarRetardos = AsisteGenerarRetardos
			  ,@GenerarHorasExtras = AsisteGenerarHorasExtras
			  ,@HerramHorasExtra = HerramientaHorasExtra
		FROM EmpresaCfg
		WHERE Empresa = @Empresa
		SELECT @TipoCambio = TipoCambio
		FROM Mon
		WHERE Moneda = @Moneda
		SELECT @MovFaltas = NomFaltas
			  ,@MovRetardos = NomRetardos
			  ,@MovHorasExtras = NomHorasExtras
		FROM EmpresaCfgMov
		WHERE Empresa = @Empresa
		DECLARE
			crAsisteConcepto
			CURSOR LOCAL FOR
			SELECT DISTINCT ISNULL(RTRIM(Concepto), '')
			FROM AsisteD
			WHERE ID = @ID
		OPEN crAsisteConcepto
		FETCH NEXT FROM crAsisteConcepto INTO @Concepto
		WHILE @@FETCH_STATUS <> -1
		AND @Ok IS NULL
		BEGIN

		IF @@FETCH_STATUS <> -2
			AND @Ok IS NULL
		BEGIN

			IF @GenerarFaltas = 1
			BEGIN

				IF EXISTS (SELECT personal FROM AsisteD d WHERE d.ID = @ID AND UPPER(d.Tipo) = 'DIAS AUSENCIA' AND ISNULL(RTRIM(d.Concepto), '') = @Concepto)
				BEGIN
					SELECT @FechaD = FechaD
						  ,@FechaA = FechaA
					FROM Asiste
					WHERE ID = @ID
					INSERT Nomina (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, FechaEmision, Proyecto, UEN, Moneda, TipoCambio, Concepto)
						SELECT GETDATE()
							  ,@Sucursal
							  ,@Sucursal
							  ,@Sucursal
							  ,'ASIS'
							  ,@Mov
							  ,@MovID
							  ,@Empresa
							  ,@Usuario
							  ,'CONFIRMAR'
							  ,@MovFaltas
							  ,FechaEmision
							  ,Proyecto
							  ,UEN
							  ,@Moneda
							  ,@TipoCambio
							  ,@Concepto
						FROM Asiste
						WHERE ID = @ID
					SELECT @NominaID = SCOPE_IDENTITY()

					INSERT NominaD (ID, Renglon, Personal, FechaD, Cantidad, Concepto)
						SELECT @NominaID
								,MIN(d.Renglon)
								,d.Personal
								,d.Fecha
								,1.0
								,@Concepto
						FROM AsisteD d
						JOIN Personal p
							ON p.Personal = d.Personal
							AND p.Estatus = 'ALTA'
						WHERE d.ID = @ID
						AND UPPER(d.Tipo) = 'DIAS AUSENCIA'
						AND ISNULL(RTRIM(d.Concepto), '') = ISNULL(@Concepto, '')
						GROUP BY d.Personal
								,d.Fecha

					IF NOT EXISTS (SELECT * FROM NominaD WHERE ID = @NominaID)
					BEGIN
						DELETE Nomina
						WHERE ID = @NominaID
					END

				END

				IF EXISTS (SELECT personal FROM AsisteD d WHERE d.ID = @ID AND UPPER(d.Tipo) = 'DIAS DE SANCION' AND ISNULL(RTRIM(d.Concepto), '') = @Concepto)
				BEGIN
					INSERT Nomina (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, FechaEmision, Proyecto, UEN, Moneda, TipoCambio, Concepto)
						SELECT GETDATE()
							  ,@Sucursal
							  ,@Sucursal
							  ,@Sucursal
							  ,'ASIS'
							  ,@Mov
							  ,@MovID
							  ,@Empresa
							  ,@Usuario
							  ,'CONFIRMAR'
							  ,'Dias de Sancion'
							  ,FechaEmision
							  ,Proyecto
							  ,UEN
							  ,@Moneda
							  ,@TipoCambio
							  ,@Concepto
						FROM Asiste
						WHERE ID = @ID
					SELECT @NominaID = @@IDENTITY
					INSERT NominaD (ID, Renglon, Personal, FechaD, Cantidad, Concepto)
						SELECT @NominaID
							  ,MIN(d.Renglon)
							  ,d.Personal
							  ,d.Fecha
							  ,1.0
							  ,@Concepto
						FROM AsisteD d
						JOIN Personal p
							ON p.Personal = d.Personal
							AND p.Estatus = 'ALTA'
						WHERE d.ID = @ID
						AND d.Tipo = 'Dias de Sancion'
						AND ISNULL(RTRIM(d.Concepto), '') = @Concepto
						GROUP BY d.Personal
								,d.Fecha
				END

			END

			IF @GenerarRetardos = 1
			BEGIN

				IF EXISTS (SELECT personal FROM AsisteD d WHERE d.ID = @ID AND UPPER(d.Tipo) = 'MINUTOS AUSENCIA' AND ISNULL(RTRIM(d.Concepto), '') = @Concepto)
				BEGIN
					SELECT @FechaD = NULL
						  ,@FechaA = NULL
					SELECT @FechaD = FechaD
						  ,@FechaA = FechaA
					FROM Asiste
					WHERE ID = @ID
					INSERT Nomina (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, FechaEmision, Proyecto, UEN, Moneda, TipoCambio, Concepto)
						SELECT GETDATE()
							  ,@Sucursal
							  ,@Sucursal
							  ,@Sucursal
							  ,'ASIS'
							  ,@Mov
							  ,@MovID
							  ,@Empresa
							  ,@Usuario
							  ,'CONFIRMAR'
							  ,@MovRetardos
							  ,FechaEmision
							  ,Proyecto
							  ,UEN
							  ,@Moneda
							  ,@TipoCambio
							  ,@Concepto
						FROM Asiste
						WHERE ID = @ID
					SELECT @NominaID = SCOPE_IDENTITY()

					INSERT NominaD (ID, Renglon, Personal, FechaD, Cantidad, Horas)
						SELECT @NominaID
								,MIN(d.Renglon)
								,d.Personal
								,d.Fecha
								,SUM(d.Cantidad) / (60)
								,CAST(CONVERT(VARCHAR, d.Fecha + (SUM(d.Cantidad) / (60 * 24)), 108) AS VARCHAR(5))
						FROM AsisteD d
						JOIN Personal p
							ON p.Personal = d.Personal
							AND p.Estatus = 'ALTA'
						WHERE d.ID = @ID
						AND UPPER(d.Tipo) = 'MINUTOS AUSENCIA'
						AND ISNULL(RTRIM(d.Concepto), '') = @Concepto
						GROUP BY d.Personal
								,d.Fecha

					IF NOT EXISTS (SELECT * FROM NominaD WHERE ID = @NominaID)
					BEGIN
						DELETE Nomina
						WHERE ID = @NominaID
					END

				END

			END

			IF @GenerarHorasExtras = 1
				SELECT @GenerarBancoHoras = ISNULL(porOmision, 0)
				FROM PersonalProp
				WHERE propiedad = 'Activar Banco de Horas'

			SET @EstatusExtra = 'CONFIRMAR'

			IF @GenerarBancoHoras = 1
			BEGIN
				SELECT @MovHorasExtras = NULL
					  ,@EstatusExtra = NULL
				SELECT @MovHorasExtras = 'Banco de Horas'
					  ,@EstatusExtra = 'CONCLUIDO'
			END

			IF EXISTS (SELECT personal FROM AsisteD d WHERE d.ID = @ID AND UPPER(d.Tipo) = 'MINUTOS EXTRAS' AND ISNULL(RTRIM(d.Concepto), '') = @Concepto)
			BEGIN
				INSERT Nomina (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, FechaEmision, Proyecto, UEN, Moneda, TipoCambio, Concepto)
					SELECT GETDATE()
							,@Sucursal
							,@Sucursal
							,@Sucursal
							,'ASIS'
							,@Mov
							,@MovID
							,@Empresa
							,@Usuario
							,@EstatusExtra
							,@MovHorasExtras
							,FechaEmision
							,Proyecto
							,UEN
							,@Moneda
							,@TipoCambio
							,@Concepto
					FROM Asiste
					WHERE ID = @ID
				SELECT @NominaID = SCOPE_IDENTITY()
				INSERT NominaD (ID, Renglon, Personal, FechaD, Cantidad, Horas)
					SELECT @NominaID
							,MIN(d.Renglon)
							,d.Personal
							,d.Fecha
							,SUM(d.Cantidad) / 60.0
							,CAST(CONVERT(VARCHAR, d.Fecha + (SUM(d.Cantidad) / (60 * 24)), 108) AS VARCHAR(5))
					FROM AsisteD d
					JOIN Personal p
						ON p.Personal = d.Personal
						AND p.Estatus = 'ALTA'
					WHERE d.ID = @ID
					AND UPPER(d.Tipo) = 'MINUTOS EXTRAS'
					AND ISNULL(RTRIM(d.Concepto), '') = @Concepto
					GROUP BY d.Personal
							,d.Fecha
				DECLARE
					crNominaD
					CURSOR LOCAL FOR
					SELECT Cantidad * 60
					FROM NominaD
					WHERE ID = @NominaID
				OPEN crNominaD
				FETCH NEXT FROM crNominaD INTO @Minutos
				WHILE @@FETCH_STATUS <> -1
				AND @Ok IS NULL
				BEGIN

				IF @@FETCH_STATUS <> -2
					AND @Ok IS NULL
				BEGIN
					EXEC spMinutosToHoras @Minutos
											,@Horas OUTPUT
											,1
					UPDATE NominaD
					SET Horas = @Horas
					WHERE CURRENT OF crNominaD
				END

				FETCH NEXT FROM crNominaD INTO @Minutos
				END
				CLOSE crNominaD
				DEALLOCATE crNominaD

				IF EXISTS (SELECT personal FROM AsisteD d WHERE d.ID = @ID AND UPPER(d.Tipo) = 'Día Desc. Lab.' AND ISNULL(RTRIM(d.Concepto), '') = @Concepto)
				BEGIN
					INSERT Nomina (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, FechaEmision, Proyecto, UEN, Moneda, TipoCambio, Concepto)
						SELECT GETDATE()
							  ,@Sucursal
							  ,@Sucursal
							  ,@Sucursal
							  ,'ASIS'
							  ,@Mov
							  ,@MovID
							  ,@Empresa
							  ,@Usuario
							  ,'CONFIRMAR'
							  ,'Día Desc. Lab.'
							  ,FechaEmision
							  ,Proyecto
							  ,UEN
							  ,@Moneda
							  ,@TipoCambio
							  ,@Concepto
						FROM Asiste
						WHERE ID = @ID
					SELECT @NominaID = @@IDENTITY
					INSERT NominaD (ID, Renglon, Personal, FechaD, Cantidad)
						SELECT @NominaID
							  ,MIN(d.Renglon)
							  ,d.Personal
							  ,d.Fecha
							  ,d.Cantidad
						FROM AsisteD d
						JOIN Personal p
							ON p.Personal = d.Personal
							AND p.Estatus = 'ALTA'
						WHERE d.ID = @ID
						AND UPPER(d.Tipo) = 'Día Desc. Lab.'
						AND ISNULL(RTRIM(d.Concepto), '') = @Concepto
						GROUP BY d.Personal
								,d.Fecha
								,d.Cantidad
				END

				IF EXISTS (SELECT personal FROM AsisteD d WHERE d.ID = @ID AND UPPER(d.Tipo) = 'Domingos Laborados' AND ISNULL(RTRIM(d.Concepto), '') = @Concepto)
				BEGIN
					INSERT Nomina (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, FechaEmision, Proyecto, UEN, Moneda, TipoCambio, Concepto)
						SELECT GETDATE()
							  ,@Sucursal
							  ,@Sucursal
							  ,@Sucursal
							  ,'ASIS'
							  ,@Mov
							  ,@MovID
							  ,@Empresa
							  ,@Usuario
							  ,'CONFIRMAR'
							  ,'Domingos Laborados'
							  ,FechaEmision
							  ,Proyecto
							  ,UEN
							  ,@Moneda
							  ,@TipoCambio
							  ,@Concepto
						FROM Asiste
						WHERE ID = @ID
					SELECT @NominaID = @@IDENTITY
					INSERT NominaD (ID, Renglon, Personal, FechaD, Cantidad)
						SELECT @NominaID
							  ,MIN(d.Renglon)
							  ,d.Personal
							  ,d.Fecha
							  ,d.Cantidad
						FROM AsisteD d
						JOIN Personal p
							ON p.Personal = d.Personal
							AND p.Estatus = 'ALTA'
						WHERE d.ID = @ID
						AND UPPER(d.Tipo) = 'Domingos Laborados'
						AND ISNULL(RTRIM(d.Concepto), '') = @Concepto
						GROUP BY d.Personal
								,d.Fecha
								,d.Cantidad
				END

				IF EXISTS (SELECT personal FROM AsisteD d WHERE d.ID = @ID AND UPPER(d.Tipo) = 'Día Festivo Lab.' AND ISNULL(RTRIM(d.Concepto), '') = @Concepto)
				BEGIN
					INSERT Nomina (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, FechaEmision, Proyecto, UEN, Moneda, TipoCambio, Concepto)
						SELECT GETDATE()
							  ,@Sucursal
							  ,@Sucursal
							  ,@Sucursal
							  ,'ASIS'
							  ,@Mov
							  ,@MovID
							  ,@Empresa
							  ,@Usuario
							  ,'CONFIRMAR'
							  ,'Día Festivo Lab.'
							  ,FechaEmision
							  ,Proyecto
							  ,UEN
							  ,@Moneda
							  ,@TipoCambio
							  ,@Concepto
						FROM Asiste
						WHERE ID = @ID
					SELECT @NominaID = @@IDENTITY
					INSERT NominaD (ID, Renglon, Personal, FechaD, Cantidad)
						SELECT @NominaID
							  ,MIN(d.Renglon)
							  ,d.Personal
							  ,d.Fecha
							  ,d.Cantidad
						FROM AsisteD d
						JOIN Personal p
							ON p.Personal = d.Personal
							AND p.Estatus = 'ALTA'
						WHERE d.ID = @ID
						AND UPPER(d.Tipo) = 'Día Festivo Lab.'
						AND ISNULL(RTRIM(d.Concepto), '') = @Concepto
						GROUP BY d.Personal
								,d.Fecha
								,d.Cantidad
				END

			END



		END

		FETCH NEXT FROM crAsisteConcepto INTO @Concepto
		END
		CLOSE crAsisteConcepto
		DEALLOCATE crAsisteConcepto
	END

	RETURN
END
GO