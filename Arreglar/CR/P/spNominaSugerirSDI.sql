SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNominaSugerirSDI
@Accion			char(20),
@Sucursal			int,
@Empresa	      		char(5),
@FechaEmision      		datetime,
@Proyecto	      		varchar(50),
@Usuario	      		char(10),
@Modulo	      		char(5),
@Mov	  	      		char(20),
@MovID             		varchar(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaRegistro		datetime,
@Ok                		int          OUTPUT,
@OkRef             		varchar(255) OUTPUT

AS BEGIN
DECLARE
@RHID		int,
@RHMov		char(20),
@RHMovID		varchar(20),
@IDGenerar		int,
@ConsecutivoPorPeriodo	bit,
@ConsecutivoPorEjercicio	bit,
@ConsecutivoPorEmpresa	char(20),
@ConsecutivoSucursalEsp	bit,
@Ejercicio			int,
@Periodo			int
SELECT @ConsecutivoPorPeriodo   = ConsecutivoPorPeriodo,
@ConsecutivoPorEjercicio = ConsecutivoPorEjercicio,
@ConsecutivoPorEmpresa   = ISNULL(UPPER(ConsecutivoPorEmpresa), 'SI'),
@ConsecutivoSucursalEsp  = ISNULL(ConsecutivoSucursalEsp, 0)
FROM MovTipo
WHERE Modulo = 'NOM'
AND Mov    = @Mov
SELECT @Ejercicio = YEAR(@FechaRegistro), @Periodo = MONTH(@FechaRegistro)
SELECT @RHMov = RHModificaciones
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
IF @Accion = 'CANCELAR'
BEGIN
SELECT @RHID = NULL
SELECT @RHID = MIN(ID) FROM RH WHERE Mov = @RHMov AND OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND Periodo   = CASE WHEN @ConsecutivoPorPeriodo   = 1    THEN @Periodo   ELSE Periodo   END
AND Ejercicio = CASE WHEN @ConsecutivoPorEjercicio = 1    THEN @Ejercicio ELSE Ejercicio END
AND Empresa   = CASE WHEN @ConsecutivoPorEmpresa   = 'SI' THEN @Empresa   ELSE Empresa  END
AND Sucursal  = CASE WHEN @ConsecutivoSucursalEsp  = 1    THEN @Sucursal  ELSE Sucursal END
IF @RHID IS NOT NULL
EXEC spRH @RHID, 'RH', @Accion, 'TODO', @FechaRegistro, NULL, @Usuario, 0, 0, @RHMov, @RHMovID OUTPUT, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
END ELSE
BEGIN
IF NOT EXISTS(SELECT * FROM #SDI s, Personal p WHERE s.Personal = p.Personal AND s.SDI <> p.SDI) RETURN
INSERT RH (Sucursal, SucursalOrigen, Empresa,  Mov,    FechaEmision,  Proyecto,  Usuario,  Moneda,     TipoCambio,     OrigenTipo, Origen, OrigenID, Estatus)
VALUES (@Sucursal, @Sucursal,     @Empresa, @RHMov, @FechaEmision, @Proyecto, @Usuario, @MovMoneda, @MovTipoCambio, @Modulo,    @Mov,   @MovID,   'CONFIRMAR')
SELECT @RHID = SCOPE_IDENTITY()
INSERT RHD (ID,    Renglon,   Personal,   SueldoDiario,   SDI,   TipoContrato,   VencimientoContrato,   PeriodoTipo,   Jornada,   TipoSueldo,   Puesto,   Departamento,   Categoria,   Grupo,   SucursalTrabajo,   CentroCostos,   FechaAlta,   FechaAntiguedad, Plaza,ReportaA)
SELECT      @RHID, s.Renglon, p.Personal, p.SueldoDiario, s.SDI, p.TipoContrato, p.VencimientoContrato, p.PeriodoTipo, p.Jornada, p.TipoSueldo, p.Puesto, p.Departamento, p.Categoria, p.Grupo, p.SucursalTrabajo, p.CentroCostos, p.FechaAlta, p.FechaAntiguedad, p. Plaza,p.ReportaA
FROM #SDI s, Personal p
WHERE s.Personal = p.Personal AND s.SDI <> p.SDI
SELECT @Ok = 80030, @OkRef = ISNULL(@OkRef, '') + '<BR>- Modificaciones al SDI, en Recursos Humanos (por Confirmar)'
END
RETURN
END

