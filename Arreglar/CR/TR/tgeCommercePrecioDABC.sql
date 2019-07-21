SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgeCommercePrecioDABC ON PrecioD

FOR INSERT, UPDATE ,DELETE
AS BEGIN
DECLARE
@PrecioID            int,
@CantidadI           float,
@CantidadD           float,
@Estatus             varchar(10),
@Ok                  int,
@OkRef               varchar(255),
@eCommerceSucursal   varchar(10),
@GUID                varchar(50),
@Sucursal            int,
@Cinserted           int,
@Cdeleted            int,
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
DECLARE crActualizar CURSOR FOR
SELECT i.ID, i.Cantidad, d.Cantidad, i.GUID
FROM Inserted i  LEFT JOIN DELETED d ON i.ID = d.ID AND i.GUID = d.GUID
END
ELSE
IF @Estatus = 'BAJA'
BEGIN
DECLARE crActualizar CURSOR local FOR
SELECT ID, Cantidad, NULL, GUID
FROM Deleted
END
IF @Estatus IS NOT NULL
BEGIN
OPEN crActualizar
FETCH NEXT FROM crActualizar INTO  @PrecioID, @CantidadI, @CantidadD, @GUID
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
EXEC speCommerceSolicitudISPrecioD  @Sucursal, @PrecioID, @CantidadI, @CantidadD, @GUID,  @eCommerceSucursal, @Estatus
FETCH NEXT FROM crSucursal INTO @Sucursal, @eCommerceSucursal
END
CLOSE crSucursal
DEALLOCATE crSucursal
END
FETCH NEXT FROM crActualizar INTO  @PrecioID, @CantidadI, @CantidadD, @GUID
END
CLOSE crActualizar
DEALLOCATE crActualizar
END
END

