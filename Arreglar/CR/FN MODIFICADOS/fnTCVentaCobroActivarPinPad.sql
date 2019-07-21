SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnTCVentaCobroActivarPinPad(
@ModuloID		int,
@FormaCobro1	varchar(50),
@FormaCobro2	varchar(50),
@FormaCobro3	varchar(50),
@FormaCobro4	varchar(50),
@FormaCobro5	varchar(50),
@TCProcesado1	bit,
@TCProcesado2	bit,
@TCProcesado3	bit,
@TCProcesado4	bit,
@TCProcesado5	bit
)
RETURNS bit
AS
BEGIN
DECLARE @Valor			bit
IF (@FormaCobro1 IS NOT NULL AND (SELECT ISNULL(TCActivarInterfaz, 0) FROM FormaPago  WITH(NOLOCK) WHERE FormaPago = @FormaCobro1) = 1 AND ISNULL(@TCProcesado1, 0) = 0) OR
(@FormaCobro2 IS NOT NULL AND (SELECT ISNULL(TCActivarInterfaz, 0) FROM FormaPago  WITH(NOLOCK) WHERE FormaPago = @FormaCobro2) = 1 AND ISNULL(@TCProcesado2, 0) = 0) OR
(@FormaCobro3 IS NOT NULL AND (SELECT ISNULL(TCActivarInterfaz, 0) FROM FormaPago  WITH(NOLOCK) WHERE FormaPago = @FormaCobro3) = 1 AND ISNULL(@TCProcesado3, 0) = 0) OR
(@FormaCobro4 IS NOT NULL AND (SELECT ISNULL(TCActivarInterfaz, 0) FROM FormaPago  WITH(NOLOCK) WHERE FormaPago = @FormaCobro4) = 1 AND ISNULL(@TCProcesado4, 0) = 0) OR
(@FormaCobro5 IS NOT NULL AND (SELECT ISNULL(TCActivarInterfaz, 0) FROM FormaPago  WITH(NOLOCK) WHERE FormaPago = @FormaCobro5) = 1 AND ISNULL(@TCProcesado5, 0) = 0)
SELECT @Valor = 1
ELSE
SELECT @Valor = 0
RETURN @Valor
END

