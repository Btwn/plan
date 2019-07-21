SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSGenerarCierreDia
@Estacion			int,
@Empresa			char(5),
@FacturaMov			varchar(20),
@Fecha				datetime,
@Usuario			char(10),
@Ok					int		OUTPUT,
@OkRef				varchar(255)	OUTPUT,
@DevolucionMov		varchar(20) = NULL

AS
BEGIN
DECLARE
@OkRefNota		varchar(255),
@Sucursal		int,
@Moneda			varchar(10)
DECLARE @Tabla table (ID int)
INSERT @Tabla
SELECT ID
FROM ListaID
WHERE Estacion = @Estacion
DELETE ListaID WHERE Estacion = @Estacion
DECLARE crSucursal CURSOR LOCAL FOR
SELECT Sucursal, Moneda
FROM POSCierreDia
WHERE ID IN (SELECT ID FROM @Tabla )
GROUP BY Sucursal, Moneda
OPEN crSucursal
FETCH NEXT FROM crSucursal INTO @Sucursal, @Moneda
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Ok IS NULL
BEGIN
DELETE ListaID WHERE Estacion = @Estacion
INSERT ListaID(Estacion,ID)
SELECT @Estacion, v.ID
FROM Venta v JOIN POSCierreDia p ON v.Sucursal = p.Sucursal AND v.FechaEmision = p.FechaEmision AND v.Empresa = p.Empresa
AND v.Almacen = p.Almacen AND v.Moneda = p.Moneda
WHERE p.ID IN (SELECT ID FROM @Tabla ) AND p.Sucursal = @Sucursal
IF EXISTS(SELECT * FROM ListaID WHERE Estacion = @Estacion)
EXEC spProcesarVentaN @Estacion = @Estacion, @Empresa = @Empresa, @FacturaMov = @FacturaMov , @FechaEmision = @Fecha, @Usuario = @Usuario,
@EnSilencio = 0, @Ok = @Ok OUTPUT, @OkRef = @OkRefNota OUTPUT, @DevolucionMov = @DevolucionMov, @Sucursal = @Sucursal
END
END
FETCH NEXT FROM crSucursal INTO @Sucursal, @Moneda
END
CLOSE crSucursal
DEALLOCATE crSucursal
IF @Ok IS NOT NULL
SELECT Descripcion+' '+ISNULL(RTRIM(@OkRef),'')
FROM MensajeLista
WHERE Mensaje = @Ok
ELSE
SELECT ISNULL(@OkRefNota  ,'')+ISNULL(@OkRef,'')
RETURN
END

