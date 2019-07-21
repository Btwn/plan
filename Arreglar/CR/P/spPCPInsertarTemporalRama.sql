SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPCPInsertarTemporalRama
@Estacion				int,
@CatalogoRamaTipo		varchar(50),
@Categoria				varchar(1)

AS BEGIN
IF NOT EXISTS(SELECT * FROM PCPDTemporalRama WHERE CatalogoRamaTipo = @CatalogoRamaTipo AND Estacion = @Estacion AND Categoria = @Categoria)
INSERT PCPDTemporalRama (Estacion, CatalogoRamaTipo, Categoria) VALUES (@Estacion, @CatalogoRamaTipo, @Categoria)
END

