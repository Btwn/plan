SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCFDVentafdgtFormatsEmail
(
@Cliente			varchar(10),
@Empresa			char(5)
)
RETURNS varchar(max)

AS BEGIN
DECLARE
@Resultado	varchar(max),
@EnviarXML	bit,
@EnviarPDF	bit,
@Enviar		bit
SELECT @EnviarXML = EnviarXML, @EnviarPDF = EnviarPDF, @Enviar = Enviar
FROM CteCFD
WHERE Cliente = @Cliente
AND Almacenar = 1
AND AlmacenarTipo = 'ESPECIFICO'
IF @@ROWCOUNT = 0
SELECT @Enviar = CASE WHEN EnviarXML = 1 OR EnviarPDF = 1 THEN 1 ELSE 0 END,
@EnviarXML = EnviarXML, @EnviarPDF = EnviarPDF
FROM EmpresaCFD
WHERE Empresa = @Empresa
AND (AlmacenarPDF = 1 OR AlmacenarXML = 1)
IF @Enviar = 1
SELECT @Resultado = CASE WHEN @EnviarXML = 1 THEN 'XML,' END + CASE WHEN @EnviarPDF = 1 THEN 'PDF,' END
IF LEN(@Resultado) > 0
SELECT @Resultado = SUBSTRING(@Resultado, 0, LEN(@Resultado)-1)
RETURN (@Resultado)
END

