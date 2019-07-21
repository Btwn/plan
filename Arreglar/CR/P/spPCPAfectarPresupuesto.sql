SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPCPAfectarPresupuesto
@Empresa		varchar(5),
@Modulo			varchar(5),
@Accion			varchar(20),
@Usuario		varchar(10),
@Fecha			datetime,
@MovTipo		varchar(20),
@ID				int,
@Proyecto		varchar(50),
@Categoria		varchar(1),
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@EstructuraID						int,
@EstructuraAprobadaID				int,
@MovEstructuraAprobada				varchar(20),
@IDGenerar							int,
@IDAplica							int
IF @Accion IN ('AFECTAR') AND @MovTipo IN ('PCP.P')
BEGIN
SELECT @MovEstructuraAprobada = PCPEstructuraAprobada FROM EmpresaCfgMovPCP WHERE Empresa = @Empresa
SELECT
@IDAplica = ID
FROM PCP p JOIN MovTipo mt
ON mt.Mov = p.Mov AND mt.Modulo = @Modulo
WHERE mt.Clave = 'PCP.PP'
AND p.Estatus = 'PENDIENTE'
AND p.Proyecto = @Proyecto
DECLARE crPCP CURSOR FOR
SELECT ID
FROM PCP p JOIN MovTipo mt
ON mt.Mov = p.Mov AND mt.Modulo = @Modulo
WHERE mt.Clave = 'PCP.E'
AND p.Estatus IN ('PENDIENTE')
AND p.Proyecto = @Proyecto
OPEN crPCP
FETCH NEXT FROM crPCP INTO @EstructuraID
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
EXEC @IDGenerar = spAfectar @Modulo, @EstructuraID, 'GENERAR', 'TODO', @MovEstructuraAprobada, @Usuario, NULL, 1, @Ok OUTPUT, @OkRef OUTPUT, @Fecha, 1
IF @IDGenerar IS NOT NULL AND @Ok IS NOT NULL
EXEC spAfectar @Modulo, @IDGenerar, @Accion, 'TODO', NULL, @Usuario, NULL, 1, @Ok OUTPUT, @OkRef OUTPUT, @Fecha, 1
IF @IDGenerar IS NOT NULL AND @Ok IS NULL
UPDATE PCP SET PresupuestoID = @ID WHERE ID = @IDGenerar
IF @@ERROR <> 0 SET @Ok = 1
FETCH NEXT FROM crPCP INTO @EstructuraID
END
CLOSE crPCP
DEALLOCATE crPCP
IF @Ok IS NULL
EXEC spMovEstatus 'PCP', 'CONCLUIDO', @IDAplica, 0, NULL, 0, @Ok OUTPUT
END ELSE
IF @Accion IN ('CANCELAR') AND @MovTipo IN ('PCP.P')
BEGIN
SELECT
@IDAplica = ID
FROM PCP p JOIN MovTipo mt
ON mt.Mov = p.Mov AND mt.Modulo = @Modulo
WHERE mt.Clave = 'PCP.PP'
AND p.Estatus = 'CONCLUIDO'
AND p.Proyecto = @Proyecto
DECLARE crPCP CURSOR FOR
SELECT
p.ID
FROM PCP p JOIN MovTipo mt
ON mt.Mov = p.Mov AND mt.Modulo = @Modulo
WHERE mt.Clave = 'PCP.EA'
AND p.Estatus = 'CONCLUIDO'
AND p.PresupuestoID = @ID
OPEN crPCP
FETCH NEXT FROM crPCP INTO @EstructuraAprobadaID
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
EXEC spAfectar @Modulo, @EstructuraAprobadaID, @Accion, 'TODO', NULL, @Usuario, NULL, 1, @Ok OUTPUT, @OkRef OUTPUT, @Fecha, 1
FETCH NEXT FROM crPCP INTO @EstructuraAprobadaID
END
CLOSE crPCP
DEALLOCATE crPCP
IF @Ok IS NULL
EXEC spMovEstatus 'PCP', 'PENDIENTE', @IDAplica, 0, NULL, 0, @Ok OUTPUT
END
END

