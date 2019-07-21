SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnWMSEnSurtidoACancelar (@Tarima varchar(20), @Articulo varchar(20), @CantidadACancelar float)
RETURNS @Tabla TABLE (
ID					int,
Mov					varchar(20),
MovID				varchar(20),
Articulo			varchar(20),
Cantidad			float,
Almacen				varchar(10),
Tipo				varchar(20),
Tarima				varchar(20),
PCK					float,
CantidadAfectar		float,
Renglon				int
)
AS BEGIN
DECLARE
@WMSID					int,
@WMSMov					varchar(20),
@WMSMovID				varchar(20),
@WMSArticulo			varchar(20),
@WMSCantidad			float,
@WMSAlmacen				varchar(10),
@WMSTipo				varchar(20),
@WMSTarima				varchar(20),
@IDGenerar				int,
@MovGenerar				varchar(20),
@PCK					float,
@WMSRenglon				int
DECLARE crResurtido CURSOR LOCAL FOR
SELECT ID, Mov, MovID, Articulo, Cantidad, Almacen, Tipo, Tarima, PCK, Renglon
FROM dbo.fnWMSEnSurtido(@Tarima, @Articulo)
ORDER BY Tipo, Cantidad
OPEN crResurtido
FETCH NEXT FROM crResurtido INTO @WMSID, @WMSMov, @WMSMovID, @WMSArticulo, @WMSCantidad, @WMSAlmacen, @WMSTipo, @WMSTarima, @PCK, @WMSRenglon
WHILE @@FETCH_STATUS = 0 AND @CantidadACancelar > 0
BEGIN
INSERT INTO @Tabla
SELECT @WMSID, @WMSMov, @WMSMovID, @WMSArticulo, @WMSCantidad, @WMSAlmacen, @WMSTipo, @WMSTarima, @PCK, CASE WHEN @CantidadACancelar > @WMSCantidad THEN @WMSCantidad ELSE @CantidadACancelar END, @WMSRenglon
SELECT @CantidadACancelar = @CantidadACancelar - @WMSCantidad
FETCH NEXT FROM crResurtido INTO @WMSID, @WMSMov, @WMSMovID, @WMSArticulo, @WMSCantidad, @WMSAlmacen, @WMSTipo, @WMSTarima, @PCK, @WMSRenglon
END
CLOSE crResurtido
DEALLOCATE crResurtido
DELETE @Tabla WHERE CantidadAfectar <= 0
RETURN
END

