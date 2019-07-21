SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tginvArtUbicaciones ON invArtUbicaciones

FOR INSERT, UPDATE
AS BEGIN
DECLARE
@Ok				int,
@cantidadA		float ,
@existencia		float,
@Articulo		char(20),
@Almacen		varchar(10),
@Posicion		varchar(10),
@Mensaje		varchar(80),
@Subcuenta		varchar(50),
@SerieLote		varchar(50),
@Unidad			varchar(50),
@PosicionDestino varchar(10)
SELECT @cantidadA=cantidadA,@Articulo = Articulo, @Almacen = Almacen, @Posicion = posicion, @Subcuenta = Subcuenta, @SerieLote = SerieLote, @Unidad = Unidad,@PosicionDestino=PosicionDestino FROM Inserted
SELECT @existencia=existencia  FROM ExistenciaAlternaPosicionSerieLote WHERE  Articulo=@Articulo and Almacen =@Almacen and posicion =@Posicion AND ISNULL(Subcuenta,'') = ISNULL(@Subcuenta,'') AND SerieLote = @SerieLote AND Unidad = @Unidad
IF UPDATE(CantidadA)
IF @cantidadA>@existencia
BEGIN
SELECT @Mensaje='La Cantidad a cambiar es mayor a la existencia '
RAISERROR (@Mensaje,16,-1)
END
IF UPDATE(PosicionDestino) AND @PosicionDestino IS NOT NULL
IF NOT EXISTS(SELECT Posicion FROM AlmPos WHERE Posicion = @PosicionDestino  AND Almacen =@Almacen )
BEGIN
SELECT @Mensaje='La Posición capturada no existe dentro del Almacén '
RAISERROR (@Mensaje,16,-1)
END
END

