SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarInvExtraccion
@Estacion			int,
@ID					int,
@Empresa			char(5),
@GenerarMov			char(20),
@AlmacenDestino		char(10),
@Usuario			char(10),
@Sucursal			int

AS
BEGIN
DECLARE
@IDInv				int,
@Mov					char(20),
@MovID				char(20),
@Almacen				char(10),
@FechaEmision			datetime,
@Moneda				char(10),
@TipoCambio			float,
@Renglon				float,
@RenglonSub			int,
@RenglonID			int,
@CantidadA			float,
@CantidadA2			float,
@CantidadInventario	float,
@PaqueteCantidad		float,
@RenglonTipo			char(1),
@Articulo				char(20),
@SubCuenta			char(50),
@Observaciones		varchar(100),
@Unidad				char(50),
@CfgMultiUnidades     bit,
@CfgMultiUnidadesNivel char(20)
SELECT @Mov = c.Mov, @MovID = c.MovID, @Almacen = c.Almacen
FROM Compra c
WHERE c.ID = @ID
IF NOT EXISTS(SELECT * FROM Alm a WHERE a.Almacen = @AlmacenDestino)
BEGIN
SELECT 'El Almacén indicado no existe'
RETURN
END
IF NOT EXISTS(SELECT * FROM MovTipo mt WHERE mt.Modulo = 'INV' AND mt.Mov = @GenerarMov)
BEGIN
SELECT 'El Movimiento indicado no existe'
RETURN
END
IF NOT EXISTS(SELECT * FROM MovTipo mt WHERE mt.Modulo = 'INV' AND mt.Mov = @GenerarMov AND mt.Clave IN ('INV.OI', 'INV.SI'))
BEGIN
SELECT 'El Movimiento debe ser Tipo Orden Traspaso o Salida Traspaso'
RETURN
END
IF NOT EXISTS(SELECT * FROM CompraExtraccionLista cel WHERE cel.Estacion = @Estacion AND cel.ID = @ID AND ISNULL(cel.CantidadA, 0) > 0)
BEGIN
SELECT 'No hay registros que generar'
RETURN
END
SELECT @Articulo = Min(Articulo)
FROM CompraExtraccion ce
WHERE ce.Estacion = @Estacion
AND ce.ID = @ID
AND ISNULL(ce.CantidadA, 0) > ce.Existencia
IF @Articulo IS NOT NULL
BEGIN
SELECT 'El Artículo ' + RTRIM(@Articulo) + ' excede la cantidad indicada a la Existencia'
RETURN
END
IF @Almacen = @AlmacenDestino
BEGIN
SELECT 'El Almacén Destino debe ser diferente al de la Compra'
RETURN
END
SELECT @FechaEmision = GETDATE()
EXEC spExtraerFecha @FechaEmision OUTPUT
SELECT @Moneda = ec.ContMoneda
FROM EmpresaCfg ec
WHERE Empresa = @Empresa
SELECT @CfgMultiUnidades         = ISNULL(MultiUnidades, 0),
@CfgMultiUnidadesNivel    = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD')
FROM EmpresaCfg2 WHERE Empresa = @Empresa
SELECT @TipoCambio = TipoCambio FROM Mon m WHERE m.Moneda = @Moneda
INSERT INTO
Inv(Empresa,  Mov,         FechaEmision,  Moneda,  TipoCambio,  Usuario, Referencia,                         Estatus, Directo, Almacen, AlmacenDestino, Sucursal)
VALUES(@Empresa, @GenerarMov, @FechaEmision, @Moneda, @TipoCambio, @Usuario, RTRIM(@Mov) + ' ' + RTRIM(@MovID), 'CONFIRMAR', 1, @Almacen, @AlmacenDestino, @Sucursal)
SELECT @IDInv = SCOPE_IDENTITY()
DECLARE crGenerarInvExtraccion CURSOR FOR
SELECT ce.Renglon, ce.RenglonSub, ce.RenglonID, ce.Observaciones, ISNULL(ce.PaqueteCantidad, 1), SUM(ISNULL(ce.CantidadA, 0)), ce.RenglonTipo, ce.Articulo, ISNULL(ce.SubCuenta, ''), ce.Unidad
FROM CompraExtraccion ce
WHERE ce.Estacion = @Estacion
AND ce.ID = @ID
AND ISNULL(ce.CantidadA, 0) > 0
GROUP BY ce.Renglon, ce.RenglonSub, ce.RenglonID, ce.Observaciones, ISNULL(ce.PaqueteCantidad, 1), ce.RenglonTipo, ce.Articulo, ISNULL(ce.SubCuenta, ''), ce.Unidad
OPEN crGenerarInvExtraccion
FETCH NEXT FROM crGenerarInvExtraccion INTO @Renglon, @RenglonSub, @RenglonID, @Observaciones, @PaqueteCantidad, @CantidadA, @RenglonTipo, @Articulo, @SubCuenta, @Unidad
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @CantidadInventario = NULL, @CantidadA2 = 0
SELECT @CantidadA2 = @PaqueteCantidad*@CantidadA
EXEC xpCantidadInventario @Articulo, @SubCuenta, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @CantidadA2, @CantidadInventario OUTPUT
INSERT INTO
InvD(ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Cantidad, Almacen, Articulo, SubCuenta, Unidad, Factor, CantidadInventario, DescripcionExtra)
VALUES(@IDInv, @Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @CantidadA2, @Almacen, @Articulo, @SubCuenta, @Unidad, 1, @CantidadInventario, @Observaciones)
INSERT INTO SerieLoteMov
(Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad)
SELECT @Empresa, 'INV', @IDInv, @RenglonID, @Articulo, @SubCuenta, SerieLote, CantidadA*@PaqueteCantidad
FROM CompraExtraccion ce
WHERE ce.Estacion = @Estacion
AND ce.ID = @ID
AND ce.Renglon = @Renglon AND ce.RenglonSub = @RenglonSub AND ce.RenglonID = @RenglonID
AND ISNULL(ce.CantidadA, 0) > 0
FETCH NEXT FROM crGenerarInvExtraccion INTO @Renglon, @RenglonSub, @RenglonID, @Observaciones, @PaqueteCantidad, @CantidadA, @RenglonTipo, @Articulo, @SubCuenta, @Unidad
END
CLOSE crGenerarInvExtraccion
DEALLOCATE crGenerarInvExtraccion
SELECT 'Movimiento Generado'
RETURN
END

