SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spISContParalelaPaqueteRecibir
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
DECLARE @MovRecibir			varchar(20),
@FechaEmision			datetime,
@ContMID				int,
@Conexion				bit,
@CONTEsCancelacion	bit
SELECT @CONTEsCancelacion = 0
IF @CPBaseLocal = 1
SELECT @Conexion = 1
ELSE
BEGIN TRAN
SELECT @FechaEmision = GETDATE()
EXEC spExtraerFecha @FechaEmision OUTPUT
SELECT @MovRecibir = CPRecepcionPaq FROM EmpresaCfgMovContParalela WHERE Empresa = @Empresa
SELECT ID, Empresa, Mov, MovID, FechaEmision, FechaContable, Concepto, Proyecto, UEN, Contacto, ContactoTipo, Moneda, TipoCambio, Usuario, Referencia, Estatus, OrigenTipo, Origen, OrigenID, Ejercicio, Periodo, Sucursal, Importe, RecepcionFecha, RecepcionMoneda, RecepcionTipoCambio, OrigenMoneda, OrigenTipoCambio, 0 'Transformada'
INTO #Cont
FROM OPENXML (@iSolicitud, '/Intelisis/Solicitud/Cont',1)
WITH (ID					int,
Empresa				varchar(5),
Mov					varchar(20),
MovID					varchar(20),
FechaEmision			datetime,
FechaContable			datetime,
Concepto				varchar(50),
Proyecto				varchar(50),
UEN					int,
Contacto				varchar(10),
ContactoTipo			varchar(20),
Moneda				varchar(10),
TipoCambio			float,
Usuario				varchar(10),
Referencia			varchar(10),
Estatus				varchar(15),
OrigenTipo			varchar(5),
Origen				varchar(20),
OrigenID				varchar(20),
Ejercicio				int,
Periodo				int,
Sucursal				int,
Importe				float,
RecepcionFecha		datetime,
RecepcionMoneda		varchar(10),
RecepcionTipoCambio	float,
OrigenMoneda			varchar(10),
OrigenTipoCambio		float)
ALTER TABLE #Cont ADD RID int IDENTITY
IF (SELECT COUNT(*) FROM #Cont) = 1
BEGIN
IF(SELECT Estatus FROM #Cont) = 'CANCELADO'
SELECT @CONTEsCancelacion = 1
END
SELECT ID, Renglon, RenglonSub, Cuenta, Debe, Haber, 0 'Transformada'
INTO #ContD
FROM OPENXML (@iSolicitud, '/Intelisis/Solicitud/Cont/ContD',1)
WITH (ID			int,
Renglon		float,
RenglonSub	int,
Cuenta		varchar(20),
Debe			float,
Haber			float)
SELECT DISTINCT ContID, ID, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Moneda, TipoCambio, Usuario, Referencia, Estatus, ContactoTipo, Contacto, Almacen, Condicion, Vencimiento, Importe, Impuestos, Ejercicio, Periodo, MovTipo, SubMovTipo, Modulo, 0 'Transformada'
INTO #Origen
FROM OPENXML (@iSolicitud,  '/Intelisis/Solicitud/Cont/ContD/Origen',1)
WITH (ContID			int '../@ID',
ContactoTipo		varchar(20),
ID				int,
Mov				varchar(20),
MovID				varchar(20),
FechaEmision		datetime,
Concepto			varchar(50),
Proyecto			varchar(50),
UEN				int,
Moneda			varchar(10),
TipoCambio		float,
Usuario			varchar(10),
Referencia		varchar(10),
Estatus			varchar(15),
Contacto			varchar(10),
Almacen			varchar(10),
Condicion			varchar(50),
Vencimiento		datetime,
Importe			float,
Impuestos			float,
Ejercicio			int,
Periodo			int,
MovTipo			varchar(20),
SubMovTipo		varchar(20),
Modulo			varchar(5))
SELECT DISTINCT ContactoTipo, Contacto, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, RFC, CURP, Categoria, Grupo, Familia
INTO #Contacto
FROM OPENXML (@iSolicitud,  '/Intelisis/Solicitud/Cont/ContD/Origen/Contacto',1)
WITH (ContactoTipo			varchar(20)		'../@ContactoTipo',
Contacto				varchar(20),
Nombre				varchar(100),
Direccion				varchar(100),
DireccionNumero		varchar(20),
DireccionNumeroInt	varchar(20),
EntreCalles			varchar(100),
Delegacion			varchar(100),
Colonia				varchar(100),
Poblacion				varchar(100),
Estado				varchar(30),
Pais					varchar(30),
CodigoPostal			varchar(15),
RFC					varchar(15),
CURP					varchar(30),
Categoria				varchar(50),
Grupo					varchar(50),
Familia				varchar(50))
IF NOT EXISTS(SELECT * FROM #Cont)
BEGIN
SELECT @Ok = 60010
RETURN
END
INSERT INTO ContParalela(
Empresa,  Mov,         FechaEmision,  Usuario, Estatus,      Sucursal,  SucursalOrigen,  SucursalDestino,  BaseDatosOrigen,  EmpresaOrigen,  IDEmpresa, Referencia,                     CONTEsCancelacion)
SELECT @Empresa, @MovRecibir, @FechaEmision, @Usuario, 'SINAFECTAR', 0,         0,               0,               @BaseDatosRemota, @EmpresaRemota, @IDEmpresa, RTRIM(@Mov)+' '+RTRIM(@MovID), @CONTEsCancelacion
SELECT @ContMID = SCOPE_IDENTITY()
INSERT INTO ContParalelaD(
ID,      Renglon,  ContID, ContMov, ContMovID, ContFechaEmision, ContOrigenTipo, ContOrigen, ContOrigenID)
SELECT @ContMID, RID*2048, ID,     Mov,     MovID,     FechaEmision,     OrigenTipo,     Origen,     OrigenID
FROM #Cont
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

