SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgeCommerceSucursalABC ON Sucursal

FOR INSERT, UPDATE ,DELETE
AS BEGIN
DECLARE
@Estatus             varchar(10),
@Ok                  int,
@OkRef               varchar(255),
@eCommerceSucursal   varchar(10),
@Sucursal            int,
@SucursalCambio      int,
@Cinserted           int,
@Cdeleted            int,
@eCommerceSincronizaD bit,
@eCommerceSincronizaI bit,
@eCommerceEmpresa    bit,
@Empresa		varchar(5),
@IDAcceso            int
SELECT @IDAcceso = dbo.fnAccesoID(@@SPID)
SELECT @Empresa = Empresa FROM Acceso WHERE ID = @IDAcceso
SELECT @eCommerceEmpresa = ISNULL(eCommerce,0) FROM EmpresaGral WHERE Empresa = @Empresa
IF dbo.fnEstaSincronizando() = 1 RETURN
IF ISNULL(@eCommerceEmpresa,0) = 0 RETURN
SELECT @eCommerceSincronizaD = eCommerceSincroniza FROM DELETED
SELECT @eCommerceSincronizaI = eCommerceSincroniza FROM INSERTED
IF @eCommerceSincronizaD <> @eCommerceSincronizaI
BEGIN
INSERT eCommerceSaldoU(Articulo, SubCuenta)
SELECT a.Articulo,ISNULL(a.SubCuenta ,'')
FROM WebArt a LEFT OUTER JOIN eCommerceSaldoU u ON a.Articulo = u.Articulo AND ISNULL(a.SubCuenta,'')=u.Subcuenta
WHERE u.Articulo IS NULL AND a.Articulo IS NOT NULL
GROUP BY a.Articulo,a.SubCuenta
INSERT eCommerceSaldoU(Articulo, SubCuenta)
SELECT a.Articulo,ISNULL(a.SubCuenta ,'')
FROM WebArtVariacionCombinacion a LEFT OUTER JOIN eCommerceSaldoU u ON a.Articulo = u.Articulo AND ISNULL(a.SubCuenta,'')=u.Subcuenta
WHERE u.Articulo IS NULL AND a.Articulo IS NOT NULL
GROUP BY a.Articulo,a.SubCuenta
END
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
DECLARE crActualizar CURSOR FOR
SELECT Sucursal
FROM Inserted
END
ELSE
IF @Estatus = 'BAJA'
BEGIN
DECLARE crActualizar CURSOR local FOR
SELECT Sucursal
FROM Deleted
END
IF @Estatus IS NOT NULL
BEGIN
OPEN crActualizar
FETCH NEXT FROM crActualizar INTO @SucursalCambio
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF EXISTS(SELECT * FROM Sucursal WHERE eCommerce = 1 AND NULLIF(eCommerceSucursal,'') IS NOT NULL)
BEGIN
DECLARE crSucursal CURSOR local FOR
SELECT Sucursal, eCommerceSucursal
FROM Sucursal
WHERE eCommerce = 1 AND NULLIF(eCommerceSucursal,'') IS NOT NULL
OPEN crSucursal
FETCH NEXT FROM crSucursal INTO @Sucursal, @eCommerceSucursal
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
EXEC speCommerceSolicitudISSucursal  @SucursalCambio, @Sucursal, @eCommerceSucursal, @Estatus
FETCH NEXT FROM crSucursal INTO @Sucursal, @eCommerceSucursal
END
CLOSE crSucursal
DEALLOCATE crSucursal
END
FETCH NEXT FROM crActualizar INTO @SucursalCambio
END
CLOSE crActualizar
DEALLOCATE crActualizar
END
END

