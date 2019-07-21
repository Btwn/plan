SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvValidarJuego
@Empresa		char(5),
@Modulo			char(5),
@ID			int,
@Almacen		char(10),
@RenglonID		int,
@Juego			char(20),
@JuegoCantidad		float,
@Ok			int     	OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Componente			char(20),
@Descripcion		varchar(100),
@OpcionCantidad		float,
@CantidadVariable		bit,
@PrecioIndependiente	bit,
@Cantidad			float,
@Precio			float,
@MovTipo		char(20)
SELECT @MovTipo = Clave
FROM Venta v
JOIN MovTipo m ON v.Mov = m.Mov
WHERE v.ID = @ID AND m.Modulo = @Modulo
DECLARE crJuego CURSOR FOR
SELECT j.Juego, j.Descripcion, j.Cantidad, j.CantidadVariable, j.PrecioIndependiente
FROM ArtJuego j
WHERE j.Articulo = @Juego AND j.Opcional = 0
OPEN crJuego
FETCH NEXT FROM crJuego INTO @Componente, @Descripcion, @OpcionCantidad, @CantidadVariable, @PrecioIndependiente
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @Cantidad = NULL, @Precio = NULL
IF @Modulo = 'VTAS' SELECT @Cantidad = d.Cantidad, @Precio = d.Precio FROM ArtJuegoD j, VentaD d  WHERE j.Articulo = @Juego AND j.Juego = @Componente AND d.ID = @ID AND d.RenglonID = @RenglonID AND d.Articulo = j.Opcion AND d.RenglonTipo IN ('C', 'E') ELSE
IF @Modulo = 'INV'  SELECT @Cantidad = d.Cantidad                     FROM ArtJuegoD j, InvD d    WHERE j.Articulo = @Juego AND j.Juego = @Componente AND d.ID = @ID AND d.RenglonID = @RenglonID AND d.Articulo = j.Opcion AND d.RenglonTipo IN ('C', 'E') ELSE
IF @Modulo = 'PROD' SELECT @Cantidad = d.Cantidad                     FROM ArtJuegoD j, ProdD d   WHERE j.Articulo = @Juego AND j.Juego = @Componente AND d.ID = @ID AND d.RenglonID = @RenglonID AND d.Articulo = j.Opcion AND d.RenglonTipo IN ('C', 'E') ELSE
IF @Modulo = 'COMS' SELECT @Cantidad = d.Cantidad                     FROM ArtJuegoD j, CompraD d WHERE j.Articulo = @Juego AND j.Juego = @Componente AND d.ID = @ID AND d.RenglonID = @RenglonID AND d.Articulo = j.Opcion AND d.RenglonTipo IN ('C', 'E')
IF @Modulo = 'VTAS' AND @MovTipo IN ('VTAS.EST', 'VTAS.N','VTAS.NO','VTAS.NR','VTAS.FM') AND @Cantidad < 0.0 SELECT @Cantidad = ABS(@Cantidad)
IF ISNULL(@Cantidad, 0) = 0 SELECT @Ok = 20620 ELSE
IF @CantidadVariable = 0 AND ROUND(@Cantidad, 4) <> ROUND(@JuegoCantidad*@OpcionCantidad, 4) SELECT @OK = 20625 ELSE
IF @Modulo = 'VTAS' AND @PrecioIndependiente = 0 AND ISNULL(@Precio, 0) <> 0 SELECT @OK = 20625
IF @Ok IS NOT NULL SELECT @OkRef = 'Juego: '+RTRIM(@Juego)+', Componente: '+RTRIM(@Descripcion)
END
FETCH NEXT FROM crJuego INTO @Componente, @Descripcion, @OpcionCantidad, @CantidadVariable, @PrecioIndependiente
END
CLOSE crJuego
DEALLOCATE crJuego
RETURN
END

