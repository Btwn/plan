SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgeCommerceMetodoEnvioCfgABC ON eCommerceMetodoEnvioCfg

FOR INSERT, UPDATE ,DELETE
AS BEGIN
DECLARE
@eCommerceSucursal   varchar(10),
@MetodoEnvio         varchar(50),
@Nombre              varchar(100),
@NombreAntes         varchar(100),
@Estatus             varchar(10),
@Ok                  int,
@OkRef               varchar(255),
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
IF @Estatus IN( 'ALTA' ,'CAMBIO')
SELECT @eCommerceSucursal = SucursaleCommerce, @MetodoEnvio = MetodoEnvio , @Nombre = Nombre FROM INSERTED
IF @Estatus IN( 'BAJA', 'CAMBIO')
SELECT @NombreAntes = Nombre FROM DELETED
IF @Estatus IN( 'BAJA')
SELECT @eCommerceSucursal = SucursaleCommerce, @MetodoEnvio = MetodoEnvio , @Nombre = Nombre FROM DELETED
SELECT @Sucursal = Sucursal FROM Sucursal WHERE    eCommerceSucursal = @eCommerceSucursal
IF NULLIF(@eCommerceSucursal,'') IS NOT NULL AND @Sucursal IS NOT NULL
EXEC speCommerceSolicitudISeCommerceMetodoEnvioCfg @eCommerceSucursal, @MetodoEnvio, @Nombre, @NombreAntes, @Sucursal,  @Estatus
END

