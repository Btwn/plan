SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCorteDConsulta
@ID                	int,
@Accion				char(20),
@Empresa	      	char(5),
@Modulo	      		char(5),
@Mov	  	      	char(20),
@MovID             	varchar(20),
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
@Ok                	int          OUTPUT,
@OkRef             	varchar(255) OUTPUT

AS
BEGIN
DECLARE @RID				int,
@RIDAnt			int,
@CEmpresa			varchar(5),
@CSucursal		int,
@CUEN				int,
@CUsuario			varchar(10),
@CModulo			varchar(5),
@CMovimiento		varchar(20),
@CEstatus			varchar(15),
@CSituacion		varchar(50),
@CProyecto		varchar(50),
@CContactoTipo	varchar(20),
@CContacto		varchar(10),
@CImporteMin		float,
@CImporteMax		float,
@CValidarAlEmitir	bit,
@CAccion			varchar(8),
@CDesglosar		varchar(20),
@CAgrupador		varchar(50),
@CMoneda			varchar(10),
@CTotalizador		varchar(255),
@CCuenta			varchar(20),
@CCtaCategoria	varchar(50),
@CCtaFamilia		varchar(50),
@CCtaGrupo		varchar(50),
@CCtaFabricante	varchar(50),
@CCtaLinea		varchar(50),
@CCtaTipo			varchar(50),
@CRama			varchar(50),
@CAlmacen			varchar(50)
SELECT @RIDAnt = 0
WHILE(1=1)
BEGIN
SELECT @RID = MIN(RID)
FROM CorteDConsultaNormalizada
WHERE ID	= @ID
AND RID	> @RIDAnt
IF @RID IS NULL BREAK
SELECT @RIDAnt = @RID
SELECT @CEmpresa = NULL, @CSucursal = NULL, @CUEN = NULL, @CUsuario = NULL, @CModulo = NULL, @CMovimiento = NULL, @CEstatus = NULL,
@CSituacion = NULL, @CProyecto = NULL, @CContactoTipo = NULL, @CContacto = NULL, @CImporteMin = NULL, @CImporteMax = NULL,
@CValidarAlEmitir = NULL, @CAccion = NULL, @CDesglosar = NULL, @CAgrupador = NULL, @CMoneda = NULL, @CTotalizador = NULL,
@CCuenta = NULL, @CCtaCategoria = NULL, @CCtaFamilia = NULL, @CCtaGrupo = NULL, @CCtaFabricante = NULL, @CCtaLinea = NULL,
@CRama = NULL, @CAlmacen = NULL, @CCtaTipo = NULL
SELECT @CEmpresa			= Empresa,
@CSucursal			= Sucursal,
@CUEN				= UEN,
@CUsuario			= Usuario,
@CModulo				= Modulo,
@CMovimiento			= Movimiento,
@CEstatus			= Estatus,
@CSituacion			= Situacion,
@CProyecto			= Proyecto,
@CContactoTipo		= ContactoTipo,
@CContacto			= Contacto,
@CImporteMin			= ImporteMin,
@CImporteMax			= ImporteMax,
@CValidarAlEmitir	= ValidarAlEmitir,
@CAccion				= Accion,
@CDesglosar			= Desglosar,
@CAgrupador			= Agrupador,
@CMoneda				= Moneda,
@CTotalizador		= Totalizador,
@CCuenta				= Cuenta,
@CCtaCategoria		= CtaCategoria,
@CCtaFamilia			= CtaFamilia,
@CCtaGrupo			= CtaGrupo,
@CCtaFabricante		= CtaFabricante,
@CCtaLinea			= CtaLinea,
@CRama				= Rama,
@CAlmacen			= Almacen,
@CCtaTipo			= CtaTipo
FROM CorteDConsultaNormalizada
WHERE ID	= @ID
AND RID	= @RID
SELECT @CRama = Rama
FROM Rama
WHERE Descripcion = @CRama
EXEC spCorteDConsultaProcesar @ID, @RID, @CEmpresa, @CSucursal, @CUEN, @CUsuario, @CModulo, @CMovimiento, @CEstatus,
@CSituacion, @CProyecto, @CContactoTipo, @CContacto, @CImporteMin, @CImporteMax, @CValidarAlEmitir,
@CAccion, @CDesglosar, @CAgrupador, @CMoneda, @Moneda, @TipoCambio, @MovTipo, @SubMovTipo,
@CorteFiltrarFechas, @CortePeriodo, @CorteEjercicio, @CorteFechaD, @CorteFechaA, @CTotalizador,
@CCuenta, @CCtaCategoria, @CCtaFamilia, @CCtaGrupo, @CCtaFabricante, @CCtaLinea,
@CRama, @CAlmacen, @CorteValuacion,
@CCtaTipo,
@Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
EXEC xpCorteDConsulta @ID, @Accion, @Empresa, @Modulo, @Mov, MovID, @MovTipo, @SubMovTipo, @FechaEmision, @FechaAfectacion, @FechaConclusion,
@Proyecto, @Usuario, @Autorizacion, @Observaciones, @Concepto, @Referencia, @Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio,
@Periodo, @MovUsuario, @CorteFrecuencia, @CorteGrupo, @CorteTipo, @CortePeriodo, @CorteEjercicio, @CorteOrigen, @CorteCuentaTipo,
@CorteGrupoDe, @CorteGrupoA, @CorteSubGrupoDe, @CorteSubGrupoA, @CorteCuentaDe, @CorteCuentaA, @CorteSubCuentaDe, @CorteSubCuenta2A,
@CorteSubCuenta2De, @CorteSubCuenta3A, @CorteSubCuenta3De, @CorteSubCuentaA, @CorteUENDe, @CorteUENA, @CorteProyectoDe, @CorteProyectoA,
@CorteFechaD, @CorteFechaA, @Moneda, @TipoCambio, @CorteTitulo, @CorteMensaje, @CorteEstatus, @CorteSucursalDe, @CorteSucursalA,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen, @Estacion, @CorteValuacion, @CorteDesglosar, @CorteFiltrarFechas,
@CortePeriodo, @CorteEjercicio, @CorteFechaD, @CorteFechaA, @CTotalizador, @CCuenta, @CCtaCategoria, @CCtaFamilia, @CCtaGrupo,
@Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
RETURN
END

