SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spMovConsecutivo]
 @Sucursal INT
,@SucursalOrigen INT
,@SucursalDestino INT
,@Empresa CHAR(5)
,@Usuario CHAR(10)
,@Modulo CHAR(5)
,@Ejercicio INT
,@Periodo INT
,@ID INT
,@Mov CHAR(20)
,@Serie VARCHAR(50)
,@Estatus CHAR(15)
,@Concepto VARCHAR(50)
,@Accion CHAR(20)
,@Conexion BIT
,@SincroFinal BIT
,@MovID VARCHAR(20) OUTPUT
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
AS
BEGIN
	DECLARE
		@Prefijo CHAR(10)
	   ,@PuedeEditar BIT
	   ,@SucursalConsecutivo INT
	   ,@SucursalPrincipal INT
	   ,@EnLinea BIT
	   ,@MovTipo VARCHAR(20)
	   ,@SubFoliosOrigen BIT
	   ,@CfgSubFoliosOrigen BIT
	   ,@CfgSubFoliosOrigenSeparador VARCHAR(10)
	   ,@ConsecutivoUnico BIT
	   ,@OrigenTipo VARCHAR(10)
	   ,@Origen VARCHAR(20)
	   ,@OrigenID VARCHAR(20)
	   ,@CFD BIT
	   ,@RamaID INT
	   ,@prefijosucursal BIT
		 ,@CFDFlex BIT
	SELECT @EnLinea = 0
		  ,@SucursalPrincipal = NULL
		  ,@CFD = 0
		  ,@MovTipo = NULL
		  ,@SubFoliosOrigen = 0
		  ,@ConsecutivoUnico = 0
			,@CFDFlex = 0
	SELECT @ConsecutivoUnico = ISNULL(ConsecutivoUnico, 0)
	FROM Modulo
	WHERE Modulo = @Modulo
	SELECT @MovTipo = Clave
		  ,@SubFoliosOrigen = ISNULL(SubFoliosOrigen, 0)
	FROM MovTipo
	WHERE Modulo = @Modulo
	AND Mov = @Mov
	SELECT @CfgSubFoliosOrigen = ISNULL(SubFoliosOrigen, 0)
		  ,@CfgSubFoliosOrigenSeparador = ISNULL(NULLIF(RTRIM(SubFoliosOrigenSeparador), ''), '.')
	FROM EmpresaGral
	WHERE Empresa = @Empresa

	IF @CfgSubFoliosOrigen = 0
		SELECT @SubFoliosOrigen = 0

	IF @ConsecutivoUnico = 1
	BEGIN
		EXEC spMovInfo @ID
					  ,@Modulo
					  ,@OrigenTipo = @OrigenTipo OUTPUT
					  ,@Origen = @Origen OUTPUT
					  ,@OrigenID = @OrigenID OUTPUT
					  ,@RamaID = @RamaID OUTPUT
		SELECT @Mov = @Modulo

		IF @RamaID IS NOT NULL
		BEGIN
			EXEC spMovInfo @RamaID
						  ,@Modulo
						  ,@MovID = @Serie OUTPUT
			SELECT @Serie = @Serie + @CfgSubFoliosOrigenSeparador
				  ,@SubFoliosOrigen = 1
		END

	END
	ELSE

	IF @SubFoliosOrigen = 1
	BEGIN
		EXEC spMovInfo @ID
					  ,@Modulo
					  ,@OrigenTipo = @OrigenTipo OUTPUT
					  ,@Origen = @Origen OUTPUT
					  ,@OrigenID = @OrigenID OUTPUT

		IF @OrigenTipo = @Modulo
			AND @Origen IS NOT NULL
			AND @OrigenID IS NOT NULL
		BEGIN
			SELECT @Serie = @OrigenID + @CfgSubFoliosOrigenSeparador
		END
		ELSE
			SELECT @SubFoliosOrigen = 0

	END

	IF (@Conexion = 0 OR @Accion = 'CANCELAR')
		AND @SincroFinal = 0
		AND @Accion <> 'SINCRO'
	BEGIN
		EXEC spPuedeEditarMovMatrizSucursal @Sucursal
										   ,@SucursalOrigen
										   ,@ID
										   ,@Modulo
										   ,@Empresa
										   ,@Usuario
										   ,@Mov
										   ,@Estatus
										   ,1
										   ,@PuedeEditar OUTPUT

		IF @PuedeEditar = 0
		BEGIN

			IF @MovTipo <> 'INV.TI'
				SELECT @Ok = 60300
					  ,@OkRef = RTRIM(@Mov) + ' (' + RTRIM(@Modulo) + ')'

		END

	END

	IF @Accion <> 'CANCELAR'
		AND NULLIF(RTRIM(@Concepto), '') IS NOT NULL
		AND @Ok IS NULL

		IF EXISTS (SELECT * FROM EmpresaConcepto c, EmpresaConceptoValidar v WHERE v.Empresa = c.Empresa AND v.Modulo = c.Modulo AND v.Mov = c.Mov AND c.Empresa = @Empresa AND c.Modulo = @Modulo AND c.Mov = @Mov)

			IF NOT EXISTS (SELECT * FROM EmpresaConceptoValidar WHERE Empresa = @Empresa AND Modulo = @Modulo AND Mov = @Mov AND Concepto = @Concepto)
				SELECT @Ok = 20485
					  ,@OkRef = RTRIM(@Mov) + ' (' + RTRIM(@Concepto) + ')'

	IF @Ok IS NOT NULL
		RETURN

	IF @Conexion = 0
		BEGIN TRANSACTION

	SELECT @MovID = NULLIF(RTRIM(@MovID), '')

	IF @MovID IS NULL
	BEGIN
		EXEC xpConsecutivoSerie @Empresa
							   ,@Modulo
							   ,@ID
							   ,@Mov
							   ,@Serie OUTPUT
							   ,@Ok OUTPUT
							   ,@OkRef OUTPUT
		SELECT @PREFIJOSUCURSAL = prefijosucursal
		FROM movtipo
		WHERE Modulo = @Modulo
		AND Mov = @Mov

		IF @Serie IS NOT NULL
		BEGIN

			IF @prefijosucursal = 1
			BEGIN
				SELECT @sucursalprincipal = @sucursal
				SELECT @SucursalConsecutivo = @SucursalPrincipal
			END
			ELSE
				SELECT @SucursalPrincipal = Sucursal
				FROM Version

			SELECT @SucursalConsecutivo = @SucursalPrincipal
		END
		ELSE
		BEGIN

			IF @Ok IS NULL
				SELECT @SucursalConsecutivo = @Sucursal

			IF @Sucursal <> @SucursalDestino
			BEGIN

				IF EXISTS (SELECT * FROM EmpresaGral WHERE Empresa = @Empresa AND UsarConsecutivoSucursalDestino = 1)
				BEGIN
					EXEC spSucursalEnLinea @SucursalDestino
										  ,@EnLinea OUTPUT

					IF @EnLinea = 1
						SELECT @SucursalConsecutivo = @SucursalDestino

				END

			END

		END

		IF @Ok IS NULL
		BEGIN
			EXEC spConsecutivoAuto @SucursalConsecutivo
								  ,@Empresa
								  ,@Modulo
								  ,@Mov
								  ,@Ejercicio
								  ,@Periodo
								  ,@Serie
								  ,@MovID OUTPUT
								  ,@Ok OUTPUT
								  ,@OkRef OUTPUT
								  ,@CFD OUTPUT
								  ,@SubFoliosOrigen
								  ,@ConsecutivoUnico
								  ,@ID
		END

		IF @MovID IS NOT NULL
			AND @CFD = 0
			AND @Ok IS NULL
			AND @CFDFlex = 0
		BEGIN
			SELECT @Prefijo = NULL
			SELECT @Prefijo = NULLIF(RTRIM(Prefijo), '')
			FROM Sucursal
			WHERE Sucursal = @SucursalConsecutivo
			EXEC xpConsecutivoPrefijo @Empresa
									 ,@Modulo
									 ,@ID
									 ,@Mov
									 ,@MovID
									 ,@Prefijo OUTPUT
									 ,@Ok OUTPUT
									 ,@OkRef OUTPUT

			IF @Prefijo IS NOT NULL
			BEGIN

				IF (@Serie IS NOT NULL AND @ConsecutivoUnico = 1)
					SELECT @Prefijo = NULL

				IF dbo.fnEsNumerico(@Prefijo) = 1
					SELECT @Ok = 70110
						  ,@OkRef = @Prefijo

				SELECT @MovID = RTRIM(@Prefijo) + RTRIM(@MovID)

				IF @Serie IS NULL
					SELECT @Serie = @Prefijo

			END
			ELSE
			BEGIN

				IF @SucursalPrincipal IS NULL
					SELECT @SucursalPrincipal = Sucursal
					FROM Version

				IF @SucursalConsecutivo <> @SucursalPrincipal
				BEGIN
					SELECT @SucursalConsecutivo = @SucursalPrincipal
					EXEC spConsecutivoAuto @SucursalConsecutivo
										  ,@Empresa
										  ,@Modulo
										  ,@Mov
										  ,@Ejercicio
										  ,@Periodo
										  ,@Serie
										  ,@MovID OUTPUT
										  ,@Ok OUTPUT
										  ,@OkRef OUTPUT
										  ,@CFD OUTPUT
										  ,@SubFoliosOrigen
										  ,@ConsecutivoUnico
										  ,@ID
				END

			END

		END

		IF @Ok IS NULL
		BEGIN

			IF @Modulo = 'CONT'
				UPDATE Cont
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'VTAS'
				UPDATE Venta
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'PROD'
				UPDATE Prod
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'COMS'
				UPDATE Compra
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'INV'
				UPDATE Inv
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CXC'
				UPDATE Cxc
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CXP'
				UPDATE Cxp
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'AGENT'
				UPDATE Agent
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'GAS'
				UPDATE Gasto
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'DIN'
				UPDATE Dinero
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'EMB'
				UPDATE Embarque
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'NOM'
				UPDATE Nomina
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'RH'
				UPDATE RH
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'ASIS'
				UPDATE Asiste
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'AF'
				UPDATE ActivoFijo
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'PC'
				UPDATE PC
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'OFER'
				UPDATE Oferta
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'VALE'
				UPDATE Vale
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CR'
				UPDATE CR
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'ST'
				UPDATE Soporte
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CAP'
				UPDATE Capital
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'INC'
				UPDATE Incidencia
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CONC'
				UPDATE Conciliacion
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'PPTO'
				UPDATE Presup
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CREDI'
				UPDATE Credito
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'TMA'
				UPDATE TMA
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'RSS'
				UPDATE RSS
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CMP'
				UPDATE Campana
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'FIS'
				UPDATE Fiscal
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CONTP'
				UPDATE ContParalela
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'OPORT'
				UPDATE Oportunidad
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CORTE'
				UPDATE Corte
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'FRM'
				UPDATE FormaExtra
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CAPT'
				UPDATE Captura
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'GES'
				UPDATE Gestion
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CP'
				UPDATE CP
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'PCP'
				UPDATE PCP
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'PROY'
				UPDATE Proyecto
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'ORG'
				UPDATE Organiza
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'RE'
				UPDATE Recluta
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'ISL'
				UPDATE ISL
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CAM'
				UPDATE Cambio
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'PACTO'
				UPDATE Contrato
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'SAUX'
				UPDATE SAUX
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'PREV'
				UPDATE PrevencionLD
				SET MovID = @MovID
				WHERE ID = @ID
			ELSE

			IF @@ERROR <> 0
				SELECT @Ok = 1

		END

	END
	ELSE

	IF @Estatus IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR')
		EXEC spConsecutivoManual @SucursalConsecutivo
								,@Empresa
								,@Modulo
								,@ID
								,@Mov
								,@Ejercicio
								,@Periodo
								,@Serie OUTPUT
								,@MovID OUTPUT
								,@OK OUTPUT
								,@OkRef OUTPUT

	EXEC xpMovConsecutivo @Sucursal
						 ,@SucursalOrigen
						 ,@SucursalDestino
						 ,@Empresa
						 ,@Usuario
						 ,@Modulo
						 ,@Ejercicio
						 ,@Periodo
						 ,@ID
						 ,@Mov
						 ,@Serie
						 ,@Estatus
						 ,@Concepto
						 ,@Accion
						 ,@Conexion
						 ,@SincroFinal
						 ,@MovID OUTPUT
						 ,@Ok OUTPUT
						 ,@OkRef OUTPUT

	IF @Conexion = 0
	BEGIN

		IF @Ok IS NULL
			COMMIT TRANSACTION
		ELSE
		BEGIN

			IF @Ok IS NULL
				SELECT @Ok = 30010
					  ,@OkRef = LTRIM(CONVERT(CHAR, @MovID))

			ROLLBACK TRANSACTION
		END

	END

	RETURN
END
GO