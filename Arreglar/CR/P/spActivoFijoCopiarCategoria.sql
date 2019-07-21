SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spActivoFijoCopiarCategoria
@Sucursal		int,
@Empresa		char(5),
@ID  			int,
@MovTipo		char(20),
@MovMoneda		char(10),
@FechaEmision	datetime,
@Categoria		varchar(50),
@Ok				int			OUTPUT,
@SubClave		varchar(20) = NULL,
@SubClaveFiscal	int			= NULL

AS BEGIN
DECLARE
@Articulo	char(20),
@Serie		varchar(50),
@Renglon	float
SELECT @Renglon = ISNULL(MAX(Renglon) + 2048, 2048) FROM ActivoFijoD WHERE ID = @ID
IF @MovTipo = 'AF.DP'
BEGIN
IF @SubClaveFiscal = 1
DECLARE crActivoFijoTodo CURSOR FOR
SELECT NULLIF(RTRIM(af.Articulo), ''), NULLIF(RTRIM(af.Serie), '')
FROM ActivoF af
JOIN ActivoFCat cat ON af.Categoria = cat.Categoria AND cat.Propietario = 'Empresa'
WHERE af.Empresa = @Empresa AND af.Estatus <> 'INACTIVO' AND af.Moneda = @MovMoneda AND (ISNULL(af.VidaUtilF, 0) - ISNULL(af.DepreciacionMesesF, 0) > 0)
AND af.DepreciacionInicioF <= @FechaEmision
AND (DATEPART(MONTH,ISNULL(af.DepreciacionUltimaF,0)) < DATEPART(MONTH, @FechaEmision) OR DATEPART(YEAR,ISNULL(af.DepreciacionUltimaF,0)) < DATEPART(YEAR, @FechaEmision))
AND af.Categoria		= @Categoria
ELSE
IF @SubClaveFiscal = 2
DECLARE crActivoFijoTodo CURSOR FOR
SELECT NULLIF(RTRIM(af.Articulo), ''), NULLIF(RTRIM(af.Serie), '')
FROM ActivoF af
JOIN ActivoFCat cat ON af.Categoria = cat.Categoria AND cat.Propietario = 'Empresa'
WHERE af.Empresa = @Empresa AND af.Estatus <> 'INACTIVO' AND af.Moneda = @MovMoneda AND (ISNULL(af.VidaUtilF2, 0) - ISNULL(af.DepreciacionMesesF2, 0) > 0)
AND af.DepreciacionInicioF2 <= @FechaEmision
AND (DATEPART(MONTH,ISNULL(af.DepreciacionUltimaF2,0)) < DATEPART(MONTH, @FechaEmision) OR DATEPART(YEAR,ISNULL(af.DepreciacionUltimaF2,0)) < DATEPART(YEAR, @FechaEmision))
AND af.Categoria		= @Categoria
ELSE
BEGIN
DECLARE crActivoFijoTodo CURSOR FOR
SELECT NULLIF(RTRIM(af.Articulo), ''), NULLIF(RTRIM(af.Serie), '')
FROM ActivoF af
JOIN ActivoFCat cat ON af.Categoria = cat.Categoria AND cat.Propietario = 'Empresa'
WHERE af.Empresa = @Empresa AND af.Estatus <> 'INACTIVO' AND af.Moneda = @MovMoneda AND (ISNULL(af.VidaUtil, 0) - ISNULL(af.DepreciacionMeses, 0) > 0)
AND af.DepreciacionInicio <= @FechaEmision
AND (DATEPART(MONTH,ISNULL(af.DepreciacionUltima,0)) < DATEPART(MONTH, @FechaEmision) OR DATEPART(YEAR,ISNULL(af.DepreciacionUltima,0)) < DATEPART(YEAR, @FechaEmision))
AND af.Categoria		= @Categoria
END
END ELSE
DECLARE crActivoFijoTodo CURSOR FOR
SELECT NULLIF(RTRIM(Articulo), ''), NULLIF(RTRIM(Serie), '')
FROM ActivoF
WHERE Empresa = @Empresa
AND Estatus <> 'INACTIVO'
AND Moneda = @MovMoneda
AND Categoria		= @Categoria
OPEN crActivoFijoTodo
FETCH NEXT FROM crActivoFijoTodo INTO @Articulo, @Serie
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Renglon = @Renglon + 2048
INSERT ActivoFijoD (Sucursal, ID, Renglon, RenglonSub, Articulo, Serie)
VALUES (@Sucursal, @ID, @Renglon, 0, @Articulo, @Serie)
END
FETCH NEXT FROM crActivoFijoTodo INTO @Articulo, @Serie
IF @@ERROR <> 0 SELECT @Ok = 1
END  
CLOSE crActivoFijoTodo
DEALLOCATE crActivoFijoTodo
RETURN
END

