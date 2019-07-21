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
	FROM EmpresaCfgModulo  WITH (NOLOCK)
	WHERE Empresa = @Empresa
	AND Modulo = @Modulo

	IF NULLIF(@CfgFechaEmision, '') IS NULL
		AND @Modulo NOT IN ('NOM', 'RH', 'ASIS', 'ST', 'RE')
		SELECT @CfgFechaEmision = 'SERVIDOR'

	IF @Modulo = 'VTAS'
	BEGIN

		IF (
				SELECT OrigenTipo
				FROM Venta  WITH (NOLOCK)
				WHERE ID = @ID
			)
			= 'POS'
			SELECT @CfgFechaEmision = 'CLIENTE'

	END

	IF @Modulo = 'DIN'
	BEGIN

		IF (
				SELECT OrigenTipo
				FROM Dinero  WITH (NOLOCK)
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
				FROM Inv  WITH (NOLOCK)
				WHERE Id = @ID
			ELSE

			IF @Modulo = 'GAS'
				SELECT @Mov = Mov
				FROM Gasto  WITH (NOLOCK)
				WHERE Id = @ID
			ELSE

			IF @Modulo = 'CXC'
				SELECT @Mov = Mov
				FROM CXC  WITH (NOLOCK)
				WHERE Id = @ID

			IF @Modulo = 'CONT'
				UPDATE Cont  WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'VTAS'
				UPDATE Venta  WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'PROD'
				UPDATE Prod WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'COMS'
				UPDATE Compra WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'INV'
				UPDATE Inv WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
				AND @Mov <> 'Estadistica'
			ELSE

			IF @Modulo = 'CXC'
				UPDATE Cxc WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
				AND @Mov <> 'Estadistica'
			ELSE

			IF @Modulo = 'CXP'
				UPDATE Cxp WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'AGENT'
				UPDATE Agent WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'GAS'
				UPDATE Gasto WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
				AND @Mov <> 'Estadistica'
			ELSE

			IF @Modulo = 'DIN'
				UPDATE Dinero WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'EMB'
				UPDATE Embarque WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'NOM'
				UPDATE Nomina WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'RH'
				UPDATE RH WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'ASIS'
				UPDATE Asiste WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'AF'
				UPDATE ActivoFijo WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'PC'
				UPDATE PC WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'OFER'
				UPDATE Oferta WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'VALE'
				UPDATE Vale WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CR'
				UPDATE CR WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'ST'
				UPDATE Soporte WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CAP'
				UPDATE Capital WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'INC'
				UPDATE Incidencia WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CONC'
				UPDATE Conciliacion WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'PPTO'
				UPDATE Presup WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CREDI'
				UPDATE Credito WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'TMA'
				UPDATE TMA WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'RSS'
				UPDATE RSS WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CMP'
				UPDATE Campana WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'FIS'
				UPDATE Fiscal WITH (ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CONTP'
				UPDATE ContParalela WITH(ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'OPORT'
				UPDATE Oportunidad WITH(ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CORTE'
				UPDATE Corte WITH(ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'FRM'
				UPDATE FormaExtra WITH(ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CAPT'
				UPDATE Captura WITH(ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'GES'
				UPDATE Gestion WITH(ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CP'
				UPDATE CP WITH(ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'PCP'
				UPDATE PCP WITH(ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'PROY'
				UPDATE Proyecto WITH(ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'ORG'
				UPDATE Organiza WITH(ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'RE'
				UPDATE Recluta WITH(ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'ISL'
				UPDATE ISL WITH(ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'CAM'
				UPDATE Cambio WITH(ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'PACTO'
				UPDATE Contrato WITH(ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID
			ELSE

			IF @Modulo = 'SAUX'
				UPDATE SAUX WITH(ROWLOCK)
				SET FechaEmision = @FechaEmision
				WHERE ID = @ID

		END

	END

	SELECT @FechaAfectacion = @FechaEmision
END

