SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarVentaLote
@Empresa		varchar(5),
@Usuario		varchar(10),
@Estacion		varchar(20),
@CteCat			varchar(20),
@CteFam			varchar (50),
@CteGpo			varchar (50),
@Ok             int			= NULL  OUTPUT,
@OkRef          varchar(255)= NULL  OUTPUT,
@Verificar			bit

AS
BEGIN
DECLARE @Mensaje		varchar(100),
@ID				int,
@Renglon    	float,
@RenglonSub    	int,
@RenglonID		int,
@Cliente		varchar(10),
@SucCte			int,
@NombreSucCte	varchar(100),
@Articulo		varchar(20),
@Precio			float,
@Impuesto		float,
@ImpuestoD		float,
@Mov			varchar(20),
@Almacen		varchar(10),
@Categoria		varchar(20),
@Familia		varchar (50),
@Grupo			varchar (50),
@Concepto		varchar (50),
@CicloEsc		varchar(10),
@Condicion		varchar(50),
@FechaEmision	datetime,
@FechaEmisionA	datetime,
@ContUso		varchar(20),
@CopiarEnTiempo	bit,
@AplicaDesc		bit,
@FechaD			datetime,
@FechaA			datetime,
@Unidad			varchar(20),
@Dcto			varchar(30),
@DctoGlobal		float,
@TiempoUnidad	varchar(50),
@Cont			int,
@Contcr			int
IF RTRIM(@CteCat) IN ('', '(TODOS)', 'NULL', 'TODOS') SELECT @CteCat = NULL
IF RTRIM(@CteFam) IN ('', '(TODOS)', 'NULL', 'TODOS') SELECT @CteFam = NULL
IF RTRIM(@CteGpo) IN ('', '(TODOS)', 'NULL', 'TODOS') SELECT @CteGpo = NULL
IF @Verificar = 1
BEGIN
IF NOT EXISTS
(SELECT DISTINCT c.Cliente
FROM cte c
 WITH(NOLOCK) JOIN CteEnviarA cea  WITH(NOLOCK) ON c.Cliente = cea.Cliente
JOIN VentaLotes	v ON cea.Categoria = CASE @CteCat WHEN NULL THEN ISNULL(cea.Categoria,'') ELSE ISNULL(v.Categoria,'') END
AND cea.Familia = CASE @CteFam WHEN NULL THEN ISNULL(cea.Familia,'') ELSE ISNULL(v.Familia,'') END
AND cea.Grupo = CASE @CteGpo WHEN NULL THEN ISNULL(cea.Grupo,'') ELSE ISNULL(v.Grupo,'') END
WHERE ISNULL(cea.Categoria, '') = CASE @CteCat WHEN NULL THEN ISNULL(cea.Categoria, '') ELSE @CteCat END AND
ISNULL(cea.Grupo, '') = CASE @CteGpo WHEN NULL THEN ISNULL(cea.Grupo, '') ELSE @CteGpo END AND
ISNULL(cea.Familia, '') = CASE @CteFam WHEN NULL THEN ISNULL(cea.Familia, '') ELSE @CteFam END
AND v.Estacion = @Estacion)
BEGIN
DELETE FROM VentaLotesAux WHERE Estacion = @Estacion
SELECT @Mensaje = 'No Existen Sucursales de Clientes con esas Agrupaciones'
RAISERROR (@Mensaje, 16, -1)
RETURN
END
DELETE FROM VentaLotesAux WHERE Estacion = @Estacion
INSERT INTO VentaLotesAux
(Estacion,  Cliente,  Sucursal, NombreSucCte, Articulo,   Mov,    Almacen,     Categoria,     Familia,
Grupo,     Concepto,    CicloEsc,    Condicion,    FechaEmision,    ContUso,    CopiarEnTiempo,    AplicaDesc,
FechaD, FechaA, Unidad)
SELECT vl.Estacion, c.Cliente, cea.ID, cea.Nombre, vl.Articulo, vl.Mov, vl.Almacen, cea.Categoria, cea.Familia,
cea.Grupo, vl.Concepto, vl.CicloEsc, vl.Condicion, vl.FechaEmision, vl.ContUso, vl.CopiarEnTiempo, vl.AplicaDesc,
vl.FechaD, vl.FechaA, vl.Unidad
FROM CteEnviarA cea
 WITH(NOLOCK) JOIN cte c  WITH(NOLOCK) ON cea.Cliente = c.Cliente
