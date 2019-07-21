SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSArtMatrizOpciones
@ID                varchar(50),
@Articulo          varchar(20),
@Estacion          int,
@Codigo            varchar(50)

AS
BEGIN
DECLARE
@Clave					varchar(50) ,
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
@ArtGrupo				varchar(50),
@ArtCategoria			varchar(50),
@ArtFamilia				varchar(50),
@ArtLinea				varchar(50),
@ArtFabricante			varchar(50),
@Agente					varchar(10),
@POSAgenteDetalle		bit,
@POSAgenteDetMaestro	varchar(15),
@ArtPOSAgenteDetalle	varchar (255),
@ArtPOSAgenteDetalleInfo varchar (255),
@Host					varchar(20),
@Caja					varchar(10)
DECLARE @Tabla table (
Articulo   varchar(20),
SubCuenta  varchar(50),
Cantidad   float)
SELECT @Empresa = p.Empresa,@Cliente = p.Cliente,@Sucursal = p.Sucursal, @EnviarA = p.EnviarA, @Mov=p.Mov, @ZonaImpuestoCliente = c.ZonaImpuesto,
@Usuario = p.Usuario, @FechaEmision = p.FechaEmision, @Almacen = p.Almacen, @Host = p.Host, @Caja = p.Caja
FROM POSL p JOIN Cte c ON p.Cliente = c.Cliente
WHERE p.ID = @ID
INSERT @Tabla( Articulo, SubCuenta, Cantidad)
SELECT @Articulo,dbo.fnPOSMatrizOpciones(Clave,1),CONVERT(float,dbo.fnPOSMatrizOpciones(Clave,2),1)
FROM ListaSt
WHERE Estacion = @Estacion
SELECT @UnidadCodigo = Unidad
FROM CB
WHERE Codigo = @Codigo
SELECT @ArtTipo = Tipo,
@Unidad = ISNULL(NULLIF(@UnidadCodigo,''),Unidad),
@Impuesto1 = Impuesto1,
@Impuesto2 = Impuesto2,
@Impuesto3 = Impuesto3,
@ArtGrupo =	Grupo,
@ArtCategoria = Categoria,
@ArtFamilia = Familia,
@ArtLinea = Linea,
@ArtFabricante = Fabricante
FROM Art
WHERE Articulo = @Articulo
SELECT @POSAgenteDetalle = ISNULL(POSAgenteDetalle,0), @POSAgenteDetMaestro = NULLIF(POSAgenteDetMaestro,'')
FROM POSCfg
WHERE Empresa = @Empresa
IF @POSAgenteDetalle = 1
SET @ArtPOSAgenteDetalle = @POSAgenteDetMaestro
SELECT @ZonaImpuestoUsuario = u.DefZonaImpuesto
FROM Usuario u
WHERE u.Usuario = @Usuario
SELECT @ZonaImpuesto = ISNULL(NULLIF(@ZonaImpuestoCliente,''),@ZonaImpuestoUsuario)
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto2 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto3 OUTPUT
EXEC spTipoImpuesto 'POS', 0, @Mov, @FechaEmision, @Empresa, @Sucursal, @Cliente, @EnviarA, @Articulo = @Articulo, @EnSilencio = 1,
@Impuesto1 = @Impuesto1 OUTPUT, @Impuesto2 = @Impuesto2 OUTPUT, @Impuesto3 = @Impuesto3 OUTPUT
SELECT @Agente = NULL, @ArtPOSAgenteDetalleInfo = NULL
IF @POSAgenteDetalle = 1 AND @ArtPOSAgenteDetalle IS NOT NULL
BEGIN
IF @ArtPOSAgenteDetalle = 'Categoría'
BEGIN
IF EXISTS (SELECT * FROM ArtCat WHERE Categoria = @ArtCategoria AND POSAgenteDetalle = 1)
SELECT @ArtPOSAgenteDetalle = 'Categoria', @ArtPOSAgenteDetalleInfo = @ArtCategoria
ELSE
SELECT @ArtPOSAgenteDetalle = NULL, @ArtCategoria = NULL, @ArtPOSAgenteDetalleInfo = NULL
END
IF @ArtPOSAgenteDetalle = 'Grupo'
BEGIN
IF EXISTS (SELECT * FROM ArtGrupo WHERE Grupo = @ArtGrupo AND POSAgenteDetalle = 1)
SELECT @ArtPOSAgenteDetalle = 'Grupo', @ArtPOSAgenteDetalleInfo = @ArtGrupo
ELSE
SELECT @ArtPOSAgenteDetalle = NULL, @ArtGrupo = NULL, @ArtPOSAgenteDetalleInfo = NULL
END
IF @ArtPOSAgenteDetalle = 'Familia'
BEGIN
IF EXISTS (SELECT * FROM ArtFam WHERE Familia = @ArtFamilia AND POSAgenteDetalle = 1)
SELECT @ArtPOSAgenteDetalle = 'Familia', @ArtPOSAgenteDetalleInfo = @ArtFamilia
ELSE
SELECT @ArtPOSAgenteDetalle = NULL, @ArtFamilia = NULL, @ArtPOSAgenteDetalleInfo = NULL
END
IF @ArtPOSAgenteDetalle = 'Línea'
BEGIN
IF EXISTS (SELECT * FROM ArtLinea WHERE Linea = @ArtLinea AND POSAgenteDetalle = 1)
SELECT @ArtPOSAgenteDetalle = 'Linea', @ArtPOSAgenteDetalleInfo =@ArtLinea
ELSE
SELECT @ArtPOSAgenteDetalle = NULL, @ArtLinea = NULL, @ArtPOSAgenteDetalleInfo = NULL
END
IF @ArtPOSAgenteDetalle = 'Fabricante'
BEGIN
IF EXISTS (SELECT * FROM Fabricante WHERE Fabricante = @ArtFabricante AND POSAgenteDetalle = 1)
SELECT @ArtPOSAgenteDetalle = 'Fabricante', @ArtPOSAgenteDetalleInfo = @ArtFabricante
ELSE
SELECT @ArtPOSAgenteDetalle = NULL, @ArtFabricante = NULL, @ArtPOSAgenteDetalleInfo = NULL
END
END
IF @ArtPOSAgenteDetalleInfo IS NOT NULL
IF EXISTS (SELECT TOP 1 * FROM POSLVenta WITH (NOLOCK) WHERE ID = @ID AND ArtObservaciones = @ArtPOSAgenteDetalleInfo)
SELECT TOP 1 @Agente = Agente FROM POSLVenta  WITH (NOLOCK) WHERE ID = @ID AND ArtObservaciones = @ArtPOSAgenteDetalleInfo
IF @ArtPOSAgenteDetalleInfo IS NOT NULL AND NULLIF(@Agente,'') IS NULL
BEGIN
INSERT POSLAccion (Host, Caja, Accion, Referencia) VALUES (@Host, @Caja, 'INSERTA AGENTE', NULL)
END
DECLARE crLista CURSOR local FOR
SELECT  SubCuenta, Cantidad
FROM @Tabla
OPEN crLista
FETCH NEXT FROM crLista INTO @SubCuenta, @Cantidad
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Renglon = MAX(Renglon),@RenglonID = MAX(RenglonID) FROM POSLVenta WHERE ID = @ID
SELECT @Renglon = ISNULL(@Renglon,0.0)+2048.0,@RenglonID = ISNULL(@RenglonID,0)+1
SELECT @RenglonTipo = dbo.fnRenglonTipo(@ArtTipo)
IF EXISTS(SELECT * FROM POSLVenta plv WHERE plv.ID = @ID AND plv.Articulo = @Articulo AND ISNULL(plv.SubCuenta,'') = ISNULL(@SubCuenta,'')
AND plv.RenglonTipo = @RenglonTipo AND plv.Unidad = @Unidad AND RenglonTipo <> 'C' AND ISNULL(Aplicado,0)=0)
UPDATE POSLVenta SET
Cantidad = Cantidad + @Cantidad,
CantidadInventario = Cantidad + @Cantidad,
Agente = @Agente
WHERE ID = @ID AND Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'') AND RenglonTipo = @RenglonTipo
AND RenglonTipo <> 'C' AND ISNULL(Aplicado,0)=0
ELSE
INSERT POSLVenta (
ID, Renglon, RenglonID, RenglonTipo, Cantidad, Articulo, SubCuenta, Unidad, Factor, CantidadInventario, Impuesto1, Impuesto2, Impuesto3,
Almacen, ArtObservaciones, Agente)
SELECT
@ID, @Renglon, @RenglonID, @RenglonTipo, @Cantidad, @Articulo, @SubCuenta,@Unidad, 1, @Cantidad, @Impuesto1, @Impuesto2, @Impuesto3,
@Almacen, @ArtPOSAgenteDetalleInfo, @Agente
FETCH NEXT FROM crLista INTO @SubCuenta, @Cantidad
END
CLOSE crLista
DEALLOCATE crLista
EXEC spPOSArtPrecioRecalcular @ID, @Estacion
END

