SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spFechaAfectacion]
 @Empresa CHAR(5)
,@Modulo CHAR(10)
,@ID INT
,@Accion CHAR(20)
,@FechaEmision DATETIME OUTPUT
,@FechaRegistro DATETIME
,@FechaAfectacion DATETIME OUTPUT
AS
BEGIN
	DECLARE
		@CfgFechaEmision VARCHAR(20)
	   ,@FechaNueva DATETIME
	   ,@Estatus VARCHAR(15)
		 ,@Mov VARCHAR(20)
	SELECT @CfgFechaEmision = NULL
	SELECT @CfgFechaEmision = UPPER(FechaEmision)
	FROM EmpresaCfgModulo
	WHERE Empresa = @Empresa
	AND Modulo = @Modulo

	IF NULLIF(@CfgFechaEmision, '') IS NULL
		AND @Modulo NOT IN ('NOM', 'RH', 'ASIS', 'ST', 'RE')
		SELECT @CfgFechaEmision = 'SERVIDOR'

	IF @Modulo = 'VTAS'
	BEGIN

		IF (
				SELECT OrigenTipo
				FROM Venta
				WHERE ID = @ID
			)
			= 'POS'
			SELECT @CfgFechaEmision = 'CLIENTE'

	END

	IF @Modulo = 'DIN'
	BEGIN

		IF (
				SELECT OrigenTipo
				FROM Dinero
				WHERE ID = @ID
			)
			= 'POS'
			SELECT @CfgFechaEmision = 'CLIENTE'

	END

	IF @CfgFechaEmision = 'SERVIDOR'
		AND @Accion NOT IN ('GENERAR', 'CANCELAR', 'RESERVAR', 'DESRESERVAR', 'RESERVARPARCIAL', 'ASIGNAR', 'DESASIGNAR')
	BEGIN
		EXEC spMovInfo @ID
					  ,@Modulo
					  ,@Estatus = @Estatus OUTPUT
		SELECT @FechaNueva = @FechaRegistro
		EXEC spExtraerFecha @FechaNueva OUTPUT
		EXEC xpFechaAfectacion @Empresa
							  ,@Modulo
							  ,@ID
							  ,@Accion
							  ,@FechaEmision
							  ,@FechaNueva OUTPUT

		IF @FechaNueva <> @FechaEmision
			AND @Estatus <> 'PENDIENTE'
		BEGIN
			EXEC xpFechaAfectacion @Empresa
								  ,@Modulo
								  ,@ID
								  ,@Accion
								  ,@FechaEmision
								  ,@FechaNueva OUTPUT
			SELECT @FechaEmision = @FechaNueva

			IF @Modulo = 'INV'
				SELECT @Mov = Mov
				FROM Inv
				WHERE Id = @ID
			ELSE

			IF @Modulo = 'GAS'
				SELECT @Mov = Mov
				FROM Gasto
				WHERE Id = @ID
			ELSE

			IF @Modulo = 'CXC'
				SELECT @Mov = Mov
				FROM CXC
				WHERE Id = @ID

			IF @Modulo = 'CONT'
				UPDATE Cont
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'VTAS'
				UPDATE Venta
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'PROD'
				UPDATE Prod
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'COMS'
				UPDATE Compra
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'INV'
				UPDATE Inv
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
				AND @Mov <> 'Estadistica'
			ELSE

			IF @Modulo = 'CXC'
				UPDATE Cxc
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
				AND @Mov <> 'Estadistica'
			ELSE

			IF @Modulo = 'CXP'
				UPDATE Cxp
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'AGENT'
				UPDATE Agent
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'GAS'
				UPDATE Gasto
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
				AND @Mov <> 'Estadistica'
			ELSE

			IF @Modulo = 'DIN'
				UPDATE Dinero
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'EMB'
				UPDATE Embarque
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'NOM'
				UPDATE Nomina
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'RH'
				UPDATE RH
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'ASIS'
				UPDATE Asiste
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'AF'
				UPDATE ActivoFijo
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'PC'
				UPDATE PC
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'OFER'
				UPDATE Oferta
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'VALE'
				UPDATE Vale
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CR'
				UPDATE CR
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'ST'
				UPDATE Soporte
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CAP'
				UPDATE Capital
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'INC'
				UPDATE Incidencia
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CONC'
				UPDATE Conciliacion
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'PPTO'
				UPDATE Presup
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CREDI'
				UPDATE Credito
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'TMA'
				UPDATE TMA
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'RSS'
				UPDATE RSS
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CMP'
				UPDATE Campana
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'FIS'
				UPDATE Fiscal
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CONTP'
				UPDATE ContParalela
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'OPORT'
				UPDATE Oportunidad
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CORTE'
				UPDATE Corte
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'FRM'
				UPDATE FormaExtra
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CAPT'
				UPDATE Captura
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'GES'
				UPDATE Gestion
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CP'
				UPDATE CP
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'PCP'
				UPDATE PCP
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'PROY'
				UPDATE Proyecto
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'ORG'
				UPDATE Organiza
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'RE'
				UPDATE Recluta
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'ISL'
				UPDATE ISL
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CAM'
				UPDATE Cambio
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'PACTO'
				UPDATE Contrato
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'SAUX'
				UPDATE SAUX
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID

		END

	END

	SELECT @FechaAfectacion = @FechaEmision
END

