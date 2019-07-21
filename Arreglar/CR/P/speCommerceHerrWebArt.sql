SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speCommerceHerrWebArt
@Estacion	        int,
@Empresa            varchar(5),
@Sucursal           int

AS BEGIN
DECLARE @Tabla table(
Articulo     varchar(20),
Comentario   varchar(2500))
INSERT @Tabla (Articulo,Comentario)
SELECT         Cuenta, SUBSTRING(CONVERT(varchar(2500),Comentario),1,2500)
FROM AnexoCta
WHERE Cuenta  IN (SELECT Clave FROM ListaSt WHERE Estacion = @Estacion)
AND Rama = 'INV'
DELETE WebArtTemp WHERE Estacion = @Estacion
INSERT WebArtTemp(Estacion,  Articulo,    Nombre,                     MarcaID, Unidad, Cantidad,             OcultarPrecio, PermiteCompra, Visible, DescripcionHTML)
SELECT         @Estacion, a.Articulo, ISNULL(a.Descripcion1,'')+' '+ a.Articulo, m.ID,   'Pieza', 1.0,       1,             0,              1,     dbo.fneWebDescripcionHTML(SUBSTRING(ISNULL((SELECT TOP 1 Comentario FROM @Tabla WHERE Articulo = a.Articulo ),a.Descripcion1),1,2559))
FROM  Art a LEFT JOIN WebArtMarca m ON m.Nombre = a.Fabricante
WHERE Articulo IN (SELECT Clave FROM ListaSt WHERE Estacion = @Estacion)
RETURN
END

