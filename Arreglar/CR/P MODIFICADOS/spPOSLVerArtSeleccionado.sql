SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSLVerArtSeleccionado
@ID					varchar(50),
@Articulo			varchar(20)	OUTPUT,
@SubCuenta			varchar(50)	OUTPUT,
@CantidadOriginal	float		OUTPUT,
@Unidad				varchar(50)	OUTPUT,
@Codigo				varchar(30)	OUTPUT

AS
BEGIN
SELECT
@Articulo	=	Articulo,
@SubCuenta =	SubCuenta,
@Unidad    =	Unidad,
@Codigo	=	Codigo
FROM POSLArtSeleccionado pal WITH (NOLOCK)
WHERE pal.ID = @ID
SELECT @CantidadOriginal = SUM(Cantidad)
FROM POSLVenta pl WITH (NOLOCK)
WHERE pl.ID = @ID
AND pl.Articulo = @Articulo
AND ISNULL(pl.SubCuenta,'') = ISNULL(@SubCuenta,'')
AND pl.Unidad = @Unidad
END

