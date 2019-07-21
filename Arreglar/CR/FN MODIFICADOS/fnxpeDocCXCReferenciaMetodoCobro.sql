SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnxpeDocCXCReferenciaMetodoCobro
(
@ID               int,
@Ref              bit,
@Resultado        varchar(max)
)
RETURNS varchar(max)
AS
BEGIN
RETURN RTRIM(LTRIM(@Resultado))
END

