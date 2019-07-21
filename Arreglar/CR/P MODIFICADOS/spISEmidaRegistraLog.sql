SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spISEmidaRegistraLog
@ID				int,
@Empresa		varchar(5),
@iSolicitud		int,
@Resultado		xml

AS
BEGIN
DECLARE @UbicacionLogTransacciones	varchar(255),
@LogTransacciones				bit,
@ExisteArchivo				int,
@ManejadorObjeto				int,
@IDArchivo					int,
@Ok							int,
@OkRef						varchar(255),
@Solicitud					xml,
@iResultado					int,
@Referencia					varchar(100),
@FechaRecarga					datetime,
@EmpresaTran					varchar(5),
@productId					varchar(255),
@clerkId						varchar(20),
@accountId					varchar(10),
@amount						float,
@invoiceNo					int,
@terminalId					varchar(20),
@ResponseCode					varchar(2),
@Pin							varchar(255),
@ControlNo					varchar(20),
@CarrierControlNo				varchar(20),
@TransactionId				varchar(20),
@Log							varchar(max),
@Encabezados					varchar(max)
SELECT @LogTransacciones = ISNULL(LogTransacciones, 0), @UbicacionLogTransacciones = ISNULL(RTRIM(UbicacionLogTransacciones), '') FROM EmidaCfg WITH (NOLOCK)  WHERE Empresa = @Empresa
IF @LogTransacciones = 0 OR(@LogTransacciones = 1 AND @UbicacionLogTransacciones = '') RETURN
SELECT @Solicitud = Solicitud, @Referencia = Referencia, @FechaRecarga = FechaEstatus FROM IntelisisService WITH (NOLOCK)  WHERE ID = @ID
SELECT @EmpresaTran = Empresa,
@productId   = productId,
@clerkId	  = clerkId,
@accountId   = accountId,
@amount	  = amount,
@invoiceNo   = invoiceNo,
@terminalId  = terminalId
FROM OPENXML (@iSolicitud, '/Intelisis/Solicitud/Emida',1)
WITH (Empresa varchar(5), terminalId varchar(20), clerkId varchar(20), productId varchar(255), accountId varchar(10), amount varchar(10), invoiceNo varchar(20))
EXEC sp_xml_preparedocument @iResultado OUTPUT, @Resultado
SELECT @ResponseCode	   = ResponseCode,
@Pin			   = Pin,
@ControlNo		   = ControlNo,
@CarrierControlNo = CarrierControlNo,
@TransactionId	   = TransactionId
FROM OPENXML(@iResultado, '/Intelisis/Resultado/PinDistSaleResponse', 2)
WITH (ResponseCode varchar(2), Pin varchar(255), ControlNo varchar(20), CarrierControlNo varchar(20), TransactionId varchar(20))
EXEC sp_xml_removedocument @iResultado
SELECT @Log = dbo.fnFormatoFecha(@FechaRecarga, 'dd/MM/aaaa hh:nn:ss') + ',' +
CONVERT(varchar(max), @accountId) + ',' +
CONVERT(varchar(max), @productId) + ',' +
CONVERT(varchar(max), @amount) + ',' +
CONVERT(varchar(max), @invoiceNo) + ',' +
CONVERT(varchar(max), @terminalId) + ',' +
CONVERT(varchar(max), @ResponseCode) + ',' +
CONVERT(varchar(max), @Pin) + ',' +
CONVERT(varchar(max), @ControlNo) + ',' +
CONVERT(varchar(max), @CarrierControlNo) + ',' +
CONVERT(varchar(max), @TransactionId) + '
'
SELECT @Encabezados = 'FechaRecarga,' + 'AccountID,' + 'ProductID,' + 'Amount,' + 'InvoiceNo,' + 'TerminalID,' + 'ResponseCode,' + 'Pin,' + 'ControlNo,' + 'CarrierControlNo,' + 'TransactionID
'
EXEC spVerificarArchivo @UbicacionLogTransacciones, @ExisteArchivo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @ExisteArchivo = 0 AND @Ok IS NULL
BEGIN
EXEC spCrearArchivo @UbicacionLogTransacciones, @ManejadorObjeto OUTPUT, @IDArchivo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spInsertaTextoEnArchivo @IDArchivo, @Encabezados, @Ok OUTPUT, @OkRef OUTPUT
END
ELSE IF @ExisteArchivo = 1 AND @Ok IS NULL
EXEC spAbreArchivo @UbicacionLogTransacciones, @ManejadorObjeto OUTPUT, @IDArchivo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spInsertaTextoEnArchivo @IDArchivo, @Log, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spCerrarArchivo @IDArchivo, @ManejadorObjeto, @Ok OUTPUT, @OkRef OUTPUT
END

