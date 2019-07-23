SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spIntelisisService]
 @Usuario VARCHAR(10)
,@Contrasena VARCHAR(32)
,@Solicitud VARCHAR(MAX)
,@Resultado VARCHAR(MAX) = NULL OUTPUT
,@Ok INT = NULL OUTPUT
,@OkRef VARCHAR(255) = NULL OUTPUT
,@Procesar BIT = 1
,@EliminarProcesado BIT = 1
,@ID INT = NULL OUTPUT
,@WMS BIT = 0
AS
BEGIN
	DECLARE
		@iSolicitud INT
	   ,@Contenido VARCHAR(100)
	   ,@Sistema VARCHAR(100)
	   ,@Referencia VARCHAR(100)
	   ,@SubReferencia VARCHAR(100)
	   ,@Descripcion VARCHAR(255)
	   ,@Version FLOAT
	   ,@ISDiasResguardoSolicitud INT
	   ,@FechaDepuracion DATETIME
	SELECT @ISDiasResguardoSolicitud = ISDiasResguardoSolicitud
	FROM Version WITH(NOLOCK)

	IF NOT EXISTS (SELECT * FROM Usuario WITH(NOLOCK) WHERE Usuario = @Usuario)
	BEGIN
		SELECT @Ok = 71020
			  ,@OkRef = @Usuario
	END

	IF EXISTS (SELECT * FROM Usuario WITH(NOLOCK) WHERE Usuario = @Usuario AND Contrasena IN (@Contrasena, dbo.fnPassword(UPPER(RTRIM(@Contrasena)))))
	BEGIN
		EXEC sp_xml_preparedocument @iSolicitud OUTPUT
								   ,@Solicitud
		SELECT @Sistema = ISNULL(Sistema, '')
			  ,@Contenido = ISNULL(Contenido, '')
			  ,@Referencia = ISNULL(Referencia, '')
			  ,@SubReferencia = ISNULL(SubReferencia, 0)
			  ,@Version = Version
		FROM OPENXML(@iSolicitud, '/Intelisis', 1)
		WITH (Sistema VARCHAR(100), Contenido VARCHAR(100), Referencia VARCHAR(100), SubReferencia VARCHAR(100), Version FLOAT)
		EXEC sp_xml_removedocument @iSolicitud
		INSERT IntelisisService (Sistema, Contenido, Referencia, SubReferencia, Version, Usuario, Solicitud)
			VALUES (@Sistema, @Contenido, @Referencia, @SubReferencia, @Version, @Usuario, @Solicitud)
		SELECT @ID = SCOPE_IDENTITY()

		IF @Procesar = 1
		BEGIN
			EXEC spIntelisisServiceProcesar @ID
			SELECT @Resultado = Resultado
				  ,@Ok = Ok
				  ,@OkRef = OkRef
			FROM IntelisisService WITH(NOLOCK)
			WHERE ID = @ID

			IF @EliminarProcesado = 1
				DELETE IntelisisService
				WHERE ID = @ID

		END

		SELECT @FechaDepuracion = dbo.fnFechaSinHora(DATEADD(DAY, 0 - (@ISDiasResguardoSolicitud + 1), GETDATE()))
		DELETE FROM IntelisisService
		WHERE Estatus = 'PROCESADO'
			AND FechaEstatus <= @FechaDepuracion
	END
	ELSE

	IF @Ok IS NULL
		AND NOT EXISTS (SELECT * FROM Usuario WITH(NOLOCK) WHERE Usuario = @Usuario AND Contrasena IN (@Contrasena, dbo.fnPassword(UPPER(RTRIM(@Contrasena)))))
		SELECT @Ok = 60230
			  ,@OkRef = @Usuario

	IF @Ok IS NOT NULL
		AND @Ok IN (71020, 60230)
	BEGIN
		SELECT @Descripcion = Descripcion
		FROM MensajeLista WITH(NOLOCK)
		WHERE Mensaje = @Ok
		SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@Referencia, '') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia, '') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(VARCHAR, @Version), '') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(VARCHAR, @ID), '') + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(VARCHAR, @Ok), '') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef, '') + CHAR(34) + ' Descripcion="' + ISNULL(@Descripcion, '') + '"> </Resultado></Intelisis>'
	END

	RETURN
END
GO