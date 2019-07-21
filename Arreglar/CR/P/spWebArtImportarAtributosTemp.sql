SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebArtImportarAtributosTemp
@Estacion        int

AS BEGIN
DECLARE
@Tipo   varchar(50),
@Ok     int
SELECT @Tipo = Tipo FROM WebArtAtributosCatTemp WHERE Estacion = @Estacion
DELETE WebArtAtributosCatDTemp WHERE Estacion = @Estacion
INSERT WebArtAtributosCatDTemp(Estacion,  Tipo,  Nombre, Valor)
SELECT                         @Estacion, @Tipo, Nombre, Valor
FROM WebArtAtributosCatD
WHERE Tipo = @Tipo
END

