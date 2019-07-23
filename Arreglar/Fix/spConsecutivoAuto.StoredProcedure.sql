SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spConsecutivoAuto]
 @Sucursal INT
,@Empresa CHAR(5)
,@Modulo CHAR(5)
,@Mov CHAR(20)
,@Ejercicio INT
,@Periodo INT
,@Serie VARCHAR(50)
,@MovID VARCHAR(20) OUTPUT
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
,@CFD BIT OUTPUT
,@SubFoliosOrigen BIT = 0
,@ConsecutivoUnico BIT = 0
,@ID INT = NULL
AS
BEGIN
	SET NOCOUNT ON
	DECLARE
		@Consecutivo BIGINT
	   ,@ConsecutivoPorPeriodo BIT
	   ,@ConsecutivoPorEjercicio BIT
	   ,@ConsecutivoPorEmpresa CHAR(20)
	   ,@ConsecutivoSerial BIT
	   ,@ConsecutivoDigitos INT
	   ,@ConsecutivoSucursalEsp BIT
	   ,@SucursalEsp INT
	   ,@ModuloAfectacion CHAR(5)
	   ,@MovAfectacion VARCHAR(20)
	   ,@MovIDSt CHAR(20)
	   ,@TipoConsecutivo VARCHAR(20)
	   ,@ConsecutivoGeneral VARCHAR(20)

	IF @MovID IS NULL
		EXEC xpConsecutivoAuto @Sucursal OUTPUT
							  ,@Empresa OUTPUT
							  ,@Modulo OUTPUT
							  ,@Mov OUTPUT
							  ,@Ejercicio OUTPUT
							  ,@Periodo OUTPUT
							  ,@Serie OUTPUT
							  ,@MovID OUTPUT
							  ,@Ok OUTPUT
							  ,@OkRef OUTPUT
							  ,@CFD OUTPUT

	IF @MovID IS NULL
	BEGIN
		SELECT @ModuloAfectacion = @Modulo
			  ,@MovAfectacion = @Mov

		IF @SubFoliosOrigen = 1
			OR @ConsecutivoUnico = 1
			SELECT @ConsecutivoPorPeriodo = 0
				  ,@ConsecutivoPorEjercicio = 0
				  ,@ConsecutivoPorEmpresa = 'SI'
				  ,@ConsecutivoSucursalEsp = 0
				  ,@SucursalEsp = NULL
				  ,@ConsecutivoSerial = 0
				  ,@ConsecutivoDigitos = NULL
		ELSE
			SELECT @Modulo = ConsecutivoModulo
				  ,@Mov = ConsecutivoMov
				  ,@ConsecutivoPorPeriodo = ConsecutivoPorPeriodo
				  ,@ConsecutivoPorEjercicio = ConsecutivoPorEjercicio
				  ,@ConsecutivoPorEmpresa = ISNULL(UPPER(ConsecutivoPorEmpresa), 'SI')
				  ,@ConsecutivoSucursalEsp = ISNULL(ConsecutivoSucursalEsp, 0)
				  ,@SucursalEsp = SucursalEsp
				  ,@TipoConsecutivo = UPPER(TipoConsecutivo)
				  ,@ConsecutivoGeneral = ConsecutivoGeneral
			FROM MovTipo WITH(NOLOCK)
			WHERE Modulo = @Modulo
			AND Mov = @Mov

		IF @TipoConsecutivo = 'GENERAL'
			EXEC spConsecutivo @ConsecutivoGeneral
							  ,@Sucursal
							  ,@MovID OUTPUT
							  ,@Ok = @Ok OUTPUT
							  ,@OkRef = @OkRef OUTPUT
		ELSE
		BEGIN
			EXEC spMovTipoCFD @Empresa
							 ,@ModuloAfectacion
							 ,@MovAfectacion
							 ,@CFD OUTPUT

			IF @CFD = 1
				EXEC spCFDFolio @Sucursal
							   ,@Empresa
							   ,@Modulo
							   ,@Mov
							   ,@MovID OUTPUT
							   ,@Ok OUTPUT
							   ,@OkRef OUTPUT
							   ,@ModuloAfectacion
							   ,@ID
			ELSE
			BEGIN

				IF @SubFoliosOrigen = 0
					SELECT @ConsecutivoSerial = ConsecutivoSerial
						  ,@ConsecutivoDigitos = ConsecutivoDigitos
					FROM EmpresaGral WITH(NOLOCK)
					WHERE Empresa = @Empresa

				IF @ConsecutivoPorPeriodo = 0
					SELECT @Periodo = NULL

				IF @ConsecutivoPorEjercicio = 0
					SELECT @Ejercicio = NULL

				IF @ConsecutivoPorEmpresa = 'NO'
					SELECT @Empresa = NULL
				ELSE

				IF @ConsecutivoPorEmpresa = 'GRUPO'
					SELECT @Empresa = Clave
					FROM EmpresaGrupo WITH(NOLOCK)
						,Empresa
					WHERE EmpresaGrupo.Grupo = Empresa.Grupo
					AND Empresa.Empresa = @Empresa

				IF @ConsecutivoSucursalEsp = 1
					AND @SucursalEsp IS NOT NULL
					SELECT @Sucursal = @SucursalEsp

				IF @Modulo = 'CONT'
					UPDATE ContC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'VTAS'
					UPDATE VentaC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'PROD'
					UPDATE ProdC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'COMS'
					UPDATE CompraC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'INV'
					UPDATE InvC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'CXC'
					UPDATE CxcC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'CXP'
					UPDATE CxpC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'AGENT'
					UPDATE AgentC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'GAS'
					UPDATE GastoC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'DIN'
					UPDATE DineroC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'EMB'
					UPDATE EmbarqueC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'NOM'
					UPDATE NominaC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'RH'
					UPDATE RHC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'ASIS'
					UPDATE AsisteC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'AF'
					UPDATE ActivoFijoC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'PC'
					UPDATE PCC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'OFER'
					UPDATE OfertaC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'VALE'
					UPDATE ValeC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'CR'
					UPDATE CRC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'ST'
					UPDATE SoporteC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'CAP'
					UPDATE CapitalC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'INC'
					UPDATE IncidenciaC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'CONC'
					UPDATE ConciliacionC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'PPTO'
					UPDATE PresupC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'CREDI'
					UPDATE CreditoC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'TMA'
					UPDATE TMAC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'RSS'
					UPDATE RSSC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'CMP'
					UPDATE CampanaC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'FIS'
					UPDATE FiscalC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'CONTP'
					UPDATE ContParalelaC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'OPORT'
					UPDATE OportunidadC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'CORTE'
					UPDATE CorteC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'FRM'
					UPDATE FormaExtraC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'CAPT'
					UPDATE CapturaC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'GES'
					UPDATE GestionC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'CP'
					UPDATE CPC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'PCP'
					UPDATE PCPC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'PROY'
					UPDATE ProyectoC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'ORG'
					UPDATE OrganizaC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'RE'
					UPDATE ReclutaC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'ISL'
					UPDATE ISLC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'CAM'
					UPDATE CambioC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'PACTO'
					UPDATE ContratoC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'SAUX'
					UPDATE SAUXC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo
				ELSE

				IF @Modulo = 'PREV'
					UPDATE PrevencionLDC WITH(ROWLOCK)
					SET Consecutivo = Consecutivo + 1
					WHERE Sucursal = @Sucursal
					AND Empresa = @Empresa
					AND Mov = @Mov
					AND Serie = @Serie
					AND Ejercicio = @Ejercicio
					AND Periodo = @Periodo

				IF @@ERROR <> 0
					SELECT @Ok = 1

				EXEC spConsecutivoUltimo @Sucursal
										,@Empresa
										,@Modulo
										,@Mov
										,@Ejercicio
										,@Periodo
										,@Serie
										,@Consecutivo OUTPUT
										,@Ok OUTPUT

				IF NULLIF(@Consecutivo, 0) = NULL
					AND @Ok IS NULL
				BEGIN

					IF @Modulo = 'CONT'
						INSERT INTO ContC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'VTAS'
						INSERT INTO VentaC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'PROD'
						INSERT INTO ProdC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'COMS'
						INSERT INTO CompraC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'INV'
						INSERT INTO InvC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'CXC'
						INSERT INTO CxcC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'CXP'
						INSERT INTO CxpC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'AGENT'
						INSERT INTO AgentC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'GAS'
						INSERT INTO GastoC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'DIN'
						INSERT INTO DineroC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'EMB'
						INSERT INTO EmbarqueC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'NOM'
						INSERT INTO NominaC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'RH'
						INSERT INTO RHC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'ASIS'
						INSERT INTO AsisteC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'AF'
						INSERT INTO ActivoFijoC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'PC'
						INSERT INTO PCC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'OFER'
						INSERT INTO OfertaC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'VALE'
						INSERT INTO ValeC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'CR'
						INSERT INTO CRC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'ST'
						INSERT INTO SoporteC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'CAP'
						INSERT INTO CapitalC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'INC'
						INSERT INTO IncidenciaC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'CONC'
						INSERT INTO ConciliacionC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'PPTO'
						INSERT INTO PresupC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'CREDI'
						INSERT INTO CreditoC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'TMA'
						INSERT INTO TMAC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'RSS'
						INSERT INTO RSSC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'CMP'
						INSERT INTO CampanaC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'FIS'
						INSERT INTO FiscalC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'CONTP'
						INSERT INTO ContParalelaC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'OPORT'
						INSERT INTO OportunidadC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'CORTE'
						INSERT INTO CorteC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'FRM'
						INSERT INTO FormaExtraC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'CAPT'
						INSERT INTO CapturaC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'GES'
						INSERT INTO GestionC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'CP'
						INSERT INTO CPC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'PCP'
						INSERT INTO PCPC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'PROY'
						INSERT INTO ProyectoC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'ORG'
						INSERT INTO OrganizaC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'RE'
						INSERT INTO ReclutaC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'ISL'
						INSERT INTO ISLC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'CAM'
						INSERT INTO CambioC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'PACTO'
						INSERT INTO ContratoC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'SAUX'
						INSERT INTO SAUXC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)
					ELSE

					IF @Modulo = 'PREV'
						INSERT INTO PrevencionLDC (Sucursal, Empresa, Mov, Serie, Ejercicio, Periodo, Consecutivo)
							VALUES (@Sucursal, @Empresa, @Mov, @Serie, @Ejercicio, @Periodo, 1)

					IF @@ERROR <> 0
						SELECT @Ok = 1

					SELECT @Consecutivo = 1
				END

				SELECT @MovID = dbo.fnConsecutivoEnMovID(@Sucursal, @Empresa, @Modulo, @Mov, @Ejercicio, @Periodo, @Serie, @Consecutivo)

				IF @SubFoliosOrigen = 1
				BEGIN
					SELECT @MovID = ISNULL(@Serie, '') + @MovID
				END
				ELSE

				IF @ConsecutivoSerial = 1
				BEGIN
					SELECT @Serie = LTRIM(RTRIM(@Serie))

					IF @Serie IS NOT NULL
						AND dbo.fnEsNumerico(@Serie) = 1
					BEGIN
						EXEC spLlenarCeros @MovID
										  ,@ConsecutivoDigitos
										  ,@MovIDSt OUTPUT
						SELECT @MovID = CONVERT(INT, LTRIM(RTRIM(@Serie)) + RTRIM(LTRIM(@MovIDSt)))
					END

				END

			END

		END

	END

	RETURN
END
GO