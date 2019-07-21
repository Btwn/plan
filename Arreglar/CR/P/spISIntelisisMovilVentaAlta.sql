SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spISIntelisisMovilVentaAlta
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
SET nocount
ON
BEGIN TRY
BEGIN TRAN
DECLARE
@IDPedido	   int,
@Agente		   varchar(10),
@Usuario	   varchar(10),
@IDVisita      varchar(10),
@OrdenID       varchar(50),
@Cliente       varchar(50),
@Observaciones varchar(max),
@ConImpuesto   bit,
@Articulo      varchar(20),
@Renglon       float,
@RenglonID     int,
@Mov           varchar(20),
@Empresa       varchar(5),
@Moneda        varchar(10),
@AlmacenDef    varchar(10),
@ImporteSUM    money,
@ImpuestosSUM  money,
@Situacion     varchar(50),
@IDO           int,
@CampanaTipo   varchar(50),
@ListaPreciosEsp varchar(20),
@EnviarA       int,
@DescuentoGlobalTipo varchar(50),
@DescuentoGlobal  varchar(50),
@DescuentoImporte varchar(50),
@ArtTipo          varchar(5),
@SubCuenta        varchar(50),
@Cantidad         float,
@Precio           money,
@DescuentoLinea   money,
@Impuesto1        float,
@DescripcionExtra varchar(255),
@Unidad           varchar(50),
@UnidadJ          varchar(50),
@Factor           int,
@Sucursal         int,
@Tipo             varchar(20),
@Articuloj        varchar(20),
@SubCuentaj       varchar(50),
@Cantidadj        float,
@DescripcionExtraj varchar(255),
@Tipoj            varchar(20)
DECLARE @TableDetalle as Table(
IDVisita         varchar(10),
Cliente          varchar(50),
Observaciones    varchar(max),
Articulo         varchar(20),
Cantidad         varchar(20),
Subcuenta        varchar(50),
ArtJuego         varchar(50),
Precio           varchar(50),
DescuentoLinea   varchar(50),
DescuentoImporte varchar(50),
Impuesto1        varchar(50),
PrecioFinal      varchar(50),
TipoDescuento    varchar(50))
DECLARE @TableImportes as Table(
RenglonID        int IDENTITY,
Articulo         varchar(20),
Cantidad         varchar(20),
Precio           money,
Impuesto1        money,
Subcuenta        varchar(50),
DescuentoLinea   money,
DescuentoImporte money,
ArtTipo          char(1))
SELECT
@Usuario       = Usuario,
@IDVisita      = IDVisita,
@OrdenID       = OrdenID,
@Cliente       = Cliente,
@Observaciones = Observaciones,
@DescuentoGlobalTipo = DescuentoGlobalTipo,
@DescuentoGlobal = DescuentoGlobal,
@DescuentoImporte = DescuentoImporte
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud')
WITH (Usuario varchar(50), IDVisita varchar(10), OrdenID varchar(50), Cliente varchar(50), Observaciones varchar(max),DescuentoGlobalTipo varchar(50), DescuentoGlobal varchar(50), DescuentoImporte varchar(50))
INSERT INTO @TableDetalle
SELECT @IDVisita, @Cliente, @Observaciones, Articulo, Cantidad, ArtOpcion, ArtJuego, PrecioLista, DescuentoLinea, DescuentoImporte, TasaIVA, PrecioFinal, TipoDescuento
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/Detalle')
WITH (Articulo       varchar(20), Cantidad         varchar(10), ArtOpcion varchar(50), ArtJuego    varchar(50), PrecioLista varchar(50),
DescuentoLinea varchar(50), DescuentoImporte varchar(50), TasaIVA   varchar(50), PrecioFinal varchar(50),TipoDescuento varchar(50))
SELECT @Agente  = Agente,
@Empresa = Empresa,
@Mov     = Movimiento
FROM MovilUsuarioCfg
WHERE Usuario = @Usuario
IF ISNULL(@Mov,'') = ''
SELECT @Mov = Mov,@Factor = Factor
FROM MovTipo
WHERE Clave = 'VTAS.P'
SELECT @RenglonID = COUNT(Art.Articulo)
FROM @TableDetalle TD
JOIN Art Art ON TD.Articulo = Art.Articulo
SELECT @Moneda = LP.Moneda, @AlmacenDef = Ct.AlmacenDef
FROM Agente Ag
JOIN Cte Ct ON Ag.Agente = Ct.Agente AND Ag.Agente = @Agente
LEFT JOIN ListaPreciosD LP ON Ct.ListaPreciosEsp = LP.Lista
WHERE ct.Cliente = @Cliente
SELECT @Sucursal = Sucursal
FROM MovilUsuarioCfg
WHERE Agente = @Agente
SET @Sucursal = ISNULL(@Sucursal,0)
SELECT @ConImpuesto = CAST(VentaPreciosImpuestoIncluido AS bit)
FROM EmpresaCfg C
WHERE c.Empresa = @Empresa
INSERT INTO @TableImportes
SELECT TD.Articulo,
TD.Cantidad,
CASE @ConImpuesto WHEN 1 THEN TD.PrecioFinal ELSE TD.Precio END,
TD.Impuesto1,
TD.Subcuenta,
CASE WHEN TD.TipoDescuento = 'porcentaje' AND (ISNULL(TD.PrecioFinal,0)+ISNULL(TD.Precio,0)) >0 THEN CAST(ISNULL(TD.DescuentoLinea,0.00) AS Float) ELSE (CAST(ISNULL(TD.DescuentoImporte,0.00) as float)/(CASE @ConImpuesto WHEN 1 THEN TD.PrecioFinal ELSE TD.Precio END))*100 END,
CASE WHEN TD.TipoDescuento = 'importe' THEN CAST(ISNULL(TD.DescuentoLinea,0.00) AS Float) ELSE 0.00 END,
ISNULL(UPPER(SUBSTRING(Articulo.Tipo, 1, 1)), 'U') ArtTipo
FROM Art Articulo
JOIN @TableDetalle TD on Articulo.Articulo = TD.Articulo
SELECT @ImporteSUM   = SUM(Suma) FROM (SELECT SUM(CAST(Precio as decimal(18,2))  * CAST(Cantidad as decimal(18,2))) Suma FROM @TableImportes GROUP BY Articulo) AS ImporteSUM
SELECT @ImpuestosSUM = SUM(Suma) FROM (SELECT SUM((CAST(Precio as decimal(18,2)) * CAST(Impuesto1 as decimal(18,2)) / 100) * CAST(Cantidad as decimal(18,2))) Suma FROM @TableImportes GROUP BY Articulo) AS ImpuestosSUM
IF @AlmacenDef IS NULL
SELECT TOP 1 @AlmacenDef = S.Grupo
FROM SaldoU S JOIN @TableImportes I ON S.Cuenta = I.Articulo
ORDER BY I.RenglonID
IF @Moneda IS NULL
SELECT TOP 1 @Moneda = Moneda FROM Mon ORDER BY TipoCambio, Orden
SELECT @ListaPreciosEsp = ListaPreciosEsp, @EnviarA = EnviarA FROM CampanaD WHERE RID = @IDVisita
IF NOT EXISTS(SELECT * FROM CteEnviarA WHERE Cliente = @Cliente AND ID = @EnviarA)
SET @EnviarA = NULL
IF ISNULL(@ListaPreciosEsp,'') = ''
SELECT @ListaPreciosEsp = DefListaPreciosEsp FROM Usuario WHERE Usuario = @Usuario
INSERT INTO Venta
(Empresa, Mov, MovID, FechaEmision, UltimoCambio, Concepto, Proyecto, Moneda, TipoCambio, Usuario, Autorizacion, Referencia, DocFuente, Observaciones,
Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Directo, Prioridad, RenglonID,
Cliente, EnviarA, Almacen, AlmacenDestino, Agente, AgenteServicio, FormaEnvio, Descuento, FechaRequerida,
HoraRequerida, FechaOrdenCompra, ReferenciaOrdenCompra, FechaOriginal, OrdenCompra, Condicion, Vencimiento, DescuentoGlobal,
Importe, Impuestos, ComisionTotal, DescuentoLineal, AnticiposFacturados, Retencion, CostoTotal, PrecioTotal, OrigenTipo, Origen,
OrigenID, Poliza, PolizaID, FechaConclusion, ServicioTipo, ServicioTipoOrden, ServicioTipoOperacion,
ServicioArticulo, ServicioSerie, ServicioContrato, ServicioContratoID, ServicioContratoTipo, ServicioGarantia, ServicioExpress,
ServicioDescripcion, ServicioFecha, ServicioIdentificador, ServicioPlacas, ServicioKms, ServicioSiniestro, ServicioDemerito, ServicioDeducible,
ServicioDeducibleImporte, ServicioNumero, ServicioNumeroEconomico, ServicioFlotilla, ServicioRampa, ServicioAseguradora, ServicioPoliza,
Peso, Volumen, Paquetes, Causa, Atencion, AtencionTelefono, Extra, CancelacionID,
ListaPreciosEsp, ZonaImpuesto, Mensaje, FechaEntrega, Departamento, Sucursal, SucursalOrigen, GenerarOP, ConVigencia, VigenciaDesde,
VigenciaHasta, DesglosarImpuestos, DesglosarImpuesto2, ExcluirPlaneacion, Enganche, Bonificacion, ContUso, SubModulo, Periodicidad, AnticiposImpuestos,
Espacio, UEN, Clase, Subclase, GastoAcreedor, GastoConcepto, Comentarios, Extra1)
VALUES
(@Empresa, @Mov, NULL, GETDATE(), GETDATE(), NULL, NULL, @Moneda, 1.0, @Usuario, NULL, NULL, NULL, @Observaciones,
'BORRADOR', NULL, NULL, NULL, NULL, 1, 'Normal', @RenglonID,
@Cliente, @EnviarA, @AlmacenDef, NULL, @Agente, NULL, NULL, NULL, GETDATE(),
NULL, NULL, NULL, NULL, NULL, NULL, GETDATE(), NULL,
@ImporteSUM, @ImpuestosSUM, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0,
NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL,
@ListaPreciosEsp, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, 'VTAS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 0)
SET @IDPedido = SCOPE_IDENTITY()
IF @DescuentoGlobalTipo = 'Importe'
BEGIN
UPDATE Venta SET DescuentoGlobal = CASE WHEN ISNULL(Importe,0) > 0 THEN (ISNULL(@DescuentoImporte,0.00) / ISNULL(Importe,0)) * 100 ELSE 0 END  WHERE ID = @IDPedido
END
IF @DescuentoGlobalTipo = 'porcentaje'
BEGIN
UPDATE Venta SET DescuentoGlobal = CASE WHEN ISNULL(Importe,0) > 0 THEN ISNULL(@DescuentoGlobal,0.00) ELSE 0 END  WHERE ID = @IDPedido
END
SET @Renglon = 1024
DECLARE crImportes CURSOR LOCAL FOR
SELECT i.RenglonID,i.Articulo,i.ArtTipo,i.Subcuenta,i.Cantidad,i.Precio,i.DescuentoLinea,i.DescuentoImporte,i.Impuesto1,a.Descripcion2,a.Tipo,ISNULL(a.Unidad,'PZA')
FROM @TableImportes i
JOIN Art a ON i.Articulo = a.Articulo
OPEN crImportes
FETCH NEXT FROM crImportes INTO @RenglonID,@Articulo,@ArtTipo,@SubCuenta,@Cantidad,@Precio,@DescuentoLinea, @DescuentoImporte, @Impuesto1,@DescripcionExtra,@Tipo,@Unidad
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
INSERT INTO VentaD
(ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Almacen, Articulo, SubCuenta,
Cantidad, Precio, PrecioSugerido, DescuentoLinea, DescuentoImporte, Impuesto1, Impuesto2, Impuesto3, DescripcionExtra, Unidad,   Factor,
CantidadInventario, Agente, Sucursal, SucursalOrigen, PrecioMoneda)
VALUES(@IDPedido, @Renglon, 0, @RenglonID, @ArtTipo, @AlmacenDef, @Articulo, @SubCuenta,
@Cantidad, @Precio, @Precio, @DescuentoLinea, @DescuentoImporte, @Impuesto1, 0.00, 0.00, NULL, @Unidad, @Factor,
@Cantidad, @Agente, @Sucursal, @Sucursal, @Moneda)
IF @Tipo = 'Juego'
BEGIN
DECLARE crComponente CURSOR LOCAL FOR
SELECT d.Opcion,j.Cantidad,d.SubCuenta,a.Descripcion2,a.Unidad
FROM ArtJuego j
JOIN ArtJuegoD d ON j.Articulo = d.Articulo AND j.Juego = d.Juego
JOIN Art a ON d.Opcion = a.Articulo
WHERE j.Articulo = @Articulo
OPEN crComponente
FETCH NEXT FROM crComponente INTO @Articuloj,@Cantidadj,@SubCuentaj,@DescripcionExtraj,@Unidadj
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SET @Renglon = @Renglon + 1024
INSERT INTO VentaD(ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Almacen, Articulo, SubCuenta,
Cantidad, Precio, PrecioSugerido, DescuentoLinea, DescuentoImporte, Impuesto1, Impuesto2, Impuesto3, DescripcionExtra, Unidad,   Factor,
CantidadInventario, Agente, Sucursal, SucursalOrigen, PrecioMoneda)
VALUES(@IDPedido, @Renglon, 0, @RenglonID, 'C', @AlmacenDef, @Articuloj, @SubCuentaj,
@Cantidadj, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, NULL, @Unidadj, @Factor,
@Cantidadj, @Agente, @Sucursal, @Sucursal, @Moneda)
END
FETCH NEXT FROM crComponente INTO @Articuloj,@Cantidadj,@SubCuentaj,@DescripcionExtraj,@Unidadj
END  
CLOSE crComponente
DEALLOCATE crComponente
END
SET @Renglon = @Renglon + 1024
END
FETCH NEXT FROM crImportes INTO @RenglonID,@Articulo,@ArtTipo,@SubCuenta,@Cantidad,@Precio,@DescuentoLinea, @DescuentoImporte, @Impuesto1,@DescripcionExtra,@Tipo,@Unidad
END  
CLOSE crImportes
DEALLOCATE crImportes
IF @IDVisita IS NOT NULL AND EXISTS (SELECT ID FROM CampanaD WHERE RID = cast(@IDVisita as int))
BEGIN
SELECT @IDO = ID
FROM CampanaD
WHERE RID = cast(@IDVisita as int)
SELECT @CampanaTipo = CampanaTipo
FROM Campana
WHERE ID = @IDO
SELECT @Situacion = Situacion
FROM CampanaTipoSituacion
WHERE CampanaTipo = @CampanaTipo
AND AccionMovil = 'Confirmado'
UPDATE CampanaD
SET Situacion = @Situacion
WHERE RID = cast(@IDVisita as int)
INSERT CampanaEvento(ID,RID,FechaHora,Tipo,Situacion,SituacionFecha,Observaciones,Comentarios,Sucursal,SucursalOrigen)
VALUES (@IDO,cast(@IDVisita as int),GETDATE(),'Cita',@Situacion,GETDATE(),'','',0,0)
END
SELECT @Resultado = CAST((
SELECT * FROM (
SELECT @IDPedido IDPedido
) AS MovilVentaAlta FOR XML AUTO, TYPE, ELEMENTS
) AS NVARCHAR(MAX))
IF @Ok IS NOT NULL
SET @OkRef = (SELECT Descripcion FROM MensajeLista WHERE Mensaje = @Ok)
COMMIT TRAN
END TRY
BEGIN CATCH
SELECT @Ok = 1, @OkRef = ERROR_MESSAGE()
ROLLBACK TRAN
END CATCH
SET nocount OFF
END

