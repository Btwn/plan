SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spImportarInv
@Estacion 	int,
@Empresa	char(5),
@Modulo		char(5),
@ID		int,
@Sucursal	int

AS BEGIN
DECLARE
@a			float,
@Mov		char(20),
@Cliente		char(10),
@Proveedor		char(10),
@Clave		char(20),
@PrimerAplica	char(20),
@PrimerAplicaID	varchar(20),
@Aplica		char(20),
@AplicaID		varchar(20),
@ArtTipo		char(20),
@Articulo		char(20),
@Cantidad		float,
@SerieLote		varchar(50),
@CantidadSerieLote	float,
@Renglon		float,
@RenglonID		int,
@Almacen		char(10),
@FechaRequerida	datetime,
@FechaEntrega	datetime,
@Costo	        float,
@Precio		float,
@Impuesto1		float,
@Impuesto2		float,
@Impuesto3		money,
@ZonaImpuesto	varchar(50),
@DescuentoTipo	char(1),
@DescuentoLinea	float,
@DescripcionExtra	varchar(100),
@FechaEmision	datetime,
@Usuario		char(10),
@Concepto		varchar(50),
@Proyecto		varchar(50),
@Moneda  		char(10),
@TipoCambio		float,
@Referencia 	varchar(50),
@Observaciones 	varchar(100),
@FormaEnvio 	varchar(50),
@Condicion  	varchar(50),
@Vencimiento	datetime,
@Descuento		varchar(30),
@DescuentoGlobal 	float,
@SobrePrecio	float,
@CfgCompraCostoSugerido char(20),
@CfgTipoCosteo	varchar(20),
@Contacto		varchar(10),
@EnviarA		int,
@Ok			int,
@OkRef		varchar(255)
SELECT @CfgCompraCostoSugerido = CompraCostoSugerido, @CfgTipoCosteo = TipoCosteo FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @Ok = NULL, @OkRef = NULL,
@Aplica = NULL, @AplicaID = NULL, @PrimerAplica = NULL, @PrimerAplicaID = NULL,
@ArtTipo = NULL, @Articulo = NULL, @Cantidad = NULL, @SerieLote = NULL, @CantidadSerieLote = NULL,
@Almacen = NULL, @FechaRequerida = NULL, @FechaEntrega = NULL,
@Renglon = 2048, @RenglonID = 1,
@Concepto = NULL, @Proyecto = NULL, @Moneda = NULL, @TipoCambio = NULL, @Referencia = NULL, @Observaciones = NULL,
@FormaEnvio = NULL, @Condicion = NULL, @Vencimiento = NULL, @Descuento = NULL, @DescuentoGlobal = NULL, @SobrePrecio = NULL,
@Cliente = NULL, @Proveedor = NULL, @FechaEmision = GETDATE(), @ZonaImpuesto = NULL , @Contacto = NULL, @EnviarA = NULL
EXEC spExtraerFecha @FechaEmision OUTPUT
BEGIN TRANSACTION
IF @Modulo = 'COMS' DELETE CompraD WHERE ID = @ID ELSE
IF @Modulo = 'INV'  DELETE InvD    WHERE ID = @ID ELSE
IF @Modulo = 'VTAS' DELETE VentaD  WHERE ID = @ID
DELETE SerieLoteMov
WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID
IF @Modulo = 'COMS' SELECT @Mov = Mov, @Moneda = Moneda, @TipoCambio = TipoCambio, @Usuario = Usuario, @Almacen = Almacen, @ZonaImpuesto = ZonaImpuesto, @Proveedor = Proveedor, @FechaRequerida = FechaRequerida, @FechaEntrega = FechaEntrega FROM Compra WHERE ID = @ID ELSE
IF @Modulo = 'INV'  SELECT @Mov = Mov, @Moneda = Moneda, @TipoCambio = TipoCambio, @Usuario = Usuario, @Almacen = Almacen FROM Inv    WHERE ID = @ID ELSE
IF @Modulo = 'VTAS' SELECT @Mov = Mov, @Moneda = Moneda, @TipoCambio = TipoCambio, @Usuario = Usuario, @Almacen = Almacen, @ZonaImpuesto = ZonaImpuesto, @Cliente = Cliente FROM Venta WITH(NOLOCK) WHERE ID = @ID
DECLARE crImportarInv CURSOR SCROLL FOR
SELECT NULLIF(RTRIM(Clave), '')
FROM ImportarInv
WITH(NOLOCK) WHERE Estacion = @Estacion
OPEN crImportarInv
FETCH NEXT FROM crImportarInv  INTO @Clave
IF @@Error <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Clave IS NOT NULL
BEGIN
IF EXISTS(SELECT * FROM MovTipo WHERE UPPER(Mov) = UPPER(@Clave) AND Modulo = @Modulo)
BEGIN
IF @Aplica IS NOT NULL AND @AplicaID IS NOT NULL
BEGIN
IF @Modulo = 'COMS'
BEGIN
UPDATE Compra
 WITH(ROWLOCK) SET RenglonID = @RenglonID , Concepto = @Concepto, Proyecto = @Proyecto, Referencia = @Referencia, Observaciones = @Observaciones,
