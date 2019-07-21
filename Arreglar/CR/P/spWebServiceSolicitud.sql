SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebServiceSolicitud
@URI            varchar(8000) = '',
@NombreMetodo   varchar(50) = '',
@Solictud       varchar(8000) = '',
@AccionSOAP     varchar(255),
@Usuario        nvarchar(100), 
@Password       nvarchar(100),
@Respuesta      varchar(max) = NULL OUTPUT,
@Ok             varbinary(4) = NULL OUTPUT,
@OkRef          varchar(255) = NULL OUTPUT
 
AS BEGIN
DECLARE
@IDObjeto            int,
@hResult             int,
@Origen              varchar(8000),
@Descripcion         varchar(8000),
@ResultadoXml        varchar(max) ,
@len                 int ,
@EstatusTexto        varchar(8000),
@Estatus             varchar(8000),
@SQL					varchar(8000)
CREATE table #Tabla (Campo xml)
DECLARE @Tabla TABLE (Campo varchar(max))
SET NOCOUNT ON
IF    @NombreMetodo = ''
BEGIN
SELECT FailPoint = 'Es Necesario Asignar Un Metodo'
RETURN
END
SET  @Respuesta = 'FAILED'
EXEC @hResult = sp_OACreate 'MSXML2.ServerXMLHTTP', @IDObjeto OUT IF @hResult <> 0
BEGIN
EXEC sp_OAGetErrorInfo @IDObjeto, @Origen OUT, @Descripcion OUT
SELECT @Ok = convert(varbinary(4), @hResult), @Okref = ISNULL(@Origen,'') +'  '+ ISNULL(@Descripcion,'')+'   '+'Create failed'
END
IF @Ok IS NULL
BEGIN
EXEC @hResult = sp_OAMethod @IDObjeto, 'open', null, @NombreMetodo, @URI, 'false', @Usuario, @Password
IF @hResult <> 0
BEGIN
EXEC sp_OAGetErrorInfo @IDObjeto, @Origen OUT, @Descripcion OUT
SELECT @Ok = convert(varbinary(4), @hResult), @Okref = ISNULL(@Origen,'') +'  '+ ISNULL(@Descripcion,'')+'   '+'Open failed'
END
END
IF ISNULL(@Solictud,'') <> ''
BEGIN
IF @Ok IS NULL
BEGIN
EXEC @hResult = sp_OAMethod @IDObjeto, 'setRequestHeader', null, 'Content-Type', 'text/xml;charset=UTF-8'
IF @hResult <> 0
BEGIN
EXEC sp_OAGetErrorInfo @IDObjeto, @Origen OUT, @Descripcion OUT
SELECT @Ok = convert(varbinary(4), @hResult), @Okref = ISNULL(@Origen,'') +'  '+ ISNULL(@Descripcion,'')+'   '+'SetRequestHeader failed'
END
END
IF @Ok IS NULL
BEGIN
EXEC @hResult = sp_OAMethod @IDObjeto, 'setRequestHeader', null, 'SOAPAction', @AccionSOAP
IF @hResult <> 0
BEGIN
EXEC sp_OAGetErrorInfo @IDObjeto, @Origen OUT, @Descripcion OUT
SELECT hResult = convert(varbinary(4), @hResult), source = @Origen, description = @Descripcion, FailPoint = 'SetRequestHeader failed', MedthodName = @NombreMetodo
END
END
IF @Ok IS NULL
BEGIN
SET @len = len(@Solictud)
EXEC @hResult = sp_OAMethod @IDObjeto, 'setRequestHeader', null, 'Content-Length', @len
IF @hResult <> 0
BEGIN
EXEC sp_OAGetErrorInfo @IDObjeto, @Origen OUT, @Descripcion OUT
SELECT hResult = convert(varbinary(4), @hResult), source = @Origen, description = @Descripcion, FailPoint = 'SetRequestHeader failed', MedthodName = @NombreMetodo
END
END
END
IF @Ok IS NULL
BEGIN
EXEC @hResult = sp_OAMethod @IDObjeto, 'send', null, @Solictud
IF    @hResult <> 0
BEGIN
EXEC sp_OAGetErrorInfo @IDObjeto, @Origen OUT, @Descripcion OUT
SELECT @Ok = convert(varbinary(4), @hResult), @Okref = ISNULL(@Origen,'') +'  '+ ISNULL(@Descripcion,'')+'   '+'Send failed'
END
EXEC sp_OAGetProperty @IDObjeto, 'StatusText', @EstatusTexto out
EXEC sp_OAGetProperty @IDObjeto, 'Status', @Estatus out
END
IF @Ok IS NULL
BEGIN
IF ISNULL(@Solictud,'') <> ''
INSERT #Tabla( Campo )
EXEC @hResult = sp_OAGetProperty @IDObjeto, 'responseXML.xml'
ELSE
BEGIN
INSERT @Tabla( Campo )
EXEC @hResult = sp_OAGetProperty @IDObjeto, 'responseText'
END
IF @hResult <> 0
BEGIN
EXEC sp_OAGetErrorInfo @IDObjeto, @Origen OUT, @Descripcion OUT
SELECT @Ok = convert(varbinary(4), @hResult), @Okref = ISNULL(@Origen,'') +'  '+ ISNULL(@Descripcion,'')+'   '+'responseXML failed'
END
END
IF ISNULL(@Solictud,'') <> ''
SELECT TOP 1 @Respuesta = convert(varchar(max),Campo) FROM #Tabla
ELSE
SELECT TOP 1 @Respuesta = convert(varchar(max),Campo) FROM @Tabla
EXEC @hResult = sp_OADestroy @IDObjeto
IF @hResult <> 0
BEGIN
EXEC sp_OAGetErrorInfo @IDObjeto
RETURN
END
SET NOCOUNT OFF
END

