SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPCPInsertarTemporalCatalogoRama
@Estacion				int,
@CatalogoTipo			varchar(50),
@Catalogo				varchar(20),
@Nombre					varchar(50),
@Categoria				varchar(1)

AS BEGIN
DECLARE
@RID				int
IF NOT EXISTS(SELECT * FROM PCPDTemporalCatalogoRama WHERE CatalogoTipo = @CatalogoTipo AND Catalogo = @Catalogo AND Estacion = @Estacion /*AND Nombre = @Nombre*/ AND @Categoria = @Categoria)
INSERT PCPDTemporalCatalogoRama (Estacion, CatalogoTipo, Catalogo, Nombre, Categoria) VALUES (@Estacion, @CatalogoTipo, @Catalogo, @Nombre, @Categoria)
ELSE
BEGIN
SELECT @RID = RID FROM PCPDTemporalCatalogoRama WHERE CatalogoTipo = @CatalogoTipo AND Catalogo = @Catalogo AND Estacion = @Estacion /*AND Nombre = @Nombre*/ AND @Categoria = @Categoria
UPDATE PCPDTemporalCatalogoRama
SET Nombre = @Nombre
WHERE RID = @RID
END
END

