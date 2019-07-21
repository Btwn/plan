SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCancelarFacturaReservarPedido
@ID        		int,
@Usuario   		char(10),
@FechaRegistro	datetime,
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Empresa    	char(5),
@Articulo		char(20),
@SubCuenta		varchar(50),
@Almacen		char(10),
@Unidad			varchar(50),
@Cantidad		float,
@Aplica			char(20),
@AplicaID		char(20),
@IDPedido		int,
@IDGenerar		int,
@ContID			int,
@VolverAfectar	int,
@AplicaRenglon	float
DECLARE @Pedidos TABLE (ID int NOT NULL)
DECLARE crAplica CURSOR FOR
SELECT v.Empresa, RTRIM(d.Aplica), RTRIM(d.AplicaID), d.Almacen, d.Articulo, NULLIF(RTRIM(d.SubCuenta), ''), Unidad, ISNULL(Cantidad, 0), d.AplicaRenglon
FROM Venta v, VentaD d
WHERE v.ID = d.ID AND v.ID = @ID AND d.Aplica IS NOT NULL AND d.AplicaID IS NOT NULL AND ISNULL(Cantidad, 0) > 0
OPEN crAplica
FETCH NEXT FROM crAplica INTO @Empresa, @Aplica, @AplicaID, @Almacen, @Articulo, @SubCuenta, @Unidad, @Cantidad, @AplicaRenglon
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @IDPedido = NULL
SELECT @IDPedido = ID
FROM Venta v, MovTipo mt
WHERE v.Empresa = @Empresa AND v.Mov = @Aplica AND v.MovID = @AplicaID AND v.Estatus = 'PENDIENTE'
AND mt.Modulo = 'VTAS' AND mt.mov = v.Mov AND mt.Clave IN ('VTAS.P', 'VTAS.S')
IF @IDPedido IS NOT NULL
BEGIN
IF NOT EXISTS(SELECT * FROM @Pedidos WHERE ID = @IDPedido)
BEGIN
INSERT @Pedidos (ID) VALUES (@IDPedido)
UPDATE VentaD SET CantidadA = NULL WHERE ID = @IDPedido
END
UPDATE VentaD
SET CantidadA = ISNULL(CantidadA, 0)+@Cantidad
FROM VentaD d, Art a
WHERE d.ID = @IDPedido AND d.Almacen = @Almacen AND d.Articulo = @Articulo AND NULLIF(RTRIM(d.SubCuenta), '') = @SubCuenta AND d.Unidad = @Unidad
AND a.Articulo = d.Articulo AND a.Tipo NOT IN ('SERVICIO', 'JUEGO') AND ISNULL(@AplicaRenglon,Renglon) = Renglon
END
END
FETCH NEXT FROM crAplica INTO @Empresa, @Aplica, @AplicaID, @Almacen, @Articulo, @SubCuenta, @Unidad, @Cantidad, @AplicaRenglon
END
CLOSE crAplica
DEALLOCATE crAplica
DECLARE crPedidos CURSOR FOR
SELECT ID FROM @Pedidos
OPEN crPedidos
FETCH NEXT FROM crPedidos INTO @IDPedido
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF EXISTS(SELECT * FROM VentaD WHERE ID = @IDPedido AND NULLIF(CantidadA, 0.0) IS NOT NULL)
EXEC spInv @IDPedido, 'VTAS', 'RESERVAR', 'SELECCION', @FechaRegistro, @Aplica, @Usuario, 0, 0, NULL,
@Aplica, @AplicaID, @IDGenerar, @ContID,
@Ok, @OkRef, @VolverAfectar
END
FETCH NEXT FROM crPedidos INTO @IDPedido
END
CLOSE crPedidos
DEALLOCATE crPedidos
END

