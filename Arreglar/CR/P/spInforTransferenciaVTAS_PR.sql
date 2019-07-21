SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInforTransferenciaVTAS_PR
@ID                        int,
@iSolicitud                           int,
@Version                              float,
@Resultado                         varchar(max) = NULL OUTPUT,
@Ok                                                      int = NULL OUTPUT,
@OkRef                                 varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@IDO                                                                    varchar(10),
@Datos                                                 varchar(max),
@Solicitud                                                                           varchar(max),
@ReferenciaIS                                                    varchar(100),
@SubReferencia                                                varchar(100),
@IDNuevo                                                                           int,
@Datos2                                                               varchar(max),
@Resultado2                                                                      varchar(max),
@Resultado3                                                                      varchar(max),
@Resultado4                                                                      varchar(max),
@Usuario                                                                             varchar(10),
@Contrasena                                                                     varchar(32),
@Cliente                                                                  varchar(10),
@Empresa                                                                           varchar(5),
@ReferenciaIntelisisService                                           varchar(50),
@Sucursal                                                                            int,
@PlantaSucEmpresa                                        varchar(10),
@FechaEmision                                                         datetime,
@FechaRegistro                                               datetime,
@Usuario2                                                                          varchar(10),
@Almacen                                                                          varchar(10)          ,
@ArtSecundario                      varchar(20),
@Articulop                          varchar(20)
DECLARE                            @Tabla                                table
(
Anyo                                      int,
Periodo                                int,
Cliente                                  varchar(10),
Articulo                                                varchar(20),
SubCuenta               varchar(50),
ArticuloSecundario                           varchar(20),
UnidadesAlmacen                                           varchar(40),
ImporteVenta                                    varchar(40),
ImporteCoste                                     varchar(40),
FechaDeAlta                                                     datetime,
FechaUltimaModificacion              datetime,
UsuarioAlta                          varchar(10),
UsuarioModificacion                        varchar(10),
ReferenciaIntelisisService                                               varchar(50)
)
BEGIN TRANSACTION
IF @Ok IS NULL
BEGIN
SELECT @IDO = ID FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Venta')
WITH (ID varchar(255))
SELECT @FechaEmision = FechaEmision ,@Cliente = Cliente ,@FechaRegistro =  FechaRegistro, @Usuario2 = Usuario, @Almacen = Almacen
FROM Venta
WHERE ID = @IDO
IF @Cliente IS NULL SET @Ok = 1
SELECT @ReferenciaIS = Referencia ,@Usuario = Usuario , @SubReferencia = SubReferencia
FROM IntelisisService
WHERE ID = @ID
SELECT @Contrasena = Contrasena
FROM Usuario
WHERE Usuario = @Usuario
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '/></Intelisis>'
SET @Datos= '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.VTAS.Mov.Listado" SubReferencia="'+@SubReferencia+'" Version="1.0"><Solicitud><Parametro Campo="ID" Valor="'+@IDO+'"/></Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario,@Contrasena,@Datos,@Resultado,@Ok Output,@OkRef Output,1,0,@IDNuevo Output
SELECT @Solicitud = Resultado
FROM IntelisisService
WHERE ID = @IDNuevo
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
SELECT @Empresa = Empresa , @Sucursal = Sucursal
FROM OPENXML (@iSolicitud, '/Intelisis/Resultado/Venta',1)
WITH ( Empresa varchar(100), Sucursal varchar(100))
EXEC sp_xml_removedocument @iSolicitud
SELECT @ReferenciaIntelisisService = ReferenciaIntelisisService
FROM Alm
WHERE Almacen = @Almacen
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
INSERT @Tabla(        Anyo,               Periodo,                    Cliente, Articulo,SubCuenta, UnidadesAlmacen, ImporteVenta, ImporteCoste, FechaDeAlta,   FechaUltimaModificacion, UsuarioAlta, UsuarioModificacion,ReferenciaIntelisisService    )
SELECT         year(@FechaEmision), datepart(week,@FechaEmision), @Cliente, Articulo, SubCuenta,Cantidad,        Precio,       Costo,        @FechaRegistro, @FechaRegistro,           @Usuario2,     @Usuario2 ,           @ReferenciaIntelisisService
FROM OPENXML (@iSolicitud, '/Intelisis/Resultado/VentaD',1)
WITH ( Articulo varchar(100),Cantidad varchar(100),Precio varchar(100),Costo varchar(100),SubCuenta varchar(100))
EXEC sp_xml_removedocument @iSolicitud
SET @Resultado2 = CONVERT(varchar(max) ,(SELECT * FROM @Tabla oObjetivosVentasCliente   FOR XML AUTO))
SET @Datos2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Infor" Contenido="Solicitud" Referencia=' + CHAR(34) + 'Infor.Movimiento.Procesar.VTAS_PR' + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Solicitud IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')   + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)  + ' ModuloID="'+ @IDO+'"  ReferenciaIntelisisService='+ CHAR(34)+ ISNULL(@ReferenciaIntelisisService,'')+CHAR(34)+ ' >' + @Resultado2 + '</Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario,@Contrasena,@Datos2,@Resultado2,@Ok Output,@OkRef Output,0,0,@IDNuevo Output
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
END
END
END

