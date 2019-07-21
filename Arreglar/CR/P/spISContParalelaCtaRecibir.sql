SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spISContParalelaCtaRecibir
@ID					int,
@Mov				varchar(20),
@MovID				varchar(20),
@Usuario			varchar(10),
@iSolicitud			int,
@Version			float,
@BaseDatosRemota	varchar(255),
@EmpresaRemota		varchar(5),
@Empresa			varchar(5),
@CuentaD			varchar(20),
@CuentaA			varchar(20),
@Nivel				varchar(10),
@CPBaseLocal		bit,
@CPBaseDatos		varchar(255),
@CPURL				varchar(255),
@CPCentralizadora	bit,
@IDEmpresa			int,
@Resultado			varchar(max)	OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS BEGIN
DECLARE @MovRecibir		varchar(20),
@FechaEmision		datetime,
@ContMID			int,
@Conexion			bit
IF @CPBaseLocal = 1
SELECT @Conexion = 1
ELSE
BEGIN TRAN
SELECT @FechaEmision = GETDATE()
EXEC spExtraerFecha @FechaEmision OUTPUT
SELECT @MovRecibir = CPRecibirCuentas FROM EmpresaCfgMovContParalela WHERE Empresa = @Empresa
SELECT Cuenta, Rama, Descripcion, Tipo, EsAcreedora, EsAcumulativa, Categoria, Grupo, Familia, Estatus, TieneMovimientos
INTO #Cuentas
FROM OPENXML (@iSolicitud, '/Intelisis/Solicitud/ContParalelaD',1)
WITH (Cuenta			varchar(20),
Rama				varchar(20),
Descripcion		varchar(100),
Tipo				varchar(15),
EsAcreedora		bit,
EsAcumulativa		bit,
Categoria			varchar(50),
Grupo				varchar(50),
Familia			varchar(50),
Estatus			varchar(15),
TieneMovimientos	bit)
ALTER TABLE #Cuentas ADD RID INT identity
IF NOT EXISTS(SELECT * FROM #Cuentas)
BEGIN
SELECT @Ok = 60010
RETURN
END
INSERT INTO ContParalela(
Empresa,  Mov,         FechaEmision,  Usuario, Estatus,      Sucursal,  SucursalOrigen,  SucursalDestino,  CuentaD,  CuentaA,  BaseDatosOrigen,  EmpresaOrigen,  Nivel,  IDEmpresa, Referencia)
SELECT @Empresa, @MovRecibir, @FechaEmision, @Usuario, 'SINAFECTAR', 0,         0,               0,               @CuentaD, @CuentaA, @BaseDatosRemota, @EmpresaRemota, @Nivel, @IDEmpresa, RTRIM(@Mov)+' '+RTRIM(@MovID)
SELECT @ContMID = SCOPE_IDENTITY()
INSERT INTO ContParalelaD(
ID,      Renglon,  Cuenta, Rama, Descripcion, Tipo, Categoria, Grupo, Familia, EsAcreedora, EsAcumulativa, Estatus, TieneMovimientos)
SELECT @ContMID, RID*2048, Cuenta, Rama, Descripcion, Tipo, Categoria, Grupo, Familia, EsAcreedora, EsAcumulativa, Estatus, TieneMovimientos
FROM #Cuentas
EXEC spAfectar 'CONTP', @ContMID, 'AFECTAR', NULL, NULL, @Usuario, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @Conexion = 1
IF @CPBaseLocal = 0
BEGIN
IF @Ok IS NULL
COMMIT TRAN
ELSE
ROLLBACK TRAN
END
IF @Ok IS NULL
SELECT @Resultado = XML FROM ContParalelaXML WHERE ID = @ContMID
RETURN
END

