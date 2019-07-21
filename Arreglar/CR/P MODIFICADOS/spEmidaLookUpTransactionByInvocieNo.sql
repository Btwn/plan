SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spEmidaLookUpTransactionByInvocieNo
@Estacion		int,
@Empresa		varchar(5),
@Sucursal		int,
@Usuario		varchar(10),
@Contrasena		varchar(32),
@URL			varchar(255),
@version		varchar(2),
@terminalId		varchar(20),
@clerkId		varchar(20),
@invoiceNo		varchar(20),
@Reintentos		int,
@Resultado		varchar(max)	OUTPUT,
@Ok				int				OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS
BEGIN
DECLARE @Solicitud		varchar(max),
@NoReintento		int,
@iResultado		int,
@ResponseCode		varchar(2),
@ResponseMessage	varchar(250),
@TimeOutLookup	int,		
@Delay			varchar(10)	
SELECT @TimeOutLookup = ISNULL(TimeOutLookup, 10) FROM EmidaCfg WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT @Delay = '00:00:' + CONVERT(varchar(2), @TimeOutLookup)
SELECT @NoReintento = 1
WHILE(@NoReintento<=@Reintentos)
BEGIN
SELECT @Ok = NULL, @OkRef = NULL
SELECT @Solicitud = '<Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Emida.LookupTransaction" SubReferencia="" Version="' + ISNULL(@Version, '') + '">' +
'  <Solicitud>' +
'    <Emida Estacion="' + CONVERT(varchar, ISNULL(@Estacion, 0)) + '" Empresa="' + ISNULL(dbo.fneDocXmlAUTF8(@Empresa, 0, 1), '') + '" URL="' + ISNULL(@URL, '') + '" terminalId="' + ISNULL(@terminalId, '') + '" Version="' + ISNULL(@Version, '') + '" Sucursal="' + CONVERT(varchar, ISNULL(@Sucursal, 0)) +'" clerkId="' + ISNULL(@clerkId, '') + '" invoiceNo="' + ISNULL(@invoiceNo, '') + '" IntentoNumero="' + CONVERT(varchar, @NoReintento) + '" />' +
'  </Solicitud>' +
'</Intelisis>'
EXEC spIntelisisService @Usuario, @Contrasena, @Solicitud, @Resultado = @Resultado OUTPUT, @Procesar = 1, @EliminarProcesado = 0, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL RETURN
WAITFOR DELAY @Delay
SELECT @NoReintento = @NoReintento + 1
END
RETURN
END

