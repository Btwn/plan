SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAutoSurtirTarima
@Estacion	int,
@Empresa	varchar(5),
@Modulo		varchar(5),
@ModuloID	int,
@Mov		varchar(20),
@MovID		varchar(20),
@Almacen	varchar(10),
@Conexion	bit		= 0,
@Ok		int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Articulo		varchar(20),
@SubCuenta		varchar(50),
@Unidad		varchar(50),
@Cantidad		float
IF @Estacion IS NULL SELECT @Estacion = -@@SPID
IF @Modulo = 'VTAS'
DECLARE crAutoSurtirTarima CURSOR LOCAL FOR
SELECT Articulo, NULLIF(RTRIM(SubCuenta), ''), NULLIF(RTRIM(Unidad), ''), SUM(Cantidad)
FROM VentaD
WHERE ID = @ModuloID AND NULLIF(RTRIM(Tarima), '') IS NULL
GROUP BY Articulo, NULLIF(RTRIM(SubCuenta), ''), NULLIF(RTRIM(Unidad), '')
ELSE IF @Modulo = 'INV'
DECLARE crAutoSurtirTarima CURSOR LOCAL FOR
SELECT Articulo, NULLIF(RTRIM(SubCuenta), ''), NULLIF(RTRIM(Unidad), ''), SUM(Cantidad)
FROM InvD
WHERE ID = @ModuloID AND NULLIF(RTRIM(Tarima), '') IS NULL
GROUP BY Articulo, NULLIF(RTRIM(SubCuenta), ''), NULLIF(RTRIM(Unidad), '')
ELSE IF @Modulo = 'COMS'
DECLARE crAutoSurtirTarima CURSOR LOCAL FOR
SELECT Articulo, NULLIF(RTRIM(SubCuenta), ''), NULLIF(RTRIM(Unidad), ''), SUM(Cantidad)
FROM CompraD
WHERE ID = @ModuloID AND NULLIF(RTRIM(Tarima), '') IS NULL
GROUP BY Articulo, NULLIF(RTRIM(SubCuenta), ''), NULLIF(RTRIM(Unidad), '')
ELSE IF @Modulo = 'PROD'
DECLARE crAutoSurtirTarima CURSOR LOCAL FOR
SELECT Articulo, NULLIF(RTRIM(SubCuenta), ''), NULLIF(RTRIM(Unidad), ''), SUM(Cantidad)
FROM ProdD
WHERE ID = @ModuloID AND NULLIF(RTRIM(Tarima), '') IS NULL
GROUP BY Articulo, NULLIF(RTRIM(SubCuenta), ''), NULLIF(RTRIM(Unidad), '')
OPEN crAutoSurtirTarima
FETCH NEXT FROM crAutoSurtirTarima INTO @Articulo, @SubCuenta, @Unidad, @Cantidad
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2 AND NULLIF(@Cantidad, 0.0) IS NOT NULL
BEGIN
DELETE SurtirTarimaMov WHERE Estacion = @Estacion
INSERT SurtirTarimaMov (
Estacion,  Almacen,  Posicion, Tarima, Articulo,  SubCuenta,  Cantidad, Unidad)
SELECT @Estacion, @Almacen, Posicion, Tarima, @Articulo, @SubCuenta, Cantidad, @Unidad
FROM dbo.fnAutoSurtirTarima(@Empresa, @Almacen, @Articulo, @SubCuenta, @Cantidad, @Unidad)
EXEC spSurtirTarima @Estacion, @Empresa, @Modulo, @ModuloID, @Mov, @MovID, 'ACEPTAR', @Conexion
END
FETCH NEXT FROM crAutoSurtirTarima INTO @Articulo, @SubCuenta, @Unidad, @Cantidad
END
CLOSE crAutoSurtirTarima
DEALLOCATE crAutoSurtirTarima
RETURN
END

