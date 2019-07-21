SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spEmidaGenerarOC
@Usuario		varchar(10),
@Empresa		varchar(5),
@Sucursal		int,
@FechaD			datetime,
@FechaA			datetime,
@Ok				int			 = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS
BEGIN
DECLARE @Proveedor		varchar(10),
@Articulo			varchar(20),
@Almacen			varchar(10),
@FechaEmision		datetime,
@FechaRegistro	datetime,
@Mov				varchar(20),
@Moneda			varchar(10),
@TipoCambio		float,
@IDCompra			int,
@Costo			float,
@OkDesc			varchar(255),
@OkTipo			varchar(50),
@URL				varchar(255),
@URLAnt			varchar(255)
SELECT @FechaEmision = GETDATE(), @FechaRegistro = GETDATE()
EXEC spExtraerFecha @FechaEmision OUTPUT
SELECT @Proveedor = Proveedor, @Mov = MovOC FROM EmidaCfg WITH (NOLOCK) WHERE Empresa = @Empresa
SELECT @Articulo = Articulo FROM Art WITH (NOLOCK) WHERE ISNULL(EmidaTiempoAire, 0) = 1
SELECT @Almacen = AlmacenPrincipal FROM Sucursal WITH (NOLOCK) WHERE Sucursal = @Sucursal
SELECT @Moneda = DefMoneda FROM Prov WITH (NOLOCK) WHERE Proveedor = @Proveedor
SELECT @TipoCambio = TipoCambio FROM Mon WITH (NOLOCK) WHERE Moneda = @Moneda
IF @Proveedor IS NULL
SELECT @Ok = 40020
IF @Articulo IS NULL AND @Ok IS NULL
SELECT @Ok = 20400
IF @Almacen IS NULL AND @Ok IS NULL
SELECT @Ok = 20390
IF @Mov IS NULL AND @Ok IS NULL
SELECT @Ok = 55130
IF @Moneda IS NULL AND @Ok IS NULL
SELECT @Ok = 30040
IF @Ok IS NULL
BEGIN
CREATE TABLE #VentaD(
ID			int,
Renglon		float,
RenglonID		int,
RenglonSub	int,
Estatus		varchar(15)	COLLATE DATABASE_DEFAULT ,
Articulo		varchar(20)	COLLATE DATABASE_DEFAULT ,
Cantidad		float,
FechaEmision	datetime,
CarrierId		varchar(255)COLLATE DATABASE_DEFAULT NULL,
URL			varchar(255)COLLATE DATABASE_DEFAULT NULL,
Comision		float		NULL,
Precio		float		NULL,
Importe		float		NULL,
EnCorte		bit			NOT NULL DEFAULT 0
)
CREATE TABLE #CompraD(
ID			int,
Renglon		int			IDENTITY(1024, 1024),
Estatus		varchar(15)	COLLATE DATABASE_DEFAULT ,
Articulo		varchar(20)	COLLATE DATABASE_DEFAULT ,
Cantidad		float,
FechaEmision	datetime,
CarrierId		varchar(255)COLLATE DATABASE_DEFAULT NULL,
URL			varchar(255)COLLATE DATABASE_DEFAULT NULL,
Comision		float		NULL,
Precio		float		NULL,
Importe		float		NULL
)
INSERT INTO #VentaD(
ID,   Renglon,   RenglonID,   RenglonSub,   Articulo,   Cantidad,   FechaEmision,   Estatus)
SELECT d.ID, d.Renglon, d.RenglonID, d.RenglonSub, d.Articulo, d.Cantidad, v.FechaEmision, v.Estatus
FROM Venta v WITH (NOLOCK)
JOIN VentaD d WITH (NOLOCK) ON v.ID = d.ID
JOIN MovTipo m WITH (NOLOCK) ON v.Mov = m.Mov AND m.Modulo = 'VTAS' AND ISNULL(m.SubClave, '') = 'VTAS.NEMIDA'
JOIN Art a WITH (NOLOCK) ON d.Articulo = a.Articulo AND ISNULL(a.EmidaRecargaTelefonica, 0) = 1
WHERE v.Estatus IN('CONCLUIDO', 'PROCESAR') 
AND v.FechaEmision BETWEEN @FechaD AND @FechaA
AND v.Sucursal = @Sucursal
AND ISNULL(EmidaResponseCode, '') = '00'
AND v.Empresa = @Empresa
UPDATE #VentaD
SET URL		= EmidaProductCfg.URL,
CarrierId= EmidaProductCfg.CarrierId,
Precio   = EmidaProductCfg.Amount,
Comision = EmidaProductCfg.Comision,
Importe = (Amount * Cantidad) - ISNULL((Amount * Cantidad) * (EmidaProductCfg.Comision / 100) ,0)
FROM #VentaD
JOIN EmidaProductCfg WITH (NOLOCK) ON #VentaD.Articulo = EmidaProductCfg.Articulo
DELETE #VentaD
FROM #VentaD
JOIN EmidaCompraD WITH (NOLOCK) ON #VentaD.ID = EmidaCompraD.IDVTAS
JOIN Compra WITH (NOLOCK) ON EmidaCompraD.ID = Compra.ID
WHERE Compra.Estatus IN('PENDIENTE', 'CONCLUIDO')
SELECT @URLAnt = ''
WHILE(1=1)
BEGIN
SELECT @URL = MIN(URL)
FROM #VentaD
WHERE URL > @URLAnt
IF @URL IS NULL BREAK
SELECT @URLAnt = @URL
INSERT INTO Compra(
Empresa,  Mov,  FechaEmision,  Moneda,  TipoCambio,  Usuario, Estatus,      Proveedor,  Almacen, OrigenTipo,  Origen,   Sucursal,  Observaciones)
SELECT @Empresa, @Mov, @FechaEmision, @Moneda, @TipoCambio, @Usuario, 'CONFIRMAR', @Proveedor, @Almacen, 'Usuario',  @Usuario, @Sucursal, @URL
SELECT @IDCompra = @@IDENTITY
TRUNCATE TABLE #CompraD
INSERT INTO #CompraD(
ID,        Articulo, Cantidad,      FechaEmision, CarrierId, URL, Comision, Precio,      Estatus)
SELECT @IDCompra, @Articulo, SUM(Cantidad), FechaEmision, CarrierId, URL, Comision, SUM(Precio), Estatus
FROM #VentaD
WHERE URL = @URL
GROUP BY FechaEmision, CarrierId, URL, Comision, Estatus
INSERT INTO EmidaCompraD(
ID,       IDVTAS, Articulo, Cantidad, FechaEmision, CarrierId, URL, Comision, Precio, Estatus)
SELECT @IDCompra, ID,     Articulo, Cantidad, FechaEmision, CarrierId, URL, Comision, Precio, Estatus
FROM #VentaD
WHERE URL = @URL
INSERT INTO CompraD(
ID,       Renglon, RenglonSub, RenglonID,    RenglonTipo, Cantidad,	 Almacen,  Articulo, Costo,  Impuesto1, Impuesto2, Impuesto3, Retencion1, Retencion2, Retencion3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoImpuesto4, TipoImpuesto5, TipoRetencion1, TipoRetencion2, TipoRetencion3, DescuentoLinea,    EmidaFechaRecarga,     EmidaProveedorCelular,       EmidaURL)
SELECT @IDCompra, Renglon, 0,          Renglon/1024, 'N',         1,        @Almacen, @Articulo, Precio, Impuesto1, Impuesto2, Impuesto3, Retencion1, Retencion2, Retencion3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoImpuesto4, TipoImpuesto5, TipoRetencion1, TipoRetencion2, TipoRetencion3, #CompraD.Comision, #CompraD.FechaEmision, EmidaCarrierCfg.Description, #CompraD.URL
FROM Art WITH (NOLOCK)
JOIN #CompraD ON Art.Articulo = #CompraD.Articulo
JOIN EmidaCarrierCfg WITH (NOLOCK) ON #CompraD.URL = EmidaCarrierCfg.URL AND #CompraD.CarrierId = EmidaCarrierCfg.CarrierId
WHERE Art.Articulo = @Articulo
END
END
IF @Ok IS NULL
SELECT @OkRef = NULL
ELSE
SELECT @OkDesc = Descripcion,
@OkTipo = Tipo
FROM MensajeLista WITH (NOLOCK)
WHERE Mensaje = @Ok
SELECT @Ok, @OkDesc, @OkTipo, @OkRef, NULL
RETURN
END