LEFT OUTER JOIN VentaLotes vl  WITH(NOLOCK) ON cea.Categoria = CASE @CteCat WHEN NULL THEN ISNULL(cea.Categoria,'') ELSE ISNULL(vl.Categoria,'') END
AND cea.Familia = CASE @CteFam WHEN NULL THEN ISNULL(cea.Familia,'') ELSE ISNULL(vl.Familia,'') END
AND cea.Grupo = CASE @CteGpo WHEN NULL THEN ISNULL(cea.Grupo,'') ELSE ISNULL(vl.Grupo,'') END
WHERE cea.Categoria = CASE @CteCat WHEN NULL THEN ISNULL(cea.Categoria, '') ELSE @CteCat END
AND cea.Grupo = CASE @CteGpo WHEN NULL THEN ISNULL(cea.Grupo, '') ELSE @CteGpo END
AND cea.Familia = CASE @CteFam WHEN NULL THEN ISNULL(cea.Familia, '') ELSE @CteFam END
AND vl.Estacion = @Estacion
SELECT @Mensaje = 'Agrupaciones Correctas'
SELECT @Mensaje
RETURN
END
ELSE
BEGIN
IF NOT EXISTS
(SELECT DISTINCT c.Cliente
FROM cte c
 WITH(NOLOCK) JOIN CteEnviarA cea  WITH(NOLOCK) ON c.Cliente = cea.Cliente
JOIN VentaLotes	v ON cea.Categoria = CASE @CteCat WHEN NULL THEN ISNULL(cea.Categoria,'') ELSE ISNULL(v.Categoria,'') END
AND cea.Familia = CASE @CteFam WHEN NULL THEN ISNULL(cea.Familia,'') ELSE ISNULL(v.Familia,'') END
AND cea.Grupo = CASE @CteGpo WHEN NULL THEN ISNULL(cea.Grupo,'') ELSE ISNULL(v.Grupo,'') END
WHERE ISNULL(cea.Categoria, '') = CASE @CteCat WHEN NULL THEN ISNULL(cea.Categoria, '') ELSE @CteCat END AND
ISNULL(cea.Grupo, '') = CASE @CteGpo WHEN NULL THEN ISNULL(cea.Grupo, '') ELSE @CteGpo END AND
ISNULL(cea.Familia, '') = CASE @CteFam WHEN NULL THEN ISNULL(cea.Familia, '') ELSE @CteFam END
AND v.Estacion = @Estacion)
BEGIN
SELECT @Mensaje = 'No se ha Generado la Venta por Lotes o es Incorrecta, Imposible Afectar'
RAISERROR (@Mensaje, 16, -1)
RETURN
END
SELECT @Cont = 0, @Contcr = 0
IF (SELECT DISTINCT CopiarEnTiempo FROM VentaLotesAux WITH(NOLOCK) WHERE Estacion = @Estacion) = 1
BEGIN
SELECT DISTINCT @TiempoUnidad = Unidad FROM VentaLotesAux WHERE Estacion = @Estacion
SELECT DISTINCT @FechaD = FechaD FROM VentaLotesAux WHERE Estacion = @Estacion
SELECT DISTINCT @FechaA = FechaA FROM VentaLotesAux WHERE Estacion = @Estacion
SELECT @FechaEmisionA = @FechaD
WHILE @FechaEmisionA <= @FechaA
BEGIN
SELECT @Cont = @Cont + 1
IF @TiempoUnidad = 'dias' SELECT @FechaEmisionA = DATEADD(day, 1, @FechaEmisionA) ELSE
IF @TiempoUnidad = 'semanas' SELECT @FechaEmisionA = DATEADD(week, 1, @FechaEmisionA) ELSE
IF @TiempoUnidad = 'a�os'    SELECT @FechaEmisionA = DATEADD(year, 1, @FechaEmisionA)
ELSE SELECT @FechaEmisionA = DATEADD(month, 1, @FechaEmisionA)
END
END
DECLARE crVentaLotes CURSOR FOR
SELECT Cliente,Sucursal,NombreSucCte,Articulo,Mov,Almacen,Categoria,Familia,Grupo,Concepto,CicloEsc,Condicion,FechaEmision,ContUso,CopiarEnTiempo,AplicaDesc,FechaD,FechaA,Unidad
FROM VentaLotesAux WITH(NOLOCK)
WHERE  Estacion = @Estacion
OPEN crVentaLotes
FETCH NEXT FROM crVentaLotes  INTO @Cliente,@SucCte,@NombreSucCte,@Articulo,@Mov,@Almacen,@Categoria,@Familia,@Grupo,@Concepto,@CicloEsc,@Condicion,@FechaEmision,@ContUso,@CopiarEnTiempo,@AplicaDesc,@FechaD,@FechaA,@Unidad
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Dcto = NULL,@DctoGlobal = 0
SELECT @Precio = PrecioLista FROM Art WITH(NOLOCK) WHERE Articulo = @Articulo
SELECT @Impuesto = Impuesto1 FROM Art WHERE Articulo = @Articulo
SELECT @Impuesto = (@Precio*@Impuesto)/100
SELECT @ImpuestoD = Impuesto1 FROM Art WHERE Articulo = @Articulo
IF ISNULL(@AplicaDesc,0) = 1
SELECT @Dcto = ISNULL(d.Descuento, ''),@DctoGlobal = ISNULL(d.Porcentaje, 0)
FROM cte c
 WITH(NOLOCK) JOIN CteEnviarA cea  WITH(NOLOCK) ON c.Cliente = cea.Cliente
