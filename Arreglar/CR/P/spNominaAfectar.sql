SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spNominaAfectar
@ID                	          int,
@Accion			                  char(20),
@Empresa	      	              char(5),
@Modulo	      	              char(5),
@Mov	        	                char(20),
@MovID             	          varchar(20)	OUTPUT,
@MovTipo     	                char(20),
@MovMoneda			                char(10),
@MovTipoCambio		              float,
@Condicion			                varchar(50),
@PeriodoTipo			              varchar(50),
@MovFechaD			                datetime,
@MovFechaA			                datetime,
@FechaEmision      	          datetime,
@FechaOrigen			              datetime,
@FechaAfectacion               datetime,
@FechaConclusion		            datetime,
@Proyecto	      	            varchar(50),
@Concepto	                    varchar(50),
@Usuario	                      char(10),
@Autorizacion                  char(10),
@DocFuente	                    int,
@Observaciones                 varchar(255),
@Estatus                       char(15),
@EstatusNuevo	                char(15),
@FechaRegistro                 datetime,
@Ejercicio	                    int,
@Periodo	                      int,
@UsaImporte			              bit,
@UsaCantidad			              bit,
@UsaPorcentaje		              bit,
@UsaMonto			                bit,
@UsaFechas			                bit,
@Conexion			                bit,
@SincroFinal			              bit,
@Sucursal			                int,
@SucursalDestino		            int,
@SucursalOrigen		            int,
@SugerirAumentoVacaciones	    bit,
@CfgAfectarAumentoVacaciones	  bit,
@CfgConceptoAumentoVacaciones  varchar(50),
@SugerirDisminucionVacaciones    bit,
@CfgAfectarDisminucionVacaciones    bit,
@CfgConceptoDisminucionVacaciones  varchar(50),
@SugerirSDI			              bit,
@CfgConceptoSDI		            varchar(50),
@MovAplicacionNomina		        varchar(20),
@CfgContX			                bit,
@CfgContXGenerar		            char(20),
@GenerarPoliza		              bit,
@GenerarMov			              char(20),
@IDGenerar			                int OUTPUT,
@GenerarMovID	                varchar(20) OUTPUT,
@Ok                	          int OUTPUT,
@OkRef             	          varchar(255) OUTPUT

