SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISIntelisisTMAAfectarTMA_OSURP
@ID                      int,
@iSolicitud              int,
@Version                 float,
@Resultado               varchar(max) = NULL OUTPUT,
@Ok                      int = NULL OUTPUT,
@OkRef                   varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@IDGenerar               int,
@IDAcceso                int,
@MovTipo                 varchar(20),
@ReferenciaIS            varchar(100),
@Usuario2                varchar(10),
@Estacion                int,
@SubReferencia           varchar(100),
@Empresa                 varchar(5),
@Mov                     varchar(20),
@MovID                   varchar(20),
@Mov2                    varchar(20),
@Mov3                    varchar(20),
@MovID2                  varchar(20),
@Sucursal                int,
@ID2                     int,
@Tarima                  varchar(20),
@Sucursal2               varchar(100),
@Posicion                varchar(20),
@PosicionDestino         varchar(20),
@Usuario                 varchar(15),
@Cantidad                float(20),
@Estatus                 varchar(20),
@Articulo                varchar(20),
@SubClave                varchar(20),
@Procesado               bit,
@Montacargas             varchar(20),
@Agente                  varchar(20),
@CB                      varchar(30),
@SubCuenta               varchar(50),
@Unidad                  varchar(20),
@UnidadCompra            varchar(20),
@Factor                  float ,
@Almacen                 varchar(20),
@Disponible              float,
@Renglon                 float
BEGIN TRANSACTION
SELECT @Estacion=@@SPID 
IF @Ok IS NULL
BEGIN
SELECT  @Empresa = NULLIF(Empresa,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(Empresa    varchar(255))
SELECT  @MovID = NULLIF(MovID,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(MovID    varchar(255))
SELECT  @Mov= NULLIF(Mov,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(Mov    varchar(255))
SELECT  @Tarima = NULLIF(Tarima,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(Tarima   varchar(255))
SELECT  @Articulo = NULLIF(Articulo,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(Articulo   varchar(255))
SELECT  @Cantidad = CONVERT(float,Cantidad)FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(Cantidad   varchar(255))
SELECT  @Usuario = NULLIF(Usuario,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(Usuario   varchar(255))
SELECT  @Sucursal2 = NULLIF(Sucursal,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(Sucursal   varchar(255))
SELECT  @Montacargas = NULLIF(Montacarga,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(Montacarga   varchar(255))
SELECT  @SubCuenta = NULLIF(SubCuenta ,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(SubCuenta    varchar(255))
SELECT  @Unidad = NULLIF(Unidad,'')FROM openxml (@iSolicitud,'/Intelisis/Solicitud/TMA')
WITH(Unidad   varchar(255))
END
SELECT @MovTipo = Clave,@SubClave = SubClave FROM MovTipo WHERE Mov = @Mov AND Modulo = 'TMA'
IF @MovTipo <>'TMA.OSUR' AND @SubClave='TMA.OSURP'
SELECT @Ok = 35005, @OkRef = @Mov
SELECT @Factor = dbo.fnArtUnidadFactor(@Empresa, @Articulo, @Unidad) 
SET @Cantidad = @Cantidad * @Factor 
IF @OK IS NULL
IF NOT EXISTS(SELECT * FROM TMAD d /*WITH(NOLOCK)*/ JOIN TMA t /*WITH(NOLOCK)*/ ON t.ID = d.ID JOIN MovTipo m /*WITH(NOLOCK)*/ ON m.Mov = t.Mov AND m.Modulo = 'TMA' AND t.MovID = @MovID
JOIN ArtDisponibleTarima a /*WITH(NOLOCK)*/ ON a.Tarima = d.Tarima AND a.Almacen = d.Almacen AND a.Empresa = t.Empresa WHERE a.Articulo = @Articulo AND m.Clave = 'TMA.OSUR' AND m.SubClave = 'TMA.OSURP' AND a.Tarima = @Tarima) SET @Ok = 13070 
IF @OK IS NULL
IF NOT EXISTS(SELECT * FROM TMAD d /*WITH(NOLOCK)*/ JOIN TMA t /*WITH(NOLOCK)*/ ON t.ID = d.ID JOIN MovTipo m /*WITH(NOLOCK)*/ ON m.Mov = t.Mov AND m.Modulo = 'TMA' AND t.MovID = @MovID
JOIN ArtDisponibleTarima a /*WITH(NOLOCK)*/ ON a.Tarima = d.Tarima AND a.Almacen = d.Almacen AND a.Empresa = t.Empresa WHERE a.Articulo = @Articulo AND m.Clave = 'TMA.OSUR' AND m.SubClave = 'TMA.OSURP' AND a.Tarima = @Tarima AND a.Disponible >= @Cantidad) SET @Ok = 20020 
SELECT @Agente = DefAgente, @Almacen=DefAlmacen FROM Usuario WHERE Usuario = @Usuario  
IF @Agente IS NULL SELECT @Ok = 20930
IF @Ok=20020
BEGIN
SELECT @Disponible = ISNULL(b.Disponible,0)/ISNULL(@Factor,1)  FROM Tarima a /*WITH(NOLOCK)*/
INNER JOIN ArtDisponibleTarima b /*WITH(NOLOCK)*/ ON a.Tarima = b.Tarima
WHERE a.Almacen = @Almacen
AND a.Estatus = 'ALTA'
AND a.Tarima=@Tarima
AND b.Articulo=@Articulo
AND b.Empresa=@Empresa
END
IF @Ok IS NULL AND @Cantidad < 1
SELECT @OK = 20015
IF @Ok IS NULL
BEGIN
SELECT @ID2 = ID FROM TMA WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID
SELECT @Estatus = Estatus FROM TMA WHERE ID = @ID2
SELECT @Procesado = ISNULL(Procesado,0),
@Renglon = Renglon
FROM TMAD
WHERE ID = @ID2
AND Tarima = @Tarima
UPDATE TMAD
SET CantidadA = @Cantidad
WHERE Tarima = @Tarima  AND ID = @ID2
IF @Ok IS NULL AND @Estatus = 'PENDIENTE' AND @MovTipo = 'TMA.OSUR'
BEGIN
SELECT @Mov3 = TMASurtidoTransitoPCK FROM EmpresaCfgMovWMS WHERE Empresa = @Empresa
EXEC @IDGenerar =  spAfectar 'TMA', @ID2, 'GENERAR', 'Seleccion', @Mov3, @Usuario, @Estacion,@EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT , @OkRef = @OkRef OUTPUT
UPDATE TMA SET Montacarga = @Montacargas , Agente = @Agente
WHERE ID = @IDGenerar
IF @Ok BETWEEN 80030 AND 81000 SELECT @Ok = NULL , @OkRef = NULL
EXEC spAfectar 'TMA', @IDGenerar, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion,@EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT ,@OkRef = @OkRef OUTPUT
IF @Ok BETWEEN 80030 AND 81000 SELECT @Ok = NULL , @OkRef = NULL
END
IF @Ok IS NULL
SELECT @Mov2 = Mov , @MovID2 = MovID  FROM TMA WHERE ID = @IDGenerar
END
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
END
SELECT @ReferenciaIS = Referencia FROM IntelisisService WHERE ID = @ID
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
IF @Ok = 20020 SELECT @OkRef = @OkRef + '. ' + 'Disponible actual = ' + CAST(ISNULL(@Disponible,0) AS varchar) 
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34)
+ ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34)
+ ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34)
+ '> <Resultado IntelisisServiceID='
+ CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')                      + CHAR(34)
+ ' Modulo='   + CHAR(34) + 'TMA'                                 + CHAR(34)
+ ' ModuloID=' + CHAR(34) + CAST(ISNULL(@IDGenerar,0) AS VARCHAR) + CHAR(34)
+ ' Mov='      + CHAR(34) + ISNULL(@Mov2,'')                      + CHAR(34)
+ ' MovID='    + CHAR(34) + ISNULL(@MovID2,'')                    + CHAR(34)
+ ' Renglon='  + CHAR(34) + CAST(ISNULL(@Renglon,0) AS varchar)   + CHAR(34)
+ ' Ok='       + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'')       + CHAR(34)
+ ' OkRef='    + CHAR(34) + ISNULL(@OkRef,'')                     + CHAR(34)
+ '/></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
END

