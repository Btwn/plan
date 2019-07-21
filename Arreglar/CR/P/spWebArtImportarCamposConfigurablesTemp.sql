SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebArtImportarCamposConfigurablesTemp
@Estacion        int

AS BEGIN
DECLARE
@Tipo   varchar(50),
@Ok     int
SELECT @Tipo = Tipo FROM WebArtCamposConfigurablesCatTemp WHERE Estacion = @Estacion
DELETE WebArtCamposConfigurablesCatDTemp WHERE Estacion = @Estacion
INSERT WebArtCamposConfigurablesCatDTemp(Estacion,Tipo,Nombre,TipoCampo)
SELECT                                  @Estacion,@Tipo,Nombre, TipoCampo
FROM WebArtCamposConfigurablesCatD
WHERE Tipo = @Tipo
END

