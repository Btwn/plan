SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgJornadaTiempoAC ON JornadaTiempo

FOR INSERT, UPDATE
AS BEGIN
DECLARE
@JornadaI  	varchar(50),
@JornadaD  	varchar(50),
@EntradaI	datetime,
@EntradaD	datetime,
@Fecha	datetime
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @JornadaI = Jornada, @EntradaI = Entrada FROM Inserted
SELECT @JornadaD = Jornada, @EntradaD = Entrada FROM Deleted
IF @JornadaI IS NOT NULL AND (@JornadaI <> @JornadaD OR @EntradaI <> @EntradaD)
BEGIN
SELECT @Fecha = @EntradaI
EXEC spExtraerFecha @Fecha OUTPUT
UPDATE JornadaTiempo SET Fecha = @Fecha WHERE Jornada = @JornadaI AND Entrada = @EntradaI
END
END

