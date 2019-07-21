SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spConsecutivoMonedero
@Sucursal       int        ,
@Empresa        varchar( 5),
@Modulo         varchar( 5),
@ID             int        ,
@Mov            varchar(20),
@Ejercicio      int          = NULL,
@Periodo        int          = NULL,
@MovIDst        varchar(20)  OUTPUT,
@Ok             int          OUTPUT,
@OkRef          varchar(255) OUTPUT
AS
BEGIN
DECLARE
@Consecutivo    bigint     ,
@MovID          bigint     ,
@Prefijo        char   (10),
@ConsecutivoGen varchar(20)
SELECT @Periodo = NULL, @Ejercicio = NULL, @ConsecutivoGen = NULL, @MovID = CONVERT(bigint, @MovIDSt)
SELECT  @Prefijo = Prefijo
FROM    Sucursal WITH ( NOLOCK )
WHERE   Sucursal = @Sucursal
UPDATE MonederoC  WITH (ROWLOCK) SET Consecutivo = Consecutivo + 1 WHERE Sucursal = @Sucursal AND Empresa = @Empresa AND Mov = @Mov AND Ejercicio = @Ejercicio AND Periodo = @Periodo
IF @@ERROR <> 0 SELECT @Ok = 1
EXEC spConsecutivoMonederoUltimo @Sucursal, @Empresa, @Modulo, @Mov, @Ejercicio, @Periodo, @Consecutivo OUTPUT, @Ok OUTPUT
IF NULLIF(@Consecutivo, 0) = NULL AND @Ok IS NULL
BEGIN
INSERT MonederoC
( Sucursal, Empresa, Mov, Ejercicio, Periodo,Consecutivo)
VALUES (@Sucursal,@Empresa,@Mov,@Ejercicio,@Periodo,1)
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @Consecutivo = 1
END
SELECT @ConsecutivoGen = RTRIM(@Prefijo) + dbo.fnConsecutivoEnMovID(@Sucursal, @Empresa, @Modulo, @Mov, @Ejercicio, @Periodo, NULL, @Consecutivo)
IF @Ok IS NULL
EXEC spMovChecarConsecutivoMonedero @Empresa, @Modulo, @Mov, @ConsecutivoGen, @Ejercicio, @Periodo, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
SELECT @MovIDst = @ConsecutivoGen
END

