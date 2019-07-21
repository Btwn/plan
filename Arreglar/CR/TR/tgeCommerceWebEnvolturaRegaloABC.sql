SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgeCommerceWebEnvolturaRegaloABC ON WebEnvolturaRegalo

FOR INSERT, UPDATE ,DELETE
AS BEGIN
DECLARE
@ID					int,
@IDUsuario           int,
@Estatus             varchar(10),
@Ok                  int,
@OkRef               varchar(255),
@SucursaleCommerce   varchar(10),
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
SELECT ID, SucursaleCommerce
FROM Inserted
END
ELSE
IF @Estatus = 'BAJA'
BEGIN
DECLARE crActualizar CURSOR local FOR
SELECT ID, SucursaleCommerce
FROM Deleted
END
IF @Estatus IS NOT NULL
BEGIN
OPEN crActualizar
FETCH NEXT FROM crActualizar INTO @ID, @SucursaleCommerce
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @Sucursal = Sucursal FROM Sucursal WHERE eCommerceSucursal = @SucursaleCommerce
EXEC speCommerceSolicitudISWebEnvolturaRegalo @ID, @Sucursal, @SucursaleCommerce, @Estatus, @Ok, @OkRef
FETCH NEXT FROM crActualizar INTO @ID, @SucursaleCommerce
END
CLOSE crActualizar
DEALLOCATE crActualizar
END
END