FormaEnvio = @FormaEnvio, Condicion = @Condicion, Vencimiento = @Vencimiento, Descuento = @Descuento, DescuentoGlobal = @DescuentoGlobal,
Almacen = @Almacen, Proveedor = @Proveedor, FechaRequerida = @FechaRequerida, FechaEntrega = @FechaEntrega, Directo = 0
WHERE ID = @ID
INSERT Compra (Sucursal, Empresa, Mov, Estatus, FechaEmision, Moneda, TipoCambio, Usuario, Almacen, Proveedor)
VALUES (@Sucursal, @Empresa, @Mov, 'SINAFECTAR', @FechaEmision, @Moneda, @TipoCambio, @Usuario, @Almacen, @Proveedor)
SELECT @ID = SCOPE_IDENTITY()
END ELSE
IF @Modulo = 'INV'
BEGIN
UPDATE Inv
 WITH(ROWLOCK) SET RenglonID = @RenglonID , Concepto = @Concepto, Proyecto = @Proyecto, Referencia = @Referencia, Observaciones = @Observaciones,
FormaEnvio = @FormaEnvio, Condicion = @Condicion, Vencimiento = @Vencimiento,
Almacen = @Almacen, Directo = 0
WHERE ID = @ID
INSERT Inv (Sucursal, Empresa, Mov, Estatus, FechaEmision, Moneda, TipoCambio, Usuario, Almacen)
VALUES (@Sucursal, @Empresa, @Mov, 'SINAFECTAR', @FechaEmision, @Moneda, @TipoCambio, @Usuario, @Almacen)
SELECT @ID = SCOPE_IDENTITY()
END ELSE
IF @Modulo = 'PROD'
BEGIN
UPDATE Prod
 WITH(ROWLOCK) SET RenglonID = @RenglonID , Concepto = @Concepto, Proyecto = @Proyecto, Referencia = @Referencia, Observaciones = @Observaciones,
Almacen = @Almacen, Directo = 0
WHERE ID = @ID
INSERT Prod (Sucursal, Empresa, Mov, Estatus, FechaEmision, Moneda, TipoCambio, Usuario, Almacen)
VALUES (@Sucursal, @Empresa, @Mov, 'SINAFECTAR', @FechaEmision, @Moneda, @TipoCambio, @Usuario, @Almacen)
SELECT @ID = SCOPE_IDENTITY()
END ELSE
IF @Modulo = 'VTAS'
BEGIN
UPDATE Venta
 WITH(ROWLOCK) SET RenglonID = @RenglonID , Concepto = @Concepto, Proyecto = @Proyecto, Referencia = @Referencia, Observaciones = @Observaciones,
