SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spTCActualizarVentaCobro
@Modulo					varchar(5),
@ID						int,
@RID					int,
@CodigoAutorizacion		varchar(255),
@FormaPago				varchar(50),
@Importe				float,
@Campo					varchar(50),
@Accion					varchar(20),
@Ok						int				OUTPUT,
@OkRef					varchar(255)	OUTPUT

AS
BEGIN
DECLARE @Estatus		varchar(15)
SELECT @Estatus = Estatus FROM Venta WHERE ID = @ID
IF @Accion = 'VOID'
BEGIN
IF @Estatus <> 'CONCLUIDO'
BEGIN
IF @Campo = 'FormaCobro1'
UPDATE VentaCobro SET Referencia1 = '', TCProcesado1 = 0 WHERE ID = @ID
ELSE IF @Campo = 'FormaCobro2'
UPDATE VentaCobro SET Referencia2 = '', TCProcesado2 = 0 WHERE ID = @ID
ELSE IF @Campo = 'FormaCobro3'
UPDATE VentaCobro SET Referencia3 = '', TCProcesado3 = 0 WHERE ID = @ID
ELSE IF @Campo = 'FormaCobro4'
UPDATE VentaCobro SET Referencia4 = '', TCProcesado4 = 0 WHERE ID = @ID
ELSE IF @Campo = 'FormaCobro5'
UPDATE VentaCobro SET Referencia5 = '', TCProcesado5 = 0 WHERE ID = @ID
END
ELSE IF @Estatus = 'CONCLUIDO'
BEGIN
IF @Campo = 'FormaCobro1'
UPDATE VentaCobro SET TCProcesado1 = 0 WHERE ID = @ID
ELSE IF @Campo = 'FormaCobro2'
UPDATE VentaCobro SET TCProcesado2 = 0 WHERE ID = @ID
ELSE IF @Campo = 'FormaCobro3'
UPDATE VentaCobro SET TCProcesado3 = 0 WHERE ID = @ID
ELSE IF @Campo = 'FormaCobro4'
UPDATE VentaCobro SET TCProcesado4 = 0 WHERE ID = @ID
ELSE IF @Campo = 'FormaCobro5'
UPDATE VentaCobro SET TCProcesado5 = 0 WHERE ID = @ID
END
END
ELSE
BEGIN
IF @Campo = 'FormaCobro1'
UPDATE VentaCobro SET Referencia1 = @CodigoAutorizacion, TCProcesado1 = 1 WHERE ID = @ID
ELSE IF @Campo = 'FormaCobro2'
UPDATE VentaCobro SET Referencia2 = @CodigoAutorizacion, TCProcesado2 = 1 WHERE ID = @ID
ELSE IF @Campo = 'FormaCobro3'
UPDATE VentaCobro SET Referencia3 = @CodigoAutorizacion, TCProcesado3 = 1 WHERE ID = @ID
ELSE IF @Campo = 'FormaCobro4'
UPDATE VentaCobro SET Referencia4 = @CodigoAutorizacion, TCProcesado4 = 1 WHERE ID = @ID
ELSE IF @Campo = 'FormaCobro5'
UPDATE VentaCobro SET Referencia5 = @CodigoAutorizacion, TCProcesado5 = 1 WHERE ID = @ID
END
END

