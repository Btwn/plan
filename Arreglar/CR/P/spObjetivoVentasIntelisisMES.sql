SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spObjetivoVentasIntelisisMES
@ID                        int,
@iSolicitud                           int,
@Version                              float,
@Resultado                         varchar(max) = NULL OUTPUT,
@Ok                                                      int = NULL OUTPUT,
@OkRef                                 varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@FechaD                                             DateTime,
@FechaA                                     DateTime,
@Empresa                            varchar(5),
@Sucursal                             int,
@Usuario                             varchar(10),
@PlantaSucEmpresa                        varchar(10),
@Contrasena                                                     varchar(32),
@ReferenciaIntelisisService                                           varchar(50),
@Texto                                                 varchar(max),
@ReferenciaIS                    varchar(100),
@SubReferencia                varchar(100),
@Datos                                                 varchar(max),
@Solicitud                                                                           varchar(max),
@IDNuevo                                                                           int,
@Datos2                                                               varchar(max),
@Resultado2                                                                      varchar(max)
DECLARE                            @Tabla                                table
(
Anyo                                      int,
Periodo                                int,
Articulo                                                varchar(20),
SubCuenta                          varchar(50),
UnidadesAlmacen                                           varchar(40),
ImporteVenta                                    varchar(40),
ImporteCoste                                     varchar(40),
ReferenciaIntelisisService                                               varchar(50)
)
SELECT @Empresa = Empresa FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Objetivo')
WITH (Empresa varchar(255))
SELECT @Sucursal = Sucursal FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Objetivo')
WITH (Sucursal varchar(255))
SELECT @FechaD = FechaD FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Objetivo')
WITH (FechaD varchar(255))
SELECT @FechaA = FechaA FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Objetivo')
WITH (FechaA varchar(255))
SELECT @ReferenciaIS = Referencia ,@Usuario = Usuario , @SubReferencia = SubReferencia
FROM IntelisisService
WHERE ID = @ID
SELECT @Contrasena = Contrasena
FROM Usuario
WHERE Usuario = @Usuario
SELECT @ReferenciaIntelisisService = ReferenciaIntelisisService
FROM Empresa
WHERE Empresa = @Empresa
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '/></Intelisis>'
SET @Datos=
'<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.Interfaz.Infor.Solicitud.ObjetivosVentas" SubReferencia="'+@SubReferencia+'" Version="1.0"><Solicitud><Objetivo  /></Solicitud></Intelisis>'
SELECT @Solicitud = Resultado
FROM IntelisisService
WHERE ID = @IDNuevo
SELECT @Empresa = NULLIF(Empresa,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Objetivo')
WITH (Empresa varchar(255))
SELECT @Sucursal = CONVERT(int,NULLIF(Sucursal,'')) FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Objetivo')
WITH (Sucursal varchar(255))
SELECT @FechaD = CONVERT(datetime,FechaD) FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Objetivo')
WITH (FechaD varchar(255))
SELECT @FechaA= CONVERT(datetime,FechaA) FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Objetivo')
WITH (FechaA varchar(255))
INSERT @Tabla(              Anyo,                Periodo,         Articulo,SubCuenta, UnidadesAlmacen, ImporteVenta, ImporteCoste, ReferenciaIntelisisService               )
SELECT year(v.FechaRequerida), MONTH(v.FechaRequerida), d.Articulo,d.SubCuenta,sum(d.Cantidad),   avg(d.Precio), avg(d.Costo),   ISNULL(@ReferenciaIntelisisService,'')
FROM Venta v JOIN VentaD d ON v.ID = d.ID
JOIN Art a ON a.Articulo = d.Articulo
JOIN MovTipo  mt ON mt.Mov = v.Mov AND mt.Modulo = 'VTAS'
WHERE v.Estatus = 'CONCLUIDO'
AND a.InforTipo = 'PRODUCTO ACABADO'
AND v.FechaRequerida BETWEEN @FechaD AND @FechaA
AND mt.Clave = 'VTAS.PR'
GROUP BY year(v.FechaRequerida), MONTH(v.FechaRequerida), d.Articulo,d.SubCuenta
SET @Resultado2 = CONVERT(varchar(max) ,(SELECT * FROM @Tabla oObjetivosVentas FOR XML AUTO))
SET @Datos2 = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Infor" Contenido="Solicitud" Referencia=' + CHAR(34) + 'Infor.Reporte.ObjetivosVentas' + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Solicitud IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')   + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)  +' ReferenciaIntelisisService='+ CHAR(34)+ ISNULL(@ReferenciaIntelisisService,'')+CHAR(34)+ ' >' + @Resultado2 + '</Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario,@Contrasena,@Datos2,@Resultado2,@Ok Output,@OkRef Output,0,0,@IDNuevo Output
IF @@ERROR <> 0 SET @Ok = 1
END

