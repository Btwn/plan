SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnFormaPagoAyudaCaptura(@Empresa varchar(5), @Modulo varchar(5), @Mov varchar(20), @Usuario varchar(10), @Campo varchar(20), @CobroIntegrado bit, @Tipo varchar(50))
RETURNS @Resultado TABLE (FormaPago varchar(50))
AS
BEGIN
DECLARE @NivelAcceso		bit,
@NivelAccesoEsp	bit
SELECT @NivelAcceso	 = ISNULL(NivelAcceso, 0),
@NivelAccesoEsp = ISNULL(NivelAccesoEsp, 0)
FROM EmpresaGral WITH(NOLOCK)
WHERE Empresa = @Empresa
SELECT @Tipo = NULLIF(NULLIF(RTRIM(@Tipo), ''), '0')
IF @Tipo IS NULL
INSERT INTO @Resultado(
FormaPago)
SELECT fp.FormaPago
FROM FormaPago fp WITH(NOLOCK)
WHERE dbo.fnFormaPagoMovEsp(@Empresa, fp.FormaPago, @Modulo, @Mov, @Usuario, @Campo, @CobroIntegrado, @NivelAcceso, @NivelAccesoEsp) = 1
AND dbo.fnFormaPagoAcceso(@Empresa, fp.FormaPago, @Modulo, @Mov, @Usuario, @Campo, @CobroIntegrado, @NivelAcceso, @NivelAccesoEsp) = 1
ORDER BY fp.Orden
ELSE
INSERT INTO @Resultado(
FormaPago)
SELECT fp.FormaPago
FROM FormaPago fp WITH(NOLOCK)
JOIN FormaPagoTipo t WITH(NOLOCK) ON t.Tipo = @Tipo
JOIN FormaPagoTipoD d WITH(NOLOCK) ON d.Tipo = t.Tipo AND d.FormaPago = fp.FormaPago
WHERE dbo.fnFormaPagoMovEsp(@Empresa, fp.FormaPago, @Modulo, @Mov, @Usuario, @Campo, @CobroIntegrado, @NivelAcceso, @NivelAccesoEsp) = 1
AND dbo.fnFormaPagoAcceso(@Empresa, fp.FormaPago, @Modulo, @Mov, @Usuario, @Campo, @CobroIntegrado, @NivelAcceso, @NivelAccesoEsp) = 1
ORDER BY fp.Orden
RETURN
END

