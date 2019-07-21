SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSHerrTransferirVale
@Estacion		int,
@Empresa		varchar(5),
@Usuario		varchar(10),
@Sucursal		int

AS BEGIN
DECLARE
@Cliente			varchar(10),
@ID					int,
@FechaEmision		datetime,
@Ok					int,
@OkRef				varchar(255),
@OKRefLDI			varchar(500),
@MonederoD			varchar(20),
@MonederoA			varchar(20),
@Mov				varchar(20),
@MovID				varchar(20),
@MovCanc				varchar(20),
@TipoCambio			float,
@IDNuevo			int,
@IDNuevoCanc			int,
@ArticuloTarjeta	varchar(20),
@AlmacenTarjeta		varchar(10),
@Importe			float,
@MonederoLDI		bit,
@Moneda				varchar(10),
@Saldo				float,
@MonedaMovOrig		varchar(10)
DECLARE @LDILog table(
IDModulo                varchar(36),
Modulo                  varchar(5),
Servicio                varchar(50),
Fecha                   varchar(20),
TipoTransaccion         varchar(50),
TipoSubservicio         varchar(50),
CodigoRespuesta         varchar(50),
DescripcionRespuesta    varchar(255),
OrigenRespuesta         varchar(50),
InfoAdicional           varchar(50),
IDTransaccion           varchar(50),
CodigoAutorizacion      varchar(50),
Importe                 float,
Comprobante             varchar(Max),
Cadena                  varchar(Max),
CadenaRespuesta         varchar(Max),
RIDCobro                int)
SELECT  @FechaEmision = dbo.fnFechaSinHora(GETDATE())
SELECT @MonederoLDI = ISNULL(MonederoLDI,0) FROM POSCfg WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT @ArticuloTarjeta= CxcArticuloTarjetasDef ,@AlmacenTarjeta= CxcAlmacenTarjetasDef
FROM EmpresaCfg WITH(NOLOCK)
WHERE Empresa = @Empresa
SELECT @Mov = MovTraspasoVale FROM POSCfg WITH(NOLOCK) WHERE Empresa = @Empresa
IF @Mov IS NULL
SELECT TOP 1 @Mov = Mov FROM MovTipo WITH(NOLOCK) WHERE Modulo = 'VALE' AND Clave = 'VALE.TT'
IF @Ok IS NULL
BEGIN
IF @Ok IS NULL
BEGIN
DECLARE crArticulo CURSOR FOR
SELECT ID, MonederoD,MonederoA
FROM POSHerrTraspasoVale
WHERE Estacion = @Estacion AND NULLIF(MonederoD,'') IS NOT NULL AND NULLIF(MonederoA,'') IS NOT NULL
OPEN crArticulo
FETCH NEXT FROM crArticulo INTO @ID, @MonederoD, @MonederoA
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
BEGIN TRANSACTION
SELECT @Ok = NULL ,@OkRef = NULL
IF NOT EXISTS(SELECT * FROM ValeSerie WITH(NOLOCK) WHERE Serie = @MonederoD AND Estatus = 'CIRCULACION')
SELECT @Ok = 36043, @OkRef = @MonederoD
IF NOT EXISTS(SELECT * FROM ValeSerie WITH(NOLOCK) WHERE Serie = @MonederoA AND Estatus = 'DISPONIBLE')
SELECT @Ok = 36031, @OkRef = @MonederoA
SET @Saldo = 0.0
SELECT @Saldo = dbo.fnVerSaldoVale(@MonederoD)
SELECT @Moneda = Moneda FROM ValeSerie WHERE Serie =@MonederoD
SELECT @TipoCambio = TipoCambio FROM Mon WITH(NOLOCK) WHERE Moneda = @Moneda
IF @Ok IS NULL
BEGIN
INSERT INTO Vale (Empresa, Mov, FechaEmision, Moneda, TipoCambio, Usuario, Estatus, Sucursal, SucursalOrigen, SucursalDestino, TarjetaDestino)
SELECT @Empresa, @Mov, @FechaEmision, @Moneda, @TipoCambio, @Usuario,'SINAFECTAR', @Sucursal, @Sucursal, @Sucursal, @MonederoA
IF @@ERROR <> 0 SET @Ok = 1
SELECT @IDNuevo = SCOPE_IDENTITY()
INSERT ValeD( ID, Serie, Sucursal, SucursalOrigen, Importe)
SELECT @IDNuevo, @MonederoD, @Sucursal, @Sucursal, ISNULL(@Saldo,0.0)
IF @MonederoLDI = 1
EXEC spPOSLDIValidarTarjeta  'MON CONSULTA',@IDNuevo, @MonederoD, @Empresa, @Usuario, @Sucursal, @Importe OUTPUT, @Ok OUTPUT, @OkRef  OUTPUT, @OKRefLDI OUTPUT ,0,'VALE'
IF ROUND(@Saldo,4)<> ROUND(@Importe,4)
SELECT @Ok = 25500, @OkRef = @OkRef+' ('+@MonederoD+')'
IF @@ERROR <> 0 SET @Ok = 1
IF @OK IS NULL
EXEC spAfectar 'VALE', @IDNuevo, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
IF @MonederoLDI = 1 AND @Ok IS NULL
EXEC spPOSLDI 'MON ALTA REEMPLAZO', @IDNuevo, @MonederoD, @Empresa, @Usuario, @Sucursal, @MonederoA, NULL, 1, NULL, @Ok OUTPUT, @OkRef OUTPUT, 'VALE'
IF @Ok IS NULL BEGIN
SELECT TOP 1 @MovCanc = Mov FROM MovTipo WHERE Modulo = 'VALE' and Clave = 'VALE.CT'
INSERT INTO Vale (Empresa, Mov, FechaEmision, Moneda, TipoCambio, Usuario, Estatus, Sucursal, SucursalOrigen, SucursalDestino, TarjetaDestino )
SELECT            @Empresa, @MovCanc, @FechaEmision, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', @Sucursal, @Sucursal, @Sucursal, @MonederoD
IF @@ERROR <> 0 SET @Ok = 1
SELECT @IDNuevoCanc = SCOPE_IDENTITY()
INSERT ValeD(ID, Serie, Sucursal, SucursalOrigen, Importe)
SELECT       @IDNuevoCanc, @MonederoD, @Sucursal,  @Sucursal, 0.0
EXEC spAfectar 'VALE', @IDNuevoCanc, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
END
IF @Ok IS NOT NULL AND EXISTS(SELECT * FROM POSLDIIDTemp WITH(NOLOCK) WHERE Estacion = @@SPID)
BEGIN
INSERT @LDILog(IDModulo, Modulo, Servicio, Fecha, TipoTransaccion, TipoSubservicio, CodigoRespuesta, DescripcionRespuesta, OrigenRespuesta,InfoAdicional, IDTransaccion, CodigoAutorizacion, Comprobante, Cadena, CadenaRespuesta, Importe, RIDCobro)
SELECT IDModulo, Modulo, Servicio, Fecha, TipoTransaccion, TipoSubservicio, CodigoRespuesta, DescripcionRespuesta, OrigenRespuesta,InfoAdicional, IDTransaccion, CodigoAutorizacion, Comprobante, Cadena, CadenaRespuesta, Importe, RIDCobro
FROM POSLDILog WITH(NOLOCK)
WHERE IDModulo = @IDNuevo AND Modulo = 'VALE' AND ID IN(SELECT ID FROM POSLDIIDTemp WITH(NOLOCK) WHERE Estacion = @@SPID)
END
DELETE POSLDIIDTemp WHERE Estacion = @@SPID
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
END
ELSE
ROLLBACK TRANSACTION
IF EXISTS(SELECT * FROM @LDILog)
BEGIN
INSERT POSLDILog(IDModulo, Modulo, Servicio, Fecha, TipoTransaccion, TipoSubservicio, CodigoRespuesta, DescripcionRespuesta, OrigenRespuesta,InfoAdicional, IDTransaccion, CodigoAutorizacion, Comprobante, Cadena, CadenaRespuesta, Importe, RIDCobro)
SELECT IDModulo, Modulo, Servicio, Fecha, TipoTransaccion, TipoSubservicio, CodigoRespuesta, DescripcionRespuesta, OrigenRespuesta,InfoAdicional, IDTransaccion, CodigoAutorizacion, Comprobante, Cadena, CadenaRespuesta, Importe, RIDCobro
FROM @LDILog
END
IF @Ok IS NOT NULL
UPDATE POSHerrTraspasoVale WITH(ROWLOCK) SET Error = @OkRef  WHERE ID = @ID
IF @Ok IS NULL
BEGIN
DELETE  POSHerrTraspasoVale   WHERE ID = @ID
END
FETCH NEXT FROM crArticulo INTO @ID, @MonederoD, @MonederoA
END
CLOSE crArticulo
DEALLOCATE crArticulo
END
END
IF @Ok IS NOT NULL
SELECT @OkRef = ISNULL(Descripcion,'') + ' '+ISNULL(@OkRef,'')
FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
IF @Ok IS NULL
SELECT @OkRef = 'PROCESO CONCLUIDO'
SELECT @OkRef
END

