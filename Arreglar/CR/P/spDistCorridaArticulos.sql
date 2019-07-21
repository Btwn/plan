SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDistCorridaArticulos (
@Empresa              varchar(5),
@Sucursal             int,
@Usuario              varchar(10),
@Estacion             int,
@Corrida              int
)
AS
BEGIN
DECLARE @TablaRet table(
ID                    int IDENTITY(1,1),
Almacen               varchar(10)  NULL,
AlmacenNombre         varchar(100) NULL,
Articulo              varchar(20)  NULL,
Descripcion           varchar(100) NULL
)
SET @Empresa   = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Sucursal  = UPPER(LTRIM(RTRIM(ISNULL(@Sucursal,''))))
SET @Usuario   = UPPER(LTRIM(RTRIM(ISNULL(@Usuario,''))))
SET @Estacion  = ISNULL(@Estacion,1)
SET @Corrida   = ISNULL(@Corrida,0)
INSERT INTO @TablaRet(ALmacen,Articulo)
SELECT ALmacen,Articulo
FROM Distribucion
WHERE Empresa = @Empresa
AND Corrida = @Corrida
GROUP BY ALmacen,Articulo
ORDER BY ALmacen,Articulo
UPDATE
@TablaRet
SET
AlmacenNombre  = LTRIM(RTRIM(ISNULL(b.Nombre,'')))
FROM
@TablaRet a
INNER JOIN
AlmDist b
ON
a.Almacen = b.Almacen
WHERE b.Empresa = @Empresa
UPDATE
@TablaRet
SET
Descripcion  = LTRIM(RTRIM(ISNULL(b.Descripcion1,'')))
FROM
@TablaRet a
INNER JOIN
Art b
ON
a.Articulo = b.Articulo
SELECT ID,Almacen,AlmacenNombre,Articulo,Descripcion FROM @TablaRet ORDER BY ID
END

