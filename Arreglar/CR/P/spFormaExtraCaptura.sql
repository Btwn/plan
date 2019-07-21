SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spFormaExtraCaptura
@Accion		varchar(20),	
@Empresa		char(5),
@Sucursal		int,
@Usuario		varchar(10),
@Estacion		int,
@FormaTipo		varchar(20),
@Aplica		varchar(50),
@AplicaClave	varchar(50),
@Campo		varchar(50),
@ValorTexto		varchar(255)	= NULL,
@ValorNumerico	int		= NULL,
@ValorFlotante	float		= NULL,
@ValorMonetario	money		= NULL,
@ValorLogico	bit		= NULL,
@ValorFechaHora	datetime	= NULL,
@Tiempo		datetime	= NULL

AS BEGIN
DECLARE
@Ok			int,
@OkRef		varchar(255),
@Grupo		varchar(50),
@Orden		int,
@CampoSiguiente	varchar(50),
@OrdenEspecial	bit,
@TipoDato		varchar(20),
@Valor		varchar(255),
@AplicaID		int
SELECT @Ok = NULL, @OkRef = NULL, @Accion = UPPER(@Accion), @CampoSiguiente = NULL
IF @Accion = 'INICIAR'
BEGIN
DELETE tempFormaCaptura WHERE Estacion = @Estacion AND FormaTipo = @FormaTipo
/*IF UPPER(@Aplica) = 'MOVIMIENTO'
INSERT tempFormaCaptura (
Estacion,  FormaTipo,    Campo,
ValorTexto,
ValorNumerico,
ValorFlotante,
ValorMonetario,
ValorLogico,
ValorFechaHora)
SELECT @Estacion, fc.FormaTipo, fc.Campo,
CASE WHEN fc.TipoDato = 'Texto'     THEN fv.Valor                 END,
CASE WHEN fc.TipoDato = 'Numerico'  THEN CONVERT(int, fv.Valor)   END,
CASE WHEN fc.TipoDato = 'Flotante'  THEN CONVERT(float, fv.Valor) END,
CASE WHEN fc.TipoDato = 'Monetario' THEN CONVERT(money, fv.Valor) END,
CASE WHEN fc.TipoDato = 'Logico'    THEN CONVERT(bit, fv.Valor)   END,
CASE WHEN fc.TipoDato IN ('Fecha', 'Hora', 'Fecha/Hora') THEN CONVERT(datetime, fv.Valor, 126) END
FROM FormaExtraCampo fc
LEFT OUTER JOIN FormaExtraD fv ON fv.FormaTipo = @FormaTipo AND fv.ID = @AplicaID AND fv.Campo = fc.Campo
WHERE fc.FormaTipo = @FormaTipo
ELSE*/
INSERT tempFormaCaptura (
Estacion,  FormaTipo,    Campo,
ValorTexto,
ValorNumerico,
ValorFlotante,
ValorMonetario,
ValorLogico,
ValorFechaHora)
SELECT @Estacion, fc.FormaTipo, fc.Campo,
CASE WHEN fc.TipoDato = 'Texto'     THEN fv.Valor                 END,
CASE WHEN fc.TipoDato = 'Numerico'  THEN CONVERT(int, fv.Valor)   END,
CASE WHEN fc.TipoDato = 'Flotante'  THEN CONVERT(float, fv.Valor) END,
CASE WHEN fc.TipoDato = 'Monetario' THEN CONVERT(money, fv.Valor) END,
CASE WHEN fc.TipoDato = 'Logico'    THEN CONVERT(bit, fv.Valor)   END,
CASE WHEN fc.TipoDato IN ('Fecha', 'Hora', 'Fecha/Hora') THEN CONVERT(datetime, fv.Valor, 126) END
FROM FormaExtraCampo fc
LEFT OUTER JOIN FormaExtraValor fv ON fv.FormaTipo = @FormaTipo AND fv.Aplica = @Aplica AND fv.AplicaClave = @AplicaClave AND fv.Campo = fc.Campo
WHERE fc.FormaTipo = @FormaTipo
END ELSE
BEGIN
IF @Campo IS NOT NULL
UPDATE tempFormaCaptura
SET ValorTexto = @ValorTexto, ValorNumerico = @ValorNumerico, ValorFlotante = @ValorFlotante, ValorMonetario = @ValorMonetario, ValorLogico = @ValorLogico, ValorFechaHora = @ValorFechaHora, Tiempo = @Tiempo
WHERE Estacion = @Estacion AND FormaTipo = @FormaTipo AND Campo = @Campo
IF @Accion = 'FINALIZAR'
BEGIN
DECLARE crFormaCaptura CURSOR LOCAL FOR
SELECT Campo, ValorTexto, ValorNumerico, ValorFlotante, ValorMonetario, ValorLogico, ValorFechaHora, Tiempo
FROM tempFormaCaptura
WHERE Estacion = @Estacion AND FormaTipo = @FormaTipo
OPEN crFormaCaptura
FETCH NEXT FROM crFormaCaptura INTO @Campo, @ValorTexto, @ValorNumerico, @ValorFlotante, @ValorMonetario, @ValorLogico, @ValorFechaHora, @Tiempo
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @TipoDato = TipoDato FROM FormaExtraCampo WHERE FormaTipo = @FormaTipo AND Campo = @Campo
SELECT @Valor = NULL
IF @TipoDato = 'Texto'     SELECT @Valor = @ValorTexto                       ELSE
IF @TipoDato = 'Numerico'  SELECT @Valor = CONVERT(varchar, @ValorNumerico)  ELSE
IF @TipoDato = 'Flotante'  SELECT @Valor = CONVERT(varchar, @ValorFlotante)  ELSE
IF @TipoDato = 'Monetario' SELECT @Valor = CONVERT(varchar, @ValorMonetario) ELSE
IF @TipoDato = 'Logico'    SELECT @Valor = CONVERT(varchar, @ValorLogico)    ELSE
IF @TipoDato IN ('Fecha', 'Hora', 'Fecha/Hora') SELECT @Valor = CONVERT(varchar, @ValorFechaHora, 126)
/*IF UPPER(@Aplica) = 'MOVIMIENTO'
BEGIN
UPDATE FormaExtraD
SET Valor = NULLIF(RTRIM(@Valor), ''),
Tiempo = NULLIF(@Tiempo, 0)
WHERE FormaTipo = @FormaTipo AND ID = @AplicaID AND Campo = @Campo
IF @@ROWCOUNT = 0
INSERT FormaExtraD (FormaTipo, ID, Campo, Valor, Tiempo) VALUES (@FormaTipo, @AplicaID, @Campo, @Valor, @Tiempo)
END ELSE
BEGIN*/
UPDATE FormaExtraValor
SET Valor = NULLIF(RTRIM(@Valor), ''),
Tiempo = NULLIF(@Tiempo, 0),
Eliminado = 0
WHERE FormaTipo = @FormaTipo AND Aplica = @Aplica AND AplicaClave = @AplicaClave AND Campo = @Campo
IF @@ROWCOUNT = 0
INSERT FormaExtraValor (FormaTipo, Aplica, AplicaClave, Campo, Valor, Tiempo) VALUES (@FormaTipo, @Aplica, @AplicaClave, @Campo, @Valor, @Tiempo)
END
FETCH NEXT FROM crFormaCaptura INTO @Campo, @ValorTexto, @ValorNumerico, @ValorFlotante, @ValorMonetario, @ValorLogico, @ValorFechaHora, @Tiempo
END
CLOSE crFormaCaptura
DEALLOCATE crFormaCaptura
END ELSE
BEGIN
SELECT @OrdenEspecial = OrdenEspecial FROM FormaTipo WHERE FormaTipo = @FormaTipo
IF @OrdenEspecial = 1
BEGIN
SELECT @Grupo = Grupo, @Orden = Orden FROM FormaExtraCampo WHERE FormaTipo = @FormaTipo AND Campo = @Campo
IF @Accion = 'SIGUIENTE' SELECT @CampoSiguiente = MIN(Campo) FROM FormaExtraCampo WHERE FormaTipo = @FormaTipo AND Campo <> @Campo AND Orden >= @Orden
IF @Accion = 'ANTERIOR'  SELECT @CampoSiguiente = MAX(Campo) FROM FormaExtraCampo WHERE FormaTipo = @FormaTipo AND Campo <> @Campo AND Orden <= @Orden
END
END
END
SELECT 'Ok' = @Ok, 'OkRef' = @OkRef, 'Campo' = @CampoSiguiente
RETURN
END

