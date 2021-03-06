SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisServiceProcesarAutorizacion
@Sistema       varchar(100),
@ID		  int,
@iSolicitud	  int,
@Solicitud     varchar(max),
@Version	  float,
@Referencia    varchar(100),
@SubReferencia varchar(100),
@CambiarEstatus bit,
@Resultado     varchar(max)    OUTPUT,
@Ok		  int		OUTPUT,
@OkRef	  varchar(255)	OUTPUT

AS BEGIN
IF @Referencia = 'Intelisis.Autorizacion' EXEC spISIntelisisAutorizacion @ID, @iSolicitud, @Version, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @CambiarEstatus OUTPUT  ELSE 
RETURN
END

