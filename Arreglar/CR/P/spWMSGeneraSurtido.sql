SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSGeneraSurtido
@Estacion   int,
@Usuario    varchar(10)

AS
BEGIN
SET NOCOUNT ON
DECLARE @Articulo                     varchar(20),
@ID                       int,
@Empresa                  varchar(5),
@Sucursal                 int,
@Mov                      varchar(20),
@FechaEmision             datetime,
@Estatus                  varchar(15),
@Almacen                  varchar(10),
@Agente                   varchar(10),
@Zona                     varchar(50),
@Observaciones   varchar(100),
@PosicionOrigen			varchar(10),
@PosicionDestino          varchar(10),
@CantidadTarima			float,
@Tarima                   varchar(20),
@Renglon                  float,
@Ok                       int,
@OkRef                    varchar(255),
@TarimaSurtido			varchar(20),
@MinimoTarima             float,
@IDDestino                int,
@Disponible               float,
@MovA                     char(20),
@MovDestino               varchar(20),
@MovDestinoID             varchar(20),
@MovID                    varchar(20),
@Tipo                     varchar(20),
@Resultado                float,
@DisponibleTarima         float,
@Ordenes                  float,
@Contador                 bit,
@ControlArticulo          varchar(20),
@IDModuloD                int,
@ModuloD                  char(5),
@CantidadD                float,
@ArticuloD                varchar(20),
@AlmacenD                 varchar(10),
@ArticuloPediente         varchar(20),
@AlmacenPediente          varchar(20),
@CantidadPediente         float,
@IDPendiente              int,
@ArticuloWMS              varchar(20),
@AlmacenWMS               varchar(20),
@CantidadWMS              float,
@ModuloWMS                char(5),
@IDModuloWMS              int,
@RenglonWMS               float,
@RenglonSubWMS   int,
@CantidadTarimaTotal  float,
@CantidadTarimaSub  float,
@CantidadTotal   float,
@Procesado    bit,
@Referencia    varchar(50),
@Unidad     varchar(50), 
@CantidadUnidad   float, 
@SucursalDestino			int,
@SucursalDestinoAnt		int,
@Pasillo					varchar(20),
@PasilloAnt				varchar(20),
@TarimasReacomodar		int,
@Reacomodar				int,
@TarimaN					varchar(20),
@ModuloAux				varchar(5),
@IDAux					int,
@RenglonID                int,
@SerieLote                varchar(50),
@Origen					varchar(20),
@OrigenID					varchar(20),
@WMSReacomodoSurtido		bit,
@ModuloAuxAnt				varchar(5),
@IDAuxAnt					int,
@TarimaAnt				varchar(20),
@IDTarima					int,
@IDTarimaAnt				int,
@OrigenObservaciones		varchar(100),
@ArticuloAux        varchar(20),
@SubCuentaAux       varchar(50),
@SubCuentaWMS       varchar(50),
@TarimaFechaCaducidad datetime, 
@TarimaFechaCaducidadAux datetime, 
@SubCuentaAct       varchar(20),
@SubCuentaAnt       varchar(20),
@ArtTipoOpcion      varchar(20),
@ArticuloTipo      varchar(20), 
@ArtSerieLoteInfo  bit, 
@PCKUbicacion      int, 
@CantidadSerieLote float,
@Propiedades       varchar(20),
@ArtCambioClave    varchar(50)
BEGIN TRAN HMp
DECLARE @TarimaDisp TABLE(
Tarima varchar(20))
CREATE TABLE #WMSVentaDR (
ID      int          NOT NULL,
Renglon    float      NOT NULL,
RenglonSub   int    NOT NULL DEFAULT 0,
RenglonID   int     NULL,
RenglonTipo   char(1)    NULL DEFAULT 'N',
Cantidad            float         NULL,
Almacen    varchar(10) COLLATE Database_Default NULL,
EnviarA    int        NULL,
Codigo    varchar(30) COLLATE Database_Default NULL,
Articulo   varchar(20) COLLATE Database_Default NOT NULL,
SubCuenta   varchar(50) COLLATE Database_Default NULL,
Precio           float         NULL,
PrecioSugerido      float         NULL,
DescuentoTipo  char(1)       NULL DEFAULT '%',
DescuentoLinea  money    NULL,
DescuentoImporte money    NULL,
Impuesto1   float    NULL,
Impuesto2   float    NULL,
Impuesto3   float    NULL,
DescripcionExtra varchar(100) COLLATE Database_Default NULL,
Costo    money    NULL,
CostoActividad  money    NULL,
Paquete    int     NULL,
ContUso    varchar(20) COLLATE Database_Default NULL,
Aplica    varchar(20) COLLATE Database_Default NULL,
AplicaID   varchar(20) COLLATE Database_Default NULL,
CantidadPendiente float       NULL,
CantidadReservada float       NULL,
CantidadCancelada float    NULL,
CantidadOrdenada float    NULL,
CantidadA   float       NULL,
Unidad    varchar(50) COLLATE Database_Default NULL,
Factor    float       NULL DEFAULT 1.0,
CantidadInventario  float        NULL,
SustitutoArticulo   varchar(20) COLLATE Database_Default NULL,
SustitutoSubCuenta varchar(50) COLLATE Database_Default NULL,
FechaRequerida  datetime   NULL,
HoraRequerida  varchar(5) COLLATE Database_Default NULL,
Instruccion   varchar(50) COLLATE Database_Default NULL,
UltimoReservadoCantidad float   NULL,
UltimoReservadoFecha datetime  NULL,
Agente     varchar(10) COLLATE Database_Default NULL,
Departamento  int     NULL,
Sucursal   int    NOT NULL DEFAULT 0,
SucursalOrigen  int     NULL DEFAULT 0,
AutoLocalidad  varchar(5) COLLATE Database_Default NULL,
UEN     int     NULL,
Espacio    varchar(10) COLLATE Database_Default NULL,
CantidadAlterna  float    NULL,
PoliticaPrecios  varchar(255) COLLATE Database_Default NULL,
PrecioMoneda  varchar(10) COLLATE Database_Default NULL,
PrecioTipoCambio float    NULL,
AFArticulo   varchar(20) COLLATE Database_Default NULL,
AFSerie    varchar(20) COLLATE Database_Default NULL,
ExcluirPlaneacion bit     NULL DEFAULT 0,
Anexo    bit     NULL DEFAULT 0,
Estado    varchar(30) COLLATE Database_Default NULL,
ExcluirISAN   bit     NULL DEFAULT 0,
Posicion   varchar(10) COLLATE Database_Default NULL,
PresupuestoEsp  bit     NULL DEFAULT 0,
Tarima    varchar(20) COLLATE Database_Default NULL,
)
CREATE TABLE #WMSInvDR (
ID      int        NOT NULL,
Renglon    float    NOT NULL,
RenglonSub   int   NOT NULL DEFAULT 0,
RenglonID   int    NULL,
RenglonTipo   char(1)         NULL DEFAULT 'N',
Cantidad   float       NULL,
Almacen    varchar(10) COLLATE Database_Default NULL,
Codigo    varchar(30) COLLATE Database_Default NULL,
Articulo   varchar(20) COLLATE Database_Default NOT NULL,
SubCuenta   varchar(50) COLLATE Database_Default NULL,
ArticuloDestino  varchar(20) COLLATE Database_Default NULL,
SubCuentaDestino varchar(50) COLLATE Database_Default NULL,
Costo               money       NULL,
CostoInv   money       NULL,
ContUso    varchar(20) COLLATE Database_Default NULL,
Espacio    varchar(10) COLLATE Database_Default NULL,
CantidadReservada float      NULL,
CantidadCancelada float   NULL,
CantidadOrdenada float   NULL,
CantidadPendiente float       NULL,
CantidadA   float       NULL,
Paquete    int    NULL,
FechaRequerida  datetime  NULL,
Aplica            varchar(20) COLLATE Database_Default NULL,
AplicaID         varchar(20) COLLATE Database_Default NULL,
DestinoTipo   varchar(10) COLLATE Database_Default NULL,
Destino    varchar(20) COLLATE Database_Default NULL,
DestinoID   varchar(20) COLLATE Database_Default NULL,
Cliente    varchar(10) COLLATE Database_Default NULL,
Unidad    varchar(50) COLLATE Database_Default NULL,
Factor    float      NULL DEFAULT 1.0,
CantidadInventario  float       NULL,
UltimoReservadoCantidad float  NULL,
UltimoReservadoFecha datetime NULL,
ProdSerieLote  varchar(50) COLLATE Database_Default NULL,
Merma             float       NULL,
Desperdicio         float       NULL,
Producto   varchar(20) COLLATE Database_Default NULL,
SubProducto   varchar(20) COLLATE Database_Default NULL,
Tipo    varchar(20) COLLATE Database_Default NULL,
Sucursal   int   NOT NULL DEFAULT 0,
SucursalOrigen  int    NULL DEFAULT 0,
Precio    money   NULL,
DescripcionExtra varchar(100) COLLATE Database_Default NULL,
Posicion   varchar(10) COLLATE Database_Default NULL,
ExistenciaAntes       float NULL,
TieneOferta           varchar(2) NULL,
Tarima    varchar(20) COLLATE Database_Default NULL,
Seccion    smallint  NULL,
ASFactor      float       NULL,
ASProveedor       varchar(10) NULL,
FechaCaducidad  datetime  NULL
)
CREATE TABLE #WMSComsDR (
ID       int         NOT NULL,
Renglon     float     NOT NULL,
RenglonSub    int   NOT NULL DEFAULT 0,
RenglonID    int    NULL,
RenglonTipo    char(1)     COLLATE Database_Default NULL,
Cantidad    float        NULL,
Almacen     varchar(10) COLLATE Database_Default NULL,
Codigo     varchar(30) COLLATE Database_Default NULL,
Articulo    varchar(20) COLLATE Database_Default NULL,
SubCuenta    varchar(50) COLLATE Database_Default NULL,
FechaRequerida   datetime     NULL,
FechaOrdenar   datetime     NULL,
FechaEntrega   datetime     NULL,
Costo             float        NULL,
Impuesto1    float   NULL,
Impuesto2    float   NULL,
Impuesto3    float   NULL,
Retencion1    float   NULL,
Retencion2    float   NULL,
Retencion3    float   NULL,
Descuento    varchar(30) COLLATE Database_Default NULL,
DescuentoTipo   char(1)     COLLATE Database_Default NULL,
DescuentoLinea   money   NULL,
DescuentoImporte  money   NULL,
DescripcionExtra  varchar(100)COLLATE Database_Default NULL,
ReferenciaExtra   varchar(50) COLLATE Database_Default NULL,
ContUso     varchar(20) COLLATE Database_Default NULL,
DestinoTipo    varchar(10) COLLATE Database_Default NULL,
Destino     varchar(20) COLLATE Database_Default NULL,
DestinoID    varchar(20) COLLATE Database_Default NULL,
Aplica     varchar(20) COLLATE Database_Default NULL,
AplicaID    varchar(20) COLLATE Database_Default NULL,
CantidadPendiente  float      NULL,
CantidadCancelada  float   NULL,
CantidadA    float      NULL,
CostoInv    float   NULL,
Unidad     varchar(50) COLLATE Database_Default NULL,
Factor     float      NULL DEFAULT 1.0,
CantidadInventario  float       NULL,
Cliente     varchar(10) COLLATE Database_Default NULL,
ServicioArticulo  varchar(20) COLLATE Database_Default NULL,
ServicioSerie   varchar(20) COLLATE Database_Default NULL,
Paquete     int    NULL,
Sucursal    int   NOT NULL DEFAULT 0,
SucursalOrigen   int   NOT NULL DEFAULT 0,
ImportacionProveedor varchar(10) COLLATE Database_Default NULL,
ImportacionReferencia varchar(50) COLLATE Database_Default NULL,
ProveedorRef   varchar(10) COLLATE Database_Default NULL,
AgenteRef    varchar(10) COLLATE Database_Default NULL,
FechaCaducidad   datetime  NULL,
Posicion    varchar(10) COLLATE Database_Default NULL,
Pais     varchar(50) COLLATE Database_Default NULL,
TratadoComercial  varchar(50) COLLATE Database_Default NULL,
ProgramaSectorial  varchar(50) COLLATE Database_Default NULL,
ValorAduana    money  NULL,
ImportacionImpuesto1 float  NULL,
ImportacionImpuesto2 float  NULL,
ID1      char(2)  COLLATE Database_Default NULL,
ID2      char(2)  COLLATE Database_Default NULL,
FormaPago    varchar(50) COLLATE Database_Default NULL,
ASDescuentoCascada      float,
ASDescuentoLinea        float,
ASCantidadConCargo      float,
ASCantidadSinCargo      float,
ASDescuentoLinea2       float,
ASTipoCosto             varchar(10),
EsEstadistica           bit,
Sugerido                bit,
PresupuestoEsp          bit,
ASSugerido              bit,
UEN                     int,
Departamento            varchar(50),
Familia                 varchar(50),
SubFamilia              varchar(50),
ASCantidadSugerida      float,
ContUso2                varchar(20),
ContUso3                varchar(20),
Tarima                  varchar(20),
ExistenciaEsperada      float,
ASFactor                float
)
DECLARE @WMSSurtidoCD TABLE
(
Modulo			varchar(5)	NULL,
ModuloID		int			NULL,
Articulo		varchar(20) NULL,
Almacen         varchar(20) NULL
)
DECLARE @WMSSurtidoProcesarD TABLE  (
Modulo			varchar(5)	COLLATE Database_Default NOT NULL,
ModuloID		int			NOT NULL,
Articulo		varchar(20) COLLATE Database_Default NULL,
Almacen         varchar(20) COLLATE Database_Default NULL,
Pasillo         varchar(20) COLLATE Database_Default NULL,   
CantidadTarima  float		NULL,
SubCuenta       varchar(50) COLLATE Database_Default NULL, 
SerieLote       varchar(50) COLLATE Database_Default NULL,
PCKUbicacion    int 
)
DECLARE @WMSSurtidoProcesarDTotal TABLE  (
Modulo			varchar(5)	COLLATE Database_Default NOT NULL,
ModuloID		int			NOT NULL,
Articulo        varchar(20) COLLATE Database_Default NULL,
Almacen         varchar(20) COLLATE Database_Default NULL,
CantidadTarima  float NULL,
SubCuenta       varchar(50) COLLATE Database_Default NULL, 
SerieLote       varchar(50) COLLATE Database_Default NULL
)
SELECT TOP 1 @Empresa = v.Empresa,
@Sucursal = v.Sucursal,
@FechaEmision = dbo.fnFechaSinHora(GETDATE()),
@Estatus = 'SINAFECTAR'
FROM WMSLista w JOIN Venta v ON v.ID = w.IDModulo AND w.Modulo = 'VTAS'
WHERE w.Estacion=@Estacion
SELECT TOP 1 @Empresa = v.Empresa,
@Sucursal = v.Sucursal,
@FechaEmision = dbo.fnFechaSinHora(GETDATE())
FROM WMSLista w JOIN Compra v ON v.ID = w.IDModulo AND w.Modulo = 'COMS'
WHERE w.Estacion=@Estacion
SELECT TOP 1 @Empresa = v.Empresa,
@Sucursal = v.Sucursal,
@FechaEmision = dbo.fnFechaSinHora(GETDATE())
FROM WMSLista w JOIN Inv v ON v.ID = w.IDModulo AND w.Modulo = 'INV'
WHERE w.Estacion=@Estacion
SELECT @WMSReacomodoSurtido = ISNULL(WMSReacomodoSurtido, 0) FROM EmpresaCfg WHERE Empresa = @Empresa
DELETE WMSSurtidoProcesarD WHERE Procesado = 1 AND Estacion = @Estacion
SELECT @ArticuloTipo=Tipo, @ArtSerieLoteInfo=SerieLoteInfo FROM Art WHERE Articulo  = @Articulo 
IF @WMSReacomodoSurtido = 1
BEGIN
DECLARE crDisponible CURSOR LOCAL STATIC FOR
SELECT Articulo, Almacen, Tipo, /*SUM(CantidadTarima)*/ 0 Cantidad, Unidad, CantidadUnidad, Articulo, SubCuenta, 
TarimaFechaCaducidad 
FROM WMSSurtidoProcesarD
WHERE Estacion = @Estacion AND Procesado = 0
AND Articulo IN(SELECT DISTINCT Clave FROM ListaSt WHERE Estacion = @Estacion)
AND Tipo = 'Domicilio'
AND (PosicionDestino IS NOT NULL AND PosicionDestino <> '' ) 
AND NULLIF(SubCuenta,'') IS NULL 
GROUP BY Articulo, Almacen, Tipo, Unidad, CantidadUnidad, Articulo, SubCuenta, TarimaFechaCaducidad 
OPEN crDisponible
FETCH NEXT FROM crDisponible INTO @Articulo, @Almacen, @Tipo, @CantidadTarima, @Unidad, @CantidadUnidad, @ArticuloAux, @SubCuentaAux, @TarimaFechaCaducidad 
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Ordenes = 0
UPDATE WMSSurtidoProcesarD SET Procesado = 1 WHERE Estacion = @Estacion AND Articulo = @Articulo AND Procesado = 0 AND (PosicionDestino IS NOT NULL AND   PosicionDestino <> '') AND Tipo <> 'Cross Docking'
DECLARE crMinimo CURSOR LOCAL FOR
SELECT SUM(d.Disponible) Disponible, a.MinimoTarima, SUM(d.Disponible) - @CantidadTarima - @Ordenes Resultado
FROM ArtDisponibleTarima d
JOIN Tarima t ON d.Tarima = t.Tarima
JOIN AlmPos p ON t.Almacen = p.Almacen AND p.Posicion = t.Posicion AND p.ArticuloEsp = d.Articulo
JOIN Art a ON d.Articulo = a.Articulo
WHERE p.Tipo = @Tipo
AND d.Articulo = @Articulo
AND t.Estatus = 'ALTA'
AND p.Estatus = 'ALTA'
GROUP BY d.Articulo, a.MinimoTarima
OPEN crMinimo
FETCH NEXT FROM crMinimo INTO @Disponible, @MinimoTarima, @Resultado
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Contador = 0
IF @Resultado < @MinimoTarima
BEGIN
SELECT @Tarima = NULL, @DisponibleTarima = NULL, @PosicionOrigen = NULL
SELECT @ControlArticulo = ControlArticulo FROM Art WHERE Articulo = @Articulo
SELECT TOP 1 @PosicionDestino = Posicion FROM AlmPos WHERE ArticuloEsp = @Articulo AND Tipo = @Tipo AND Almacen = @Almacen
IF @Contador = 0
SELECT @Resultado = @Resultado + ISNULL(SUM(ISNULL(a.Disponible,0)),0)
FROM TMA t
JOIN TMAD d on t.id = d.id
JOIN ArtDisponibleTarima a ON d.Tarima = a.Tarima AND a.Articulo = @Articulo AND a.Almacen = @Almacen
JOIN MovTipo m ON m.Mov = t.Mov AND m.Modulo = 'TMA'
WHERE m.Clave = 'TMA.SRADO'
AND t.Estatus = 'PENDIENTE'
AND d.PosicionDestino = @PosicionDestino
AND a.Empresa = @Empresa
IF @Resultado < @MinimoTarima
BEGIN
SELECT @Mov = TMASolicitudReacomodo FROM EmpresaCfgMovWMS WHERE Empresa = @Empresa
SELECT @TarimasReacomodar = ISNULL(TarimasReacomodar,0) FROM Art WHERE Articulo = @Articulo
IF ISNULL(@TarimasReacomodar,0) = 0
SET @TarimasReacomodar = 1
INSERT TMA (Empresa, Sucursal,   Usuario,  Mov,  FechaEmision,  Estatus,       Almacen,  TarimaSurtido,  Prioridad, Referencia)
VALUES     (@Empresa, @Sucursal, @Usuario, @Mov, @FechaEmision, 'SINAFECTAR', @Almacen, @TarimaSurtido, 'Media',  'Herramienta de Surtido')
SET @IDDestino = @@IDENTITY
SET @Renglon = 2048
SET @Reacomodar = 1
IF @Reacomodar <= @TarimasReacomodar 
BEGIN
SELECT TOP 1
@Tarima		   = A.Tarima,
@Disponible	   = A.Disponible - ISNULL(D.Apartado,0),
@PosicionOrigen = B.Posicion
FROM ArtDisponibleTarima A
JOIN Tarima B ON A.Tarima = B.Tarima
JOIN AlmPos C ON B.Almacen = C.Almacen AND ISNULL(B.Posicion,C.Posicion) = C.Posicion AND C.Tipo <> 'Surtido'
LEFT JOIN ArtApartadoTarima D ON A.Empresa = D.Empresa AND A.Articulo = D.Articulo AND A.Almacen = D.Almacen AND A.Tarima = D.Tarima
WHERE A.Articulo = @Articulo
AND A.Tarima NOT IN (SELECT Tarima
FROM WMSSurtidoProcesarD
WHERE Estacion = @Estacion
AND Procesado = 1
AND Articulo IN (SELECT DISTINCT Clave FROM ListaSt WHERE Estacion = @Estacion)
AND (PosicionDestino IS NOT NULL AND PosicionDestino <> '')
AND NULLIF(SubCuenta,'') IS NULL
AND Tarima NOT IN (SELECT Tarima FROM @TarimaDisp)
)
AND C.Tipo = 'Ubicacion'
AND A.Almacen = @Almacen
AND A.Disponible - ISNULL(D.Apartado,0) > 0
AND B.Estatus = 'ALTA'
AND A.Empresa = @Empresa
ORDER BY B.FechaCaducidad, CASE @ControlArticulo
WHEN 'Caducidad'		THEN CONVERT(varchar, B.FechaCaducidad)
WHEN 'Fecha Entrada'	THEN CONVERT(varchar, B.Alta)
ELSE B.Posicion
END, A.Tarima ASC
INSERT @TarimaDisp (Tarima) VALUES (@Tarima)
IF @Tarima IS NOT NULL AND @Ok IS NULL
BEGIN
INSERT TMAD (ID,         Sucursal,  Renglon,  Tarima,                   Almacen,  Posicion,        PosicionDestino,  CantidadPicking, Prioridad, EstaPendiente, Procesado, Unidad,  CantidadUnidad, Articulo, SubCuenta, FechaCaducidad) 
SELECT       @IDDestino, @Sucursal, @Renglon, @Tarima, @Almacen, @PosicionOrigen, @PosicionDestino, @Disponible,     'Media',   1,             0,         @Unidad, @Disponible, @ArticuloAux, @SubCuentaAux, @TarimaFechaCaducidad 
SET @Renglon = @Renglon +2048
END
SET @Reacomodar = ISNULL(@Reacomodar,0) + 1
END
IF @Ok IS NULL AND @IDDestino IS NOT NULL AND EXISTS (SELECT * FROM TMAD WHERE ID = @IDDestino) AND @Tarima IS NOT NULL
BEGIN
EXEC spAfectar 'TMA', @IDDestino, 'Afectar', @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @MovDestino = Mov, @MovDestinoID = MovID FROM TMA WHERE ID = @IDDestino
EXEC spMovFlujo @Sucursal, Afectar, @Empresa, 'TMA', @ID, @Mov, @MovID, 'TMA', @IDDestino, @MovDestino, @MovDestinoID, @Ok OUTPUT
END
ELSE
DELETE TMA WHERE ID = @IDDestino
SELECT @Resultado = @Resultado + ISNULL(@DisponibleTarima,0)
SELECT @Contador = 1
END
IF @Tarima IS NULL
SELECT @Resultado = @MinimoTarima
END
FETCH NEXT FROM crMinimo INTO @Disponible, @MinimoTarima, @Resultado
END
CLOSE crMinimo
DEALLOCATE crMinimo
FETCH NEXT FROM crDisponible INTO @Articulo, @Almacen, @Tipo, @CantidadTarima, @Unidad, @CantidadUnidad, @ArticuloAux, @SubCuentaAux, @TarimaFechaCaducidad 
END
CLOSE crDisponible
DEALLOCATE crDisponible
END
SELECT @ModuloAuxAnt = ''
WHILE(1=1)
BEGIN
SELECT @ModuloAux = MIN(Modulo)
FROM WMSSurtidoProcesarD
WHERE Estacion = @Estacion
AND Modulo > @ModuloAuxAnt
AND NULLIF(RTRIM(TarimaSurtido), '') IS NULL
IF @ModuloAux IS NULL BREAK
SELECT @ModuloAuxAnt = @ModuloAux
SELECT @IDAuxAnt = 0
WHILE(1=1)
BEGIN
SELECT @IDAux = MIN(ModuloID)
FROM WMSSurtidoProcesarD
WHERE NULLIF(RTRIM(TarimaSurtido), '') IS NULL
AND Estacion = @Estacion
AND Modulo = @ModuloAux
AND ModuloID > @IDAuxAnt
IF @IDAux IS NULL BREAK
SELECT @IDAuxAnt = @IDAux
SELECT @TarimaSurtido = NULL
EXEC spConsecutivo 'Tarima', @Sucursal, @TarimaSurtido OUTPUT
EXEC spTarimaAlta @Empresa, @Sucursal, @Usuario, @Almacen, @FechaEmision, @FechaEmision, @TarimaSurtido, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
UPDATE WMSSurtidoProcesarD
SET TarimaSurtido = @TarimaSurtido
WHERE /*Estacion = @Estacion
AND */Modulo = @ModuloAux
AND ModuloID = @IDAux
END
END
SELECT @TarimaSurtido = NULL
SELECT @Procesado = 0
UPDATE WMSSurtidoProcesarD SET Procesado = 1 WHERE Estacion = @Estacion AND Articulo IN(SELECT DISTINCT Clave FROM ListaSt WHERE Estacion = @Estacion) AND Procesado = 0 AND Tipo <> 'Cross Docking'
AND (PosicionDestino IS NOT NULL AND PosicionDestino <> '') 
DELETE @WMSSurtidoProcesarD
INSERT @WMSSurtidoProcesarD
SELECT wp.Modulo, wp.ModuloID, Articulo, wp.Almacen,'',SUM(wp.CantidadTarima), wp.SubCuenta, wp.SerieLote, ISNULL(wp.PCKUbicacion,0) 
FROM WMSSurtidoProcesarD wp
WHERE wp.Estacion = @Estacion AND wp.Procesado = 1 AND wp.Tipo = 'Ubicacion' AND Articulo IN(SELECT DISTINCT Clave FROM ListaSt WHERE Estacion = @Estacion)
AND (wp.PosicionDestino IS NOT NULL AND wp.PosicionDestino <> '') 
GROUP BY Modulo, ModuloID, Articulo,wp.Almacen, SubCuenta, wp.SerieLote, wp.PCKUbicacion 
DELETE @WMSSurtidoProcesarDTotal
INSERT @WMSSurtidoProcesarDTotal
SELECT Modulo, ModuloID, Articulo, wp.Almacen,SUM(wp.CantidadTarima), wp.SubCuenta, wp.SerieLote 
FROM WMSSurtidoProcesarD wp
WHERE wp.Estacion = @Estacion AND wp.Procesado = 1 AND Articulo IN(SELECT DISTINCT Clave FROM ListaSt WHERE Estacion = @Estacion)
AND (wp.PosicionDestino IS NOT NULL AND wp.PosicionDestino <> '') 
AND wp.Tipo = 'Ubicacion'
GROUP BY Modulo, ModuloID, Articulo,wp.Almacen, SubCuenta, wp.SerieLote 
SELECT @CantidadTarima = NULL, @CantidadWMS = NULL, @CantidadTarimaTotal = NULL, @CantidadTarimaSub = NULL
DECLARE crUbicacion CURSOR LOCAL STATIC FOR
SELECT wp.Modulo, wp.ModuloID,
@Empresa, @Sucursal,
@Usuario, dbo.fnFechaSinHora(GETDATE()), 'SINAFECTAR',
wp.Almacen,
wp.Acomodador, wp.Zona, 'Herramienta',
wp.PosicionOrigen, wp.PosicionDestino, wp.CantidadTarima, wP.Tarima, wp.Referencia, wp.Unidad, wp.CantidadUnidad, 
wp.SucursalFiltro,
wp.TarimaSurtido,
wp.Articulo, 
wp.SubCuenta, 
WP.TarimaFechaCaducidad, 
WP.PCKUbicacion,
WP.SerieLote 
FROM WMSSurtidoProcesarD wp inner join almpos ap on wp.Almacen = ap.Almacen AND wp. PosicionOrigen = ap.Posicion
WHERE wp.Estacion = @Estacion AND wp.Procesado = 1 AND wp.Tipo = 'Ubicacion' AND Articulo IN(SELECT DISTINCT Clave FROM ListaSt WHERE Estacion = @Estacion)
AND (wp.PosicionDestino IS NOT NULL AND wp.PosicionDestino <> '') 
OPEN crUbicacion
FETCH NEXT FROM crUbicacion INTO @ModuloAux, @IDAux, @Empresa, @Sucursal, @Usuario, @FechaEmision, @Estatus, @Almacen, @Agente, @Zona, @Observaciones, @PosicionOrigen, @PosicionDestino, @CantidadTarima, @Tarima, @Referencia, @Unidad, @CantidadUnidad, @SucursalDestino, @TarimaSurtido, @ArticuloAux, @SubCuentaAux, @TarimaFechaCaducidadAux, @PCKUbicacion, @SerieLote 
WHILE @@FETCH_STATUS = 0
BEGIN
IF @PCKUbicacion=1
SELECT TOP 1 @Mov = Mov FROM MovTipo WHERE Clave = 'TMA.OPCKTarima' AND Modulo = 'TMA'
ELSE
SELECT TOP 1 @Mov = Mov FROM MovTipo WHERE Clave = 'TMA.OSUR' AND Modulo = 'TMA'
EXEC spMovInfo  @IDAux, @ModuloAux, @Mov = @Origen OUTPUT, @MovID = @OrigenID OUTPUT, @Observaciones = @OrigenObservaciones OUTPUT
IF @ModuloAux = 'VTAS'
SELECT @ArtCambioClave = VD.ArtCambioClave
FROM VentaD VD
JOIN Venta V ON VD.ID = V.ID
WHERE V.Mov = @Origen
AND V.MovId = @OrigenID
AND VD.Articulo = @ArticuloAux
AND v.ID = @IDAux
INSERT TMA (Empresa, Sucursal, Usuario, Mov, FechaEmision, Estatus, Almacen, Agente, Zona, Observaciones, TarimaSurtido, Prioridad, Referencia, SucursalFiltro, OrigenTipo, Origen, OrigenID, OrigenObservaciones)
VALUES     (@Empresa, @Sucursal, @Usuario, @Mov, @FechaEmision, @Estatus, @Almacen, @Agente, @Zona, @Observaciones, @TarimaSurtido, 'Normal', @Referencia, @SucursalDestino, @ModuloAux, @Origen, @OrigenID, @OrigenObservaciones)
SET @ID = @@IDENTITY
UPDATE Tarima SET Posicion = @PosicionOrigen WHERE Tarima = @Tarima
INSERT TMAD (ID, Sucursal, Renglon, Tarima, Almacen, Posicion, PosicionDestino, CantidadPicking, Zona, Prioridad, Montacarga, EstaPendiente, Procesado, Unidad,  CantidadUnidad, Articulo, SubCuenta, FechaCaducidad, ArtCambioClave) 
VALUES      (@ID, @Sucursal, 2048, @Tarima, @Almacen, @PosicionOrigen, @PosicionDestino, @CantidadTarima, @Zona, 'Normal', @Agente, 1,  0,         @Unidad, @CantidadUnidad, @ArticuloAux, @SubCuentaAux, @TarimaFechaCaducidadAux, @ArtCambioClave) 
DECLARE crSerieLote CURSOR LOCAL STATIC FOR
SELECT SUM(slm.Cantidad),
MAX(slm.Propiedades),
slm.SerieLote
FROM SerieLoteMov slm
WHERE slm.ID = @IDAux
AND slm.Modulo = @ModuloAux
AND slm.Articulo = @ArticuloAux
AND ISNULL(slm.SubCuenta,'') = ISNULL(@SubCuentaAux,'')
AND slm.SerieLote = @SerieLote
AND slm.Tarima = @Tarima
GROUP BY slm.SerieLote
OPEN crSerieLote
FETCH NEXT FROM crSerieLote INTO @CantidadSerieLote, @Propiedades, @SerieLote
WHILE @@FETCH_STATUS = 0
BEGIN
IF @CantidadSerieLote > @CantidadTarima
SET @CantidadSerieLote = @CantidadTarima
INSERT SerieLoteMov
(Empresa,  Sucursal,  Modulo,  ID,  RenglonID,  Articulo,  SubCuenta, SerieLote, Cantidad, Propiedades, Tarima, AsignacionUbicacion)
VALUES (@Empresa, @Sucursal, 'TMA', @ID, 2048, @ArticuloAux, ISNULL(@SubCuentaAux,''), @SerieLote, @CantidadSerieLote, @Propiedades, @Tarima, 0)
FETCH NEXT FROM crSerieLote INTO @CantidadSerieLote, @Propiedades, @SerieLote
END
CLOSE crSerieLote
DEALLOCATE crSerieLote
IF @OK IS NULL
EXEC spAfectar 'TMA', @ID, 'AFECTAR', @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @OK IS NULL
BEGIN
SELECT @MovDestino = Mov, @MovDestinoID = MovID FROM TMA WHERE ID = @ID
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @ModuloAux, @IDAux, @Origen, @OrigenID, 'TMA', @ID, @MovDestino, @MovDestinoID, @Ok OUTPUT
END
FETCH NEXT FROM crUbicacion INTO @ModuloAux, @IDAux, @Empresa, @Sucursal, @Usuario, @FechaEmision, @Estatus, @Almacen, @Agente, @Zona, @Observaciones, @PosicionOrigen, @PosicionDestino, @CantidadTarima, @Tarima, @Referencia, @Unidad, @CantidadUnidad, @SucursalDestino, @TarimaSurtido, @ArticuloAux, @SubCuentaAux, @TarimaFechaCaducidadAux, @PCKUbicacion, @SerieLote 
END
CLOSE crUbicacion
DEALLOCATE crUbicacion
SELECT @Procesado = 0
DELETE @WMSSurtidoProcesarD
INSERT @WMSSurtidoProcesarD
SELECT wp.Modulo, wp.ModuloID, Articulo, wp.Almacen, ap.Pasillo, SUM(wp.CantidadTarima), wp.SubCuenta, wp.SerieLote, wp.PCKUbicacion 
FROM WMSSurtidoProcesarD wp  inner join almpos ap on wp.Almacen = ap.Almacen AND wp. PosicionOrigen = ap.Posicion
WHERE wp.Estacion = @Estacion AND wp.Procesado = 1 AND wp.Tipo = 'Domicilio' AND Articulo IN(SELECT DISTINCT Clave FROM ListaSt WHERE Estacion = @Estacion)
AND (wp.PosicionDestino IS NOT NULL AND wp.PosicionDestino <> '') 
GROUP BY Modulo, ModuloID, Articulo,wp.Almacen, ap.Pasillo, wp.SubCuenta, wp.SerieLote, wp.PCKUbicacion 
SELECT @CantidadTarima = NULL, @CantidadWMS = NULL, @CantidadTarimaTotal = NULL, @CantidadTarimaSub = NULL
IF (OBJECT_ID('Tempdb..#WMSSurtidoProcesarD')) IS NOT NULL
DROP TABLE #WMSSurtidoProcesarD
IF (OBJECT_ID('Tempdb..#WMSSurtidoProcesarDModulo')) IS NOT NULL
DROP TABLE #WMSSurtidoProcesarDModulo
SELECT wp.*, 1 Pasillo 
INTO #WMSSurtidoProcesarD
FROM WMSSurtidoProcesarD wp
JOIN Almpos ap on wp.Almacen = ap.Almacen AND wp. PosicionOrigen = ap.Posicion
WHERE wp.Estacion = @Estacion
AND wp.Procesado = 1
AND wp.Tipo = 'Domicilio'
AND Articulo IN(SELECT DISTINCT Clave FROM ListaSt WHERE Estacion = @Estacion)
AND (wp.PosicionDestino IS NOT NULL AND wp.PosicionDestino <> '') 
CREATE INDEX Ciclo ON #WMSSurtidoProcesarD(SucursalFiltro, Pasillo, Modulo, ModuloID, Tarima)
SELECT DISTINCT SucursalFiltro, Pasillo, Modulo, ModuloID INTO #WMSSurtidoProcesarDModulo FROM #WMSSurtidoProcesarD
CREATE INDEX CicloModulo ON #WMSSurtidoProcesarDModulo(SucursalFiltro, Pasillo, Modulo, ModuloID)
SELECT @SucursalDestinoAnt = -1 
WHILE(1=1)
BEGIN
SELECT @SucursalDestino = MIN(SucursalFiltro)
FROM #WMSSurtidoProcesarD wp
WHERE wp.SucursalFiltro > @SucursalDestinoAnt
IF @SucursalDestino IS NULL BREAK
SELECT @SucursalDestinoAnt = @SucursalDestino
SELECT @PasilloAnt = ''
WHILE(1=1)
BEGIN
SELECT @Pasillo = MIN(Pasillo)
FROM #WMSSurtidoProcesarD wp
WHERE wp.SucursalFiltro = @SucursalDestino
AND Pasillo > @PasilloAnt
IF @Pasillo IS NULL BREAK
SELECT @PasilloAnt = @Pasillo
SELECT @ModuloAuxAnt = ''
WHILE(1=1)
BEGIN
SELECT @ModuloAux = MIN(wp.Modulo)
FROM #WMSSurtidoProcesarD wp
WHERE wp.SucursalFiltro = @SucursalDestino
AND wp.Pasillo = @Pasillo
AND wp.Modulo > @ModuloAuxAnt
IF @ModuloAux IS NULL BREAK
SELECT @ModuloAuxAnt = @ModuloAux
SELECT @IDAuxAnt = 0
WHILE(1=1)
BEGIN
SELECT @IDAux = MIN(wp.ModuloID)
FROM #WMSSurtidoProcesarDModulo wp
WHERE wp.SucursalFiltro = @SucursalDestino
AND wp.Pasillo = @Pasillo
AND wp.Modulo = @ModuloAux
AND wp.ModuloID > @IDAuxAnt
IF @IDAux IS NULL BREAK
SELECT @IDAuxAnt = @IDAux
SELECT @TarimaSurtido = NULL
SELECT @TarimaSurtido = TarimaSurtido
FROM WMSSurtidoProcesarD
WHERE Modulo = @ModuloAux
AND ModuloID = @IDAux
SELECT @Agente = wp.Acomodador,
@PosicionDestino = wp.PosicionDestino,
@Almacen = wp.Almacen,
@Referencia = wp.Referencia
FROM #WMSSurtidoProcesarD wp
WHERE wp.SucursalFiltro = @SucursalDestino
AND wp.Pasillo = @Pasillo
AND wp.Modulo = @ModuloAux
AND wp.ModuloID = @IDAux
EXEC spMovInfo  @IDAux, @ModuloAux, @Mov = @Origen OUTPUT, @MovID = @OrigenID OUTPUT, @Observaciones = @OrigenObservaciones OUTPUT
SELECT DISTINCT @Zona =  wp.Zona
FROM #WMSSurtidoProcesarD wp
WHERE wp.Estacion = @Estacion AND wp.Procesado = 1 AND wp.Tipo = 'Domicilio' AND wp.Acomodador = @Agente AND wp.PosicionDestino = @PosicionDestino
AND Articulo IN(SELECT DISTINCT Clave FROM ListaSt WHERE Estacion = @Estacion)
AND (wp.PosicionDestino IS NOT NULL AND wp.PosicionDestino <> '') 
SELECT TOP 1 @Mov = Mov FROM MovTipo WHERE Clave = 'TMA.OSUR' AND SubClave = 'TMA.OSURP' AND Modulo = 'TMA'
SELECT @Observaciones =  'Herramienta',
@Estatus = 'SINAFECTAR',
@FechaEmision =  dbo.fnFechaSinHora(GETDATE())
INSERT TMA (Empresa, Sucursal, Usuario, Mov, FechaEmision, Estatus, Almacen, Agente, Zona, Observaciones, TarimaSurtido, Prioridad, Referencia, SucursalFiltro, OrigenTipo, Origen, OrigenID, OrigenObservaciones)
VALUES     (@Empresa, @Sucursal, @Usuario, @Mov, @FechaEmision, @Estatus, @Almacen, @Agente, @Zona, @Observaciones, @TarimaSurtido, 'Normal', @Referencia, @SucursalDestino, @ModuloAux, @Origen, @OrigenID, @OrigenObservaciones)
SET @ID = @@IDENTITY
SET @Renglon = 2048
SELECT @TarimaAnt = ''
WHILE(1=1)
BEGIN
SELECT @Tarima = MIN(wp.Tarima)
FROM #WMSSurtidoProcesarD wp
WHERE wp.SucursalFiltro = @SucursalDestino
AND wp.Pasillo = @Pasillo
AND wp.Modulo = @ModuloAux
AND wp.ModuloID = @IDAux
AND wp.Tarima > @TarimaAnt
IF @Tarima IS NULL BREAK
SELECT @TarimaAnt = @Tarima
SELECT @ArtTipoOpcion = a.TipoOpcion
FROM #WMSSurtidoProcesarD wp
JOIN Art a ON a.Articulo=wp.Articulo
WHERE wp.SucursalFiltro = @SucursalDestino
AND wp.Pasillo = @Pasillo
AND wp.Modulo = @ModuloAux
AND wp.ModuloID = @IDAux
AND wp.Tarima = @TarimaAnt
IF @ArtTipoOpcion='Si'
BEGIN
SELECT @SubCuentaAnt = ''
WHILE(1=1)
BEGIN
SELECT @SubCuentaAct = MIN(wp.SubCuenta)
FROM #WMSSurtidoProcesarD wp
WHERE wp.SucursalFiltro = @SucursalDestino
AND wp.Pasillo = @Pasillo
AND wp.Modulo = @ModuloAux
AND wp.ModuloID = @IDAux
AND wp.Tarima = @TarimaAnt
AND wp.SubCuenta > @SubCuentaAnt
IF @SubCuentaAct IS NULL BREAK
SELECT @SubCuentaAnt = @SubCuentaAct
SELECT @Renglon = @Renglon + 2048
SELECT @PosicionOrigen = PosicionOrigen,
@PosicionDestino = PosicionDestino,
@CantidadTarima = SUM(CantidadTarima),
@Zona = wp.Zona,
@Unidad = Unidad,
@CantidadUnidad = SUM(CantidadUnidad),
@ArticuloAux=Articulo,
@SubCuentaAux=SubCuenta,
@TarimaFechaCaducidadAux=TarimaFechaCaducidad 
FROM #WMSSurtidoProcesarD wp
WHERE wp.SucursalFiltro = @SucursalDestino
AND wp.Pasillo = @Pasillo
AND wp.Modulo = @ModuloAux
AND wp.ModuloID = @IDAux
AND wp.Tarima = @Tarima
AND wp.SubCuenta=@SubCuentaAct 
GROUP BY PosicionOrigen, PosicionDestino, wp.Zona, Unidad, Articulo, SubCuenta, TarimaFechaCaducidad 
UPDATE Tarima SET Posicion = @PosicionOrigen WHERE Tarima = @Tarima
IF @ModuloAux = 'VTAS'
SELECT @ArtCambioClave = VD.ArtCambioClave
FROM VentaD VD
JOIN Venta V ON VD.ID = V.ID
WHERE V.Mov = @Origen
AND V.MovId = @OrigenID
AND VD.Articulo = @ArticuloAux
AND v.ID = @IDAux
INSERT TMAD (ID, Sucursal, Renglon, Tarima, Almacen, Posicion, PosicionDestino, CantidadPicking, Zona, Prioridad, Montacarga, EstaPendiente, Procesado, Unidad,  CantidadUnidad, Articulo, SubCuenta, FechaCaducidad, ArtCambioClave) 
VALUES      (@ID, @Sucursal, @Renglon, @Tarima, @Almacen, @PosicionOrigen, @PosicionDestino, @CantidadTarima, @Zona, 'Normal', @Agente, 1,   0,         @Unidad, @CantidadUnidad, @ArticuloAux, @SubCuentaAux, @TarimaFechaCaducidadAux, @ArtCambioClave) 
DECLARE crSerieLote CURSOR LOCAL STATIC FOR
SELECT SUM(slm.Cantidad),
MAX(slm.Propiedades),
slm.SerieLote
FROM SerieLoteMov slm
WHERE slm.ID = @IDAux
AND slm.Modulo = @ModuloAux
AND slm.Articulo = @ArticuloAux
AND ISNULL(slm.SubCuenta,'') = ISNULL(@SubCuentaAux,'')
AND slm.SerieLote = @SerieLote
AND slm.Tarima = @Tarima
GROUP BY slm.SerieLote
OPEN crSerieLote
FETCH NEXT FROM crSerieLote INTO @CantidadSerieLote, @Propiedades, @SerieLote
WHILE @@FETCH_STATUS = 0
BEGIN
IF @CantidadSerieLote > @CantidadTarima
SET @CantidadSerieLote = @CantidadTarima
INSERT SerieLoteMov
(Empresa,  Sucursal,  Modulo,  ID,  RenglonID,  Articulo,  SubCuenta, SerieLote, Cantidad, Propiedades, Tarima, AsignacionUbicacion)
VALUES (@Empresa, @Sucursal, 'TMA', @ID, @Renglon, @ArticuloAux, ISNULL(@SubCuentaAux,''), @SerieLote, @CantidadSerieLote, @Propiedades, @Tarima, 0)
FETCH NEXT FROM crSerieLote INTO @CantidadSerieLote, @Propiedades, @SerieLote
END
CLOSE crSerieLote
DEALLOCATE crSerieLote
END
END  /*** OPCIONES **/
ELSE
BEGIN
SELECT @Renglon = @Renglon + 2048 
SELECT @PosicionOrigen = PosicionOrigen,
@PosicionDestino = PosicionDestino,
@CantidadTarima = SUM(CantidadTarima),
@Zona = wp.Zona,
@Unidad = Unidad,
@CantidadUnidad = SUM(CantidadUnidad),
@ArticuloAux=Articulo,
@SubCuentaAux=SubCuenta,
@TarimaFechaCaducidadAux=TarimaFechaCaducidad 
FROM #WMSSurtidoProcesarD wp
WHERE wp.SucursalFiltro = @SucursalDestino
AND wp.Pasillo = @Pasillo
AND wp.Modulo = @ModuloAux
AND wp.ModuloID = @IDAux
AND wp.Tarima = @Tarima
GROUP BY PosicionOrigen, PosicionDestino, wp.Zona, Unidad, Articulo, SubCuenta, TarimaFechaCaducidad 
UPDATE Tarima SET Posicion = @PosicionOrigen WHERE Tarima = @Tarima
IF @ModuloAux = 'VTAS'
SELECT @ArtCambioClave = VD.ArtCambioClave
FROM VentaD VD
JOIN Venta V ON VD.ID = V.ID
WHERE V.Mov = @Origen
AND V.MovId = @OrigenID
AND VD.Articulo = @ArticuloAux
AND v.ID = @IDAux
INSERT TMAD (ID, Sucursal, Renglon, Tarima, Almacen, Posicion, PosicionDestino, CantidadPicking, Zona, Prioridad, Montacarga, EstaPendiente, Procesado, Unidad,  CantidadUnidad, Articulo, SubCuenta, FechaCaducidad, ArtCambioClave) 
VALUES      (@ID, @Sucursal, @Renglon, @Tarima, @Almacen, @PosicionOrigen, @PosicionDestino, @CantidadTarima, @Zona, 'Normal', @Agente, 1,   0,         @Unidad, @CantidadUnidad, @ArticuloAux, @SubCuentaAux, @TarimaFechaCaducidadAux, @ArtCambioClave) 
DECLARE crSerieLote CURSOR LOCAL STATIC FOR
SELECT SUM(slm.Cantidad),
MAX(slm.Propiedades),
slm.SerieLote
FROM SerieLoteMov slm
WHERE slm.ID = @IDAux
AND slm.Modulo = @ModuloAux
AND slm.Articulo = @ArticuloAux
AND ISNULL(slm.SubCuenta,'') = ISNULL(@SubCuentaAux,'')
AND slm.Tarima = @Tarima
GROUP BY slm.SerieLote
OPEN crSerieLote
FETCH NEXT FROM crSerieLote INTO @CantidadSerieLote, @Propiedades, @SerieLote
WHILE @@FETCH_STATUS = 0
BEGIN
IF @CantidadSerieLote > @CantidadTarima
SET @CantidadSerieLote = @CantidadTarima
INSERT SerieLoteMov
(Empresa,  Sucursal,  Modulo,  ID,  RenglonID,  Articulo,  SubCuenta, SerieLote, Cantidad, Propiedades, Tarima, AsignacionUbicacion)
VALUES (@Empresa, @Sucursal, 'TMA', @ID, @Renglon, @ArticuloAux, ISNULL(@SubCuentaAux,''), @SerieLote, @CantidadSerieLote, @Propiedades, @Tarima, 0)
FETCH NEXT FROM crSerieLote INTO @CantidadSerieLote, @Propiedades, @SerieLote
END
CLOSE crSerieLote
DEALLOCATE crSerieLote
END  /*** nORMAL **/
END
IF @Ok IS NULL
EXEC spAfectar 'TMA', @ID, 'AFECTAR', @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SELECT @TarimaSurtido = NULL
SELECT @TarimaSurtido = TarimaSurtido FROM TMA WHERE ID = @ID
UPDATE WMSModuloTarima SET IDTMA = @ID, TarimaSurtido = @TarimaSurtido
WHERE IDModulo = @IDAux
AND Modulo  = @ModuloAux
DECLARE crMovFlujo CURSOR LOCAL STATIC FOR
SELECT DISTINCT t.Modulo, t.IDModulo
FROM WMSModuloTarima t
JOIN WMSLista l ON t.IDModulo = l.IDModulo AND t.Modulo = l.Modulo
WHERE l.Estacion = @Estacion
AND t.Modulo = @ModuloAux AND t.IDModulo = @IDAux
OPEN crMovFlujo
FETCH NEXT FROM crMovFlujo INTO @ModuloD, @IDModuloD
WHILE @@FETCH_STATUS = 0 AND @OK = NULL
BEGIN
SELECT @Mov = NULL, @MovID = NULL
IF @ModuloD = 'VTAS' SELECT @Mov = Mov, @MovID = MovID FROM Venta WHERE ID = @IDModuloD ELSE
IF @ModuloD = 'COMS' SELECT @Mov = Mov, @MovID = MovID FROM Compra WHERE ID = @IDModuloD ELSE
IF @ModuloD = 'INV'  SELECT @Mov = Mov, @MovID = MovID FROM Inv WHERE ID = @IDModuloD ELSE
IF @ModuloD = 'PROD' SELECT @Mov = Mov, @MovID = MovID FROM Prod WHERE ID = @IDModuloD
SELECT @MovDestino = Mov, @MovDestinoID = MovID FROM TMA WHERE ID = @ID
IF @Mov IS NOT NULL AND @MovID IS NOT NULL AND @MovDestino IS NOT NULL AND @MovDestinoID IS NOT NULL
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @ModuloD, @IDModuloD, @Mov, @MovID, 'TMA', @ID, @MovDestino, @MovDestinoID, @Ok OUTPUT
FETCH NEXT FROM crMovFlujo INTO @ModuloD, @IDModuloD
END
CLOSE crMovFlujo
DEALLOCATE crMovFlujo
END
END
END
END
END
DELETE @WMSSurtidoProcesarDTotal
INSERT @WMSSurtidoProcesarDTotal
SELECT Modulo, ModuloID, Articulo, wp.Almacen,SUM(wp.CantidadTarima), wp.SubCuenta, wp.SerieLote 
FROM WMSSurtidoProcesarD wp
WHERE wp.Estacion = @Estacion AND wp.Procesado = 1 AND Articulo IN(SELECT DISTINCT Clave FROM ListaSt WHERE Estacion = @Estacion)
AND (wp.PosicionDestino IS NOT NULL AND wp.PosicionDestino <> '') 
GROUP BY Modulo, ModuloID, Articulo,wp.Almacen, wp.SubCuenta, wp.SerieLote 
SELECT @ModuloAuxAnt = ''
WHILE(1=1)
BEGIN
SELECT @ModuloAux = MIN(wp.Modulo)
FROM WMSSurtidoProcesarD wp
WHERE wp.Estacion = @Estacion
AND wp.Procesado = 1
AND Articulo IN(SELECT DISTINCT Clave FROM ListaSt WHERE Estacion = @Estacion)
AND (wp.PosicionDestino IS NOT NULL AND wp.PosicionDestino <> '') 
AND wp.Modulo > @ModuloAuxAnt
IF @ModuloAux IS NULL BREAK
SELECT @ModuloAuxAnt = @ModuloAux
SELECT @IDAuxAnt = 0
WHILE(1=1)
BEGIN
SELECT @IDAux = MIN(wp.ModuloID)
FROM WMSSurtidoProcesarD wp
WHERE wp.Estacion = @Estacion
AND wp.Procesado = 1
AND Articulo IN(SELECT DISTINCT Clave FROM ListaSt WHERE Estacion = @Estacion)
AND (wp.PosicionDestino IS NOT NULL AND wp.PosicionDestino <> '') 
AND wp.Modulo = @ModuloAux
AND wp.ModuloID > @IDAuxAnt
IF @IDAux IS NULL BREAK
SELECT @IDAuxAnt = @IDAux
SELECT @TarimaSurtido =  NULL
SELECT @TarimaSurtido = TarimaSurtido
FROM WMSSurtidoProcesarD
WHERE /*Estacion = @Estacion
AND Procesado = 1
AND */Modulo = @ModuloAux
AND ModuloID = @IDAux
SELECT @IDTarimaAnt = 0
WHILE(1=1)
BEGIN
SELECT @IDTarima = MIN(ID)
FROM WMSModuloTarima
WHERE Modulo = @ModuloAux
AND IDModulo = @IDAux
AND ID > @IDTarimaAnt
IF @IDTarima IS NULL BREAK
SELECT @IDTarimaAnt = @IDTarima
SELECT @ArticuloWMS = Articulo,
@AlmacenWMS = Almacen,
@ModuloWMS = @ModuloAux,
@IDModuloWMS = @IDAux,
@RenglonWMS = Renglon,
@RenglonSubWMS = RenglonSub,
@SubCuentaWMS = SubCuenta 
FROM WMSModuloTarima
WHERE Modulo = @ModuloAux
AND IDModulo = @IDAux
AND ID = @IDTarima
SELECT @CantidadWMS = (SELECT SUM(CantidadTarima) FROM @WMSSurtidoProcesarDTotal WHERE Articulo = @ArticuloWMS AND Almacen = @AlmacenWMS AND Modulo = @ModuloWMS AND ModuloID = @IDModuloWMS AND SubCuenta=@SubCuentaWMS) 
EXEC spWMSDividirPorReservadoPck @IDModuloWMS, @ModuloWMS, @Empresa, @ArticuloWMS, @SubCuentaWMS, @AlmacenWMS, @CantidadWMS, @TarimaSurtido, @Usuario, @Estacion, @RenglonWMS, @RenglonSubWMS, @Ok OUTPUT, @OkRef OUTPUT 
UPDATE WMSModuloTarima
SET IDTMA = 0,
Cantidad = Cantidad - ISNULL(CASE WHEN @CantidadTarima >= @CantidadWMS THEN @CantidadWMS ELSE @CantidadTarima END, 0)
WHERE ID = @IDTarima
AND Modulo = @ModuloWMS AND IDModulo = @IDModuloWMS
END
IF @ModuloWMS = 'VTAS' UPDATE VentaD  SET Tarima = NULL WHERE ID = @IDModuloWMS AND Tarima = 'tmpTarimaDividir'
IF @ModuloWMS = 'COMS' UPDATE CompraD SET Tarima = NULL WHERE ID = @IDModuloWMS AND Tarima = 'tmpTarimaDividir'
IF @ModuloWMS = 'INV'  UPDATE InvD    SET Tarima = NULL WHERE ID = @IDModuloWMS AND Tarima = 'tmpTarimaDividir'
END
END
/* Al Explosionar con Cross Docking Genera Surtido */
BEGIN
DECLARE crDisponible CURSOR LOCAL STATIC FOR
SELECT Articulo, Almacen, Tipo, 0 Cantidad, Unidad, SUM(CantidadUnidad), Articulo, SubCuenta,
TarimaFechaCaducidad
FROM WMSSurtidoProcesarD
WHERE Estacion = @Estacion AND Procesado = 0
AND Articulo IN(SELECT DISTINCT Clave FROM ListaSt WHERE Estacion = @Estacion)
AND Tipo = 'Cross Docking'
AND (PosicionDestino IS NOT NULL AND PosicionDestino <> '' )
AND NULLIF(SubCuenta,'') IS NULL
GROUP BY Articulo, Almacen, Tipo, Unidad, Articulo, SubCuenta, TarimaFechaCaducidad
OPEN crDisponible
FETCH NEXT FROM crDisponible INTO @Articulo, @Almacen, @Tipo, @CantidadTarima, @Unidad, @CantidadUnidad, @ArticuloAux, @SubCuentaAux, @TarimaFechaCaducidad 
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Ordenes = 0
UPDATE WMSSurtidoProcesarD SET Procesado = 1 WHERE Estacion = @Estacion AND Articulo = @Articulo AND Procesado = 0 AND (PosicionDestino IS NOT NULL AND PosicionDestino <> '') AND Tipo = 'Cross Docking'
/* Se crea la Solicitud Reacomodo si se llega al minimo en domicilio */
DECLARE crMinimo CURSOR LOCAL FOR
SELECT SUM(d.Disponible) Disponible, a.MinimoTarima, SUM(d.Disponible) - @CantidadTarima - @Ordenes Resultado
FROM ArtDisponibleTarima d
JOIN Tarima t ON d.Tarima = t.Tarima AND d.Almacen = t.Almacen
JOIN AlmPos p ON t.Almacen = p.Almacen AND p.Posicion = t.Posicion
JOIN Art a ON d.Articulo = a.Articulo
WHERE p.Tipo = 'Cross Docking'
AND d.Articulo = @Articulo
AND t.Estatus = 'ALTA'
AND p.Estatus = 'ALTA'
GROUP BY d.Articulo, a.MinimoTarima
OPEN crMinimo
FETCH NEXT FROM crMinimo INTO @Disponible, @MinimoTarima, @Resultado
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Contador = 0
WHILE @Resultado < @MinimoTarima
BEGIN
SELECT @Tarima = NULL, @DisponibleTarima = NULL, @PosicionOrigen = NULL
SELECT @ControlArticulo = ControlArticulo FROM Art WHERE Articulo = @Articulo
IF NOT EXISTS(SELECT * FROM SerieLoteMov WHERE Modulo=@ModuloWMS AND ID=@IDModuloWMS)
EXEC spTMAExplocionTarima @Almacen, @Articulo, NULL, @ControlArticulo, 'Cross Docking', @Estacion, @Tarima OUTPUT, @Disponible OUTPUT, @PosicionOrigen OUTPUT
ELSE
EXEC spTMAExplocionTarimaSerieLote @ModuloWMS, @IDAux, @Almacen, @Articulo, NULL, @ControlArticulo, 'Cross Docking', NULL, @Tarima OUTPUT, @Disponible OUTPUT, NULL, @RenglonID, @SerieLote
SELECT TOP 1 @PosicionDestino = Posicion FROM AlmPos WHERE ArticuloEsp = @Articulo AND Tipo = @Tipo AND Almacen = @Almacen
IF @Contador = 0
SELECT @Resultado = @Resultado + ISNULL(SUM(ISNULL(a.Disponible,0)),0)
FROM TMA t
JOIN TMAD d on t.id = d.id
JOIN ArtDisponibleTarima a ON d.Tarima = a.Tarima AND a.Articulo = @Articulo AND a.Almacen = d.Almacen
JOIN MovTipo m ON m.Mov = t.Mov AND m.Modulo = 'TMA'
WHERE m.Clave = 'TMA.SRADO'
AND t.Estatus = 'PENDIENTE'
AND d.PosicionDestino = @PosicionDestino
IF @Resultado < @MinimoTarima AND @Tarima IS NOT NULL
BEGIN
SELECT @Mov = TMASolicitudReacomodo FROM EmpresaCfgMovWMS WHERE Empresa = @Empresa
SELECT @TarimasReacomodar = ISNULL(TarimasReacomodar,0) FROM Art WHERE Articulo = @Articulo
IF ISNULL(@TarimasReacomodar,0) = 0
SET @TarimasReacomodar = 1
INSERT TMA (Empresa, Sucursal,   Usuario,  Mov,  FechaEmision,  Estatus,       Almacen,  TarimaSurtido,  Prioridad, Referencia)
VALUES     (@Empresa, @Sucursal, @Usuario, @Mov, @FechaEmision, 'SINAFECTAR', @Almacen, @TarimaSurtido, 'Media',  'Herramienta de Surtido')
SET @IDDestino = @@IDENTITY
SET @Renglon = 0
SET @Reacomodar = 1
WHILE @Reacomodar < = @TarimasReacomodar
BEGIN
SELECT @TarimaN = MIN(Tarima)
FROM ArtDisponibleTarima
WHERE Articulo = @Articulo
AND Almacen = @Almacen
AND Disponible >= @Disponible
AND Tarima NOT IN (SELECT Tarima FROM @TarimaDisp)
AND Tarima >= @Tarima
INSERT @TarimaDisp(Tarima)VALUES(@TarimaN)
INSERT TMAD (ID,         Sucursal,  Renglon,  Tarima,                   Almacen,  Posicion,        PosicionDestino,  CantidadPicking, Prioridad, EstaPendiente, Procesado, Unidad,  CantidadUnidad, Articulo, SubCuenta, FechaCaducidad) 
SELECT       @IDDestino, @Sucursal, @Renglon, ISNULL(@TarimaN,@Tarima), @Almacen, @PosicionOrigen, @PosicionDestino, @Disponible,     'Media',   1,             0,         @Unidad, @CantidadUnidad, @ArticuloAux, @SubCuentaAux, @TarimaFechaCaducidad 
SET @Renglon = @Renglon +2048
SET @Reacomodar = @Reacomodar +1
END
IF @Ok IS NULL AND @IDDestino IS NOT NULL AND EXISTS (SELECT * FROM TMAD WHERE ID = @IDDestino) AND @Tarima IS NOT NULL
BEGIN
EXEC spAfectar 'TMA', @IDDestino, 'Afectar', @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @MovDestino = Mov, @MovDestinoID = MovID FROM TMA WHERE ID = @IDDestino
EXEC spMovFlujo @Sucursal, Afectar, @Empresa, 'TMA', @ID, @Mov, @MovID, 'TMA', @IDDestino, @MovDestino, @MovDestinoID, @Ok OUTPUT
END
ELSE
DELETE TMA where ID = @IDDestino
SELECT @Resultado = @Resultado + @DisponibleTarima
SELECT @Contador = 1
END
IF @Tarima IS NULL
SELECT @Resultado = @MinimoTarima
END
FETCH NEXT FROM crMinimo INTO @Disponible, @MinimoTarima, @Resultado
END
CLOSE crMinimo
DEALLOCATE crMinimo
/* Se crea el movimiento Surtido en TMA(WMS) Cuando es Cross Docking */
DECLARE crUbicacion CURSOR LOCAL STATIC FOR
SELECT wp.Modulo, wp.ModuloID,
@Empresa, @Sucursal,
@Usuario, dbo.fnFechaSinHora(GETDATE()), 'SINAFECTAR',
wp.Almacen,
wp.Acomodador, wp.Zona, 'Herramienta',
wp.PosicionOrigen, wp.PosicionDestino, SUM(wp.CantidadTarima), wP.Tarima, wp.Referencia, wp.Unidad, SUM(wp.CantidadUnidad),
wp.SucursalFiltro,
wp.TarimaSurtido,
wp.Articulo,
wp.SubCuenta,
WP.TarimaFechaCaducidad,
WP.PCKUbicacion,
WP.SerieLote
FROM WMSSurtidoProcesarD wp inner join almpos ap on wp.Almacen = ap.Almacen AND wp. PosicionOrigen = ap.Posicion
WHERE wp.Estacion = @Estacion AND wp.Procesado = 1 AND wp.Tipo = 'Cross Docking'  AND Articulo IN (SELECT DISTINCT Clave FROM ListaSt WHERE Estacion = @Estacion)
AND (wp.PosicionDestino IS NOT NULL AND wp.PosicionDestino <> '')
AND wp.Articulo = @Articulo AND wp.Almacen = @Almacen AND wp.Unidad = ISNULL(@Unidad,wp.Unidad) AND ISNULL(wp.TarimaFechaCaducidad,1) = ISNULL(ISNULL(@TarimaFechaCaducidad, wp.TarimaFechaCaducidad),1)
GROUP BY wp.Modulo, wp.ModuloID, wp.Almacen, wp.Acomodador, wp.Zona, wp.PosicionOrigen,
wp.PosicionDestino, wp.CantidadTarima, wP.Tarima, wp.Referencia, wp.Unidad, wp.SucursalFiltro, wp.TarimaSurtido, wp.Articulo, wp.SubCuenta,
WP.TarimaFechaCaducidad, WP.PCKUbicacion,WP.SerieLote
OPEN crUbicacion
FETCH NEXT FROM crUbicacion INTO @ModuloAux, @IDAux, @Empresa, @Sucursal, @Usuario, @FechaEmision, @Estatus, @Almacen, @Agente, @Zona, @Observaciones, @PosicionOrigen, @PosicionDestino, @CantidadTarima, @Tarima, @Referencia, @Unidad, @CantidadUnidad, @SucursalDestino, @TarimaSurtido, @ArticuloAux, @SubCuentaAux, @TarimaFechaCaducidadAux, @PCKUbicacion, @SerieLote 
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Mov = Mov FROM MovTipo WHERE Clave = 'TMA.OSUR' AND Modulo = 'TMA' AND SubClave IS NULL
EXEC spMovInfo  @IDAux, @ModuloAux, @Mov = @Origen OUTPUT, @MovID = @OrigenID OUTPUT, @Observaciones = @OrigenObservaciones OUTPUT
IF @ModuloAux = 'VTAS'
SELECT @ArtCambioClave = VD.ArtCambioClave
FROM VentaD VD
JOIN Venta V ON VD.ID = V.ID
WHERE V.Mov = @Origen
AND V.MovId = @OrigenID
AND VD.Articulo = @ArticuloAux
AND v.ID = @IDAux
INSERT TMA (Empresa, Sucursal, Usuario, Mov, FechaEmision, Estatus, Almacen, Agente, Zona, Observaciones, TarimaSurtido, Prioridad, Referencia, SucursalFiltro, OrigenTipo, Origen, OrigenID, OrigenObservaciones)
VALUES     (@Empresa, @Sucursal, @Usuario, @Mov, @FechaEmision, @Estatus, @Almacen, @Agente, @Zona, @Observaciones, @TarimaSurtido, 'Normal', @Referencia, @SucursalDestino, @ModuloAux, @Origen, @OrigenID, @OrigenObservaciones)
SET @ID = @@IDENTITY
UPDATE Tarima SET Posicion = @PosicionOrigen WHERE Tarima = @Tarima
INSERT TMAD (ID, Sucursal, Renglon, Tarima, Almacen, Posicion, PosicionDestino, CantidadPicking, Zona, Prioridad, Montacarga, EstaPendiente, Procesado, Unidad,  CantidadUnidad, Articulo, SubCuenta, FechaCaducidad, ArtCambioClave)
VALUES      (@ID, @Sucursal, 2048, @Tarima, @Almacen, @PosicionOrigen, @PosicionDestino, @CantidadTarima, @Zona, 'Normal', @Agente, 1,  0,         @Unidad, @CantidadUnidad, @ArticuloAux, @SubCuentaAux, @TarimaFechaCaducidadAux, @ArtCambioClave)
DECLARE crSerieLote CURSOR LOCAL STATIC FOR
SELECT slm.SerieLote,
SUM(slm.Cantidad),
MAX(slm.Propiedades)
FROM SerieLoteMov slm
WHERE slm.ID = @IDAux
AND slm.Modulo = @ModuloAux
AND slm.Articulo = @ArticuloAux
AND ISNULL(slm.SubCuenta,'') = ISNULL(@SubCuentaAux,'')
AND slm.SerieLote = @SerieLote
GROUP BY slm.SerieLote
OPEN crSerieLote
FETCH NEXT FROM crSerieLote INTO @SerieLote, @CantidadSerieLote, @Propiedades
WHILE @@FETCH_STATUS = 0
BEGIN
IF @CantidadSerieLote > @CantidadTarima
SET @CantidadSerieLote = @CantidadTarima
INSERT SerieLoteMov
(Empresa,  Sucursal,  Modulo,  ID,  RenglonID,  Articulo,  SubCuenta, SerieLote, Cantidad, Propiedades, Tarima, AsignacionUbicacion)
VALUES (@Empresa, @Sucursal, 'TMA', @ID, 2048, @ArticuloAux, ISNULL(@SubCuentaAux,''), @SerieLote, @CantidadSerieLote, @Propiedades, @Tarima, 0)
FETCH NEXT FROM crSerieLote INTO @SerieLote, @CantidadSerieLote, @Propiedades
END
CLOSE crSerieLote
DEALLOCATE crSerieLote
IF @OK IS NULL
EXEC spAfectar 'TMA', @ID, 'AFECTAR', @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @OK IS NULL
BEGIN
SELECT @MovDestino = Mov, @MovDestinoID = MovID FROM TMA WHERE ID = @ID
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @ModuloAux, @IDAux, @Origen, @OrigenID, 'TMA', @ID, @MovDestino, @MovDestinoID, @Ok OUTPUT
END
/* Este codigo es para que actualice a la Tarima de Surtido el pedido, etc ... */
SELECT  @ArticuloWMS = Articulo,
@AlmacenWMS = Almacen,
@ModuloWMS = @ModuloAux,
@IDModuloWMS = @IDAux,
@RenglonWMS = Renglon,
@RenglonSubWMS = RenglonSub,
@SubCuentaWMS = SubCuenta
FROM WMSModuloTarima
WHERE Modulo = @ModuloAux
AND IDModulo = @IDAux
DELETE @WMSSurtidoProcesarDTotal
INSERT @WMSSurtidoProcesarDTotal
SELECT Modulo, ModuloID, Articulo, wp.Almacen,SUM(wp.CantidadTarima), wp.SubCuenta, wp.SerieLote
FROM WMSSurtidoProcesarD wp
WHERE wp.Estacion = @Estacion AND wp.Procesado = 1 AND Articulo IN(SELECT DISTINCT Clave FROM ListaSt WHERE Estacion = @Estacion)
AND (wp.PosicionDestino IS NOT NULL AND wp.PosicionDestino <> '')
AND wp.Tipo = 'Cross Docking'
GROUP BY Modulo, ModuloID, Articulo,wp.Almacen, SubCuenta, wp.SerieLote
SELECT @CantidadWMS = (SELECT SUM(CantidadTarima) FROM @WMSSurtidoProcesarDTotal WHERE Articulo = @Articulo AND Almacen = @Almacen AND Modulo = @ModuloAux AND ModuloID = @IDModuloWMS AND SubCuenta=@SubCuentaWMS)
IF NOT EXISTS (SELECT * FROM @WMSSurtidoCD WHERE ModuloID = @IDModuloWMS AND Modulo = @ModuloAux AND Articulo = @Articulo AND Almacen = @Almacen)
EXEC spWMSDividirPorReservadoPck @IDModuloWMS, @ModuloAux, @Empresa, @Articulo, @SubCuentaWMS, @Almacen, @CantidadWMS, @TarimaSurtido, @Usuario, @Estacion, @RenglonWMS, @RenglonSubWMS, @Ok OUTPUT, @OkRef OUTPUT
INSERT @WMSSurtidoCD (Modulo,     ModuloID,     Articulo,  Almacen)
SELECT @ModuloAux, @IDModuloWMS, @Articulo, @Almacen
FETCH NEXT FROM crUbicacion INTO @ModuloAux, @IDAux, @Empresa, @Sucursal, @Usuario, @FechaEmision, @Estatus, @Almacen, @Agente, @Zona, @Observaciones, @PosicionOrigen, @PosicionDestino, @CantidadTarima, @Tarima, @Referencia, @Unidad, @CantidadUnidad, @SucursalDestino, @TarimaSurtido, @ArticuloAux, @SubCuentaAux, @TarimaFechaCaducidadAux, @PCKUbicacion, @SerieLote 
END
CLOSE crUbicacion
DEALLOCATE crUbicacion
FETCH NEXT FROM crDisponible INTO @Articulo, @Almacen, @Tipo, @CantidadTarima, @Unidad, @CantidadUnidad, @ArticuloAux, @SubCuentaAux, @TarimaFechaCaducidad 
END
CLOSE crDisponible
DEALLOCATE crDisponible
END
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000 OR @Ok = 80010
BEGIN
COMMIT TRAN HMp
SELECT 'Procesadas Con Éxito'
END
ELSE
BEGIN
ROLLBACK TRAN HMp
SELECT @OkRef =  ISNULL(Descripcion,'') + '. Posición: ' + RTRIM(LTRIM(@OkRef))FROM MensajeLista WHERE Mensaje = @Ok
SELECT 'Error ' + CONVERT(varchar,@Ok) + ' ' + ISNULL(@OkRef,'')
END
RETURN
END

