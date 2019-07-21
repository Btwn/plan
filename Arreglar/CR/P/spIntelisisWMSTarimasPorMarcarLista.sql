SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSTarimasPorMarcarLista
@ID                 int,
@iSolicitud         int,
@Version            float,
@Resultado          varchar(max) = NULL OUTPUT,
@Ok                 int = NULL OUTPUT,
@OkRef              varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto                xml,
@ReferenciaIS         varchar(100),
@SubReferencia        varchar(100),
@Empresa              varchar(5),
@Almacen              varchar(10),
@ListaMovimientos     varchar(max),
@Delimitador          char(1),
@Inicio               int,
@Fin                  int,
@idx                  int,
@Maximo               int,
@MaxIdx               int
DECLARE @ListaID table (
idx                   int IDENTITY(1,1),
ID                    varchar(10)
)
DECLARE @Tabla Table(
Empresa               varchar(5),
Almacen               varchar(10),
ModuloID              int,
Mov                   varchar(20),
MovID                 varchar(20),
Renglon               float
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Almacen = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Almacen'
SELECT @ListaMovimientos = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ListaMovimientos'
SET @Empresa          = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Almacen          = LTRIM(RTRIM(ISNULL(@Almacen,'')))
SET @ListaMovimientos = LTRIM(RTRIM(ISNULL(@ListaMovimientos,'')))
SET @Delimitador = '~'
SET @Maximo = 1000
SET @idx = 0
SET @Inicio = 1
SET @Fin = CHARINDEX(@Delimitador, @ListaMovimientos)
WHILE (@Inicio < (LEN(@ListaMovimientos) + 1)) AND (@idx < @Maximo)
BEGIN
SET @idx = @idx + 1
IF @Fin = 0 SET @Fin = (LEN(@ListaMovimientos) + 1)
INSERT INTO @ListaID (ID) VALUES(SUBSTRING(@ListaMovimientos, @Inicio, (@Fin - @Inicio)))
SET @Inicio = (@Fin + 1)
SET @Fin = CHARINDEX(@Delimitador, @ListaMovimientos, @Inicio)
END
INSERT INTO @Tabla (Empresa, Almacen, ModuloID, Mov, MovID)
SELECT @Empresa, @Almacen, t.ID, t.Mov, t.MovID
FROM TMA t
JOIN @ListaID d ON (t.ID = d.ID)
INSERT INTO @Tabla (Empresa, Almacen, ModuloID, Mov, MovID)
SELECT @Empresa, @Almacen, t.ID, t.Mov, t.MovID
FROM TMA t
JOIN @Tabla d ON (t.Origen = d.Mov AND t.OrigenID = d.MovID)
UPDATE @Tabla
SET Renglon = b.Renglon
FROM @Tabla a
JOIN TMAD b ON(a.ModuloID = b.ID)
SELECT @Texto = (SELECT CAST(ISNULL(ModuloID,0) AS varchar) AS ModuloID,
ISNULL(Mov,'')                      AS Mov,
ISNULL(MovID,'')                    AS MovID,
CAST(ISNULL(Renglon,0) AS varchar)  AS Renglon
FROM @Tabla AS TMA
FOR XML AUTO)
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
END TRY
BEGIN CATCH
SET @Ok = 1
SELECT @OkRef = LTRIM(RTRIM(LEFT(ERROR_MESSAGE(),255)))
END CATCH
SELECT @ReferenciaIS = Referencia FROM IntelisisService WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + ISNULL(CONVERT(varchar(max),@Texto),'') + '</Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

