SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpOk_60110
@Empresa            char(5),
@Usuario            char(10),
@Accion             char(20),
@Modulo             char(5),
@ID                 int,
@ModuloInicial      char(5),
@Ok                 int             OUTPUT,
@OkRef              varchar(255)    OUTPUT
AS BEGIN
DECLARE   @ConcPolizaGenerar   bit
SELECT @ConcPolizaGenerar = ISNULL(ConcPolizaGenerar, 0)
FROM EmpresaCFG2
WHERE Empresa = @Empresa
IF @ConcPolizaGenerar = 1 AND @ModuloInicial = 'CONC'
SELECT @Ok = NULL
RETURN
END

