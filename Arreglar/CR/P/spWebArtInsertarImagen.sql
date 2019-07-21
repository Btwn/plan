SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebArtInsertarImagen
@IDArt           int,
@Directorio      varchar(255),
@Nombre          varchar(255)

AS BEGIN
DECLARE
@Orden int
SELECT @Orden = ISNULL(MAX(orden),0)+1 FROM  WebArtImagen WHERE IDArt = @IDArt
IF NULLIF(@Directorio,'') IS NULL OR @IDArt IS NULL RETURN
INSERT WebArtImagen(IDArt,ArchivoImagen,Orden,Nombre,TipoArchivo)
SELECT              @IDArt,@Directorio,@Orden, dbo.fnWebQuitarTipoArchivo(@Nombre),dbo.fnWebTipoArchivo(@Nombre)
END

