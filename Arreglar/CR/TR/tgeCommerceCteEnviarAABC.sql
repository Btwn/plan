SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgeCommerceCteEnviarAABC ON CteEnviarA

FOR INSERT, UPDATE ,DELETE
AS BEGIN
DECLARE
@IDEnviarA           int,
@IDUsuario           int,
@Cliente             varchar(10),
@Estatus             varchar(10),
@Ok                  int,
@OkRef               varchar(255),
@eCommerceSucursal    varchar(10),
@Sucursal            int,
@Cinserted           int,
@Cdeleted            int,
@eCommerceEmpresa    bit,
@Empresa		varchar(5),
@IDAcceso            int,
@Pais				varchar(30),
@PaisID				int,
@Estado				varchar(30)
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
SELECT Cliente, ID
FROM Inserted
SELECT @Pais = dbo.fneCommerceReemplazarAcentos(Pais), @Estado = dbo.fneCommerceReemplazarAcentos(Estado) FROM Inserted
IF(ISNULL(@Pais, '') != '')
BEGIN
IF NOT EXISTS (SELECT ID FROM WebPais WHERE UPPER(Nombre) = UPPER(@Pais))
INSERT INTO WebPais (Nombre) VALUES (@Pais)
SELECT @PaisID = ID FROM WebPais WHERE Nombre = @Pais
END
IF(ISNULL(@Estado, '') != '')
BEGIN
IF NOT EXISTS (SELECT ID FROM WebPaisEstado WHERE UPPER(Nombre) = UPPER(@Estado) AND IDPais = @PaisID)
INSERT INTO WebPaisEstado (IDPais, Nombre) VALUES (@PaisID, @Estado)
END
END
ELSE
IF @Estatus = 'BAJA'
BEGIN
DECLARE crActualizar CURSOR local FOR
SELECT Cliente, ID
FROM Deleted
END
IF @Estatus IS NOT NULL
BEGIN
OPEN crActualizar
FETCH NEXT FROM crActualizar INTO @Cliente, @IDEnviarA
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
IF EXISTS(SELECT * FROM WebUsuarios WHERE Cliente = @Cliente)
BEGIN
DECLARE crUsuario CURSOR local FOR
SELECT ID
FROM WebUsuarios
WHERE Cliente = @Cliente
OPEN crUsuario
FETCH NEXT FROM crUsuario INTO @IDUsuario
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
EXEC speCommerceSolicitudISWebCteEnviarA @IDUsuario, @Cliente,@IDEnviarA, @Sucursal, @eCommerceSucursal, @Estatus
FETCH NEXT FROM crUsuario INTO @IDUsuario
END
CLOSE crUsuario
DEALLOCATE crUsuario
END
FETCH NEXT FROM crSucursal INTO @Sucursal, @eCommerceSucursal
END
CLOSE crSucursal
DEALLOCATE crSucursal
END
FETCH NEXT FROM crActualizar INTO @Cliente, @IDEnviarA
END
CLOSE crActualizar
DEALLOCATE crActualizar
END
END

