SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroISEliminarEnviados

AS BEGIN
DECLARE
@Transaccion		varchar(50),
@Ok					int,
@OkRef				varchar(255),
@Fecha				datetime,
@Sucursal			int,
@SucursalLocal		int
SET @Transaccion = 'spSincroISEliminarEnviados' + RTRIM(LTRIM(CONVERT(varchar,@@SPID)))
SELECT @Fecha = dbo.fnFechaSinHora(DATEADD(dd,0-(5+ISNULL(ISDiasResguardoSolicitud,0)),GETDATE())), @SucursalLocal = Sucursal FROM Version
PRINT @Fecha
BEGIN TRANSACTION @Transaccion
DECLARE crSucursal CURSOR FOR
SELECT Sucursal
FROM Sucursal
WHERE Sucursal NOT IN (@SucursalLocal)
OPEN crSucursal
FETCH NEXT FROM crSucursal INTO @Sucursal
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
EXEC spSincroISEliminarEnviadosSucursal @Sucursal, @Fecha
FETCH NEXT FROM crSucursal INTO @Sucursal
END
CLOSE crSucursal
DEALLOCATE crSucursal
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION @Transaccion
END ELSE
BEGIN
ROLLBACK TRANSACTION @Transaccion
SELECT 'ERROR: ' + CONVERT(varchar,@Ok) + (SELECT Descripcion FROM MensajeLista WHERE Mensaje = @Ok) +'. ' + ISNULL(@OkRef,'')
END
END

