SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spEmidaDineroSubmitPayment
@Modulo			varchar(5),
@ModuloID		int,
@Empresa		varchar(5),
@Estacion		int,
@Usuario		varchar(10),
@Sucursal		int,
@Ok				int			 = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS
BEGIN
DECLARE @OrigenModuloID		int,
@OrigenModuloIDAnt	int,
@CarrierID			int,
@CtaDinero			varchar(10),
@Version				varchar(2),
@terminalId			varchar(20),
@clerkId				varchar(20),
@URL					varchar(255),
@bankCode				varchar(20),
@iResultado			int,
@Resultado			varchar(max),
@Solicitud			varchar(max),
@Fecha				datetime,
@Contrasena			varchar(32),
@amount				float,
@documentNumber		varchar(25),
@documentDate			datetime,
@documentDateTexto	varchar(10),
@OkDesc				varchar(255),
@OkTipo				varchar(50),
@EmidaRequestId		varchar(20)
SELECT @Version = Version FROM EmidaCfg WITH (NOLOCK) WHERE Empresa = @Empresa
SELECT @Fecha = GETDATE()
SELECT @Contrasena = Contrasena FROM Usuario WITH (NOLOCK) WHERE Usuario = @Usuario
SELECT @documentNumber = Referencia,
@documentDate	 = FechaEmision,
@amount		 = ISNULL(Importe, 0)
FROM Dinero WITH (NOLOCK)
WHERE ID = @ModuloID
IF DATEPART(mm, @documentDate) < 10
SELECT @documentDateTexto = '0' + CONVERT(varchar, DATEPART(mm, @documentDate)) + '/'
ELSE
SELECT @documentDateTexto = CONVERT(varchar, DATEPART(mm, @documentDate)) + '/'
IF DATEPART(dd, @documentDate) < 10
SELECT @documentDateTexto = @documentDateTexto + '0' + CONVERT(varchar, DATEPART(dd, @documentDate)) + '/'
ELSE
SELECT @documentDateTexto = @documentDateTexto + CONVERT(varchar, DATEPART(dd, @documentDate)) + '/'
SELECT @documentDateTexto = @documentDateTexto + CONVERT(varchar, DATEPART(yy, @documentDate))
SELECT @OrigenModuloIDAnt = 0
WHILE(1=1)
BEGIN
SELECT @OrigenModuloID = MIN(Cxp.ID)
FROM MovImpuesto WITH (NOLOCK)
JOIN Cxp WITH (NOLOCK) ON MovImpuesto.OrigenModulo = 'CXP' AND MovImpuesto.OrigenModuloID = Cxp.ID
JOIN MovTipo WITH (NOLOCK) ON MovTipo.Modulo = 'CXP' AND MovTipo.Mov = Cxp.Mov
WHERE MovImpuesto.Modulo = 'DIN'
AND MovImpuesto.ModuloID = @ModuloID
AND ISNULL(MovTipo.SubClave, '') = 'CXP.AEMIDA'
AND Cxp.ID > @OrigenModuloIDAnt
IF @OrigenModuloID IS NULL BREAK
SELECT @OrigenModuloIDAnt = @OrigenModuloID
SELECT @CarrierID = EmidaCarrierID, @CtaDinero = CtaDinero
FROM Cxp WITH (NOLOCK)
WHERE ID = @OrigenModuloID
SELECT @URL = URL
FROM EmidaCarrierCfg WITH (NOLOCK)
WHERE EmidaCarrierCfg.CarrierId = @CarrierID
SELECT @terminalId = dbo.fnEmidaSiteID(@Empresa, @URL, @Sucursal, @Usuario)
SELECT @ClerkID = Agente.ClerkID
FROM Agente WITH (NOLOCK)
JOIN Usuario WITH (NOLOCK) ON Agente.Agente = Usuario.DefAgente
WHERE Usuario = @Usuario
SELECT @bankCode = EmidaBankCode
FROM InstitucionFin WITH (NOLOCK)
JOIN CtaDinero WITH (NOLOCK) ON CtaDinero.Institucion = InstitucionFin.Institucion
WHERE CtaDinero.CtaDinero = @CtaDinero
SELECT @Solicitud = '<Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Emida.SubmitPayment" SubReferencia="" Version="' + ISNULL(@Version, '') + '">' +
'  <Solicitud>' +
'    <Emida Estacion="' + CONVERT(varchar, ISNULL(@Estacion, 0)) + '" Empresa="' + ISNULL(dbo.fneDocXmlAUTF8(@Empresa, 0, 1), '') + '" URL="' + ISNULL(@URL, '') + '" terminalId="' + ISNULL(@terminalId, '') + '" Version="' + ISNULL(@Version, '') + '" clerkId="' + ISNULL(@clerkId, '') + '" bankCode="' + ISNULL(@bankCode, '') + '" amount="' + ISNULL(CONVERT(varchar, @amount), '') + '" documentNumber="' + ISNULL(@documentNumber, '') + '" documentDate="' + ISNULL(@documentDateTexto, '') + '" />' +
'  </Solicitud>' +
'</Intelisis>'
EXEC spIntelisisService @Usuario, @Contrasena, @Solicitud, @Resultado = @Resultado OUTPUT, @Procesar = 1, @EliminarProcesado = 0, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
EXEC sp_xml_preparedocument @iResultado OUTPUT, @Resultado
SELECT @EmidaRequestId = requestId
FROM OPENXML(@iResultado, '/Intelisis/Resultado/SubmitPaymentNotificationResponse', 2)
WITH(requestId varchar(20))
UPDATE Cxp WITH (ROWLOCK) SET EmidaRequestId = @EmidaRequestId WHERE ID = @OrigenModuloID
UPDATE Dinero WITH (ROWLOCK)  SET EmidaRequestId = @EmidaRequestId WHERE ID = @ModuloID
EXEC sp_xml_removedocument @iResultado
END
END
IF @Ok IS NULL
SELECT @OkRef = NULL
RETURN
END

