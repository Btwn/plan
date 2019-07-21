SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spBandejaEntrada
@Estacion	int

AS BEGIN
DECLARE
@ID 	varchar(255),
@Asunto	varchar(255),
@Origen	varchar(255),
@Destino	varchar(255),
@Fecha 	varchar(255),
@Mensaje	varchar(8000),
@salir	    bit,
@Version    bit
SELECT @Version = dbo.fnSQL2012()
IF ISNULL(@Version,0) = 0
BEGIN
DELETE BandejaEntrada WHERE Estacion = @Estacion
SELECT @salir = 0
WHILE @salir = 0
BEGIN
EXEC master..xp_findnextmsg @msg_id = @ID OUTPUT
IF @ID IS NULL
SELECT @salir = 1
ELSE BEGIN
EXEC master..xp_readmail @ID, @subject = @Asunto OUTPUT, @message = @Mensaje OUTPUT, @originator = @Origen OUTPUT, @recipients = @Destino OUTPUT, @date_received = @Fecha OUTPUT
INSERT BandejaEntrada (Estacion, Origen, Destino, Fecha, Asunto, Mensaje) VALUES (@Estacion, @Origen, @Destino, @Fecha, @Asunto, @Mensaje)
END
END
EXEC master..xp_stopmail
END
END

