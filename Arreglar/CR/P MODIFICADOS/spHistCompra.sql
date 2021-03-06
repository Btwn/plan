SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spHistCompra
@Horas      float,
@HastaFecha datetime,
@HastaHora  datetime,
@Ok         int          OUTPUT,
@OkRef      varchar(255) OUTPUT

AS BEGIN
DECLARE
@ID        int,
@Cantidad  int
BEGIN TRANSACTION
ALTER TABLE Compra DISABLE TRIGGER ALL
SELECT @Cantidad = 0
DECLARE crHistCompra CURSOR FORWARD_ONLY LOCAL STATIC FOR
SELECT TOP 1000000 ID
FROM Compra WITH(NOLOCK)
WHERE FechaEmision < @HastaFecha AND Estatus IN ('CONCLUIDO', 'CONCILIADO', 'CANCELADO')
ORDER BY FechaEmision
OPEN crHistCompra
FETCH NEXT FROM crHistCompra  INTO @ID
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
EXEC spHistCompraMover @ID, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spHistMovMover @ID, 'COMS', @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL SELECT @Cantidad = @Cantidad + 1
FETCH NEXT FROM crHistCompra  INTO @ID
END
CLOSE crHistCompra
DEALLOCATE crHistCompra
ALTER TABLE Compra ENABLE TRIGGER ALL
IF @Ok IS NULL COMMIT TRANSACTION ELSE ROLLBACK TRANSACTION
INSERT HistLog (Modulo, HastaFecha, HastaHora, Cantidad, Ok, OkRef, Horas, Periodo, Ejercicio) VALUES ('COMS', @HastaFecha, @HastaHora, @Cantidad, @Ok, @OkRef, @Horas, MONTH(@HastaFecha), YEAR(@HastaFecha))
RETURN
END
;

