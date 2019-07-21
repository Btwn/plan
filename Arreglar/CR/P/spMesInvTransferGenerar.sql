SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMesInvTransferGenerar
@Empresa          varchar(5),
@Usuario          varchar(10),
@Sucursal         int,
@Lanzamiento      int

AS
BEGIN
DECLARE
@IDInv              int,
@MovInv             varchar(20),
@FechaEmision       datetime,
@Articulo           varchar(20),
@Almacen            varchar(10),
@AlmacenDestino     varchar(10),
@Renglon            int,
@RenglonID          int,
@ID                 int,
@Cantidad           float,
@Unidad             varchar(50),
@Ok                 int,
@OkRef              varchar(255),
@Moneda             varchar(10),
@TipoCambio         float,
@Mensaje            varchar(255),
@CfgMultiUnidades		bit,
@CfgMultiUnidadesNivel		varchar(20),
@ArtTipo            varchar(20),
@RenglonTipo        varchar(1),
@CantidadInventario float
IF ISNULL((SELECT ecm.TransferenciaManual FROM EmpresaCfgMES ecm WHERE ecm.Empresa = @Empresa), 0) = 0
BEGIN
SELECT 'Desactivado'
RETURN
END
IF (SELECT SeriesLotesAutoOrden FROM EmpresaCfg ec WHERE ec.Empresa = @Empresa) = 'No'
BEGIN
SELECT @Articulo = MIN(m.Hijo)
FROM MesInvTransfer m
JOIN Art a ON m.Hijo = a.Articulo
LEFT OUTER JOIN MesInvTransferSerieLote sl ON sl.Usuario = m.Usuario AND sl.ID = m.ID
WHERE m.Usuario = @Usuario
AND a.Tipo IN ('Serie', 'Lote')
GROUP BY m.Hijo, m.CantidadA
HAVING m.CantidadA <> SUM(sl.Cantidad)
IF @Articulo IS NOT NULL
BEGIN
SELECT 'La Cantidad capturada de la Serie/Lote no coincide con la cantidad a Afectar. Artículo: ' + RTRIM(@Articulo)
RETURN
END
END
BEGIN TRAN
SELECT @FechaEmision = GETDATE()
EXEC spExtraerFecha	@FechaEmision OUTPUT
SELECT @CfgMultiUnidades         = MultiUnidades,
@CfgMultiUnidadesNivel    = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD')
FROM EmpresaCfg2
WHERE Empresa = @Empresa
SELECT @Moneda = MonedaCosteo FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @TipoCambio = m.TipoCambio FROM Mon m WHERE m.Moneda = @Moneda
DECLARE crMesInvTransferGenerar CURSOR FOR
SELECT mit.Almacen, mit.AlmacenD
FROM MesInvTransfer mit
WHERE mit.Usuario = @Usuario
AND mit.Lanzamiento = @Lanzamiento
AND ISNULL(mit.CantidadA, 0) > 0
AND ISNULL(mit.Almacen, '') <> ISNULL(mit.AlmacenD, '')
GROUP BY mit.Almacen, mit.AlmacenD
OPEN crMesInvTransferGenerar
FETCH NEXT FROM crMesInvTransferGenerar INTO @Almacen, @AlmacenDestino
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @IDInv = NULL
INSERT INTO Inv
(Empresa,  Mov,             FechaEmision,  Moneda,  TipoCambio,  Referencia,   Usuario, Estatus,       Almacen,  AlmacenDestino, OrigenTipo, Sucursal, MesLanzamiento)
VALUES(@Empresa, 'Transferencia', @FechaEmision, @Moneda, @TipoCambio, @Lanzamiento, @Usuario, 'SINAFECTAR', @Almacen, @AlmacenDestino, 'MESTxfer', @Sucursal, @Lanzamiento)
SELECT @IDInv = @@IDENTITY
IF @IDInv IS NOT NULL
BEGIN
DECLARE crMesInvTransferGenerarD CURSOR FOR
SELECT mit.ID, (ROW_NUMBER() OVER(order by Hijo))*2048, mit.CantidadA, mit.Hijo, mit.UnidMedidaAlmacen, a.Tipo
FROM MesInvTransfer mit
JOIN Art a ON mit.Hijo = a.Articulo
WHERE mit.Usuario = @Usuario
AND mit.Lanzamiento = @Lanzamiento
AND ISNULL(mit.CantidadA, 0) > 0
AND ISNULL(mit.Almacen, '') = @Almacen
AND ISNULL(mit.AlmacenD, '') = @AlmacenDestino
SELECT @RenglonID = 1
OPEN crMesInvTransferGenerarD
FETCH next FROM crMesInvTransferGenerarD INTO @ID, @Renglon, @Cantidad, @Articulo, @Unidad, @ArtTipo
WHILE @@FETCH_STATUS = 0
BEGIN
EXEC spRenglonTipo @ArtTipo, '', @RenglonTipo OUTPUT
EXEC xpCantidadInventario @Articulo, '', @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
INSERT INTO InvD
(ID,     Renglon, RenglonSub,  RenglonID,  RenglonTipo,  Cantidad,  CantidadInventario,  Almacen,  Articulo, Unidad, MesLanzamiento)
VALUES(@IDInv, @Renglon, 0,          @RenglonID, @RenglonTipo, @Cantidad, @CantidadInventario, @Almacen, @Articulo, @Unidad, @Lanzamiento)
IF @ArtTipo IN ('Serie', 'Lote')
INSERT INTO SerieLoteMov
(Empresa, Modulo, ID,     RenglonID,  Articulo, SubCuenta, SerieLote, Cantidad, Sucursal)
SELECT @Empresa, 'INV', @IDInv, @RenglonID, @Articulo, '',        sl.SerieLote, sl.Cantidad, @Sucursal
FROM MesInvTransferSerieLote sl
WHERE sl.Usuario = @Usuario
AND sl.ID = @ID
AND ISNULL(sl.Cantidad, 0) > 0
SELECT @RenglonID = @RenglonID + 1
FETCH next FROM crMesInvTransferGenerarD INTO @ID, @Renglon, @Cantidad, @Articulo, @Unidad, @ArtTipo
END
CLOSE crMesInvTransferGenerarD
DEALLOCATE crMesInvTransferGenerarD
EXEC spAfectar 'INV', @IDInv, 'AFECTAR', NULL, NULL, @Usuario, 0, 1, @Ok OUTPUT, @OkRef OUTPUT, NULL, 0
END
ELSE
SELECT @Ok = 10060, @OkRef = 'No se generó la Transferencia'
FETCH NEXT FROM crMesInvTransferGenerar INTO @Almacen, @AlmacenDestino
END
CLOSE crMesInvTransferGenerar
DEALLOCATE crMesInvTransferGenerar
IF @Ok IS NULL
BEGIN
UPDATE PrevisionesConsumoMES SET EstatusIntelIMES = CASE WHEN ISNULL(PrevisionesConsumoMES.Transferido, 0)+ CASE a.AlmacenROP WHEN mit.AlmacenD THEN ISNULL(mit.CantidadA, 0) ELSE 0 END >= ISNULL(mit.Cantidad, 0) THEN 2 ELSE 1 END,
PrevisionesConsumoMES.Transferido = ISNULL(PrevisionesConsumoMES.Transferido, 0) + CASE a.AlmacenROP WHEN mit.AlmacenD THEN ISNULL(mit.CantidadA, 0) ELSE 0 END
FROM MesInvTransfer mit
JOIN Art a ON mit.Hijo = a.Articulo
WHERE mit.Usuario = @Usuario
AND mit.Lanzamiento = PrevisionesConsumoMES.Lanzamiento AND PrevisionesConsumoMES.Padre = mit.Padre AND PrevisionesConsumoMES.Hijo = mit.Hijo
AND ISNULL(mit.CantidadA, 0) > 0
DELETE FROM MesInvTransfer WHERE Usuario = @Usuario
DELETE FROM MesInvTransferSerieLote WHERE Usuario = @Usuario
COMMIT TRAN
SELECT 'Proceso Concluido'
END
ELSE
BEGIN
SELECT @Mensaje = ml.Descripcion FROM MensajeLista ml WHERE ml.Mensaje = @Ok
SELECT @Mensaje = RTRIM(@Mensaje) + '. ' + RTRIM(@OkRef)
SELECT @Mensaje
ROLLBACK TRAN
END
RETURN
END

