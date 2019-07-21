SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCFDVentafdgtToEmail
(
@Cliente			varchar(10),
@Empresa			char(5)
)
RETURNS varchar(255)

AS BEGIN
DECLARE
@Resultado	varchar(255),
@Enviar		bit
SELECT @Enviar = EnviarXML FROM CteCFD WHERE Cliente = @Cliente AND Almacenar = 1 AND AlmacenarTipo = 'ESPECIFICO'
IF ISNULL(@Enviar,0) = 0
SELECT @Enviar = CASE WHEN EnviarXML = 1 OR EnviarPDF = 1 THEN 1 ELSE 0 END FROM EmpresaCFD WHERE Empresa = @Empresa AND (AlmacenarPDF = 1 OR AlmacenarXML = 1)
IF ISNULL(@Enviar,0) = 1
SELECT @Resultado = eMail1 FROM Cte WHERE Cliente = @Cliente
RETURN (@Resultado)
END

