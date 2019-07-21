SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spISIntelisisMovilMetadatoListado
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Agente		varchar(10),
@Usuario	varchar(10),
@Empresa	VARCHAR(5)
SELECT
@Usuario    = Usuario
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud')
WITH (Usuario varchar(10))
SELECT @Agente = Agente,
@Empresa = Empresa
FROM MovilUsuarioCfg WITH(NOLOCK)
WHERE Usuario = @Usuario
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_WARNINGS ON
SET ANSI_PADDING ON
DECLARE @SQL nvarchar(MAX), @XMLMetaDato XML
DECLARE @Llave varchar(100), @Pantalla   varchar(20)
SET @Resultado  = '<MovilMetadatoListado>'
DECLARE PantallaCursor CURSOR FOR
SELECT Pantalla
FROM MovilPantallaVista WITH(NOLOCK)
WHERE Empresa = @Empresa
ORDER BY IDMovilVista
OPEN PantallaCursor
FETCH NEXT FROM PantallaCursor INTO @Pantalla
WHILE @@FETCH_STATUS = 0
BEGIN
SET @Resultado = @Resultado + '<' + @Pantalla + '>'
DECLARE MetaDatosCursor CURSOR FOR
SELECT MV.Llave
FROM MovilPantallaVista MP WITH(NOLOCK)
JOIN MovilVistaCampo MV WITH(NOLOCK) ON MP.IDMovilVista = MV.IDMovilVista
WHERE MP.Empresa = @Empresa AND MP.Pantalla = @Pantalla
ORDER BY MV.Seccion, MV.Orden, MV.Etiqueta
OPEN MetaDatosCursor
FETCH NEXT FROM MetaDatosCursor INTO @Llave
WHILE @@FETCH_STATUS = 0
BEGIN
SET @SQL = 'SET @XMLOUT = (SELECT MV.Etiqueta, MV.Formato, MV.Longitud, MV.Editable, MV.Requerido, MV.Visible, MV.Seccion, MV.Orden, MV.Busqueda '
+ ' FROM MovilPantallaVista MP WITH(NOLOCK)'
+ ' JOIN MovilVistaCampo MV WITH(NOLOCK) ON MP.IDMovilVista = MV.IDMovilVista '
+ 'WHERE MP.Empresa = '''+ @Empresa +''' AND MP.Pantalla = ''' + @Pantalla + ''' AND MV.Llave = ''' + @Llave + ''' '
+ '  FOR XML PATH(''' + @Llave + '''), TYPE, ELEMENTS)'
EXEC sp_executesql @SQL, N'@XMLOUT XML OUTPUT', @XMLOUT = @XMLMetaDato OUTPUT;
SET @Resultado = @Resultado + CAST(@XMLMetaDato AS VARCHAR(MAX))
FETCH NEXT FROM MetaDatosCursor INTO @Llave
END
CLOSE MetaDatosCursor
DEALLOCATE MetaDatosCursor
SET @Resultado = @Resultado + '</' + @Pantalla + '>'
FETCH NEXT FROM PantallaCursor INTO @Pantalla
END
CLOSE PantallaCursor
DEALLOCATE PantallaCursor
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
SET ANSI_WARNINGS OFF
SET ANSI_PADDING OFF
SET NOCOUNT OFF
SET @Resultado = @Resultado + '</MovilMetadatoListado>'
IF @Ok IS NOT NULL
SET @OkRef = (SELECT Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok)
END

