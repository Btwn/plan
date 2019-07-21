SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnPCPValidarClavePresupuestal
(
@Proyecto				varchar(50),
@Mascara				varchar(50),
@ClavePresupuestal		varchar(50)
)
RETURNS bit

AS BEGIN
DECLARE
@Resultado			bit,
@Contador			int,
@Categoria			varchar(1),
@Catalogo			varchar(20),
@Salir				bit,
@Tipo				varchar(50),
@Validacion			varchar(50),
@Contador2			int,
@Caracter			varchar(1)
SELECT @Resultado = 1, @Salir = 0
SELECT @Contador = 1
IF LEN(@Mascara) <> LEN(@ClavePresupuestal) SELECT @Salir = 1, @Resultado = 0
WHILE @Contador <= 12 AND @Salir = 0
BEGIN
IF @Contador < 10
SET @Categoria = CONVERT(varchar,@Contador)
ELSE
BEGIN
IF @Contador = 10 SET @Categoria = 'A' ELSE
IF @Contador = 11 SET @Categoria = 'B' ELSE
IF @Contador = 12 SET @Categoria = 'C'
END
IF dbo.fnPCPCategoriaEnMascara(@Categoria,@Mascara) = 1
BEGIN
SELECT @Catalogo = dbo.fnPCPClavePresupuestalExtraerCategoria(@Categoria,@Mascara,@ClavePresupuestal)
SELECT @Validacion = NULL, @Tipo = NULL
SELECT
@Tipo = cpc.Tipo,
@Validacion = cpct.Validacion
FROM ClavePresupuestalCatalogo cpc JOIN ClavePresupuestalCatalogoTipo cpct
ON cpc.Tipo = cpct.Tipo AND cpc.Proyecto = cpct.Proyecto
WHERE cpc.Clave = @Catalogo
AND cpc.Proyecto = @Proyecto
AND cpc.Categoria = @Categoria
IF @Tipo IS NULL SELECT @Resultado = 0, @Salir = 1
IF @Salir = 0
BEGIN
SET @Contador2 = 1
WHILE @Contador2 <= LEN(@Catalogo) AND @Salir = 0
BEGIN
SET @Caracter = SUBSTRING(@Catalogo,@Contador2,1)
IF @Validacion = 'Numerico' AND @Caracter NOT IN ('1','2','3','4','5','6','7','8','9','0') SELECT @Salir = 1, @Resultado = 0 ELSE
IF @Validacion = 'Alfabetico' AND @Caracter NOT IN ('A','B','C','D','E','F','G','H','I','J','K','L','M','N','Ñ','O','P','Q','R','S','T','U','V','W','X','Y','Z') SELECT @Salir = 1, @Resultado = 0 ELSE
IF @Validacion = 'Alfanumerico' AND @Caracter NOT IN ('1','2','3','4','5','6','7','8','9','0','A','B','C','D','E','F','G','H','I','J','K','L','M','N','Ñ','O','P','Q','R','S','T','U','V','W','X','Y','Z') SELECT @Salir = 1, @Resultado = 0
SET @Contador2 = @Contador2 + 1
END
END
END
SET @Contador = @Contador + 1
END
RETURN (@Resultado)
END

