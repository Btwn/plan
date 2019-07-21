SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spEmidaRecargaTelefonica
@Modulo			varchar(5),
@ModuloID		int,
@Estacion		int,
@Empresa		varchar(5),
@Sucursal		int,
@Usuario		varchar(10),
@Ok				int			 = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS
BEGIN
DECLARE @Renglon				int,
@RenglonAnt			int,
@Articulo				varchar(20), 
@URL					varchar(255),
@version				varchar(2),
@terminalId			varchar(20),
@clerkId				varchar(20),
@CarrierId			varchar(255),
@ProductId			varchar(255),
@Description			varchar(255),
@ShortDescription		varchar(255),
@RecargaTelefono			varchar(10), 
@RecargaConfirmarTelefono	varchar(10), 
@amount				varchar(10),
@invoiceNo			varchar(20),
@languageOption		varchar(2),
@Solicitud			varchar(max),
@Contrasena			varchar(32),
@Fecha				datetime,
@Reintentos			int,
@Resultado			varchar(max),
@iResultado			int,
@EmidaControlNo		varchar(20),
@EmidaCarrierControlNo varchar(20), 
@EmidaTransactionId	varchar(20),
@EmidaResponseMessage	varchar(500),
@EmidaTransactionDateTime	datetime,
@EmidaResponseCode	varchar(2)
SELECT @Contrasena = Contrasena FROM Usuario WITH (NOLOCK) WHERE Usuario = @Usuario
SELECT @version = Version, @Reintentos = Reintentos FROM EmidaCfg WITH (NOLOCK) WHERE Empresa = @Empresa
IF @Modulo = 'VTAS'
SELECT @ClerkID = Agente.ClerkID
FROM Agente WITH (NOLOCK)
JOIN Venta WITH (NOLOCK) ON Agente.Agente = Venta.Agente
WHERE ID = @ModuloID
SELECT @RenglonAnt = 0
WHILE(1=1)
BEGIN
IF @Modulo = 'VTAS'
SELECT @Renglon = MIN(Renglon)
FROM VentaD WITH (NOLOCK)
JOIN Art WITH (NOLOCK) ON VentaD.Articulo = Art.Articulo AND ISNULL(Art.EmidaRecargaTelefonica, 0) = 1
WHERE ID = @ModuloID
AND Renglon > @RenglonAnt
IF @Renglon IS NULL BREAK
SELECT @RenglonAnt = @Renglon
SELECT @Articulo = Articulo, @RecargaTelefono = ISNULL(RecargaTelefono, ''), @RecargaConfirmarTelefono = ISNULL(RecargaConfirmarTelefono, '') FROM VentaD WITH (NOLOCK) WHERE ID = @ModuloID AND Renglon = @Renglon
SELECT @URL = URL, @CarrierId = CarrierId, @ProductId = ProductId, @Description = Description, @ShortDescription = ShortDescription, @amount = amount,
@languageOption = '02'
FROM EmidaProductCfg WITH (NOLOCK)
WHERE Articulo = @Articulo
SELECT @terminalId = dbo.fnEmidaSiteID(@Empresa, @URL, @Sucursal, @Usuario)
EXEC spEmidaInvoiceNo @Estacion, @Empresa, @URL, 'CONSECUTIVO', @Sucursal, @Usuario, @invoiceNo OUTPUT 
IF @Ok IS NULL
BEGIN
SELECT @Solicitud = '<Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Emida.RecargaTelefonica" SubReferencia="" Version="' + ISNULL(@Version, '') + '">' +
'  <Solicitud>' +
'    <Emida Estacion="' + CONVERT(varchar, ISNULL(@Estacion, 0)) + '" Empresa="' + ISNULL(dbo.fneDocXmlAUTF8(@Empresa, 0, 1), '') + '" URL="' + ISNULL(@URL, '') + '" terminalId="' + ISNULL(@terminalId, '') + '" Version="' + ISNULL(@Version, '') + '" Sucursal="' + CONVERT(varchar, ISNULL(@Sucursal, 0)) +'" productId="' + ISNULL(@productId, '') + '" clerkId="' + ISNULL(@clerkId, '') + '" accountId="' + ISNULL(@RecargaTelefono, '') + '" amount="' + ISNULL(@amount, '') + '" invoiceNo="' + ISNULL(@invoiceNo, '') + '" languageOption="' + ISNULL(@languageOption, '') + '" Usuario="' + @Usuario +'" Contrasena="' + @Contrasena + '" />' +  
'  </Solicitud>' +
'</Intelisis>'
EXEC spIntelisisService @Usuario, @Contrasena, @Solicitud, @Resultado = @Resultado OUTPUT, @Procesar = 1, @EliminarProcesado = 0, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
IF @Ok IS NULL
BEGIN
SELECT @OkRef = NULL
EXEC sp_xml_preparedocument @iResultado OUTPUT, @Resultado
SELECT @EmidaControlNo = ControlNo, @EmidaTransactionId = TransactionId, @EmidaResponseMessage = ResponseMessage,
@EmidaTransactionDateTime = TransactionDateTime, @EmidaResponseCode = ResponseCode,
@EmidaCarrierControlNo = CarrierControlNo 
FROM OPENXML(@iResultado, '/Intelisis/Resultado/PinDistSaleResponse', 2)
WITH(CarrierControlNo varchar(20), ControlNo varchar(20), TransactionId varchar(20), ResponseMessage varchar(500), TransactionDateTime datetime, ResponseCode varchar(2))
UPDATE Venta WITH (ROWLOCK)
SET RecargaTelefono = @RecargaTelefono, 
EmidaResponseCode = @EmidaResponseCode,
EmidaControlNo = @EmidaControlNo,
EmidaCarrierControlNo = @EmidaCarrierControlNo, 
EmidaTransactionId = @EmidaTransactionId,
EmidaResponseMessage = @EmidaResponseMessage,
EmidaTransactionDateTime = @EmidaTransactionDateTime
FROM Venta WITH(NOLOCK)
WHERE ID = @ModuloID
EXEC sp_xml_removedocument @iResultado
EXEC spEmidaInvoiceNo @Estacion, @Empresa, @URL, 'AFECTAR', @Sucursal, @Usuario 
END
END
RETURN
END

