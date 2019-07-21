SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnPCPEnsamblarClavePresupuestal
(
@ClavePresupuestalCat1			varchar(20),
@ClavePresupuestalCat2			varchar(20),
@ClavePresupuestalCat3			varchar(20),
@ClavePresupuestalCat4			varchar(20),
@ClavePresupuestalCat5			varchar(20),
@ClavePresupuestalCat6			varchar(20),
@ClavePresupuestalCat7			varchar(20),
@ClavePresupuestalCat8			varchar(20),
@ClavePresupuestalCat9			varchar(20),
@ClavePresupuestalCatA			varchar(20),
@ClavePresupuestalCatB			varchar(20),
@ClavePresupuestalCatC			varchar(20),
@Mascara						varchar(50)
)
RETURNS varchar(50)

AS BEGIN
DECLARE
@Longitud1			int,
@Longitud2			int,
@Longitud3			int,
@Longitud4			int,
@Longitud5			int,
@Longitud6			int,
@Longitud7			int,
@Longitud8			int,
@Longitud9			int,
@LongitudA			int,
@LongitudB			int,
@LongitudC			int,
@Contador			int,
@LongitudMascara	int,
@Caracter			varchar(1),
@Resultado			varchar(50)
SELECT
@Resultado = '',
@Longitud1 = 0,
@Longitud2 = 0,
@Longitud3 = 0,
@Longitud4 = 0,
@Longitud5 = 0,
@Longitud6 = 0,
@Longitud7 = 0,
@Longitud8 = 0,
@Longitud9 = 0,
@LongitudA = 0,
@LongitudB = 0,
@LongitudC = 0,
@LongitudMascara = LEN(@Mascara),
@Contador = 1
WHILE @Contador <= @LongitudMascara
BEGIN
SET @Caracter = SUBSTRING(@Mascara,@Contador,1)
IF @Caracter = '1' SET @Longitud1 = @Longitud1 + 1 ELSE
IF @Caracter = '2' SET @Longitud2 = @Longitud2 + 1 ELSE
IF @Caracter = '3' SET @Longitud3 = @Longitud3 + 1 ELSE
IF @Caracter = '4' SET @Longitud4 = @Longitud4 + 1 ELSE
IF @Caracter = '5' SET @Longitud5 = @Longitud5 + 1 ELSE
IF @Caracter = '6' SET @Longitud6 = @Longitud6 + 1 ELSE
IF @Caracter = '7' SET @Longitud7 = @Longitud7 + 1 ELSE
IF @Caracter = '8' SET @Longitud8 = @Longitud8 + 1 ELSE
IF @Caracter = '9' SET @Longitud9 = @Longitud9 + 1 ELSE
IF @Caracter = 'A' SET @LongitudA = @LongitudA + 1 ELSE
IF @Caracter = 'B' SET @LongitudB = @LongitudB + 1 ELSE
IF @Caracter = 'C' SET @LongitudC = @LongitudC + 1
SET @Contador = @Contador + 1
END
SET @Mascara = REPLACE(@Mascara,REPLICATE('1',@Longitud1),ISNULL(@ClavePresupuestalCat1,''))
SET @Mascara = REPLACE(@Mascara,REPLICATE('2',@Longitud2),ISNULL(@ClavePresupuestalCat2,''))
SET @Mascara = REPLACE(@Mascara,REPLICATE('3',@Longitud3),ISNULL(@ClavePresupuestalCat3,''))
SET @Mascara = REPLACE(@Mascara,REPLICATE('4',@Longitud4),ISNULL(@ClavePresupuestalCat4,''))
SET @Mascara = REPLACE(@Mascara,REPLICATE('5',@Longitud5),ISNULL(@ClavePresupuestalCat5,''))
SET @Mascara = REPLACE(@Mascara,REPLICATE('6',@Longitud6),ISNULL(@ClavePresupuestalCat6,''))
SET @Mascara = REPLACE(@Mascara,REPLICATE('7',@Longitud7),ISNULL(@ClavePresupuestalCat7,''))
SET @Mascara = REPLACE(@Mascara,REPLICATE('8',@Longitud8),ISNULL(@ClavePresupuestalCat8,''))
SET @Mascara = REPLACE(@Mascara,REPLICATE('9',@Longitud9),ISNULL(@ClavePresupuestalCat9,''))
SET @Mascara = REPLACE(@Mascara,REPLICATE('A',@LongitudA),ISNULL(@ClavePresupuestalCatA,''))
SET @Mascara = REPLACE(@Mascara,REPLICATE('B',@LongitudB),ISNULL(@ClavePresupuestalCatB,''))
SET @Mascara = REPLACE(@Mascara,REPLICATE('C',@LongitudC),ISNULL(@ClavePresupuestalCatC,''))
SET @Resultado = @Mascara
RETURN (@Resultado)
END

