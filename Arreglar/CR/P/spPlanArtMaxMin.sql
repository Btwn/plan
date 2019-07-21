SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPlanArtMaxMin(
@Empresa              varchar(5),
@Sucursal             int,
@Usuario              varchar(10),
@Estacion             int,
@Buscar               varchar(20),
@Categoria            varchar(50),
@Grupo                varchar(50),
@Familia              varchar(50),
@Linea                varchar(50),
@Fabricante           varchar(50),
@Proveedor            varchar(50),
@Almacen              varchar(50)
)

AS
BEGIN
SET NOCOUNT ON
DECLARE @NoEspecificado char(15)
DECLARE @q              nvarchar(max)            
DECLARE @a              char(1)                  
DECLARE @p              char(1)                  
DECLARE @c              char(1)                  
DECLARE @r              char(1)                  
DECLARE @TablaRet table(
[ID]                  int          NULL,
[Empresa]             varchar(5)   NULL,
[Sucursal]            int          NULL,
[Usuario]             varchar(10)  NULL,
[Estacion]            int          NULL,
[Grupo]               varchar(50)  NULL,
[Categoria]           varchar(50)  NULL,
[Familia]             varchar(50)  NULL,
[Linea]               varchar(50)  NULL,
[Fabricante]          varchar(50)  NULL,
[Proveedor]           varchar(10)  NULL,
[Nombre]              varchar(100) NULL,
[Almacen]             varchar(10)  NULL,
[AlmacenNombre]       varchar(100) NULL,
[Articulo]            varchar(20)  NULL,
[SubCuenta]           varchar(50)  NULL,
[Descripcion1]        varchar(100) NULL,
[Descripcion2]        varchar(255) NULL,
[NombreCorto]         varchar(20)  NULL,
[Unidad]              varchar(50)  NULL,
[ABC]                 varchar(5)   NULL,
[Maximo]              float        NULL,
[Minimo]              float        NULL,
[VentaPromedio]       float        NULL,
[Precio]              float        NULL,
[ImporteTotal]        float        NULL,
[Existencia]          float        NULL,
[EnCompra]            float        NULL,
[PorRecibir]          float        NULL,
[PorEntregar]         float        NULL,
[Disponible]          float        NULL,
[DiasInvInicio]       float        NULL,
[AlmacenD]            varchar(10)  NULL,
[AlmacenNombreD]      varchar(100) NULL,
[MaximoD]             float        NULL,
[MinimoD]             float        NULL,
[VentaPromedioD]      float        NULL,
[ExistenciaD]         float        NULL,
[EnCompraD]           float        NULL,
[PorRecibirD]         float        NULL,
[PorEntregarD]        float        NULL,
[DisponibleD]         float        NULL,
[DiasInvD]            float        NULL,
[Solicitar]           float        NULL,
[Cantidad]            float        NULL,
[CantidadA]           float        NULL,
[DiasInvFin]          float        NULL,
[Tipo]                varchar(20)  NULL,
[Movimiento]          varchar(20)  NULL,
[Aplicar]             int          NULL        
)
SET @Empresa           = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Sucursal          = ISNULL(@Sucursal,0)
SET @Usuario           = LTRIM(RTRIM(ISNULL(@Usuario,'')))
SET @Estacion          = ISNULL(@Estacion,0)
SET @Buscar            = LTRIM(RTRIM(ISNULL(@Buscar,'')))
SET @Categoria         = LTRIM(RTRIM(ISNULL(@Categoria,'')))
SET @Grupo             = LTRIM(RTRIM(ISNULL(@Grupo,'')))
SET @Familia           = LTRIM(RTRIM(ISNULL(@Familia,'')))
SET @Linea             = LTRIM(RTRIM(ISNULL(@Linea,'')))
SET @Fabricante        = LTRIM(RTRIM(ISNULL(@Fabricante,'')))
SET @Proveedor         = LTRIM(RTRIM(ISNULL(@Proveedor,'')))
SET @Almacen           = LTRIM(RTRIM(ISNULL(@Almacen,'')))
SET @NoEspecificado    = 'No especificado'
SET @a = CHAR(42)
SET @p = CHAR(37)
SET @c = CHAR(39)
SET @r = CHAR(13)
SET @q = N'
DECLARE @TablaTmp table(
[ID]                  int          NULL,
[Empresa]             varchar(5)   NULL,
[Sucursal]            int          NULL,
[Usuario]             varchar(10)  NULL,
[Estacion]            int          NULL,
[Grupo]               varchar(50)  NULL,
[Categoria]           varchar(50)  NULL,
[Familia]             varchar(50)  NULL,
[Linea]               varchar(50)  NULL,
[Fabricante]          varchar(50)  NULL,
[Proveedor]           varchar(10)  NULL,
[Nombre]              varchar(100) NULL,
[Almacen]             varchar(10)  NULL,
[AlmacenNombre]       varchar(100) NULL,
[Articulo]            varchar(20)  NULL,
[SubCuenta]           varchar(50)  NULL,
[Descripcion1]        varchar(100) NULL,
[Descripcion2]        varchar(255) NULL,
[NombreCorto]         varchar(20)  NULL,
[Unidad]              varchar(50)  NULL,
[ABC]                 varchar(5)   NULL,
[Maximo]              float        NULL,
[Minimo]              float        NULL,
[VentaPromedio]       float        NULL,
[Precio]              float        NULL,
[ImporteTotal]        float        NULL,
[Existencia]          float        NULL,
[EnCompra]            float        NULL,
[PorRecibir]          float        NULL,
[PorEntregar]         float        NULL,
[Disponible]          float        NULL,
[DiasInvInicio]       float        NULL,
[AlmacenD]            varchar(10)  NULL,
[AlmacenNombreD]      varchar(100) NULL,
[MaximoD]             float        NULL,
[MinimoD]             float        NULL,
[VentaPromedioD]      float        NULL,
[ExistenciaD]         float        NULL,
[EnCompraD]           float        NULL,
[PorRecibirD]         float        NULL,
[PorEntregarD]        float        NULL,
[DisponibleD]         float        NULL,
[DiasInvD]            float        NULL,
[Solicitar]           float        NULL,
[Cantidad]            float        NULL,
[CantidadA]           float        NULL,
[DiasInvFin]          float        NULL,
[Tipo]                varchar(20)  NULL,
[Movimiento]          varchar(20)  NULL,
[Aplicar]             bit          NULL
)
'
SET @q = @q + @r + 'INSERT INTO @TablaTmp('
SET @q = @q + @r + '  [ID], [Empresa], [Sucursal], [Estacion], [Usuario],'
SET @q = @q + @r + '  [Grupo], [Categoria], [Familia], [Linea], [Fabricante],'
SET @q = @q + @r + '  [Proveedor], [Nombre], [Almacen], [AlmacenNombre], [Articulo],'
SET @q = @q + @r + '  [SubCuenta], [Descripcion1], [Descripcion2], [NombreCorto], [Unidad],'
SET @q = @q + @r + '  [ABC], [Maximo], [Minimo], [VentaPromedio], [Precio],'
SET @q = @q + @r + '  [ImporteTotal], [Existencia], [EnCompra], [PorRecibir], [PorEntregar],'
SET @q = @q + @r + '  [Disponible], [DiasInvInicio], [AlmacenD], [AlmacenNombreD], [MaximoD],'
SET @q = @q + @r + '  [MinimoD], [VentaPromedioD], [ExistenciaD], [EnCompraD], [PorRecibirD],'
SET @q = @q + @r + '  [PorEntregarD], [DisponibleD], [DiasInvD], [Solicitar], [Cantidad],'
SET @q = @q + @r + '  [CantidadA], [DiasInvFin], [Tipo], [Movimiento], [Aplicar]'
SET @q = @q + @r + ')'
SET @q = @q + @r + 'SELECT'
SET @q = @q + @r + '  [ID], [Empresa], [Sucursal], [Estacion], [Usuario],'
SET @q = @q + @r + '  [Grupo], [Categoria], [Familia], [Linea], [Fabricante],'
SET @q = @q + @r + '  [Proveedor], [Nombre], [Almacen], [AlmacenNombre], [Articulo],'
SET @q = @q + @r + '  [SubCuenta], [Descripcion1], [Descripcion2], [NombreCorto], [Unidad],'
SET @q = @q + @r + '  [ABC], [Maximo], [Minimo], [VentaPromedio], [Precio],'
SET @q = @q + @r + '  [ImporteTotal], [Existencia], [EnCompra], [PorRecibir], [PorEntregar],'
SET @q = @q + @r + '  [Disponible], [DiasInvInicio], [AlmacenD], [AlmacenNombreD], [MaximoD],'
SET @q = @q + @r + '  [MinimoD], [VentaPromedioD], [ExistenciaD], [EnCompraD], [PorRecibirD],'
SET @q = @q + @r + '  [PorEntregarD], [DisponibleD], [DiasInvD], [Solicitar], [Cantidad],'
SET @q = @q + @r + '  [CantidadA], [DiasInvFin], [Tipo], [Movimiento], [Aplicar]'
SET @q = @q + @r + '  FROM PlanArtMaxMin WHERE Empresa = ' + @c + @Empresa + @c
SET @q = @q + @r + '   AND Usuario = ' + @c + @Usuario + @c
SET @q = @q + @r + '   AND Estacion = ' +  CAST(@Estacion AS varchar)
IF LEN(@Categoria) > 0
BEGIN
IF @Categoria = @NoEspecificado
SET @q = @q + @r + 'AND LTRIM(RTRIM(ISNULL(Categoria,' + @c + @c +'))) = ' + @c + @c
ELSE
SET @q = @q + @r + 'AND Categoria = ' + @c + @Categoria + @c
END
IF LEN(@Grupo) > 0
BEGIN
IF @Grupo = @NoEspecificado
SET @q = @q + @r + 'AND LTRIM(RTRIM(ISNULL(Grupo,' + @c + @c +'))) = ' + @c + @c
ELSE
SET @q = @q + @r + 'AND Grupo = ' + @c + @Grupo + @c
END
IF LEN(@Familia) > 0
BEGIN
IF @Familia = @NoEspecificado
SET @q = @q + @r + 'AND LTRIM(RTRIM(ISNULL(Familia,' + @c + @c +'))) = ' + @c + @c
ELSE
SET @q = @q + @r + 'AND Familia = ' + @c + @Familia + @c
END
IF LEN(@Linea) > 0
BEGIN
IF @Linea = @NoEspecificado
SET @q = @q + @r + 'AND LTRIM(RTRIM(ISNULL(Linea,' + @c + @c +'))) = ' + @c + @c
ELSE
SET @q = @q + @r + 'AND Linea = ' + @c + @Linea + @c
END
IF LEN(@Fabricante) > 0
BEGIN
IF @Fabricante = @NoEspecificado
SET @q = @q + @r + 'AND LTRIM(RTRIM(ISNULL(Fabricante,' + @c + @c +'))) = ' + @c + @c
ELSE
SET @q = @q + @r + 'AND Fabricante = ' + @c + @Fabricante + @c
END
IF LEN(@Proveedor) > 0
BEGIN
IF @Proveedor = @NoEspecificado
SET @q = @q + @r + 'AND LTRIM(RTRIM(ISNULL(Proveedor,' + @c + @c +'))) = ' + @c + @c
ELSE
SET @q = @q + @r + 'AND Proveedor = ' + @c + @Proveedor + @c
END
IF LEN(@Almacen) > 0
BEGIN
IF @Almacen = @NoEspecificado
SET @q = @q + @r + 'AND LTRIM(RTRIM(ISNULL(Almacen,' + @c + @c +'))) = ' + @c + @c
ELSE
SET @q = @q + @r + 'AND Almacen = ' + @c + @Almacen + @c
END
IF LEN(@Buscar) > 0
BEGIN
IF CHARINDEX(@a,@Buscar) = 0
BEGIN
SET @q = @q + @r + 'AND (Articulo      = ' + @c + @Buscar + @c
SET @q = @q + @r + 'OR Descripcion1    = ' + @c + @Buscar + @c
SET @q = @q + @r + 'OR Descripcion2    = ' + @c + @Buscar + @c
SET @q = @q + @r + 'OR NombreCorto     = ' + @c + @Buscar + @c
SET @q = @q + @r + 'OR Grupo           = ' + @c + @Buscar + @c
SET @q = @q + @r + 'OR Categoria       = ' + @c + @Buscar + @c
SET @q = @q + @r + 'OR Familia         = ' + @c + @Buscar + @c
SET @q = @q + @r + 'OR Linea           = ' + @c + @Buscar + @c
SET @q = @q + @r + 'OR Fabricante      = ' + @c + @Buscar + @c
SET @q = @q + @r + 'OR Proveedor       = ' + @c + @Buscar + @c
SET @q = @q + @r + 'OR Nombre          = ' + @c + @Buscar + @c + ')'
END
ELSE
BEGIN
SET @Buscar = REPLACE(@Buscar,@a,@p)
SET @q = @q + @r + 'AND (Articulo   LIKE ' + @c + @Buscar + @c
SET @q = @q + @r + 'OR Descripcion1 LIKE ' + @c + @Buscar + @c
SET @q = @q + @r + 'OR Descripcion2 LIKE ' + @c + @Buscar + @c
SET @q = @q + @r + 'OR NombreCorto  LIKE ' + @c + @Buscar + @c
SET @q = @q + @r + 'OR Grupo        LIKE ' + @c + @Buscar + @c
SET @q = @q + @r + 'OR Categoria    LIKE ' + @c + @Buscar + @c
SET @q = @q + @r + 'OR Familia      LIKE ' + @c + @Buscar + @c
SET @q = @q + @r + 'OR Linea        LIKE ' + @c + @Buscar + @c
SET @q = @q + @r + 'OR Fabricante   LIKE ' + @c + @Buscar + @c
SET @q = @q + @r + 'OR Proveedor    LIKE ' + @c + @Buscar + @c
SET @q = @q + @r + 'OR Nombre       LIKE ' + @c + @Buscar + @c + ')'
END
END
SET @q = @q + @r + @r + 'SELECT * FROM @TablaTmp'
INSERT INTO @TablaRet EXEC sp_executesql @q
SELECT ID, Empresa, Sucursal, Usuario, Estacion,
Grupo, Categoria, Familia, Linea, Fabricante,
Proveedor, Nombre, Articulo, SubCuenta, Descripcion1,
Descripcion2, NombreCorto, Unidad, ABC, Almacen,
AlmacenNombre, Maximo, Minimo, VentaPromedio, Precio,
ImporteTotal, Existencia, EnCompra, PorRecibir, PorEntregar,
Disponible, DiasInvInicio, AlmacenD, AlmacenNombreD, MaximoD,
MinimoD, VentaPromedioD, ExistenciaD, EnCompraD, PorRecibirD,
PorEntregarD, DisponibleD, DiasInvD, Solicitar, Cantidad,
CantidadA, DiasInvFin, Tipo, Movimiento, Aplicar
FROM @TablaRet
ORDER BY Almacen, Articulo, SubCuenta, AlmacenD
SET NOCOUNT OFF
END

