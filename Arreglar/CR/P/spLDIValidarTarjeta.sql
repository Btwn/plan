SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spLDIValidarTarjeta
@Servicio			varchar(20),
@ID			varchar(36),
@NoTarjeta			varchar(36),
@Empresa                   varchar(5),
@Usuario                   varchar(10),
@Sucursal                  int,
@Importe			float = NULL OUTPUT,
@Ok			int = NULL	OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT,
@OkRefLDI	                varchar(500) = NULL OUTPUT,
@Mostrar                   bit = 0,
@Modulo                    varchar(5) = 'POS'

AS BEGIN
DECLARE @Cadena			nvarchar(2048),
@CadenaRespuesta		nvarchar(2048),
@MensajeError			nvarchar(2048),
@DireccionIP			varchar(15),
@Puerto			varchar(10),
@TiempoEspera			nvarchar(4),
@Cliente			varchar(10),
@ImporteOUT			varchar(20),
@OkLDI	varchar(255),
@Mensaje	varchar(255),
@Voucher				varchar(MAX),
@Voucher2				varchar(MAX),
@Banco			varchar(255)
/* Tiempo Espera, es el tiempo maximo que la DLL local, espera respuesta del servidor de LDI, en caso de no recibirla en ese tiempo, responderá cadena con error */
SELECT @TiempoEspera = '45'
/* Determina la direccion a donde se enviara */
SELECT @DireccionIP = pls.DireccionIP,
@Puerto = pls.Puerto
FROM LDIServicio pls
WHERE pls.Servicio = @Servicio
IF @Ok IS NULL
EXEC spLDIGeneraCadena @Servicio, @ID, @NoTarjeta, NULL, @Cadena OUTPUT, @Importe, NULL, @Modulo, @Ok OUTPUT, @OkRef OUTPUT, NULL, NULL,0,0, @Empresa, @Sucursal
EXEC usp_EnviarMensaje @Cadena, @DireccionIP, @Puerto, @TiempoEspera, @CadenaRespuesta OUTPUT, @MensajeError OUTPUT
/* Determina si fue exitosa o hubo error */
EXEC spLDIAnalizaCadena @CadenaRespuesta, '14', @OkLDI OUTPUT
/* Si @MensajeError Es diferente de NULL, significa que hubo error de conexion */
IF @MensajeError IS NOT NULL
SELECT @Ok = 2, @OkRef = @MensajeError
/* Determina el voucher */
EXEC spLDIAnalizaCadena @CadenaRespuesta, '163', @Voucher OUTPUT
EXEC spLDIAnalizaCadena @CadenaRespuesta, '27', @Banco OUTPUT
IF @Voucher IS NOT NULL OR @Banco IS NOT NULL AND @Modulo = 'POS'
BEGIN
INSERT POSLRefBancaria (ID, Voucher, Banco)
VALUES                (@ID, @Voucher, @Banco)
SELECT @Voucher2 = REPLACE(@Voucher,'^',':')
IF NOT EXISTS (SELECT * FROM POSLDIVentaID WHERE ID = @ID)AND @Modulo = 'POS'
INSERT POSLDIVentaID(ID,Referencia2)
SELECT              @ID,@Voucher2
IF EXISTS (SELECT * FROM POSLDIVentaID WHERE ID = @ID)
UPDATE POSLDIVentaID SET Referencia2= @Voucher2 WHERE ID = @ID
END
/* Si @OKLDI es diferente de 0, es que hubo error de LDI o de los proveedores de servicio*/
IF @Ok IS NULL AND @OkLDI <> 0
BEGIN
EXEC spLDIAnalizaCadena @CadenaRespuesta, '16', @OkRefLDI OUTPUT
SELECT @Ok = 2, @OkRef = 'El Proveedor de transacción mandó el mensaje ' + @OkRefLDI
END
IF @Ok IS NULL
BEGIN
/* Inserta el dato del monedero solo cuando se dio de alta*/
IF @Servicio = 'MON CONSULTA'
BEGIN
EXEC spLDIAnalizaCadena @CadenaRespuesta, '45', @Importe OUTPUT
SELECT @Importe = ISNULL(@Importe,0.0)
END
END
IF @Ok IS NULL AND @Mostrar = 1
SELECT @Importe
IF @Ok IS NOT NULL AND @Mostrar = 1
SELECT @OkRefLDI
END

