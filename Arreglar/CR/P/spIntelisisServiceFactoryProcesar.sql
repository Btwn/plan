SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisServiceFactoryProcesar
@ID        int

AS BEGIN
DECLARE
@Usuario                           varchar(10),
@Estatus                            varchar(15),
@EstatusD         varchar(15),
@Contrasena                   varchar(32),
@Solicitud                         varchar(max),
@Resultado                      varchar(max),
@RID                 int,
@iSolicitud          int ,
@Modulo              varchar(20),
@ModuloID            int
SELECT @Estatus = Estatus, @Usuario = Usuario, @Solicitud = Solicitud
FROM IntelisisServiceFactory
WHERE ID = @ID
IF @Estatus = 'SINPROCESAR'
BEGIN
SELECT @Contrasena = Contrasena FROM Usuario WHERE Usuario = @Usuario
EXEC spIntelisisService @Usuario, @Contrasena, @Solicitud, @Procesar = 1, @ID = @RID OUTPUT, @Resultado = @Resultado OUTPUT, @EliminarProcesado =0
SELECT @EstatusD = Estatus FROM IntelisisService WHERE ID = @RID
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Resultado
SELECT  @Modulo = Modulo, @ModuloID = ModuloID
FROM OPENXML(@iSolicitud, '/Intelisis/Resultado',1)
WITH (Modulo  varchar(100), ModuloID  int)
EXEC sp_xml_removedocument @iSolicitud
UPDATE IntelisisServiceFactory SET RID = @RID , Estatus = @EstatusD,Modulo = @Modulo, ModuloID = @ModuloID
WHERE ID = @ID
END
END

