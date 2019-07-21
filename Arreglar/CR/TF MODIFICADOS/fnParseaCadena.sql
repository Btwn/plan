SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnParseaCadena(
@Cadena		varchar(max),
@Separador	varchar(100) = ','
)
RETURNS @Tabla TABLE
(
Posicion		int identity(1,1),
ValorTexto	varchar(max)
)
AS
BEGIN
DECLARE @w_Continue  int
,@w_StartPos  int
,@w_Length  int
,@w_Delimeter_pos int
,@w_tmp_txt   varchar(max)
,@w_Delimeter_Len tinyint
if len(@Cadena) = 0
begin
SET  @w_Continue = 0 
end
else
begin
SET  @w_Continue = 1
SET @w_StartPos = 1
SET @Cadena = RTRIM( LTRIM( @Cadena))
SET @w_Length   = DATALENGTH( RTRIM( LTRIM( @Cadena)))
SET @w_Delimeter_Len = len(@Separador)
end
WHILE @w_Continue = 1
BEGIN
SET @w_Delimeter_pos = CHARINDEX( @Separador
,(SUBSTRING( @Cadena, @w_StartPos
,((@w_Length - @w_StartPos) + @w_Delimeter_Len)))
)
IF @w_Delimeter_pos > 0  
BEGIN
SET @w_tmp_txt = LTRIM(RTRIM( SUBSTRING( @Cadena, @w_StartPos
,(@w_Delimeter_pos - 1)) ))
SET @w_StartPos = @w_Delimeter_pos + @w_StartPos + (@w_Delimeter_Len- 1)
END
ELSE 
BEGIN
SET @w_tmp_txt = LTRIM(RTRIM( SUBSTRING( @Cadena, @w_StartPos
,((@w_Length - @w_StartPos) + @w_Delimeter_Len)) ))
SELECT @w_Continue = 0
END
INSERT INTO @Tabla VALUES(@w_tmp_txt)
END
RETURN
END

