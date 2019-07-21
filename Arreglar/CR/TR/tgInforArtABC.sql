SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgInforArtABC ON Art

FOR INSERT, UPDATE ,DELETE
AS BEGIN
DECLARE
@ProdInterfazINFOR					bit,
@Articulo							varchar (20),
@Estatus							    varchar (10),
@Datos								varchar (max),
@Ok									int,
@OkRef								varchar(255),
@Id									int,
@Cinserted		                	int,
@Cdeleted			                int,
@ReferenciaIntelisisService			varchar(50)	,
@Empresa					varchar(20),
@EsFactory                                   bit,
@EsFactoryIN                                 bit,
@EsFactoryDel                                bit,
@Existencia                                  float,
@Mensaje                                     varchar(255),
@Sucursal                                    int,
@Usuario                                     varchar(10)
SELECT @ID = dbo.fnAccesoID(@@SPID)
SELECT @Empresa = Empresa, @Usuario = Usuario, @Sucursal = Sucursal FROM Acceso WHERE ID = @ID
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
SELECT Articulo,ReferenciaIntelisisService, ISNULL(EsFactory,0)
FROM Inserted
END
ELSE IF @Estatus = 'BAJA'
BEGIN
DECLARE crActualizar CURSOR LOCAL FAST_FORWARD FOR
SELECT Articulo,ReferenciaIntelisisService, ISNULL(EsFactory,0)
FROM Deleted
END
IF  @Estatus IN( 'ALTA','CAMBIO', 'BAJA')
BEGIN
OPEN crActualizar
FETCH NEXT FROM crActualizar INTO @Articulo,@ReferenciaIntelisisService, @EsFactory
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @EsFactoryIN = ISNULL(EsFactory,0) FROM Inserted where Articulo = @Articulo
SELECT @EsFactoryDel = ISNULL(EsFactory,0) FROM Deleted where Articulo = @Articulo
SELECT @Mensaje = 'El Articulo tiene existencia no se puede dejar de sincronizar con factory  '
SELECT @Existencia = ISNULL(SUM(ISNULL(Disponible,0)+ISNULL(Reservado,0)),0) FROM ArtDisponibleReservado WHERE Empresa = @Empresa AND Articulo = @Articulo
IF @EsFactoryDel = 1 AND @EsFactoryIN = 0  AND @Existencia <> 0
RAISERROR (@Mensaje,16,-1)
IF @EsFactoryDel = 0 AND @EsFactoryIN = 1 AND @Existencia <> 0
EXEC spInforArticuloSaldoInicial @Articulo, @Usuario, @Empresa, @Sucursal
IF  @EsFactory = 1
BEGIN
EXEC spInforGenerarSolicitudArticulo  @Articulo,@Estatus,@ReferenciaIntelisisService,@Datos OUTPUT
EXEC spInforGenerarSolicitudArtContadorLotes  @Articulo,@Estatus,@ReferenciaIntelisisService,@Datos OUTPUT
END
FETCH NEXT FROM crActualizar INTO @Articulo,@ReferenciaIntelisisService, @EsFactory
END
CLOSE crActualizar
DEALLOCATE crActualizar
END
END
END

