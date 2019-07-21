SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSISTarjetaMonederoActivar
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
@LimiteCredito		float,
@Usuario			varchar(10),
@SucursalT			varchar(3),
@Sucursal			int
DECLARE @TarjetaMonederoActivar table (Empresa varchar( 5), Serie varchar(20), Estatus varchar(15), TieneMovimientos bit, Usuario varchar(10), FechaAlta datetime, UsuarioActivacion varchar(10), FechaActivacion datetime, FechaBaja datetime )
SELECT @ReferenciaIS = Referencia , @SubReferenciaIS = SubReferencia
FROM IntelisisService WITH (NOLOCK)
WHERE ID = @ID
SELECT @Serie = RTRIM(LTRIM(Serie)), @Empresa = Empresa, @SucursalT = SucursalT, @Usuario = Usuario
FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TarjetaMonederoActivar')
WITH (Serie varchar(20), Empresa varchar(5), SucursalT varchar(3), Usuario varchar(10))
IF NULLIF(@SucursalT,'') IS NOT NULL
SELECT @Sucursal = CONVERT(int,@SucursalT)
EXEC spMonederoActivar @Empresa, @Serie, @Usuario, @Sucursal, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
INSERT @TarjetaMonederoActivar (Empresa, Serie, Estatus, TieneMovimientos, Usuario, FechaAlta, UsuarioActivacion, FechaActivacion, FechaBaja)
SELECT						  Empresa, Serie, Estatus, TieneMovimientos, Usuario, FechaAlta, UsuarioActivacion, FechaActivacion, FechaBaja
FROM TarjetaMonedero WITH (NOLOCK)
WHERE Empresa = @Empresa
AND Serie = @Serie
SELECT @Datos =(SELECT * FROM @TarjetaMonederoActivar TarjetaMonederoActivar FOR XML AUTO)
SELECT @Datos = ISNULL(@Datos,'')
SELECT @LenDatos = LEN(ISNULL(@Datos,''))
SELECT @Datos = ISNULL(@Datos,'')+ '<Relleno '+  +'A="'+REPLICATE('X',8000-@LenDatos)+'" />'
SELECT @Resultado = '<Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34)
+ ' SubReferencia='+ CHAR(34) + ISNULL(@SubReferenciaIS,'') + CHAR(34)
+' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)+' >'
+ISNULL(@Datos,'')+'</Resultado></Intelisis>'
END