FormaEnvio = @FormaEnvio, Condicion = @Condicion, Vencimiento = @Vencimiento, Descuento = @Descuento, DescuentoGlobal = @DescuentoGlobal, SobrePrecio = @SobrePrecio,
Almacen = @Almacen, Cliente = @Cliente, Directo = 0
WHERE ID = @ID
INSERT Venta (Sucursal, Empresa, Mov, Estatus, FechaEmision, Moneda, TipoCambio, Usuario, Almacen, Cliente)
VALUES (@Sucursal, @Empresa, @Mov, 'SINAFECTAR', @FechaEmision, @Moneda, @TipoCambio, @Usuario, @Almacen, @Cliente)
SELECT @ID = SCOPE_IDENTITY()
END
END
SELECT @Aplica = @Clave
FETCH NEXT FROM crImportarInv  INTO @Clave
IF @@FETCH_STATUS = 0
SELECT @AplicaID = RTRIM(@Clave)
IF @@Error <> 0 SELECT @Ok = 1
IF @Ok IS NULL
BEGIN
IF @Modulo = 'COMS'
SELECT @Concepto = Concepto, @Proyecto = Proyecto, @Moneda = Moneda, @TipoCambio = TipoCambio, @Referencia = Referencia, @Observaciones = Observaciones,
@FormaEnvio = FormaEnvio, @Condicion = Condicion, @Vencimiento = Vencimiento, @Descuento = Descuento, @DescuentoGlobal = DescuentoGlobal,
@Almacen = Almacen, @Proveedor = Proveedor, @FechaRequerida = FechaRequerida, @FechaEntrega = FechaEntrega,
@Contacto = Proveedor
FROM Compra
WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Aplica AND MovID = @AplicaID AND Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
ELSE
IF @Modulo = 'INV'
SELECT @Concepto = Concepto, @Proyecto = Proyecto, @Moneda = Moneda, @TipoCambio = TipoCambio, @Referencia = Referencia, @Observaciones = Observaciones,
@FormaEnvio = FormaEnvio, @Condicion = Condicion, @Vencimiento = Vencimiento,
@Almacen = @Almacen
FROM Inv
WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Aplica AND MovID = @AplicaID AND Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
ELSE
IF @Modulo = 'PROD'
SELECT @Concepto = Concepto, @Proyecto = Proyecto, @Moneda = Moneda, @TipoCambio = TipoCambio, @Referencia = Referencia, @Observaciones = Observaciones,
@Almacen = @Almacen
FROM Inv
WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Aplica AND MovID = @AplicaID AND Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
ELSE
IF @Modulo = 'VTAS'
SELECT @Concepto = Concepto, @Proyecto = Proyecto, @Moneda = Moneda, @TipoCambio = TipoCambio, @Referencia = Referencia, @Observaciones = Observaciones,
@FormaEnvio = FormaEnvio, @Condicion = Condicion, @Vencimiento = Vencimiento, @Descuento = Descuento, @DescuentoGlobal = DescuentoGlobal, @SobrePrecio = SobrePrecio,
@Almacen = Almacen, @Cliente = Cliente,
@Contacto = Cliente, @EnviarA = EnviarA
FROM Venta
WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Aplica AND MovID = @AplicaID AND Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
END
FETCH NEXT FROM crImportarInv  INTO @Clave
IF @@FETCH_STATUS = 0
BEGIN
IF EXISTS(SELECT * FROM Art WHERE Articulo = @Clave)
FETCH PRIOR FROM crImportarInv INTO @Clave
ELSE
SELECT @Referencia = RTRIM(@Clave)
END
END ELSE
BEGIN
SELECT @ArtTipo = NULL, @Articulo = NULL
SELECT @Articulo = Articulo, @ArtTipo = Tipo FROM Art WHERE Articulo = UPPER(@Clave)
IF @Articulo IS NOT NULL
BEGIN
FETCH NEXT FROM crImportarInv  INTO @Clave
IF @@FETCH_STATUS = 0
IF dbo.fnEsNumerico(@Clave) = 1 SELECT @Cantidad = CONVERT(float, @Clave) ELSE SELECT @Cantidad = NULL
IF @@Error <> 0 SELECT @Ok = 1
IF @ArtTipo IN ('SERIE', 'LOTE', 'VIN')
BEGIN
SELECT @a = 0
WHILE @a < @Cantidad AND @Ok IS NULL
BEGIN
FETCH NEXT FROM crImportarInv  INTO @Clave
IF EXISTS(SELECT * FROM Art WHERE Articulo = @Clave)
SELECT @a = @Cantidad
ELSE BEGIN
IF @@FETCH_STATUS = 0 SELECT @SerieLote = @Clave
IF @@Error <> 0 SELECT @Ok = 1
IF @ArtTipo = 'LOTE'
BEGIN
SELECT @CantidadSerieLote = @Cantidad
/*FETCH NEXT FROM crImportarInv  INTO @Clave
IF @@FETCH_STATUS = 0
IF dbo.fnEsNumerico(@Clave) = 1 SELECT @CantidadSerieLote = CONVERT(float, @Clave) ELSE SELECT @CantidadSerieLote = NULL
IF @@Error <> 0 SELECT @Ok = 1*/
END ELSE SELECT @CantidadSerieLote = 1
IF @Ok IS NULL
INSERT SerieLoteMov (Sucursal, Empresa, Modulo, ID, RenglonID, Articulo, SubCuenta, SerieLote, Cantidad)
VALUES (@Sucursal, @Empresa, @Modulo, @ID, @RenglonID, @Articulo, '', @SerieLote, @CantidadSerieLote)
SELECT @a = @a + @CantidadSerieLote
END
END
END
IF @Ok IS NULL
BEGIN
SELECT @Costo = NULL, @Precio = NULL, @Impuesto1 = NULL, @Impuesto2 = NULL, @Impuesto3 = NULL, @DescuentoTipo = NULL, @DescuentoLinea = NULL, @DescripcionExtra = NULL
IF @Aplica IS NOT NULL AND @AplicaID IS NOT NULL
BEGIN
IF @Modulo = 'COMS'
SELECT @Almacen = d.Almacen, @FechaRequerida = d.FechaRequerida, @FechaEntrega = d.FechaEntrega, @Costo = d.Costo,
@Impuesto1 = d.Impuesto1, @Impuesto2 = d.Impuesto2, @Impuesto3 = d.Impuesto3, @DescuentoTipo = d.DescuentoTipo, @DescuentoLinea = d.DescuentoLinea, @DescripcionExtra = d.DescripcionExtra
FROM Compra e, CompraD d
WITH(NOLOCK) WHERE e.ID = d.ID AND e.Empresa = @Empresa AND e.Mov = @Aplica AND e.MovID = @AplicaID AND e.Estatus NOT IN ('SINAFECTAR', 'CANCELADO') AND d.Articulo = @Articulo
ELSE
IF @Modulo = 'INV'
SELECT @Almacen = d.Almacen, @Costo = d.Costo
FROM Inv e, InvD d
WITH(NOLOCK) WHERE e.ID = d.ID AND e.Empresa = @Empresa AND e.Mov = @Aplica AND e.MovID = @AplicaID AND e.Estatus NOT IN ('SINAFECTAR', 'CANCELADO') AND d.Articulo = @Articulo
ELSE
IF @Modulo = 'PROD'
SELECT @Almacen = d.Almacen, @Costo = d.Costo
FROM Prod e, ProdD d
WITH(NOLOCK) WHERE e.ID = d.ID AND e.Empresa = @Empresa AND e.Mov = @Aplica AND e.MovID = @AplicaID AND e.Estatus NOT IN ('SINAFECTAR', 'CANCELADO') AND d.Articulo = @Articulo
ELSE
IF @Modulo = 'VTAS'
SELECT @Almacen = d.Almacen, @Precio = Precio, @Impuesto1 = d.Impuesto1, @Impuesto2 = d.Impuesto2, @Impuesto3 = d.Impuesto3, @DescuentoTipo = d.DescuentoTipo, @DescuentoLinea = d.DescuentoLinea, @DescripcionExtra = d.DescripcionExtra
FROM Venta e, VentaD d
WITH(NOLOCK) WHERE e.ID = d.ID AND e.Empresa = @Empresa AND e.Mov = @Aplica AND e.MovID = @AplicaID AND e.Estatus NOT IN ('SINAFECTAR', 'CANCELADO') AND d.Articulo = @Articulo
END ELSE BEGIN
SELECT @Aplica = NULL, @AplicaID = NULL
IF @Modulo = 'COMS'
EXEC spVerCosto @Sucursal, @Empresa, @Proveedor, @Articulo, NULL, NULL, @CfgCompraCostoSugerido, @Moneda, @TipoCambio, @Costo OUTPUT, 0
ELSE
EXEC spVerCosto @Sucursal, @Empresa, @Proveedor, @Articulo, NULL, NULL, @CfgTipoCosteo, @Moneda, @TipoCambio, @Costo OUTPUT, 0
SELECT @Impuesto1 = Impuesto1, @Impuesto2 = Impuesto2, @Impuesto3 = Impuesto3 FROM Art WHERE Articulo = @Articulo
END
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto2 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto3 OUTPUT
EXEC spTipoImpuesto @Modulo, @ID, @Mov, @FechaEmision, @Empresa, @Sucursal, @Contacto, @EnviarA, @Articulo = @Articulo, @EnSilencio = 1, @Impuesto1 = @Impuesto1 OUTPUT, @Impuesto2 = @Impuesto2 OUTPUT, @Impuesto3 = @Impuesto3 OUTPUT
IF @Modulo = 'COMS'
INSERT CompraD (Sucursal, ID, Renglon, RenglonSub, RenglonID, Aplica, AplicaID, Articulo, Cantidad, DescripcionExtra, Almacen, FechaRequerida, FechaEntrega, Costo, Impuesto1, Impuesto2, Impuesto3, DescuentoTipo, DescuentoLinea)
VALUES (@Sucursal, @ID, @Renglon, 0, @RenglonID, @Aplica, @AplicaID, @Articulo, @Cantidad, @DescripcionExtra, @Almacen, @FechaRequerida, @FechaEntrega, @Costo, @Impuesto1, @Impuesto2, @Impuesto3, @DescuentoTipo, @DescuentoLinea)
ELSE
IF @Modulo = 'INV'
INSERT InvD (Sucursal, ID, Renglon, RenglonSub, RenglonID, Aplica, AplicaID, Articulo, Cantidad, Costo, Almacen)
VALUES (@Sucursal, @ID, @Renglon, 0, @RenglonID, @Aplica, @AplicaID, @Articulo, @Cantidad, @Costo, @Almacen)
ELSE
IF @Modulo = 'PROD'
INSERT ProdD (Sucursal, ID, Renglon, RenglonSub, RenglonID, Aplica, AplicaID, Articulo, Cantidad, Costo, Almacen)
VALUES (@Sucursal, @ID, @Renglon, 0, @RenglonID, @Aplica, @AplicaID, @Articulo, @Cantidad, @Costo, @Almacen)
ELSE
IF @Modulo = 'VTAS'
INSERT VentaD (Sucursal, ID, Renglon, RenglonSub, RenglonID, Aplica, AplicaID, Articulo, Cantidad, DescripcionExtra, Precio, Impuesto1, Impuesto2, Impuesto3, DescuentoTipo, DescuentoLinea, Almacen)
VALUES (@Sucursal, @ID, @Renglon, 0, @RenglonID, @Aplica, @AplicaID, @Articulo, @Cantidad, @DescripcionExtra, @Precio, @Impuesto1, @Impuesto2, @Impuesto3, @DescuentoTipo, @DescuentoLinea, @Almacen)
SELECT @Renglon = @Renglon + 2048, @RenglonID = @RenglonID + 1
END
END ELSE
BEGIN
SELECT @Ok = 1, @OkRef = 'No Existe el Articulo: '+RTRIM(@Clave)
RAISERROR(@OkRef,16,-1)
END
END
END
FETCH NEXT FROM crImportarInv  INTO @Clave
END
CLOSE crImportarInv
DEALLOCATE crImportarInv
IF @Ok IS NULL
BEGIN
IF @Aplica IS NOT NULL AND @AplicaID IS NOT NULL
BEGIN
IF @Modulo = 'COMS'
UPDATE Compra
 WITH(ROWLOCK) SET RenglonID = @RenglonID , Concepto = @Concepto, Proyecto = @Proyecto, Referencia = @Referencia, Observaciones = @Observaciones,
