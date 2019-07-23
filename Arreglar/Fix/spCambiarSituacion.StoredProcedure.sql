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
		UPDATE Cont WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'VTAS'
		UPDATE Venta WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'PROD'
		UPDATE Prod WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'COMS'
		UPDATE Compra WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'INV'
		UPDATE Inv WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CXC'
		UPDATE Cxc WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CXP'
		UPDATE Cxp WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'AGENT'
		UPDATE Agent WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'GAS'
		UPDATE Gasto WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'DIN'
		UPDATE Dinero WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'EMB'
		UPDATE Embarque WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'NOM'
		UPDATE Nomina WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'RH'
		UPDATE RH WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'ASIS'
		UPDATE Asiste WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'AF'
		UPDATE ActivoFijo WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'PC'
		UPDATE PC WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'OFER'
		UPDATE Oferta WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'VALE'
		UPDATE Vale WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CR'
		UPDATE CR WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'ST'
		UPDATE Soporte WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CAP'
		UPDATE Capital WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'INC'
		UPDATE Incidencia WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CONC'
		UPDATE Conciliacion WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'PPTO'
		UPDATE Presup WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CREDI'
		UPDATE Credito WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'WMS'
		UPDATE WMS WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'RSS'
		UPDATE RSS WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CMP'
		UPDATE Campana WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'FIS'
		UPDATE Fiscal WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'FRM'
		UPDATE FormaExtra WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'PROY'
		UPDATE Proyecto WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID
	ELSE

	IF @Modulo = 'CAM'
		UPDATE Cambio WITH(ROWLOCK)
		SET Situacion = NULLIF(RTRIM(@Situacion), '')
		   ,SituacionFecha = @SituacionFecha
		   ,SituacionUsuario = @SituacionUsuario
		   ,SituacionNota = @SituacionNota
		WHERE ID = @ID

	SELECT @FechaComenzo = NULL
	SELECT @FechaComenzo = MAX(FechaComenzo)
	FROM MovTiempo WITH(NOLOCK)
	WHERE Modulo = @Modulo
	AND ID = @ID
	AND Situacion = @Situacion

	IF @FechaComenzo IS NOT NULL
		UPDATE MovTiempo WITH(ROWLOCK)
		SET Usuario = @Usuario
		WHERE Modulo = @Modulo
		AND ID = @ID
		AND FechaComenzo = @FechaComenzo
		AND Situacion = @Situacion

	COMMIT TRANSACTION
	RETURN
	SET NOCOUNT OFF
END
GO