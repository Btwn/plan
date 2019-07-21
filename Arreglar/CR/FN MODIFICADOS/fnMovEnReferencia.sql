SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnMovEnReferencia(
@Referencia			varchar(50)
)
RETURNS varchar(20)
AS
BEGIN
DECLARE @Valor			varchar(20),
@Posicion			int,
@PosicionNueva	int
SELECT @Posicion = 0
WHILE(1=1)
BEGIN
SELECT @PosicionNueva = CHARINDEX(' ', @Referencia, @Posicion)
IF @PosicionNueva <> 0
SELECT @Posicion = @PosicionNueva + 1
ELSE
BREAK
END
SELECT @Valor = RTRIM(SUBSTRING(@Referencia, 1, @Posicion - 1))
RETURN @Valor
END

