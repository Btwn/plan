SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSInfoCodigoBarrasSurtido
@ID                      int,
@iSolicitud              int,
@Version                 float,
@Resultado               varchar(max) = NULL OUTPUT,
@Ok                      int = NULL OUTPUT,
@OkRef                   varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@ReferenciaIS            varchar(100),
@SubReferencia           varchar(100),
@Texto                   xml,
@Empresa                 varchar(5),
@Sucursal                int,
@Almacen                 varchar(10),
@Usuario                 varchar(10),
@Mov                     varchar(20),
@MovID                   varchar(20),
@Renglon                 float,
@RenglonSub              int,
@RenglonID               int,
@Articulo                varchar(20),
@SubCuenta               varchar(50),
@CodigoBarras            varchar(30),
@DUN14                   varchar(30),
@idr                     int
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Sucursal = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sucursal'
SELECT @Almacen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Almacen'
SELECT @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SELECT @Mov = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mov'
SELECT @MovID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MovID'
SELECT @Renglon = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Renglon'
SELECT @RenglonSub = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'RenglonSub'
SELECT @RenglonID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'RenglonID'
SELECT @Articulo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Articulo'
SELECT @SubCuenta = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SubCuenta'
SELECT @CodigoBarras = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CodigoBarras'
DECLARE @Tabla Table(
IDR                 int identity(1,1),
CodigoBarras        varchar(30),
DUN14               varchar(30),
Articulo            varchar(20),
Articulo2           varchar(20),
SubCuenta           varchar(50),
SubCuenta2          varchar(50),
Cantidad            float,
CantidadInner       float,
CantidadMaster      float,
Cliente             varchar(99),
Mensaje             varchar(255)
)
INSERT INTO @Tabla(CodigoBarras, Articulo, SubCuenta, Cantidad)
SELECT TOP 1 Codigo, LTRIM(RTRIM(ISNULL(Cuenta,''))), LTRIM(RTRIM(ISNULL(SubCuenta,''))), ISNULL(Cantidad,1)
FROM CB
WITH(NOLOCK) WHERE Codigo = @CodigoBarras
AND TipoCuenta = 'Articulos'
SELECT @idr = Max(IDR) FROM @Tabla
IF ISNULL(@idr,0) = 0
BEGIN
INSERT INTO @Tabla(CodigoBarras, DUN14, CantidadInner, CantidadMaster, Cliente)
SELECT TOP 1 Codigo, DUN14, CantidadINNER, CantidadMaster, Cliente
FROM SterenDUN14 WITH(NOLOCK)
WHERE DUN14 = @CodigoBarras
UPDATE @Tabla
SET Articulo = LTRIM(RTRIM(ISNULL(b.Cuenta,''))),
SubCuenta = LTRIM(RTRIM(ISNULL(b.SubCuenta,'')))
FROM @Tabla a
JOIN CB b
 WITH(NOLOCK) ON (a.CodigoBarras = b.Codigo AND b.TipoCuenta = 'Articulos')
SELECT @idr = Max(IDR) FROM @Tabla
END
IF ISNULL(@idr,0) = 0
BEGIN
INSERT INTO @Tabla (Mensaje) SELECT 'C�digo no encontrado.'
END
ELSE
BEGIN
SELECT @DUN14 = LTRIM(RTRIM(ISNULL(DUN14,''))) FROM @Tabla WHERE IDR = 1
IF LEN(@DUN14) > 0
BEGIN
UPDATE @Tabla SET Cantidad = CantidadMaster WHERE IDR = 1
END
IF NOT (SELECT Articulo FROM @Tabla WHERE IDR = 1) = @Articulo
BEGIN
UPDATE @Tabla
SET Articulo2 = @Articulo,
Mensaje = 'Art�culo incorrecto.'
WHERE IDR = 1
END
ELSE IF NOT (SELECT SubCuenta FROM @Tabla WHERE IDR = 1) = @SubCuenta
UPDATE @Tabla SET Mensaje = 'Opci�n Incorrecta.' WHERE IDR = 1
END
SELECT @Texto = (SELECT CAST(ISNULL(IDR,0) AS varchar)            AS IDR,
ISNULL(CodigoBarras,'')                   AS CodigoBarras,
ISNULL(DUN14,'')                          AS DUN14,
ISNULL(Articulo,'')                       AS Articulo,
ISNULL(Articulo2,'')                      AS Articulo2,
ISNULL(SubCuenta,'')                      AS SubCuenta,
ISNULL(SubCuenta2,'')                     AS SubCuenta2,
CAST(ISNULL(Cantidad,0) AS varchar)       AS Cantidad,
CAST(ISNULL(CantidadInner,0) AS varchar)  AS CantidadInner,
CAST(ISNULL(CantidadMaster,0) AS varchar) AS CantidadMaster,
ISNULL(Cliente,'')                        AS Cliente,
ISNULL(Mensaje,'')                        AS Mensaje
FROM @Tabla AS TMA
FOR XML AUTO)
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @ReferenciaIS = Referencia FROM IntelisisService WITH(NOLOCK) WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

