SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spTCAplicacionSaldo
@Modulo			varchar(5),
@ID				int,
@Mov			varchar(20),
@MovTipo		varchar(20),
@Empresa		varchar(5),
@Sucursal		int,
@Usuario		varchar(10),
@Accion			varchar(20),
@Cliente		varchar(10),
@TCDelEfectivo	float,
@FechaEmision	datetime,
@CxID			int,
@CxMov			varchar(20),
@CxMovID		varchar(20),
@Ok				int				OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
DECLARE @GenerarMov	varchar(20),
@IDGenerar	int,
@TCAccion		varchar(20)
CREATE TABLE #CxcD(
ID				int,
Renglon			int IDENTITY(2048, 2048),
RenglonSub		int,
Importe			float,
Aplica			varchar(20),
AplicaID		varchar(20)
)
SELECT @TCAccion = TCAccion FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov AND Clave = @MovTipo
IF @TCAccion = 'Auth'
SELECT @GenerarMov = CxcAplicacionSaldo FROM EmpresaCfgMov WHERE Empresa = @Empresa
ELSE IF @TCAccion = 'Credit'
SELECT @GenerarMov = CxcAplicacion FROM EmpresaCfgMov WHERE Empresa = @Empresa
IF @Accion = 'AFECTAR'
BEGIN
IF @TCAccion = 'Auth'
BEGIN
INSERT INTO Cxc(
Empresa, Cliente,   ClienteEnviarA, Agente,    Mov,         Importe,       Impuestos, Proyecto,   Moneda,    FechaEmision, TipoCambio,    Usuario, Estatus,      ClienteMoneda, ClienteTipoCambio,             Vencimiento,  Sucursal,    AplicaManual, OrigenTipo, Origen,  OrigenID, Observaciones)
SELECT @Empresa, v.Cliente, v.EnviarA,      v.Agente, @GenerarMov, @TCDelEfectivo, 0,         v.Proyecto, v.Moneda, @FechaEmision, v.TipoCambio, @Usuario, 'SINAFECTAR', c.DefMoneda,   dbo.fnTipoCambio(c.DefMoneda), @FechaEmision, v.Sucursal, 1,            'CXC',      @CxMov, @CxMovID,  'Aplicacion Cobros Tarjetas Bancarias'
FROM Venta v
JOIN Cte c ON v.Cliente = c.Cliente
WHERE v.ID = @ID
SELECT @IDGenerar = @@IDENTITY
INSERT INTO CxcD(ID, Renglon, RenglonSub, Importe, Aplica, AplicaID) VALUES(@IDGenerar, 2048, 0, @TCDelEfectivo, @CxMov, @CxMovID)
END
ELSE IF @TCAccion = 'Credit'
BEGIN
EXEC @IDGenerar = spAfectar 'CXC', @CxID, 'GENERAR', 'Todo', @GenerarMov, @Usuario = @Usuario, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
INSERT INTO #CxcD(
ID,         RenglonSub, Importe,                            Aplica, AplicaID)
SELECT @IDGenerar, 0,          Cxc.Importe + ISNULL(Impuestos, 0), Mov,    MovID
FROM TCTransaccion JOIN Cxc ON TCTransaccion.CxcID = Cxc.ID
WHERE Modulo = @Modulo
AND ModuloID = @ID
AND Cxc.Estatus = 'PENDIENTE'
INSERT INTO CxcD(ID, Renglon, RenglonSub, Importe, Aplica, AplicaID) SELECT ID, Renglon, RenglonSub, Importe, Aplica, AplicaID FROM #CxcD
END
IF @IDGenerar IS NOT NULL
BEGIN
EXEC spAfectar 'CXC', @IDGenerar, 'AFECTAR', @Usuario = @Usuario, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
UPDATE VentaCobro SET TCCxcIDAplicacion = @IDGenerar WHERE ID = @ID
END
END
ELSE IF @Accion = 'CANCELAR'
BEGIN
SELECT @IDGenerar = TCCxcIDAplicacion FROM VentaCobro WHERE ID = @ID
IF @IDGenerar IS NOT NULL AND(SELECT Estatus FROM Cxc WHERE ID = @IDGenerar) IN('CONCLUIDO', 'PENDIENTE')
BEGIN
EXEC spAfectar 'CXC', @IDGenerar, 'CANCELAR', @Usuario = @Usuario, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
END
RETURN
END

