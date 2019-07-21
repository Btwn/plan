SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnPCPCatalogoTipo
(
@Proyecto				varchar(50),
@Catalogo				varchar(20)
)
RETURNS varchar(50)

AS BEGIN
DECLARE
@Resultado	varchar(50)
SELECT @Resultado = ISNULL(Tipo,'') FROM ClavePresupuestalCatalogo WHERE RTRIM(Proyecto) = RTRIM(@Proyecto) AND Clave = RTRIM(@Catalogo)
RETURN (@Resultado)
END

