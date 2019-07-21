SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spISIntelisisMovilVentaConsulta
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
SET nocount
ON
BEGIN TRY
BEGIN TRAN
DECLARE
@IDVenta int,
@Cliente varchar(50),
@Usuario varchar(50)
SELECT
@Cliente = Cliente,
@Usuario = Usuario
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud')
WITH (Usuario varchar(50), Cliente varchar(50))
SELECT TOP 1
@IDVenta = V.ID
FROM Campana Ca
JOIN CampanaTipo CT ON Ca.CampanaTipo = CT.CampanaTipo AND Ca.Estatus = 'PENDIENTE'
JOIN CampanaD Visitas ON Ca.ID = Visitas.ID AND Visitas.Usuario = @Usuario
JOIN Cte Cliente ON Visitas.Contacto = Cliente.Cliente AND Cliente.Cliente = @Cliente
JOIN Venta V ON Cliente.Cliente = V.Cliente
ORDER BY V.UltimoCambio DESC
SELECT @Resultado = CAST((
SELECT
MovilVentaConsulta.ID, MovilVentaConsulta.Empresa, MovilVentaConsulta.Mov, MovilVentaConsulta.FechaEmision, MovilVentaConsulta.UltimoCambio, MovilVentaConsulta.Moneda, MovilVentaConsulta.Usuario, MovilVentaConsulta.Estatus, MovilVentaConsulta.Prioridad, MovilVentaConsulta.Cliente, MovilVentaConsulta.Almacen, MovilVentaConsulta.Agente, MovilVentaConsulta.FechaRequerida, MovilVentaConsulta.Vencimiento,
Detalle.Renglon, Detalle.RenglonID, Detalle.RenglonTipo, Detalle.Articulo, Detalle.Cantidad, Detalle.Precio, Detalle.PrecioSugerido, Detalle.Impuesto1, Detalle.PrecioMoneda
FROM Campana Ca
JOIN CampanaTipo CT ON Ca.CampanaTipo = CT.CampanaTipo AND Ca.Estatus = 'PENDIENTE'
JOIN CampanaD Visitas ON Ca.ID = Visitas.ID AND Visitas.Usuario = @Usuario
JOIN Cte Cliente ON Visitas.Contacto = Cliente.Cliente AND Cliente.Cliente = @Cliente
JOIN Venta MovilVentaConsulta ON Cliente.Cliente = MovilVentaConsulta.Cliente AND MovilVentaConsulta.ID = @IDVenta
JOIN VentaD Detalle ON MovilVentaConsulta.ID = Detalle.ID
FOR XML AUTO, TYPE, ELEMENTS
) AS NVARCHAR(MAX))
IF @Ok IS NOT NULL
SET @OkRef = (SELECT Descripcion FROM MensajeLista WHERE Mensaje = @Ok)
COMMIT TRAN
END TRY
BEGIN CATCH
SELECT @Ok = 1, @OkRef = ERROR_MESSAGE()
ROLLBACK TRAN
END CATCH
SET nocount OFF
END

