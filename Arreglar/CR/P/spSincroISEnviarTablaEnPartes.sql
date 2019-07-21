SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroISEnviarTablaEnPartes
@Desde                timestamp,
@Hasta                timestamp,
@Solicitud			uniqueidentifier,
@Conversacion         uniqueidentifier,
@SucursalOrigen       int,
@SucursalDestino		int,
@EsSincroFinal        bit,
@EsRespaldo			bit,
@EsTRCL               bit,
@Tabla                varchar(100),
@TablaTipo			varchar(20),
@TablaModulo          char(5),
@LongitudPaquete		int,
@Datos                xml       OUTPUT,
@PaqueteCambios       int       OUTPUT,
@PaqueteBajas         int       OUTPUT,
@Continuar			bit       OUTPUT

AS BEGIN
DECLARE
@FechaEnvio			datetime,
@SQL				nvarchar(max),
@Cambios			nvarchar(max),
@Bajas				nvarchar(max),
@WHERE				nvarchar(max),
@JOIN_Mov			nvarchar(max),
@WHERE_IDLocal		nvarchar(max),
@JOIN_GUIDSesion	nvarchar(max),
@WHERE_GUIDSesion	nvarchar(max),
@RegistrosEnviados	int,
@RegistrosPorEnviar	int,
@TruncarTabla		bit,
@FiltroEspecial		varchar(255),
@TablaVirtual		bit,
@TablaVirtualNombre	varchar(50), 
@TablaRemota		varchar(50), 
@WHERE_Mov			varchar(max) 
SELECT @Datos = NULL, @PaqueteCambios = 0, @PaqueteBajas = 0, @TablaVirtual = 0, @TablaVirtualNombre = @Tabla 
SET @FiltroEspecial = dbo.fnSincroISTablaFiltroEspecial(@Tabla)
IF @Tabla <> dbo.fnSincroISTablaSinonimo(@Tabla)
BEGIN
SET @TablaVirtualNombre = @Tabla   
SET @Tabla = dbo.fnSincroISTablaSinonimo(@Tabla)
SET @TablaVirtual = 1
END
IF dbo.fnCampoExiste(@Tabla, 'SincroID') = 0 OR dbo.fnCampoExiste(@Tabla, 'SincroGUID') = 0
EXEC spSincroISActivarTabla @Tabla
SELECT @TablaTipo = UPPER(@TablaTipo), @TablaModulo = NULLIF(RTRIM(@TablaModulo), ''), @WHERE = '', @Bajas = '', @JOIN_Mov = ''
IF @TablaTipo IN ('MOVIMIENTO','MOVIMIENTOINFO') AND @SucursalDestino > 0 AND dbo.fnCampoExiste(@Tabla, 'Sucursal') = 1 AND @Tabla NOT IN ('MovFlujo') 
BEGIN
SELECT @WHERE = N'(Sucursal IN (SELECT Sucursal FROM dbo.fnSucursalesLigadas(@SucursalDestino)) OR ' + CHAR(39) + ISNULL(RTRIM(@TablaModulo),'') + CHAR(39) + ' IN (''PRECI'',''SIS01'',''SIS02'',''SIS03'',''SIS04'',''SIS05'',''SIS06'',''SIS07'',''SIS08'',''SIS09'',''SIS10'',''OFER'',''SIS11'',''SIS12'',''SIS13'')'
IF @TablaModulo IS NOT NULL AND dbo.fnCampoExiste(@Tabla, 'SucursalOrigen') = 1
SELECT @WHERE = @WHERE + N' OR SucursalOrigen IN (SELECT Sucursal FROM dbo.fnSucursalesLigadas(@SucursalDestino))'
SELECT @WHERE = @WHERE + N')'
END
ELSE
BEGIN
IF UPPER(@TablaTipo) IN ('MOVIMIENTO','MOVIMIENTOINFO') AND @SucursalDestino > 0 AND (ISNULL(dbo.fnCampoExiste(@Tabla, 'Sucursal'),0) = 0 OR @Tabla IN ('MovFlujo'))AND @Tabla NOT IN ('Mov') 
BEGIN
EXEC spSincroISTablaEstructura @Tabla, @JOIN_Mov = @JOIN_Mov OUTPUT, @WHERE_Mov = @WHERE_Mov OUTPUT
IF NULLIF(@JOIN_Mov,'') IS NOT NULL
SELECT @WHERE = N'(' + @WHERE_Mov + N' OR ' + CHAR(39) + ISNULL(RTRIM(@TablaModulo),'') + CHAR(39) + ' IN (''PRECI'',''SIS01'',''SIS02'',''SIS03'',''SIS04'',''SIS05'',''SIS06'',''SIS07'',''SIS08'',''SIS09'',''SIS10'',''OFER'',''SIS11'',''SIS12'',''SIS13''))' 
ELSE
SELECT @WHERE = N'(' + CHAR(39) + ISNULL(RTRIM(@TablaModulo),'') + CHAR(39) + N' IN (''PRECI'',''SIS01'',''SIS02'',''SIS03'',''SIS04'',''SIS05'',''SIS06'',''SIS07'',''SIS08'',''SIS09'',''SIS10'',''OFER'',''SIS11'',''SIS12'',''SIS13''))'
END
END
SET @TablaRemota = dbo.fnSincroISMovTabla(@TablaModulo) 
IF @TablaRemota = @Tabla AND dbo.fnCampoExiste(@Tabla, 'Estatus') = 1 AND @TablaTipo = 'MOVIMIENTO' 
BEGIN
IF @WHERE <> '' SELECT @WHERE = @WHERE + N' AND '
SELECT @WHERE = @WHERE + N' ('+@Tabla + N'.Estatus NOT IN (''SINAFECTAR'',''BORRADOR'',''CONFIRMAR'',''AUTORIZARE'') OR ' + N'(' + CHAR(39) + ISNULL(RTRIM(@TablaModulo),'') + CHAR(39) + N' IN (''PRECI'',''SIS01'',''SIS02'',''SIS03'',''SIS04'',''SIS05'',''SIS06'',''SIS07'',''SIS08'',''SIS09'',''SIS10'',''SIS11'',''SIS12'',''SIS13''))' + N')'
END
IF @EsRespaldo = 0
BEGIN
SELECT @SQL = N'SELECT @Bajas = CONVERT(nvarchar(max), (SELECT Llave FROM SincroISBaja WHERE Tabla='''+@Tabla+''' AND SincroID BETWEEN @Desde AND @Hasta FOR XML RAW(''Baja''), ROOT(''Bajas'')))'
PRINT @tabla + ',Env,Query 1,'  + convert(varchar,getdate(),126) + ','+@SQL
EXEC sp_executesql @SQL, N'@Bajas nvarchar(max) OUTPUT, @Desde timestamp, @Hasta timestamp', @Bajas OUTPUT, @Desde = @Desde, @Hasta = @Hasta
END
IF @EsRespaldo = 0
BEGIN
IF @WHERE <> '' SELECT @WHERE = @WHERE + N' AND '
SELECT @WHERE = @WHERE + N' ('+@Tabla + N'.SincroID NOT IN (SELECT SincroID FROM SincroISNoRebote WHERE Sucursal=@SucursalDestino)) AND ('+@Tabla + N'.SincroID BETWEEN @Desde AND @Hasta)'
END
IF @WHERE <> '' SELECT @WHERE = N' WHERE '+@WHERE
EXEC spSincroISTablaEstructura @Tabla, @WHERE_IDLocal = @WHERE_IDLocal OUTPUT
IF NULLIF(@WHERE_IDLocal,'') IS NOT NULL AND ISNULL(@FiltroEspecial,'') = ''
BEGIN
IF @WHERE <> ''
SELECT @WHERE = @WHERE + N' AND '
ELSE
SELECT @WHERE = @WHERE + N' WHERE '
SELECT @WHERE = @WHERE + '('+@WHERE_IDLocal+') '
END
SELECT @JOIN_GUIDSesion = N''
SELECT @WHERE_GUIDSesion = @Tabla + N'.SincroGUID NOT IN (SELECT SincroGUID FROM SincroISGUIDSesion WHERE SPID = ' + CONVERT(varchar,@@SPID) + ') '
IF @WHERE <> ''
SELECT @WHERE = @WHERE + N' AND '
ELSE
SELECT @WHERE = @WHERE + N' WHERE '
SELECT @WHERE = @WHERE + @WHERE_GUIDSesion
IF ISNULL(@FiltroEspecial,'') <> ''
BEGIN
IF @WHERE <> ''
SELECT @WHERE = @WHERE + N' AND '
ELSE
SELECT @WHERE = @WHERE + N' WHERE '
SELECT @WHERE = @WHERE + @FiltroEspecial
END
SELECT @SQL = N'SELECT @Cambios = CONVERT(nvarchar(max), (SELECT TOP ' + CONVERT(varchar,@LongitudPaquete) + ' '+@Tabla+N'.* FROM '+@Tabla+ISNULL(@JOIN_Mov,'')+ISNULL(@JOIN_GUIDSesion,'')+@WHERE + N' ORDER BY ' + @Tabla + N'.SincroGUID ' + N' FOR XML RAW(''Cambio''), BINARY BASE64, ROOT(''Cambios'')))'
PRINT @tabla + ',Env,Query 2,'  + convert(varchar,getdate(),126) + ','+@SQL
EXEC sp_executesql @SQL, N'@Cambios nvarchar(max) OUTPUT, @Desde timestamp, @Hasta timestamp, @SucursalDestino int', @Cambios OUTPUT, @Desde = @Desde, @Hasta = @Hasta, @SucursalDestino = @SucursalDestino
SELECT @RegistrosEnviados = ISNULL(COUNT(*),0) FROM SincroISGUIDSesion WHERE SPID = @@SPID
IF @EsRespaldo = 1 AND @RegistrosEnviados = 0 SELECT @TruncarTabla = 1 ELSE SELECT @TruncarTabla = 0
IF @EsRespaldo = 1 AND @TruncarTabla = 1 AND @TablaVirtual = 1 AND EXISTS(SELECT SincroTabla FROM IntelisisService WHERE SincroTabla = @Tabla AND Conversacion = @Conversacion AND SucursalOrigen = @SucursalOrigen AND SucursalDestino = @SucursalDestino) SELECT @TruncarTabla = 0
SELECT @SQL = N'INSERT SincroISGUIDSesion (SincroGUID, SPID) SELECT TOP ' + CONVERT(varchar,@LongitudPaquete) + ' '+@Tabla+N'.SincroGUID, ' + CONVERT(varchar,@@SPID) + N' FROM '+@Tabla+ISNULL(@JOIN_Mov,'')+ISNULL(@JOIN_GUIDSesion,'')+@WHERE + N' ORDER BY ' + @Tabla + N'.SincroGUID '
PRINT @tabla + ',Env,Query 3,'  + convert(varchar,getdate(),126) + ','+@SQL
EXEC sp_executesql @SQL, N'@Desde timestamp, @Hasta timestamp, @SucursalDestino int', @Desde = @Desde, @Hasta = @Hasta, @SucursalDestino = @SucursalDestino
SELECT @RegistrosPorEnviar = ISNULL(COUNT(*),0) - @RegistrosEnviados FROM SincroISGUIDSesion WHERE SPID = @@SPID
IF @RegistrosPorEnviar < @LongitudPaquete
SET @Continuar = 0
ELSE
SET @Continuar = 1
SELECT @Cambios = REPLACE(@Cambios,'&#','##')
SELECT @Cambios = REPLACE(@Cambios,'##x0D','&#x0D')
SELECT @Cambios = REPLACE(@Cambios,'##x0A','&#x0A')
SELECT @PaqueteCambios = LEN(@Cambios), @PaqueteBajas = LEN(@Bajas)
IF @Bajas IS NOT NULL
SELECT @Cambios = ISNULL(@Cambios, '') + @Bajas
IF @Cambios IS NOT NULL
SELECT @Cambios = '<IntelisisSincroIS'+
dbo.fnXML('Tipo', 'Tabla')+
dbo.fnXMLGID('Solicitud', @Solicitud)+
dbo.fnXMLGID('Conversacion', @Conversacion)+
dbo.fnXMLDateTime('FechaEnvio', @FechaEnvio)+
dbo.fnXMLInt('SucursalOrigen', @SucursalOrigen)+
dbo.fnXMLInt('SucursalDestino', @SucursalDestino)+
'>'+
'<Tabla'+
dbo.fnXML('Tabla', @Tabla)+
dbo.fnXML('TablaVirtual', ISNULL(@TablaVirtualNombre,''))+  
dbo.fnXMLBit('EsSincroFinal', @EsSincroFinal)+
dbo.fnXMLBit('EsRespaldo', @EsRespaldo)+
dbo.fnXMLBit('EsTRCL', @EsTRCL)+
dbo.fnXMLBit('Truncar', @TruncarTabla)+
dbo.fnXMLInt('PaqueteCambios', @PaqueteCambios)+
dbo.fnXMLInt('PaqueteBajas', @PaqueteBajas)+
'>'+
NULLIF(RTRIM(@Cambios), '')+
'</Tabla></IntelisisSincroIS>'
SELECT @Datos = CONVERT(xml,@Cambios)
RETURN
END

