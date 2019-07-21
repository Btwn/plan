SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSLDIFacCred
@Servicio				varchar(20),
@ID						varchar(36),
@NoTarjeta				varchar(36),
@Empresa                varchar(5),
@Usuario                varchar(10),
@Sucursal               int,
@NoTarjetaReemplazo		varchar(36) = NULL,
@Importe				float = NULL,
@EnSilencio				bit = 0,
@NoTelefono				varchar(10) = NULL,
@Ok						int = NULL				OUTPUT,
@OkRef					varchar(255) = NULL		OUTPUT,
@Modulo					varchar(5) = 'POS',
@Cuenta                 varchar(255) = NULL,
@Referencia             varchar(255) = NULL,
@RIDCobro               int = NULL,
@ADO                    bit = 0,
@Mes                    varchar(2) = NULL,
@Ano                    varchar(4) = NULL,
@FechaD                 datetime = NULL,
@FechaA                 datetime = NULL,
@ImporteS				float = NULL			OUTPUT

AS
BEGIN
DECLARE
@Cadena					nvarchar(2048),
@CadenaRespuesta		nvarchar(2048),
@MensajeError			nvarchar(2048),
@DireccionIP			varchar(15),
@Puerto					varchar(10),
@TiempoEspera			nvarchar(4),
@Cliente				varchar(10),
@ImporteOUT				varchar(20),
@OkLDI					varchar(255),
@OkRefLDI               varchar(500),
@Mensaje                varchar(255),
@Voucher                varchar(MAX),
@Voucher2               varchar(MAX),
@Banco					varchar(255),
@IDLDI                  int,
@MonedaMonedero         varchar(10),
@Moneda                 varchar(10),
@TipoCambio             float,
@MonederoTipoCambio		float
IF @Modulo = 'POS'
IF NOT EXISTS (SELECT * FROM POSL WHERE ID = @ID)
SELECT @Ok = 14055
IF @Modulo = 'NOM'
IF NOT EXISTS (SELECT * FROM Nomina WHERE ID = @ID)
SELECT @Ok = 14055
DELETE POSLDIIDTemp WHERE Estacion = @@SPID
/* TIEMPO ESPERA, ES EL TIEMPO MAXIMO QUE LA DLL LOCAL, ESPERA RESPUESTA DEL SERVIDOR DE LDI, EN CASO DE NO RECIBIRLA EN ESE TIEMPO, RESPONDERa CADENA CON ERROR */
SELECT @TiempoEspera = '45'
/* DETERMINA LA DIRECCION A DONDE SE ENVIARA */
SELECT
@DireccionIP = pls.DireccionIP,
@Puerto = pls.Puerto
FROM POSLDIServicio pls
WHERE pls.Servicio = @Servicio
IF @Ok IS NULL
EXEC spPOSLDIGeneraCadena @Servicio, @ID, @NoTarjeta, @NoTarjetaReemplazo, @Cadena OUTPUT, @Importe, @NoTelefono, @Modulo,
@Ok OUTPUT, @OkRef OUTPUT, @Cuenta, @Referencia
IF @OK IS NULL
EXEC usp_EnviarMensaje @Cadena, @DireccionIP, @Puerto, @TiempoEspera, @CadenaRespuesta OUTPUT, @MensajeError OUTPUT
IF NULLIF(@CadenaRespuesta,'') IS NULL
SELECT @Ok = 2, @OkRef ='El Proveedor No envio Ninguna Respuesta'
/* DETERMINA SI FUE EXITOSA O HUBO ERROR */
EXEC spPOSLDIAnalizaCadena @CadenaRespuesta, '14', @OkLDI OUTPUT
/* SI @MENSAJEERROR ES DIFERENTE DE NULL, SIGNIFICA QUE HUBO ERROR DE CONEXION */
IF @MensajeError IS NOT NULL
SELECT @Ok = 2, @OkRef = @MensajeError
/* DETERMINA EL VOUCHER */
EXEC spPOSLDIAnalizaCadena @CadenaRespuesta, '163', @Voucher OUTPUT
EXEC spPOSLDIAnalizaCadena @CadenaRespuesta, '27', @Banco OUTPUT
IF @Voucher IS NOT NULL OR @Banco IS NOT NULL AND @Modulo = 'POS'
BEGIN
INSERT POSLRefBancaria (
ID, Voucher, Banco)
VALUES (
@ID, @Voucher, @Banco)
SELECT @Voucher2 = REPLACE(@Voucher,'^',':')
IF NOT EXISTS (SELECT * FROM POSLDIVentaID WHERE ID = @ID)
INSERT POSLDIVentaID(
ID, Referencia2)
SELECT
@ID, @Voucher2
IF EXISTS (SELECT * FROM POSLDIVentaID WHERE ID = @ID)
UPDATE POSLDIVentaID SET Referencia2= @Voucher2 WHERE ID = @ID
END
/* SI @OKLDI ES DIFERENTE DE 0, ES QUE HUBO ERROR DE LDI O DE LOS PROVEEDORES DE SERVICIO*/
IF @Ok IS NULL AND @OkLDI <> 0
BEGIN
EXEC spPOSLDIAnalizaCadena @CadenaRespuesta, '16', @OkRefLDI OUTPUT
SELECT @Ok = 2, @OkRef = 'El Proveedor de transacción mandó el mensaje ' + @OkRefLDI
END
IF @Ok IS NULL
BEGIN
IF @Servicio = 'MON CONSULTA'
BEGIN
DELETE POSLDISaldoMonederoTemp WHERE Estacion = @@SPID
SELECT @MonedaMonedero = Moneda, @Cliente = Cliente
FROM POSValeSerie
WHERE Serie = @NoTarjeta
SELECT @Moneda = Moneda, @TipoCambio = TipoCambio
FROM POSLTipoCambioRef
WHERE EsPrincipal = 1 AND Sucursal = @Sucursal
SELECT @MonederoTipoCambio = TipoCambio
FROM POSLTipoCambioRef
WHERE Sucursal = @Sucursal AND Moneda = @MonedaMonedero
EXEC spPOSLDIAnalizaCadena @CadenaRespuesta, '45', @Importe OUTPUT
SELECT @ImporteS = ISNULL(@Importe,0)
END
END
END

