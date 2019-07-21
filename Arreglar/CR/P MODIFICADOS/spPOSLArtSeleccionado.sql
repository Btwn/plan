SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSLArtSeleccionado
@ID				varchar(50),
@Articulo		varchar(20),
@SubCuenta		varchar(50),
@Unidad			varchar(50),
@Codigo			varchar(30) = NULL

AS
BEGIN
IF NOT EXISTS(SELECT 1 FROM POSLArtSeleccionado pal WITH (NOLOCK) WHERE pal.ID = @ID)
INSERT POSLArtSeleccionado (
ID,  Articulo,  SubCuenta, Unidad, Codigo)
VALUES (
@ID, @Articulo, @SubCuenta, @Unidad, @Codigo)
ELSE
UPDATE POSLArtSeleccionado
SET Articulo = @Articulo, SubCuenta = @SubCuenta, Unidad = @Unidad, Codigo = @Codigo
WHERE ID = @ID
END

