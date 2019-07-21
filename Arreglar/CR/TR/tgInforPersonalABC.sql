SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgInforPersonalABC ON Personal

FOR INSERT, UPDATE ,DELETE
AS BEGIN
DECLARE
@ProdInterfazINFOR					bit,
@Personal   							varchar (10),
@Estatus							    varchar (10),
@Datos								varchar (max),
@Ok									int,
@OkRef								varchar(255),
@Id									int,
@Cinserted		                	int,
@Cdeleted			                int,
@Empresa								varchar(20),
@ReferenciaIntelisisService			varchar(50),
@Personal2                           varchar (10),
@Personal3                           varchar (10),
@ApellidoPaterno                     varchar (30),
@ApellidoPaterno2                    varchar (30),
@ApellidoMaterno                     varchar (30),
@ApellidoMaterno2                    varchar (30),
@Nombre                              varchar (30),
@Nombre2                             varchar (30),
@Direccion                           varchar (100),
@Direccion2                          varchar (100),
@Poblacion                           varchar (100),
@Poblacion2                          varchar (100),
@CodigoPostal                        varchar (15),
@CodigoPostal2                       varchar (15),
@Telefono                            varchar (50),
@Telefono2                           varchar (50),
@LugarNacimiento                     varchar (50),
@LugarNacimiento2                    varchar (50),
@EstadoCivil                         varchar (20),
@EstadoCivil2                        varchar (20),
@TipoContrato                        varchar (50),
@TipoContrato2                       varchar (50),
@Estatus2                             varchar (15) ,
@Estatus3                            varchar (15)
SELECT @ID = dbo.fnAccesoID(@@SPID)
SELECT @Empresa = Empresa FROM Acceso WHERE ID = @ID
SELECT @ProdInterfazINFOR = ProdInterfazINFOR
FROM EmpresaGral WHERE Empresa = @Empresa
SELECT @Personal2= Personal, @ApellidoPaterno = ApellidoPaterno ,@ApellidoMaterno = ApellidoMaterno,@Nombre = Nombre, @Direccion = Direccion, @Poblacion = Poblacion,@CodigoPostal=CodigoPostal, @Telefono=Telefono, @LugarNacimiento = LugarNacimiento, @EstadoCivil= EstadoCivil,@TipoContrato = TipoContrato,  @Estatus2= Estatus FROM DELETED
SELECT @Personal3= Personal, @ApellidoPaterno2 = ApellidoPaterno ,@ApellidoMaterno2 = ApellidoMaterno,@Nombre2 = Nombre, @Direccion2 = Direccion, @Poblacion2 = Poblacion,@CodigoPostal2=CodigoPostal, @Telefono2=Telefono, @LugarNacimiento2 = LugarNacimiento, @EstadoCivil2= EstadoCivil,@TipoContrato2 = TipoContrato,  @Estatus3= Estatus FROM INSERTED
SELECT @Cinserted =  COUNT(*) FROM inserted
SELECT @Cdeleted =  COUNT(*) FROM deleted
IF @ProdInterfazINFOR = 1
BEGIN
IF @Personal2 <> @Personal3 OR @ApellidoPaterno <> @ApellidoPaterno2 OR @ApellidoMaterno <> @ApellidoMaterno2 OR @Nombre <> @Nombre2 OR @Direccion <> @Direccion2 OR @Poblacion <> @Poblacion OR @CodigoPostal <> @CodigoPostal2 OR  @Telefono <> @Telefono2 OR  @LugarNacimiento <> @LugarNacimiento2 OR  @EstadoCivil <> @EstadoCivil2 OR @TipoContrato <> @TipoContrato2 OR  @Estatus2 <> @Estatus3
BEGIN
IF @Cinserted <> 0           AND @Cdeleted = 0
BEGIN
SET @Estatus = 'ALTA'
END
IF @Cinserted <> 0           AND @Cdeleted<> 0
BEGIN
SET @Estatus = 'CAMBIO'
END
IF @Cinserted = 0           AND @Cdeleted <> 0
BEGIN
SET @Estatus = 'BAJA'
END
IF  @Estatus IN( 'ALTA','CAMBIO')
BEGIN
DECLARE crActualizar CURSOR LOCAL FAST_FORWARD FOR
SELECT Personal,ReferenciaIntelisisService
FROM Inserted
END
ELSE
IF @Estatus = 'BAJA'
BEGIN
DECLARE crActualizar CURSOR LOCAL FAST_FORWARD FOR
SELECT Personal,ReferenciaIntelisisService
FROM Deleted
END
IF @Estatus IN( 'ALTA','CAMBIO', 'BAJA')
BEGIN
OPEN crActualizar
FETCH NEXT FROM crActualizar INTO @Personal ,@ReferenciaIntelisisService
WHILE @@FETCH_STATUS = 0
BEGIN
EXEC spInforGenerarSolicitudPersonal @Personal,@Estatus,@ReferenciaIntelisisService,@Datos OUTPUT
FETCH NEXT FROM crActualizar INTO @Personal,@ReferenciaIntelisisService
END
CLOSE crActualizar
DEALLOCATE crActualizar
END
END
END
END

