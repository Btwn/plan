SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spNominaGenerarVacacionesPanama
@Estacion	    int,
@ID		        int,
@FechaD		    datetime,
@FechaA		    datetime,
@PeriodoTipo	varchar(20),
@FechaTrabajo	datetime = NULL

AS BEGIN
DECLARE
@Empresa				                char(5),
@RedondeoMonetarios 		        int,
@CfgAjusteMensualISR		        bit,
@CfgSueldoMinimo			          varchar(20),
@CfgTablaVacaciones			        varchar(50),
@CfgSubsidioIncapacidadEG		    bit,
@CfgPrimaDominicalAuto		      bit,
@CfgISRReglamentoAguinaldo		  bit,
@CfgISRReglamentoPTU      		  bit,
@CfgISRLiquidacionSueldoMensual	varchar(50),
@CfgFactorIntegracionAntiguedad	varchar(20),
@CfgFactorIntegracionTabla		  varchar(50),
@CfgFondoAhorroRepartirInteres	varchar(20),
@CfgCajaAhorroRepartirInteres	  varchar(20),
@Sucursal				                int,
@Mov				                    varchar(20),
@NomTipo				                varchar(50),
@NomCalcSDI				              bit,
@NomCxc 				                varchar(20),
@Moneda				                  char(10),
@TipoCambio				              float,
@Personal				                char(10),
@ClaveInterna			              varchar(10),
@Conteo				                  int,
@RepartirDesde			            datetime,
@RepartirHasta			            datetime,
@RepartirImporte			          money,
@RepartirIngresoTope		        money,
@RepartirIngresoTotal		        money,
@RepartirTotalDias			        float,
@RepartirIngresoFactor		      float,
@RepartirDiasFactor			        float,
@Renglon				                float,
@CalendarioEsp			            bit,
@IncidenciaD			              datetime,
@IncidenciaA			              datetime,
@Ok					                    int,
@OkRef				                  varchar(255),
@FechaMaxVacaciones             datetime,
@Dia                            int,
@Mes                            int,
@Ano                            int,
@CuantosMov                     int,
@RamaID                         int
SELECT @RamaID = @ID 
SELECT @RedondeoMonetarios = RedondeoMonetarios FROM Version
SELECT @IncidenciaD = @FechaD, @IncidenciaA = @FechaA
IF @FechaTrabajo IS NULL
BEGIN
SELECT @FechaTrabajo = GETDATE()
EXEC spExtraerFecha @FechaTrabajo OUTPUT
END
SELECT @Conteo = 0, @Ok = NULL, @OkRef = NULL
SELECT @Empresa = n.Empresa, @Sucursal = n.Sucursal, @Mov = n.Mov, @Moneda = n.Moneda, @TipoCambio = n.TipoCambio,
@NomTipo = ISNULL(NULLIF(RTRIM(UPPER(mt.NomAutoTipo)), ''), 'NORMAL'),
@NomCalcSDI = ISNULL(mt.NomAutoCalcSDI, 0),
@NomCxc  = UPPER(mt.NomAutoCxc)		
FROM Nomina n
JOIN MovTipo mt ON mt.Modulo = 'NOM' AND mt.Mov = n.Mov
WHERE n.ID = @ID
SELECT @CalendarioEsp = NomAutoCalendarioEsp FROM MovTipo WHERE Modulo = 'NOM' AND Mov = @Mov
IF @CalendarioEsp = 1
SELECT @IncidenciaD = IncidenciaD, @IncidenciaA = IncidenciaA
FROM MovTipoNomAutoCalendarioEsp
WHERE Modulo = 'NOM' AND Mov = @Mov AND FechaNomina = @FechaA
SELECT @FechaMaxVacaciones= MAX(d.FechaAplicacion)
FROM  Incidencia i
JOIN IncidenciaD d ON i.ID = d.id AND i.estatus = 'PENDIENTE'
JOIN NominaConcepto c ON c.NominaConcepto = d.NominaConcepto AND c.Especial = 'VACACIONES'
AND i.Personal in(
SELECT i2.Personal
FROM Incidencia i2
JOIN IncidenciaD d2 ON i.ID = d2.id AND i2.estatus = 'PENDIENTE'
JOIN NominaConcepto c ON c.NominaConcepto = d2.NominaConcepto AND c.Especial = 'VACACIONES'
JOIN ListaSt  s ON  i2.Personal = s.Clave
AND s.Estacion = @Estacion
WHERE d2.FechaAplicacion BETWEEN @IncidenciaD AND @IncidenciaA)
CREATE TABLE #Nomina (
ID		          int		NOT NULL IDENTITY(1,1) PRIMARY KEY,
IncidenciaID	  int		NULL,
IncidenciaRID	int		NULL,
Fecha		      datetime	NULL,
Personal	      varchar(10)COLLATE Database_Default 	NULL,
Semana		      int		NULL,
NominaConcepto	varchar(10)COLLATE Database_Default 	NULL,
Movimiento	    varchar(20)COLLATE Database_Default 	NULL,
Referencia	    varchar(50)	COLLATE Database_Default NULL,
Cantidad	      float		NULL,
Importe		    money		NULL,
Cuenta	 	      varchar(10) COLLATE Database_Default 	NULL,
Vencimiento  	datetime 	NULL,
Beneficiario	  varchar(100)	COLLATE Database_Default  NULL)
CREATE TABLE #Nomina2 (
ID		          int		NOT NULL IDENTITY(1,1) PRIMARY KEY,
IncidenciaID	  int		NULL,
IncidenciaRID	  int		NULL,
Fecha		        datetime	NULL,
Personal	      varchar(10)	COLLATE Database_Default NULL,
NominaConcepto	varchar(10)	COLLATE Database_Default NULL,
Movimiento	    varchar(20)	COLLATE Database_Default NULL,
Referencia	    varchar(50)	COLLATE Database_Default NULL,
Cantidad	      float		NULL,
Importe		      money		NULL,
Cuenta	 	      varchar(10) 	COLLATE Database_Default NULL,
Vencimiento  	  datetime 	NULL,
Beneficiario	  varchar(100)	COLLATE Database_Default NULL)
CREATE INDEX Personal ON #Nomina (Personal, NominaConcepto)
CREATE INDEX IncidenciaID ON #Nomina (Personal, IncidenciaID)
CREATE INDEX IncidenciaRID ON #Nomina (Personal, IncidenciaRID)
SELECT @CfgTablaVacaciones = TablaVacaciones
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @CfgAjusteMensualISR            = AjusteMensualISR,
@CfgSueldoMinimo                = UPPER(SueldoMinimo),	
@CfgSubsidioIncapacidadEG       = ISNULL(SubsidioIncapacidadEG, 0),
@CfgPrimaDominicalAuto          = ISNULL(PrimaDominicalAuto, 0),
@CfgISRReglamentoAguinaldo      = ISNULL(ISRReglamentoAguinaldo, 0),
@CfgISRReglamentoPTU            = ISNULL(ISRReglamentoPTU, 0),
@CfgISRLiquidacionSueldoMensual = UPPER(ISRLiquidacionSueldoMensual),
@CfgFactorIntegracionAntiguedad = UPPER(FactorIntegracionAntiguedad),
@CfgFactorIntegracionTabla      = FactorIntegracionTabla,
@CfgFondoAhorroRepartirInteres  = FondoAhorroRepartirInteres,
@CfgCajaAhorroRepartirInteres   = CajaAhorroRepartirInteres
FROM EmpresaCfgNomAuto
WHERE Empresa = @Empresa
SELECT @ClaveInterna = NULL
SELECT @ClaveInterna = MIN(cfg.ClaveInterna)
FROM CfgNominaConcepto cfg
LEFT OUTER JOIN NominaConcepto nc ON nc.NominaConcepto = cfg.NominaConcepto
WHERE nc.NominaConcepto IS NULL
IF @ClaveInterna IS NOT NULL
SELECT @Ok = 10034, @OkRef = @ClaveInterna
SELECT @CuantosMov = 1
WHILE @IncidenciaD <= @FechaMaxVacaciones AND @OK IS NULL
BEGIN
DELETE #Nomina
DELETE #Nomina2
SELECT @IncidenciaD = @FechaD, @IncidenciaA = @FechaA
IF @CalendarioEsp = 1
SELECT @IncidenciaD = IncidenciaD, @IncidenciaA = IncidenciaA
FROM MovTipoNomAutoCalendarioEsp
WHERE Modulo = 'NOM' AND Mov = @Mov AND FechaNomina = @FechaA
DECLARE crLista CURSOR FOR
SELECT DISTINCT  i2.Personal
FROM Incidencia i2
JOIN IncidenciaD d2 ON i2.ID = d2.ID AND i2.Estatus = 'PENDIENTE'
JOIN NominaConcepto c ON c.NominaConcepto = d2.NominaConcepto AND c.Especial = 'VACACIONES'
JOIN ListaSt  s ON i2.Personal = s.Clave
AND s.Estacion = @Estacion
WHERE d2.FechaAplicacion BETWEEN @IncidenciaD AND @IncidenciaA
OPEN crLista
FETCH NEXT FROM crLista INTO @Personal
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
EXEC spNominaCalc @Empresa, @FechaTrabajo, @Sucursal, @ID, @Mov, @Moneda, @TipoCambio, @Personal, @FechaD, @FechaA, @PeriodoTipo,
@CfgAjusteMensualISR, @CfgSueldoMinimo, @CfgTablaVacaciones, @CfgSubsidioIncapacidadEG, @CfgPrimaDominicalAuto,
@CfgISRReglamentoAguinaldo, @CfgISRReglamentoPTU, @CfgISRLiquidacionSueldoMensual, @CfgFactorIntegracionAntiguedad, @CfgFactorIntegracionTabla,
@NomTipo, @NomCalcSDI, @NomCxc,
@RepartirDesde, @RepartirHasta, @RepartirIngresoTope, @RepartirIngresoFactor, @RepartirDiasFactor,
@CalendarioEsp, @IncidenciaD, @IncidenciaA,
@Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL SELECT @Conteo = @Conteo + 1
END
FETCH NEXT FROM crLista INTO @Personal
END 
CLOSE crLista
DEALLOCATE crLista
IF @Ok IS NULL
BEGIN
EXEC spNominaImpuestoEstatalEspecial @Empresa, @Ok OUTPUT, @OkRef OUTPUT
DELETE NominaD WHERE ID = @ID
INSERT #Nomina2 (
Personal,   IncidenciaID,   IncidenciaRID,   NominaConcepto,   Movimiento,   Referencia,   Cuenta,   Vencimiento,   Beneficiario,   Importe,        Cantidad)
SELECT d.Personal, d.IncidenciaID, d.IncidenciaRID, d.NominaConcepto, d.Movimiento, d.Referencia, d.Cuenta, d.Vencimiento, d.Beneficiario, SUM(d.Importe), SUM(d.Cantidad)
FROM #Nomina d
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto
WHERE NULLIF(d.Importe, 0.0) IS NOT NULL OR NULLIF(d.Cantidad, 0.0) IS NOT NULL
GROUP BY nc.Modulo,      d.Personal, d.IncidenciaID, d.IncidenciaRID, d.NominaConcepto, d.Movimiento, nc.Concepto, d.Referencia, d.Cuenta, d.Vencimiento, d.Beneficiario
ORDER BY nc.Modulo DESC, d.Personal, d.IncidenciaID, d.IncidenciaRID, d.NominaConcepto, d.Movimiento, nc.Concepto, d.Referencia, d.Cuenta, d.Vencimiento, d.Beneficiario
INSERT NominaD (
ID,  Sucursal,  Renglon, Modulo,    Personal,   IncidenciaID,    NominaConcepto,   Movimiento,   Concepto,    Referencia,   Cuenta,   FechaA,        Beneficiario,   Importe,                               Cantidad,   CuentaContable)
SELECT @ID, @Sucursal, d.ID,    nc.Modulo, d.Personal, d.IncidenciaRID, d.NominaConcepto, d.Movimiento, nc.Concepto, d.Referencia, d.Cuenta, d.Vencimiento, d.Beneficiario, d.Importe/*ROUND(d.Importe, @RedondeoMonetarios)*/, d.Cantidad, dbo.fnNominaCuentaContable (nc.CuentaBase, nc.Cuenta, d.Personal, d.NominaConcepto)
FROM #Nomina2 d
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto
SELECT @Renglon = MAX(Renglon) FROM NominaD WHERE ID = @ID
INSERT NominaD (
ID,  Sucursal,  Renglon,       Modulo, Personal,   IncidenciaID,    NominaConcepto,   Movimiento,    Concepto,    Referencia,   Cuenta,                FechaA,        Beneficiario,   Importe,                               Cantidad,   CuentaContable)
SELECT @ID, @Sucursal, @Renglon+d.ID, 'CXP',  d.Personal, d.IncidenciaRID, d.NominaConcepto, 'Estadistica', nc.Concepto, d.Referencia, nc.AcreedorDef, d.Vencimiento, d.Beneficiario, d.Importe/*ROUND(d.Importe, @RedondeoMonetarios)*/, d.Cantidad, dbo.fnNominaCuentaContable (nc.CuentaBase, nc.Cuenta, d.Personal, d.NominaConcepto)
FROM #Nomina2 d
JOIN NominaConcepto nc ON nc.NominaConcepto = d.NominaConcepto AND nc.Modulo = 'CXC' AND nc.GenerarEstadisticaCxp = 1
UPDATE Nomina SET PeriodoTipo = @PeriodoTipo, FechaD = @FechaD, FechaA = @FechaA, Estatus = 'BORRADOR', RamaID = @RamaID WHERE ID = @ID
EXEC xpNominaGenerar @Estacion, @ID, @FechaD, @FechaA, @PeriodoTipo
IF @FechaD <= @FechaMaxVacaciones
BEGIN
SELECT @FechaD = DATEADD(dd, 1,  @FechaA)
IF DAY(@FechaD) = 1   
BEGIN
SELECT @Mes = MONTH(@FechaD), @Ano = YEAR(@FechaD)
EXEC SpIntToDateTime 15, @Mes, @Ano, @FechaA OUTPUT
END ELSE
BEGIN
SELECT @Mes = MONTH(@FechaD), @Ano = YEAR(@FechaD)
EXEC spDiasMes @Mes, @Ano, @Dia OUTPUT
EXEC SpIntToDateTime @Dia, @Mes, @Ano, @FechaA OUTPUT
END
SELECT @IncidenciaD = @FechaD, @IncidenciaA = @FechaA
IF @CalendarioEsp = 1
SELECT @IncidenciaD = IncidenciaD, @IncidenciaA = IncidenciaA
FROM MovTipoNomAutoCalendarioEsp
WHERE Modulo = 'NOM' AND Mov = @Mov AND FechaNomina = @FechaA
IF @FechaD <= @FechaMaxVacaciones
BEGIN
INSERT Nomina (Empresa, Mov,  FechaEmision, UltimoCambio, Proyecto, UEN, Concepto, Moneda, TipoCambio, Usuario, Autorizacion, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, OrigenTipo, Origen, OrigenID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, Condicion, PeriodoTipo, FechaD, FechaA, Poliza, PolizaID, GenerarPoliza, ContID, Sucursal, Percepciones, Deducciones, FechaOrigen, FechaRegistroNomXD, FechaRegistroNomXA, SucursalOrigen, SucursalDestino, RamaID)
SELECT         Empresa, Mov,  FechaEmision, UltimoCambio, Proyecto, UEN, Concepto, Moneda, TipoCambio, Usuario, Autorizacion, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, OrigenTipo, Origen, OrigenID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, Condicion, PeriodoTipo, FechaD, FechaA, Poliza, PolizaID, GenerarPoliza, ContID, Sucursal, Percepciones, Deducciones, FechaOrigen, FechaRegistroNomXD, FechaRegistroNomXA, SucursalOrigen, SucursalDestino, @RamaID
FROM Nomina
WHERE ID = @ID
SELECT @ID = SCOPE_IDENTITY()
SELECT @CuantosMov = @CuantosMov + 1
END
END
END ELSE
BEGIN
SELECT Descripcion+' '+ISNULL(RTRIM(@OkRef), '') FROM MensajeLista WHERE Mensaje = @Ok
return
END
END
IF @Ok IS  NULL
SELECT 'Se Generaron ' + CONVERT(VARCHAR, @CuantosMov) +' Movimientos.'
ELSE
SELECT Descripcion+' '+ISNULL(RTRIM(@OkRef), '') FROM MensajeLista WHERE Mensaje = @Ok
RETURN
END

