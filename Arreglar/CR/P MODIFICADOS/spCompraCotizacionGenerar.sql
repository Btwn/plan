SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCompraCotizacionGenerar
@Estacion	int,
@Empresa	varchar(5),
@Sucursal	int,
@Usuario	varchar(10),
@FechaEmision	datetime,
@Proveedor	varchar(10),
@Mov		varchar(20)

AS BEGIN
DECLARE
@Conteo	int,
@Ok		int,
@OkRef	varchar(255),
@ID		int,
@MovID	varchar(20),
@Moneda	char(10),
@TipoCambio	float,
@Almacen	varchar(10),
@Renglon	float
SELECT @Ok = NULL, @OkRef = NULL, @Conteo = 0
SELECT @Moneda = m.Moneda, @TipoCambio = m.TipoCambio
FROM EmpresaCfg cfg WITH (NOLOCK), Mon m WITH (NOLOCK)
WHERE cfg.Empresa = @Empresa AND m.Moneda = cfg.ContMoneda
IF NOT EXISTS(SELECT * FROM Prov WITH (NOLOCK) WHERE Proveedor = @Proveedor AND Estatus = 'ALTA')
SELECT @Ok = 26050, @OkRef = @Proveedor
BEGIN TRANSACTION
IF @Ok IS NULL
BEGIN
INSERT Compra (Sucursal,  Empresa,  Mov,   Estatus,     FechaEmision,  Moneda,  TipoCambio,  Usuario,  Proveedor,  Directo)
VALUES (@Sucursal, @Empresa, @Mov, 'SINAFECTAR', @FechaEmision, @Moneda, @TipoCambio, @Usuario, @Proveedor, 0)
SELECT @ID = SCOPE_IDENTITY()
SELECT d.* INTO #CompraDetalle
FROM cCompraD d WITH (NOLOCK)
JOIN ListaIDRenglon l WITH (NOLOCK) ON l.Estacion = @Estacion AND l.Modulo = 'COMS' AND l.ID = d.ID AND l.Renglon = d.Renglon AND l.RenglonSub = d.RenglonSub
UPDATE #CompraDetalle
SET Aplica = r.Mov, AplicaID = r.MovID, EmpresaRef = r.Empresa
FROM #CompraDetalle d
JOIN Compra r WITH (NOLOCK) ON r.ID = d.ID
UPDATE #CompraDetalle
SET ID = @ID, Cantidad = CantidadPendiente, CantidadPendiente = NULL, CantidadCancelada = NULL, CantidadA = NULL
SELECT @Renglon = 0.0
UPDATE #CompraDetalle
SET @Renglon = Renglon = @Renglon + 2048.0, RenglonSub = 0
/*
UPDATE #CompraDetalle
SET EmpresaRef = c.Empresa
FROM #CompraDetalle d
JOIN Compra c ON c.ID = d.ID
*/
INSERT INTO cCompraD SELECT * FROM #CompraDetalle
DROP TABLE #CompraDetalle
SELECT @Almacen = MIN(Almacen) FROM CompraD WITH (NOLOCK) WHERE ID = @ID
UPDATE Compra WITH (ROWLOCK) SET Almacen = @Almacen WHERE ID = @ID
SELECT @Conteo = @Conteo + 1
END
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
SELECT 'Se Generaron '+LTRIM(CONVERT(char, @Conteo))+ ' '+@Mov+' (sin Afectar)'
END ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT Descripcion+' '+ISNULL(RTRIM(@OkRef), '') FROM MensajeLista WITH (NOLOCK) WHERE Mensaje = @Ok
END
RETURN
END

