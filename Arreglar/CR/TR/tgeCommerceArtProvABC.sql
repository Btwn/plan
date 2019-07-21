SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgeCommerceArtProvABC ON ArtProv

FOR INSERT, UPDATE ,DELETE
AS BEGIN
DECLARE
@Articulo			varchar(20),
@SubCuenta			varchar(50),
@Proveedor			varchar(10),
@IDUsuario           int,
@Estatus             varchar(10),
@Ok                  int,
@OkRef               varchar(255),
@eCommerceSucursal    varchar(10),
@Sucursal            int,
@Cinserted           int,
@Cdeleted            int
SELECT @Cinserted =  COUNT(*) FROM inserted
SELECT @Cdeleted =  COUNT(*) FROM deleted
IF @Cinserted <> 0 AND @Cdeleted = 0
SET @Estatus = 'ALTA'
IF @Cinserted <> 0 AND @Cdeleted<> 0
SET @Estatus = 'CAMBIO'
IF @Cinserted = 0 AND @Cdeleted <> 0
SET @Estatus = 'BAJA'
IF  @Estatus IN( 'ALTA','CAMBIO')
BEGIN
DECLARE crActualizar CURSOR local FOR
SELECT Articulo, SubCuenta, Proveedor
FROM Inserted
END
ELSE
IF @Estatus = 'BAJA'
BEGIN
DECLARE crActualizar CURSOR local FOR
SELECT Articulo, SubCuenta, Proveedor
FROM Deleted
END
IF @Estatus IS NOT NULL
BEGIN
OPEN crActualizar
FETCH NEXT FROM crActualizar INTO @Articulo, @SubCuenta, @Proveedor
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF (EXISTS(SELECT ID FROM WebArt WHERE Articulo = @Articulo AND SubCuenta = @SubCuenta) OR EXISTS(SELECT ID FROM WebArtVariacionCombinacion WHERE Articulo = Articulo AND SubCuenta = @SubCuenta)) AND EXISTS(SELECT * FROM Sucursal WHERE eCommerce = 1 AND NULLIF(eCommerceSucursal,'') IS NOT NULL)
BEGIN
DECLARE crSucursal CURSOR local FOR
SELECT Sucursal, eCommerceSucursal
FROM Sucursal
WHERE eCommerce = 1 AND NULLIF(eCommerceSucursal,'') IS NOT NULL
OPEN crSucursal
FETCH NEXT FROM crSucursal INTO @Sucursal, @eCommerceSucursal
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
EXEC speCommerceSolicitudISArtProv @Articulo, @SubCuenta, @Proveedor, @Sucursal, @eCommerceSucursal, @Estatus, @Ok, @OkRef
FETCH NEXT FROM crSucursal INTO @Sucursal, @eCommerceSucursal
END
CLOSE crSucursal
DEALLOCATE crSucursal
END
FETCH NEXT FROM crActualizar INTO @Articulo, @SubCuenta, @Proveedor
END
CLOSE crActualizar
DEALLOCATE crActualizar
END
END

