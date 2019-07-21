SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebArtImportarCamposConfigurables
@Estacion        int,
@IDArt           int

AS BEGIN
DECLARE
@Tipo   varchar(50),
@Nombre varchar(255),
@TipoCampo varchar(255),
@ID     int,
@Ok     int
DELETE WebArtCamposConfigurables WHERE ID = @IDArt
DECLARE crArt CURSOR FOR
SELECT Nombre,  TipoCampo, Tipo
FROM WebArtCamposConfigurablesCatDTemp WITH(NOLOCK)
WHERE ID IN (SELECT ID FROM ListaID WITH(NOLOCK) WHERE Estacion = @Estacion)
OPEN crArt
FETCH NEXT FROM crArt INTO @Nombre,  @TipoCampo, @Tipo
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF NOT EXISTS(SELECT * FROM WebArtCamposConfigurables WITH(NOLOCK) WHERE IDArt = @IDArt AND TipoCampo = @TipoCampo AND Nombre = @Nombre)
INSERT WebArtCamposConfigurables(IDArt, Nombre, TipoCampo, Requerido, Orden)
SELECT                          @IDArt,@Nombre,  @TipoCampo, 0,0
IF @@ERROR <> 0 SET @Ok = 1
SELECT @ID = SCOPE_IDENTITY()
IF @TipoCampo =  'Menú de selección' AND @ID IS NOT NULL
BEGIN
IF NOT EXISTS(SELECT * FROM WebArtCamposConfigurablesD WITH(NOLOCK) WHERE ID = @ID)
INSERT WebArtCamposConfigurablesD (ID, Valor, Orden)
SELECT                             @ID,Valor,0
FROM WebArtCamposConfigurablesCatDD WITH(NOLOCK)
WHERE   Tipo = @Tipo AND Nombre = @Nombre
END
IF @@ERROR <> 0 SET @Ok = 1
FETCH NEXT FROM crArt INTO @Nombre,  @TipoCampo, @Tipo
END
CLOSE crArt
DEALLOCATE crArt
END