FormaEnvio = @FormaEnvio, Condicion = @Condicion, Vencimiento = @Vencimiento, Descuento = @Descuento, DescuentoGlobal = @DescuentoGlobal,
Almacen = @Almacen, Proveedor = @Proveedor, FechaRequerida = @FechaRequerida, FechaEntrega = @FechaEntrega, Directo = 0
WHERE ID = @ID
ELSE
IF @Modulo = 'INV'
UPDATE Inv
 WITH(ROWLOCK) SET RenglonID = @RenglonID , Concepto = @Concepto, Proyecto = @Proyecto, Referencia = @Referencia, Observaciones = @Observaciones,
FormaEnvio = @FormaEnvio, Condicion = @Condicion, Vencimiento = @Vencimiento,
Almacen = @Almacen, Directo = 0
WHERE ID = @ID
ELSE
IF @Modulo = 'PROD'
UPDATE Prod
 WITH(ROWLOCK) SET RenglonID = @RenglonID , Concepto = @Concepto, Proyecto = @Proyecto, Referencia = @Referencia, Observaciones = @Observaciones,
Almacen = @Almacen, Directo = 0
WHERE ID = @ID
ELSE
IF @Modulo = 'VTAS'
UPDATE Venta
 WITH(ROWLOCK) SET RenglonID = @RenglonID , Concepto = @Concepto, Proyecto = @Proyecto, Referencia = @Referencia, Observaciones = @Observaciones,
FormaEnvio = @FormaEnvio, Condicion = @Condicion, Vencimiento = @Vencimiento, Descuento = @Descuento, DescuentoGlobal = @DescuentoGlobal, SobrePrecio = @SobrePrecio,
Almacen = @Almacen, Cliente = @Cliente, Directo = 0
WHERE ID = @ID
END ELSE
BEGIN
IF @Modulo = 'COMS' UPDATE Compra  WITH(ROWLOCK) SET RenglonID = @RenglonID WHERE ID = @ID ELSE
IF @Modulo = 'INV'    UPDATE Inv WITH(ROWLOCK) SET RenglonID = @RenglonID WHERE ID = @ID ELSE
IF @Modulo = 'PROD'   UPDATE Prod WITH(ROWLOCK) SET RenglonID = @RenglonID WHERE ID = @ID ELSE
IF @Modulo = 'VTAS'   UPDATE Venta WITH(ROWLOCK) SET RenglonID = @RenglonID WHERE ID = @ID
END
END
IF @Ok IS NULL
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
RETURN
END

