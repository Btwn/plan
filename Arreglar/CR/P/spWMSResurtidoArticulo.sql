SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSResurtidoArticulo
@Tarima					varchar(20),
@Articulo				varchar(20),
@CantidadACancelar		int,
@Ok						int				OUTPUT,
@OkRef					varchar(255)	OUTPUT

AS BEGIN
DECLARE
@ID					int,
@Tipo				int,
@PCK				float,
@WMSTarima			varchar(20),
@CantidadAfectar	float,
@IDGenerar			int,
@MovGenerar			varchar(20),
@WMSRenglon			int
DECLARE crResurtidoArticulo CURSOR LOCAL FOR
SELECT ID, Articulo, Tipo, Tarima, PCK, CantidadAfectar, Renglon
FROM dbo.fnWMSEnSurtidoACancelar(@Tarima, @Articulo, @CantidadACancelar)
ORDER BY Tipo, Cantidad
OPEN crResurtidoArticulo
FETCH NEXT FROM crResurtidoArticulo INTO @ID, @Articulo, @Tipo, @WMSTarima, @PCK, @CantidadAfectar, @WMSRenglon
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF @Tipo = 1
EXEC spWMSSurtidoPerdidoGenerar @ID, @WMSTarima, @PCK, @CantidadAfectar, @WMSRenglon, @Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Tipo = 2
EXEC spWMSDesentarimadoGenerar @ID, @Tarima, @PCK, @Articulo, @CantidadAfectar, @WMSRenglon, @WMSTarima, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Tipo = 3
SELECT @Ok = 20939
FETCH NEXT FROM crResurtidoArticulo INTO @ID, @Articulo, @Tipo, @WMSTarima, @PCK, @CantidadAfectar, @WMSRenglon
END
CLOSE crResurtidoArticulo
DEALLOCATE crResurtidoArticulo
IF @IDGenerar IS NOT NULL AND @Ok IS NULL
EXEC spWMSDesentarimadoAfectar @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

