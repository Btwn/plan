SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spImpuestosImportacion
@Articulo	varchar(20),
@Arancel	varchar(50),
@Pais		varchar(50)

AS BEGIN
DECLARE
@ArtProgramaSectorial	varchar(50),
@ArtOrigenPais		varchar(50),
@TratadoComercial		varchar(50),
@TratadoComercialPct	varchar(50),
@ProgramaSectorial		varchar(50),
@ProgramaSectorialPct	float,
@Porcentaje			float,
@IGI			float,
@Cuota			float
SELECT @ArtProgramaSectorial = NULLIF(RTRIM(ProgramaSectorial), ''), @ArtOrigenPais = NULLIF(RTRIM(OrigenPais), '') FROM Art with (nolock) WHERE Articulo = @Articulo
SELECT @Porcentaje = Porcentaje, @Cuota = Cuota FROM ArtArancel with(nolock) WHERE Arancel = @Arancel
SELECT @TratadoComercialPct = MIN(atc.Porcentaje)
FROM ArtArancelTratadoComercial atc
 WITH(NOLOCK) JOIN TratadoComercialPais tcp  WITH(NOLOCK) ON tcp.Pais = @Pais AND tcp.TratadoComercial = atc.TratadoComercial
WHERE atc.Arancel = @Arancel
SELECT @TratadoComercial = MIN(atc.TratadoComercial)
FROM ArtArancelTratadoComercial atc
 WITH(NOLOCK) JOIN TratadoComercialPais tcp  WITH(NOLOCK) ON tcp.Pais = @Pais AND tcp.TratadoComercial = atc.TratadoComercial
WHERE atc.Arancel = @Arancel AND atc.Porcentaje = @TratadoComercialPct
SELECT @ProgramaSectorialPct = MIN(aps.Porcentaje)
FROM ArtArancelProgramaSectorial aps
WITH(NOLOCK) WHERE aps.Arancel = @Arancel
SELECT @ProgramaSectorial = MIN(aps.ProgramaSectorial)
FROM ArtArancelProgramaSectorial aps
WITH(NOLOCK) WHERE aps.Arancel = @Arancel AND aps.Porcentaje = @ProgramaSectorialPct
IF @ArtProgramaSectorial IS NULL SELECT @ProgramaSectorialPct = 0.0
IF @ArtOrigenPais IS NULL SELECT @TratadoComercialPct = 0.0
IF NULLIF(@ProgramaSectorialPct, 0.0) IS NULL OR @ProgramaSectorialPct > @TratadoComercialPct
SELECT @IGI = @TratadoComercialPct, @ProgramaSectorial = NULL
ELSE
SELECT @IGI = @ProgramaSectorialPct, @TratadoComercial = NULL
IF NULLIF(@IGI, 0.0) IS NULL AND @ArtProgramaSectorial IS NULL AND @TratadoComercial IS NULL SELECT @IGI = @Porcentaje
SELECT 'ImportacionImpuesto1' = @IGI, 'ImportacionImpuesto2' = @Cuota, 'TratadoComercial' = @TratadoComercial, 'ProgramaSectorial' = @ProgramaSectorial
RETURN
END

