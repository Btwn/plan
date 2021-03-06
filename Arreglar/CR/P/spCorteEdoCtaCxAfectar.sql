SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCorteEdoCtaCxAfectar
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
@Ok                		int          OUTPUT,
@OkRef             		varchar(255) OUTPUT

AS
BEGIN
IF @MovTipo = 'CORTE.EDOCTACXC'
BEGIN
UPDATE RepParam
SET InfoEmpresa				= @Empresa,
InfoFechaD				= @CorteFechaD,
InfoClienteD				= NULLIF(@CorteCuentaDe, ''),
InfoClienteA				= NULLIF(@CorteCuentaA, ''),
InfoSucursal				= ISNULL(@Sucursal, -1),
InfoEstatusEspecifico	= @CorteEstatus,
InfoMoneda				= CASE
WHEN @CorteMoneda = '(Todas)' THEN NULL
ELSE @CorteMoneda
END,
InformeGraficarTipo		= '(Todos)',
InfoTitulo				= ISNULL(@CorteTitulo, ''),
InfoModulo				= 'CXC',
VerGraficaDetalle		= 0
WHERE Estacion = @Estacion
EXEC spCorteCxcEstadoCuentaSimple @Estacion, 1, @ID
END
IF @MovTipo = 'CORTE.EDOCTACXP'
BEGIN
UPDATE RepParam
SET InfoEmpresa				= @Empresa,
InfoFechaD				= @CorteFechaD,
InfoProveedorD			= NULLIF(@CorteCuentaDe, ''),
InfoProveedorA			= NULLIF(@CorteCuentaA, ''),
InfoSucursal				= ISNULL(@Sucursal, -1),
InfoEstatusEspecifico	= @CorteEstatus,
InfoMoneda				= CASE
WHEN @CorteMoneda = '(Todas)' THEN NULL
ELSE @CorteMoneda
END,
InformeGraficarTipo		= '(Todos)',
InfoTitulo				= ISNULL(@CorteTitulo, ''),
InfoModulo				= 'CXP',
VerGraficaDetalle		= 0
WHERE Estacion = @Estacion
EXEC spCorteCxpEstadoCuentaSimple @Estacion, 1, @ID
END
RETURN
END

