SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spProyGenerarMov
@IDProyecto int,
@Modulo     varchar(20),
@Mov        varchar(20),
@Empresa	varchar(5),
@Sucursal	int,
@Usuario	varchar(10),
@Proyecto   varchar(50),
@Proveedor  varchar(50)

AS BEGIN
DECLARE
@MovID          varchar(20),
@MovTipo        varchar(20),
@Origen         varchar(20),
@OrigenID       varchar(20),
@FechaEmision   datetime,
@Almacen        varchar(10),
@Articulo	    varchar(20),
@SerieLote	    varchar(50),
@Ok		        int,
@OkRef	        varchar(255),
@AlmTipo	    varchar(20),
@ArtTipo	    varchar(20),
@ID		        int,
@Costo	        float,
@Moneda	        varchar(10),
@TipoCambio	    float,
@UEN			int,
@ConceptoRH		varchar(255),
@ConceptoStaff	varchar(255),
@ImporteRH		float,
@Renglon		float,
@Acreedor		varchar(50),
@ArticuloMP		varchar(255),
@AlmacenMP		varchar(255),
@CantidadMP		int,
@UnidadMP		varchar(50),
@SubCuentaMP	varchar(255),
@Impuesto1MP	float,
@Impuesto2MP	float,
@Impuesto3MP	float,
@FactorMP		float,
@DuracionDias	float,
@CostoHora		float,
@HorasDia		float,
@UltimoCostoArt	float,
@CfgCostoSugerido	varchar(50),
@ClienteProy	varchar(50)
SET @Ok = null
SET @OkRef = null
SELECT @Moneda = Moneda,
@TipoCambio = TipoCambio,
@Origen = Mov,
@OrigenID = MovID,
@ClienteProy = Cliente
FROM Proyecto
WHERE ID = @IDProyecto
SELECT @CfgCostoSugerido = CompraCostoSugerido FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @UEN = UEN FROM UEN WHERE NOMBRE = @Moneda
IF @Modulo NOT IN ('VTAS','COMS','GAS','CXP','CXC')
SELECT @Ok = 1, @OkRef = 'Error: Solo es posible generar movimientos de Ventas, Compras, Gastos, Cuentas por Pagar o Cuentas por Cobrar'
IF @Ok IS NULL AND @Modulo = 'VTAS'
BEGIN
SELECT @Ok = NULL, @OkRef = NULL
IF EXISTS (SELECT * FROM Venta WHERE Mov = @Mov AND OrigenTipo = 'PROY' AND Origen = @Origen AND OrigenID = @OrigenID AND ESTATUS = 'CONCLUIDO')
BEGIN
SELECT @Ok = 80001, @OkRef = 'Error: ya existe un movimiento '+@Mov+' de Ventas. Si desea agregar un nuevo movimiento necesita cancelar el existente.'
END
ELSE
BEGIN
SELECT TOP 1 @AlmacenMP = Almacen FROM PROYECTODArtMaterial WHERE ID = @IDProyecto
INSERT Venta (Empresa,     Mov,    FechaEmision,   UltimoCambio,	Cliente,		Almacen,		Proyecto,   Moneda,		Estatus,		Usuario,  Sucursal,	 TipoCambio,  UEN,	OrigenTipo, Origen,	OrigenID)
VALUES       (@Empresa,    @Mov,   GETDATE(),      GETDATE(),		@ClienteProy,	@AlmacenMP,		@Proyecto,  @Moneda,	'SINAFECTAR',   @Usuario, @Sucursal, @TipoCambio, @UEN,	'PROY',		@Origen,@OrigenID)
SELECT @ID = SCOPE_IDENTITY()
EXEC spAfectar @Modulo, @ID, 'CONSECUTIVO'
SELECT @MovID = MovID FROM Venta WHERE ID = @ID
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, 'PROY', @IDProyecto, @Origen, @OrigenID, @Modulo, @ID, @Mov, @MovID, @Ok OUTPUT
END 
END
IF @Ok IS NULL AND @Modulo = 'COMS'
BEGIN
SELECT @Ok = NULL, @OkRef = NULL
IF EXISTS (SELECT * FROM Compra WHERE Mov = @Mov AND Proveedor = @Proveedor AND OrigenTipo = 'PROY' AND Origen = @Origen AND OrigenID = @OrigenID AND ESTATUS = 'CONCLUIDO')
BEGIN
SELECT @Ok = 80001, @OkRef = 'Error: ya existe un movimiento '+@Mov+' en el modulo de Compras con el proveedor '+@Proveedor+'.<BR>Si desea agregar un nuevo movimiento necesita cancelar el existente.'
END
ELSE
BEGIN
INSERT Compra (Empresa,     Mov,    FechaEmision,   UltimoCambio,   Proyecto,   Moneda,      Estatus,       Usuario,  Sucursal,	 TipoCambio,  UEN,	Proveedor,	OrigenTipo, Origen, OrigenID)
VALUES        (@Empresa,    @Mov,   GETDATE(),      GETDATE(),      @Proyecto,  @Moneda,    'SINAFECTAR',   @Usuario, @Sucursal, @TipoCambio, @UEN,	@Proveedor, 'PROY', @Origen, @OrigenID)
SELECT @ID = SCOPE_IDENTITY()
EXEC spAfectar @Modulo, @ID, 'CONSECUTIVO'
SELECT @MovID = MovID FROM Compra WHERE ID = @ID
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, 'PROY', @IDProyecto, @Origen, @OrigenID, @Modulo, @ID, @Mov, @MovID, @Ok OUTPUT
END 
END
IF @Ok IS NULL AND @Modulo = 'GAS'
BEGIN
SELECT @Ok = NULL, @OkRef = NULL
IF EXISTS (SELECT * FROM Gasto WHERE Mov = @Mov AND Acreedor = @Proveedor AND OrigenTipo = 'PROY' AND Origen = @Origen AND OrigenID = @OrigenID AND ESTATUS = 'CONCLUIDO')
BEGIN
SELECT @Ok = 80001, @OkRef = 'Error: ya existe un movimiento '+@Mov+' en el modulo de Gastos con el acreedor '+@Proveedor+'.<BR>Si desea agregar un nuevo movimiento con este mismo proveedor, necesita cancelar el existente.'
END
ELSE
BEGIN
INSERT Gasto (Empresa,     Mov,    FechaEmision,   UltimoCambio,   Proyecto,   Moneda,      Estatus,       Usuario,  Sucursal,	 TipoCambio,  UEN,	Acreedor,	OrigenTipo, Origen, OrigenID)
VALUES       (@Empresa,    @Mov,   GETDATE(),      GETDATE(),      @Proyecto,  @Moneda,    'SINAFECTAR',   @Usuario, @Sucursal, @TipoCambio, @UEN,	@Proveedor, 'PROY',		@Origen, @OrigenID)
SELECT @ID = SCOPE_IDENTITY()
EXEC spAfectar @Modulo, @ID, 'CONSECUTIVO'
SELECT @MovID = MovID FROM Gasto WHERE ID = @ID
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, 'PROY', @IDProyecto, @Origen, @OrigenID, @Modulo, @ID, @Mov, @MovID, @Ok OUTPUT
END 
END
IF @Ok IS NULL AND @Modulo = 'CXP'
BEGIN
SELECT @Ok = NULL, @OkRef = NULL
IF EXISTS (SELECT * FROM Cxp WHERE Mov = @Mov AND Proveedor = @Proveedor AND OrigenTipo = 'PROY' AND Origen = @Origen AND OrigenID = @OrigenID AND ESTATUS = 'CONCLUIDO')
BEGIN
SELECT @Ok = 80001, @OkRef = 'Error: ya existe un movimiento '+@Mov+' en el modulo de Cuentas por Pagar con el proveedor '+@Proveedor+'.<BR>Si desea agregar un nuevo movimiento con este mismo proveedor, necesita cancelar el existente.'
END
ELSE
BEGIN
INSERT Cxp (Empresa,     Mov,    FechaEmision,   UltimoCambio,	Proyecto,   Moneda,		TipoCambio,		Usuario,	Estatus,		Proveedor,	ProveedorMoneda,ProveedorTipoCambio,	Importe,	OrigenTipo,	Origen,		OrigenID,	Sucursal,	SucursalOrigen,	UEN,	LineaCredito)
VALUES     (@Empresa,    @Mov,   GETDATE(),      GETDATE(),		@Proyecto,  @Moneda,	@TipoCambio,	@Usuario,	'SINAFECTAR',	@Proveedor,	@Moneda,		@TipoCambio,			0.0,		'PROY',		@Origen,	@OrigenID,	@Sucursal,	@Sucursal,		@UEN,	0)
SELECT @ID = SCOPE_IDENTITY()
EXEC spAfectar @Modulo, @ID, 'CONSECUTIVO'
SELECT @MovID = MovID FROM Cxp WHERE ID = @ID
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, 'PROY', @IDProyecto, @Origen, @OrigenID, @Modulo, @ID, @Mov, @MovID, @Ok OUTPUT
END 
END
IF @Ok IS NULL AND @Modulo = 'CXC'
BEGIN
SELECT @Ok = NULL, @OkRef = NULL
IF EXISTS (SELECT * FROM Cxc WHERE Mov = @Mov AND OrigenTipo = 'PROY' AND Origen = @Origen AND OrigenID = @OrigenID AND ESTATUS = 'CONCLUIDO')
BEGIN
SELECT @Ok = 80001, @OkRef = 'Error: ya existe un movimiento '+@Mov+' en el modulo de Cuentas por Cobrar.<BR>Si desea agregar un nuevo movimiento necesita cancelar el existente.'
END
ELSE
BEGIN
INSERT Cxc (Empresa,     Mov,    FechaEmision,   UltimoCambio,	Proyecto,	Moneda,		TipoCambio,		Usuario,	Estatus,		Cliente,		ClienteMoneda,	ClienteTipoCambio,	Importe,	OrigenTipo, Origen,		OrigenID,	Sucursal,	SucursalOrigen,	UEN)
VALUES     (@Empresa,    @Mov,   GETDATE(),      GETDATE(),		@Proyecto,	@Moneda,	@TipoCambio,	@Usuario,	'SINAFECTAR',	@ClienteProy,	@Moneda,		@TipoCambio,		0.0,		'PROY',		@Origen,	@OrigenID,	@Sucursal,	@Sucursal,		@UEN)
SELECT @ID = SCOPE_IDENTITY()
EXEC spAfectar @Modulo, @ID, 'CONSECUTIVO'
SELECT @MovID = MovID FROM Cxc WHERE ID = @ID
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, 'PROY', @IDProyecto, @Origen, @OrigenID, @Modulo, @ID, @Mov, @MovID, @Ok OUTPUT
END 
END
IF @Ok IS NOT NULL AND @OkRef IS NOT NULL
BEGIN
SELECT @OkRef = Descripcion+' '+ISNULL(RTRIM(@OkRef), '')
FROM MensajeLista
WHERE Mensaje = @Ok
END
IF @Ok = NULL
SELECT 'Se Genero '+@Mov+ ' (por Confirmar)'
ELSE
SELECT @OkRef
RETURN
END

