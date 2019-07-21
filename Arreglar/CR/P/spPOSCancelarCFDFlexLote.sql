SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSCancelarCFDFlexLote
@Estacion           int,
@Empresa            varchar(5),
@Sucursal           int,
@Usuario            varchar(10)

AS
BEGIN
DECLARE
@Modulo					varchar(5),
@ID						int,
@Estatus				varchar(15),
@Ok						int,
@OkRef					varchar(255),
@IDPOS					varchar(50),
@MovNota				varchar(20),
@MovIDNota				varchar(20),
@Prefijo				varchar(5),
@Consecutivo			int,
@noAprobacion			int,
@fechaAprobacion		datetime
SELECT TOP 1 @MovNota = Mov
FROM MovTipo
WHERE Modulo = 'POS' AND Clave = 'POS.N' AND SubClave = 'POS.NPF'
BEGIN TRANSACTION
DECLARE crCFDTemp CURSOR LOCAL FOR
SELECT Empresa, Modulo, ID, Estatus, IDPOS
FROM POSCFDFlexPendiente
WHERE ID IN(SELECT ID FROM LISTAID WHERE Estacion = @Estacion)
OPEN crCFDTemp
FETCH NEXT FROM crCFDTemp INTO @Empresa, @Modulo, @ID, @Estatus,@IDPOS
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
EXEC spAfectar @Modulo, @ID, 'CANCELAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
EXEC spPOSConsecutivoAuto @Empresa, @Sucursal, @MovNota, @MovIDNota OUTPUT, @Prefijo OUTPUT, @Consecutivo OUTPUT,
@noAprobacion OUTPUT, @FechaAprobacion OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
UPDATE POSL SET
Mov = @MovNota,
MovID =  @MovIDNota,
Prefijo = ISNULL(Prefijo, @Prefijo),
Consecutivo = ISNULL(Consecutivo, @Consecutivo),
noAprobacion = ISNULL(noAprobacion, @NoAprobacion),
fechaAprobacion = ISNULL(fechaAprobacion, @fechaAprobacion),
Estatus = 'CONCLUIDO'
WHERE ID = @IDPOS
END
FETCH NEXT FROM crCFDTemp INTO @Empresa, @Modulo, @ID, @Estatus, @IDPOS
END
CLOSE crCFDTemp
DEALLOCATE crCFDTemp
IF @Ok IS NULL
COMMIT TRAN
ELSE
ROLLBACK TRAN
IF @Ok IS NOT NULL
SELECT @OkRef
ELSE
SELECT 'PROCESO CONCLUIDO EXISTOSAMENTE'
RETURN
END

