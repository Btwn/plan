SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCxcFormaPagoEsDineroAnticipado (@ID		int)
RETURNS bit
AS BEGIN
DECLARE @FormaPago		varchar(50),
@FormaPago1		varchar(50),
@Valor			bit
SELECT @FormaPago = FormaCobro, @FormaPago1 = FormaCobro1 FROM Cxc WHERE ID = @ID
IF EXISTS(SELECT MovTipo.Clave
FROM MovTipo
JOIN FormaPago ON FormaPago.MovIngresos = MovTipo.Mov AND MovTipo.Modulo = 'DIN'
WHERE MovTipo.Clave IN('DIN.DA')
AND FormaPago.FormaPago IN(@FormaPago, @FormaPago1))
SELECT @Valor = 1
ELSE
SELECT @Valor = 0
RETURN @Valor
END

