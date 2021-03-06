SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnPCPCatalogoObservaciones
(
@Proyecto				varchar(50),
@Clave					varchar(20)
)
RETURNS varchar(255)

AS BEGIN
DECLARE
@Resultado	varchar(255)
SELECT @Resultado = ISNULL(Descripcion,'') FROM ClavePresupuestalCatalogo WITH(NOLOCK) WHERE Clave = @Clave AND Proyecto = @Proyecto
RETURN (@Resultado)
END

