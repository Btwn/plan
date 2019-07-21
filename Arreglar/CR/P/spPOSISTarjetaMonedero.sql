SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSISTarjetaMonedero
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int          = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Serie				varchar(20),
@Datos				varchar(max),
@Datos2				varchar(max),
@Datos3				varchar(max),
@Datos4				varchar(max),
@Empresa			varchar(5),
@ReferenciaIS		varchar(50),
@SubReferenciaIS	varchar(50),
@LenDatos			int,
@SaldoMN			float,
@LimiteCredito		float
DECLARE @TarjetaMonedero table (Empresa varchar( 5), Serie varchar(20), Estatus varchar(15), TieneMovimientos bit, Usuario varchar(10), FechaAlta datetime, UsuarioActivacion varchar(10), FechaActivacion datetime, FechaBaja datetime )
SELECT @ReferenciaIS = Referencia , @SubReferenciaIS = SubReferencia
FROM IntelisisService
WHERE ID = @ID
SELECT @Serie = RTRIM(LTRIM(Serie)), @Empresa = Empresa
FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TarjetaMonedero')
WITH (Serie varchar(20), Empresa varchar(5))
INSERT @TarjetaMonedero (Empresa, Serie, Estatus, TieneMovimientos, Usuario, FechaAlta, UsuarioActivacion, FechaActivacion, FechaBaja)
SELECT			       Empresa, Serie, Estatus, TieneMovimientos, Usuario, FechaAlta, UsuarioActivacion, FechaActivacion, FechaBaja
FROM TarjetaMonedero
WHERE Empresa = @Empresa
AND Serie = @Serie
SELECT @Datos =(SELECT * FROM @TarjetaMonedero TarjetaMonedero FOR XML AUTO)
SELECT @Datos = ISNULL(@Datos,'')
SELECT @LenDatos = LEN(ISNULL(@Datos,''))
SELECT @Datos = ISNULL(@Datos,'')+ '<Relleno '+  +'A="'+REPLICATE('X',8000-@LenDatos)+'" />'
SELECT @Resultado = '<Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34)
+ ' SubReferencia='+ CHAR(34) + ISNULL(@SubReferenciaIS,'') + CHAR(34)
+' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)+' >'
+ISNULL(@Datos,'')+'</Resultado></Intelisis>'
END

