SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCompraImportacionEstadoCuenta
@Empresa			char(5),
@Almacen			char(10),
@ProveedorD			char(10),
@ProveedorA			char(10),
@ArticuloD			char(20),
@ArticuloA			char(20),
@ArtCat				char(50),
@ArtGrupo			char(50),
@ArtFam				char(50),
@Fabricante			char(50)

AS
BEGIN
DECLARE
@Mov				char(20),
@MovID			char(20),
@Articulo			char(20),
@SubCuenta		char(50),
@SerieLote		char(20),
@IDInv			int,
@MovInv			char(20),
@MovIDInv			char(20)
DECLARE @CompraImportacionEstadoCuenta TABLE(
Modulo			char(10),
Mov				char(20),
MovID				char(20),
Aplica			char(20),
AplicaID			char(20),
FechaEmision		datetime,
Proveedor			char(10),
NombreProveedor	char(100),
GuiaEntrega		char(20),
FechaGuia			datetime,
PuertoDestino		char(50),
FechaDestino		datetime,
Articulo			char(20),
SubCuenta			char(50),
Descripcion		char(100),
ReferenciaD		char(50),
SerieLote			char(50),
Propiedades		char(50),
Cantidad			float,
Existencia		float,
Paquete			int,
PaqueteCantidad	money,
Cargo				float,
Abono				float)
IF RTRIM(@ProveedorD) IN (NULL, '') SELECT @ProveedorD = Min(Proveedor) FROM Prov WHERE Tipo <> 'Estructura'
IF RTRIM(@ProveedorA) IN (NULL, '') SELECT @ProveedorA = Max(Proveedor) FROM Prov WHERE Tipo <> 'Estructura'
IF RTRIM(@ArticuloD) IN (NULL, '') SELECT @ArticuloD = Min(Articulo) FROM Art WHERE Tipo <> 'Estructura'
IF RTRIM(@ArticuloA) IN (NULL, '') SELECT @ArticuloA = Max(Articulo) FROM Art WHERE Tipo <> 'Estructura'
IF RTRIM(@ArtCat) IN (NULL, 'NULL', '', '(TODOS)', 'TODOS') SELECT @ArtCat = NULL
IF RTRIM(@ArtGrupo) IN (NULL, 'NULL', '', '(TODOS)', 'TODOS') SELECT @ArtGrupo = NULL
IF RTRIM(@ArtFam) IN (NULL, 'NULL', '', '(TODOS)', 'TODOS') SELECT @ArtFam = NULL
IF RTRIM(@Fabricante) IN (NULL, 'NULL', '', '(TODOS)', 'TODOS') SELECT @Fabricante = NULL
INSERT INTO @CompraImportacionEstadoCuenta
(Modulo, Mov, MovID, Aplica, AplicaID, FechaEmision, Proveedor, NombreProveedor, GuiaEntrega, FechaGuia, PuertoDestino, FechaDestino,
Articulo, SubCuenta, Descripcion, ReferenciaD, SerieLote, Propiedades, Cantidad, Existencia, Paquete, PaqueteCantidad, Cargo)
SELECT 'COMS', v.Mov, v.MovID, v.Mov, v.MovID, v.FechaEmision, v.Proveedor, p.Nombre, ci.GuiaEntrega, ci.FechaGuia, ci.PuertoDestino, ci.FechaDestino,
v.Articulo, v.SubCuenta, a.Descripcion1, v.ImportacionReferencia, v.SerieLote, v.Propiedades, v.Cantidad, v.Existencia, v.Paquete, v.PaqueteCantidad, v.Cantidad
FROM VerCompraImportacionSerieLote v
LEFT OUTER JOIN CompraImportacion ci ON v.ID = ci.ID
JOIN Prov p ON v.Proveedor = p.Proveedor
JOIN Art a ON v.Articulo = a.Articulo
WHERE v.Empresa = @Empresa
AND v.Almacen = @Almacen
AND v.Proveedor BETWEEN @ProveedorD AND @ProveedorA
AND v.Articulo BETWEEN @ArticuloD AND @ArticuloA
AND ISNULL(a.Categoria, '')  = ISNULL(@ArtCat, ISNULL(a.Categoria, ''))
AND ISNULL(a.Grupo, '')      = ISNULL(@ArtGrupo, ISNULL(a.Grupo, ''))
AND ISNULL(a.Familia, '')    = ISNULL(@ArtFam, ISNULL(a.Familia, ''))
AND ISNULL(a.Fabricante, '') = ISNULL(@Fabricante, ISNULL(a.Fabricante, ''))
DECLARE crCompraImportacionEstadoCuenta CURSOR LOCAL FOR
SELECT DISTINCT c.Mov, c.MovID, c.Articulo, ISNULL(c.SubCuenta, ''), c.SerieLote
FROM @CompraImportacionEstadoCuenta c
OPEN crCompraImportacionEstadoCuenta
FETCH NEXT FROM crCompraImportacionEstadoCuenta INTO @Mov, @MovID, @Articulo, @SubCuenta, @SerieLote
WHILE @@FETCH_STATUS = 0
BEGIN
INSERT INTO @CompraImportacionEstadoCuenta
(Modulo, Mov, MovID, Aplica, AplicaID, FechaEmision, Articulo, SubCuenta, Abono)
SELECT 'INV', @Mov, @MovID, i.Mov, i.MovID, i.FechaEmision, id.Articulo, id.SubCuenta, slm.Cantidad
FROM Inv i
JOIN InvD id ON i.ID = id.ID
JOIN MovTipo mt ON i.Mov = mt.Mov AND mt.Modulo = 'INV' AND mt.Clave = 'INV.SI'
JOIN SerieLoteMov slm ON i.Empresa = slm.Empresa AND slm.Modulo = 'INV' AND i.ID = slm.ID AND id.RenglonID = slm.RenglonID AND id.Articulo = slm.Articulo AND ISNULL(id.SubCuenta,'') = slm.SubCuenta
JOIN SerieLoteD sld ON i.Empresa = sld.Empresa AND id.Articulo = sld.Articulo AND ISNULL(id.SubCuenta, '') = isnull(sld.SubCuenta, '') AND i.ID = sld.ID AND mt.Modulo = sld.Modulo AND slm.SerieLote = sld.SerieLote
WHERE i.Estatus = 'CONCLUIDO'
AND i.Empresa = @Empresa
AND i.Almacen = @Almacen
AND sld.Empresa = @Empresa AND sld.Articulo = @Articulo AND ISNULL(sld.SubCuenta, '') = @SubCuenta AND sld.SerieLote = @SerieLote AND sld.Modulo = 'INV'
FETCH NEXT FROM crCompraImportacionEstadoCuenta INTO @Mov, @MovID, @Articulo, @SubCuenta, @SerieLote
END
CLOSE crCompraImportacionEstadoCuenta
DEALLOCATE crCompraImportacionEstadoCuenta
SELECT * FROM @CompraImportacionEstadoCuenta ciec
ORDER BY ciec.Mov, ciec.MovID, ciec.Articulo, ciec.SubCuenta, ciec.SerieLote, ciec.Aplica, ciec.AplicaID
RETURN
END

