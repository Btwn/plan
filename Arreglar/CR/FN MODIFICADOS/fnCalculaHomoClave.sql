SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnCalculaHomoClave
(
@T_NomTot         char(52),
@Rfc              varchar(16)
)
RETURNS varchar(16)
AS
BEGIN
DECLARE  @VarLoops              int,
@T_NomNum              char(102),
@T_Suma                int,
@T_Divid               int,
@T_Mod                 int,
@T_HomoClv             char(3),
@T_Numero              int,
@T_Parcial             int
SELECT @T_NomNum = '0'
SELECT @VarLoops = 1
WHILE @VarLoops <= 52
BEGIN
SELECT @T_NomNum = LTRIM(RTRIM (@T_NomNum)) +
CASE
WHEN SUBSTRING (@T_NomTot , @VarLoops, 1) = 'A' THEN '11'
WHEN SUBSTRING (@T_NomTot , @VarLoops , 1) = 'B' THEN '12'
WHEN SUBSTRING (@T_NomTot , @VarLoops , 1) = 'C' THEN '13'
WHEN SUBSTRING (@T_NomTot , @VarLoops , 1) = 'D' THEN '14'
WHEN SUBSTRING (@T_NomTot , @VarLoops , 1) = 'E' THEN '15'
WHEN SUBSTRING (@T_NomTot , @VarLoops , 1) = 'F' THEN '16'
WHEN SUBSTRING (@T_NomTot , @VarLoops , 1) = 'G' THEN '17'
WHEN SUBSTRING (@T_NomTot , @VarLoops , 1) = 'H' THEN '18'
WHEN SUBSTRING (@T_NomTot , @VarLoops , 1) = 'I' THEN '19'
WHEN SUBSTRING (@T_NomTot , @VarLoops , 1) = 'J' THEN '21'
WHEN SUBSTRING (@T_NomTot , @VarLoops , 1) = 'K' THEN '22'
WHEN SUBSTRING (@T_NomTot , @VarLoops , 1) = 'L' THEN '23'
WHEN SUBSTRING (@T_NomTot , @VarLoops , 1) = 'M' THEN '24'
WHEN SUBSTRING (@T_NomTot , @VarLoops , 1) = 'N' THEN '25'
WHEN SUBSTRING (@T_NomTot , @VarLoops , 1) = 'O' THEN '26'
WHEN SUBSTRING (@T_NomTot , @VarLoops , 1) = 'P' THEN '27'
WHEN SUBSTRING (@T_NomTot , @VarLoops , 1) = 'Q' THEN '28'
WHEN SUBSTRING (@T_NomTot , @VarLoops , 1) = 'R' THEN '29'
WHEN SUBSTRING (@T_NomTot , @VarLoops , 1) = 'S' THEN '32'
WHEN SUBSTRING (@T_NomTot , @VarLoops , 1) = 'T' THEN '33'
WHEN SUBSTRING (@T_NomTot , @VarLoops , 1) = 'U' THEN '34'
WHEN SUBSTRING (@T_NomTot , @VarLoops , 1) = 'V' THEN '35'
WHEN SUBSTRING (@T_NomTot , @VarLoops , 1) = 'W' THEN '36'
WHEN SUBSTRING (@T_NomTot , @VarLoops , 1) = 'X' THEN '37'
WHEN SUBSTRING (@T_NomTot , @VarLoops , 1) = 'Y' THEN '38'
WHEN SUBSTRING (@T_NomTot , @VarLoops , 1) = 'Z' THEN '39'
WHEN SUBSTRING (@T_NomTot , @VarLoops , 1) >= '0' AND
SUBSTRING (@T_NomTot , @VarLoops , 1) <= '9' THEN
CONVERT(varchar,CONVERT(int, SUBSTRING (@T_NomTot , @VarLoops , 1)) , 2)
WHEN SUBSTRING (@T_NomTot , @VarLoops , 1) IN ('&','Ñ') THEN '10'
ELSE '00'
END
SELECT @VarLoops = @VarLoops + 1
END
SELECT @VarLoops = 1
SELECT @T_Suma = 0
while @VarLoops <= 99
BEGIN
SELECT @T_Suma = @T_Suma + ((CONVERT(int,SUBSTRING (@T_NomNum , @VarLoops , 1))*10) + CONVERT(int,SUBSTRING (@T_NomNum , @VarLoops+1 , 1))) * CONVERT(int,SUBSTRING (@T_NomNum , @VarLoops+1 , 1))
SELECT @VarLoops = @VarLoops + 1
END
SELECT @T_Divid = @T_Suma%1000 
SELECT @T_Mod = @T_Divid%34 
SELECT @T_Divid = (@T_Divid - @T_Mod) / 34 
SELECT @VarLoops = 0
WHILE @VarLoops <= 1
BEGIN
SELECT @T_HomoClv =
CASE CASE @VarLoops WHEN 0 THEN @T_Divid ELSE @T_Mod END
WHEN 0 THEN '1'
WHEN 1 THEN '2'
WHEN 2 THEN '3'
WHEN 3 THEN '4'
WHEN 4 THEN '5'
WHEN 5 THEN '6'
WHEN 6 THEN '7'
WHEN 7 THEN '8'
WHEN 8 THEN '9'
WHEN 9 THEN 'A'
WHEN 10 THEN 'B'
WHEN 11 THEN 'C'
WHEN 12 THEN 'D'
WHEN 13 THEN 'E'
WHEN 14 THEN 'F'
WHEN 15 THEN 'G'
WHEN 16 THEN 'H'
WHEN 17 THEN 'I'
WHEN 18 THEN 'J'
WHEN 19 THEN 'K'
WHEN 20 THEN 'L'
WHEN 21 THEN 'M'
WHEN 22 THEN 'N'
WHEN 23 THEN 'P'
WHEN 24 THEN 'Q'
WHEN 25 THEN 'R'
WHEN 26 THEN 'S'
WHEN 27 THEN 'T'
WHEN 28 THEN 'U'
WHEN 29 THEN 'V'
WHEN 30 THEN 'W'
WHEN 31 THEN 'X'
WHEN 32 THEN 'Y'
ELSE 'Z'
END
SELECT @VarLoops = @VarLoops + 1
SELECT @Rfc = LTRIM(RTRIM (@Rfc)) + LTRIM(RTRIM (@T_HomoClv))
END
SELECT @VarLoops = 0
SELECT @T_Parcial = 0
WHILE @VarLoops < 12
BEGIN
SELECT @VarLoops = @VarLoops + 1
SELECT @T_Numero =
CASE
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = 'A' THEN 10
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = 'B' THEN 11
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = 'C' THEN 12
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = 'D' THEN 13
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = 'E' THEN 14
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = 'F' THEN 15
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = 'G' THEN 16
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = 'H' THEN 17
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = 'I' THEN 18
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = 'J' THEN 19
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = 'K' THEN 20
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = 'L' THEN 21
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = 'M' THEN 22
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = 'N' THEN 23
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = 'O' THEN 25
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = 'P' THEN 26
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = 'Q' THEN 27
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = 'R' THEN 28
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = 'S' THEN 29
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = 'T' THEN 30
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = 'U' THEN 31
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = 'V' THEN 32
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = 'W' THEN 33
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = 'X' THEN 34
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = 'Y' THEN 35
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = 'Z' THEN 36
WHEN SUBSTRING (@Rfc , @VarLoops , 1) >= '0' AND
SUBSTRING (@Rfc , @VarLoops , 1) <= '9'
THEN CONVERT(int,SUBSTRING (@Rfc , @VarLoops , 1))
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = ''
THEN 24
WHEN SUBSTRING (@Rfc , @VarLoops , 1) = ' '
THEN 37
ELSE 0
END
SELECT @T_Parcial = @T_Parcial + (@T_Numero * (14 - @VarLoops))
END
SELECT @T_Mod = ROUND(@T_Parcial%11,1)
IF @T_Mod = 0
SELECT @Rfc = LTRIM(RTRIM (@Rfc)) + '0'
ELSE
BEGIN
SELECT @T_Parcial = 11 - @T_Mod
IF @T_Parcial = 10
SELECT @Rfc = LTRIM(RTRIM (@Rfc)) + 'A'
ELSE
SELECT @Rfc = LTRIM(RTRIM (@Rfc)) + CONVERT(varchar ,@T_Parcial)
END
RETURN @Rfc
END

