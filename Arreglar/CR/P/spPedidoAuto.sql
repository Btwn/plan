SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPedidoAuto
@Empresa	char(5),
@Sucursal	int,
@Usuario	char(10),
@Almacen	char(10),
@Fecha		datetime

AS BEGIN
DECLARE
@CfgMultiUnidades		bit,
@CfgMultiUnidadesNivel	char(20),
@Conteo			int,
@ID				int,
@Moneda			char(10),
@TipoCambio			float,
@Mov			char(20),
@Cliente			char(10),
@ListaPrecios		varchar(50),
@ZonaImpuesto		varchar(50),
@Articulo			char(20),
@SubCuenta			varchar(50),
@Cantidad			float,
@CantidadInventario		float,
@Unidad			varchar(50),
@ArtTipo			varchar(20),
@Impuesto1			float,
@Impuesto2			float,
@Impuesto3			money,
@Renglon			float,
@RenglonID			int,
@RenglonTipo		char(1),
@Precio			money,
@EnviarA			int,
@Factor                     float
SELECT @Conteo = 0
SELECT @Moneda = ContMoneda
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @Mov = VentaPedidoAuto
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
SELECT @CfgMultiUnidades       = MultiUnidades,
@CfgMultiUnidadesNivel  = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD')
FROM EmpresaCfg2
WHERE Empresa = @Empresa
DECLARE crCte CURSOR FOR
SELECT Cliente, ISNULL(c.SucursalEmpresa, @Sucursal), m.Moneda, m.TipoCambio, c.ListaPreciosEsp, c.ZonaImpuesto, ISNULL(NULLIF(RTRIM(c.AlmacenDef), ''), @Almacen)
FROM Cte c
JOIN Mon m ON m.Moneda = ISNULL(c.DefMoneda, @Moneda)
WHERE c.PedidoDef = 1
OPEN crCte
FETCH NEXT FROM crCte INTO @Cliente, @Sucursal, @Moneda, @TipoCambio, @ListaPrecios, @ZonaImpuesto, @Almacen
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2 AND NULLIF(RTRIM(@Almacen), '') IS NOT NULL
BEGIN
IF NOT EXISTS(SELECT v.ID FROM Venta v, MovTipo mt WHERE v.Empresa = @Empresa AND v.Cliente = @Cliente AND v.FechaRequerida = @Fecha AND v.Estatus = 'PENDIENTE' AND mt.Modulo = 'VTAS' AND mt.Mov = v.Mov AND mt.Clave = 'VTAS.P')
BEGIN
IF EXISTS(SELECT * FROM CtePedidoDef WHERE Cliente = @Cliente)
BEGIN
INSERT Venta (Estatus,     Usuario,  Mov,  Empresa,  FechaEmision, FechaRequerida, Sucursal,  Cliente,  EnviarA,   Agente,   Almacen,  Moneda,  TipoCambio,  ListaPreciosEsp, Condicion,   Descuento,   DescuentoGlobal, Proyecto,   FormaEnvio)
SELECT 'CONFIRMAR', @Usuario, @Mov, @Empresa, @Fecha,       @Fecha,         @Sucursal, @Cliente, c.EnviarA, c.Agente, @Almacen, @Moneda, @TipoCambio, @ListaPrecios,   c.Condicion, c.Descuento, d.Porcentaje,    c.Proyecto, c.FormaEnvio
FROM Cte c
LEFT OUTER JOIN Descuento d ON d.Descuento = c.Descuento
WHERE c.Cliente = @Cliente
SELECT @ID = SCOPE_IDENTITY()
IF @ID IS NOT NULL
BEGIN
SELECT @Renglon = 0.0, @RenglonID = 0, @Conteo = @Conteo + 1
SELECT @EnviarA = EnviarA FROM Venta WHERE ID = @ID
DECLARE crPedidoDef CURSOR LOCAL FOR
SELECT d.Articulo, NULLIF(RTRIM(d.SubCuenta), ''), d.Cantidad, d.Unidad, a.Tipo, a.Impuesto1, a.Impuesto2, a.Impuesto3
FROM CtePedidoDef d, Art a
WHERE d.Cliente = @Cliente AND d.Articulo = a.Articulo
OPEN crPedidoDef
FETCH NEXT FROM crPedidoDef INTO @Articulo, @SubCuenta, @Cantidad, @Unidad, @ArtTipo, @Impuesto1, @Impuesto2, @Impuesto3
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto2 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto3 OUTPUT
EXEC spTipoImpuesto 'VTAS', @ID, @Mov, @Fecha, @Empresa, @Sucursal, @Cliente, @EnviarA, @Articulo = @Articulo, @EnSilencio = 1, @Impuesto1 = @Impuesto1 OUTPUT, @Impuesto2 = @Impuesto2 OUTPUT, @Impuesto3 = @Impuesto3 OUTPUT
EXEC spRenglonTipo @ArtTipo, @SubCuenta, @RenglonTipo OUTPUT
EXEC spPCGet @Sucursal, @Empresa, @Articulo, @SubCuenta, @Unidad, @Moneda, @TipoCambio, @ListaPrecios, @Precio OUTPUT
SELECT @Renglon = @Renglon + 2048.0, @RenglonID = @RenglonID + 1
EXEC xpCantidadInventario @Articulo, @SubCuenta, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
SELECT @Factor =  dbo.fnArtUnidadFactor(@Empresa, @Articulo,@Unidad)
INSERT VentaD (ID,  Renglon,  RenglonID,  RenglonTipo,  Articulo,  SubCuenta,  Cantidad,  CantidadInventario,  Unidad,  Precio,  Impuesto1,  Impuesto2,  Impuesto3,          Almacen,  FechaRequerida)
VALUES (@ID, @Renglon, @RenglonID, @RenglonTipo, @Articulo, @SubCuenta, @Cantidad, @CantidadInventario, @Unidad, @Precio, @Impuesto1, @Impuesto2, @Impuesto3*@Factor, @Almacen, @Fecha)
END
FETCH NEXT FROM crPedidoDef INTO @Articulo, @SubCuenta, @Cantidad, @Unidad, @ArtTipo, @Impuesto1, @Impuesto2, @Impuesto3
END
CLOSE crPedidoDef
DEALLOCATE crPedidoDef
END
END
END
END
FETCH NEXT FROM crCte INTO @Cliente, @Sucursal, @Moneda, @TipoCambio, @ListaPrecios, @ZonaImpuesto, @Almacen
END
CLOSE crCte
DEALLOCATE crCte
SELECT 'Se Generaron '+LTRIM(CONVERT(char, @Conteo))+' '+RTRIM(@Mov)+' (por Confirmar)'
RETURN
END

