SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgeCommerceWebUsuarioABC ON WebUsuarios

FOR INSERT, UPDATE ,DELETE
AS BEGIN
DECLARE
@IDUsuario           int,
@Estatus             varchar(10),
@Ok                  int,
@OkRef               varchar(255),
@Empresa             varchar(5),
@eCommerceSucursal   varchar(10),
@Sucursal            int,
@Cinserted           int,
@Cdeleted            int,
@Cliente             varchar(10),
@eCommerceEmpresa    bit,
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
SELECT ID, Empresa, Sucursal, Cliente
FROM Inserted
END
ELSE
IF @Estatus = 'BAJA'
BEGIN
DECLARE crActualizar CURSOR local FOR
SELECT ID, Empresa, Sucursal, Cliente
FROM Deleted
END
IF @Estatus IS NOT NULL
BEGIN
OPEN crActualizar
FETCH NEXT FROM crActualizar INTO @IDUsuario, @Empresa, @Sucursal, @Cliente
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
EXEC speCommerceSolicitudISWebUsuario @IDUsuario,@Empresa, @Sucursal, @eCommerceSucursal, @Estatus
IF @Estatus IN( 'ALTA','CAMBIO')
BEGIN
IF @Ok IS NULL
EXEC speCommerceSolicitudISWebUsuarioDireccion @IDUsuario, @Cliente, @Empresa, @Sucursal, @eCommerceSucursal, @Estatus, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND EXISTS(SELECT * FROM CteEnviarA WHERE Cliente = @Cliente) AND @Estatus = 'ALTA'
UPDATE CteEnviarA SET Nombre = Nombre WHERE Cliente = @Cliente
END
IF NOT EXISTS(SELECT ID FROM CteEnviarA WHERE Cliente = @Cliente)
BEGIN
INSERT CteEnviarA(ID, GUID, Cliente,  Nombre,	Direccion,          DireccionNumeroInt,                                          Pais,     Estado,   Poblacion, CodigoPostal, Estatus, Delegacion,  DireccionNumero, Colonia,   eMail1, Telefonos)
SELECT 			  1, NEWID(), Cliente, ISNULL(NULLIF(Nombre, ''), 'N/A'), ISNULL(NULLIF(Direccion, ''), 'N/A'),          ISNULL(NULLIF(DireccionNumeroInt, ''), 'N/A'),                                          ISNULL(NULLIF(Pais, ''), 'N/A'),     ISNULL(NULLIF(Estado, ''), 'N/A'),   ISNULL(NULLIF(Poblacion, ''), 'N/A'), ISNULL(NULLIF(CodigoPostal, '00000'), 'N/A'), Estatus, ISNULL(NULLIF(Delegacion, ''), 'N/A'),  ISNULL(NULLIF(DireccionNumero, ''), 'N/A'), ISNULL(NULLIF(Colonia, ''), 'N/A'),   ISNULL(NULLIF(eMail1, ''), 'N/A'), ISNULL(NULLIF(Telefonos, ''), '00000')
FROM Cte WHERE Cliente = @Cliente
END
FETCH NEXT FROM crSucursal INTO @Sucursal, @eCommerceSucursal
END
CLOSE crSucursal
DEALLOCATE crSucursal
END
FETCH NEXT FROM crActualizar INTO @IDUsuario, @Empresa, @Sucursal, @Cliente
END
CLOSE crActualizar
DEALLOCATE crActualizar
END
END

