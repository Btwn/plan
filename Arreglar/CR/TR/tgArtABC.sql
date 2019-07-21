SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgArtABC ON Art

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@Fecha		datetime,
@ClaveNueva  	char(20),
@ClaveAnterior	char(20),
@SituacionNueva	varchar(50),
@SituacionAnterior	varchar(50),
@TipoNuevo		char(20),
@TipoAnterior	char(20),
@MonedaNueva	char(10),
@MonedaAnterior	char(10),
@Precio1A		money,
@Precio1N		money,
@Precio2A		money,
@Precio2N		money,
@Precio3A		money,
@Precio3N		money,
@Precio4A		money,
@Precio4N		money,
@Precio5A		money,
@Precio5N		money,
@Precio6A		money,
@Precio6N		money,
@Precio7A		money,
@Precio7N		money,
@Precio8A		money,
@Precio8N		money,
@Precio9A		money,
@Precio9N		money,
@Precio10A		money,
@Precio10N		money,
@ValidarCodigoN	bit,
@ValidarCodigoA	bit,
@Mensaje 		varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @Fecha = GETDATE()
SELECT @ClaveNueva    = Articulo, @TipoNuevo    = Tipo, @MonedaNueva    = MonedaCosto, @SituacionNueva = Situacion, @ValidarCodigoN = ISNULL(ValidarCodigo, 0),
@Precio1N = PrecioLista, @Precio2N = Precio2, @Precio3N = Precio3, @Precio4N = Precio4, @Precio5N = Precio5, @Precio6N = Precio6, @Precio7N = Precio7, @Precio8N = Precio8, @Precio9N = Precio9, @Precio10N = Precio10
FROM Inserted
SELECT @ClaveAnterior = Articulo, @TipoAnterior = Tipo, @MonedaAnterior = MonedaCosto, @SituacionAnterior = Situacion, @ValidarCodigoA = ISNULL(ValidarCodigo, 0),
@Precio1A = PrecioLista, @Precio2A = Precio2, @Precio3A = Precio3, @Precio4A = Precio4, @Precio5A = Precio5, @Precio6A = Precio6, @Precio7A = Precio7, @Precio8A = Precio8, @Precio9A = Precio9, @Precio10A = Precio10
FROM Deleted
IF @ClaveNueva <> @ClaveAnterior OR @ValidarCodigoN <> @ValidarCodigoA
BEGIN
IF @ValidarCodigoN = 1 AND (SELECT dbo.fnUPCValidar(@ClaveNueva)) = 0
BEGIN
SELECT @Mensaje = '"'+LTRIM(RTRIM(@ClaveAnterior))+ '" ' + Descripcion FROM MensajeLista WHERE Mensaje = 10440
RAISERROR (@Mensaje,16,-1)
END
END
IF @ClaveNueva=@ClaveAnterior AND @TipoNuevo=@TipoAnterior AND @MonedaNueva=@MonedaAnterior AND @SituacionNueva=@SituacionAnterior AND
@Precio1N=@Precio1A AND @Precio2N=@Precio2A AND @Precio3N=@Precio3A AND @Precio4N=@Precio4A AND @Precio5N=@Precio5A AND
@Precio6N=@Precio6A AND @Precio7N=@Precio7A AND @Precio8N=@Precio8A AND @Precio9N=@Precio9A AND @Precio10N=@Precio10A RETURN
IF @ClaveNueva IS NULL
BEGIN
IF EXISTS (SELECT * FROM Art WHERE Rama = @ClaveAnterior) OR
EXISTS (SELECT * FROM ArtMaterial WHERE Material = @ClaveAnterior) OR
EXISTS (SELECT * FROM CompraD WHERE Articulo = @ClaveAnterior)
BEGIN
SELECT @Mensaje = '"'+LTRIM(RTRIM(@ClaveAnterior))+ '" ' + Descripcion FROM MensajeLista WHERE Mensaje = 30167
RAISERROR (@Mensaje,16,-1)
END ELSE
BEGIN
DELETE ArtSub             WHERE Articulo = @ClaveAnterior
DELETE ArtAcceso          WHERE Articulo = @ClaveAnterior
DELETE ArtAnexo           WHERE Articulo = @ClaveAnterior
DELETE ArtLoteFijo	WHERE Articulo = @ClaveAnterior
DELETE ArtActividad	WHERE Articulo = @ClaveAnterior
DELETE ArtPresenta        WHERE Articulo = @ClaveAnterior
DELETE ArtMatriz          WHERE Articulo = @ClaveAnterior
DELETE ArtJuego           WHERE Articulo = @ClaveAnterior
DELETE ArtProv            WHERE Articulo = @ClaveAnterior
DELETE ArtProvSucursal    WHERE Articulo = @ClaveAnterior
DELETE ArtPrecioHist      WHERE Articulo = @ClaveAnterior
DELETE ArtSituacionHist   WHERE Articulo = @ClaveAnterior
DELETE ArtCostoHist       WHERE Articulo = @ClaveAnterior
DELETE ArtSubCostoHist    WHERE Articulo = @ClaveAnterior
DELETE ListaPreciosD      WHERE Articulo = @ClaveAnterior
DELETE ArtIdioma          WHERE Articulo = @ClaveAnterior
DELETE ArtFecha	        WHERE Articulo = @ClaveAnterior
DELETE ArtMaterial        WHERE Articulo = @ClaveAnterior
DELETE ArtMaterial        WHERE Material = @ClaveAnterior
DELETE ArtSucursal        WHERE Articulo = @ClaveAnterior
DELETE ArtPlanEx		WHERE Articulo = @ClaveAnterior
DELETE ArtKms	        WHERE Articulo = @ClaveAnterior
DELETE ArtCompraProrrateo WHERE Articulo = @ClaveAnterior
DELETE ArtUnidad		WHERE Articulo = @ClaveAnterior
DELETE ArtAccesorio	WHERE Articulo = @ClaveAnterior
DELETE ArtRefaccion	WHERE Articulo = @ClaveAnterior
DELETE ArtServicio	WHERE Articulo = @ClaveAnterior
DELETE ArtConsumible	WHERE Articulo = @ClaveAnterior
DELETE ArtVINAccesorio	WHERE Articulo = @ClaveAnterior
DELETE ArtInfoAdicional	WHERE Articulo = @ClaveAnterior
DELETE ArtDescuentoCompra	WHERE Articulo = @ClaveAnterior
DELETE ArtCalidad		WHERE Articulo = @ClaveAnterior
DELETE ArtACCupon		WHERE Articulo = @ClaveAnterior
DELETE ListaD	        WHERE Cuenta = @ClaveAnterior AND Rama='INV'
DELETE Prop               WHERE Cuenta = @ClaveAnterior AND Rama='INV'
DELETE AnexoCta           WHERE Cuenta = @ClaveAnterior AND Rama='INV'
END
END ELSE
IF @ClaveNueva <> @ClaveAnterior AND @ClaveAnterior IS NOT NULL
BEGIN
IF (SELECT Sincro FROM Version) = 1
EXEC sp_executesql N'UPDATE Art SET Rama = @ClaveNueva, SincroC = SincroC WHERE Rama = @ClaveAnterior', N'@ClaveNueva varchar(20), @ClaveAnterior varchar(20)', @ClaveNueva = @ClaveNueva, @ClaveAnterior = @ClaveAnterior
ELSE
UPDATE Art SET Rama = @ClaveNueva WHERE Rama = @ClaveAnterior
UPDATE ArtSub             SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtAcceso          SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtAnexo           SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtLoteFijo        SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtActividad       SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtPresenta        SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtMatriz          SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtJuego           SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtProv            SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtProvSucursal    SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtPrecioHist      SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtSituacionHist   SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtCostoHist       SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtSubCostoHist    SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ListaPreciosD      SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtIdioma          SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtFecha           SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtMaterial        SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtMaterial        SET Material = @ClaveNueva WHERE Material = @ClaveAnterior
UPDATE ArtPlanEx	      SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtSucursal        SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtKms	      SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtCompraProrrateo SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtUnidad	      SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtAccesorio	      SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtRefaccion	      SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtServicio        SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtConsumible      SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtVINAccesorio    SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtInfoAdicional   SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtDescuentoCompra SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtCalidad         SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ArtACCupon         SET Articulo = @ClaveNueva WHERE Articulo = @ClaveAnterior
UPDATE ListaD 	      SET Cuenta   = @ClaveNueva WHERE Cuenta   = @ClaveAnterior AND Rama='INV'
UPDATE Prop               SET Cuenta   = @ClaveNueva WHERE Cuenta   = @ClaveAnterior AND Rama='INV'
UPDATE AnexoCta           SET Cuenta   = @ClaveNueva WHERE Cuenta   = @ClaveAnterior AND Rama='INV'
END
IF @ClaveNueva IS NOT NULL
BEGIN
IF @Precio1N  <> @Precio1A  INSERT ArtPrecioHist (Articulo, Numero, Fecha, PrecioActual, PrecioAnterior) VALUES (@ClaveNueva, 1, @Fecha, @Precio1N, @Precio1A)
IF @Precio2N  <> @Precio2A  INSERT ArtPrecioHist (Articulo, Numero, Fecha, PrecioActual, PrecioAnterior) VALUES (@ClaveNueva, 2, @Fecha, @Precio2N, @Precio2A)
IF @Precio3N  <> @Precio3A  INSERT ArtPrecioHist (Articulo, Numero, Fecha, PrecioActual, PrecioAnterior) VALUES (@ClaveNueva, 3, @Fecha, @Precio3N, @Precio3A)
IF @Precio4N  <> @Precio4A  INSERT ArtPrecioHist (Articulo, Numero, Fecha, PrecioActual, PrecioAnterior) VALUES (@ClaveNueva, 4, @Fecha, @Precio4N, @Precio4A)
IF @Precio5N  <> @Precio5A  INSERT ArtPrecioHist (Articulo, Numero, Fecha, PrecioActual, PrecioAnterior) VALUES (@ClaveNueva, 5, @Fecha, @Precio5N, @Precio5A)
IF @Precio6N  <> @Precio6A  INSERT ArtPrecioHist (Articulo, Numero, Fecha, PrecioActual, PrecioAnterior) VALUES (@ClaveNueva, 6, @Fecha, @Precio6N, @Precio6A)
IF @Precio7N  <> @Precio7A  INSERT ArtPrecioHist (Articulo, Numero, Fecha, PrecioActual, PrecioAnterior) VALUES (@ClaveNueva, 7, @Fecha, @Precio7N, @Precio7A)
IF @Precio8N  <> @Precio8A  INSERT ArtPrecioHist (Articulo, Numero, Fecha, PrecioActual, PrecioAnterior) VALUES (@ClaveNueva, 8, @Fecha, @Precio8N, @Precio8A)
IF @Precio9N  <> @Precio9A  INSERT ArtPrecioHist (Articulo, Numero, Fecha, PrecioActual, PrecioAnterior) VALUES (@ClaveNueva, 9, @Fecha, @Precio9N, @Precio9A)
IF @Precio10N <> @Precio10A INSERT ArtPrecioHist (Articulo, Numero, Fecha, PrecioActual, PrecioAnterior) VALUES (@ClaveNueva, 10, @Fecha, @Precio10N, @Precio10A)
IF @SituacionNueva <> @SituacionAnterior
INSERT ArtSituacionHist (Articulo, Fecha, SituacionActual, SituacionAnterior) VALUES (@ClaveNueva, @Fecha, @SituacionNueva, @SituacionAnterior)
END
END

