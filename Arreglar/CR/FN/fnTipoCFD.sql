SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnTipoCFD
(       @Modulo  varchar(5), @Mov      varchar(20), @Estatus    varchar(15))
RETURNS bit

AS BEGIN
DECLARE
@Resultado bit,
@Comprobante        varchar(50)
SELECT @Resultado = 0
SELECT  @Comprobante = Comprobante
FROM MovTipoCFDFlex
WHERE Modulo = @Modulo
AND Mov = @Mov
AND ISNULL(NULLIF(Contacto,''),'(Todos)') = '(Todos)'
AND Estatus = @Estatus
SELECT @Resultado = ISNULL(TipoCFD,0) FROM eDoc WHERE Modulo = @Modulo AND eDoc = @Comprobante
RETURN (@Resultado)
END

