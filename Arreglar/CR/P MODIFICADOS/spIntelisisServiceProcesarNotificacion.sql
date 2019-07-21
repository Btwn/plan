SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisServiceProcesarNotificacion
@Sistema       varchar(100),
@ID		  int,
@iSolicitud	  int,
@Solicitud     varchar(max),
@Version	  float,
@Referencia    varchar(100),
@SubReferencia varchar(100),
@Resultado     varchar(max)    OUTPUT,
@Ok		  int		OUTPUT,
@OkRef	  varchar(255)	OUTPUT,
@CambiarEstatus bit          OUTPUT

AS BEGIN
IF @Referencia = 'Intelisis.Notificacion' EXEC spISIntelisisNotificacion @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @CambiarEstatus OUTPUT
RETURN
END

