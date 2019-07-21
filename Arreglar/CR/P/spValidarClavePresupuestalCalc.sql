SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spValidarClavePresupuestalCalc
@Proyecto		varchar(50),
@ClavePresupuestal	varchar(50),
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE @Cat1			varchar(50),
@Cat2			varchar(50),
@Cat3			varchar(50),
@Cat4			varchar(50),
@Cat5			varchar(50),
@Cat6			varchar(50),
@Cat7			varchar(50),
@Cat8			varchar(50),
@Cat9			varchar(50),
@CatA			varchar(50),
@CatB			varchar(50),
@CatC			varchar(50),
@CatGeneral		varchar(50),
@Largo		int,
@PosicionInicial	int,
@PosicionCategoria	int,
@Concatenacion	varchar(50),
@Tipo			varchar(50),
@Digitos		int,
@Validacion		varchar(50),
@Caracter		varchar(1),
@Categoria		int
SELECT @Ok = NULL,
@OkRef = NULL,
@Concatenacion = NULL,
@Categoria = 0
EXEC spClavePresupuestalEnMascara @Proyecto, @ClavePresupuestal, @Cat1 OUTPUT, @Cat2 OUTPUT, @Cat3 OUTPUT, @Cat4 OUTPUT, @Cat5 OUTPUT, @Cat6 OUTPUT, @Cat7 OUTPUT, @Cat8 OUTPUT, @Cat9 OUTPUT, @CatA OUTPUT, @CatB OUTPUT, @CatC OUTPUT
WHILE @Categoria <= 12 AND @Ok IS NULL
BEGIN
SELECT @Categoria = @Categoria + 1
SELECT @CatGeneral = CASE WHEN @Categoria = 1 THEN @Cat1
WHEN @Categoria = 2 THEN @Cat2
WHEN @Categoria = 3 THEN @Cat3
WHEN @Categoria = 4 THEN @Cat4
WHEN @Categoria = 5 THEN @Cat5
WHEN @Categoria = 6 THEN @Cat6
WHEN @Categoria = 7 THEN @Cat7
WHEN @Categoria = 8 THEN @Cat8
WHEN @Categoria = 9 THEN @Cat9
WHEN @Categoria = 10 THEN @CatA
WHEN @Categoria = 11 THEN @CatB
WHEN @Categoria = 12 THEN @CatC
END
DECLARE crTipos CURSOR LOCAL FOR
SELECT cpct.Tipo,
cpct.Digitos,
cpct.Validacion
FROM ClavePresupuestalCatalogoTipo cpct
WHERE cpct.Proyecto = @Proyecto
AND cpct.Categoria = CASE WHEN @Categoria = 10 THEN 'A'
WHEN @Categoria = 11 THEN 'B'
WHEN @Categoria = 12 THEN 'C'
ELSE CONVERT(varchar, @Categoria)
END
ORDER BY RID
OPEN crTipos
FETCH NEXT FROM crTipos INTO @Tipo, @Digitos, @Validacion
SELECT @Largo = LEN(@CatGeneral),
@PosicionInicial = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @PosicionInicial = 1
SELECT @PosicionCategoria = 1
WHILE @PosicionCategoria <= @Digitos AND @Ok IS NULL
BEGIN
SELECT @Caracter = SUBSTRING(@CatGeneral, @PosicionInicial, 1), @PosicionInicial = @PosicionInicial + 1, @PosicionCategoria = @PosicionCategoria + 1
SELECT @Concatenacion = CASE WHEN @Concatenacion IS NULL THEN CONVERT(varchar,@Caracter) ELSE CONVERT(varchar, @Concatenacion) + CONVERT(varchar,@Caracter) END
IF (@Validacion = 'Numerico' AND @Caracter NOT IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9'))
OR (@Validacion = 'Alfabetico' AND @Caracter NOT IN ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'Ñ', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'))
OR (@Validacion = 'Alfanumerico' AND @Caracter NOT IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'Ñ', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'))
SELECT @Ok = 10060
IF @PosicionCategoria = @Digitos + 1
BEGIN
IF NOT EXISTS(SELECT *
FROM ClavePresupuestalCatalogo cpc
WHERE cpc.Clave = @Concatenacion
AND cpc.Categoria = CASE WHEN @Categoria = 10 THEN 'A'
WHEN @Categoria = 11 THEN 'B'
WHEN @Categoria = 12 THEN 'C'
ELSE CONVERT(varchar, @Categoria)
END
AND cpc.Tipo = @Tipo)
SELECT @Ok = 10260
SELECT @Concatenacion = NULL
END
END
END
FETCH NEXT FROM crTipos INTO @Tipo, @Digitos, @Validacion
END
CLOSE crTipos
DEALLOCATE crTipos
END
RETURN
END

