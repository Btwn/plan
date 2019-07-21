SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexSepararAddendaCFDI
@CFDI				varchar(max),
@CFDISinAddenda		varchar(max) OUTPUT,
@Addenda			varchar(max) OUTPUT

AS BEGIN
DECLARE
@InicioAddenda			bigint,
@FinAddenda				bigint,
@CFDIInicio				varchar(max),
@CFDIFinal				varchar(max)
SET @InicioAddenda = CHARINDEX('<cfdi:Addenda>', @CFDI)
SET @FinAddenda = CHARINDEX('</cfdi:Addenda>', @CFDI)
IF NULLIF(@InicioAddenda,0) IS NOT NULL AND NULLIF(@FinAddenda,0) IS NOT NULL
BEGIN
SET @CFDIInicio = SUBSTRING(@CFDI, 1,  @InicioAddenda - 1)
SET @CFDIFinal = SUBSTRING(@CFDI, @FinAddenda + 15, LEN(@CFDI))
SELECT @CFDISinAddenda =  @CFDIInicio + @CFDIFinal
SET @Addenda = SUBSTRING(@CFDI, @InicioAddenda,LEN(@CFDI))
SET @Addenda = SUBSTRING(@Addenda,1,CHARINDEX('</cfdi:Addenda>', @Addenda) + 14)
END ELSE
BEGIN
SET @CFDISinAddenda = @CFDI
SET @Addenda = ''
END
END

