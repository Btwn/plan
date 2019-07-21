SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarCOMS_OC
@Sucursal	int,
@Empresa	char(5),
@Usuario	char(10),
@FechaTrabajo	datetime,
@GenerarMov	char(20)

AS BEGIN
DECLARE
@Conteo		int,
@Proveedor		char(10),
@UltProveedor	char(10),
@Agente		char(10),
@UltAgente		char(10),
@Almacen		char(10),
@UltAlmacen		char(10),
@ID			int,
@Renglon		float,
@RenglonSub		int,
@GenerarID		int,
@GenerarRenglon	float,
@GenerarRenglonID	int,
@Moneda		char(10),
@TipoCambio		float,
@Mov		char(20),
@MovID		varchar(20),
@Ok			int,
@OkRef		varchar(255),
@Condicion		varchar(50),
@UsuarioAgente	char(10),
@ZonaImpuesto	varchar(50),
@Impuesto1		float,
@Impuesto2		float,
@Impuesto3		float,
@Articulo		varchar(20)
SELECT @Ok = NULL, @OkRef = NULL, @Conteo = 0, @UltProveedor = NULL, @UltAgente = NULL, @UltAlmacen = NULL, @GenerarID = NULL, @GenerarRenglon = 0.0, @GenerarRenglonID = 0
DECLARE crGenerarOC CURSOR FOR
SELECT ProveedorRef, AgenteRef, c.ID, c.Mov, c.MovID, c.Moneda, c.TipoCambio, c.Almacen, d.Renglon, d.RenglonSub
FROM Compra c WITH (NOLOCK), CompraD d WITH (NOLOCK), MovTipo mt
WITH(NOLOCK) WHERE c.Empresa = @Empresa AND c.Estatus = 'PENDIENTE' AND mt.Modulo = 'COMS' AND mt.Mov = c.Mov AND mt.Clave = 'COMS.R'
AND d.CantidadPendiente > 0 AND d.CantidadA > 0 AND UPPER(d.EstadoRef) = 'AUTORIZADO'
AND NULLIF(RTRIM(ProveedorRef), '') IS NOT NULL
AND c.ID = d.ID
ORDER BY ProveedorRef, AgenteRef, c.Almacen, c.ID, d.Renglon, d.RenglonSub
OPEN crGenerarOC
FETCH NEXT FROM crGenerarOC  INTO @Proveedor, @Agente, @ID, @Mov, @MovID, @Moneda, @TipoCambio, @Almacen, @Renglon, @RenglonSub
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF @UltProveedor <> @Proveedor OR @UltAgente <> @Agente OR @Almacen <> @UltAlmacen
BEGIN
IF @Agente IS NULL SELECT @UsuarioAgente = @Usuario
ELSE SELECT @UsuarioAgente = ISNULL(NULLIF(RTRIM(MIN(Usuario)), ''), @Usuario) FROM Usuario WITH (NOLOCK) WHERE DefAgente = @Agente
SELECT @UltProveedor = @Proveedor, @UltAgente = @Agente, @UltAlmacen = @Almacen
IF @GenerarID IS NOT NULL
UPDATE Compra  WITH(ROWLOCK) SET RenglonID = @GenerarRenglonID WHERE ID = @GenerarID
SELECT @Conteo = @Conteo + 1
SELECT @Condicion = Condicion,
@ZonaImpuesto = ZonaImpuesto,
@Moneda = DefMoneda
FROM Prov
WITH(NOLOCK) WHERE Proveedor = @Proveedor
SELECT @TipoCambio = TipoCambio FROM Mon WITH(NOLOCK) WHERE Moneda = @Moneda
EXEC spMovCopiarEncabezado @Sucursal, 'COMS', @ID, @Empresa, @Mov, @MovID, @UsuarioAgente, @FechaTrabajo, 'CONFIRMAR',
@Moneda, @TipoCambio, @Almacen, NULL,
0, @GenerarMov, NULL,
@GenerarID OUTPUT, @Ok OUTPUT, 1
UPDATE Compra
 WITH(ROWLOCK) SET Proveedor    = @Proveedor,
Agente       = @Agente,
Condicion    = @Condicion,
ZonaImpuesto = @ZonaImpuesto
WHERE ID = @GenerarID
END
SELECT @GenerarRenglon = @GenerarRenglon + 2048.0,
@GenerarRenglonID = @GenerarRenglonID + 1
SELECT @Articulo = d.Articulo, @Impuesto1 = a.Impuesto1, @Impuesto2 = a.Impuesto2, @Impuesto3 = a.Impuesto3
FROM CompraD d WITH (NOLOCK), Art a
WITH(NOLOCK) WHERE d.ID = @ID AND d.Renglon = @Renglon AND d.RenglonSub = @RenglonSub
AND d.Articulo = a.Articulo
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto2 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto3 OUTPUT
EXEC spTipoImpuesto 'COMS', @ID, @Mov, @FechaTrabajo, @Empresa, @Sucursal, @Proveedor, @Articulo = @Articulo, @EnSilencio = 1, @Impuesto1 = @Impuesto1 OUTPUT, @Impuesto2 = @Impuesto2 OUTPUT, @Impuesto3 = @Impuesto3 OUTPUT
INSERT CompraD
(ID, Renglon, RenglonSub, RenglonID, Aplica, AplicaID, RenglonTipo, Cantidad, CantidadInventario, Unidad, Factor, Almacen, Articulo, SubCuenta, FechaRequerida, FechaOrdenar, FechaEntrega, Costo, Impuesto1, Impuesto2, Impuesto3, Retencion1, Retencion2, Retencion3,
DescuentoTipo, DescuentoLinea, DescuentoImporte, DescripcionExtra, ReferenciaExtra, ContUso, Cliente, ServicioArticulo, ServicioSerie, Paquete)
SELECT @GenerarID, @GenerarRenglon, 0, @GenerarRenglonID, @Mov, @MovID, RenglonTipo, CantidadA, CantidadA*Factor, Unidad, Factor, Almacen, Articulo, SubCuenta, FechaRequerida, FechaOrdenar, FechaEntrega, Costo, @Impuesto1, @Impuesto2, @Impuesto3, Retencion1, Retencion2, Retencion3,
DescuentoTipo, DescuentoLinea, DescuentoImporte, DescripcionExtra, ReferenciaExtra, ContUso, Cliente, ServicioArticulo, ServicioSerie, Paquete
FROM CompraD
WITH(NOLOCK) WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
UPDATE CompraD  WITH(ROWLOCK) SET CantidadA = NULL, EstadoRef = 'Liberado' WHERE CURRENT OF crGenerarOC
END
FETCH NEXT FROM crGenerarOC  INTO @Proveedor, @Agente, @ID, @Mov, @MovID, @Moneda, @TipoCambio, @Almacen, @Renglon, @RenglonSub
END 
CLOSE crGenerarOC
DEALLOCATE crGenerarOC
IF @GenerarID IS NOT NULL
UPDATE Compra  WITH(ROWLOCK) SET RenglonID = @GenerarRenglonID WHERE ID = @GenerarID
IF @Ok IN (NULL, 80300)
SELECT 'Se Generaron '+LTRIM(CONVERT(char, @Conteo))+ ' Ordenes (por Confirmar)'
ELSE
SELECT Descripcion+' '+ISNULL(RTRIM(@OkRef), '') FROM MensajeLista WITH (NOLOCK) WHERE Mensaje = @Ok
RETURN
END

