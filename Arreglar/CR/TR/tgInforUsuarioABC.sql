SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgInforUsuarioABC ON Usuario

FOR INSERT, UPDATE ,DELETE
AS BEGIN
DECLARE
@ProdInterfazINFOR					bit,
@Usuario 							varchar (10),
@Nombre	 							varchar (10),
@Estatus							    varchar (10),
@Datos								varchar (max),
@Ok									int,
@OkRef								varchar(255),
@Id									int,
@Cinserted		                	int,
@Cdeleted			                int,
@ReferenciaIntelisisService			varchar(50),
@Empresa								varchar(20) ,
@Alta								datetime,
@Cinfo                               varbinary(128),
@EstatusIns						    varchar (10),
@EstatusDel						    varchar (10),
@EstatusUsuarioA					    varchar (10), 
@EstatusUsuarioN					    varchar (10), 
@EstatusInfor						varchar(10) 
SELECT @ID = dbo.fnAccesoID(@@SPID)
SELECT @Cinfo = Context_Info()
IF @Cinfo = 0x55555
RETURN
SELECT @Empresa = Empresa FROM Acceso WHERE ID = @ID
SELECT @ProdInterfazINFOR = ProdInterfazINFOR
FROM EmpresaGral WHERE Empresa = @Empresa
SELECT @Cinserted =  COUNT(*) FROM inserted
SELECT @Cdeleted =  COUNT(*) FROM deleted
IF @Cinserted = 1 OR @Cdeleted=1 
BEGIN
SELECT @EstatusIns = Estatus FROM inserted
SELECT @EstatusDel = Estatus FROM deleted
IF (@EstatusIns <> 'BAJA' AND @EstatusDel = 'BAJA')
BEGIN
SELECT @Ok = 71020, @OkRef = 'No se permite modificar el Estatus de usuarios dados de BAJA  - ' + Usuario FROM inserted
UPDATE Usuario set Estatus = @EstatusDel WHERE Usuario = (SELECT Usuario FROM inserted)
RAISERROR(@OkRef, 16, 1)
END
END
IF @Ok IS NULL AND @ProdInterfazINFOR = 1
BEGIN
IF @Cinserted <> 0 AND @Cdeleted = 0
BEGIN
SET @Estatus = 'ALTA'
END
IF @Cinserted <> 0 AND @Cdeleted<> 0
BEGIN
SET @Estatus = 'CAMBIO'
END
IF (@Cinserted = 0 AND @Cdeleted <> 0) 
BEGIN
SET @Estatus = 'BAJA'
END
IF  @Estatus IN( 'ALTA','CAMBIO')
BEGIN
DECLARE  crActualizar CURSOR LOCAL FAST_FORWARD FOR
SELECT  Usuario, ReferenciaIntelisisService, Nombre, Alta, Estatus
FROM Inserted
END
IF @Estatus = 'BAJA'
BEGIN
DECLARE  crActualizar CURSOR LOCAL FAST_FORWARD FOR
SELECT  Usuario, ReferenciaIntelisisService, Nombre, Alta, Estatus
FROM Deleted
END
IF @Estatus IN( 'ALTA','CAMBIO', 'BAJA')
BEGIN
OPEN  crActualizar
FETCH NEXT FROM crActualizar INTO @Usuario, @ReferenciaIntelisisService, @Nombre, @Alta, @EstatusUsuarioN
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @EstatusUsuarioA='', @EstatusInfor=''
SELECT @EstatusInfor = @Estatus
IF @Estatus ='CAMBIO'
BEGIN
SELECT @EstatusUsuarioA = Estatus FROM Deleted WHERE Usuario=@Usuario
IF (@EstatusUsuarioN <> 'BAJA' AND @EstatusUsuarioA = 'BAJA')
BEGIN
SELECT @Ok = 71020, @OkRef = 'No se permite modificar el Estatus de usuarios dados de BAJA  - ' + @Usuario
UPDATE Usuario SET Estatus = @EstatusUsuarioA WHERE Usuario = @Usuario
RAISERROR(@OkRef, 16, 1)
END
IF @EstatusUsuarioN = 'BAJA' AND @EstatusUsuarioA <> 'BAJA'
SELECT @EstatusInfor = 'BAJA'
END
EXEC  spInforGenerarSolicitudUsuario  @Usuario, @EstatusInfor, @ReferenciaIntelisisService, @Nombre, @Alta, @Datos OUTPUT
FETCH NEXT FROM crActualizar INTO @Usuario, @ReferenciaIntelisisService, @Nombre, @Alta, @EstatusUsuarioN
END
CLOSE crActualizar
DEALLOCATE crActualizar
END
END
END

