SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSReAgruparPOSLVenta
@Estacion		int,
@ID             varchar(36)

AS
BEGIN
DECLARE
@Renglon   float,
@RenglonID int,
@Ok        int
DECLARE  @Tabla table(
Renglon				float,
RenglonID			int,
RenglonTipo			varchar(1),
RenglonSub			int,
Cantidad			float,
Articulo			varchar(20),
SubCuenta			varchar(50),
Precio				float,
DescuentoLinea		money,
Impuesto1			float,
Impuesto2			float,
Impuesto3			float,
Unidad				varchar(50),
Factor				float,
CantidadInventario	float,
LDIServicio			varchar(20),
PrecioImpuestoInc	float,
Almacen				varchar(10))
DECLARE  @Tabla2 table(
Renglon				float,
RenglonID			int,
RenglonTipo			varchar(1),
RenglonSub			int,
Cantidad			float,
Articulo			varchar(20),
SubCuenta			varchar(50),
Precio				float,
DescuentoLinea		money,
Impuesto1			float,
Impuesto2			float,
Impuesto3			float,
Unidad				varchar(50),
Factor				float,
CantidadInventario	float,
LDIServicio			varchar(20),
PrecioImpuestoInc	float,
Almacen				varchar(10))
INSERT @Tabla(
RenglonTipo, RenglonSub, Cantidad, Articulo, SubCuenta, Precio, DescuentoLinea, Impuesto1, Impuesto2, Impuesto3, Unidad, Factor,
CantidadInventario, LDIServicio, Almacen)
SELECT
RenglonTipo, RenglonSub, Cantidad, Articulo, SubCuenta, NULL, DescuentoLinea, Impuesto1, Impuesto2, Impuesto3, Unidad, Factor,
CantidadInventario, LDIServicio, Almacen
FROM POSLVenta WITH (NOLOCK)
WHERE ID = @ID
AND Aplicado = 0
IF @@ERROR <>0
SET @Ok = 1
IF @Ok IS NULL
BEGIN
DELETE POSLVenta WHERE ID = @ID AND Aplicado = 0
INSERT @Tabla2(
Renglon, RenglonID, RenglonTipo, RenglonSub, Cantidad, Articulo, SubCuenta, Precio, Impuesto1, Impuesto2, Impuesto3, Unidad, Factor,
CantidadInventario, LDIServicio, PrecioImpuestoInc, Almacen)
SELECT
Renglon, RenglonID, RenglonTipo, RenglonSub, SUM(Cantidad), Articulo, SubCuenta, Precio, Impuesto1, Impuesto2, Impuesto3, Unidad, Factor,
SUM(CantidadInventario), LDIServicio, PrecioImpuestoInc, Almacen
FROM @Tabla
GROUP BY Renglon, RenglonID, RenglonTipo, RenglonSub, Articulo, SubCuenta, Precio, Impuesto1, Impuesto2, Impuesto3, Unidad, Factor,
LDIServicio, PrecioImpuestoInc, Almacen
SELECT @Renglon = MAX(Renglon),@RenglonID = MAX(RenglonID)
FROM POSLVenta WITH (NOLOCK)
WHERE ID = @ID
SELECT @Renglon = ISNULL(@Renglon,0.0)+ 2048.0, @RenglonID = ISNULL(@RenglonID,0)+1
UPDATE @Tabla2
SET @Renglon = Renglon = @Renglon + 2048.0, @RenglonID = RenglonID = @RenglonID + 1
FROM @Tabla
INSERT POSLVenta(
ID, Renglon, RenglonID, RenglonTipo, RenglonSub, Cantidad, Articulo, SubCuenta, Precio, Impuesto1, Impuesto2, Impuesto3, Unidad, Factor,
CantidadInventario, LDIServicio, PrecioImpuestoInc, Almacen)
SELECT
@ID, Renglon, RenglonID, RenglonTipo, RenglonSub, Cantidad, Articulo, SubCuenta, Precio, Impuesto1, Impuesto2, Impuesto3, Unidad, Factor,
CantidadInventario, LDIServicio, PrecioImpuestoInc, Almacen
FROM @Tabla2
IF @@ERROR <>0
SET @Ok = 1
SELECT @Renglon = 0.0,@RenglonID = 0
UPDATE POSLVenta WITH (ROWLOCK)
SET @Renglon = Renglon = @Renglon + 2048.0, @RenglonID = RenglonID = @RenglonID + 1
FROM POSLVenta 
WHERE ID = @ID
END
END

