SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContParalelaVerificar
@ID               	int,
@Accion				char(20),
@Empresa          	char(5),
@Usuario			char(10),
@Modulo	      		char(5),
@Mov              	char(20),
@MovID				varchar(20),
@MovTipo	      	char(20),
@FechaEmision		datetime,
@Estatus			char(15),
@EstatusNuevo		char(15),
@CuentaD			varchar(20),
@CuentaA			varchar(20),
@BaseDatos			varchar(255),
@EmpresaOrigen		varchar(5),
@CPBaseLocal		bit,
@CPBaseDatos		varchar(255),
@CPURL				varchar(255),
@CPCentralizadora	bit,
@CPUsuario			varchar(10),
@CPContrasena		varchar(32),
@ISReferencia		varchar(100),
@OrigenTipo			varchar(5),
@Origen				varchar(20),
@OrigenID			varchar(20),
@IDEmpresa			int,
@GeneraEjercicio	int,
@GeneraPeriodo		int,
@GeneraFechaD		datetime,
@GeneraFechaA		datetime,
@GeneraEmpresaOrigen int,
@GeneraMov			varchar(20),
@GeneraMovID		varchar(20),
@GeneraContMov		varchar(20),
@GeneraContMovID	varchar(20),
@GeneraContID		int,
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@Ok               	int          OUTPUT,
@OkRef            	varchar(255) OUTPUT

