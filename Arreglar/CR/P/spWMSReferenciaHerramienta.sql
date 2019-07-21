SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSReferenciaHerramienta
@Referencia		varchar(50) OUTPUT

AS BEGIN
DECLARE @Modulo				varchar(5),
@ID					int,
@IDModulo			int,
@SucursalDestino	int,
@AlmacenDestino		varchar(10)
DECLARE @Tabla TABLE (IDModulo int, Modulo char(5), SucursalDestino int)
IF (SELECT COUNT(Modulo) FROM (SELECT DISTINCT w.Modulo FROM #CualesID i JOIN WMSModuloTarima w ON i.ID = w.ID) x) = 1
BEGIN
DECLARE crCualesID CURSOR FOR
SELECT w.IDModulo, w.Modulo
FROM #CualesID i
JOIN WMSModuloTarima w
ON i.ID = w.ID
WHERE w.Modulo = 'INV'
OPEN crCualesID
FETCH NEXT FROM crCualesID INTO @IDModulo, @Modulo
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @AlmacenDestino	= AlmacenDestino,
@SucursalDestino	= NULL
FROM Inv
WHERE ID = @IDModulo
IF @AlmacenDestino IS NOT NULL
SELECT @SucursalDestino = (SELECT Sucursal FROM  Alm WHERE Almacen = @AlmacenDestino)
INSERT @Tabla
SELECT @IDModulo, @Modulo, @SucursalDestino
FETCH NEXT FROM crCualesID INTO @IDModulo, @Modulo
END
CLOSE crCualesID
DEALLOCATE crCualesID
IF (SELECT COUNT(*) FROM @Tabla WHERE SucursalDestino <> @SucursalDestino) = 0
SELECT @Referencia = 'Sucursal Destino ' + CONVERT(varchar,@SucursalDestino)
END
RETURN
END

