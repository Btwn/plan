SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWebService
@Usuario				varchar(10),
@Contrasena				varchar(32),
@Solicitud				varchar(max),
@Procesar				bit = 0,
@EliminarProcesado		bit = 0

AS BEGIN
DECLARE
@Resultado				varchar(max),
@Ok						int,
@OkRef					varchar(255),
@ID						int
EXEC spIntelisisService @Usuario, @Contrasena, @Solicitud, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @Procesar, @EliminarProcesado, @ID OUTPUT
SELECT @Resultado Resultado, @Ok Ok, @OkRef OkRef, @id ID
END

