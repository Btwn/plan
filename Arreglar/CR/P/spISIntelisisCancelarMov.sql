SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISIntelisisCancelarMov
@ID                                   int,
@iSolicitud                           int,
@Version                              float,
@Resultado                            varchar(max) = NULL OUTPUT,
@Ok                                   int = NULL OUTPUT,
@OkRef                                varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@IDO                     int,
@IDInv                   int,
@IDI                     int,
@Estacion                int,
@IDAcceso                int,
@ReferenciaIS            varchar(100),
@Usuario2                varchar(10),
@SubReferencia           varchar(100),
@Empresa                 varchar(5),
@Sucursal                int,
@Mov                     varchar(20),
@MovID                   varchar(20),
@Modulo                  char(5)  ,
@CantidadA               float,
@ReferenciaMES           varchar(50),
@Estatus                 varchar(20),
@Estatus2                varchar(20),
@Cantidad                bit,
@Cantidad2               float,
@Renglon                 float,
@Articulo                varchar(20),
@CfgReservar             bit,
@Serie                   varchar(3),
@PedidoMES               varchar(20),
@IDVenta                 int,
@MovVenta                varchar(20),
@CantidadVenta           float,
@Reservar                bit,
@SubClave                varchar(20),
@MovInv                  varchar(20),
@SubCuenta               varchar(50)
DECLARE
@Tabla table(
ID int,
Estatus varchar(20))
BEGIN TRANSACTION
SELECT @IDAcceso = dbo.fnAccesoID(@@SPID)
SET @Cantidad=0
SELECT @Estacion = EstacionTrabajo ,@Usuario2 = Usuario FROM Acceso WHERE ID = @IDAcceso
SELECT  @Modulo= Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'Modulo'
SELECT  @ReferenciaMES = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'ReferenciaMES'
SELECT  @IDInv= Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Campo varchar(255), Valor varchar(255))
WHERE Campo = 'IDMarcaje'
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL
BEGIN
IF @Modulo = 'COMS'
INSERT INTO @Tabla(ID,Estatus)
SELECT ID,Estatus
FROM Compra
WHERE ReferenciaMES = @ReferenciaMES
IF @Modulo = 'INV'
INSERT INTO @Tabla(ID,Estatus)
SELECT ID,Estatus
FROM Inv
WHERE IDMarcaje = @IDInv
IF @Modulo = 'COMS' AND @Ok IS NULL
BEGIN
DECLARE crCompra CURSOR LOCAL FAST_FORWARD FOR
SELECT ID,Estatus
FROM @Tabla
OPEN crCompra
FETCH NEXT FROM crCompra INTO @IDO,@Estatus
WHILE @@FETCH_STATUS = 0
BEGIN
IF(SELECT Estatus FROM Compra WHERE ID =  @IDO)='CONCLUIDO' SET @Ok=46090
IF EXISTS(SELECT * FROM CompraD WHERE ID = @IDO AND  ISNULL(CantidadPendiente,0.0) <> ISNULL(Cantidad,0.0))
BEGIN
DECLARE crActualizar CURSOR LOCAL FAST_FORWARD FOR
SELECT Renglon,Articulo,CantidadPendiente
FROM CompraD
WHERE ID =@IDO
OPEN crActualizar
FETCH NEXT FROM crActualizar INTO @Renglon,@Articulo,@CantidadA
WHILE @@FETCH_STATUS = 0
BEGIN
UPDATE CompraD
SET CantidadA = @CantidadA
WHERE ID = @IDO AND Renglon = @Renglon AND Articulo =@Articulo
SET @Cantidad=1
FETCH NEXT FROM crActualizar INTO @Renglon,@Articulo,@CantidadA
END
CLOSE crActualizar
DEALLOCATE crActualizar
END
IF @Ok IS NULL AND @Cantidad=1 AND @IDO IS NOT NULL AND @Modulo = 'COMS'
EXEC spAfectar @Modulo, @IDO, 'CANCELAR', 'Seleccion', NULL, @Usuario2, NULL, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @EnSilencio = 1, @Conexion = 1, @Estacion = @Estacion
IF @Ok IS NULL AND @Cantidad=0 AND @IDO IS NOT NULL AND @Modulo = 'COMS'
EXEC spAfectar @Modulo, @IDO, 'CANCELAR', 'Todo', NULL, @Usuario2, NULL, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @EnSilencio = 1, @Conexion = 1, @Estacion = @Estacion
FETCH NEXT FROM crCompra INTO @IDO,@Estatus
END
CLOSE crCompra
DEALLOCATE crCompra
END
IF @Modulo = 'INV'
BEGIN
DECLARE crActualizar2 CURSOR LOCAL FAST_FORWARD FOR
SELECT ID,Estatus
FROM @Tabla
OPEN crActualizar2
FETCH NEXT FROM crActualizar2 INTO @IDI,@Estatus2
WHILE @@FETCH_STATUS = 0
BEGIN
IF NOT EXISTS(SELECT * FROM Inv WHERE ID = @IDI AND ESTATUS  <> 'CANCELADO')SET @Ok =14055
IF @Estatus2 <> 'CANCELADO'   AND @Ok IS NULL
EXEC spAfectar @Modulo, @IDI, 'CANCELAR', 'Todo', NULL, @Usuario2, NULL, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @EnSilencio = 1, @Conexion = 1, @Estacion = @Estacion
SELECT @MovInv = Mov FROM Inv WHERE ID = @IDI
SELECT @SubClave = SubClave FROM MovTipo WHERE Mov = @MovInv AND Modulo = 'INV'
SELECT @CfgReservar = PedidosReservar FROM EmpresaCfg WHERE Empresa = @Empresa
IF @Ok IS NULL AND @CfgReservar = 1 AND @SubClave NOT IN('INV.ER')
BEGIN
SELECT @Serie = Serie ,@PedidoMES = PedidoMES FROM Inv WHERE ID = @IDI
SELECT @MovVenta = Mov FROM MovTipo WHERE SerieMES = @Serie
SELECT @IDVenta = ID FROM Venta WHERE Mov = @MovVenta AND MovID =@PedidoMES AND Empresa=@Empresa
SELECT @CantidadVenta=CantidadPendiente FROM VentaD WHERE ID = @IDVenta AND Articulo = @Articulo AND SubCuenta = @SubCuenta
DECLARE crDetalle CURSOR LOCAL FAST_FORWARD FOR
SELECT   Cantidad,Articulo,  SubCuenta
FROM VentaD
WHERE  ID = @IDVenta
OPEN crDetalle
FETCH NEXT FROM crDetalle INTO   @CantidadVenta,@Articulo, @SubCuenta
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @Cantidad = Cantidad FROM InvD WHERE ID = @IDI AND Articulo = @Articulo AND SubCuenta= @SubCuenta
IF @Cantidad >= @CantidadVenta
BEGIN
UPDATE VentaD
SET CantidadA = @CantidadVenta
WHERE ID = @IDVenta AND Articulo = @Articulo AND SubCuenta = @SubCuenta
IF @@ROWCOUNT >0 Set @Reservar =1
END
IF @Cantidad < @CantidadVenta AND @Cantidad >0.0
BEGIN
UPDATE VentaD
SET CantidadA = @Cantidad
WHERE ID = @IDVenta AND Articulo = @Articulo AND SubCuenta = @SubCuenta
IF @@ROWCOUNT >0 Set @Reservar =1
END
END
FETCH NEXT FROM crDetalle INTO   @CantidadVenta,@Articulo, @SubCuenta
END
CLOSE crDetalle
DEALLOCATE crDetalle
IF @Ok IS NULL AND @Reservar =1 AND @IDVenta IS NOT NULL AND @SubClave NOT IN('INV.ER')
BEGIN
EXEC  spAfectar 'VTAS', @IDVenta, 'DESRESERVAR', 'Seleccion', NULL, @Usuario2, NULL, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @EnSilencio = 1, @Conexion = 1, @Estacion = @Estacion
END
FETCH NEXT FROM crActualizar2 INTO @IDI,@Estatus2
END
CLOSE crActualizar2
DEALLOCATE crActualizar2
END
IF @OK = 46090 SET @Ok = NULL
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + ' Modulo="'+@Modulo+'" ModuloID =' + CHAR(34) + ISNULL(CONVERT(varchar,@IDO),'') + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '"/></Intelisis>'
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
END
END

