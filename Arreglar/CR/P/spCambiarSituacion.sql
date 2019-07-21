SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spCambiarSituacion]
 @Modulo CHAR(5)
,@ID INT
,@Situacion CHAR(50)
,@SituacionFecha DATETIME
,@Usuario CHAR(10)
,@SituacionUsuario VARCHAR(10) = NULL
,@SituacionNota VARCHAR(100) = NULL
AS
BEGIN
	SET NOCOUNT ON
	DECLARE
		@FechaComenzo DATETIME
	BEGIN TRANSACTION

	IF @Modulo = 'CONT'
		UPDATE Cont
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'VTAS'
		UPDATE Venta
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'PROD'
		UPDATE Prod
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'COMS'
		UPDATE Compra
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'INV'
		UPDATE Inv
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CXC'
		UPDATE Cxc
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CXP'
		UPDATE Cxp
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'AGENT'
		UPDATE Agent
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'GAS'
		UPDATE Gasto
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'DIN'
		UPDATE Dinero
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'EMB'
		UPDATE Embarque
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'NOM'
		UPDATE Nomina
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'RH'
		UPDATE RH
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'ASIS'
		UPDATE Asiste
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'AF'
		UPDATE ActivoFijo
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'PC'
		UPDATE PC
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'OFER'
		UPDATE Oferta
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'VALE'
		UPDATE Vale
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CR'
		UPDATE CR
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'ST'
		UPDATE Soporte
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CAP'
		UPDATE Capital
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'INC'
		UPDATE Incidencia
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CONC'
		UPDATE Conciliacion
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'PPTO'
		UPDATE Presup
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CREDI'
		UPDATE Credito
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'WMS'
		UPDATE WMS
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'RSS'
		UPDATE RSS
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CMP'
		UPDATE Campana
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'FIS'
		UPDATE Fiscal
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'FRM'
		UPDATE FormaExtra
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'PROY'
		UPDATE Proyecto
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CAM'
		UPDATE Cambio
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID

	SELECT @FechaComenzo = NULL
	SELECT @FechaComenzo = MAX(FechaComenzo)
	FROM MovTiempo
	WHERE Modulo = @Modulo
	AND ID = @ID
	AND Situacion = @Situacion

	IF @FechaComenzo IS NOT NULL
		UPDATE MovTiempo
		SET Usuario = @Usuario
		WHERE Modulo = @Modulo
		AND ID = @ID
		AND FechaComenzo = @FechaComenzo
		AND Situacion = @Situacion

	COMMIT TRANSACTION
	RETURN
	SET NOCOUNT OFF
END

