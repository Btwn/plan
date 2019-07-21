SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSValidarCBOSURP
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@CB                varchar(30),
@Articulo 			varchar(20),
@SubCuenta 			varchar(50),
@Texto				xml,
@ReferenciaIS		varchar(100),
@SubReferencia		varchar(100),
@UsuarioSucursal    bit,
@Verifica           int,
@Verifica2          int,
@Sucursal         int,
@Tarima             varchar(30),
@Cantidad           float
SELECT  @Articulo   = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Articulo'
SELECT  @CB = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Codigo'
SELECT  @SubCuenta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SubCuenta'
SELECT  @Tarima  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tarima'
SELECT  @Cantidad = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Cantidad'
IF NOT EXISTS(SELECT * FROM CB WHERE Codigo = @CB AND Cuenta = @Articulo AND SubCuenta = ISNULL(@SubCuenta,''))SET @Ok = 72040
IF NOT EXISTS(SELECT * FROM TMAD d JOIN TMA  t ON t.ID = d.ID  JOIN MovTipo m ON m.Mov = t.Mov AND m.Modulo = 'TMA'
JOIN ArtDisponibleTarima a ON a.Tarima = d.Tarima WHERE a.Articulo = @Articulo AND m.Clave='TMA.OSUR'AND m.SubClave='TMA.OSURP' AND a.Tarima=@Tarima AND a.Disponible <=@Cantidad)SET @Ok = 20020
IF @@ERROR <> 0 SET @Ok = 1
BEGIN
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '></Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
END
END

