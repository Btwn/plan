SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgTipoTasaAC ON TipoTasa

FOR INSERT, UPDATE
AS BEGIN
DECLARE
@EsTasaFija	bit,
@TasaBase	varchar(50),
@SobreTasa	float,
@Mensaje	varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @EsTasaFija = ISNULL(EsTasaFija, 0), @TasaBase = NULLIF(RTRIM(TasaBase), ''), @SobreTasa = NULLIF(SobreTasa, 0.0)
FROM Inserted
IF @EsTasaFija = 0 AND (@TasaBase IS NULL OR @SobreTasa IS NULL)
BEGIN
SELECT @Mensaje = Descripcion + ' Tasa / SobreTasa' FROM MensajeLista WHERE Mensaje = 10010
RAISERROR (@Mensaje,16,-1)
END
END

