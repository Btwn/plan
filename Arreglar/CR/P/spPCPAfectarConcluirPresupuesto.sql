SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPCPAfectarConcluirPresupuesto
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
@IDAplica							int
IF @Accion IN ('AFECTAR') AND @MovTipo IN ('PCP.PC')
BEGIN
SELECT
@IDAplica = ID
FROM PCP p JOIN MovTipo mt
ON mt.Mov = p.Mov AND mt.Modulo = @Modulo
WHERE mt.Clave = 'PCP.P'
AND p.Estatus = 'VIGENTE'
AND p.Proyecto = @Proyecto
IF @Ok IS NULL
EXEC spMovEstatus 'PCP', 'CONCLUIDO', @IDAplica, 0, NULL, 0, @Ok OUTPUT
END ELSE
IF @Accion IN ('CANCELAR') AND @MovTipo IN ('PCP.PC')
BEGIN
SELECT
@IDAplica = ID
FROM PCP p JOIN MovTipo mt
ON mt.Mov = p.Mov AND mt.Modulo = @Modulo
WHERE mt.Clave = 'PCP.P'
AND p.Estatus = 'CONCLUIDO'
AND p.Proyecto = @Proyecto
IF @Ok IS NULL
EXEC spMovEstatus 'PCP', 'VIGENTE', @IDAplica, 0, NULL, 0, @Ok OUTPUT
END
END

