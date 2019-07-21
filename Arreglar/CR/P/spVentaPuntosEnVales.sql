SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVentaPuntosEnVales
@Empresa		char(5),
@Modulo			char(10),
@ID			int,
@Mov			char(20),
@MovID			varchar(20),
@MovTipo		char(20),
@Accion			char(20),
@FechaEmision		datetime,
@Usuario		char(10),
@Sucursal		int,
@MovMoneda		char(10),
@MovTipoCambio		float,
@Ok 			int 		OUTPUT,
@OkRef 			varchar(255)	OUTPUT

AS
BEGIN
DECLARE
@ValeID		int,
@ValeMov		varchar(20),
@ValeMovID		varchar(20),
@Consecutivo	varchar(50),
@Serie		varchar(50),
@Puntos		money
IF @Accion <> 'CANCELAR'
SELECT @Accion = 'AFECTAR'
IF @Accion = 'CANCELAR'
BEGIN
SELECT @ValeID = MIN(ID), @ValeMov = MIN(Mov), @ValeMovID = MIN(MovID) FROM Vale WHERE Empresa = @Empresa AND Origen = @Mov AND OrigenID = @MovID AND Estatus = 'CONCLUIDO'
END ELSE
BEGIN
SELECT @Puntos = SUM(Puntos) FROM VentaD WHERE ID = @ID
IF ISNULL(@Puntos, 0.0) = 0.0 RETURN
SELECT @Consecutivo = Consecutivo FROM EmpresaCfgPuntosEnVales WHERE Empresa = @Empresa
INSERT Vale (
Empresa,   Estatus,      Mov,          FechaEmision,   Proyecto, UEN, Moneda,       TipoCambio,   Usuario,   Referencia,   Concepto, OrigenTipo, Origen, OrigenID, Sucursal, Cliente,     Tipo,          Precio, FechaInicio, FechaTermino)
SELECT v.Empresa, 'SINAFECTAR', cfg.ValesMov, v.FechaEmision, v.Proyecto, v.UEN, v.Moneda, v.TipoCambio, v.Usuario, v.Referencia, v.Concepto, 'VTAS',   v.Mov,  v.MovID,  v.Sucursal, v.Cliente, cfg.ValeTipo, @Puntos, FechaEmision, dbo.fnDuracion(FechaEmision, cfg.Duracion, cfg.DuracionUnidad)
FROM Venta v
JOIN EmpresaCfgPuntosEnVales cfg ON cfg.Empresa = v.Empresa
WHERE v.ID = @ID
SELECT @ValeID = SCOPE_IDENTITY()
EXEC spConsecutivo @Consecutivo, @Sucursal, @Serie OUTPUT
INSERT ValeD (ID, Serie, Sucursal)
SELECT @ValeID, @Serie, @Sucursal
END
IF @ValeID IS NOT NULL
BEGIN
EXEC spAfectar 'VALE', @ValeID, @Accion, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @ValeMov = Mov, @ValeMovID = MovID FROM Vale WHERE ID = @ValeID
END ELSE SELECT @Ok = 30120
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'VALE', @ValeID, @ValeMov, @ValeMovID, @Ok = @OK OUTPUT
RETURN
END

