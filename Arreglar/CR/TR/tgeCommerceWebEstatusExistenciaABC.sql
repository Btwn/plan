SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgeCommerceWebEstatusExistenciaABC ON WebEstatusExistencia

FOR INSERT, UPDATE ,DELETE
AS BEGIN
DECLARE
@WebEstatusExistencia	varchar(20),
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
SELECT WebEstatusExistencia, Sucursal
FROM Inserted
END
ELSE
IF @Estatus = 'BAJA'
BEGIN
DECLARE crActualizar CURSOR local FOR
SELECT WebEstatusExistencia, Sucursal
FROM Deleted
END
IF @Estatus IS NOT NULL
BEGIN
OPEN crActualizar
FETCH NEXT FROM crActualizar INTO @WebEstatusExistencia, @Sucursal
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF EXISTS(SELECT * FROM Sucursal WHERE eCommerce = 1 AND NULLIF(eCommerceSucursal,'') IS NOT NULL)
BEGIN
SELECT @eCommerceSucursal = eCommerceSucursal FROM Sucursal WHERE Sucursal = @Sucursal
EXEC speCommerceSolicitudISWebEstatusExistencia @WebEstatusExistencia, @Sucursal, @eCommerceSucursal, @Estatus, @Ok, @OkRef
END
FETCH NEXT FROM crActualizar INTO @WebEstatusExistencia, @Sucursal
END
CLOSE crActualizar
DEALLOCATE crActualizar
END
END

