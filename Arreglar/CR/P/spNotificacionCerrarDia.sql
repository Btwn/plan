SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNotificacionCerrarDia
@Sucursal				int,
@Empresa				varchar(5),
@Usuario				varchar(10),
@Fecha					datetime,
@Ok						int OUTPUT,
@OkRef					varchar(255) OUTPUT,
@Conexion				bit = 1

AS BEGIN
DECLARE
@ID				int,
@Mov				varchar(20),
@IDGenerar		int,
@FechaRegistro	datetime
SET @FechaRegistro = GETDATE()
SELECT @Mov = Notificacion FROM EmpresaCFGMovGES WHERE Empresa = @Empresa
DECLARE crIntelisisService CURSOR FOR
SELECT ID
FROM IntelisisService
WHERE Sistema = 'Intelisis'
AND Contenido = 'Solicitud'
AND Referencia = 'Intelisis.Notificacion'
AND Estatus = 'SINPROCESAR'
OPEN crIntelisisService
FETCH NEXT FROM crIntelisisService INTO @ID
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
EXEC spIntelisisServiceProcesar @ID
FETCH NEXT FROM crIntelisisService INTO @ID
END
CLOSE crIntelisisService
DEALLOCATE crIntelisisService
IF @Ok IS NULL
BEGIN
INSERT Gestion (Empresa,  Mov,  FechaEmision, Sucursal,  Usuario,  Estatus,      FechaRegistro,  Asunto)
VALUES (@Empresa, @Mov, @Fecha,       @Sucursal, @Usuario, 'SINAFECTAR', @FechaRegistro, @Mov)
IF @@ERROR <> 0 SElect @Ok = 1, @OkRef = @Mov
SET @IDGenerar = SCOPE_IDENTITY()
IF @Ok IS NULL
EXEC spAfectar 'GES', @IDGenerar, 'AFECTAR', 'TODO', NULL, @Usuario, NULL, 1, @Ok OUTPUT, @OKRef OUTPUT, @FechaRegistro, @Conexion, @@SPID
END
END

