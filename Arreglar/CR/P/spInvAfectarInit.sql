SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvAfectarInit
@Accion		varchar(20),
@Empresa	varchar(5),
@Sucursal	int,
@MovTipo     	varchar(20),
@OrigenTipo	varchar(10),
@Origen		varchar(20),
@OrigenID	varchar(20),
@IDOrigen	int		OUTPUT,
@Ok		int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
IF @OrigenTipo = 'INV'
SELECT @IDOrigen = ID FROM Inv    WHERE Empresa = @Empresa AND Sucursal = @Sucursal AND Mov = @Origen AND MovID = @OrigenID AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
IF @OrigenTipo = 'VTAS'
SELECT @IDOrigen = ID FROM Venta  WHERE Empresa = @Empresa AND Sucursal = @Sucursal AND Mov = @Origen AND MovID = @OrigenID AND Estatus IN ('PENDIENTE', 'CONCLUIDO', 'CONFIRMAR')
IF @OrigenTipo = 'COMS'
SELECT @IDOrigen = ID FROM Compra WHERE Empresa = @Empresa AND Sucursal = @Sucursal AND Mov = @Origen AND MovID = @OrigenID AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
IF @OrigenTipo = 'PROD'
SELECT @IDOrigen = ID FROM Prod   WHERE Empresa = @Empresa AND Sucursal = @Sucursal AND Mov = @Origen AND MovID = @OrigenID AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
IF @Accion IN ('RESERVAR', 'DESRESERVAR', 'RESERVARPARCIAL', 'ASIGNAR', 'DESASIGNAR') AND @MovTipo NOT IN ('VTAS.P', 'VTAS.F','VTAS.FAR', 'VTAS.FC', 'VTAS.FG', 'VTAS.FX', 'VTAS.S', 'INV.SOL', 'INV.SM', 'INV.OT', 'INV.OI')
SELECT @Ok = 60040
END

