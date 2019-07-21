SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spReconstruirSerieLoteMov
@Empresa                      char(5),
@Modulo                       varchar(5),
@ModuloID                     int,
@Ok                           int = NULL OUTPUT,
@OkRef                        varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Articulo                     varchar(20),
@SubCuenta                    varchar(50),
@RenglonID                    int,
@SerieLote                    varchar(50),
@Cantidad                     float,
@CantidadD                    float,
@TotalRenglon                float,
@Procesado                    bit,
@idx                          int,
@k                            int
SET @Empresa    = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Modulo     = LTRIM(RTRIM(ISNULL(@Modulo,'')))
SET @ModuloID   = LTRIM(RTRIM(ISNULL(@ModuloID,'')))
SET @Procesado  = 0
SET @RenglonID  = 0
DECLARE @TablaD table (
IDX                         int IDENTITY (1,1),
Renglon                     float,
RenglonSub                  int,
RenglonID                   int,
RenglonTipo                 char(1),
Cantidad                    float,
Articulo                    varchar(20),
SubCuenta                   varchar(50)
)
DECLARE @SerieLoteMov Table(
IDX                         int IDENTITY (1,1),
Empresa                     varchar(5),
Modulo                      varchar(5),
ID                          int,
RenglonID                   int,
RenglonID2                  int,
Articulo                    varchar(20),
SubCuenta                   varchar(50),
SerieLote                   varchar(50),
Cantidad                    float,
CantidadAlterna             float,
Propiedades                 varchar(20),
Ubicacion                   int,
Cliente                     varchar(10),
Localizacion                varchar(10),
Sucursal                    int,
ArtCostoInv                 money,
Tarima                      varchar(20),
AsignacionUbicacion         bit,
Procesado                   bit
)
BEGIN TRY
INSERT INTO @TablaD(Renglon,RenglonSub,RenglonID,RenglonTipo,Cantidad,Articulo,SubCuenta)
SELECT Renglon,
RenglonSub,
RenglonID,
RenglonTipo,
Cantidad,
LTRIM(RTRIM(ISNULL(Articulo,''))),
LTRIM(RTRIM(ISNULL(SubCuenta,'')))
FROM CompraD
WHERE ID = @ModuloID
AND RenglonTipo IN ('L','S')
INSERT INTO @SerieLoteMov (Empresa,Modulo,ID,RenglonID,Articulo,SubCuenta,SerieLote,Cantidad,CantidadAlterna,Propiedades,Ubicacion,Cliente,Localizacion,Sucursal,ArtCostoInv,Tarima,AsignacionUbicacion)
SELECT Empresa,
Modulo,
ID,
RenglonID,
LTRIM(RTRIM(ISNULL(Articulo,''))),
LTRIM(RTRIM(ISNULL(SubCuenta,''))),
LTRIM(RTRIM(ISNULL(SerieLote,''))),
ISNULL(Cantidad,0),
CantidadAlterna,
Propiedades,
Ubicacion,
Cliente,
Localizacion,
Sucursal,
ArtCostoInv,
Tarima,
AsignacionUbicacion
FROM SerieLoteMov
WHERE Empresa = @Empresa
AND Modulo = @Modulo
AND ID = @ModuloID
SELECT @k = MAX(IDX) FROM @SerieLoteMov
SET @k = ISNULL(@k,0)
SET @idx = 0
WHILE @idx < @k
BEGIN
SET @idx = @idx + 1  
SELECT @RenglonID = RenglonID, @SerieLote = SerieLote, @Articulo = Articulo, @SubCuenta = SubCuenta, @Procesado = ISNULL(Procesado,0)
FROM @SerieLoteMov
WHERE IDX = @idx
IF @Procesado = 0
BEGIN
UPDATE @SerieLoteMov
SET RenglonID2 = @RenglonID,
Procesado = 1
WHERE Articulo = @Articulo
AND SubCuenta = @SubCuenta
IF (SELECT COUNT(SerieLote) FROM @SerieLoteMov WHERE Articulo = @Articulo  AND SubCuenta = @SubCuenta AND SerieLote = @SerieLote) > 1
BEGIN
SELECT @Cantidad = SUM(Cantidad) FROM @SerieLoteMov WHERE Articulo = @Articulo  AND SubCuenta = @SubCuenta AND SerieLote = @SerieLote
UPDATE @SerieLoteMov SET Cantidad = @Cantidad WHERE IDX = @idx
UPDATE @SerieLoteMov SET Cantidad = 0, Procesado = 1
WHERE IDX > @idx
AND RenglonID2 = @RenglonID
AND Articulo = @Articulo
AND SubCuenta = @SubCuenta
AND SerieLote = @SerieLote
END
END
END
SELECT @k = MAX(IDX) FROM @TablaD
SET @k = ISNULL(@k,0)
SET @Ok = NULL
SET @idx = 0
WHILE @idx < @k AND @Ok IS NULL
BEGIN
SET @idx = @idx + 1
SELECT @RenglonID = RenglonID,
@CantidadD = Cantidad
FROM @TablaD WHERE IDX = @idx
SELECT @TotalRenglon = SUM(Cantidad)
FROM @SerieLoteMov
WHERE RenglonID2 = @RenglonID
IF @TotalRenglon <> @CantidadD SET @OK = 20330
END
DELETE SerieLoteMov WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ModuloID
INSERT INTO SerieLoteMov(Empresa,Modulo,ID,RenglonID,Articulo,SubCuenta,SerieLote,Cantidad,CantidadAlterna,Propiedades,Ubicacion,Cliente,Localizacion,Sucursal,ArtCostoInv,Tarima,AsignacionUbicacion)
SELECT Empresa,Modulo,ID,RenglonID2,Articulo,SubCuenta,SerieLote,Cantidad,CantidadAlterna,Propiedades,Ubicacion,Cliente,Localizacion,Sucursal,ArtCostoInv,Tarima,AsignacionUbicacion
FROM @SerieLoteMov
WHERE Procesado = 1
AND Cantidad > 0
ORDER BY RenglonID2, SerieLote
END TRY
BEGIN CATCH
SET @OK = 1
SET @OkRef = LEFT(LTRIM(RTRIM(ERROR_MESSAGE())),255)
END CATCH
END

