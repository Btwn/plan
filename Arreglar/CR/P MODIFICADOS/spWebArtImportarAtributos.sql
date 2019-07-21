SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebArtImportarAtributos
@Estacion        int,
@IDArt           int

AS BEGIN
DECLARE
@Nombre           varchar(255),
@Valor            varchar(255),
@Ok               int
DELETE WebArtAtributos WHERE IDArt = @IDArt
DECLARE crArt CURSOR FOR
SELECT Nombre,  Valor
FROM WebArtAtributosCatDTemp WITH(NOLOCK)
WHERE ID IN (SELECT ID FROM ListaID WITH(NOLOCK) WHERE Estacion = @Estacion)
OPEN crArt
FETCH NEXT FROM crArt INTO @Nombre,  @Valor
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF NOT EXISTS(SELECT * FROM WebArtAtributos WITH(NOLOCK) WHERE IDArt = @IDArt AND Valor = @Valor AND Nombre = @Nombre)
INSERT WebArtAtributos(IDArt,  Nombre,  Valor)
SELECT                 @IDArt, @Nombre, @Valor
IF @@ERROR <> 0 SET @Ok = 1
FETCH NEXT FROM crArt INTO @Nombre,  @Valor
END
CLOSE crArt
DEALLOCATE crArt
END