AS BEGIN
DECLARE
@Renglon			       float,
@Personal			       char(10),
@Importe			       money,
@Impuestos			     money,
@Porcentaje			     float,
@Cantidad			       money,
@FechaD			         datetime,
@FechaA			         datetime,
@Cuenta			         char(10),
@ModuloD			       char(5),
@MovimientoD		     varchar(20),
@ConceptoD			     varchar(50),
@ReferenciaD		     varchar(50),
@FormaPago			     varchar(50),
@ReferenciaActual		 varchar(50),
@DineroMov			     char(20),
@DineroBeneficiario	 varchar(100),
@PersonalUltimoPago	 datetime,
@GastoMov			       char(20),
@GastoMovID			     varchar(20),
@GastoID			       int,
@CxCondicion		     varchar(50),
@SumaPercepciones		 money,
@SumaDeducciones		 money,
@EsCargo			       bit,
@NomXID			         int,
@Clase			         varchar(50),
@SubClase			       varchar(50),
@GastoClase			     varchar(50),
@GastoSubClase		   varchar(50),
@CfgGastoUENDetalle	 bit,
@GastoUEN			       int,
@IncidenciaID		     int,
@Generar			       bit,
@GenerarAfectado		 bit,
@GenerarModulo		   char(5),
@GenerarMovTipo		   char(20),
@GenerarEstatus		   char(15),
@GenerarPeriodo 		 int,
@GenerarEjercicio 	 int,
@FechaCancelacion		 datetime,
@GenerarAccion		   char(20),
@ProcesarIncidencias bit,
@GenerarBaja		     bit,
@DividirCantidades	 bit,
@DineroConcepto		   varchar(50),
@PersonalFechaD		   datetime,
@PersonalFechaA		   datetime,
@Origen              varchar(20),
@NomAuto			       bit,
@NomAutoTipo 		     varchar(50),
@Beneficiario		     varchar(50),
@Valor               varchar(50),
@SucursalTrabajo     int,
@Categoria           varchar(50),
@Puesto              varchar(50),
@UEN                 int,
@CentroCostos		varchar(20)	,
@FechaInicioV datetime,
@PersonalAnt		varchar(10)
SELECT @Generar = 0,
@GenerarAfectado = 0,
@IDGenerar = NULL,
@GenerarModulo = NULL,
@GenerarMovID = NULL,
@GenerarMovTipo = NULL,
@GenerarEstatus = 'SINAFECTAR',
@SumaPercepciones = 0.0,
@SumaDeducciones = 0.0
SELECT @NomXID = MIN(ID) FROM NomX WHERE NomMov = @Mov AND Estatus = 'ACTIVA' AND Empresa IN ('(Todas)', @Empresa)
SELECT @GastoClase = GastoClase,
@GastoSubClase = GastoSubClase
FROM NomX
WHERE ID = @NomXID
EXEC spMovConsecutivo @Sucursal, @SucursalOrigen, @SucursalDestino, @Empresa, @Usuario, @Modulo, @Ejercicio, @Periodo, @ID, @Mov, NULL, @Estatus, @Concepto, @Accion, @Conexion, @SincroFinal, @MovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') AND @Accion <> 'CANCELAR' AND @Ok IS NULL
EXEC spMovChecarConsecutivo	@Empresa, @Modulo, @Mov, @MovID, NULL, @Ejercicio, @Periodo, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion IN ('CONSECUTIVO', 'SINCRO') AND @Ok IS NULL
BEGIN
IF @Accion = 'SINCRO' EXEC spAsignarSucursalEstatus @ID, @Modulo, @SucursalDestino, @Accion
SELECT @Ok = 80060, @OkRef = @MovID
RETURN
END
IF @OK IS NOT NULL RETURN
IF @SugerirAumentoVacaciones = 1 AND @Accion <> 'CANCELAR'
CREATE TABLE #AumentoVacaciones (Renglon float NULL, Personal char(10) NULL, Cantidad float NULL)
IF @SugerirDisminucionVacaciones = 1 AND @Accion <> 'CANCELAR'
CREATE TABLE #DisminucionVacaciones (Renglon float NULL, Personal char(10) NULL, Cantidad float NULL, FechaD datetime NULL)
IF @SugerirSDI = 1 AND @Accion <> 'CANCELAR'
CREATE TABLE #SDI (Renglon float NULL, Personal char(10) NULL, SDI money NULL)
IF @Accion = 'GENERAR' AND @Ok IS NULL
BEGIN
EXEC spMovGenerar @Sucursal, @Empresa, @Modulo, @Ejercicio, @Periodo, @Usuario, @FechaRegistro, @GenerarEstatus,
NULL, NULL,
@Mov, @MovID, 0,
@GenerarMov, NULL, @GenerarMovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spMovTipo @Modulo, @GenerarMov, @FechaAfectacion, @Empresa, NULL, NULL, @GenerarMovTipo OUTPUT, @GenerarPeriodo OUTPUT, @GenerarEjercicio OUTPUT, @Ok OUTPUT
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Ok IS NULL SELECT @Ok = 80030
RETURN
END
IF @OK IS NOT NULL RETURN
SELECT @ProcesarIncidencias = NomProcesarIncidencias,
@GenerarBaja = NomGenerarBaja,
@DividirCantidades = NomDividirCantidades,
@NomAuto = ISNULL(NomAuto, 0),
@NomAutoTipo = NomAutoTipo
FROM MovTipo
WHERE Modulo = @Modulo AND Mov = @Mov
IF @Conexion = 0
BEGIN TRANSACTION
EXEC spMovEstatus @Modulo, 'AFECTANDO', @ID, @Generar, @IDGenerar, @GenerarAfectado, @Ok OUTPUT
IF @Accion = 'AFECTAR' AND @Estatus IN ('SINAFECTAR', 'CONFIRMAR')
IF (SELECT Sincro FROM Version) = 1
UPDATE NominaD SET Sucursal = @Sucursal WHERE ID = @ID AND (Sucursal <> @Sucursal )
IF @Accion <> 'CANCELAR'
EXEC spRegistrarMovimiento @Sucursal, @Empresa, @Modulo, @Mov, @MovID, @ID, @Ejercicio, @Periodo, @FechaRegistro, @FechaEmision,
NULL, @Proyecto, @MovMoneda, @MovTipoCambio,
@Usuario, @Autorizacion, NULL, @DocFuente, @Observaciones,
@Generar, @GenerarMov, @GenerarMovID, @IDGenerar,
@Ok OUTPUT
IF @EstatusNuevo = 'PROCESAR' AND @MovTipo IN ('NOM.CD', 'NOM.CDH', 'NOM.VT') AND @DividirCantidades = 1
EXEC spNominaDividirCantidad @Empresa, @ID, @FechaEmision, @MovTipo
IF @GenerarBaja = 1 AND @Accion <> 'CANCELAR'
EXEC spNominaBajaVacaciones @Accion, @Sucursal, @Empresa, @FechaOrigen, @Proyecto, @Usuario, @Modulo,
@ID, @Mov, @MovID, @MovMoneda, @MovTipoCambio, @FechaRegistro,
@Ok OUTPUT, @OkRef OUTPUT
SELECT @ReferenciaActual = RTRIM(@Mov)+' '+LTRIM(CONVERT(char, @MovID))
IF @Accion = 'DESAFECTAR'
EXEC spMovDesafectar @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
ELSE BEGIN
DECLARE crNomina CURSOR
FOR SELECT d.Renglon, NULLIF(RTRIM(d.Personal), ''), ISNULL(d.Importe, 0.0), ISNULL(d.Cantidad, 0.0), d.FechaD, d.FechaA,
NULLIF(RTRIM(d.Cuenta), ''), NULLIF(RTRIM(d.Modulo), ''), NULLIF(RTRIM(d.Movimiento), ''), NULLIF(RTRIM(d.Concepto), ''), NULLIF(RTRIM(d.Referencia), ''), NULLIF(RTRIM(d.FormaPago), ''), d.Porcentaje, d.IncidenciaID
FROM NominaD d
WHERE ID = @ID
OPEN crNomina
FETCH NEXT FROM crNomina INTO @Renglon, @Personal, @Importe, @Cantidad, @FechaD, @FechaA,
@Cuenta, @ModuloD, @MovimientoD, @ConceptoD, @ReferenciaD, @FormaPago, @Porcentaje, @IncidenciaID
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF @MovTipo = 'NOM.DP' AND @Personal IS NOT NULL
EXEC spNominaDevolucionPrestamo @Sucursal, @ID, @Accion, @Empresa, @Personal, @FechaD, @Importe, @Ok OUTPUT, @OkRef OUTPUT
IF @NomAuto = 0 AND @Accion <> 'CANCELAR' AND @ModuloD = 'NOM' AND @ReferenciaD IS NOT NULL AND @MovTipo IN ('NOM.N', 'NOM.NE', 'NOM.NC') AND @Personal IS NOT NULL AND UPPER(@MovimientoD) IN ('PERCEPCION', 'DEDUCCION')
BEGIN
/*IF EXISTS (SELECT * FROM Nomina n, MovTipo mt WHERE Empresa = @Empresa AND RTRIM(Mov)+' '+RTRIM(MovID) = @ReferenciaD AND Estatus = 'PENDIENTE' AND mt.Modulo = 'NOM' AND mt.Clave = 'NOM.CA' AND mt.Mov = n.Mov)
BEGIN*/
IF UPPER(@MovimientoD) IN ('DEDUCCION', 'PERCEPCION')
EXEC spNominaMatarReferencia @Sucursal, @ID, @Accion, @Empresa, @Personal, @ReferenciaD, @Importe, @Ok OUTPUT, @OkRef OUTPUT
ELSE SELECT @Ok = 55370, @OkRef = @ReferenciaD
/*END*/
END
IF @MovTipo IN ('NOM.N', 'NOM.NE', 'NOM.NA', 'NOM.NC')
BEGIN
IF @Personal IS NOT NULL
BEGIN
IF @SugerirSDI = 1 AND @Accion <> 'CANCELAR' AND UPPER(@ConceptoD) = UPPER(@CfgConceptoSDI)
INSERT #SDI (Renglon, Personal, SDI) VALUES (@Renglon, @Personal, @Importe)
IF @SugerirAumentoVacaciones = 1 AND @Accion <> 'CANCELAR' AND UPPER(@ConceptoD) = UPPER(@CfgConceptoAumentoVacaciones)
INSERT #AumentoVacaciones (Renglon, Personal, Cantidad) VALUES (@Renglon, @Personal, @Cantidad)
IF @SugerirDisminucionVacaciones = 1 AND @Accion <> 'CANCELAR' AND UPPER(@ConceptoD) = UPPER(@CfgConceptoDisminucionVacaciones)
BEGIN
INSERT #DisminucionVacaciones (Renglon, Personal, Cantidad, FechaD) VALUES (@Renglon, @Personal, @Cantidad, @MovFechaD)
END
END
IF @IncidenciaID IS NOT NULL AND (@Cantidad <> 0.0 OR @Importe <> 0.0)
EXEC spNominaMatarIncidencia @Empresa, @Sucursal, @Modulo, @ID, @Mov, @MovID, @MovTipo, @Accion, @Cantidad, @Importe, @MovTipoCambio, @IncidenciaID, @NomAutoTipo, @Ok OUTPUT, @OkRef OUTPUT
END
IF @MovTipo IN ('NOM.VA', 'NOM.VT')
BEGIN
IF @MovTipo = 'NOM.VA' SELECT @EsCargo = 1 ELSE SELECT @EsCargo = 0
IF @Accion = 'CANCELAR' SELECT @EsCargo = ~@EsCargo
EXEC spSaldo @Sucursal, @Accion, @Empresa, @Usuario, 'VAC', @MovMoneda, @MovTipoCambio, @Personal, NULL, NULL, NULL,
@Modulo, @ID, @Mov, @MovID, @EsCargo, NULL, @Cantidad, NULL,
@FechaAfectacion, @Ejercicio, @Periodo, @Mov, @MovID, 0, 0, 0,
@Ok OUTPUT, @OkRef OUTPUT
END
IF @MovTipo IN ('NOM.C', 'NOM.CH', 'NOM.CD', 'NOM.CDH', 'NOM.VT')
UPDATE NominaD
SET CantidadPendiente = CASE @Accion WHEN 'CANCELAR' THEN NULL ELSE @Cantidad END
WHERE CURRENT OF crNomina
ELSE
IF @MovTipo IN ('NOM.P', 'NOM.PD', 'NOM.PI', 'NOM.D', 'NOM.CA')
UPDATE NominaD
SET CantidadPendiente = CASE WHEN @UsaCantidad = 0 THEN NULL WHEN @Accion = 'CANCELAR' THEN NULL ELSE @Cantidad END,
Saldo = CASE WHEN UPPER(@Condicion) = 'REPETIR' THEN @Importe * @Cantidad
WHEN UPPER(@Condicion) IN ('REPETIR SIEMPRE', 'REPETIR FECHAS', '% SUELDO') THEN NULL
WHEN @UsaCantidad = 1 AND UPPER(@Condicion) <> 'PRORRATEAR' THEN NULL
WHEN @Accion = 'CANCELAR' THEN NULL ELSE @Importe END
WHERE CURRENT OF crNomina
IF @MovTipo IN ('NOM.N', 'NOM.NE', 'NOM.NA', 'NOM.NC') AND @ModuloD = 'CXC' AND @ReferenciaD IS NOT NULL
EXEC spNominaAfectarCxc @ID, @Accion, @Empresa, @Sucursal, @Usuario, @FechaRegistro, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio, @MovAplicacionNomina, @Cuenta, @ReferenciaD, @Importe, @Ok OUTPUT, @OkRef OUTPUT
IF UPPER(@MovimientoD) = 'PERCEPCION' SELECT @SumaPercepciones = @SumaPercepciones + @Importe ELSE
IF UPPER(@MovimientoD) = 'DEDUCCION'  SELECT @SumaDeducciones  = @SumaDeducciones  + @Importe
EXEC xpNominaAfectarDetalle @ID, @Accion, @Empresa, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@Condicion, @PeriodoTipo, @MovFechaD, @MovFechaA, @FechaEmision, @FechaOrigen, @FechaAfectacion, @FechaConclusion,
@Usuario, @Estatus, @EstatusNuevo, @FechaRegistro, @Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen,
@Renglon, @Personal, @Importe, @Cantidad, @Ok OUTPUT, @OkRef OUTPUT
END
FETCH NEXT FROM crNomina INTO @Renglon, @Personal, @Importe, @Cantidad, @FechaD, @FechaA,
@Cuenta, @ModuloD, @MovimientoD, @ConceptoD, @ReferenciaD, @FormaPago, @Porcentaje, @IncidenciaID
IF @@ERROR <> 0 SELECT @Ok = 1
END  
CLOSE crNomina
DEALLOCATE crNomina
END
IF @NomAuto = 0 AND @Accion = 'CANCELAR'
EXEC spNominaMatarReferenciaCancelar @Sucursal, @ID, @Accion, @Empresa, @Ok OUTPUT, @OkRef OUTPUT
IF @MovTipo IN ('NOM.N', 'NOM.NE', 'NOM.NA', 'NOM.NC')
BEGIN
DECLARE crNominaCx CURSOR FOR
SELECT Personal.UEN, NominaD.Modulo, NominaD.Cuenta, NominaD.Concepto, NominaD.FechaA, NominaD.Porcentaje, SUM(NominaD.Importe), NominaD.Beneficiario
FROM NominaD
LEFT OUTER JOIN  Personal on Personal.Personal= Nominad.Personal
WHERE NominaD.ID = @ID AND (NominaD.Modulo = 'CXP' OR (NominaD.Modulo = 'CXC' AND NULLIF(RTRIM(NominaD.Referencia), '') IS NULL))
GROUP BY Personal.UEN, NominaD.Modulo, NominaD.Cuenta, NominaD.Concepto, NominaD.FechaA, NominaD.Porcentaje, NominaD.Beneficiario
ORDER BY Personal.UEN, NominaD.Modulo, NominaD.Cuenta, NominaD.Concepto, NominaD.FechaA, NominaD.Porcentaje, NominaD.Beneficiario
OPEN crNominaCx
FETCH NEXT FROM crNominaCx INTO @UEN, @ModuloD, @Cuenta, @ConceptoD, @FechaA, @Porcentaje, @Importe, @Beneficiario
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF @FechaA IS NOT NULL SELECT @CxCondicion = '(Fecha)' ELSE SELECT @CxCondicion = NULL
SELECT @Impuestos = @Importe * (NULLIF(@Porcentaje, 0.0)/100.0)
EXEC spGenerarCx @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, NULL, @Empresa, @Modulo,
@ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaEmision,  @ConceptoD, @Proyecto, @Usuario, @Autorizacion,
@ReferenciaActual, @DocFuente, @Beneficiario, @FechaRegistro, @Ejercicio, @Periodo,
@CxCondicion, @FechaA, @Cuenta, NULL, NULL, NULL, NULL, NULL,
@Importe, @Impuestos, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, NULL,
@GenerarModulo OUTPUT, @GenerarMov OUTPUT, @GenerarMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT,
@ModuloEspecifico = @ModuloD
/*if @GenerarModulo = 'CXP'
BEGIN
IF @UEN in('1','3')
UPDATE CXP set NOTA ='FIDE',  UEN = @UEN, Proyecto ='AC-1-08'   WHERE MOV = @GenerarMov AND MOVID = @GenerarMovID
IF @UEN in('2','4','5')
UPDATE CXP set NOTA ='PFAEE', UEN = @UEN, Proyecto ='PFAEE-08'   WHERE MOV = @GenerarMov AND MOVID = @GenerarMovID
END    */
END
FETCH NEXT FROM crNominaCx INTO @UEN, @ModuloD, @Cuenta, @ConceptoD, @FechaA, @Porcentaje, @Importe, @Beneficiario
END  
CLOSE crNominaCx
DEALLOCATE crNominaCx
END
IF @MovTipo IN ('NOM.N', 'NOM.NE', 'NOM.NA', 'NOM.NC', 'NOM.PI', 'NOM.DP')
BEGIN
IF @MovTipo IN ('NOM.PI', 'NOM.DP')
BEGIN
DECLARE crNominaDinero CURSOR FOR
SELECT ISNULL(nc.ModuloMov, d.Movimiento), d.Cuenta, NULLIF(RTRIM(d.Personal), ''), NULLIF(RTRIM(d.Beneficiario), ''), SUM(d.Importe), @Concepto
FROM NominaD d
LEFT OUTER JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto
WHERE d.ID = @ID
GROUP BY ISNULL(nc.ModuloMov, d.Movimiento), d.Cuenta, d.Personal, d.Beneficiario
END ELSE
BEGIN
DECLARE crNominaDinero CURSOR FOR
SELECT ISNULL(nc.ModuloMov, d.Movimiento), d.Cuenta, NULLIF(RTRIM(d.Personal), ''), NULLIF(RTRIM(d.Beneficiario), ''), SUM(Importe), d.Concepto
FROM NominaD d
LEFT OUTER JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto
WHERE d.ID = @ID AND d.Modulo = 'DIN'
GROUP BY ISNULL(nc.ModuloMov, d.Movimiento), d.Cuenta, d.Personal, d.Beneficiario, d.Concepto
END
OPEN crNominaDinero
FETCH NEXT FROM crNominaDinero INTO @DineroMov, @Cuenta, @Personal, @DineroBeneficiario, @Importe, @DineroConcepto
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF @DineroBeneficiario IS NULL AND @Personal IS NOT NULL
SELECT @DineroBeneficiario = ApellidoPaterno +' '+ ApellidoMaterno +' '+ Nombre FROM Personal WHERE Personal = @Personal
EXEC spGenerarDinero @Sucursal, @SucursalOrigen, @SucursalDestino, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaEmision, @DineroConcepto, @Proyecto, @Usuario, @Autorizacion, @ReferenciaActual, @DocFuente, @Observaciones, 1, 0,
@FechaRegistro, @Ejercicio, @Periodo,
NULL, NULL, NULL,
NULL, @Cuenta, NULL, @Importe, NULL,
@DineroMov, @DineroBeneficiario, NULL,
@GenerarMov OUTPUT, @GenerarMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT,
@ContactoEspecifico = @Personal
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
END
FETCH NEXT FROM crNominaDinero INTO @DineroMov, @Cuenta, @Personal, @DineroBeneficiario, @Importe, @DineroConcepto
IF @@ERROR <> 0 SELECT @Ok = 1
END  
CLOSE crNominaDinero
DEALLOCATE crNominaDinero
END
IF @MovTipo IN ('NOM.N', 'NOM.NE', 'NOM.NA', 'NOM.NC')
BEGIN
IF @Accion = 'CANCELAR'
BEGIN
DECLARE crNominaGasto CURSOR FOR
SELECT g.ID, g.Mov, g.MovID
FROM Gasto g
JOIN MovFlujo mf ON mf.Empresa = @Empresa AND mf.OModulo = @Modulo AND mf.OID = @ID AND mf.DModulo = 'GAS' AND mf.DID = g.ID
WHERE g.Empresa = @Empresa AND g.OrigenTipo = @Modulo AND g.Origen = @Mov AND g.OrigenID = @MovID AND g.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
OPEN crNominaGasto
FETCH NEXT FROM crNominaGasto INTO @GastoID, @GastoMov, @GastoMovID
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
EXEC spGasto @GastoID, 'GAS', @Accion, 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, @GastoMov, @GastoMovID OUTPUT, @GastoID, @Ok OUTPUT, @OkRef OUTPUT
FETCH NEXT FROM crNominaGasto INTO @GastoID, @GastoMov, @GastoMovID
END  
CLOSE crNominaGasto
DEALLOCATE crNominaGasto
END ELSE
BEGIN
SELECT @CfgGastoUENDetalle = GastoUENDetalle FROM EmpresaCfg2 WHERE Empresa = @Empresa
IF @CfgGastoUENDetalle = 1
DECLARE crNominaGasto CURSOR FOR
SELECT CASE when nc.GenerarEstadisticaGas = 1 then 'ESTADISTICA' else  ISNULL(nc.ModuloMov, d.Movimiento) END,
d.Referencia, d.Cuenta, d.FechaA, d.UEN, Personal.CentroCostos
FROM NominaD d
LEFT OUTER JOIN PERSONAL ON D.PERSONAL=PERSONAL.PERSONAL
LEFT OUTER JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto
WHERE d.ID = @ID AND (d.Modulo = 'GAS' or nc.GenerarEstadisticaGas = 1)
GROUP BY ISNULL(nc.ModuloMov, d.Movimiento),nc.GenerarEstadisticaGas,
d.Referencia, d.Cuenta, d.FechaA, d.UEN, Personal.CentroCostos
ELSE
DECLARE crNominaGasto CURSOR FOR
SELECT ISNULL(nc.ModuloMov, d.Movimiento), d.Referencia, d.Cuenta, d.FechaA, CONVERT(int, NULL), Personal.CentroCostos
FROM NominaD d
LEFT OUTER JOIN PERSONAL ON D.PERSONAL=PERSONAL.PERSONAL
LEFT OUTER JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto
WHERE d.ID = @ID AND (d.Modulo = 'GAS' OR nc.GenerarEstadisticaGas = 1)
GROUP BY ISNULL(nc.ModuloMov, d.Movimiento), d.Referencia, d.Cuenta, d.FechaA, Personal.CentroCostos
OPEN crNominaGasto
FETCH NEXT FROM crNominaGasto INTO @GastoMov, @ReferenciaD, @Cuenta, @FechaA, @GastoUEN, @CentroCostos
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @Clase = @GastoClase, @SubClase = @GastoSubClase
EXEC xpNominaGastoClase @ID, @GastoMov, @ReferenciaD, @Cuenta, @FechaA, @GastoUEN, @Clase OUTPUT, @SubClase OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
INSERT Gasto (UltimoCambio, Sucursal,  SucursalOrigen, SucursalDestino, UEN,       OrigenTipo,  Origen,  OrigenID,  Empresa,  Usuario,  Estatus,      Mov,       Acreedor, FechaEmision, Moneda, TipoCambio, Observaciones, Condicion, Vencimiento, Clase,  SubClase,  fecharequerida)
SELECT GETDATE(),     @Sucursal, @Sucursal,      @Sucursal,       @GastoUEN, @Modulo,     Mov,     MovID,     @Empresa, @Usuario, 'SINAFECTAR', @GastoMov, @Cuenta,  FechaEmision, Moneda, TipoCambio, Observaciones, '(Fecha)', @FechaA,     @Clase, @SubClase, fechaemision
FROM Nomina
WHERE ID = @ID
SELECT @GastoID = SCOPE_IDENTITY()
EXEC spNominaAfectarGasto @ID, @GastoID, @GastoMov, @Cuenta, @FechaA, @CfgGastoUENDetalle, @GastoUEN, @Centrocostos, @NomAuto
IF @GastoID IS NOT NULL AND @Ok IS NULL
BEGIN
EXEC spGasto @GastoID, 'GAS', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, @GastoMov, @GastoMovID OUTPUT, @GastoID, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'GAS', @GastoID, @GastoMov, @GastoMovID, @Ok OUTPUT
END
END
FETCH NEXT FROM crNominaGasto INTO @GastoMov, @ReferenciaD, @Cuenta, @FechaA, @GastoUEN, @CentroCostos
IF @@ERROR <> 0 SELECT @Ok = 1
END  
CLOSE crNominaGasto
DEALLOCATE crNominaGasto
END
END
IF @MovTipo IN ('NOM.N', 'NOM.NA', 'NOM.NE', 'NOM.NC') AND @EstatusNuevo = 'CONCLUIDO'
BEGIN
SELECT  TOP 1 @SucursalTrabajo=SucursalTrabajo,@Personal=Personal.Personal,@Categoria=Categoria, @Puesto=Puesto
FROM  Personal
JOIN  NominaD ON NominaD.Personal=Personal.Personal
WHERE  NominaD.ID =  @ID
EXEC spPersonalPropValor      @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'REGISTRO PATRONAL',
@Valor OUTPUT
DELETE NominaPersonal WHERE ID = @ID
DELETE NominaPersonalProy WHERE ID = @ID
INSERT NominaPersonal
(
ID, Personal, SucursalTrabajo, CentroCostos, Actividad, UEN, Puesto, FormaPago, Proyecto, UltimoPago, Sucursal, SucursalOrigen, SucursalDestino,
SueldoDiario, SDIEstaNomina, Departamento, Categoria, Grupo, Jornada, TipoContrato, TipoSueldo, ZonaEconomica,
RegistroPatronal,FechaAntiguedad, Estado
)
SELECT DISTINCT d.ID, p.Personal, p.SucursalTrabajo, p.CentroCostos, p.Actividad, p.UEN, p.Puesto, p.FormaPago, p.Proyecto, p.UltimoPago, @Sucursal, @SucursalOrigen, @SucursalDestino,
p.SueldoDiario, p.SDI, p.Departamento, p.Categoria, p.Grupo, p.Jornada, p.TipoContrato, p.TipoSueldo,  p.ZonaEconomica,
@Valor,p.FechaAntiguedad, p.Estado
FROM NominaD d, Personal p
WHERE d.ID = @ID AND d.Personal = p.Personal
SELECT @PersonalAnt = ''
WHILE(1=1)
BEGIN
SELECT @Personal = MIN(Personal)
FROM NominaD
WHERE NominaD.ID =  @ID
AND NominaD.Personal > @PersonalAnt
IF @Personal IS NULL BREAK
SELECT @PersonalAnt = @Personal
SELECT @SucursalTrabajo = SucursalTrabajo, @Categoria = Categoria, @Puesto = Puesto
FROM Personal
JOIN NominaD ON NominaD.Personal=Personal.Personal
WHERE NominaD.ID =  @ID
AND Personal.Personal = @Personal
SELECT @Valor = NULL
EXEC spPersonalPropValor @Empresa, @SucursalTrabajo, @Categoria, @Puesto, @Personal, 'REGISTRO PATRONAL', @Valor OUTPUT
UPDATE NominaPersonal
SET RegistroPatronal = @Valor
FROM NominaPersonal n
JOIN Personal p ON n.Personal = p.Personal
WHERE n.ID = @ID
AND n.Personal = @Personal
END
INSERT NominaPersonalProy (ID, Personal, Proyecto, Sucursal, SucursalOrigen, SucursalDestino)
SELECT d.ID, p.Personal, yd.Proyecto, @Sucursal, @SucursalOrigen, @SucursalDestino
FROM NominaD d, Personal p, ProyD yd, Proy y
WHERE d.ID = @ID AND d.Personal = p.Personal
AND yd.Personal = p.Personal
AND y.Proyecto = yd.Proyecto AND y.Estatus = 'ALTA'
GROUP BY d.ID, p.Personal, yd.Proyecto
END
IF @MovTipo IN ('NOM.N', 'NOM.NE', 'NOM.NA', 'NOM.NC') AND @Ok IS NULL
BEGIN
DECLARE crNominaPersonal CURSOR
FOR SELECT DISTINCT RTRIM(Personal)
FROM NominaD
WHERE ID = @ID AND NULLIF(RTRIM(Personal), '') IS NOT NULL
OPEN crNominaPersonal
FETCH NEXT FROM crNominaPersonal INTO @Personal
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @PersonalFechaD = @MovFechaD,
@PersonalFechaA = @MovFechaA
SELECT @PersonalFechaD = ISNULL(FechaD, @MovFechaD),
@PersonalFechaA = ISNULL(FechaA, @MovFechaA)
FROM NominaPersonalFecha
WHERE ID = @ID AND Personal = @Personal
EXEC spNominaMatarCorresponde @Sucursal, @Accion, @Modulo, @Empresa, @ID, @Mov, @MovID, @MovTipo, @Personal, @PersonalFechaD, @PersonalFechaA, @GenerarBaja, @ProcesarIncidencias, @Ok OUTPUT, @OkRef OUTPUT
IF @MovTipo IN ('NOM.N', 'NOM.NC')
BEGIN
SELECT @PersonalUltimoPago = NULL
IF (@MovTipo = 'NOM.N' AND @Accion = 'CANCELAR') OR (@MovTipo = 'NOM.NC' AND @Accion <> 'CANCELAR')
BEGIN
Declare @OrigenN Varchar(20), @OrigenIDN Int
IF @Mov = 'Cancelacion Parcial' AND @Accion = 'AFECTAR'
BEGIN
Select @OrigenN = Origen, @OrigenIDN = OrigenID From nomina Where id = @ID
Select @PersonalUltimoPago = UltimoPago From NominaPersonal NP JOIN  Nomina N ON N.ID=NP.ID Where Mov = @OrigenN AND MovID = @OrigenIDN
END
ELSE
SELECT @PersonalUltimoPago = UltimoPago FROM NominaPersonal WHERE ID = @ID AND Personal = @Personal
END
ELSE
SELECT @PersonalUltimoPago = @PersonalFechaA
UPDATE Personal SET UltimoPago = @PersonalUltimoPago WHERE Personal = @Personal
UPDATE PersonalUltimoPago SET UltimoPago = @PersonalUltimoPago WHERE Personal = @Personal AND Mov = @Mov AND Empresa = @Empresa
IF @@ROWCOUNT = 0
INSERT PersonalUltimoPago (Personal, Mov, Empresa, UltimoPago) VALUES (@Personal, @Mov, @Empresa, @PersonalUltimoPago)
IF (@MovTipo = 'NOM.NC' AND @Accion <> 'CANCELAR')
BEGIN
/*  Código agregado para el bug 24341  */
DECLARE @OrigenID varchar(20), @FechaUP datetime, @Persona varchar(10)
SELECT @Origen = Origen, @OrigenID = OrigenID FROM Nomina WHERE ID = @ID
SELECT @FechaUP = FechaD FROM Nomina WHERE Mov = @Origen AND MovID = @OrigenID
SELECT @FechaUP = DATEADD(day, -1, @FechaUP)
SELECT DISTINCT @Persona = ISNULL(Personal, '') FROM NominaD WHERE ID = @ID and ISNULL(Personal, '') <> ''
IF EXISTS (SELECT n.ID, n.Empresa, n.Mov, n.MovID, n.FechaD, n.FechaA
FROM Nomina n
JOIN NominaPersonal np on np.ID = n.ID
WHERE n.Empresa = @Empresa
AND n.Mov = @Origen
AND n.Estatus = 'CONCLUIDO'
AND n.FechaA = @FechaUP
AND np.Personal = @Persona) BEGIN
UPDATE PersonalUltimoPago SET UltimoPago = @FechaUP WHERE Personal = @Personal AND Mov = @Origen AND Empresa = @Empresa
IF @@ROWCOUNT = 0
INSERT PersonalUltimoPago (Personal, Mov, Empresa, UltimoPago) VALUES (@Personal, @Origen, @Empresa, @FechaUP)
UPDATE Personal SET UltimoPago = @FechaUP WHERE Personal = @Personal
END ELSE BEGIN
/*  Código Original antes del cambio para el bug 24341 */
SELECT @Origen = Origen FROM Nomina WHERE ID = @ID
UPDATE PersonalUltimoPago SET UltimoPago = @PersonalUltimoPago WHERE Personal = @Personal AND Mov = @Origen AND Empresa = @Empresa
IF @@ROWCOUNT = 0
INSERT PersonalUltimoPago (Personal, Mov, Empresa, UltimoPago) VALUES (@Personal, @Origen, @Empresa, @PersonalUltimoPago)
END
END
END
END
FETCH NEXT FROM crNominaPersonal INTO @Personal
IF @@ERROR <> 0 SELECT @Ok = 1
END  
CLOSE crNominaPersonal
DEALLOCATE crNominaPersonal
IF @Ok IS NULL AND @MovTipo IN ('NOM.N', 'NOM.E') AND @EstatusNuevo = 'CONCLUIDO'
EXEC spNominaProrrateo @ID, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @MovTipo IN ('NOM.N', 'NOM.NC')
IF (@MovTipo = 'NOM.N' AND @Accion = 'CANCELAR') OR (@MovTipo = 'NOM.NC' AND @Accion <> 'CANCELAR')
BEGIN
UPDATE PeriodoTipo    SET UltimoDiaPagado = DATEADD(day, -1, @MovFechaD) WHERE PeriodoTipo = @PeriodoTipo
UPDATE PeriodoTipoMov SET UltimoDiaPagado = DATEADD(day, -1, @MovFechaD) WHERE PeriodoTipo = @PeriodoTipo AND Mov = @Mov
IF @@ROWCOUNT = 0
INSERT PeriodoTipoMov (PeriodoTipo, Mov, UltimoDiaPagado) VALUES (@PeriodoTipo, @Mov, DATEADD(day, -1, @MovFechaD))
UPDATE PeriodoTipoMovEmpresa SET UltimoDiaPagado = DATEADD(day, -1, @MovFechaD) WHERE PeriodoTipo = @PeriodoTipo AND Mov = @Mov AND Empresa = @Empresa
IF @@ROWCOUNT = 0
INSERT PeriodoTipoMovEmpresa (PeriodoTipo, Mov, Empresa, UltimoDiaPagado) VALUES (@PeriodoTipo, @Mov, @Empresa, DATEADD(day, -1, @MovFechaD))
END ELSE
BEGIN
UPDATE PeriodoTipo    SET UltimoDiaPagado = @MovFechaA WHERE PeriodoTipo = @PeriodoTipo
UPDATE PeriodoTipoMov SET UltimoDiaPagado = @MovFechaA WHERE PeriodoTipo = @PeriodoTipo AND Mov = @Mov
IF @@ROWCOUNT = 0
INSERT PeriodoTipoMov (PeriodoTipo, Mov, UltimoDiaPagado) VALUES (@PeriodoTipo, @Mov, @MovFechaA)
UPDATE PeriodoTipoMovEmpresa SET UltimoDiaPagado = @MovFechaA WHERE PeriodoTipo = @PeriodoTipo AND Mov = @Mov AND Empresa = @Empresa
IF @@ROWCOUNT = 0
INSERT PeriodoTipoMovEmpresa (PeriodoTipo, Mov, Empresa, UltimoDiaPagado) VALUES (@PeriodoTipo, @Mov, @Empresa, @MovFechaA)
END
END
IF @Ok IS NULL
BEGIN
IF @EstatusNuevo = 'CANCELADO' SELECT @FechaCancelacion = @FechaRegistro ELSE SELECT @FechaCancelacion = NULL
IF @EstatusNuevo = 'CONCLUIDO' SELECT @FechaConclusion  = @FechaEmision  ELSE IF @EstatusNuevo <> 'CANCELADO' SELECT @FechaConclusion  = NULL
IF @CfgContX = 1 AND @CfgContXGenerar <> 'NO'
BEGIN
IF @Estatus     IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') AND @EstatusNuevo <> 'CANCELADO' SELECT @GenerarPoliza = 1 ELSE
IF @Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') AND @EstatusNuevo =  'CANCELADO' IF @GenerarPoliza = 1 SELECT @GenerarPoliza = 0 ELSE SELECT @GenerarPoliza = 1
END
EXEC spValidarTareas @Empresa, @Modulo, @ID, @EstatusNuevo, @Ok OUTPUT, @OkRef OUTPUT
UPDATE Nomina
SET FechaConclusion  = @FechaConclusion,
FechaCancelacion = @FechaCancelacion,
FechaA           = CASE WHEN @MovTipo = 'NOM.NA' THEN FechaEmision ELSE FechaA END,
UltimoCambio     = /*CASE WHEN UltimoCambio IS NULL THEN */@FechaRegistro /*ELSE UltimoCambio END*/,
Estatus          = @EstatusNuevo,
Situacion 	      = CASE WHEN @Estatus<>@EstatusNuevo THEN NULL ELSE Situacion END,
Concepto	      = @Concepto,
GenerarPoliza    = @GenerarPoliza,
Percepciones     = @SumaPercepciones,
Deducciones      = @SumaDeducciones
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
/*
IF @MovTipo IN ('NOM.N', 'NOM.NA', 'NOM.NE', 'NOM.NC') AND @EstatusNuevo = 'CONCLUIDO'
BEGIN
DELETE NominaPersonal WHERE ID = @ID
DELETE NominaPersonalProy WHERE ID = @ID
INSERT NominaPersonal (
ID,   Personal,   SucursalTrabajo,   CentroCostos,   Actividad,   UEN,   Puesto,   FormaPago,   Proyecto,   Sucursal,  SucursalOrigen,  SucursalDestino)
SELECT d.ID, p.Personal, p.SucursalTrabajo, p.CentroCostos, p.Actividad, p.UEN, p.Puesto, p.FormaPago, p.Proyecto, @Sucursal, @SucursalOrigen, @SucursalDestino
FROM NominaD d, Personal p
WHERE d.ID = @ID AND d.Personal = p.Personal
GROUP BY d.ID, p.Personal, p.SucursalTrabajo, p.CentroCostos, p.Actividad, p.UEN, p.Puesto, p.FormaPago, p.Proyecto
INSERT NominaPersonalProy (ID, Personal, Proyecto, Sucursal, SucursalOrigen, SucursalDestino)
SELECT d.ID, p.Personal, yd.Proyecto, @Sucursal, @SucursalOrigen, @SucursalDestino
FROM NominaD d, Personal p, ProyD yd, Proy y
WHERE d.ID = @ID AND d.Personal = p.Personal
AND yd.Personal = p.Personal
AND y.Proyecto = yd.Proyecto AND y.Estatus = 'ALTA'
GROUP BY d.ID, p.Personal, yd.Proyecto
END
*/
END
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spMovFinal @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion = 'CANCELAR' AND @EstatusNuevo = 'CANCELADO' AND @Ok IS NULL
EXEC spCancelarFlujo @Empresa, @Modulo, @ID, @Ok OUTPUT
IF @Accion <> 'CANCELAR' AND @Ok IS NULL
BEGIN
IF @SugerirAumentoVacaciones = 1
EXEC spNominaSugerirAumentoVacaciones @Accion, @Sucursal, @Empresa, @FechaOrigen, @Proyecto, @Usuario, @Modulo,
@Mov, @MovID, @MovMoneda, @MovTipoCambio, @FechaRegistro,
@CfgAfectarAumentoVacaciones,
@Ok OUTPUT, @OkRef OUTPUT
IF @SugerirDisminucionVacaciones = 1
EXEC spNominaSugerirDisminucionVacaciones @Accion, @Sucursal, @Empresa, @FechaOrigen, @Proyecto, @Usuario, @Modulo,
@Mov, @MovID, @MovMoneda, @MovTipoCambio, @FechaRegistro,
@CfgAfectarDisminucionVacaciones,
@Ok OUTPUT, @OkRef OUTPUT
IF @SugerirSDI = 1
EXEC spNominaSugerirSDI @Accion, @Sucursal, @Empresa, @FechaOrigen, @Proyecto, @Usuario, @Modulo,
@Mov, @MovID, @MovMoneda, @MovTipoCambio, @FechaRegistro,
@Ok OUTPUT, @OkRef OUTPUT
IF @GenerarBaja = 1
EXEC spNominaGenerarBaja @Accion, @Sucursal, @Empresa, @FechaOrigen, @Proyecto, @Usuario, @Modulo,
@ID, @Mov, @MovID, @MovMoneda, @MovTipoCambio, @FechaRegistro,
@Ok OUTPUT, @OkRef OUTPUT
END
/*
JGD 28Enero2011 y 31Enero2011. Solución Ticket 2743 Y 2789. Se manda llamar a los SP's spNominaSugerirAumentoVacaciones y spNominaSugerirSDI
para Cancelar los Movimientos de Aumento de Vacaciones (NOM) y Modicicaciones (RH), si es que se generarón
*/
IF @Accion = 'CANCELAR' AND @Ok IS NULL
BEGIN
EXEC spNominaCancelar @ID, @Mov, @MovID, @Usuario, @FechaRegistro, @Ok OUTPUT, @OkRef OUTPUT
IF @SugerirAumentoVacaciones = 1
EXEC spNominaSugerirAumentoVacaciones @Accion,@Sucursal,@Empresa,@FechaEmision,@Proyecto,@Usuario,@Modulo,@Mov,@MovID,@MovMoneda,@MovTipoCambio,@FechaRegistro,0,@Ok OUTPUT, @OkRef OUTPUT
IF @SugerirDisminucionVacaciones = 1
EXEC spNominaSugerirDisminucionVacaciones @Accion,@Sucursal,@Empresa,@FechaEmision,@Proyecto,@Usuario,@Modulo,@Mov,@MovID,@MovMoneda,@MovTipoCambio,@FechaRegistro,0,@Ok OUTPUT, @OkRef OUTPUT
IF @SugerirSDI = 1
EXEC spNominaSugerirSDI @Accion,@Sucursal,@Empresa,@FechaEmision,@Proyecto,@Usuario,@Modulo,@Mov,@MovID,@MovMoneda,@MovTipoCambio,@FechaRegistro,@Ok OUTPUT, @OkRef OUTPUT
END
IF @Conexion = 0
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
COMMIT TRANSACTION
ELSE
BEGIN
DECLARE @PolizaDescuadrada TABLE (Cuenta varchar(20) NULL, SubCuenta varchar(50) NULL, Concepto varchar(50) NULL, Debe money NULL, Haber money NULL, SucursalContable int NULL)
IF EXISTS(SELECT * FROM PolizaDescuadrada WHERE Modulo = @Modulo AND ID = @ID)
INSERT @PolizaDescuadrada (Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable) SELECT Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable FROM PolizaDescuadrada WHERE Modulo = @Modulo AND ID = @ID
ROLLBACK TRANSACTION
DELETE PolizaDescuadrada WHERE Modulo = @Modulo AND ID = @ID
INSERT PolizaDescuadrada (Modulo, ID, Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable) SELECT @Modulo, @ID, Cuenta, SubCuenta, Concepto, Debe, Haber, SucursalContable FROM @PolizaDescuadrada
END
RETURN
END

