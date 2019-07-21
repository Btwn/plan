SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSInfoOrdenCompra
@ID            int,
@iSolicitud    int,
@Version       float,
@Resultado     varchar(max) = NULL OUTPUT,
@Ok            int = NULL OUTPUT,
@OkRef         varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Empresa                      varchar(5),
@ID2                          int,
@Mov                          varchar(20),
@Anden                        varchar(20),
@MovID                        varchar(20),
@Texto                        xml,
@ReferenciaIS                 varchar(100),
@SubReferencia                varchar(100),
@UsuarioSucursal              bit,
@Verifica                     int,
@Verifica2                    int,
@Sucursal                     int,
@ExisteOrden                  int,
@LeerPosicionOrigen           int,
@ModuloID                     int,
@Usuario                      varchar(10),
@ModificarPosicionSugeridaWMS bit
DECLARE @Tabla Table(
Proveedor                     varchar(20),
NombreProveedor               varchar(50),
FechaEntrega                  datetime,
Anden                         varchar(20),
Almacen                       varchar(10),
LeerPosicionOrigen            int,
ModificarPosicionSugeridaWMS  bit,
ModuloID                      int
)
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Mov = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mov'
SELECT @MovID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MovID'
SELECT @Usuario = Usuario FROM IntelisisService WITH(NOLOCK) WHERE ID = @ID
SELECT @ModificarPosicionSugeridaWMS = ModificarPosicionSugeridaWMS FROM Usuario WITH(NOLOCK) WHERE Usuario = @Usuario
SELECT @LeerPosicionOrigen = ISNULL(WMSLeerPosicionOrigen, 0) FROM EmpresaCfg WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT @ModuloID = ID FROM Compra WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID
IF @Ok IS NULL
INSERT Into @Tabla(Proveedor, NombreProveedor, FechaEntrega, Anden, Almacen, LeerPosicionOrigen, ModificarPosicionSugeridaWMS, ModuloID)
SELECT c.Proveedor, p.Nombre, ISNULL(c.FechaEntrega, c.FechaEmision), c.PosicionWMS, c.Almacen, @LeerPosicionOrigen, @ModificarPosicionSugeridaWMS, @ModuloID
FROM Compra c  WITH(NOLOCK) JOIN Prov p  WITH(NOLOCK) ON c.Proveedor = p.Proveedor
WHERE c.Empresa = @Empresa AND c.ID = @ModuloID
ELSE
INSERT Into @Tabla(Proveedor, NombreProveedor, FechaEntrega, LeerPosicionOrigen, ModificarPosicionSugeridaWMS, Anden, Almacen, ModuloID)
VALUES ('No existe', 'No existe', '', 'Sin Anden', 'Sin Almacen', @LeerPosicionOrigen, @ModificarPosicionSugeridaWMS, @ModuloID)
SELECT @Texto = (SELECT ISNULL(Proveedor,'')                                    AS Proveedor,
ISNULL(NombreProveedor,'')                              AS NombreProveedor,
ISNULL(FechaEntrega,'')                                 AS FechaEntrega,
ISNULL(Anden,'')                                        AS Anden,
ISNULL(Almacen,'')                                      AS Almacen,
CAST(ISNULL(LeerPosicionOrigen,0) AS varchar)           AS LeerPosicionOrigen,
CAST(ISNULL(ModificarPosicionSugeridaWMS,0) AS varchar) AS ModificarPosicionSugeridaWMS,
CAST(ISNULL(ModuloID,0) AS varchar)                     AS ModuloID
FROM @Tabla AS OrdenCompra
FOR XML AUTO)
SELECT @ReferenciaIS = Referencia FROM IntelisisService WITH(NOLOCK) WHERE ID = @ID
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max),@Texto) + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

