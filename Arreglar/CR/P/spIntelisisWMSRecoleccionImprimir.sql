SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSRecoleccionImprimir
@ID                        int,
@iSolicitud                int,
@Version                   float,
@Resultado                 varchar(max) = NULL OUTPUT,
@Ok                        int = NULL OUTPUT,
@OkRef                     varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Texto                     xml,
@ReferenciaIS              varchar(100),
@SubReferencia             varchar(100),
@Empresa                   varchar(5),
@Almacen                   varchar(10),
@Sucursal                  int,
@SucursalNombre            varchar(100),
@Usuario                   varchar(20),
@Agente                    varchar(10),
@Paquete                   varchar(20),
@Fecha                     varchar(20),
@MovOrigen                 varchar(50),
@Mov                       varchar(20),
@MovID                     varchar(20),
@Articulo                  varchar(20),
@Subcuenta                 varchar(20),
@Cantidad                  int,
@Tarima                    varchar(20),
@TarimaSurtido             varchar(20),
@Posicion                  varchar(20),
@PosicionDestino           varchar(20),
@Linea                     varchar(255),
@Interlinea                int,
@xPos                      int,
@yPos                      int
DECLARE @TablaPaquete table(
idx                       int IDENTITY(1,1),
Paquete                   varchar(20),
IDOrigen                  int,
IDDestino                 int,
Articulo                  varchar(20),
Subcuenta                 varchar(50),
Cantidad                  float,
Tarima                    varchar(20),
TarimaSurtido             varchar(20),
Posicion                  varchar(10),
PosicionDestino           varchar(10),
Sucursal                  int,
Usuario                   varchar(10),
Fecha                     datetime,
Mov                       varchar(20),
MovID                     varchar(20),
OrigenTipo                varchar(10),
Origen                    varchar(20),
OrigenID                  varchar(20),
Referencia                varchar(50),
SucursalNombre            varchar(100),
Almacen                   varchar(10),
AlmacenNombre             varchar(100)
)
DECLARE @Tabla Table(
idx                        int IDENTITY(1,1),
Linea                      varchar(255)
)
BEGIN TRY
SELECT @Empresa = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SELECT @Paquete = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Paquete'
SET @Empresa = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Usuario = LTRIM(RTRIM(ISNULL(@Usuario,'')))
SET @Paquete = LTRIM(RTRIM(ISNULL(@Paquete,'')))
SET @Interlinea = 30
SET @xPos = 125
SET @yPos = 60
INSERT INTO @TablaPaquete (Paquete, IDOrigen, IDDestino, Articulo, Subcuenta, Cantidad, Tarima, TarimaSurtido, Posicion, PosicionDestino, Sucursal, Usuario, Fecha)
SELECT Paquete, IDOrigen, IDDestino, Articulo, Subcuenta, Cantidad, Tarima, TarimaSurtido, Posicion, PosicionDestino, Sucursal, Usuario, Fecha
FROM WMSPaquete
WHERE Paquete = @Paquete
ORDER BY IDDestino
UPDATE @TablaPaquete
SET Mov = b.Mov,
MovID = b.MovID
FROM @TablaPaquete a
JOIN TMA b ON(a.IDDestino = b.ID)
UPDATE @TablaPaquete
SET OrigenTipo = b.OrigenTipo,
Origen     = b.Origen,
OrigenID   = b.OrigenID,
Referencia = b.Referencia,
Almacen    = b.Almacen
FROM @TablaPaquete a
JOIN TMA b ON(a.IDOrigen = b.ID)
UPDATE @TablaPaquete
SET SucursalNombre = b.Nombre
FROM @TablaPaquete a
JOIN Sucursal b ON(a.Sucursal = b.Sucursal)
UPDATE @TablaPaquete
SET AlmacenNombre = b.Nombre
FROM @TablaPaquete a
JOIN Alm b ON(a.Almacen = b.Almacen)
SET @Linea = '! 0 200 200 200 1'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @yPos = @yPos + @Interlinea
SET @Linea = 'TEXT 0 4 ' + CONVERT(varchar, @xPos) + ' ' + CONVERT(varchar, @yPos) + ' Paquete ' + @Paquete
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @yPos = @yPos + (@Interlinea * 2)
SELECT @Fecha = CONVERT(varchar,Fecha,126) FROM @TablaPaquete WHERE idx = 1
SET @Fecha = REPLACE (@fecha,'T',' ')
SET @Fecha = REPLACE (@fecha,'.','')
SET @Fecha = LTRIM(RTRIM(ISNULL(@Fecha,'')))
SET @Linea = 'TEXT 0 3 ' + CONVERT(varchar, @xPos) + ' ' + CONVERT(varchar, @yPos) + ' Fecha:  ' + @Fecha
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @yPos = @yPos + @Interlinea
SELECT @MovOrigen = Origen + ' '  + OrigenID FROM @TablaPaquete WHERE idx = 1
SET @Linea = 'TEXT 0 3 ' + CONVERT(varchar, @xPos) + ' ' + CONVERT(varchar, @yPos) + ' Origen: ' + @MovOrigen
INSERT INTO @Tabla (Linea) VALUES (@Linea)
DECLARE crImprimirCPCL CURSOR FOR
SELECT t.Mov, t.MovID, t.Articulo, t.Subcuenta, t.Cantidad, t.Tarima, t.TarimaSurtido, t.Posicion,t.PosicionDestino
FROM @TablaPaquete t
OPEN crImprimirCPCL
FETCH NEXT FROM crImprimirCPCL INTO @Mov, @MovID, @Articulo, @Subcuenta, @Cantidad, @Tarima, @TarimaSurtido, @Posicion, @PosicionDestino
WHILE @@FETCH_STATUS = 0
BEGIN
SET @yPos = @yPos + (@Interlinea * 1.5)
SET @Linea = 'TEXT 0 3 ' + CONVERT(varchar, @xPos) + ' ' + CONVERT(varchar, @yPos) + ' ' + @Mov + ' ' + @MovID
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @yPos = @yPos + @Interlinea
SET @Linea = 'TEXT 0 2 ' + CONVERT(varchar, @xPos) + ' ' + CONVERT(varchar, @yPos) + ' ' + 'Articulo            Cantidad  Tarima              T. Surtido'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @yPos = @yPos + @Interlinea
SET @Linea = 'TEXT 0 2 ' + CONVERT(varchar, @xPos) + ' ' + CONVERT(varchar, @yPos) + ' ' + @Articulo + SPACE(20 - LEN(@Articulo)) + CAST(@Cantidad AS varchar) + SPACE(10 - LEN(CAST(@Cantidad AS varchar))) + @Tarima +  + SPACE(20 - LEN(@Tarima)) + @TarimaSurtido
INSERT INTO @Tabla (Linea) VALUES (@Linea)
FETCH NEXT FROM crImprimirCPCL INTO @Mov, @MovID, @Articulo, @Subcuenta, @Cantidad, @Tarima, @TarimaSurtido, @Posicion, @PosicionDestino
END
CLOSE crImprimirCPCL
DEALLOCATE crImprimirCPCL
SET @Linea = 'FORM'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @Linea = 'PRINT'
INSERT INTO @Tabla (Linea) VALUES (@Linea)
SET @yPos = @yPos + (@Interlinea * 2)
SET @Linea = '! 0 200 200 ' + CONVERT(varchar, @yPos) + ' 1'
UPDATE @Tabla SET Linea = @Linea WHERE idx = 1
SELECT @Texto = (SELECT ISNULL(Tabla.Linea,'') AS Linea
FROM @Tabla AS Tabla
ORDER BY Tabla.idx
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

