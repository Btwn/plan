SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDistArticulos (
@Empresa              varchar(5),
@Almacen              varchar(10),
@Articulo             varchar(20),
@Descripcion1         varchar(100),
@Rama                 varchar(20),
@Grupo                varchar(50),
@Categoria            varchar(50),
@Familia              varchar(50),
@Linea                varchar(50),
@Fabricante           varchar(50)
)

AS
BEGIN
DECLARE @q              nvarchar(max)  
DECLARE @a              char(1)        
DECLARE @p              char(1)        
DECLARE @c              char(1)        
DECLARE @r              char(1)        
DECLARE @maximo         int            
DECLARE @comodin        int            
DECLARE @ArticuloRet    varchar(20)    
DECLARE @Disponible     FLOAT          
DECLARE @i              int            
DECLARE @k              int            
DECLARE @TablaPre table(
[Articulo]            varchar(20)  NULL,
[Descripcion]         varchar(100) NULL,
[Rama]                varchar(20)  NULL,
[Grupo]               varchar(50)  NULL,
[Categoria]           varchar(50)  NULL,
[Familia]             varchar(50)  NULL,
[Linea]               varchar(50)  NULL,
[Fabricante]          varchar(50)  NULL
)
DECLARE @TablaRet table(
[ID]                  int IDENTITY(1,1),
[Empresa]             varchar(5)   NULL,
[Almacen]             varchar(10)  NULL,
[Articulo]            varchar(20)  NULL,
[Descripcion]         varchar(100) NULL,
[Rama]                varchar(20)  NULL,
[Grupo]               varchar(50)  NULL,
[Categoria]           varchar(50)  NULL,
[Familia]             varchar(50)  NULL,
[Linea]               varchar(50)  NULL,
[Fabricante]          varchar(50)  NULL,
[Disponible]          float        NULL
)
SET @q = ''
SET @a = CHAR(42)
SET @p = CHAR(37)
SET @c = CHAR(39)
SET @r = CHAR(13)
SET @maximo = 100
SET @comodin = 0
SET @ArticuloRet = ''
SET @Disponible = 0
SET @i = 0
SET @k = 0
SET @Empresa      = ISNULL(@Empresa,'')
SET @Articulo     = ISNULL(@Articulo,'')
SET @Descripcion1 = ISNULL(@Descripcion1,'')
SET @Rama         = ISNULL(@Rama,'')
SET @Grupo        = ISNULL(@Grupo,'')
SET @Categoria    = ISNULL(@Categoria,'')
SET @Familia      = ISNULL(@Familia,'')
SET @Linea        = ISNULL(@Linea,'')
SET @Fabricante   = ISNULL(@Fabricante,'')
SET @q = N'
DECLARE @TablaTmp table(
[Articulo]            varchar(20),
[Descripcion]         varchar(100),
[Rama]                varchar(20),
[Grupo]               varchar(50),
[Categoria]           varchar(50),
[Familia]             varchar(50),
[Linea]               varchar(50),
[Fabricante]          varchar(50)
)
'
SET @q = @q + @r + 'INSERT INTO @TablaTmp([Articulo],[Descripcion],[Rama],[Grupo],[Categoria],[Familia],[Linea],[Fabricante])'
SET @q = @q + @r + 'SELECT LTRIM(RTRIM(Articulo)), LTRIM(RTRIM(Descripcion1)), LTRIM(RTRIM(Rama)), LTRIM(RTRIM(Grupo)), LTRIM(RTRIM(Categoria)), LTRIM(RTRIM(Familia)), LTRIM(RTRIM(Linea)), LTRIM(RTRIM(Fabricante))'
SET @q = @q + @r + 'FROM Art WHERE Estatus = ' + @c + 'ALTA' + @c + ' AND Tipo = '  + @c + 'Normal' + @c
IF LEN(@Articulo) > 0
BEGIN
SET @comodin = CHARINDEX(@a,@Articulo)
IF @comodin > 0
BEGIN
SET @Articulo = LEFT(@Articulo, (@comodin - 1))
SET @q = @q + @r + 'AND Articulo LIKE ' + @c +  @Articulo + @p + @c
END
ELSE
BEGIN
SET @q = @q + @r + 'AND Articulo = ' + @c +  @Articulo + @c
END
END
ELSE IF LEN(@Descripcion1) > 0
BEGIN
SET @comodin = CHARINDEX(@a,@Descripcion1)
IF @comodin > 0
BEGIN
SET @Descripcion1 = LEFT(@Descripcion1, (@comodin - 1))
SET @q = @q + @r + 'AND Descripcion1 LIKE ' + @c +  @Descripcion1 + @p + @c
END
ELSE
BEGIN
SET @q = @q + @r + 'AND Descripcion1 = ' + @c +  @Descripcion1 + @c
END
END
IF LEN(@Rama)         > 0 SET @q = @q + @r + 'AND Rama = '       + @c + @Rama       + @c
IF LEN(@Grupo)        > 0 SET @q = @q + @r + 'AND Grupo = '      + @c + @Grupo      + @c
IF LEN(@Categoria)    > 0 SET @q = @q + @r + 'AND Categoria = '  + @c + @Categoria  + @c
IF LEN(@Familia)      > 0 SET @q = @q + @r + 'AND Familia = '    + @c + @Familia    + @c
IF LEN(@Linea)        > 0 SET @q = @q + @r + 'AND Linea = '      + @c + @Linea      + @c
IF LEN(@Fabricante)   > 0 SET @q = @q + @r + 'AND Fabricante = ' + @c + @Fabricante + @c
SET @q = @q + @r + @r + 'SELECT TOP ' + CAST(@maximo AS VARCHAR(4)) + ' [Articulo],[Descripcion],[Rama],[Grupo],[Categoria],[Familia],[Linea],[Fabricante] FROM @TablaTmp'
INSERT INTO @TablaPre EXEC sp_executesql @q
INSERT INTO @TablaRet (Empresa,Almacen,Articulo,Descripcion,Rama,Grupo,Categoria,Familia,Linea,Fabricante,Disponible)
SELECT @Empresa,@ALmacen,Articulo,Descripcion,Rama,Grupo,Categoria,Familia,Linea,Fabricante,@Disponible
FROM @TablaPre
SELECT @k = MAX(ID) FROM @TablaRet
SET @i = 0
WHILE @i < @k
BEGIN
SET @i = @i + 1
SELECT @ArticuloRet = Articulo FROM @TablaRet WHERE ID = @i
SELECT @Disponible = SUM(Disponible)
FROM ArtSubDisponible
WHERE Empresa = @Empresa AND Almacen = @Almacen AND Articulo = @ArticuloRet
IF ISNULL(@Disponible,0) > 0
BEGIN
UPDATE @TablaRet SET Disponible = @Disponible WHERE ID = @i
END
END
SELECT
ID          AS 'ID',
Empresa     AS 'Empresa',
Almacen     AS 'Almacen',
Articulo    AS 'Artículo',
Descripcion AS 'Descripción',
Rama        AS 'Rama',
Grupo       AS 'Grupo',
Categoria   AS 'Categoría',
Familia     AS 'Familia',
Linea       AS 'Línea',
Fabricante  AS 'Fabricante',
Disponible  AS 'Disponible'
FROM @TablaRet
ORDER BY ID
END

