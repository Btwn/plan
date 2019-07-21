SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speCommerceHerrInsertarWebArt
@Estacion	        int

AS BEGIN
DECLARE
@Articulo        varchar(20),
@Nombre          varchar(255),
@MarcaID         int,
@Unidad          varchar(50),
@Cantidad        float,
@DescripcionHTML varchar(8000),
@PermiteCompra   bit,
@OcultarPrecio   bit,
@Visible         bit ,
@Categoria1      varchar(50),
@Categoria2      varchar(50),
@Categoria3      varchar(50),
@Categoria4      varchar(50),
@IDArt           int,
@IDCat1          int,
@IDCat2          int,
@IDCat3          int,
@IDCat4          int,
@NombreCat1      varchar(50),
@NombreCat2      varchar(50),
@NombreCat3      varchar(50),
@NombreCat4      varchar(50),
@Orden           int,
@Ok              int
DECLARE crArt CURSOR local FOR
SELECT Nombre, ISNULL(Visible,1),  ISNULL(OcultarPrecio,1), ISNULL(PermiteCompra,0), MarcaID, Articulo, ISNULL(NULLIF(Unidad,''),'Pieza'),ISNULL(Cantidad,1.0), DescripcionHTML, NULLIF(Categoria1,'') , NULLIF(Categoria2,''), NULLIF(Categoria3,''), NULLIF(Categoria4,'')
FROM WebArtTemp
WHERE Estacion = @Estacion AND Articulo IS NOT NULL
OPEN crArt
FETCH NEXT FROM crArt INTO @Nombre, @Visible, @OcultarPrecio, @PermiteCompra, @MarcaID, @Articulo, @Unidad, @Cantidad, @DescripcionHTML, @Categoria1 , @Categoria2, @Categoria3, @Categoria4
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @Orden = MAX(Orden) FROM WebArt
SELECT @Orden = ISNULL(@Orden,0)+1
INSERT WebArt (Orden,  Nombre, EsDigital, Visible, Destacado, DestacadoProv, OpcionesReq, EnvioGratis, FechaAlta,  MarcaID,  PermiteCompra,  OcultarPrecio, DesHabilitarGoogle, Articulo,  Unidad,  Cantidad,      DescripcionHTML)
SELECT         @Orden, @Nombre, 0,        @Visible, 0,         0,             0,           0,           GETDATE(), @MarcaID, @PermiteCompra, @OcultarPrecio,             1,     @Articulo, @Unidad, @Cantidad,    @DescripcionHTML
SELECT @IDArt = SCOPE_IDENTITY()
SELECT @IDCat1 = ID, @NombreCat1 = Nombre FROM WebCatArt WHERE Nombre = @Categoria1
SELECT @IDCat2 = ID, @NombreCat2 = Nombre FROM WebCatArt WHERE Nombre = @Categoria2
SELECT @IDCat3 = ID, @NombreCat3 = Nombre FROM WebCatArt WHERE Nombre = @Categoria3
SELECT @IDCat4 = ID, @NombreCat4 = Nombre FROM WebCatArt WHERE Nombre = @Categoria4
IF @IDArt IS NOT NULL AND @IDCat1 IS NOT NULL
INSERT WebCatArt_Art(IDWebArt,IDWebCatArt, Nombre)
SELECT               @IDArt,  @IDCat1, @NombreCat1
IF @@ERROR <> 0 SET @Ok = 1
IF @IDArt IS NOT NULL AND @IDCat2 IS NOT NULL
INSERT WebCatArt_Art(IDWebArt,IDWebCatArt, Nombre)
SELECT               @IDArt,  @IDCat2, @NombreCat2
IF @@ERROR <> 0 SET @Ok = 1
IF @IDArt IS NOT NULL AND @IDCat3 IS NOT NULL
INSERT WebCatArt_Art(IDWebArt,IDWebCatArt, Nombre)
SELECT               @IDArt,  @IDCat3,    @NombreCat3
IF @@ERROR <> 0 SET @Ok = 1
IF @IDArt IS NOT NULL AND @IDCat4 IS NOT NULL
INSERT WebCatArt_Art(IDWebArt,IDWebCatArt, Nombre)
SELECT               @IDArt,  @IDCat4 , @NombreCat4
IF @@ERROR <> 0 SET @Ok = 1
EXEC spWebArtCategoias @IDArt
FETCH NEXT FROM crArt INTO @Nombre, @Visible, @OcultarPrecio, @PermiteCompra, @MarcaID, @Articulo, @Unidad, @Cantidad, @DescripcionHTML, @Categoria1 , @Categoria2, @Categoria3, @Categoria4
END
CLOSE crArt
DEALLOCATE crArt
IF @Ok IS NULL
DELETE WebArtTemp WHERE Estacion = @Estacion
SELECT 'Artículos Importados Exitosamente'
RETURN
END

