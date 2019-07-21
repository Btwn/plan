SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisWMSAfectarOC
@ID    int,
@iSolicitud  int,
@Version  float,
@Resultado  varchar(max) = NULL OUTPUT,
@Ok    int = NULL OUTPUT,
@OkRef   varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@ID2                int,
@IDGenerar          int,
@IDAcceso           int,
@Estacion           int,
@Empresa            varchar(5),
@Mov                varchar(20),
@Mov2                varchar(20),
@Usuario            varchar(20),
@CB                 varchar(30),
@Cantidad           float,
@MovID              varchar(20),
@Articulo           varchar(20),
@SubCuenta          varchar(50),
@Texto              xml,
@ReferenciaIS       varchar(100),
@SubReferencia      varchar(100),
@Caducidad          datetime,
@FechaCaducidad     int,
@Fecha              datetime,
@Verifica           int,
@Verifica2          int,
@Sucursal           int,
@Partidas           int, /*RJP 171110 Cuenta partidas con CantidadA > 0*/
@Referencia         varchar (50), 
@RenglonID          float,
@RenglonID2         float,
@RenglonSub         int,
@Renglon            int,
@Renglon2           int,
@Cantidad2          float,
@FechaCaducidad2    datetime,
@StrSQL             nvarchar(max),
@EsSSFA             varchar(2),
@TipoDocSF          varchar(10),
@FacturaSF          varchar(20),
@FechaFacturaSF     varchar(8),
@SubTotalSF         money,
@IEPSSF             money,
@IVASF              money,
@ImporteTotalSF     money,
@Moneda			        varchar(10),
@TipoCambio		      float,
@FechaEmision		    datetime,
@Parametros		      nvarchar(max),
@ArticuloCaducidad  varchar(20)
DECLARE @TipoEntradaGenerar varchar(100) 
DECLARE @AndenRecibo varchar(10)
SELECT @Parametros = '@ID					int,
@Empresa			varchar(5),
@Usuario			varchar(10),
@Mov				varchar(20),
@Moneda				varchar(10),
@TipoCambio			float,
@FechaEmision		datetime,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT'
BEGIN TRANSACTION
SELECT @Estacion=@@SPID 
SELECT  @Empresa   = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT  @Usuario = Usuario FROM IntelisisService WHERE ID = @ID
SELECT  @Mov= Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Mov'
SELECT  @MovID = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'MovID'
SELECT  @EsSSFA = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'EsSSFA'
SELECT  @TipoDocSF = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TipoDocSF'
SELECT  @FacturaSF = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'FacturaSF'
SELECT  @FechaFacturaSF = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'FechaFacturaSF'
SELECT  @SubTotalSF = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'SubTotalSF'
SELECT  @IEPSSF = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'IEPSSF'
SELECT  @IVASF = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'IVASF'
SELECT  @ImporteTotalSF = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ImporteTotalSF'
SELECT  @TipoEntradaGenerar = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'TipoEntradaGenerar'
SELECT @AndenRecibo = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'AndenRecibo'
IF @@ERROR <> 0 SET @Ok = 1
BEGIN
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @@ERROR <> 0 SET @Ok = 1
SELECT @ID2 = ID FROM Compra WHERE  Mov=@Mov AND MovID=@MovID AND Empresa=@Empresa
/*RJP 171110 Valida que existan partidas recibidas para que la entrada de compra no se genere vacia*/
IF @OK is NULL
BEGIN
SELECT @Partidas = count(ID) FROM CompraD WHERE ID = @ID2  AND (CantidadA > 0 or CantidadA is not null)
IF @Partidas = 0
SET @OK = 60010 
END
/*RJP 171110 Valida que existan partidas recibidas para que la entrada de compra no se genere vacia*/
IF @Ok IS NULL
BEGIN
SET @Mov2 = @TipoEntradaGenerar
EXEC  @IDGenerar=spAfectar 'COMS', @ID2, 'GENERAR', 'Seleccion', @Mov2, @Usuario, @Estacion=@Estacion, @EnSilencio=1, @Conexion=1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok BETWEEN 80030 AND 81000
IF @Ok<>60010 
SELECT @Ok = NULL
END
DECLARE crRenglon CURSOR LOCAL FOR
SELECT d.Renglon, d.RenglonSub, f.Cantidad, f.FechaCaducidad, f.Articulo
FROM FechaCaducidadMovil f
JOIN CompraD d ON f.ID = d.ID AND f.Articulo = d.Articulo
WHERE d.ID = @ID2
AND f.Procesado = 0
AND f.Cantidad > 0
OPEN crRenglon
FETCH NEXT FROM crRenglon INTO @Renglon, @RenglonSub, @Cantidad2, @FechaCaducidad2, @ArticuloCaducidad
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
UPDATE CompraD SET FechaCaducidad = @FechaCaducidad2 WHERE ID = @IDGenerar AND Articulo = @ArticuloCaducidad AND Cantidad = @Cantidad2 
FETCH NEXT FROM crRenglon INTO @Renglon, @RenglonSub, @Cantidad2, @FechaCaducidad2, @ArticuloCaducidad
END
CLOSE crRenglon
DEALLOCATE crRenglon
IF @Ok IS NULL
UPDATE Compra SET Usuario = @Usuario WHERE ID = @IDGenerar
IF @Ok IS NULL AND @EsSSFA='SI'
BEGIN
SET @StrSQL='UPDATE Compra ' +
'SET TipoDocSF=NULLIF(RTRIM(' +'''' + @TipoDocSF + '''), '''')' +
', FacturaNumeroSF=NULLIF(RTRIM(' +'''' + @FacturaSF + '''), '''')' +
', FechaFacturaSF=' +'''' + @FechaFacturaSF + '''' +
', SubTotalSF='+ CAST(@SubTotalSF AS VARCHAR(10)) +
', IEPSSF='+ CAST(@IEPSSF AS VARCHAR(10)) +
', IVASF=' + CAST(@IVASF AS VARCHAR(10)) +
', ImporteTotalSF=' + CAST(@ImporteTotalSF AS VARCHAR(10)) +
' WHERE ID=' + CAST(@IDGenerar AS VARCHAR(10))
EXEC(@StrSQL)
SELECT @Moneda = Moneda, @TipoCambio = TipoCambio, @FechaEmision = FechaEmision FROM Compra WHERE ID = @ID
/*
SELECT @StrSQL = 'EXEC xpASCompraValidarCaptura @ID, ''AFECTAR'', ''Todo'', @Empresa, @Usuario, ''COMS'', @Mov,'''',
''COMS.F'',@Moneda,@TipoCambio,''SINAFECTAR'',''CONCLUIDO'',@FechaEmision,@Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT'
EXEC sp_executesql @StrSQL, @Parametros, @IDGenerar, @Empresa, @Usuario, @Mov, @Moneda, @TipoCambio, @FechaEmision, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
*/
END
IF @Ok IS NULL  
IF EXISTS(SELECT * FROM MovTipo WHERE Modulo = 'COMS' AND Mov = @Mov2 AND Clave = 'COMS.EI')
BEGIN
UPDATE CompraD
SET ImportacionProveedor = b.Proveedor
FROM CompraD a
INNER JOIN Compra b
ON (a.Aplica = b.Mov AND a.AplicaID = b.MovID)
WHERE a.ID = @IDGenerar
END
ELSE
BEGIN
UPDATE CompraD SET ImportacionProveedor = NULL WHERE ID = @IDGenerar
END
SELECT @Sucursal = Sucursal FROM Compra WHERE ID = @ID2
SET @Sucursal = ISNULL(@Sucursal,0)
DELETE SerieLoteMov WHERE Empresa = @Empresa AND Modulo = 'COMS' AND ID = @IDGenerar
EXEC spMovCopiarSerielote @Sucursal, 'COMS', @ID2, @IDGenerar
EXEC spReconstruirSerieLoteMov 'DEMO', 'COMS', @IDGenerar, @OK, @OKRef
IF @OK IS NULL
BEGIN
UPDATE Compra SET PosicionWMS = @AndenRecibo WHERE ID = @IDGenerar
EXEC spAfectar 'COMS', @IDGenerar, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion = @Estacion, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
IF @OK IS NULL
BEGIN
DELETE SerieLoteMov WHERE Empresa = @Empresa AND Modulo = 'COMS' AND ID = @ID2
END
IF @Ok = 80060 SELECT @Ok = NULL
IF @Ok=10060 AND @EsSSFA='SI'
BEGIN
SET @Ok = NULL
SET @StrSQL='UPDATE Compra
SET TipoDocSF=NULL,
FacturaNumeroSF=NULL,
FechaFacturaSF=NULL,
SubTotalSF=NULL,
IEPSSF=NULL,
IVASF=NULL,
ImporteTotalSF=NULL
WHERE ID=' + CAST(@IDGenerar AS VARCHAR(10))
EXEC(@StrSQL)
END
IF @OK IS NULL
BEGIN
SELECT @Referencia = Idioma from compra
where ID = @ID2   
UPDATE Compra set Referencia = @Referencia
Where ID = @IDGenerar   
END
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NOT NULL SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
IF @Ok IS NULL
BEGIN
SELECT @OkRef = RTRIM(Mov)+' '+RTRIM(MovID) FROM Compra WHERE ID = @IDGenerar 
END
ELSE
SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '></Resultado></Intelisis>'
SET @Resultado = REPLACE(@Resultado,'<BR>','.')
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL OR @Ok = -1
BEGIN
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
END
IF @Ok IS NOT NULL
BEGIN
DELETE FechaCaducidadMovil WHERE ID = @ID2 AND Modulo = 'COMS'
DELETE SerieLoteMovMovil WHERE ID = @ID2 AND Modulo = 'COMS'
END
END
END

