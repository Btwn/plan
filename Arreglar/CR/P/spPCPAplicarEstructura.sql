SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPCPAplicarEstructura
@Empresa	varchar(5),
@Accion		varchar(20),
@ID			int,
@Ok			int = NULL OUTPUT,
@OkRef		varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Aplica				varchar(20),
@AplicaID			varchar(20),
@CatalogoTipoTipo	varchar(50),
@EstatusNuevo		varchar(15),
@EstatusAnterior	varchar(15),
@IDAplica			int
SET @EstatusNuevo    = CASE WHEN @Accion = 'AFECTAR' THEN 'CONCLUIDO' ELSE 'PENDIENTE' END
SET @EstatusAnterior = CASE WHEN @Accion = 'AFECTAR' THEN 'PENDIENTE' ELSE 'CONCLUIDO' END
DECLARE crPCPD CURSOR FOR
SELECT Aplica, AplicaID, CatalogoTipoTipo
FROM PCPD
WHERE ID = @ID
ORDER BY Aplica, AplicaID, CatalogoTipoTipo
OPEN crPCPD
FETCH NEXT FROM crPCPD INTO @Aplica, @AplicaID, @CatalogoTipoTipo
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @IDAplica = ID FROM PCP WHERE Mov = @Aplica AND MovID = @AplicaID AND Empresa = @Empresa
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
UPDATE PCPD SET Estatus = @EstatusNuevo WHERE ID = @IDAplica AND CatalogoTipoTipo = @CatalogoTipoTipo
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL AND @Accion = 'AFECTAR' AND NOT EXISTS(SELECT * FROM PCPD JOIN PCP ON PCP.ID = PCPD.ID WHERE PCP.ID = @IDAplica AND PCPD.Estatus = @EstatusAnterior AND PCP.Estatus = @EstatusAnterior)
EXEC spMovEstatus 'PCP', @EstatusNuevo, @IDAplica, 0, NULL, 0, @Ok OUTPUT
IF @Ok IS NULL AND @Accion = 'CANCELAR' AND EXISTS(SELECT * FROM PCPD JOIN PCP ON PCP.ID = PCPD.ID WHERE PCP.ID = @IDAplica AND PCPD.Estatus = @EstatusNuevo AND PCP.Estatus = @EstatusAnterior)
EXEC spMovEstatus 'PCP', @EstatusNuevo, @IDAplica, 0, NULL, 0, @Ok OUTPUT
FETCH NEXT FROM crPCPD INTO @Aplica, @AplicaID, @CatalogoTipoTipo
END
CLOSE crPCPD
DEALLOCATE crPCPD
END

