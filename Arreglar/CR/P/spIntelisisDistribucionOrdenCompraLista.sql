SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisDistribucionOrdenCompraLista
@ID                        int,
@iSolicitud                int,
@Version                   float,
@Resultado                 varchar(max) = NULL OUTPUT,
@Ok                        int = NULL OUTPUT,
@OkRef                     varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto                   xml,
@ReferenciaIS            varchar(100),
@SubReferencia           varchar(100),
@Empresa                 varchar(5),
@Usuario                 varchar(10),
@Agente                  varchar(10),
@Mov                     varchar(20),
@Orden                   varchar(20),
@Clave                   varchar(20),
@SubClave                varchar(20)
DECLARE @Tabla table(
ID                       int,
Mov                      varchar(20),
MovID                    varchar(20),
Movimiento               varchar(40),
Almacen                  varchar(10),
AlmacenNombre            varchar(100),
Proveedor                varchar(10),
ProveedorNombre          varchar(100),
fFechaEmision            datetime,
FechaEmision             varchar(10)
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SELECT @Agente = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Agente'
SELECT @Mov = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mov'
SELECT @Orden = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Orden'
SELECT @Clave = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Clave'
SELECT @SubClave = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SubClave'
SET @Empresa  = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Usuario  = LTRIM(RTRIM(ISNULL(@Usuario,'')))
SET @Agente   = LTRIM(RTRIM(ISNULL(@Agente,'')))
SET @Mov      = LTRIM(RTRIM(ISNULL(@Mov,'')))
SET @Orden    = LTRIM(RTRIM(ISNULL(@Orden,'')))
SET @Clave    = LTRIM(RTRIM(ISNULL(@Clave,'')))
SET @SubClave = LTRIM(RTRIM(ISNULL(@SubClave,'')))
IF LTRIM(RTRIM(ISNULL(@Agente,''))) = '' SET @Agente = LTRIM(RTRIM(ISNULL(@Usuario,'')))
IF LTRIM(RTRIM(ISNULL(@Agente,''))) = '' SELECT @Agente = DefAgente FROM Usuario WHERE Usuario = @Usuario
IF NOT EXISTS(SELECT * FROM Agente WHERE Agente = @Agente) SET @Ok = 26090
IF ISNULL(@Ok, 0) = 0
BEGIN
INSERT INTO @Tabla (ID, Mov, MovID, Almacen, AlmacenNombre, Proveedor, ProveedorNombre, fFechaEmision)
SELECT c.ID, c.Mov, c.MovID, c.Almacen, a.Nombre, c.Proveedor, p.Nombre, c.FechaEmision
FROM Compra c
JOIN Alm a ON (c.Almacen = a.Almacen)
JOIN Prov p ON (c.Proveedor = p.Proveedor)
WHERE c.Agente = @Agente
AND c.Estatus = 'PENDIENTE'
AND c.Mov = @Mov
UPDATE @Tabla SET FechaEmision = CAST(YEAR(fFechaEmision) AS varchar) + '-' + RIGHT('00' + CAST(MONTH(fFechaEmision) AS varchar),2) + '-' + RIGHT('00' + CAST(DAY(fFechaEmision) AS varchar), 2)
UPDATE @Tabla SET Movimiento = RTRIM(LTRIM(RTRIM(ISNULL(Mov,''))) + ' ' + LTRIM(RTRIM(ISNULL(MovID,''))))
SELECT @Texto = (SELECT CAST(ISNULL(ID,0) AS varchar)            AS ID,
LTRIM(RTRIM(ISNULL(Mov,'')))             AS Mov,
LTRIM(RTRIM(ISNULL(MovID,'')))           AS MovID,
LTRIM(RTRIM(ISNULL(Movimiento,'')))      AS Movimiento,
LTRIM(RTRIM(ISNULL(Almacen,'')))         AS Almacen,
LTRIM(RTRIM(ISNULL(AlmacenNombre,'')))   AS AlmacenNombre,
LTRIM(RTRIM(ISNULL(Proveedor,'')))       AS Proveedor,
LTRIM(RTRIM(ISNULL(ProveedorNombre,''))) AS ProveedorNombre,
LTRIM(RTRIM(ISNULL(FechaEmision,'')))    AS FechaEmision
FROM @Tabla AS Tabla
FOR XML AUTO)
END
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @ReferenciaIS = Referencia, @SubReferencia = SubReferencia FROM IntelisisService WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

