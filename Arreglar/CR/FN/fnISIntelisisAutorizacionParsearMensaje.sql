SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnISIntelisisAutorizacionParsearMensaje
(
@MensajeRespuesta			varchar(max),
@Empresa					varchar(5),
@Modulo						varchar(5),
@Movimiento					varchar(50),
@Estatus					varchar(15),
@Situacion					varchar(50),
@SituacionSiguiente			varchar(50),
@Usuario					varchar(10)
)
RETURNS varchar(max)

AS BEGIN
DECLARE
@Resultado	varchar(max)
SET @MensajeRespuesta = REPLACE(@MensajeRespuesta,'<Empresa>',ISNULL(@Empresa,''))
SET @MensajeRespuesta = REPLACE(@MensajeRespuesta,'<Modulo>',ISNULL(@Modulo,''))
SET @MensajeRespuesta = REPLACE(@MensajeRespuesta,'<Movimiento>',ISNULL(@Movimiento,''))
SET @MensajeRespuesta = REPLACE(@MensajeRespuesta,'<Estatus>',ISNULL(@Estatus,''))
SET @MensajeRespuesta = REPLACE(@MensajeRespuesta,'<Situacion>',ISNULL(@Situacion,''))
SET @MensajeRespuesta = REPLACE(@MensajeRespuesta,'<SituacionSiguiente>',ISNULL(@SituacionSiguiente,''))
SET @MensajeRespuesta = REPLACE(@MensajeRespuesta,'<Usuario>',ISNULL(@Usuario,''))
SET @Resultado = ISNULL(@MensajeRespuesta,'')
RETURN (ISNULL(@Resultado,''))
END

