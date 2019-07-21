SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvVerificarTarima
@ID               		int,
@Accion			varchar(20),
@Empresa          		varchar(5),
@Sucursal			int,
@Usuario			varchar(10),
@Ok               		int           	OUTPUT,
@OkRef            		varchar(255)  	OUTPUT

AS BEGIN
DECLARE
@Almacen	varchar(10),
@Articulo	varchar(20),
@SubCuenta	varchar(50),
@Unidad	varchar(50),
@Cantidad	float,
@CantidadN	float
DECLARE crVerificarTarima CURSOR FOR
SELECT Almacen, Articulo, ISNULL(RTRIM(SubCuenta), ''), ISNULL(RTRIM(Unidad), ''), SUM(ISNULL(CantidadInventario,Cantidad)) 
FROM InvD WITH(NOLOCK)
WHERE ID = @ID AND Seccion IS NULL
GROUP BY Almacen, Articulo, ISNULL(RTRIM(SubCuenta), ''), ISNULL(RTRIM(Unidad), '')
OPEN crVerificarTarima
FETCH NEXT FROM crVerificarTarima INTO @Almacen, @Articulo, @SubCuenta, @Unidad, @Cantidad
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @CantidadN = NULL
SELECT @CantidadN = SUM(Cantidad)
FROM InvD WITH(NOLOCK)
WHERE ID = @ID AND Seccion = 1
AND Almacen = @Almacen AND Articulo = @Articulo AND ISNULL(RTRIM(SubCuenta), '') = @SubCuenta AND ISNULL(RTRIM(Unidad), '') = @Unidad
IF ROUND(ISNULL(@Cantidad, 0.0), 3) <> ROUND(ISNULL(@CantidadN, 0.0), 3) SELECT @Ok = 13150, @OkRef = @Articulo+' '+@SubCuenta 
END
FETCH NEXT FROM crVerificarTarima INTO @Almacen, @Articulo, @SubCuenta, @Unidad, @Cantidad
END
CLOSE crVerificarTarima
DEALLOCATE crVerificarTarima
RETURN
END

