SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDINominaXMLGenerar
@Estacion					int,
@ID							int,
@Empresa					varchar(5),
@Mov						varchar(20),
@MovID						varchar(20),
@Version					varchar(5),
@Personal					varchar(10),
@TotalPercepciones			float,
@TotalDeducciones			float,
@PercepcionesTotalGravado	float,
@PercepcionesTotalExcento	float,
@DeduccionesTotalGravado	float,
@DeduccionesTotalExcento	float,
@XML						varchar(max)	OUTPUT,
@XMLComprobante				varchar(max)	OUTPUT,
@XMLComplemento				varchar(max)	OUTPUT,
@Ok							int				OUTPUT,
@OkRef						varchar(255)	OUTPUT

AS
BEGIN
DECLARE @Vista			varchar(100)
SELECT @XML = Plantilla, @Vista = Vista FROM CFDINominaXMLPlantilla WHERE Version = @Version
EXEC spCFDINominaXMLComprobante @Estacion, @ID, @Personal, @Version, @Vista, @TotalPercepciones, @TotalDeducciones, @PercepcionesTotalGravado, @PercepcionesTotalExcento, @DeduccionesTotalGravado, @DeduccionesTotalExcento, @XML OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spCFDINominaXMLComplemento @Estacion, @ID, @Personal, @TotalPercepciones, @TotalDeducciones, @PercepcionesTotalGravado, @PercepcionesTotalExcento, @DeduccionesTotalGravado, @DeduccionesTotalExcento, @XMLComplemento OUTPUT, @XML OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
SELECT @XML = REPLACE(ISNULL(@XML, ''), 'T00:00:00', ''),
@XMLComplemento = REPLACE(ISNULL(@XMLComplemento, ''), 'T00:00:00', ''),
@XMLComprobante = REPLACE(ISNULL(@XMLComprobante, ''), 'T00:00:00', '')
/*
SELECT @XML            = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@XML, 'á', 'a'), 'é', 'e'), 'í', 'i'), 'ó', 'o'), 'ú', 'u'), 'ü', 'u'), 'a', 'A'), 'É', 'E'), 'S', 'I'), '±', 'O'), '˜', 'U'), 'Ü', 'U'),
@XMLComplemento = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@XMLComplemento, 'á', 'a'), 'é', 'e'), 'í', 'i'), 'ó', 'o'), 'ú', 'u'), 'ü', 'u'), 'a', 'A'), 'É', 'E'), 'S', 'I'), '±', 'O'), '˜', 'U'), 'Ü', 'U'),
@XMLComprobante = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@XMLComprobante, 'á', 'a'), 'é', 'e'), 'í', 'i'), 'ó', 'o'), 'ú', 'u'), 'ü', 'u'), 'a', 'A'), 'É', 'E'), 'S', 'I'), '±', 'O'), '˜', 'U'), 'Ü', 'U')
*/
SELECT @XML			 = dbo.fnCFDILimpiarXML(@XML, ' SELLO CERTIFICADO '),
@XMLComplemento = dbo.fnCFDILimpiarXML(@XMLComplemento, ' SELLO CERTIFICADO '),
@XMLComprobante = dbo.fnCFDILimpiarXML(@XMLComprobante, ' SELLO CERTIFICADO ')
RETURN
END

