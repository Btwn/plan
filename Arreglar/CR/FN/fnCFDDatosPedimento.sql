SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCFDDatosPedimento
(@Modulo			varchar(20),
@Id        		Int,
@Cual				varchar(20))
RETURNS varchar(8000)

AS BEGIN
DECLARE
@Resultado			varchar(8000),
@SerieLote			varchar(20),
@Pedimento			varchar(20),
@PedimentoFecha		datetime,
@Aduana               varchar(20),
@TextoPedimento       varchar(1000),
@TextoPedimentoFecha  varchar(1000),
@TextoAduana          varchar(1000)
SELECT @TextoPedimento = '', @TextoPedimentoFecha = '', @TextoAduana = ''
DECLARE crRepCFDSerieLote CURSOR LOCAL FOR
SELECT DISTINCT s.Propiedades, p.Fecha1, p.Aduana
FROM SerieLoteMov s
JOIN SerieLoteProp p ON p.Propiedades = s.Propiedades
WHERE s.Modulo = @Modulo AND s.ID = @ID
GROUP BY s.Propiedades, p.Fecha1, p.Aduana
ORDER BY s.Propiedades, p.Fecha1, p.Aduana
OPEN crRepCFDSerieLote
FETCH NEXT FROM crRepCFDSerieLote INTO @Pedimento, @PedimentoFecha, @Aduana
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Pedimento = dbo.fnLimpiarRFC(@Pedimento)
IF NULLIF(@TextoPedimento,'') IS NOT NULL AND NULLIF(@Pedimento,'') IS NOT NULL
SELECT @TextoPedimento = @TextoPedimento + ','
IF NULLIF(@Pedimento,'') IS NOT NULL
SELECT @TextoPedimento = @TextoPedimento + @Pedimento
IF NULLIF(@TextoPedimentoFecha,'') IS NOT NULL AND NULLIF(@PedimentoFecha,'') IS NOT NULL
SELECT @TextoPedimentoFecha = @TextoPedimentoFecha + ','
IF NULLIF(@PedimentoFecha,'') IS NOT NULL
SELECT @TextoPedimentoFecha = @TextoPedimentoFecha + CONVERT(varchar, @PedimentoFecha, 103)
IF NULLIF(@TextoAduana,'') IS NOT NULL AND NULLIF(@Aduana,'') IS NOT NULL
SELECT @TextoAduana = @TextoAduana + ','
IF NULLIF(@Aduana,'') IS NOT NULL
SELECT @TextoAduana = @TextoAduana + @Aduana
END
FETCH NEXT FROM crRepCFDSerieLote INTO @Pedimento, @PedimentoFecha, @Aduana
END
CLOSE crRepCFDSerieLote
DEALLOCATE crRepCFDSerieLote
IF @Cual = 'PEDIMENTO'      SELECT @Resultado = @TextoPedimento
IF @Cual = 'PEDIMENTOFECHA' SELECT @Resultado = @TextoPedimentoFecha
IF @Cual = 'ADUANA'         SELECT @Resultado = @TextoAduana
RETURN (@Resultado)
END

