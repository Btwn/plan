SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spValidarFechaAplicacion
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
DECLARE @CfgValidarFechaAplicacion varchar(10)
SELECT @CfgValidarFechaAplicacion = CASE @Modulo
WHEN 'VTAS' THEN VTASValidarFechaAplicacion
WHEN 'COMS' THEN COMSValidarFechaAplicacion
WHEN 'INV'  THEN INVValidarFechaAplicacion
WHEN 'CXC'  THEN CXCValidarFechaAplicacion
WHEN 'CXP'  THEN CXPValidarFechaAplicacion
WHEN 'DIN'  THEN DINValidarFechaAplicacion
WHEN 'GAS'  THEN GASValidarFechaAplicacion
WHEN 'PROD' THEN PRODValidarFechaAplicacion
END
FROM EmpresaCfg2
WHERE Empresa = @Empresa
IF @CfgValidarFechaAplicacion = 'No' OR @MovID IS NULL OR @AplicaModulo IS NULL OR @AplicaModuloID IS NULL OR @Aplica IS NULL OR @AplicaID IS NULL RETURN
IF @CfgValidarFechaAplicacion = 'Fecha'
BEGIN
IF @Fecha < @FechaAplica
SELECT @Ok = 50052, @OkRef = RTRIM(@Aplica) + ' ' + RTRIM(@AplicaID)
END
ELSE IF @CfgValidarFechaAplicacion = 'Periodo'
BEGIN
IF @EjercicioAplica <> @EjercicioRegistro OR @PeriodoAplica > @PeriodoRegistro
SELECT @Ok = 50054, @OkRef = RTRIM(@Aplica) + ' ' + RTRIM(@AplicaID)
END
RETURN
END

