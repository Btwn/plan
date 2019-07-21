SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNominaVerificar
@ID               		int,
@Accion			char(20),
@Empresa          		char(5),
@Usuario			char(10),
@Modulo	      		char(5),
@Mov              		char(20),
@MovID			varchar(20),
@MovTipo	      		char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@Condicion			varchar(50),
@PeriodoTipo		varchar(50),
@MovFechaD			datetime,
@MovFechaA			datetime,
@FechaEmision		datetime,
@Estatus			char(15),
@UsaImporte			bit,
@UsaCantidad		bit,
@UsaPorcentaje		bit,
@UsaMonto			bit,
@UsaFechas			bit,
@CfgValidarReferencias	bit,
@MovIncapacidades		varchar(20),
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@CfgContX			bit,
@CfgContXGenerar		char(20),
@GenerarPoliza		bit,
@Ok               		int          OUTPUT,
@OkRef            		varchar(255) OUTPUT

AS BEGIN
DECLARE
@NomModulo  		char(5),
@Movimiento 		char(20),
@Personal			char(10),
@PersonalEmpresa		varchar(5),
@PersonalEstatus		char(15),
@PersonalMoneda		char(10),
@PersonalPeriodoTipo	varchar(50),
@PersonalUltimoPago		datetime,
@Cuenta			char(10),
@Importe			money,
@Saldo			money,
@Cantidad			money,
@Porcentaje			money,
@Monto			money,
@FechaD			datetime,
@FechaA			datetime,
@Referencia			varchar(50),
@ValidarFechas		bit,
@InterfazAspel              bit,
@InterfazAspelNOI           bit,
@NOI                        bit,
@Concepto                   varchar(50)
SELECT @InterfazAspel = ISNULL(InterfazAspel,0),@InterfazAspelNOI = ISNULL(InterfazAspelNOI,0)
FROM EmpresaGral WHERE Empresa = @Empresa
SELECT @NOI = ISNULL(NOI,0) FROM Nomina WHERE ID = @ID
SELECT @ValidarFechas = 0
IF @Accion IN ('CANCELAR', 'DESAFECTAR') AND @Ok IS NULL
BEGIN
IF @Estatus = 'PROCESAR'
BEGIN
IF @MovTipo IN ('NOM.P', 'NOM.PI', 'NOM.D', 'NOM.PD', 'NOM.C', 'NOM.CH', 'NOM.CD', 'NOM.CDH', 'NOM.VT')
BEGIN
IF @MovTipo IN ('NOM.P', 'NOM.PI', 'NOM.D', 'NOM.PD')
BEGIN
IF EXISTS(SELECT * FROM NominaD WHERE ID = @ID AND ISNULL(Importe, 0)<>ISNULL(Saldo, 0)) SELECT @Ok = 60081
END ELSE
BEGIN
IF EXISTS(SELECT * FROM NominaD WHERE ID = @ID AND ISNULL(Cantidad, 0)<>ISNULL(CantidadPendiente, 0)) SELECT @Ok = 60081
END
IF @CfgContX = 1 AND @CfgContXGenerar <> 'NO' AND @GenerarPoliza = 0 SELECT @Ok = 60200
END ELSE SELECT @Ok = 60040
END
IF @Conexion = 0 AND @MovTipo <> 'NOM.CH'
IF EXISTS (SELECT * FROM MovFlujo WHERE Cancelado = 0 AND Empresa = @Empresa AND DModulo = @Modulo AND DID = @ID AND OModulo <> DModulo)
IF @Accion = 'DESAFECTAR' SELECT @Ok = 60075 ELSE SELECT @Ok = 60070
IF @Conexion = 0 AND @MovTipo = 'NOM.CH'
IF EXISTS (SELECT * FROM MovFlujo WHERE Cancelado = 0 AND Empresa = @Empresa AND OModulo = @Modulo AND OID = @ID AND OModulo <> DModulo)
IF @Accion = 'DESAFECTAR' SELECT @Ok = 60075 ELSE SELECT @Ok = 60070
END
IF @MovTipo IN ('NOM.N', 'NOM.NE') AND @Accion = 'AFECTAR'
IF EXISTS (SELECT * FROM Nomina n JOIN NominaCorrespondeLote c ON n.ID = c.ID WHERE n.Estatus = 'CANCELADO' AND c.IDNomina = @ID)
SELECT @Ok = 30690, @OkRef = (SELECT TOP 1 RTRIM(n.Mov)+' '+RTRIM(n.MovID) FROM Nomina n JOIN NominaCorrespondeLote c ON n.ID = c.ID WHERE n.Estatus = 'CANCELADO' AND c.IDNomina = @ID)
IF @MovTipo = 'NOM.N' AND @PeriodoTipo IS NULL SELECT @Ok = 55140
IF EXISTS(SELECT * FROM NominaValidarFecha WHERE Mov = @Mov) SELECT @ValidarFechas = 1
IF @MovTipo = 'NOM.N' AND @Accion = 'AFECTAR' AND @InterfazAspel = 1 AND @InterfazAspelNOI = 1 AND @NOI = 0
SELECT @Ok = 55170
IF @Ok IS NOT NULL RETURN
DECLARE crNominaVerificar CURSOR
FOR SELECT NULLIF(RTRIM(d.Personal), ''), p.Empresa, RTRIM(p.Estatus), RTRIM(p.Moneda), NULLIF(RTRIM(p.PeriodoTipo), ''), ISNULL(d.Importe, 0.0), ISNULL(d.Cantidad, 0.0), ISNULL(d.Porcentaje, 0.0), ISNULL(d.Monto, 0.0), d.FechaD, d.FechaA, NULLIF(RTRIM(d.Modulo), ''), NULLIF(RTRIM(d.Movimiento), ''), NULLIF(RTRIM(d.Cuenta), ''), ISNULL(d.Saldo, 0), NULLIF(RTRIM(d.Referencia), ''),d.Concepto
FROM NominaD d
LEFT OUTER JOIN Personal p ON d.Personal = p.Personal
WHERE ID = @ID
OPEN crNominaVerificar
FETCH NEXT FROM crNominaVerificar INTO @Personal, @PersonalEmpresa, @PersonalEstatus, @PersonalMoneda, @PersonalPeriodoTipo, @Importe, @Cantidad, @Porcentaje, @Monto, @FechaD, @FechaA, @NomModulo, @Movimiento, @Cuenta, @Saldo, @Referencia, @Concepto
IF @@ERROR <> 0 SELECT @Ok = 1
IF @@FETCH_STATUS = -1 SELECT @Ok = 60010
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF @Empresa <> ISNULL(@PersonalEmpresa, @Empresa) SELECT @Ok = 45050
SELECT @PersonalUltimoPago = NULL
SELECT @PersonalUltimoPago = UltimoPago FROM PersonalUltimoPago WHERE Personal = @Personal AND Mov = @Mov AND Empresa = @Empresa
IF @PersonalUltimoPago IS NULL
SELECT @PersonalUltimoPago = UltimoPago FROM PersonalUltimoPago WHERE Personal = @Personal AND Mov = @Mov AND Empresa = ''
IF @Accion = 'CANCELAR'
BEGIN
IF @MovTipo = 'NOM.N' AND @NomModulo = 'NOM' AND @PersonalUltimoPago <> @MovFechaA SELECT @Ok = 60190
IF @MovTipo = 'NOM.CA' AND @Saldo <> @Importe SELECT @Ok = 60060, @OkRef = @Referencia
END ELSE
BEGIN
IF @MovTipo = 'NOM.N' AND @NomModulo = 'NOM'
BEGIN
IF @PersonalPeriodoTipo <> @PeriodoTipo SELECT @Ok = 55150 ELSE
IF @PersonalPeriodoTipo IS NULL SELECT @Ok = 55140
IF @InterfazAspel = 1 AND @InterfazAspelNOI = 1 AND @NOI = 1 AND NOT EXISTS(SELECT * FROM NominaConcepto WHERE Concepto = @Concepto AND ConceptoNOI = 1 AND ConceptoNOIValidado = 1)
SELECT @Ok =55175,@OkRef = @OkRef +' Concepto ('+ @Concepto+')'
END ELSE
IF @MovTipo IN ('NOM.N', 'NOM.NE', 'NOM.NA', 'NOM.NC')
BEGIN
IF @NomModulo = 'NOM' AND @Personal IS NULL SELECT @Ok = 55100 ELSE
IF @NomModulo = 'CXP' AND @Cuenta   IS NULL SELECT @Ok = 55110 ELSE
IF @NomModulo = 'CXC' AND @Cuenta   IS NULL SELECT @Ok = 55115 ELSE
IF @NomModulo = 'GAS' AND @Cuenta   IS NULL SELECT @Ok = 55110 ELSE
IF @NomModulo = 'DIN' AND @Cuenta   IS NULL SELECT @Ok = 55120 ELSE
IF @NomModulo <> 'DIN' AND @Movimiento IS NULL SELECT @Ok = 55130
END
IF (@MovTipo NOT IN ('NOM.N', 'NOM.NE', 'NOM.NA') OR @NomModulo = 'NOM') AND @MovTipo <> 'NOM.NC' AND @Personal IS NOT NULL AND @PersonalEstatus <> 'ALTA'
BEGIN
IF @PersonalEstatus <> 'BAJA' OR NOT EXISTS(SELECT * FROM NomX WHERE NomMov = @Mov AND AceptaBajas =1 AND Estatus = 'ACTIVA' AND Empresa IN ('(Todas)', @Empresa))
SELECT @Ok = 55020
END
IF @Ok = 55020
EXEC xpOk_55020 @Empresa, @Usuario, @Accion, @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NOT NULL AND @OkRef IS NULL
SELECT @OkRef = 'Persona - '+ISNULL(RTRIM(@Personal), '')+', Importe - '+LTRIM(CONVERT(char, @Importe))
IF @MovTipo = 'NOM.N' AND @NomModulo = 'NOM' AND (@PersonalUltimoPago BETWEEN @MovFechaD AND @MovFechaA OR @PersonalUltimoPago > @MovFechaD)
BEGIN
IF (SELECT Top 1 PeriodoTipo FROM Nomina n JOIN NominaD d ON n.Id = d.ID WHERE Empresa = @Empresa AND Personal = @Personal AND n.Estatus ='CONCLUIDO' AND n.Mov = @Mov AND n.ID < @ID ORDER BY n.ID DESC) = @PeriodoTipo
SELECT @Ok = 55160
END ELSE
IF @MovTipo = 'NOM.DP'
BEGIN
IF NOT EXISTS(SELECT *
FROM Nomina n, NominaD d, MovTipo mt
WHERE n.ID = d.ID AND mt.Modulo = @Modulo AND mt.Mov = n.Mov AND mt.Clave IN ('NOM.PD', 'NOM.PI')
AND n.Empresa = @Empresa AND n.Estatus IN ('PENDIENTE', 'PROCESAR', 'VIGENTE') AND d.Personal = @Personal AND d.FechaD = @FechaD AND NULLIF(Saldo, 0) IS NOT NULL)
SELECT @Ok = 30620
END
IF @UsaImporte    = 1 AND @Importe    <= 0 AND @MovTipo NOT IN ('NOM.VA', 'NOM.VT') AND @Conexion = 0 SELECT @Ok = 55050
IF @UsaCantidad   = 1 AND @Cantidad   < 0  AND @MovTipo NOT IN ('NOM.VA', 'NOM.VT') SELECT @Ok = 55060
IF @UsaPorcentaje = 1 AND @Porcentaje < 0 SELECT @Ok = 55070
IF @UsaMonto      = 1 AND @Monto      < 0 SELECT @Ok = 55080
IF @UsaFechas     = 1 AND (@FechaD IS NULL OR @FechaA IS NULL) SELECT @Ok = 55090
IF @ValidarFechas = 1 AND @Accion IN ('AFECTAR', 'VERIFICAR')
BEGIN
SELECT @FechaA = DATEADD(day, @Cantidad-1, @FechaD)
IF EXISTS(SELECT *
FROM Nomina n, NominaD d, NominaValidarFecha v
WHERE n.Empresa = @Empresa AND n.Estatus IN ('PROCESAR', 'VIGENTE') AND n.Mov = v.Mov
AND d.ID = n.ID AND d.Personal = @Personal AND (d.FechaD BETWEEN @FechaD AND @FechaA OR DATEADD(day, d.Cantidad-1, d.FechaD) BETWEEN @FechaD AND @FechaA OR @FechaD BETWEEN d.FechaD AND DATEADD(day, d.Cantidad-1, d.FechaD) OR @FechaA BETWEEN d.FechaD AND DATEADD(day, d.Cantidad-1, d.FechaD)))
SELECT @Ok = 10190
END
IF @Referencia IS NOT NULL AND @CfgValidarReferencias = 1 AND @Mov = @MovIncapacidades AND @Accion IN ('AFECTAR', 'VERIFICAR')
BEGIN
IF EXISTS(SELECT *
FROM Nomina n, NominaD d
WHERE n.Empresa = @Empresa AND Mov = @Mov AND n.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND d.ID = n.ID AND d.Referencia = @Referencia)
SELECT @Ok = 20915, @OkRef = @Referencia
END
END
IF @Ok IS NOT NULL AND @OkRef IS NULL
SELECT @OkRef = 'Persona - '+RTRIM(@Personal)
END
FETCH NEXT FROM crNominaVerificar INTO @Personal, @PersonalEmpresa, @PersonalEstatus, @PersonalMoneda, @PersonalPeriodoTipo, @Importe, @Cantidad, @Porcentaje, @Monto, @FechaD, @FechaA, @NomModulo, @Movimiento, @Cuenta, @Saldo, @Referencia, @Concepto
IF @@ERROR <> 0 SELECT @Ok = 1
END  
CLOSE crNominaVerificar
DEALLOCATE crNominaVerificar
IF @MovTipo IN ('NOM.N', 'NOM.NE', 'NOM.NA') AND @Ok IS NULL
BEGIN
SELECT @OkRef = NULL
SELECT @OkRef = MIN(Personal)
FROM NominaD
WHERE /*Modulo = 'NOM' AND */UPPER(Movimiento) IN ('PERCEPCION', 'DEDUCCION') AND ID = @ID
GROUP BY Personal
HAVING SUM(ISNULL(Importe, 0) * CASE WHEN UPPER(Movimiento)='DEDUCCION' THEN -1 ELSE 1 END) < 0
IF @OkRef IS NOT NULL  SELECT @Ok = 30570
END
IF @Ok IS NULL
EXEC xpNominaVerificar @ID, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@Condicion, @PeriodoTipo, @MovFechaD, @MovFechaA, @FechaEmision, @Estatus,
@UsaImporte, @UsaCantidad, @UsaPorcentaje, @UsaMonto, @UsaFechas,
@CfgValidarReferencias, @MovIncapacidades,
@Conexion, @SincroFinal, @Sucursal,
@CfgContX, @CfgContXGenerar, @GenerarPoliza,
@Ok OUTPUT, @OkRef OUTPUT
RETURN
END

