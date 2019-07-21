SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSHerrCancelarVale
@Estacion   int,
@Empresa    varchar(5),
@Usuario    varchar(10),
@Sucursal   int

AS
BEGIN
DECLARE
@Cliente             varchar(10),
@ID                  int,
@FechaEmision        datetime,
@Ok                  int,
@OkRef               varchar(255),
@OKRefLDI            varchar(500),
@Monedero            varchar(20),
@Mov                 varchar(20),
@MovID               varchar(20),
@TipoCambio          float,
@IDNuevo             int,
@ArticuloTarjeta     varchar(20),
@AlmacenTarjeta      varchar(10),
@Importe             float,
@MonederoLDI         bit,
@Moneda              varchar(10),
@Saldo               float,
@SugerirFechaCierre  bit,
@FechaCierre         datetime
SELECT @FechaEmision = dbo.fnFechaSinHora(GETDATE())
SELECT @Moneda =  DefMoneda
FROM Usuario WITH(NOLOCK)
WHERE Usuario = @Usuario
SELECT @MonederoLDI = ISNULL(MonederoLDI,0)
FROM POSCfg WITH(NOLOCK)
WHERE Empresa = @Empresa
SELECT @TipoCambio = TipoCambio
FROM Mon WITH(NOLOCK)
WHERE Moneda = @Moneda
SELECT @ArticuloTarjeta= CxcArticuloTarjetasDef ,@AlmacenTarjeta= CxcAlmacenTarjetasDef
FROM EmpresaCfg WITH(NOLOCK)
WHERE Empresa = @Empresa
SELECT @Mov = MovCancelacion
FROM POSCfg WITH(NOLOCK)
WHERE Empresa = @Empresa
IF @Mov IS NULL
SELECT TOP 1 @Mov = Mov FROM MovTipo WITH(NOLOCK) WHERE Modulo = 'VALE' AND Clave = 'VALE.CT'
IF @Ok IS NULL
BEGIN
IF @Ok IS NULL
BEGIN
DECLARE crArticulo CURSOR FOR
SELECT ID, Monedero, Cliente
FROM POSHerrCancelacionVale WITH(NOLOCK)
WHERE ID IN (SELECT ID FROM ListaID WITH(NOLOCK) WHERE Estacion = @Estacion)AND Monedero IS NOT NULL
OPEN crArticulo
FETCH NEXT FROM crArticulo INTO @ID, @Monedero, @Cliente
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
BEGIN TRANSACTION
SELECT @Ok = NULL ,@OkRef = NULL
SET @Saldo = 0.0
SELECT @Saldo = dbo.fnVerSaldoVale(@Monedero)
IF @Saldo > 0.0
BEGIN
INSERT INTO Vale (
Empresa, Mov, FechaEmision, Moneda, TipoCambio, Usuario, Estatus, Sucursal, Cliente, SucursalOrigen,
SucursalDestino, Articulo, Almacen)
SELECT
@Empresa, @Mov, @FechaEmision, @Moneda, @TipoCambio, @Usuario,'SINAFECTAR', @Sucursal, @Cliente, @Sucursal,
@Sucursal, @ArticuloTarjeta, @AlmacenTarjeta
IF @@ERROR <> 0
SET @Ok = 1
SELECT @IDNuevo = SCOPE_IDENTITY()
INSERT ValeD(
ID, Serie, Sucursal, SucursalOrigen,Importe)
SELECT
@IDNuevo, @Monedero, @Sucursal, @Sucursal, ISNULL(@Saldo,0.0)
IF @@ERROR <> 0
SET @Ok = 1
IF @OK IS NULL
EXEC spAfectar 'VALE', @IDNuevo, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1,
@Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @MonederoLDI = 1
EXEC spPOSLDIValidarTarjeta  'MON CONSULTA',@IDNuevo, @Monedero,@Empresa,@Usuario,@Sucursal,
@Importe OUTPUT, @Ok OUTPUT, @OkRef  OUTPUT, @OKRefLDI OUTPUT ,0,'VALE'
IF @OKRefLDI = 'Tarjeta no registrada'
SELECT @Ok = 1 , @OkRef = @OKRefLDI
IF @Ok IS NULL
IF @MonederoLDI = 1 AND ISNULL(@Importe,0.0) >0.0
EXEC spPOSLDI 'MON CARGO', @IDNuevo, @Monedero, @Empresa, @Usuario, @Sucursal, NULL, @Importe, 1, NULL,
@Ok OUTPUT, @OkRef OUTPUT, 'VALE'
END
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
END
ELSE
ROLLBACK TRANSACTION
IF @Ok IS NOT NULL
UPDATE POSHerrCancelacionVale WITH(ROWLOCK) SET Error = @OkRef  WHERE ID = @ID
IF @Ok IS NULL
BEGIN
DELETE  POSHerrCancelacionVale WHERE ID = @ID
END
FETCH NEXT FROM crArticulo INTO @ID, @Monedero, @Cliente
END
CLOSE crArticulo
DEALLOCATE crArticulo
END
END
IF @Ok IS NULL
SELECT @OkRef = 'PROCESO CONCLUIDO'
SELECT @OkRef
END

