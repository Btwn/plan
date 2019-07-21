SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnPeriodoNombre
(
@Periodo				int,
@Usuario				varchar(10)
)
RETURNS varchar(50)

AS BEGIN
DECLARE
@Resultado	varchar(50)
SET @Periodo = ISNULL(@Periodo,0)
IF @Periodo = 1  SET @Resultado = 'Enero'      ELSE
IF @Periodo = 2  SET @Resultado = 'Febrero'    ELSE
IF @Periodo = 3  SET @Resultado = 'Marzo'      ELSE
IF @Periodo = 4  SET @Resultado = 'Abril'      ELSE
IF @Periodo = 5  SET @Resultado = 'Mayo'       ELSE
IF @Periodo = 6  SET @Resultado = 'Junio'      ELSE
IF @Periodo = 7  SET @Resultado = 'Julio'      ELSE
IF @Periodo = 8  SET @Resultado = 'Agosto'     ELSE
IF @Periodo = 9  SET @Resultado = 'Septiembre' ELSE
IF @Periodo = 10 SET @Resultado = 'Octubre'    ELSE
IF @Periodo = 11 SET @Resultado = 'Noviembre'  ELSE
IF @Periodo = 12 SET @Resultado = 'Diciembre'  ELSE
SET @Resultado = 'Periodo ' + LTRIM(RTRIM(CONVERT(varchar,@Periodo)))
SET @Resultado = dbo.fnIdiomaTraducir(@Usuario,@Resultado)
RETURN (@Resultado)
END

