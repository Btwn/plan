SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spProcesarVentaRedondeo
@Empresa			varchar(5),
@Sucursal			int,
@Usuario			varchar(10),
@FechaEmision		datetime

AS BEGIN
DECLARE @CfgFormaPagoOmision		varchar(50),
@UsuarioDefFormaPago		varchar(50),
@RedondeoVenta				bit,
@RedondeoVentaCodigo		varchar(30),
@RedondeoVentaMov			varchar(20),
@RedondeoVentaProv			varchar(10),
@RedondeoVentaConcepto		varchar(50),
@RedondeoVentaCtaDinero		varchar(10),
@RedondeoVentaCondicion		varchar(50),
@RedondeosMonetarios		int,
@ArtRedondeo				varchar(20),
@ImporteRedondeo			money,
@ContMoneda					varchar(10),
@ContTipoCambio				float,
@ProvDefMoneda				varchar(10),
@ProvDefMonedaTC			float,
@UltimoCambio				datetime,
@Vencimiento				datetime,
@Dias						int,
@Ok							int,
@OkRef						varchar(255),
@IDNuevo					int,
@MovID						varchar(20)
BEGIN TRAN
SET @UltimoCambio = GETDATE()
SELECT @CfgFormaPagoOmision = NULLIF(FormaPagoOmision,'')
FROM EmpresaCfg WITH(NOLOCK)
WHERE Empresa = @Empresa
SELECT @UsuarioDefFormaPago = ISNULL(NULLIF(DefFormaPago,''), @CfgFormaPagoOmision)
FROM Usuario WITH(NOLOCK)
WHERE Usuario = @Usuario
SELECT @RedondeoVenta			= ISNULL(RedondeoVenta,0),
@RedondeoVentaCodigo		= NULLIF(RedondeoVentaCodigo,''),
@RedondeoVentaMov		= NULLIF(RedondeoVentaMov,''),
@RedondeoVentaProv		= NULLIF(RedondeoVentaProv,''),
@RedondeoVentaConcepto	= NULLIF(RedondeoVentaConcepto,''),
@RedondeoVentaCtaDinero	= NULLIF(RedondeoVentaCtaDinero,''),
@RedondeoVentaCondicion	= NULLIF(RedondeoVentaCondicion,''),
@RedondeosMonetarios		= ISNULL(RedondeosMonetarios,2)
FROM POSCfg WITH(NOLOCK)
WHERE Empresa = @Empresa
SELECT @ContMoneda = ec.ContMoneda
FROM EmpresaCfg ec WITH(NOLOCK)
WHERE ec.Empresa = @Empresa
SELECT @ContTipoCambio = TipoCambio FROM Mon WITH(NOLOCK) WHERE Moneda = @ContMoneda
SELECT @ProvDefMoneda = ISNULL(NULLIF(DefMoneda,''),@ContMoneda)
FROM Prov WITH(NOLOCK)
WHERE Proveedor = @RedondeoVentaProv
SELECT @ProvDefMonedaTC = TipoCambio FROM Mon WITH(NOLOCK) WHERE Moneda = @ProvDefMoneda
SELECT @ArtRedondeo	= NULLIF(Cuenta,'')
FROM CB WITH(NOLOCK)
WHERE Codigo = @RedondeoVentaCodigo
CREATE TABLE #VentaRedondeo	(ID int NULL)
DELETE FROM #VentaRedondeo
INSERT INTO #VentaRedondeo (ID)
SELECT v.ID
FROM Venta v WITH(NOLOCK)
JOIN VentaD vd WITH(NOLOCK) ON v.ID = vd.ID AND vd.Articulo = @ArtRedondeo
WHERE v.FechaEmision = @FechaEmision
AND v.POSRedondeoVerif = 0
AND v.Sucursal = @Sucursal
AND v.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
GROUP BY v.ID
SELECT @ImporteRedondeo = ROUND(SUM(ISNULL(Precio, 0)),@RedondeosMonetarios)
FROM VentaD WITH(NOLOCK)
WHERE ID IN (SELECT ID FROM #VentaRedondeo)
AND Articulo = @ArtRedondeo
IF @RedondeoVenta = 0
SELECT @Ok = 20500, @OkRef = 'No esta Configurada esta Opción'
IF (@RedondeoVentaCodigo IS NULL OR @RedondeoVentaMov  IS NULL OR @RedondeoVentaProv  IS NULL
OR @RedondeoVentaCtaDinero IS NULL OR @RedondeoVentaCondicion IS NULL OR @ArtRedondeo IS NULL) AND @Ok IS NULL
SELECT @Ok = 20500, @OkRef = 'Es necesario completar la Configuración'
IF NOT EXISTS (SELECT * FROM #VentaRedondeo)
SELECT @Ok = 60010, @OkRef = 'No hay Movimientos que Afectar'
IF ISNULL(@ImporteRedondeo, 0) <= 0 AND @Ok IS NULL
SELECT @Ok = 60010, @OkRef = 'El Importe de las Operaciones no es el Correcto'
IF @Ok IS NULL
BEGIN
EXEC spCalcularVencimiento 'CXP', @Empresa, @RedondeoVentaProv, @RedondeoVentaCondicion, @FechaEmision,
@Vencimiento OUTPUT, @Dias OUTPUT, @Ok OUTPUT
INSERT INTO Cxp (Empresa, Mov,					FechaEmision,  UltimoCambio,	Concepto,				Moneda,		TipoCambio,		 Usuario,  Estatus,
Proveedor,			ProveedorMoneda, ProveedorTipoCambio,	CtaDinero,					Condicion,					Vencimiento,	FormaPago,
Importe,			Impuestos,	AplicaManual, Sucursal, SucursalOrigen)
VALUES			(@Empresa, @RedondeoVentaMov,	@FechaEmision, @UltimoCambio,	@RedondeoVentaConcepto, @ContMoneda,@ContTipoCambio, @Usuario, 'SINAFECTAR',
@RedondeoVentaProv, @ProvDefMoneda,  @ProvDefMonedaTC,		@RedondeoVentaCtaDinero,	@RedondeoVentaCondicion,	@Vencimiento,	@UsuarioDefFormaPago,
@ImporteRedondeo,	0.00,		0,			  @Sucursal, @Sucursal)
SELECT @IDNuevo = IDENT_CURRENT('Cxp')
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Ok IS NULL
EXEC spAfectar 'CXP', @IDNuevo, 'AFECTAR', 'Todo', NULL, @Usuario,	@EnSilencio = 1, @Conexion = 1, @Ok = @ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @MovID = MovID FROM Cxp WITH(NOLOCK) WHERE ID = @IDNuevo
IF @Ok IS NULL
INSERT INTO VentaOrigenRedondeo (ID, OrigenID, Sucursal)
SELECT							 ID, @IDNuevo, @Sucursal
FROM #VentaRedondeo
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Ok IS NULL
UPDATE Venta WITH(ROWLOCK) SET POSRedondeoVerif = 1 WHERE ID IN (SELECT ID FROM #VentaRedondeo)
END
IF @Ok IS NULL
BEGIN
COMMIT TRAN
SELECT @OkRef = 'Se Generó el Movimiento ' + @RedondeoVentaMov + ' ' + @MovID
SELECT @OkRef
END
ELSE
BEGIN
SELECT @OkRef = Descripcion + ', '  + @OkRef
FROM MensajeLista WITH(NOLOCK)
WHERE Mensaje = @Ok
SELECT @OkRef
ROLLBACK TRAN
END
END

