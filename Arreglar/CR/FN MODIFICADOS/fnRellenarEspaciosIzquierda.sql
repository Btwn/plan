SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnRellenarEspaciosIzquierda
(
@Numero				varchar(100),
@Longitud				int
)
RETURNS varchar(100)

AS BEGIN
DECLARE
@Resultado   varchar(100)
SET @Numero =RTRIM(LTRIM(@Numero))
SELECT  @Resultado =  dbo.fnRellenarConCaracter (@Numero,@Longitud,'i',' ')
RETURN (@Resultado)
END

