SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSArtMatrizOpcionesCancelar
@ID                varchar(50),
@Articulo          varchar(20),
@Estacion          int,
@Codigo            varchar(50)

AS
BEGIN
DECLARE
@Clave					varchar(50),
@Renglon				float,
@RenglonID				int,
@RenglonTipo			varchar(1),
@Cantidad				float,
@SubCuenta				varchar(50),
@Unidad					varchar(50),
@UnidadCodigo			varchar(50),
@ArtTipo				varchar(20),
@Empresa				varchar(5),
@Cliente				varchar(10),
@Sucursal				int,
@EnviarA				int,
@Mov					varchar(20),
@ZonaImpuestoCliente	varchar(50),
@ZonaImpuestoUsuario	varchar(50),
@ZonaImpuesto			varchar(50),
@Usuario				varchar(10),
@Impuesto1				float,
@Impuesto2				float,
@Impuesto3				float,
@FechaEmision			datetime,
@Almacen				varchar(20),
@Caja					varchar(10),
@Precio					float
DECLARE @Tabla table (
Articulo   varchar(20),
SubCuenta  varchar(50),
Cantidad   float,
Precio     float)
INSERT @Tabla( Articulo, SubCuenta, Cantidad)
SELECT @Articulo,dbo.fnPOSMatrizOpciones(Clave,1),CONVERT(float,dbo.fnPOSMatrizOpciones(Clave,2))
FROM ListaSt
WHERE Estacion = @Estacion
UPDATE @Tabla SET Precio = v.Precio
FROM @Tabla a JOIN POSLVenta v ON a.Articulo = v.Articulo AND ISNULL(a.Subcuenta,'') = ISNULL(v.Subcuenta,'')
WHERE v.ID = @ID
SELECT @UnidadCodigo = Unidad
FROM CB
WHERE Codigo = @Codigo
SELECT @ArtTipo = Tipo, @Unidad = ISNULL(NULLIF(@UnidadCodigo,''),Unidad)
FROM Art
WHERE Articulo = @Articulo
SELECT @Empresa = p.Empresa,@Cliente = p.Cliente,@Sucursal = p.Sucursal, @EnviarA = p.EnviarA, @Mov=p.Mov, @ZonaImpuestoCliente = c.ZonaImpuesto,
@Usuario = p.Usuario, @FechaEmision = p.FechaEmision, @Almacen = p.Almacen, @Caja = p.Caja
FROM POSL p JOIN Cte c ON p.Cliente = c.Cliente
WHERE p.ID = @ID
SELECT @ZonaImpuestoUsuario = u.DefZonaImpuesto
FROM Usuario u
WHERE u.Usuario = @Usuario
SELECT @ZonaImpuesto = ISNULL(NULLIF(@ZonaImpuestoCliente,''),@ZonaImpuestoUsuario)
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto2 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto3 OUTPUT
EXEC spTipoImpuesto 'POS', 0, @Mov, @FechaEmision, @Empresa, @Sucursal, @Cliente, @EnviarA, @Articulo = @Articulo, @EnSilencio = 1,
@Impuesto1 = @Impuesto1 OUTPUT, @Impuesto2 = @Impuesto2 OUTPUT, @Impuesto3 = @Impuesto3 OUTPUT
DECLARE crLista CURSOR local FOR
SELECT  SubCuenta, Cantidad, Precio
FROM @Tabla
OPEN crLista
FETCH NEXT FROM crLista INTO @SubCuenta, @Cantidad, @Precio
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Renglon = MAX(Renglon),@RenglonID = MAX(RenglonID)
FROM POSLVenta
WHERE ID = @ID
SELECT @Renglon = ISNULL(@Renglon,0.0)+2048.0,@RenglonID = ISNULL(@RenglonID,0)+1
SELECT @RenglonTipo = dbo.fnRenglonTipo(@ArtTipo)
IF EXISTS (SELECT * FROM POSLSerieLote WHERE ID = @ID AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'') AND Articulo = @Articulo)
DELETE  POSLSerieLote WHERE ID = @ID AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'') AND Articulo = @Articulo
IF EXISTS(SELECT * FROM POSLVenta plv WHERE plv.ID = @ID AND plv.Articulo = @Articulo AND ISNULL(plv.SubCuenta,'') = ISNULL(@SubCuenta,'')
AND plv.RenglonTipo = @RenglonTipo AND plv.Unidad = @Unidad  AND RenglonTipo <> 'C' AND ISNULL(Aplicado,0)=0)
UPDATE POSLVenta SET
Cantidad = Cantidad - @Cantidad,
CantidadInventario = Cantidad - @Cantidad
WHERE ID = @ID AND Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'') AND RenglonTipo = @RenglonTipo
AND RenglonTipo <> 'C' AND ISNULL(Aplicado,0)=0
ELSE
INSERT POSLVenta (
ID, Renglon, RenglonID, RenglonTipo, Cantidad, Articulo, SubCuenta, Unidad, Factor, CantidadInventario, Impuesto1, Impuesto2, Impuesto3, Almacen)
SELECT
@ID, @Renglon, @RenglonID, @RenglonTipo, (@Cantidad*-1), @Articulo, @SubCuenta,@Unidad, 1, @Cantidad, @Impuesto1, @Impuesto2, @Impuesto3, @Almacen
INSERT POSCancelacionArticulos(
ID, Empresa, Sucursal, Cajero, Caja, Articulo, Precio, Fecha, Cantidad)
SELECT
@ID, @Empresa, @Sucursal, @Usuario, @Caja, @Articulo, @Precio, GETDATE(),(@Cantidad*-1)
FETCH NEXT FROM crLista INTO @SubCuenta, @Cantidad, @Precio
END
CLOSE crLista
DEALLOCATE crLista
IF EXISTS(SELECT * FROM POSLVenta WHERE ID = @ID AND Cantidad = 0)
DELETE POSLVenta WHERE ID = @ID AND Cantidad = 0
EXEC spPOSArtPrecioRecalcular @ID, @Estacion
END

