SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDistDisponible
@Empresa                varchar(5),
@AlmacenOrigen          varchar(10),
@Articulo               varchar(20),
@Corrida                int

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
DECLARE @ArticuloCr     varchar(20)
DECLARE @SubcuentaCr    varchar(20)
DECLARE @TransferirCr   float
DECLARE @Opciones       bit
DECLARE @AlmacenOrigenNombre varchar(10)
DECLARE @EsOrigen            bit
DECLARE @EsDestino           bit
DECLARE @TablaAlm table(
ID                    int IDENTITY(1,1),
Almacen               varchar(10)   NULL,
Nombre                varchar(100)   NULL
)
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
Almacen               varchar(10)   NULL,
Articulo              varchar(20)   NULL,
Subcuenta             varchar(20)   NULL,
Descripcion           varchar(1000) NULL
)
DECLARE @TablaTmp table(
ID                    int IDENTITY(1,1),
Empresa               varchar(5)    NULL,
Almacen               varchar(10)   NULL,
Nombre                varchar(100)  NULL,
Articulo              varchar(20)   NULL,
Subcuenta             varchar(100)  NULL,
Descripcion           varchar(1000) NULL,
Disponible            float         NULL,
Transferir            float         NULL DEFAULT 0
)
DECLARE @TablaPre table(
ID                    int IDENTITY(1,1),
Empresa               varchar(5)    NULL,
Almacen               varchar(10)   NULL,
Nombre                varchar(100)  NULL,
Articulo              varchar(20)   NULL,
Subcuenta             varchar(100)  NULL,
Descripcion           varchar(1000) NULL,
Disponible            float         NULL DEFAULT 0,
Transferir            float         NULL DEFAULT 0
)
DECLARE @TablaRet table(
ID                    int IDENTITY(1,1),
Empresa               varchar(5)    NULL,
Almacen               varchar(10)   NULL,
Nombre                varchar(100)  NULL,
Articulo              varchar(20)   NULL,
Subcuenta             varchar(100)  NULL,
Descripcion           varchar(1000) NULL,
Disponible            float         NULL,
Transferir            float         NULL,
Virtual               float         NULL
)
SET @Empresa       = UPPER(LTRIM(RTRIM(ISNULL(@Empresa,''))))
SET @AlmacenOrigen = UPPER(LTRIM(RTRIM(ISNULL(@AlmacenOrigen,''))))
SET @Articulo      = UPPER(LTRIM(RTRIM(ISNULL(@Articulo,''))))
SET @Corrida       = ISNULL(@Corrida,0)
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
SELECT @EsDestino = EsDestino, @AlmacenOrigenNombre = Nombre
FROM AlmDist
WHERE Empresa = @Empresa AND Almacen = @AlmacenOrigen
SET @EsDestino = ISNULL(@EsDestino,0)
SET @AlmacenOrigenNombre = ISNULL(@AlmacenOrigenNombre,'')
PRINT @EsDestino
PRINT @AlmacenOrigenNombre
IF @EsDestino = 0
BEGIN
INSERT INTO @TablaAlm (Almacen,Nombre) VALUES (@AlmacenOrigen,@AlmacenOrigenNombre)
PRINT 'ES DESTINO'
END
INSERT INTO @TablaAlm (Almacen,Nombre)
SELECT a.Almacen,a.Nombre
FROM AlmDist a
JOIN Alm b ON (a.Almacen = b.Almacen)
WHERE a.Empresa = @Empresa
AND a.Distribuir = 1
AND a.EsDestino = 1
AND b.Estatus = 'ALTA'
ORDER BY a.Nombre
INSERT INTO @TablaOpcionD EXEC spVerOpcionD @Articulo
IF EXISTS(SELECT TOP 1 ID FROM @TablaOpcionD) SET @Opciones = 1 ELSE SET @Opciones = 0
IF @Opciones = 1
BEGIN
INSERT INTO @TablaOpcion (Opcion) SELECT Opcion FROM @TablaOpcionD GROUP BY Opcion
SELECT @Opcion1 = Opcion FROM @TablaOpcion WHERE ID = 1
SELECT @Opcion2 = Opcion FROM @TablaOpcion WHERE ID = 2
SET @i = 1
SELECT @iMax = MAX(ID) FROM @TablaOpcionD WHERE Opcion = @Opcion1
SET @j = @iMax + 1
SELECT @jMax = MAX(ID) FROM @TablaOpcionD WHERE Opcion = @Opcion2
/* Si @jMax es nula solo tiene una opcion */
IF ISNULL(@jMax,0) = 0
BEGIN
WHILE @i <= @iMax
BEGIN
SELECT @SC1 = Opcion + CAST(Numero AS VARCHAR(10)) FROM @TablaOpcionD WHERE ID = (@i) + ' '
SET @Subcuenta = @SC1
INSERT INTO @TablaSubcuenta (Almacen,Articulo,Subcuenta) VALUES(@AlmacenOrigen,@Articulo,@Subcuenta)
SET @SC1 = ''
SET @i = @i + 1
END
END
/* Tiene 2 opciones */
WHILE @i <= @iMax
BEGIN
SELECT @SC1 = Opcion + CAST(Numero AS VARCHAR(10)) FROM @TablaOpcionD WHERE ID = (@i) + ' '
WHILE @j <= @jMax
BEGIN
SELECT @SC2 = Opcion + CAST(Numero AS VARCHAR(10)) FROM @TablaOpcionD WHERE ID = (@j)
SET @Subcuenta = @SC1 + @SC2
INSERT INTO @TablaSubcuenta (Almacen,Articulo,Subcuenta) VALUES(@AlmacenOrigen,@Articulo,@Subcuenta)
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
INSERT INTO @TablaSubcuenta (Almacen,Articulo,Subcuenta) VALUES(@AlmacenOrigen,@Articulo,@Subcuenta)
END
INSERT INTO @TablaTmp (Empresa,Almacen,Nombre,Articulo,Subcuenta,Descripcion,Disponible)
SELECT @Empresa,@AlmacenOrigen,UPPER(a.Nombre),@Articulo,t.Subcuenta,t.Descripcion,0
FROM @TablaSubcuenta t LEFT JOIN @TablaAlm a ON (t.Almacen = a.Almacen)
WHERE a.Almacen = @AlmacenOrigen
UPDATE @TablaTmp SET Disponible = ISNULL(b.Disponible,0)
FROM @TablaTmp a INNER JOIN ArtSubDisponible b
ON (a.Empresa = b.Empresa AND a.Almacen = b.Almacen AND a.Articulo = b.Articulo AND a.Subcuenta = b.Subcuenta)
IF @Corrida > 0
BEGIN
IF EXISTS (SELECT TOP 1 Corrida FROM Distribucion WHERE Corrida = @Corrida)
BEGIN
UPDATE @TablaTmp SET Transferir = 1
FROM @TablaTmp a INNER JOIN Distribucion b
ON (a.Empresa = b.Empresa AND a.Almacen = b.Almacen AND a.Articulo = b.Articulo AND a.Subcuenta = b.Subcuenta)
WHERE b.Corrida = @Corrida
END
END
DELETE @TablaTmp WHERE Disponible = 0 AND Transferir = 0
IF @Opciones = 1
BEGIN
UPDATE @TablaTmp SET Descripcion = dbo.fnSubcuenta(Subcuenta)
END
ELSE
BEGIN
UPDATE @TablaTmp SET Descripcion = @Descripcion
END
INSERT INTO @TablaPre (Empresa, Almacen,Nombre,Articulo,Subcuenta,Descripcion)
SELECT t.Empresa, a.Almacen,a.Nombre,t.Articulo, t.Subcuenta,t.Descripcion
FROM @TablaTmp t
CROSS JOIN @TablaAlm a
WHERE a.Almacen = @AlmacenOrigen
INSERT INTO @TablaPre (Empresa, Almacen,Nombre,Articulo,Subcuenta,Descripcion)
SELECT t.Empresa, a.Almacen,a.Nombre,t.Articulo, t.Subcuenta,t.Descripcion
FROM @TablaTmp t
CROSS JOIN @TablaAlm a
WHERE a.Almacen <> @AlmacenOrigen
UPDATE @TablaPre SET Disponible = ISNULL(b.Disponible,0)
FROM @TablaPre a INNER JOIN ArtSubDisponible b
ON (a.Empresa = b.Empresa AND a.Almacen = b.Almacen AND a.Articulo = b.Articulo AND a.Subcuenta = b.Subcuenta)
INSERT INTO @TablaRet (Empresa,Almacen,Nombre,Articulo,Subcuenta,Descripcion,Disponible,Transferir,Virtual)
SELECT Empresa,Almacen,Nombre,Articulo,Subcuenta,Descripcion,Disponible,0,Disponible
FROM @TablaPre
WHERE Almacen = @AlmacenOrigen
ORDER BY Almacen, Subcuenta
INSERT INTO @TablaRet (Empresa,Almacen,Nombre,Articulo,Subcuenta,Descripcion,Disponible,Transferir,Virtual)
SELECT Empresa,Almacen,Nombre,Articulo,Subcuenta,Descripcion,Disponible,0,Disponible
FROM @TablaPre
WHERE NOT Almacen = @AlmacenOrigen
ORDER BY Almacen, Subcuenta
IF @Corrida > 0
BEGIN
UPDATE @TablaRet SET Transferir = ISNULL(b.Cantidad,0)
FROM @TablaRet a INNER JOIN Distribucion b
ON (a.Empresa = b.Empresa AND a.Almacen = b.AlmacenDestino AND a.Articulo = b.Articulo AND a.Subcuenta = b.SubCuenta)
WHERE b.Almacen = @AlmacenOrigen
AND b.Corrida = @Corrida
DECLARE crDistDisponibleCorrida CURSOR FOR
SELECT Articulo,Subcuenta FROM @TablaRet WHERE Almacen = @AlmacenOrigen GROUP BY Articulo,Subcuenta
OPEN crDistDisponibleCorrida
FETCH NEXT FROM crDistDisponibleCorrida INTO @ArticuloCr,@SubcuentaCr
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @TransferirCr = SUM(Transferir) FROM @TablaRet WHERE Articulo = @ArticuloCr AND Subcuenta = @SubcuentaCr
SET @TransferirCr = ISNULL(@TransferirCr,0)
UPDATE @TablaRet SET Transferir = @TransferirCr WHERE Almacen = @AlmacenOrigen AND Articulo = @ArticuloCr AND Subcuenta = @SubcuentaCr
FETCH NEXT FROM crDistDisponibleCorrida INTO @ArticuloCr,@SubcuentaCr
END
CLOSE crDistDisponibleCorrida
DEALLOCATE crDistDisponibleCorrida
UPDATE @TablaRet
SET Virtual = Disponible - Transferir
WHERE Almacen = @AlmacenOrigen
UPDATE @TablaRet
SET Virtual = Disponible + Transferir
WHERE NOT Almacen = @AlmacenOrigen
END
SELECT ID,Almacen,Nombre,Articulo,Subcuenta,Descripcion,Disponible,Transferir,Virtual FROM @TablaRet ORDER BY ID
END

