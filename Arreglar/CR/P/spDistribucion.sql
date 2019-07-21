SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDistribucion (
@Empresa              varchar(5),
@Sucursal             int,
@Usuario              varchar(10),
@Estacion             int,
@Corrida              int,
@Almacen              varchar(10)
)

AS
BEGIN
DECLARE
@NombreTrans          varchar(255),
@SPID                 varchar(20),
@FechaHoy             datetime,
@Cuenta               int,
@Generados            int,
@idx                  int,
@MovIdLog             varchar(20),
@EstatusLog           varchar(15),
@Observacion          varchar(4000),
@Mensaje              varchar(4000),
@AlmacenOrigen        varchar(10),
@ArtTipo              varchar(20)
DECLARE
@MovEstatus           varchar(15),
@MovConsecutivo       bit,
@MovReservar          bit
DECLARE
@Modulo               varchar(5),
@Accion               varchar(20),
@Base                 varchar(20),
@GenerarMov           varchar(20),
@SincroFinal          bit,
@EnSilencio           bit,
@Conexion             bit,
@Ok                   int,
@OkRef                varchar(255),
@FechaRegistro        datetime
DECLARE
@ID                   int,
@Mov                  varchar(20),
@MovID                varchar(20),
@FechaEmision         datetime,
@Proyecto             varchar(50),
@Moneda               varchar(10),
@TipoCambio           float,
@Concepto             varchar(50),
@Referencia           varchar(50),
@DocFuente            int,
@Observaciones        varchar(100),
@Estatus              varchar(15),
@Situacion            varchar(50),
@SituacionFecha       datetime,
@SituacionUsuario     varchar(10),
@SituacionNota        varchar(100),
@Directo              bit,
@RenglonID            int,
@AlmacenDestino       varchar(10),
@AlmacenTransito      varchar(10),
@Largo                bit,
@Condicion            varchar(50),
@Vencimiento          datetime,
@FormaEnvio           varchar(50),
@Autorizacion         varchar(10),
@OrigenTipo           varchar(10),
@Origen               varchar(20),
@OrigenID             varchar(20),
@Poliza               varchar(20),
@PolizaID             varchar(20),
@FechaConclusion      datetime,
@FechaCancelacion     datetime,
@FechaOrigen          datetime,
@FechaRequerida       datetime,
@Peso                 float,
@Volumen              float,
@SucursalOrigen       int,
@VerLote              bit,
@UEN                  int,
@VerDestino           bit,
@Personal             varchar(10),
@Conteo               int,
@Agente               varchar(10),
@ACRetencion          float,
@SubModulo            varchar(5),
@Motivo               varchar(8),
@ReferenciaMES        varchar(50),
@PedidoMES            varchar(50),
@Serie                varchar(3),
@IDMES                int,
@IDMarcaje            int,
@MovMES               bit,
@Actividad            varchar(100),
@PedimentoExtraccion  varchar(50),
@PosicionWMS          varchar(10),
@PosicionDWMS         varchar(10)
DECLARE
@Renglon              float,
@RenglonSub           int,
@RenglonTipo          char(1),
@Cantidad             float,
@Codigo               varchar(30),
@Articulo             varchar(20),
@ArticuloDestino      varchar(20),
@SubCuenta            varchar(50),
@SubCuentaDestino     varchar(50),
@Costo                money,
@CostoInv             money,
@ContUso              varchar(20),
@Espacio              varchar(10),
@CantidadA            float,
@Paquete              int,
@Aplica               varchar(20),
@AplicaID             varchar(20),
@DestinoTipo          varchar(10),
@Destino              varchar(20),
@DestinoID            varchar(20),
@Cliente              varchar(10),
@DefUnidad            varchar(50),
@Unidad               varchar(50),
@Factor               float,
@CantidadInventario   float,
@ProdSerieLote        varchar(50),
@Merma                float,
@Desperdicio          float,
@Producto             varchar(20),
@SubProducto          varchar(20),
@Tipo                 varchar(20),
@Precio               money,
@SegundoConteo        float,
@DescripcionExtra     varchar(100),
@Posicion             varchar(10),
@MultiUnidad          varchar(20)
SET @Empresa            = UPPER(LTRIM(RTRIM(ISNULL(@Empresa,''))))
SET @Sucursal           = UPPER(LTRIM(RTRIM(ISNULL(@Sucursal,''))))
SET @Usuario            = UPPER(LTRIM(RTRIM(ISNULL(@Usuario,''))))
SET @Estacion           = ISNULL(@Estacion,1)
SET @Corrida            = ISNULL(@Corrida,0)
SET @Almacen            = UPPER(LTRIM(RTRIM(ISNULL(@Almacen,''))))
SET @FechaHoy           = GETDATE()
SET @Generados          = 0
SELECT TOP 1
@MovEstatus = LTRIM(RTRIM(ISNULL(Estatus,'SIN AFECTAR'))),
@MovConsecutivo = ISNULL(Consecutivo,0),
@MovReservar = ISNULL(Reservar,0)
FROM DistribucionCfg
WHERE Empresa = @Empresa
SELECT @MultiUnidad = NivelFactorMultiUnidad FROM EmpresaCFG2 WHERE Empresa = @Empresa
SELECT @Moneda = DefMoneda,@UEN = UEN FROM Usuario WHERE Usuario = @Usuario
SELECT @TipoCambio = TipoCambio FROM Mon WHERE Moneda = @Moneda
SELECT @DefUnidad = ISNULL(DefUnidad,'pza') FROM EmpresaGral WHERE Empresa = @Empresa
SELECT TOP 1 @AlmacenOrigen = Almacen FROM Distribucion WHERE Corrida = @Corrida
SELECT @SucursalOrigen = Sucursal FROM Alm WHERE ALmacen = @AlmacenOrigen
SET @ID                  = NULL
SET @Mov                 = 'Orden Traspaso'
SET @MovID               = NULL
SET @FechaEmision        = dbo.fnFechaSinHora(@FechaHoy)
SET @Proyecto            = NULL
SET @Concepto            = 'Traspaso entre sucursales'
SET @Referencia          = NULL
SET @DocFuente           = NULL
SET @Observaciones       = 'Corrida ' + CAST(@Corrida AS VARCHAR(20))
SET @Estatus             = 'SINAFECTAR'
SET @Situacion           = NULL
SET @SituacionFecha      = NULL
SET @SituacionUsuario    = NULL
SET @SituacionNota       = NULL
SET @Directo             = 1
SET @RenglonID           = NULL
SET @AlmacenDestino      = NULL
SET @AlmacenTransito     = '(TRANSITO)'
SET @Largo               = 0
SET @Condicion           = NULL
SET @Vencimiento         = @FechaEmision
SET @FormaEnvio          = NULL
SET @Autorizacion        = NULL
SET @OrigenTipo          = NULL
SET @Origen              = NULL
SET @OrigenID            = NULL
SET @Poliza              = NULL
SET @PolizaID            = NULL
SET @FechaConclusion     = NULL
SET @FechaCancelacion    = NULL
SET @FechaOrigen         = NULL
SET @FechaRequerida      = @FechaEmision
SET @Peso                = NULL
SET @Volumen             = NULL
SET @VerLote             = 0
SET @VerDestino          = 0
SET @Personal            = NULL
SET @Conteo              = NULL
SET @Agente              = @Usuario
SET @ACRetencion         = NULL
SET @SubModulo           = 'INV'
SET @Motivo              = NULL
SET @ReferenciaMES       = NULL
SET @PedidoMES           = NULL
SET @Serie               = NULL
SET @IDMES               = NULL
SET @IDMarcaje           = NULL
SET @MovMES              = NULL
SET @Actividad           = NULL
SET @PedimentoExtraccion = NULL
SET @PosicionWMS         = 0
SET @PosicionDWMS        = NULL
SET @RenglonSub          = 0
SET @RenglonTipo         = NULL
SET @Modulo              = 'INV'
SET @Accion              = 'AFECTAR'
SET @Base                = 'TODO'
SET @GenerarMov          = NULL
SET @SincroFinal         = 0
SET @EnSilencio          = 0
SET @Conexion            = 0
SET @Observacion         = ''
SET @Mensaje             = ''
DECLARE @Distribucion Table (
Almacen               varchar(10)   NULL,
AlmacenDestino        varchar(10)   NULL,
Articulo              varchar(20)   NULL,
SubCuenta             varchar(50)   NULL,
Cantidad              float         NULL
)
DECLARE @AlmDestino Table (
ID                    int IDENTITY(1,1),
AlmacenDestino        varchar(10)   NULL
)
DECLARE @TablaAfectar table(
Ok                  int,
OkDesc              varchar(255),
OkTipo              varchar(50),
OkRef               varchar(255),
IDGenerar           int
)
INSERT INTO @Distribucion(Almacen,AlmacenDestino,Articulo,SubCuenta,Cantidad)
SELECT @Almacen,AlmacenDestino,Articulo,SubCuenta,Cantidad
FROM Distribucion
WHERE Empresa  = @Empresa
AND Corrida  = @Corrida
AND Almacen  = @Almacen
AND Usuario  = @Usuario
AND Cantidad > 0
ORDER BY Almacen,AlmacenDestino,Articulo,SubCuenta
INSERT INTO @AlmDestino (AlmacenDestino)
SELECT AlmacenDestino FROM @Distribucion GROUP BY AlmacenDestino ORDER BY AlmacenDestino
SELECT @Cuenta = MAX(ID) FROM @AlmDestino
SET @Cuenta = ISNULL(@Cuenta,0)
SET @idx = 1
WHILE @idx <= @Cuenta
BEGIN
SELECT @AlmacenDestino = AlmacenDestino FROM @AlmDestino WHERE ID = @idx
SELECT @RenglonID = COUNT(AlmacenDestino) + 1 FROM @Distribucion WHERE AlmacenDestino = @AlmacenDestino
INSERT INTO Inv
(
Empresa, Mov, MovID, FechaEmision, Proyecto,
Moneda, TipoCambio, Concepto, Referencia, DocFuente,
Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario,
SituacionNota, Directo, RenglonID, Almacen, AlmacenDestino,
AlmacenTransito, Largo, Condicion, Vencimiento, FormaEnvio,
Autorizacion, Usuario, OrigenTipo, Origen,
OrigenID, Poliza, PolizaID, FechaConclusion, FechaCancelacion,
FechaOrigen, FechaRequerida, Peso, Volumen, Sucursal,
SucursalOrigen, VerLote, UEN, VerDestino, Personal,
Conteo, Agente, ACRetencion, SubModulo, Motivo,
ReferenciaMES, PedidoMES, Serie, IDMES, IDMarcaje,
MovMES, Actividad, PedimentoExtraccion, PosicionWMS, PosicionDWMS
)
VALUES
(
@Empresa, @Mov, @MovID, @FechaEmision, @Proyecto,
@Moneda, @TipoCambio, @Concepto, @Referencia, @DocFuente,
@Observaciones, @Estatus, @Situacion, @SituacionFecha, @SituacionUsuario,
@SituacionNota, @Directo, @RenglonID, @Almacen, @AlmacenDestino,
@AlmacenTransito, @Largo, @Condicion, @Vencimiento, @FormaEnvio,
@Autorizacion, @Usuario, @OrigenTipo, @Origen,
@OrigenID, @Poliza, @PolizaID, @FechaConclusion, @FechaCancelacion,
@FechaOrigen, @FechaRequerida, @Peso, @Volumen, @Sucursal,
@SucursalOrigen, @VerLote, @UEN, @VerDestino, @Personal,
@Conteo, @Agente, @ACRetencion, @SubModulo, @Motivo,
@ReferenciaMES, @PedidoMES, @Serie, @IDMES, @IDMarcaje,
@MovMES, @Actividad, @PedimentoExtraccion, @PosicionWMS, @PosicionDWMS
)
SET @ID = SCOPE_IDENTITY()
SET @RenglonID = 0
DECLARE crDistribucion_01 CURSOR FOR
SELECT Articulo,SubCuenta,Cantidad
FROM @Distribucion
WHERE AlmacenDestino = @AlmacenDestino
OPEN crDistribucion_01
FETCH NEXT FROM crDistribucion_01 INTO @Articulo,@SubCuenta,@Cantidad
WHILE @@FETCH_STATUS = 0
BEGIN
SET @RenglonID = @RenglonID + 1
SET @Renglon   = @RenglonID * 2048
SELECT @Unidad = ISNULL(UnidadTraspaso,@DefUnidad), @ArtTipo = Tipo FROM Art WITH(NOLOCK) WHERE Articulo = @Articulo
IF @MultiUnidad = 'Articulo'
SELECT @Factor = Factor FROM ArtUnidad WITH(NOLOCK) WHERE Unidad = @Unidad AND Articulo = @Articulo
IF @MultiUnidad = 'Unidad'
SELECT @Factor = Factor FROM Unidad WITH(NOLOCK) WHERE Unidad = @Unidad
IF ISNULL(@MultiUnidad,'') = '' OR ISNULL(@Factor, '') = ''
SELECT @Factor = 1
EXEC spRenglonTipo @ArtTipo,@SubCuenta,@RenglonTipo
IF NOT @RenglonTipo IN('N','S','L','V','J') SET @RenglonTipo = 'N'
EXEC spPrecioEsp '(Precio Lista)', @Moneda, @Articulo, @SubCuenta, @Precio OUTPUT
SET @CantidadInventario = @Cantidad * @Factor
SET @Cantidad = @Cantidad / @Factor
IF ISNULL(@SubCuenta,'') = '' SET @SubCuenta = NULL
INSERT INTO InvD(
ID,Renglon,RenglonSub,RenglonID,RenglonTipo,
Almacen,Codigo,Articulo,SubCuenta,ArticuloDestino,
SubCuentaDestino,Cantidad,Paquete,Costo,CantidadA,
Aplica,AplicaID,ContUso,Unidad,Factor,
CantidadInventario,FechaRequerida,ProdSerieLote,Merma,Desperdicio,
Producto,SubProducto,Tipo,Sucursal,SucursalOrigen,
Precio,CostoInv,Espacio,DestinoTipo,Destino,
DestinoID,Cliente,SegundoConteo,DescripcionExtra,Posicion)
VALUES(
@ID,@Renglon,@RenglonSub,@RenglonID,@RenglonTipo,
@Almacen,@Codigo,@Articulo,@SubCuenta,@ArticuloDestino,
@SubCuentaDestino,@Cantidad,@Paquete,@Costo,@Cantidad,
@Aplica,@AplicaID,@ContUso,@Unidad,@Factor,
@CantidadInventario,@FechaRequerida,@ProdSerieLote,@Merma,@Desperdicio,
@Producto,@SubProducto,@Tipo,@Sucursal,@SucursalOrigen,
@Precio,@CostoInv,@Espacio,@DestinoTipo,@Destino,
@DestinoID,@Cliente,@SegundoConteo,@DescripcionExtra,@Posicion)
FETCH NEXT FROM crDistribucion_01 INTO @Articulo,@SubCuenta,@Cantidad
END
CLOSE crDistribucion_01
DEALLOCATE crDistribucion_01
IF @MovEstatus = 'SIN AFECTAR' AND @MovConsecutivo = 1
BEGIN
SET @Accion = 'Consecutivo'
SET @Base = 'Todo'
INSERT INTO @TablaAfectar
EXECUTE spAfectar @Modulo, @ID, @Accion, @Base, @GenerarMov, @Usuario, @SincroFinal, @EnSilencio, @Ok OUTPUT, @OkRef OUTPUT, @FechaRegistro, @Conexion, @Estacion
END
IF @MovEstatus = 'PENDIENTE'
BEGIN
SET @Accion = 'Afectar'
SET @Base = 'Todo'
INSERT INTO @TablaAfectar
EXECUTE spAfectar @Modulo, @ID, @Accion, @Base, @GenerarMov, @Usuario, @SincroFinal, @EnSilencio, @Ok OUTPUT, @OkRef OUTPUT, @FechaRegistro, @Conexion, @Estacion
END
IF @MovEstatus = 'PENDIENTE' AND @MovReservar = 1
BEGIN
SET @Accion = 'Reservar'
SET @Base = 'Pendiente'
INSERT INTO @TablaAfectar EXECUTE spAfectar @Modulo, @ID, @Accion, @Base, @GenerarMov, @Usuario, @SincroFinal, @EnSilencio, @Ok OUTPUT, @OkRef OUTPUT, @FechaRegistro, @Conexion, @Estacion
END
BEGIN TRY
SELECT @MovIdLog = MovID, @EstatusLog = Estatus FROM Inv WHERE ID = @ID
SET @Observacion = ''
INSERT INTO DistInvLog(Empresa,Sucursal,Usuario,Corrida,Estacion,Almacen,AlmacenDestino,Reservar,InvID,InvMov,InvMovId,Estatus,FechaLog,Observacion)
VALUES(@Empresa,@Sucursal,@Usuario,@Estacion,@Corrida,@Almacen,@AlmacenDestino,@MovReservar,@ID,@Mov,@MovIdLog,@EstatusLog,GETDATE(),@Observacion)
UPDATE Distribucion SET Procesado = 1, FechaProcesado = @FechaHoy
WHERE Empresa = @Empresa AND Corrida = @Corrida AND Almacen = Almacen AND AlmacenDestino = @AlmacenDestino
END TRY
BEGIN CATCH
SET @Observacion = 'Error en ' + ERROR_PROCEDURE() + ': ' + ERROR_MESSAGE()
INSERT INTO DistInvLog(Empresa,Sucursal,Usuario,Estacion,Corrida,Almacen,AlmacenDestino,Reservar,InvID,InvMov,InvMovId,Estatus,FechaLog,Observacion)
VALUES(@Empresa,@Sucursal,@Usuario,@Estacion,@Corrida,@Almacen,@AlmacenDestino,@MovReservar,@ID,@Mov,@MovIdLog,@EstatusLog,GETDATE(),@Observacion)
END CATCH
SET @Generados = @Generados + 1
SET @idx = @idx + 1
END
SELECT @Generados
END

