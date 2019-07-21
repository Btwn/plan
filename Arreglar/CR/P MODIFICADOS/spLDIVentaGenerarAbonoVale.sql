SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spLDIVentaGenerarAbonoVale
@Empresa		char(5),
@Modulo			char(10),
@ID			int,
@Mov			char(20),
@MovID			varchar(20),
@MovTipo		char(20),
@Accion			char(20),
@FechaEmision		datetime,
@Ejercicio		int,
@Periodo		int,
@Usuario		char(10),
@Sucursal		int,
@MovMoneda		char(10),
@MovTipoCambio		float,
@Importe                float,
@Ok 			int 		OUTPUT,
@OkRef 			varchar(255)	OUTPUT

AS
BEGIN
DECLARE
@IDVale         int,
@MovGenerar     varchar(20),
@Cliente        varchar(10),
@Articulo       varchar(20),
@Monedero       varchar(50),
@TipoMonedero   varchar(50),
@RenglonID      int,
@ArtTipo        varchar(50),
@Almacen	  varchar(10),
@AlmacenTipo	  varchar(15),
@ValeMovID      varchar(20),
@OkVale 	  int ,
@OkRefVale 	  varchar(255),
@CadenaRespuesta varchar(8000),
@Cadena         varchar(8000)
SELECT TOP 1 @MovGenerar = Mov FROM MovTipo  WITH (NOLOCK) WHERE Clave = 'VALE.AMLDI' AND Modulo = 'VALE'
SELECT @Cliente = v.Cliente
FROM Venta v WITH (NOLOCK)   WHERE v.ID = @ID
SELECT @AlmacenTipo = Tipo FROM Alm  WITH (NOLOCK) WHERE Almacen = @Almacen
SELECT TOP 1 @Monedero = Serie FROM TarjetaSeriemov WITH (NOLOCK)   WHERE Empresa = @Empresa AND Modulo = 'VTAS' AND ID = @ID
SELECT  @TipoMonedero = Tipo FROM ValeSerie WITH (NOLOCK)  WHERE Serie = @Monedero
IF @Accion = 'AFECTAR'
BEGIN
IF @Ok IS NULL
BEGIN
INSERT Vale(Empresa, Mov,          FechaEmision, Moneda,     TipoCambio,     Usuario,  Estatus,      Sucursal,  Tipo,          Precio, Importe,  Cantidad,  Articulo,   Almacen,   OrigenTipo, Origen, OrigenID, Cliente)
SELECT      @Empresa,@MovGenerar, @FechaEmision, @MovMoneda, @MovTipoCambio, @Usuario, 'SINAFECTAR', @Sucursal, @TipoMonedero, @Importe,     @Importe,     1,    NULL,       NULL,      @Modulo,    @Mov,   @MovID , @Cliente
SELECT @IDVale = SCOPE_IDENTITY()
INSERT ValeD(ID,      Serie,      Sucursal, SucursalOrigen,Importe)
SELECT       @IDVale, @Monedero, @Sucursal, @Sucursal,     @Importe
IF @OK IS NULL
EXEC spAfectar 'VALE', @IDVale, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
SELECT @ValeMovID = MovID FROM Vale WITH (NOLOCK)  WHERE ID = @IDVale
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'VALE', @IDVale, @MovGenerar, @ValeMovID, @Ok OUTPUT
END
IF @Ok IS NULL AND (SELECT Estatus FROM Vale WITH (NOLOCK)  WHERE ID = @IDVale)='PENDIENTE'
BEGIN
SAVE TRANSACTION Vale
EXEC spAfectar 'VALE', @IDVale, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion =1, @Ok = @OkVale OUTPUT, @OkRef = @OkRefVale OUTPUT
IF @OkVale IS NOT NULL
BEGIN
SELECT TOP 1 @Cadena = Cadena ,@CadenaRespuesta = CadenaRespuesta FROM LDIMovLog WITH (NOLOCK)  WHERE IDModulo = @IDVale AND Modulo = 'VALE' ORDER BY ID DESC
ROLLBACK TRANSACTION Vale
EXEC spLDIGenerarLOG  @Empresa, 'VALE', @IDVale, 'MON ABONO', @Cadena, @CadenaRespuesta, @Importe, @Ok  OUTPUT, @OkRef  OUTPUT
END
ELSE
SELECT @Ok = @OkVale, @OKRef = @OkRefVale
END
END
IF @Accion = 'CANCELAR' AND @Ok IS NULL
BEGIN
SELECT @IDVale = ID FROM Vale WITH (NOLOCK)  WHERE Origen = @Mov AND OrigenID = @MovID AND OrigenTipo = 'VTAS' AND @Empresa = @Empresa
EXEC spAfectar 'VALE', @IDVale, 'CANCELAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
RETURN
END

