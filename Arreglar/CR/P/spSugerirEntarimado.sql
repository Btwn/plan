SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSugerirEntarimado
@Modulo			varchar(5),
@ModuloID       int,
@Empresa        varchar(5),
@Sucursal		int,
@Usuario		varchar(10),
@Ok             int           	OUTPUT,
@OkRef          varchar(255)  	OUTPUT

AS BEGIN
DECLARE
@Estacion				int,
@ID						int,
@Mov					varchar(20),
@MovID					varchar(20),
@Articulo				varchar(20),
@Salir					bit,
@Antes					float,
@Despues				float,
@Cantidad				float,
@CantidadA				float,
@CantidadTarima			float,
@Tarima					varchar(20),
@Unidad					varchar(50),
@UnidadTarima			varchar(50),
@NivelFactorMultiUnidad varchar(20) 
BEGIN TRANSACTION
SELECT @NivelFactorMultiUnidad = NivelFactorMultiUnidad FROM EmpresaCfg2 WHERE Empresa = @Empresa 
SELECT @Estacion = -@@SPID
SELECT @Mov = Mov, @MovID = MovID FROM Inv WHERE ID = @ModuloID
EXEC spEntarimar @Estacion, @Empresa, @Modulo, @ModuloID, @Mov, @MovID, 'SUGERIR', @Conexion = 1
SELECT @Salir = 0
WHILE @Salir = 0 AND @Ok IS NULL
BEGIN
SELECT @ID = NULL, @Cantidad = 0.0, @CantidadTarima = 0.0, @CantidadA = 0.0, @Antes = 0.0, @Despues = 0.0
SELECT @Antes = SUM(Cantidad) FROM EntarimarMov WHERE Estacion = @Estacion
SELECT @ID = MIN(ID) FROM EntarimarMov WHERE Estacion = @Estacion AND NULLIF(Cantidad, 0.0) IS NOT NULL
IF @ID IS NOT NULL
BEGIN
SELECT @Articulo = Articulo,
@Unidad = Unidad
FROM EntarimarMov
WHERE Estacion = @Estacion AND ID = @ID
IF EXISTS(SELECT * FROM ArtUnidad WHERE Articulo = @Articulo AND Unidad = @Unidad)
SELECT @Articulo = em.Articulo,
@Cantidad = ISNULL(em.Cantidad, 0.0),
@Unidad = NULLIF(RTRIM(em.Unidad), ''),
@CantidadTarima = ISNULL(u.factor, 1), 
@UnidadTarima = NULLIF(RTRIM(u.Unidad), '')
FROM EntarimarMov em
JOIN Art a ON a.Articulo = em.Articulo
JOIN ArtUnidad u ON u.Articulo = a.Articulo AND em.Unidad = u.Unidad
WHERE em.Estacion = @Estacion AND em.ID = @ID
ELSE
SELECT @Articulo = em.Articulo,
@Cantidad = ISNULL(em.Cantidad, 0.0), @Unidad = NULLIF(RTRIM(em.Unidad), ''),
@CantidadTarima = ISNULL(a.CantidadTarima, 1), 
@UnidadTarima = NULLIF(RTRIM(a.UnidadTarima), '')
FROM EntarimarMov em
JOIN Art a ON a.Articulo = em.Articulo
WHERE em.Estacion = @Estacion AND em.ID = @ID
IF @NivelFactorMultiUnidad = 'Articulo'
SELECT @Cantidad = ISNULL(NULLIF(Factor,0),1) * @Cantidad FROM ArtUnidad WHERE Articulo = @Articulo AND Unidad = @Unidad 
IF @NivelFactorMultiUnidad = 'Unidad'
SELECT @Cantidad = ISNULL(Factor,1) * @Cantidad FROM Unidad WHERE Unidad = @Unidad
IF @NivelFactorMultiUnidad = 'Articulo'
SELECT @CantidadTarima = ISNULL(NULLIF(Factor,0),1) * CantidadCamaTarima FROM ArtUnidad WHERE Articulo = @Articulo AND Unidad = @unidad 
IF @NivelFactorMultiUnidad = 'Unidad'
SELECT @CantidadTarima = ISNULL(u.Factor,1) * a.CantidadCamaTarima FROM Unidad u JOIN ArtUnidad a on  u.Unidad = a.Unidad WHERE  a.Articulo = @Articulo AND u.Unidad = @unidad 
IF @Cantidad > 0
SELECT @Unidad = @UnidadTarima
IF @Cantidad > @CantidadTarima SELECT @CantidadA = @CantidadTarima ELSE SELECT @CantidadA = @Cantidad
IF ISNULL(@Unidad, '') <> ISNULL(ISNULL(@UnidadTarima, @Unidad), '') SELECT @Salir = 1, @Ok = 20130, @OkRef = @Articulo
IF ISNULL(@CantidadA, 0.0) > 0.0 AND @Salir = 0 AND @Ok IS NULL
BEGIN
EXEC spConsecutivo 'Tarima', @Sucursal, @Tarima OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
UPDATE EntarimarMov
SET CantidadA = @CantidadA
WHERE Estacion = @Estacion AND ID = @ID
EXEC spEntarimar @Estacion, @Empresa, @Modulo, @ModuloID, @Mov, @MovID, 'ENTARIMAR', @Tarima, @Conexion = 1
END
END
IF @Salir = 0 AND @Ok IS NULL
BEGIN
SELECT @Despues = SUM(CantidadA) FROM EntarimarMov WHERE Estacion = @Estacion 
IF ISNULL(@Antes, 0.0) = ISNULL(@Despues, 0.0) SELECT @Salir = 1
END
END
IF @Ok IS NULL
EXEC spEntarimar @Estacion, @Empresa, @Modulo, @ModuloID, @Mov, @MovID, 'ACEPTAR', @Conexion = 1
IF @Ok IS NULL
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
RETURN
END

