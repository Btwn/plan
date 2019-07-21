SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarComisionesLote
@Sucursal	int,
@Empresa	char(5),
@Usuario	char(10),
@FechaCorte	datetime

AS BEGIN
DECLARE
@Conteo		int,
@Ok			int,
@OkRef		varchar(255),
@Mensaje		varchar(255),
@FechaEmision	datetime,
@FechaRegistro	datetime,
@AgentMov		char(20),
@AgentMovID		varchar(20),
@AgentComision	char(20),
@AgentDevolucion	char(20),
@Referencia		varchar(50),
@Observaciones	varchar(100),
@ID			int,
@Mov		char(20),
@MovID		varchar(20),
@MovTipo		varchar(20),
@Moneda		char(10),
@TipoCambio		float,
@Agente		char(10),
@Comision		money,
@AgentID		int,
@IDGenerar		int
SELECT @Conteo = 0, @Ok = NULL, @OkRef = NULL, @FechaEmision = GETDATE(), @FechaRegistro = GETDATE()
EXEC spExtraerFecha @FechaEmision OUTPUT
EXEC spExtraerFecha @FechaCorte OUTPUT
SELECT @AgentComision   = AgentComision,
@AgentDevolucion = AgentDevolucion
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
DECLARE crComisionLote CURSOR FOR
SELECT c.ID, c.Mov, c.MovID, mt.Clave, c.Moneda, c.TipoCambio, NULLIF(RTRIM(c.Agente), ''), ISNULL(c.ComisionTotal, 0), '('+RTRIM(Cliente)+', '+CONVERT(varchar, (ISNULL(c.ComisionTotal, 0)/Importe)*100)+'%)'
FROM Cxc c, MovTipo mt
WHERE c.Estatus = 'CONCLUIDO' AND c.ComisionCorte IS NULL AND c.FechaConclusion <= @FechaCorte
AND mt.Modulo = 'CXC' AND mt.Mov = c.Mov AND mt.Clave IN ('CXC.F', 'CXC.NC')
AND c.Empresa = @Empresa AND NULLIF(RTRIM(c.Agente), '') IS NOT NULL
OPEN crComisionLote
FETCH NEXT FROM crComisionLote INTO @ID, @Mov, @MovID, @MovTipo, @Moneda, @TipoCambio, @Agente, @Comision, @Observaciones
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @Conteo = @Conteo + 1, @Referencia = RTRIM(@Mov)+' '+RTRIM(@MovID)
IF @MovTipo = 'CXC.NC' SELECT @AgentMov = @AgentDevolucion ELSE SELECT @AgentMov = @AgentComision
INSERT Agent (Sucursal, Empresa,   Mov,       FechaEmision,  Moneda,  TipoCambio,  Usuario,  Estatus,     Agente,   Importe,   Observaciones,  Referencia,  OrigenTipo, Origen, OrigenID)
VALUES (@Sucursal, @Empresa, @AgentMov, @FechaEmision, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', @Agente, @Comision, @Observaciones, @Referencia, 'CXC',      @Mov,   @MovID)
SELECT @AgentID = SCOPE_IDENTITY()
EXEC spCx @AgentID, 'AGENT', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 0, 0,
@AgentMov OUTPUT, @AgentMovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, 'CXC', @ID, @Mov, @MovID, 'AGENT', @AgentID, @AgentMov, @AgentMovID, @Ok OUTPUT
IF @Ok IS NULL
UPDATE Cxc SET ComisionCorte = @FechaEmision WHERE CURRENT OF crComisionLote
END
FETCH NEXT FROM crComisionLote INTO @ID, @Mov, @MovID, @MovTipo, @Moneda, @TipoCambio, @Agente, @Comision, @Observaciones
END  
CLOSE crComisionLote
DEALLOCATE crComisionLote
IF @Ok IS NULL
SELECT @Mensaje = LTRIM(CONVERT(char, @Conteo))+' Comisiones Generadas.'
ELSE
SELECT @Mensaje = Descripcion FROM MensajeLista WHERE Mensaje = @Ok
SELECT @Mensaje
RETURN
END

