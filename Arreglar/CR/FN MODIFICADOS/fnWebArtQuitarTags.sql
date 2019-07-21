SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnWebArtQuitarTags
(@Texto    varchar(MAX),@Tag  varchar(255))
RETURNS varchar(MAX)

AS BEGIN
DECLARE
@Resultado  varchar(MAX),
@Resultado2  varchar(MAX),
@Longitud   int,
@Desde      int,
@Hasta      int,
@Ntag       int,
@Tag2       varchar(255)
IF @Texto IS NULL OR @Tag IS NULL RETURN @Resultado
IF CHARINDEX(@Tag,@Texto)=0 RETURN @Texto
SELECT @Ntag = LEN(@Tag)-1
SELECT @Desde = CHARINDEX(@Tag,@Texto)
SELECT @Resultado= REPLACE(@Texto,SUBSTRING(@Texto,1,@Desde+@Ntag),'')
SELECT @Tag2 = REPLACE(@Tag,'<','</')
SELECT @Hasta = CHARINDEX(@Tag2,@Resultado)
SELECT @Longitud = LEN(@Resultado)
SELECT @Resultado2 =REPLACE(@Resultado,SUBSTRING(@Resultado,@Hasta,@Longitud),'')
RETURN(@Resultado2)
END

