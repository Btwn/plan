SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMAFInsertarActivoFTipoIndicador
@Empresa		varchar(5),
@ID			int,
@Articulo		varchar(20),
@Serie			varchar(50),
@Ok			int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE	@Tipo		varchar(50)
DELETE FROM GestionActivoFIndicador WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
SELECT @Tipo = Tipo FROM ActivoF WITH (NOLOCK) WHERE Articulo = @Articulo AND Serie = @Serie
INSERT GestionActivoFIndicador (ID,  Tipo,  Indicador,     Referencia,     LecturaAnterior)
SELECT @ID,  @Tipo, afi.Indicador, afi.Referencia, afi.Lectura
FROM ActivoFIndicador afi WITH (NOLOCK) JOIN ActivoF af WITH (NOLOCK)
ON afi.ActivoFID = af.ID
WHERE af.Articulo = @Articulo
AND af.Serie = @Serie
AND af.Empresa = @Empresa
IF @@ERROR <> 0 SET @Ok = 1
END
END

