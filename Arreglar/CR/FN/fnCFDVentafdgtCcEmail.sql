SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCFDVentafdgtCcEmail
(
@Cliente			varchar(10),
@Empresa			char(5)
)
RETURNS varchar(max)

AS BEGIN
DECLARE
@Resultado	varchar(max),
@EnviarPara	varchar(255),
@eMail		varchar(255),
@Enviar		bit
SELECT @Enviar = EnviarXML FROM CteCFD WHERE Cliente = @Cliente AND Almacenar = 1 AND AlmacenarTipo = 'ESPECIFICO'
IF ISNULL(@Enviar,0) = 0
SELECT @Enviar = CASE WHEN EnviarXML = 1 OR EnviarPDF = 1 THEN 1 ELSE 0 END FROM EmpresaCFD WHERE Empresa = @Empresa AND (AlmacenarPDF = 1 OR AlmacenarXML = 1)
IF ISNULL(@Enviar,0) = 1
BEGIN
DECLARE crCteCto CURSOR LOCAL FOR
SELECT eMail
FROM CteCto
WHERE Cliente = @Cliente AND CFD_Enviar = 1 AND NULLIF(RTRIM(eMail), '') IS NOT NULL
OPEN crCteCto
FETCH NEXT FROM crCteCto INTO @eMail
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @EnviarPara <> '' SELECT @EnviarPara = @EnviarPara+';'
SELECT @EnviarPara = @EnviarPara + @eMail
END
FETCH NEXT FROM crCteCto INTO @eMail
END
CLOSE crCteCto
DEALLOCATE crCteCto
SELECT @Resultado = @EnviarPara
END
RETURN (@Resultado)
END

