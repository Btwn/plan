SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnPCPCatalogoClave
(
@RID					int
)
RETURNS varchar(20)

AS BEGIN
DECLARE
@Resultado	varchar(20)
SELECT @Resultado = ISNULL(Clave,'') FROM ClavePresupuestalCatalogo WHERE RID = @RID
RETURN (@Resultado)
END

