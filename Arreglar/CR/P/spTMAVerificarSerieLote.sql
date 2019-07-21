SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spTMAVerificarSerieLote
@Empresa		varchar(5),
@Sucursal		int,
@ID				int,
@Ok				int				OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS
BEGIN
DECLARE @Renglon			float,
@RenglonAnt		float,
@Articulo			varchar(20),
@SubCuenta		varchar(50),
@Tarima			varchar(20),
@CantidadPck		float,
@CantidadPckSerie	float,
@CantidadSerieMov	float,
@CantidadSerie	float,
@Almacen			varchar(10),
@SerieLote		varchar(50),
@SerieLoteAnt		varchar(50),
@MovTipo		    varchar(20)
SELECT @MovTipo = Clave FROM MovTipo JOIN TMA ON MovTipo.Mov = TMA.Mov AND MovTipo.Modulo = 'TMA' WHERE ID = @ID
SELECT @RenglonAnt = ''
WHILE(1=1)
BEGIN
SELECT @Renglon = MIN(Renglon)
FROM TMAD
JOIN Art ON TMAD.Articulo = Art.Articulo AND Art.Tipo IN('SERIE','LOTE','VIN','PARTIDA')
WHERE Renglon > @RenglonAnt
AND ID = @ID
IF @Renglon IS NULL BREAK
SELECT @RenglonAnt = @Renglon, @Articulo = NULL, @SubCuenta = NULL, @Tarima = NULL, @CantidadPck = NULL, @CantidadSerieMov = NULL, @Almacen = NULL
SELECT @Articulo = Articulo,
@SubCuenta = ISNULL(SubCuenta, ''),
@CantidadPck = CantidadPicking,
@Tarima =CASE CHARINDEX('-', Tarima) WHEN 0 THEN ISNULL(Tarima, '') ELSE SUBSTRING(Tarima, 1, CHARINDEX('-', Tarima)-1) END,
@Almacen = Almacen
FROM TMAD
WHERE ID = @ID
AND Renglon = @Renglon
SELECT @CantidadSerieMov = SUM(Cantidad)
FROM SerieLoteMov
WHERE Modulo = 'TMA'
AND ID = @ID
AND RenglonID = @Renglon
AND Articulo = @Articulo
AND ISNULL(SubCuenta, '') = @SubCuenta
IF ISNULL(@CantidadPck, 0) <> ISNULL(@CantidadSerieMov, 0)
BEGIN
SELECT @Ok = 20330, @OkRef = @Articulo
RETURN
END
SELECT @SerieLoteAnt = ''
WHILE(1=1)
BEGIN
SELECT @SerieLote = MIN(SerieLote)
FROM SerieLoteMov
WHERE Modulo = 'TMA'
AND ID = @ID
AND RenglonID = @Renglon
AND Articulo = @Articulo
AND ISNULL(SubCuenta, '') = @SubCuenta
AND SerieLote > @SerieLoteAnt
IF @SerieLote IS NULL BREAK
SELECT @SerieLoteAnt = @SerieLote, @CantidadPckSerie = NULL, @CantidadSerie = NULL
SELECT @CantidadPckSerie = SUM(Cantidad)
FROM SerieLoteMov
WHERE Modulo = 'TMA'
AND ID = @ID
AND RenglonID = @Renglon
AND Articulo = @Articulo
AND ISNULL(SubCuenta, '') = @SubCuenta
AND SerieLote = @SerieLote
SELECT @CantidadSerie = SUM(Existencia)
FROM SerieLote
WHERE Articulo = @Articulo
AND ISNULL(SubCuenta, '') = @SubCuenta
AND SerieLote = @SerieLote
AND Almacen = @Almacen
AND Tarima = @Tarima
AND Sucursal = @Sucursal
AND Empresa = @Empresa
IF ISNULL(@CantidadPckSerie, 0) > ISNULL(@CantidadSerie, 0)
BEGIN
SELECT @Ok = 20510, @OkRef = @Articulo + ' - ' + @SerieLote
RETURN
END
END
END
RETURN
END