LEFT OUTER JOIN Descuento d  WITH(NOLOCK) ON d.Descuento = cea.Descuento
WHERE cea.ID = @SucCte and c.Cliente = @Cliente
INSERT INTO Venta(Empresa,  Mov,MovID,FechaEmision, Concepto,Moneda,TipoCambio,Usuario,  Estatus,  Directo,Prioridad,RenglonID,Cliente,EnviarA,Almacen, FechaRequerida,OrdenCompra,Condicion, Vencimiento,  Importe,Impuestos,Descuento,DescuentoGlobal,ServicioGarantia,ServicioExpress,ServicioDemerito,ServicioDeducible,ServicioFlotilla,ServicioRampa,Extra,ListaPreciosEsp,Sucursal,SucursalOrigen,GenerarOP,ConVigencia,DesglosarImpuestos,DesglosarImpuesto2,ExcluirPlaneacion,SubModulo,Comentarios,Extra1,SucursalVenta,AF,FordVisitoOASIS,ServicioPuntual,TieneTasaEsp)
VALUES(@Empresa,@Mov,NULL,@FechaEmision,          @Concepto,'Pesos',1.0,     @Usuario,'SINAFECTAR',1,     'Normal',   1,    @Cliente,@SucCte,@Almacen,@FechaEmision,  @CicloEsc, @Condicion,@FechaEmision,@Precio,@Impuesto, @Dcto,     @DctoGlobal,        0,             0,               0,              0,                0,                 0,         0,'(Precio Lista)', @SucCte,  @SucCte,        0,          0,        0,                   0,                 0,             'VTAS',     '',       0,     @SucCte,    0,  0,                 0,              0)
SELECT @ID = MAX(ID) FROM Venta
SELECT @Renglon = MAX(Renglon) FROM VentaD WHERE ID = @ID
SELECT @Renglon = ISNULL(@Renglon,0) + 1024
INSERT INTO VentaD(ID,Renglon,RenglonSub,RenglonID,RenglonTipo,EnviarA,Almacen,Articulo,Cantidad,Precio,PrecioSugerido,DescuentoTipo,DescuentoImporte,Impuesto1,Impuesto2,Impuesto3,CantidadReservada,Unidad,Factor,FechaRequerida,UltimoReservadoCantidad,Sucursal,SucursalOrigen,PrecioMoneda,PrecioTipoCambio,ExcluirPlaneacion,ExcluirISAN,PresupuestoEsp)
VALUES(@ID,@Renglon,0,1,'N',1,@Almacen,@Articulo,1.0,@Precio,@Precio,NULL,NULL,@ImpuestoD,0.0,0.0,1,'pza',1.0,@FechaEmision,1,@SucCte,0,'Pesos',1.0,0,0,0)
EXEC spAfectar 'VTAS',@ID, 'VERIFICAR', 'Todo', @Usuario = @Usuario, @Estacion = @Estacion, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef= @Okref OUTPUT
IF @Ok BETWEEN 80000 AND 80050
SELECT @Ok = NULL
IF @Ok IS NULL
EXEC spAfectar 'VTAS',@ID, 'AFECTAR', 'Todo', NULL, @Usuario = @Usuario, @Estacion = @Estacion, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef= @Okref OUTPUT
IF @Ok IS NOT NULL
BEGIN
SELECT @Mensaje = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
RAISERROR(@Mensaje, 16, -1)
END
ELSE
BEGIN
IF ISNULL(@CopiarEnTiempo, 0) = 1
EXEC spMovCopiarMeses @SucCte,'VTAS',@ID,@Usuario,@FechaD,@FechaA,1,@Unidad,1
END
SELECT @Contcr = @Contcr + 1
FETCH NEXT FROM crVentaLotes  INTO @Cliente,@SucCte,@NombreSucCte,@Articulo,@Mov,@Almacen,@Categoria,@Familia,@Grupo,@Concepto,@CicloEsc,@Condicion,@FechaEmision,@ContUso,@CopiarEnTiempo,@AplicaDesc,@FechaD,@FechaA,@Unidad
END
CLOSE crVentaLotes
DEALLOCATE crVentaLotes
DELETE FROM VentaLotes WHERE Estacion = @Estacion
DELETE FROM VentaLotesAux WHERE Estacion = @Estacion
SELECT @Cont = @Cont * @Contcr
IF @Cont = 0
SELECT @Mensaje = 'Proceso Concluido'
ELSE
SELECT @Mensaje = 'Proceso Concluido, Movimientos Generados: ' + RTRIM(Convert(char, @Cont))
SELECT @Mensaje
RETURN
END
RETURN
END

