SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroSSBEnviarTabla
@Desde                  timestamp,
@Hasta                  timestamp,
@Solicitud        uniqueidentifier,
@Conversacion           uniqueidentifier,
@SucursalOrigen         int,
@SucursalOrigenIP varchar(20),
@SucursalOrigenPuerto   int,
@SucursalDestino  int,
@EsSincroFinal          bit,
@EsRespaldo       bit,
@EsTRCL                 bit,
@Tabla                  varchar(100),
@TablaTipo        varchar(20),
@TablaModulo            char(5),
@Datos                  xml       OUTPUT,
@PaqueteCambios         int       OUTPUT,
@PaqueteBajas           int       OUTPUT

AS BEGIN
DECLARE
@FechaEnvio         datetime,
@SQL          nvarchar(max),
@Cambios            nvarchar(max),
@Bajas        nvarchar(max),
@WHERE        nvarchar(max)
SELECT @Datos = NULL, @PaqueteCambios = 0, @PaqueteBajas = 0
IF dbo.fnCampoExiste(@Tabla, 'SincroID') = 0
EXEC spSincroSSBActivarTabla @Tabla
SELECT @TablaTipo = UPPER(@TablaTipo), @TablaModulo = NULLIF(RTRIM(@TablaModulo), ''), @WHERE = '', @Bajas = ''
IF @TablaTipo = 'MOVIMIENTO' AND @SucursalDestino > 0 AND dbo.fnCampoExiste(@Tabla, 'Sucursal') = 1
BEGIN
SELECT @WHERE = N'(Sucursal IN (SELECT Sucursal FROM dbo.fnSucursalesLigadas(@SucursalDestino))'
IF @TablaModulo IS NOT NULL AND dbo.fnCampoExiste(@Tabla, 'SucursalOrigen') = 1
SELECT @WHERE = @WHERE + N' OR SucursalOrigen IN (SELECT Sucursal FROM dbo.fnSucursalesLigadas(@SucursalDestino))'
SELECT @WHERE = @WHERE + N')'
END
IF @EsRespaldo = 0
BEGIN
SELECT @SQL = N'SELECT @Bajas = CONVERT(nvarchar(max), (SELECT Llave FROM SincroSSBBaja WHERE Tabla='''+@Tabla+''' AND SincroID BETWEEN @Desde AND @Hasta FOR XML RAW(''Baja''), ROOT(''Bajas'')))'
EXEC sp_executesql @SQL, N'@Bajas nvarchar(max) OUTPUT, @Desde timestamp, @Hasta timestamp', @Bajas OUTPUT, @Desde = @Desde, @Hasta = @Hasta
END
IF @EsRespaldo = 0
BEGIN
IF @WHERE <> '' SELECT @WHERE = @WHERE + N' AND '
SELECT @WHERE = @WHERE + N' (SincroID NOT IN (SELECT SincroID FROM SincroSSBNoRebote WHERE Sucursal=@SucursalDestino)) AND (SincroID BETWEEN @Desde AND @Hasta)'
END
IF @WHERE <> '' SELECT @WHERE = N' WHERE '+@WHERE
SELECT @SQL = N'SELECT @Cambios = CONVERT(nvarchar(max), (SELECT * FROM '+@Tabla+@WHERE+N' FOR XML RAW(''Cambio''), BINARY BASE64, ROOT(''Cambios'')))'
EXEC sp_executesql @SQL, N'@Cambios nvarchar(max) OUTPUT, @Desde timestamp, @Hasta timestamp, @SucursalDestino int', @Cambios OUTPUT, @Desde = @Desde, @Hasta = @Hasta, @SucursalDestino = @SucursalDestino
SELECT @Cambios = REPLACE(@Cambios,'&#','##')
SELECT @Cambios = REPLACE(@Cambios,'##x0D','&#x0D')
SELECT @Cambios = REPLACE(@Cambios,'##x0A','&#x0A')
SELECT @PaqueteCambios = LEN(@Cambios), @PaqueteBajas = LEN(@Bajas)
IF @Bajas IS NOT NULL
SELECT @Cambios = ISNULL(@Cambios, '') + @Bajas
IF @Cambios IS NOT NULL
SELECT @Cambios = '<IntelisisSincroSSB'+
dbo.fnXML('Tipo', 'Tabla')+
dbo.fnXMLGID('Solicitud', @Solicitud)+
dbo.fnXMLGID('Conversacion', @Conversacion)+
dbo.fnXMLDateTime('FechaEnvio', @FechaEnvio)+
dbo.fnXMLInt('SucursalOrigen', @SucursalOrigen)+
dbo.fnXML('SucursalOrigenIP', @SucursalOrigenIP)+
dbo.fnXMLInt('SucursalOrigenPuerto', @SucursalOrigenPuerto)+
dbo.fnXMLInt('SucursalDestino', @SucursalDestino)+
'>'+
'<Tabla'+
dbo.fnXML('Tabla', @Tabla)+
dbo.fnXMLBit('EsSincroFinal', @EsSincroFinal)+
dbo.fnXMLBit('EsRespaldo', @EsRespaldo)+
dbo.fnXMLBit('EsTRCL', @EsTRCL)+
dbo.fnXMLInt('PaqueteCambios', @PaqueteCambios)+
dbo.fnXMLInt('PaqueteBajas', @PaqueteBajas)+
'>'+
NULLIF(RTRIM(@Cambios), '')+
'</Tabla></IntelisisSincroSSB>'
SELECT @Datos = CONVERT(xml, @Cambios)
RETURN
END

