SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPCPCatalogoLista
@Estacion				int,
@CatalogoRamaTipo		varchar(50),
@Proyecto				varchar(50),
@Categoria				varchar(1)

AS BEGIN
SELECT
Clave,
Nombre
FROM ClavePresupuestalCatalogo
WHERE Proyecto = @Proyecto
AND Tipo = @CatalogoRamaTipo
AND Categoria = @Categoria
UNION
SELECT
Catalogo,
Nombre
FROM PCPDTemporalCatalogoRama
WHERE CatalogoTipo = @CatalogoRamaTipo
AND Estacion = @Estacion
AND Categoria = @Categoria
END

