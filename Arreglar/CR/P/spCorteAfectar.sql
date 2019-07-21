SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCorteAfectar
@ID                	int,
@Accion				char(20),
@Empresa	      	char(5),
@Modulo	      		char(5),
@Mov	  	      	char(20),
@MovID             	varchar(20)	OUTPUT,
@MovTipo     		char(20),
@SubMovTipo     	char(20),
@FechaEmision      	datetime,
@FechaAfectacion    datetime,
@FechaConclusion	datetime,
@Proyecto	      	varchar(50),
@Usuario	      	char(10),
@Autorizacion      	char(10),
@Observaciones     	varchar(255),
@Concepto     		varchar(50),
@Referencia			varchar(50),
@Estatus           	char(15),
@EstatusNuevo	    char(15),
@FechaRegistro     	datetime,
@Ejercicio	      	int,
@Periodo	      	int,
@MovUsuario			char(10),
@CorteFrecuencia	varchar(50),
@CorteGrupo			varchar(50),
@CorteTipo			varchar(50),
@CortePeriodo		int,
@CorteEjercicio		int,
@CorteOrigen		varchar(50),
@CorteCuentaTipo	varchar(20),
@CorteGrupoDe		varchar(10),
@CorteGrupoA		varchar(10),
@CorteSubGrupoDe	varchar(20),
@CorteSubGrupoA		varchar(20),
@CorteCuentaDe		varchar(10),
@CorteCuentaA		varchar(10),
@CorteSubCuentaDe	varchar(50),
@CorteSubCuenta2A	varchar(50),
@CorteSubCuenta2De	varchar(50),
@CorteSubCuenta3A	varchar(50),
@CorteSubCuenta3De	varchar(50),
@CorteSubCuentaA	varchar(50),
@CorteUENDe			int,
@CorteUENA			int,
@CorteProyectoDe	varchar(50),
@CorteProyectoA		varchar(50),
@CorteFechaD		datetime,
@CorteFechaA		datetime,
@CorteMoneda		varchar(10),
@Moneda				varchar(10),
@TipoCambio			float,
@CorteTitulo		varchar(100),
@CorteMensaje		varchar(100),
@CorteEstatus		varchar(15),
@CorteSucursalDe	int,
@CorteSucursalA		int,
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@SucursalDestino	int,
@SucursalOrigen		int,
@Estacion			int,
@CorteValuacion		varchar(50),
@CorteDesglosar		varchar(20),
@CorteFiltrarFechas	bit,
@Generar			bit,
@GenerarMov			char(20),
@GenerarAfectado	bit,
@IDGenerar			int	     	OUTPUT,
@GenerarMovID	  	varchar(20)	OUTPUT,
@Ok                	int          OUTPUT,
@OkRef             	varchar(255) OUTPUT

