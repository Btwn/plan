SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarReciboImportacion
@Modulo                 varchar(5),
@ID                     int,
@Accion                 varchar(20),
@Empresa                varchar(5),
@Sucursal               int,
@Usuario                varchar(10),
@Mov                    varchar(20),
@MovID                  varchar(20),
@MovTipo                varchar(20),
@Estatus                varchar(15),
@Ok                     int             OUTPUT,
@OkRef                  varchar(255)    OUTPUT

AS
BEGIN
DECLARE
@GenerarID              int,
@Proveedor              varchar(20),
@Almacen                varchar(10),
@Proyecto               varchar(20),
@UEN                    int,
@FechaEmision           datetime,
@Moneda                 varchar(10),
@TipoCambio             float,
@FormaEnvio             varchar(50),
@Referencia             varchar(50),
@Observaciones          varchar(100),
@FechaRequerida         datetime,
@Condicion              varchar(50),
@Concepto               varchar(50),
@Vencimiento            datetime,
@Agente                 varchar(10),
@Descuento              varchar(30),
@DescuentoGlobal        float,
@SucursalMov            int,
@GenerarMov             varchar(20),
@DMovID                 varchar(20),
@Fecha                  datetime,
@GastoGenerado          bit,
@RenglonID              int
IF NOT EXISTS(SELECT ID FROM CompraD WHERE ID = @ID AND MonedaD IS NOT NULL AND TipoCambioD IS NOT NULL)
BEGIN
RETURN
END
SELECT @Fecha = GETDATE(), @GastoGenerado = 0
EXEC spExtraerFecha @Fecha OUTPUT
SELECT @GenerarMov = 'Entrada Importacion'
SELECT @Proveedor         = Proveedor,
@Almacen           = Almacen,
@Proyecto          = Proyecto,
@UEN               = UEN,
@FechaEmision      = FechaEmision,
@Moneda            = Moneda,
@TipoCambio        = TipoCambio,
@Referencia        = Referencia,
@Observaciones     = Observaciones,
@FechaRequerida    = FechaRequerida,
@Condicion         = Condicion,
@Concepto          = Concepto,
@Vencimiento       = Vencimiento,
@Agente            = Agente,
@Descuento         = Descuento,
@DescuentoGlobal   = DescuentoGlobal,
@SucursalMov       = Sucursal
FROM Compra
WHERE ID = @ID
IF @Accion IN ('AFECTAR', 'RESERVAR')
BEGIN
DECLARE crMoneda CURSOR FOR
SELECT DISTINCT MonedaD, TipoCambioD
FROM CompraD WHERE ID = @ID
OPEN crMoneda
FETCH NEXT FROM crMoneda INTO @Moneda, @TipoCambio
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Moneda IS NOT NULL
BEGIN
INSERT Compra(Empresa,  Mov,  FechaEmision,  Proyecto,  UEN,  Moneda,  TipoCambio,  Usuario,  Referencia,  Observaciones,  Estatus,  Proveedor,  FormaEnvio, Concepto,
FechaRequerida,  Almacen,  Condicion,  Vencimiento,  Agente,  Descuento,  DescuentoGlobal, OrigenTipo, Origen, OrigenID, Sucursal)
SELECT @Empresa, @GenerarMov, @FechaEmision, @Proyecto, @UEN, @Moneda, @TipoCambio, @Usuario, @Referencia, @Observaciones, 'SINAFECTAR', @Proveedor, @FormaEnvio, @Concepto,
@FechaRequerida, @Almacen, @Condicion, @Vencimiento, @Agente, @Descuento, @DescuentoGlobal, 'COMS', @Mov, @MovID, @SucursalMov
SELECT @GenerarID = SCOPE_IDENTITY()
INSERT CompraD(ID, Renglon, RenglonSub, RenglonID, RenglonTipo, Cantidad, Almacen, Codigo, Articulo, SubCuenta, CostoConImpuesto, Costo, Impuesto1, Impuesto2, Impuesto3,
Impuesto5, Retencion1, Retencion2, Retencion3, Descuento, DescuentoTipo, DescuentoLinea, DescuentoImporte, DescripcionExtra, ReferenciaExtra, ContUso, ContUso2,
ContUso3, ClavePresupuestal, DestinoTipo, Destino, DestinoID, Aplica, AplicaID, CostoInv, Unidad, Factor, CantidadInventario, ImportacionProveedor, ImportacionReferencia,
Pais, TratadoComercial, ProgramaSectorial, ValorAduana, ImportacionImpuesto1, ImportacionImpuesto2, ID1, ID2, FormaPago, Estado, PaqueteCantidad, TipoImpuesto1, TipoImpuesto2,
TipoImpuesto3, TipoImpuesto4, TipoImpuesto5, TipoRetencion1, TipoRetencion2, TipoRetencion3, CambioImpuesto, MonedaD, TipoCambioD)
SELECT @GenerarID, Renglon, RenglonSub, RenglonID, RenglonTipo, Cantidad, Almacen, Codigo, Articulo, SubCuenta, CostoConImpuesto, Costo, Impuesto1, Impuesto2, Impuesto3,
Impuesto5, Retencion1, Retencion2, Retencion3, Descuento, DescuentoTipo, DescuentoLinea, DescuentoImporte, DescripcionExtra, ReferenciaExtra, ContUso, ContUso2,
ContUso3, ClavePresupuestal, DestinoTipo, Destino, DestinoID, Aplica, AplicaID, ISNULL(NULLIF(CostoInv, 0), Costo), Unidad, Factor, CantidadInventario, ImportacionProveedor, ImportacionReferencia,
Pais, TratadoComercial, ProgramaSectorial, ValorAduana, ImportacionImpuesto1, ImportacionImpuesto2, ID1, ID2, FormaPago, Estado, PaqueteCantidad, TipoImpuesto1, TipoImpuesto2,
TipoImpuesto3, TipoImpuesto4, TipoImpuesto5, TipoRetencion1, TipoRetencion2, TipoRetencion3, CambioImpuesto, @Moneda, @TipoCambio
FROM CompraD
WHERE ID = @ID AND MonedaD = @Moneda AND TipoCambioD = @TipoCambio
INSERT SerieLoteMov(Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, CantidadAlterna, Propiedades, Sucursal, ArtCostoInv)
SELECT Empresa, Modulo, @GenerarID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad, CantidadAlterna, Propiedades, Sucursal, ArtCostoInv
FROM SerieLoteMov
WHERE Empresa = @Empresa
AND ID = @ID
AND RenglonID IN (SELECT RenglonID FROM CompraD WHERE ID = @GenerarID)
IF @GastoGenerado = 0
BEGIN
INSERT CompraGastoDiverso(ID, Concepto, Acreedor, Importe, PorcentajeImpuestos, Moneda, TipoCambio, Prorrateo, FechaEmision, Condicion, Vencimiento, Referencia,
Retencion, Retencion2, Retencion3, Impuestos, Multiple, Sucursal, PedimentoEspecifico, SucursalOrigen, ProrrateoNivel)
SELECT @GenerarID, Concepto, Acreedor, Importe, PorcentajeImpuestos, Moneda, TipoCambio, Prorrateo, FechaEmision, Condicion, Vencimiento, Referencia,
Retencion, Retencion2, Retencion3, Impuestos, Multiple, Sucursal, PedimentoEspecifico, SucursalOrigen, ProrrateoNivel
FROM CompraGastoDiverso WHERE ID = @ID
SELECT @GastoGenerado = 1
END
SELECT @RenglonID = MAX(RenglonID) FROM CompraD WHERE ID = @GenerarID
EXEC spAfectar @Modulo, @GenerarID, @Accion, 'Todo', NULL, @Usuario, NULL, 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @Conexion = 1
IF @Ok IS NULL
BEGIN
SELECT @DMovID = MovID FROM Compra WHERE ID = @GenerarID
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'COMS', @GenerarID, @GenerarMov, @DMovID, @Ok OUTPUT
END
END
FETCH NEXT FROM crMoneda INTO @Moneda, @TipoCambio
END
CLOSE crMoneda
DEALLOCATE crMoneda
IF @GenerarID IS NOT NULL
UPDATE Compra SET Estatus = 'CONCLUIDO', FechaConclusion = @Fecha WHERE ID = @ID
END ELSE IF @Accion = 'CANCELAR'
BEGIN
DECLARE crCancela CURSOR FOR
SELECT DID
FROM MovFlujo
WHERE OID = @ID
AND OModulo = @Modulo
AND DModulo = @Modulo
AND Cancelado = 0
OPEN crCancela
FETCH NEXT FROM crCancela INTO @GenerarID
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
EXEC spAfectar @Modulo, @GenerarID, @Accion, 'Todo', NULL, @Usuario, NULL, 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @Conexion = 1
FETCH NEXT FROM crCancela INTO @GenerarID
END
CLOSE crCancela
DEALLOCATE crCancela
IF @Ok IS NULL
UPDATE Compra SET Estatus = 'CANCELADO', FechaCancelacion = @Fecha WHERE ID = @ID
END
RETURN
END

