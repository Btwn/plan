SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnPCPClavePresupuestalExtraerCategoria
(
@Categoria				varchar(1),
@Mascara				varchar(50),
@ClavePresupuestal		varchar(50)
)
RETURNS varchar(20)

AS BEGIN
DECLARE
@Resultado				varchar(20),
@PosicionInicial		int,
@PosicionFinal			int,
@Longitud				int
SELECT @Resultado = ''
SELECT @PosicionInicial = CHARINDEX(@Categoria,@Mascara)
IF @PosicionInicial <> 0
BEGIN
SELECT @PosicionFinal = LEN(@Mascara) - CHARINDEX(@Categoria,REVERSE(@Mascara))
SET @Longitud = @PosicionFinal - @PosicionInicial + 2
SET @Resultado = SUBSTRING(@ClavePresupuestal,@PosicionInicial,@Longitud)
END
RETURN (@Resultado)
END

