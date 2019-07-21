SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spProcesarVentaFM
@Estacion		int,
@EnSilencio		bit	 	= 0,
@Ok			int	 	= NULL	OUTPUT,
@OkRef		varchar(255)	= NULL	OUTPUT

AS BEGIN
DECLARE
@Conteo		int,
@ID			int,
@FechaRegistro	datetime,
@Mensaje		varchar(255),
@CFDEmpresa         varchar(5),
@CFDID              int,
@CFDModulo          varchar(5),
@FacturaMov         varchar(20),
@FacturaMovID       varchar(20),
@CFDMov             varchar(20),
@CFDMovID           varchar(20),
@CFDEstatusNuevo    varchar(15),
@FacturaEstatus     varchar(15),
@Empresa            varchar(5)
DECLARE @TablaCFD table(
Empresa        varchar(5),
Modulo         varchar(5),
Mov            varchar(20),
MovID          varchar(20),
ID             int,
EstatusNuevo   varchar(15))
SELECT @FechaRegistro = GETDATE(), @Conteo = 0
CREATE TABLE #ProcesarVentaFM(ID int NOT NULL)
INSERT #ProcesarVentaFM (ID)
SELECT ID FROM ListaID WHERE Estacion = @Estacion
BEGIN TRANSACTION
DECLARE crProcesarVentaFM CURSOR LOCAL
FOR SELECT ID FROM #ProcesarVentaFM
OPEN crProcesarVentaFM
FETCH NEXT FROM crProcesarVentaFM INTO @ID
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
/*AR 11/09/07 */
UPDATE Venta SET OrigenTipo = 'VMOS' WHERE ID = @ID
IF EXISTS (SELECT Convert(float, Disponible) FROM Venta v
JOIN VentaD d ON v.ID = d.ID
JOIN ArtDisponible a ON d.Articulo = a.Articulo AND ISNULL(d.almacen,v.Almacen) = a.almacen AND v.Empresa = a.Empresa
WHERE v.ID = @ID AND a.Disponible < 0)
SELECT @Ok = 20025
IF EXISTS (SELECT v.ID FROM Venta v
JOIN VentaD d ON v.ID = d.ID
JOIN SerieLoteMov sm ON sm.Empresa = v.Empresa AND sm.Modulo = 'VTAS' AND sm.ID = d.ID AND d.RenglonID = sm.RenglonID AND d.Articulo = sm.Articulo AND ISNULL(d.SubCuenta,'') = ISNULL(sm.SubCuenta,'')
JOIN SerieLote sl ON sl.Sucursal = v.Sucursal AND sl.Empresa = v.Empresa AND sl.Articulo = sm.Articulo AND ISNULL(sl.SubCuenta,'') = ISNULL(sm.SubCuenta,'') AND sl.Serielote = sm.SerieLote AND sl.Almacen = d.Almacen
WHERE v.ID = @ID AND Existencia < 0)
SELECT @Ok = 20510
IF @OK IS NULL
EXEC spInv @ID, 'VTAS', 'AFECTAR', 'TODO', @FechaRegistro, NULL, NULL, 1, 0, NULL,
NULL, NULL, NULL, NULL,
@Ok OUTPUT, @OkRef OUTPUT, 0
SELECT @Conteo = @Conteo + 1
IF @Ok IS NULL
BEGIN
SELECT @FacturaEstatus = Estatus, @FacturaMov = Mov, @FacturaMovID = MovID, @Empresa = Empresa  FROM Venta WHERE ID = @ID
INSERT @TablaCFD(Empresa,  ID,         Modulo, Mov,          MovID,         EstatusNuevo)
SELECT           @Empresa, @ID, 'VTAS', @FacturaMov,  @FacturaMovID, @FacturaEstatus
END
END
FETCH NEXT FROM crProcesarVentaFM INTO @ID
END 
CLOSE crProcesarVentaFM
DEALLOCATE crProcesarVentaFM
IF @Ok IS NULL
COMMIT TRANSACTION
IF @Ok IS NULL
BEGIN
DECLARE crcfd CURSOR LOCAL FOR
SELECT Empresa,ID,Modulo,Mov,MovID,EstatusNuevo
FROM @TablaCFD
OPEN crcfd
FETCH NEXT FROM crcfd INTO @CFDEmpresa,@CFDID,@CFDModulo,@CFDMov,@CFDMovID,@CFDEstatusNuevo
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
EXEC spCFDFlexAfectarSinMovFinal @CFDEmpresa,@CFDModulo, @CFDMov, @CFDMovID, @CFDID, @CFDEstatusNuevo, NULL, NULL
SELECT @CFDEmpresa = NULL, @CFDModulo= NULL, @CFDMov= NULL, @CFDMovID= NULL, @CFDID= NULL
FETCH NEXT FROM crcfd INTO @CFDEmpresa,@CFDID,@CFDModulo,@CFDMov,@CFDMovID,@CFDEstatusNuevo
END
CLOSE crcfd
DEALLOCATE crcfd
END
ELSE
ROLLBACK TRANSACTION
DELETE ListaID WHERE Estacion = @Estacion
IF @Ok IS NULL
SELECT @Mensaje = CONVERT(varchar, @Conteo)+' Movimientos Procesados.'
ELSE
SELECT @Mensaje = Descripcion+' '+RTRIM(ISNULL(@OkRef, '')) FROM MensajeLista WHERE Mensaje = @Ok
SELECT @Mensaje
RETURN
END

