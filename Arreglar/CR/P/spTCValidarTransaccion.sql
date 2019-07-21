SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spTCValidarTransaccion
@Estacion			int,
@Modulo				varchar(5),
@ID					int,
@FormaPago			varchar(50),
@Importe			float,
@Campo				varchar(50),
@ProcesadorTrans	varchar(15),
@Accion				varchar(20),
@CxcID				int,
@CodigoAutorizacion	varchar(255) OUTPUT,
@Ok					int			 OUTPUT,
@OkRef				varchar(255) OUTPUT

AS
BEGIN
DECLARE @CodigoError			varchar(255),
@Texto				varchar(255)
SELECT @CodigoError = TCHashTableTransaccion.Valor FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'Codigo Error'
SELECT @Texto = TCHashTableTransaccion.Valor FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'Texto'
SELECT @CodigoAutorizacion = TCHashTableTransaccion.Valor FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'Codigo Autorizacion'
IF @ProcesadorTrans = 'BANORTE' AND ISNULL(@CodigoError, '') <> '1'
SELECT @Ok = 7, @OkRef = @FormaPago + ' - ' + @Texto
IF @Ok IS NULL
UPDATE Cxc SET TarjetaBancariaAutorizacion = @CodigoAutorizacion WHERE ID = @CxcID
RETURN
END

