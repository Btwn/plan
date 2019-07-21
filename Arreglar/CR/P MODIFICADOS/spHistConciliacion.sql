SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spHistConciliacion
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
ALTER TABLE Conciliacion DISABLE TRIGGER ALL
SELECT @Cantidad = 0
DECLARE crHistConciliacion CURSOR FORWARD_ONLY LOCAL STATIC FOR
SELECT TOP 1000000 ID
FROM Conciliacion WITH(NOLOCK)
WHERE FechaEmision < @HastaFecha AND Estatus IN ('CONCLUIDO', 'CONCILIADO', 'CANCELADO')
ORDER BY FechaEmision
OPEN crHistConciliacion
FETCH NEXT FROM crHistConciliacion  INTO @ID
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
EXEC spHistConciliacionMover @ID, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spHistMovMover @ID, 'CONC', @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL SELECT @Cantidad = @Cantidad + 1
FETCH NEXT FROM crHistConciliacion  INTO @ID
END
CLOSE crHistConciliacion
DEALLOCATE crHistConciliacion
ALTER TABLE Conciliacion ENABLE TRIGGER ALL
IF @Ok IS NULL COMMIT TRANSACTION ELSE ROLLBACK TRANSACTION
INSERT HistLog (Modulo, HastaFecha, HastaHora, Cantidad, Ok, OkRef, Horas, Periodo, Ejercicio) VALUES ('CONC', @HastaFecha, @HastaHora, @Cantidad, @Ok, @OkRef, @Horas, MONTH(@HastaFecha), YEAR(@HastaFecha))
RETURN
END
;

