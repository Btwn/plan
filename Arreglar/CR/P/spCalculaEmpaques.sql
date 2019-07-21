SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCalculaEmpaques
@ID			int,
@Modulo		char(5),
@Sucursal	int

AS
BEGIN
DECLARE @RenglonID		int,
@RenglonAux		float,
@Articulo		varchar(20),
@Almacen		varchar(10),
@Empaque		varchar(20),
@Corrugado		varchar(20),
@Pzascorrugado	float,
@PzasEmpaque	int,
@Cantidad		float,
@CantidadAux	float,
@CantidadE		float,
@CantidadEAux	float,
@CantidadC		float,
@Unidad			varchar(50),
@FechaRequerida	datetime,
@Agente			varchar(10),
@Moneda			varchar(10),
@TipoCambio		float,
@Cliente		varchar(10),
@Mensaje		varchar(100),
@Estatus		char(15)
SELECT @Estatus = Estatus FROM Venta v WHERE ID = @ID
IF @Estatus <> 'SINAFECTAR'
RETURN
IF @Modulo = 'VTAS' AND @Estatus = 'SINAFECTAR' 
BEGIN/*
IF NOT EXISTS (SELECT ID FROM VentaD WHERE ID = @ID)
BEGIN
SELECT @Mensaje = 'No existen Articulos, no se pueden calcular Empaques'
RAISERROR (@Mensaje, 16, -1)
RETURN
END
*/
DELETE FROM Ventad WHERE DescripcionExtra = 'Empaques' AND Precio = 0 AND ID = @ID
SELECT @RenglonAux = 0
DECLARE crVentaD CURSOR FOR
SELECT v.RenglonID,d.Articulo,d.Cantidad,v.Almacen,v.FechaRequerida,v.Agente,v.Moneda,v.TipoCambio,v.Cliente
FROM Venta v
JOIN VentaD d ON v.ID = d.ID
WHERE v.ID = @ID
ORDER BY d.Renglon
OPEN crVentaD
FETCH NEXT FROM crVentaD INTO @RenglonID,@Articulo,@Cantidad,@Almacen,@FechaRequerida,@Agente,@Moneda,@TipoCambio,@Cliente
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @RenglonAux = MAX(Renglon) FROM VentaD WHERE ID = @ID
SELECT @Unidad = Unidad FROM Art WHERE Articulo = @Articulo
IF EXISTS(SELECT Cliente, Articulo FROM CteArtEmpaque WHERE Cliente = @Cliente AND Articulo = @Articulo)
BEGIN
SELECT @Empaque = ISNULL(Empaque,''), @Corrugado = Corrugado, @PzasCorrugado = PzasCorrugado, @PzasEmpaque = CASE WHEN ISNULL(Empaque,'') = '' THEN 0 ELSE 1 END
FROM CteArtEmpaque
WHERE Articulo = @Articulo AND Cliente = @Cliente
IF @PzasEmpaque <> 0
BEGIN
IF EXISTS(SELECT Articulo FROM VentaD WHERE Articulo = @Empaque AND ID = @ID)
BEGIN
SELECT @CantidadE = Cantidad FROM VentaD WHERE Articulo = @Empaque AND ID = @ID
SELECT @CantidadEAux = @CantidadE + @Cantidad
UPDATE VentaD SET Cantidad = @CantidadEAux,CantidadPendiente = @CantidadEAux,CantidadInventario = @CantidadEAux
WHERE Articulo = @Empaque AND ID = @ID
END
ELSE
BEGIN
SELECT @RenglonAux = @RenglonAux + 1024
INSERT INTO VentaD
(ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Cantidad,  Almacen, Articulo, Precio, PrecioSugerido, Unidad, Factor, CantidadInventario, FechaRequerida, Agente, Sucursal, PrecioMoneda, PrecioTipoCambio, DescripcionExtra)
VALUES (@ID, @RenglonAux, 0, @RenglonID, 'N',            @Cantidad, @Almacen, @Empaque, 0,       0,            @Unidad, 1 ,    @Cantidad,          @FechaRequerida, @Agente, @Sucursal, @Moneda, @TipoCambio, 'Empaques')
END
END
IF EXISTS(SELECT Articulo FROM VentaD WHERE Articulo = @Corrugado AND ID = @ID)
BEGIN
SELECT @CantidadAux = CEILING(ISNULL(@Cantidad,0)/ISNULL(@Pzascorrugado,0))
SELECT @CantidadC = Cantidad FROM VentaD WHERE Articulo = @Corrugado AND ID = @ID
SELECT @CantidadAux = @CantidadC + @CantidadAux
UPDATE VentaD SET Cantidad = @CantidadAux,CantidadPendiente = @CantidadAux,CantidadInventario = @CantidadAux
WHERE Articulo = @Corrugado AND ID = @ID
END
ELSE
BEGIN
SELECT @RenglonAux = @RenglonAux + 1024
SELECT @CantidadAux = CEILING(ISNULL(@Cantidad,0)/ISNULL(@Pzascorrugado,0))
INSERT INTO VentaD
(ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Cantidad,  Almacen, Articulo, Precio, PrecioSugerido, Unidad, Factor, CantidadInventario, FechaRequerida, Agente, Sucursal, PrecioMoneda, PrecioTipoCambio, DescripcionExtra)
VALUES (@ID, @RenglonAux, 0, @RenglonID, 'N',        @CantidadAux, @Almacen, @Corrugado,0,       0,            @Unidad, 1,     @CantidadAux,      @FechaRequerida,  @Agente, @Sucursal, @Moneda, @TipoCambio, 'Empaques')
END
END
FETCH NEXT FROM crVentaD INTO @RenglonID,@Articulo,@Cantidad,@Almacen,@FechaRequerida,@Agente,@Moneda,@TipoCambio,@Cliente
END
CLOSE crVentaD
DEALLOCATE crVentaD
END
RETURN
END

