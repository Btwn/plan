SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgeCommerceWebCertificadosRegaloABC ON WebCertificadosRegalo
FOR INSERT, UPDATE ,DELETE
AS BEGIN
DECLARE
@IDCertificado		int,
@IDCertificadoA		int,
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
IF  @Estatus IN ('ALTA', 'CAMBIO')
BEGIN
DECLARE crActualizar CURSOR local FOR
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
FETCH NEXT FROM crActualizar INTO @Sucursal
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @SucursaleCommerce = eCommerceSucursal FROM Sucursal WHERE @Sucursal = Sucursal
EXEC speCommerceSolicitudISWebCertificadosRegalo @Sucursal, @SucursaleCommerce, @Estatus, @Ok, @OkRef
FETCH NEXT FROM crActualizar INTO @Sucursal
END
CLOSE crActualizar
DEALLOCATE crActualizar
END
END

