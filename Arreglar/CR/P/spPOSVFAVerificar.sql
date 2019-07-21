SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSVFAVerificar
@IDPOS		varchar(36)

AS
BEGIN
DECLARE
@ID                      int,
@Referencia              varchar(50),
@Accion                  varchar(20),
@CodigoAutorizacion      varchar(255),
@EstatusTransaccion      varchar(255),
@FechaTransaccion        datetime,
@IDTransaccion           varchar(255),
@Monto                   float,
@Moneda                  varchar(20),
@NumeroTarjeta           varchar(255),
@Tarjetahabiente         varchar(500),
@Error                   varchar(20),
@Mensaje                 varchar(max),
@TransaccionOriginal     varchar(255)
SELECT  @ID = MAX(ID)
FROM POSVFALog
WHERE IDModulo = @IDPOS AND Modulo = 'POS'
SELECT  @Referencia = Referencia, @Accion = Accion, @CodigoAutorizacion = CodigoAutorizacion, @EstatusTransaccion = EstatusTransaccion,
@FechaTransaccion = FechaTransaccion, @IDTransaccion = IDTransaccion, @Monto = Monto, @NumeroTarjeta = @NumeroTarjeta,
@Tarjetahabiente = Tarjetahabiente, @Error = Error, @Mensaje = Mensaje, @TransaccionOriginal = @TransaccionOriginal
FROM POSVFALog
WHERE ID = @ID
SELECT NULLIF(@Error,'') Error, NULLIF(@Mensaje,'')Mensaje, ISNULL(@Monto ,0.0)Monto
END

