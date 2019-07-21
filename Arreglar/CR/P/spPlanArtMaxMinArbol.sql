SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPlanArtMaxMinArbol
@Empresa              varchar(5),
@Sucursal             int,
@Usuario              varchar(10),
@Estacion             int

AS
BEGIN
SET NOCOUNT ON
DECLARE @NodoRaiz       varchar(20)
DECLARE @NoEspecificado char(15)
DECLARE @TablaRet table(
IDR                   int IDENTITY(1,1),
NodoNombre            varchar(50)  NULL,
NodoPadre             varchar(50)  NULL
)
SET @Empresa  = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Sucursal = ISNULL(@Sucursal,0)
SET @Usuario  = LTRIM(RTRIM(ISNULL(@Usuario,'')))
SET @Estacion = ISNULL(@Estacion,0)
SET @NodoRaiz = '(Todo)'
SET @NoEspecificado = 'NO ESPECIFICADO'
INSERT INTO @TablaRet (NodoNombre,NodoPadre) VALUES ('Categoria',@NodoRaiz)
INSERT INTO @TablaRet (NodoNombre,NodoPadre) VALUES ('Grupo',@NodoRaiz)
INSERT INTO @TablaRet (NodoNombre,NodoPadre) VALUES ('Familia',@NodoRaiz)
INSERT INTO @TablaRet (NodoNombre,NodoPadre) VALUES ('Linea',@NodoRaiz)
INSERT INTO @TablaRet (NodoNombre,NodoPadre) VALUES ('Fabricante',@NodoRaiz)
INSERT INTO @TablaRet (NodoNombre,NodoPadre) VALUES ('Proveedor',@NodoRaiz)
INSERT INTO @TablaRet (NodoNombre,NodoPadre) VALUES ('Almacen',@NodoRaiz)
INSERT INTO @TablaRet
SELECT UPPER(LTRIM(RTRIM(ISNULL(Categoria,'')))), 'Categoria' FROM PlanArtMaxMin
WHERE Empresa = @Empresa AND Usuario = @Usuario AND Estacion = @Estacion
GROUP BY Categoria
ORDER BY Categoria
INSERT INTO @TablaRet
SELECT UPPER(LTRIM(RTRIM(ISNULL(Grupo,'')))), 'Grupo' FROM PlanArtMaxMin
WHERE Empresa = @Empresa AND Usuario = @Usuario AND Estacion = @Estacion
GROUP BY Grupo
ORDER BY Grupo
INSERT INTO @TablaRet
SELECT UPPER(LTRIM(RTRIM(ISNULL(Familia,'')))), 'Familia' FROM PlanArtMaxMin
WHERE Empresa = @Empresa AND Usuario = @Usuario AND Estacion = @Estacion
GROUP BY Familia
ORDER BY Familia
INSERT INTO @TablaRet
SELECT UPPER(LTRIM(RTRIM(ISNULL(Linea,'')))), 'Linea' FROM PlanArtMaxMin
WHERE Empresa = @Empresa AND Usuario = @Usuario AND Estacion = @Estacion
GROUP BY Linea
ORDER BY Linea
INSERT INTO @TablaRet
SELECT UPPER(LTRIM(RTRIM(ISNULL(Fabricante,'')))), 'Fabricante' FROM PlanArtMaxMin
WHERE Empresa = @Empresa AND Usuario = @Usuario AND Estacion = @Estacion
GROUP BY Fabricante
ORDER BY Fabricante
INSERT INTO @TablaRet
SELECT UPPER(LTRIM(RTRIM(ISNULL(Proveedor,'')))), 'Proveedor' FROM PlanArtMaxMin
WHERE Empresa = @Empresa AND Usuario = @Usuario AND Estacion = @Estacion
GROUP BY Proveedor
ORDER BY Proveedor
INSERT INTO @TablaRet
SELECT UPPER(LTRIM(RTRIM(ISNULL(Almacen,'')))), 'Almacen' FROM PlanArtMaxMin
WHERE Empresa = @Empresa AND Usuario = @Usuario AND Estacion = @Estacion
GROUP BY Almacen
ORDER BY Almacen
UPDATE @TablaRet SET NodoNombre = @NoEspecificado
WHERE LTRIM(RTRIM(ISNULL(NodoNombre,''))) = ''
SELECT NodoNombre,NodoPadre FROM @TablaRet ORDER BY IDR
SET NOCOUNT OFF
END

