SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISIntelisisCRM
@ID					int,
@iSolicitud			int,
@Version			float,
@Resultado			varchar(max) = NULL OUTPUT,
@Ok					int			 = NULL OUTPUT,
@OkRef				varchar(255) = NULL OUTPUT,
@CambiarEstatus		bit					OUTPUT

AS BEGIN
DECLARE
@Campoint				varchar(100),
@CampoExt				varchar(100),
@Campos				varchar(5000),
@Variables			varchar(5000),
@xml					xml,
@Valor				varchar(max),
@Tabla				varchar(100),
@Tablaintelisis		varchar(100),
@TablaCrm				varchar(100),
@Accion				varchar(100),
@xmlInserted			xml,
@xmlDelete			xml,
@CRMID				varchar(100),
@Bandera				int,
@idAutomatico			bit,
@TEMP					varchar(100),
@Where				varchar(100),
@Where1				varchar(100),
@BuscarDato			bit,
@DefaultInsert		varchar(100),
@AccionEspecifica		varchar(10),
@AccionAnterior		varchar(10),
@Fecha				varchar(23),
@CampoLlave			varchar(50),
@TablaAnterior		varchar(50),
@ModoDebug			bit,
@SQL					nvarchar(max),
@RutaXML				varchar(255),
@Servidor				varchar(100),
@Base					varchar(100)
IF (OBJECT_ID('Tempdb..#IntelisisDatosXML')) IS NOT NULL
DROP TABLE #IntelisisDatosXML
ELSE
CREATE TABLE #IntelisisDatosXML
(
Campo varchar(max) COLLATE Modern_Spanish_CS_AS NOT NULL,
Valor varchar(max) COLLATE Modern_Spanish_CS_AS NULL
)
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON
SET QUOTED_IDENTIFIER ON
SET CONTEXT_INFO 0x01
SELECT @Accion = localname
FROM OPENXML(@iSolicitud,'/Intelisis/Solicitud',1)
WHERE nodetype = 1 AND parentid = 7
SELECT @Tabla = localname
FROM OPENXML(@iSolicitud,'/Intelisis/Solicitud',1)
WHERE nodetype = 1 AND parentid = 8
SELECT @RutaXML = '/Intelisis/Solicitud/' + @Accion + '/' + @Tabla
INSERT #IntelisisDatosXML
SELECT Campo.localname Campo, Valor.text Valor
FROM OPENXML (@iSolicitud, @Rutaxml, 3) Campo
LEFT OUTER JOIN OPENXML (@iSolicitud, @Rutaxml, 1) Valor
ON Campo.id = Valor.parentid
WHERE Campo.nodetype = 2
AND Valor.nodetype = 3
SELECT @Campos =''
SELECT @Variables=''
SELECT @Bandera = 0
SELECT @TablaAnterior = ''
SELECT
@Servidor	= ServidorIntelisis,
@Base		= BaseIntelisis
FROM CfgCRM
DECLARE crTablaSyncroIntelisis CURSOR FOR
SELECT TablaCrm,CampoInt, CampoExt , idAutomatico, BuscarDato, DefaultInsert, AccionEspecifica
FROM TablaSyncro
WHERE TablaIntelisis = @Tabla
ORDER BY  OrdenTabla, TablaIntelisis, TablaCRM, OrdenCampo
OPEN crTablaSyncroIntelisis
FETCH NEXT FROM crTablaSyncroIntelisis
INTO @TablaIntelisis, @CampoInt, @CampoExt, @idAutomatico, @BuscarDato, @DefaultInsert, @AccionEspecifica
WHILE @@FETCH_STATUS = 0
BEGIN
IF @CampoExt IS NOT NULL
BEGIN
IF @TablaAnterior <> @TablaIntelisis AND @Bandera=0
SELECT @TablaAnterior = @TablaIntelisis
IF @TablaAnterior <> @TablaIntelisis
BEGIN
IF @Campos<>''
BEGIN
IF @Accion = 'INSERT'
BEGIN
SET @Campos = SUBSTRING(@Campos,1,LEN(@Campos)-1)
SET @Variables = SUBSTRING(@Variables,1,LEN(@Variables)-1)
SET @Campos = 'EXEC spSetInformacionContexto CRM, 1 INSERT INTO [' + @Servidor + '].[' + @Base + '].dbo.'+@TablaAnterior+' (' + @Campos + ') VALUES'
SET @Variables = '(' +@Variables+ ')'
SELECT @Campos = @Campos + @Variables
IF @ModoDebug = 1
PRINT (@Campos)
ELSE
BEGIN
EXEC (@Campos)
END
END
IF @Accion = 'UPDATE'
BEGIN
IF @TablaAnterior = 'LeadAddressBase'
SELECT @Where =  ' AddressNumber= ''1'' AND ParentId '
ELSE
BEGIN
SELECT @SQL = 'EXEC [' + @Servidor + '].[' + @Base + '].dbo.spBuscaDatoCRM ''' + 'Llave' + ''', ''' + @TablaAnterior + ''', ''' + '' + ''', @Where OUTPUT'
IF @ModoDebug = 1
PRINT (@Campos)
ELSE
BEGIN
EXEC sp_executesql @SQL, N'@Where varchar(max) OUTPUT', @Where = @Where OUTPUT
END
END
SET @Campos = SUBSTRING(@Campos,1,LEN(@Campos)-1)
SELECT @Campos = 'EXEC spSetInformacionContexto CRM, 1 UPDATE [' + @Servidor + '].[' + @Base + '].dbo.' + @TablaAnterior + ' SET '+ @Campos+' WHERE '+@Where+' = '''+@CRMID+''''
IF @ModoDebug = 1
PRINT (@Campos)
ELSE
BEGIN
EXEC (@Campos)
END
END
END
SELECT
@Campos		 = '',
@Variables	 = '',
@TablaAnterior = @TablaIntelisis
END
IF @AccionEspecifica IS NOT NULL
BEGIN
SELECT @Accion = @AccionEspecifica
END
IF @Accion = 'INSERT'
BEGIN
SET @Campos = @Campos + @CampoExt + ', '
SELECT @SQL = 'SELECT @Valor = Valor '+ ' FROM #IntelisisDatosXML WHERE Campo = ''' + @CampoInt + ''''
EXECUTE sp_executesql @SQL, N'@Valor varchar(max) OUTPUT', @Valor OUTPUT
IF @Valor IS NULL
SELECT @Valor = ''
IF @CampoInt = 'Estatus' AND @CampoExt = 'StateCode' AND @Valor = 'ALTA'
SELECT @Valor = '0'
IF @CampoInt = 'Estatus' AND @CampoExt = 'StateCode' AND @Valor = 'BAJA'
SELECT @Valor = '1'
IF @CampoInt = 'Estatus' AND @CampoExt = 'StatusCode' AND @Valor = 'ALTA'
SELECT @Valor = '1'
IF @CampoInt = 'Estatus' AND @CampoExt = 'StatusCode' AND @Valor = 'BAJA'
SELECT @Valor = '2'
IF @idAutomatico= 1
BEGIN
SELECT @SQL = 'EXEC [' + @Servidor + '].[' + @Base + '].dbo.spBuscaDatoCRM ''' + 'Consecutivo' + ''', ''' + @TablaIntelisis + ''', ''' + ISNULL(@Campos,'') + ''', @TEMP OUTPUT'
IF @ModoDebug = 1
PRINT (@Campos)
ELSE
BEGIN
EXEC sp_executesql @SQL, N'@TEMP varchar(max) OUTPUT', @TEMP = @TEMP OUTPUT
END
SELECT @Valor = RTRIM(@TEMP)
END
IF @BuscarDato= 1 AND @idAutomatico= 0
BEGIN
SELECT @SQL = 'EXEC [' + @Servidor + '].[' + @Base + '].dbo.spBuscaDatoCRM ''' + 'Busca' + ''', ''' + @CampoExt + ''', ''' + @Valor + ''', @TEMP OUTPUT'
IF @ModoDebug = 1
PRINT (@Campos)
ELSE
BEGIN
EXEC sp_executesql @SQL, N'@TEMP varchar(max) OUTPUT', @TEMP = @TEMP OUTPUT
END
SELECT @Valor = RTRIM(@TEMP)
END
IF @DefaultInsert IS NOT NULL
BEGIN
IF @DefaultInsert = 'GUID'
SELECT @DefaultInsert = NEWID()
IF @DefaultInsert = 'Fecha'
SELECT @DefaultInsert= GETDATE()
SELECT @Valor= @DefaultInsert
END
SET @Variables = @Variables + '''' + @Valor + ''', '
END
IF @Accion = 'UPDATE'
BEGIN
SELECT @SQL = 'SELECT @Valor = Valor '+ ' FROM #IntelisisDatosXML WHERE Campo = ''' + @CampoInt + ''''
EXECUTE sp_executesql @SQL, N'@Valor varchar(max) OUTPUT', @Valor OUTPUT
IF @Valor IS NULL
SELECT @Valor = ''
IF @CampoInt = 'Estatus' AND @CampoExt = 'StateCode' AND @Valor = 'ALTA'
SELECT @Valor = '0'
IF @CampoInt = 'Estatus' AND @CampoExt = 'StateCode' AND @Valor = 'BAJA'
SELECT @Valor = '1'
IF @CampoInt = 'Estatus' AND @CampoExt = 'StatusCode' AND @Valor = 'ALTA'
SELECT @Valor = '1'
IF @CampoInt = 'Estatus' AND @CampoExt = 'StatusCode' AND @Valor = 'BAJA'
SELECT @Valor = '2'
IF @BuscarDato= 1
BEGIN
SELECT @SQL = 'EXEC [' + @Servidor + '].[' + @Base + '].dbo.spBuscaDatoCRM ''' + 'Busca' + ''', ''' + @CampoExt + ''', ''' + @Valor + ''', @TEMP OUTPUT'
IF @ModoDebug = 1
PRINT (@Campos)
ELSE
BEGIN
EXEC sp_executesql @SQL, N'@TEMP varchar(max) OUTPUT', @TEMP = @TEMP OUTPUT
END
SELECT @Valor= RTRIM(@TEMP)
END
IF @DefaultInsert IS NOT NULL
BEGIN
IF @DefaultInsert = 'GUID'
SELECT @DefaultInsert = NEWID()
IF @DefaultInsert = 'Fecha'
SELECT @DefaultInsert= GETDATE()
SELECT @Valor= @DefaultInsert
END
IF @Valor<>''
SET @Campos = @Campos + @CampoExt + '= ''' + @Valor + ''', '
END
IF @Bandera = 0
BEGIN
SELECT @CRMID = @Valor
SELECT @Bandera = 1
END
END
FETCH NEXT FROM crTablaSyncroIntelisis
INTO @TablaIntelisis, @CampoInt, @CampoExt, @idAutomatico, @BuscarDato, @DefaultInsert, @AccionEspecifica
END
CLOSE crTablaSyncroIntelisis
DEALLOCATE crTablaSyncroIntelisis
IF @Campos <> ''
BEGIN
IF @Accion = 'INSERT'
BEGIN
SET @Campos = SUBSTRING(@Campos,1,LEN(@Campos)-1)
SET @Variables = SUBSTRING(@Variables,1,LEN(@Variables)-1)
SET @Campos = 'EXEC spSetInformacionContexto CRM, 1 INSERT INTO [' + @Servidor + '].[' + @Base + '].dbo.'+@TablaIntelisis+' (' +@Campos+ ') VALUES'
SET @Variables = '(' +@Variables+ ')'
SELECT @CAMPOS = @CAMPOS + @Variables
IF @ModoDebug = 1
PRINT (@Campos)
ELSE
BEGIN
EXEC (@Campos)
END
END
IF @Accion = 'UPDATE'
BEGIN
IF @TablaAnterior = 'LeadAddressBase' OR @TablaAnterior = 'CustomerAddressBase'
SELECT @Where =  ' AddressNumber= ''1'' AND ParentId '
ELSE
BEGIN
SELECT @SQL = 'EXEC [' + @Servidor + '].[' + @Base + '].dbo.spBuscaDatoCRM ''' + 'Llave' + ''', ''' + @TablaAnterior + ''', ''' + '' + ''', @Where OUTPUT'
IF @ModoDebug = 1
PRINT (@Campos)
ELSE
BEGIN
EXEC sp_executesql @SQL, N'@Where varchar(max) OUTPUT', @Where = @Where OUTPUT
END
END
SET @Campos = SUBSTRING(@Campos,1,LEN(@Campos)-1)
SELECT @Campos = 'EXEC spSetInformacionContexto CRM, 1 UPDATE [' + @Servidor + '].[' + @Base + '].dbo.' + @TablaIntelisis + ' SET '+ @Campos+' WHERE '+@Where+' = '''+@CRMID+''''
IF @ModoDebug = 1
PRINT (@Campos)
ELSE
BEGIN
EXEC (@Campos)
END
END
END
EXEC spSetInformacionContexto CRM, 0
RETURN
END

