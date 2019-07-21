SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSInfoOrdenCompraImprimirCPLC
@ID                        int,
@iSolicitud                int,
@Version                   float,
@Resultado                 varchar(max) = NULL OUTPUT,
@Ok                        int = NULL OUTPUT,
@OkRef                     varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Empresa                   varchar(5),
@Mov                       varchar(20),
@MovID                     varchar(20),
@Articulo                  varchar(20),
@Cantidad                  float,
@Descripcion1              varchar(100),
@Unidad                    varchar(50),
@Texto                     xml,
@ReferenciaIS              varchar(100),
@SubReferencia             varchar(100),
@DescripcionTexto          char(29),
@CantidadTexto             char(8),
@UnidadTexto               char(6),
@PosY                      int,
@Linea                     varchar(255),
@AnchoDescripcion          int,
@AnchoCantidad             int,
@AnchoUnidad               int,
@Interlineado              int
DECLARE @Tabla Table(
idx                      int IDENTITY(1,1),
Linea                    varchar(255)
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
IF @OK IS NULL
BEGIN
IF NOT EXISTS(SELECT TOP 1 * FROM Compra WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID)
SET @OK = 14055
END
IF @OK IS NULL
BEGIN
SET @AnchoDescripcion = 29
SET @AnchoCantidad = 8
SET @AnchoUnidad = 6
SET @Interlineado = 30
SET @PosY = 60
SET @Linea = '! 0 200 200 210 1'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = 'TEXT 0 3 10  10 ' + @Mov + ' ' + @MovID
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = 'TEXT 0 2 10  50 Articulo                      Cantidad Unidad'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
DECLARE crImprimirOC CURSOR FOR
SELECT cd.Articulo,
LTRIM(RTRIM(ISNULL(a.Descripcion1, ''))),
cd.Cantidad,
LTRIM(RTRIM(ISNULL(cd.Unidad,'')))
FROM Compra c
JOIN CompraD cd ON (c.ID = cd.ID)
JOIN Art a ON (cd.Articulo = a.Articulo)
WHERE c.Empresa = @Empresa
AND c.Mov = @Mov
AND c.MovID = @MovID
OPEN crImprimirOC
FETCH NEXT FROM crImprimirOC INTO @Articulo, @Descripcion1, @Cantidad, @Unidad
WHILE @@FETCH_STATUS = 0
BEGIN
SET @PosY = @PosY + @Interlineado
SET @DescripcionTexto = LEFT(@Descripcion1,@AnchoDescripcion)
SET @CantidadTexto    = RIGHT(SPACE(@AnchoCantidad) + CAST(@Cantidad AS varchar), @AnchoCantidad)
SET @UnidadTexto      = RIGHT(SPACE(@AnchoUnidad) + @Unidad, @AnchoUnidad)
SET @Linea = 'TEXT 0 2 10' + ' ' + CONVERT(varchar, @PosY) + ' ' + @DescripcionTexto + ' ' + @CantidadTexto + ' ' + @UnidadTexto
INSERT INTO @Tabla (Linea) VALUES (@Linea)
FETCH NEXT FROM crImprimirOC INTO @Articulo, @Descripcion1, @Cantidad, @Unidad
END
CLOSE crImprimirOC
DEALLOCATE crImprimirOC
END
SET @Linea = 'FORM'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = 'PRINT'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @PosY = @PosY + (@Interlineado * 2)
SET @Linea = '! 0 200 200 ' + CONVERT(varchar, @PosY) + ' 1'
UPDATE @Tabla SET Linea = @Linea WHERE idx = 1
SELECT @Texto = (SELECT ISNULL(Tabla.Linea,'') AS Linea
FROM @Tabla AS Tabla
ORDER BY Tabla.idx
FOR XML AUTO)
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max),@Texto) + '</Resultado></Intelisis>'
END

