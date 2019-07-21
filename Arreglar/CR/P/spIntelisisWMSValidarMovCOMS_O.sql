SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSValidarMovCOMS_O
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Empresa            varchar(5),
@ID2                int,
@Mov                varchar(20),
@Mov2               varchar(20),
@MovID  			varchar(20),
@Texto				xml,
@ReferenciaIS		varchar(100),
@SubReferencia		varchar(100),
@UsuarioSucursal    bit,
@Verifica           int,
@Verifica2          int,
@Sucursal           int,
@Anden				varchar(10),
@OPreEntarimado    bit
SELECT  @Empresa   = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT  @Mov= Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mov'
SELECT  @MovID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MovID'
IF @Mov NOT IN(SELECT Mov FROM MovTipo WHERE Clave ='COMS.O' AND Modulo='COMS') SET @Ok= 35005
IF @Ok IS NULL AND NOT EXISTS(
SELECT *
FROM Compra
WHERE Compra.Mov = @Mov
AND Compra.MovID = @MovID
AND Compra.Empresa =@Empresa)
SELECT @Ok=14055
IF @Ok IS NULL AND NOT EXISTS(
SELECT *
FROM Compra
JOIN Alm ON Compra.Almacen=Alm.Almacen
WHERE Compra.Mov = @Mov
AND Compra.MovID = @MovID
AND Compra.Empresa =@Empresa
AND Alm.WMS=1)
SELECT @Ok=20830
if @Ok is NULL
IF EXISTS(SELECT * FROM Compra WHERE Mov = @Mov and MovID = @MovID AND Empresa =@Empresa AND Estatus ='CONCLUIDO') SET @Ok =80010
if @Ok is NULL   
IF NOT EXISTS(SELECT * FROM Compra WHERE Mov = @Mov and MovID = @MovID AND Empresa =@Empresa AND Estatus ='PENDIENTE')SET @Ok =14055
if @Ok is NULL  
SELECT @Anden = LTRIM(RTRIM(isnull(PosicionWMS,''))) FROM Compra WHERE Mov = @Mov and MovID = @MovID AND Empresa =@Empresa  
If @Anden = ''
SET @Ok =80202
SET @OPreEntarimado = NULL 
IF EXISTS(SELECT *
FROM Compra c
WHERE c.Mov = 'Orden Pre Entarimado' and c.OrigenID = @MovID AND c.Empresa =@Empresa AND Estatus ='PENDIENTE')
SET @OPreEntarimado = 1
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

