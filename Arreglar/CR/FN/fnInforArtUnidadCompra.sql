SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnInforArtUnidadCompra (@Articulo varchar(20))
RETURNS varchar(50)

AS BEGIN
DECLARE
@Resultado                                     varchar(50),
@Unidad                     varchar(50)
SELECT @Unidad = ISNULL(NULLIF(UnidadCompra,''),Unidad) FROM Art WHERE Articulo = @Articulo
RETURN(@Unidad)
END

