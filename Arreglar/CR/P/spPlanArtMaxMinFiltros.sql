SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPlanArtMaxMinFiltros
@Empresa         varchar(5),
@Sucursal        int,
@Usuario         varchar(10),
@Estacion        int

AS
BEGIN
SET NOCOUNT ON
SET @Empresa           = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Sucursal          = ISNULL(@Sucursal,0)
SET @Usuario           = LTRIM(RTRIM(ISNULL(@Usuario,'')))
SET @Estacion          = ISNULL(@Estacion,0)
DECLARE @Filtro         varchar(20)
DECLARE @Valor          varchar(100)
SET @Valor = 'Seleccionar'
DECLARE @TablaRet table(
IDR               int IDENTITY(1,1),
Filtro            varchar(20) NULL,
Valor             varchar(100) NULL
)
SET @Filtro = 'Categoria'
INSERT INTO @TablaRet (Filtro,Valor) VALUES (@Filtro,@Valor)
INSERT INTO @TablaRet
SELECT @Filtro, UPPER(ISNULL(Categoria,''))
FROM PlanArtMaxMin
WHERE Empresa = @Empresa
AND Usuario = @Usuario
GROUP BY Categoria
ORDER BY 2
SET @Filtro = 'Grupo'
INSERT INTO @TablaRet (Filtro,Valor) VALUES (@Filtro,@Valor)
INSERT INTO @TablaRet
SELECT @Filtro, UPPER(ISNULL(Grupo,''))
FROM PlanArtMaxMin
WHERE Empresa = @Empresa
AND Usuario = @Usuario
GROUP BY Grupo
ORDER BY 2
SET @Filtro = 'Familia'
INSERT INTO @TablaRet (Filtro,Valor) VALUES (@Filtro,@Valor)
INSERT INTO @TablaRet
SELECT @Filtro, UPPER(ISNULL(Familia,''))
FROM PlanArtMaxMin
WHERE Empresa = @Empresa
AND Usuario = @Usuario
GROUP BY Familia
ORDER BY 2
SET @Filtro = 'Linea'
INSERT INTO @TablaRet (Filtro,Valor) VALUES (@Filtro,@Valor)
INSERT INTO @TablaRet
SELECT @Filtro, UPPER(ISNULL(Linea,''))
FROM PlanArtMaxMin
WHERE Empresa = @Empresa
AND Usuario = @Usuario
GROUP BY Linea
ORDER BY 2
SET @Filtro = 'Fabricante'
INSERT INTO @TablaRet (Filtro,Valor) VALUES (@Filtro,@Valor)
INSERT INTO @TablaRet
SELECT @Filtro, UPPER(ISNULL(Fabricante,''))
FROM PlanArtMaxMin
WHERE Empresa = @Empresa
AND Usuario = @Usuario
GROUP BY Fabricante
ORDER BY 2
SET @Filtro = 'Proveedor'
INSERT INTO @TablaRet (Filtro,Valor) VALUES (@Filtro,@Valor)
INSERT INTO @TablaRet
SELECT @Filtro, UPPER(ISNULL(Proveedor,''))
FROM PlanArtMaxMin
WHERE Empresa = @Empresa
AND Usuario = @Usuario
GROUP BY Proveedor
ORDER BY 2
SET @Filtro = 'Almacen'
INSERT INTO @TablaRet (Filtro,Valor) VALUES (@Filtro,@Valor)
INSERT INTO @TablaRet
SELECT @Filtro, UPPER(ISNULL(Almacen,''))
FROM PlanArtMaxMin
WHERE Empresa = @Empresa
AND Usuario = @Usuario
GROUP BY Almacen
ORDER BY 2
SET @Valor = 'No especificado'
UPDATE @TablaRet SET Valor = @Valor WHERE LTRIM(RTRIM(ISNULL(Valor,''))) = ''
SET @Filtro = 'Categoria'
SELECT IDR AS Clave, Valor FROM @TablaRet WHERE Filtro = @Filtro ORDER BY IDR
SET @Filtro = 'Grupo'
SELECT IDR AS Clave, Valor FROM @TablaRet WHERE Filtro = @Filtro ORDER BY IDR
SET @Filtro = 'Familia'
SELECT IDR AS Clave, Valor FROM @TablaRet WHERE Filtro = @Filtro ORDER BY IDR
SET @Filtro = 'Linea'
SELECT IDR AS Clave, Valor FROM @TablaRet WHERE Filtro = @Filtro ORDER BY IDR
SET @Filtro = 'Fabricante'
SELECT IDR AS Clave, Valor FROM @TablaRet WHERE Filtro = @Filtro ORDER BY IDR
SET @Filtro = 'Proveedor'
SELECT IDR AS Clave, Valor FROM @TablaRet WHERE Filtro = @Filtro ORDER BY IDR
SET @Filtro = 'Almacen'
SELECT IDR AS Clave, Valor FROM @TablaRet WHERE Filtro = @Filtro ORDER BY IDR
SET NOCOUNT OFF
END

