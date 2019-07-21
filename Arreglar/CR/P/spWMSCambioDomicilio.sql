SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spWMSCambioDomicilio
@Almacen			varchar(10),
@PosicionActual		varchar(10),
@PosicionNueva		varchar(10)

AS
BEGIN
DECLARE @Articulo			varchar(20),
@ArticuloEsp		varchar(20),
@Ok				int,
@OkRef			varchar(255),
@Tarima			varchar(20),
@TipoActual		varchar(20),
@TipoDestino		varchar(20)
BEGIN TRANSACTION
SELECT @ArticuloEsp = ISNULL(ArticuloEsp, ''), @TipoDestino = Tipo FROM AlmPos WHERE Almacen = @Almacen AND Posicion = @PosicionNueva
SELECT @Articulo = ISNULL(ArticuloEsp, ''), @TipoActual = Tipo  FROM AlmPos WHERE Almacen = @Almacen AND Posicion = @PosicionActual
IF @Ok IS NULL AND ISNULL(RTRIM(@PosicionActual), '') = ''
SELECT @Ok = 1, @OkRef = 'Favor de Especificar el Domicilio Origen'
IF @Ok IS NULL AND ISNULL(RTRIM(@PosicionNueva), '') = ''
SELECT @Ok = 1, @OkRef = 'Favor de Especificar el Domicilio Destino'
IF @Ok IS NULL AND @ArticuloEsp <> '' AND @ArticuloEsp <> @Articulo
SELECT @Ok = 1, @OkRef = 'El Domicilio Destino(' + ISNULL(@PosicionNueva, '')+') esta reservado para el Artículo ' + @ArticuloEsp
IF @Ok IS NULL AND @TipoActual <> 'Domicilio'
SELECT @Ok = 1, @OkRef = 'La Posición Origen no es Domicilio'
IF @Ok IS NULL AND @TipoDestino <> 'Domicilio'
SELECT @Ok = 1, @OkRef = 'La Posición Destino no es Domicilio'
IF @Ok IS NULL AND @PosicionActual = @PosicionNueva
SELECT @Ok = 1, @OkRef = 'La Posición Destino es igual a la Posición Origen'
IF @Ok IS NULL
BEGIN
UPDATE AlmPos SET CambioDomicilios = 1 WHERE Almacen = @Almacen AND Posicion IN(@PosicionActual, @PosicionNueva)
UPDATE Tarima SET Posicion = @PosicionNueva WHERE Almacen = @Almacen AND Posicion = @PosicionActual
UPDATE AlmPos SET ArticuloEsp = @Articulo WHERE Almacen = @Almacen AND Posicion = @PosicionNueva
UPDATE AlmPos SET ArticuloEsp = NULL WHERE Almacen = @Almacen AND Posicion = @PosicionActual
UPDATE AlmPos SET CambioDomicilios = NULL WHERE Almacen = @Almacen AND Posicion IN(@PosicionActual, @PosicionNueva)
END
IF @Ok IS NULL
BEGIN
SELECT 'Proceso Concluido'
COMMIT TRANSACTION
END
ELSE
BEGIN
SELECT @OkRef
ROLLBACK TRANSACTION
END
RETURN
END

