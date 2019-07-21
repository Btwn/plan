SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgeCommerceWebSucursalImagenABC ON WebSucursalImagen

FOR INSERT, UPDATE ,DELETE
AS BEGIN
DECLARE
@Estatus             varchar(10),
@Nombre              varchar(50),
@Ok                  int,
@OkRef               varchar(255),
@eCommerceSucursal   varchar(10),
@Sucursal            int,
@Cinserted           int,
@Cdeleted            int,
@TipoArchivo         varchar(10),
@eCommerceEmpresa    bit,
@Empresa		varchar(5),
@IDAcceso            int
SELECT @IDAcceso = dbo.fnAccesoID(@@SPID)
SELECT @Empresa = Empresa FROM Acceso WHERE ID = @IDAcceso
SELECT @eCommerceEmpresa = ISNULL(eCommerce,0) FROM EmpresaGral WHERE Empresa = @Empresa
IF dbo.fnEstaSincronizando() = 1 RETURN
IF ISNULL(@eCommerceEmpresa,0) = 0 RETURN
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
SELECT Sucursal, Nombre, TipoArchivo
FROM Inserted
END
ELSE
IF @Estatus = 'BAJA'
BEGIN
DECLARE crActualizar CURSOR local FOR
SELECT Sucursal, Nombre, TipoArchivo
FROM Deleted
END
IF @Estatus IS NOT NULL
BEGIN
OPEN crActualizar
FETCH NEXT FROM crActualizar INTO @Sucursal, @Nombre, @TipoArchivo
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF EXISTS(SELECT * FROM Sucursal WHERE eCommerce = 1 AND NULLIF(eCommerceSucursal,'') IS NOT NULL AND Sucursal = @Sucursal)
BEGIN
SELECT @eCommerceSucursal = eCommerceSucursal FROM Sucursal WHERE Sucursal = @Sucursal
EXEC speCommerceSolicitudISWebSucursalImagen @Sucursal, @Nombre, @eCommerceSucursal, @Estatus,  @TipoArchivo
END
FETCH NEXT FROM crActualizar INTO @Sucursal, @Nombre, @TipoArchivo
END
CLOSE crActualizar
DEALLOCATE crActualizar
END
END

