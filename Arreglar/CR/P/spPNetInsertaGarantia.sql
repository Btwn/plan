SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC dbo.spPNetInsertaGarantia
@Usuario				 varchar(10),
@Cliente	             varchar(10),
@ServicioArticulo		 varchar(20),
@ServicioSerie			 varchar(50),
@ServicioTipo		     varchar(50), 
@ServicioTipoOperacion	 varchar(50), 
@Comentarios            varchar(max)
AS BEGIN
DECLARE
/* Datos que va a regresar el SP */
@Ok                 int,
@OkRef              varchar(255),
@ID                 int,
@Ruta               varchar(max),
@NombreArch         varchar(max),
@Empresa            varchar(5),
@Agente		     varchar(10),
@Mov                varchar(20),
@Moneda             varchar(15),
@TipoCambio         float,
@FechaEmision       datetime,
@Almacen	         varchar(10),
@Sucursal	         int,
@DefArticulo        varchar(20),
@Renglon            float,
@RenglonSub         int,
@RenglonID          int,
@RenglonTipo        varchar(1),
@Cantidad           float,
@Tipo               varchar(20),
@Unidad             varchar(50),
@Impuesto1          float,
@Factor             float,
@PrecioMoneda       varchar(50),
@PrecioTipoCambio   float,
@ServicioTipoOrden	 varchar(20), 
@TipoAlmacen		 varchar(15),
@EnGarantia	     bit,
@ConVigencia        bit,
@VigenciaDesde      datetime,
@VigenciaHasta      datetime,
@ServicioSerieO     varchar(50),
@Serie				 varchar(20),
@Folio				 bigint,
@MovID				 varchar(20)
/* Obtener valor por omision */
SELECT @FechaEmision = dbo.fnFechaSinHora(GETDATE())
SELECT @Moneda = DefMoneda, @Almacen = DefAlmacen, @Mov = DefMovVentas, @Agente = DefAgente FROM Usuario WHERE Usuario = @Usuario
SELECT @TipoCambio = TipoCambio FROM Mon WHERE Moneda = @Moneda
SELECT @Sucursal = SucursalEmpresa, @DefArticulo = ArticuloDef FROM Agente WHERE Agente = @Agente
SELECT TOP 1 @Empresa = ud.Empresa FROM UsuarioD ud JOIN Empresa e ON ud.Empresa = e.Empresa WHERE ud.Usuario = @Usuario
SELECT TOP 1 @ServicioTipoOrden = TipoOrden FROM ServicioTipoOrden
SELECT @TipoAlmacen = Tipo FROM Alm WHERE Almacen = @Almacen
/* Validar el tipo de Almacen para saber si está en Garantía o no */
IF ISNULL(@TipoAlmacen,'') = 'Garantias' SELECT @EnGarantia = 1 ELSE SELECT @EnGarantia = 0
/* Obtener la vigencia del movimiento original de venta del articulo */
SELECT @ConVigencia = v.ConVigencia, @VigenciaDesde = v.VigenciaDesde, @VigenciaHasta = v.VigenciaHasta, @ServicioSerieO = s.SerieLote
FROM Venta v JOIN MovTipo mt ON 'VTAS' = mt.Modulo AND v.Mov = mt.Mov
JOIN VentaD vd ON v.ID = vd.ID
JOIN SerieLoteMov s ON v.Empresa = s.Empresa AND 'VTAS' = s.Modulo AND v.ID = s.ID AND vd.Articulo = s.Articulo
WHERE v.Empresa = @Empresa AND v.Estatus NOT IN ('SIANFECTAR', 'CANCELADO')
AND v.Cliente = @Cliente AND mt.Clave = 'VTAS.F' AND vd.Articulo = @ServicioArticulo AND s.SerieLote =  @ServicioSerie
IF ISNULL(@Empresa, '') = '' OR NOT EXISTS ( SELECT 1 FROM Empresa WHERE Empresa = @Empresa )
SELECT @Ok = 1, @OkRef = 'Empresa Incorrecta'
/* Validar datos que vienen del usuario */
ELSE IF ISNULL(@Cliente, '') = '' OR NOT EXISTS ( SELECT 1 FROM Cte WHERE Cliente = @Cliente )
SELECT @Ok = 1, @OkRef = 'Cliente Incorrecto'
ELSE IF ISNULL(@Usuario, '') = '' OR NOT EXISTS ( SELECT 1 FROM Usuario WHERE Usuario = @Usuario )
SELECT @Ok = 1, @OkRef = 'Usuario Incorrecto'
ELSE IF ISNULL(@Agente, '') = '' OR NOT EXISTS ( SELECT 1 FROM Agente WHERE Agente = @Agente )
SELECT @Ok = 1, @OkRef = 'Falta Configurar el Agente'
ELSE IF NOT EXISTS ( SELECT 1 FROM AgenteCte WHERE Agente = @Agente AND Cliente =  @Cliente )
SELECT @Ok = 1, @OkRef = 'El Cliente no corresponde al Agente'
ELSE IF ISNULL(@ServicioArticulo,'') = '' OR NOT EXISTS ( SELECT 1 FROM Art WHERE Articulo = @ServicioArticulo AND Tipo IN ('Serie', 'VIN') AND Estatus = 'ALTA')
SELECT @Ok = 1, @OkRef = 'Artículo de Servicio Incorrecto'
ELSE IF ISNULL(@ServicioSerie,'') = '' OR NOT EXISTS ( SELECT 1 FROM VIN WHERE VIN = @ServicioSerie AND Articulo = @ServicioArticulo ) OR NOT EXISTS
( SELECT 1 FROM SerieLote WHERE Articulo = @ServicioArticulo AND SerieLote = @ServicioSerie )
SELECT @Ok = 1, @OkRef = '# Serie/VIN Incorrecto'
/* Validar si el movimiento original de venta tenía vigencia */
ELSE IF ISNULL(@ServicioSerieO,'') <> ISNULL(@ServicioSerie,'')
SELECT @Ok = 1, @OkRef = 'La Serie/VIN no pertenece al Cliente'
ELSE IF ISNULL(@ConVigencia,0) = 1
BEGIN
IF @FechaEmision < @VigenciaDesde OR @FechaEmision > @VigenciaHasta
SELECT @Ok = 1, @OkRef = 'La Vigencia de la Garantía ha expirado'
END
ELSE IF ISNULL(@ConVigencia, 0) = 0
SELECT @Ok = 1, @OkRef = 'No se encuentra con Garantía'
ELSE IF NOT EXISTS ( SELECT 1 FROM ServicioTipo WHERE Tipo = ISNULL(@ServicioTipo,'') )
SELECT @Ok = 1, @OkRef = 'Tipo Servicio Incorrecto'
ELSE IF NOT EXISTS ( SELECT 1 FROM ServicioTipoOperacion WHERE TipoOperacion = ISNULL(@ServicioTipoOperacion,'') )
SELECT @Ok = 1, @OkRef = 'Tipo Operación Incorrecta'
/* Validar datos que vienen de la configuración */
ELSE IF ISNULL(@Moneda,'') = '' OR NOT EXISTS ( SELECT 1 FROM Mon WHERE Moneda = @Moneda )
SELECT @Ok = 1, @OkRef = 'Moneda Incorrecta'
ELSE IF ISNULL(@Almacen,'') = '' OR NOT EXISTS ( SELECT 1 FROM Alm WHERE Almacen = @Almacen )
SELECT @Ok = 1, @OkRef = 'Almacén Incorrecto'
ELSE IF ISNULL(@Mov,'') = ''  OR NOT EXISTS ( SELECT 1 FROM MovTipo WHERE Modulo = 'VTAS' AND Mov = @Mov )
SELECT @Ok = 1, @OkRef = 'Falta Configurar el Movimiento'
ELSE IF ISNULL(@Sucursal,-1) = -1 OR NOT EXISTS ( SELECT 1 FROM Sucursal WHERE Sucursal = @Sucursal )
SELECT @Ok = 1, @OkRef = 'Falta Configurar la Sucursal'
ELSE IF ISNULL(@DefArticulo,'') = '' OR NOT EXISTS ( SELECT 1 FROM Art WHERE Articulo = @DefArticulo )
SELECT @Ok = 1, @OkRef = 'Falta Configurar el Artículo'
ELSE IF ISNULL(@Empresa, '') = ''
SELECT @Ok = 1, @OkRef = 'Falta Especificar la Empresa'
IF @Ok IS NULL
BEGIN
/* Insertar el encabezado */
INSERT INTO Venta(Empresa, Sucursal, Mov, FechaEmision, Moneda, TipoCambio, Usuario, Estatus, Cliente,
Almacen, Agente, ServicioTipo, ServicioArticulo, ServicioSerie, ServicioTipoOrden, ServicioTipoOperacion, Comentarios, ServicioGarantia,
ConVigencia, VigenciaDesde, VigenciaHasta)
SELECT @Empresa, @Sucursal, @Mov, @FechaEmision, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', @Cliente,
@Almacen, @Agente, @ServicioTipo, @ServicioArticulo, @ServicioSerie, @ServicioTipoOrden, @ServicioTipoOperacion, @Comentarios, @EnGarantia,
@ConVigencia, @VigenciaDesde, @VigenciaHasta
SELECT @ID = SCOPE_IDENTITY(), @Renglon = 2048, @RenglonSub = 0, @Cantidad = 1, @RenglonID = 1
SELECT @Tipo = Tipo, @Unidad = Unidad, @Impuesto1 = Impuesto1, @PrecioMoneda = MonedaPrecio FROM Art WHERE Articulo = @DefArticulo
SELECT @Factor = Factor FROM Unidad WHERE Unidad = @Unidad
SELECT @PrecioTipoCambio = TipoCambio FROM Mon WHERE Moneda = @Moneda
EXEC spRenglonTipo @Tipo, NULL, @RenglonTipo OUTPUT
IF ISNULL(@DefArticulo,'') = '' OR NOT EXISTS ( SELECT 1 FROM Art WHERE Articulo = @DefArticulo)
SELECT @Ok = 1, @OkRef = 'Artículo por Omisión Incorrecto'
IF @Ok IS NULL
BEGIN
/* Insertar el detalle */
INSERT INTO VentaD(ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Cantidad, Almacen, Articulo, Impuesto1,
Precio, Unidad, Factor, CantidadInventario, Agente, PrecioMoneda, PrecioTipoCambio)
SELECT @ID, @Renglon, @RenglonSub, @RenglonID, @RenglonTipo, @Cantidad, @Almacen, @DefArticulo, @Impuesto1,
0.0, @Unidad, @Factor, @Factor*@Cantidad, @Agente, @PrecioMoneda, @PrecioTipoCambio
/* Afectar el movimiento */
EXEC spAfectar 'VTAS', @ID, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion=@@SPID, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
/* Obtener la ruta para guardar los anexos */
END
END
SELECT @Mov = Mov, @Cliente = Cliente, @MovID = MovID FROM Venta WHERE ID = @ID
SELECT @Ruta = DirectorioAnexosEsp
FROM EmpresaGral WHERE Empresa = @Empresa
EXEC spMovIDEnSerieConsecutivo @MovID, @Serie OUTPUT, @Folio OUTPUT
SELECT @Ruta = REPLACE(@Ruta, '<Cliente>', @Cliente)
SELECT @Ruta = REPLACE(@Ruta, '<Ejercicio>', CONVERT(varchar, YEAR(GETDATE())))
SELECT @Ruta = REPLACE(@Ruta, '<Periodo>', CONVERT(varchar, MONTH(GETDATE())))
SELECT @Ok Ok, @OkRef OkRef, @ID ID, @Ruta Ruta
RETURN
END

