SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroISRecibirSincro
@iDatos				int,
@Solicitud			uniqueidentifier,
@Conversacion		uniqueidentifier,
@FechaEnvio			datetime,
@SucursalLocal		int,
@SucursalSincro		int,
@Brincar			bit				OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Tabla				varchar(100),
@FechaRecibo		datetime,
@EsRespaldo			bit,
@EsTRCL				bit,
@TruncarTabla		bit,
@PaqueteCambios		int,
@PaqueteBajas		int,
@SQL				nvarchar(max),
@SELECT				varchar(max),
@SELECT2			varchar(max),
@SELECT_VALUES		varchar(max),
@SELECT_VALUES2		varchar(max),
@WITH				varchar(max),
@JOIN				varchar(max),
@SET_JOIN			varchar(max),
@CampoIdentity		varchar(100),
@SQL_ERROR_NUMBER	int,
@SQL_ERROR_MESSAGE	varchar(255),
@SELECT_IDLocal		nvarchar(max),
@SELECTCampoLocal	bit,
@ModuloCur			varchar(100),
@CampoCur			varchar(100),
@SucursalRemota		int,
@Empresa			varchar(5),
@Usuario			varchar(10),
@IDRemoto			int,
@SucursalLocalCur	int,
@TablaVirtual		varchar(50), 
@SET_JOIN_UPDATE	varchar(max), 
@JOIN_QUERY11			varchar(max), 
@SELECT_VALUES_QUERY11	varchar(max)  
SELECT @SQL_ERROR_NUMBER = NULL, @SQL_ERROR_MESSAGE = NULL
EXEC spSetInformacionContexto 'SINCROIS', 1
/*
BEGIN TRY
*/
SELECT @FechaRecibo = GETDATE()
DECLARE crSincroISRecibirTablas CURSOR LOCAL FOR
SELECT  Tabla, ISNULL(EsRespaldo, 0), ISNULL(EsTRCL, 0), ISNULL(Truncar,0), PaqueteCambios, PaqueteBajas, TablaVirtual 
FROM OPENXML (@iDatos, '/Intelisis/Solicitud/IntelisisSincroIS/Tabla')
WITH (Tabla varchar(100), EsRespaldo bit, EsTRCL bit, Truncar bit, PaqueteCambios int, PaqueteBajas int, TablaVirtual varchar(50)) 
OPEN crSincroISRecibirTablas
FETCH NEXT FROM crSincroISRecibirTablas INTO @Tabla, @EsRespaldo, @EsTRCL, @TruncarTabla, @PaqueteCambios, @PaqueteBajas, @TablaVirtual 
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @EsRespaldo = 1 AND @SucursalLocal = 0
BEGIN
IF (SELECT SincroISRecibirRespaldoMatriz FROM Version) = 0 SELECT @Ok = 17030
END
IF @@FETCH_STATUS <> -2 AND ((@SucursalLocal = 0 AND @SucursalSincro > 0) OR (@SucursalLocal > 0 AND @SucursalSincro = 0)) AND dbo.fnTablaExiste(@Tabla) = 1
BEGIN
EXEC spSincroISTablaEstructura @Tabla, @Prefijo = 'u.', @ExcluirIdentity=1, @ExcluirTimeStamp = 1, @ExcluirCalculados=1, @JOIN_TABLA1='x', @SET_JOIN_T1 = @SET_JOIN OUTPUT, @TablaVirtual = @TablaVirtual, @SET_JOIN_T3 = @SET_JOIN_UPDATE OUTPUT 
EXEC spSincroISTablaEstructura @Tabla, @SELECT_VALUES = @SELECT_VALUES2 OUTPUT, @Prefijo = 'x.', @ExcluirTimeStamp = 1, @ExcluirCalculados=1, @SucursalRemota = @SucursalSincro, @TablaVirtual = @TablaVirtual 
EXEC spSincroISTablaEstructura @Tabla, @SELECT = @SELECT2 OUTPUT, @ExcluirIdentity=1, @ExcluirTimeStamp = 1, @ExcluirCalculados=1, @TablaVirtual = @TablaVirtual 
EXEC spSincroISTablaEstructura @Tabla, @SELECT = @SELECT OUTPUT, @WITH = @WITH OUTPUT, @CampoIdentity = @CampoIdentity OUTPUT, @ExcluirTimeStamp = 1, @ExcluirCalculados = 1, @SucursalRemota = @SucursalSincro, @SELECT_VALUES = @SELECT_VALUES OUTPUT, @SELECT_IDLocal = @SELECT_IDLocal OUTPUT, @SELECTCampoLocal = @SELECTCampoLocal OUTPUT, @GenerarTabla = 1, @TablaVirtual = @TablaVirtual 
IF @SELECTCampoLocal = 1
BEGIN
DELETE FROM SincroISInsertarEncabezado WHERE SPID = @@SPID
DECLARE crTablaEstructura CURSOR FOR
SELECT ISNULL(CASE WHEN Modulo IS NULL THEN NULL ELSE CHAR(39) + Modulo + CHAR(39) END,CampoModulo), SucursalRemota, SELECT_IDLocal, Campo
FROM SincroISTablaEstructura
WHERE [SPID] = @@SPID
AND Tabla = @Tabla
OPEN crTablaEstructura
FETCH NEXT FROM crTablaEstructura INTO @ModuloCur, @SucursalRemota, @SELECT_IDLocal, @CampoCur
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @SELECT_IDLocal = N'INSERT SincroISInsertarEncabezado (SPID,  Tabla,  Modulo,               Empresa,                               Usuario,                             IDRemoto,                SucursalRemota,  SucursalLocal) ' +
N'                           SELECT  @SPID, @Tabla, ' + @ModuloCur + ', ' + CHAR(39) + 'ERROR' + CHAR(39) + ', ' + CHAR(39) + 'ERROR' + CHAR(39) + ', ' + @CampoCur + ',       @SucursalRemota, @SucursalLocal ' +
N'FROM OPENXML (@iDatos, ''/Intelisis/Solicitud/IntelisisSincroIS/Tabla/Cambios/Cambio'', 1) WITH ('+@WITH+') WHERE '+@SELECT_IDLocal+' '
PRINT @tabla + ',Rec,Query 1,'  + convert(varchar,getdate(),126) + ','+@SELECT_IDLocal
EXEC sp_executesql @SELECT_IDLocal, N'@iDatos int, @SPID int, @Tabla varchar(100), @Modulo varchar(5), @SucursalRemota int, @SucursalLocal int', @iDatos = @iDatos, @SPID = @@SPID, @Tabla = @Tabla, @Modulo = @ModuloCur, @SucursalRemota = @SucursalRemota, @SucursalLocal = @SucursalLocal
FETCH NEXT FROM crTablaEstructura INTO @ModuloCur, @SucursalRemota, @SELECT_IDLocal, @CampoCur
END
CLOSE crTablaEstructura
DEALLOCATE crTablaEstructura
DECLARE crInsertarEncabezado CURSOR FOR
SELECT Modulo, Empresa, Usuario, IDRemoto, SucursalRemota, SucursalLocal
FROM SincroISInsertarEncabezado
WHERE [SPID] = @@SPID
AND Tabla = @Tabla
GROUP BY Modulo, Empresa, Usuario, IDRemoto, SucursalRemota, SucursalLocal
OPEN crInsertarEncabezado
FETCH NEXT FROM crInsertarEncabezado INTO @ModuloCur, @Empresa, @Usuario, @IDRemoto, @SucursalRemota, @SucursalLocalCur
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
EXEC spSincroISInsertarEncabezado @ModuloCur, @Empresa, @Usuario, @IDRemoto, @SucursalRemota, @SucursalLocalCur, @Ok OUTPUT, @OkRef OUTPUT
FETCH NEXT FROM crInsertarEncabezado INTO @ModuloCur, @Empresa, @Usuario, @IDRemoto, @SucursalRemota, @SucursalLocalCur
END
CLOSE crInsertarEncabezado
DEALLOCATE crInsertarEncabezado
END
EXEC spSincroISTablaEstructura @Tabla, @JOIN = @JOIN OUTPUT, @JOIN_Tabla1 = @Tabla, @JOIN_Tabla2 = 'x', @PK = 1, @TablaVirtual = @TablaVirtual 
IF NULLIF(RTRIM(@JOIN), '') IS NOT NULL
BEGIN
EXEC spSincroISLog @Solicitud, @Conversacion, @Tabla, @PaqueteCambios, @PaqueteBajas, @SucursalSincro, @SucursalLocal, @FechaEnvio, @FechaRecibo
EXEC spSincroISSolicitud @Solicitud, @FechaRecibo = @FechaRecibo, @Estatus = 'RECIBIENDO'
IF @EsRespaldo = 1
BEGIN
IF @TruncarTabla = 1
BEGIN
SELECT @SQL = N'EXEC spSetInformacionContexto ''SINCROIS'', 1 DELETE FROM ' + @Tabla + ' FROM ' + @Tabla + ' t LEFT OUTER JOIN IDLocal i ON t.SincroGUID = i.RegistroTemporal WHERE i.RegistroTemporal IS NULL'
PRINT @tabla + ',Rec,Query 2,'  + convert(varchar,getdate(),126) + ','+@SQL
EXEC sp_executesql @SQL
END
IF @CampoIdentity IS NOT NULL
BEGIN
SELECT @SQL = N'EXEC spSetInformacionContexto ''SINCROIS'', 1 ' +
N' UPDATE u ' +
N'  SET ' + @SET_JOIN + N' ' +
N' FROM ' + @Tabla + N' AS u JOIN OPENXML (@iDatos, ''/Intelisis/Solicitud/IntelisisSincroIS/Tabla/Cambios/Cambio'', 1) WITH (' + @WITH + N') AS x ' +
N'   ON  (SELECT ISNULL(RegistroTemporal,x.SincroGUID) FROM IDLocal WHERE IDRemoto = x.' + RTRIM(LTRIM(@CampoIdentity)) + ' AND Tabla = ' + CHAR(39) + @Tabla + CHAR(39) + ' AND SucursalRemota = ' + RTRIM(CONVERT(varchar,@SucursalSincro)) + ') = u.SincroGUID '
PRINT @tabla + ',Rec,Query 3,'  + convert(varchar,getdate(),126) + ','+@SQL
EXEC sp_executesql @SQL, N'@iDatos int', @iDatos = @iDatos
SELECT @SQL = N'EXEC spSetInformacionContexto ''SINCROIS'', 1 ' +
N'INSERT '+@Tabla+ N' ('+@SELECT2+N') '+
N'SELECT '+@SELECT_VALUES2+N' ' +
N'  FROM OPENXML (@iDatos, ''/Intelisis/Solicitud/IntelisisSincroIS/Tabla/Cambios/Cambio'', 1) WITH ('+@WITH+') x LEFT OUTER JOIN ' + @Tabla + ' t ' +
N'    ON t.SincroGUID = x.SincroGUID ' +
N' WHERE t.SincroGUID IS NULL '
PRINT @tabla + ',Rec,Query 4,'  + convert(varchar,getdate(),126) + ','+@SQL
EXEC sp_executesql @SQL, N'@iDatos int', @iDatos = @iDatos
END ELSE
BEGIN
SELECT @SQL = N'EXEC spSetInformacionContexto ''SINCROIS'', 1 ' +
N'INSERT '+@Tabla+ N' ('+@SELECT+N') '+
N'SELECT '+@SELECT_VALUES+N' FROM OPENXML (@iDatos, ''/Intelisis/Solicitud/IntelisisSincroIS/Tabla/Cambios/Cambio'', 1) WITH ('+@WITH+')'
PRINT @tabla + ',Rec,Query 5,'  + convert(varchar,getdate(),126) + ','+@SQL
EXEC sp_executesql @SQL, N'@iDatos int', @iDatos = @iDatos
END
END ELSE
BEGIN
IF @CampoIdentity IS NOT NULL
BEGIN
SELECT @SQL = N'EXEC spSetInformacionContexto ''SINCROIS'', 1 ' +
N'DELETE '+@Tabla+N' WHERE SincroGUID IN (SELECT dbo.fnRegistroTemporal(' + CHAR(39) +  @Tabla + CHAR(39) + N',' + RTRIM(LTRIM(CONVERT(varchar,@SucursalSincro))) + N',' + RTRIM(LTRIM(@CampoIdentity))+ N',SincroGUID) FROM OPENXML (@iDatos, ''/Intelisis/Solicitud/IntelisisSincroIS/Tabla/Bajas/Baja/Llave/Llave'', 1) WITH (' + RTRIM(LTRIM(@CampoIdentity))+ N' int, SincroGUID uniqueidentifier))'  + dbo.fnSincroISTablaConMovimientos(@Tabla)
PRINT @tabla + ',Rec,Query 6,'  + convert(varchar,getdate(),126) + ','+@SQL
EXEC sp_executesql @SQL, N'@iDatos int', @iDatos = @iDatos
END ELSE
BEGIN
SELECT @SQL = N'EXEC spSetInformacionContexto ''SINCROIS'', 1 ' +
N'DELETE '+@Tabla+N' WHERE SincroGUID IN (SELECT SincroGUID FROM OPENXML (@iDatos, ''/Intelisis/Solicitud/IntelisisSincroIS/Tabla/Bajas/Baja/Llave/Llave'', 1) WITH (SincroGUID uniqueidentifier))' + dbo.fnSincroISTablaConMovimientos(@Tabla)
PRINT @tabla + ',Rec,Query 7,'  + convert(varchar,getdate(),126) + ','+@SQL
EXEC sp_executesql @SQL, N'@iDatos int', @iDatos = @iDatos
END
IF @CampoIdentity IS NOT NULL
BEGIN
SELECT @SQL = N'EXEC spSetInformacionContexto ''SINCROIS'', 1 ' +
N' UPDATE u ' +
N'  SET ' + @SET_JOIN_UPDATE + N' ' + 
N' FROM ' + @Tabla + N' AS u JOIN OPENXML (@iDatos, ''/Intelisis/Solicitud/IntelisisSincroIS/Tabla/Cambios/Cambio'', 1) WITH (' + @WITH + N') AS x ' +
N'   ON  (SELECT ISNULL(RegistroTemporal,x.SincroGUID) FROM IDLocal WHERE IDRemoto = x.' + RTRIM(LTRIM(@CampoIdentity)) + ' AND Tabla = ' + CHAR(39) + @Tabla + CHAR(39) + ' AND SucursalRemota = ' + RTRIM(CONVERT(varchar,@SucursalSincro)) + ') = u.SincroGUID '
PRINT @tabla + ',Rec,Query 8,'  + convert(varchar,getdate(),126) + ','+@SQL
EXEC sp_executesql @SQL, N'@iDatos int', @iDatos = @iDatos
SELECT @SQL = N'EXEC spSetInformacionContexto ''SINCROIS'', 1 ' +
N'INSERT '+@Tabla+ N' ('+@SELECT2+N') '+
N'SELECT '+@SELECT_VALUES2+N' ' +
N'  FROM OPENXML (@iDatos, ''/Intelisis/Solicitud/IntelisisSincroIS/Tabla/Cambios/Cambio'', 1) WITH ('+@WITH+') x LEFT OUTER JOIN ' + @Tabla + ' t ' +
N'    ON t.SincroGUID = x.SincroGUID ' +
N' WHERE t.SincroGUID IS NULL '
PRINT @tabla + ',Rec,Query 9,'  + convert(varchar,getdate(),126) + ','+@SQL
EXEC sp_executesql @SQL, N'@iDatos int', @iDatos = @iDatos
END ELSE
BEGIN
SELECT @SQL = N'EXEC spSetInformacionContexto ''SINCROIS'', 1 ' +
N'DELETE '+@Tabla+N' WHERE SincroGUID IN (SELECT SincroGUID FROM OPENXML (@iDatos, ''/Intelisis/Solicitud/IntelisisSincroIS/Tabla/Cambios/Cambio'', 1) WITH (SincroGUID uniqueidentifier))'
PRINT @tabla + ',Rec,Query 10,'  + convert(varchar,getdate(),126) + ','+@SQL
EXEC sp_executesql @SQL, N'@iDatos int', @iDatos = @iDatos
EXEC spSincroISTablaEstructura @Tabla, @CampoIdentity = @CampoIdentity OUTPUT, @ExcluirTimeStamp = 1, @ExcluirCalculados = 1, @SucursalRemota = @SucursalSincro, @SELECT_VALUES = @SELECT_VALUES_QUERY11 OUTPUT, @GenerarTabla = 0, @TablaVirtual = @TablaVirtual, @Prefijo = 'x.' 
EXEC spSincroISTablaEstructura @Tabla, @JOIN_IDLocal = @JOIN_QUERY11 OUTPUT, @JOIN_Tabla1 = '', @JOIN_Tabla2 = 't', @Prefijo = 'x.', @PK = 1, @SucursalRemota = @SucursalSincro 
SELECT @SQL = N'EXEC spSetInformacionContexto ''SINCROIS'', 1 ' + 
N'INSERT '+@Tabla+ N' ('+@SELECT+N') '+
N'SELECT '+@SELECT_VALUES_QUERY11+N' FROM OPENXML (@iDatos, ''/Intelisis/Solicitud/IntelisisSincroIS/Tabla/Cambios/Cambio'', 1) WITH ('+@WITH+') x ' +
N'  LEFT OUTER JOIN ' + @Tabla + N' t ON ' +  @JOIN_QUERY11 + ' ' +
N' WHERE t.SincroID IS NULL '
PRINT @tabla + ',Rec,Query 11,'  + convert(varchar,getdate(),126) + ','+@SQL
EXEC sp_executesql @SQL, N'@iDatos int', @iDatos = @iDatos
END
END
SELECT @SQL = N'EXEC spSetInformacionContexto ''SINCROIS'', 1 ' +
N'UPDATE SysTabla WITH (ROWLOCK) SET UltimoCambio = GETDATE() WHERE SysTabla = '''+@Tabla+''''
PRINT @tabla + ',Rec,Query 12,'  + convert(varchar,getdate(),126) + ','+@SQL
EXEC sp_executesql @SQL
IF @CampoIdentity IS NOT NULL
BEGIN
SELECT @SQL = N'EXEC spSetInformacionContexto ''SINCROIS'', 1 ' +
N'DELETE FROM IDLocal ' +
N'FROM OPENXML (@iDatos, ''/Intelisis/Solicitud/IntelisisSincroIS/Tabla/Cambios/Cambio'', 1) WITH ('+@WITH+') x JOIN IDLocal il ' +
N'ON il.IDRemoto = x.' + @CampoIdentity + ' JOIN ' + @Tabla + ' t ' +
N'ON (t.SincroGUID = ISNULL(il.RegistroTemporal,x.SincroGUID) OR t.SincroGUID = x.SincroGUID) ' +
N'WHERE il.Tabla = ' + CHAR(39) + @Tabla + char(39) + ' ' +
N'AND il.SucursalRemota = ' + LTRIM(RTRIM(CONVERT(varchar,@SucursalSincro))) + ' ' +
N'AND IDRemoto = x.' + @CampoIdentity + ' ' +
N'AND Tabla = ' + CHAR(39) + @Tabla + char(39) + ' ' +
N'AND SucursalRemota = ' + LTRIM(RTRIM(CONVERT(varchar,@SucursalSincro))) + ' ' +
N'INSERT IDLocal (Tabla,                                    SucursalRemota,                                     IDRemoto,                  SucursalLocal,                                         IDLocal) '+
N'        SELECT  ' + CHAR(39) + @Tabla + CHAR(39) + ', ' + LTRIM(RTRIM(CONVERT(varchar,@SucursalSincro))) + ', x.'+@CampoIdentity+N', ' + LTRIM(RTRIM(CONVERT(varchar,@SucursalLocal))) + ', '+N'MIN(t.'+@CampoIdentity+') ' + 
N'          FROM OPENXML (@iDatos, ''/Intelisis/Solicitud/IntelisisSincroIS/Tabla/Cambios/Cambio'', 1) WITH ('+@WITH+') x '+
N'          JOIN '+@Tabla+N' t ON t.SincroGUID = x.SincroGUID' +
N'         GROUP BY x.' + @CampoIdentity + ' ' 
PRINT @tabla + ',Rec,Query 13,'  + convert(varchar,getdate(),126) + ','+@SQL
EXEC sp_executesql @SQL, N'@iDatos int, @SucursalRemota int, @SucursalLocal int, @Tabla varchar(100)', @iDatos = @iDatos, @Tabla = @Tabla, @SucursalRemota = @SucursalSincro, @SucursalLocal = @SucursalLocal
/*
SELECT @SQL = N'EXEC spSetInformacionContexto ''SINCROIS'', 0 ' +
N'DELETE FROM IDRemoto ' +
N'FROM OPENXML (@iDatos, ''/Intelisis/Solicitud/IntelisisSincroIS/Tabla/Cambios/Cambio'', 1) WITH ('+@WITH+') x   JOIN ' + @Tabla + ' t ' +
N'ON (t.SincroGUID = (SELECT ISNULL(RegistroTemporal,x.SincroGUID) FROM IDLocal WHERE IDRemoto = x.' + RTRIM(LTRIM(@CampoIdentity)) + ' AND Tabla = ' + CHAR(39) + @Tabla + CHAR(39) + ' AND SucursalRemota = ' + RTRIM(CONVERT(varchar,@SucursalSincro)) + ') OR t.SincroGUID = x.SincroGUID) ' +
N'WHERE IDRemoto = x.' + @CampoIdentity + ' ' +
N'AND Tabla = ' + CHAR(39) + @Tabla + CHAR(39) + ' ' +
N'AND SucursalRemota = ' + LTRIM(RTRIM(CONVERT(varchar,@SucursalSincro))) + ' ' +
N'INSERT IDRemoto (Tabla, SucursalRemota, IDRemoto, SucursalLocal, IDLocal) '+
N'SELECT ' + CHAR(39) + @Tabla + CHAR(39) + ', ' + LTRIM(RTRIM(CONVERT(varchar,@SucursalSincro))) + ', x.'+@CampoIdentity+N', ' + LTRIM(RTRIM(CONVERT(varchar,@SucursalLocal))) + ', '+N't.'+@CampoIdentity +
N'  FROM OPENXML (@iDatos, ''/Intelisis/Solicitud/IntelisisSincroIS/Tabla/Cambios/Cambio'', 1) WITH ('+@WITH+') x '+
N'  JOIN '+@Tabla+N' t ON t.SincroGUID = (SELECT ISNULL(RegistroTemporal,x.SincroGUID) FROM IDLocal WHERE IDRemoto = x.' + RTRIM(LTRIM(@CampoIdentity)) + ' AND Tabla = ' + CHAR(39) + @Tabla + CHAR(39) + ' AND SucursalRemota = ' + RTRIM(CONVERT(varchar,@SucursalSincro)) + ') '
*/
SELECT @SQL = N'EXEC spSetInformacionContexto ''SINCROIS'', 0 ' + 
N'DELETE FROM IDRemoto ' +
N'FROM OPENXML (@iDatos, ''/Intelisis/Solicitud/IntelisisSincroIS/Tabla/Cambios/Cambio'', 1) WITH ('+@WITH+') x
JOIN IDLocal ON IDLocal.IDRemoto = x.'+LTRIM(RTRIM(@CampoIdentity))+ ' AND IDLocal.Tabla = ' + CHAR(39) + @Tabla + CHAR(39) +  ' AND IDLocal.SucursalRemota = ' + LTRIM(RTRIM(CONVERT(varchar,@SucursalSincro))) +
' JOIN ' + @Tabla + ' t ON (t.SincroGUID = ISNULL(IDLocal.RegistroTemporal,x.SincroGUID) OR t.SincroGUID = x.SincroGUID) ' +
N'JOIN IDRemoto ON IDRemoto.IDRemoto = x.'+LTRIM(RTRIM(@CampoIdentity))+' AND IDRemoto.Tabla = ' + CHAR(39) + @Tabla + char(39) + ' AND IDRemoto.SucursalRemota = ' + LTRIM(RTRIM(CONVERT(varchar,@SucursalSincro))) + ' ' +
N'INSERT IDRemoto (Tabla,       SucursalRemota, IDRemoto, SucursalLocal, IDLocal) ' +
N'SELECT ' + CHAR(39) + @Tabla + CHAR(39) + ', ' + LTRIM(RTRIM(CONVERT(varchar,@SucursalSincro))) + ', x.'+@CampoIdentity+N', ' + LTRIM(RTRIM(CONVERT(varchar,@SucursalLocal))) + ', '+N'MIN(t.'+@CampoIdentity + ') ' +
N'FROM OPENXML (@iDatos, ''/Intelisis/Solicitud/IntelisisSincroIS/Tabla/Cambios/Cambio'', 1) WITH ('+@WITH+') x ' +
N'JOIN IDLocal ON IDLocal.IDRemoto = x.'+LTRIM(RTRIM(@CampoIdentity)) + ' AND IDLocal.Tabla = ' + CHAR(39) + @Tabla + CHAR(39) +  ' AND IDLocal.SucursalRemota = ' + LTRIM(RTRIM(CONVERT(varchar,@SucursalSincro))) + ' ' +
N'JOIN ' + @Tabla + ' t ON (t.SincroGUID = ISNULL(IDLocal.RegistroTemporal,x.SincroGUID) OR t.SincroGUID = x.SincroGUID)' +
N' GROUP BY x.' + @CampoIdentity + ' '
PRINT @tabla + ',Rec,Query 14,'  + convert(varchar,getdate(),126) + ','+@SQL
EXEC sp_executesql @SQL, N'@iDatos int, @SucursalRemota int, @SucursalLocal int, @Tabla varchar(100)', @iDatos = @iDatos, @Tabla = @Tabla, @SucursalRemota = @SucursalSincro, @SucursalLocal = @SucursalLocal
END
SELECT @SQL = N'EXEC spSetInformacionContexto ''SINCROIS'', 1 ' +
N'DECLARE @TablaTemp TABLE (SincroID binary(8) NULL,  Sucursal int NULL) ' +
N'INSERT @TablaTemp (SincroID, Sucursal) ' +
N'SELECT t.SincroID, ' + LTRIM(RTRIM(CONVERT(varchar,@SucursalSincro))) + ' ' +
N'  FROM OPENXML (@iDatos, ''/Intelisis/Solicitud/IntelisisSincroIS/Tabla/Cambios/Cambio'', 1) WITH ('+@WITH+') x '+
N'  JOIN '+@Tabla+N' t ON t.SincroGUID = x.SincroGUID ' +
N'DELETE FROM SincroISNoRebote ' +
N'  FROM @TablaTemp t ' +
N'  JOIN SincroISNoRebote sisnr ON sisnr.SincroID = t.SincroID AND sisnr.Sucursal = t.Sucursal ' +
N'INSERT SincroISNoRebote (SincroID, Sucursal) ' +
N'SELECT          DISTINCT SincroID, Sucursal FROM @TablaTemp '
/*
SELECT @SQL = N'EXEC spSetInformacionContexto ''SINCROIS'', 1 ' + 
N'DECLARE @TablaTemp TABLE (SincroID binary(8) NULL,  Sucursal int NULL) ' +
N'INSERT @TablaTemp (SincroID, Sucursal) ' +
N'SELECT t.SincroID, ' + LTRIM(RTRIM(CONVERT(varchar,@SucursalSincro))) + ' ' +
N'  FROM OPENXML (@iDatos, ''/Intelisis/Solicitud/IntelisisSincroIS/Tabla/Cambios/Cambio'', 1) WITH ('+@WITH+') x '+
N'  JOIN '+@Tabla+N' t ON t.SincroGUID = x.SincroGUID ' +
N'DELETE FROM SincroISNoRebote ' +
N'  FROM @TablaTemp t ' +
N'  JOIN SincroISNoRebote sisnr ON sisnr.SincroID = t.SincroID AND sisnr.Sucursal = t.Sucursal ' +
N'INSERT SincroISNoRebote (SincroID, Sucursal) ' +
N'SELECT '+N't.SincroID, ' + LTRIM(RTRIM(CONVERT(varchar,@SucursalSincro))) + ' ' +
N'  FROM OPENXML (@iDatos, ''/Intelisis/Solicitud/IntelisisSincroIS/Tabla/Cambios/Cambio'', 1) WITH ('+@WITH+') x '+
N'  JOIN '+@Tabla+N' t ON t.SincroGUID = x.SincroGUID '
*/
PRINT @tabla + ',Rec,Query 15,'  + convert(varchar,getdate(),126) + ','+@SQL
EXEC sp_executesql @SQL, N'@iDatos int, @Sucursal int', @iDatos = @iDatos, @Sucursal = @SucursalSincro
IF @Tabla = 'IDRemoto'
BEGIN
SELECT @SQL = N'EXEC spSetInformacionContexto ''SINCROIS'', 1 ' + 
N'        DELETE FROM IDLocal' +
N'          FROM OPENXML (@iDatos, ''/Intelisis/Solicitud/IntelisisSincroIS/Tabla/Cambios/Cambio'', 1) WITH ('+@WITH+') x JOIN IDLocal '+
N'            ON x.Tabla = IDLocal.Tabla AND x.SucursalLocal = IDLocal.SucursalRemota AND x.IDLocal = IDLocal.IDRemoto JOIN '+@Tabla+N' t ' +
N'            ON t.SincroGUID = x.SincroGUID ' +
N'         WHERE x.SucursalRemota = ' + CONVERT(varchar,@SucursalLocal) + ' ' +
N'INSERT IDLocal (Tabla,      SucursalRemota,   IDRemoto,       SucursalLocal,    IDLocal) ' +
N'        SELECT '+N't.Tabla, t.SucursalLocal,  MIN(t.IDLocal), t.SucursalRemota, t.IDRemoto' +
N'          FROM OPENXML (@iDatos, ''/Intelisis/Solicitud/IntelisisSincroIS/Tabla/Cambios/Cambio'', 1) WITH ('+@WITH+') x '+
N'          JOIN '+@Tabla+N' t ON t.SincroGUID = x.SincroGUID ' +
N'         WHERE x.SucursalRemota = ' + CONVERT(varchar,@SucursalLocal) + ' ' +
N'         GROUP BY t.IDRemoto, t.Tabla, t.SucursalRemota, t.SucursalLocal '
PRINT @tabla + ',Rec,Query 16,'  + convert(varchar,getdate(),126) + ','+@SQL
EXEC sp_executesql @SQL, N'@iDatos int, @Sucursal int', @iDatos = @iDatos, @Sucursal = @SucursalSincro
END
END
END
FETCH NEXT FROM crSincroISRecibirTablas INTO @Tabla, @EsRespaldo, @EsTRCL, @TruncarTabla, @PaqueteCambios, @PaqueteBajas, @TablaVirtual 
END
CLOSE crSincroISRecibirTablas
DEALLOCATE crSincroISRecibirTablas
/*
END TRY
BEGIN CATCH
IF NULLIF(@SQL_ERROR_NUMBER,0) IS NOT NULL
SELECT @Ok = 1, @OkRef = ISNULL(@SQL_ERROR_MESSAGE, '')+' ['+CONVERT(varchar, @SQL_ERROR_NUMBER)+']'
END CATCH
*/
EXEC spSetInformacionContexto 'SINCROIS', 0
RETURN
END

