SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCorteVerificar
@ID               	int,
@Accion				char(20),
@Empresa          	char(5),
@Usuario			char(10),
@Modulo	      		char(5),
@Mov              	char(20),
@MovID				varchar(20),
@MovTipo	      	char(20),
@SubMovTipo	      	char(20),
@FechaEmision		datetime,
@Estatus			char(15),
@EstatusNuevo		char(15),
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
@Estacion			int,
@CorteFiltrarFechas	bit,
@Ok               	int          OUTPUT,
@OkRef            	varchar(255) OUTPUT

AS
BEGIN
DECLARE @VigenciaD		datetime,
@VigenciaA		datetime,
@CorteNoPeriodos	int,
@CorteTipoPeriodo	varchar(3)
SELECT @VigenciaD			= VigenciaD,
@VigenciaA			= VigenciaA,
@CorteNoPeriodos	= CorteNoPeriodos,
@CorteTipoPeriodo	= CorteTipoPeriodo
FROM Corte
WHERE ID = @ID
IF ISNULL(@TipoCambio, 0) = 0
BEGIN
SELECT @Ok = 30140, @OkRef = @Moneda
RETURN
END
IF ISNULL(@MovTipo, '') = 'CORTE.REPEXTERNO' AND ISNULL(@CorteOrigen, '') IN('Intelisis', '') AND @Accion = 'AFECTAR'
BEGIN
SELECT @Ok = 20380
RETURN
END
IF ISNULL(@MovTipo, '') = 'CORTE.REPEXTERNO' AND NOT EXISTS(SELECT ID FROM CorteDReporte WHERE ID = @ID) AND @Accion = 'AFECTAR'
BEGIN
SELECT @Ok = 60010
RETURN
END
IF ISNULL(@MovTipo, '') IN('CORTE.CORTEIMPORTE') AND @Accion = 'AFECTAR'
BEGIN
IF EXISTS(SELECT ID FROM CorteDConsulta WHERE ID = @ID AND ISNULL(Totalizador, '') = '')
BEGIN
SELECT @Ok = 10010, @OkRef = 'Totalizador'
RETURN
END
IF @Ok IS NULL AND NOT EXISTS(SELECT ID FROM CorteDConsulta WHERE ID = @ID)
BEGIN
SELECT @Ok = 60010
RETURN
END
IF @Ok IS NULL AND EXISTS(SELECT RID FROM CorteDConsulta WHERE ID = @ID AND ISNULL(Modulo, '') IN('', '(TODOS)'))
BEGIN
SELECT @Ok = 70020, @OkRef = Modulo
FROM CorteDConsulta
WHERE ID = @ID
AND ISNULL(Modulo, '') IN('', '(TODOS)')
RETURN
END
IF @Ok IS NULL AND ISNULL(@CorteFiltrarFechas, 0) = 1 AND(@CorteFechaD IS NULL OR @CorteFechaA IS NULL)
BEGIN
SELECT @Ok = 46100
RETURN
END
IF @Ok IS NULL AND ISNULL(@CorteFiltrarFechas, 0) = 0 AND @CorteEjercicio IS NULL AND @CortePeriodo IS NULL
BEGIN
SELECT @Ok = 10050
RETURN
END
IF EXISTS(SELECT CorteDConsulta.Totalizador, CorteMovTotalizadorTipoCampo.Tipo
FROM CorteDConsulta
LEFT OUTER JOIN CorteMovTotalizadorTipoCampo ON CorteDConsulta.Totalizador = CorteMovTotalizadorTipoCampo.Totalizador
WHERE CorteDConsulta.ID = @ID
AND Tipo IS NULL)
BEGIN
SELECT @Ok = 10386, @OkRef = CorteDConsulta.Totalizador
FROM CorteDConsulta
LEFT OUTER JOIN CorteMovTotalizadorTipoCampo ON CorteDConsulta.Totalizador = CorteMovTotalizadorTipoCampo.Totalizador
WHERE CorteDConsulta.ID = @ID
AND Tipo IS NULL
RETURN
END
IF (SELECT COUNT(DISTINCT CorteMovTotalizadorTipoCampo.Tipo)
FROM CorteDConsulta
LEFT OUTER JOIN CorteMovTotalizadorTipoCampo ON CorteDConsulta.Totalizador = CorteMovTotalizadorTipoCampo.Totalizador
WHERE CorteDConsulta.ID = @ID) > 1
BEGIN
SELECT @Ok = 10387
RETURN
END
END
IF ISNULL(@MovTipo, '') IN('CORTE.CORTECONTABLE') AND @Accion = 'AFECTAR'
BEGIN
IF NOT EXISTS(SELECT ID FROM CorteDConsulta WHERE ID = @ID)
BEGIN
SELECT @Ok = 60010
RETURN
END
IF @Ok IS NULL AND ISNULL(@CorteFiltrarFechas, 0) = 1 AND(@CorteFechaD IS NULL OR @CorteFechaA IS NULL)
BEGIN
SELECT @Ok = 46100
RETURN
END
IF @Ok IS NULL AND ISNULL(@CorteFiltrarFechas, 0) = 0 AND @CorteEjercicio IS NULL AND @CortePeriodo IS NULL
BEGIN
SELECT @Ok = 10050
RETURN
END
IF @Ok IS NULL AND ISNULL(@CorteFiltrarFechas, 0) = 0 AND @CorteEjercicio IS NULL
BEGIN
SELECT @Ok = 10050
RETURN
END
IF EXISTS(SELECT RID FROM CorteDConsulta WHERE ID = @ID AND ISNULL(Modulo, '') NOT IN('CONT'))
BEGIN
SELECT @Ok = 70020, @OkRef = Modulo
FROM CorteDConsulta
WHERE ID = @ID
AND ISNULL(Modulo, '') NOT IN('CONT')
RETURN
END
END
IF ISNULL(@MovTipo, '') IN('CORTE.EDOCTACXC') AND @Accion = 'AFECTAR'
BEGIN
IF @Ok IS NULL AND @CorteFechaD IS NULL AND ISNULL(@SubMovTipo, '') = ''
BEGIN
SELECT @Ok = 41020
RETURN
END
END
IF ISNULL(@MovTipo, '') IN('CORTE.CORTECX') AND @Accion = 'AFECTAR'
BEGIN
IF @Ok IS NULL AND EXISTS(SELECT RID FROM CorteDConsulta WHERE ID = @ID AND ISNULL(Modulo, '') IN('', '(TODOS)'))
BEGIN
SELECT @Ok = 70020, @OkRef = Modulo
FROM CorteDConsulta
WHERE ID = @ID
AND ISNULL(Modulo, '') IN('', '(TODOS)')
RETURN
END
IF @Ok IS NULL AND NOT EXISTS(SELECT ID FROM CorteDConsulta WHERE ID = @ID)
BEGIN
SELECT @Ok = 60010
RETURN
END
END
IF ISNULL(@SubMovTipo, '') IN('CORTE.GENERACORTECON', 'CORTE.GENERACORTECX', 'CORTE.GENERACORTEIMP', 'CORTE.GENERACORTEU') AND @Accion = 'AFECTAR'
BEGIN
IF @VigenciaD IS NULL OR @VigenciaA IS NULL
BEGIN
SELECT @Ok = 10095
RETURN
END
IF ISNULL(@CorteTipoPeriodo, '') = ''
BEGIN
SELECT @Ok = 55140
RETURN
END
IF ISNULL(@CorteNoPeriodos, 0) = 0
BEGIN
SELECT @Ok = 10385
RETURN
END
END
RETURN
END

