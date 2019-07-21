SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebSucursalInsertarImagen
@Sucursal         int,
@Directorio      varchar(255),
@Nombre          varchar(255)

AS BEGIN
DECLARE
@Orden int
SELECT @Orden = ISNULL(MAX(orden),0)+1 FROM  WebSucursalImagen WHERE Sucursal = @Sucursal
IF NULLIF(@Directorio,'') IS NULL OR @Sucursal IS NULL RETURN
INSERT WebSucursalImagen(Sucursal,ArchivoImagen,Orden,Nombre,TipoArchivo)
SELECT                  @Sucursal,@Directorio,@Orden, dbo.fnWebQuitarTipoArchivo(@Nombre),dbo.fnWebTipoArchivo(@Nombre)
END