AS
BEGIN
DECLARE @FechaCancelacion		datetime,
@GenerarMovTipo		varchar(20),
@GenerarPeriodo		int,
@GenerarEjercicio		int,
@OModulo				varchar(5),
@OMov					varchar(20),
@OMovID				varchar(20),
@OID					int
SELECT @OModulo	= OrigenTipo,
@OMov		= Origen,
@OMovID	= OrigenID
FROM Corte
WHERE ID = @ID
CREATE TABLE #CorteD(
ID						int			NULL,
Renglon					float		NULL,
RenglonSub				int			NULL,
RID						int			NOT NULL IDENTITY(1, 1),
Cuenta					varchar(20)	COLLATE DATABASE_DEFAULT NULL,
Mov						varchar(20) COLLATE DATABASE_DEFAULT NULL,
MovID					varchar(20)	COLLATE DATABASE_DEFAULT NULL,
Fecha					datetime	NULL,
Vencimiento				datetime	NULL,
Moneda					varchar(10)	COLLATE DATABASE_DEFAULT NULL,
Aplica					varchar(20)	COLLATE DATABASE_DEFAULT NULL,
AplicaID				varchar(20)	COLLATE DATABASE_DEFAULT NULL,
Referencia				varchar(50)	COLLATE DATABASE_DEFAULT NULL,
CtaCreditoDias			int			NULL,
CtaCondicion			varchar(50)	COLLATE DATABASE_DEFAULT NULL,
CtaLimiteCredito		float		NULL,
CtaLimiteCreditoMoneda	varchar(10) NULL,
Cargo					float		NULL,
Abono					float		NULL,
CargoU					float		NULL,
AbonoU					float		NULL,
SaldoU					float		NULL,
CostoPromedio			float		NULL,
UltimoCosto				float		NULL,
ValuacionNombre			varchar(50)	NULL,
ValuacionValor			float		NULL,
ValuacionValorArtConCosto float		NULL,
PrecioLista				float		NULL,
Precio2					float		NULL,
Precio3					float		NULL,
Precio4					float		NULL,
Precio5					float		NULL,
Precio6					float		NULL,
Precio7					float		NULL,
Precio8					float		NULL,
Precio9					float		NULL,
Precio10				float		NULL,
CostoEstandar			float		NULL,
CostoReposicion			float		NULL,
Grupo					varchar(10)	NULL,
Sucursal				int			NULL,
SubCuenta				varchar(50)	NULL,
CostoUnitario			float		NULL,
CostoUnitarioOtraMoneda	float		NULL,
MonedaContable			varchar(10)	NULL,
Modulo					varchar(5)	NULL,
ModuloID				int			NULL,
Cantidad				float		NULL,
Importe					float		NULL,
RIDConsulta				int			NULL,
TipoCambio				float		NULL,
Saldo					float		NULL,
Empresa					varchar(5)	NULL,
Periodo					int			NULL,
Ejercicio				int			NULL,
Estatus					varchar(15)	NULL,
SaldoI					float		NULL,
EsCancelacion			bit			NULL,
SaldoUI					float		NULL
)
CREATE TABLE #CorteDReporte(
ID					int			NULL,
Renglon				float		NULL,
RenglonSub			int			NULL,
RID					int			NOT NULL IDENTITY(1, 1),
Tipo				varchar(5)	COLLATE DATABASE_DEFAULT NULL,
Columna1			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna2			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna3			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna4			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna5			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna6			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna7			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna8			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna9			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna10			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna11			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna12			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna13			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna14			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna15			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna16			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna17			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna18			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna19			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna20			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna21			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna22			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna23			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna24			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna25			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna26			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna27			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna28			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna29			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna30			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna31			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna32			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna33			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna34			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna35			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna36			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna37			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna38			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna39			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna40			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna41			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna42			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna43			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna44			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna45			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna46			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna47			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna48			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna49			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Columna50			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Agrupador1			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Agrupador2			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Agrupador3			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Agrupador4			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Agrupador5			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Agrupador6			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Agrupador7			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Agrupador8			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Agrupador9			varchar(100)COLLATE DATABASE_DEFAULT NULL,
Agrupador10			varchar(100)COLLATE DATABASE_DEFAULT NULL
)
CREATE TABLE #ContactoDireccion(
Contacto				varchar(10)  COLLATE DATABASE_DEFAULT NULL,
Direccion1				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion2				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion3				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion4				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion5				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion6				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion7				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion8				varchar(255) COLLATE DATABASE_DEFAULT NULL
)
EXEC spMovConsecutivo @Sucursal, @SucursalOrigen, @SucursalDestino, @Empresa, @Usuario, @Modulo, @Ejercicio, @Periodo, @ID, @Mov, NULL, @Estatus, @Concepto, @Accion, @Conexion, @SincroFinal, @MovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Estatus IN ('SINAFECTAR') AND @Accion <> 'CANCELAR' AND @Ok IS NULL
EXEC spMovChecarConsecutivo	@Empresa, @Modulo, @Mov, @MovID, NULL, @Ejercicio, @Periodo, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion IN ('CONSECUTIVO', 'SINCRO') AND @Ok IS NULL
BEGIN
IF @Accion = 'SINCRO' EXEC spAsignarSucursalEstatus @ID, @Modulo, @SucursalDestino, @Accion
SELECT @Ok = 80060, @OkRef = @MovID
RETURN
END
IF @OK IS NOT NULL RETURN
IF @Accion = 'GENERAR' AND @Ok IS NULL
BEGIN
EXEC spMovGenerar @Sucursal, @Empresa, @Modulo, @Ejercicio, @Periodo, @Usuario, @FechaRegistro, 'SINAFECTAR',
NULL, NULL, @Mov, @MovID, 0, @GenerarMov, NULL, @GenerarMovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spCorteCalcPeriodoFecha @ID, @IDGenerar, @Ok = @Ok OUTPUT
EXEC spMovTipo @Modulo, @GenerarMov, @FechaAfectacion, @Empresa, NULL, NULL, @GenerarMovTipo OUTPUT, @GenerarPeriodo OUTPUT, @GenerarEjercicio OUTPUT, @Ok OUTPUT
IF @Ok IS NULL
BEGIN
SELECT * INTO #CorteDConsulta FROM cCorteDConsulta WHERE ID = @ID
UPDATE #CorteDConsulta SET ID = @IDGenerar
INSERT INTO cCorteDConsulta SELECT * FROM #CorteDConsulta
END
IF @Ok IS NULL SELECT @Ok = 80030
RETURN
END
IF @Conexion = 0
BEGIN TRANSACTION
EXEC spMovEstatus @Modulo, 'AFECTANDO', @ID, NULL, NULL, NULL, @Ok OUTPUT
IF @Accion <> 'CANCELAR'
EXEC spRegistrarMovimiento @Sucursal, @Empresa, @Modulo, @Mov, @MovID, @ID, @Ejercicio, @Periodo, @FechaRegistro, @FechaEmision,
NULL, @Proyecto, NULL, NULL,
@Usuario, @Autorizacion, NULL, NULL, @Observaciones,
NULL, NULL, NULL, NULL, @Ok OUTPUT
IF @Accion IN ('AFECTAR', 'CANCELAR')
BEGIN
IF @MovTipo IN('CORTE.EDOCTACXC', 'CORTE.EDOCTACXP') AND @Accion = 'AFECTAR'
BEGIN
EXEC spCorteEdoCtaCxAfectar
@ID, @Accion, @Empresa, @Modulo, @Mov, @MovID, @MovTipo, @SubMovTipo, @FechaEmision, @FechaAfectacion, @FechaConclusion,
@Proyecto, @Usuario, @Autorizacion, @Observaciones, @Concepto, @Referencia,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo, @MovUsuario, @CorteFrecuencia, @CorteGrupo, @CorteTipo,
@CortePeriodo, @CorteEjercicio, @CorteOrigen, @CorteCuentaTipo, @CorteGrupoDe, @CorteGrupoA, @CorteSubGrupoDe, @CorteSubGrupoA,
@CorteCuentaDe, @CorteCuentaA, @CorteSubCuentaDe, @CorteSubCuenta2A, @CorteSubCuenta2De, @CorteSubCuenta3A, @CorteSubCuenta3De,
@CorteSubCuentaA, @CorteUENDe, @CorteUENA, @CorteProyectoDe, @CorteProyectoA, @CorteFechaD, @CorteFechaA, @CorteMoneda,
@Moneda, @TipoCambio, @CorteTitulo, @CorteMensaje, @CorteEstatus, @CorteSucursalDe, @CorteSucursalA,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen, @Estacion,
@Ok OUTPUT, @OkRef OUTPUT
END
IF @MovTipo IN('CORTE.INVVAL') AND @Accion = 'AFECTAR'
BEGIN
EXEC spCorteInvValAfectar
@ID, @Accion, @Empresa, @Modulo, @Mov, @MovID, @MovTipo, @SubMovTipo, @FechaEmision, @FechaAfectacion, @FechaConclusion,
@Proyecto, @Usuario, @Autorizacion, @Observaciones, @Concepto, @Referencia,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo, @MovUsuario, @CorteFrecuencia, @CorteGrupo, @CorteTipo,
@CortePeriodo, @CorteEjercicio, @CorteOrigen, @CorteCuentaTipo, @CorteGrupoDe, @CorteGrupoA, @CorteSubGrupoDe, @CorteSubGrupoA,
@CorteCuentaDe, @CorteCuentaA, @CorteSubCuentaDe, @CorteSubCuenta2A, @CorteSubCuenta2De, @CorteSubCuenta3A, @CorteSubCuenta3De,
@CorteSubCuentaA, @CorteUENDe, @CorteUENA, @CorteProyectoDe, @CorteProyectoA, @CorteFechaD, @CorteFechaA, @Moneda, @TipoCambio,
@CorteTitulo, @CorteMensaje, @CorteEstatus, @CorteSucursalDe, @CorteSucursalA,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen, @Estacion, @CorteValuacion, @CorteDesglosar,
@Ok OUTPUT, @OkRef OUTPUT
END
IF @MovTipo IN('CORTE.CORTEIMPORTE', 'CORTE.CORTECONTABLE', 'CORTE.CORTEUNIDADES', 'CORTE.CORTECX') AND ISNULL(@SubMovTipo, '') NOT IN('CORTE.GENERACORTEIMP', 'CORTE.GENERACORTECON', 'CORTE.GENERACORTEU', 'CORTE.GENERACORTECX') AND @Accion = 'AFECTAR'
BEGIN
EXEC spCorteDinamicoAfectar
@ID, @Accion, @Empresa, @Modulo, @Mov, @MovID, @MovTipo, @SubMovTipo, @FechaEmision, @FechaAfectacion, @FechaConclusion,
@Proyecto, @Usuario, @Autorizacion, @Observaciones, @Concepto, @Referencia,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo, @MovUsuario, @CorteFrecuencia, @CorteGrupo, @CorteTipo,
@CortePeriodo, @CorteEjercicio, @CorteOrigen, @CorteCuentaTipo, @CorteGrupoDe, @CorteGrupoA, @CorteSubGrupoDe, @CorteSubGrupoA,
@CorteCuentaDe, @CorteCuentaA, @CorteSubCuentaDe, @CorteSubCuenta2A, @CorteSubCuenta2De, @CorteSubCuenta3A, @CorteSubCuenta3De,
@CorteSubCuentaA, @CorteUENDe, @CorteUENA, @CorteProyectoDe, @CorteProyectoA, @CorteFechaD, @CorteFechaA, @Moneda, @TipoCambio,
@CorteTitulo, @CorteMensaje, @CorteEstatus, @CorteSucursalDe, @CorteSucursalA,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen, @Estacion, @CorteValuacion, @CorteDesglosar, @CorteFiltrarFechas,
@Ok OUTPUT, @OkRef OUTPUT
END
IF @Accion = 'AFECTAR' AND ISNULL(@SubMovTipo, '') NOT IN('CORTE.GENERACORTEIMP', 'CORTE.GENERACORTECON', 'CORTE.GENERACORTEU', 'CORTE.GENERACORTECX')
BEGIN
EXEC spCorteD @ID, @Accion, @Empresa, @Modulo, @Mov, @MovID, @MovTipo, @SubMovTipo, @FechaEmision, @FechaAfectacion, @FechaConclusion,
@Proyecto, @Usuario, @Autorizacion, @Observaciones, @Concepto, @Referencia,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo, @MovUsuario, @CorteFrecuencia, @CorteGrupo, @CorteTipo,
@CortePeriodo, @CorteEjercicio, @CorteOrigen, @CorteCuentaTipo, @CorteGrupoDe, @CorteGrupoA, @CorteSubGrupoDe, @CorteSubGrupoA,
@CorteCuentaDe, @CorteCuentaA, @CorteSubCuentaDe, @CorteSubCuenta2A, @CorteSubCuenta2De, @CorteSubCuenta3A, @CorteSubCuenta3De,
@CorteSubCuentaA, @CorteUENDe, @CorteUENA, @CorteProyectoDe, @CorteProyectoA, @CorteFechaD, @CorteFechaA, @Moneda, @TipoCambio,
@CorteTitulo, @CorteMensaje, @CorteEstatus, @CorteSucursalDe, @CorteSucursalA,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen, @Estacion, @CorteValuacion, @CorteDesglosar,
@Ok OUTPUT, @OkRef OUTPUT
EXEC spCorteDReporte @ID, @Accion, @Empresa, @Modulo, @Mov, @MovID, @MovTipo, @SubMovTipo, @FechaEmision, @FechaAfectacion, @FechaConclusion,
@Proyecto, @Usuario, @Autorizacion, @Observaciones, @Concepto, @Referencia,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo, @MovUsuario, @CorteFrecuencia, @CorteGrupo, @CorteTipo,
@CortePeriodo, @CorteEjercicio, @CorteOrigen, @CorteCuentaTipo, @CorteGrupoDe, @CorteGrupoA, @CorteSubGrupoDe, @CorteSubGrupoA,
@CorteCuentaDe, @CorteCuentaA, @CorteSubCuentaDe, @CorteSubCuenta2A, @CorteSubCuenta2De, @CorteSubCuenta3A, @CorteSubCuenta3De,
@CorteSubCuentaA, @CorteUENDe, @CorteUENA, @CorteProyectoDe, @CorteProyectoA, @CorteFechaD, @CorteFechaA, @Moneda, @TipoCambio,
@CorteTitulo, @CorteMensaje, @CorteEstatus, @CorteSucursalDe, @CorteSucursalA,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen, @Estacion, @CorteValuacion, @CorteDesglosar, @CorteFiltrarFechas,
@Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IN (NULL, 80030)
BEGIN
IF @EstatusNuevo = 'CANCELADO' SELECT @FechaCancelacion = @FechaRegistro ELSE SELECT @FechaCancelacion = NULL
IF @EstatusNuevo = 'CONCLUIDO' SELECT @FechaConclusion  = @FechaEmision  ELSE IF @EstatusNuevo <> 'CANCELADO' SELECT @FechaConclusion  = NULL
EXEC spValidarTareas @Empresa, @Modulo, @ID, @EstatusNuevo, @Ok OUTPUT, @OkRef OUTPUT
UPDATE Corte
SET FechaConclusion  = @FechaConclusion,
FechaCancelacion = @FechaCancelacion,
UltimoCambio     = CASE WHEN UltimoCambio IS NULL THEN @FechaRegistro ELSE UltimoCambio END,
Estatus          = @EstatusNuevo,
Situacion 		= CASE WHEN @Estatus<>@EstatusNuevo THEN NULL ELSE Situacion END
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
END
END
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spMovFinal @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, NULL, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion = 'CANCELAR' AND @EstatusNuevo = 'CANCELADO' AND @Ok IS NULL
EXEC spCancelarFlujo @Empresa, @Modulo, @ID, @Ok OUTPUT, 1
IF @Accion = 'AFECTAR' AND @EstatusNuevo = 'CONCLUIDO' AND @Ok IS NULL
BEGIN
IF ISNULL(@OModulo, '') <> ''
BEGIN
EXEC spMovEnID @OModulo, @Empresa, @OMov, @OMovID, @OID OUTPUT, NULL, @Ok OUTPUT
IF @Ok IS NULL
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @OModulo, @OID, @OMov, @OMovID, @Modulo, @ID, @Mov, @MovID, @Ok OUTPUT
END
END
IF @Conexion = 0
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
END

