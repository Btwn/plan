SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnPCPValidarDigitosCatalogoEnMascara
(
@Categoria				varchar(1),
@Digitos				int,
@Mascara				varchar(50)
)
RETURNS bit

AS BEGIN
DECLARE
@Resultado			bit
SELECT @Resultado = 0
IF PATINDEX('%' + REPLICATE(@Categoria,@Digitos) + '%',@Mascara) > 0 AND @Digitos > 0 SET @Resultado = 1
RETURN (@Resultado)
END

