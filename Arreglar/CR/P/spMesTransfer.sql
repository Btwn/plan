SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMesTransfer
@Empresa      varchar(5),
@Usuario      varchar(10),
@Sucursal     int

AS BEGIN
DECLARE
@ID           		        int,
@IDTransfer               int,
@MovTransfer              varchar(20),
@FechaEmision             datetime,
@Articulo                 varchar(20),
@Cantidad                 float,
@CantidadInventario       float,
@Unidad                   varchar(50),
@Almacen                  varchar(10),
@AlmacenDestino           varchar(10),
@CfgMultiUnidades	      	bit,
@CfgMultiUnidadesNivel		varchar(20),
@ArtTipo                  varchar(20),
@Moneda                   varchar(10),
@TipoCambio               float,
@Renglon                  float,
@RenglonTipo              varchar(1),
@Mensaje                  varchar(255),
@Ok                       int,
@OkRef                    varchar(255)
IF ISNULL((SELECT ecm.TransferenciaManual FROM EmpresaCfgMES ecm WHERE ecm.Empresa = @Empresa), 0) = 1
BEGIN
SELECT 'Desactivado'
RETURN
END
BEGIN TRANSACTION
SELECT @CfgMultiUnidades         = MultiUnidades,
@CfgMultiUnidadesNivel    = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD')
FROM EmpresaCfg2
WHERE Empresa = @Empresa
SELECT @Moneda = ec.MonedaCosteo
FROM EmpresaCfg ec
WHERE ec.Empresa = @Empresa
SELECT @TipoCambio = m.TipoCambio FROM Mon m WHERE m.Moneda = @Moneda
SELECT @FechaEmision = GETDATE()
EXEC spExtraerFecha @FechaEmision OUTPUT
CREATE TABLE #MesTransfer(
Articulo        varchar(20),
Cantidad        money,
Unidad          varchar(50)   NULL,
Almacen         varchar(10),
AlmacenDestino  varchar(10))
SELECT @MovTransfer = ecm.InvOrdenTransferencia
FROM EmpresaCfgMov ecm
WHERE ecm.Empresa = @Empresa
INSERT INTO #MesTransfer(Articulo, Cantidad, Unidad, Almacen, AlmacenDestino)
SELECT mt.Hijo, mt.CantidadTotalHijo, mt.UnidMedidaAlmacen, a.AlmMesComs, a.AlmacenROP
FROM PrevisionesConsumoMES mt
JOIN Art a ON mt.Hijo = a.Articulo
WHERE ISNULL(mt.EstatusIntelIMES, 0) = 0 AND
a.AlmMesComs <> a.AlmacenROP
AND NULLIF(RTRIM(a.AlmacenROP), '') IS NOT NULL
AND NULLIF(RTRIM(a.AlmMesComs), '') IS NOT NULL
DECLARE crMesTransfer CURSOR FOR
SELECT mt.Almacen, mt.AlmacenDestino
FROM #MesTransfer mt
GROUP BY mt.Almacen, mt.AlmacenDestino
OPEN crMesTransfer
FETCH NEXT FROM crMesTransfer INTO @Almacen, @AlmacenDestino
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @IDTransfer = NULL
INSERT INTO Inv(Empresa, Mov, FechaEmision, Moneda, TipoCambio, Usuario, Estatus, Almacen, AlmacenDestino, OrigenTipo, Sucursal)
VALUES(@Empresa, @MovTransfer, @FechaEmision, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', @Almacen, @AlmacenDestino, 'MESTrfer', @Sucursal)
SELECT @IDTransfer = @@IDENTITY
IF @IDTransfer IS NOT NULL
BEGIN
SELECT @Renglon = 2048
DECLARE crMesTransferD CURSOR FOR
SELECT mt.Articulo, mt.Cantidad, mt.Unidad, a.Tipo
FROM #MesTransfer mt
JOIN Art a ON mt.Articulo = a.Articulo
WHERE mt.Almacen = @Almacen AND mt.AlmacenDestino = @AlmacenDestino
OPEN crMesTransferD
FETCH next FROM crMesTransferD INTO  @Articulo, @Cantidad, @Unidad, @ArtTipo
WHILE @@FETCH_STATUS = 0
BEGIN
EXEC spRenglonTipo @ArtTipo, NULL, @RenglonTipo OUTPUT
SELECT @Renglon = @Renglon + 2048
EXEC xpCantidadInventario @Articulo, NULL, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
/*  jsmv Actualizar InvD en Espacios id de MovMes / prodserielote = lote de MES */
INSERT INTO InvD
(ID,          Renglon, RenglonSub, RenglonID,  RenglonTipo,  Cantidad,  CantidadInventario,  Almacen,  Articulo, Unidad)
VALUES(@IDTransfer, @Renglon, 0,         0,          @RenglonTipo, @Cantidad, @CantidadInventario, @AlmacenDestino, @Articulo, @Unidad)
EXEC xpCantidadInventario @Articulo, NULL, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
FETCH next FROM crMesTransferD INTO  @Articulo, @Cantidad, @Unidad, @ArtTipo
END
EXEC spAfectar 'INV', @IDTransfer, 'AFECTAR', NULL, NULL, @Usuario, 0, 1, @Ok OUTPUT, @OkRef OUTPUT, NULL, 1
CLOSE crMesTransferD
DEALLOCATE crMesTransferD
END
ELSE
SELECT @Ok = 10060, @OkRef = 'No se generó el movimiento'
FETCH NEXT FROM crMesTransfer INTO @Almacen, @AlmacenDestino
END
CLOSE crMesTransfer
DEALLOCATE crMesTransfer
DELETE FROM #MesTransfer
INSERT INTO #MesTransfer(Articulo, Cantidad, Unidad, Almacen, AlmacenDestino)
SELECT mt.Padre, mt.CantidadTotalPadre, mt.UnidMedidaAlmacen, a.AlmacenROP, a.AlmMesComs 
FROM PrevisionesConsumoMES mt
JOIN Art a ON mt.Padre = a.Articulo
WHERE ISNULL(mt.EstatusIntelIMES, 0) = 0
AND a.AlmMesComs <> a.AlmacenROP
AND NULLIF(RTRIM(a.AlmacenROP), '') IS NOT NULL
AND NULLIF(RTRIM(a.AlmMesComs), '') IS NOT NULL
AND ISNULL(mt.FaseConsumo, 0) = '999'
DECLARE crMesTransfer CURSOR FOR
SELECT mt.Almacen, mt.AlmacenDestino
FROM #MesTransfer mt
GROUP BY mt.Almacen, mt.AlmacenDestino
OPEN crMesTransfer
FETCH NEXT FROM crMesTransfer INTO @Almacen, @AlmacenDestino
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @IDTransfer = NULL
INSERT INTO Inv(Empresa, Mov, FechaEmision, Moneda, TipoCambio, Usuario, Estatus, Almacen, AlmacenDestino, OrigenTipo, Sucursal)
VALUES(@Empresa, @MovTransfer, @FechaEmision, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', @Almacen, @AlmacenDestino, 'MESTrfer', @Sucursal)
SELECT @IDTransfer = @@IDENTITY
IF @IDTransfer IS NOT NULL
BEGIN
SELECT @Renglon = 2048
DECLARE crMesTransferD CURSOR FOR
SELECT mt.Articulo, mt.Cantidad, mt.Unidad, a.Tipo
FROM #MesTransfer mt
JOIN Art a ON mt.Articulo = a.Articulo
WHERE mt.Almacen = @Almacen AND mt.AlmacenDestino = @AlmacenDestino
OPEN crMesTransferD
FETCH next FROM crMesTransferD INTO  @Articulo, @Cantidad, @Unidad, @ArtTipo
WHILE @@FETCH_STATUS = 0
BEGIN
EXEC spRenglonTipo @ArtTipo, NULL, @RenglonTipo OUTPUT
SELECT @Renglon = @Renglon + 2048
EXEC xpCantidadInventario @Articulo, NULL, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
/*  jsmv Actualizar InvD en Espacios id de MovMes / prodserielote = lote de MES */
INSERT INTO InvD
(ID,          Renglon, RenglonSub, RenglonID,  RenglonTipo,  Cantidad,  CantidadInventario,  Almacen,  Articulo, Unidad)
VALUES(@IDTransfer, @Renglon, 0,         0,          @RenglonTipo, @Cantidad, @CantidadInventario, @AlmacenDestino, @Articulo, @Unidad)
EXEC xpCantidadInventario @Articulo, NULL, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
FETCH next FROM crMesTransferD INTO  @Articulo, @Cantidad, @Unidad, @ArtTipo
END
EXEC spAfectar 'INV', @IDTransfer, 'AFECTAR', NULL, NULL, @Usuario, 0, 1, @Ok OUTPUT, @OkRef OUTPUT, NULL, 1
CLOSE crMesTransferD
DEALLOCATE crMesTransferD
END
ELSE
SELECT @Ok = 10060, @OkRef = 'No se generó el movimiento'
FETCH NEXT FROM crMesTransfer INTO @Almacen, @AlmacenDestino
END
CLOSE crMesTransfer
DEALLOCATE crMesTransfer
IF @Ok IS NULL
BEGIN
UPDATE PrevisionesConsumoMES SET EstatusIntelIMES = 1
FROM PrevisionesConsumoMES mt
JOIN Art a ON mt.Hijo = a.Articulo
WHERE ISNULL(mt.EstatusIntelIMES, 0) = 0
AND a.AlmMesComs <> a.AlmacenROP
AND NULLIF(RTRIM(a.AlmacenROP), '') IS NOT NULL
AND NULLIF(RTRIM(a.AlmMesComs), '') IS NOT NULL
UPDATE PrevisionesConsumoMES SET EstatusIntelIMES = 1
FROM Art a
WHERE Hijo = a.Articulo
AND ISNULL(EstatusIntelIMES, 0) = 0
AND a.AlmMesComs <> a.AlmacenROP
AND NULLIF(RTRIM(a.AlmacenROP), '') IS NOT NULL
AND NULLIF(RTRIM(a.AlmMesComs), '') IS NOT NULL
AND ISNULL(FaseConsumo, 0) = '999'
SELECT @Mensaje = 'Proceso concluido con éxito'
COMMIT TRAN
END
ELSE
BEGIN
SELECT @Mensaje = m.Descripcion FROM MensajeLista m WHERE m.Mensaje = @Ok
SELECT @Mensaje = RTRIM(ISNULL(@Mensaje, '')) + ' ' + RTRIM(ISNULL(@OkRef, ''))
ROLLBACK TRAN
END
SELECT @Mensaje
RETURN
END

