SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroISEnviarTablasEnPartes
@SucursalDestino	int = 0,
@EsSincroFinal		bit = 0,
@EsRespaldo			bit = 0,
@EsTRCL				bit = 0,
@EsPrueba			bit = 0,
@Solicitud			uniqueidentifier	= NULL,
@Conversacion		uniqueidentifier    = NULL,
@FechaEnvio			datetime			= NULL OUTPUT,
@Ok					int					= NULL OUTPUT,
@OkRef				varchar(255)		= NULL	OUTPUT

AS BEGIN
DECLARE
@SucursalOrigen					int,
@Desde							timestamp,
@Hasta							timestamp,
@SQL							nvarchar(max),
@Tabla							varchar(100),
@TablaTipo						varchar(20),
@TablaModulo					char(5),
@EnviarTabla					bit,
@Datos							xml,
@PaqueteCambios					int,
@PaqueteBajas					int,
@Conteo							bit,
@SQL_ERROR_NUMBER				int,
@SQL_ERROR_MESSAGE				varchar(255),
@SincroISLongitudPaquete		int,
@Continuar						bit,
@IDRemotoDesde					timestamp,
@IDRemotoHasta					timestamp,
@ContadorLimpieza				int
SELECT @SQL_ERROR_NUMBER = 0, @SQL_ERROR_MESSAGE = NULL
SELECT @Conteo = 0, @ContadorLimpieza = 0
SELECT @SucursalOrigen = Sucursal, @SincroISLongitudPaquete = SincroISLongitudPaquete FROM Version
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
IF @EsPrueba = 1
BEGIN
SELECT @Datos = '<IntelisisSincroIS'+
dbo.fnXML('Tipo', 'Prueba')+
dbo.fnXMLGID('Solicitud', @Solicitud)+
dbo.fnXMLDateTime('FechaEnvio', @FechaEnvio)+
dbo.fnXMLInt('SucursalOrigen', @SucursalOrigen)+
dbo.fnXMLInt('SucursalDestino', @SucursalDestino)+
'/>'
EXEC spSincroISSend 'Prueba', @Datos, @Conversacion, @SucursalOrigen, @SucursalDestino, NULL, @Solicitud, @Ok OUTPUT, @OkRef OUTPUT
END ELSE
BEGIN
EXEC spSincroISControl @SucursalOrigen, @SucursalDestino, @Conversacion, @FechaEnvio OUTPUT, @Desde OUTPUT, @Hasta OUTPUT
EXEC spSincroISIDRemotoControl @SucursalOrigen, @SucursalDestino, @Conversacion, @FechaEnvio, @IDRemotoDesde OUTPUT, @IDRemotoHasta OUTPUT
DECLARE crSincroISEnviar CURSOR LOCAL FOR
SELECT SysTabla, UPPER(dbo.fnSincroISTablaTipo(SysTabla)), Modulo
FROM SysTabla
WHERE SincroActivo = 1
AND UPPER(NULLIF(RTRIM(dbo.fnSincroISTablaTipo(SysTabla)), '')) NOT IN (NULL, 'N/A')
AND (@EsRespaldo = 1 OR CONVERT(timestamp,dbo.fnSincroISSincroIDTablaSinonimo(SysTabla,CONVERT(int,SincroID))) BETWEEN @Desde AND @Hasta OR @Tabla = 'IDRemoto')
ORDER BY SincroOrden, SysTabla
OPEN crSincroISEnviar
FETCH NEXT FROM crSincroISEnviar INTO @Tabla, @TablaTipo, @TablaModulo
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND dbo.fnTablaExiste(dbo.fnSincroISTablaSinonimo(@Tabla)) = 1
BEGIN
SELECT @EnviarTabla = 1
IF @EsTRCL = 1 AND @TablaTipo NOT IN ('MAESTRO', 'CUENTA') SELECT @EnviarTabla = 0 ELSE
IF @TablaTipo IN ('CUENTASUCURSAL', 'CUENTAREGION', 'SALDOSUCURSAL', 'SALDOREGION') AND @SucursalOrigen > 0 SELECT @EnviarTabla = 0 ELSE
IF @TablaTipo = 'SUCURSALINFOMATRIZ' AND @SucursalOrigen = 0 SELECT @EnviarTabla = 0 ELSE
IF @EsRespaldo = 0 AND @TablaTipo = 'MAESTRO' AND @SucursalOrigen > 0 AND @Tabla NOT IN ('IDRemoto') SELECT @EnviarTabla = 0
IF @EnviarTabla = 1
BEGIN
DELETE FROM SincroISGUIDSesion WHERE SPID = @@SPID
SET @Continuar = 1
WHILE @Continuar = 1
BEGIN
IF @Tabla NOT IN ('IDRemoto')
BEGIN
EXEC spSincroISEnviarTablaEnPartes @Desde, @Hasta, @Solicitud, @Conversacion, @SucursalOrigen, @SucursalDestino, @EsSincroFinal, @EsRespaldo, @EsTRCL, @Tabla, @TablaTipo, @TablaModulo, @SincroISLongitudPaquete, @Datos OUTPUT, @PaqueteCambios OUTPUT, @PaqueteBajas OUTPUT, @Continuar OUTPUT
END ELSE
BEGIN
EXEC spSincroISEnviarTablaEnPartes @IDRemotoDesde, @IDRemotoHasta, @Solicitud, @Conversacion, @SucursalOrigen, @SucursalDestino, @EsSincroFinal, @EsRespaldo, @EsTRCL, @Tabla, @TablaTipo, @TablaModulo, @SincroISLongitudPaquete, @Datos OUTPUT, @PaqueteCambios OUTPUT, @PaqueteBajas OUTPUT, @Continuar OUTPUT
END
IF @Datos IS NOT NULL
BEGIN
EXEC spSincroISSend 'Sincro', @Datos, @Conversacion, @SucursalOrigen, @SucursalDestino, @Tabla, @Solicitud, @Ok OUTPUT, @OkRef OUTPUT
EXEC spSincroISLog @Solicitud, @Conversacion, @Tabla, @PaqueteCambios, @PaqueteBajas, @SucursalOrigen, @SucursalDestino, @FechaEnvio, NULL
SELECT @Conteo = @Conteo + 1
END
END
SET @ContadorLimpieza = @ContadorLimpieza + 1
IF @ContadorLimpieza = 20
BEGIN
CHECKPOINT
DBCC DROPCLEANBUFFERS
SET @ContadorLimpieza = 0
END
END
END
FETCH NEXT FROM crSincroISEnviar INTO @Tabla, @TablaTipo, @TablaModulo
END
CLOSE crSincroISEnviar
DEALLOCATE crSincroISEnviar
/* Hay que checar bien esto del conteo porque puede genear un rebote permantent si se quita */
IF @Conteo > 0 OR NOT EXISTS(SELECT 1 FROM IntelisisService WHERE Referencia = 'SincroIS' AND SubReferencia = 'SincroFinal' AND Estatus = 'BORRADOR' AND SucursalOrigen = @SucursalOrigen AND SucursalDestino = @SucursalDestino) OR @SucursalOrigen = 0 
BEGIN
SELECT @Datos = '<IntelisisSincroIS'+
dbo.fnXML('Tipo', 'SincroFinal')+
dbo.fnXMLGID('Solicitud', @Solicitud)+
dbo.fnXMLDateTime('FechaEnvio', @FechaEnvio)+
dbo.fnXMLInt('SucursalOrigen', @SucursalOrigen)+
dbo.fnXMLInt('SucursalDestino', @SucursalDestino)+
dbo.fnXMLBit('EsRespaldo', @EsRespaldo)+
dbo.fnXMLBit('EsTRCL', @EsTRCL)+
'/>'
EXEC spSincroISSend 'SincroFinal', @Datos, @Conversacion, @SucursalOrigen, @SucursalDestino, NULL, @Solicitud, @Ok OUTPUT, @OkRef OUTPUT
IF @EsRespaldo = 0 AND @EsTRCL = 0
EXEC spSincroISSolicitud @Solicitud, 'Sincronizacion', @SucursalOrigen, @SucursalDestino, @FechaEnvio = @FechaEnvio, @Estatus = 'PENDIENTE'
END
END
EXEC spSincroISOk @Conversacion, 'SincroIS/Sincro', @Datos, @Tabla, @SQL_ERROR_NUMBER, @SQL_ERROR_MESSAGE, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

