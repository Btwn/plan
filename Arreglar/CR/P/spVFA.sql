SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVFA
@Empresa        varchar(5),
@Usuario	varchar(10),
@Sucursal       int,
@Modulo		varchar(5),
@ID		varchar(50),
@Renglon	float,
@Referencia	varchar(50),
@Accion		varchar(20),
@Importe	money,
@AutorizacionID	varchar(50),
@Respuesta	varchar(max)

AS
BEGIN
IF @Modulo = 'POS' AND NULLIF(@Respuesta,'') IS NOT NULL
BEGIN
INSERT POSVFALog(IDModulo, Modulo,     Accion,  CodigoAutorizacion, EstatusTransaccion, FechaTransaccion, IDTransaccion, Monto, Moneda, NumeroTarjeta, Tarjetahabiente, Error, Mensaje, TransaccionOriginal, Referencia)
SELECT           @ID,      @Modulo,    @Accion,*
FROM(SELECT Parametro,Valor FROM dbo.fnPOSSepararCadenaVFA (@Respuesta)) tabla
PIVOT( MAX(Valor)
FOR [Parametro] IN ([[CODIGO_AUT], [ESTATUS_TRANSACCION_L], [FECHA_TRANSACCION], [ID_TRANSACCION], [MONTO], [MONEDA], [NUMERO_TARJETA],  [TARJETAHABIENTE], [ERROR],  [MENSAJES], [TRANS_ORIGINAL], [REFERENCIA])) p
END
RETURN
END

