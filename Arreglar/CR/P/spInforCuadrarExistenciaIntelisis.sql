SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spInforCuadrarExistenciaIntelisis
@Empresa   varchar(5),
@Usuario   varchar(20),
@Sucursal  int,
@Estacion  int

AS
BEGIN
DECLARE
@Articulo         varchar(20),
@Cantidad         float,
@Moneda                          varchar(10),
@TipoCambio                   float,
@Unidad           varchar(50),
@SerieLote        varchar(50),
@SubCuenta        varchar(50),
@Factor           float,
@MovEnt           varchar(20),
@MovSal           varchar(20),
@Tipo             varchar(20),
@EntID            int,
@SalID            int,
@Renglon                          float   ,
@RenglonSub                  int   ,
@RenglonID                      int   ,
@UltRenglonID     int,
@Almacen          varchar(20),
@AlmacenU         varchar(20),
@RenglonTipo      varchar(20),
@ExistenciaI      float,
@Costo            float,
@Ok               int,
@OkRef            varchar(255),
@CfgCompraCostoSugerido       varchar(20),
@CfgPosiciones    bit,
@Posicion         varchar(50)
IF EXISTS (SELECT * FROM IntelisisService WHERE Referencia  IN (
'Intelisis.Cuenta.Alm.Listado',
'Intelisis.Interfaz.Infor.Transferencia.Alm',
'Intelisis.Cuenta.CteTipo.Listado',
'Intelisis.Interfaz.Infor.Transferencia.CteTipo',
'Intelisis.Cuenta.Mon.Listado',
'Intelisis.Interfaz.Infor.Transferencia.Mon',
'Intelisis.Interfaz.Infor.Transferencia.Prov',
'Intelisis.Cuenta.Prov.Listado',
'Intelisis.Cuenta.Articulo.Listado',
'Intelisis.Cuenta.Usuario.Listado',
'Intelisis.Interfaz.Infor.Transferencia.Art',
'Intelisis.Interfaz.Infor.Transferencia.ArtContadorLotes',
'Intelisis.Interfaz.Infor.Transferencia.Usuario',
'Intelisis.Cuenta.ArtFam.Listado',
'Intelisis.Interfaz.Infor.Transferencia.ArtFam',
'Intelisis.Cuenta.Departamento.Listado',
'Intelisis.Interfaz.Infor.Transferencia.Departamento',
'Intelisis.Cuenta.Empresa.Listado',
'Intelisis.Interfaz.Infor.Transferencia.Empresa',
'Intelisis.COMS.Mov.Listado',
'Intelisis.Interfaz.Infor.Transferencia.COMS_F',
'Intelisis.Interfaz.Infor.Transferencia.COMS_O',
'Intelisis.Interfaz.Infor.Transferencia.COMS_OC',
'Intelisis.VTAS.Mov.Listado',
'Intelisis.Interfaz.Infor.Transferencia.VTAS_P',
'Intelisis.Interfaz.Infor.Transferencia.VTAS_PR',
'Intelisis.Cuenta.Cte.Listado',
'Intelisis.Interfaz.Infor.Transferencia.Cte',
'Intelisis.Cuenta.Unidad.Listado',
'Intelisis.Interfaz.Infor.Transferencia.Unidad',
'Intelisis.Cuenta.Personal.Listado',
'Intelisis.Interfaz.Infor.Transferencia.Personal',
'Intelisis.COMS.InsertarMov.COMS_O',
'Intelisis.Cuenta.Art.Insertar',
'Intelisis.INV.InsertarMov.INV_E',
'Intelisis.INV.InsertarMov.INV_S',
'Intelisis.Cuenta.Sucursal.Listado',
'Intelisis.Interfaz.Infor.Transferencia.Sucursal',
'Intelisis.Interfaz.Infor.Solicitud.ObjetivosVentas',
'Intelisis.Interfaz.Infor.Insertar.CancelacionMov',
'Intelisis.Cuenta.Planta.Usuario.Listado',
'Intelisis.Interfaz.Infor.Transferencia.PlantaUsuario',
'Intelisis.Cuenta.Planta.Listado',
'Intelisis.Interfaz.Infor.Transferencia.Planta',
'Intelisis.Cuenta.ArtLinea.Listado',
'Intelisis.Interfaz.Infor.Transferencia.ArtLinea',
'Intelisis.PC.InsertarMov.PC_C',
'Intelisis.Cuenta.MotivoRechazo.Listado',
'Intelisis.Interfaz.Infor.Transferencia.MotivoRechazo',
'Intelisis.Interfaz.Infor.Transferencia.OpcionDetalle',
'Intelisis.Interfaz.Infor.Transferencia.Opcion',
'Intelisis.INV.InsertarMov.NOM_P',
'Intelisis.Interfaz.Infor.CancelarMov',
'Infor.Movimiento.Procesar.COMS_OC',
'Infor.Movimiento.Procesar.COMS_O',
'Infor.Cuenta.Articulo.Mantenimiento',
'Infor.Cuenta.ArtContadorLotes.Mantenimiento',
'Infor.Cuenta.ArtLinea.Mantenimiento',
'Infor.Movimiento.Procesar.INV',
'Infor.Reporte.ObjetivosVentas',
'Infor.Cuenta.Cte.Mantenimiento',
'Infor.Cuenta.Usuario.Mantenimiento',
'Infor.Cuenta.Proveedor.Mantenimiento',
'Infor.Cuenta.Planta.Usuario.Mantenimiento',
'Infor.Movimiento.Procesar.VTAS_P',
'Infor.Cuenta.Art.Mantenimiento',
'Infor.Cuenta.Personal.Mantenimiento',
'Infor.Cuenta.Moneda.Mantenimiento',
'Infor.Cuenta.ArtFam.Mantenimiento',
'Infor.Movimiento.Procesar.COMS_F',
'Infor.Cuenta.MotivoRechazo.Mantenimiento',
'Infor.Cuenta.Unidad.Mantenimiento',
'Infor.Movimiento.Procesar.VTAS_PR',
'Infor.Cuenta.Planta.Mantenimiento',
'Infor.Movimiento.Procesar.COMS_OC',
'Infor.Cuenta.Empresa.Mantenimiento',
'Infor.Cuenta.CteTipo.Mantenimiento',
'Infor.Cuenta.Almacen.Mantenimiento',
'Infor.Cuenta.Opcion.Mantenimiento',
'Infor.Cuenta.OpcionDetalle.Mantenimiento')
AND Estatus IN ('SINPROCESAR') )SET @Ok = 2
IF @Ok IS NULL
BEGIN
SET @Ok = null
SELECT @Moneda = ContMoneda, @CfgCompraCostoSugerido = CompraCostoSugerido, @CfgPosiciones = ISNULL(Posiciones, 0)  FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @MovEnt= Mov FROM MovTipo WHERE Clave ='INV.E' AND Subclave ='INV.EA'
SELECT @MovSal= Mov FROM MovTipo WHERE Clave ='INV.S' AND Subclave ='INV.SA'
SELECT @TipoCambio = TipoCambio FROM Mon WHERE Moneda = @Moneda
BEGIN TRANSACTION
IF EXISTS(SELECT * FROM ArtExistenciaIntMES WHERE (ISNULL(ExistenciaMES,0.0)-ISNULL(ExistenciaInte,0.0))>0.0)
BEGIN
SELECT TOP 1 @AlmacenU = Almacen FROM ArtExistenciaIntMES
SELECT @Sucursal = Sucursal FROM Alm WHERE Almacen = @AlmacenU
INSERT Inv (Empresa,  Sucursal,  Mov,     Almacen,    FechaEmision, Estatus, Moneda, TipoCambio,Usuario)
SELECT      @Empresa, @Sucursal,@MovEnt,@AlmacenU, dbo.fnFechaSinHora(GETDATE()),'SINAFECTAR', @Moneda,ISNULL(@TipoCambio,1.0),@Usuario
SELECT @EntID = SCOPE_IDENTITY()
IF @@ERROR <> 0 SET @OK = 1
DECLARE crDetalle CURSOR LOCAL FAST_FORWARD FOR
SELECT e.Articulo ,e.SubCuenta , e.SerieLote , e.Almacen, ISNULL(e.ExistenciaMES,0.0)-ISNULL(e.ExistenciaInte,0.0),e.CostoMes
FROM ArtExistenciaIntMES e JOIN Alm a ON a.Almacen = e.Almacen
WHERE  (ISNULL(e.ExistenciaMES,0.0)-ISNULL(e.ExistenciaInte,0.0))>0.0
AND ISNULL(a.EsFactory,0) = 1
SET @Renglon = 0.0
SET @RenglonID = 0
OPEN crDetalle
FETCH NEXT FROM crDetalle INTO @Articulo,@SubCuenta,@SerieLote,@Almacen,@Cantidad,@Costo
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @Posicion = DefPosicionRecibo FROM Alm WHERE ISNULL(Ubicaciones,0) = 1 AND NULLIF(DefPosicionSurtido,'') IS NOT NULL AND Almacen = @Almacen
SET @Renglon = @Renglon + 2048.0
SET @RenglonID = @RenglonID + 1
SET @RenglonSub =0
SELECT @Tipo = Tipo ,@Unidad= Unidad FROM Art WHERE Articulo = @Articulo
SELECT @Factor= Factor FROM ArtUnidad WHERE Unidad = @Unidad
EXEC spRenglonTipo @Tipo, NULL, @RenglonTipo OUTPUT
EXEC spVerCosto @Sucursal, @Empresa, NULL, @Articulo, @SubCuenta, @Unidad, @CfgCompraCostoSugerido, @Moneda, 1.0, @Costo OUTPUT, 0
INSERT InvD ( ID,     Renglon,RenglonID,RenglonTipo, RenglonSub, Sucursal, Almacen, Articulo, SubCuenta, Cantidad, Unidad, Factor,CantidadInventario,Costo, Posicion)
SELECT @EntID, @Renglon,@RenglonID,@RenglonTipo, @RenglonSub,@Sucursal, @Almacen, @Articulo, ISNULL(@SubCuenta,''), @Cantidad, @Unidad, @Factor ,@Cantidad*ISNULL(@Factor,1),ISNULL(@Costo,0.0), @Posicion
IF @SerieLote IS NOT NULL  AND @Tipo  IN ('Lote','Serie')
BEGIN
SELECT @UltRenglonID = ISNULL(MAX(RenglonID), 0) FROM InvD WHERE ID = @EntID AND Articulo=@Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'') AND Cantidad = @Cantidad
INSERT SerieLoteMov (Empresa,  Modulo, ID,          RenglonID,     Articulo,Cantidad,         SubCuenta,     SerieLote, Sucursal)
SELECT               @Empresa, 'INV',  @EntID, @UltRenglonID, @Articulo,@Cantidad, ISNULL(@SubCuenta,''), @SerieLote,@Sucursal
END
IF @@ERROR <> 0 SET @Ok = 1
FETCH NEXT FROM crDetalle INTO @Articulo,@SubCuenta,@SerieLote,@Almacen,@Cantidad,@Costo
END
CLOSE crDetalle
DEALLOCATE crDetalle
END
IF EXISTS(SELECT * FROM ArtExistenciaIntMES WHERE (ISNULL(ExistenciaMES,0.0)-ISNULL(ExistenciaInte,0.0))<0.0)
BEGIN
SELECT TOP 1 @AlmacenU = Almacen FROM ArtExistenciaIntMES
SELECT @Sucursal = Sucursal FROM Alm WHERE Almacen = @AlmacenU
INSERT Inv (Empresa,  Sucursal,  Mov,     Almacen,    FechaEmision, Estatus, Moneda, TipoCambio,Usuario)
SELECT      @Empresa, @Sucursal,@MovSal,@AlmacenU, dbo.fnFechaSinHora(GETDATE()),'SINAFECTAR', @Moneda,@TipoCambio,@Usuario
SELECT @SalID = SCOPE_IDENTITY()
IF @@ERROR <> 0 SET @OK = 1
DECLARE crDetalle2 CURSOR LOCAL FAST_FORWARD FOR
SELECT Articulo ,SubCuenta , SerieLote , Almacen, ISNULL(ExistenciaMES,0.0)-ISNULL(ExistenciaInte,0.0)
FROM ArtExistenciaIntMES
WHERE ISNULL(ExistenciaMES,0.0)-ISNULL(ExistenciaInte,0.0)<0.0
SET @Renglon = 0.0
SET @RenglonID = 0
OPEN crDetalle2
FETCH NEXT FROM crDetalle2 INTO @Articulo,@SubCuenta,@SerieLote,@Almacen,@Cantidad
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @Posicion = DefPosicionSurtido FROM Alm WHERE ISNULL(Ubicaciones,0) = 1 AND NULLIF(DefPosicionSurtido,'') IS NOT NULL AND Almacen = @Almacen
SELECT @Cantidad = @Cantidad*-1
SET @Renglon = @Renglon + 2048.0
SET @RenglonID = @RenglonID + 1
SET @RenglonSub =0
SET @Costo = 0.0
SELECT @Tipo = Tipo ,@Unidad= Unidad FROM Art WHERE Articulo = @Articulo
SELECT @Factor= Factor FROM ArtUnidad WHERE Unidad = @Unidad
EXEC spRenglonTipo @Tipo, NULL, @RenglonTipo OUTPUT
INSERT InvD ( ID,     Renglon,RenglonID,RenglonTipo, RenglonSub, Sucursal, Almacen, Articulo, SubCuenta, Cantidad, Unidad, Factor,CantidadInventario,Costo)
SELECT @SalID, @Renglon,@RenglonID,@RenglonTipo, @RenglonSub,@Sucursal, @Almacen, @Articulo, ISNULL(@SubCuenta,''), @Cantidad, @Unidad, @Factor ,@Cantidad*ISNULL(@Factor,1) ,@Costo
IF @SerieLote IS NOT NULL  AND @Tipo  IN ('Lote','Serie')
BEGIN
SELECT @UltRenglonID = ISNULL(MAX(RenglonID), 0) FROM InvD WHERE ID = @SalID AND Articulo=@Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'') AND Cantidad = @Cantidad
INSERT SerieLoteMov (Empresa,  Modulo, ID,          RenglonID,     Articulo,Cantidad,         SubCuenta,     SerieLote, Sucursal)
SELECT               @Empresa, 'INV',  @SalID, @UltRenglonID, @Articulo,@Cantidad, ISNULL(@SubCuenta,''), @SerieLote,@Sucursal
END
IF @@ERROR <> 0 SET @Ok = 1
FETCH NEXT FROM crDetalle2 INTO @Articulo,@SubCuenta,@SerieLote,@Almacen,@Cantidad
END
CLOSE crDetalle2
DEALLOCATE crDetalle2
END
IF @Ok IS NULL AND @EntID IS NOT NULL
BEGIN
EXEC spAfectar 'INV', @EntID, 'AFECTAR', 'Todo', NULL, @Usuario, NULL, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @EnSilencio = 1, @Conexion = 1, @Estacion = @Estacion
END
IF @Ok IS NULL AND @SalID IS NOT NULL
BEGIN
EXEC spAfectar 'INV', @SalID, 'AFECTAR', 'Todo', NULL, @Usuario, NULL, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @EnSilencio = 1, @Conexion = 1, @Estacion = @Estacion
END
IF @OK IS NOT NULL
BEGIN
SELECT @OkRef = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SELECT CONVERT(varchar,@ok)+'    '+@OkRef+'   '
END
ELSE
SELECT 'Los ajustes en el inventario pueden tardar algunos minutos en verse reflejados, por favor espere antes de verificar los resultados.'
IF @Ok IS NULL
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
END
IF @Ok = 2 SELECT 'Existen Tareas Por Procesar  No Se Puede  Cuadrar La Existencia'
RETURN
END