AS BEGIN
DECLARE @CPPaquete			varchar(20),
@DiasPaquete			int,
@CfgMaximoDiasPaquete	int,
@Debe					float,
@Haber				float,
@DeEjercicio			int,
@AEjercicio			int,
@DePeriodo			int,
@APeriodo				int
SELECT @CfgMaximoDiasPaquete = ISNULL(CONTPMaximoDiasPaquete, 1) FROM EmpresaCfg2 WHERE Empresa = @Empresa
SELECT @CPPaquete = CPPaquete FROM EmpresaCfgMovContParalela WHERE Empresa = @Empresa
IF @CPCentralizadora = 0
BEGIN
IF @Ok IS NULL AND @CPBaseLocal = 1 AND @CPBaseDatos IS NULL
SELECT @Ok = 10700
IF @Ok IS NULL AND @CPBaseLocal = 0 AND @CPURL IS NULL
SELECT @Ok = 10701
IF @Ok IS NULL AND @MovTipo = 'CONTP.RECIBIRCUENTA'
SELECT @Ok = 10702
IF @Ok IS NULL AND @MovTipo IN('CONTP.GENERADORPAQ') AND @GeneraEjercicio IS NULL
SELECT @Ok = 10050
IF @Ok IS NULL AND @MovTipo IN('CONTP.GENERADORPAQ') AND @GeneraPeriodo IS NULL
SELECT @Ok = 10051
IF @Ok IS NULL AND @MovTipo = 'CONTP.PAQUETE' AND (@GeneraFechaD IS NULL OR @GeneraFechaA IS NULL)
SELECT @Ok = 55245
IF @Ok IS NULL AND @MovTipo = 'CONTP.RECIBIRPAQUETE'
SELECT @Ok = 10706
IF @Ok IS NULL AND @MovTipo = 'CONTP.TRANSFORMACION'
SELECT @Ok = 10708
IF @Ok IS NULL AND @MovTipo = 'CONTP.CIERRE'
SELECT @Ok = 10710
IF @Ok IS NULL AND @MovTipo = 'CONTP.PAQUETE'
BEGIN
SELECT @DiasPaquete = DATEDIFF(D, @GeneraFechaD, @GeneraFechaA)
IF @DiasPaquete > @CfgMaximoDiasPaquete
SELECT @Ok = 10707, @OkRef = RTRIM(@Mov)+' '+RTRIM(@MovID)
END
END
IF @CPCentralizadora = 1
BEGIN
IF @Ok IS NULL AND @MovTipo = 'CONTP.ENVIARCUENTAS'
SELECT @Ok = 10703
IF @Ok IS NULL AND @MovTipo IN('CONTP.GENERADORPAQ', 'CONTP.PAQUETE')
SELECT @Ok = 10705, @OkRef = @Mov
IF @Ok IS NULL AND @MovTipo = 'CONTP.RECIBIRCUENTA' AND @OrigenTipo IS NULL AND @Origen IS NULL AND @OrigenID IS NULL AND @Conexion = 0
SELECT @Ok = 46020, @OkRef = @Mov
IF @Ok IS NULL AND @MovTipo IN('CONTP.TRANSFORMACION', 'CONTP.CIERRE') AND @GeneraEjercicio IS NULL
SELECT @Ok = 10050
IF @Ok IS NULL AND @MovTipo IN('CONTP.TRANSFORMACION') AND @GeneraEmpresaOrigen IS NULL
SELECT @Ok = 10711
IF @Ok IS NULL AND @MovTipo IN('CONTP.TRANSFORMACION', 'CONTP.CIERRE') AND @GeneraPeriodo IS NULL
SELECT @Ok = 10051
IF @Ok IS NULL AND @MovTipo IN('CONTP.POLIZA')
BEGIN
SELECT @Debe = SUM(Debe), @Haber = SUM(Haber) FROM ContParalelaD WHERE ID = @ID
IF @Debe <> @Haber
SELECT @Ok = 50010
END
IF @Ok IS NULL AND @MovTipo IN('CONTP.RECIBIRPAQUETE')
BEGIN
SELECT DISTINCT @IDEmpresa IDEmpresa, YEAR(ContFechaEmision) Ejercicio, MONTH(ContFechaEmision) Periodo
INTO #PeriodoCerrado
FROM ContParalelaD
WHERE ID = @ID
IF EXISTS(SELECT * FROM ContParalelaPeriodoCierre c JOIN #PeriodoCerrado e ON c.IDEmpresa = e.IDEmpresa AND c.Ejercicio = e.Ejercicio AND c.Periodo = e.Periodo)
SELECT @Ok = 60110
END
IF @Ok IS NULL AND @MovTipo IN('CONTP.TRANSFORMACION', 'CONTP.POLIZA')
BEGIN
IF EXISTS(SELECT * FROM ContParalelaPeriodoCierre WHERE IDEmpresa = ISNULL(@GeneraEmpresaOrigen, IDEmpresa) AND Ejercicio = @GeneraEjercicio AND Periodo = @GeneraPeriodo)
SELECT @Ok = 60110
END
IF @Ok IS NULL AND @MovTipo IN('CONTP.POLIZA') AND @OrigenTipo IS NULL
SELECT @Ok = 10709
END
IF @Accion = 'CANCELAR'
BEGIN
IF @MovTipo IN('CONTP.ENVIARCUENTAS', 'CONTP.RECIBIRCUENTA', 'CONTP.RECIBIRPAQUETE')
SELECT @Ok = 60050, @OkRef = RTRIM(@Mov)+' '+RTRIM(@MovID)
IF @MovTipo IN('CONTP.PAQUETE') AND @Estatus = 'CONCLUIDO'
SELECT @Ok = 60050, @OkRef = RTRIM(@Mov)+' '+RTRIM(@MovID)
IF @Conexion = 0
IF EXISTS (SELECT * FROM MovFlujo WHERE Cancelado = 0 AND Empresa = @Empresa AND DModulo = @Modulo AND DID = @ID AND OModulo <> DModulo)
SELECT @Ok = 60070
IF @MovTipo = 'CONTP.GENERADORPAQ' AND EXISTS(SELECT ID FROM ContParalela WHERE Mov = @CPPaquete AND OrigenTipo = 'CONTP' AND Origen = @Mov AND OrigenID = @MovID AND Estatus = 'CONCLUIDO')
SELECT @Ok = 60060, @OkRef = RTRIM(@Mov)+' '+RTRIM(@MovID)
END
RETURN
END

