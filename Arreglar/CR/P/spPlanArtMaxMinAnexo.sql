SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPlanArtMaxMinAnexo
@Empresa         varchar(5),
@Sucursal        int,
@Usuario         varchar(10),
@Estacion        int

AS
BEGIN
SET NOCOUNT ON
DECLARE @Rama           varchar(5)
DECLARE @Nombre         varchar(255)
DECLARE @Tipo           varchar(10)
DECLARE @TablaTmp table(
Articulo              varchar(20)   NULL
)
SET @Empresa           = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Sucursal          = ISNULL(@Sucursal,0)
SET @Usuario           = LTRIM(RTRIM(ISNULL(@Usuario,'')))
SET @Estacion          = ISNULL(@Estacion,0)
SET @Rama     = 'INV'
SET @Nombre   = 'FOTO'
SET @Tipo     = 'IMAGEN'
INSERT INTO @TablaTmp (Articulo)
SELECT Articulo
FROM PlanArtMaxMin
WHERE Empresa = @Empresa
AND Usuario = @Usuario
GROUP BY Articulo
ORDER BY Articulo
SELECT t.Articulo,a.Direccion
FROM @TablaTmp t
JOIN AnexoCta a ON (t.Articulo = a.Cuenta)
WHERE a.Rama = @Rama
AND a.Nombre = @Nombre
AND a.Tipo = @Tipo
ORDER BY a.Cuenta
SET NOCOUNT OFF
END

