SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgInforProvABC ON Prov

FOR INSERT, UPDATE ,DELETE
AS BEGIN
DECLARE
@ProdInterfazINFOR					bit,
@Proveedor						varchar (10),
@Estatus						varchar (10),
@Datos						varchar (max),
@Datos2						varchar (max),
@Resultado						varchar(max),
@Ok							int,
@OkRef						varchar(255),
@Id							int,
@Cinserted		                		int,
@Cdeleted						int,
@Empresa						varchar(20),
@ReferenciaIntelisisService			varchar(50)
SELECT @ID = dbo.fnAccesoID(@@SPID)
SELECT @Empresa = Empresa FROM Acceso WHERE ID = @ID
SELECT @ProdInterfazINFOR = ProdInterfazINFOR
FROM EmpresaGral WHERE Empresa = @Empresa
SELECT @Cinserted =  COUNT(*) FROM inserted
SELECT @Cdeleted =  COUNT(*) FROM deleted
IF @ProdInterfazINFOR = 1
BEGIN
IF @Cinserted <> 0 AND @Cdeleted = 0
BEGIN
SET @Estatus = 'ALTA'
END
IF @Cinserted <> 0 AND @Cdeleted<> 0
BEGIN
SET @Estatus = 'CAMBIO'
END
IF @Cinserted = 0 AND @Cdeleted <> 0
BEGIN
SET @Estatus = 'BAJA'
END
IF  @Estatus IN( 'ALTA','CAMBIO')
BEGIN
DECLARE crActualizar CURSOR LOCAL FAST_FORWARD FOR
SELECT Proveedor,ReferenciaIntelisisService
FROM Inserted
END
ELSE
IF @Estatus = 'BAJA'
BEGIN
DECLARE crActualizar CURSOR LOCAL FAST_FORWARD FOR
SELECT Proveedor,ReferenciaIntelisisService
FROM Deleted
END
IF @Estatus IN( 'ALTA','CAMBIO', 'BAJA')
BEGIN
OPEN crActualizar
FETCH NEXT FROM crActualizar INTO @Proveedor ,@ReferenciaIntelisisService
WHILE @@FETCH_STATUS = 0
BEGIN
EXEC spInforGenerarSolicitudProveedor  @Proveedor,@Estatus,@ReferenciaIntelisisService,@Datos OUTPUT
FETCH NEXT FROM crActualizar INTO @Proveedor,@ReferenciaIntelisisService
END
CLOSE crActualizar
DEALLOCATE crActualizar
END
END
END

