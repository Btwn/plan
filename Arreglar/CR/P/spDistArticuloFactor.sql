SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDistArticuloFactor (
@Empresa                varchar(5),
@AlmacenOrigen          varchar(10),
@Articulo               varchar(20)
)

AS
BEGIN
DECLARE @Subcuenta      varchar(20)
DECLARE @Descripcion    varchar(1000)
DECLARE @Disponible     float
DECLARE @SC1            varchar(20)
DECLARE @SC2            varchar(20)
DECLARE @Opcion1        varchar(1)
DECLARE @Opcion2        varchar(1)
DECLARE @i              int
DECLARE @j              int
DECLARE @iMax           int
DECLARE @jMax           int
DECLARE @Opciones       bit
DECLARE @TablaOpcion table(
ID                    int IDENTITY(1,1),
Opcion                char(1)       NULL
)
DECLARE @TablaOpcionD table(
ID                    int IDENTITY(1,1),
Opcion                char(1)       NULL,
Numero                int           NULL,
Nombre                varchar(100)  NULL,
InformacionAdicional  varchar(100)  NULL,
Imagen                varchar(255)  NULL
)
DECLARE @TablaSubcuenta table(
ID                    int IDENTITY(1,1),
Empresa               varchar(5),
Almacen               varchar(10),
Articulo              varchar(20)   NULL,
Subcuenta             varchar(20)   NULL,
Disponible            float         NULL
)
DECLARE @TablaRet table(
ID                    int IDENTITY(1,1),
Empresa               varchar(5)  NOT NULL,
Articulo              varchar(20) NOT NULL,
SubCuenta             varchar(50) NOT NULL,
Descripcion           varchar(1000) NULL,
Unidad                varchar(50) NULL DEFAULT 'pza',
Factor                float       NULL DEFAULT 1
)
SET @Empresa       = UPPER(LTRIM(RTRIM(@Empresa)))
SET @AlmacenOrigen = UPPER(LTRIM(RTRIM(@AlmacenOrigen)))
SET @Articulo      = UPPER(LTRIM(RTRIM(@Articulo)))
SET @Subcuenta     = ''
SET @SC1           = ''
SET @SC2           = ''
SET @Opcion1       = ''
SET @Opcion2       = ''
SET @Disponible    = 0
SET @i             = 0
SET @j             = 0
SET @iMax          = 0
SET @jMax          = 0
SELECT @Descripcion = UPPER(LTRIM(RTRIM(ISNULL(Descripcion1,'')))) FROM Art WHERE Articulo = @Articulo
INSERT INTO @TablaOpcionD EXEC spVerOpcionD @Articulo
IF EXISTS(SELECT TOP 1 ID FROM @TablaOpcionD) SET @Opciones = 1 ELSE SET @Opciones = 0
IF @Opciones = 1
BEGIN
INSERT INTO @TablaOpcion (Opcion) SELECT Opcion FROM @TablaOpcionD GROUP BY Opcion
SELECT @Opcion1 = Opcion FROM @TablaOpcion WHERE ID = 1
SELECT @Opcion2 = Opcion FROM @TablaOpcion WHERE ID = 2
SET @i = 1
SELECT @iMax = MAX(ID) FROM @TablaOpcionD WHERE Opcion = @Opcion1
SET @j = @iMax  + 1
SELECT @jMax = MAX(ID) FROM @TablaOpcionD WHERE Opcion = @Opcion2
/* Si @jMax es nula solo tiene una opcion */
IF ISNULL(@jMax,0) = 0
BEGIN
WHILE @i <= @iMax
BEGIN
SELECT @SC1 = Opcion + CAST(Numero AS VARCHAR(10)) FROM @TablaOpcionD WHERE ID = (@i) + ' '
SET @Subcuenta = @SC1
INSERT INTO @TablaSubcuenta (Empresa,Almacen,Articulo,Subcuenta,Disponible) VALUES(@Empresa,@AlmacenOrigen,@Articulo,@Subcuenta,@Disponible)
SET @SC1 = ''
SET @i = @i + 1
END
END
WHILE @i <= @iMax
BEGIN
SELECT @SC1 = Opcion + CAST(Numero AS VARCHAR(10)) FROM @TablaOpcionD WHERE ID = (@i) + ' '
WHILE @j <= @jMax
BEGIN
SELECT @SC2 = Opcion + CAST(Numero AS VARCHAR(10)) FROM @TablaOpcionD WHERE ID = (@j)
SET @Subcuenta = @SC1 + @SC2
INSERT INTO @TablaSubcuenta (Empresa,Almacen,Articulo,Subcuenta,Disponible) VALUES(@Empresa,@AlmacenOrigen,@Articulo,@Subcuenta,@Disponible)
SET @SC2 = ''
SET @j = @j + 1
END
SET @j = @iMax  + 1
SET @SC1 = ''
SET @i = @i + 1
END
END
ELSE
BEGIN
INSERT INTO @TablaSubcuenta (Empresa,Almacen,Articulo,Subcuenta,Disponible) VALUES(@Empresa,@AlmacenOrigen,@Articulo,@Subcuenta,@Disponible)
END
UPDATE @TablaSubcuenta SET Disponible = ISNULL(b.Disponible,0)
FROM @TablaSubcuenta a INNER JOIN ArtSubDisponible b
ON (a.Empresa = b.Empresa AND a.Almacen = b.Almacen AND a.Articulo = b.Articulo AND a.Subcuenta = b.Subcuenta)
DELETE @TablaSubcuenta WHERE Disponible = 0
INSERT INTO @TablaRet(Empresa,Articulo,SubCuenta)
SELECT @Empresa,Articulo,Subcuenta FROM @TablaSubcuenta
IF @Opciones = 1
BEGIN
UPDATE @TablaRet SET Descripcion = dbo.fnSubcuenta(Subcuenta)
END
ELSE
BEGIN
UPDATE @TablaRet SET Descripcion = @Descripcion
END
UPDATE @TablaRet SET Unidad = ISNULL(b.Unidad,'pza'), Factor = ISNULL(b.Factor,1)
FROM @TablaRet a INNER JOIN DistArtUnidad b
ON (a.Empresa = b.Empresa AND a.Articulo = b.Articulo AND a.SubCuenta = b.SubCuenta)
SELECT ID,Empresa,Articulo,SubCuenta,Descripcion,Unidad,Factor FROM @TablaRet
END

