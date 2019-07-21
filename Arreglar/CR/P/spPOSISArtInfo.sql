SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSISArtInfo
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok			int          = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Articulo     	        varchar(20),
@Datos		        varchar(max),
@Datos2		        varchar(max),
@Datos3		        varchar(max),
@Datos4  	        varchar(max),
@Empresa                varchar(5),
@ReferenciaIS           varchar(50),
@SubReferenciaIS        varchar(50),
@LenDatos               int,
@SaldoMN                float,
@LimiteCredito          float
DECLARE @Disponible  table(Empresa  varchar(5), Articulo  varchar(20), Almacen   varchar(10), Disponible   float, Grupo  varchar(50), Tipo varchar(15))
DECLARE @Reservado   table(Empresa  varchar(5), Articulo  varchar(20), Almacen   varchar(10), Reservado    float, Grupo  varchar(50), Tipo varchar(15))
SELECT @ReferenciaIS = Referencia , @SubReferenciaIS = SubReferencia
FROM IntelisisService
WHERE ID = @ID
SELECT @Articulo = RTRIM(LTRIM(Articulo)), @Empresa = Empresa
FROM openxml (@iSolicitud,'/Intelisis/Solicitud/ArtInfo')
WITH (Articulo varchar(20), Empresa varchar(5))
INSERT @Disponible(Empresa, Articulo, Almacen, Disponible,   Grupo,      Tipo)
SELECT  a.Empresa, a.Articulo,   a.Almacen,   a.Disponible,  Alm.Grupo,   Alm.Tipo
FROM ArtDisponible a JOIN Alm alm ON a.Almacen=Alm.Almacen
WHERE a.Articulo = @Articulo
INSERT @Reservado(Empresa, Articulo, Almacen, Reservado,   Grupo,      Tipo)
SELECT a.Empresa,   a.Articulo,  a.Almacen,   a.Reservado, Alm.Grupo,  Alm.Tipo
FROM ArtReservado a  LEFT OUTER JOIN Alm Alm ON a.Almacen=Alm.Almacen
WHERE a.Articulo = @Articulo
SELECT @Datos =(SELECT * FROM @Disponible Disponible FOR XML AUTO)
SELECT @Datos2 =(SELECT * FROM @Reservado Reservado FOR XML AUTO)
SELECT @Datos = ISNULL(@Datos,'')+ISNULL(@Datos2,'')
SELECT @LenDatos = LEN(ISNULL(@Datos,''))
SELECT @Datos = ISNULL(@Datos,'')+ '<Relleno '+  +'A="'+REPLICATE('X',8000-@LenDatos)+'" />'
SELECT @Resultado = '<Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34)
+ ' SubReferencia='+ CHAR(34) + ISNULL(@SubReferenciaIS,'') + CHAR(34)
+' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)+' >'
+ISNULL(@Datos,'')+'</Resultado></Intelisis>'
END

