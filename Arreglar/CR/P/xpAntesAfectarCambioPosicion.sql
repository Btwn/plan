SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpAntesAfectarCambioPosicion
@Empresa		varchar(20),
@ID			int,
@Mov			varchar(20),
@movtipo		varchar(20),
@Accion		varchar(20),
@Estatus		varchar(20),
@Ok			int OUTPUT,
@OkRef		varchar(255) OUTPUT
AS BEGIN
DECLARE
@Renglon				float,
@RenglonSub				int,
@RenglonID				int,
@CantidadA				float,
@CantidadInventario		float,
@Articulo				varchar(20),
@Subcuenta				varchar(50),
@Unidad					varchar(50),
@SerieLote				varchar(50),
@Decimales				int,
@Factor					int,
@CfgMultiUnidades		bit,
@CfgMultiUnidadesNivel  char(20),
@RenglonUltimo			float,
@RenglonIDUltimo		int,
@RID					int,
@PosicionDestino		varchar(10),
@Posicionactual		varchar(10)
IF @MovTipo NOT IN ('INV.CPOS') RETURN
IF @Estatus IN ('CONFIRMAR', 'SINAFECTAR') AND @Accion = 'AFECTAR'
BEGIN
DELETE SerieLoteMov WHERE ID = @ID AND AsignacionUbicacion = 1
DELETE InvD WHERE ID = @ID AND AsignacionUbicacion = 1
SELECT @CfgMultiUnidades         = MultiUnidades,
@CfgMultiUnidadesNivel    = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD')
FROM EmpresaCfg2
WHERE Empresa = @Empresa
CREATE TABLE #RenglonActualizado (ID int, Renglon Float)
SELECT @RenglonUltimo = MAX(Renglon), @RenglonIDUltimo = MAX(RenglonID) FROM InvD WHERE ID = @ID
IF EXISTS ( SELECT e.ID FROM InvD d
JOIN InvArtUbicaciones e ON d.ID = e.ID AND d.Renglon = e.Renglon AND d.Articulo = d.Articulo  AND d.REnglonSub = e.Renglonsub
WHERE d.ID = @ID AND e.Articulo <> d.Articulo)
SELECT @Ok = 1, @OkRef = 'El Articulo ya no Corresponde al Cambio de Ubicaciones'
DECLARE CrVaciarDetallePosicion CURSOR FOR
SELECT REnglon, REnglonSub, REnglonID, Articulo, Subcuenta, SerieLote,  Unidad, Sum(ISNULL(d.cantidad,CantidadA)), ISNuLL(d.posicion, PosicionDestino) , e.Posicion
FROM InvArtUbicaciones e
LEFT OUTER JOIN InvArtUbicacionD d ON e.RID = d.RID
WHERE ID = @ID AND d.RenglonInvD IS NULL  AND ISNULL(d.cantidad,e.CantidadA) IS NOT NULL
GROUP BY ID, REnglon, REnglonSub, REnglonID, Articulo, Subcuenta, SerieLote, Unidad,  ISNuLL(d.posicion, PosicionDestino), e.Posicion
OPEN CrVaciarDetallePosicion
FETCH NEXT FROM CrVaciarDetallePosicion INTO @Renglon, @RenglonSub, @REnglonID, @Articulo, @Subcuenta, @SerieLote,  @Unidad, @CantidadA, @PosicionDestino, @PosicionActual
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF EXISTS (SELECT ID FROM InvD WHERE Id = @ID AND renglon = @Renglon AND @RenglonSub = RenglonSub AND Articulo = @Articulo )
BEGIN
SELECT @Factor = 1.0
IF @CfgMultiUnidades = 1
BEGIN
IF @CfgMultiUnidadesNivel = 'ARTICULO'
EXEC xpArtUnidadFactor @Articulo, @SubCuenta, @Unidad, @Factor OUTPUT, @Decimales OUTPUT, NULL
ELSE
EXEC xpUnidadFactor @Articulo, @SubCuenta, @Unidad, @Factor OUTPUT, @Decimales OUTPUT
SELECT @Factor = ISNULL(NULLIF(@Factor, 0), 1)
END
SELECT @CantidadInventario = @CantidadA * ISNULL(@Factor, 1.0)
IF NOT EXISTS (SELECT ID FROM #RenglonActualizado WHERE ID = @ID and REnglon = @Renglon)
BEGIN
UPDATE InvD SET Cantidad = @CantidadA, Unidad = @Unidad, CantidadInventario = @CantidadInventario, Posicion = @PosicionActual, PosicionDestino = @PosicionDestino WHERE ID = @ID AND Renglon = @Renglon AND Articulo = @Articulo
IF @SerieLote IS NOT NULL
INSERT SerieLoteMov (Empresa,  Modulo,  ID,  RenglonID,  Articulo, SubCuenta, SerieLote, Cantidad, AsignacionUbicacion)
SELECT @Empresa, 'INV', @ID, @RenglonID, Articulo,  ISNULL(SubCuenta, ''), SerieLote, SUM(ISNULL(d.cantidad,CantidadA)), 1
FROM InvArtUbicaciones e
LEFT OUTER JOIN InvArtUbicacionD d ON e.RID = d.RID
WHERE ID = @ID
AND REnglon = @REnglon And REnglonSub = @REnglonSub AND REnglonID = @RenglonId AND Articulo = @Articulo AND ISNuLL(Subcuenta,'') = ISNULL(@Subcuenta,'') AND SerieLote = @SerieLote AND Unidad = @Unidad AND   ISNULL(d.posicion, PosicionDestino) = @PosicionDestino AND e.posicion = @PosicionActual
GROUP BY ID, REnglon, REnglonSub, REnglonID, Articulo, Subcuenta, SerieLote, Unidad,  ISNuLL(d.posicion, PosicionDestino), e.Posicion
INSERT #RenglonActualizado (ID, Renglon) VALUES (@ID, @Renglon)
UPDATE InvArtUbicaciones SET RenglonInvD = @Renglon FROM InvArtUbicaciones e
LEFT OUTER JOIN InvArtUbicacionD d ON e.RID = d.RID
WHERE ID = @ID
AND REnglon = @REnglon And REnglonSub = @REnglonSub AND REnglonID = @RenglonId AND Articulo = @Articulo AND ISNULL(Subcuenta,'') = ISNULL(@Subcuenta,'') AND SerieLote = @SerieLote AND Unidad = @Unidad AND   ISNULL(d.posicion, PosicionDestino) = @PosicionDestino AND e.posicion = @PosicionActual
END
ELSE
BEGIN
SELECT @RenglonUltimo = @RenglonUltimo + 2048, @RenglonIDultimo = @RenglonIDUltimo + 1
INSERT InvD (ID,         Renglon,  RenglonSub, RenglonID,  RenglonTipo,  Aplica,     AplicaID,     Almacen,  Producto,  SubProducto,  ProdSerieLote,  Articulo,  SubCuenta,  Cantidad,  Merma,  Desperdicio,  Unidad,  CantidadInventario, Factor,  Tipo, Posicion, PosicionDestino, AsignacionUbicacion)
SELECT @ID, @RenglonUltimo, 0,          @RenglonIDultimo, RenglonTipo, NULL, NULL, Almacen, Producto, SubProducto, ProdSerieLote, Articulo, SubCuenta, @CantidadA, Merma, Desperdicio, @Unidad, @CantidadInventario, @Factor, Tipo, @PosicionActual, @PosicionDestino, 1
FROM InvD
WHERE ID = @ID AND Renglon = @Renglon AND Articulo = @Articulo
IF @SerieLote IS NOT NULL
INSERT SerieLoteMov (Empresa,  Modulo,  ID,  RenglonID,  Articulo, SubCuenta, SerieLote, Cantidad, AsignacionUbicacion)
SELECT @Empresa, 'INV', @ID, @RenglonIDUltimo, Articulo,  ISNULL(SubCuenta, ''), SerieLote, SUM(ISNULL(d.cantidad,CantidadA)), 1
FROM InvArtUbicaciones e
LEFT OUTER JOIN InvArtUbicacionD d ON  e.RID = d.RID
WHERE ID = @ID
AND REnglon = @REnglon And REnglonSub = @REnglonSub AND REnglonID = @RenglonId AND Articulo = @Articulo AND ISNULL(Subcuenta,'') = ISNULL(@Subcuenta,'') AND SerieLote = @SerieLote AND Unidad = @Unidad AND   ISNULL(d.posicion, PosicionDestino) = @PosicionDestino AND e.posicion = @PosicionActual
GROUP BY ID, REnglon, REnglonSub, REnglonID, Articulo, Subcuenta, SerieLote, Unidad,  ISNuLL(d.posicion, PosicionDestino), e.Posicion
UPDATE InvArtUbicaciones SET RenglonInvD = @RenglonIDUltimo             FROM InvArtUbicaciones e
LEFT OUTER JOIN InvArtUbicacionD d ON e.RID = d.RID
WHERE ID = @ID
AND REnglon = @REnglon And REnglonSub = @REnglonSub AND REnglonID = @RenglonId AND Articulo = @Articulo AND ISNULL(Subcuenta,'') = ISNULL(@Subcuenta,'') AND SerieLote = @SerieLote AND Unidad = @Unidad AND   ISNULL(d.posicion, PosicionDestino) = @PosicionDestino
END
END
ELSE
BEGIN
SELECT @RID = RID FROM InvArtUbicaciones WHERE ID = @ID AND renglon = @Renglon AND @RenglonSub = RenglonSub AND Articulo = @Articulo
DELETE InvArtUbicaciones WHERE RID = @RID
DELETE InvArtUbicacionD WHERE RID = @RID
END
END
FETCH NEXT FROM CrVaciarDetallePosicion INTO @Renglon, @RenglonSub, @REnglonID, @Articulo, @Subcuenta, @SerieLote,  @Unidad, @CantidadA, @PosicionDestino, @PosicionActual
END  
CLOSE CrVaciarDetallePosicion
DEALLOCATE CrVaciarDetallePosicion
IF @Ok IS NULL
UPDATE Inv SET Estatus = 'CONFIRMAR' WHERE ID = @ID
END
END

