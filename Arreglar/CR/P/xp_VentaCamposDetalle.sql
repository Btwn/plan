SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xp_VentaCamposDetalle
@CodigosNumericos	bit,
@ZonaImpuesto		varchar(30),
@Campo			varchar(50),
@Dato			varchar(100),
@Articulo		char(20)	OUTPUT,
@SubCuenta		varchar(20)	OUTPUT,
@Unidad			varchar(50)	OUTPUT,
@Almacen		char(10)	OUTPUT,
@DescripcionExtra	varchar(100)	OUTPUT,
@SustitutoArticulo  	varchar(20)	OUTPUT,
@SustitutoSubCuenta	varchar(20)	OUTPUT,
@Instruccion		varchar(50)	OUTPUT,
@Agente 		char(10)	OUTPUT,
@Paquete		int		OUTPUT,
@Departamento		int		OUTPUT,
@FechaRequerida		datetime	OUTPUT,
@Veces			float		OUTPUT,
@Cantidad		float		OUTPUT,
@CantidadInventario	float		OUTPUT,
@Factor			float		OUTPUT,
@Precio			money		OUTPUT,
@DescuentoLinea		money		OUTPUT,
@Costo			money		OUTPUT,
@Impuesto1		float		OUTPUT,
@Impuesto2		float		OUTPUT,
@Impuesto3		money		OUTPUT,
@ArtTipo		varchar(20)	OUTPUT,
@RenglonTipo		char(1)		OUTPUT,
@Ok			int		OUTPUT,
@OkRef			varchar(255)	OUTPUT
AS BEGIN
DECLARE
@UltArticulo	char(20)
SELECT @UltArticulo = @Articulo
IF @Campo = 'Articulo' 		SELECT @Articulo           = @Dato ELSE
IF @Campo = 'SubCuenta' 		SELECT @SubCuenta          = @Dato ELSE
IF @Campo = 'Unidad'			SELECT @Unidad             = @Dato ELSE
IF @Campo = 'Almacen' 		SELECT @Almacen            = @Dato ELSE
IF @Campo = 'DescripcionExtra'	SELECT @DescripcionExtra   = @Dato ELSE
IF @Campo = 'SustitutoArticulo' 	SELECT @SustitutoArticulo  = @Dato ELSE
IF @Campo = 'SustitutoSubCuenta' 	SELECT @SustitutoSubCuenta = @Dato ELSE
IF @Campo = 'Instruccion'      	SELECT @Instruccion        = @Dato ELSE
IF @Campo = 'Agente'           	SELECT @Agente             = @Dato ELSE
IF @Campo = 'Paquete'			SELECT @Paquete            = CONVERT(int, @Dato) ELSE
IF @Campo = 'Departamento' 	        SELECT @Departamento 	   = CONVERT(int, @Dato) ELSE
IF @Campo = 'FechaRequerida'        	SELECT @FechaRequerida     = CONVERT(datetime, @Dato, 103) ELSE
IF @Campo = 'Cantidad' 		SELECT @Cantidad           = CONVERT(float, @Dato) ELSE
IF @Campo = 'CantidadInventario' 	SELECT @CantidadInventario = CONVERT(float, @Dato) ELSE
IF @Campo = 'Factor' 			SELECT @Factor             = CONVERT(float, @Dato) ELSE
IF @Campo = 'Precio'   		SELECT @Precio             = CONVERT(money, @Dato) ELSE
IF @Campo = 'DescuentoLinea'		SELECT @DescuentoLinea     = CONVERT(money, @Dato) ELSE
IF @Campo = 'Costo'   		SELECT @Costo              = CONVERT(money, @Dato) ELSE
IF @Campo = 'Codigo'
BEGIN
IF @CodigosNumericos = 0 OR dbo.fnEsNumerico(@Dato) = 1
EXEC xp_ValidarCodigoBarras @Dato, @Articulo OUTPUT, @SubCuenta OUTPUT, @Unidad OUTPUT, @Veces OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Articulo <> @UltArticulo
EXEC xp_ValidarArticulo @Articulo, @SubCuenta, @ZonaImpuesto, @ArtTipo OUTPUT, @RenglonTipo OUTPUT, @Impuesto1 OUTPUT, @Impuesto2 OUTPUT, @Impuesto3 OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

