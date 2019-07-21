SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnPCPCatalogoTieneSubCatalogo
(
@Catalogo				varchar(20),
@Proyecto				varchar(50),
@Categoria				varchar(1)
)
RETURNS bit

AS BEGIN
DECLARE
@Resultado			bit
SELECT @Resultado = 0
IF EXISTS(SELECT * FROM ClavePresupuestalCatalogo cpc WITH(NOLOCK) JOIN ClavePresupuestalCatalogo cpc1 WITH(NOLOCK) ON ISNULL(cpc1.Rama,'') = CONVERT(varchar,cpc.RID) WHERE cpc.Proyecto = @Proyecto AND cpc.Clave = @Catalogo AND cpc.Categoria = @Categoria) SELECT @Resultado = 1
RETURN (@Resultado)
END

