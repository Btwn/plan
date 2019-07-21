SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spEmpresaValidarFechaAplicacion
@Sucursal					int,
@Accion						char(20),
@Empresa					char(5),
@Modulo						char(5),
@ID							int,
@Mov						char(20),
@MovID						varchar(20),
@Fecha						datetime,
@EjercicioRegistro			int,
@PeriodoRegistro			int,
@Aplica						char(20),
@AplicaID					varchar(20),
@AplicaModulo				varchar(5),
@AplicaModuloID				int,
@FechaAplica				datetime,
@EjercicioAplica			int,
@PeriodoAplica				int,
@Ok							int         OUTPUT,
@OkRef						varchar(255)OUTPUT

AS BEGIN
IF @MovID IS NULL OR @AplicaModulo IS NULL OR @AplicaModuloID IS NULL OR @Aplica IS NULL OR @AplicaID IS NULL RETURN
IF EXISTS(SELECT * FROM EmpresaValidarFechaAplicacion WHERE Empresa = @Empresa AND Modulo = @Modulo AND Mov = @Mov AND AplicaModulo = @AplicaModulo AND AplicaMov = @Aplica)
BEGIN
IF @EjercicioAplica <> @EjercicioRegistro OR @PeriodoAplica <> @PeriodoRegistro
SELECT @Ok = 50056, @OkRef = RTRIM(@Aplica) + ' ' + RTRIM(@AplicaID)
END
RETURN
END

