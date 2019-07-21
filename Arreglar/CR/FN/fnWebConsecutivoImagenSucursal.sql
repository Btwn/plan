SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnWebConsecutivoImagenSucursal
(
@Sucursal          int,
@Archivo         varchar(255)
)
RETURNS varchar(255)

AS BEGIN
DECLARE
@Orden int,
@CantidadImagenes  int,
@Nombre varchar(50),
@Extencion          varchar(10)
SELECT @CantidadImagenes = ISNULL(COUNT(*),0)+1 FROM  WebSucursalImagen WHERE Sucursal = @Sucursal
SELECT @Nombre = CONVERT(varchar,@Sucursal)+'_Imagen'+CONVERT(varchar,@CantidadImagenes)
WHILE EXISTS(SELECT Nombre FROM  WebSucursalImagen WHERE Nombre = @Nombre AND Sucursal = @Sucursal)
BEGIN
SELECT @Nombre = CONVERT(varchar,@Sucursal)+'_Imagen'+CONVERT(varchar,@CantidadImagenes)
SELECT @CantidadImagenes = @CantidadImagenes +1
END
SELECT @Orden = ISNULL(MAX(orden),0)+1 FROM  WebSucursalImagen WHERE Sucursal = @Sucursal
SELECT @Nombre = @Nombre + ISNULL(dbo.fnWebTipoArchivo(@Archivo),'')
RETURN (@Nombre)
END

