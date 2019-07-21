SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnWebConsecutivoImagenEnvoltura
(
@IDEnvoltura				int,
@Archivo         varchar(255)
)
RETURNS varchar(255)

AS BEGIN
DECLARE
@Orden int,
@CantidadImagenes  int,
@Nombre varchar(50),
@SucursaleCommerce varchar(10),
@Sucursal	int
SELECT @SucursaleCommerce = SucursaleCommerce FROM WebEnvolturaRegalo WHERE ID = @IDEnvoltura
SELECT @Sucursal = Sucursal FROM Sucursal WHERE eCommerceSucursal = @SucursaleCommerce
SELECT @Nombre = CONVERT(varchar(50), @Sucursal)+'Imagen'+CONVERT(varchar,@IDEnvoltura)
SELECT @Nombre = @Nombre + ISNULL(dbo.fnWebTipoArchivo(@Archivo),'')
RETURN (@Nombre)
END

