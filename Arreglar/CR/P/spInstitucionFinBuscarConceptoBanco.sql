SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInstitucionFinBuscarConceptoBanco
@Institucion	varchar(20),
@Concepto	varchar(50),
@Resultado	varchar(50)	OUTPUT

AS BEGIN
DECLARE
@ConceptoBanco	varchar(50),
@p			int
SELECT @Resultado	= NULL
DECLARE crInstitucionFinConcepto CURSOR LOCAL FOR
SELECT ConceptoBanco
FROM InstitucionFinConcepto
WHERE Institucion = @Institucion AND (ConceptoBanco LIKE '%<RB>' OR ConceptoBanco LIKE '%*')
OPEN crInstitucionFinConcepto
FETCH NEXT FROM crInstitucionFinConcepto INTO @ConceptoBanco
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0 AND @Resultado IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @p = 0
SELECT @p = CHARINDEX('*', @ConceptoBanco)
IF @p = 0 SELECT @p = CHARINDEX('<RB>', @ConceptoBanco)
IF @p > 0 AND SUBSTRING(@Concepto, 1, @p-1) = SUBSTRING(@ConceptoBanco, 1, @p-1)
SELECT @Resultado = @ConceptoBanco
END
FETCH NEXT FROM crInstitucionFinConcepto INTO @ConceptoBanco
END
CLOSE crInstitucionFinConcepto
DEALLOCATE crInstitucionFinConcepto
RETURN
END

