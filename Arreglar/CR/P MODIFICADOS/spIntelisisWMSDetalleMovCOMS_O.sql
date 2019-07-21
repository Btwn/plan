SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSDetalleMovCOMS_O
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Empresa            varchar(5),
@ID2                 int,
@Mov                varchar(20),
@Mov2                varchar(20),
@MovID  			varchar(20),
@Texto				xml,
@ReferenciaIS		varchar(100),
@SubReferencia		varchar(100),
@UsuarioSucursal    bit,
@Verifica           int,
@Verifica2          int,
@Sucursal         int,
@Anden				varchar(10),
@Descripcion		varchar(100)
SELECT  @Empresa   = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT  @Mov= Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mov'
SELECT  @MovID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MovID'
DECLARE
@Tabla Table(
Codigo                    varchar(30),
Cantidad                  varchar(100),
Unidad                    varchar(50),
Articulo                  varchar(20),
Descripcion               varchar(100),
Tipo                      varchar(20)
)
IF @Mov NOT IN(SELECT Mov FROM MovTipo WITH(NOLOCK) WHERE Clave ='COMS.O' AND Modulo='COMS') SET @Ok= 35005
if @Ok is NULL
IF EXISTS(SELECT * FROM Compra WITH(NOLOCK) WHERE Mov = @Mov and MovID = @MovID AND Empresa =@Empresa AND Estatus ='CONCLUIDO')SET @Ok =80010
if @Ok is NULL   
IF NOT EXISTS(SELECT * FROM Compra WITH(NOLOCK) WHERE Mov = @Mov and MovID = @MovID AND Empresa =@Empresa AND Estatus ='PENDIENTE')SET @Ok =14055
if @Ok is NULL  
SELECT @Anden = LTRIM(RTRIM(isnull(PosicionWMS,''))) FROM Compra WITH(NOLOCK) WHERE Mov = @Mov and MovID = @MovID AND Empresa =@Empresa
If @Anden = ''
SET @Ok =80202
IF @Ok IS NULL
INSERT INTO @Tabla
SELECT ISNULL(cb.Codigo,''),
ISNULL(d.CantidadA,0),
ISNULL(d.Unidad,''),
ISNULL(d.Articulo,''),
ISNULL(a.Descripcion1,''),
ISNULL(a.Tipo,'')
FROM Compra c
 WITH(NOLOCK) JOIN CompraD d  WITH(NOLOCK) ON d.ID=c.ID
JOIN CB cb  WITH(NOLOCK) ON cb.Cuenta=d.Articulo
JOIN Art a  WITH(NOLOCK) ON d.Articulo = a.Articulo
WHERE c.Mov = @Mov and c.MovID = @MovID AND c.Empresa =@Empresa
/*AND cb.CodigoPrincipal=1*/
SELECT @Texto =(SELECT TMA.Codigo,
TMA.Cantidad,
TMA.Unidad,
TMA.Articulo,
TMA.Descripcion,
TMA.Tipo
FROM @Tabla TMA
WHERE Cantidad>0
FOR XML AUTO)
IF @@ERROR <> 0 SET @Ok = 1
BEGIN
SELECT @ReferenciaIS = Referencia
FROM IntelisisService WITH(NOLOCK)
WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + ' Descripcion="' + ISNULL(@Descripcion,'') +'">' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
END
END

