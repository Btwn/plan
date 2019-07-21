SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISIntelisisTMAAfectarTMA_RADOPck
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max)	= NULL OUTPUT,
@Ok				int				= NULL OUTPUT,
@OkRef			varchar(255)	= NULL OUTPUT

AS BEGIN
DECLARE
@Texto						xml,
@ReferenciaIS				varchar(100),
@SubReferencia				varchar(100),
@Mov						varchar(20),
@MovID			            varchar(20),
@Empresa				    varchar(5),
@Sucursal			        int,
@Sucursal2					varchar(100),
@Tarima						varchar(20),
@TarimaDestino				varchar(20),
@Posicion					varchar(10),
@ArticuloEsp			    varchar(20),
@ArticuloDestino		    varchar(20),
@Descripcion1			    varchar(100),
@UnidadCompra				varchar(50),
@Cantidad			        float,
@Tipo						varchar(20),
@DescripcionPosicion		varchar(100),
@PosicionDestino			varchar(10),
@DescripcionPosicionDestino varchar(100),
@Completo                   int,
@Codigo					    varchar(50),
@Descripcion			    varchar(100),
@Almacen                    VARCHAR(20),
@Usuario			        varchar(20),
@Factor                     FLOAT,
@Unidad                     VARCHAR(20),
@Minimo                     FLOAT,
@Agente                     VARCHAR(20),
@PosicionD					varchar(10),
@Montacargas                varchar(20),
@IDAcceso					int,
@Estacion					int,
@CantidadPck                float,
@MovAjuste					varchar(20),
@RenglonID					float,
@RenglonID2					float,
@ContMoneda					varchar(10),
@RenglonTipo				varchar(1),
@ArtTipo					varchar(20),
@Costo						float,
@TipoCosteo					varchar(20),
@Concepto					varchar(50),
@Observaciones				varchar(100)
BEGIN TRANSACTION
SELECT @Estacion=@@SPID 
SELECT  @Sucursal2  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Sucursal'
SELECT  @Empresa  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Empresa'
SELECT  @Tarima  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Tarima'
SELECT  @Posicion  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Posicion'
SELECT  @PosicionD  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'PosicionD'
SELECT  @Usuario = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Usuario'
SELECT  @Montacargas = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Montacarga'
SELECT  @ArticuloEsp  = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Articulo'
SELECT  @CantidadPck = CONVERT(float, Valor) FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'CantidadPck'
SELECT @ContMoneda = ContMoneda ,
@TipoCosteo = ISNULL(NULLIF(RTRIM(UPPER(TipoCosteo)), ''), 'PROMEDIO')
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @Agente = DefAgente, @Almacen=DefAlmacen, @Sucursal = Sucursal FROM Usuario WHERE Usuario = @Usuario
SELECT @MovAjuste = 'Ajuste Posicion WMS'
SELECT @Concepto = Concepto FROM EmpresaConcepto WHERE Empresa = @Empresa AND Modulo = 'INV' AND Mov = @MovAjuste
IF @CantidadPck <= 0 SET @Ok=20010
SELECT @Tipo = Tipo,
@ArticuloDestino = ArticuloEsp
FROM AlmPos
WHERE Posicion = @PosicionD
AND Almacen = @Almacen
AND Estatus = 'ALTA'
SELECT @TarimaDestino = MIN(a.Tarima)
FROM ArtDisponibleTarima a
JOIN Tarima t ON t.Tarima = a.Tarima
JOIN AlmPos p ON p.Posicion = t.Posicion  AND p.Almacen = @Almacen
WHERE a.Articulo = @ArticuloDestino
AND p.Tipo = 'Domicilio'
AND a.Disponible > 0
AND t.Estatus = 'ALTA' AND t.Tarima NOT LIKE '%-%'
AND p.Posicion = @PosicionD
AND p.ArticuloEsp = @ArticuloDestino
IF @TarimaDestino IS NULL
SELECT @TarimaDestino = MIN(a.Tarima)
FROM ArtDisponibleTarima a
JOIN Tarima t ON t.Tarima = a.Tarima
JOIN AlmPos p ON p.Posicion = t.Posicion  AND p.Almacen = @Almacen
WHERE a.Articulo = @ArticuloDestino
AND p.Tipo = 'Domicilio'
AND t.Estatus = 'ALTA' AND t.Tarima NOT LIKE '%-%'
AND p.Posicion = @PosicionD
AND p.ArticuloEsp = @ArticuloDestino
IF @TarimaDestino IS NULL
SELECT @TarimaDestino = MIN(a.Tarima)
FROM ArtDisponibleTarima a
JOIN Tarima t ON t.Tarima = a.Tarima
JOIN AlmPos p ON p.Posicion = t.Posicion  AND p.Almacen = @Almacen
WHERE a.Articulo = @ArticuloDestino
AND p.Tipo = 'Domicilio'
AND t.Estatus = 'BAJA' AND t.Tarima NOT LIKE '%-%'
AND p.Posicion = @PosicionD
AND p.ArticuloEsp = @ArticuloDestino
IF @Ok IS NULL AND ISNULL(@Tipo, '') <> 'Domicilio' AND ISNULL(@Tipo, '') <> ''
SELECT @Ok=13035
IF @Ok IS NULL AND (@Tipo = 'Domicilio' AND ISNULL(@ArticuloDestino, '') <> ISNULL(@ArticuloEsp, ''))
SELECT @Ok=10530, @OkRef = @ArticuloEsp
SELECT @Factor = dbo.fnArtUnidadFactor(@Empresa, @ArticuloEsp, UnidadTraspaso),
@Minimo = MinimoTarima,
@ArtTipo = Tipo,
@Unidad = UnidadTraspaso
FROM Art a
WHERE a.Articulo = @ArticuloEsp
EXEC spRenglonTipo @ArtTipo, NULL, @RenglonTipo OUTPUT
EXEC spVerCosto @Sucursal, @Empresa, NULL, @ArticuloEsp, NULL, @Unidad, @TipoCosteo, @ContMoneda, 1, @Costo OUTPUT, 0
SELECT @Cantidad = Disponible/@Factor
FROM ArtDisponibleTarima /*WITH (NOLOCK)*/
WHERE Tarima = @Tarima
AND Almacen = @Almacen
AND Articulo = @ArticuloEsp
AND Empresa = @Empresa
IF (SELECT COUNT(*)
FROM TMA a
JOIN MovTipo ON a.Mov = MovTipo.Mov AND MovTipo.Modulo = 'TMA'
JOIN TMAD b /*WITH(NOLOCK)*/ ON a.ID = b.ID
WHERE MovTipo.Clave IN(/*'TMA.ADO', 'TMA.OADO', 'TMA.ORADO', 'TMA.RADO', */'TMA.OSUR', 'TMA.TSUR'/*, 'TMA.SADO', 'TMA.SRADO'*/)
AND a.Estatus = 'PENDIENTE'
AND b.Tarima = @Tarima
AND a.Almacen = @Almacen) > 0 AND @Ok IS NULL
SELECT @Ok=13077
IF @Ok IS NULL AND (SELECT COUNT(*)
FROM TMA a
JOIN MovTipo ON a.Mov = MovTipo.Mov AND MovTipo.Modulo = 'TMA'
JOIN TMAD b /*WITH(NOLOCK)*/ ON a.ID = b.ID
WHERE MovTipo.Clave IN('TMA.ADO', 'TMA.OADO', 'TMA.ORADO', 'TMA.RADO', 'TMA.SADO', 'TMA.SRADO')
AND a.Estatus = 'PENDIENTE'
AND ISNULL(b.Procesado, 0) = 0
AND b.Tarima = @Tarima
AND a.Almacen = @Almacen) > 0 AND @Ok IS NULL
SELECT @Ok=13077
IF @Ok IS NULL AND NOT EXISTS(SELECT ISNULL(Posicion,'') FROM AlmPos WHERE Posicion=@PosicionD AND Almacen = @Almacen) SELECT @Ok=13030, @OkRef = @PosicionD
IF @Ok IS NULL AND NOT EXISTS(SELECT ISNULL(Posicion,'') FROM AlmPos WHERE Posicion=@Posicion AND Almacen = @Almacen) SELECT @Ok=13030, @OkRef = @Posicion
IF @Ok IS NULL AND @CantidadPCK > @Cantidad SELECT @Ok=20020, @OkRef = @ArticuloEsp
IF @CantidadPck = @Cantidad
SELECT @Observaciones = 'Reacomodo Tarima Completa'
ELSE
SELECT @Observaciones = 'Reacomodo Picking'
IF @Ok IS NULL
BEGIN
INSERT INTO Inv (
Empresa,  Mov,       FechaEmision,                  Moneda,      TipoCambio,  Usuario, Estatus,       Almacen,  Sucursal,  SucursalOrigen, Concepto,  Observaciones)
SELECT @Empresa, @MovAjuste, dbo.fnFechaSinHora(GETDATE()), @ContMoneda, 1,          @Usuario, 'SINAFECTAR', @Almacen, @Sucursal, @Sucursal,      @Concepto, @Observaciones
SET @ID = @@IDENTITY
INSERT INTO InvD (
ID, Renglon, RenglonSub, RenglonID, RenglonTipo,  Cantidad,     Almacen,  Articulo,     Costo,  Unidad,  Factor,  CantidadInventario,   Sucursal,  SucursalOrigen,  Tarima,         PosicionActual,  PosicionReal)
SELECT @ID, 2048,    0,          1,        @RenglonTipo, @CantidadPck, @Almacen, @ArticuloEsp, @Costo, @Unidad, @Factor, @CantidadPck*@Factor, @Sucursal, @Sucursal,       @TarimaDestino, @PosicionD,      @PosicionD
INSERT INTO InvD (
ID, Renglon, RenglonSub, RenglonID, RenglonTipo,   Cantidad,     Almacen,  Articulo,     Costo,  Unidad,  Factor,   CantidadInventario,   Sucursal,  SucursalOrigen,  Tarima,  PosicionActual, PosicionReal)
SELECT @ID, 2048,    1,          1,        @RenglonTipo, -@CantidadPck, @Almacen, @ArticuloEsp, @Costo, @Unidad, @Factor, -@CantidadPck*@Factor, @Sucursal, @Sucursal,       @Tarima, @Posicion,      @Posicion
EXEC spAfectar 'INV', @ID, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT ,@OkRef = @OkRef OUTPUT
IF @Ok BETWEEN 80030 AND 81000 OR @Ok IS NULL SELECT @Ok = NULL , @OkRef = RTRIM(Mov)+' '+RTRIM(MovID) FROM Inv WHERE ID = @ID
END
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
END
IF @Ok IS NOT NULL SELECT @Descripcion = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + ' Descripcion="' + ISNULL(@Descripcion,'') +'">' + CONVERT(varchar(max),ISNULL(@Texto,'')) + '</Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
END

