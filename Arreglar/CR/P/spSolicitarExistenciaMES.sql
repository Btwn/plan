SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSolicitarExistenciaMES
@Empresa       varchar(5),
@Usuario       varchar(10),
@Sucursal      int

AS BEGIN
DECLARE
@Solicitud                                           varchar(max),
@ReferenciaIS                                    varchar(100),
@SubReferencia                                varchar(100),
@ID                                        int,
@Datos                                                 varchar(max),
@Resultado                                         varchar(max),
@Contrasena                                      varchar(32),
@ReferenciaIntelisisService     varchar(50) ,
@iSolicitud                                   int,
@IDNuevo                                           int,
@Datos2                               varchar(max),
@Resultado2                                       varchar(max),
@Verificar                                            int           ,
@Ok                               int ,
@OkRef                                         varchar(255)
DECLARE
@Tabla table(
Articulo            varchar(20),
SubCuenta           varchar(50),
SerieLote           varchar(50),
Almacen             varchar(10),
ExistenciaMES       float  ,
ExistenciaIntel     float  ,
Costo               float
)
DECLARE
@Tabla2 table(
Articulo            varchar(20),
SubCuenta           varchar(50),
SerieLote           varchar(50),
Almacen             varchar(10),
ExistenciaIntel      float  ,
ExistenciaMES       float  ,
CostoMES            float
)
DECLARE
@Tabla3 table(
Articulo      varchar(20),
SubCuenta     varchar(50),
SerieLote     varchar(50),
Almacen       varchar(10),
EntradaSalida varchar(1),
Existencia    float
)
SELECT @ReferenciaIS = Referencia ,@Usuario = Usuario , @SubReferencia = SubReferencia
FROM IntelisisService
WHERE ID = @ID
SELECT @Contrasena = Contrasena
FROM Usuario
WHERE Usuario = @Usuario
SELECT @ReferenciaIntelisisService = Referencia
FROM MapeoPlantaIntelisisMes
WHERE Empresa = @Empresa AND Sucursal = @Sucursal
IF @Ok IS NULL
BEGIN
DELETE ArtExistenciaIntMES
SET @Datos='<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Infor" Contenido="Solicitud" Referencia="Intelisis.Interfaz.Infor.ExistenciaMES" SubReferencia="" Version="1.0" ReferenciaIntelisisService='+CHAR(34)+ISNULL(@ReferenciaIntelisisService,'')+CHAR(34)+' Sucursal='+CHAR(34)+ISNULL(CONVERT(varchar,@Sucursal),'')+CHAR(34)+' Empresa='+CHAR(34)+ISNULL(@Empresa,'')+CHAR(34)+'><Solicitud></Solicitud> </Intelisis>'
EXEC spIntelisisService @Usuario,@Contrasena,@Datos,@Resultado ,@Ok Output,@OkRef Output,1,0,@ID Output
IF @Ok IS NULL
SELECT @Solicitud = Resultado
FROM IntelisisService
WHERE ID = @ID
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
IF @@ERROR <> 0 SET @Ok = 1
INSERT @Tabla (       Articulo ,SubCuenta , SerieLote , Almacen, ExistenciaMES,ExistenciaIntel,Costo)
SELECT        Articulo ,ISNULL(SubCuenta,'') , NULLIF(NULLIF(Lote,'(none)'),'') , Almacen, Existencia,0.0,Costo
FROM OPENXML (@iSolicitud, '/Intelisis/Resultado/INV',1)
WITH (Articulo  varchar(100),  SubCuenta  varchar(100),  Lote  varchar(100),  Almacen  varchar(100),  Existencia  float, Costo Float)
IF @@ERROR <> 0 SET @Ok = 1
EXEC sp_xml_removedocument @iSolicitud
IF @@ERROR <> 0 SET @Ok = 1
INSERT @Tabla (Articulo ,SubCuenta ,            SerieLote , Almacen, ExistenciaIntel,ExistenciaMES)
SELECT         s.Articulo ,ISNULL(s.SubCuenta,'') , s.SerieLote , s.Almacen, s.Existencia* dbo.fnInforArtUnidadCompraFactor(@Empresa,s.Articulo) ,    0.0
FROM SerieLote s JOIN Alm a ON s.Almacen = a.Almacen
JOIN Art art ON art.Articulo = s.Articulo
WHERE s.Existencia IS NOT NULL  AND s.Empresa = @Empresa
AND ISNULL(a.EsFactory,0) = 1
AND ISNULL(art.EsFactory,0) = 1
AND a.Sucursal = @Sucursal
GROUP BY   s.Articulo ,s.SubCuenta , s.SerieLote , s.Almacen, s.Existencia
INSERT @Tabla ( Articulo ,  SubCuenta ,             Almacen,   ExistenciaIntel,                                                   ExistenciaMES)
SELECT          s.Articulo ,ISNULL(s.SubCuenta,'') ,s.Almacen, s.Existencias* dbo.fnInforArtUnidadCompraFactor(@Empresa,s.Articulo),0.0
FROM ArtSubExistenciaReservado s JOIN Art a ON a.Articulo = s.Articulo
JOIN Alm al ON s.Almacen = al.Almacen
WHERE a.Tipo = 'Normal'
AND ISNULL(al.EsFactory,0) = 1
AND ISNULL(a.EsFactory,0) = 1
AND al.Sucursal = @Sucursal
GROUP BY   s.Articulo ,s.SubCuenta , s.Almacen, s.Existencias
INSERT  @Tabla2 (Articulo, SubCuenta,  SerieLote, Almacen ,ExistenciaIntel,               ExistenciaMES,               CostoMES)
SELECT             Articulo, SubCuenta,  SerieLote, Almacen, SUM(ROUND(ExistenciaIntel,4)), SUM(ROUND(ExistenciaMES,4)) ,ISNULL(Costo,0.0)
FROM @Tabla
WHERE ExistenciaMES <> ExistenciaIntel
GROUP BY Articulo,SubCuenta,SerieLote,Almacen ,Costo
INSERT  ArtExistenciaIntMES (Articulo, SubCuenta, SerieLote, Almacen ,ExistenciaInte,  ExistenciaMES,CostoMES)
SELECT                         Articulo, SubCuenta, SerieLote, Almacen, ExistenciaIntel, ExistenciaMES ,ISNULL(CostoMES,0.0)
FROM @Tabla2
WHERE ExistenciaMES <> ExistenciaIntel
AND Almacen IN (SELECT Almacen FROM Alm)
END
END

