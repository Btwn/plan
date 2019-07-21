SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSValidarSoloCB
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@CB					varchar(30),
@Articulo 			varchar(20),
@SubCuenta 			varchar(50),
@Cantidad           float,
@Tarima				varchar(20),
@Texto				xml,
@ReferenciaIS		varchar(100),
@SubReferencia		varchar(100)
DECLARE
@Tabla Table(
CB				varchar(30),
Articulo			varchar(10),
Subcuenta			varchar(10),
Tarima			varchar(20)
)
SELECT  @CB = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Codigo'
SELECT  @Cantidad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Cantidad'
SELECT  @Tarima = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tarima'
IF NOT EXISTS(SELECT * FROM CB WHERE Codigo = @CB)SET @Ok = 72040
IF @Ok IS NULL
BEGIN
SELECT @Articulo = Cuenta, @SubCuenta=ISNULL(SubCuenta,'') FROM CB WHERE Codigo = @CB
IF NOT EXISTS(SELECT * FROM Tarima WHERE Tarima = @Tarima AND Estatus = 'Alta') AND @Ok IS NULL
SELECT @OK = 13110
IF NOT EXISTS(SELECT * FROM ArtDisponibleTarima WHERE Tarima = @Tarima AND Articulo = @Articulo) AND @Ok IS NULL
SELECT @Ok = 10530
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
INSERT @Tabla
SELECT @CB, @Articulo, @SubCuenta, @Tarima
END
SELECT @Texto = (SELECT * FROM @Tabla CB
FOR XML AUTO)
IF @@ERROR <> 0 SET @Ok = 1
BEGIN
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max),ISNULL(@Texto,'')) + '</Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
END
END

