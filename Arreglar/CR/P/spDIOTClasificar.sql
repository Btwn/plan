SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spDIOTClasificar
@Estacion		int,
@Empresa		varchar(5),
@FechaD			datetime,
@FechaA			datetime

AS
BEGIN
DECLARE @RID					int,
@RIDAnt				int,
@EsExcento			bit,
@EsImportacion		bit,
@Tasa					float,
@TipoDocumento		varchar(20),
@TipoTercero			varchar(20),
@Rubro				int
SELECT @RIDAnt = 0
WHILE(1=1)
BEGIN
SELECT @RID = MIN(RID)
FROM #Documentos
WHERE RID > @RIDAnt
IF @RID IS NULL BREAK
SELECT @RIDAnt = @RID
SELECT @EsExcento = NULL, @EsImportacion = NULL, @Tasa = NULL, @TipoDocumento = NULL, @TipoTercero = NULL, @Rubro = NULL
SELECT @EsExcento = ISNULL(EsExcento, 0),
@EsImportacion = ISNULL(EsImportacion, 0),
@Tasa = ISNULL(Tasa, 0),
@TipoDocumento = ISNULL(TipoDocumento, ''),
@TipoTercero = ISNULL(TipoTercero, '')
FROM #Documentos
WHERE RID = @RID
EXEC spDIOTTipoOperacion @EsExcento, @EsImportacion, @Tasa, @TipoDocumento, @TipoTercero, @Rubro OUTPUT
UPDATE #Documentos
SET TipoOperacion = @Rubro
WHERE RID = @RID
END
END

