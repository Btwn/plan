SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTMAAcomodar
@ID			int,
@Accion		varchar(20),
@Empresa		varchar(5),
@Usuario		varchar(10),
@Modulo	      	varchar(5),
@Mov	  	varchar(20),
@MovID             	varchar(20),
@MovTipo     	varchar(20),
@FechaEmision      	datetime,
@FechaRegistro    	datetime,
@TarimaNueva	varchar(20),
@Almacen		varchar(10),
@PosicionAnterior	varchar(10),
@PosicionNueva	varchar(10),
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Brincar			bit,
@TarimaAnterior		varchar(20),
@TarimaAnteriorEstatus	varchar(20)
DECLARE crTMAAcomodar CURSOR LOCAL FOR
SELECT Tarima, Estatus
FROM Tarima
WHERE Posicion = @PosicionNueva AND Almacen = @Almacen AND Estatus <> 'BAJA'
OPEN crTMAAcomodar
FETCH NEXT FROM crTMAAcomodar INTO @TarimaAnterior, @TarimaAnteriorEstatus
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND dbo.fnTarimaEstaVacia(@Empresa, @TarimaAnterior) = 0
BEGIN
SELECT @Brincar = 0
IF @Accion <> 'CANCELAR'
BEGIN
IF dbo.fnTarimaEstaVacia(@Empresa, @TarimaAnterior) = 1
SELECT @Brincar = 1
ELSE
IF dbo.fnTarimaEnPuntoReorden (@Empresa, @Almacen, @TarimaAnterior, dbo.fnArticuloEnTarima(@Empresa, @TarimaAnterior)) = 0
SELECT @Brincar = 1
END
IF @Brincar = 0
EXEC spTraspasarTarima 'TMA', @ID, @Accion, @Empresa, @Usuario, @Mov, @MovID, @MovTipo, @FechaEmision, @TarimaNueva, @TarimaAnterior, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion = 'CANCELAR'
UPDATE Tarima SET Estatus = 'ALTA', Alta = @FechaRegistro WHERE Tarima = @TarimaAnterior
END
FETCH NEXT FROM crTMAAcomodar INTO @TarimaAnterior, @TarimaAnteriorEstatus
END
CLOSE crTMAAcomodar
DEALLOCATE crTMAAcomodar
IF @Accion = 'CANCELAR'
UPDATE Tarima SET Posicion = @PosicionAnterior WHERE Tarima = @TarimaNueva
ELSE
UPDATE Tarima SET Posicion = @PosicionNueva WHERE Tarima = @TarimaNueva
RETURN
END

